--require "common/MessageProtocol"

CAcknowledgementMessage = class(function(self, msgid)
    self.MsgID = msgid
    self:init()
end)

function CAcknowledgementMessage.init(self)
    
end

function CAcknowledgementMessage.deserialize(self, reader)
    
end



