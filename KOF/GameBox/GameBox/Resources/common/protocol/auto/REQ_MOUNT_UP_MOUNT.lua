
require "common/RequestMessage"

-- [12145]坐骑升阶 -- 坐骑 

REQ_MOUNT_UP_MOUNT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_UP_MOUNT
	self:init(0, nil)
end)

function REQ_MOUNT_UP_MOUNT.serialize(self, writer)
	writer:writeInt16Unsigned(self.mount_id)  -- {要升阶的坐骑ID}
end

function REQ_MOUNT_UP_MOUNT.setArguments(self,mount_id)
	self.mount_id = mount_id  -- {要升阶的坐骑ID}
end

-- {要升阶的坐骑ID}
function REQ_MOUNT_UP_MOUNT.setMountId(self, mount_id)
	self.mount_id = mount_id
end
function REQ_MOUNT_UP_MOUNT.getMountId(self)
	return self.mount_id
end
