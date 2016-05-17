require "controller/command"

PeopleInfoInit_command = class(command, function(self, _data_model)
    self.type = "SetTextRoleProperty_commandType"

    self.data = _data_model
end)
PeopleInfoInit_command.TYPE = "SetTextRoleProperty_commandType"

function PeopleInfoInit_command.getModel(self)
    return self.data
end


PeopleInfoChange_command = class(command, function(self, _data_model)
self.type = "ChangeTextRoleProperty_commandType"

self.data = _data_model
end)

PeopleInfoChange_command.TYPE = "ChangeTextRoleProperty_commandType"

function PeopleInfoChange_command.getModel(self)
    return self.data
end