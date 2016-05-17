
require "common/AcknowledgementMessage"

-- [5050]地图玩家数据 -- 场景 

ACK_SCENE_ROLE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_ROLE_DATA
	self:init()
end)

function ACK_SCENE_ROLE_DATA.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {详见：CONST_MAP_ENTER_*}
	self.uid = reader:readInt32Unsigned() -- {用户ID}
	self.name = reader:readString() -- {昵称}
	self.name_color = reader:readInt8Unsigned() -- {角色名颜色}
	self.sex = reader:readInt8Unsigned() -- {性别}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.lv = reader:readInt16Unsigned() -- {等级}
	self.is_war = reader:readInt8Unsigned() -- {是否在战斗(0:正常状态|1:战斗)}
	self.is_guide = reader:readInt8Unsigned() -- {新手指导员 (0:正常状态|1:指导员)}
	self.leader_uid = reader:readInt32Unsigned() -- {队伍Id(无为0)}
	self.pos_x = reader:readInt16Unsigned() -- {X坐标}
	self.pos_y = reader:readInt16Unsigned() -- {Y坐标}
	self.speed = reader:readInt16Unsigned() -- {移动速度}
	self.dir = reader:readInt8Unsigned() -- {方向}
	self.distance = reader:readInt8Unsigned() -- {距离(格)}
	self.country = reader:readInt8Unsigned() -- {国家：显示玩家的国家}
	self.country_post = reader:readInt8Unsigned() -- {国家：职位}
	self.clan = reader:readInt16Unsigned() -- {家族：显示玩家的家族}
	self.clan_name = reader:readString() -- {家族名称}
	self.clan_post = reader:readInt8Unsigned() -- {家族：职位}
	self.vip = reader:readInt8Unsigned() -- {VIP等级}
	self.skin_mount = reader:readInt16Unsigned() -- {坐骑皮肤}
	self.skin_armor = reader:readInt16Unsigned() -- {衣服皮肤}
	self.skin_weapon = reader:readInt16Unsigned() -- {武器皮肤}
	self.skin_pet = reader:readInt16Unsigned() -- {魔宠皮肤}
	self.hp_now = reader:readInt32Unsigned() -- {当前血量}
	self.hp_max = reader:readInt32Unsigned() -- {最大血量}
	self.title_id = reader:readInt16Unsigned() -- {称号ID}
	self.artifact_id = reader:readInt32Unsigned() -- {神器ID}
	self.ext1 = reader:readInt32Unsigned() -- {扩展1}
	self.ext2 = reader:readInt32Unsigned() -- {扩展2}
	self.ext3 = reader:readInt32Unsigned() -- {扩展3}
	self.ext4 = reader:readInt32Unsigned() -- {扩展4}
	self.ext5 = reader:readInt32Unsigned() -- {扩展5}
end

-- {详见：CONST_MAP_ENTER_*}
function ACK_SCENE_ROLE_DATA.getType(self)
	return self.type
end

-- {用户ID}
function ACK_SCENE_ROLE_DATA.getUid(self)
	return self.uid
end

-- {昵称}
function ACK_SCENE_ROLE_DATA.getName(self)
	return self.name
end

-- {角色名颜色}
function ACK_SCENE_ROLE_DATA.getNameColor(self)
	return self.name_color
end

-- {性别}
function ACK_SCENE_ROLE_DATA.getSex(self)
	return self.sex
end

-- {职业}
function ACK_SCENE_ROLE_DATA.getPro(self)
	return self.pro
end

-- {等级}
function ACK_SCENE_ROLE_DATA.getLv(self)
	return self.lv
end

-- {是否在战斗(0:正常状态|1:战斗)}
function ACK_SCENE_ROLE_DATA.getIsWar(self)
	return self.is_war
end

-- {新手指导员 (0:正常状态|1:指导员)}
function ACK_SCENE_ROLE_DATA.getIsGuide(self)
	return self.is_guide
end

-- {队伍Id(无为0)}
function ACK_SCENE_ROLE_DATA.getLeaderUid(self)
	return self.leader_uid
end

-- {X坐标}
function ACK_SCENE_ROLE_DATA.getPosX(self)
	return self.pos_x
end

-- {Y坐标}
function ACK_SCENE_ROLE_DATA.getPosY(self)
	return self.pos_y
end

-- {移动速度}
function ACK_SCENE_ROLE_DATA.getSpeed(self)
	return self.speed
end

-- {方向}
function ACK_SCENE_ROLE_DATA.getDir(self)
	return self.dir
end

-- {距离(格)}
function ACK_SCENE_ROLE_DATA.getDistance(self)
	return self.distance
end

-- {国家：显示玩家的国家}
function ACK_SCENE_ROLE_DATA.getCountry(self)
	return self.country
end

-- {国家：职位}
function ACK_SCENE_ROLE_DATA.getCountryPost(self)
	return self.country_post
end

-- {家族：显示玩家的家族}
function ACK_SCENE_ROLE_DATA.getClan(self)
	return self.clan
end

-- {家族名称}
function ACK_SCENE_ROLE_DATA.getClanName(self)
	return self.clan_name
end

-- {家族：职位}
function ACK_SCENE_ROLE_DATA.getClanPost(self)
	return self.clan_post
end

-- {VIP等级}
function ACK_SCENE_ROLE_DATA.getVip(self)
	return self.vip
end

-- {坐骑皮肤}
function ACK_SCENE_ROLE_DATA.getSkinMount(self)
	return self.skin_mount
end

-- {衣服皮肤}
function ACK_SCENE_ROLE_DATA.getSkinArmor(self)
	return self.skin_armor
end

-- {武器皮肤}
function ACK_SCENE_ROLE_DATA.getSkinWeapon(self)
	return self.skin_weapon
end

-- {魔宠皮肤}
function ACK_SCENE_ROLE_DATA.getSkinPet(self)
	return self.skin_pet
end

-- {当前血量}
function ACK_SCENE_ROLE_DATA.getHpNow(self)
	return self.hp_now
end

-- {最大血量}
function ACK_SCENE_ROLE_DATA.getHpMax(self)
	return self.hp_max
end

-- {称号ID}
function ACK_SCENE_ROLE_DATA.getTitleId(self)
	return self.title_id
end

-- {神器ID}
function ACK_SCENE_ROLE_DATA.getArtifactId(self)
	return self.artifact_id
end

-- {扩展1}
function ACK_SCENE_ROLE_DATA.getExt1(self)
	return self.ext1
end

-- {扩展2}
function ACK_SCENE_ROLE_DATA.getExt2(self)
	return self.ext2
end

-- {扩展3}
function ACK_SCENE_ROLE_DATA.getExt3(self)
	return self.ext3
end

-- {扩展4}
function ACK_SCENE_ROLE_DATA.getExt4(self)
	return self.ext4
end

-- {扩展5}
function ACK_SCENE_ROLE_DATA.getExt5(self)
	return self.ext5
end
