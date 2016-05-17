
require "common/RequestMessage"

-- [8560]删除邮件 -- 邮件 


REQ_MAIL_DEL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_DEL
	self:init()
end)

function REQ_MAIL_DEL.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)
	--writer:writeXXXGroup(self.mailids)
    
    if self.count > 0 then
        for i=1, self.count do
            writer:writeInt32Unsigned( self.mailids[i])
        end
    end
end

function REQ_MAIL_DEL.setArguments(self,count,mailids)
	self.count = count
	self.mailids = mailids
end

function REQ_MAIL_DEL.setcount(self, value)
	self.count = value
end

function REQ_MAIL_DEL.setmailids(self, value)
	self.mailids = value
end
