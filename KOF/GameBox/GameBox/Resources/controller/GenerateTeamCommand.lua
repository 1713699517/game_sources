require "controller/command"

CGenerateTeamCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CGenerateTeamCommand"
	self.data = VO_data
end)

CGenerateTeamCommand.TYPE = "TYPE_CGenerateTeamCommand"

function CGenerateTeamCommand.getModel(self)
    return self.data
end

function CGenerateTeamCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CGenerateTeamCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CGenerateTeamCommand.getOtheData(self)
	return self.otherData
end
