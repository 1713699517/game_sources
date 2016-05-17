require "mediator/mediator"
require "common/MessageProtocol"
require "controller/ChatCommand"
require "proxy/ChatDataProxy"

CChatMediator = class(mediator, function(self, _view)
	self.name = "CChatMediator"
	self.view = _view
end)

function CChatMediator.getView(self)
	return self.view
end

function CChatMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol.ACK_CHAT_OFFICE_PLAYER then
			self:getView():onReceiverOffline( CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Offline") )
			return true
		end

		--jun  2013.10.10
		if msgID == _G.Protocol["ACK_TEAM_LIVE_REP"] then  -- (手动) -- [3730]查询队伍返回 -- 组队系统
			self : ACK_TEAM_LIVE_REP( ackMsg )
		end
	end

	if _command:getType() == CChatWindowedCommand.TYPE then
		
	end

	if _command:getType() == CChatReceivedCommand.TYPE then
        print("36ReceivedCommReceivedComm", debug.traceback() )
		self:getView():autoArchiveMessage( _command:getData() )
	end

	return false
end

function CChatMediator.ACK_TEAM_LIVE_REP(self,ackMsg)
	local rep        = tonumber(ackMsg : getRep()) --队伍是否存在 0:不存在|1:存在
	local InviteType = tonumber(ackMsg : getInviteType()) ---- {0：招募|1：邀请}
	print("CChatMediator.ACK_TEAM_LIVE_REP 队伍是否存在",rep)
    self : getView() : NetWorkReturn_TEAM_LIVE_REP(rep,InviteType) --sever methond    
end