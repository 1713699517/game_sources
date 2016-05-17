
require "common/RequestMessage"

-- [7795]通知副本完成 -- 副本 

REQ_COPY_NOTICE_OVER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_NOTICE_OVER
	self:init(0, nil)
end)

function REQ_COPY_NOTICE_OVER.serialize(self, writer)
	writer:writeInt16Unsigned(self.hit_times)  -- {被击数}
	writer:writeInt16Unsigned(self.carom_times)  -- {最高连击数}
	writer:writeInt32Unsigned(self.mons_hp)  -- {对怪物伤害(所有怪物杀出的血)}
end

function REQ_COPY_NOTICE_OVER.setArguments(self,hit_times,carom_times,mons_hp)
	self.hit_times = hit_times  -- {被击数}
	self.carom_times = carom_times  -- {最高连击数}
	self.mons_hp = mons_hp  -- {对怪物伤害(所有怪物杀出的血)}
end

-- {被击数}
function REQ_COPY_NOTICE_OVER.setHitTimes(self, hit_times)
	self.hit_times = hit_times
end
function REQ_COPY_NOTICE_OVER.getHitTimes(self)
	return self.hit_times
end

-- {最高连击数}
function REQ_COPY_NOTICE_OVER.setCaromTimes(self, carom_times)
	self.carom_times = carom_times
end
function REQ_COPY_NOTICE_OVER.getCaromTimes(self)
	return self.carom_times
end

-- {对怪物伤害(所有怪物杀出的血)}
function REQ_COPY_NOTICE_OVER.setMonsHp(self, mons_hp)
	self.mons_hp = mons_hp
end
function REQ_COPY_NOTICE_OVER.getMonsHp(self)
	return self.mons_hp
end
