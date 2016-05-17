
require "common/RequestMessage"

-- [8550]提取邮件物品 -- 邮件 


REQ_MAIL_PICK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAIL_PICK
	self:init()
end)

function REQ_MAIL_PICK.serialize(self, writer)
	writer:writeInt16Unsigned(self.count)
    --writer:writeInt32Unsigned(self.mailids)
    
    if self.count > 0 then
        for i=1, self.count do
            writer:writeInt32Unsigned(self.mailids[i])
        end
    end
    
	--writer:writeXXXGroup(self.mailids)
end

function REQ_MAIL_PICK.setArguments(self,count,mailids)
	self.count = count
	self.mailids = mailids
end

function REQ_MAIL_PICK.setcount(self, value)
	self.count = value
end


function REQ_MAIL_PICK.setmailids(self, value)
	self.mailids = value
end