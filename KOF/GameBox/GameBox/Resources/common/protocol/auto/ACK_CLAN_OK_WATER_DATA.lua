
require "common/AcknowledgementMessage"

-- (手动) -- [33330]返回浇水面板数据 -- 社团 

ACK_CLAN_OK_WATER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_WATER_DATA
	self:init()
end)

function ACK_CLAN_OK_WATER_DATA.deserialize(self, reader)
	self.stamina     = reader:readInt32Unsigned() -- {现有体能点数}
	self.water_times = reader:readInt8Unsigned()  -- {已浇水次数}
	self.all_times   = reader:readInt8Unsigned()  -- {总可浇水次数}
	self.yqs_exp     = reader:readInt32Unsigned() -- {摇钱树现有经验}
	self.up_exp      = reader:readInt32Unsigned() -- {摇钱树升级经验}
	self.yq_times    = reader:readInt8Unsigned()  -- {可摇钱次数}
    print("招财猫活动数据: 帮贡->"..self.stamina.." 互动次数->("..self.water_times.."/"..self.all_times..") 经验->("..self.yqs_exp.."/"..self.up_exp..") 可摇钱次数->"..self.yq_times)
	self.count       = reader:readInt16Unsigned() -- {数量}
    print(" 浇水日志数量: "..self.count)
	--self.water_logs  = reader:readXXXGroup() -- {浇水日志数据块【33335】}
    local icount = 1
    self.water_logs = {}
    while icount <= self.count do
        print("第 "..icount.." 个浇水日志数据:")
        local tempData = ACK_CLAN_WATER_LOGS_DATA()
        tempData :deserialize( reader)
        self.water_logs[icount] = tempData
        icount = icount + 1
    end
end

-- {现有体能点数}
function ACK_CLAN_OK_WATER_DATA.getStamina(self)
	return self.stamina
end

-- {已浇水次数}
function ACK_CLAN_OK_WATER_DATA.getWaterTimes(self)
	return self.water_times
end

-- {总可浇水次数}
function ACK_CLAN_OK_WATER_DATA.getAllTimes(self)
	return self.all_times
end

-- {摇钱树现有经验}
function ACK_CLAN_OK_WATER_DATA.getYqsExp(self)
	return self.yqs_exp
end

-- {摇钱树升级经验}
function ACK_CLAN_OK_WATER_DATA.getUpExp(self)
	return self.up_exp
end

-- {可摇钱次数}
function ACK_CLAN_OK_WATER_DATA.getYqTimes(self)
	return self.yq_times
end

-- {数量}
function ACK_CLAN_OK_WATER_DATA.getCount(self)
	return self.count
end

-- {浇水日志数据块【33335】}
function ACK_CLAN_OK_WATER_DATA.getWaterLogs(self)
	return self.water_logs
end
