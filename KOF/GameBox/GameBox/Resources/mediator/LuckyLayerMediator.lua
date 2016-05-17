require "mediator/mediator"
require "model/VO_LuckyModel"


CLuckyLayerMediator = class(mediator, function(self, _view)
	self.name = "LuckyLayerMediator"
	self.view = _view
end)


function CLuckyLayerMediator.getView(self)
	return self.view
end

function CLuckyLayerMediator.getName(self)
	return self.name
end

function CLuckyLayerMediator.getUserName(self)
	return self.user_name
end

function CLuckyLayerMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回镶嵌结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给招财页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()


		if msgID == _G.Protocol["ACK_WEAGOD_REPLY"] then  --接受到招财面板返回 32020
			print("CLuckyLayerMediator收到招财协议,ackMessage:getMsgID===",msgID)
			self : ACK_WEAGOD_REPLY( ackMsg )
		end

		if msgID == _G.Protocol["ACK_WEAGOD_SUCCESS"] then  -- [32060]招财成功返回 -- 财神 
			print("CLuckyLayerMediator收到招财成功返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WEAGOD_SUCCESS( ackMsg )
		end
	end
	return false
end

function CLuckyLayerMediator.ACK_WEAGOD_REPLY(self, ackMsg)   --接受到招财面板返回 32020

	print("CLuckyLayerMediator进入到招财协议处理方法")
	--self:getView() : setReNewData_EquipmentList(m_EquipmentListData)
	print("get the data =",ackMsg,ackMsg : getTimes(),ackMsg : getIsAuto(),ackMsg : getAutoGold())
	local vo_data = VO_LuckyModel()
	vo_data : setLuckyTimes    (ackMsg : getTimes())
	vo_data : setLuckyIsauto   (ackMsg : getIsAuto())
	vo_data : setLuckyauto_gold(ackMsg : getAutoGold())
	vo_data : setLuckynext_rmb (ackMsg : getNextRmb())
	vo_data : setLuckynext_gold(ackMsg : getNextGold())

	-- require "proxy/LuckyDataProxy"
	-- _G.g_LuckyDataProxy = CLuckyDataProxy()
	-- _G.g_LuckyDataProxy : setLuckyTimes(ackMsg : getTimes())


	tt = vo_data : getLuckyTimes()
	print("vo_data ==",tt)
	self:getView() : pushData(vo_data)
	--self:getView() : update(m_EquipmentListData)
	print("CLuckyLayerMediator招财协议处理方法处理完毕～～")
end

function CLuckyLayerMediator.ACK_WEAGOD_SUCCESS(self, ackMsg)   --接受到招财面板返回 32020

	print("CLuckyLayerMediator进入到招财成功返回协议处理方法")

	local returntype = ackMsg : getType() -- {返回类型（1：单次招财；2：批量招财）}
	print("returntype ==",returntype)
	self:getView() : pushSuccess(returntype)

	print("CLuckyLayerMediator招财成功返回协议处理方法处理完毕～～")
end






















