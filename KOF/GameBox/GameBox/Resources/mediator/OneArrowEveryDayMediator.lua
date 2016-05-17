--*********************************
--2013-8-8 by 陈元杰
--每日一箭界面的Mediator-COneArrowEveryDayMediator
--*********************************

require "mediator/mediator"

COneArrowEveryDayMediator = class(mediator, function(self, _view)
	self.name = "COneArrowEveryDayMediator"
	self.view = _view
	self.isShoot = false
end)


function COneArrowEveryDayMediator.setIsShoot( self, _isShoot )
	self.isShoot = _isShoot
end

function COneArrowEveryDayMediator.getIsShoot( self )
	return self.isShoot
end

function COneArrowEveryDayMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_SHOOT_REPLY"] then 
			--[51220]	 每日一箭返回
			--CCMessageBox( "界面返回数据", "提示" )
			self : ACK_SHOOT_REPLY( ackMsg )
		end
		
	end
	return false
end


--[51220]	 每日一箭返回
function COneArrowEveryDayMediator.ACK_SHOOT_REPLY( self, _ackMsg )

	if self.isShoot then 
		self.isShoot = false
		self :getView() :shootCallBackForMediator( )
	end

	local freeTimes = _ackMsg :getFreeTime() -- 免费次数
	local purchaseTime  = _ackMsg :getPurchaseTime() -- 剩余购买次数
	local nowTotalMoney = _ackMsg :getMoney() -- 奖池金额
	local maxRewardName = _ackMsg :getName() -- 获奖玩家名字 至尊奖
	local maxRewardGold = _ackMsg :getAst_award() -- 获得金额 至尊奖
	local headInfo  = _ackMsg :getHeadInfo() -- 头像信息块
	local awardInfo = _ackMsg :getAwardInfo() -- 获取其他玩家获奖信息块

	self :getView() :resetFreeTimesLabel( freeTimes )
	self :getView() :resetBuyTimesSurplusLabel( purchaseTime )
	self :getView() :resetTotalGoldLabel( nowTotalMoney )

	if maxRewardName~="" and maxRewardName~=nil and maxRewardGold>0 then 
		self :getView() :resetMaxRewardLabel( maxRewardName, maxRewardGold )
	end

	--if #headInfo > 0 then
		self :getView() :resetArrowLayout( headInfo )
	--end
	
	if #awardInfo > 0 then 
		self :getView() :resetLargeRewardConTainer( awardInfo )
	end
end
