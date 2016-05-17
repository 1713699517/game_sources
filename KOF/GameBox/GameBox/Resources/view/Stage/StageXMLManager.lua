require "common/Constant"
require "view/Character/Npc"
require "view/Character/Monster"
require "view/Character/Transport"
require "view/Character/Vitro"

require "view/Stage/MonsterXMLManager"
require "view/Stage/TransportXMLManager"
require "common/CreateID"


--全局实例在 最下

CStageXMLManager = class(function ( self )
    self : load()
end)



function CStageXMLManager.load( self )
    _G.Config:load("config/scene.xml")
    _G.Config:load("config/skill.xml")
    _G.Config:load("config/vitro.xml")
end

function CStageXMLManager.getXMLScenes( self, _nScenesID )
    _G.Config:load("config/scene.xml")
    local str = "scene[@scene_id="..tostring(_nScenesID).."]"
    return _G.Config.scenes:selectSingleNode(str)
end

function CStageXMLManager.getScenesIDByCopyID( self, _copyID )
    local str = "scene[@copy_id="..tostring(_copyID).."]"
    local node = _G.Config.scenes:selectSingleNode(str)
    if node ~= nil then
        return tonumber(node:getAttribute("scene_id"))
    end
end

function CStageXMLManager.getMaterialIDByScenesID( self, _nScenesID )
    local xml = self : getXMLScenes(_nScenesID)
    if xml ~= nil then
        return tonumber(xml:getAttribute("material_id"))
    end
end

function CStageXMLManager.getXMLScenesNPCList( self, _nScenesID )
    --NPC XML 列表
    local scene = self : getXMLScenes( _nScenesID )
    if scene ~= nil then
        return scene:children():get(0,"npcs")
    end
end

function CStageXMLManager.getXMLScenesCheckpointList( self, _nScenesID )
    --关卡 XML 列表
    local scene = self : getXMLScenes( _nScenesID )
    if not scene :isEmpty() then
        return scene : children() : get(0,"checkpoints")
    end
end

function CStageXMLManager.getXMLScenesCheckpoint( self, _nScenesID, _nCheckPointIndex )
    --关卡 XML
    local checkpointList = self : getXMLScenesCheckpointList( _nScenesID )
    if not checkpointList :isEmpty() then
        local check = checkpointList : children() : get(_nCheckPointIndex-1,"checkpoint")
        return check
    end
end


function CStageXMLManager.getXMLScenesMonsterList( self, _nScenesID, _nCheckPointIndex )
    -- 关卡怪物 XML 列表
    local checkpoint = self : getXMLScenesCheckpoint( _nScenesID, _nCheckPointIndex )
    if checkpoint : isEmpty() then
        return
    end
    local monlist = {}
    local child = checkpoint:children()
    local nextNode = child :get(0,"monsters")
    if nextNode :isEmpty() then
        CCLOG("配置表.读取不了怪物,配置表错误.fcuk")
        return
    end
    local nextChild = nextNode : children()
    local monCount = nextChild : getCount( "monster" )

    for i=0,monCount-1 do
        local node = nextChild : get(i,"monster")
        local tb = {}
        tb.monster_id = node:getAttribute("monster_id")
        tb.x = node:getAttribute("x")
        tb.y = node:getAttribute("y")
        table.insert(monlist , tb)
    end
    return monlist
end


function CStageXMLManager.getXMLTransportList( self, _nScenesID )

    local scene = self : getXMLScenes( _nScenesID )
    if scene ~= nil and
        scene:children():get(0,"doors") ~= nil then
        return scene:children():get(0,"doors")
    end
end



function CStageXMLManager.addNPC( self, _nScenesID )
    --添加NPC
    local npcList = self : getXMLScenesNPCList( _nScenesID )
    if npcList == nil then
        return
    end

    --读取npc xml
    require "view/Character/Npc"
    _G.Config:load("config/scene_npc.xml")
    local npcChildren = npcList:children()
    local count = npcChildren:getCount("npc")
    for i=0,count-1 do
        local npcChildren = npcChildren:get(i,"npc")

        local npcObject = CNpc(_G.Constant.CONST_NPC)
        local npcId = tonumber(npcChildren:getAttribute("npc_id"))
        local npcPx = tonumber(npcChildren:getAttribute("x"))
        local npcPy = tonumber(npcChildren:getAttribute("y"))
        local npcSkin = 1
        --临时代码,应该做一个npc 的proxy类
        local npcName = "配置的npc"
        local npcStr = "scene_npc[@id="..tostring(npcId).."]"
        local npcNode = _G.Config.scene_npcs:selectSingleNode(npcStr)
        if npcNode ~= nil then
            npcName = npcNode:getAttribute( "npc_name" )
            npcSkin = tonumber(npcNode:getAttribute("skin"))
        end
        npcObject : npcInit (npcId , npcName, npcPx , npcPy , npcSkin)

        _G.g_Stage : addCharacter(npcObject)
    end

