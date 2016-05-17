require "mediator/mediator"


CKingHegemonyLayerMediator = class(mediator, function(self, _view)
	self.name = "KingHegemonyLayerMediatorr"
	self.view = _view
end)


function CKingHegemonyLayerMediator.getView(self)
	return self.view
end

function CKingHegemonyLayerMediator.getName(self)
	return self.name
end

function CKingHegemonyLayerMediator.getUserName(self)
	return self.user_name
end

function CKingHegemonyLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给我的比赛页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()


		-- if msgID == _G.Protocol["ACK_WRESTLE_STATE"] then  -- [54812]活动状态 -- 格斗之王 
		-- 	print("CFunQuizLayerMediator收到竞猜状态返回协议,ackMessage:getMsgID===",msgID)
		-- 	self : ACK_WRESTLE_STATE( ackMsg )
		-- end

		if msgID == _G.Protocol["ACK_WRESTLE_ZHENGBA_REQUEST"] then -- [54920]争霸信息返回 -- 格斗之王 
			print("CFunQuizLayerMediator收到 竞技水晶更新 返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_ZHENGBA_REQUEST( ackMsg )
		end

		if msgID == _G.Protocol["ACK_WRESTLE_TIME"] then  -- [54805]各种倒计时 -- 格斗之王
			print("CUpperHalfLayerMediator收到各种倒计时返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_WRESTLE_TIME( ackMsg )
		end
	end

	return false
end


function CKingHegemonyLayerMediator.ACK_WRESTLE_STATE(self, ackMsg)  -- [54812]活动状态 -- 格斗之王
	local State  = tonumber(ackMsg : getState())
	print("CKingHegemonyLayerMediator.ACK_WRESTLE_STATE 活动状态",State)
	self : getView() : NetWorkReturn_WRESTLE_STATE(State) --sever methond
end

function CKingHegemonyLayerMediator.ACK_WRESTLE_ZHENGBA_REQUEST(self, ackMsg)  -- [54930]竞技水晶更新 -- 格斗之王 
	local Name  = ackMsg : getName()
	local Lv    = ackMsg : getLv()
	local Power = ackMsg : getPower()
	local Pro   = tonumber(ackMsg : getPro())

	print("CKingHegemonyLayerMediator.ACK_WRESTLE_ZHENGBA_REQUEST 争霸信息返回",State,Lv,Power,Pro)

	self : getView() : pushData(Name,Lv,Power,Pro) --sever methond
end

function CKingHegemonyLayerMediator.ACK_WRESTLE_TIME(self, ackMsg) -- [54805]各种倒计时 -- 格斗之王  

    local end_time   = tonumber(ackMsg : getEndTime())
	--local Value   = tonumber(ackMsg : getValue())
	print("CKingHegemonyLayerMediator.ACK_WRESTLE_TIME 各种倒计时")
    local now        = _G.g_ServerTime : getServerTimeSeconds()
    local endTime    = tonumber(ackMsg : getEndTime())      --结束时间
    local startTime  = tonumber(ackMsg : getStartTime())  --开始时间
    print("print the time = ",now,endTime,startTime)
    print("true time ======",endTime-startTime)
    
    if State ~= nil and State == 3 then
       	self : getView() : NetWorkReturn_WRESTLE_TIME(nowtime,endTime,startTime) --sever methond
    end
    self : getView() : NetWorkReturn_WRESTLE_STATE(State)         --sever methond
end








