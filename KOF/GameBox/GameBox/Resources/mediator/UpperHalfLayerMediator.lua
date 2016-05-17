require "mediator/mediator"


CUpperHalfLayerMediator = class(mediator, function(self, _view)
	self.name = "UpperHalfLayerMediator"
	self.view = _view
end)


function CUpperHalfLayerMediator.getView(self)
	return self.view
end

function CUpperHalfLayerMediator.getName(self)
	return self.name
end

function CUpperHalfLayerMediator.getUserName(self)
	return self.user_name
end

function CUpperHalfLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给上半区页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_WRESTLE_FINAL_INFO"] then  -- [54870]决赛对阵信息返回 -- 格斗之王 
			print("CUpperHalfLayerMediator收到决赛对阵信息返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_FINAL_INFO( ackMsg )
		end
		if msgID == _G.Protocol["ACK_WRESTLE_TIME"] then  -- [54805]各种倒计时 -- 格斗之王
			print("CUpperHalfLayerMediator收到各种倒计时返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_TIME( ackMsg )
		end

		if msgID == _G.Protocol["ACK_WRESTLE_FINAL_REP"] then  -- (手动) -- [54940]决赛信息2 -- 格斗之王
			print("CUpperHalfLayerMediator收到决赛对阵信息返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_FINAL_REP( ackMsg )
		end
	end

	return false
end


function CUpperHalfLayerMediator.ACK_WRESTLE_FINAL_INFO(self, ackMsg) -- [54870]决赛对阵信息返回 -- 格斗之王 
	local Count    = tonumber(ackMsg : getCount())
	local Msg      = ackMsg : getMsg() 
	local upperMsg = {}
	local count    = 0 
	local lunci    = 0 
	for k,v in pairs(Msg) do
		if tonumber(v.type) == 0 then
			count = count + 1
			upperMsg[count] = {}
			upperMsg[count] = v
			lunci = v.lunci
		end   
	end
	print("CUpperHalfLayerMediator.ACK_WRESTLE_FINAL_INFO 决赛对阵信息返回",count,#upperMsg,lunci)
	self : getView() : pushData(count,upperMsg,lunci) --sever methond
end

function CUpperHalfLayerMediator.ACK_WRESTLE_STATE(self, ackMsg) -- [54870]决赛对阵信息返回 -- 格斗之王 
	local State = tonumber(ackMsg : getState())
	print("CUpperHalfLayerMediator.ACK_WRESTLE_STATE 活动状态",State)
	self : getView() : NetWorkReturn_WRESTLE_STATE(State) --sever methond
end

function CUpperHalfLayerMediator.ACK_WRESTLE_TIME(self, ackMsg) -- [54805]各种倒计时 -- 格斗之王  
	local State      = tonumber(ackMsg : getState())

	--local Value   = tonumber(ackMsg : getValue())
	print("CUpperHalfLayerMediator.ACK_WRESTLE_TIME 各种倒计时")
    local now        = _G.g_ServerTime : getServerTimeSeconds()
    local endTime    = tonumber(ackMsg : getEndTime())      --结束时间
    local startTime  = tonumber(ackMsg : getStartTime())  --开始时间
    print("print the time = ",now,endTime,startTime)
    print("true time ======",endTime-startTime)
    
    if State ~= nil and State == 1 then
       	self : getView() : NetWorkReturn_WRESTLE_TIME(now,endTime,startTime) --sever methond
    end
    self : getView() : NetWorkReturn_WRESTLE_STATE(State)         --sever methond
end

function CUpperHalfLayerMediator.ACK_WRESTLE_FINAL_REP(self, ackMsg)  -- (手动) -- [54940]决赛信息2 -- 格斗之王  
	local Type     = tonumber(ackMsg : getType())  -- {上半区0|下半区:1}
    local Turn     = ackMsg : getTurn()            -- {当前轮次}
    local Count    = tonumber(ackMsg : getCount()) -- {信息块数量}
    local Msg      = ackMsg : getMsg()             -- 信息块
    if  Type == 0 then
    	self : getView() : NetWorkReturn_WRESTLE_FINAL_REP(Turn,Count,Msg) --sever methond
    end
end