end

function CStageXMLManager.addMonster( self, _nScenesID, _nCheckPointIndex )
    -- 添加Monster _nCheckPointIndex=关卡ID
    local monsterList = self : getXMLScenesMonsterList( _nScenesID, _nCheckPointIndex )
    print("addMonster,",monsterList)
    for k,v in pairs(monsterList) do
        print(k,v)
    end
    if monsterList == nil then
        return
    end
    return self : addMonsterByIDList( monsterList )
end

function CStageXMLManager.addPlotMonsterByID( self, _monsterID, _monsterName )
    local addMonsterObject = nil
    local addMonsterObjectRank = 0
    local hpNum = 1

    local monsterXmlProperty        = _G.MonsterXMLManager : getXMLMonster("109")--getXMLFristMonster( tonumber(109) )
    if not monsterXmlProperty:isEmpty() then
        local monsterObject = CMonster( _G.Constant.CONST_MONSTER )
        local uid = _G.CreateID : getNewID()
        if monsterObject : monsterInit( monsterXmlProperty, 0, 800 ,uid, _monsterID, _monsterName) == true then
            addMonsterObject = monsterObject
        end
    end
    return addMonsterObject
end

function CStageXMLManager.addMonsterByIDList( self, _monsterIDList )
    local addMonsterObject = nil
    local addMonsterObjectRank = 0
    local hpNum = 1
    local list = {}

    for _, monsterXml in pairs(_monsterIDList) do
        print("addMonsterByIDList")
        if monsterXml.monster_id ~= nil then
            local monsterXmlProperty = _G.MonsterXMLManager : getXMLMonster( tonumber(monsterXml.monster_id) )
            if monsterXmlProperty ~= nil then
                local monsterObject = CMonster( _G.Constant.CONST_MONSTER )
                local uid = tonumber(monsterXml.uid) or _G.CreateID : getNewID()
                if monsterObject : monsterInit( monsterXmlProperty, monsterXml.x, monsterXml.y ,uid) == true then
                    _G.g_Stage : addCharacter( monsterObject )
                    monsterObject : setMoveClipContainerScalex( tonumber(monsterXml.monster_direction) or -1 )
                    if monsterXml.hp_now ~= nil and monsterXml.hp_max then
                        monsterObject : setMaxHp( monsterXml.hp_max )
                        monsterObject : setHP( monsterXml.hp_now )
                    end
                    local buffObject = _G.buffManager : getBuffNewObject(monsterXmlProperty:getAttribute( "buffs"))
                    if buffObject ~= nil then
                        monsterObject : addBuff( buffObject )
                    end
                    local property = CCharacterProperty()
                    local attrXML = monsterXmlProperty:children():get(0,"attr")
                    property : updateProperty ( _G.Constant.CONST_ATTR_LV , tonumber( monsterXmlProperty:getAttribute("lv") ) )
                    property : setUid( uid )
                    property : updateProperty ( _G.Constant.CONST_ATTR_SP , tonumber( attrXML:getAttribute("sp")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_SP_UP , tonumber( attrXML:getAttribute("sp_up")  ) )
                    --property : updateProperty ( _G.Constant.CONST_ATTR_ANIMA , tonumber( attrXML:getAttribute(" )")  )
                    property : updateProperty ( _G.Constant.CONST_ATTR_HP , tonumber( attrXML:getAttribute("hp")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_HP_GRO , tonumber( attrXML:getAttribute("hp_gro")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_STRONG , tonumber( attrXML:getAttribute("strong")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_STRONG_GRO , tonumber( attrXML:getAttribute("strong_gro")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_MAGIC , tonumber( attrXML:getAttribute("magic")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_MAGIC_GRO , tonumber( attrXML:getAttribute("magic_gro")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_STRONG_ATT , tonumber( attrXML:getAttribute("strong_att")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_STRONG_DEF , tonumber( attrXML:getAttribute("strong_def")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_SKILL_ATT , tonumber( attrXML:getAttribute("skill_att")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_SKILL_DEF , tonumber( attrXML:getAttribute("skill_def")  ) )
                    -- property : updateProperty ( _G.Constant.CONST_ATTR_HIT , tonumber( attrXML:getAttribute(" )")  )
                    -- property : updateProperty ( _G.Constant.CONST_ATTR_DOD , tonumber( attrXML:getAttribute(" )")  )
                    property : updateProperty ( _G.Constant.CONST_ATTR_CRIT , tonumber( attrXML:getAttribute("crit")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_RES_CRIT , tonumber( attrXML:getAttribute("crit_res")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_CRIT_HARM , tonumber( attrXML:getAttribute("crit_harm")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_DEFEND_DOWN , tonumber( attrXML:getAttribute("defend_down")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_LIGHT , tonumber( attrXML:getAttribute("light")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_LIGHT_DEF , tonumber( attrXML:getAttribute("light_def")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_DARK , tonumber( attrXML:getAttribute("dark")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_DARK_DEF , tonumber( attrXML:getAttribute("dark_def")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_GOD , tonumber( attrXML:getAttribute("god")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_GOD_DEF , tonumber( attrXML:getAttribute("god_def")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_BONUS , tonumber( attrXML:getAttribute("bonus")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_REDUCTION , tonumber( attrXML:getAttribute("reduction")  ) )
                    property : updateProperty ( _G.Constant.CONST_ATTR_IMM_DIZZ , tonumber( attrXML:getAttribute("imm_dizz")  ) )
                    property : setTeamID( -1 )

                    _G.g_characterProperty : addOne( property, _G.Constant.CONST_MONSTER )
                    local rank = tonumber(monsterXmlProperty:getAttribute("steps"))
                    monsterObject : setMonsterRank( rank )
                    if rank >= _G.Constant.CONST_MONSTER_RANK_ELITE and addMonsterObjectRank < rank then
                        addMonsterObject = monsterObject
                        addMonsterObjectRank = rank
                        hpNum = tonumber(monsterXmlProperty:getAttribute("says1"))
                    end
                    table.insert(list, monsterObject)
                    if rank == _G.Constant.CONST_OVER_BOSS then
                        _G.g_Stage : setBoss( monsterObject )
                        _G.g_Stage : setBossHp( monsterObject : getHP() )
                    end
                end
            end
        end
    end

    if addMonsterObject ~= nil then
        addMonsterObject : addBigHpView( hpNum )
    end
    return list
end

function CStageXMLManager.addTransport( self, _nScenesID )
    local transportList = self : getXMLTransportList( _nScenesID )
    if transportList :isEmpty() then
        return
    end
    local nowList = _G.CharacterManager : getTransport()
    for _,character in pairs(nowList) do
        _G.g_Stage : removeCharacter( character )
    end
    local MainProperty = _G.g_characterProperty : getMainPlay()
    local transportCount = transportList : children(): getCount("door")
    for i=0,transportCount-1 do
        local transportXML = transportList : children() :get(i,"door")
        local TransportObject = CTransport(_G.Constant.CONST_TRANSPORT)
        local transportPropery = _G.TransportXMLManager : getXMLTransport( tonumber( transportXML:getAttribute( "door_id" ) ) )
        if transportPropery ~= nil and MainProperty : getLv() >= tonumber(transportPropery:getAttribute("lv")) then
            TransportObject : transportInit(transportPropery, tonumber(transportXML:getAttribute( "x")), tonumber(transportXML:getAttribute( "y")))
            _G.g_Stage : addCharacter(TransportObject)
        end
    end
end


function CStageXMLManager.getSkillMcArg( self, _skillID, _lv )
    local skillData = _G.g_SkillXmlManager : getByID( _skillID )
    if skillData ~= nil and skillData.lvs[_lv] ~= nil then
        return skillData.lvs[_lv].mc.mc_arg2 / 10000
    end
    return 1
end











function CStageXMLManager.handleSkillFrameVitro( self, _character, _currentFrame )
    local masterUID = _character : getID()
    local masterType = _character : getType()
    if masterType == _G.Constant.CONST_VITRO then
        masterUID = _character : getMasterUID()
        masterType = _character : getMasterType()
    end

    for _,currentAddvitro in pairs(_currentFrame.addvitro) do
        local vitro = CVitro( _G.Constant.CONST_VITRO )
        local vitroXml = _G.Config.vitros : selectSingleNode("vitro[@id="..tostring(currentAddvitro.id).."]")
        if vitroXml : isEmpty() == false then
            vitro : initVitro(vitroXml,currentAddvitro,_character,masterUID,masterType)
            _G.g_Stage : addCharacter(vitro)
        end
    end
end































_G.StageXMLManager = CStageXMLManager()



















