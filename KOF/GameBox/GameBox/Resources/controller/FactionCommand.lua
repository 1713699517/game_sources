require "controller/command"

CFactionLuckCatCommand = class(command, function(self, vo_data)
	self.type = "TYPE_CFactionLuckCatCommand"
	self.data = vo_data
end)

CFactionLuckCatCommand.TYPE = "TYPE_CFactionLuckCatCommand"

