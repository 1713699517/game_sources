
CPeopleInfoChange = class(function(self, _view)
    print("self.view",_view)
    self.view = _view
end)

function CPeopleInfoChange.changePropertText(self,_table)
    print("CPeopleInfoChangechangePropertText",self,self.view)
    for i,v in pairs(_table) do
        print(i,v)
    end
    
    self.view.critharm          :setString(_table["critharm"])
    self.view.wreck             :setString(_table["wreck"])
    self.view.crit              :setString(_table["crit"])
    self.view.critres           :setString(_table["critres"])
    self.view.skillatt          :setString(_table["skillatt"])
    self.view.skilldef          :setString(_table["skilldef"])
    self.view.strongatt         :setString(_table["strongatt"])
    self.view.strongdef         :setString(_table["strongdef"])
    self.view.hp                :setString(_table["hp"])
    self.view.strong            :setString(_table["strong"])
    self.view.magic             :setString(_table["magic"])
    self.view.bonus             :setString(_table["bonus"])
    self.view.reduction         :setString(_table["reduction"])

end
--[[ self.Experience =CCLabelTTF :create("","Arial",self.m_uFontSize)
tempNode = self.Experience
elseif(k==18)then
self.lv =CCLabelTTF :create("","Arial",self.m_uFontSize)
tempNode = self.lv
elseif(k==19)then
self.career =CCLabelTTF :create("","Arial",self.m_uFontSize)
tempNode = self.career
elseif(k==20)then
self.name =CCLabelTTF :create("","Arial",self.m_uFontSize)
tempNode = self.name
elseif(k==21)then
self.ranking =CCLabelTTF :create("","Arial",self.m_uFontSize)
tempNode = self.ranking
]]

--更改竞技排名text
function CPeopleInfoChange.changeRankText(self,_Value)
    self.view.ranking   :setString(_Value)
end


function CPeopleInfoChange.changeExpText(self,_Value)
    self.view.Experience     :setString(_Value)
end

function CPeopleInfoChange.changeExpnText(self,_Value)
    --self.view.m_node["PropertyText"][""] :setString(_Value)
end

function CPeopleInfoChange.changePowerful(self,_Value)
     _G.pRoleEquipLayer.rolePowerful :setString("战斗力："..tostring(_Value))
end

function CPeopleInfoChange.changeProText(self,_Value)
    self.view.career :setString(_Value)
end

function CPeopleInfoChange.changeNameText(self,_Value)
    self.view.name :setString(_Value)
end
function CPeopleInfoChange.changeLvText(self,_Value)
    self.view.lv :setString(_Value)
end
--穿上装备
function CPeopleInfoChange.ChangeloadOnEquip(self,_Value)
    print("CPeopleInfoChange.loadOnEquip",self,self.view.m_node)
    
    local m_table = {}
    for k,v in pairs(_Value)do
        for i,j in pairs(v) do
            print(i,j)
            if(i =="goods_id") then
                m_table["goods_id"] = j
            elseif (i =="type_sub") then
                m_table["type_sub"] = j
            elseif (i =="index") then
                m_table["index"] = j
            --self :loadOnEquip(v,)
            end
        end
        self :loadOnEquip(m_table["goods_id"],m_table["type_sub"],m_table["index"])
    end
end

