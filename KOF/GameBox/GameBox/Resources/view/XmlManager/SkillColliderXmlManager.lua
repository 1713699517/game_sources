
-- skill_collider.xml
CSkillColliderXmlManager = class( function ( self )
    self.m_xmlData = {}
end)

function CSkillColliderXmlManager.clean( self )
    self.m_xmlData = {}
end

function CSkillColliderXmlManager.getByID( self, _id )
    _id = tonumber( _id )
    local skillData = self.m_xmlData[ _id ]
    if skillData == 1 then
        return nil
    end
    if skillData == nil then
        self : initSkillNode( _id )
        skillData = self.m_xmlData[ _id ]
        if self.m_xmlData[_id] == nil then
            self.m_xmlData[_id] = 1
        end
    end
    return skillData
end

function CSkillColliderXmlManager.initSkillNode( self, _id )
    _G.Config : load("config/skill_collider.xml")
    local skillColliderNode = _G.Config.skill_collider : selectSingleNode("collider[@id=".. tostring( _id ) .. "]")
    if skillColliderNode : isEmpty() then
        return
    end

    local data = {}
    self.m_xmlData[_id] = data

    data.offsetX = tonumber(skillColliderNode :getAttribute( "offsetX" ))
    data.offsetY = tonumber(skillColliderNode :getAttribute( "offsetY" ))
    data.offsetZ = tonumber(skillColliderNode :getAttribute( "offsetZ" ))
    data.vWidth  = tonumber(skillColliderNode :getAttribute( "vWidth" ))
    data.vHeight = tonumber(skillColliderNode :getAttribute( "vHeight" ))
    data.vRange  = tonumber(skillColliderNode :getAttribute( "vRange" ))

end

_G.g_SkillColliderXmlManager = CSkillColliderXmlManager()