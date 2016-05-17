require "controller/command"

CSelectRoleInitCommand = class(command,function(self, VO_data)
	self.type = "TYPE_CSelectRoleInitCommand"
	self.data = VO_data
end)

CSelectRoleInitCommand.TYPE = "TYPE_CSelectRoleInitCommand"

CSelectRoleCommand = class(command,function(self, VO_data)
	self.type = "TYPE_CSelectRoleCommand"
	self.data = VO_data
end)

CSelectRole_ChangeSelectedSeverCommand = class(command,function(self, VO_data)
    self.type = "CSelectRole_ChangeSelectedSeverCommand"
    self.data = VO_data
end)

CSelectRole_ChangeSelectedSeverCommand.TYPE = "CSelectRole_ChangeSelectedSeverCommand"

function CSelectRole_ChangeSelectedSeverCommand.getModel(self)
   return self.data
end
