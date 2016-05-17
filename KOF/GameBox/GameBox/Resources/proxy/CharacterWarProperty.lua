
--[[下面
    变量名和函数名
    的命名都是根据服务端命名的
]]

require "common/Constant"


-- {人物战斗属性}
CCharacterWarProperty = class( function ( self )
    self.is_data            = 0 --是否有数据 false:没 true:有
    self.sp                 = 0 --怒气
    self.sp_speed           = 0 --怒气回复速度
    self.anima              = 0 --灵气值
    self.hp                 = 0 --气血值
    self.maxhp              = nil --气血值
    self.hp_gro             = 0 --气血成长值
    self.strong             = 0 --力量值
    self.strong_gro         = 0 --力量成长值
    self.magic              = 0 --智力值
    self.magic_gro          = 0 --智力攻击成长值
    self.strong_att         = 0 --力量物理攻击
    self.strong_def         = 0 --力量物理防御值
    self.skill_att          = 0 --技能攻击
    self.skill_def          = 0 --技能防御
    self.crit               = 0 --暴击值
    self.crit_res           = 0 --抗暴值
    self.crit_harm          = 0 --暴击伤害值
    self.wreck              = 0 --破甲值
    self.light              = 0 --光属性
    self.light_def          = 0 --光抗性
    self.dark               = 0 --暗属性
    self.dark_def           = 0 --暗抗性
    self.god                = 0 --灵属性
    self.god_def            = 0 --灵抗性
    self.bonus              = 0 --伤害系数(万分比)
    self.reduction          = 0 --免伤系数(万分比)
    self.imm_dizz           = 0 --抗晕值(万分比)

    self.funList            = {}
    self : initFunlist()
end)

function CCharacterWarProperty.initFunlist( self )
    self.funList[_G.Constant.CONST_ATTR_SP]                 = self.setSp                --怒气
    self.funList[_G.Constant.CONST_ATTR_SP_UP]              = self.setSpSpeed           --怒气恢复速度
    self.funList[_G.Constant.CONST_ATTR_ANIMA]              = self.setAnima             --初始灵气值
    self.funList[_G.Constant.CONST_ATTR_HP]                 = self.setNowMaxHp          --气血值
    self.funList[_G.Constant.CONST_ATTR_HP_GRO]             = self.setHpGro             --气血成长值
    self.funList[_G.Constant.CONST_ATTR_STRONG]             = self.setStrong            --武力
    self.funList[_G.Constant.CONST_ATTR_STRONG_GRO]         = self.setStrongGro         --武力成长
    self.funList[_G.Constant.CONST_ATTR_MAGIC]              = self.setMagic             --内力
    self.funList[_G.Constant.CONST_ATTR_MAGIC_GRO]          = self.setMagicGro          --内力成长
    self.funList[_G.Constant.CONST_ATTR_STRONG_ATT]         = self.setStrongAtt         --物攻
    self.funList[_G.Constant.CONST_ATTR_STRONG_DEF]         = self.setStrongDef         --物防
    self.funList[_G.Constant.CONST_ATTR_SKILL_ATT]          = self.setSkillAtt          --技能攻击
    self.funList[_G.Constant.CONST_ATTR_SKILL_DEF]          = self.setSkillDef          --技能防御
    -- self.funList[_G.Constant.CONST_ATTR_HIT]                = self.setHit               --命中 -未见有人物
    -- self.funList[_G.Constant.CONST_ATTR_DOD]                = self.setDod               --躲避 -未见有人物
    self.funList[_G.Constant.CONST_ATTR_CRIT]               = self.setCrit              --暴击
    self.funList[_G.Constant.CONST_ATTR_RES_CRIT]           = self.setCritRes           --抗暴
    self.funList[_G.Constant.CONST_ATTR_CRIT_HARM]          = self.setCritHarm          --暴伤
    self.funList[_G.Constant.CONST_ATTR_DEFEND_DOWN]        = self.setWreck             --破甲
    self.funList[_G.Constant.CONST_ATTR_LIGHT]              = self.setLight             --光属性
    self.funList[_G.Constant.CONST_ATTR_LIGHT_DEF]          = self.setLightDef          --光抗性
    self.funList[_G.Constant.CONST_ATTR_DARK]               = self.setDark              --暗属性
    self.funList[_G.Constant.CONST_ATTR_DARK_DEF]           = self.setDarkDef           --暗抗性
    self.funList[_G.Constant.CONST_ATTR_GOD]                = self.setGod               --灵属性
    self.funList[_G.Constant.CONST_ATTR_GOD_DEF]            = self.setGodDef            --灵抗性
    self.funList[_G.Constant.CONST_ATTR_BONUS]              = self.setBonus             --伤害率
    self.funList[_G.Constant.CONST_ATTR_REDUCTION]          = self.setReduction         --免伤率
    self.funList[_G.Constant.CONST_ATTR_IMM_DIZZ]           = self.setImmDizz          --免疫眩晕
end

-- {是否有数据 false:没 true:有}
function CCharacterWarProperty.getIsData(self)
    return self.is_data
end
function CCharacterWarProperty.setIsData(self, _isData)
    self.is_data = _isData
end

-- {怒气}
function CCharacterWarProperty.getSp(self)
    return self.sp
end
function CCharacterWarProperty.setSp(self, _sp)
    self.sp = _sp
end

-- {怒气回复速度}
function CCharacterWarProperty.getSpSpeed(self)
    return self.sp_speed
end
function CCharacterWarProperty.setSpSpeed(self, _spSpeed)
    self.sp_speed = _spSpeed
end

-- {灵气值}
function CCharacterWarProperty.getAnima(self)
    return self.anima
end
function CCharacterWarProperty.setAnima(self, _anima)
    self.anima = _anima
