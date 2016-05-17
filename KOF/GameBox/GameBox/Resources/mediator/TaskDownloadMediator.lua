require "mediator/mediator"
require "common/MessageProtocol"
require "controller/TaskDownloadCommand"

CTaskDownloadMediator = class(mediator, function(self, _view)
	self.name = "CTaskDownloadMediator"
	self.view = _view
end)

function CTaskDownloadMediator.getView(self)
	return self.view
end

function CTaskDownloadMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

	end


	return false
end
