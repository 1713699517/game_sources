--*********************************
--2013-8-12 by 陈元杰
--翻翻乐界面的Mediator-CFurinkazanMediator
--*********************************

require "mediator/mediator"

CFurinkazanMediator = class(mediator, function(self, _view)
	self.name = "CFurinkazanMediator"
	self.view = _view
end)

function CFurinkazanMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_FLSH_PAI_REPLY"] then 
			-- 50240	 牌语返回
			--CCMessageBox( "界面返回数据", ackMsg:getTimes() )
			self : ACK_FLSH_PAI_REPLY( ackMsg )
		elseif msgID == _G.Protocol["ACK_FLSH_REWARD_OK"] then 
			self :ACK_FLSH_REWARD_OK( ackMsg )
		end
		
	end
	return false
end


-- 50240	 牌语返回
function CFurinkazanMediator.ACK_FLSH_PAI_REPLY( self, _ackMsg )
	local times = _ackMsg :getTimes()
	local data  = _ackMsg :getData()
	print("^^^^^^^^^^^^^^^^^^^^^^")
	print(times,data)
	print("^^^^^^^^^^^^^^^^^^^^^^")
	if data ~= nil then 
		self :getView() :statdCallBackForMediator( times, data )
	end
end

function CFurinkazanMediator.ACK_FLSH_REWARD_OK( self, _ackMsg )

	local sz_num   = _ackMsg :getSzNum()
	local same_num = _ackMsg :getSameNum()
	local dz_num   = _ackMsg :getDzNum()
	local id  	   = tostring(sz_num).."_"..tostring(same_num).."_"..tostring(dz_num)

	self :getView() :getRewardCallBackForMediator( id )
end
