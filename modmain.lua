GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local STACK_INTERVAL = GetModConfigData("STACK_INTERVAL")
local STACK_RADIUS = GetModConfigData("STACK_RADIUS")
local START_DELAY = GetModConfigData("START_DELAY")
local SORT_METHOD = GetModConfigData("SORT_METHOD")
local ENABLE_STACK_DELAY = GetModConfigData("STACK_DELAY")
local ALLOW_MOB_STACK = GetModConfigData("ALLOW_MOB_STACK")
local STACK_MODE = GetModConfigData("STACK_MODE")
local EXCLUDE_TRAPS = GetModConfigData("EXCLUDE_TRAPS")
local PROTECT_RARE = GetModConfigData("PROTECT_RARE")

local ENABLE_STATISTICS = GetModConfigData("ENABLE_STATISTICS")
local ENABLE_ACHIEVEMENTS = GetModConfigData("ENABLE_ACHIEVEMENTS")
local ENABLE_SOUND = GetModConfigData("ENABLE_SOUND")
local SOUND_TYPE = GetModConfigData("SOUND_TYPE")
local ENABLE_MAGNET = GetModConfigData("ENABLE_MAGNET")
local MAGNET_SPEED = GetModConfigData("MAGNET_SPEED")
local ENABLE_RANGE_INDICATOR = GetModConfigData("ENABLE_RANGE_INDICATOR")

local stack_count = 0
local total_items_stacked = 0
local session_stack_count = 0

local BASIC_RESOURCES = {
    "log",
    "rocks",
    "cutgrass",
    "twigs",
    "flint",
    "rock_avocado_fruit",
    "rock_avocado_fruit_ripe",
    "nitre",
    "goldnugget",
    "cutreeds",
    "charcoal",
    "petals",
    "foliage",
    "rope",
    "boards",
    "cutstone",
    "papyrus",
    "houndstooth",
    "stinger",
    "silk",
    "ash",
    "pinecone",
    "acorn",
    "twiggy_nut",
    "seeds",
    "ice",
    "moonrocknugget"
}

local WINTER_FEAST_ITEMS = {
    "winter_food1",
    "winter_food2",
    "winter_food3",
    "winter_food4",
    "winter_food5",
    "winter_food6",
    "winter_food7",
    "winter_food8",
    "winter_food9",
    "festive_plant",
    "festive_tree_item",
    "festive_tree_planter",
    "winter_ornament_plain1",
    "winter_ornament_plain2",
    "winter_ornament_plain3",
    "winter_ornament_plain4",
    "winter_ornament_plain5",
    "winter_ornament_plain6",
    "winter_ornament_fancy1",
    "winter_ornament_fancy2",
    "winter_ornament_fancy3",
    "winter_ornament_fancy4",
    "winter_ornament_fancy5",
    "winter_ornament_fancy6",
    "winter_ornament_light1",
    "winter_ornament_light2",
    "winter_ornament_light3",
    "winter_ornament_light4",
    "winter_ornament_light5",
    "winter_ornament_light6",
    "winter_ornament_light7",
    "winter_ornament_light8",
    "gift",
    "giftwrap",
    "winter_gingerbreadcookie",
    "winter_ornamentstar",
    "winter_ornamentbutterfly",
    "winter_ornamentdeerhead",
    "winter_ornament_boss_bearger",
    "winter_ornament_boss_deerclops",
    "winter_ornament_boss_moose",
    "winter_ornament_boss_dragonfly",
    "winter_ornament_boss_beequeen",
    "winter_ornament_boss_toadstool",
    "winter_ornament_boss_antlion",
    "winter_ornament_boss_klaus",
    "winter_ornament_boss_fuelweaver",
    "winter_ornament_boss_malbatross",
    "winter_ornament_boss_crabking",
    "winter_ornament_boss_eyeofterror",
    "winter_ornament_boss_twinofterror",
    "winter_ornament_boss_wagstaff",
    "winter_ornament_boss_daywalker",
    "winter_ornament_boss_krampus",
    "winter_ornament_boss_minotaur",
    "winter_ornament_boss_pearl",
    "winter_ornament_boss_celestialchampion",
    "winter_ornament_boss_alterguardian",
    "winter_ornament_boss_stalker"
}

