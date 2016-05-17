
require "common/AcknowledgementMessage"

-- (手动) -- [1271]开启的系统ID(新) -- 角色 

ACK_ROLE_SYS_ID_2 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_SYS_ID_2
	self:init()
end)

function ACK_ROLE_SYS_ID_2.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {功能数量}
    print("功能开放数据数量-->", self.count)
    
    if self.count > 0 then
        
        self.sys_id = {}
        
        for i=1, self.count do
            self.sys_id[i] = {}
            self.sys_id[i].id  = reader:readInt16Unsigned()   -- {系统ID}
            self.sys_id[i].use = reader:readInt8Unsigned()    -- {是否使用(1:使用过0:没使用)}
            
        end
    end
    
    if self.sys_id ~= nil then
        for k, v in pairs( self.sys_id ) do
            print("sself.sys_idsself.sys_id", k, v.id, v.use)
        end
    end
end

-- {功能数量}
function ACK_ROLE_SYS_ID_2.getCount(self)
	return self.count
end

-- {系统ID}
function ACK_ROLE_SYS_ID_2.getSysId(self)
	return self.sys_id
end

-- {是否使用(1:使用过0:没使用)}
function ACK_ROLE_SYS_ID_2.getIsUse(self)
	return self.is_use
end
