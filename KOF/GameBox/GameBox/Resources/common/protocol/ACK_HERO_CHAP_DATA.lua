
require "common/AcknowledgementMessage"

-- [39010]当前章节信息 -- 英雄副本 

ACK_HERO_CHAP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_CHAP_DATA
	self:init()
end)

function ACK_HERO_CHAP_DATA.deserialize(self, reader)
	self.chap      = reader:readInt16Unsigned() -- {当前章节}
	self.next_chap = reader:readInt8Unsigned() -- {下一章节 1：可去 | 0：不可去}
    self.times     = reader:readInt16Unsigned() --{可进入次数}
    self.buy_times = reader:readInt16Unsigned()  --｛以购买次数｝
    self.free_times= reader:readInt16Unsigned() -- {可购买次数}
	self.count     = reader:readInt16Unsigned() -- {战役数量}	
    print("英雄副本\n当前章节:"..self.chap.."\n下一章节是否可去:"..self.next_chap.."\n可进入次数:"..self.times.."\n战役数量:"..self.count)
    print("buy_times/free_times :",self.buy_times,"/",self.free_times)
	--self.battle_data = reader:readXXXGroup() -- {战役数据信息块(39015)}
    self.battle_data = {}   -- {战役数据信息块(39015)}
    local icount = 1
    while icount <= self.count do
        self.battle_data[icount] = {}
        self.battle_data[icount].copy_id       = reader: readInt16Unsigned()
        self.battle_data[icount].is_pass       = reader: readInt8Unsigned()
        print("FFFFFFFFFFFF副本ID：",self.battle_data[icount].copy_id,"\nFFFFFFFFFFFFIs_pass:",self.battle_data[icount].is_pass)
        icount = icount+1
    end
end

-- {当前章节}
function ACK_HERO_CHAP_DATA.getChap(self)
	return self.chap
end

-- {下一章节 1：可去 | 0：不可去}
function ACK_HERO_CHAP_DATA.getNextChap(self)
	return self.next_chap
end

-- {buy次数}
function ACK_HERO_CHAP_DATA.getBuyTimes(self)
	return self.buy_times
end
-- {free次数}
function ACK_HERO_CHAP_DATA.getFreeTimes(self)
	return self.free_times
end

-- {可进入次数}
function ACK_HERO_CHAP_DATA.getTimes(self)
	return self.times
end

-- {战役数量}
function ACK_HERO_CHAP_DATA.getCount(self)
	return self.count
end

-- {战役数据信息块(39015)}
function ACK_HERO_CHAP_DATA.getBattleData(self)
	return self.battle_data
end
