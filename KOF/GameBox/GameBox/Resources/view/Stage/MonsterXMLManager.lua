require "view/Character/Monster"


CMonsterXMLManager = class(function ( self )
    self : load()
end)





function CMonsterXMLManager.load( self )
    _G.Config:load("config/scene_monster.xml")
end

function CMonsterXMLManager.getXMLMonster( self, _nMonsterID )
    local str = "scene_monster[@id="..tostring(_nMonsterID).."]"
    return _G.Config.scene_monsters:selectSingleNode(str)
end

function CMonsterXMLManager.getXMLFristMonster( self )
    if _G.Config.scene_monsters:children()~= nil and _G.Config.scene_monsters:children():get(0) ~= nil then
       return _G.Config.scene_monsters:children():get(0)
    end
    return nil
end







_G.MonsterXMLManager = CMonsterXMLManager()
















-- CLoadXMLBase = class()
-- function CLoadXMLBase.init( self, _xmlData )
--     for k,v in pairs(_xmlData) do
--         self[k] = v
--         local function get( self )
--             return self[k]
--         end
--         self["get"..k] = get

--         local function set( self, _setData )
--             self[k] = _setData
--         end
--         self["set"..k] = set
--     end
-- end





-- CMonsterPropertyXML = class( CLoadXMLBase )


-- CScenesMonsterXML = class(CLoadXMLBase)










-- _G.MonsterXMLManager = class()


-- function MonsterXMLManager.initMonsterProperty( self )
--     if self.m_monsterList ~= nil then
--         return true
--     end
--     if _G.Config == nil or _G.Config.monster_property == nil or _G.Config.monster_property.monster == nil then
--         if _G.Config == nil or _G.Config.monster_property == nil or _G.Config.monster_property.monster == nil then
--             CCLOG("no load monster_property.xml ")
--             return false
--         end
--     end
--     self.m_monsterList = {}
--     for k,v in pairs( _G.Config.monster_property.monster ) do
--         local xml = CMonsterPropertyXML()
--         xml : init(v)
--         local monsterID = tonumber( xml : getmonster_id())
--         self.m_monsterList[monsterID] = xml
--     end
--     return true
-- end

-- function MonsterXMLManager.getMonsterProperty( self, _monsterID )
--     if self : initMonsterProperty() == false then
--         return nil
--     end
--     _monsterID = tonumber(_monsterID)
--     return self.m_monsterList[ _monsterID ]
-- end










-- function MonsterXMLManager.initScenesMonster( self )
--     if _G.Config == nil or _G.Config.scenes_monsters == nil or _G.Config.scenes_monsters.scenes_monster == nil then
--         if _G.Config == nil or _G.Config.scenes_monsters == nil or _G.Config.scenes_monsters.scenes_monster == nil then
--             CCLOG("no load scenes_monster.xml ")
--             return false
--         end
--         return true
--     end
--     return true
-- end

-- function MonsterXMLManager.getScenesMonsterList( self, _scenesID, _checkpoints_id )
--     if self : initScenesMonster() == false then
--         CCLOG("self : initScenesMonster()")
--         return nil
--     end
--     local node = _G.Config.scenes_monsters:selectNode("scenes_monster","scenes_id", tostring( _scenesID ) )
--     if node == nil or node.checkpoints == nil then
--         CCLOG("node == nil or node.checkpoints == nil",node )
--         return nil
--     end
--     local list = {}
--     for _,currCheckPoint in pairs( node.checkpoints ) do
--         if tonumber(currCheckPoint.checkpoints_id) == _checkpoints_id then
--             for _, currMonster in pairs(currCheckPoint.monster) do
--                 local MonsterXMlObject = CScenesMonsterXML()
--                 MonsterXMlObject : init(currMonster)
--                 table.insert(list, MonsterXMlObject)
--             end
--         end
--     end
--     return list
-- end

-- function MonsterXMLManager.addMonster( self )
--     if _G.g_Stage == nil then
--         return
--     end
--     local scenesID = _G.g_Stage : getMapID()
--     local checkPointsID = _G.g_Stage : getCheckPointsID()
--     local scenesMonsterList = self : getScenesMonsterList( scenesID, checkPointsID)
--     if scenesMonsterList == nil then
--         CCLOG("scenesMonsterList == nil")
--         return
--     end
--     for _, scenesMonster in pairs( scenesMonsterList ) do
--         local monsterProperty = self : getMonsterProperty( scenesMonster.monster_id )
--         if monsterProperty ~= nil then
--             local monster = CMonster(_G.Constant.CONST_MONSTER)
--             monster : monsterInit( monsterProperty, scenesMonster.x, scenesMonster.y )
--             _G.g_Stage : addCharacter( monster )
--         end
--     end
-- end



