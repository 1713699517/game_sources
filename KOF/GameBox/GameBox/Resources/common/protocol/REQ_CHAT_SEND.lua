
require "common/RequestMessage"

-- [9525]发送频道聊天 -- 聊天 

REQ_CHAT_SEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_SEND
	self:init()
end)

function REQ_CHAT_SEND.serialize(self, writer)
	writer:writeInt8Unsigned(self.channel_id)    -- {频道类型}
	writer:writeInt32Unsigned(self.uid)          -- {对方UID}
    writer:writeUTF(self.msg)                    -- {聊天内容}
    writer:writeInt8Unsigned(self.arg_type)      -- {参数类型（见常量）}
    writer:writeInt16Unsigned(self.team_id)      -- {队伍ID}
    writer:writeInt16Unsigned(self.copy_id)      -- {场景ID}
	writer:writeInt16Unsigned(self.goods_count)  -- {物品数量}
	local i = 0
	if self.goods_list ~= nil and self.goods_count > 0 then
		-- for k,v in paris(self.goods_list) do
		-- 	i = i + 1
		-- 	if i > self.goods_count then
		-- 		break
		-- 	end
			print("WWWWWWWW:",self.goods_list.goods_type,self.goods_list.id,self.goods_list.goods_index)
			writer:writeInt8Unsigned(self.goods_list.goods_type)
			print("11111111")
			writer:writeInt32Unsigned(self.goods_list.id)
			print("22222222")
			writer:writeInt16Unsigned(self.goods_list.goods_index)
			print("33333333")
		--end
	end
end

function REQ_CHAT_SEND.setArguments(self,channel_id,uid,arg_type,goods_count,goods_list,team_id,copy_id,msg)
	self.channel_id  = channel_id  -- {频道类型}
	self.uid         = uid         -- {对方UID}
	self.arg_type    = arg_type    -- {参数类型（见常量）}    
	self.goods_count = goods_count -- {物品数量}
	self.goods_list  = goods_list  -- {发送物品信息块}
    self.team_id     = team_id     -- {队伍id}
    self.copy_id     = copy_id     -- {场景id}
    self.msg         = msg         -- {聊天内容}
end

-- {频道类型}
function REQ_CHAT_SEND.setChannelId(self, channel_id)
	self.channel_id = channel_id
end
function REQ_CHAT_SEND.getChannelId(self)
	return self.channel_id
end

-- {对方UID}
function REQ_CHAT_SEND.setUid(self, uid)
	self.uid = uid
end
function REQ_CHAT_SEND.getUid(self)
	return self.uid
end

-- {参数类型}
function REQ_CHAT_SEND.setArg_type(self, arg_type)
	self.arg_type = arg_type
end
function REQ_CHAT_SEND.getArg_type(self)
	return self.arg_type
end

-- {聊天内容}
function REQ_CHAT_SEND.setMsg(self, msg)
	self.msg = msg
end
function REQ_CHAT_SEND.getMsg(self)
	return self.msg
end

-- {物品数量}
function REQ_CHAT_SEND.setGoodsCount(self, goods_count)
	self.goods_count = goods_count
end
function REQ_CHAT_SEND.getGoodsCount(self)
	return self.goods_count
end

-- {队伍ID}
function REQ_CHAT_SEND.setTeamId(self, team_id)
	self.team_id = team_id
end
function REQ_CHAT_SEND.getTeamId(self)
	return self.team_id
end

-- {场景ID}
function REQ_CHAT_SEND.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_CHAT_SEND.getCopyId(self)
	return self.copy_id
end

-- {发送物品信息块}
function REQ_CHAT_SEND.setGoodsList(self, goods_list)
	self.goods_list = goods_list
end
function REQ_CHAT_SEND.getGoodsList(self)
	return self.goods_list
end
