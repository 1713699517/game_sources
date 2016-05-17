--*********************************
--2013-8-5 by 陈元杰
--每日签到(登陆礼包)界面的Mediator-CSignInMediator
--*********************************

require "mediator/mediator"

CSignInMediator = class(mediator, function(self, _view)
	self.name = "CSignInMediator"
	self.view = _view
end)

function CSignInMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()
		if msgID == _G.Protocol["ACK_SIGN_GET_REWARDS_OK"] then
			
			self :ACK_SIGN_GET_REWARDS_OK( ackMsg )
		elseif msgID == _G.Protocol["ACK_SIGN_DAYS"] then
			self :ACK_SIGN_DAYS( ackMsg )
		end
		
	end
	return false
end


function CSignInMediator.ACK_SIGN_GET_REWARDS_OK( self , _ackMag )
	--local whichDay = tonumber(_ackMag :getDay())
	self : getView() : getRewardCallBackForMediator( )
end

function CSignInMediator.ACK_SIGN_DAYS( self , _ackMag )
	local get_info = _ackMag :getGetInfo()
	self : getView() : requestViewCallBackForMediator( get_info )
end