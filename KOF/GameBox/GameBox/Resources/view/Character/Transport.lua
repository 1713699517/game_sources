require "view/Character/Npc"

CTransport = class(CNpc, function( self, _nType )
   if( _nType == nil ) then
       error( "CNpc _nType == nil" )
       return
   end
   self.m_nType = _nType --人物／npc/传送门
end)

--初始化
function CTransport.transportInit(self, _xmlData,_x,_y )
    self.m_nID = tonumber( _xmlData:getAttribute("door_id") )
    self.m_doorType = tonumber( _xmlData:getAttribute("type") )
    self.m_transferID = tonumber( _xmlData:getAttribute("transfer_id") )
    self.m_nRoleEnterRadius = tonumber( _xmlData:getAttribute("door_radius") )
    --print("self.m_nRoleEnterRadius",self.m_nRoleEnterRadius)

    self.m_bRoleEnter = true --玩家是否进入

    self : init(self.m_nID,
                nil,
                nil,
                nil,
                nil,
                nil,
                tonumber(_x),
                tonumber(_y),
                tonumber( _xmlData:getAttribute("material_id") ) )

    local function clickTransportFun ( eventType, arg0, arg1, arg2, arg3 )
        --eventType, obj, x, y
        self : animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        return self : onclickTransportFun( eventType, arg0, arg1, arg2)
    end
    print("加点击传送门事件", self.m_lpMovieClip, _G.g_isEnterTransport)
    --增加点击传送门事件
    if self.m_lpMovieClip then
        self.m_lpMovieClip : setTouchesPriority( -28 )
        self.m_lpMovieClip : setTouchesEnabled( true )
        self.m_lpMovieClip : registerControlScriptHandler ( clickTransportFun, "this CTransport self.m_lpMovieClip 39" )
    end
end

_G.g_isEnterTransport = false
--传送门点击事件
function CTransport.onclickTransportFun( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        print( "CTransport.onclickTransportFun21", _G.g_isEnterTransport)
         _G.g_isEnterTransport     = true
    elseif eventType == "Enter" then
        local status = self : getStatus()
        self.m_nStatus = -100
        self : setStatus( status )

    end
end



function CTransport.onRoleEnter( self, _fRoleX, _fRoleY )
    --玩家进入范围
    if self.m_bRoleEnter == true then
        return
    end
    local distance = ccpDistance( ccp( self:getLocationXY() ), ccp( _fRoleX, _fRoleY ) )
    if distance > self.m_nRoleEnterRadius then
        return
    end
    self.m_bRoleEnter = true

    if self.m_doorType == _G.Constant.CONST_MAP_DOOR_MAP then --主城 发送服务器.由服务器下发
        if _G.g_isGotoScene == true then
            local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_FLY"])
            tempCommand : setOtherData({mapID = self.m_transferID})
            _G.controller: sendCommand(tempCommand)
            _G.g_isGotoScene = false
        end
    elseif self.m_doorType == _G.Constant.CONST_MAP_DOOR_OPEN then -- 打开界面
        require "view/DuplicateLayer/DuplicateSelectPanelView"
        if self.m_transferID == _G.Constant.CONST_MAP_OPEN_COM_COPY then --副本界面
            local tempview = CDuplicateSelectPanelView()
            CCDirector :sharedDirector() :pushScene( tempview :scene())
        end
    elseif self.m_doorType == _G.Constant.CONST_MAP_DOOR_NEXT_COPY then --进入下层副本
        local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER"])
        tempCommand : setOtherData({mapID = 1})
        _G.controller: sendCommand(tempCommand)
    end

end


function CTransport.onRoleExit( self, _fRoleX, _fRoleY )
    --玩家离开范围
    _G.g_isEnterTransport = false
    if self.m_bRoleEnter == false then
        return
    end
    local distance = ccpDistance ( ccp( self:getLocationXY() ), ccp( _fRoleX, _fRoleY ) )
    if distance <= self.m_nRoleEnterRadius then
        return
    end
    self.m_bRoleEnter = false


end
