CSkillEffectXmlManager = class(function ( self )
    self.m_xmlData = {}
end)

function CSkillEffectXmlManager.clean( self )
    self.m_xmlData = {}
end

function CSkillEffectXmlManager.getByID( self, _id )
    _id = tonumber(_id)
    local skillData = self.m_xmlData[_id]
    if skillData == 1 then
        return nil
    end
    if skillData == nil then
        self : initSkillEffectNode(_id)
        skillData = self.m_xmlData[_id]
        if self.m_xmlData[_id] == nil then
            self.m_xmlData[_id] = 1
        end
    end
    return skillData
end

function CSkillEffectXmlManager.initSkillEffectNode( self, _id )
    _G.Config : load("config/skill_effect.xml")
    local skillNode = _G.Config.skill_effect : selectSingleNode("skill[@id=".. tostring(_id).. "]")
    if skillNode : isEmpty() then
        return
    end
    local child = skillNode : children()

    local data = {}
    self.m_xmlData[_id] = data
    data.id = _id
    data.cd = tonumber(skillNode:getAttribute("cd"))
    data.sp = tonumber(skillNode:getAttribute("sp"))
    data.chain = tonumber(skillNode:getAttribute("chain"))
    data.chaincd = tonumber(skillNode:getAttribute("chaincd"))
    data.isSkill = tonumber(skillNode:getAttribute("isSkill"))

    local frame = {}
    data.frame = frame
    local frameCount = child : getCount("frame")
    for i=0,frameCount-1 do
        local frameNode = child : get(i,"frame")
        if not frameNode : isEmpty() then
            local frameData = {}
            frame[i] = frameData
            frameData.id = tonumber(frameNode : getAttribute("id"))
            frameData.time = tonumber(frameNode : getAttribute("time"))
            frameData.collider = tonumber(frameNode : getAttribute("collider"))
            frameData.be_collider = tonumber(frameNode : getAttribute("be_collider"))
            frameData.damage = tonumber(frameNode : getAttribute("damage"))
            frameData.sound = tonumber(frameNode : getAttribute("sound"))

            local buff = {}
            frameData.buff = buff
            local frameChild = frameNode : children()
            local buffCount = frameChild : getCount("buff")
            for i=0,buffCount-1 do
                buffNode = frameChild :get(i,"buff")
                local buffData = {}
                buff[i] = buffData
                buffData.id = tonumber(buffNode : getAttribute("id"))
                buffData.personal = tonumber(buffNode : getAttribute("personal"))
                buffData.collision = tonumber(buffNode : getAttribute("collision"))
            end

            local debuff = {}
            frameData.debuff = debuff
            local frameChild = frameNode : children()
            local debuffCount = frameChild : getCount("debuff")
            for i=0,debuffCount-1 do
                debuffNode = frameChild :get(i,"debuff")
                local debuffData = {}
                debuff[i] = debuffData
                debuffData.id = tonumber(debuffNode : getAttribute("id"))
                debuffData.personal = tonumber(debuffNode : getAttribute("personal"))
                debuffData.collision = tonumber(debuffNode : getAttribute("collision"))
            end

            local addvitro = {}
            frameData.addvitro = addvitro
            local frameChild = frameNode : children()
            local addvitroCount = frameChild : getCount("addvitro")
            for i=0,addvitroCount-1 do
                addvitroNode = frameChild :get(i,"addvitro")
                local addvitroData = {}
                addvitro[i] = addvitroData
                addvitroData.id = tonumber(addvitroNode : getAttribute("id"))
                addvitroData.startX = tonumber(addvitroNode : getAttribute("startX"))
                addvitroData.startY = tonumber(addvitroNode : getAttribute("startY"))
                addvitroData.startZ = tonumber(addvitroNode : getAttribute("startZ"))
                addvitroData.endX = tonumber(addvitroNode : getAttribute("endX"))
                addvitroData.endY = tonumber(addvitroNode : getAttribute("endY"))
                addvitroData.endZ = tonumber(addvitroNode : getAttribute("endZ"))
                addvitroData.speed = tonumber(addvitroNode : getAttribute("speed"))
                addvitroData.useTime = tonumber(addvitroNode : getAttribute("useTime"))
            end

            local effect = {}
            frameData.effect = effect
            local frameChild = frameNode : children()
            local effectCount = frameChild : getCount("effect")
            for i=0,effectCount-1 do
                effectNode = frameChild :get(i,"effect")
                local effectData = {}
                effect[i] = effectData
                effectData.fileName = effectNode : getAttribute("fileName")
                effectData.posX = tonumber(effectNode : getAttribute("posX"))
                effectData.posY = tonumber(effectNode : getAttribute("posY"))
                effectData.delTime = tonumber(effectNode : getAttribute("delTime"))
            end
        end
    end
end

_G.g_SkillEffectXmlManager = CSkillEffectXmlManager()