end

-- {气血值}
function CCharacterWarProperty.getHp(self)
    return self.hp
end
function CCharacterWarProperty.setHp(self, _hp)
    self.hp = _hp
    if self : getMaxHp() == nil or self : getMaxHp() < _hp then
        self : setMaxHp( _hp )
    end
end
-- {最大气血值}
function CCharacterWarProperty.getMaxHp(self)
    return self.maxhp
end
function CCharacterWarProperty.setMaxHp(self, _hp)
    self.maxhp = _hp
end

function CCharacterWarProperty.getNowMaxHp(self)
    return self.nowMaxHp
end
function CCharacterWarProperty.setNowMaxHp(self, _hp)
    self.nowMaxHp = _hp
    self : setMaxHp(_hp)
    self : setHp(_hp)
end


-- {气血成长值}
function CCharacterWarProperty.getHpGro(self)
    return self.hp_gro
end
function CCharacterWarProperty.setHpGro(self, _hpGro)
    self.hp_gro = _hpGro
end

-- {力量值}
function CCharacterWarProperty.getStrong(self)
    return self.strong
end
function CCharacterWarProperty.setStrong(self, _strong)
    self.strong = _strong
end

-- {力量成长值}
function CCharacterWarProperty.getStrongGro(self)
    return self.strong_gro
end
function CCharacterWarProperty.setStrongGro(self, _strongGro)
    self.strong_gro = _strongGro
end

-- {智力值}
function CCharacterWarProperty.getMagic(self)
    return self.magic
end
function CCharacterWarProperty.setMagic(self, _magic)
    self.magic = _magic
end

-- {智力攻击成长值}
function CCharacterWarProperty.getMagicGro(self)
    return self.magic_gro
end
function CCharacterWarProperty.setMagicGro(self, _magicGro)
    self.magic_gro = _magicGro
end

-- {力量物理攻击}
function CCharacterWarProperty.getStrongAtt(self)
    return self.strong_att
end
function CCharacterWarProperty.setStrongAtt(self, _strongAtt)
    self.strong_att = _strongAtt
end

-- {力量物理防御值}
function CCharacterWarProperty.getStrongDef(self)
    return self.strong_def
end
function CCharacterWarProperty.setStrongDef(self, _strongDef)
    self.strong_def = _strongDef
end

-- {技能攻击}
function CCharacterWarProperty.getSkillAtt(self)
    return self.skill_att
end
function CCharacterWarProperty.setSkillAtt(self, _skillAtt)
    self.skill_att = _skillAtt
end

-- {技能防御}
function CCharacterWarProperty.getSkillDef(self)
    return self.skill_def
end
function CCharacterWarProperty.setSkillDef(self, _skillDef)
    self.skill_def = _skillDef
end

-- {暴击值}
function CCharacterWarProperty.getCrit(self)
    return self.crit
end
function CCharacterWarProperty.setCrit(self, _crit)
    self.crit = _crit
end

-- {抗暴值}
function CCharacterWarProperty.getCritRes(self)
    return self.crit_res
end
function CCharacterWarProperty.setCritRes(self, _critRes)
    self.crit_res = _critRes
end

-- {暴击伤害值}
function CCharacterWarProperty.getCritHarm(self)
    return self.crit_harm
end
function CCharacterWarProperty.setCritHarm(self, _critHarm)
    self.crit_harm = _critHarm
end

-- {破甲值}
function CCharacterWarProperty.getWreck(self)
    return self.wreck
end
function CCharacterWarProperty.setWreck(self, _wreck)
    self.wreck = _wreck
end

-- {光属性}
function CCharacterWarProperty.getLight(self)
    return self.light
end
function CCharacterWarProperty.setLight(self, _light)
    self.light = _light
end

-- {光抗性}
function CCharacterWarProperty.getLightDef(self)
    return self.light_def
end
function CCharacterWarProperty.setLightDef(self, _lightDef)
    self.light_def = _lightDef
end

-- {暗属性}
function CCharacterWarProperty.getDark(self)
    return self.dark
end
function CCharacterWarProperty.setDark(self, _dark)
    self.dark = _dark
end

-- {暗抗性}
function CCharacterWarProperty.setDarkDef(self)
    return self.dark_def
end
function CCharacterWarProperty.setDarkDef(self, _darkDef)
    self.dark_def = _darkDef
end

-- {灵属性}
function CCharacterWarProperty.getGod(self)
    return self.god
end
function CCharacterWarProperty.setGod(self, _god)
    self.god = _god
end

-- {灵抗性}
function CCharacterWarProperty.getGodDef(self)
    return self.god_def
end
function CCharacterWarProperty.setGodDef(self, _godDef)
    self.god_def = _godDef
end

-- {伤害系数(万分比)}
function CCharacterWarProperty.getBonus(self)
    return self.bonus
end
function CCharacterWarProperty.setBonus(self, _bonus)
    self.bonus = _bonus
end

-- {免伤系数(万分比)}
function CCharacterWarProperty.getReduction(self)
    return self.reduction
end
function CCharacterWarProperty.setReduction(self, _reduction)
    self.reduction = _reduction
end

-- {抗晕值(万分比)}
function CCharacterWarProperty.getImmDizz(self)
    return self.imm_dizz
end
function CCharacterWarProperty.setImmDizz(self, _immDizz)
    self.imm_dizz = _immDizz
end



-- {得到函数 以类型}
function CCharacterWarProperty.getFuncByType( self, _type )
    return self.funList[ _type ]
end
-- {更新数据  根据类型}
function CCharacterWarProperty.updateProperty( self, _type, _value )
    local func = self : getFuncByType( _type )
    if func ~= nil then
        func( self, _value )
    end
end
