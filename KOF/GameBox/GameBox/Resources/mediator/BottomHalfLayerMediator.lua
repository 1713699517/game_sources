require "mediator/mediator"


CBottomHalfLayerMediator = class(mediator, function(self, _view)
	self.name = "BottomHalfLayerMediator"
	self.view = _view
end)

_G.g_CBottomHalfLayerMediator = CBottomHalfLayerMediator ()

function CBottomHalfLayerMediator.getView(self)
	return self.view
end

function CBottomHalfLayerMediator.getName(self)
	return self.name
end

function CBottomHalfLayerMediator.getUserName(self)
	return self.user_name
end

function CBottomHalfLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给下半区页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_WRESTLE_FINAL_INFO"] then  -- [54870]决赛对阵信息返回 -- 格斗之王 
			print("CUpperHalfLayerMediator收到决赛对阵信息返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_FINAL_INFO( ackMsg )
		end
		-- if msgID == _G.Protocol["ACK_WRESTLE_STATE"] then  -- [54870]活动状态 -- 格斗之王 
		-- 	print("CUpperHalfLayerMediator收到活动状态返回协议,ackMessage:getMsgID===",msgID)
		-- 	self : ACK_WRESTLE_STATE( ackMsg )
		-- end
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



function CBottomHalfLayerMediator.ACK_WRESTLE_FINAL_INFO(self, ackMsg) -- [54870]决赛对阵信息返回 -- 格斗之王 
	local Count = tonumber(ackMsg : getCount())
	local Msg   = ackMsg : getMsg() 
	-- print("CBottomHalfLayerMediator.ACK_WRESTLE_FINAL_INFO 决赛对阵信息返回",Count,#Msg)
	-- self : getView() : pushData(Count,Msg) --sever methond
	local upperMsg = {}
	local count    = 0 
	for k,v in pairs(Msg) do
		if tonumber(v.type) == 1 then
			count = count + 1
			upperMsg[count] = {}
			upperMsg[count] = v
		end   
	end
	print("CUpperHalfLayerMediator.ACK_WRESTLE_FINAL_INFO 决赛对阵信息返回",count,#upperMsg)
	self : getView() : pushData(count,upperMsg) --sever methond
end

function CBottomHalfLayerMediator.ACK_WRESTLE_STATE(self, ackMsg) -- [54870]决赛对阵信息返回 -- 格斗之王 
	local State = tonumber(ackMsg : getState())
	print("CBottomHalfLayerMediator.ACK_WRESTLE_STATE 活动状态",State)
	self : getView() : NetWorkReturn_WRESTLE_STATE(State) --sever methond
end

function CBottomHalfLayerMediator.ACK_WRESTLE_TIME(self, ackMsg) -- [54805]各种倒计时 -- 格斗之王 
	local State      = tonumber(ackMsg : getState())
	--local Value   = tonumber(ackMsg : getValue())
	print("CBottomHalfLayerMediator.ACK_WRESTLE_TIME 各种倒计时")
    local now        = _G.g_ServerTime : getServerTimeSeconds()
    local endTime    = tonumber(ackMsg : getEndTime())      --结束时间
    local startTime  = tonumber(ackMsg : getStartTime())  --开始时间
    print("print the time = ",now,endTime,startTime)
    print("true time ======",endTime-startTime)
    
    if State ~= nil and State == 2 then
       	--self : getView() : NetWorkReturn_WRESTLE_TIME(Type,Value) --sever methond
    end
    self : getView() : NetWorkReturn_WRESTLE_STATE(State) --sever methond
end

function CBottomHalfLayerMediator.ACK_WRESTLE_FINAL_REP(self, ackMsg)  -- (手动) -- [54940]决赛信息2 -- 格斗之王  
	local Type     = tonumber(ackMsg : getType())  -- {上半区0|下半区:1}
    local Turn     = ackMsg : getTurn()            -- {当前轮次}
    local Count    = tonumber(ackMsg : getCount()) -- {信息块数量}
    local Msg      = ackMsg : getMsg()             -- 信息块
    if  Type == 1 then
    	self : getView() : NetWorkReturn_WRESTLE_FINAL_REP(Turn,Count,Msg) --sever methond
    end
end










