require "mediator/mediator"
--require "model/VO_TreasureHouseModel"


CEquipmentManufactureMediator = class(mediator, function(self, _view)
	self.name = "EquipmentManufactureMediator"
	self.view = _view
end)

function CEquipmentManufactureMediator.getView(self)
	return self.view
end

function CEquipmentManufactureMediator.getName(self)
	return self.name
end

function CEquipmentManufactureMediator.getUserName(self)
	return self.user_name
end

function CEquipmentManufactureMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给藏宝阁的制作页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID  = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		-- if msgID == _G.Protocol["ACK_TREASURE_REQUEST_INFO"] then  --接受到藏宝阁页面请求返回 47210
		-- 	print("CEquipmentManufactureMediator收到藏宝阁协议,ackMessage:getMsgID===",msgID)
		-- 	self : ACK_TREASURE_REQUEST_INFO( ackMsg )
		-- end

		if msgID == _G.Protocol["ACK_TREASURE_ATTRIBUTE"] then  -- [47230]触发属性加成 -- 藏宝阁系统 
			print("CEquipmentManufactureMediator收到触发属性加成,ackMessage:getMsgID===",msgID)
			self : ACK_TREASURE_ATTRIBUTE( ackMsg )
		end

		if msgID == _G.Protocol["ACK_TREASURE_COPY_STATE"] then  -- [47320]副本开启状态 -- 珍宝阁系统
			print("CEquipmentManufactureMediator 副本开启状态,ackMessage:getMsgID===",msgID)
			self : ACK_TREASURE_COPY_STATE( ackMsg )
		end
	end

	if _command:getType() == CTreasureHouseInfoViewCommand.TYPE then
        local page  = _command : getPage()  
        if page == 2 then
        	self :getView()    : pushData( _command : getModel())    
        end
    end

	return false
end

function CEquipmentManufactureMediator.ACK_TREASURE_REQUEST_INFO(self, ackMsg)   --接受到藏宝阁页面请求返回 47210

	print("CEquipmentManufactureMediator进入到藏宝阁协议处理方法")

	local LevelId   = ackMsg : getLevelId()
	local GoodsData = ackMsg : getGoodsMsgNo()	
	local Count     = ackMsg : getCount()
	
	self:getView() : pushData(LevelId,GoodsData,Count)

	print("CEquipmentManufactureMediator藏宝阁面板接受协议处理方法处理完毕～～")
end


function CEquipmentManufactureMediator.ACK_TREASURE_ATTRIBUTE(self, ackMsg)   -- [47230]触发属性加成 -- 藏宝阁系统

	print("CEquipmentManufactureMediator进入到藏宝阁触发属性加成协议处理方法")

	local Id   = ackMsg : getId()
	local State = ackMsg : getState()
	print("ACK_TREASURE_ATTRIBUTE--->>>>88",self:getView(),Id,State)
	
	self:getView() : TriggerPropertyAdd( Id,State )
	print("CEquipmentManufactureMediator藏宝阁触发属性加成协议方法处理完毕～～")
end

function CEquipmentManufactureMediator.ACK_TREASURE_COPY_STATE(self, ackMsg)   -- [47230]触发属性加成 -- 藏宝阁系统

	print("CEquipmentManufactureMediator进入到副本开启状态协议处理方法")

	local State = tonumber(ackMsg : getState())   -- {1:副本开启状态|0:关闭}
	print("ACK_TREASURE_ATTRIBUTE--->>>>99",self:getView(),Id,State)
	
	self:getView() : NetWorkReturn_TREASURE_COPY_STATE( State )
	print("CEquipmentManufactureMediator藏宝阁副本开启状态协议方法处理完毕～～")
end



















