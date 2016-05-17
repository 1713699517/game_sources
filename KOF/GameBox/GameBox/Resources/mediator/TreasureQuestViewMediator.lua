require "mediator/mediator"



CTreasureQuestViewMediator = class(mediator, function(self, _view)
	self.name = "TreasureQuestViewMediator"
	self.view = _view
end)


function CTreasureQuestViewMediator.getView(self)
	return self.view
end

function CTreasureQuestViewMediator.getName(self)
	return self.name
end

function CTreasureQuestViewMediator.getUserName(self)
	return self.user_name
end

function CTreasureQuestViewMediator.processCommand(self,_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给宝箱探秘<<<<<<<<<<<<<<<<<<<<<<")
		local msgID  = _command :getProtocolID()
		local ackMsg = _command:getAckMessage()
		print("ackMessage:getMsgID===",msgID)

		if msgID == _G.Protocol["ACK_DISCOVE_STORE_DATA"] then -- [57830]返回物品 -- 宝箱探秘
			
			self : ACK_DISCOVE_STORE_DATA( ackMsg )
		end

		if msgID == _G.Protocol["ACK_DISCOVE_STORE_GOODS"] then   -- [57830]返回物品 -- 宝箱探秘
			self : ACK_DISCOVE_STORE_GOODS( ackMsg )
		end
	end

	return false
end



function CTreasureQuestViewMediator.ACK_DISCOVE_STORE_DATA(self, ackMsg)   -- [57810]数据返回 -- 宝箱探秘 

	local GoodsCount = tonumber(ackMsg : getGoodsCount()) 
	print("CTreasureQuestViewMediator 获取剩余钥匙数量 =",GoodsCount)

	self:getView() : pushData(GoodsCount)
	print("CTreasureQuestViewMediator ACK_DISCOVE_STORE_DATA 协议处理方法处理完毕～～")
end

function CTreasureQuestViewMediator.ACK_DISCOVE_STORE_GOODS(self, ackMsg)  -- [57830]返回物品 -- 宝箱探秘

	local GoodsId    = ackMsg : getGoodsId()
	local GoodsCount = ackMsg : getCount()
	
    self:getView() : NetWorkReturn_DISCOVE_STORE_GOODS(GoodsId,GoodsCount)
end





















