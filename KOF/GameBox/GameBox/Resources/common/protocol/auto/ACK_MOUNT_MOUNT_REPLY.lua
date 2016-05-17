
require "common/AcknowledgementMessage"

-- [12135]坐骑系统请求返回 -- 坐骑 

ACK_MOUNT_MOUNT_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MOUNT_MOUNT_REPLY
	self:init()
end)

function ACK_MOUNT_MOUNT_REPLY.deserialize(self, reader)
	self.mount_id = reader:readInt16Unsigned() -- {坐骑ID}
	self.strong_att = reader:readInt32Unsigned() -- {物理攻击}
	self.strong_def = reader:readInt32Unsigned() -- {物理防御}
	self.magic_att = reader:readInt32Unsigned() -- {法术攻击}
	self.magic_def = reader:readInt32Unsigned() -- {法术防御}
	self.nowspeed = reader:readInt16Unsigned() -- {速度}
	self.nowhp = reader:readInt32Unsigned() -- {气血}
	self.nowstate = reader:readInt8Unsigned() -- {当前状态(0：下骑 1：上骑)}
	self.nowlv = reader:readInt16Unsigned() -- {坐骑当前等级}
	self.nowexp = reader:readInt32Unsigned() -- {坐骑当前经验}
	self.usemount_id = reader:readInt16Unsigned() -- {当前使用的坐骑ID}
	self.senior = reader:readInt8Unsigned() -- {是否可高级培养(1：可以|0：不可以)}
end

-- {坐骑ID}
function ACK_MOUNT_MOUNT_REPLY.getMountId(self)
	return self.mount_id
end

-- {物理攻击}
function ACK_MOUNT_MOUNT_REPLY.getStrongAtt(self)
	return self.strong_att
end

-- {物理防御}
function ACK_MOUNT_MOUNT_REPLY.getStrongDef(self)
	return self.strong_def
end

-- {法术攻击}
function ACK_MOUNT_MOUNT_REPLY.getMagicAtt(self)
	return self.magic_att
end

-- {法术防御}
function ACK_MOUNT_MOUNT_REPLY.getMagicDef(self)
	return self.magic_def
end

-- {速度}
function ACK_MOUNT_MOUNT_REPLY.getNowspeed(self)
	return self.nowspeed
end

-- {气血}
function ACK_MOUNT_MOUNT_REPLY.getNowhp(self)
	return self.nowhp
end

-- {当前状态(0：下骑 1：上骑)}
function ACK_MOUNT_MOUNT_REPLY.getNowstate(self)
	return self.nowstate
end

-- {坐骑当前等级}
function ACK_MOUNT_MOUNT_REPLY.getNowlv(self)
	return self.nowlv
end

-- {坐骑当前经验}
function ACK_MOUNT_MOUNT_REPLY.getNowexp(self)
	return self.nowexp
end

-- {当前使用的坐骑ID}
function ACK_MOUNT_MOUNT_REPLY.getUsemountId(self)
	return self.usemount_id
end

-- {是否可高级培养(1：可以|0：不可以)}
function ACK_MOUNT_MOUNT_REPLY.getSenior(self)
	return self.senior
end
