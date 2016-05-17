--require "common/MessageProtocol"

CRequestMessage = class(function(self, msgid)
    self.MsgID = msgid
    self:init()
end)

function CRequestMessage.init(self, reactTime, tabReact)
    self.ReactTime = reactTime
    self.ReactProtocol = tabReact
end

function CRequestMessage.serialize(self, writer)

end