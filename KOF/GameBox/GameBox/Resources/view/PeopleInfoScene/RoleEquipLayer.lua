
CRoleEquipLayer = class()


function CRoleEquipLayer.nextRole()
    print("sdfsdfsdfsdfds")
    _G.pRoleEquipLayer.m_pScrollView :SetPage(_G.pRoleEquipLayer.m_pScrollView :GetPage()-1)
    return false
end

function CRoleEquipLayer.initScrollViewAndLayer(self,m_uPageSum)
    self.m_RoleEquipViewLayer =CCLayer :create()
    self.m_pScrollView =CPageScrollView :create(2,self.PageScrollViewSize)
    self.m_pScrollView :setViewSize(self.PageScrollViewSize)
    self.m_pScrollView :setContainer(self.m_RoleEquipViewLayer)
    
 
    self.m_pScrollView :setDirection(1)
    self.Scenelayer :addChild(self.m_pScrollView)
    self.m_pScrollView :SetContainerPageAndSize(m_uPageSum, self.m_pScrollView :getViewSize())
    self.m_pScrollView :SetPage(m_uPageSum-1)
end


function CRoleEquipLayer.loadResources(self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("PeopleInfoResources/RoleResources.plist")
end

function CRoleEquipLayer.initView(self)
    self.m_uFontSize = 15
    local m_uPageSum = 1
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.PageScrollViewSize = CCSizeMake(550,580)
    
    self: initScrollViewAndLayer(m_uPageSum)
    
    self.m_unLoadNode = {}
    self.m_node= {["RolePageNode"]  = {},["RoleEquip"]={},["button"]={["关闭"]=nil,["全部卸下"]=nil,["下一个角色x"]=nil}}
    self.m_table = {}
    self.m_table["RoleEquip"]       = {[1]="鞋子",[2]="腰带",[3]="衣服",[4]="披风",[5]="武器",[6]="帽子",["RoleText"]={[1]="称号",[2]="战斗力",[3]="命格"}}
    self.m_node["PageContainer"]    = {}

    
    for m_page =0,m_uPageSum-1 do
        self.m_node["PageContainer"] =CContainer :create()
        self.m_node["PageContainer"] : setControlName( "this is CRoleEquipLayer self.m_node[PageContainer] 46  " )
        
        --local nnnnnn = CCSprite :createWithSpriteFrameName("People.png")
        -- nnnnnn :setPosition(300,10)
        self.m_node["RolePageNode"][m_page]= CCNode :create()
        self.m_pScrollView :addPage(self.m_node["PageContainer"]);
        -- self.m_node["PageContainer"] :addChild(nnnnnn)
        self.m_RoleEquipViewLayer :addChild(self.m_node["RolePageNode"][m_page])
        self : initEquipLayout(m_page)
        self : initEquipView(m_page)
        self : initRolePageScrollViewPosition(m_page)
    end
    
    self :initSelectLayerBtn()

end

function CRoleEquipLayer.layout(self)
    local winSize  = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        local _posX = 40
        local _poxY = 20

        self.m_pScrollView          :setPosition(winSize.width/2-520+_posX          ,10)
        self.SelectLayerBtnLayout   :setPosition(winSize.width/2-530+_posX    ,285+winSize.height/2)

        elseif winSize.height == 768 then
        CCLOG("768--资源")
    end

end

function CRoleEquipLayer.init(self,_pScene,layer)
    print("CRoleEquipLayer:initRoleEquipView")
    self.Scenelayer = layer
    self: loadResources()
    self: initView()
    self: layout()

end


function CRoleEquipLayer.initRolePageScrollViewPosition(self,m_page)
    self.m_LayoutEquip :setPosition(-240,180)
    
    self.m_node["RoleEquip"]["background"]  :setPosition(50,290)
    
    self.m_node["RoleEquip"]["People"]      :setPosition(70,self.m_node["RoleEquip"]["background"] :getPositionY())
    self.roleTitle                          :setPosition(self.weapons :getPositionX()+self.m_LayoutEquip :getPositionX(),self.weapons :getPositionY()+self.m_LayoutEquip :getPositionY()+100)
    self.m_node["RolePageNode"][m_page]     :setPosition(200,self.m_node["RoleEquip"]["background"]: getPreferredSize().height * m_page)
end

function CRoleEquipLayer.initEquipView(self,m_page)
    --self.m_table["RoleEquip"] = {[1]="鞋子",[2]="腰带",[3]="衣服",[4]="披风",[5]="武器",[6]="帽子"}
    self:initBtn(m_page)
    
    --角色装备box背景图片
    for k=1,6 do
        if(k ==1)then
            self.shoes = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.shoes,0,-1)
            
        elseif(k==2)then
            self.waistband = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.waistband,0,-1)
            
        elseif(k==3)then
            self.clothes = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.clothes,0,-1)
            
        elseif(k==4)then
            
            self.cloak = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.cloak,0,-1)
            
        elseif(k==5)then
            self.weapons = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.weapons,0,-1)
            
        elseif(k==6)then
            self.cap = CCScale9Sprite :createWithSpriteFrameName("general_the_props.png")
            self.m_LayoutEquip :addChild(self.cap,0,-1)
        end
    end
    --["RoleText"]={[1]="称号",[2]="战斗力",[3]="命格"}}
    --装备上面的三个文字
    self.roleTitle                      =CCLabelTTF :create("","Arial",self.m_uFontSize);
    self.roleTitle                      :setFontSize(self.m_uFontSize)
    self.m_node["RolePageNode"][m_page] :addChild(self.roleTitle)
    self.roleTitle                      :setColor(ccc3(255,0,0))
    
    local templabel                     =CCLabelTTF :create("称号:","Arial",17)
    --+self.m_node["RoleEquip"]["background"]: getContentSize().height * m_page
    templabel :setPosition(0,9)
    self.roleTitle :addChild(templabel)

    self.rolePowerful = CCLabelTTF :create("","Arial",self.m_uFontSize)
    self.rolePowerful :setColor(ccc3(255,0,0))
    self.rolePowerful :setPosition (160,9)
    templabel :addChild(self.rolePowerful)
    
    self.roleFate=CButton :createWithSpriteFrameName("","role_ability.png")
    self.roleFate : setControlName( "this CRoleEquipLayer self.roleFate 148 ")
    self.roleFate :setFontSize(self.m_uFontSize)
    self.roleFate :setColor(ccc3(0,0,0))
    self.roleFate :setPosition (335,0)
    self.roleTitle :addChild(self.roleFate)
    