local RARE_ITEMS = {
    "deerclops_eyeball",
    "dragon_scales",
    "bearger_fur",
    "thulecite",
    "thulecite_pieces",
    "purehorror",
    "purelight",
    "walrus_tusk",
    "malbatross_beak",
    "gears",
}

local BASIC_RESOURCES_LOOKUP = {}
for _, prefab in ipairs(BASIC_RESOURCES) do
    BASIC_RESOURCES_LOOKUP[prefab] = true
end

local WINTER_FEAST_ITEMS_LOOKUP = {}
for _, prefab in ipairs(WINTER_FEAST_ITEMS) do
    WINTER_FEAST_ITEMS_LOOKUP[prefab] = true
end

local RARE_ITEMS_LOOKUP = {}
for _, prefab in ipairs(RARE_ITEMS) do
    RARE_ITEMS_LOOKUP[prefab] = true
end

local achievement_milestones = {10, 50, 100, 500, 1000, 5000, 10000}
local announced_milestones = {}

local function PlayStackSound(player)
    if not ENABLE_SOUND or not player or not player:IsValid() then return end
    
    local sound_map = {
        pop = "dontstarve/common/destroy_wood",
        ding = "dontstarve/wilson/pickup_reeds",
        whoosh = "dontstarve/common/teleportworm/swallow",
        click = "dontstarve/common/together/packaged"
    }
    
    local sound = sound_map[SOUND_TYPE] or sound_map.pop
    player.SoundEmitter:PlaySound(sound)
end

local function MoveItemToTarget(item, target)
    if not ENABLE_MAGNET or not item or not item:IsValid() or not target or not target:IsValid() then
        return
    end
    
    local item_pos = item:GetPosition()
    local target_pos = target:GetPosition()
    local dx = target_pos.x - item_pos.x
    local dz = target_pos.z - item_pos.z
    local dist = math.sqrt(dx * dx + dz * dz)
    
    if dist > 0.1 then
        local speed = MAGNET_SPEED * 0.1
        local move_x = item_pos.x + (dx / dist) * speed
        local move_z = item_pos.z + (dz / dist) * speed
        item.Transform:SetPosition(move_x, 0, move_z)
    end
end

local function AnnounceToPlayers(message)
    for _, player in ipairs(AllPlayers) do
        if player and player.components.talker then
            player.components.talker:Say(message)
        end
    end
end

local function CheckAchievements()
    for _, milestone in ipairs(achievement_milestones) do
        if stack_count >= milestone and not announced_milestones[milestone] then
            announced_milestones[milestone] = true
            AnnounceToPlayers(" 堆叠成就达成：" .. milestone .. "次堆叠！")
        end
    end
end

local function RecordSpawnTime(inst)
    if inst.components and inst.components.stackable then
        inst.spawn_time = GetTime()
    end
end

AddPrefabPostInit("", RecordSpawnTime)

