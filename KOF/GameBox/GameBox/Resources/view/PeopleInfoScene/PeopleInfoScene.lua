require "view/view"
require "mediator/mediator"

require "model/VO_PeopleInfoModel"
require "controller/PeopleInfoControll"
require "mediator/PeopleInfomediator"
require "view/PeopleInfoScene/PeopleInfoChange"
require "view/PeopleInfoScene/RoleEquipLayer"
require "view/PeopleInfoScene/PeopleInfoPropsLayer"
require "common/protocol/auto/REQ_ROLE_PROPERTY"
require "common/protocol/auto/REQ_GOODS_EQUIP_ASK"
--_G.pPeopleInfoScene

CPeopleInfoScene = class(view, function(self) end)

function CPeopleInfoScene.scene(self)
    print("CPeopleInfoScene.scene")
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local _scene = CCScene :create()

    _scene :addChild(self:layer())
    return _scene--self.scene
end

function CPeopleInfoScene.loadResources( self )

end


function CPeopleInfoScene.layer(self)
    print("CPeopleInfoScene.layer")
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer = CContainer :create()
    self.Scenelayer : setControlName( "this is CPeopleInfoScene self.Scenelayer 37  " )

    self:init(winSize, self.Scenelayer)
    return self.Scenelayer
end
function CPeopleInfoScene:getChangeHandle()
    return self.ChangeHandle
end

function CPeopleInfoScene.initParameter(self,layer)
    local m_changeHandle = CPeopleInfoChange(self)
    print("CPeopleInfoScene.initParameter",m_changeHandle,self)
    self.ChangeHandle = m_changeHandle
    self.m_uFontSize = 15
    self.m_table ={}
    --m_table方便对应date表和node之间的关系
    self.m_table["PropertyText"] = {[1]="暴伤",[2]="破甲",[3]="暴击",[4]="抗暴",[5]="技攻",[6]="技防",[7]="物攻",[8]="物防",[9]="气血",[10]= nil,[11]="武力",[12]="内力",[13]="伤害率",[14]="免伤率",[15]="PVP属性",[16]="经验:",[17]=nil,[18]="等级:",[19]="职业:",[20]="玩家名字:",[21]="竞技排名:"}

    self.m_ProgertyTextLayout ={}   --右边属性文字的布局
    self.m_PeopleInfoViewLayer ={}  --人物信息layer


    --存储的数据索引
    --self.m_date = nil
    --根据node找到 需要更改的ccnode指针
    self.m_node ={["PropertyText"]={}}

end

function CPeopleInfoScene.setDate(self, date)
    self.m_date = date
end

function CPeopleInfoScene.init(self, winSize, layer)

    --初始化界面操作在mediator里面
    self :loadResources()
    self :initParameter(layer)
    self :initView()
    self :layout()
    local m_model = PeopleInfo_model()

    self.mediator = PeopleInfo_mediator( self)
    print("999999999")
    controller :registerMediator(self.mediator)

    require "common/protocol/auto/REQ_ROLE_PROPERTY"
    msg = REQ_ROLE_PROPERTY()
    msg: setSid(_G.g_LoginInfoProxy :getServerId())
    msg: setUid(_G.g_LoginInfoProxy :getUid())
    msg: setType(0)
    CNetwork :send(msg)
    print("######################################\n")

end

