
require "common/RequestMessage"

-- (手动) -- [4070]添加好友，最近联系人，黑名单 -- 好友 

REQ_FRIEND_ADD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FRIEND_ADD
	self:init()
end)

function REQ_FRIEND_ADD.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
	writer:writeInt16Unsigned(self.count)  -- {添加的数量}
	--writer:writeXXXGroup(self.detail)  -- {请求添加好友详情}
    print("[4070]添加好友，最近联系人，黑名单", self.count)
    
    if self.count > 0 then
        for i=1, self.count do
            writer:writeInt32Unsigned( self.detail[i])
        end
    end
    
end

function REQ_FRIEND_ADD.setArguments(self,type,count,detail)
	self.type = type  -- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
	self.count = count  -- {添加的数量}
	self.detail = detail  -- {请求添加好友详情}
end

-- {好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表}
function REQ_FRIEND_ADD.setType(self, type)
	self.type = type
end
function REQ_FRIEND_ADD.getType(self)
	return self.type
end

-- {添加的数量}
function REQ_FRIEND_ADD.setCount(self, count)
	self.count = count
end
function REQ_FRIEND_ADD.getCount(self)
	return self.count
end

-- {请求添加好友详情}
function REQ_FRIEND_ADD.setDetail(self, detail)
	self.detail = detail
end
function REQ_FRIEND_ADD.getDetail(self)
	return self.detail
end
