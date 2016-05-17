
require "common/AcknowledgementMessage"

-- [6020]战斗数据 -- 战斗 

ACK_WAR_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_DATA
	self:init()
end)

-- {战斗类型(打怪/PK)见CONST_WAR_TYPE_* 切磋:CONST_WAR_PARAS_PK2}
function ACK_WAR_DATA.getType(self)
	return self.type
end

-- {背景}
function ACK_WAR_DATA.getMapType(self)
	return self.map_type
end

-- {怪物组ID}
function ACK_WAR_DATA.getMonstergroundid(self)
	return self.monstergroundid
end

-- {是否有BOSS参战0:没有，1有}
function ACK_WAR_DATA.getIsBoosWar(self)
	return self.is_boos_war
end

-- {左边战斗单元个数}
function ACK_WAR_DATA.getLeftCount(self)
	return self.left_count
end

-- {玩家/怪物数据结构(6001)}
function ACK_WAR_DATA.getLeftXxx(self)
	return self.left_xxx
end

-- {右边战斗单元个数}
function ACK_WAR_DATA.getRightCount(self)
	return self.right_count
end

-- {玩家/怪物数据结构(6001)}
function ACK_WAR_DATA.getRightXxx(self)
	return self.right_xxx
end

-- {回合数}
function ACK_WAR_DATA.getRoundCount(self)
	return self.round_count
end

-- {指命数量}
function ACK_WAR_DATA.getCollCount(self)
	return self.coll_count
end

-- {指命集类型}
function ACK_WAR_DATA.getCollType(self)
	return self.coll_type
end

-- {战斗数据数}
function ACK_WAR_DATA.getComCount(self)
	return self.com_count
end

-- {指命类型(见:CONST_WAR_COM_*)}
function ACK_WAR_DATA.getComType(self)
	return self.com_type
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getSelfXx(self)
	return self.self_xx
end

-- {影响目个数}
function ACK_WAR_DATA.getToCount(self)
	return self.to_count
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getToXx(self)
	return self.to_xx
end

-- {技能ID}
function ACK_WAR_DATA.getSkillId(self)
	return self.skill_id
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getSelfXx2(self)
	return self.self_xx_2
end

-- {影响目个数}
function ACK_WAR_DATA.getToCount2(self)
	return self.to_count_2
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getToXx2(self)
	return self.to_xx_2
end

-- {炼体uid}
function ACK_WAR_DATA.getToUid(self)
	return self.to_uid
end

-- {最终炼体能量}
function ACK_WAR_DATA.getToTried(self)
	return self.to_tried
end

-- {左边或右边}
function ACK_WAR_DATA.getTriedPos(self)
	return self.tried_pos
end

-- {位置索引}
function ACK_WAR_DATA.getTriedIdx(self)
	return self.tried_idx
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getSelfXx5(self)
	return self.self_xx_5
end

-- {buff数量(循环)}
function ACK_WAR_DATA.getBuffCount(self)
	return self.buff_count
end

-- {buff效果ID}
function ACK_WAR_DATA.getBuffId(self)
	return self.buff_id
end

-- {buff叠加数量}
function ACK_WAR_DATA.getStackCount(self)
	return self.stack_count
end

-- {buff持续回合}
function ACK_WAR_DATA.getRoundCount2(self)
	return self.round_count_2
end

-- {Buff释放数量(循环)}
function ACK_WAR_DATA.getCount(self)
	return self.count
end

-- {Buff释放类型}
function ACK_WAR_DATA.getBuffType(self)
	return self.buff_type
end

-- {1:增加0:见血}
function ACK_WAR_DATA.getZType(self)
	return self.z_type
end

-- {Buff释放类型值}
function ACK_WAR_DATA.getValue(self)
	return self.value
end

-- {Buff释放对象数据结果包(6002)}
function ACK_WAR_DATA.getSelfXx6(self)
	return self.self_xx_6
end

-- {炸弹影响目个数}
function ACK_WAR_DATA.getZdCount(self)
	return self.zd_count
end

-- {数据结果包(6002)}
function ACK_WAR_DATA.getToXx22(self)
	return self.to_xx_22
end

-- {左边还是右边胜（CONST_WAR_POSITION_*）}
function ACK_WAR_DATA.getWin(self)
	return self.win
end