function CPeopleInfoScene.initView(self,layer)
    print("CPeopleInfoScene.initView",self,self.Scenelayer)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_PeopleInfoViewLayer = CCLayer :create();
    self.Scenelayer :addChild(self.m_PeopleInfoViewLayer)
    self :initPeopleInfoLayout()
    self :initPeopleInfo()
    self :initPeopleName()


    function closeLayer( eventType, obj, x, y)
        print("CPeopleInfoScene.closeLayerCEquipInfoView:initBtnCEquipInfoView:initBtn")
        if eventType == "TouchBegan" then
            local ret = obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
            print( "XXXXXXXXXXXXXXXXXXXX", ret)
            return ret
        elseif eventType == "TouchEnded" then
            _G.pPeopleInfoScene.Scenelayer :removeAllChildrenWithCleanup(true)
            self.Scenelayer :removeAllChildrenWithCleanup(true)
            controller :unregisterMediator(self.mediator)
            CCDirector : sharedDirector () : popScene()
        end
    end

    self.closeBtn = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.closeBtn :registerControlScriptHandler( closeLayer)
    self.Scenelayer :addChild(self.closeBtn)

    self.m_imgBackGround = CSprite :createWithSpriteFrameName("general_main_underframe.png")
    self.m_imgBackGround : setControlName( "this CPeopleInfoScene self.m_imgBackGround 118 ")
    self.m_imgBackGround :setPreferredSize(CCSizeMake(winSize.width,winSize.height))
    self.Scenelayer :addChild(self.m_imgBackGround,-1)
end

