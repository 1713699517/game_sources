mediator = class(function(self, _name, _view)
    self.name = _name
    self.view = _view
end)

function mediator.getName(self)
    return self.name
end

function mediator.processCommand(self, _command)
    return false
end

function mediator.getView(self)
    return self.view
end