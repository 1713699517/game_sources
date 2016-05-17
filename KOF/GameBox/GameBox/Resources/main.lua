

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
    CCLuaLog(debug.traceback())
    CCLuaLog("----------------------------------------")
    --os.exit()
    --print("----------------------------------------")
    --print("LUA ERROR: " .. tostring(msg) .. "\n")
    --print(debug.traceback())
    --print("----------------------------------------")
end

function CCLOG(...)
    --print(string.format(...))
    CCLuaLog(string.format(...))
end

function g_resetAll()
    if _G.controller ~= nil then
        _G.controller:unregisterMediators()
    end
    if _G.CNetwork ~= nil then
        _G.CNetwork:setReconnect(false)
        _G.CNetwork:disconnect()
    end
end

function g_initializeMediators()

    require "proxy/CharacterPropertyProxy"
    require "proxy/ChatDataProxy"
    require "proxy/DailyTaskProxy"
    require "proxy/DuplicateDataProxy"
    require "proxy/FriendDataProxy"

    require "proxy/FunctionOpenProxy"
    require "proxy/GoodsPropertyProxy"
    require "proxy/LoginInfoProxy"
    require "proxy/LuckyDataProxy"

    require "proxy/SkillDataProxy"
    require "proxy/SystemSettingProxy"
    require "proxy/TaskNewDataProxy"
    require "model/GameDataProxy"

    require "proxy/PayCheckProxy"
    --清空缓存
    _G.g_characterProperty      = nil
    _G.g_ChatDataProxy          = nil
    _G.pCDailyTaskProxy         = nil
    _G.g_DuplicateDataProxy     = nil
    _G.pCFriendDataProxy        = nil

    _G.pCFunctionOpenProxy      = nil
    _G.g_GoodsProperty          = nil
    _G.g_LoginInfoProxy         = nil
    _G.g_LuckyDataProxy         = nil

    _G.g_SkillDataProxy         = nil
    _G.pCSystemSettingProxy     = nil
    _G.g_CTaskNewDataProxy      = nil
    _G.g_GameDataProxy          = nil
    _G.g_CPayCheckProxy         = nil

    _G.g_characterProperty      = CCharacterPropertyProxy()
    _G.g_ChatDataProxy          = CChatDataProxy()
    _G.pCDailyTaskProxy         = CDailyTaskProxy()
    _G.g_DuplicateDataProxy     = CDuplicateDataProxy()
    _G.pCFriendDataProxy        = CFriendDataProxy()

    _G.pCFunctionOpenProxy      = CFunctionOpenProxy()
    _G.g_GoodsProperty          = CGoodsPropertyProxy()
    _G.g_LoginInfoProxy         = CLoginInfoProxy()
    _G.g_LuckyDataProxy         = CLuckyDataProxy()

    _G.g_SkillDataProxy         = CSkillDataProxy()
    _G.pCSystemSettingProxy     = CSystemSettingProxy()
    _G.g_CTaskNewDataProxy      = CTaskNewDataProxy()
    _G.g_GameDataProxy          = CGameDataProxy()
    _G.g_CPayCheckProxy         = CPayCheckProxy()
    --]]

    --CCMessageBox("重新加载", "1" )
    require "common/ServerTime"
    _G.pServerTimeMediator = CServerTimeMediator(_G.g_ServerTime)
    controller:registerMediator(_G.pServerTimeMediator)

    _G.g_Stage = CStage()

    --人物属性
    require "proxy/CharacterPropertyProxy"
    require "mediator/CharacterPropertyMediator"
    _G.pCharacterPropertyMediator = CCharacterPropertyMediator( _G.g_characterProperty )
    _G.controller : registerMediator( _G.pCharacterPropertyMediator )

    --{任务缓存}
    require "proxy/TaskNewDataProxy"
    require "mediator/TaskNewDataMediator"
    _G.pTaskNewDataMediator = CTaskNewDataMediator( _G.g_CTaskNewDataProxy )
    controller :registerMediator( _G.pTaskNewDataMediator )

    --{技能缓存}
    require "proxy/SkillDataProxy"
    require "mediator/SkillDataMediator"
    _G.g_CSkillDataMediator = CSkillDataMediator( _G.g_SkillDataProxy )
    controller :registerMediator( _G.g_CSkillDataMediator )

    --{功能开放缓存}
    require "proxy/FunctionOpenProxy"
    require "mediator/FunctionOpenMediator"
    _G.pCFunctionOpenMediator = CFunctionOpenMediator( _G.pCFunctionOpenProxy )
    controller :registerMediator( _G.pCFunctionOpenMediator)

    --{好友缓存}
    require "proxy/FriendDataProxy"
    require "mediator/FriendDataMediator"
    _G.pCFriendDataMediator = CFriendDataMediator( _G.pCFriendDataProxy )
    controller :registerMediator( _G.pCFriendDataMediator )

    --{日常任务缓存}
    require "proxy/DailyTaskProxy"
    require "mediator/DailyProxyMediator"
    _G.pCDailyProxyMediator = CDailyProxyMediator( _G.pCDailyTaskProxy )
    controller :registerMediator( _G.pCDailyProxyMediator)

    --{错误信息提示框}
    require "mediator/ErrorBoxShopMediator"
    _G.g_CErrorBoxShopMediator = CErrorBoxShopMediator ()
    controller : registerMediator(  _G.g_CErrorBoxShopMediator )


    require "model/GameDataProxy"
    require "mediator/GameDataMediator"
    --注册背包缓存mediator
    _G.pCGameDataMediator = CGameDataMediator( _G.g_GameDataProxy )
    controller :registerMediator( _G.pCGameDataMediator )

    --系统设置
    require "proxy/SystemSettingProxy"
    require "mediator/SystemSettingMediator"
    _G.pCSystemSettingMediator = CSystemSettingMediator( _G.pCSystemSettingProxy)
    controller :registerMediator( _G.pCSystemSettingMediator)

    --聊天数据
    require "proxy/ChatDataProxy"
    require "mediator/ChatDataMediator"
    _G.pChatDataMediator = CChatDataMediator( _G.g_ChatDataProxy )
    controller:registerMediator(_G.pChatDataMediator)

    --新手指引
    require "mediator/GuideMediator"
    _G.pCGuideMediator = CGuideMediator ()
    controller : registerMediator(  _G.pCGuideMediator )
    ---------打印
    if _G.controller.mediators ~= nil then
        for key, value in pairs( _G.controller.mediators ) do
            print( "_G.controller.mediators1111", key, value )
        end
    end

    require "mediator/LogsMediator"
    require "view/Logs/Logs"
    _G.g_Logs = CLogs()
    _G.pLogsMediator = CLogsMediator( _G.g_Logs )
    _G.controller :registerMediator( _G.pLogsMediator )

    --跑马灯
    require "mediator/MarqueeMediator"
    require "view/Marquee/Marquee"
    _G.g_Marquee = CMarquee()
    _G.pMarqueeMediator = CMarqueeMediator( _G.g_Marquee)
    _G.controller :registerMediator( _G.pMarqueeMediator)

    require "mediator/WaitMediator"
    _G.g_WaitMediator = CWaitMediator()
    _G.controller :registerMediator( _G.g_WaitMediator )

    require "mediator/PayCheckMediator"
    _G.g_CPayCheckMediator = CPayCheckMediator( _G.g_CPayCheckProxy )
    _G.controller :registerMediator( _G.g_CPayCheckMediator )

end

local function main()
    require "common/Configuration"
    --require "mediator/ErrorBoxShopMediator"
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 200)
    -- collectgarbage("stop")


    _G.LoginConstant = {
        CID = LUA_CID(),
        KEY = LUA_KEY(),
    }

    require "common/Network"
    require "common/ServerTime"
    require "common/WordFilter"

    require "mediator/SelectRoleMediator"
    require "view/CreateRoleScene/SelectServerScene"

    require "common/unLoadIconSources"

    require "view/Guide/FunOpenManager"

    g_initializeMediators()

    _G.pSelectServerView = CSelectServerScene()
    print("_G.pSelectServerView_G.pSelectServerView" )
    local _startupScene = _G.pSelectServerView :scene()
    CCDirector :sharedDirector():replaceScene( _startupScene )
    _G.pSelectServerView :getServerList()


    local function tempShow(  )
        _G.pDateTime : reset()
        local nowTime = _G.pDateTime : getTotalMilliseconds()
        if _G.g_Logs ~= nil then
            _G.g_Logs : show( nowTime )
        end
    end

    CCDirector :sharedDirector() :getScheduler() :scheduleScriptFunc( tempShow, 0, false )
end
xpcall(main, __G__TRACKBACK__)