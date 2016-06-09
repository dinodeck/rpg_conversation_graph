function HasFlag(id)
    return function(flags)

        if type(id) == "table" then
            for k, v in ipairs(id) do
                if flags[v] == false then
                    return false
                end
            end
            return true
        else
            return flags[id] == true
        end
    end
end

function NoFlag(id)
    return function(flags)
        return not flags[id] or flags[id] == false
    end
end

function SetFlag(id)
    return function(flags)
        flags[id] = true
    end
end

conversation_5 =
{
    type = "root",
    id = "root",
    condition = nil,
    variables =
    {
        -- Flags to track what's been asked during this conversation
        ["clever"] = false,
        ["black_hand"] = false,
    },
    children =
    {
        {
            type = "dialog",
            id = "questions",
            text = "Yes?",
            children =
            {
                {
                    type = "response",
                    text = "Do you know where the leader of the black hand is?",
                    condition = NoFlag("black_hand"),
                    on_choose = SetFlag("black_hand"),
                    children =
                    {
                        {
                            type = "dialog",
                            text = "Never heard of them.",
                            children =
                            {
                                {
                                    type = "response",
                                    text = "I have more questions.",
                                    jump = "questions"
                                }
                            }
                        }
                    }
                },
                {
                    type = "response",
                    text = "Is there are a cleverman in this town?",
                    condition = NoFlag("clever"),
                    on_choose = SetFlag("clever"),
                    children =
                    {
                        {
                            type = "dialog",
                            text = "Yeh, end of main street. You'll find him "
                            .. " in the Hanged Man's Tavern",
                            children =
                            {
                                {
                                    type = "response",
                                    text = "Thanks.",
                                    jump = "questions"
                                }
                            }
                        }
                    }
                },
                {
                    type = "response",
                    text = "Thanks for the help. Bye",
                    condition = HasFlag({"clever", "black_hand"}),
                    exit = true
                }
            }
        }
    }
}