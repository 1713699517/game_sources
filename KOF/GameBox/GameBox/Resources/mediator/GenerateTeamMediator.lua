require "mediator/mediator"


CGenerateTeamMediator = class(mediator, function(self, _view)
	self.name = "GenerateTeamMediator"
	self.view = _view
end)


function CGenerateTeamMediator.getView(self)
	return self.view
end

function CGenerateTeamMediator.getName(self)
	return self.name
end

function CGenerateTeamMediator.getUserName(self)
	return self.user_name
end

function CGenerateTeamMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给队伍信息返回界面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_TEAM_TEAM_INFO_NEW"] then  -- [3572]队伍信息返回 -- 组队系统 
			print("CGenerateTeamMediator收到队伍信息返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_TEAM_TEAM_INFO_NEW( ackMsg )
		end

		if msgID == _G.Protocol["ACK_TEAM_LEAVE_NOTICE"] then  -- [3620]离队通知 -- 组队系统
			print("CGenerateTeamMediator收到离队通知返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_TEAM_LEAVE_NOTICE( ackMsg )
		end
	end
	return false
end

function CGenerateTeamMediator.ACK_TEAM_TEAM_INFO_NEW(self, ackMsg)   -- [3572]队伍信息返回 -- 组队系统

	print("CGenerateTeamMediator进入到队伍信息返回协议处理方法")

	local team_id    = ackMsg : getTeamId()    -- {队伍ID}
	local copy_id    = ackMsg : getCopyId()    -- {副本ID}
	local leader_uid = ackMsg : getLeaderUid() -- {队长Uid}
	local count      = ackMsg : getCount()     -- {成员数量}
    local Msg        = ackMsg : getData()      -- {成员信息块(3590)}
    
    print("CGenerateTeamMediator.ACK_TEAM_TEAM_INFO_NEW-->",team_id,copy_id,leader_uid,leader_uid,count,Msg,#Msg)
    for k,v in pairs(Msg) do
    	print("--->",k,v.name,v.pos,v.clan_name)
    	for kk,vv in pairs(v) do
    		print(kk,vv)
    	end
    end
    
	self:getView() : pushData(team_id,leader_uid,copy_id,Msg)

	print("CGenerateTeamMediator队伍信息返回协议方法处理完毕～～")
end

function CGenerateTeamMediator.ACK_TEAM_LEAVE_NOTICE(self, ackMsg)   -- [3620]离队通知 -- 组队系统

	print("CGenerateTeamMediator离队通知返回协议处理方法",ackMsg : getReason())
    local Reason        = ackMsg : getReason()       -- {离队原因(CONST_TEAM_OUT_*)}
	self:getView()      : leaveNotice(Reason)
	print("CGenerateTeamMediator离队通知协议方法处理完毕～～")
end























