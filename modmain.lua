-- 优化版掉落物堆叠模组
-- 作者: 橙小幸
-- Q群:1042944194 欢迎饥荒联机交流

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

-- 定义基础资源列表
local BASIC_RESOURCES = {
    -- 基础资源
    "log",           -- 木头
    "rocks",         -- 石头
    "cutgrass",      -- 草
    "twigs",         -- 树枝
    "flint",         -- 燧石
    
    -- 可以根据需要添加更多基础资源

    "rock_avocado_fruit", --石果
    "rock_avocado_fruit_ripe", --熟石果

    "nitre",         -- 硝石
    "goldnugget",    -- 金块
    "cutreeds",      -- 芦苇
    "charcoal",      -- 木炭
    "petals",        -- 花瓣
    "foliage",       -- 蕨叶
    "rope",          -- 绳子
    "boards",        -- 木板
    "cutstone",      -- 石砖
    "papyrus",       -- 莎草纸
    "houndstooth",   -- 狗牙
    "stinger",       -- 蜂刺
    "silk",          -- 蜘蛛丝
    "ash",           -- 灰烬
    "pinecone",      -- 松果
    "acorn",         -- 橡果
    "twiggy_nut",    -- 树枝树种
    "seeds",         -- 种子
    "ice",           -- 冰
    "moonrocknugget" -- 月岩
}

