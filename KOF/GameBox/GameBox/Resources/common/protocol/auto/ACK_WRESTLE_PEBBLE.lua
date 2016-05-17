
require "common/AcknowledgementMessage"

-- [54930]竞技水晶更新 -- 格斗之王 

ACK_WRESTLE_PEBBLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_PEBBLE
	self:init()
end)

function ACK_WRESTLE_PEBBLE.deserialize(self, reader)
	self.pebble = reader:readInt32Unsigned() -- {竞技水晶数量}
end

-- {竞技水晶数量}
function ACK_WRESTLE_PEBBLE.getPebble(self)
	return self.pebble
end
