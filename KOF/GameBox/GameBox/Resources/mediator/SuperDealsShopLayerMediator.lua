require "mediator/mediator"

require "model/VO_ShopModel"

CSuperDealsShopLayerMediator = class(mediator, function(self, _view)
	self.name = "SuperDealsShopLayerMediator"
	self.view = _view
end)


function CSuperDealsShopLayerMediator.getView(self)
	return self.view
end

function CSuperDealsShopLayerMediator.getName(self)
	return self.name
end

function CSuperDealsShopLayerMediator.getUserName(self)
	return self.user_name
end

function CSuperDealsShopLayerMediator.processCommand(self,_command)

	--接受服务端发回商店结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给商店页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_SHOP_REQUEST_OK_NEW"] then  -- (手动) -- [34512]请求店铺面板成功 -- 商城
			print("CSuperDealsShopLayerMediator收到请求店铺面板成功协议,ackMessage:getMsgID===",msgID)
			self : ACK_SHOP_REQUEST_OK_NEW( ackMsg )
		end

		if msgID == _G.Protocol["ACK_SHOP_BUY_SUCC"] then  -- [34516]购买成功 -- 商城
			print("CSuperDealsShopLayerMediator收到请求店铺面板成功协议,ackMessage:getMsgID===",msgID)
			self : ACK_SHOP_BUY_SUCC( ackMsg )
		end
	end
	--商店windows弹出
	if _command:getType() == CChatWindowedCommand.TYPE then

		if _command:getData() == CChatWindowedCommand.OPEN then
			--打开
			self:getView():open() --ok
			return true
		end
	end

	return false
end



function CSuperDealsShopLayerMediator.ACK_SHOP_REQUEST_OK_NEW(self, ackMsg)   

	print("CSuperDealsShopLayerMediator进入到商店面板协议处理方法")
	--self:getView() : setReNewData_EquipmentList(m_EquipmentListData)
	local Type    = ackMsg : getType()
	local TypeBb  = tonumber(ackMsg : getTypeBb()) 
	local Count   =	tonumber(ackMsg : getCount()) 
	local Msg     =	ackMsg : getMsg()
	local EndTime =	ackMsg : getEndTime()
	print("CSuperDealsShopLayerMediator get the data =",Type,TypeBb,Count,Msg,EndTime)
	print("---------------------------------------------")
	for k,v in pairs(Msg) do
		print(k,v,v.goods_id,v.v_price,v.etra_type,v.etra_value)
	end
	print("---------------------------------------------")


	if TypeBb == 2000 or TypeBb == 2010 then
		--等级特惠
		self:getView() : pushData(Msg,Count,TypeBb,Type)
	elseif TypeBb == 2020 then
		--每日特惠
		self:getView() : NetWrokReturn_EveryDayDealsView(Msg,Count,TypeBb,Type)
	end

	--self:getView() : pushData(Msg,Count,TypeBb,Type)
	print("CSuperDealsShopLayerMediator 商店面板协议处理方法处理完毕～～")
end

function CSuperDealsShopLayerMediator.ACK_SHOP_BUY_SUCC(self, ackMsg)   
    self:getView() : NetWorkReturn_SHOP_BUY_SUCC()
end





















