DialogState = {}
DialogState.__index = DialogState

local eMode =
{
    Entering = "Entering",
    Running = "Running",
    Exiting = "Exiting"
}

function DialogState:Create(dialogDef)


    local this =
    {
        mMode = eMode.Entering,
        mDef = dialogDef,
        mGraph = dialogDef.graphDef,

        -- Code for the in/out transition
        mTransTween = nil,
        mTransDuration = 0.3, -- seconds
        mCamDiff = Vector.Create(),

        -- Code for display
        mCurrentNode = {},
        mReplyMenu = nil,
        mAreThereReplies = false,
        mNoReplyText = "Press Space to Continue",
        mFinishedText = "Press Space to Exit",
        mTextColor = Vector.Create(1,1,1,1),
    }


    local layout = Layout:Create()
    layout:Contract('screen', 32, 20)
    layout:SplitHorz('screen', 'top', 'bottom', 0.5, 1)
    layout:SplitHorz('bottom', 'dialog', 'response', 0.4, 1)
    this.mLayout = layout

    self.mPanels =
    {
        layout:CreatePanel("dialog"),
        layout:CreatePanel("response")
    }

    setmetatable(this, self)
    this:ProcessGraph(this.mGraph)
    return this
end

function DialogState:ProcessGraph(root)

    -- Reset variables to original values

    root.variables = root.variables or {}

    if root.variables_original == nil then
        local clone = ShallowClone(root.variables)
        root.variables_original = clone
    else
        local clone = ShallowClone(root.variables_original)
        root.variables = clone
    end

    if root.processed == true then
        print("Early out")
        return
    end

    print(root)
    self.mIdToNode = self:CreateIdToNodeTable(root)


    print("CALL ADD LOOPS", tostring(root))
    self:AddLoops(root)

    root.processed = true
end

-- In DialogState.lua
function DialogState:AddLoops(node)

    if not node then
        print("Add nodes: node is null")
        return
    end

    if node.jump then
        -- Store the id locally and remove it from the node
        local id = node.jump
        node.jump = nil

        -- Get the node the id points to
        local jumpNode = self.mIdToNode[id]

        print("ADDING JUMP", id, jumpNode)

        -- Some error checking
        if not jumpNode then
            local error = string.format(
                "Error: Couldn't find node with id [%s]", id)
            print(error)
            return
        end

        if node.children then
            local warning = string.format(
                "Warning jump to [%s] destroys children in node.", id)
            print(warning)
        end

        -- Add loop
        node.children = { jumpNode }


        return -- we can skip this node's children
    end

    for k, v in ipairs(node.children or {}) do
        self:AddLoops(v)
    end

end

function DialogState:CreateIdToNodeTable(root, nodes)
    local t = nodes or {}

    if root ~= nil then

        if root.id then

            if t[root.id] then
                local warning = string.format(
                    "Root id [%s] appears more than once!",
                    root.id)
                print(warning)
            end

            t[root.id] = root
        end

        for k, v in ipairs(root.children or {}) do
            self:CreateIdToNodeTable(v, t)
        end

    end

    return t
end

function DialogState:Enter()

    -- Debug data to fill out the NPC
    -- self:MoveToNode
    -- {
    --     text = "Hello, I'm an NPC. Doing some talking.",
    --     children =
    --     {
    --         { text = "Hello." },
    --         { text = "Goodbye." }
    --     }
    -- }

    local nodes = self:FilterNodes(self.mGraph.children)
    local _, firstNode = next(nodes)
    self:MoveToNode(firstNode)

    self.mMode = eMode.Entering
    self:InitEnterTransition(self.mDef.speakerX,
                             self.mDef.speakerY)
end

function DialogState:FilterNodes(nodeList)

    local passingNodes = {}
    local variables = self.mGraph.variables or {}

    for k, v in ipairs(nodeList) do
        if  v.condition == nil or
            v.condition(variables) == true
        then
            table.insert(passingNodes, v)
        end
    end

    return passingNodes
end

function DialogState:FilterForResponses(nodeList)

    local passingNodes = {}

    for k, v in ipairs(nodeList) do
        if v.type == "response" then
            table.insert(passingNodes, v)
        end
    end

    return passingNodes
