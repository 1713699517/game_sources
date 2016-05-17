require "controller/command"

CBuildTeamCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CBuildTeamCommand"
	self.data = VO_data
end)

CBuildTeamCommand.TYPE = "TYPE_CBuildTeamCommand"

function CBuildTeamCommand.getdata(self)
    return self.data
end

function CBuildTeamCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CBuildTeamCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CBuildTeamCommand.getOtheData(self)
	return self.otherData
end
