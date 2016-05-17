require "mediator/mediator"


CFunQuizLayerMediator = class(mediator, function(self, _view)
	self.name = "FunQuizLayerMediatorr"
	self.view = _view
end)


function CFunQuizLayerMediator.getView(self)
	return self.view
end

function CFunQuizLayerMediator.getName(self)
	return self.name
end

function CFunQuizLayerMediator.getUserName(self)
	return self.user_name
end

function CFunQuizLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给欢乐竞猜页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()


		if msgID == _G.Protocol["ACK_WRESTLE_GUESS_STATE"] then  -- [54900]竞猜状态 -- 格斗之王
			print("CFunQuizLayerMediator收到竞猜状态返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_GUESS_STATE( ackMsg )
		end

		if msgID == _G.Protocol["ACK_WRESTLE_PEBBLE"] then  -- [54930]竞技水晶更新 -- 格斗之王 
			print("1001CFunQuizLayerMediator收到 竞技水晶更新 返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_PEBBLE( ackMsg )
		end
	end

	return false
end


function CFunQuizLayerMediator.ACK_WRESTLE_GUESS_STATE(self, ackMsg)  -- [54900]竞猜状态 -- 格斗之王
	local State  = tonumber(ackMsg : getState())
	local Name1  = ackMsg : getName1() 
	local Name2  = ackMsg : getName2() 
	local Rmb    = ackMsg : getRmb() 
	print("CFunQuizLayerMediator.ACK_WRESTLE_GUESS_STATE 竞猜状态",State,Name1,Name2,Rmb)
	self : getView() : NetWorkReturn_WRESTLE_GUESS_STATE(State,Name1,Name2,Rmb) --sever methond
end

function CFunQuizLayerMediator.ACK_WRESTLE_PEBBLE(self, ackMsg)  -- [54930]竞技水晶更新 -- 格斗之王 
	local Pebble  = tonumber(ackMsg : getPebble())
	print("CFunQuizLayerMediator.ACK_WRESTLE_PEBBLE 竞技水晶更新",State,Name1,Name2,Rmb)
	self : getView() : NetWorkReturn_WRESTLE_PEBBLE(Pebble) --sever methond
end















