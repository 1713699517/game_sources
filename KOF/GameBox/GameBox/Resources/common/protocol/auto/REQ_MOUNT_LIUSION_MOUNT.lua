
require "common/RequestMessage"

-- [12140]幻化坐骑 -- 坐骑 

REQ_MOUNT_LIUSION_MOUNT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOUNT_LIUSION_MOUNT
	self:init(0, nil)
end)

function REQ_MOUNT_LIUSION_MOUNT.serialize(self, writer)
	writer:writeInt16Unsigned(self.mount_id)  -- {要幻化的坐骑ID}
end

function REQ_MOUNT_LIUSION_MOUNT.setArguments(self,mount_id)
	self.mount_id = mount_id  -- {要幻化的坐骑ID}
end

-- {要幻化的坐骑ID}
function REQ_MOUNT_LIUSION_MOUNT.setMountId(self, mount_id)
	self.mount_id = mount_id
end
function REQ_MOUNT_LIUSION_MOUNT.getMountId(self)
	return self.mount_id
end