end

function CRoleEquipLayer.initEquipLayout(self,m_page)
    
    self.m_node["RoleEquip"]["background"] = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_node["RoleEquip"]["background"] :setPreferredSize(CCSizeMake(480,self.PageScrollViewSize.height) )
    self.m_node["RolePageNode"][m_page] :addChild(self.m_node["RoleEquip"]["background"])
    
    self.m_node["RoleEquip"]["People"] = CCSprite :createWithSpriteFrameName("People.png")
    
    self.m_node["RolePageNode"][m_page] :addChild(self.m_node["RoleEquip"]["People"])
    
    self.m_LayoutEquip = CHorizontalLayout :create()
    self.m_LayoutEquip :setCellSize(CCSizeMake(300,130))
    self.m_LayoutEquip :setLineNodeSum(2)
    self.m_node["RolePageNode"][m_page] :addChild(self.m_LayoutEquip,10)
end
function CRoleEquipLayer.initBtn(self,m_page)

    function CRoleEquipLayer.unloadEquip(eventType,obj,x,y)
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
            self:onUnloadEquip()
        end
    end
    
    self.unLoad = CButton :createWithSpriteFrameName("全部卸下","general_two_label_normal.png")
    self.unLoad : setControlName( "this CRoleEquipLayer self.unLoad 182 ")
    self.unLoad :setFontSize(self.m_uFontSize)

    self.unLoad :setColor(ccc4(0,0,0,255))
    self.unLoad :registerControlScriptHandler(CRoleEquipLayer.unloadEquip, "this CRoleEquipLayer self.unLoad 186")
    self.m_node["RolePageNode"][m_page] :addChild(self.unLoad,10)
    
    self.btnNextRole = CButton :createWithSpriteFrameName("","role_triangle.png")
    self.btnNextRole : setControlName( "this CRoleEquipLayer self.btnNextRole 190 ")

    self.btnNextRole :setColor(ccc4(0,0,0,255))
    self.btnNextRole :registerControlScriptHandler(CRoleEquipLayer.nextRole, "this CRoleEquipLayer self.btnNextRole 193")
    self.m_node["RolePageNode"][m_page] :addChild(self.btnNextRole,10)
    
    self.btnRest = CButton :createWithSpriteFrameName("休息","general_two_label_normal.png")
    self.btnRest : setControlName( "this CRoleEquipLayer self.btnRest 197 ")
    self.btnRest :setFontSize(self.m_uFontSize)

    self.btnRest :setColor(ccc4(0,0,0,255))
    --self.btnRest :registerControlScriptHandler(CPeopleInfoScene.nextRole)
    self.m_node["RolePageNode"][m_page] :addChild(self.btnRest,10)
    
    local _posX = 40
    self.btnRest :setPosition(-150+_posX,50)
    self.btnNextRole:setPosition(_posX,50)
    self.unLoad:setPosition(150+_posX ,50)