end


function DialogState:MoveToNode(def)
    self.mCurrentNode = def

    local responses = def.children or {}

    -- Filter the responses
    responses = self:FilterForResponses(responses)
    responses = self:FilterNodes(responses)


    if next(responses) == nil then
        self.mAreThereReplies = false
        return
    end

    self.mAreThereReplies = true

    -- This list may be filtered so give each entry
    -- an index now
    for k, v in ipairs(responses) do
        v.index = k
    end

    self.mReplyMenu = Selection:Create
    {
        data = responses,
        columns = 1,
        displayRows = 3,
        spacingY = 24,
        rows = #responses,
        RenderItem = function(self_, renderer, x, y, item)
            if item == nil then
                return -- draw a space for missing elements
            end
            renderer:AlignText("left", "center")
            local text = string.format("%d. %s", item.index, item.text)
            renderer:DrawText2d(x, y, text, self.mTextColor)
        end,
        OnSelection = function(...)
            self:OnReplySelected(...)
        end
    }
end

function DialogState:OnReplySelected(index, item)

    -- First deal with exit commands
    if item.exit then
        self:InitExitTransition()
        self.mMode = eMode.Exiting
        return
    end

    if item.on_choose then
        local variables = self.mGraph.variables or {}
        print("calling on choose")
        item.on_choose(variables)
    end

    local nodeList = self:FilterNodes(item.children)
    local _, node = next(nodeList)
    self:MoveToNode(node)
    print(index, item.text)
end


function DialogState:InitEnterTransition(x, y)

    -- Find the follow state
    -- and tell the camera to stop following the player
    local explore = self:FindExploreState()
    self.mExploreState = explore
    explore:SetFollowCam(false)

    -- Store the original camera position for the player
    -- We'll restore this when we exit the dialog
    local pos = explore.mHero.mEntity.mSprite:GetPosition()
    self.mOriginalCamPos = Vector.Create()
    self.mOriginalCamPos:SetX(math.floor(pos:X()))
    self.mOriginalCamPos:SetY(math.floor(pos:Y()))


    -- Store the target position for the NPC camera alignment
    self.mNPCCamPos = Vector.Create()
    -- To center the NPC in the top half of the map we get it's pixel position
    -- Then add 0.25 of the height of the window
    local pX, pY = explore.mMap:GetTileFoot(x, y)
    self.mNPCCamPos:SetX(math.floor(pX))
    self.mNPCCamPos:SetY(math.floor(pY + System.ScreenHeight() * 0.25))

    -- Set the camera to start in the original camera position
    explore.mManualCamX = self.mOriginalCamPos:X()
    explore.mManualCamY = self.mOriginalCamPos:Y()

    -- Set up the transition tween and the different vector
    -- between where the camera is and where we want it to be
    self.mTransTween = Tween:Create(0, 1, self.mTransDuration,
                                    Tween.EaseOutQuad)
    self.mCamDiff = self.mOriginalCamPos - self.mNPCCamPos

    -- Set the UI alpha
    self:SetUIAlpha(0)
end

function DialogState:InitExitTransition()
   self.mTransTween = Tween:Create(1, 0, self.mTransDuration,
                                    Tween.EaseOutQuad)
end

function DialogState:FindExploreState()
    -- Don't have a great way to get access to this at the moment.
    local exploreState = nil
    for k, v in ipairs(gStack.mStates) do
        if v.__index == ExploreState then
            exploreState = v
            break
        end
    end
    return exploreState
end

function DialogState:Exit()
    self.mExploreState:SetFollowCam(true) -- restore the follow cam
end

function DialogState:Update(dt)

    -- Update the camera position
    self.mExploreState:UpdateCamera(self.mExploreState.mMap)

    if self.mMode == eMode.Entering then
        self:UpdateEnter(dt)
    elseif self.mMode == eMode.Running then
        self:UpdateRun(dt)
    elseif self.mMode == eMode.Exiting then
        self:UpdateExit(dt)
    end
end

