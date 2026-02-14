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
local ENABLE_COMBO = GetModConfigData("ENABLE_COMBO")
local ENABLE_LEADERBOARD = GetModConfigData("ENABLE_LEADERBOARD")
local LEADERBOARD_INTERVAL = GetModConfigData("LEADERBOARD_INTERVAL")
local ENABLE_BLESSING = GetModConfigData("ENABLE_BLESSING")
local BLESSING_CHANCE = GetModConfigData("BLESSING_CHANCE")
local BLESSING_MESSAGE = GetModConfigData("BLESSING_MESSAGE")
local BLESSING_MESSAGE_STYLE = GetModConfigData("BLESSING_MESSAGE_STYLE")
local BLESSING_STRENGTH = GetModConfigData("BLESSING_STRENGTH")
local BLESSING_DURATION = GetModConfigData("BLESSING_DURATION")
local BLESSING_TYPES = GetModConfigData("BLESSING_TYPES")
local ENABLE_FIREWORKS = GetModConfigData("ENABLE_FIREWORKS")
local ENABLE_PREVIEW = GetModConfigData("ENABLE_PREVIEW")
local ENABLE_EMOTE = GetModConfigData("ENABLE_EMOTE")
local ENABLE_AUTO_PICKUP = GetModConfigData("ENABLE_AUTO_PICKUP")
local PICKUP_THRESHOLD = GetModConfigData("PICKUP_THRESHOLD")
local PICKUP_MODE = GetModConfigData("PICKUP_MODE")
local ENABLE_RAGE = GetModConfigData("ENABLE_RAGE")
local RAGE_THRESHOLD = GetModConfigData("RAGE_THRESHOLD")
local ENABLE_HEAL = GetModConfigData("ENABLE_HEAL")
local HEAL_TYPE = GetModConfigData("HEAL_TYPE")
local HEAL_AMOUNT = GetModConfigData("HEAL_AMOUNT")
local ENABLE_SHIELD = GetModConfigData("ENABLE_SHIELD")
local SHIELD_AMOUNT = GetModConfigData("SHIELD_AMOUNT")
local ENABLE_AURA = GetModConfigData("ENABLE_AURA")
local AURA_RANGE = GetModConfigData("AURA_RANGE")
local ENABLE_LUCKY = GetModConfigData("ENABLE_LUCKY")
local LUCKY_DURATION = GetModConfigData("LUCKY_DURATION")

local stack_count = 0
local total_items_stacked = 0
local session_stack_count = 0
local player_stats = {}
local combo_count = 0
local last_stack_time = 0
local combo_reset_time = 3

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

local function GetPlayerStat(player)
    if not player or not player.userid then return nil end
    if not player_stats[player.userid] then
        player_stats[player.userid] = {
            name = player.name or "Unknown",
            count = 0
        }
    end
    return player_stats[player.userid]
end

local function UpdateCombo()
    local current_time = GetTime()
    if current_time - last_stack_time > combo_reset_time then
        combo_count = 0
    end
    combo_count = combo_count + 1
    last_stack_time = current_time
    
    if ENABLE_COMBO and combo_count > 1 then
        AnnounceToPlayers(combo_count .. " 连击！")
    end
end

