require "mediator/mediator"

require "model/VO_ShopModel"

CShopLayerMediator = class(mediator, function(self, _view)
	self.name = "ShopLayerMediator"
	self.view = _view
end)


function CShopLayerMediator.getView(self)
	return self.view
end

function CShopLayerMediator.getName(self)
	return self.name
end

function CShopLayerMediator.getUserName(self)
	return self.user_name
end

function CShopLayerMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回商店结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给商店页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_SHOP_REQUEST_OK"] then  --接受店铺面板成功协议返回 [34511]
			print("CShopLayerMediator收到请求店铺面板成功协议,ackMessage:getMsgID===",msgID)
			self : ACK_SHOP_REQUEST_OK( ackMsg )
		end

		if msgID == _G.Protocol["ACK_SHOP_BUY_SUCC"] then  -- [34516]购买成功 -- 商城
			print("CShopLayerMediator收到请求店铺面板成功协议,ackMessage:getMsgID===",msgID)
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



function CShopLayerMediator.ACK_SHOP_REQUEST_OK(self, ackMsg)   --接受到招财面板返回 32020

	print("CShopLayerMediator进入到商店面板协议处理方法")
	--self:getView() : setReNewData_EquipmentList(m_EquipmentListData)
	local Type    = ackMsg : getType()
	local TypeBb  = ackMsg : getTypeBb()
	local Count   =	ackMsg : getCount()
	local Msg     =	ackMsg : getMsg()
	local EndTime =	ackMsg : getEndTime()
	print("get the data =",Type,TypeBb,Count,Msg,EndTime)
	print("---------------------------------------------")
	for k,v in pairs(Msg) do
		print(k,v,v.goods_id,v.v_price,v.total_remaider_Num,v.idx)
	end
	print("---------------------------------------------")

	local vo_data = VO_ShopModel()
	vo_data : setType    (ackMsg : getType())
	vo_data : setTypeBb  (ackMsg : getTypeBb())
	vo_data : setCount   (ackMsg : getCount())
	vo_data : setMsg     (ackMsg : getMsg())
	vo_data : setEndTime (ackMsg : getEndTime())

	self:getView() : pushData(vo_data,Count,TypeBb,Type)
	print("CShopLayerMediator商店面板协议处理方法处理完毕～～")
end

function CShopLayerMediator.ACK_SHOP_BUY_SUCC(self, ackMsg)   --接受到招财面板返回 32020
    self:getView() : NetWorkReturn_SHOP_BUY_SUCC()
end





















