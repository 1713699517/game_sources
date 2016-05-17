
require "common/Constant"


CSkillHurt = class()

function CSkillHurt.calculateSkillHurt( self, _skillNode, _currentFrame, _Assailant, _Victim, _skillMcArg, _skillLv, vitroCharacter )
    --技能碰撞后结算伤害_Assailant 攻击者    _Victim 受害者


    --处理当前技能帧的BUFF添加
    _Assailant : handleSkillFrameBuff( _currentFrame, 1, 1, _skillNode.id)

    if _Victim : isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_INVINCIBLE ) then
        --无敌状态   4
        return
    end
    --增加BUFF结算
    _Victim : handleSkillFrameBuff( _currentFrame, 0, 1, _skillNode.id)
    self : addThrust( _Assailant, _Victim, vitroCharacter )



    --伤害结算
    local hurtHP, crit_fix = self : compute( _skillNode, _currentFrame, _Assailant, _Victim, _skillMcArg )
    if _currentFrame.damage == 0 then
        hurtHP = 0
    end

    if hurtHP > 0 then
        --发送结算受伤Hp
        self : sendComputeHP( _skillNode, -hurtHP, crit_fix, _Assailant, _Victim, _skillLv)
    end

    --播放受击
    if _Victim : isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_ENDUCE ) == nil and _Victim : isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_ENDUCE_FOREVER ) == nil then    --没有霸体则受伤
        if _Victim:isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_RIGIDITY) then
            if _Victim:getStatus() == _G.Constant.CONST_BATTLE_STATUS_USESKILL
                or _Victim:getStatus() == _G.Constant.CONST_BATTLE_STATUS_JUMPATTACK then
                --删除相应的BUFF
                _Victim:removeBuffBySkillId( _Victim.m_nSkillID )
            end
            if _Victim : getStatus() ~= _G.Constant.CONST_BATTLE_STATUS_CRASH  then
                _Victim:setStatus( _G.Constant.CONST_BATTLE_STATUS_HURT)
            end
            if _skillNode.isSkill == 1 then
                _Victim:setStatus( _G.Constant.CONST_BATTLE_STATUS_HURT)
            end
            _Victim:onHurt( _skillNode.isSkill==1, false )
        end
        if _Victim:isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_CRASH) then
            if _Victim:getStatus() == _G.Constant.CONST_BATTLE_STATUS_USESKILL
                or _Victim:getStatus() == _G.Constant.CONST_BATTLE_STATUS_JUMPATTACK then
                --删除相应的BUFF
                _Victim:removeBuffBySkillId( _Victim.m_nSkillID )
            end
            _Victim:setStatus( _G.Constant.CONST_BATTLE_STATUS_CRASH)
            _Victim:onHurt( _skillNode.isSkill==1, true )
        end
    end

    --受击回蓝 -增加受击数量
    if _G.g_Stage : isMainPlay( _Victim ) == true or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        _Victim : addSP(_G.Constant.CONST_BATTLE_PASSIVE_HIT_SP)
        _G.g_Stage : addHitTimes()
    end

    --增加攻击血量
    if _G.g_Stage : isMainPlay( _Assailant ) == true and _Victim : getType() == _G.Constant.CONST_MONSTER then
        _G.g_Stage : addMonsHp( hurtHP )
    end

end

--增加推力
function CSkillHurt.addThrust( self, _Assailant, _Victim, vitroCharacter )
    if _Victim : isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_ENDUCE ) == true or _Victim : isHaveBuff( _G.Constant.CONST_BATTLE_BUFF_ENDUCE_FOREVER ) == true then    --霸体
        return
    end

    self : addThrustByID( _Assailant, _Victim, _G.Constant.CONST_BATTLE_BUFF_RIGIDITY, vitroCharacter )     --僵值
    self : addThrustByID( _Assailant, _Victim, _G.Constant.CONST_BATTLE_BUFF_CRASH, vitroCharacter )        --击飞

end