local function GiveBlessing(player)
    if not ENABLE_BLESSING or not player or not player:IsValid() then return end
    
    if math.random() < BLESSING_CHANCE then
        local available_blessings = {}
        
        if BLESSING_TYPES == "all" then
            available_blessings = {
                {name = "speed", display = "速度", mult = 1 + BLESSING_STRENGTH},
                {name = "attack", display = "攻击", mult = 1 + BLESSING_STRENGTH},
                {name = "defense", display = "防御", mult = 1 - BLESSING_STRENGTH * 0.5}
            }
        elseif BLESSING_TYPES == "speed" then
            available_blessings = {
                {name = "speed", display = "速度", mult = 1 + BLESSING_STRENGTH}
            }
        elseif BLESSING_TYPES == "combat" then
            available_blessings = {
                {name = "attack", display = "攻击", mult = 1 + BLESSING_STRENGTH},
                {name = "defense", display = "防御", mult = 1 - BLESSING_STRENGTH * 0.5}
            }
        elseif BLESSING_TYPES == "speed_attack" then
            available_blessings = {
                {name = "speed", display = "速度", mult = 1 + BLESSING_STRENGTH},
                {name = "attack", display = "攻击", mult = 1 + BLESSING_STRENGTH}
            }
        elseif BLESSING_TYPES == "speed_defense" then
            available_blessings = {
                {name = "speed", display = "速度", mult = 1 + BLESSING_STRENGTH},
                {name = "defense", display = "防御", mult = 1 - BLESSING_STRENGTH * 0.5}
            }
        end
        
        if #available_blessings == 0 then return end
        
        local blessing = available_blessings[math.random(#available_blessings)]
        
        if blessing.name == "speed" and player.components.locomotor then
            player.components.locomotor:SetExternalSpeedMultiplier(player, "stack_blessing", blessing.mult)
            player:DoTaskInTime(BLESSING_DURATION, function()
                if player and player:IsValid() and player.components.locomotor then
                    player.components.locomotor:RemoveExternalSpeedMultiplier(player, "stack_blessing")
                end
            end)
            
            if BLESSING_MESSAGE and player.components.talker then
                if BLESSING_MESSAGE_STYLE == "detailed" then
                    local percent = math.floor(BLESSING_STRENGTH * 100)
                    player.components.talker:Say("[祝福] 速度+" .. percent .. "% (" .. BLESSING_DURATION .. "秒)")
                else
                    player.components.talker:Say("[速度]")
                end
            end
            
        elseif blessing.name == "attack" and player.components.combat then
            player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1) * blessing.mult
            player:DoTaskInTime(BLESSING_DURATION, function()
                if player and player:IsValid() and player.components.combat then
                    player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1) / blessing.mult
                end
            end)
            
            if BLESSING_MESSAGE and player.components.talker then
                if BLESSING_MESSAGE_STYLE == "detailed" then
                    local percent = math.floor(BLESSING_STRENGTH * 100)
                    player.components.talker:Say("[祝福] 攻击+" .. percent .. "% (" .. BLESSING_DURATION .. "秒)")
                else
                    player.components.talker:Say("[攻击]")
                end
            end
            
        elseif blessing.name == "defense" and player.components.combat then
            player.components.combat.externaldamagetakenmultipliers:SetModifier(player, blessing.mult, "stack_blessing")
            player:DoTaskInTime(BLESSING_DURATION, function()
                if player and player:IsValid() and player.components.combat then
                    player.components.combat.externaldamagetakenmultipliers:RemoveModifier(player, "stack_blessing")
                end
            end)
            
            if BLESSING_MESSAGE and player.components.talker then
                if BLESSING_MESSAGE_STYLE == "detailed" then
                    local percent = math.floor(BLESSING_STRENGTH * 50)
                    player.components.talker:Say("[祝福] 防御+" .. percent .. "% (" .. BLESSING_DURATION .. "秒)")
                else
                    player.components.talker:Say("[防御]")
                end
            end
        end
    end
end

local function LaunchFireworks(player)
    if not ENABLE_FIREWORKS or not player or not player:IsValid() then return end
    
    local x, y, z = player.Transform:GetWorldPosition()
    for i = 1, 3 do
        player:DoTaskInTime(i * 0.3, function()
            if player and player:IsValid() then
                local fx = SpawnPrefab("firework_fx")
                if fx then
                    fx.Transform:SetPosition(x + math.random(-3, 3), 0, z + math.random(-3, 3))
                end
            end
        end)
    end
end

local function ShowStackPreview(player)
    if not ENABLE_PREVIEW or not player or not player:IsValid() then return end
    
    local x, y, z = player.Transform:GetWorldPosition()
    local items = TheSim:FindEntities(x, y, z, STACK_RADIUS, {"_inventoryitem"}, {"INLIMBO", "NOCLICK"})
    
    local stackable_count = 0
    for _, item in ipairs(items) do
        if item and item:IsValid() and item.components and item.components.stackable then
            stackable_count = stackable_count + 1
        end
    end
    
    if stackable_count > 5 and player.components.talker then
        player.components.talker:Say("附近有 " .. stackable_count .. " 个可堆叠物品")
    end
end

