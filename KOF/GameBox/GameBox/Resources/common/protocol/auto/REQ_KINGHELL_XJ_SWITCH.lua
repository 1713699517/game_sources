
require "common/RequestMessage"

-- [44700]请求心经交换 -- 阎王殿 

REQ_KINGHELL_XJ_SWITCH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_XJ_SWITCH
	self:init(0, nil)
end)

function REQ_KINGHELL_XJ_SWITCH.serialize(self, writer)
	writer:writeInt32Unsigned(self.partnerid1)  -- {交换伙伴id}
	writer:writeInt32Unsigned(self.partnerid2)  -- {被交换伙伴id}
end

function REQ_KINGHELL_XJ_SWITCH.setArguments(self,partnerid1,partnerid2)
	self.partnerid1 = partnerid1  -- {交换伙伴id}
	self.partnerid2 = partnerid2  -- {被交换伙伴id}
end

-- {交换伙伴id}
function REQ_KINGHELL_XJ_SWITCH.setPartnerid1(self, partnerid1)
	self.partnerid1 = partnerid1
end
function REQ_KINGHELL_XJ_SWITCH.getPartnerid1(self)
	return self.partnerid1
end

-- {被交换伙伴id}
function REQ_KINGHELL_XJ_SWITCH.setPartnerid2(self, partnerid2)
	self.partnerid2 = partnerid2
end
function REQ_KINGHELL_XJ_SWITCH.getPartnerid2(self)
	return self.partnerid2
end
