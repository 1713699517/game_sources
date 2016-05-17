
require "common/RequestMessage"

-- [7880]领取章节评价奖励 -- 副本 

REQ_COPY_CHAP_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_CHAP_REWARD
	self:init(0, nil)
end)

function REQ_COPY_CHAP_REWARD.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {副本类型,详见CONST_COPY_TYPE_*}
	writer:writeInt16Unsigned(self.chap_id)  -- {章节ID}
end

function REQ_COPY_CHAP_REWARD.setArguments(self,type,chap_id)
	self.type = type  -- {副本类型,详见CONST_COPY_TYPE_*}
	self.chap_id = chap_id  -- {章节ID}
end

-- {副本类型,详见CONST_COPY_TYPE_*}
function REQ_COPY_CHAP_REWARD.setType(self, type)
	self.type = type
end
function REQ_COPY_CHAP_REWARD.getType(self)
	return self.type
end

-- {章节ID}
function REQ_COPY_CHAP_REWARD.setChapId(self, chap_id)
	self.chap_id = chap_id
end
function REQ_COPY_CHAP_REWARD.getChapId(self)
	return self.chap_id
end
