require "mediator/mediator"


CKofCareerLayerMediator = class(mediator, function(self, _view)
	self.name = "KofCareerLayerMediator"
	self.view = _view
end)


function CKofCareerLayerMediator.getView(self)
	return self.view
end

function CKofCareerLayerMediator.getName(self)
	return self.name
end

function CKofCareerLayerMediator.getUserName(self)
	return self.user_name
end

function CKofCareerLayerMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回镶嵌结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给拳皇生涯页面<<<<<<<<<<<<<<<<<<<<<<")
		local msgID = _command :getProtocolID()
		print("ackMessage:getMsgID===",msgID)
		local ackMsg = _command:getAckMessage()


		if msgID == _G.Protocol["ACK_FIGHTERS_CHAP_DATA"] then  -- [55820]当前章节信息返回 
			print("CKofCareerLayerMediator收到拳皇生涯数据返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_FIGHTERS_CHAP_DATA( ackMsg )
		end
		if msgID == _G.Protocol["ACK_FIGHTERS_BUY_OK"] then     -- [55850]购买挑战次数成功 -- 拳皇生涯 
			print("CKofCareerLayerMediator收到拳皇生涯购买挑战次数成功返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_FIGHTERS_BUY_OK( ackMsg )
		end
		if msgID == _G.Protocol["ACK_FIGHTERS_UP_REPLY"] then   -- [55870]挂机返回 -- 拳皇生涯
			print("CKofCareerLayerMediator收到拳皇生涯购挂机返回返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_FIGHTERS_UP_REPLY( ackMsg )
		end
		if msgID == _G.Protocol["ACK_FIGHTERS_UP_OVER"] then   -- [55880]挂机完成 -- 拳皇生涯 
			print("CKofCareerLayerMediator收到拳皇生涯挂机完成返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_FIGHTERS_UP_OVER( ackMsg )
		end
		if msgID == _G.Protocol["ACK_FIGHTERS_UP_RESET_OK"] then   -- [55970]重置挂机成功 -- 拳皇生涯
			print("CKofCareerLayerMediator收到拳皇生涯重置挂机成功返回协议,ackMessage:getMsgID===",msgID)
			self : ACK_FIGHTERS_UP_RESET_OK( ackMsg )
		end
	end
	return false
end


function CKofCareerLayerMediator.ACK_FIGHTERS_CHAP_DATA(self, ackMsg)   -- [55820]当前章节信息返回 
	print("CKofCareerLayerMediator进入到拳皇生涯数据协议处理方法")

	local chap        = ackMsg : getChap()       -- {当前章节}
	local next_chap   = ackMsg : getNextChap()   -- {下一章节 1：可去 | 0：不可去}
	local times       = ackMsg : getTimes()      -- {剩余挑战次数}
	local reset_times = ackMsg : getResetTimes() -- {剩余重置次数}
	local buy_times   = ackMsg : getBuyTimes()   -- {已购买挑战次数}	
	local Alre_times  = ackMsg : getAlre_times() -- {已重置次数}	
	local Reis_mo     = ackMsg : getReis_mon()   -- {重置是否免费(1:免费|0:不免费)}	

	local up_is       = ackMsg : getUpIs()       -- {是否挂机(1:是|0:不是)}
	local up_chap     = ackMsg : getUpChap()     -- {当前挂机章节}
	local up_copy     = ackMsg : getUpCopy()     -- {当前挂机副本}
	local count       = ackMsg : getCount()      -- {战役数量}
	local data        = ackMsg : getData()       -- {战役信息块(55830)}
	data              =  self : changeDataLocationById(data)

	print("CKofCareerLayerMediator.ACK_FIGHTERS_CHAP_DATA1==",chap,next_chap,times,reset_times,buy_times,Alre_times,Reis_mo)
	print("CKofCareerLayerMediator.ACK_FIGHTERS_CHAP_DATA2==",up_is,up_chap,up_copy,count,#data)

	self : getView() : pushData (chap,next_chap,times,reset_times,buy_times,Alre_times,Reis_mo,up_is,up_chap,up_copy,count,data)

	print("CKofCareerLayerMediator拳皇生涯数据返回协议处理方法处理完毕～～")
end

function CKofCareerLayerMediator.ACK_FIGHTERS_BUY_OK(self, ackMsg)     --[55850]购买挑战次数成功 -- 拳皇生涯 
	print("CKofCareerLayerMediator进入到拳皇生涯购买挑战次数成功处理方法",ackMsg : getTimes())
	local Times   = ackMsg : getTimes()   -- {当前剩余挑战次数}
	self : getView() : BuyOKNetWorkReturn(Times)
end

function CKofCareerLayerMediator.ACK_FIGHTERS_UP_REPLY(self, ackMsg)   -- [55870]挂机返回 -- 拳皇生涯
	print("CKofCareerLayerMediator进入到拳皇生涯挂机返回处理方法")
	local ChapId  = ackMsg : getChapId() -- {挂到这个章节}
	local CopyId  = ackMsg : getCopyId() -- {挂机这个副本}
	local Exp     = ackMsg : getExp()    -- {经验}
	local Gold    = ackMsg : getGold()   -- {铜钱}
	local Power   = ackMsg : getPower()  -- {战功}
	local Num     = ackMsg : getNum()    -- {物品数量}
	local Data    = ackMsg : getData()   -- {物品信息块}

	print("ChapId&CopyId==",ChapId,CopyId,Exp,Gold,Power,Num,Data)
	for k,v in pairs(Data) do
		print("-------->",k,v.goold_id,v.count)
	end
	self : getView() : HookNetWorkReturn(ChapId,CopyId,Num,Data,Gold)
	print("CKofCareerLayerMediator拳皇生涯挂机返回处理方法处理完毕～～")
end

function CKofCareerLayerMediator.ACK_FIGHTERS_UP_OVER(self, ackMsg)    -- [55880]挂机完成 -- 拳皇生涯 
	print("CKofCareerLayerMediator进入到拳皇生涯挂机完成成功处理方法")
	self : getView() : HookOKNetWorkReturn()
end

function CKofCareerLayerMediator.ACK_FIGHTERS_UP_RESET_OK(self, ackMsg)  -- [55970]重置挂机成功 -- 拳皇生涯
	print("CKofCareerLayerMediator进入到拳皇生涯重置挂机成功处理方法")
	local ResetTimes     = ackMsg : getResetTimes()      -- {剩余重置次数}
	local Reis_mon       = ackMsg : getReisMon()         -- {重置是否免费(1:免费|0:不免费)}
	local UpIs           = ackMsg : getUpIs()            -- {挂机状态 详见：CONST_FIGHTERS_UP*}
	local UpChan         = ackMsg : getUpChap()          -- {当前挂机章节}
	local UpCopy         = ackMsg : getUpCopy()          -- {当前挂机副本}
	print("ResetTimes&CoUpIspyId&UpChan&==",ResetTimes,Reis_mon,UpIs,UpChan,UpCopy)
	self : getView() : HookResetOKWorkReturn(ResetTimes,Reis_mon,UpIs,UpChan,UpCopy)
	print("CKofCareerLayerMediator拳皇生涯挂机返回处理方法处理完毕～～")
end

function CKofCareerLayerMediator.changeDataLocationById(self,_data)
	data  = _data
	count = #_data
	temp  = {}
	if  data ~= nil and count > 0  then
		for i = 1,count do
			for j=1,count-i do
				if tonumber(data[j].copy_id) > tonumber(data[j+1].copy_id) then
					temp      = data[j]
					data[j]   = data[j+1] 
					data[j+1] = temp
				end
			end
		end

	end
	print("重新排序后的结果")
	for k,v in pairs(data) do
		print("yy=====",k,v.copy_id)
	end
	return data
end