function CSkillHurt.sendComputeHP( self, _skillNode, _hurtHP, _crit_fix,_Assailant, _Victim, _skillLv )
    local assailantProperty = _G.g_characterProperty : getOneByUid( _Assailant : getID(), _Assailant : getType() )
    local victimProperty = _G.g_characterProperty : getOneByUid( _Victim : getID(), _Victim : getType() )
    local mainProperty = _G.g_characterProperty : getMainPlay()
    local stataCrit = _crit_fix > 1 and _G.Constant.CONST_WAR_DISPLAY_CRIT or _G.Constant.CONST_WAR_DISPLAY_NORMAL
    local scenesType = _G.g_Stage : getScenesType()
    if scenesType == _G.Constant.CONST_MAP_TYPE_BOSS
        or scenesType == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS
        or mainProperty : getIsTeam() == true
        or scenesType == _G.Constant.CONST_MAP_TYPE_INVITE_PK
        or scenesType == _G.Constant.CONST_MAP_TYPE_KOF  then --格斗之王
        local warType = _G.Constant.CONST_WAR_PARAS_1_WORLD_BOSS
        if mainProperty : getIsTeam() == true then
            warType = _G.Constant.CONST_WAR_PARAS_1_TEAM
        end
        if  scenesType == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
            warType = _G.Constant.CONST_WAR_PARAS_1_CLAN2
        end
        if scenesType == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
            warType = _G.Constant.CONST_WAR_PARAS_1_PK
            if mainProperty : getUid() == victimProperty : getUid() then
                return
            end
        end
        if scenesType == _G.Constant.CONST_MAP_TYPE_KOF then --格斗之王
            warType = _G.Constant.CONST_WAR_PARAS_1_PK
            if mainProperty : getUid() == victimProperty : getUid() then
                return
            end
        end

        if mainProperty : getUid() ==  assailantProperty : getUid() or mainProperty : getUid() == victimProperty : getUid() then

            local assailant_type = _Assailant : getType()
            local assailant_uid =  _Assailant : getID()
            local assailant_xml_id =  _Assailant : getMonsterXMLID()
            if assailant_type == _G.Constant.CONST_PARTNER then
                assailant_uid = assailantProperty : getUid()
                assailant_xml_id = assailantProperty : getPartner()
            end

            local victim_type = _Victim : getType()
            local victim_xml_id = _Victim : getMonsterXMLID()
            local victim_uid = _Victim : getID()
            if victim_type == _G.Constant.CONST_PARTNER then
                victim_uid = victimProperty : getUid()
                victim_xml_id = victimProperty : getPartner()
            end


            local tempCommand = CStageREQCommand(_G.Protocol["REQ_WAR_HARM_NEW"])
            tempCommand : setOtherData(
                                       {type=warType,
                                       one_type = assailant_type,
                                       one_mid = assailant_uid,
                                       one_id = assailant_xml_id,
                                       foe_type = _Victim : getType(),
                                       attr_type = tonumber(_skillNode.isSkill or 0),
                                       mid = victim_uid,
                                       id = victim_xml_id,
                                       skill_id=_skillNode.id,
                                       lv = _skillLv,
                                       harm=math.abs(_hurtHP),
                                       stata=stataCrit }
                                       )
            _G.controller: sendCommand(tempCommand)

        end
    else
        --伤害少于0时,自动播放死亡
        _Victim : addHP( _hurtHP )
        _Victim : addHurtString(-_hurtHP, stataCrit)
    end
end

--增加推力
function CSkillHurt.addThrustByID( self, _Assailant, _Victim, _buffID, vitroCharacter )
    if _Victim : isHaveBuff( _buffID ) then

        local buff = _Victim : getBuff( _buffID )
        if buff == nil then
            return
        end
        local selfCharacter = _Assailant
        if vitroCharacter ~= nil then
            selfCharacter = vitroCharacter
        end
        if buff.speed ~=nil and buff.pushAngle ~= nil and buff.acceleration ~= nil then
            local _AssailantScaleX = selfCharacter : getScaleX()
            local pushAngle = buff.pushAngle
            if _AssailantScaleX < 0 then
                pushAngle = -( 90- (math.abs(buff.pushAngle) -90) )
            end
            print("addThrustByID")
            _Victim : thrust( buff.speed, pushAngle, buff.acceleration )
        end
    end
end

