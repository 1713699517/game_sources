require "mediator/mediator"
require "model/VO_TreasureHouseModel"
require "controller/TreasureHouseInfoViewCommand"


CTreasureHouseMediator = class(mediator, function(self, _view)
	self.name = "TreasureHouseMediator"
	self.view = _view
end)


function CTreasureHouseMediator.getView(self)
	return self.view
end

function CTreasureHouseMediator.getName(self)
	return self.name
end

function CTreasureHouseMediator.getUserName(self)
	return self.user_name
end

function CTreasureHouseMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给藏宝阁页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID  = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_TREASURE_REQUEST_INFO"] then  --接受到藏宝阁页面请求返回 47210
			print("CTreasureHouseMediator收到藏宝阁协议,ackMessage:getMsgID===",msgID)
			self : ACK_TREASURE_REQUEST_INFO( ackMsg )
		end

		if msgID == _G.Protocol["ACK_TREASURE_ATTRIBUTE"] then  -- [47230]触发属性加成 -- 藏宝阁系统 
			print("CTreasureHouseMediator收到触发属性加成,ackMessage:getMsgID===",msgID)
			self : ACK_TREASURE_ATTRIBUTE( ackMsg )
		end
	end

	return false
end

function CTreasureHouseMediator.ACK_TREASURE_REQUEST_INFO(self, ackMsg)   --接受到藏宝阁页面请求返回 47210

	print("CTreasureHouseMediator进入到藏宝阁协议处理方法")

	local LevelId   = ackMsg : getLevelId()
	local GoodsData = ackMsg : getGoodsMsgNo()	
	local Count     = ackMsg : getCount()
	local Level     = math.floor(LevelId/100)

	print("Level-->",Level)
	
	self:getView() : pushData(LevelId,Level,GoodsData,Count)

	print("CTreasureHouseMediator藏宝阁面板接受协议处理方法处理完毕～～")
end

function CTreasureHouseMediator.ACK_TREASURE_ATTRIBUTE(self, ackMsg)   -- [47230]触发属性加成 -- 藏宝阁系统

	print("CTreasureHouseMediator进入到藏宝阁触发属性加成协议处理方法")

	local Id   = ackMsg : getId()
	local State = ackMsg : getState()
	print("ACK_TREASURE_ATTRIBUTE--->>>>",Id,State)
	
	self:getView() : TriggerPropertyAdd( Id,State )
	print("CTreasureHouseMediator藏宝阁触发属性加成协议方法处理完毕～～")
end






















