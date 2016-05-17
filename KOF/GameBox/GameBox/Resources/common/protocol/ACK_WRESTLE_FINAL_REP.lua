
require "common/AcknowledgementMessage"

-- (手动) -- [54940]决赛信息2 -- 格斗之王 

ACK_WRESTLE_FINAL_REP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_FINAL_REP
	self:init()
end)

function ACK_WRESTLE_FINAL_REP.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {上半区0|下半区:1}
	self.turn = reader:readInt16Unsigned() -- {当前轮次}
	self.count = reader:readInt16Unsigned() -- {信息块数量}
	--self.msg = reader:readXXXGroup() -- {54945}
    self.Msg = {}
    local icount = 1
    while icount <= self.count do
        self.Msg[icount] =  {}
        self.Msg[icount].index     = reader:readInt16Unsigned()  -- {位置索引}
        self.Msg[icount].uid       = reader:readInt32Unsigned()  -- {轮次}
        self.Msg[icount].name      = reader:readString()         -- {名字}
        self.Msg[icount].pro       = reader:readInt8Unsigned()   -- {玩家职业}
        self.Msg[icount].power     = reader:readInt32Unsigned()  -- {玩家战斗力}
        self.Msg[icount].is_fail   = reader:readInt8Unsigned()   -- {是否失败过}
        self.Msg[icount].fail_turn = reader:readInt16Unsigned()  -- {失败轮次}
        icount = icount + 1
    end
end

-- {上半区0|下半区:1}
function ACK_WRESTLE_FINAL_REP.getType(self)
	return self.type
end

-- {当前轮次}
function ACK_WRESTLE_FINAL_REP.getTurn(self)
	return self.turn
end

-- {信息块数量}
function ACK_WRESTLE_FINAL_REP.getCount(self)
	return self.count
end

-- {54945}
function ACK_WRESTLE_FINAL_REP.getMsg(self)
	return self.Msg
end
