
require "common/AcknowledgementMessage"

-- [48310]拾取成功 -- 斗气系统 

ACK_SYS_DOUQI_OK_GET_DQ = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_GET_DQ
	self:init()
end)

function ACK_SYS_DOUQI_OK_GET_DQ.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.lan_msg = reader:readXXXGroup() -- {栏位ID列表【48295】}
    print("成功拾取:"..self.count.." 个斗气")
    local icount = 1
    self.lan_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个被拾取。")
        local tempData = ACK_SYS_DOUQI_LAN_MSG()
        tempData :deserialize( reader)
        self.lan_msg[icount] = tempData        
        icount = icount + 1
    end
    
end

-- {数量}
function ACK_SYS_DOUQI_OK_GET_DQ.getCount(self)
	return self.count
end

-- {栏位ID列表【48295】}
function ACK_SYS_DOUQI_OK_GET_DQ.getLanMsg(self)
	return self.lan_msg
end
