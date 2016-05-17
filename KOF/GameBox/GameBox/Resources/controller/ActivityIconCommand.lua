require "controller/command"

CActivityIconCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CActivityIconCommand"
	self.data = VO_data
end)

CActivityIconCommand.TYPE   = "TYPE_CActivityIconCommand"
CActivityIconCommand.REMOVE = "activity_remove"
CActivityIconCommand.HIDE   = "activity_hide"
CActivityIconCommand.NOHIDE = "activity_noHide"


function CActivityIconCommand.getData(self)
    return self.data
end

function CActivityIconCommand.setType(self,CommandType)
    self.type = CommandType
end

function CActivityIconCommand.setOtherData(self,_data)
	self.otherData = _data
end

function CActivityIconCommand.getOtheData(self)
	return self.otherData
end
