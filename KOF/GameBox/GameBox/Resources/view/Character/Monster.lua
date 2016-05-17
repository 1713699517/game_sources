require "view/Character/Npc"
require "proxy/CharacterPropertyProxy"

CMonster = class(CNpc, function( self, _nType )
    if( _nType == nil ) then
        error( "CMonster _nType == nil" )
        return
    end
    self.m_nType = _nType --人物／npc
    self : initAI()
end)
--AI相关参数
function CMonster.initAI( self )
    self.m_fThinkInterval = 1.0     --怪物反应速度
    self.m_fStartPosX = 300         --怪物出生点
    self.m_fStartPosY = 300
    self.m_fTraceDistance = 600     --追踪距离
    self.m_fAttackInterval = 5.0    --攻击间隔时间

    self.m_nStandupSkillID = 0      --倒地站立

    self.m_nTarget = nil
    self.m_nThoughtSkillId = 0      --确定使用技能ID
    self.m_fThoughtSkillRangeWidth = 0      --确定使用技能范围X
    self.m_fThoughtSkillRangeHeight = 0     --确定使用技能范围Z
    self.m_fThoughtSkillRangeRange = 0      --确定使用技能范围Y

    _G.pDateTime : reset()
    local nowTime = _G.pDateTime : getTotalMilliseconds()
    self.m_fLastThinkTime = nowTime

    self.m_fLastAttackTime = nowTime - self.m_fAttackInterval * 1000 --上次攻击时间,毫秒

    self.m_fBackTospTime = 0 --回复SP最后时间

    self.m_fTargetAttackDispersion = 0.8 --目标点+攻击距离+分散值

-----------------
end

function CMonster.monsterInit( self, _xml, _x, _y, _clientID, _skinID, _monsterName )
    local uid = _clientID or _xml : getAttribute("id")
    self.m_nMonsterXMLID = _xml : getAttribute("id")
    local attr = _xml:children():get(0,"attr")
    if attr == nil then
        return false
    end
    self : init(tonumber(uid),
                _monsterName or _xml : getAttribute("monster_name"),
                tonumber(attr:getAttribute("hp")),
                tonumber(attr:getAttribute("hp")),
                tonumber(attr:getAttribute("sp")),
                tonumber(attr:getAttribute("sp")),
                tonumber(_x),
                tonumber(_y),
                _skinID or tonumber(_xml : getAttribute("skin") ))
    self.m_fStartPosX = tonumber(_x)
    self.m_fStartPosY = tonumber(_y)
    self.m_nMaxTenacity = tonumber(_xml : getAttribute("toughness"))
    self.m_nMaxTenacityA = tonumber(_xml : getAttribute("toughness")) -- 技能
    self.m_nMaxTenacityB = tonumber(_xml : getAttribute("says2")) -- 普通攻击
    self.m_fAIDelay = tonumber(_xml : getAttribute("delay"))


    if not(_G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_characterProperty : getMainPlay() : getIsTeam() == true or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS ) then
        self : setAI( tonumber( _xml : getAttribute("ai" ) ))
    end
    self : setLv( tonumber(_xml : getAttribute("lv") ))
    return true
end

--怪物等阶
function CMonster.setMonsterRank( self,_rank )
    self.m_nMonsterRank = _rank
end
function CMonster.getMonsterRank( self )
    return self.m_nMonsterRank
end

--重写析构
function CMonster.onDestory(self)
    -- CBaseCharacter.onDestory(self)
    self.m_nAI = nil
    self.m_lpAINode = nil
end

