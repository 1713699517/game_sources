
require "common/AcknowledgementMessage"

-- [1270]开启的系统ID -- 角色 

ACK_ROLE_SYS_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_SYS_ID
	self:init()
    print("tionOpenMediator注功能开放", self.MsgID)
end)

function ACK_ROLE_SYS_ID.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {数量}
	--self.sys_id = reader:readXXXGroup() -- {信息块(1270)}
    print( "ACK_ROLE_SYS_ID.deserialize", self.count)
    
    if self.count > 0 then
        self.sys_id = {}
        
        for i=1, self.count do
            self.sys_id[i] = reader:readInt16Unsigned()
        end
    end
    
    
    if self.sys_id ~= nil and #self.sys_id >0 then
        for k, v in pairs( self.sys_id) do
            print("[1270]开启的系统ID ", v, #self.sys_id)
        end
    end
end


-- {数量}
function ACK_ROLE_SYS_ID.getCount(self)
	return self.count
end

-- {系统ID}
function ACK_ROLE_SYS_ID.getSysId(self)
	return self.sys_id
end
