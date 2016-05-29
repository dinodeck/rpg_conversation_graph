
-- WaitState, MoveState must already be loaded.
assert(WaitState)
assert(MoveState)

gCharacterStates =
{
    wait = WaitState,
    move = MoveState,
    npc_stand = NPCStandState,
    plan_stroll = PlanStrollState,
    follow_path = FollowPathState,
    cs_run_anim = CSRunAnim,
    cs_hurt = CSHurt,
    cs_move = CSMove,
    cs_standby = CSStandby,
    cs_die_enemy = CSEnemyDie,
    cs_hurt_enemy = CSEnemyHurt,
}

gEntities =
{
    hero =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 9,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    thief =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 41,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    mage =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 25,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    npc_major =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 105,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    npc_1 =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 121,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    npc_2 =
    {
        texture = "walk_cycle.png",
        width = 16,
        height = 24,
        startFrame = 137,
        tileX = 11,
        tileY = 3,
        layer = 1
    },
    chest =
    {
        texture = "chest.png",
        width = 16,
        height = 16,
        startFrame = 1,
        openFrame = 2
    },
    save_point =
    {
        texture = "save_point.png",
        width = 16,
        height = 16,
        startFrame = 1,
    },
}


gCharacters =
{
    hero =
    {
        entity = "hero",
        actorId = "hero",
        combatEntity = "combat_hero",
        anims =
        {
            up      = {1, 2, 3, 4},
            right   = {5, 6, 7, 8},
            down    = {9, 10, 11, 12},
            left    = {13, 14, 15, 16},
            prone   = {19, 20},
            attack  = {5, 4, 3, 2, 1},
            use     = {46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57},
            hurt    = {21, 22, 23, 24},
            standby = {36, 37, 38, 39},
            advance = {36, 37, 38, 39},
            retreat = {61, 62, 63, 64},
            death   = {26, 27, 28, 29},
            victory = {6, 7, 8, 9},
            slash   = {11, 12, 13, 14, 15, 16, 17, 18, 11},
        },
        facing = "down",
        controller =
        {
            "wait",
            "move",
            "follow_path",
            "cs_run_anim",
            "cs_hurt",
            "cs_move",
            "cs_standby",
        },
        state = "wait",
    },
    thief =
    {
        entity = "thief",
        actorId = "thief",
        combatEntity = "combat_thief",
        anims =
        {
            up      = {33, 34, 35, 36},
            right   = {37, 38, 39, 40},
            down    = {41, 42, 43, 44},
            left    = {45, 46, 47, 48},
            prone   = {9, 10},
            attack  = {1, 2, 3, 4, 5, 6, 7, 8},
            use     = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
            hurt    = {21, 22, 23, 24, 25, 33, 34},
            standby = {36, 37, 38, 39},
            advance = {36, 37, 38, 39},
            retreat = {61, 62, 63, 64},
            death   = {26, 27, 28, 29, 30, 31, 32},
            victory = {56, 57, 58, 59, 60, 40},
            steal_1 = {41, 42, 43, 44, 45},
            steal_2 = {46, 47, 48, 49, 50, 51, 52, 53},
            steal_3 = {49, 48, 43, 44, 45},
            steal_4 = {45, 44, 43, 42, 41},
            steal_success = {54},
            steal_failure = {55}
        },
        facing = "down",
        controller =
        {
            "npc_stand",
            "follow_path",
            "move",
            "cs_run_anim",
            "cs_hurt",
            "cs_move",
            "cs_standby",
        },
        state = "npc_stand",
    },
    mage =
    {
        entity = "mage",
        actorId = "mage",
        combatEntity = "combat_mage",
        anims =
        {
            up      = {17, 18, 19, 20},
            right   = {21, 22, 23, 24},
            down    = {25, 26, 27, 28},
            left    = {29, 30, 31, 32},
            prone   = {51, 52},
            attack  = {1, 2, 3, 4, 5, 6, 7},
            use     = {41, 42, 43, 44, 45, 46, 47, 48},
            hurt    = {8, 9, 10, 21, 22, 23},
            standby = {36, 37, 38, 39},
            advance = {36, 37, 38, 39},
            retreat = {61, 62, 63, 64},
            death   = {26, 27, 28, 29, 30, 31, 32, 33, 34},
            victory = {56, 57, 58, 59, 60, 53, 54, 55, 49, 50, 40, 35},
            cast    = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25},
        },
        facing = "down",
        controller =
        {
            "npc_stand",
            "follow_path",
            "move",
            "cs_run_anim",
            "cs_hurt",
            "cs_move",
            "cs_standby",
        },
        state = "npc_stand",
    },
    npc_major =
    {
        entity = "npc_major",
        anims =
        {
            up      = {97,  98,  99,  100},
            right   = {101, 102, 103, 104},
            down    = {105, 106, 107, 108},
            left    = {109, 110, 111, 112},
        },
        facing = "down",
        controller = {"npc_stand", "follow_path", "move"},
        state = "npc_stand"
    },
    npc_inn_keeper =
    {
        entity = "npc_1",
        anims =
        {
            up      = {113, 114, 115, 116},
            right   = {117, 118, 119, 120},
            down    = {121, 122, 123, 124},
            left    = {125, 126, 127, 128},
        },
        facing = "down",
        controller = {"npc_stand"},
        state = "npc_stand"
    },
    npc_blacksmith =
    {
        entity = "npc_1",
        anims =
        {
            up      = {113, 114, 115, 116},
            right   = {117, 118, 119, 120},
            down    = {121, 122, 123, 124},
            left    = {125, 126, 127, 128},
        },
        facing = "down",
        controller = {"npc_stand"},
        state = "npc_stand"
    },
    npc_potion_master =
    {
        entity = "npc_1",
        anims =
        {
            up      = {113, 114, 115, 116},
            right   = {117, 118, 119, 120},
            down    = {121, 122, 123, 124},
            left    = {125, 126, 127, 128},
        },
        facing = "down",
        controller = {"npc_stand"},
        state = "npc_stand"
    },
    npc_villager_1 =
    {
        entity = "npc_1",
        anims =
        {
            up      = {113, 114, 115, 116},
            right   = {117, 118, 119, 120},
            down    = {121, 122, 123, 124},
            left    = {125, 126, 127, 128},
        },
        facing = "down",
        controller = {"npc_stand"},
        state = "npc_stand"
    },
    npc_villager_2 =
    {
        entity = "npc_2",
        anims =
        {
            up      = {129, 130, 131, 132},
            right   = {133, 134, 135, 136},
            down    = {137, 138, 139, 140},
            left    = {141, 142, 143, 144},
        },
        facing = "down",
        controller = {"npc_stand"},
        state = "npc_stand"
    },
}