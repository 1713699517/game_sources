
require "common/AcknowledgementMessage"

-- [46220]当前章节信息 -- 魔王副本 

ACK_FIEND_CHAP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FIEND_CHAP_DATA
	self:init()
end)

function ACK_FIEND_CHAP_DATA.deserialize(self, reader)
	self.chap = reader:readInt16Unsigned() -- {当前章节}
	self.next_chap = reader:readInt8Unsigned() -- {下一章节 1：可去 | 0：不可去}
	self.times = reader:readInt16Unsigned() -- {可刷新次数}
	self.count = reader:readInt16Unsigned() -- {战役数量}
	
    print("魔王副本\n当前章节:"..self.chap.."\n下一章节是否可去:"..self.next_chap.."\n可刷新次数:"..self.times.."\n战役数量:"..self.count)
	--self.data = reader:readInt16Unsigned() -- {战役数据信息块(46230)}
    self.data = {}   -- {战役数据信息块(39015)}
    local icount = 1
    while icount <= self.count do
        self.data[icount] = {}
        self.data[icount].copy_id       = reader: readInt16Unsigned()
        self.data[icount].times         = reader: readInt16Unsigned() --可以进入次数
        self.data[icount].is_pass       = reader: readInt8Unsigned()
        print("FFFFFFFFFFFFF副本ID：",self.data[icount].copy_id,"\nFFFFFFFFF可以进入次数",self.data[icount].times,"\nFFFFFFFFFFFFIs_pass:",self.data[icount].is_pass)
        icount = icount+1
    end
end

-- {当前章节}
function ACK_FIEND_CHAP_DATA.getChap(self)
	return self.chap
end

-- {下一章节 1：可去 | 0：不可去}
function ACK_FIEND_CHAP_DATA.getNextChap(self)
	return self.next_chap
end

-- {可刷新次数}
function ACK_FIEND_CHAP_DATA.getTimes(self)
	return self.times
end

-- {战役数量}
function ACK_FIEND_CHAP_DATA.getCount(self)
	return self.count
end

-- {战役数据信息块(46230)}
function ACK_FIEND_CHAP_DATA.getData(self)
	return self.data
end
