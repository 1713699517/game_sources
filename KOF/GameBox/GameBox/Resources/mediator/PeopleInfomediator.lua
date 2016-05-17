require "mediator/mediator"

--require "view/EquipInfoView/EquipInfoView"

PeopleInfo_mediator = class(mediator, function(self, _view)
    self.name = "PeopleInfo_mediator"
    self.view = _view
end)

function PeopleInfo_mediator.getView(self)
    return self.view
end

function PeopleInfo_mediator.getName(self)
    return self.name
end

function PeopleInfo_mediator.processCommand(self, _command)
    print("PeopleInfo_mediator.processCommand",_command)
    if _command:getType() ==PeopleInfoInit_command.TYPE then
        print("PeopleInfoInit_command")

        self:getView() : getChangeHandle() : changePropertText(_command:getModel():getPropertTable())
        self:getView() : getChangeHandle() : changeNameText(_command:getModel():getName())
        self:getView() : getChangeHandle() : changeLvText(_command:getModel():getLv())
        self:getView() : getChangeHandle() : changeRankText(_command:getModel():getRank())
        self:getView() : getChangeHandle() : changeExpText(_command:getModel():getExp())
        self:getView() : getChangeHandle() : changeExpnText(_command:getModel():getExpn())
        self:getView() : getChangeHandle() : changePowerful(_command:getModel():getPowerful())
        return true
        elseif _command:getType() == PeopleInfoChange_command.TYPE then
            self:getView() : getChangeHandle() : ChangeloadOnEquip(_command:getModel():getChangeTable())
    end

    if _command:getType() == CNetworkCommand.TYPE then

        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()

        print("CNetworkCommand.TYPECNetworkCommand.TYPE",_command :getProtocolID())
        if msgID == _G.Protocol["ACK_GOODS_REMOVE"] then        --  2040消失物品
            --print("CNetworkCommand.TYPECNetworkCommand.TYPE")
            --self:getView() : getChangeHandle() :unLoadEquip()
        end
        if(msgID ==_G.Protocol["ACK_GOODS_EQUIP_BACK"] )then    --  2242角色装备信息返回
            self :ACK_GOODS_EQUIP_BACK( ackMsg)
        end
        -- if(msgID ==_G.Protocol["ACK_ROLE_PROPERTY_UPDATE"] )then    --  [1130]玩家单个属性更新
        --     print("ACK_ROLE_PROPERTY_UPDATE")
        --     self :ACK_ROLE_PROPERTY_UPDATE( ackMsg)
        -- end

        -- if(msgID==_G.Protocol["ACK_ROLE_PROPERTY_REVE"])then-- [1108]玩家属性 -- 角色
        --     print("ACK_ROLE_PROPERTY_REVE")
        --     self :ACK_ROLE_PROPERTY_REVE( ackMsg)
        -- end

    end

    return false
end

function PeopleInfo_mediator.ACK_ROLE_PROPERTY_REVE( self,ackMsg)

    print("getUid",ackMsg :getUid())
    print("getName",ackMsg :getName())
    print("getNameColor",ackMsg :getNameColor())
    print("getPro",ackMsg :getPro())
    print("getSex",ackMsg :getSex())
    print("getLv",ackMsg :getLv())
    print("getRank",ackMsg :getRank())
    print("getCountry",ackMsg :getCountry())
    print("getClan",ackMsg :getClan())
    print("getClanName",ackMsg :getClanName())
    print("getAttr",ackMsg :getAttr())
    for k,v in pairs (ackMsg :getAttr())  do
        print(k, v)
    end



    --self.view : initView(self.view.Scenelayer)
    --self.view : layout()

    _G.pRoleEquipLayer = CRoleEquipLayer()
    _G.pRoleEquipLayer :init(_G.pPeopleInfoScene,_G.pPeopleInfoScene.Scenelayer)

    local m_tableRoleProperty = PeopleInfo_model()
    m_tableRoleProperty :setPropertyData( ackMsg :getAttr())

    m_tableRoleProperty :setUid( ackMsg :getUid() )
    m_tableRoleProperty :setName( ackMsg :getName() )
    m_tableRoleProperty :setName_color( ackMsg :getNameColor() )
    m_tableRoleProperty :setPro( ackMsg :getPro() )
    m_tableRoleProperty :setSex( ackMsg :getSex() )
    m_tableRoleProperty :setLv( ackMsg :getLv() )
    m_tableRoleProperty :setRank( ackMsg :getRank() )
    m_tableRoleProperty :setCountry( ackMsg :getCountry() )
    m_tableRoleProperty :setClan( ackMsg :getClan() )
    m_tableRoleProperty :setClanName( ackMsg :getClanName() )
    m_tableRoleProperty :setPowerful( ackMsg :getPowerful() )

    m_tableRoleProperty :setExp( ackMsg :getExp() )
    m_tableRoleProperty :setExpn( ackMsg :getExpn() )
    m_tableRoleProperty :setSkin_weapon ( ackMsg :getSkinWeapon() )
    m_tableRoleProperty :setSkin_armor( ackMsg :getSkinArmor() )
    m_tableRoleProperty :setCount( ackMsg :getCount() )
    m_tableRoleProperty :setPartner( ackMsg :getPartner() )

    local keyBoardCommand = PeopleInfoInit_command(m_tableRoleProperty)
    controller :sendCommand(keyBoardCommand)


    local msg = REQ_GOODS_EQUIP_ASK()
    msg: setUid( _G.g_LoginInfoProxy :getUid() )
    msg: setPartner(0)
    CNetwork :send(msg)

