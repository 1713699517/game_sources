require "mediator/mediator"

template_mediator = class(mediator, function(self, _view)
    self.name = "template_mediator"
    self.view = _view
end)

function template_mediator.processCommand(self, _command)
    if _command:getType() == "template_commandType" then
        local cmdDataFormat = tostring(_command:getData():getData1()) .. " = " .. tostring(_command:getData():getData2())
        self:getView():setViewMethodXXX( cmdDataFormat )
        return true
    --elseif
    end
    return false
end