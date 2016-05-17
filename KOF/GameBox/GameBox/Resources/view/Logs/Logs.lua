require "view/view"
require "controller/LogsCommand"

CLogs = class(view, function ( self )
    self.m_szStringList = {}
    self.m_isRun = false
    self.winSize = CCDirector      : sharedDirector() :getVisibleSize()
    self.m_lastTime = 0
end)


function CLogs.pushOne( self, _szString, _isColor )
    local _color = "<color:255,255,255,255>"

    --print("_isColor_isColor", _isColor, debug.traceback() )
    if _isColor == _G.Constant.CONST_LOGS_DEL then        --红色
        _color = "<color:255, 0, 0,255>"
    elseif _isColor == _G.Constant.CONST_LOGS_ADD then    --绿色
        _color = "<color:0, 255, 0,255>"
    end

    _szString = _color .. _szString
    table.insert( self.m_szStringList, _szString )
end

function CLogs.show( self, _nowTime )
    -- if _G.g_Stage == nil or _G.g_Stage : isInit() ~= true then
    --     return
    -- end
    if #self.m_szStringList <= 0 then
        self.m_lastTime = _nowTime
        return
    end
    if _nowTime - self.m_lastTime <= 400 then
        return
    end

    local tmpString = self.m_szStringList[1]
    self.m_szStringList[1] = nil
    table.remove(self.m_szStringList,1)
    self : addString( tmpString )
    self.m_lastTime = _nowTime
end

function CLogs.addString( self, _string )
    local lpString = CLabelColor : create(  )
    lpString : appendText(_string, "Marker Felt", 21)
    --_G.g_Stage : addLogs(lpString)
    CCDirector : sharedDirector() : getRunningScene() : addChild( lpString, 10000)
    lpString : setPosition( ccp( self.winSize.width/2, self.winSize.height/2 ) )

    local function onCallBack()
        lpString : removeFromParentAndCleanup(true)
        lpString = nil
    end
    local _callBacks = CCArray:create()
    local num = #self.m_szStringList
    if num <= 0 then
        num = 1
    end
    _callBacks:addObject(CCMoveTo:create( 2 , ccp( self.winSize.width/2, self.winSize.height/2+self.winSize.height/4 ) ))
    _callBacks:addObject(CCCallFunc:create(onCallBack))
    lpString : runAction( CCSequence:create(_callBacks) )
end

