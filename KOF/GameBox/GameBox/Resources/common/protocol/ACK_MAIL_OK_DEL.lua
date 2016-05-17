
require "common/AcknowledgementMessage"

-- [8562]邮件移出 -- 邮件 

ACK_MAIL_OK_DEL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_OK_DEL
	self:init()
end)

function ACK_MAIL_OK_DEL.deserialize(self, reader)
    self.count = reader:readInt16Unsigned()
    --writer:writeInt32Unsigned(self.mailids)
    
    if self.count > 0 then
        self.data = {}
        
        for i=1, self.count do
            self.data[i] = reader:readInt32Unsigned()
        end
    end
end


-- {数量}
function ACK_MAIL_OK_DEL.getCount(self)
	return self.count
end

-- {8563}
function ACK_MAIL_OK_DEL.getData(self)
	return self.data
end
