require "mediator/mediator"


CStandingsLayerMediator = class(mediator, function(self, _view)
	self.name = "StandingsLayerMediator"
	self.view = _view
end)


function CStandingsLayerMediator.getView(self)
	return self.view
end

function CStandingsLayerMediator.getName(self)
	return self.name
end

function CStandingsLayerMediator.getUserName(self)
	return self.user_name
end

function CStandingsLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给积分榜页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_WRESTLE_SCORE_MSG"] then  -- [54818]积分榜返回 -- 格斗之王 
			print("CStandingsLayerMediator收到积分榜返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_SCORE_MSG( ackMsg )
		end

	end

	return false
end




function CStandingsLayerMediator.ACK_WRESTLE_SCORE_MSG(self, ackMsg)  -- [54818]积分榜返回 -- 格斗之王 
	local Count    = tonumber(ackMsg : getCount())    
	local Msg      = ackMsg : getMsg()    
	print("CStandingsLayerMediator.ACK_WRESTLE_SCORE_MSG 各种倒计时",Count,#Msg)
	self : getView() : pushData(Count,Msg) --sever methond
end
















