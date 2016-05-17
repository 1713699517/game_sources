
require "common/AcknowledgementMessage"

-- [45755]战报数据 -- 活动-阵营战 

ACK_CAMPWAR_WAR_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_WAR_DATA
	self:init()
end)

-- {战报类型：CONST_CAMPWAR_TYPE_*}
function ACK_CAMPWAR_WAR_DATA.getType(self)
	return self.type
end

-- {胜方阵营}
function ACK_CAMPWAR_WAR_DATA.getYCamp(self)
	return self.y_camp
end

-- {胜方服务器id}
function ACK_CAMPWAR_WAR_DATA.getYSid(self)
	return self.y_sid
end

-- {胜方玩家uid}
function ACK_CAMPWAR_WAR_DATA.getYUid(self)
	return self.y_uid
end

-- {胜方名字}
function ACK_CAMPWAR_WAR_DATA.getYName(self)
	return self.y_name
end

-- {胜方名字颜色}
function ACK_CAMPWAR_WAR_DATA.getYNameColor(self)
	return self.y_name_color
end

-- {胜方连胜次数}
function ACK_CAMPWAR_WAR_DATA.getYWars(self)
	return self.y_wars
end

-- {败方阵营}
function ACK_CAMPWAR_WAR_DATA.getNCamp(self)
	return self.n_camp
end

-- {战败服务器id}
function ACK_CAMPWAR_WAR_DATA.getNSid(self)
	return self.n_sid
end

-- {战败玩家uid}
function ACK_CAMPWAR_WAR_DATA.getNUid(self)
	return self.n_uid
end

-- {战败名字}
function ACK_CAMPWAR_WAR_DATA.getNName(self)
	return self.n_name
end

-- {战败名字颜色}
function ACK_CAMPWAR_WAR_DATA.getNNameColor(self)
	return self.n_name_color
end

-- {战败连胜次数}
function ACK_CAMPWAR_WAR_DATA.getNWars(self)
	return self.n_wars
end

-- {战报id：0无战报}
function ACK_CAMPWAR_WAR_DATA.getShowId(self)
	return self.show_id
end

-- {数量}
function ACK_CAMPWAR_WAR_DATA.getCount(self)
	return self.count
end

-- {奖励数据块【45677】}
function ACK_CAMPWAR_WAR_DATA.getRewardsMsg(self)
	return self.rewards_msg
end
