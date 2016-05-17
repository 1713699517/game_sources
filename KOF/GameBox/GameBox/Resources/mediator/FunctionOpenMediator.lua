--功能开放缓存的mediator

require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "common/protocol/ACK_ROLE_SYS_ID_2"
require "controller/FunctionOpenCommand"

CFunctionOpenMediator = class( mediator, function( self, _view )
	self.m_name = "CFunctionOpenMediator"
	self.m_view = _view

	print("CFunctionOpenMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CFunctionOpenMediator.getView( self )
	-- body
	return self.m_view
end


function CFunctionOpenMediator.getName( self )
	return self.m_name
end


function CFunctionOpenMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        --功能开放 1271
        if msgID == _G.Protocol.ACK_ROLE_SYS_ID_2 then
            self :ACK_ROLE_SYS_ID_2( ackMsg)
        end
        
        if msgID == _G.Protocol.ACK_ROLE_BUFF then
            self :ACK_ROLE_BUFF( ackMsg )
        end
	end

    
end

function CFunctionOpenMediator.ACK_ROLE_BUFF( self, _ackMsg )
    print( "收到1370-->", _ackMsg :getId(), _ackMsg :getState() )
    self :getView() :setInited( true )
    local _data = {}
    _data.id      = _ackMsg :getId()
    _data.state   = _ackMsg :getState()
    self :getView() :setRoleBuff( _data )
    
    local buffCommand = CFunctionUpdateCommand( CFunctionUpdateCommand.BUFF_TYPE )
    controller :sendCommand( buffCommand )
end

function CFunctionOpenMediator.ACK_ROLE_SYS_ID_2( self, _ackMsg)
    print("ACK_ROLE_SYS_ID_2===", _ackMsg :getCount())
    local nCount = _ackMsg :getCount()
    local nCompareCount = self :getView() :getCount()
    
    if nCompareCount ~= nil and nCount <= nCompareCount and self :getView() :getInited() then
        print("和以前一样，不变", nCount)
        return
    end
    
    if nCount ~= nil and nCount > 0 then
        
        local newSysList = _ackMsg :getSysId()
        if self:getView():getInited() then
            
            local ollSysList = self:getView():getSysId()
            
            for i,v in ipairs(newSysList) do
                local newSysId = tonumber(v.id)
                local isHas    = false
                for ii,vv in ipairs(ollSysList) do
                    local ollSysId = tonumber( vv.id )
                    if newSysId == ollSysId then
                        isHas = true
                        break
                    end
                end
                if isHas == false then
                    --CCMessageBox("新功能开放?","id->"..newSysId)
                    _G.g_CFunOpenManager:showFunOpenView( newSysId )
                    break
                end
            end
            
        end
        
        self :getView() :setInited( true)
        self :getView() :setIsVisible( 1)
        self :getView() :setSysId( _ackMsg :getSysId())
        self :getView() :setCount( nCount)
        
        print("_sys_id_list===", _ackMsg :getSysId(), _G.g_Stage, _G.g_Stage :getScenesType())
        
        --getScenesType()  如果玩家在城镇 就直接打开
        if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
            --local openCommand = CFunctionOpenCommand( CFunctionOpenCommand.TYPE)
            --controller :sendCommand( openCommand)
        end
        local command = CFunctionOpenCommand( CFunctionOpenCommand.UPDATE)
        controller :sendCommand( command)
        print("在城镇中，更新吧，小宇宙")
    end
end