require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
--require "common/protocol/ACK_ROLE_SYS_ID"
require "controller/FunctionOpenCommand"

CSystemMenuMediator = class( mediator, function( self, _view )
	self.m_name = "CSystemMenuMediator"
	self.m_view = _view

	print("CSystemMenuMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CSystemMenuMediator.getView( self )
	-- body
	return self.m_view
end


function CSystemMenuMediator.getName( self )
	return self.m_name
end


function CSystemMenuMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        --CCLOG("CSystemMenuMediator.processCommand")
        if msgID == _G.Protocol.ACK_ROLE_SYS_ID then
            --self :ACK_ROLE_SYS_ID( ackMsg)
        end
	end
    
    if _command:getType() == CGotoSceneCommand.TYPE then
        print("准备跳场景所以要删除所有的ccbi")
        self :getView() : removeAllIconCCBI()     
    end
    
    --如果在城镇中
    if CFunctionOpenCommand.TYPE == _command :getType() then
        print("open system")
        if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
            --_G.pmainView : setMenuStatus( true )
            print("open system success")
        end
    end
end

--[[
function CSystemMenuMediator.ACK_ROLE_SYS_ID( self, _ackMsg)
    print("ACK_ROLE_SYS_ID===", _ackMsg :getCount())
    local nCount = _ackMsg :getCount()
    
    if nCount > 0 then
        local _sys_id_list = _ackMsg :getSysId()
        
        print("_sys_id_list===", _sys_id_list)
        if _sys_id_list~= nil then
            print("_sys_id_list", #_sys_id_list)
            self :getView() :setInitView( _sys_id_list, nCount)
        else
            --CCMessageBox( "_sys_id_list为空,怎摸回事", _sys_id_list)
            CCLOG("codeError!!!! _sys_id_list为空,怎摸回事".._sys_id_list)
        end
    end
end
--]]