local function EnhancedStackItems()
    local world = TheWorld
    if not world then return end
    
    local players = AllPlayers
    if not players or #players == 0 then return end
    
    session_stack_count = 0
    
    for _, player in ipairs(players) do
        if player and player:IsValid() then
            local x, y, z = player.Transform:GetWorldPosition()
            
            local items = TheSim:FindEntities(x, y, z, STACK_RADIUS, 
                {"_inventoryitem"}, 
                {"INLIMBO", "NOCLICK", "catchable", "fire"}
            )
            
            local grouped = {}
            for _, item in ipairs(items) do
                if item and item:IsValid() and item.prefab and 
                   item.components and item.components.stackable and 
                   not item.components.stackable:IsFull() and
                   item.components.inventoryitem and 
                   not item.components.inventoryitem:IsHeld() and
                   not item:HasTag("INLIMBO") and
                   (not EXCLUDE_TRAPS or not item:HasTag("trap")) and
                   (not PROTECT_RARE or not RARE_ITEMS_LOOKUP[item.prefab]) and
                   (ALLOW_MOB_STACK or (
                       not item:HasTag("mob") and
                       not item:HasTag("firefly") and
                       not item.components.health and
                       not item.components.locomotor
                   )) and
                   (STACK_MODE == "all" or 
                    (STACK_MODE == "basic" and BASIC_RESOURCES_LOOKUP[item.prefab]) or
                    (STACK_MODE == "basic_winter" and (BASIC_RESOURCES_LOOKUP[item.prefab] or WINTER_FEAST_ITEMS_LOOKUP[item.prefab]))) then
                    
                    if not grouped[item.prefab] then
                        grouped[item.prefab] = {}
                    end
                    table.insert(grouped[item.prefab], item)
                end
            end
            
            for prefab, group in pairs(grouped) do
                if #group > 1 then
                    if SORT_METHOD == "most_first" then
                        table.sort(group, function(a, b)
                            return a.components.stackable.stacksize > b.components.stackable.stacksize
                        end)
                    elseif SORT_METHOD == "least_first" then
                        table.sort(group, function(a, b)
                            return a.components.stackable.stacksize < b.components.stackable.stacksize
                        end)
                    elseif SORT_METHOD == "balanced" then
                        local total = 0
                        for _, item in ipairs(group) do
                            total = total + item.components.stackable.stacksize
                        end
                        local average = total / #group
                        
                        table.sort(group, function(a, b)
                            return math.abs(a.components.stackable.stacksize - average) < 
                                   math.abs(b.components.stackable.stacksize - average)
                        end)
                    elseif SORT_METHOD == "old_to_new" then
                        table.sort(group, function(a, b)
                            local a_time = a.spawn_time or 0
                            local b_time = b.spawn_time or 0
                            if a_time == b_time then
                                return false
                            end
                            return b_time < a_time
                        end)
                    elseif SORT_METHOD == "new_to_old" then
                        table.sort(group, function(a, b)
                            local a_time = a.spawn_time or 0
                            local b_time = b.spawn_time or 0
                            if a_time == b_time then
                                return false
                            end
                            return a_time < b_time
                        end)
                    end
                    
                    local target = group[1]
                    for i = 2, #group do
                        local item = group[i]
                        if target and target:IsValid() and item and item:IsValid() then
                            if target.components and target.components.stackable and 
                               item.components and item.components.stackable then
                                
                                if ENABLE_STACK_DELAY then
                                    player:DoTaskInTime(0.1 * (i-2), function()
                                        if target and target:IsValid() and item and item:IsValid() then
                                            if ENABLE_MAGNET then
                                                MoveItemToTarget(item, target)
                                            end
                                            
                                            if target.components.stackable and 
                                               not target.components.stackable:IsFull() then
                                                local old_size = target.components.stackable.stacksize
                                                target.components.stackable:Put(item)
                                                local new_size = target.components.stackable.stacksize
                                                
                                                if new_size > old_size then
                                                    session_stack_count = session_stack_count + (new_size - old_size)
                                                    stack_count = stack_count + 1
                                                    total_items_stacked = total_items_stacked + (new_size - old_size)
                                                    
                                                    PlayStackSound(player)
                                                    
                                                    if ENABLE_ACHIEVEMENTS then
                                                        CheckAchievements()
                                                    end
                                                end
                                            end
                                        end
                                    end)
                                else
                                    if ENABLE_MAGNET then
                                        MoveItemToTarget(item, target)
                                    end
                                    
                                    if not target.components.stackable:IsFull() then
                                        local old_size = target.components.stackable.stacksize
                                        target.components.stackable:Put(item)
                                        local new_size = target.components.stackable.stacksize
                                        
                                        if new_size > old_size then
                                            session_stack_count = session_stack_count + (new_size - old_size)
                                            stack_count = stack_count + 1
                                            total_items_stacked = total_items_stacked + (new_size - old_size)
                                            
                                            PlayStackSound(player)
                                            
                                            if ENABLE_ACHIEVEMENTS then
                                                CheckAchievements()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if ENABLE_STATISTICS and session_stack_count > 0 then
        AnnounceToPlayers(" 本次堆叠了 " .. session_stack_count .. " 个物品！")
    end
end

AddSimPostInit(function()
    if ENABLE_RANGE_INDICATOR then
        for _, player in ipairs(AllPlayers) do
            if player and player:IsValid() then
                player:DoPeriodicTask(1, function()
                    if player and player:IsValid() then
                        local x, y, z = player.Transform:GetWorldPosition()
                        SpawnPrefab("groundpoundring_fx").Transform:SetPosition(x, 0, z)
                    end
                end)
            end
        end
    end
    
    TheWorld:DoTaskInTime(START_DELAY, function()
        if STACK_INTERVAL <= 0 then
            TheWorld:DoPeriodicTask(0, EnhancedStackItems)
        else
            TheWorld:DoPeriodicTask(STACK_INTERVAL, EnhancedStackItems)
        end
    end)
end)
