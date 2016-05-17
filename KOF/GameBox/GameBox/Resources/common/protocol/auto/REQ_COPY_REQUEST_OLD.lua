
require "common/RequestMessage"

-- [7001]请求副本列表 -- 副本 

REQ_COPY_REQUEST_OLD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_REQUEST_OLD
	self:init(0, nil)
end)

function REQ_COPY_REQUEST_OLD.serialize(self, writer)
	writer:writeInt32Unsigned(self.map_id)  -- {副本地图ID}
end

function REQ_COPY_REQUEST_OLD.setArguments(self,map_id)
	self.map_id = map_id  -- {副本地图ID}
end

-- {副本地图ID}
function REQ_COPY_REQUEST_OLD.setMapId(self, map_id)
	self.map_id = map_id
end
function REQ_COPY_REQUEST_OLD.getMapId(self)
	return self.map_id
end
