
require "common/AcknowledgementMessage"

-- [48245]伙伴数据信息块 -- 斗气系统 

ACK_SYS_DOUQI_ROLE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYS_DOUQI_ROLE_DATA
	self:init()
    print("---------------------------------伙伴数据")
end)

function ACK_SYS_DOUQI_ROLE_DATA.deserialize(self, reader)
    print("---start")
	self.role_id = reader:readInt16Unsigned() -- {伙伴ID | 自己0}
	self.count   = reader:readInt16Unsigned()  -- {已装备斗气个数}
    print("角色: "..self.role_id.."已装备斗气个数"..self.count)
	--self.douqi_msg = reader:readXXXGroup() -- {斗气信息块【48203】}
    self.douqi_msg = {}
    for i=1,self.count do
        print("第 "..i.." 个斗气:")
        local tempData = ACK_SYS_DOUQI_DOUQI_DATA()
        tempData :deserialize( reader)
        self.douqi_msg[i] = tempData
        
    end
    print("--_end")
    
    --[[local icount = 1
    self.douqi_msg = {}
    while icount <= self.count do
        print("第 "..icount.." 个斗气:")
        local tempData = ACK_SYS_DOUQI_DOUQI_DATA()
        tempData :deserialize( reader)
        self.douqi_msg[icount] = tempData
        icount = icount + 1
    end]]
end

-- {伙伴ID | 自己0}
function ACK_SYS_DOUQI_ROLE_DATA.getRoleId(self)
	return self.role_id
end

-- {已装备斗气个数}
function ACK_SYS_DOUQI_ROLE_DATA.getCount(self)
	return self.count
end

-- {斗气栏信息块【48203】}
function ACK_SYS_DOUQI_ROLE_DATA.getDouqiMsg(self)
	return self.douqi_msg
end
