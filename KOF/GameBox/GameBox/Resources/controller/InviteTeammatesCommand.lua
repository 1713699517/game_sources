require "controller/command"

CInviteTeammatesCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CInviteTeammatesCommand"
	self.data = VO_data
end)

CInviteTeammatesCommand.TYPE = "TYPE_CInviteTeammatesCommand"

function CInviteTeammatesCommand.getModel(self)
    return self.data
end

function CInviteTeammatesCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CInviteTeammatesCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CInviteTeammatesCommand.getOtheData(self)
	return self.otherData
end
