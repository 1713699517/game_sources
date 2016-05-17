require "view/view"
require "view/Stage/PKReceiveView"

CPKFlashView = class(view, function( self )
    self : loadResources()
    self.winSize = CCDirector : sharedDirector() : getVisibleSize()
end)


CPKFlashView.TAG_SHOW = 10

function CPKFlashView.loadResources( self )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "General.plist" )
end

function CPKFlashView.getShowView( self )
    self : initView()
    self : initlayout()
    return self.m_lpShowBtn
end

function CPKFlashView.initView( self )
    self.m_lpShowBtn = CButton :createWithSpriteFrameName("被邀请切磋", "general_button_normal.png")

    self.m_lpShowBtn : setControlName( "this is CPKFlashView, m_lpShowBtn, 24" )
    self.m_lpShowBtn : setTag( self.TAG_SHOW )

    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    self.m_lpShowBtn : registerControlScriptHandler( CellCallBack, "this CPKFlashView self.m_lpShowBtn 36")

end

function CPKFlashView.initlayout( self )
    self.m_lpShowBtn : setPosition( self.winSize.width / 2, self.winSize.height / 4 )
end

function CPKFlashView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.TAG_SHOW then
                self : clickShow()
            end
            return true
        end
    end
end

function CPKFlashView.clickShow( self )
    if _G.g_pkReceiveManager : isEmpty() == true then
        self.m_lpShowBtn : removeFromParentAndCleanup( true )
        return
    end
    local receive = _G.g_pkReceiveManager : getTop()
    if  receive == nil then
        return
    end

    local receiveView = CPKReceiveView( receive : getUid(), receive : getName(), receive : getTime() )
    local container = _G.g_Stage : getPKReceiveContainer()
    container : addChild( receiveView : getShowView() )
    _G.g_pkReceiveManager : removeByUid( receive : getUid() )
end
























CPKReceive = class( function( self,_uid, _name, _time )
    self.m_nUid = _uid
    self.m_szName = _name
    self.m_nTime = _time
end)

function CPKReceive.isTimeOut( self )
    local now = _G.g_ServerTime : getServerTimeSeconds()
    return now > self.m_nTime
end
function CPKReceive.getName( self )
    return self.m_szName
end
function CPKReceive.getTime( self )
    return self.m_nTime
end
function CPKReceive.getUid( self )
    return self.m_nUid
end
function CPKReceive.setTime( self, _time )
    self.m_nTime = _time
end


CPKReceiveManager = class( function( self )
    self.m_lpList = {}
end)

function CPKReceiveManager.addReceive( self, _uid, _name, _time )
    for _,v in pairs(self.m_lpList) do
        if v : getUid() == _uid then
            v : setTime( _time )
            return
        end
    end
    local _receive = CPKReceive( _uid, _name, _time )
    table.insert(self.m_lpList, _receive)
end

function CPKReceiveManager.removeByUid( self, _uid )
    for k,v in pairs(self.m_lpList) do
        if v : getUid() == _uid then
            table.remove(self.m_lpList, k)
            return
        end
    end
end

function CPKReceiveManager.isEmpty( self )
    return #self.m_lpList <= 0
end

function CPKReceiveManager.getTop( self )
    if self : isEmpty() == true then
        return nil
    end
    return self.m_lpList[1]
end

function CPKReceiveManager.update( self )
    for k,v in pairs(self.m_lpList) do
        if v : isTimeOut() == true then
            table.remove(self.m_lpList,k)
            break
        end
    end
    if self : isEmpty() == true then
        _G.g_Stage : removePKFlashContainerChild()
        return
    end

    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_PK) == 0 then
        return
    end

    if _G.g_Stage : getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY then
        return
    end
    local container =  _G.g_Stage : getPKFlashContainer()
    local flashView = container : getChildByTag( CPKFlashView.TAG_SHOW )
    if flashView == nil then
        local tempObject = CPKFlashView()
        local tempView = tempObject : getShowView()
        tempView : setTag( CPKFlashView.TAG_SHOW )
        container : addChild( tempView )
    end
end


_G.g_pkReceiveManager = CPKReceiveManager()



