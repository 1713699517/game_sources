
require "common/AcknowledgementMessage"

-- [51220]每日一箭返回 -- 每日一箭 

ACK_SHOOT_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOOT_REPLY
	self:init()
end)

function ACK_SHOOT_REPLY.deserialize(self, reader)
    print("ACK_SHOOT_REPLY.deserialize")
    print("-------------------------------")
	self.free_time = reader:readInt16Unsigned() -- {免费次数}
	self.purchase_time = reader:readInt16Unsigned() -- {剩余购买次数}
	self.money = reader:readInt32Unsigned() -- {奖池金额}
    self.name = reader:readString() -- {获奖玩家名字}
    self.last_award = reader:readInt32Unsigned() -- {上一期中大奖信息}
    
    print(self.free_time,self.purchase_time,self.money,self.name,self.last_award)
    
	self.count1 = reader:readInt16Unsigned() -- {头像个数}
	self.head_info = {} -- {头像信息块（51230）}
    local iCount1 = 1
    while iCount1 <= self.count1 do
        self.head_info[iCount1] = {}
        self.head_info[iCount1].position = reader:readInt16Unsigned()
        self.head_info[iCount1].type     = reader:readInt8Unsigned()
        self.head_info[iCount1].award    = reader:readInt16Unsigned()
        print("self.head_info  "..iCount1,self.head_info[iCount1].position,self.head_info[iCount1].type,self.head_info[iCount1].award)
        iCount1 = iCount1 + 1
    end

	self.count2 = reader:readInt16Unsigned() -- {获取其他玩家获奖信息个数}
    self.award_info = {} -- {获取其他玩家获奖信息块（51240）}
    local iCount2 = 1
    print("iCount1="..self.count1.."   iCount2="..self.count2)
	while iCount2 <= self.count2 do
        self.award_info[iCount2] = {}
        self.award_info[iCount2].uname  = reader:readString()
        self.award_info[iCount2].reward = reader:readInt16Unsigned()
        self.award_info[iCount2].count  = reader:readInt16Unsigned()
        print("self.award_info   "..iCount2,self.award_info[iCount2].uname,self.award_info[iCount2].reward,self.award_info[iCount2].count)
        iCount2 = iCount2 + 1
    end
end

-- {免费次数}
function ACK_SHOOT_REPLY.getFreeTime(self)
	return self.free_time
end

-- {剩余购买次数}
function ACK_SHOOT_REPLY.getPurchaseTime(self)
	return self.purchase_time
end

-- {奖池金额}
function ACK_SHOOT_REPLY.getMoney(self)
	return self.money
end

-- {获奖玩家名字}
function ACK_SHOOT_REPLY.getName(self)
	return self.name
end

-- {上一期中大奖信息}
function ACK_SHOOT_REPLY.getAst_award(self)
	return self.last_award
end

-- {头像个数}
function ACK_SHOOT_REPLY.getCount1(self)
	return self.count1
end

-- {头像信息块（51230）}
function ACK_SHOOT_REPLY.getHeadInfo(self)
	return self.head_info
end

-- {获取其他玩家获奖信息个数}
function ACK_SHOOT_REPLY.getCount2(self)
	return self.count2
end

-- {获取其他玩家获奖信息块（51240）}
function ACK_SHOOT_REPLY.getAwardInfo(self)
	return self.award_info
end
