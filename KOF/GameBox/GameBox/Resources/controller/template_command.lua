require "controller/command"

template_command = class(command, function(self, _data_model)
    self.type = "template_commandType"
    self.data = _data_model
end)