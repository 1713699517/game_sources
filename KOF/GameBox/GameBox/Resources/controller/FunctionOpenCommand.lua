require "controller/command"

CFunctionOpenCommand = class(command, function(self, vo_data)
	self.type = "TYPE_CFunctionOpenCommand"
	self.data = vo_data
end)

CFunctionOpenCommand.TYPE = "TYPE_CFunctionOpenCommand"
CFunctionOpenCommand.UPDATE = "UPDATE_CFunctionOpenCommand"


CFunctionUpdateCommand = class(command, function(self, way)
	self.type = "TYPE_CFunctionUpdateCommand"
	self.data = way
end)

CFunctionUpdateCommand.TYPE = "TYPE_CFunctionUpdateCommand"
CFunctionUpdateCommand.BUFF_TYPE = "BUFF_TYPE_CFunctionUpdateCommand"

