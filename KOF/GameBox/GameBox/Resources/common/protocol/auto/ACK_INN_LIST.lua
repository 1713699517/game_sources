
require "common/AcknowledgementMessage"

-- (手动) -- [31120]伙伴列表 -- 客栈 

ACK_INN_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_LIST
	self:init()
end)

function ACK_INN_LIST.deserialize(self, reader)
    self.renown = reader:readInt32Unsigned() -- {角色声望}
	self.count = reader:readInt16Unsigned() -- {伙伴数量}
    print( "-- {伙伴数量}:", self.count.."/"..self.renown)
	--self.data = reader:readXXXGroup() -- {信息块（31121）}
    self.data = {}
    for icount=1, self.count do
        self.data[icount] = {}
        self.data[icount].partner_id = reader:readInt16Unsigned() -- {伙伴ID}
        self.data[icount].stata      = reader:readInt8Unsigned() -- {状态（CONST_INN_STATA）}
        self.data[icount].lv         = reader:readInt8Unsigned() -- {伙伴当前等级}
        print( icount,"{伙伴ID}:",self.data[icount].partner_id,"状态:",self.data[icount].stata,"LV:",self.data[icount].lv)
    end
end

-- {伙伴数量}
function ACK_INN_LIST.getCount(self)
	return self.count
end

-- {信息块（31121）}
function ACK_INN_LIST.getData(self)
	return self.data
end

function ACK_INN_LIST.getRenown(self)
    return self.renown
end
