
require "common/AcknowledgementMessage"

-- [48390]移动斗气成功 -- 斗气系统 

ACK_SYS_DOUQI_OK_USE_DOUQI = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_USE_DOUQI
	self:init()
end)

function ACK_SYS_DOUQI_OK_USE_DOUQI.deserialize(self, reader)
	self.role_id     = reader:readInt16Unsigned() -- {伙伴ID | 0 自己}
	self.dq_id       = reader:readInt32Unsigned() -- {斗气唯一ID}
	self.lanid_start = reader:readInt8Unsigned()  -- {起始位置}
	self.lanid_end   = reader:readInt8Unsigned()  -- {目标位置}
	self.count       = reader:readInt16Unsigned() -- {数量}
    print("移动斗气成功:",self.role_id,self.dq_id,self.lanid_start,self.lanid_end)
	--self.dq_msg      = reader:readXXXGroup()      -- {移动后的斗气信息块【48203】}
    print("斗气数量:",self.count)
    local icount = 1
    self.dq_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个斗气:")
        local tempData = ACK_SYS_DOUQI_DOUQI_DATA()
        tempData :deserialize( reader)
        self.dq_msg[icount] = tempData
        icount = icount + 1
    end
end

-- {伙伴ID | 0 自己}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getRoleId(self)
	return self.role_id
end

-- {斗气唯一ID}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getDqId(self)
	return self.dq_id
end

-- {起始位置}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getLanidStart(self)
	return self.lanid_start
end

-- {目标位置}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getLanidEnd(self)
	return self.lanid_end
end

-- {数量}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getCount(self)
	return self.count
end

-- {移动后的斗气信息块【48203】}
function ACK_SYS_DOUQI_OK_USE_DOUQI.getDqMsg(self)
	return self.dq_msg
end
