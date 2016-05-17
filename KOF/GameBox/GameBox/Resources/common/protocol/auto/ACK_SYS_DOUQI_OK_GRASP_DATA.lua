
require "common/AcknowledgementMessage"

-- [48220]领悟界面信息返回 -- 斗气系统 

ACK_SYS_DOUQI_OK_GRASP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_GRASP_DATA
	self:init()
end)

function ACK_SYS_DOUQI_OK_GRASP_DATA.deserialize(self, reader)
	self.type_grasp = reader:readInt8Unsigned() -- {当前领悟方式}
	self.ok_times = reader:readInt16Unsigned() -- {已钻石领悟次数}
	self.all_times = reader:readInt16Unsigned() -- {总计可钻石领悟次数}
	self.adam_war = reader:readInt32Unsigned() -- {战魂值}
end

-- {当前领悟方式}
function ACK_SYS_DOUQI_OK_GRASP_DATA.getTypeGrasp(self)
	return self.type_grasp
end

-- {已钻石领悟次数}
function ACK_SYS_DOUQI_OK_GRASP_DATA.getOkTimes(self)
	return self.ok_times
end

-- {总计可钻石领悟次数}
function ACK_SYS_DOUQI_OK_GRASP_DATA.getAllTimes(self)
	return self.all_times
end

-- {战魂值}
function ACK_SYS_DOUQI_OK_GRASP_DATA.getAdamWar(self)
	return self.adam_war
end
