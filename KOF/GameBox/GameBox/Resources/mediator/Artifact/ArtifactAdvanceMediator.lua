--*********************************
--2013-8-16 by 陈元杰
--神器强化界面的Mediator-CArtifactAdvanceMediator
--*********************************

require "mediator/mediator"

CArtifactAdvanceMediator = class(mediator, function(self, _view)
	self.name = "CArtifactAdvanceMediator"
	self.view = _view
end)


function CArtifactAdvanceMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_MAGIC_EQUIP_ENHANCED_REPLY"] then 
			-- 神器进阶 协议返回
			self : ACK_MAGIC_EQUIP_ENHANCED_REPLY( ackMsg )

		-- elseif msgID == _G.Protocol["ACK_FLSH_REWARD_OK"] then 
		-- 	
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
function CArtifactAdvanceMediator.ACK_MAGIC_EQUIP_ENHANCED_REPLY( self, _ackMsg )

    if _G.g_CArtifactView ~= nil then
        local isSuccess = tonumber(_ackMsg :getFlag())
        if isSuccess == 1 then 
        	print("进阶成功")
            --_G.g_CArtifactView:showSureBox( "进阶成功" )
        else 
            _G.g_CArtifactView:showSureBox( "进阶失败" )
        end

        self :getView() :advanceCallBackForMadiator(  )
    end
end


function CArtifactAdvanceMediator.ACK_MAGIC_EQUIP_ATTR_REPLY( self, _ackMsg )
	
	self :getView() :showAdvanceInfo( _ackMsg )

end