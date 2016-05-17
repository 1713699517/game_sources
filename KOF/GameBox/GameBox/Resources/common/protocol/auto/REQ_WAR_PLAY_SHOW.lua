
require "common/RequestMessage"

-- (手动) -- [6130]请求播放战报 -- 战斗 

REQ_WAR_PLAY_SHOW = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_PLAY_SHOW
	self:init()
end)

function REQ_WAR_PLAY_SHOW.serialize(self, writer)
	writer:writeInt32Unsigned(self.id)  -- {战斗数据展示ID}
end

function REQ_WAR_PLAY_SHOW.setArguments(self,id)
	self.id = id  -- {战斗数据展示ID}
end

-- {战斗数据展示ID}
function REQ_WAR_PLAY_SHOW.setId(self, id)
	self.id = id
end
function REQ_WAR_PLAY_SHOW.getId(self)
	return self.id
end
