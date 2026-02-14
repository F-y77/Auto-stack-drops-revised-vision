local MOD_VERSION = "2.2.9"

local function GetLanguage()
    return locale ~= nil and locale or "zh"
end

local is_chinese = GetLanguage():find("zh") ~= nil

name = is_chinese and "自动堆叠掉落物" or "Auto Stack Items"
description = is_chinese and "自动将附近的同类掉落物堆叠在一起\n版本: "..MOD_VERSION.."\n支持多种堆叠模式和自定义配置\n推荐联机使用" or "Automatically stack nearby similar items\nVersion: "..MOD_VERSION.."\nSupports multiple stacking modes and custom configurations\nRecommended for multiplayer"
author = "橙小幸"
version = MOD_VERSION
forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"自动堆叠掉落物", "Auto_Stack_Drops", "橙小幸"}

local function Title(title)
    return {
        name = title,
        hover = "",
        options = {{description = "", data = 0}},
        default = 0,
    }
end

local config_labels = {
    basic_settings = is_chinese and "========== 基础设置 ==========" or "========== Basic Settings ==========",
    stack_mode_title = is_chinese and "========== 堆叠模式 ==========" or "========== Stack Mode ==========",
    sound_settings = is_chinese and "========== 音效设置 ==========" or "========== Sound Settings ==========",
    special_settings = is_chinese and "========== 特殊设置 ==========" or "========== Special Settings ==========",
    mod_info = is_chinese and "========== 模组信息 ==========" or "========== Mod Info ==========",
    
    stack_interval = is_chinese and "堆叠间隔" or "Stack Interval",
    stack_interval_hover = is_chinese and "多久执行一次堆叠操作（秒）" or "How often to perform stacking (seconds)",
    stack_radius = is_chinese and "堆叠范围" or "Stack Radius",
    stack_radius_hover = is_chinese and "检查多大范围内的物品进行堆叠（格子）" or "How far to check for items to stack (tiles)",
    start_delay = is_chinese and "启动延迟" or "Start Delay",
    start_delay_hover = is_chinese and "游戏开始后多久开始第一次堆叠（秒）" or "How long to wait before first stack after game starts (seconds)",
    
    stack_mode = is_chinese and "堆叠模式" or "Stack Mode",
    stack_mode_hover = is_chinese and "选择哪些物品可以堆叠" or "Choose which items can be stacked",
    stack_all = is_chinese and "堆叠所有物品" or "Stack All Items",
    stack_basic = is_chinese and "仅堆叠基础资源" or "Stack Basic Resources Only",
    stack_basic_winter = is_chinese and "基础资源+冬季盛宴物品" or "Basic Resources + Winter Feast Items",
    
    sort_method = is_chinese and "堆叠顺序" or "Stack Order",
    sort_method_hover = is_chinese and "决定如何选择堆叠目标" or "Determines how to choose stacking targets",
    most_first = is_chinese and "多到少" or "Most to Least",
    least_first = is_chinese and "少到多" or "Least to Most",
    balanced = is_chinese and "平均分配" or "Balanced",
    old_to_new = is_chinese and "老到新" or "Old to New",
    new_to_old = is_chinese and "新到老" or "New to Old",
    
    stack_delay = is_chinese and "延迟堆叠" or "Stack Delay",
    stack_delay_hover = is_chinese and "开启后物品会逐个堆叠，确保特殊效果能正确触发" or "Items will stack one by one to ensure special effects trigger correctly",
    
    enable_sound = is_chinese and "启用堆叠音效" or "Enable Stack Sound",
    enable_sound_hover = is_chinese and "堆叠时播放音效" or "Play sound when stacking",
    
    sound_type = is_chinese and "音效类型" or "Sound Type",
    sound_type_hover = is_chinese and "选择堆叠时播放的音效" or "Choose the sound to play when stacking",
    sound_pop = is_chinese and "啵" or "Pop",
    sound_ding = is_chinese and "叮" or "Ding",
    sound_whoosh = is_chinese and "嗖" or "Whoosh",
    sound_click = is_chinese and "咔" or "Click",
    
    allow_mob_stack = is_chinese and "允许小型生物堆叠" or "Allow Mob Stacking",
    allow_mob_stack_hover = is_chinese and "是否允许小型生物（如萤火虫等）进行堆叠" or "Whether to allow stacking of creatures (like fireflies)",
    
    exclude_traps = is_chinese and "排除陷阱" or "Exclude Traps",
    exclude_traps_hover = is_chinese and "是否排除陷阱类物品的堆叠" or "Whether to exclude traps from stacking",
    
    protect_rare = is_chinese and "保护稀有物品" or "Protect Rare Items",
    protect_rare_hover = is_chinese and "是否保护稀有物品不被堆叠（巨鹿眼球、熊皮、龙蝇皮、齿轮等）" or "Whether to protect rare items from stacking (Deerclops Eyeball, Bearger Fur, Dragon Scales, Gears, etc.)",
    
    instant = is_chinese and "立即" or "Instant",
    enable = is_chinese and "开启" or "Enable",
    disable = is_chinese and "关闭" or "Disable",
    allow = is_chinese and "允许" or "Allow",
    disallow = is_chinese and "禁止" or "Disallow",
    exclude = is_chinese and "排除" or "Exclude",
    dont_exclude = is_chinese and "不排除" or "Don't Exclude",
    protect = is_chinese and "保护" or "Protect",
    dont_protect = is_chinese and "不保护" or "Don't Protect",
    
    seconds = function(n) return is_chinese and n.."秒" or n.." seconds" end,
    tiles = function(n) return is_chinese and n.."格" or n.." tiles" end,
    
    version_info = is_chinese and "版本: "..MOD_VERSION.." | 支持多种堆叠模式" or "Version: "..MOD_VERSION.." | Multiple stacking modes",
    author_info = is_chinese and "作者：橙小幸" or "Author: 橙小幸",
    qq_group = is_chinese and "Q群:1042944194 欢迎饥荒联机交流" or "QQ Group:1042944194 Welcome to DST discussion",
    thanks = is_chinese and "感谢您的大力支持！" or "Thank you for your support!",
    
    unstable_features = is_chinese and "====== ⚠️超级不稳定功能 ======" or "========== Unstable Features ==========",
    unstable_warning = is_chinese and " 以下功能为实验性功能，默认关闭" or " Experimental features, disabled by default",
    
    enable_sound = is_chinese and "启用堆叠音效" or "Enable Stack Sound",
    enable_sound_hover = is_chinese and "堆叠时播放音效" or "Play sound when stacking",
    
    sound_type = is_chinese and "音效类型" or "Sound Type",
    sound_type_hover = is_chinese and "选择堆叠时播放的音效" or "Choose the sound to play when stacking",
    sound_pop = is_chinese and "啵" or "Pop",
    sound_ding = is_chinese and "叮" or "Ding",
    sound_whoosh = is_chinese and "嗖" or "Whoosh",
    sound_click = is_chinese and "咔" or "Click",
    
    enable_magnet = is_chinese and "启用磁铁效果" or "Enable Magnet Effect",
    enable_magnet_hover = is_chinese and "物品会自动向堆叠目标移动" or "Items will automatically move towards stack target",
    
    magnet_speed = is_chinese and "磁铁速度" or "Magnet Speed",
    magnet_speed_hover = is_chinese and "物品移动的速度" or "Speed of item movement",
    speed_slow = is_chinese and "慢速" or "Slow",
    speed_normal = is_chinese and "正常" or "Normal",
    speed_fast = is_chinese and "快速" or "Fast",
    
    enable_statistics = is_chinese and "启用堆叠统计" or "Enable Stack Statistics",
    enable_statistics_hover = is_chinese and "播报每次堆叠的物品数量" or "Announce the number of items stacked each time",
    
    enable_achievements = is_chinese and "启用堆叠成就" or "Enable Stack Achievements",
    enable_achievements_hover = is_chinese and "记录堆叠次数并在达到里程碑时播报" or "Track stacking count and announce milestones",
    
    enable_range_indicator = is_chinese and "显示堆叠范围" or "Show Stack Range",
    enable_range_indicator_hover = is_chinese and "在玩家周围显示堆叠范围光圈" or "Show a circle around player indicating stack range",
    
    enable_combo = is_chinese and "启用连击系统" or "Enable Combo System",
    enable_combo_hover = is_chinese and "连续堆叠会显示连击数" or "Show combo count for consecutive stacks",
    
    enable_leaderboard = is_chinese and "启用堆叠排行榜" or "Enable Stack Leaderboard",
    enable_leaderboard_hover = is_chinese and "定期播报堆叠排行榜" or "Periodically announce stack leaderboard",
    
    leaderboard_interval = is_chinese and "排行榜播报间隔" or "Leaderboard Interval",
    leaderboard_interval_hover = is_chinese and "多久播报一次排行榜（分钟）" or "How often to announce leaderboard (minutes)",
    
    enable_blessing = is_chinese and "启用堆叠祝福" or "Enable Stack Blessing",
    enable_blessing_hover = is_chinese and "堆叠时有概率获得临时增益" or "Chance to get temporary buff when stacking",
    
    blessing_chance = is_chinese and "祝福概率" or "Blessing Chance",
    blessing_chance_hover = is_chinese and "获得祝福的概率" or "Chance to receive blessing",
    
    blessing_message = is_chinese and "显示祝福消息" or "Show Blessing Message",
    blessing_message_hover = is_chinese and "获得祝福时是否显示消息" or "Whether to show message when receiving blessing",
    
    blessing_message_style = is_chinese and "消息风格" or "Message Style",
    blessing_message_style_hover = is_chinese and "祝福消息的显示风格" or "Display style of blessing message",
    message_detailed = is_chinese and "详细" or "Detailed",
    message_simple = is_chinese and "简洁" or "Simple",
    
    blessing_strength = is_chinese and "祝福强度" or "Blessing Strength",
    blessing_strength_hover = is_chinese and "祝福效果的强度" or "Strength of blessing effects",
    strength_weak = is_chinese and "弱（10%）" or "Weak (10%)",
    strength_normal = is_chinese and "正常（20%）" or "Normal (20%)",
    strength_strong = is_chinese and "强（30%）" or "Strong (30%)",
    strength_very_strong = is_chinese and "很强（50%）" or "Very Strong (50%)",
    
    blessing_duration = is_chinese and "祝福持续时间" or "Blessing Duration",
    blessing_duration_hover = is_chinese and "祝福效果持续多久（秒）" or "How long blessing effects last (seconds)",
    
    blessing_types = is_chinese and "祝福类型" or "Blessing Types",
    blessing_types_hover = is_chinese and "选择可以获得哪些类型的祝福" or "Choose which types of blessings can be received",
    types_all = is_chinese and "全部" or "All",
    types_speed_only = is_chinese and "仅速度" or "Speed Only",
    types_combat_only = is_chinese and "仅战斗（攻击+防御）" or "Combat Only (Attack+Defense)",
    types_speed_attack = is_chinese and "速度+攻击" or "Speed+Attack",
    types_speed_defense = is_chinese and "速度+防御" or "Speed+Defense",
    
    enable_fireworks = is_chinese and "启用堆叠烟花" or "Enable Stack Fireworks",
    enable_fireworks_hover = is_chinese and "达到里程碑时放烟花" or "Launch fireworks when reaching milestones",
    
    enable_preview = is_chinese and "启用堆叠预告" or "Enable Stack Preview",
    enable_preview_hover = is_chinese and "显示附近可堆叠物品数量" or "Show number of stackable items nearby",
    
    enable_emote = is_chinese and "启用堆叠表情" or "Enable Stack Emote",
    enable_emote_hover = is_chinese and "堆叠时玩家做表情动作" or "Player performs emote when stacking",
    
    enable_rage = is_chinese and "启用狂暴模式" or "Enable Rage Mode",
    enable_rage_hover = is_chinese and "连续堆叠进入狂暴状态" or "Enter rage mode with consecutive stacks",
    
    rage_threshold = is_chinese and "狂暴阈值" or "Rage Threshold",
    rage_threshold_hover = is_chinese and "多少次连击触发狂暴" or "How many combos to trigger rage",
    
    enable_heal = is_chinese and "启用堆叠治疗" or "Enable Stack Healing",
    enable_heal_hover = is_chinese and "堆叠时恢复生命/饥饿/理智" or "Restore health/hunger/sanity when stacking",
    
    heal_type = is_chinese and "治疗类型" or "Heal Type",
    heal_type_hover = is_chinese and "选择恢复哪种属性" or "Choose which attribute to restore",
    heal_health = is_chinese and "生命" or "Health",
    heal_hunger = is_chinese and "饥饿" or "Hunger",
    heal_sanity = is_chinese and "理智" or "Sanity",
    heal_random = is_chinese and "随机" or "Random",
    
    heal_amount = is_chinese and "治疗量" or "Heal Amount",
    heal_amount_hover = is_chinese and "每次恢复多少" or "How much to restore each time",
    
    enable_shield = is_chinese and "启用堆叠护盾" or "Enable Stack Shield",
    enable_shield_hover = is_chinese and "堆叠时获得临时护盾" or "Get temporary shield when stacking",
    
    shield_amount = is_chinese and "护盾值" or "Shield Amount",
    shield_amount_hover = is_chinese and "护盾可以吸收多少伤害" or "How much damage shield can absorb",
    
    enable_aura = is_chinese and "启用堆叠光环" or "Enable Stack Aura",
    enable_aura_hover = is_chinese and "堆叠时给附近队友加buff" or "Give buff to nearby teammates when stacking",
    
    aura_range = is_chinese and "光环范围" or "Aura Range",
    aura_range_hover = is_chinese and "光环影响范围" or "Range of aura effect",
    
    enable_lucky = is_chinese and "启用堆叠幸运" or "Enable Stack Lucky",
    enable_lucky_hover = is_chinese and "堆叠后提升掉落品质" or "Improve drop quality after stacking",
    
    lucky_duration = is_chinese and "幸运持续时间" or "Lucky Duration",
    lucky_duration_hover = is_chinese and "幸运效果持续多久" or "How long lucky effect lasts",
    
    enable_auto_pickup = is_chinese and "启用自动拾取" or "Enable Auto Pickup",
    enable_auto_pickup_hover = is_chinese and "堆叠后自动将物品放入背包" or "Automatically pickup items after stacking",
    
    enable_stack_limit = is_chinese and "启用堆叠上限修改" or "Enable Stack Limit Modifier",
    enable_stack_limit_hover = is_chinese and "修改物品的最大堆叠数量（模组联动）" or "Modify maximum stack size (mod integration)",
    
    stack_limit = is_chinese and "堆叠上限" or "Stack Limit",
    stack_limit_hover = is_chinese and "设置物品的最大堆叠数量" or "Set maximum stack size for items",
    
    enable_teleport = is_chinese and "启用堆叠传送" or "Enable Stack Teleport",
    enable_teleport_hover = is_chinese and "堆叠大量物品时传送到玩家身边" or "Teleport items to player when stacking large amounts",
    
    teleport_threshold = is_chinese and "传送阈值" or "Teleport Threshold",
    teleport_threshold_hover = is_chinese and "堆叠到多少个时触发传送" or "Stack size to trigger teleport",
    
    enable_exp = is_chinese and "启用堆叠经验" or "Enable Stack Experience",
    enable_exp_hover = is_chinese and "堆叠时获得经验值（需要等级模组）" or "Gain experience when stacking (requires level mod)",
    
    exp_amount = is_chinese and "经验值" or "Experience Amount",
    exp_amount_hover = is_chinese and "每次堆叠获得的经验值" or "Experience gained per stack",
    
    enable_durability = is_chinese and "启用堆叠修复" or "Enable Stack Repair",
    enable_durability_hover = is_chinese and "堆叠时修复装备耐久度" or "Repair equipment durability when stacking",
    
    repair_amount = is_chinese and "修复量" or "Repair Amount",
    repair_amount_hover = is_chinese and "每次堆叠修复的耐久度百分比" or "Durability percentage repaired per stack",
    
    enable_temperature = is_chinese and "启用堆叠温度调节" or "Enable Stack Temperature",
    enable_temperature_hover = is_chinese and "堆叠时调节玩家温度" or "Adjust player temperature when stacking",
    
    temperature_effect = is_chinese and "温度效果" or "Temperature Effect",
    temperature_effect_hover = is_chinese and "选择温度调节效果" or "Choose temperature adjustment effect",
    temp_cooling = is_chinese and "降温" or "Cooling",
    temp_warming = is_chinese and "升温" or "Warming",
    temp_normalize = is_chinese and "恒温" or "Normalize",
    
    enable_light = is_chinese and "启用堆叠光源" or "Enable Stack Light",
    enable_light_hover = is_chinese and "堆叠时在玩家周围产生光源" or "Create light source around player when stacking",
    
    light_duration = is_chinese and "光源持续时间" or "Light Duration",
    light_duration_hover = is_chinese and "光源持续多久（秒）" or "How long light lasts (seconds)",
    
    enable_wetness = is_chinese and "启用堆叠防潮" or "Enable Stack Dryness",
    enable_wetness_hover = is_chinese and "堆叠时降低玩家潮湿度" or "Reduce player wetness when stacking",
    
    enable_fertilizer = is_chinese and "启用堆叠施肥" or "Enable Stack Fertilizer",
    enable_fertilizer_hover = is_chinese and "堆叠时自动给附近农作物施肥" or "Automatically fertilize nearby crops when stacking",
    
    pickup_threshold = is_chinese and "拾取阈值" or "Pickup Threshold",
    pickup_threshold_hover = is_chinese and "堆叠到多少个时自动拾取" or "Auto pickup when stack reaches this amount",
    
    pickup_rare_only = is_chinese and "仅拾取稀有物品" or "Pickup Rare Items Only",
    pickup_rare_only_hover = is_chinese and "只自动拾取稀有物品" or "Only auto pickup rare items",
    
    pickup_basic_only = is_chinese and "仅拾取基础资源" or "Pickup Basic Resources Only",
    pickup_basic_only_hover = is_chinese and "只自动拾取基础资源" or "Only auto pickup basic resources",
    
    pickup_all = is_chinese and "拾取所有物品" or "Pickup All Items",
    pickup_all_hover = is_chinese and "自动拾取所有堆叠物品" or "Auto pickup all stacked items",
    
    chance_low = is_chinese and "低（5%）" or "Low (5%)",
    chance_medium = is_chinese and "中（10%）" or "Medium (10%)",
    chance_high = is_chinese and "高（20%）" or "High (20%)",
    
    minutes = function(n) return is_chinese and n.."分钟" or n.." minutes" end,
    items = function(n) return is_chinese and n.."个" or n.." items" end
}