function CMonster.setAI( self, _AI )
    self.m_nAI = _AI
    self.m_nNextSkillID = 0
    self.m_nNextSkillID2 = 0
    print("setAI",_AI)
    if _AI == nil or _AI == 0 then
        return
    end
    _G.Config:load("config/battle_ai.xml")
    self.m_lpAINode = _G.Config.battle_ais:selectSingleNode("battle_ai[@ai_id="..tostring(_AI).."]")
    if self.m_lpAINode == nil then
        CCMessageBox("monsterAI : ".._AI, "ERROR INIT MONSTER")
        CCLOG("codeError!!!!  monsterAI : ".._AI )
        error("_____________")
        return
    end
    self.m_fThinkInterval = tonumber(self.m_lpAINode:getAttribute("reaction_time"))
    self.m_fAttackInterval = tonumber(self.m_lpAINode:getAttribute("attack_interval"))
    self.m_fTraceDistance = tonumber(self.m_lpAINode:getAttribute("view"))
end
function CMonster.getAI( self )
    return self.m_nAI
end

function CMonster.getLv( self )
    return self.m_nLv
end

function CMonster.setLv( self, _nLv )
    self.m_nLv = _nLv
end

function CMonster.think( self, _now )
    self : backToSp( _now )
    if self:getAI() == nil or self:getAI() == 0 then
        return
    end
    -- if self:getHP() <= 0 and _G.Constant.CONST_BATTLE_STATUS_IDLE then
    --     self:setStatus(_G.Constant.CONST_BATTLE_STATUS_DEAD)
    --     return
    -- end
	if math.abs(_now - self.m_fLastThinkTime) < (self.m_fThinkInterval * 1000) then   --判断是否有反应
        return
    end

    if self.m_fAIDelay ~= nil and self.m_fAIDelay > 0 then
        self.m_fAIDelay = self.m_fAIDelay - math.abs(_now - self.m_fLastThinkTime) / 1000
        return
    end
    local property = _G.g_characterProperty : getOneByUid( self :getID(), self : getType() )
    if property == nil then
        return
    end

    if self.m_fLastThinkTime == 0 then
        self.m_fLastThinkTime = _now + math.random(1,self.m_fThinkInterval * 1000)
    else
        self.m_fLastThinkTime = _now
    end

    if self.m_nStandupSkillID ~= 0 then     --已结算起身技能
        return
    end

    if self:getStatus() == _G.Constant.CONST_BATTLE_STATUS_FALL and self.m_nStandupSkillID == 0 then --如果是倒地状态.则设定为起身策略
        local standupRand = math.random(1,10000)
        if standupRand > tonumber(self.m_lpAINode:getAttribute("get_up_rand")) then
            local child = self.m_lpAINode:children()
            local getUpSkillNodes = child:get(0,"get_up_skills")
            if not getUpSkillNodes:isEmpty() then
                local getupWeight = 2
                local child = getUpSkillNodes:children()
                local get_up_skillCount = child:getCount("get_up_skill")
                for i=0,get_up_skillCount-1 do
                    local get_up_skillNode = child:get(i,"get_up_skill")
                    if not get_up_skillNode:isEmpty() then
                        getupWeight = getupWeight + tonumber(get_up_skillNode:getAttribute("odds"))
                    end
                end
                local getupRandomWeight = math.random(1, getupWeight)
                local currentGetupWeight = 0
                for i=0,get_up_skillCount-1 do
                    local get_up_skillNode = child:get(i,"get_up_skill")
                    if not get_up_skillNode:isEmpty() then
                        if currentGetupWeight <= getupRandomWeight and getupRandomWeight < currentGetupWeight + tonumber(get_up_skillNode:getAttribute("odds")) then
                            self.m_nStandupSkillID = tonumber(get_up_skillNode:getAttribute("id"))
                        end
                    end
                end
            end
        end
    end

    if self.m_nTarget == nil then    --没有目标,则寻找目标
        --查找场景中所有对象
        local charList = _G.CharacterManager:getCharacter()
        local target = nil
        local maxDist = 1000000
        for k,char in pairs(charList) do
            --查找距离最近的进行攻击
            --if char : getType()== _G.Constant.CONST_PLAYER then
            --查找不同队伍的对象打
            local charProperty = _G.g_characterProperty : getOneByUid( char :getID(), char : getType() )
            if charProperty ~= nil and charProperty : getTeamID() ~= property : getTeamID() then
                print("找到了队伍不一样的")
                local dist = math.sqrt(math.pow(char:getLocationX() - self.m_fStartPosX, 2) + math.pow(char:getLocationY() - self.m_fStartPosY, 2))
                if dist < self.m_fTraceDistance then --判断出生点与距离

                    --下面是找到最近距离的
                    dist = math.sqrt(math.pow(self:getLocationX() - char:getLocationX(), 2) + math.pow(self:getLocationY() - char:getLocationY(), 2))
                    if dist < maxDist then
                        maxDist = dist
                        target = char
                    end
                end
            end
        end
        self.m_nTarget = target
    end

    if self.m_nTarget == nil then      --场景中再没有任何目标
        return
    end

    if self.m_nTarget : getHP() <= 0 then
        self.m_nTarget = nil
        return
    end

    local danger = false
    local duoshan = false
    if  self.m_nTarget ~= nil and (self.m_nTarget:getStatus() == _G.Constant.CONST_BATTLE_STATUS_FALL or _now < self.m_nTarget:getLaseDangerTime()) then
    --危险区域判断
        if self.m_nTarget:getAI() == nil or self.m_nTarget:getAI() == 0 then
            --如果目标木有AI.就将目标设置为空
            self.m_nTarget = nil
            return
        end
        local child = self.m_nTarget.m_lpAINode:children()
        local node = child:get(0,"special_areas")
        local nextChild = node:children()
        local special_area = nextChild:get(0,"special_area")

        local collider = { offsetX = tonumber(special_area:getAttribute("x")),
                    offsetY = tonumber(special_area:getAttribute("y")),
                    offsetZ = 0,
                    vWidth = tonumber(special_area:getAttribute("w")),
                    vHeight = 100,
                    vRange = tonumber(special_area:getAttribute("h")) }
        if _G.CharacterManager:checkColliderByCharacter( self.m_nTarget, collider, self  ) == true
        or _G.CharacterManager:checkColliderByCharacter( self.m_nTarget, collider, self, true  ) == true then
            danger = true
        end
    end

