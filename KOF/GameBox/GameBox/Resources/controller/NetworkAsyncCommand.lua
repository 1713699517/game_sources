require "controller/command"



CNetworkAsyncCommand = class(command, function(self, _act, VO_data_model)
    self.type = "TYPE_CNetworkAsyncCommand"     --getType
    self.data = VO_data_model               --getData
    self.act = _act
end)

CNetworkAsyncCommand.TYPE = "TYPE_CNetworkAsyncCommand"
CNetworkAsyncCommand.ACT_WAIT = "TYPE_CNetworkAsyncCommand_ACT_WAIT"
CNetworkAsyncCommand.ACT_CONTINUE = "TYPE_CNetworkAsyncCommand_ACT_CONTINUE"

function CNetworkAsyncCommand.getData(self)
    return self.data
end

function CNetworkAsyncCommand.getAction(self)
	return self.act
end