function DialogState:UpdateEnter(dt)

    if self.mTransTween:IsFinished() then
        self.mMode = eMode.Running
        return
    end

    self.mTransTween:Update(dt)
    local v01 = self.mTransTween:Value()

    -- Move the camera
    local camPos = self.mOriginalCamPos + (self.mCamDiff * v01)
    self.mExploreState.mManualCamX = camPos:X()
    self.mExploreState.mManualCamY = camPos:Y()

    -- Fade in the dialog box
    self:SetUIAlpha(v01)
end

function DialogState:SetUIAlpha(a01)
    local color = Vector.Create(1, 1, 1, a01)

    -- Set the panels alpha
    for _, v in pairs(self.mPanels) do
        v:SetColor(color)
    end

    -- Set the text color
    self.mTextColor:SetW(a01)
    -- Update the selection box cursor
    if self.mReplyMenu then
        self.mReplyMenu.mCursor:SetColor(color)
    end
end

function DialogState:UpdateRun(dt)

end

function DialogState:UpdateExit(dt)

    if self.mTransTween:IsFinished() then
        gStack:Pop()
        return
    end

    self.mTransTween:Update(dt)
    local v10 = self.mTransTween:Value()

    local camPos = self.mOriginalCamPos + (self.mCamDiff * v10)
    self.mExploreState.mManualCamX = camPos:X()
    self.mExploreState.mManualCamY = camPos:Y()

    self:SetUIAlpha(v10)

end

function DialogState:MoveToChainedNode(node)

    if node.exit then
        self:InitExitTransition()
        self.mMode = eMode.Exiting
        return
    end
    -- Deal with chained nodes
    local nodes = node.children or {}
    -- Filter the nodes
    nodes = self:FilterNodes(nodes)
    local nodeToChangeTo = nil
    for k, v in ipairs(nodes) do
        if v.type == "dialog" then
            nodeToChangeTo = v
            break
        end
    end

    if nodeToChangeTo ~= nil then
        self:MoveToNode(nodeToChangeTo)
    else
        print("This conversation graph is broken!")
    end

end

function DialogState:HandleInput()
    -- only accept input when no transition is running.
    if self.mMode ~= eMode.Running then
        return
    end

    local spacePressed = Keyboard.JustPressed(KEY_SPACE)

    if self.mCurrentNode.exit and spacePressed then
        self:InitExitTransition()
        self.mMode = eMode.Exiting
        return
    elseif self.mAreThereReplies then
        self.mReplyMenu:HandleInput()
    elseif spacePressed then
        self:MoveToChainedNode(self.mCurrentNode)
    end

    -- if Keyboard.JustPressed(KEY_SPACE) then
    --     self:InitExitTransition()
    --     self.mMode = eMode.Exiting
    -- end
end

function DialogState:Render(renderer)
    renderer:ScaleText(0.75, 0.75)
    local leftPad = 8
    local topPad = 6
    local maxWidth = self.mLayout.mPanels["dialog"].width - (leftPad * 2)

    for _, v in pairs(self.mPanels) do
        v:Render(renderer)
    end

    local dX = self.mLayout:Left("dialog") + leftPad
    local dY = self.mLayout:Top("dialog") - topPad
    local color = self.mTextColor
    local text = self.mCurrentNode.text

    renderer:AlignText("left", "top")
    renderer:DrawText2d(dX, dY, text, self.mTextColor, maxWidth)

    if self.mAreThereReplies then
        local x = self.mLayout:Left("response") + leftPad
        local y = self.mLayout:Top("response") - topPad
        y = y - 12 -- replies are centered, so push down a little more
        self.mReplyMenu:SetPosition(x, y)
        renderer:ScaleText(0.75, 0.75)
        self.mReplyMenu:Render(gRenderer)
    else
        local x = self.mLayout:MidX("response")
        local y = self.mLayout:MidY("response")
        renderer:AlignText("center", "center")
        renderer:ScaleText(0.75, 0.75)

        local message = self.mNoReplyText

        if self.mCurrentNode.exit then
            message = self.mFinishedText
        end

        renderer:DrawText2d(x, y, message, self.mTextColor)
    end
end