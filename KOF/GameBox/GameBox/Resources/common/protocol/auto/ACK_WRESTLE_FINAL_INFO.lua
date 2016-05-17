
require "common/AcknowledgementMessage"

-- (手动) -- [54860]决赛信息 -- 格斗之王 

ACK_WRESTLE_FINAL_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_FINAL_INFO
	self:init()
end)

function ACK_WRESTLE_FINAL_INFO.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {循环变量}
	--self.msg = reader:readXXXGroup() -- {54870}
    self.Msg = {}
    local icount = 1
    while icount <= self.count do
        self.Msg[icount] =  {}
        self.Msg[icount].type   = reader:readInt8Unsigned()  -- {0：上半区|1：下半区}
        self.Msg[icount].lunci  = reader:readInt8Unsigned()  -- {轮次}
        self.Msg[icount].uid1   = reader:readInt32Unsigned() -- {一号玩家id}
        self.Msg[icount].name1  = reader:readString()        -- {一号玩家名字}
        self.Msg[icount].uid2   = reader:readInt32Unsigned() -- {二号玩家id}
        self.Msg[icount].name2  = reader:readString()        -- {二号玩家名字}
        self.Msg[icount].uid    = reader:readInt32Unsigned() -- {胜利玩家|0:还未决出胜利}
        icount = icount + 1
    end
end

-- {循环变量}
function ACK_WRESTLE_FINAL_INFO.getCount(self)
	return self.count
end

-- {54870}
function ACK_WRESTLE_FINAL_INFO.getMsg(self)
	return self.Msg
end
