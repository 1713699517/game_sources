
require "common/AcknowledgementMessage"

-- [55820]当前章节信息 -- 拳皇生涯 

ACK_FIGHTERS_CHAP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIGHTERS_CHAP_DATA
	self:init()
end)

function ACK_FIGHTERS_CHAP_DATA.deserialize(self, reader)
	self.chap        = reader:readInt16Unsigned() -- {当前章节}
	self.next_chap   = reader:readInt8Unsigned()  -- {下一章节 1：可去 | 0：不可去}
	self.times       = reader:readInt16Unsigned() -- {剩余挑战次数}
	self.reset_times = reader:readInt16Unsigned() -- {剩余重置次数}
    self.buy_times   = reader:readInt16Unsigned() -- {已购买挑战次数}
    self.alre_times  = reader:readInt16Unsigned() -- {已重置次数}
    self.reis_mon    = reader:readInt8Unsigned()  -- {重置是否免费(1:免费|0:不免费)}
	self.up_is       = reader:readInt8Unsigned()  -- {是否挂机(1:是|0:不是)}
	self.up_chap     = reader:readInt16Unsigned() -- {当前挂机章节}
	self.up_copy     = reader:readInt16Unsigned() -- {当前挂机副本}
	self.count       = reader:readInt16Unsigned() -- {战役数量}
	--self.data = reader:readXXXGroup() -- {战役信息块(55830)}
    local i = 1
    self.chapData = {}
    while i <= self.count do
        self.chapData[i] = {}
        self.chapData[i].copy_id  = reader:readInt16Unsigned() -- {可以挑战的副本Id}
        self.chapData[i].is_pass  = reader:readInt8Unsigned()  -- {是否通关过(1：是 0：否)}
        i = i + 1
    end
    
end

-- {当前章节}
function ACK_FIGHTERS_CHAP_DATA.getChap(self)
	return self.chap
end

-- {下一章节 1：可去 | 0：不可去}
function ACK_FIGHTERS_CHAP_DATA.getNextChap(self)
	return self.next_chap
end

-- {剩余挑战次数}
function ACK_FIGHTERS_CHAP_DATA.getTimes(self)
	return self.times
end

-- {剩余重置次数}
function ACK_FIGHTERS_CHAP_DATA.getResetTimes(self)
	return self.reset_times
end

-- {已购买挑战次数}
function ACK_FIGHTERS_CHAP_DATA.getBuyTimes(self)
	return self.buy_times
end

-- {已重置次数}
function ACK_FIGHTERS_CHAP_DATA.getAlre_times(self)
	return self.alre_times
end

-- {重置是否免费(1:免费|0:不免费)}
function ACK_FIGHTERS_CHAP_DATA.getReis_mon(self)
	return self.reis_mon
end

-- {是否挂机(1:是|0:不是)}
function ACK_FIGHTERS_CHAP_DATA.getUpIs(self)
	return self.up_is
end

-- {当前挂机章节}
function ACK_FIGHTERS_CHAP_DATA.getUpChap(self)
	return self.up_chap
end

-- {当前挂机副本}
function ACK_FIGHTERS_CHAP_DATA.getUpCopy(self)
	return self.up_copy
end

-- {战役数量}
function ACK_FIGHTERS_CHAP_DATA.getCount(self)
	return self.count
end

-- {战役信息块(55830)}
function ACK_FIGHTERS_CHAP_DATA.getData(self)
	return self.chapData
end
