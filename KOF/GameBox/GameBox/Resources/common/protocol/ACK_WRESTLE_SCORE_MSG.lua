
require "common/AcknowledgementMessage"

-- (手动) -- [54818]积分榜返回 -- 格斗之王 

ACK_WRESTLE_SCORE_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_SCORE_MSG
	self:init()
end)

function ACK_WRESTLE_SCORE_MSG.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {循环变量}
	--self.msg = reader:readXXXGroup() -- {信息块54820}
    self.Msg = {}
    local icount = 1
    while icount <= self.count do
        self.Msg[icount] =  {}
        self.Msg[icount].pos     = reader:readInt8Unsigned()  -- {位置}
        self.Msg[icount].name    = reader:readString()        -- {玩家的名字}
        self.Msg[icount].success = reader:readInt16Unsigned() -- {胜场次}
        self.Msg[icount].fail    = reader:readInt16Unsigned() -- {输场次}
        self.Msg[icount].score   = reader:readInt32Unsigned() -- {玩家积分}
        icount = icount + 1
    end
end

-- {循环变量}
function ACK_WRESTLE_SCORE_MSG.getCount(self)
	return self.count
end

-- {信息块54820}
function ACK_WRESTLE_SCORE_MSG.getMsg(self)
	return self.Msg
end