--计算伤害
function CSkillHurt.compute( self, _skillNode, _currentFrame, _Assailant, _Victim, _skillMcArg )
    local assailantProperty = _G.g_characterProperty : getOneByUid( _Assailant : getID(), _Assailant : getType() )
    local victimProperty = _G.g_characterProperty : getOneByUid( _Victim : getID(),  _Victim : getType() )
    if assailantProperty == nil or victimProperty == nil then
        CCLOG("攻击者或者受击者数据为空+++++++++++++++++++++++++=====ERROR")
        return 0
    end
    local assailantAttr = assailantProperty : getAttr()
    local victimAttr = victimProperty : getAttr()
    --暴击 万分比：战斗发生暴击几率=（暴击值-对方抗暴值）/（（暴击值-对方抗暴值）+自身等级*3+3000）
    local assailantCrit = assailantAttr : getCrit()
    local assailantLv = assailantProperty : getLv()
    local assailantCritHarm = assailantAttr : getCritHarm()
    local victimCritRes = victimAttr : getCritRes()

    local crit = (assailantCrit-victimCritRes) / ((assailantCrit-victimCritRes) + assailantLv *3 +3000) * 10000
    if victimCritRes >= assailantCrit then
        crit = 100
    end
    crit = crit <= 0 and 0 or crit
    local r = math.random(0,10000)
    local crit_fix = 1
    if r <= crit then --中暴击
        crit_fix = ( 1 + (assailantCritHarm /30 /100) ) * _G.Constant.CONST_BATTLE_FORMULA_D
    end

    --伤害=（a*物理攻击-b*对方物理防御+c*破甲）*技能威力系数*（1+己方伤害率-对方免伤害率）*暴击修正
    --伤害=（a*技能攻击-b*对方技能防御+c*破甲）*技能威力系数*（1+己方伤害率-对方免伤害率）*暴击修正
    local isSkill = _skillNode.isSkill

    local changeHp = 0
    local assailantStrongAtt =  assailantAttr : getStrongAtt() --物理攻击
    local victimStrongDef = victimAttr : getStrongDef() -- 对方物理防御
    local assailantWreck = assailantAttr : getWreck() --破甲
    local damage = _currentFrame.damage --技能威力系数   _skillMcArg 技能威力系数
    local assailantBonus = assailantAttr : getBonus()  --伤害率
    local victimReduction = victimAttr : getReduction()  --对方免伤害率
    local assailantSkillAtt = assailantAttr : getSkillAtt() --技能攻击
    local victimSkillDef = victimAttr : getSkillDef() --对方技能防御
    local tempA = _G.Constant.CONST_BATTLE_FORMULA_A
    local tempB = _G.Constant.CONST_BATTLE_FORMULA_B
    local tempC = _G.Constant.CONST_BATTLE_FORMULA_C
    local tempE = _G.Constant.CONST_BATTLE_FORMULA_E
    local tempF = _G.Constant.CONST_BATTLE_FORMULA_F
    if isSkill == 1 then --技能攻击
        -- changeHp = ( tempA*assailantSkillAtt - tempB*victimSkillDef + tempC*assailantWreck ) * damage * ( 1 + assailantBonus - victimReduction ) * crit_fix * _skillMcArg
        -- local tempHp = (tempA*assailantSkillAtt*tempF) * damage * ( 1 + assailantBonus - victimReduction ) * crit_fix * _skillMcArg
        changeHp = ( tempA*assailantSkillAtt - tempB*victimSkillDef) * damage * _skillMcArg * crit_fix + ( tempC*assailantWreck - victimReduction )
        local tempHp = tempA*assailantSkillAtt*tempE*damage * _skillMcArg * crit_fix + ( tempC*assailantWreck - victimReduction )
        changeHp = math.max(changeHp, tempHp)
    else --普通攻击
        changeHp = ( tempA*assailantStrongAtt - tempB*victimStrongDef) * damage * _skillMcArg * crit_fix + ( tempC*assailantWreck - victimReduction )
        local tempHp = tempA*assailantStrongAtt*tempE*damage * _skillMcArg * crit_fix + ( tempC*assailantWreck - victimReduction )
        changeHp = math.max(changeHp, tempHp)
    end
    changeHp = changeHp <= 0 and 1 or changeHp
    return math.floor(changeHp), crit_fix
end


























_G.SkillHurt = CSkillHurt()