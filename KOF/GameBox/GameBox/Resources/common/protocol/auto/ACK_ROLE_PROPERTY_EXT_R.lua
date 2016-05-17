
require "common/AcknowledgementMessage"

-- [1128]玩家扩展属性(暂无效) -- 角色 

ACK_ROLE_PROPERTY_EXT_R = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_PROPERTY_EXT_R
	self:init()
end)

function ACK_ROLE_PROPERTY_EXT_R.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.renown = reader:readInt32Unsigned() -- {声望}
	self.slaughter = reader:readInt32Unsigned() -- {杀戮值}
	self.honor = reader:readInt32Unsigned() -- {荣誉值}
	self.ext2 = reader:readInt32Unsigned() -- {扩展}
	self.ext3 = reader:readInt32Unsigned() -- {扩展}
	self.ext4 = reader:readInt32Unsigned() -- {扩展}
	self.ext5 = reader:readInt32Unsigned() -- {扩展}
	self.ext6 = reader:readInt32Unsigned() -- {扩展}
	self.ext7 = reader:readInt32Unsigned() -- {扩展}
end

-- {玩家UID}
function ACK_ROLE_PROPERTY_EXT_R.getUid(self)
	return self.uid
end

-- {声望}
function ACK_ROLE_PROPERTY_EXT_R.getRenown(self)
	return self.renown
end

-- {杀戮值}
function ACK_ROLE_PROPERTY_EXT_R.getSlaughter(self)
	return self.slaughter
end

-- {荣誉值}
function ACK_ROLE_PROPERTY_EXT_R.getHonor(self)
	return self.honor
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt2(self)
	return self.ext2
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt3(self)
	return self.ext3
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt4(self)
	return self.ext4
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt5(self)
	return self.ext5
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt6(self)
	return self.ext6
end

-- {扩展}
function ACK_ROLE_PROPERTY_EXT_R.getExt7(self)
	return self.ext7
end
