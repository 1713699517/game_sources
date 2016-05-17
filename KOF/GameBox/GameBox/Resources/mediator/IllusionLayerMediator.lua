require "mediator/mediator"


CIllusionLayerMediator = class(mediator, function(self, _view)
	self.name = "IllusionLayerMediator"
	self.view = _view
end)


function CIllusionLayerMediator.getView(self)
	return self.view
end

function CIllusionLayerMediator.getName(self)
	return self.name
end

function CIllusionLayerMediator.getUserName(self)
	return self.user_name
end

function CIllusionLayerMediator.processCommand(self,_command)
	print("_command==============",_command)

	--接受服务端发回商店结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给魔宠页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_PET_HH_REPLY_MSG"] then  -- [23010]幻化界面返回 -- 宠物
			print("CIllusionLayerMediator收到返回幻化列表协议,ackMessage:getMsgID===",msgID)
			self : ACK_PET_HH_REPLY_MSG( ackMsg )
		end

		if msgID == _G.Protocol["ACK_PET_HUANHUA_REPLY"] then  -- [22950]幻化成功返回 -- 宠物 
			print("CIllusionLayerMediator收到开启式神ok协议,ackMessage:getMsgID===",msgID)
			self : ACK_PET_HUANHUA_REPLY( ackMsg )
		end
	end

	return false
end


function CIllusionLayerMediator.ACK_PET_HH_REPLY_MSG(self, ackMsg)   -- [23010]幻化界面返回 -- 宠物

  	local Count    = ackMsg : getCount()      -- {皮肤数量}
  	local SkinId   = ackMsg : getSkinId()     -- {使用中的皮肤id}
	local MsgSkin  = ackMsg : getMsgSkin()   -- {皮肤id}
		 

	print("CIllusionLayerMediator.ACK_PET_HH_REPLY_MSG",Count,SkinId,#MsgSkin,MsgSkin)
	self : getView() : pushData(Count,SkinId,MsgSkin) --sever methond
 
end

function CIllusionLayerMediator.ACK_PET_HUANHUA_REPLY(self, ackMsg)   -- [22950]幻化成功返回 -- 宠物
	local Type    = tonumber(ackMsg : getType())     -- {1为成幻化2为失败}
	print("CIllusionLayerMediator.ACK_PET_HUANHUA_REPLY 幻化成功",Type)
	self : getView() : NetWorkReturn_HUANHUA_REPLY(Type) --sever methond
end
















