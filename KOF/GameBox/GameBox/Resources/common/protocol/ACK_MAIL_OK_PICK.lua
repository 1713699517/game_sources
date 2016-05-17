
require "common/AcknowledgementMessage"

-- [8552]提取物品成功 -- 邮件 

ACK_MAIL_OK_PICK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAIL_OK_PICK
	self:init()
    print("[8552]提取物品成功self.MsgID", self.MsgID)
end)

function ACK_MAIL_OK_PICK.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {已提取邮件ID数量}
	--self.id_msg = reader:readXXXGroup() -- {删除邮件信息块 【8563】}
    if self.count > 0 then
        self.id_msg = {}
        
        for i=1, self.count do
            self.id_msg[i] = reader:readInt32Unsigned()
        end
    end
end

-- {已提取邮件ID数量}
function ACK_MAIL_OK_PICK.getCount(self)
	return self.count
end

-- {删除邮件信息块 【8563】}
function ACK_MAIL_OK_PICK.getIdMsg(self)
	return self.id_msg
end
