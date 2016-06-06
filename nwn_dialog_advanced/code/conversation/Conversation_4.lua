
conversation_4 =
{
    type = "root",
    id = "root",
    condition = nil,
    children =
    {
        {
            type = "dialog",
            text = "Can I help you detective?",
            id = "help",
            children =
            {
                {
                    type = "response",
                    text = "I have some questions.",
                    children =
                    {
                        {
                            type = "dialog",
                            text = "What do you need to know?",
                            id = "questions",
                            children =
                            {
                                {
                                    type = "response",
                                    text =
                                    "Where were you last night, around seven?",
                                    children =
                                    {
                                        {
                                            type = "dialog",
                                            text = "Here. "
                                                .. "You can ask my customers.",
                                            children =
                                            {
                                                {
                                                    type = "response",
                                                    text = "Maybe I will.",
                                                    jump = "questions"
                                                }
                                            }
                                        }
                                    },
                                },
                                {
                                    type = "response",
                                    text = "You ever been to Salem Hotel?",
                                    children =
                                    {
                                        {
                                            type = "dialog",
                                            text = "Can't say that I have.",
                                            children =
                                            {
                                                {
                                                    type = "response",
                                                    text = "Ok then.",
                                                    jump = "questions"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    type = "response",
                                    text = "Do you know a Dr. Suther?",
                                    children =
                                    {
                                        {
                                            type = "dialog",
                                            text =
                                               "Only that he's the local Doc.",
                                            children =
                                            {
                                                {
                                                    type = "response",
                                                    text =
                                                       "I have other questions.",
                                                    jump = "questions"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    type = "response",
                                    text = "That's all for now",
                                    jump = "help"
                                }
                            }
                        }
                    }
                },
                {
                    type = "response",
                    text = "Maybe later.",
                    exit = true
                }
            }
        },
    }
}
