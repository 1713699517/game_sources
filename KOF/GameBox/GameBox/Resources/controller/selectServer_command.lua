require "controller/command"

selectServer_command = class(command, function(self, _data_model)
    self.type = "selectSever_commandType"
    self.data = _data_model
end)