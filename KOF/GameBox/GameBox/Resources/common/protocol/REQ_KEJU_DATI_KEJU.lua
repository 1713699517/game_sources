
require "common/RequestMessage"

-- [44530]开始答题 -- 御前科举 


REQ_KEJU_DATI_KEJU = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KEJU_DATI_KEJU
	self:init()
end)

function REQ_KEJU_DATI_KEJU.serialize(self, writer)
	writer:writeInt16Unsigned(self.question_id)
	writer:writeInt8Unsigned(self.data)
	writer:writeInt8Unsigned(self.type)
end

function REQ_KEJU_DATI_KEJU.setArguments(self,question_id,data,type)
	self.question_id = question_id
	self.data = data
	self.type = type
end

function REQ_KEJU_DATI_KEJU.getquestionId(self, value)
	return self.question_id
end

function REQ_KEJU_DATI_KEJU.getdata(self, value)
	return self.data
end

function REQ_KEJU_DATI_KEJU.gettype(self, value)
	return self.type
end
