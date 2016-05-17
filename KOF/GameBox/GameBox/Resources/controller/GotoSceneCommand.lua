require "controller/command"

CGotoSceneCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CGotoSceneCommand"
	self.data = VO_data
end)

CGotoSceneCommand.TYPE = "TYPE_CGotoSceneCommand"

function CGotoSceneCommand.getModel(self)
    return self.data
end

function CGotoSceneCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CGotoSceneCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CGotoSceneCommand.getOtheData(self)
	return self.otherData
end
