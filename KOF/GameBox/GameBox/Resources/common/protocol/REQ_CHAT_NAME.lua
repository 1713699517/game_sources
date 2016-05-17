
require "common/RequestMessage"

-- [9526]发送名字私聊 -- 聊天 

REQ_CHAT_NAME = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CHAT_NAME
	self:init()
end)

function REQ_CHAT_NAME.serialize(self, writer)
	writer:writeString(self.name)  -- {对方名字}
	writer:writeUTF(self.msg)  -- {聊天内容}
	writer:writeInt16Unsigned(self.goods_count)  -- {物品数量}
	local i = 0
	if self.goods_list ~= nil and self.goods_count > 0 then
		for k,v in paris(self.goods_list) do
			i = i + 1
			if i > self.goods_count then
				break
			end
			writer.writeInt8Unsigned(v.goods_type)
			writer.writeInt32Unsigned(v.id)
			writer.writeInt16Unsigned(v.goods_index)
		end
	end
	--writer:writeXXXGroup(self.goods_list)  -- {发送物品信息块}
end

function REQ_CHAT_NAME.setArguments(self,name,msg,goods_count,goods_list)
	self.name = name  -- {对方名字}
	self.msg = msg  -- {聊天内容}
	self.goods_count = goods_count  -- {物品数量}
	self.goods_list = goods_list  -- {发送物品信息块}
end

-- {对方名字}
function REQ_CHAT_NAME.setName(self, name)
	self.name = name
end
function REQ_CHAT_NAME.getName(self)
	return self.name
end

-- {聊天内容}
function REQ_CHAT_NAME.setMsg(self, msg)
	self.msg = msg
end
function REQ_CHAT_NAME.getMsg(self)
	return self.msg
end

-- {物品数量}
function REQ_CHAT_NAME.setGoodsCount(self, goods_count)
	self.goods_count = goods_count
end
function REQ_CHAT_NAME.getGoodsCount(self)
	return self.goods_count
end

-- {发送物品信息块}
function REQ_CHAT_NAME.setGoodsList(self, goods_list)
	self.goods_list = goods_list
end
function REQ_CHAT_NAME.getGoodsList(self)
	return self.goods_list
end
