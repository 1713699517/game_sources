
require "common/AcknowledgementMessage"

-- [21120]进入场景 -- 活动-保卫经书 

ACK_DEFEND_BOOK_INTER_SCENE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_INTER_SCENE
	self:init()
end)

function ACK_DEFEND_BOOK_INTER_SCENE.deserialize(self, reader)
	self.start_time = reader:readInt32Unsigned() -- {开始时间}
	self.end_time = reader:readInt32Unsigned() -- {结束时间}
	self.map_id = reader:readInt16Unsigned() -- {地图ID}
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.sid = reader:readInt8Unsigned() -- {服务器ID}
	self.entertype = reader:readInt8Unsigned() -- {类型 1:普通 2:副本 3:瞬移 4:校正}
end

-- {开始时间}
function ACK_DEFEND_BOOK_INTER_SCENE.getStartTime(self)
	return self.start_time
end

-- {结束时间}
function ACK_DEFEND_BOOK_INTER_SCENE.getEndTime(self)
	return self.end_time
end

-- {地图ID}
function ACK_DEFEND_BOOK_INTER_SCENE.getMapId(self)
	return self.map_id
end

-- {玩家Uid}
function ACK_DEFEND_BOOK_INTER_SCENE.getUid(self)
	return self.uid
end

-- {服务器ID}
function ACK_DEFEND_BOOK_INTER_SCENE.getSid(self)
	return self.sid
end

-- {类型 1:普通 2:副本 3:瞬移 4:校正}
function ACK_DEFEND_BOOK_INTER_SCENE.getEntertype(self)
	return self.entertype
end
