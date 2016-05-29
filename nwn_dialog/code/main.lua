LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()


function SetupNewGame()
    gStack = StateStack:Create()
    gWorld = World:Create()

    local startPos = Vector.Create(5, 9, 1)

    local hero = Actor:Create(gPartyMemberDefs.hero)
    local thief = Actor:Create(gPartyMemberDefs.thief)
    local mage = Actor:Create(gPartyMemberDefs.mage)
    gWorld.mParty:Add(hero)
    gWorld.mParty:Add(thief)
    gWorld.mParty:Add(mage)


    gWorld.mGold = 0
    gWorld:AddItem(11, 3)
    gWorld:AddItem(10, 5)
    gWorld:AddItem(12, 5)

    do
        local map = MapDB['town'](gWorld.mGameState)
        gStack:Push(ExploreState:Create(gStack, map, startPos))
    end
end



SetupNewGame()

math.randomseed( os.time() )

function update()
    local dt = GetDeltaTime()
    gStack:Update(dt)
    gStack:Render(gRenderer)
    gWorld:Update(dt)
end
