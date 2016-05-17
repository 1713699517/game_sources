require "controller/command"

CFlyItemCommand = class(command,function(self, _itemId)
	self.type = "TYPE_CFlyItemCommand"
	self.data = _itemId
end)

CFlyItemCommand.TYPE = "TYPE_CFlyItemCommand"