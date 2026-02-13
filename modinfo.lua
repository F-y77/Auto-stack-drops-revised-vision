local MOD_VERSION = "2.0.0"

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
    
    unstable_features = is_chinese and "========== 不稳定功能 ==========" or "========== Unstable Features ==========",
    unstable_warning = is_chinese and "⚠️ 以下功能为实验性功能，默认关闭" or "⚠️ Experimental features, disabled by default",
    
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
    enable_range_indicator_hover = is_chinese and "在玩家周围显示堆叠范围光圈" or "Show a circle around player indicating stack range"
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
    Title(""),
    Title(config_labels.mod_info),
    Title(config_labels.version_info),
    Title(config_labels.author_info),
    Title(config_labels.qq_group),
    Title(config_labels.thanks)
}
