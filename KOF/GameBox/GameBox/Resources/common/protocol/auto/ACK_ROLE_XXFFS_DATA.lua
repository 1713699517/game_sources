
require "common/AcknowledgementMessage"

-- [1365]buffs数据 -- 角色 

ACK_ROLE_XXFFS_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_XXFFS_DATA
	self:init()
end)

function ACK_ROLE_XXFFS_DATA.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {buff的id，详见CONST_BUFF_*}
	self.add_gold = reader:readInt16Unsigned() -- {buff铜钱加成}
	self.add_exp = reader:readInt16Unsigned() -- {buff经验加成}
end

-- {buff的id，详见CONST_BUFF_*}
function ACK_ROLE_XXFFS_DATA.getId(self)
	return self.id
end

-- {buff铜钱加成}
function ACK_ROLE_XXFFS_DATA.getAddGold(self)
	return self.add_gold
end

-- {buff经验加成}
function ACK_ROLE_XXFFS_DATA.getAddExp(self)
	return self.add_exp
end
