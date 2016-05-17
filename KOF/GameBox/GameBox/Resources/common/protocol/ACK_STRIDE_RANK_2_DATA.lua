
require "common/AcknowledgementMessage"

-- [43551]三界争霸/巅峰之战排行榜数据块 -- 跨服战 

ACK_STRIDE_RANK_2_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_RANK_2_DATA
	self:init()
end)

-- {昨日排名}
function ACK_STRIDE_RANK_2_DATA.getZrank(self)
	return self.zrank
end

-- {排名}
function ACK_STRIDE_RANK_2_DATA.getRank(self)
	return self.rank
end

-- {服务器ID}
function ACK_STRIDE_RANK_2_DATA.getSid(self)
	return self.sid
end

-- {玩家UID}
function ACK_STRIDE_RANK_2_DATA.getUid(self)
	return self.uid
end

-- {玩家姓名}
function ACK_STRIDE_RANK_2_DATA.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_STRIDE_RANK_2_DATA.getNameColcor(self)
	return self.name_colcor
end

-- {玩家等级}
function ACK_STRIDE_RANK_2_DATA.getLv(self)
	return self.lv
end

-- {性别}
function ACK_STRIDE_RANK_2_DATA.getSex(self)
	return self.sex
end

-- {职业}
function ACK_STRIDE_RANK_2_DATA.getPro(self)
	return self.pro
end

-- {1:可挑战 0:不能挑战}
function ACK_STRIDE_RANK_2_DATA.getIsWar(self)
	return self.is_war
end

-- {战斗力}
function ACK_STRIDE_RANK_2_DATA.getPower(self)
	return self.power
end

-- {级别组}
function ACK_STRIDE_RANK_2_DATA.getGourp(self)
	return self.gourp
end

-- {战斗积分}
function ACK_STRIDE_RANK_2_DATA.getArg(self)
	return self.arg
end

-- {昨日积分}
function ACK_STRIDE_RANK_2_DATA.getZarg(self)
	return self.zarg
end

-- {伙伴数量}
function ACK_STRIDE_RANK_2_DATA.getCount(self)
	return self.count
end

-- {信息块(43552)}
function ACK_STRIDE_RANK_2_DATA.getData(self)
	return self.data
end
