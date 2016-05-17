--*********************************
--2013-8-17 by 陈元杰
--神器商店界面的Mediator-CArtifactShopMediator
--*********************************

require "mediator/mediator"

CArtifactShopMediator = class(mediator, function(self, _view)
	self.name = "CArtifactShopMediator"
	self.view = _view
end)


function CArtifactShopMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_SHOP_REQUEST_OK"] then 
			-- 神器强化 协议返回
			self : ACK_SHOP_REQUEST_OK( ackMsg )

		elseif msgID == _G.Protocol["ACK_SHOP_BUY_SUCC"] then 
			--CCMessageBox( "操作成功!", "提示" )
            local msg = "操作成功!"
            self :getView() :createMessageBox(msg)
            self :getView() :resetGoldNum()
		end
		
	end

	return false
end


-- 神器强化 
function CArtifactShopMediator.ACK_SHOP_REQUEST_OK( self, _ackMsg )

	local count = _ackMsg :getCount()
	if count > 0 then 
		local msg = _ackMsg :getMsg()
		self :getView() :shopDataCallBackForMadiator(  msg )
	else

	end
	
end
