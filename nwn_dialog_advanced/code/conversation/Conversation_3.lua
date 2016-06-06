
local text1 =   "And he turns to me, and says \"How the devil did you "
            ..  "get in here?\", and it was then I knew it was time to scarper."
local text2 =   "So I pointed over his shoulder shouted \"SHE-BEAR\" and was"
            ..  " out of the window and down the alleyway in a flea's second."
local text3 =   "Course, I didn't leave empty handed, on no, but as to what "
            ..  "I took, that's a gentleman's secret, if you know what I mean."

conversation_3 =
{
    type = "root",
    id = "root",
    condition = nil,
    children =
    {
        {
            type = "dialog",
            text = text1,
            children =
            {
                {
                    type = "dialog",
                    text = text2,
                    children =
                    {
                        {
                            type = "dialog",
                            text = text3,
                            children =
                            {
                                {
                                    type = "dialog",
                                    text = "Anyway, must dash.",
                                    exit = true
                                }
                            }
                        }
                    }
                }
            }
        },
    }
}