function CPeopleInfoScene.layout(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then

        local _posX = 30
        local _poxY = 20
        self.m_imgBackGround :setPosition(winSize.width/2,winSize.height/2)

        self.m_PeopleInfoViewLayer                  :setPosition(winSize.width/2+180+_posX,winSize.height/2-300)
        self.m_ProgertyTextLayout["Property"]       :setPosition(winSize.width/2-720+_posX,winSize.height/2-130)
        self.m_ProgertyTextLayout["PVP"]            :setPosition(winSize.width/2-800+_posX,winSize.height/2-270)
        self.m_ProgertyTextLayout["Name"]           :setPosition(winSize.width/2-800+_posX,winSize.height/2+160)

        self.m_node["PropertyText"]["background"]   :setPosition(winSize.width/2-520+_posX,winSize.height/2-40)
        self.closeBtn                :setPosition(winSize.width-self.closeBtn :getPreferredSize().width/2,winSize.height-self.closeBtn :getPreferredSize().height/2)
    elseif winSize.height == 768 then
        CCLOG("768--资源")

    end
end

function CPeopleInfoScene.initPeopleInfoLayout(self)

    self.m_node["PropertyText"]["background"] = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_node["PropertyText"]["background"] :setPreferredSize(CCSizeMake(400,580))
    self.m_PeopleInfoViewLayer :addChild(self.m_node["PropertyText"]["background"])

    self.m_ProgertyTextLayout["PVP"] = {}
    self.m_ProgertyTextLayout["PVP"] = CHorizontalLayout :create()
    self.m_ProgertyTextLayout["PVP"] :setCellSize(CCSizeMake(200,50))
    self.m_ProgertyTextLayout["PVP"] :setLineNodeSum(2)
    self.m_PeopleInfoViewLayer :addChild(self.m_ProgertyTextLayout["PVP"],10)

    self.m_ProgertyTextLayout["Name"] = {}
    self.m_ProgertyTextLayout["Name"] = CHorizontalLayout :create()
    self.m_ProgertyTextLayout["Name"] :setCellSize(CCSizeMake(200,30))
    self.m_ProgertyTextLayout["Name"] :setLineNodeSum(2)
    self.m_PeopleInfoViewLayer :addChild(self.m_ProgertyTextLayout["Name"],10)

    self.m_ProgertyTextLayout["Property"] = CHorizontalLayout :create()
    self.m_ProgertyTextLayout["Property"] :setCellSize(CCSizeMake(200,50))
    self.m_ProgertyTextLayout["Property"] :setLineNodeSum(2)
    self.m_ProgertyTextLayout["Property"] :setVerticalDirection(true)

    self.m_PeopleInfoViewLayer :addChild(self.m_ProgertyTextLayout["Property"],10)
end

function CPeopleInfoScene.initPeopleInfo(self)
    for k=1, 12 do
        if(k==10 )then
            self.m_ProgertyTextLayout["Property"] :addChild(CCNode :create())
            else
            local tempSprite = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
            local tempLable =CCLabelTTF :create(self.m_table["PropertyText"][k],"Arial",self.m_uFontSize)
            local tempNode  =nil
            tempSprite :setPreferredSize(CCSizeMake(165,45))
            tempLable :setColor(ccc3(255,255,0))
            tempLable :setPosition(30,15)
            tempSprite :addChild(tempLable)

            if (k == 1)then
                self.critharm =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.critharm
            elseif (k == 2)then
                self.wreck =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.wreck
            elseif (k == 3)then
                self.crit =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.crit
            elseif (k == 4)then
                self.critres =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.critres
            elseif (k == 5)then
                self.skillatt =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.skillatt
            elseif (k == 6)then
                self.skilldef =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.skilldef
            elseif (k == 7)then
                self.strongatt =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.strongatt
            elseif (k == 8)then
                self.strongdef =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.strongdef
            elseif (k == 9)then
                self.hp =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.hp
            elseif (k == 11)then
                self.strong =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.strong
            elseif (k == 12)then
                self.magic =CCLabelTTF :create("","Arial",self.m_uFontSize)
                tempNode = self.magic
            end
            tempNode :setColor(ccc3(255,0,255))
            tempNode :setPosition(115,15)
            tempSprite :addChild(tempNode)
            print("self.m_ProgertyTextLayout",tempSprite,k)
            self.m_ProgertyTextLayout["Property"] :addChild(tempSprite)
        end
    end

    for k=13,15 do
        local tempSprite
        local m_tempLable
        if k==15 then
            m_tempLable =CCLabelTTF :create("PVP属性","Arial",self.m_uFontSize)
            tempSprite = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
            else
            tempSprite = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
            if(k==13)then
                m_tempLable =CCLabelTTF :create("伤害率","Arial",self.m_uFontSize)
                self.bonus =CCLabelTTF :create("".."%","Arial",self.m_uFontSize)
                self.bonus :setPosition(115,15)
                tempSprite :addChild(self.bonus)
            end
            if(k==14)then
                m_tempLable =CCLabelTTF :create("免伤率","Arial",self.m_uFontSize)
                self.reduction =CCLabelTTF :create("".."%","Arial",self.m_uFontSize)
                self.reduction :setPosition(115,15)
                tempSprite :addChild(self.reduction)
            end
        end

        m_tempLable :setColor(ccc3(255,0,255))
        m_tempLable :setPosition(32,15)
        tempSprite :setPreferredSize(CCSizeMake(165,45))
        tempSprite :addChild(m_tempLable)
        tempSprite :setAnchorPoint(ccp(0,0))
        self.m_ProgertyTextLayout["PVP"] :addChild(tempSprite)
    end

end

function CPeopleInfoScene.initPeopleName(self)
    for k=16,21 do
        if(k==17)then
            self.m_ProgertyTextLayout["Name"] :addChild(CCNode :create())
        else
        local m_tempNode =CCNode :create()
        local tempLable =CCLabelTTF :create(self.m_table["PropertyText"][k],"Arial",self.m_uFontSize)
        tempLable :setPosition(32,15)
        tempLable :setColor(ccc3(0,125,255))
        local tempNode =nil
        --="免伤率",[15]="PVP属性",[16]="经验:",[17]=nil,[18]="等级:",[19]="职业:",[20]="玩家名字:",[21]="竞技排名:"}
            if(k==16)then
                self.Experience =CCLabelTTF :create("","Arial",self.m_uFontSize)
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
            end
        tempNode :setPosition(115,15)
        tempNode :setColor(ccc3(255,0,255))
        m_tempNode :setAnchorPoint(ccp(0,0))
        m_tempNode :addChild(tempLable)
        m_tempNode :addChild(tempNode)
        self.m_ProgertyTextLayout["Name"] :addChild(m_tempNode)
        end
    end
end

