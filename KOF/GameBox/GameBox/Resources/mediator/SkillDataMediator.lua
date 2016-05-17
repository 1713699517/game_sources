require "mediator/mediator"
require "controller/command"
require "model/VO_SkillModel"
require "common/MessageProtocol"
require "controller/MoneyCommand"

require "common/protocol/ACK_SKILL_PARENTINFO"

CSkillDataMediator = class( mediator, function(self, _view)

    --self.nEquipCount = 0        --计数6545  装备技能信息
    --self.equioInfoList = {}

    self.m_name = "CSkillDataMediator"
    self.m_view = _view
end)

function CSkillDataMediator.getView( self)
   return self.m_view
end

function CSkillDataMediator.getName( self)
   return self.m_name
end

function CSkillDataMediator.processCommand( self, _command)

    if _command :getType() == CNetworkCommand.TYPE then
        local msgID  = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()

        if msgID == _G.Protocol.ACK_SKILL_LIST then                 --6520

            self :ACK_SKILL_LIST( ackMsg)
            local command = CSkillDataUpdateCommand( msgID)
            controller :sendCommand( command)
            
            if _G.g_LoginInfoProxy:getFirstLogin() then
                print("请求开启进入新手副本")
                require "common/protocol/auto/REQ_COPY_CREAT"
                local msg = REQ_COPY_CREAT()
                msg : setCopyId(_G.Constant.CONST_COPY_FIRST_COPY)   -- {副本ID}
                CNetwork : send(msg)
            end
        end
        
        --[[
        elseif  msgID == _G.Protocol.ACK_SKILL_INFO then            --6530

            --self :ACK_SKILL_INFO( ackMsg)
            --local command = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_UPDATE)
            --controller :sendCommand( command)

        elseif  msgID == _G.Protocol.ACK_SKILL_EQUIP_INFO then      --6545
            --self :ACK_SKILL_EQUIP_INFO( ackMsg)
            --local command = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_EQUIP)
            --controller :sendCommand( command)
            
        elseif msgID == _G.Protocol.ACK_SKILL_PARENTINFO then       --6560
            --self :ACK_SKILL_PARENTINFO( ackMsg)
        --]]
    end

    if _command :getType() == CMoneyChangedCommand.TYPE then
        if _command :getData() ~= CMoneyChangedCommand.MONEY then
            return true
        end
        local skillList = {}
        local mainProperty = _G.g_characterProperty : getMainPlay()
        --获取银币
        local gold   = mainProperty :getGold()
        --获取元宝
        local bindRmb     = mainProperty :getBindRmb()
        local rmb         = mainProperty :getRmb()

        skillList.gold      = gold              --美刀
        skillList.rmb_bind  = bindRmb +rmb      --绑定钻石   skillList.rmb_bind = bindRmb +rmb
        skillList.rmb       = bindRmb +rmb

        local uid = _G.g_LoginInfoProxy : getUid()
        local skillData = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
        if skillData == nil then
            skillData = CSkillData()
            _G.g_SkillDataProxy : setCharacterSkill( uid, skillData )
        end
        if skillData ~= nil then
            local skillMoney    = skillData : getSkillList( )

            skillList.power    = skillMoney.power

            skillData :setSkillList( skillList)
        end

    end
    print("退出skillDatamediator")
    return false
end


--6520
function CSkillDataMediator.ACK_SKILL_LIST( self, _ackMsg )
    --print("\n [6520]技能列表数据 ")
    

    local mainProperty = _G.g_characterProperty : getMainPlay()

    local gold        = mainProperty :getGold()
    local bindRmb     = mainProperty :getBindRmb()
    local rmb         = mainProperty :getRmb()

    local skillList     = {}
    skillList.gold      = gold
    skillList.rmb       = bindRmb +rmb
    skillList.power     = _ackMsg :getPower()
    skillList.rmb_bind  = bindRmb +rmb

    --print("gold==", gold, "bindRmb==", bindRmb, "rmb==", rmb, "skillList.power", skillList.power)

    local uid = _G.g_LoginInfoProxy : getUid()
    local skillData = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
    if skillData == nil then
        skillData = CSkillData()
        _G.g_SkillDataProxy : setCharacterSkill( uid, skillData )
    end
    if skillData ~= nil then
        skillData : setSkillList( skillList )
    end

end


--6530
function CSkillDataMediator.ACK_SKILL_INFO( self, _ackMsg )
    local _vo_data = VO_SkillUpdateModel()
    _vo_data:setSkillId( _ackMsg:getSkillId() )
    _vo_data:setSkillLevel( _ackMsg:getSkillLv() )
    self :getView() :setInitialized( true)
    self:getView():setSkillDataInfo( _vo_data )
end


--6545
function CSkillDataMediator.ACK_SKILL_EQUIP_INFO( self, _ackMsg )
    --print("\n [6545]返回装备技能信息 --次数 self.nEquipCount=", self.nEquipCount)

    local equip_pos = tonumber( _ackMsg:getEquipPos())
    local skill_id  = tonumber( _ackMsg:getSkillId())
    local skill_lv  = tonumber( _ackMsg:getSkillLv())
                 
     --------new add
     print("[6545]返回", equip_pos, skill_id, skill_lv)
     local _vo_data = VO_Skill6545Model()
     _vo_data :setEquipId( skill_id)
     _vo_data :setEquipPos( equip_pos)
     _vo_data :setEquipLv( skill_lv)
     
     self :getView() :setInitialized( true)
     self :getView() :setEquipDataInfo( _vo_data)
     --------
    
     local l_equipInfoList = self :getView() :getEquipDataInfoList()
     if l_equipInfoList ~= nil then
         for key, value in pairs( l_equipInfoList) do
            print("l_equipInfoList==", key, value)
         end
     end
     local uid = _G.g_LoginInfoProxy : getUid()
     local skillData = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
     print("时刻注意异常情况，一路跟下去6", skillData)
     if skillData == nil then
         print("时刻注意异常情况，一路跟下去5", skillData)
         skillData = CSkillData()
         _G.g_SkillDataProxy : setCharacterSkill( uid, skillData )
     end
     print("时刻注意异常情况，一路跟下去4", skillData)
     skillData : setSkillIdByIndex( skill_id, equip_pos )
     print("时刻注意异常情况，一路跟下去3", skillData)
     skillData : setSkillEquipInfo( l_equipInfoList)
     print("时刻注意异常情况，一路跟下去2", skillData)
     skillData = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
     print("时刻注意异常情况，一路跟下去1", skillData)
                 
                 
end

function CSkillDataMediator.ACK_SKILL_PARENTINFO( self, _ackMsg)
    print("6560.ACK_SKILL_PARENTINFO", _ackMsg :getSkillId(), _ackMsg :getSkillLv())
    local _vo_data = {}
    _vo_data.skill_id = _ackMsg :getSkillId()
    _vo_data.skill_lv = _ackMsg :getSkillLv()
    
    self :getView() :setInitialized( true)
    self :getView() :setPartnerSkillData( _vo_data)
    
    if self :getView() :getPartnerSkillDataList() == nil then
        return
    end

    local partnerCommand = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_PARTNER)
    controller :sendCommand( partnerCommand)
end




