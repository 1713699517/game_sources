
require "common/AcknowledgementMessage"

-- [48290]仓库数据 -- 斗气系统 

ACK_SYS_DOUQI_STORAGE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_STORAGE_DATA
	self:init()
end)

function ACK_SYS_DOUQI_STORAGE_DATA.deserialize(self, reader)
	self.type  = reader:readInt8Unsigned()  -- {仓库类型  0领悟仓库| 1装备仓库}
	self.count = reader:readInt16Unsigned() -- {斗气个数}
    local temptype = "(领悟仓库)"
    if self.type == 1 then
        temptype = "(装备仓库)"
    end
    print( "仓库类型: "..self.type..temptype.."斗气个数:"..self.count)
	--self.dq_msg = reader:readXXXGroup() -- {斗气信息块【48203】}
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

-- {仓库类型  0领悟仓库| 1装备仓库}
function ACK_SYS_DOUQI_STORAGE_DATA.getType(self)
	return self.type
end

-- {斗气个数}
function ACK_SYS_DOUQI_STORAGE_DATA.getCount(self)
	return self.count
end

-- {斗气信息块【48203】}
function ACK_SYS_DOUQI_STORAGE_DATA.getDqMsg(self)
	return self.dq_msg
end