end

function CRoleEquipLayer.onUnloadEquip(self)
    require "common/protocol/auto/REQ_GOODS_USE"
    for k ,v in pairs(self.m_unLoadNode)do
        print("CRoleEquipLayer.onUnloadEquip",k,v)
        v :removeFromParentAndCleanup(true)
        local msg = REQ_GOODS_USE()
        msg: setType(2)
        msg: setTarget(0)
        msg: setFromIndex(v.index)
        msg: setCount(1)
        CNetwork :send(msg)
    end
    self.m_unLoadNode = nil
end


function CRoleEquipLayer:initSelectLayerBtn()
    
    self.SelectLayerBtnLayout = CHorizontalLayout :create()
    self.SelectLayerBtnLayout :setCellSize(CCSizeMake(150,0))
    self.SelectLayerBtnLayout :setLineNodeSum(3)

    self.Scenelayer :addChild(self.SelectLayerBtnLayout,10)
    
    self.attributBtn = CButton :createWithSpriteFrameName("属性","general_two_label_normal.png")
    self.attributBtn : setControlName( "this CRoleEquipLayer self.attributBtn 235 ")
    self.attributBtn :setPreferredSize(CCSizeMake(120,50))
    self.attributBtn :setFontSize(self.m_uFontSize)
    self.attributBtn :setColor(ccc4(0,0,0,255))
    self.SelectLayerBtnLayout :addChild(self.attributBtn)
    
    self.goodsBtn = CButton :createWithSpriteFrameName("道具","general_two_label_normal.png")
    self.goodsBtn : setControlName( "this CRoleEquipLayer self.goodsBtn 242 ")
    self.goodsBtn :setFontSize(self.m_uFontSize)
    self.goodsBtn :setPreferredSize(CCSizeMake(120,50))
    self.goodsBtn :registerControlScriptHandler(CPeopleInfoScene.unloadEquip, "this CRoleEquipLayer self.goodsBtn 245")
    self.goodsBtn :setColor(ccc4(0,0,0,255))
    self.SelectLayerBtnLayout :addChild(self.goodsBtn,10)
    
    self.artifactBtn = CButton :createWithSpriteFrameName("神器","general_two_label_normal.png")
    self.artifactBtn : setControlName( "this CRoleEquipLayer self.artifactBtn 250 ")
    self.artifactBtn :setFontSize(self.m_uFontSize)
    self.artifactBtn :setPreferredSize(CCSizeMake(120,50))
    self.artifactBtn :registerControlScriptHandler(CPeopleInfoScene.nextRole, "this CRoleEquipLayer self.artifactBtn 253")
    self.artifactBtn :setColor(ccc4(0,0,0,255))
    self.SelectLayerBtnLayout :addChild(self.artifactBtn,10)
end

