
require "common/AcknowledgementMessage"

-- (手动) -- [40020]连续登陆的天数 -- 签到 

ACK_SIGN_DAYS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SIGN_DAYS
	self:init()
end)

function ACK_SIGN_DAYS.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {连续登陆天数}
	self.get_info = {} -- {领取信息块(40030)}
    
    print("ACK_SIGN_DAYS count="..self.count)
    local icount = 1
    while icount<= self.count do
        self.get_info[icount] = {}
        self.get_info[icount].day = reader:readInt16Unsigned()
        self.get_info[icount].is_get = reader:readInt8Unsigned()
        print(icount,self.get_info[icount].day,self.get_info[icount].is_get)
        icount = icount + 1
    end
end

-- {连续登陆天数}
function ACK_SIGN_DAYS.getCount(self)
	return self.count
end

-- {领取信息块(40030)}
function ACK_SIGN_DAYS.getGetInfo(self)
	return self.get_info
end
