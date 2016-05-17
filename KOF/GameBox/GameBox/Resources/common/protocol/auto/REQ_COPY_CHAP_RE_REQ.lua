
require "common/RequestMessage"

-- [7890]查询是否领取章节评价奖励 -- 副本 

REQ_COPY_CHAP_RE_REQ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_CHAP_RE_REQ
	self:init(0.5 ,{ 7900 })
end)

function REQ_COPY_CHAP_RE_REQ.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {副本类型,详见CONST_COPY_TYPE_*}
	writer:writeInt16Unsigned(self.chap_id)  -- {章节ID}
end

function REQ_COPY_CHAP_RE_REQ.setArguments(self,type,chap_id)
	self.type = type  -- {副本类型,详见CONST_COPY_TYPE_*}
	self.chap_id = chap_id  -- {章节ID}
end

-- {副本类型,详见CONST_COPY_TYPE_*}
function REQ_COPY_CHAP_RE_REQ.setType(self, type)
	self.type = type
end
function REQ_COPY_CHAP_RE_REQ.getType(self)
	return self.type
end

-- {章节ID}
function REQ_COPY_CHAP_RE_REQ.setChapId(self, chap_id)
	self.chap_id = chap_id
end
function REQ_COPY_CHAP_RE_REQ.getChapId(self)
	return self.chap_id
end