function CPeopleInfoChange.loadOnEquip(self,_goodsID,_typeSubID,_index)
    print("CPeopleInfoChange.loadOnEquip",_index)
    
    local function EquipBtnCallBack(eventType,obj ,x,y)
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
                
            require "common/protocol/auto/REQ_GOODS_USE"            
            local msg = REQ_GOODS_USE()
            msg: setType(2)
            msg: setTarget(0)
            msg: setFromIndex(_index)
            msg: setCount(1)
            CNetwork :send(msg)
            
            print("EquipBtnCallBackEquipBtnCallBack",eventType,obj)
            obj :removeFromParentAndCleanup (true)
            print("click")
            
        end
    end
    
    
    
    local m_btn = CButton :create(tostring(_goodsID),"Icon/i"..tostring(_goodsID)..".jpg")
    m_btn : setControlName( "this CPeopleInfoChange m_btn 119 ")

    m_btn.index = _index
    m_btn :setFontSize(35)
    m_btn :setColor(ccc3(255,255,255))
    m_btn :registerControlScriptHandler(EquipBtnCallBack)
    _G.pRoleEquipLayer.m_unLoadNode[_typeSubID] = m_btn
   
    print("CPeopleInfoChange.loadOnEquip",_G.pRoleEquipLayer.m_unLoadNode[_typeSubID])
    local _typeStr
    if(tonumber(_typeSubID)~= 11 and tonumber(_typeSubID)~= 12 and tonumber(_typeSubID)~= 13 and tonumber(_typeSubID)~= 14 and tonumber(_typeSubID)~= 15)then
        --"武器"
        m_btn :setPosition(_G.pRoleEquipLayer.weapons :getPreferredSize().width/2,_G.pRoleEquipLayer.weapons :getPreferredSize().height/2)
        _G.pRoleEquipLayer.weapons :addChild(m_btn,0,1)
        print("CPeopleInfoChange.loadOnEquip")
    elseif(tonumber(_typeSubID) == 12)then
        --"衣服"
        m_btn :setPosition(_G.pRoleEquipLayer.clothes :getPreferredSize().width/2,_G.pRoleEquipLayer.clothes :getPreferredSize().height/2)
        _G.pRoleEquipLayer.clothes :addChild(m_btn,0,1)
    
    elseif(tonumber(_typeSubID) == 13)then
        --"披风"
        m_btn :setPosition(_G.pRoleEquipLayer.cloak :getPreferredSize().width/2,_G.pRoleEquipLayer.cloak :getPreferredSize().height/2)
        _G.pRoleEquipLayer.cloak :addChild(m_btn,0,1)
    
    elseif(tonumber(_typeSubID) == 14)then
       --"腰带"
        m_btn :setPosition(_G.pRoleEquipLayer.waistband :getPreferredSize().width/2,_G.pRoleEquipLayer.waistband :getPreferredSize().height/2)
        _G.pRoleEquipLayer.waistband :addChild(m_btn,0,1)
    
    elseif(tonumber(_typeSubID) == 15)then
       --"鞋子"
        m_btn :setPosition(_G.pRoleEquipLayer.shoes :getPreferredSize().width/2,_G.pRoleEquipLayer.shoes :getPreferredSize().height/2)
        _G.pRoleEquipLayer.shoes :addChild(m_btn,0,1)

    elseif(tonumber(_typeSubID) == 11) then
       --"帽子"
        m_btn :setPosition(_G.pRoleEquipLayer.cap :getPreferredSize().width/2,_G.pRoleEquipLayer.cap :getPreferredSize().height/2)
        _G.pRoleEquipLayer.cap :addChild(m_btn,0,1)
    end
end


function CPeopleInfoChange.updata(self,msgStr,_newValue ) 
    print("CPeopleInfoChange.updata",msgStr,_newValue)
    
    --local _tableFind = {[40]= "hp",[41]= "怒气",[42]= "怒气恢复速度",[43]= "初始灵气值",[44]= "气血值",[45]= "气血成长值",[46]= "strong",[47]= "武力成长",[48]= "magic",[49]= "内力成长",[50]= "strongatt",[51]= "strongdef",[52]= "skillatt",[53]= "skilldef",[54]= "命中",[55]= "躲避",[56]= "crit",[57]= "critres",[58]= "critharm",[59]= "wreck",[60]= "光属性",[61]= "光抗性",[62]= "暗属性",[63]= "暗抗性",[64]= "灵属性",[65]= "灵抗性",[66]= "bonus",[67]= "reduction",[68]= "免疫眩晕",[69]= "攻击"}
    if(msgStr=="hp")then
        self.view.critharm          :setString(tostring(_newValue))
    elseif(msgStr=="strong")then
        self.view.strong            :setString(tostring(_newValue))
    elseif(msgStr=="magic")then
        self.view.magic             :setString(tostring(_newValue))
    elseif(msgStr=="strongatt")then
        self.view.strongatt         :setString(tostring(_newValue))
    elseif(msgStr=="strongdef")then
        self.view.strongdef         :setString(tostring(_newValue))
    elseif(msgStr=="skillatt")then
        self.view.skillatt          :setString(tostring(_newValue))
    elseif(msgStr=="skilldef")then
        self.view.skilldef          :setString(tostring(_newValue))
    elseif(msgStr=="crit")then
        self.view.crit              :setString(tostring(_newValue))
    elseif(msgStr=="critres")then
        self.view.critres           :setString(tostring(_newValue))
    elseif(msgStr=="critharm")then   
        self.view.critharm          :setString(tostring(_newValue))
    elseif(msgStr=="wreck")then
        self.view.wreck             :setString(tostring(_newValue))
    elseif(msgStr=="bonus")then
        self.view.bonus             :setString(tostring(_newValue))
    elseif(msgStr=="reduction")then
        self.view.reduction         :setString(tostring(_newValue))
end
    
end

