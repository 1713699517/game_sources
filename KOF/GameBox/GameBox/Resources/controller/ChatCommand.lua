require "controller/command"

CChatCommand = class(command,function(self, vo_data)

end)

CChatReceivedCommand = class(command, function(self, vo_data)
	self.type = "TYPE_CChatReceivedCommand"
	self.data = vo_data
end)

CChatReceivedCommand.TYPE = "TYPE_CChatReceivedCommand"


CChatWindowedCommand = class(command, function(self, way)
	self.type = "TYPE_CChatWindowedCommand"
	self.data = way
end)

CChatWindowedCommand.TYPE = "TYPE_CChatWindowedCommand"
CChatWindowedCommand.SHOW = "chat_show"
CChatWindowedCommand.HIDE = "chat_hide"
CChatWindowedCommand.OPEN = "chat_open"