require "mediator/mediator"


CFamiliarLayerMediator = class(mediator, function(self, _view)
	self.name = "FamiliarLayerMediator"
	self.view = _view
end)

_G.g_CFamiliarLayerMediator = CFamiliarLayerMediator ()

function CFamiliarLayerMediator.getView(self)
	return self.view
end

function CFamiliarLayerMediator.getName(self)
	return self.name
end

function CFamiliarLayerMediator.getUserName(self)
	return self.user_name
end

function CFamiliarLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	--接受服务端发回商店结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给魔宠页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_PET_REVERSE"] then  -- [22820]返回宠物列表 -- 宠物 
			print("CFamiliarLayerMediator收到返回宠物列表协议,ackMessage:getMsgID===",msgID)
			self : ACK_PET_REVERSE( ackMsg )
		end

		if msgID == _G.Protocol["ACK_PET_OPEN_OK"] then  -- (手动) -- [22840]开启式神ok -- 宠物 
			print("CFamiliarLayerMediator收到开启式神ok协议,ackMessage:getMsgID===",msgID)
			self : ACK_PET_OPEN_OK( ackMsg )
		end

		if msgID == _G.Protocol["ACK_PET_CALL_OK"] then  -- (手动) -- [22860]召唤式神成功返回 -- 宠物
			print("CFamiliarLayerMediator 召唤式神成功返回,ackMessage:getMsgID===",msgID)
			self : ACK_PET_CALL_OK( ackMsg )
		end

		if msgID == _G.Protocol["ACK_PET_NEED_RMB_REPLY"] then  -- (手动) -- [22875]修炼需要钻石返回 -- 宠物 
			print("CFamiliarLayerMediator 修炼需要钻石返回,ackMessage:getMsgID===",msgID)
			self : ACK_PET_NEED_RMB_REPLY( ackMsg )
		end

		if msgID == _G.Protocol["ACK_PET_XIULIAN_OK"] then  -- (手动) -- [22885]魔宠修炼成功返回 -- 宠物 
			print("CFamiliarLayerMediator 魔宠修炼成功返回,ackMessage:getMsgID===",msgID)
			self : ACK_PET_XIULIAN_OK( ackMsg )
		end
	end

	return false
end


function CFamiliarLayerMediator.ACK_PET_REVERSE(self, ackMsg)   -- [22820]返回宠物列表 -- 宠物 

  	local Lv       = ackMsg : getLv()       -- {宠物等级}
	local SkinId   = ackMsg : getSkinId()   -- {皮肤id}
	local SkillId  = ackMsg : getSkillId()  -- {技能id}
	local Exp      = ackMsg : getExp()      -- {当前经验值}
	local Count    = ackMsg : getCount()    -- {式神数量}
	local MsgSkill = ackMsg : getMsgSkill() -- {技能信息块(22825)} 
	local Count2   = ackMsg : getCount2()   -- {皮肤数量}	
	local MsgSkin  = ackMsg : getMsgSkin()  -- {皮肤信息块(22827)} 		 

	print("CFamiliarLayerMediator.ACK_PET_REVERSE",Lv,SkinId,SkillId,Exp,Count,#MsgSkill,Count2,#MsgSkin)
	self : getView() : pushData(Lv,SkinId,SkillId,Exp,Count,MsgSkill,Count2,MsgSkin) --sever methond
 
end

function CFamiliarLayerMediator.ACK_PET_OPEN_OK(self, ackMsg)   -- (手动) -- [22840]开启式神ok -- 宠物

	print("CFamiliarLayerMediator.ACK_PET_OPEN_OK 开启式神ok")
end

function CFamiliarLayerMediator.ACK_PET_CALL_OK(self, ackMsg)  -- (手动) -- [22860]召唤式神成功返回 -- 宠物

	print("CFamiliarLayerMediator.ACK_PET_CALL_OK 召唤式神成功返回")
	self : getView() : NetWorkReturn_CALL_OK()   
end

function CFamiliarLayerMediator.ACK_PET_NEED_RMB_REPLY(self, ackMsg)  -- (手动) -- [22875]修炼需要钻石返回 -- 宠物

	local Rmb       = ackMsg : getRmb()       -- {钻石数}
	self : getView() : NetWorkReturn_NEED_RMB(Rmb)
	print("CFamiliarLayerMediator.ACK_PET_NEED_RMB_REPLY 修炼需要钻石返回 Rmb=",Rmb) 
end

function CFamiliarLayerMediator.ACK_PET_XIULIAN_OK(self, ackMsg)  -- (手动) -- [22885]魔宠修炼成功返回 -- 宠物

	print("CFamiliarLayerMediator.ACK_PET_XIULIAN_OK 魔宠修炼成功返回 ") 
end















