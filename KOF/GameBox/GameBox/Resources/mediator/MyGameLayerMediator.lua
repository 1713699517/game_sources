require "mediator/mediator"


CMyGameLayerMediator = class(mediator, function(self, _view)
	self.name = "MyGameLayerMediator"
	self.view = _view
end)


function CMyGameLayerMediator.getView(self)
	return self.view
end

function CMyGameLayerMediator.getName(self)
	return self.name
end

function CMyGameLayerMediator.getUserName(self)
	return self.user_name
end

function CMyGameLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给我的比赛页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_WRESTLE_TIME"] then  --  [54805]各种倒计时 -- 格斗之王 
			print("11CMyGameLayerMediator收到各种倒计时协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_TIME( ackMsg )
		end

		-- if msgID == _G.Protocol["ACK_WRESTLE_STATE"] then  -- [54812]活动状态 -- 格斗之王 
		-- 	print("CMyGameLayerMediator收到活动状态表协议,ackMessage:getMsgID===",msgID)
		-- 	self : ACK_WRESTLE_STATE( ackMsg )
		-- end
	end

	return false
end


function CMyGameLayerMediator.ACK_WRESTLE_TIME(self, ackMsg)  --  [54805]各种倒计时 -- 格斗之王 
	local State      = tonumber(ackMsg : getState()) 
	--local Value   = tonumber(ackMsg : getValue())
    _G.pDateTime:reset()
	print("CMyGameLayerMediator.ACK_WRESTLE_TIME 各种倒计时")
    --local nowtime    = tonumber(_G.pDateTime:getTotalSeconds())
    local nowtime    = tonumber(_G.g_ServerTime:getServerTimeSeconds())
    local endTime    = tonumber(ackMsg : getEndTime())    --结束时间
    local startTime  = tonumber(ackMsg : getStartTime())  --开始时间
    print("拿到的两个服务器时间===",nowtime,_G.g_ServerTime:getServerTimeSeconds())
	if State ~= nil and State ==0 or State ==1 or State ==5 then
        self : getView() : NetWorkReturn_WRESTLE_TIME(nowtime,endTime,startTime) --sever methond
	end
	self : getView() : NetWorkReturn_WRESTLE_STATE(State)         --sever methond
end

function CMyGameLayerMediator.ACK_WRESTLE_STATE(self, ackMsg) -- [54812]活动状态 -- 格斗之王 
	local State   = tonumber(ackMsg : getState())      
	print("CMyGameLayerMediator.ACK_WRESTLE_STATE 活动状态",State)
	self : getView() : NetWorkReturn_WRESTLE_STATE(State) --sever methond
end














