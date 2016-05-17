require "mediator/mediator"

CHangupMediator = class(mediator, function(self, _view)
	self.name = "CHangupMediator"
	self.view = _view
	isFreeTimes = true
end)

function CHangupMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()


		if msgID == _G.Protocol["ACK_COPY_UP_RESULT"] then
			--self:getView():onReceiverOffline()
			self : ACK_COPY_UP_RESULT(ackMsg)
			
			
		elseif msgID == _G.Protocol["ACK_COPY_UP_OVER"] then
			--挂机完成
			self : ACK_COPY_UP_OVER(ackMsg)

		end
	end
	return false
end

function CHangupMediator.ACK_COPY_UP_RESULT(self, _ackMsg)
	print("------wqeqACK_COPY_UP_RESULT" , _ackMsg : getNowtimes())
	local oneTimes = _ackMsg : getNowtimes()
	if oneTimes == 0 then 
		isFreeTimes = false
		--CCMessageBox( "挂机中"..isFreeTimes, "ACK_COPY_UP_RESULT" )
		self.view : autoArchiveMessage()
	else
		self.view : addOneReward( _ackMsg )
	end
end

function CHangupMediator.ACK_COPY_UP_OVER(self, _ackMsg)
	print("ACK_COPY_UP_OVER--->".._ackMsg : getType())
	if _ackMsg : getType() == _G.Constant.CONST_COPY_UPTYPE_BAG_FULL then
		local msg = "背包已满,请先清理"
        self.view : createMessageBox(msg)
		self.view : setHuangUpType( 1 )
	elseif _ackMsg : getType() == _G.Constant.CONST_COPY_UPTYPE_SPEED then
		--加速完成
		--CCMessageBox( "加速成功", "提示" )
        local msg = "加速成功"
        self.view : createMessageBox(msg)
		self.view : autoSpeedMessageCallBack()
	elseif _ackMsg : getType() == _G.Constant.CONST_COPY_UPTYPE_VIP then 
		--CCMessageBox( "挂机完成", "提示" )
        local msg = "挂机完成"
        self.view : createMessageBox(msg)
		-- self.view : autoArchiveMessage(1)
	end
end



