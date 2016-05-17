
require "common/AcknowledgementMessage"

-- [1108]玩家属性 -- 角色

ACK_ROLE_PROPERTY_REVE = class(CAcknowledgementMessage,function(self)
self.MsgID = Protocol.ACK_ROLE_PROPERTY_REVE
self:init()
end)

function ACK_ROLE_PROPERTY_REVE.deserialize(self, reader)
    self.uid = reader:readInt32Unsigned() -- {玩家UID}
    self.name = reader:readString() -- {玩家姓名}
    self.name_color = reader:readInt8Unsigned() -- {名字颜色}
    self.pro = reader:readInt8Unsigned() -- {玩家职业}
    self.sex = reader:readInt8Unsigned() -- {玩家性别}
    self.lv = reader:readInt16Unsigned() -- {玩家等级}
    self.renown = reader:readInt32Unsigned() -- {声望值}
    self.rank = reader:readInt16Unsigned() -- {竞技排名}
    self.country = reader:readInt8Unsigned() -- {阵营类型(见常量)}
    self.clan = reader:readInt16Unsigned() -- {家族ID}
    self.clan_name = reader:readString() -- {家族名称}
    --self.attr = reader:readXXXGroup() -- {角色基本属性块2002}
    require "common/protocol/ACK_GOODS_XXX2"
    self.attr = ACK_GOODS_XXX2()
    self.attr : deserialize( reader )
    self.powerful = reader:readInt32Unsigned() -- {玩家战斗力}
    self.exp = reader:readInt32Unsigned() -- {经验值}
    self.expn = reader:readInt32Unsigned() -- {下级要多少经验}
    self.skin_weapon = reader:readInt16Unsigned() -- {武器皮肤}
    self.skin_armor = reader:readInt16Unsigned() -- {衣服皮肤}
    self.count = reader:readInt16Unsigned() -- {伙伴数量}
    --self.partner = reader:readInt16Unsigned() -- {伙伴ID}
    self.partner = {}
    for i=1,self.count do
        self.partner[i] = reader:readInt16Unsigned()
    end
    self.magic_id = reader:readInt32Unsigned() -- {神器Id}
    self.ext1 = reader:readInt32Unsigned() -- {扩展1}
    self.ext2 = reader:readInt32Unsigned() -- {扩展2}
    self.ext3 = reader:readInt32Unsigned() -- {扩展3}
    self.ext4 = reader:readInt32Unsigned() -- {扩展4}
    self.ext5 = reader:readInt32Unsigned() -- {扩展5}
end

-- {玩家UID}
function ACK_ROLE_PROPERTY_REVE.getUid(self)
return self.uid
end

-- {玩家姓名}
function ACK_ROLE_PROPERTY_REVE.getName(self)
return self.name
end

-- {名字颜色}
function ACK_ROLE_PROPERTY_REVE.getNameColor(self)
return self.name_color
end

-- {玩家职业}
function ACK_ROLE_PROPERTY_REVE.getPro(self)
return self.pro
end

-- {玩家性别}
function ACK_ROLE_PROPERTY_REVE.getSex(self)
return self.sex
end

-- {玩家等级}
function ACK_ROLE_PROPERTY_REVE.getLv(self)
return self.lv
end

-- {玩家声望}
function ACK_ROLE_PROPERTY_REVE.getRenown(self)
    return self.renown
end

-- {竞技排名}
function ACK_ROLE_PROPERTY_REVE.getRank(self)
return self.rank
end

-- {阵营类型(见常量)}
function ACK_ROLE_PROPERTY_REVE.getCountry(self)
return self.country
end

-- {家族ID}
function ACK_ROLE_PROPERTY_REVE.getClan(self)
return self.clan
end

-- {家族名称}
function ACK_ROLE_PROPERTY_REVE.getClanName(self)
return self.clan_name
end

-- {角色基本属性块2002}
function ACK_ROLE_PROPERTY_REVE.getAttr(self)
return self.attr
end

-- {玩家战斗力}
function ACK_ROLE_PROPERTY_REVE.getPowerful(self)
return self.powerful
end

-- {经验值}
function ACK_ROLE_PROPERTY_REVE.getExp(self)
return self.exp
end

-- {下级要多少经验}
function ACK_ROLE_PROPERTY_REVE.getExpn(self)
return self.expn
end

-- {武器皮肤}
function ACK_ROLE_PROPERTY_REVE.getSkinWeapon(self)
return self.skin_weapon
end

-- {衣服皮肤}
function ACK_ROLE_PROPERTY_REVE.getSkinArmor(self)
return self.skin_armor
end

-- {伙伴数量}
function ACK_ROLE_PROPERTY_REVE.getCount(self)
return self.count
end

-- {伙伴ID}
function ACK_ROLE_PROPERTY_REVE.getPartner(self)
return self.partner
end

function ACK_ROLE_PROPERTY_REVE.getMagicId(self)
    return self.magic_id
end
function ACK_ROLE_PROPERTY_REVE.getExt1(self)
    return self.ext1
end
function ACK_ROLE_PROPERTY_REVE.getExt2(self)
    return self.ext2
end
function ACK_ROLE_PROPERTY_REVE.getExt3(self)
    return self.ext3
end
function ACK_ROLE_PROPERTY_REVE.getExt4(self)
    return self.ext4
end
function ACK_ROLE_PROPERTY_REVE.getExt5(self)
    return self.ext5
end
