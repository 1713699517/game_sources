
require "common/AcknowledgementMessage"

-- [48240]装备界面信息返回 -- 斗气系统 

ACK_SYS_DOUQI_OK_DOUQI_ROLE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_OK_DOUQI_ROLE
	self:init()
    print("-- [48240]装备界面信息返回 -- 斗气系统")
end)

function ACK_SYS_DOUQI_OK_DOUQI_ROLE.deserialize(self, reader)
	self.lan_count = reader:readInt8Unsigned()  -- {已开启斗气栏个数}
	self.count     = reader:readInt16Unsigned() -- {伙伴数量}
    print("已开启斗气栏个数:"..self.lan_count.."伙伴数量:"..self.count)
	--self.role_msg = reader:readXXXGroup() -- {伙伴数据信息块【48265】}
    local icount = 1
    self.role_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个角色:")
        local tempData = ACK_SYS_DOUQI_ROLE_DATA()
        tempData :deserialize( reader)
        self.role_msg[icount] = tempData
        icount = icount + 1
    end
end

-- {已开启斗气栏个数}
function ACK_SYS_DOUQI_OK_DOUQI_ROLE.getLanCount(self)
	return self.lan_count
end

-- {伙伴数量}
function ACK_SYS_DOUQI_OK_DOUQI_ROLE.getCount(self)
	return self.count
end

-- {伙伴数据信息块【48265】}
function ACK_SYS_DOUQI_OK_DOUQI_ROLE.getRoleMsg(self)
	return self.role_msg
end