--math.abs(_now - self.m_fLastAttackTime) > self.m_fAttackInterval *1000 and
    if danger == false and self.m_nTarget ~= nil and math.abs(_now - self.m_fLastAttackTime) < self.m_fAttackInterval * 1000 then
        --self.m_nTarget ~= nil and math.abs(_now - self.m_fLastAttackTime) < self.m_fAttackInterval * 1000
    --判断躲闪策略类型
        duoshan = true
    end


    if danger == true or duoshan == true  then
        local rtab = {}
        for i=1,4 do
            local child = self.m_lpAINode:children()
            local node = child:get(0,"rand_types")
            local nextChild = node:children()
            local nextNode = nextChild:get(0,"rand_type")
            local p = nextNode:getAttribute("r"..tostring(i))
            if p ~= nil and tonumber(p) then
                table.insert(rtab, tonumber(p) )
            end
        end

        if #rtab <= 0 then
            return
        end

        local rIndex = math.random(1, #rtab)
        local rStra = rtab[rIndex]

        local child = self.m_lpAINode : children()
        local node = child:get(0,"rand_zuos")
        local nextChild = node:children()
        local nextNode = nextChild:get(0,"rand_zuo")
        local rand_x = nextNode:getAttribute("x")
        local rand_y = nextNode:getAttribute("y")
        local userx,usery = self.m_nTarget:getLocationXY()
        local selfx = self:getLocationX()
        local selfy = self:getLocationY()
        local targetx = selfx
        local targety = selfy
        local mapminx = tonumber(_G.g_Stage:getMaplx())
        local mapmaxx = tonumber(_G.g_Stage:getMaprx())
        local mapminy = 0
        local mapmaxy = tonumber(_G.g_Stage:getMapData():getCanWalkHeight())
        if rStra == 2 then
            targetx = math.random(math.min(150, rand_x),math.max(150,rand_x)) + userx
            print("targetx111",targetx)
            if targetx >= mapmaxx then
                targetx = targetx - userx -200
            end
            self.m_nThoughtSkillId = 0
            self:setMovePos( ccp(targetx, targety) )
            print("targetx, targety",targetx,selfx, userx)
            return
        elseif rStra == 3 then
            targety = math.random(1, rand_y) + usery
            if targety >= mapmaxy then
                targety = targety - usery
            elseif targety >= mapminy then
                targety = targety + usery
            elseif targety < mapmaxy then
                targety = targety + usery
            else
                targety = targety - usery
            end
            self.m_nThoughtSkillId = 0
            self:setMovePos( ccp(targetx, targety) )
            return
        elseif rStra == 4 then
            targetx = math.random(1, rand_x) + userx
            targety = math.random(1, rand_y) + usery
            if targetx >= mapmaxx then
                targetx = targetx - userx - 200
            end
            if targety >= mapmaxy then
                targety = targety - usery
            elseif targety >= mapminy then
                targety = targety + usery
            elseif targety < mapmaxy then
                targety = targety + usery
            else
                targety = targety - usery
            end
            self.m_nThoughtSkillId = 0
            self:setMovePos( ccp(targetx, targety) )
            return
        else
            return
        end
        return
    end


    --随机技能
    if self.m_nThoughtSkillId == 0 and self.m_lpAINode ~= nil then
        print("ai_id ",self.m_lpAINode:getAttribute("ai_id"))
        local child = self.m_lpAINode : children()
        local attackSkillNodes = child:get(0,"attack_skills")
        if not attackSkillNodes:isEmpty() then
            local allWeight = 2
            local child = attackSkillNodes:children()
            local nodeCount = child:getCount("attack_skill")
            for i=0,nodeCount-1 do
                local attack_skillNode =child:get(i,"attack_skill")
                allWeight = allWeight + tonumber( attack_skillNode:getAttribute("odds") ) --权重总值
            end
            local randomWeight = math.random(1, allWeight)
            local currentWeight = 0
            for i=0,nodeCount-1 do
                local attack_skillNode =child:get(i,"attack_skill")
                if currentWeight <= randomWeight and randomWeight < currentWeight + tonumber(attack_skillNode:getAttribute("odds")) then
                    local _skillID = tonumber(attack_skillNode:getAttribute("id"))
                    print("_skillID",_skillID)
                    --查找到权重值到达的技能
                    --判断该技能是否可使用

                    local skillNode = _G.g_SkillEffectXmlManager : getByID( attack_skillNode:getAttribute("id") )
                    if skillNode == nil then
                        randomWeight = randomWeight + tonumber(attack_skillNode:getAttribute("odds"))
                        break
                    end
                    local sp = skillNode.sp   --正数
                    if self:canSubSp( -sp ) == false then
                        randomWeight = randomWeight + tonumber(attack_skillNode:getAttribute("odds"))
                        break
                    end
                    if self:isSkillCD( _skillID ) then
                        randomWeight = randomWeight + tonumber(attack_skillNode:getAttribute("odds"))
                        break
                    end
                    self.m_nThoughtSkillId = _skillID
                    self.m_nNextSkillID = tonumber(attack_skillNode:getAttribute("id2"))
                    self.m_nNextSkillID2 = tonumber(attack_skillNode:getAttribute("id3"))
                    self.m_fThoughtSkillRangeWidth = tonumber(attack_skillNode:getAttribute("x"))      --确定使用技能范围X
                    self.m_fThoughtSkillRangeHeight = tonumber(attack_skillNode:getAttribute("z"))     --确定使用技能范围Z
                    self.m_fThoughtSkillRangeRange = tonumber(attack_skillNode:getAttribute("y"))      --确定使用技能范围Y
                    break
                end
                currentWeight = currentWeight + tonumber(attack_skillNode:getAttribute("odds"))
            end
        end --end attackSkillNodes
    end

    if self.m_nThoughtSkillId == 0 then         --没有能使用的技能
        return
    end


    --判断目标是否在有效的攻击范围
    local collider = { offsetX = 0,
                        offsetY = 0,
                        offsetZ = 0,
                        vWidth = self.m_fThoughtSkillRangeWidth,
                        vHeight = self.m_fThoughtSkillRangeHeight,
                        vRange = self.m_fThoughtSkillRangeRange }

    if _G.CharacterManager:checkColliderByCharacter( self, collider, self.m_nTarget ) == true then
        self : cancelMove()
        --在有效的攻击范围中
        --攻击
        self:useSkill(self.m_nThoughtSkillId)
        self.m_fLastAttackTime = _now
        self.m_nThoughtSkillId = 0
        self.m_fThoughtSkillRangeWidth = 0
        self.m_fThoughtSkillRangeHeight = 0
        self.m_fThoughtSkillRangeRange = 0
    elseif _G.CharacterManager:checkColliderByCharacter( self, collider, self.m_nTarget, true) == true then
        self : cancelMove()
        --在有效的攻击范围中,转身
        local scalex = self:getScaleX()
        self:setMoveClipContainerScalex( -scalex )
        scalex = self:getScaleX()

        self:useSkill(self.m_nThoughtSkillId)
        self.m_fLastAttackTime = _now
        self.m_nThoughtSkillId = 0
        self.m_fThoughtSkillRangeWidth = 0
        self.m_fThoughtSkillRangeHeight = 0
        self.m_fThoughtSkillRangeRange = 0
        self : cancelMove()
    else
        local _x,_y = self.m_nTarget:getLocationXY()
        local selfx = self:getLocationX()
        local selfy = self:getLocationY()
        local disx = math.abs(selfx - _x) - collider.vWidth
        local disy = math.abs(selfy - _y) - collider.vRange

        if disx > 0 then
            if selfx - _x > 0 then
                _x = selfx - disx
            else
                _x = selfx + disx
            end
        end

        if disx <= 0 then
            _x = math.random(math.min(selfx,(selfx + _x)/2),math.max(selfx,(selfx + _x)/2))

        end

        if disy > 0 then
            if selfy - _y > 0 then
                _y = selfy - disy
            else
                _y = selfy + disy
            end
        end

        if disy <= 0 then
            _y =math.random(math.min(selfy,(selfy + _y)/2),math.max(selfy,(selfy + _y)/2))
        end

        --_x = math.abs(self:getLocationX() - _x) - collider.vWidth + math.random(-collider.vWidth * self.m_fTargetAttackDispersion, collider.vWidth * self.m_fTargetAttackDispersion)
        --_y = math.abs(self:getLocationY() - _y) - collider.vRange + math.random(-collider.vRange * self.m_fTargetAttackDispersion, collider.vRange * self.m_fTargetAttackDispersion)
        self:setMovePos( ccp(_x, _y) )   --移动去目标点
    end
end

function CMonster.resetThinkTime( self )
    self.m_fLastThinkTime = self.m_fLastThinkTime + self.m_fThinkInterval
end

function CMonster.backToSp( self, _now )
    if self.m_fBackTospTime == nil then
        self.m_fBackTospTime = _now
    end
    if (_now - self.m_fBackTospTime) < 1000 then
        return
    end
    -- if self ~= _G.g_Stage : getPlay() then
    --     return
    -- end
    self.m_fBackTospTime = _now
    local sp = 1
    if self == _G.g_Stage : getPlay() then
        local mainProperty = _G.g_characterProperty : getMainPlay()
        local mainWarProperty = mainProperty : getAttr()
        sp = mainWarProperty : getSpSpeed()
    end
    if sp ~= nil and type(sp) == "number" then
        self : addSP( sp )

    end
end