end

function PeopleInfo_mediator.ACK_ROLE_PROPERTY_UPDATE(self,ackMsg)
    print("PeopleInfo_mediator.ACK_ROLE_PROPERTY_UPDATE")
    print(ackMsg :getId())
    print(ackMsg :getType())
    print(ackMsg :getValue())
    local _Type = ackMsg :getType()

    local msgStr
        --    self.CheckTable = {["critharm"] = "暴伤",["wreck"] = "破甲",["crit"] = "暴击",["critres"] = "抗暴",["skillatt"] = "技攻",["skilldef"] = "技防",["strongatt"] = "物攻",["strongdef"] = "物防",["hp"] = "气血",["strong"] = "武力",["magic"] = "内力",["bonus"] = "伤害率",["reduction"] = "免伤率"}

    local _tableFind = {[40]= "hp",[41]= "怒气",[42]= "怒气恢复速度",[43]= "初始灵气值",[44]= "气血值",[45]= "气血成长值",[46]= "strong",[47]= "武力成长",[48]= "magic",[49]= "内力成长",[50]= "strongatt",[51]= "strongdef",[52]= "skillatt",[53]= "skilldef",[54]= "命中",[55]= "躲避",[56]= "crit",[57]= "critres",[58]= "critharm",[59]= "wreck",[60]= "光属性",[61]= "光抗性",[62]= "暗属性",[63]= "暗抗性",[64]= "灵属性",[65]= "灵抗性",[66]= "bonus",[67]= "reduction",[68]= "免疫眩晕",[69]= "攻击"}
    if(_Type == 40 or _Type == 41 or _Type == 43 or _Type == 44 or _Type == 46 or _Type == 48 or _Type == 50 or _Type == 51 or _Type == 52 or _Type == 53 or _Type == 54 or _Type == 55 or _Type == 56 or _Type == 57 or _Type == 58 or _Type == 59 or _Type == 60 or _Type == 61 or _Type == 62 or _Type == 63 or _Type == 64 or _Type == 65 or _Type == 66 or _Type == 67 or _Type == 68 or _Type == 69)then
        msgStr = _tableFind[_Type]
        print("_tableFind_tableFind_tableFind",msgStr)
    end
    if(msgStr ~= nil) then
        self:getView() : getChangeHandle() :updata(msgStr, ackMsg :getValue())
    end
end

function PeopleInfo_mediator.ACK_GOODS_EQUIP_BACK(self,ackMsg)
    print(ackMsg :getUid())
    print(ackMsg :getPartner())
    print(ackMsg :getCount())
    print(ackMsg :getMsgGroup())
    _G.Config:load("config/goods.xml")
    print ("ckMsggetPartner())" , _G.Config.goodss);


    local m_tableChange = ackMsg :getMsgGroup()
    for k,v in pairs(ackMsg :getMsgGroup())do
        print(k,v)
        for i,j in pairs(v)do
            print(i,j)
            if(i == "goods_id")then--根据id查找相关属性
                --m_tableChange[k]["goods_id"] =j
                local taskNode = _G.Config.goodss:selectNode("goods","id",tostring(j));

                -- print("----得到的节点-------" , taskNode.name);
                for a , b in pairs(taskNode) do
                    if(a == "type_sub")then--查找subid
                        m_tableChange[k]["type_sub"] = b
                        --print ( a , b);
                    end
                end
            end
        end
    end

    for k,v in pairs(m_tableChange)do
        for i,j in pairs(v) do
            print(i,j)
        end
    end

    local m_PeopleInfo_model = PeopleInfo_model()
    m_PeopleInfo_model :setChangeTable(m_tableChange)

    local PeopleInfoChangeCommand = PeopleInfoChange_command(m_PeopleInfo_model)
    controller :sendCommand(PeopleInfoChangeCommand)

end