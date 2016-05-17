require "mediator/mediator"
require "controller/BuildTeamCommand"


CBuildTeamMediator = class(mediator, function(self, _view)
	self.name = "BuildTeamMediator"
	self.view = _view
	self.thedata      = {}
	self.thedataCount = nil
	self.thedataType  = nil
end)

function CBuildTeamMediator.getView(self)
	return self.view
end

function CBuildTeamMediator.getName(self)
	return self.name
end

function CBuildTeamMediator.getUserName(self)
	return self.user_name
end

function CBuildTeamMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给组队界面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_TEAM_REPLY"] then  --队伍面板回复 3520
			CCLOG("CBuildTeamMediator收到队伍面板回复协议,ackMessage:getMsgID===")
			self : ACK_TEAM_REPLY( ackMsg )
		end

		if msgID == _G.Protocol["ACK_TEAM_PASS_REPLY"] then  -- [3550]通关副本返回 -- 组队系统
			print("CBuildTeamMediator收到队伍面板回复协议,ackMessage:getMsgID===",msgID)
			self : ACK_TEAM_PASS_REPLY( ackMsg )
		end
	end

	self.transfSceneId = 0
	if _command:getType() == CBuildTeamCommand.TYPE  then
        print("CBuildTeamCommand.TYPE------>",_command : getData())
        self.transfSceneId = _command : getData()
        self:getView() : pushTransfData(self.thedataType,self.thedataCount,self.thedata,self.transfSceneId)
    end

	return false
end

function CBuildTeamMediator.ACK_TEAM_REPLY(self, ackMsg)   --队伍面板回复 3520
	CCLOG("CBuildTeamMediator进入到队伍面板回复协议处理方法")
    local Type  = ackMsg : getType()
    local Count = ackMsg : getCount()
    local Msg   = ackMsg :getMsg()

    -- for k,v in pairs(Msg) do
    -- 	print(k,v,v.leader_name)
    -- end

    CCLOG("CBuildTeamMediator.ACK_TEAM_REPLY-->"..Type..Count..#Msg)
	self:getView() : pushData(Type,Count,Msg)
	CCLOG("CBuildTeamMediator队伍面板回复协议方法处理完毕～～")
	self.thedata      = Msg
	self.thedataCount = Count
	self.thedataType  = Type

end

function CBuildTeamMediator.ACK_TEAM_PASS_REPLY(self, ackMsg)  -- [3550]通关副本返回 -- 组队系统
	print("CBuildTeamMediator进入到通关副本返回复协议处理方法1011")
    local Type  = ackMsg : getType()
    local Count = ackMsg : getCount()
    local Msg   = ackMsg :getMsg()
    for k,v in pairs(Msg) do
    	print(k,v.copy_id)
    end
    print("CBuildTeamMediator.ACK_TEAM_PASS_REPLY-->",Type,Count,Msg,#Msg)
	self:getView() : getCopyListDataFromSever(Type,Count,Msg)
	print("CBuildTeamMediator通关副本返回协议方法处理完毕～～")
end






















