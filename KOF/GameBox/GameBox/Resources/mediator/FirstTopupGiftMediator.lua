--*********************************
--2013-8-2 by 陈元杰
--首充礼包界面的Mediator-CFirstTopupGiftMediator
--*********************************

require "mediator/mediator"

CFirstTopupGiftMediator = class(mediator, function(self, _view)
	self.name = "CFirstTopupGiftMediator"
	self.view = _view
end)

function CFirstTopupGiftMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_CARD_GET_OK"] then
			--CCMessageBox( "领取成功", "提示" )
            local msg =  "领取成功"
            self : getView() : createMessageBox(msg)
			self : getView() : getRewardCallBackForMediator()
		elseif msgID == _G.Protocol["ACK_CARD_SALES_DATA"] then --  24932	 促销活动状态返回
			self : ACK_CARD_SALES_DATA( ackMsg )
		end
		
	end
	return false
end


function CFirstTopupGiftMediator.ACK_CARD_SALES_DATA(self, ackMsg)   --24932	 促销活动状态返回
	local idData = ackMsg : getIdDate()
	for i,v in ipairs(idData) do
		if v.id ==  _G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID then 
			if v.count > 0 then 
				self :getView() : canGetCallBackForMediator( v.sub_date[1].id_sub )
			end
		end
	end
end