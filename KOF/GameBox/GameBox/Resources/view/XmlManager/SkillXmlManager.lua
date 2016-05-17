CSkillXmlManager = class(function ( self )
    self.m_xmlData = {}
end)

function CSkillXmlManager.clean( self )
    self.m_xmlData = {}
end

function CSkillXmlManager.getByID( self, _id )
    _id = tonumber(_id)
    local skillData = self.m_xmlData[_id]
    if skillData == 1 then
        return nil
    end
    if skillData == nil then
        self : initSkillNode(_id)
        skillData = self.m_xmlData[_id]
        if self.m_xmlData[_id] == nil then
            self.m_xmlData[_id] = 1
        end
    end
    return skillData
end

function CSkillXmlManager.initSkillNode( self, _id )
    _G.Config : load("config/skill.xml")
    local skillNode = _G.Config.skills : selectSingleNode("skill[@id=".. tostring(_id).. "]")
    if skillNode : isEmpty() then
        return
    end
    local child = skillNode : children()

    local data = {}
    self.m_xmlData[_id] = data

    --等级
    local lvs = {}
    data.lvs = lvs

    local lvsNode = child:get(0,"lvs")
    if not lvsNode : isEmpty() then
        local lvsChild = lvsNode : children()
        local lvCount = lvsChild : getCount("lv")
        for i=0,lvCount-1 do
            local lvNode = lvsChild : get(i)
            if not lvNode : isEmpty() then
                local lv = {}
                lvs[tonumber(lvNode : getAttribute("lv"))] = lv
                local lvChild = lvNode : children()
                local mcNode = lvChild : get(0,"mc")
                if not mcNode : isEmpty() then
                    local mc = {}
                    lv.mc = mc
                    mc.mc_arg2 = tonumber(mcNode : getAttribute("mc_arg2"))
                end
            end
        end
    end
end

_G.g_SkillXmlManager = CSkillXmlManager()