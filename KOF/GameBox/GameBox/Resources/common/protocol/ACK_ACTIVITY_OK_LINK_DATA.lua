
require "common/AcknowledgementMessage"

-- [30620]活跃度数据返回 -- 活动面板 

ACK_ACTIVITY_OK_LINK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_OK_LINK_DATA
	self:init()
end)

function ACK_ACTIVITY_OK_LINK_DATA.deserialize(self, reader)
	self.vitality = reader:readInt32Unsigned() -- {当前活跃度}
    
    print("\n\n--------活动数据信息块----------")
	self.count1   = reader:readInt16Unsigned() -- {活动数量}
	self.active_data = {}--reader:readXXXGroup() -- {活动数据信息块【30630】}
    local iCount = 1
    while iCount <= self.count1 do
        self.active_data[iCount] = {}
        self.active_data[iCount].active_id       = reader:readInt16Unsigned()
        self.active_data[iCount].ok_times        = reader:readInt8Unsigned()
        self.active_data[iCount].all_times       = reader:readInt8Unsigned()
        self.active_data[iCount].active_vitality = reader:readInt8Unsigned()
        
        print("活动入口id="..self.active_data[iCount].active_id,"已 完成次数="..self.active_data[iCount].ok_times,"应 完成次数="..self.active_data[iCount].all_times,"完成活动可得活跃度="..self.active_data[iCount].active_vitality)
        
        iCount = iCount + 1
    end
    
    print("\n\n--------礼包编号块----------")
    
    self.count2  = reader:readInt16Unsigned() -- {活动数量}
    self.rewards = {}
    iCount = 1
    while iCount <= self.count2 do
        self.rewards[iCount] = {}
        self.rewards[iCount].id = reader:readInt8Unsigned()
        
        print("礼包编号="..self.rewards[iCount].id)
        
        iCount = iCount + 1
    end
    
    print("count1="..self.count1,"   count2="..self.count2)
    
end

-- {当前活跃度}
function ACK_ACTIVITY_OK_LINK_DATA.getVitality(self)
	return self.vitality
end

-- {活动数量}
function ACK_ACTIVITY_OK_LINK_DATA.getCount1(self)
	return self.count1
end

-- {活动数据信息块【30630】}
function ACK_ACTIVITY_OK_LINK_DATA.getActiveData(self)
	return self.active_data
end

-- {已领礼包编号}
function ACK_ACTIVITY_OK_LINK_DATA.getCount2(self)
	return self.count2
end

-- {奖励数据块【30640】}
function ACK_ACTIVITY_OK_LINK_DATA.getRewards(self)
	return self.rewards
end
