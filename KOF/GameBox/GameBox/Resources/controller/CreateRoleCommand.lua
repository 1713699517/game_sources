require "controller/command"

CCreateRole_AskRandomNameCommand = class(command,function(self, VO_data)
	self.type = "TYPE_CCreateRole_AskRandomNameCommand"
	self.data = VO_data
end)

CCreateRole_AskRandomNameCommand.TYPE = "TYPE_CCreateRole_AskRandomNameCommand"

CCreateRole_LoginCommand = class(command,function(self, VO_data)
    self.type = "TYPE_CCreateRole_LoginCommand"
    self.data = VO_data
end)

CCreateRole_LoginCommand.TYPE = "TYPE_CCreateRole_LoginCommand"

CCreateRoleCommand = class(command,function(self, VO_data)
	self.type = "TYPE_CCreateRoleCommand"
	self.data = VO_data
end)

