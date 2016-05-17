require "mediator/mediator"


CInviteTeammatesMediator = class(mediator, function(self, _view)
	self.name = "InviteTeammatesMediator"
	self.view = _view
end)


function CInviteTeammatesMediator.getView(self)
	return self.view
end

function CInviteTeammatesMediator.getName(self)
	return self.name
end

function CInviteTeammatesMediator.getUserName(self)
	return self.user_name
end

function CInviteTeammatesMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())

	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给组队邀请好友界面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()
 
        if msgID == _G.Protocol["ACK_FRIEND_INFO"] then          -- (手动) -- [4020]返回好友信息 -- 好友
            self : ACK_FRIEND_INFO( ackMsg)
        end
        if msgID == _G.Protocol["ACK_CLAN_OK_MEMBER_LIST"] then  -- [33140]返回社团成员列表 -- 社团 
            self : ACK_CLAN_OK_MEMBER_LIST( ackMsg)
        end
	end
	return false
end

function CInviteTeammatesMediator.ACK_FRIEND_INFO(self, ackMsg)    -- (手动) -- [4020]返回好友信息 -- 好友

	print("CInviteTeammatesMediator进入返回好友信息协议处理方法")

    local Type  = ackMsg : getType()  -- {返回好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
    local Count = ackMsg : getCount() -- {好友数量}
    local Msg   = ackMsg : getData()  -- {好友信息块}
    
    print("CInviteTeammatesMediator.ACK_FRIEND_INFO-->",Type,Count,Msg)
    
	self:getView() : pushData(Count,Msg,1)

	print("CInviteTeammatesMediator队返回好友信息协议方法处理完毕～～")
end

function CInviteTeammatesMediator.ACK_CLAN_OK_MEMBER_LIST(self, ackMsg)    -- [33140]返回社团成员列表 -- 社团 

	print("CInviteTeammatesMediator进入返回社团信息协议处理方法")

    local Count = ackMsg : getCount()      -- {社团成员数量}
    local Msg   = ackMsg : getMemberMsg()  -- {社团成员信息块}
    local myuid = _G.g_characterProperty:getMainPlay():getUid()
    local data  = {}
    local MsgNo = 0 
    for k,v in pairs(Msg) do
    	print(k,v)
    	if tonumber(v.uid) ~= tonumber(myuid) then
    		MsgNo = MsgNo + 1
    		data[MsgNo] = {}
    		data[MsgNo] = v 
    	end
    end
    
    print("CInviteTeammatesMediator.ACK_CLAN_OK_MEMBER_LIST-->",Type,Count,Msg,"======",MsgNo,data)
    
	-- self:getView() : pushData(Count,Msg,2)
	self:getView() : pushData(MsgNo,data,2)

	print("CInviteTeammatesMediator队返回社团信息协议方法处理完毕～～")
end
-- self.data[i].fid        = reader:readInt32Unsigned()
-- self.data[i].fname      = reader:readString()
-- self.data[i].fclan      = reader:readInt8Unsigned()
-- self.data[i].flv        = reader:readInt8Unsigned()
-- self.data[i].isonline   = reader:readInt16Unsigned()
-- self.data[i].pro        = reader:readInt8Unsigned()

function CInviteTeammatesMediator.getMySelfUid(self) 

end





















