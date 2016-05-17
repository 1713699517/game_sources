
require "common/AcknowledgementMessage"

-- (手动) -- [39070]当前章节信息(new) -- 英雄副本 

ACK_HERO_CHAP_DATA_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_CHAP_DATA_NEW
	self:init()
end)

function ACK_HERO_CHAP_DATA_NEW.deserialize(self, reader)
	self.chap = reader:readInt16Unsigned() -- {当前章节}
	self.next_chap = reader:readInt8Unsigned() -- {下一章节 1：可去 | 0：不可去}
	self.times = reader:readInt16Unsigned() -- {可以进入次数}
	self.buy_times = reader:readInt16Unsigned() -- {已购买次数}
	self.free_times = reader:readInt16Unsigned() -- {剩余购买次数}
	self.count = reader:readInt16Unsigned() -- {战役数量}
	--self.data = reader:readXXXGroup() -- {战役数据信息块(39080)}
    print("普通副本\n当前章节:"..self.chap.."\n下一章节是否可去:"..self.next_chap.."\n战役数量:"..self.count)
    self.data = {}   -- {战役数据信息块(39080)}
    local icount = 1
    while icount <= self.count do
        print("第 "..icount.." 个副本数据:")
        local tempData = ACK_HERO_MSG_BATTLE_NEW()
        tempData :deserialize( reader)
        self.data[icount] = tempData
        icount = icount + 1
    end
end

-- {当前章节}
function ACK_HERO_CHAP_DATA_NEW.getChap(self)
	return self.chap
end

-- {下一章节 1：可去 | 0：不可去}
function ACK_HERO_CHAP_DATA_NEW.getNextChap(self)
	return self.next_chap
end

-- {可以进入次数}
function ACK_HERO_CHAP_DATA_NEW.getTimes(self)
	return self.times
end

-- {已购买次数}
function ACK_HERO_CHAP_DATA_NEW.getBuyTimes(self)
	return self.buy_times
end

-- {剩余购买次数}
function ACK_HERO_CHAP_DATA_NEW.getFreeTimes(self)
	return self.free_times
end

-- {战役数量}
function ACK_HERO_CHAP_DATA_NEW.getCount(self)
	return self.count
end

-- {战役数据信息块(39080)}
function ACK_HERO_CHAP_DATA_NEW.getData(self)
	return self.data
end
