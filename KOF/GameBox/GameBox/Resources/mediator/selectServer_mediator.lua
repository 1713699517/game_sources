require "mediator/mediator"

selectServer_mediator = class(mediator, function(self, _view)
    self.name = "selectSever_mediator"
    self.view = _view
    CCLOG("selectSever_mediator")
end)

function selectSever_mediator.processCommand(self, _command)
    if _command:getType() == "selectSever_commandType" then
    local cmdDataFormat = tostring(_command:getData():getData1()) .. " = " .. tostring(_command:getData():getData2())

    self:getView():setViewMethodXXX( cmdDataFormat )
    return true
--elseif
    end
    return false
end