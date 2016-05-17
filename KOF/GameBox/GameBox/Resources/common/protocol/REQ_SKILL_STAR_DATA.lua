
require "common/RequestMessage"

-- (手动) -- [6530]请求星阵图 -- 技能/星阵图 

REQ_SKILL_STAR_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_STAR_DATA
	self:init()
end)
