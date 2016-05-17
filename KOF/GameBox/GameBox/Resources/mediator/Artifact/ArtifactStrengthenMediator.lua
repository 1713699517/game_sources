--*********************************
--2013-8-17 by 陈元杰
--神器强化界面的Mediator-CArtifactStrengthenMediator
--*********************************

require "mediator/mediator"

CArtifactStrengthenMediator = class(mediator, function(self, _view)
	self.name = "CArtifactStrengthenMediator"
	self.view = _view
end)


function CArtifactStrengthenMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_MAGIC_EQUIP_ENHANCED_REPLY"] then 
			-- 神器强化 协议返回
			self : ACK_MAGIC_EQUIP_ENHANCED_REPLY( ackMsg )

		elseif msgID == _G.Protocol["ACK_MAGIC_EQUIP_NEED_MONEY_REPLY"] then 
			self : ACK_MAGIC_EQUIP_NEED_MONEY_REPLY( ackMsg )

		elseif msgID == _G.Protocol["ACK_MAGIC_EQUIP_ATTR_REPLY"] then
			self : ACK_MAGIC_EQUIP_ATTR_REPLY( ackMsg )

		end
		
	end

	if _command:getType() == CProxyUpdataCommand.TYPE then
        print("CProxyUpdataCommand.TYPE",CProxyUpdataCommand.TYPE)
        self :getView() :refreshPackageData()
    end


	return false
end


-- 神器强化 
function CArtifactStrengthenMediator.ACK_MAGIC_EQUIP_ENHANCED_REPLY( self, _ackMsg )
	self :getView() :strengthenCallBackForMadiator( _ackMsg :getFlag(), _ackMsg :getIdx() )
end

-- 神器强化 
function CArtifactStrengthenMediator.ACK_MAGIC_EQUIP_NEED_MONEY_REPLY( self, _ackMsg )

    local bless_rmb   = tonumber( _ackMsg :getBlessRmb() )
    local protect_rmb = tonumber( _ackMsg :getProtectRmb() )
	local total_rmb   = tonumber(_ackMsg :getTotalRmb())

	self :getView() :oneKeyMenoryCallBackForMadiator( bless_rmb,protect_rmb,total_rmb )
end

function CArtifactStrengthenMediator.ACK_MAGIC_EQUIP_ATTR_REPLY( self, _ackMsg )
	
	self :getView() :showStrengthenInfo( _ackMsg )

end
