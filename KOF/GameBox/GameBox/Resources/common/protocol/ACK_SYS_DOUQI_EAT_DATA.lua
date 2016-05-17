
require "common/AcknowledgementMessage"

-- [48290]吞噬结果信息块 -- 斗气系统 

ACK_SYS_DOUQI_EAT_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_EAT_DATA
	self:init()
end)

function ACK_SYS_DOUQI_EAT_DATA.deserialize(self, reader)
	self.lan_id = reader:readInt8Unsigned() -- {吞噬者位置ID}
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.id_data = reader:readXXXGroup() -- {被吞者位置ID列表【48295】}
    print("成功吞噬:"..self.count.." 个斗气")
    local icount = 1
    self.id_data = {}
    while icount <= self.count do
        print("第 "..icount.." 个被吞噬。")
        local tempData = ACK_SYS_DOUQI_LAN_MSG()
        tempData :deserialize( reader)
        self.id_data[icount] = tempData
        icount = icount + 1
    end
end

-- {吞噬者位置ID}
function ACK_SYS_DOUQI_EAT_DATA.getLanId(self)
	return self.lan_id
end

-- {数量}
function ACK_SYS_DOUQI_EAT_DATA.getCount(self)
	return self.count
end

-- {被吞者位置ID列表【48295】}
function ACK_SYS_DOUQI_EAT_DATA.getIdData(self)
	return self.id_data
end
