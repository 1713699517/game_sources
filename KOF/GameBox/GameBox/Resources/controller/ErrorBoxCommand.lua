require "controller/command"

CErrorBoxCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CErrorBoxCommand"
	self.data = VO_data
end)

CErrorBoxCommand.TYPE = "TYPE_CErrorBoxCommand"

function CErrorBoxCommand.getModel(self)
    return self.data
end

function CErrorBoxCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CErrorBoxCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CErrorBoxCommand.getOtheData(self)
	return self.otherData
end