local function DoEmote(player)
    if not ENABLE_EMOTE or not player or not player:IsValid() then return end
    
    local emotes = {"happy", "pose", "loop_sit", "loop_laugh"}
    local emote = emotes[math.random(#emotes)]
    
    if player.components.playercontroller then
        player.components.playercontroller:DoEmote(emote)
    end
end

local function CheckRageMode(player)
    if not ENABLE_RAGE or not player or not player:IsValid() then return end
    
    if combo_count >= RAGE_THRESHOLD then
        if player.components.combat then
            player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1) * 1.5
            player:DoTaskInTime(10, function()
                if player and player:IsValid() and player.components.combat then
                    player.components.combat.damagemultiplier = (player.components.combat.damagemultiplier or 1) / 1.5
                end
            end)
        end
        
        if player.components.locomotor then
            player.components.locomotor:SetExternalSpeedMultiplier(player, "rage_mode", 1.3)
            player:DoTaskInTime(10, function()
                if player and player:IsValid() and player.components.locomotor then
                    player.components.locomotor:RemoveExternalSpeedMultiplier(player, "rage_mode")
                end
            end)
        end
        
        if player.components.talker then
            player.components.talker:Say("[狂暴] 进入狂暴状态！")
        end
    end
end

local function HealPlayer(player)
    if not ENABLE_HEAL or not player or not player:IsValid() then return end
    
    local heal_type = HEAL_TYPE
    if heal_type == "random" then
        local types = {"health", "hunger", "sanity"}
        heal_type = types[math.random(#types)]
    end
    
    if heal_type == "health" and player.components.health and not player.components.health:IsDead() then
        player.components.health:DoDelta(HEAL_AMOUNT)
        if player.components.talker then
            player.components.talker:Say("[治疗] 生命+" .. HEAL_AMOUNT)
        end
    elseif heal_type == "hunger" and player.components.hunger then
        player.components.hunger:DoDelta(HEAL_AMOUNT)
        if player.components.talker then
            player.components.talker:Say("[治疗] 饥饿+" .. HEAL_AMOUNT)
        end
    elseif heal_type == "sanity" and player.components.sanity then
        player.components.sanity:DoDelta(HEAL_AMOUNT)
        if player.components.talker then
            player.components.talker:Say("[治疗] 理智+" .. HEAL_AMOUNT)
        end
    end
end

local function GiveShield(player)
    if not ENABLE_SHIELD or not player or not player:IsValid() then return end
    
    if not player.stack_shield then
        player.stack_shield = 0
    end
    
    player.stack_shield = player.stack_shield + SHIELD_AMOUNT
    
    if player.components.talker then
        player.components.talker:Say("[护盾] +" .. SHIELD_AMOUNT)
    end
    
    if not player.shield_listener then
        player.shield_listener = player:ListenForEvent("attacked", function(inst, data)
            if inst.stack_shield and inst.stack_shield > 0 then
                local damage = data and data.damage or 0
                if damage > 0 then
                    local absorbed = math.min(damage, inst.stack_shield)
                    inst.stack_shield = inst.stack_shield - absorbed
                    
                    if data.attacker and data.attacker.components.combat then
                        data.attacker.components.combat:GetAttacked(inst, 0)
                    end
                    
                    if inst.components.talker then
                        inst.components.talker:Say("[护盾] 吸收" .. absorbed .. "伤害")
                    end
                    
                    if inst.stack_shield <= 0 then
                        inst.stack_shield = 0
                        if inst.components.talker then
                            inst.components.talker:Say("[护盾] 护盾破碎")
                        end
                    end
                end
            end
        end)
    end
end

local function ApplyAura(player)
    if not ENABLE_AURA or not player or not player:IsValid() then return end
    
    local x, y, z = player.Transform:GetWorldPosition()
    local nearby_players = TheSim:FindEntities(x, y, z, AURA_RANGE, {"player"})
    
    for _, nearby in ipairs(nearby_players) do
        if nearby and nearby:IsValid() and nearby ~= player then
            if nearby.components.locomotor then
                nearby.components.locomotor:SetExternalSpeedMultiplier(nearby, "stack_aura", 1.15)
                nearby:DoTaskInTime(5, function()
                    if nearby and nearby:IsValid() and nearby.components.locomotor then
                        nearby.components.locomotor:RemoveExternalSpeedMultiplier(nearby, "stack_aura")
                    end
                end)
            end
            
            if nearby.components.talker then
                nearby.components.talker:Say("[光环] 速度+15%")
            end
        end
    end
    
    if player.components.talker then
        player.components.talker:Say("[光环] 影响" .. (#nearby_players - 1) .. "名队友")
    end
end

local function ApplyLucky(player)
    if not ENABLE_LUCKY or not player or not player:IsValid() then return end
    
    if not player.stack_lucky_active then
        player.stack_lucky_active = true
        
        if player.components.talker then
            player.components.talker:Say("[幸运] 幸运效果激活")
        end
        
        player:DoTaskInTime(LUCKY_DURATION, function()
            if player and player:IsValid() then
                player.stack_lucky_active = false
                if player.components.talker then
                    player.components.talker:Say("[幸运] 幸运效果结束")
                end
            end
        end)
    end
end

local function AutoPickupItem(player, item)
    if not ENABLE_AUTO_PICKUP or not player or not player:IsValid() or not item or not item:IsValid() then
        return false
    end
    
    if not item.components or not item.components.stackable or not item.components.inventoryitem then
        return false
    end
    
    local stacksize = item.components.stackable.stacksize
    if stacksize < PICKUP_THRESHOLD then
        return false
    end
    
    local should_pickup = false
    if PICKUP_MODE == "all" then
        should_pickup = true
    elseif PICKUP_MODE == "rare" then
        should_pickup = RARE_ITEMS_LOOKUP[item.prefab] == true
    elseif PICKUP_MODE == "basic" then
        should_pickup = BASIC_RESOURCES_LOOKUP[item.prefab] == true
    end
    
    if should_pickup and player.components.inventory then
        if not player.components.inventory:IsFull() then
            player.components.inventory:GiveItem(item)
            return true
        end
    end
    
    return false
end

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
            
            if ENABLE_FIREWORKS then
                for _, player in ipairs(AllPlayers) do
                    if player and player:IsValid() then
                        LaunchFireworks(player)
                    end
                end
            end
        end
    end
end

local function AnnounceLeaderboard()
    if not ENABLE_LEADERBOARD then return end
    
    local sorted = {}
    for userid, stat in pairs(player_stats) do
        table.insert(sorted, {name = stat.name, count = stat.count})
    end
    
    table.sort(sorted, function(a, b) return a.count > b.count end)
    
    if #sorted > 0 then
        local msg = " 堆叠排行榜："
        for i = 1, math.min(3, #sorted) do
            msg = msg .. " " .. i .. "." .. sorted[i].name .. "(" .. sorted[i].count .. ")"
        end
        AnnounceToPlayers(msg)
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
                                                    
                                                    local stat = GetPlayerStat(player)
                                                    if stat then
                                                        stat.count = stat.count + 1
                                                    end
                                                    
                                                    UpdateCombo()
                                                    PlayStackSound(player)
                                                    GiveBlessing(player)
                                                    CheckRageMode(player)
                                                    HealPlayer(player)
                                                    GiveShield(player)
                                                    ApplyAura(player)
                                                    ApplyLucky(player)
                                                    
                                                    if math.random() < 0.1 then
                                                        DoEmote(player)
                                                    end
                                                    
                                                    AutoPickupItem(player, target)
                                                    
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
                                            
                                            local stat = GetPlayerStat(player)
                                            if stat then
                                                stat.count = stat.count + 1
                                            end
                                            
                                            UpdateCombo()
                                            PlayStackSound(player)
                                            GiveBlessing(player)
                                            CheckRageMode(player)
                                            HealPlayer(player)
                                            GiveShield(player)
                                            ApplyAura(player)
                                            ApplyLucky(player)
                                            
                                            if math.random() < 0.1 then
                                                DoEmote(player)
                                            end
                                            
                                            AutoPickupItem(player, target)
                                            
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
    
    if ENABLE_PREVIEW then
        for _, player in ipairs(AllPlayers) do
            if player and player:IsValid() then
                player:DoPeriodicTask(30, function()
                    ShowStackPreview(player)
                end)
            end
        end
    end
    
    if ENABLE_LEADERBOARD then
        TheWorld:DoPeriodicTask(LEADERBOARD_INTERVAL * 60, AnnounceLeaderboard)
    end
    
    TheWorld:DoTaskInTime(START_DELAY, function()
        if STACK_INTERVAL <= 0 then
            TheWorld:DoPeriodicTask(0, EnhancedStackItems)
        else
            TheWorld:DoPeriodicTask(STACK_INTERVAL, EnhancedStackItems)
        end
    end)
end)