-- 定义冬季盛宴物品列表
local WINTER_FEAST_ITEMS = {
    "winter_food1",      -- 姜饼人
    "winter_food2",      -- 糖果手杖
    "winter_food3",      -- 永恒水果蛋糕
    "winter_food4",      -- 巧克力饼干
    "winter_food5",      -- 冬季浆果塔
    "winter_food6",      -- 胡萝卜蛋糕
    "winter_food7",      -- 布丁
    "winter_food8",      -- 甜甜圈
    "winter_food9",      -- 薄荷糖
    "festive_plant",     -- 节日植物
    "festive_tree_item", -- 节日树
    "festive_tree_planter", -- 节日树盆栽
    "winter_ornament_plain1", -- 普通装饰品1
    "winter_ornament_plain2", -- 普通装饰品2
    "winter_ornament_plain3", -- 普通装饰品3
    "winter_ornament_plain4", -- 普通装饰品4
    "winter_ornament_plain5", -- 普通装饰品5
    "winter_ornament_plain6", -- 普通装饰品6
    "winter_ornament_fancy1", -- 精美装饰品1
    "winter_ornament_fancy2", -- 精美装饰品2
    "winter_ornament_fancy3", -- 精美装饰品3
    "winter_ornament_fancy4", -- 精美装饰品4
    "winter_ornament_fancy5", -- 精美装饰品5
    "winter_ornament_fancy6", -- 精美装饰品6
    "winter_ornament_light1", -- 节日灯1
    "winter_ornament_light2", -- 节日灯2
    "winter_ornament_light3", -- 节日灯3
    "winter_ornament_light4", -- 节日灯4
    "winter_ornament_light5", -- 节日灯5
    "winter_ornament_light6", -- 节日灯6
    "winter_ornament_light7", -- 节日灯7
    "winter_ornament_light8", -- 节日灯8
    "gift",              -- 礼物
    "giftwrap",          -- 礼物包装
    "winter_gingerbreadcookie", -- 姜饼饼干
    "winter_ornamentstar",      -- 星星装饰
    "winter_ornamentbutterfly", -- 蝴蝶装饰
    "winter_ornamentdeerhead",  -- 鹿头装饰
    -- 添加所有boss装饰品
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

-- 定义稀有物品列表
local RARE_ITEMS = {
    "deerclops_eyeball",    -- 巨鹿眼球
    "dragon_scales",        -- 龙鳞
    "bearger_fur",          -- 熊皮
    "thulecite",           -- 铥矿
    "thulecite_pieces",    -- 铥矿碎片
    "purehorror",          -- 纯粹恐惧
    "purelight",           -- 纯粹光芒
    "walrus_tusk",         -- 海象牙
    "malbatross_beak",     -- 邪天翁喙
    "gears",               -- 齿轮
}

-- 将基础资源转换为查找表，以便快速检查
local BASIC_RESOURCES_LOOKUP = {}
for _, prefab in ipairs(BASIC_RESOURCES) do
    BASIC_RESOURCES_LOOKUP[prefab] = true
end

-- 将冬季盛宴物品转换为查找表
local WINTER_FEAST_ITEMS_LOOKUP = {}
for _, prefab in ipairs(WINTER_FEAST_ITEMS) do
    WINTER_FEAST_ITEMS_LOOKUP[prefab] = true
end

-- 将稀有物品转换为查找表
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
            AnnounceToPlayers("🏆 堆叠成就达成：" .. milestone .. "次堆叠！")
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
    
    -- 对每个玩家周围的物品进行堆叠
    for _, player in ipairs(players) do
        if player and player:IsValid() then
            -- 获取玩家位置
            local x, y, z = player.Transform:GetWorldPosition()
            
            local items = TheSim:FindEntities(x, y, z, STACK_RADIUS, 
                {"_inventoryitem"}, 
                {"INLIMBO", "NOCLICK", "catchable", "fire"}
            )
            
            -- 分组
            local grouped = {}
            for _, item in ipairs(items) do
                -- 增加更多安全检查
                if item and item:IsValid() and item.prefab and 
                   item.components and item.components.stackable and 
                   not item.components.stackable:IsFull() and
                   item.components.inventoryitem and 
                   not item.components.inventoryitem:IsHeld() and
                   not item:HasTag("INLIMBO") and
                   -- 检查是否排除陷阱
                   (not EXCLUDE_TRAPS or not item:HasTag("trap")) and
                   -- 检查是否保护稀有物品
                   (not PROTECT_RARE or not RARE_ITEMS_LOOKUP[item.prefab]) and
                   -- 根据配置决定是否检查生物相关的条件
                   (ALLOW_MOB_STACK or (
                       not item:HasTag("mob") and
                       not item:HasTag("firefly") and
                       not item.components.health and
                       not item.components.locomotor
                   )) and
                   -- 根据堆叠模式决定是否堆叠该物品
                   (STACK_MODE == "all" or 
                    (STACK_MODE == "basic" and BASIC_RESOURCES_LOOKUP[item.prefab]) or
                    (STACK_MODE == "basic_winter" and (BASIC_RESOURCES_LOOKUP[item.prefab] or WINTER_FEAST_ITEMS_LOOKUP[item.prefab]))) then
                    
                    if not grouped[item.prefab] then
                        grouped[item.prefab] = {}
                    end
                    table.insert(grouped[item.prefab], item)
                end
            end
            
            -- 对每种物品类型进行堆叠
            for prefab, group in pairs(grouped) do
                if #group > 1 then
                    -- 根据配置的排序方法进行排序
                    if SORT_METHOD == "most_first" then
                        -- 从多到少排序
                        table.sort(group, function(a, b)
                            return a.components.stackable.stacksize > b.components.stackable.stacksize
                        end)
                    elseif SORT_METHOD == "least_first" then
                        -- 从少到多排序
                        table.sort(group, function(a, b)
                            return a.components.stackable.stacksize < b.components.stackable.stacksize
                        end)
                    elseif SORT_METHOD == "balanced" then
                        -- 平均分配，先计算平均值
                        local total = 0
                        for _, item in ipairs(group) do
                            total = total + item.components.stackable.stacksize
                        end
                        local average = total / #group
                        
                        -- 按照与平均值的差距排序
                        table.sort(group, function(a, b)
                            return math.abs(a.components.stackable.stacksize - average) < 
                                   math.abs(b.components.stackable.stacksize - average)
                        end)
                    elseif SORT_METHOD == "old_to_new" then
                        -- 从老到新排序，使用实体的创建时间
                        table.sort(group, function(a, b)
                            -- 获取物品的存在时间（如果没有则使用当前时间）
                            local a_time = a.spawn_time or 0
                            local b_time = b.spawn_time or 0
                            -- 防止比较nil值导致崩溃
                            if a_time == b_time then
                                return false -- 相等时保持原顺序
                            end
                            -- 较新的物品（时间值大）放在前面作为目标
                            return b_time < a_time
                        end)
                    elseif SORT_METHOD == "new_to_old" then
                        -- 从新到老排序，使用实体的创建时间
                        table.sort(group, function(a, b)
                            local a_time = a.spawn_time or 0
                            local b_time = b.spawn_time or 0
                            -- 防止比较nil值导致崩溃
                            if a_time == b_time then
                                return false -- 相等时保持原顺序
                            end
                            return a_time < b_time
                        end)
                    end
                    
                    -- 从第一个物品开始，尝试将其他物品堆叠到它上面
                    local target = group[1]
                    for i = 2, #group do
                        local item = group[i]
                        -- 增加额外的安全检查
                        if target and target:IsValid() and item and item:IsValid() then
                            -- 确保目标和物品都有必要的组件
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