configuration_options = {
    Title(config_labels.basic_settings),
    {
        name = "STACK_INTERVAL",
        label = config_labels.stack_interval,
        hover = config_labels.stack_interval_hover,
        options = {
            {description = config_labels.instant, data = 0},
            {description = config_labels.seconds(1), data = 1},
            {description = config_labels.seconds(2), data = 2},
            {description = config_labels.seconds(5), data = 5},
            {description = config_labels.seconds(10), data = 10},
            {description = config_labels.seconds(20), data = 20},
            {description = config_labels.seconds(30), data = 30},
            {description = config_labels.seconds(60), data = 60},
            {description = config_labels.seconds(120), data = 120}
        },
        default = 1
    },
    {
        name = "STACK_RADIUS",
        label = config_labels.stack_radius,
        hover = config_labels.stack_radius_hover,
        options = {
            {description = config_labels.tiles(3), data = 3},
            {description = config_labels.tiles(5), data = 5},
            {description = config_labels.tiles(8), data = 8},
            {description = config_labels.tiles(10), data = 10},
            {description = config_labels.tiles(15), data = 15},
            {description = config_labels.tiles(20), data = 20},
            {description = config_labels.tiles(30), data = 30},
            {description = config_labels.tiles(100), data = 100},
        },
        default = 15
    },
    {
        name = "START_DELAY",
        label = config_labels.start_delay,
        hover = config_labels.start_delay_hover,
        options = {
            {description = config_labels.seconds(5), data = 5},
            {description = config_labels.seconds(10), data = 10},
            {description = config_labels.seconds(20), data = 20},
            {description = config_labels.seconds(30), data = 30},
            {description = config_labels.seconds(60), data = 60}
        },
        default = 10
    },
    Title(""),
    Title(config_labels.stack_mode_title),
    {
        name = "STACK_MODE",
        label = config_labels.stack_mode,
        hover = config_labels.stack_mode_hover,
        options = {
            {description = config_labels.stack_all, data = "all"},
            {description = config_labels.stack_basic, data = "basic"},
            {description = config_labels.stack_basic_winter, data = "basic_winter"},
        },
        default = "all",
    },
    {
        name = "SORT_METHOD",
        label = config_labels.sort_method,
        hover = config_labels.sort_method_hover,
        options = {
            {description = config_labels.most_first, data = "most_first"},
            {description = config_labels.least_first, data = "least_first"},
            {description = config_labels.balanced, data = "balanced"},
            {description = config_labels.old_to_new, data = "old_to_new"},
            {description = config_labels.new_to_old, data = "new_to_old"}   
        },
        default = "most_first"
    },
    {
        name = "STACK_DELAY",
        label = config_labels.stack_delay,
        hover = config_labels.stack_delay_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = true,
    },
    Title(""),
    Title(config_labels.sound_settings),
    {
        name = "ENABLE_SOUND",
        label = config_labels.enable_sound,
        hover = config_labels.enable_sound_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "SOUND_TYPE",
        label = config_labels.sound_type,
        hover = config_labels.sound_type_hover,
        options = {
            {description = config_labels.sound_pop, data = "pop"},
            {description = config_labels.sound_ding, data = "ding"},
            {description = config_labels.sound_whoosh, data = "whoosh"},
            {description = config_labels.sound_click, data = "click"},
        },
        default = "pop",
    },
    Title(""),
    Title(config_labels.special_settings),
    {
        name = "ALLOW_MOB_STACK",
        label = config_labels.allow_mob_stack,
        hover = config_labels.allow_mob_stack_hover,
        options = {
            {description = config_labels.allow, data = true},
            {description = config_labels.disallow, data = false},
        },
        default = false,
    },
    {
        name = "EXCLUDE_TRAPS",
        label = config_labels.exclude_traps,
        hover = config_labels.exclude_traps_hover,
        options = {
            {description = config_labels.exclude, data = true},
            {description = config_labels.dont_exclude, data = false},
        },
        default = true,
    },
    {
        name = "PROTECT_RARE",
        label = config_labels.protect_rare,
        hover = config_labels.protect_rare_hover,
        options = {
            {description = config_labels.protect, data = true},
            {description = config_labels.dont_protect, data = false},
        },
        default = true,
    },
    Title(""),
    Title(config_labels.unstable_features),
    Title(config_labels.unstable_warning),
    {
        name = "ENABLE_MAGNET",
        label = config_labels.enable_magnet,
        hover = config_labels.enable_magnet_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "MAGNET_SPEED",
        label = config_labels.magnet_speed,
        hover = config_labels.magnet_speed_hover,
        options = {
            {description = config_labels.speed_slow, data = 1},
            {description = config_labels.speed_normal, data = 2},
            {description = config_labels.speed_fast, data = 4},
        },
        default = 2,
    },
    {
        name = "ENABLE_RANGE_INDICATOR",
        label = config_labels.enable_range_indicator,
        hover = config_labels.enable_range_indicator_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_COMBO",
        label = config_labels.enable_combo,
        hover = config_labels.enable_combo_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_LEADERBOARD",
        label = config_labels.enable_leaderboard,
        hover = config_labels.enable_leaderboard_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "LEADERBOARD_INTERVAL",
        label = config_labels.leaderboard_interval,
        hover = config_labels.leaderboard_interval_hover,
        options = {
            {description = config_labels.minutes(5), data = 5},
            {description = config_labels.minutes(10), data = 10},
            {description = config_labels.minutes(15), data = 15},
            {description = config_labels.minutes(30), data = 30},
        },
        default = 10,
    },
    {
        name = "ENABLE_BLESSING",
        label = config_labels.enable_blessing,
        hover = config_labels.enable_blessing_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "BLESSING_CHANCE",
        label = config_labels.blessing_chance,
        hover = config_labels.blessing_chance_hover,
        options = {
            {description = config_labels.chance_low, data = 0.05},
            {description = config_labels.chance_medium, data = 0.1},
            {description = config_labels.chance_high, data = 0.2},
        },
        default = 0.1,
    },
    {
        name = "BLESSING_MESSAGE",
        label = config_labels.blessing_message,
        hover = config_labels.blessing_message_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = true,
    },
    {
        name = "BLESSING_MESSAGE_STYLE",
        label = config_labels.blessing_message_style,
        hover = config_labels.blessing_message_style_hover,
        options = {
            {description = config_labels.message_detailed, data = "detailed"},
            {description = config_labels.message_simple, data = "simple"},
        },
        default = "simple",
    },
    {
        name = "BLESSING_STRENGTH",
        label = config_labels.blessing_strength,
        hover = config_labels.blessing_strength_hover,
        options = {
            {description = config_labels.strength_weak, data = 0.1},
            {description = config_labels.strength_normal, data = 0.2},
            {description = config_labels.strength_strong, data = 0.3},
            {description = config_labels.strength_very_strong, data = 0.5},
        },
        default = 0.2,
    },
    {
        name = "BLESSING_DURATION",
        label = config_labels.blessing_duration,
        hover = config_labels.blessing_duration_hover,
        options = {
            {description = config_labels.seconds(5), data = 5},
            {description = config_labels.seconds(10), data = 10},
            {description = config_labels.seconds(15), data = 15},
            {description = config_labels.seconds(20), data = 20},
            {description = config_labels.seconds(30), data = 30},
        },
        default = 10,
    },
    {
        name = "BLESSING_TYPES",
        label = config_labels.blessing_types,
        hover = config_labels.blessing_types_hover,
        options = {
            {description = config_labels.types_all, data = "all"},
            {description = config_labels.types_speed_only, data = "speed"},
            {description = config_labels.types_combat_only, data = "combat"},
            {description = config_labels.types_speed_attack, data = "speed_attack"},
            {description = config_labels.types_speed_defense, data = "speed_defense"},
        },
        default = "all",
    },
    {
        name = "ENABLE_FIREWORKS",
        label = config_labels.enable_fireworks,
        hover = config_labels.enable_fireworks_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_PREVIEW",
        label = config_labels.enable_preview,
        hover = config_labels.enable_preview_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_EMOTE",
        label = config_labels.enable_emote,
        hover = config_labels.enable_emote_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_RAGE",
        label = config_labels.enable_rage,
        hover = config_labels.enable_rage_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "RAGE_THRESHOLD",
        label = config_labels.rage_threshold,
        hover = config_labels.rage_threshold_hover,
        options = {
            {description = "5", data = 5},
            {description = "10", data = 10},
            {description = "15", data = 15},
            {description = "20", data = 20},
        },
        default = 10,
    },
    {
        name = "ENABLE_HEAL",
        label = config_labels.enable_heal,
        hover = config_labels.enable_heal_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "HEAL_TYPE",
        label = config_labels.heal_type,
        hover = config_labels.heal_type_hover,
        options = {
            {description = config_labels.heal_health, data = "health"},
            {description = config_labels.heal_hunger, data = "hunger"},
            {description = config_labels.heal_sanity, data = "sanity"},
            {description = config_labels.heal_random, data = "random"},
        },
        default = "random",
    },
    {
        name = "HEAL_AMOUNT",
        label = config_labels.heal_amount,
        hover = config_labels.heal_amount_hover,
        options = {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "5", data = 5},
            {description = "10", data = 10},
        },
        default = 2,
    },
    {
        name = "ENABLE_SHIELD",
        label = config_labels.enable_shield,
        hover = config_labels.enable_shield_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "SHIELD_AMOUNT",
        label = config_labels.shield_amount,
        hover = config_labels.shield_amount_hover,
        options = {
            {description = "10", data = 10},
            {description = "20", data = 20},
            {description = "50", data = 50},
            {description = "100", data = 100},
        },
        default = 20,
    },
    {
        name = "ENABLE_AURA",
        label = config_labels.enable_aura,
        hover = config_labels.enable_aura_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "AURA_RANGE",
        label = config_labels.aura_range,
        hover = config_labels.aura_range_hover,
        options = {
            {description = config_labels.tiles(5), data = 5},
            {description = config_labels.tiles(10), data = 10},
            {description = config_labels.tiles(15), data = 15},
        },
        default = 10,
    },
    {
        name = "ENABLE_LUCKY",
        label = config_labels.enable_lucky,
        hover = config_labels.enable_lucky_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "LUCKY_DURATION",
        label = config_labels.lucky_duration,
        hover = config_labels.lucky_duration_hover,
        options = {
            {description = config_labels.seconds(30), data = 30},
            {description = config_labels.seconds(60), data = 60},
            {description = config_labels.seconds(120), data = 120},
        },
        default = 60,
    },
    {
        name = "ENABLE_AUTO_PICKUP",
        label = config_labels.enable_auto_pickup,
        hover = config_labels.enable_auto_pickup_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "PICKUP_THRESHOLD",
        label = config_labels.pickup_threshold,
        hover = config_labels.pickup_threshold_hover,
        options = {
            {description = config_labels.items(5), data = 5},
            {description = config_labels.items(10), data = 10},
            {description = config_labels.items(20), data = 20},
            {description = config_labels.items(40), data = 40},
        },
        default = 20,
    },
    {
        name = "PICKUP_MODE",
        label = is_chinese and "拾取模式" or "Pickup Mode",
        hover = is_chinese and "选择自动拾取哪些物品" or "Choose which items to auto pickup",
        options = {
            {description = config_labels.pickup_all, data = "all", hover = config_labels.pickup_all_hover},
            {description = config_labels.pickup_rare_only, data = "rare", hover = config_labels.pickup_rare_only_hover},
            {description = config_labels.pickup_basic_only, data = "basic", hover = config_labels.pickup_basic_only_hover},
        },
        default = "all",
    },
    {
        name = "ENABLE_STATISTICS",
        label = config_labels.enable_statistics,
        hover = config_labels.enable_statistics_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_ACHIEVEMENTS",
        label = config_labels.enable_achievements,
        hover = config_labels.enable_achievements_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_STACK_LIMIT",
        label = config_labels.enable_stack_limit,
        hover = config_labels.enable_stack_limit_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "STACK_LIMIT",
        label = config_labels.stack_limit,
        hover = config_labels.stack_limit_hover,
        options = {
            {description = "99", data = 99},
            {description = "199", data = 199},
            {description = "499", data = 499},
            {description = "999", data = 999},
        },
        default = 99,
    },
    {
        name = "ENABLE_TELEPORT",
        label = config_labels.enable_teleport,
        hover = config_labels.enable_teleport_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "TELEPORT_THRESHOLD",
        label = config_labels.teleport_threshold,
        hover = config_labels.teleport_threshold_hover,
        options = {
            {description = "50", data = 50},
            {description = "100", data = 100},
            {description = "200", data = 200},
        },
        default = 100,
    },
    {
        name = "ENABLE_EXP",
        label = config_labels.enable_exp,
        hover = config_labels.enable_exp_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "EXP_AMOUNT",
        label = config_labels.exp_amount,
        hover = config_labels.exp_amount_hover,
        options = {
            {description = "1", data = 1},
            {description = "5", data = 5},
            {description = "10", data = 10},
            {description = "20", data = 20},
        },
        default = 5,
    },
    {
        name = "ENABLE_DURABILITY",
        label = config_labels.enable_durability,
        hover = config_labels.enable_durability_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "REPAIR_AMOUNT",
        label = config_labels.repair_amount,
        hover = config_labels.repair_amount_hover,
        options = {
            {description = "1%", data = 0.01},
            {description = "2%", data = 0.02},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
        },
        default = 0.02,
    },
    {
        name = "ENABLE_TEMPERATURE",
        label = config_labels.enable_temperature,
        hover = config_labels.enable_temperature_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "TEMPERATURE_EFFECT",
        label = config_labels.temperature_effect,
        hover = config_labels.temperature_effect_hover,
        options = {
            {description = config_labels.temp_cooling, data = "cooling"},
            {description = config_labels.temp_warming, data = "warming"},
            {description = config_labels.temp_normalize, data = "normalize"},
        },
        default = "normalize",
    },
    {
        name = "ENABLE_LIGHT",
        label = config_labels.enable_light,
        hover = config_labels.enable_light_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "LIGHT_DURATION",
        label = config_labels.light_duration,
        hover = config_labels.light_duration_hover,
        options = {
            {description = config_labels.seconds(10), data = 10},
            {description = config_labels.seconds(30), data = 30},
            {description = config_labels.seconds(60), data = 60},
        },
        default = 30,
    },
    {
        name = "ENABLE_WETNESS",
        label = config_labels.enable_wetness,
        hover = config_labels.enable_wetness_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    {
        name = "ENABLE_FERTILIZER",
        label = config_labels.enable_fertilizer,
        hover = config_labels.enable_fertilizer_hover,
        options = {
            {description = config_labels.enable, data = true},
            {description = config_labels.disable, data = false},
        },
        default = false,
    },
    Title(""),
    Title(config_labels.mod_info),
    Title(config_labels.version_info),
    Title(config_labels.author_info),
    Title(config_labels.qq_group),
    Title(config_labels.thanks)
}
