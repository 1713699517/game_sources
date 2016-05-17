
require "common/AcknowledgementMessage"

-- [7800]副本完成 -- 副本 

ACK_COPY_OVER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_OVER
	self:init()
end)

function ACK_COPY_OVER.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.copy_type = reader:readInt8Unsigned() -- {副本类型}
	self.hit_score = reader:readInt16Unsigned() -- {无损得分}
	self.time_score = reader:readInt16Unsigned() -- {时间得分}
	self.carom_score = reader:readInt16Unsigned() -- {连击得分}
	self.kill_score = reader:readInt16Unsigned() -- {杀敌得分}
	self.eva = reader:readInt8Unsigned() -- {副本评价}
	self.exp = reader:readInt32Unsigned() -- {经验}
	self.gold = reader:readInt32Unsigned() -- {铜钱}
	self.power = reader:readInt32Unsigned() -- {潜能}
	self.count = reader:readInt16Unsigned() -- {物品数量}
	--self.data = reader:readXXXGroup() -- {物品信息块(7805)}
	self.data = {}
	for i=1,self.count do   -- {物品信息块(7805)}
		local temp_id   = reader:readInt16Unsigned()
		local temp_count = reader:readInt16Unsigned()
		self.data[i] = {goods_id=temp_id, count=temp_count}
	end
end

-- {副本ID}
function ACK_COPY_OVER.getCopyId(self)
	return self.copy_id
end

-- {副本类型}
function ACK_COPY_OVER.getCopyType(self)
	return self.copy_type
end

-- {无损得分}
function ACK_COPY_OVER.getHitScore(self)
	return self.hit_score
end

-- {时间得分}
function ACK_COPY_OVER.getTimeScore(self)
	return self.time_score
end

-- {连击得分}
function ACK_COPY_OVER.getCaromScore(self)
	return self.carom_score
end

-- {杀敌得分}
function ACK_COPY_OVER.getKillScore(self)
	return self.kill_score
end

-- {副本评价}
function ACK_COPY_OVER.getEva(self)
	return self.eva
end

-- {经验}
function ACK_COPY_OVER.getExp(self)
	return self.exp
end

-- {铜钱}
function ACK_COPY_OVER.getGold(self)
	return self.gold
end

-- {潜能}
function ACK_COPY_OVER.getPower(self)
	return self.power
end

-- {物品数量}
function ACK_COPY_OVER.getCount(self)
	return self.count
end

-- {物品信息块(7805)}
function ACK_COPY_OVER.getData(self)
	return self.data
end
