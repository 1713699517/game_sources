

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

function CCLOG(...)
    --print(string.format(...))
    CCLuaLog(string.format(...))
end

local function main()
    -- avoid memory leak
    -- collectgarbage("setpause", 100)
    -- collectgarbage("setstepmul", 5000)
    collectgarbage("stop")    

    require "view/MainUILayer/MainUIScene"
    require "view/Stage/Stage"
    require "proxy/LoginInfoProxy"
    require "proxy/CharacterPropertyProxy"

    --hello 单机
    _G.pmainView = CMainUIScene()
    _G.g_LoginInfoProxy:setServerId( 1000 )
    _G.g_LoginInfoProxy:setUid( 5201314 )


    _G.g_Stage : addStageMediator()
    _G.pDateTime = CDateTime : create()
    --记录人物数据

    local mainProperty = _G.g_characterProperty : initMainPlay( 5201314 )
    mainProperty : setPro( 1 )
    mainProperty : setSex( 1 )
    mainProperty : setIsRedName( false )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_NAME, "毒枭" )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_ARMOR, 10001 )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_COUNTRY, 1 )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_LV, 80 )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_HP, 1000 )
    mainProperty : setGold( 100 )
    mainProperty : setRmb( 100 )
    mainProperty : setBindRmb( 100 )
    mainProperty : setSum(100)
    mainProperty : setMax( 100 )
    mainProperty : setVipLv( 10 )
    mainProperty : setVipUp( 100 )


    _G.pStageMediator : gotoScene( 10100, 100,200 )
end

xpcall(main, __G__TRACKBACK__)
