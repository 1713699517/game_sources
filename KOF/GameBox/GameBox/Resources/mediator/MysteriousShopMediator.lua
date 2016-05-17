require "mediator/mediator"
--require "model/VO_TreasureHouseModel"


CMysteriousShopMediator = class(mediator, function(self, _view)
	self.name = "MysteriousShopMediator"
	self.view = _view
end)



function CMysteriousShopMediator.getView(self)
	return self.view
end

function CMysteriousShopMediator.getName(self)
	return self.name
end

function CMysteriousShopMediator.getUserName(self)
	return self.user_name
end

function CMysteriousShopMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给神秘商店页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID  = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		-- if msgID == _G.Protocol["ACK_TREASURE_SHOP_INFO"] then  --接受到藏宝阁页面请求返回 47280
		-- 	print("CMysteriousShopMediator收到商店面板数据协议,ackMessage:getMsgID===",msgID)
		-- 	self : ACK_TREASURE_SHOP_INFO( ackMsg )
		-- end

		if msgID == _G.Protocol["ACK_TREASURE_SHOP_INFO_NEW"] then  --接受到藏宝阁页面请求返回 47280
			print("CMysteriousShopMediator收到商店面板数据协议,ackMessage:getMsgID===",msgID)
			self : ACK_TREASURE_SHOP_INFO( ackMsg )
		end

		if msgID == _G.Protocol["ACK_TREASURE_PURCHASE_STATE"] then -- [47300]购买成功与否 -- 藏宝阁系统 
			self : ACK_TREASURE_PURCHASE_STATE( ackMsg )
		end

	end
	return false
end

function CMysteriousShopMediator.ACK_TREASURE_SHOP_INFO(self, ackMsg)   --接受到藏宝阁页面请求返回 47280

	print("CMysteriousShopMediator进入到神秘商店协议处理方法",ackMsg : getTime(),ackMsg : getCount())

	local Time      = ackMsg : getTime()
	local GoodsData = ackMsg : getGoodsIdNo()	
	local Count     = ackMsg : getCount()


	self:getView() : pushData(Time,GoodsData,Count)

	print("CMysteriousShopMediator神秘商店面板接受协议处理方法处理完毕～～")
end

function CMysteriousShopMediator.ACK_TREASURE_PURCHASE_STATE(self, ackMsg)   --接受到藏宝阁页面请求返回 47280

	print("CMysteriousShopMediator进入到神秘商店协议处理方法")

	local State    = ackMsg : getState()
	if State ~= nil then
		self:getView() : isBuyOk(State)
	else 
		print("神秘商店购买返回为nil")
	end
	print("神秘商店ACK_TREASURE_PURCHASE_STATE接受协议处理方法处理完毕～～")
end






















