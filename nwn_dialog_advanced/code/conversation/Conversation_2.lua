local function IsKnight()
    local hero = gWorld.mParty.mMembers["hero"]
    print(hero.mDef.socialClass)
    return hero.mDef.socialClass == "knight"
end

conversation_2 =
  {
    type = "root",
    id = "root",
    condition = nil,
    children =
    {
        {
            type = "dialog",
            condition = IsKnight,
            text = "Anything I can help you with sire?",
            children =
            {
                {
                    type = "response",
                    text = "Any news?",
                    children =
                    {
                        {
                            type = "dialog",
                            text = "No, sire.",
                            exit = true -- ends conversation
                        }
                    }
                },
                {
                    type = "response",
                    text = "No, thank you.",
                    exit = true, -- ends conversation
                }
            }
        },
        {
            type = "dialog",
            text = "Hello. You ok?",
            children =
            {
                {
                    type = "response",
                    text = "Any news?",
                    children =
                    {
                        {
                            type = "dialog",
                            text = "Heard one of royals has been sneaking"
                                .. " out at night.",
                            children =
                            {
                                {
                                    type = "response",
                                    text = "Interesting. Thanks.",
                                    exit = true
                                }
                            }
                        }
                    }
                },
                {
                    type = "response",
                    text = "Fine thank, just a bit busy now.",
                    exit = true
                }

            }
        }
    }
}
