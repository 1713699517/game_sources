require "common/protocol/auto/REQ_MAKE_KEY_STREN"
require "mediator/EquipStrengthenMediator"
require "model/VO_BackpackModle"
require "common/protocol/auto/REQ_GOODS_REQUEST"
require "common/protocol/auto/REQ_MAKE_STREN_DATA_ASK"

CEquipStrengthenLayer = class(view,function (self)
                        self.isstr_need   = nil
                        self.thepartnerId = 0
                        self.pushDataId   = 0 
                        self.TheFirstIndex   = {}
                        self.TheFirstIndexNo = 1
                           end)
--CCharacterProperty.getLv 拿人物等级


function CEquipStrengthenLayer.layer(self)
    local winSize     = CCDirector:sharedDirector():getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CEquipStrengthenLayer _layer 14" )
    print("CEquipStrengthenLayer.layer",self)
    self : init(winSize, self.m_scenelayer)

    return self.m_scenelayer
end

function CEquipStrengthenLayer.loadResources(self)
 
    _G.Config:load("config/goods.xml")
    _G.Config:load("config/equip_make.xml")
    _G.Config:load("config/partner_init.xml")
end

function CEquipStrengthenLayer.layout(self, winSize)  --适配布局
    local IpadSize    = 854
    if winSize.height == 640 then
        --self.m_allBackGround      : setPosition(winSize.width/2,winSize.height/2)             --总底图
        self.m_leftBackGround     : setPosition(250,358-5)    --左底图
        self.m_leftdownBackGround : setPosition(250,80-9+2)   --左底图
        self.m_rightBackGround    : setPosition(665,290-3)    --右底图
   
        --self.m_pScrollView        : setPosition(60,167)     --活动页0.052
        --self.roleNameLabel        : setPosition(winSize.width/2*0.6,winSize.height/2*0.375)     --人物名字
        --self.equipInfoArea_layer  : setPosition(winSize.width/2*1.125,winSize.height/2*0.72)    --宝石区域
        elseif winSize.height == 768 then
        --self.m_allBackGround      : setPosition(winSize.width/2,winSize.height/2)             --总底图
        self.m_leftBackGround     : setPosition(250,358)    --左底图
        self.m_leftdownBackGround : setPosition(250,80)     --左底图
        self.m_rightBackGround    : setPosition(665,290)    --右底图

        --self.m_pScrollView        : setPosition(60,167)     --活动页0.052
        --self.roleNameLabel        : setPosition(winSize.width/2*0.6,winSize.height/2*0.375)     --人物名字
        --self.equipInfoArea_layer  : setPosition(winSize.width/2*1.125,winSize.height/2*0.72)    --宝石区域
    end
end

function CEquipStrengthenLayer.init(self, winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(winSize,_layer)              --界面初始化
    self : layout(winSize)                       --适配布局初始化
    self : initParameter()                       --参数初始化
    self : getTeamersData()                      --小伙伴初始化
    self : DefaultFirstEquip()                   --默认第一个装备
end

function CEquipStrengthenLayer.initView(self,winSize,_layer)

    --self.m_allBackGround    = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.jpg") --总底图
    self.m_leftBackGround     = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_leftdownBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround    = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图
    
    --self.m_allBackGround    : setPreferredSize(CCSizeMake(winSize.width*0.93,winSize.height*0.82))          --530 890
    self.m_leftBackGround     : setPreferredSize(CCSizeMake(410,425)) --420 260
    self.m_leftdownBackGround : setPreferredSize(CCSizeMake(410,130-5)) --420 260
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(410,550+5)) --400 500
    
    --_layer : addChild(self.m_allBackGround,-1)
    _layer : addChild(self.m_leftBackGround)
    _layer : addChild(self.m_leftdownBackGround)
    _layer : addChild(self.m_rightBackGround)

    local function BagEquipButtonCallBack(eventType,obj,x,y)
        return self:BagEquipBtnCallBack(eventType,obj,x,y)
    end
--活动页
    -- local m_ViewSize      = CCSizeMake(388,390)
    -- self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    -- self.m_pScrollView    : setTouchesPriority(1)
    -- _layer                : addChild(self.m_pScrollView)
    
    self.m_BagEquipBtn       = {} --背包装备物品按钮
    self.m_BagEquipBtnSprite = {} --背包装备物品按钮图
    self.BagEquipBtnSprites  = {} --背包装备物品按钮图
    self.effectsCCBI         = {} --物品特效
    -- for i=1,4 do
    --     local pageContiner = CContainer : create()
    --     pageContiner       : setControlName( "this is CEquipEnchantView pageContainer 74" )
        local iconLayout   = CHorizontalLayout : create()
        iconLayout         : setControlName( "this is CEquipEnchantView iconLayout 76" )

        iconLayout   : setLineNodeSum(2)
        iconLayout   : setCellSize(CCSizeMake(293-30,140-10))
        iconLayout   : setVerticalDirection(false)
        iconLayout   : setPosition(-45+32,358+140-13)
        --iconLayout   : setPosition(-296,140)
        _layer       : addChild(iconLayout)

        -- self.m_pScrollView : addPage(pageContiner)
        for k=1,6 do
            -- num = (i-1)*6+k
            self.m_BagEquipBtn[k] = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
            self.m_BagEquipBtn[k] : setControlName( "this is CEquipStrengthenLayer self.m_BagEquipBtn[k] 108" )
            self.m_BagEquipBtn[k] : registerControlScriptHandler(BagEquipButtonCallBack,"this is CEquipEnchantView.initView m_BagEquipBtn 108")
            self.m_BagEquipBtn[k] : setTouchesPriority( -100 )
            iconLayout :  addChild(self.m_BagEquipBtn[k])

            self.BagEquipBtnSprites[k] = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
            self.m_BagEquipBtn[k]      :  addChild(self.BagEquipBtnSprites[k],3) 

            --框底图
            local BlackSprite          = CSprite :createWithSpriteFrameName("general_props_underframe.png")
            self.m_BagEquipBtn[k]      :  addChild(BlackSprite,-2) 
        end
    -- end
    -- self.m_pScrollView : setPage(0, false)--设置起始页[0,1,2,3...]

     -- self.roleNameLabel = CCLabelTTF : create ("","Arial",20) --获取人物名字
     -- _layer : addChild(self.roleNameLabel,2)

    --小伙伴区域
    local function teamerCallBack(eventType,obj,x,y)
       return self:teamerCallBack(eventType,obj,x,y)
    end   
    self.teamerlayout = CHorizontalLayout : create()
    self.teamerlayout : setLineNodeSum(4)
    --self.teamerlayout : setCellSize(CCSizeMake(winSize.width/2*0.729,winSize.height/2*0.4375))
    self.teamerlayout : setCellSize(CCSizeMake(100,100))
    self.teamerlayout : setVerticalDirection(false)
    local m_leftdownBackGroundSize = self.m_leftdownBackGround : getPreferredSize()
    self.teamerlayout : setPosition((m_leftdownBackGroundSize.width-400)/2,(m_leftdownBackGroundSize.height-100)/2+50)
    self.m_leftdownBackGround : addChild(self.teamerlayout,10)

    self.TeamerBtn      = {} --小伙伴按钮
    self.TeamerBtnImage = {} --小伙伴按钮头像
    for w=1,4 do
        self.TeamerBtn[w] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
        --self.TeamerBtn[w] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
        self.teamerlayout : addChild( self.TeamerBtn[w] )

        local TeamerBtnSprite = CSprite : createWithSpriteFrameName("general_role_head_underframe.png")
        self.TeamerBtn[w]     : addChild(TeamerBtnSprite,-2)
        
        -- self.TeamerBtnImage[w] = CSprite : create("HeadIconResources/role_head_01.jpg")
        -- self.TeamerBtn[w]      : addChild( self.TeamerBtnImage[w],-1 )     
    end
    --------
    self.theEquipmentArea = CContainer : create()
    self.theEquipmentArea : setControlName( "this is CEquipStrengthenLayer self.theEquipmentArea 98" )
    _layer                : addChild(self.theEquipmentArea,2)  
    self.theEquipmentArea : setPosition (630,354)

    self.strengthen_dqzbSprite        = CSprite : createWithSpriteFrameName("equip_strengthen_dqzb.png")
    self.strengthen_underframeSprite1 = CSprite : createWithSpriteFrameName("equip_strengthen_underframe.png")
    self.lineSprite                   = CSprite : createWithSpriteFrameName("general_dividing_line.png")
    self.arrow_downSprite             = CSprite : createWithSpriteFrameName("equip_arrow_down.png")
    self.strengthen_qhhSprite         = CSprite : createWithSpriteFrameName("equip_strengthen_qhh.png")
    self.strengthen_underframeSprite2 = CSprite : createWithSpriteFrameName("equip_strengthen_underframe.png")

    self.unStrengthenEquBtn  = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
    self.unStrengthenEquBtn : setControlName( "this is CEquipStrengthenLayer self.unStrengthenEquBtn 108" )
    self.unStrengthenEquBtn : setTouchesPriority( -100 )
    self.unStrengthNameLabel = CCLabelTTF : create("","Arial",20)
    self.unStrengthLvLabel   = CCLabelTTF : create("","Arial",20)    
    self.unStrengthLabel     = {}
    for i=1,3 do
        self.unStrengthLabel[i] = CCLabelTTF : create("","Arial",20)
        self.unStrengthLabel[i] : setAnchorPoint(ccp(0,0.5)) 
        self.unStrengthLabel[i] : setPosition(100,0-(i-1)*25)
        self.unStrengthenEquBtn : addChild(self.unStrengthLabel[i])
    end
    self.unStrengthNameLabel : setAnchorPoint(ccp(0,0.5)) 
    self.unStrengthLvLabel   : setAnchorPoint(ccp(0,0.5)) 

    self.theEquipmentArea      : addChild (self.strengthen_dqzbSprite)
    self.strengthen_dqzbSprite : addChild(self.strengthen_underframeSprite1,-1)
    self.theEquipmentArea      : addChild (self.unStrengthenEquBtn)

    self.unStrengthenEquBtn : addChild(self.unStrengthNameLabel)
    self.unStrengthenEquBtn : addChild(self.unStrengthLvLabel)
    self.unStrengthenEquBtn : addChild(self.lineSprite)
    self.lineSprite         : addChild(self.arrow_downSprite)

    self.strengthen_dqzbSprite        : setPosition(40,185)
    self.strengthen_underframeSprite1 : setPosition(0,0)

    self.unStrengthenEquBtn  : setPosition(-100,100)
    self.unStrengthNameLabel : setPosition(100,30)
    self.unStrengthLvLabel   : setPosition(200,30)
    self.lineSprite          : setPosition(140,-55)
    self.arrow_downSprite    : setPosition(0,-45)   


    self.StrengthenEquBtn  = CButton : createWithSpriteFrameName("","general_equip_frame.png")
    self.StrengthenEquBtn : setControlName( "this is CEquipStrengthenLayer self.StrengthenEquBtn 108" )
    self.StrengthenEquBtn : setTouchesPriority( -100 )
    self.StrengthNameLabel = CCLabelTTF : create("","Arial",20)
    self.StrengthLvLabel   = CCLabelTTF : create("","Arial",20)  
    self.StrengthLabel     = {}
    for i=1,3 do
        self.StrengthLabel[i] = CCLabelTTF : create("","Arial",20)
        self.StrengthLabel[i] : setAnchorPoint(ccp(0,0.5)) 
        self.StrengthLabel[i] : setPosition(100,0-(i-1)*25)
        self.StrengthenEquBtn : addChild(self.StrengthLabel[i])
    end
    self.StrengthNameLabel : setAnchorPoint(ccp(0,0.5)) 
    self.StrengthLvLabel   : setAnchorPoint(ccp(0,0.5)) 

    self.theEquipmentArea      : addChild (self.strengthen_qhhSprite)
    self.strengthen_qhhSprite  : addChild(self.strengthen_underframeSprite2,-1)
    self.theEquipmentArea      : addChild (self.StrengthenEquBtn)  

    self.StrengthenEquBtn : addChild(self.StrengthNameLabel)  
    self.StrengthenEquBtn : addChild(self.StrengthLvLabel)  

    self.strengthen_qhhSprite         : setPosition(40,-60)
    self.strengthen_underframeSprite2 : setPosition(0,0)

    self.StrengthenEquBtn    : setPosition(-100,-150)
    self.StrengthNameLabel   : setPosition(100,30)
    self.StrengthLvLabel     : setPosition(200,30)

    
    local function StrengthenButtonCallBack(eventType,obj,x,y)
     return   self : StrengthenBtnCallBack(eventType,obj,x,y)
    end
    local function OnekeyStrengthenButtonCallBack(eventType,obj,x,y)
     return   self : OnekeyStrengthenBtnCallBack(eventType,obj,x,y)
    end
    --强化按钮
    self.m_StrengthenBtn      = CButton :createWithSpriteFrameName("强化","general_button_normal.png")
    self.m_StrengthenBtn      : setControlName( "this is CEquipStrengthenLayer self.m_StrengthenBtn 108" )
    self.m_StrengthenBtn      : registerControlScriptHandler(StrengthenButtonCallBack)
    self.m_StrengthenBtn      : setFontSize(20)
    self.m_StrengthenBtn      : setPosition(40-75,-290)
    self.m_StrengthenBtn      : setTouchesPriority( -100 )
    self.theEquipmentArea     : addChild(self.m_StrengthenBtn)

    self.ConsumptionLabel     = CCLabelTTF : create("","Arial",20)
    self.ConsumptionLabel     : setPosition (-50+120,60)
    self.ConsumptionLabel     : setColor(ccc3(255,255,0))
    self.m_StrengthenBtn      : addChild (self.ConsumptionLabel)

    --一键强化按钮
    self.m_OnekeyStrengthenBtn      = CButton :createWithSpriteFrameName("一键强化","general_button_normal.png")
    self.m_OnekeyStrengthenBtn      : setControlName( "this is CEquipStrengthenLayer self.m_OnekeyStrengthenBtn 108" )
    self.m_OnekeyStrengthenBtn      : registerControlScriptHandler(OnekeyStrengthenButtonCallBack)
    self.m_OnekeyStrengthenBtn      : setFontSize(20)
    self.m_OnekeyStrengthenBtn      : setPosition(40+70,-290)
    self.m_OnekeyStrengthenBtn      : setTouchesPriority( -100 )
    self.theEquipmentArea           : addChild(self.m_OnekeyStrengthenBtn)
end

function CEquipStrengthenLayer.initParameter(self)
    self.HeadIconUrlList     = {} --头像路径存储
    self.m_iconNameLabel     = {}  --装备名字
    self.m_iconLvLabel       = {}  --装备lv
    self : EquipmentListAnalyzed() --装备表解析
end
function CEquipStrengthenLayer.EquipmentListAnalyzed(self,_EquipmentList)  --装备表解析
    require "view/EquipInfoView/EquipXmlAnalyzed"
    require "proxy/GoodsProperty"

    if _EquipmentList == nil then
        self.EquipmentList   = self : getPartnerParams(0)
    else
        self.EquipmentList = _EquipmentList
    end

    self.EquipListData       = {}  --装备数据表
    self.theTransId          = {}
    self.EquipCount          = nil

    --先清除一些东西
    for i=1,6 do
        if  self.m_BagEquipBtnSprite[i] ~= nil then
            self.m_BagEquipBtnSprite[i] : removeFromParentAndCleanup(true)
            self.m_BagEquipBtnSprite[i] = nil
        end

        if self.effectsCCBI[i] ~= nil then
            if self.effectsCCBI[i]    : retainCount() >= 1 then
                self.m_BagEquipBtn[i] : removeChild(self.effectsCCBI[i],false)
                self.effectsCCBI[i]   = nil 
            end
        end
        self.m_BagEquipBtn[i] : setTag(-1)                         --传递背包装备的ID
        self.theTransId[i]    = nil
    end
    --装备
    if self.EquipmentList ~= nil then
        for i,Equip in ipairs(self.EquipmentList) do
            self.EquipCount = i
            self.EquipListData[Equip.goods_id] = {}
            self.EquipListData[Equip.goods_id]["goods_id"  ] = Equip.goods_id        --装备id
            self.EquipListData[Equip.goods_id]["index"     ] = Equip.index           --装备索引位置idx
            self.EquipListData[Equip.goods_id]["goods_num" ] = Equip.goods_num       --装备叠加数量
            self.EquipListData[Equip.goods_id]["goods_type"] = Equip.goods_type      --装备大类
            self.EquipListData[Equip.goods_id]["price"     ] = Equip.price           --装备价格
            self.EquipListData[Equip.goods_id]["strengthen"] = Equip.strengthen      --装备强化等级  
            self.EquipListData[Equip.goods_id]["attr_count"] = Equip.attr_count      --附加属性数量 
            self.EquipListData[Equip.goods_id]["attr_data"]  =  self : exchangeDataTable(Equip.attr_data,tonumber(Equip.attr_count))   --Equip.attr_data      --附加属性信息块 (组:装备-打造-附加) 

            for i,base_type in pairs(Equip.attr_data ) do           --装备的基础属性
                self.EquipListData[Equip.goods_id]["base_type_count"]      = i
                self.EquipListData[Equip.goods_id]["base_type"..i]         = {}
                self.EquipListData[Equip.goods_id]["base_type"..i]["type"] = base_type.attr_base_type
                self.EquipListData[Equip.goods_id]["base_type"..i]["v"]    = base_type.attr_base_value    
            end            

            print("装备==",Equip,Equip.goods_id,Equip.goods_num,self.EquipListData[Equip.goods_id])

            --equipNode = _G.Config.goodss :selectNode("goods","id",tostring(Equip.goods_id)) --装备xml信息
            equipNode                 = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(Equip.goods_id).."]")
            local equipNode_child     = equipNode : children()
            local equipNode_nextchild = equipNode_child : get(0,"attr")
            -- for i,base_type in pairs(equipNode.base_types[1].base_type) do           --装备的基础属性
            --     self.EquipListData[Equip.goods_id]["base_type_count"]      = i
            --     self.EquipListData[Equip.goods_id]["base_type"..i]         = {}
            --     self.EquipListData[Equip.goods_id]["base_type"..i]["type"] = base_type.type
            --     self.EquipListData[Equip.goods_id]["base_type"..i]["v"]    = base_type.v    
            -- end

            self.EquipListData[Equip.goods_id]["name"]          = equipNode : getAttribute("name")       --装备名字(xml)
            self.EquipListData[Equip.goods_id]["name_color"]    = equipNode : getAttribute("name_color") --装备名字颜色(xml)
            self.EquipListData[Equip.goods_id]["class"]         = equipNode : getAttribute("class")      --装备阶级class(xml)
            self.EquipListData[Equip.goods_id]["type_sub"]      = equipNode : getAttribute("type_sub")   --装备类型(xml)

            self.EquipListData[Equip.goods_id]["strong_att"]    = equipNode_nextchild : getAttribute("strong_att") --装备物理攻击(xml)
            self.EquipListData[Equip.goods_id]["skill_att"]     = equipNode_nextchild : getAttribute("skill_att")  --装备技能攻击(xml)

            -- self.EquipListData[Equip.goods_id]["strong_att"]    = equipNode.attr[1].strong_att  --装备物理攻击(xml)
            -- self.EquipListData[Equip.goods_id]["skill_att"]     = equipNode.attr[1].skill_att   --装备技能攻击(xml)
            self.EquipListData[Equip.goods_id]["equ_lv"]        = equipNode : getAttribute("lv")                  --装备等级()
            self.EquipListData[Equip.goods_id]["icon"]          = equipNode : getAttribute("icon")                --装备图标()
            self.EquipListData[Equip.goods_id]["type_sub_name"] = equipNode : getAttribute("type_sub_name")       --类型名字()   
             
            local type_sub = tonumber(equipNode : getAttribute("type_sub"))
            if    type_sub  == 11 then
                    i = 2
            elseif type_sub == 12 then
                    i = 3
            elseif type_sub == 13 then
                    i = 6
            elseif type_sub == 14 then
                    i = 4
            elseif type_sub == 15 then
                    i = 5
            else
                    i = 1
            end
            self.m_BagEquipBtn[i] : setTag(tonumber(i))                         --传递背包装备的ID
            self.theTransId[i]    = Equip.goods_id
            --------------------------------------------------------------------------------------------------------
            local icon                 = equipNode : getAttribute("icon") 
            local name_color           = equipNode : getAttribute("name_color") 
            local ion_url              = "Icon/i"..icon..".jpg"
            _G.g_unLoadIconSources : addIconData( icon )
            self.m_BagEquipBtnSprite[i] = CCSprite :create(ion_url)
            self.m_BagEquipBtn[i]      : addChild(self.m_BagEquipBtnSprite[i],-1)

            self : Create_effects_equip(i,self.m_BagEquipBtn[i],name_color,1) --加特效

        end
    end
end

function CEquipStrengthenLayer.Create_effects_equip ( self,no,obj,name_color,types) --type=1是左边装备栏 2是未强化 3是强化后的
    name_color = tonumber(name_color)
    if name_color ~= nil and name_color > 0 and name_color < 8 then 
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunction( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "11Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end

        if obj ~= nil then
            if types == 1 then
                if  self.effectsCCBI[no] ~= nil then
                    self.effectsCCBI[no] : removeFromParentAndCleanup(true)
                    self.effectsCCBI[no] = nil
                end

                if no ~= nil then
                    self.effectsCCBI[no] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                    self.effectsCCBI[no] : setControlName( "this CCBI Create_effects_activity CCBI")
                    self.effectsCCBI[no] : registerControlScriptHandler( animationCallFunction)
                    obj                  : addChild(self.effectsCCBI[no],1000)
                end
            end 

            if types == 2 then
                if self.unStreng_effectsCCBI ~= nil then
                    self.unStreng_effectsCCBI : removeFromParentAndCleanup(true)
                    self.unStreng_effectsCCBI = nil 
                end

                self.unStreng_effectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self.unStreng_effectsCCBI : setControlName( "this CCBI Create_effects_activity CCBI")
                self.unStreng_effectsCCBI : registerControlScriptHandler( animationCallFunction)
                obj                       : addChild(self.unStreng_effectsCCBI,1000)
            end

            if types == 3 then
                if self.Streng_effectsCCBI ~= nil then
                    self.Streng_effectsCCBI : removeFromParentAndCleanup(true)
                    self.Streng_effectsCCBI = nil 
                end

                self.Streng_effectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self.Streng_effectsCCBI : setControlName( "this CCBI Create_effects_activity CCBI")
                self.Streng_effectsCCBI : registerControlScriptHandler( animationCallFunction)
                obj                     : addChild(self.Streng_effectsCCBI,1000)
            end
        end
    end
end

function CEquipStrengthenLayer.removeeffectsCCBI(self)
    for i=1,6 do
        if self.effectsCCBI[i] ~= nil then
            if self.effectsCCBI[i]  : retainCount() >= 1 then
                print("强化界面关闭的时候删除 effectsCCBI",i)
                self.effectsCCBI[i] : removeChild(self.effectsCCBI[i],false)
                self.effectsCCBI[i] = nil 
            end
        end
    end

    if self.Streng_effectsCCBI ~= nil then
        if self.Streng_effectsCCBI  : retainCount() >= 1 then
            print("强化界面关闭的时候删除 Streng_effectsCCBI")
            self.Streng_effectsCCBI : removeFromParentAndCleanup(true)
            self.Streng_effectsCCBI = nil
        end
    end

    if self.unStreng_effectsCCBI ~= nil then
        if self.unStreng_effectsCCBI  : retainCount() >= 1 then
            print("强化界面关闭的时候删除 unStreng_effectsCCBI")
            self.unStreng_effectsCCBI : removeFromParentAndCleanup(true)
            self.unStreng_effectsCCBI = nil
        end
    end

    print("累干不爱")
    if self.m_scenelayer ~= nil then
        self.m_scenelayer : removeFromParentAndCleanup(true)
        self.m_scenelayer = nil 
    end
end

--方法回调-----

function CEquipStrengthenLayer.BagEquipBtnCallBack(self,eventType, obj,x, y)
  if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    self : CleanEquipXmlData() --数据清空
    print("装备回调",obj : getTag())
    local  i      = obj : getTag()      --传递过来的ID
    local equ_id  = tonumber(self.theTransId[i])  

    self : chagneBagEquipBtnSprites(i)

    if equ_id ~= nil and equ_id > 0 then
        self.transferId = equ_id        --将ID传递到更新函数
        -- local equipNode = _G.Config.goodss :selectNode("goods","id",tostring(equ_id)) --装备xml信息
        -- local ion_url            = "Icon/i"..equipNode.icon..".jpg"
        -- self.EquipInfoBtnSprites = CCSprite :create(ion_url)
        -- self.m_EquipInfoBtn      : addChild(self.EquipInfoBtnSprites,1) --装备信息栏装备图标

        self : GetEquipXmlData(equ_id)  --装备XML表解析
        self : createIconSprite(equ_id)
       
        local index           =  self.EquipListData[equ_id]["index"] 
        print("-----------)))))))))))_________",index)
        self.m_StrengthenBtn        : setTag(tonumber(index))
        self.m_OnekeyStrengthenBtn  : setTag(tonumber(index))
       -- index = nil 
    end

    _G.pCGuideManager:sendStepFinish()
  end
end

function CEquipStrengthenLayer.chagneBagEquipBtnSprites(self, _i)
    local i = tonumber (_i) 
    if self.oldno ~= nil and self.oldno > 0 then
        self.BagEquipBtnSprites[self.oldno] :  setImageWithSpriteFrameName( "general_props_frame_normal.png" )
    end
    if i ~= nil and i > 0 then
        self.BagEquipBtnSprites[i] : setImageWithSpriteFrameName("general_props_frame_click.png")  
        self.oldno = i   
    end 
end

function CEquipStrengthenLayer.CleanEquipXmlData(self)
    -- for i=1,8 do
    --     self.iconInfoLabel[i] : setString("")
    -- end
    for i=1,3 do
        if  self.unStrengthLabel[i] ~= nil then
            self.unStrengthLabel[i] : setString("")
        end
        if  self.StrengthLabel[i] ~= nil then
            self.StrengthLabel[i] : setString("")
        end
    end
    if  self.unStrengthNameLabel ~= nil then
        self.unStrengthNameLabel : setString("")
    end
    if  self.unStrengthLvLabel ~= nil then
        self.unStrengthLvLabel : setString("")
    end
    if  self.StrengthNameLabel ~= nil then
        self.StrengthNameLabel : setString("")
    end
    if  self.StrengthLvLabel ~= nil then
        self.StrengthLvLabel : setString("")
    end
    if  self.ConsumptionLabel ~= nil then
        self.ConsumptionLabel : setString("")
    end
    -- self.unStrengthNameLabel    : setString("")
    -- self.unStrengthLvLabel      : setString("")
    -- self.StrengthNameLabel      : setString("")  
    -- self.StrengthLvLabel        : setString("") 
    -- self.ConsumptionLabel       : setString("") 

    -- if  self.EquipInfoBtnSprites ~= nil then
    --     self.EquipInfoBtnSprites : removeFromParentAndCleanup(true)
    --     self.EquipInfoBtnSprites = nil
    --     print("EquipInfoBtnSpritesEquipInfoBtnSprites")
    -- end

    if  self.unStrengthenEquBtnSpr ~= nil then
        self.unStrengthenEquBtnSpr : removeFromParentAndCleanup(true)
        self.unStrengthenEquBtnSpr = nil
    end

    if  self.StrengthenEquBtnSpr ~= nil then
        self.StrengthenEquBtnSpr : removeFromParentAndCleanup(true)
        self.StrengthenEquBtnSpr = nil
    end

    if self.unStreng_effectsCCBI ~= nil then
        if self.unStreng_effectsCCBI  : retainCount() >= 1 then
            self.unStreng_effectsCCBI : removeFromParentAndCleanup(true)
            self.unStreng_effectsCCBI = nil 
        end
    end
    if self.Streng_effectsCCBI ~= nil then
        if self.Streng_effectsCCBI  : retainCount() >= 1 then
            self.Streng_effectsCCBI : removeFromParentAndCleanup(true)
            self.Streng_effectsCCBI = nil 
        end
    end
end


function CEquipStrengthenLayer.GetEquipXmlData(self,equ_id)

    local equ_lv     = self.EquipListData[equ_id]["equ_lv"]     --装备等级(xml)
    local equ_name   = self.EquipListData[equ_id]["name"]       --装备名字(xml)
    local lv         = self.EquipListData[equ_id]["strengthen"] --装备强化等级(服务器)==lv
    local class      = self.EquipListData[equ_id]["class"]      --装备阶级class(xml)
    local typesub    = self.EquipListData[equ_id]["type_sub"]   --装备类型(xml)
    local strong_att = self.EquipListData[equ_id]["strong_att"] --装备物理攻击(xml)
    local skill_att  = self.EquipListData[equ_id]["skill_att"]  --装备技能攻击(xml)
    local equ_index  = self.EquipListData[equ_id]["index"]      --装备位置(服务器)
    local icon       = self.EquipListData[equ_id]["icon"]       --装备图标() 
    local goods_type = self.EquipListData[equ_id]["goods_type"] 
    local color      = tonumber(self.EquipListData[equ_id]["name_color"] ) --装备名字颜色(xml)==color
    local base_type_count          = tonumber(self.EquipListData[equ_id]["base_type_count"]) --装备基础属性数量

    local base_type                = {} --属性表（属性类型[数字]，属性值）
    local base_type_name           = {} --属性名称名字表
    local base_type_add            = {} --属性强化后数值
    local next_base_type_add       = {} --下一等级属性强化后数值
    local base_type_statement      = {}
    local next_base_type_statement = {}
    local k    = 1 
    self.money = 0
    self.change_equ_index = equ_index

    print("尝试发发给你",equ_name,equ_id)
    self : NetWorkSend_MAKE_STREN_DATA_ASK( 123,equ_id,lv,color,goods_type,typesub,class)
    print("发送完了")

    --lv需要判断是否为O
    --if(lv ~= 0)then
         --EquipStrID        = lv.."_"..color.."_"..typesub.."_"..class                                    --装备强化id拼接
         --local  equStrNode = _G.Config.equip_strens :selectNode("equip_stren","id",tostring(EquipStrID)) --装备强化信息
         self.streng_lv        = lv    --equStrNode.lv                 --强化等级
         self.streng_color     = color --tonumber(equStrNode.color )   --强化颜色
         --equ_nextlv            = equ_lv + 1 
         --local nextlv          = lv + 1
         --EquipNextStrID        = nextlv.."_"..color.."_"..typesub.."_"..class                                    --下一等级强化id拼接
         --local equNextStrNode  = _G.Config.equip_strens :selectNode("equip_stren","id",tostring(EquipNextStrID)) --下一等级装备强化信息
         -- self.streng_nextlv    = tonumber(equNextStrNode.lv)        --下一强化等级  
         -- self.streng_nextcolor = tonumber(equNextStrNode.color )    --强化颜色                          
         -- self.money            = equNextStrNode.g[1].money          --强化费用  

        --print("EquipNextStrID 309",EquipNextStrID)
        --获取装备基础属性
        while k <= base_type_count do
            base_type[k]         = {}
            base_type[k]["type"] =tonumber(self.EquipListData[equ_id]["base_type"..k]["type"])             --属性类型
            base_type[k]["v"]    = self.EquipListData[equ_id]["base_type"..k]["v"]                         --属性值
            print("aaaaa?",base_type[k]["type"])
            base_type_id         = "goodss_goods_base_types_base_type_type"..base_type[k]["type"]          --属性名称ID

            base_type_name[k] = CLanguageManager:sharedLanguageManager():getString(tostring(base_type_id)) --属性名称名字
            print("**********************************45>>",k,base_type[k]["type"],base_type_name[k],base_type[k]["v"],self.EquipListData[equ_id]["base_type"..k]["v"] )

            --获取属性附加值
            --local addvalue     = self:getAttrValue(EquipStrID    ,base_type[k]["type"])     --通过判断属性方法获取属性值（物品id，属性类型）
            --local nextaddvalue = self:getAttrValue(EquipNextStrID,base_type[k]["type"])     --通过判断属性方法获取属性值（物品id，属性类型）

            base_type_add["no"..k]            = base_type[k]["v"] --+ addvalue                         --增加后的数值
            next_base_type_add["no"..k]       = base_type[k]["v"] --+ nextaddvalue                     --下一等级增加后的数值
            base_type_statement["no"..k]      = base_type_name[k].."+"..base_type_add["no"..k]       --例如：技能攻击+100
            next_base_type_statement["no"..k] = base_type_name[k].."+"..next_base_type_add["no"..k]  --例如：技能攻击+100

            k = k + 1 
        end

    if(self.streng_color == 1)then
        style_color ="白"
        self.unStrengthLvLabel : setColor(ccc3(255,255,255))
        self.unStrengthNameLabel : setColor(ccc3(255,255,255))
    elseif(self.streng_color == 2)then
        style_color ="绿"
        self.unStrengthLvLabel : setColor(ccc3(91,200,19))
        self.unStrengthNameLabel : setColor(ccc3(91,200,19))
    elseif(self.streng_color == 3)then
        style_color ="蓝"
        self.unStrengthLvLabel : setColor(ccc3(0,155,255))
        self.unStrengthNameLabel : setColor(ccc3(0,155,255))
    elseif(self.streng_color == 4)then
        style_color ="紫"
        self.unStrengthLvLabel : setColor(ccc3(155,0,188))
        self.unStrengthNameLabel : setColor(ccc3(155,0,188))
    elseif(self.streng_color == 5)then
        style_color ="金"
        self.unStrengthLvLabel : setColor(ccc3(255,255,0))
        self.unStrengthNameLabel : setColor(ccc3(255,255,0))
    elseif(self.streng_color == 6)then
        style_color ="橙"
        self.unStrengthLvLabel : setColor(ccc3(255,155,0))
        self.unStrengthNameLabel : setColor(ccc3(255,155,0))
    elseif(self.streng_color == 7)then
        style_color ="红"
        self.unStrengthLvLabel : setColor(ccc3(255,0,0))
        self.unStrengthNameLabel : setColor(ccc3(255,0,0))
    else
        style_color ="无"
    end

    local theloops = 0 
    theloops = tonumber(base_type_count)
    if theloops > 0 then
        for i=1,theloops do
            self.unStrengthLabel[i] : setString(base_type_statement["no"..i])
            --self.StrengthLabel[i]   : setString(next_base_type_statement["no"..i])
        end
    end

    self.unStrengthNameLabel : setString(equ_name)
    self.unStrengthLvLabel   : setString(style_color.."色"..self.streng_lv.."级")
    print("成功改变装备框信息")
end

function CEquipStrengthenLayer.getAttrValue(self,Node,_base_type)
    local value = 0
    if Node : isEmpty() == false then
      local child = Node : children() : get(0,"base_types")
      local count = tonumber(child : children() : getCount("base_type"))
      print("ooxx=====",count) 
      for i=0,count-1 do
        local base_Node = child : children() : get(i,"base_type")
        if tonumber(base_Node : getAttribute("type")) == _base_type then
            value = tonumber(base_Node : getAttribute("v"))
            break
        end
      end


      -- local equNodeAttr = Node.base_types[1].base_type
      -- for k,base in pairs(equNodeAttr) do
      --   if tonumber(base.type) == _base_type then
      --       value = tonumber(base.v)
      --       break
      --   end
      --   print("---->>>>mm",base,base.v)
      -- end

    end  
    return value 
end


function CEquipStrengthenLayer.StrengthenBtnCallBack(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    local ismoneyOK = self : CompareMoney(self.money)
    print("强化按钮回调",ismoneyOK)

    
    self : setStrengthenBtnNoTouch() --设置强化按钮不给按

    if ismoneyOK == 1 then
        local msg = REQ_MAKE_KEY_STREN()
        local equ_index = obj : getTag()  --传递过来的index
        local theno               = self.TheFirstIndexNo
        self.TheFirstIndex[theno] = tonumber(equ_index)
        print("thenothenothenothenotheno",theno,self.TheFirstIndex[theno])

        print("equ_index =",equ_index,obj)
        if equ_index ~= nil and self.thepartnerId ~= nil  then
            msg :setStrenType(2) -- {1:一键强化,2:普通强化}
            msg :setType(2) --1:背包2:装备栏
            msg :setId(self.thepartnerId)
            msg :setIdx(equ_index)
            msg :setDiscount(false)
            msg :setDou(false)
            msg :setCostType(0)
           CNetwork :send(msg)
        end
    elseif ismoneyOK == 0 then
        local msg = "美刀不足，招财可获得美刀！"
        self : createMessageBox(msg)
    end

    _G.pCGuideManager:sendStepFinish()

    self : setm_StrengthenBtnTrue()

    
    print("强化发送")
  end
end

function CEquipStrengthenLayer.OnekeyStrengthenBtnCallBack(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    local ismoneyOK = self : CompareMoney(self.money)
    print("一键强化按钮回调",ismoneyOK)

    local msgs = "在美刀足够的情况下，可强化至当前最高等级，确定要一键强化？"
    local function fun1()
        self : setStrengthenBtnNoTouch() --设置强化按钮不给按

        if ismoneyOK == 1 then
            local msg = REQ_MAKE_KEY_STREN()
            local equ_index = obj : getTag()  --传递过来的index
            local theno               = self.TheFirstIndexNo
            self.TheFirstIndex[theno] = tonumber(equ_index)
            print("thenothenothenothenotheno",theno,self.TheFirstIndex[theno])

            print("equ_index =",equ_index,obj)
            if equ_index ~= nil and self.thepartnerId ~= nil  then
                msg :setStrenType(1) -- {1:一键强化,2:普通强化}
                msg :setType(2) --1:背包2:装备栏
                msg :setId(self.thepartnerId)
                msg :setIdx(equ_index)
                msg :setDiscount(false)
                msg :setDou(false)
                msg :setCostType(0)
               CNetwork :send(msg)
            end
        elseif ismoneyOK == 0 then
            local msg = "美刀不足，招财可获得美刀！"
            self : createMessageBox(msg)
        end

        _G.pCGuideManager:sendStepFinish()

        self : setm_StrengthenBtnTrue()
    end

    local function fun2()
        print("不要你了")    
    end
    self : createMessageBox(msgs,fun1,fun2)

  end
end

function CEquipStrengthenLayer.setStrengthenBtnNoTouch( self )
    local actarr = CCArray:create()
    local function t_callback1()
        self.m_StrengthenBtn       : setTouchesEnabled(false)
        self.m_OnekeyStrengthenBtn : setTouchesEnabled(false)
        self.m_scenelayer          : setFullScreenTouchEnabled(true)
        self.m_scenelayer          : setTouchesPriority(-100)
        self.m_scenelayer          : setTouchesEnabled(true)
    end
    actarr:addObject( CCCallFunc:create(t_callback1) )
    self.m_scenelayer : runAction( CCSequence:create(actarr) )
end


function CEquipStrengthenLayer.setm_StrengthenBtnTrue( self )
    local actarr = CCArray:create()

    local function t_callback2()
        self.m_StrengthenBtn       : setTouchesEnabled(true)
        self.m_OnekeyStrengthenBtn : setTouchesEnabled(true)
        self.m_scenelayer          : setFullScreenTouchEnabled(false)
    end
    local delayTime = 1
    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(t_callback2) )
    self.m_scenelayer:runAction( CCSequence:create(actarr) )
end

function CEquipStrengthenLayer.NetWorkSend_MAKE_STREN_DATA_ASK( self,_Ref,_GoodsId,_StrenLv,_Color,_Type,_TypeSub,_EquipClass)
    print("我看看我发了什么给你==",_Ref,_GoodsId,_StrenLv,_Color,_Type,_TypeSub,_EquipClass)
    local msg = REQ_MAKE_STREN_DATA_ASK()
    msg :setRef(_Ref)               -- {标识}
    msg :setGoodsId(_GoodsId)       -- {物品id}
    msg :setStrenLv(_StrenLv)       -- {强化等级}
    msg :setColor(_Color)           -- {颜色}
    msg :setType(_Type)             -- {物品大类}
    msg :setTypeSub(_TypeSub)       -- {物品子类}
    msg :setEquipClass(_EquipClass) -- {等阶}
    CNetwork :send(msg)
end

function CEquipStrengthenLayer.NetWorkReturn_MAKE_STREN_DATA_BACK( self,Ref,GoodsId,Lv,Color,CostCoin,Count,Msg) 
    print("拿到下一级的强化数据哇咔咔====",Ref,GoodsId,Lv,Color,CostCoin,Count,Msg)
    for k,v in pairs(Msg) do
        print(k,v.type,v.type_value)
    end

    --local Node = _G.Config.goodss :selectNode("goods","id",tostring(GoodsId))
    local Node = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(GoodsId).."]")
    if Node : isEmpty() == false then
       self.StrengthNameLabel   : setString(Node : getAttribute("name")) 
    end

    Count = tonumber(Count)
    if Count > 0 then
        for i=1,Count do
            local types           = tonumber(Msg[i].type)
            local base_type_id    = "goodss_goods_base_types_base_type_type"..types                            --属性名称ID
            local base_type_name  = CLanguageManager:sharedLanguageManager():getString(tostring(base_type_id)) --属性名称名字
            local base_type_value = 0
            base_type_value = self : getAttrValue(Node,types) --拿基础属性值


            base_type_value = base_type_value + tonumber(Msg[i].type_value)
            self.StrengthLabel[i]   : setString(base_type_name.."+"..base_type_value)
        end
    end   


    if(Color == 1)then
        style_color ="白"
        self.StrengthLvLabel : setColor(ccc3(255,255,255))
        self.StrengthNameLabel   : setColor(ccc3(255,255,255))
    elseif(Color == 2)then
        style_color ="绿"
        self.StrengthLvLabel : setColor(ccc3(91,200,19))
        self.StrengthNameLabel   : setColor(ccc3(91,200,19))
    elseif(Color == 3)then
        style_color ="蓝"
        self.StrengthLvLabel : setColor(ccc3(0,155,255))
        self.StrengthNameLabel   : setColor(ccc3(0,155,255))
    elseif(Color == 4)then
        style_color ="紫"
        self.StrengthLvLabel : setColor(ccc3(155,0,188))
        self.StrengthNameLabel   : setColor(ccc3(155,0,188))
    elseif(Color == 5)then
        style_color ="金"
        self.StrengthLvLabel : setColor(ccc3(255,255,0))
        self.StrengthNameLabel   : setColor(ccc3(255,255,0))
    elseif(Color == 6)then
        style_color ="橙"
        self.StrengthLvLabel : setColor(ccc3(255,155,0))
        self.StrengthNameLabel   : setColor(ccc3(255,155,0))
    elseif(Color == 7)then
        style_color ="红"
        self.StrengthLvLabel : setColor(ccc3(255,0,0))
        self.StrengthNameLabel   : setColor(ccc3(255,0,0))
    else
        style_color ="无"
    end
    self.StrengthLvLabel     : setString(style_color.."色"..Lv.."级") 

    self.ConsumptionLabel : setString("强化费用      "..CostCoin)

    local Node_icon          = Node : getAttribute("icon")
    local icon_url           = "Icon/i"..Node_icon..".jpg"
    _G.g_unLoadIconSources : addIconData( Node_icon )
    self.StrengthenEquBtnSpr = CSprite :create(icon_url)
    self.StrengthenEquBtn    : addChild(self.StrengthenEquBtnSpr,-1) --装备信息栏装备图标
    self : Create_effects_equip(nil,self.StrengthenEquBtn,Node: getAttribute("name_color"),3) --装备特效
end


function CEquipStrengthenLayer.CompareMoney(self,_price)
    local mainProperty = _G.g_characterProperty : getMainPlay()

    --获取美刀
    self.m_GoldNum     = tonumber(mainProperty :getGold()) 
    if self.m_GoldNum  == nil then
        self.m_GoldNum = 0
    end
    --获取钻石
    self.m_RmbNum     = tonumber(mainProperty :getBindRmb()) 
    if self.m_RmbNum  == nil then
        self.m_RmbNum = 0
    end
    print("ddddddd-->",self.m_GoldNum,self.m_RmbNum)
    if _price ~= nil then
        if self.m_GoldNum >= tonumber(_price)  then
            return 1
        else
            return 0
        end
    else
        return nil 
    end
end
--更新数据表
function CEquipStrengthenLayer.setReNewData_EqiupList(self,m_ReNewData_MaterialList)
        self.m_ReNewData_EquipmentList =  m_ReNewData_MaterialList
end
function CEquipStrengthenLayer.getReNewData_EqiupList(self)
       return self.m_ReNewData_EquipmentList
end

--更新函数
function CEquipStrengthenLayer.update(self,_EquipmentList)
    self : CleanEquipXmlData()      --清理面板
    print("CEquipComposeLayer.update",self.transferId,"-----",self.change_equ_index)
    self : EquipmentListAnalyzed(_EquipmentList)  --装备表解析
    local equ_id = nil

    for k,v in pairs(_EquipmentList) do
        print("the update index",v.index)
        if tonumber(v.index)  == tonumber(self.change_equ_index)  then
            equ_id = v.goods_id
        end
    end

    if equ_id ~= nil and equ_id > 0 then
        -- local equipNode = _G.Config.goodss :selectNode("goods","id",tostring(equ_id)) --装备xml信息
        -- local ion_url            = "Icon/i"..equipNode.icon..".jpg"
        -- self.EquipInfoBtnSprites = CCSprite :create(ion_url)
        -- self.m_EquipInfoBtn      : addChild(self.EquipInfoBtnSprites,1) --装备信息栏装备图标
        self : createIconSprite(equ_id)
        self:GetEquipXmlData(equ_id)  --装备XML表解析
       
        local index           =  self.EquipListData[equ_id]["index"] 
        self.m_StrengthenBtn        : setTag(tonumber(index))
        self.m_OnekeyStrengthenBtn  : setTag(tonumber(index))
        index = nil 
    end
end

--默认第一个物品
function CEquipStrengthenLayer.DefaultFirstEquip(self,_EquipmentList,_no)

    local no = nil
    local EquipmentList = {}
    if _EquipmentList == nil then
        EquipmentList = self : getPartnerParams(0)--人物身上的装备 0为主将
    else
        self : CleanEquipXmlData ()  --清理面板
        EquipmentList = _EquipmentList
    end
    if _no == nil then
        no = 1
    else
        no = tonumber(_no)
    end

    if EquipmentList ~= nil  then
        for k,v in pairs(EquipmentList) do
            if self.TheFirstIndex[no] ==tonumber(v.index)  then
                self.theFirstId = v.goods_id  --获取第一个装备id
                print("DefaultFirstEquip7788=",v.goods_id,v.index)
                --local equipNode = _G.Config.goodss :selectNode("goods","id",tostring(v.goods_id)) --装备xml信息
                local equipNode   = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(v.goods_id).."]")
                local no = nil 
                local type_sub = tonumber(equipNode : getAttribute("type_sub"))
                if    type_sub  == 11 then
                        no = 2
                elseif type_sub == 12 then
                        no = 3
                elseif type_sub == 13 then
                        no = 6
                elseif type_sub == 14 then
                        no = 4
                elseif type_sub == 15 then
                        no = 5
                else
                        no = 1
                end
                if no ~= nil then
                    self : chagneBagEquipBtnSprites(no)
                end
            end
        end
    end

    print("默认第一个装备 510",self.theFirstId)   
    if self.theFirstId ~= nil and tonumber(self.theFirstId)  > 0 then 
        self.transferId = self.theFirstId        --将ID传递到更新函数
        local equ_id    = self.theFirstId

        self : GetEquipXmlData(equ_id)  --装备XML表解析
        self : createIconSprite(equ_id)

        local index           =  self.EquipListData[equ_id]["index"] 
        self.m_StrengthenBtn        : setTag(tonumber(index))
        self.m_OnekeyStrengthenBtn  : setTag(tonumber(index))
        index = nil 
    else
        self.m_StrengthenBtn        : setTag("")
        self.m_OnekeyStrengthenBtn  : setTag("")
    end
    self.theFirstId = nil
end

--mediator注册
function CEquipStrengthenLayer.mediatorRegister(self)
    _G.g_CEquipStrengthenMediator = CEquipStrengthenMediator(self)
    controller :registerMediator(  _G.g_CEquipStrengthenMediator )
end

function CEquipStrengthenLayer.createIconSprite(self,_id)
    local id = _id
    local unNode      = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(id).."]") --装备xml信息
    local unNode_icon = unNode : getAttribute("icon")
    local name_color  = unNode : getAttribute("name_color") 

    local unicon_url           = "Icon/i"..unNode_icon..".jpg"   
    _G.g_unLoadIconSources     : addIconData( unNode_icon )
    self.unStrengthenEquBtnSpr = CSprite :create(unicon_url)
    self.unStrengthenEquBtn    : addChild(self.unStrengthenEquBtnSpr,-1) --装备信息栏装备图标

    self : Create_effects_equip(nil,self.unStrengthenEquBtn,name_color,2) --装备特效


    -- if  self.isstr_need ~= nil and  self.isstr_need == 1 then
    --     print("------------------------------------is need = 1  ",self.isstr_need)
    --     local equip_makeNode = _G.Config.equip_makes :selectNode("equip_make","id",tostring(id)) --装备xml信息
    --     local makeid = equip_makeNode.make1[1].goods
    --     local Node   = _G.Config.goodss :selectNode("goods","id",tostring(makeid)) --装备xml信息
    --     local icon_url           = "Icon/i"..Node.icon..".jpg"
    --     _G.g_unLoadIconSources : addIconData( Node.icon )
    --     self.StrengthenEquBtnSpr = CSprite :create(icon_url)
    --     self.StrengthenEquBtn    : addChild(self.StrengthenEquBtnSpr,-1) --装备信息栏装备图标
    --     self : Create_effects_equip(nil,self.StrengthenEquBtn,Node.name_color,3) --装备特效
    --     self.isstr_need = nil
    -- else
    --     print("------------------------------------is need = 0  ",self.isstr_need)
    --     local icon_url           = "Icon/i"..unNode.icon..".jpg"
    --     _G.g_unLoadIconSources : addIconData( unNode.icon )
    --     self.StrengthenEquBtnSpr = CSprite :create(icon_url)
    --     self.StrengthenEquBtn    : addChild(self.StrengthenEquBtnSpr,-1) --装备信息栏装备图标
    --     self : Create_effects_equip(nil,self.StrengthenEquBtn,unNode.name_color,3) --装备特效
    --     self.isstr_need = nil
    -- end
end

----[[
function CEquipStrengthenLayer.getTeamersData(self)
    local roleProperty   = _G.g_characterProperty : getMainPlay() --猪脚
    self.m_partnerconut  = roleProperty :getCount()               --猪脚的伙伴数量
    self.m_partneridlist = roleProperty :getPartner()             --伙伴ID列表
    self.m_uid           = _G.g_LoginInfoProxy:getUid()           --uid

    self.m_equiplist     = {}
    self.m_partneridList = {}
    self.m_partnerProNo  = {}
    for i=1,4 do
        self.m_partnerProNo[i] = {}
        local _partnerid = nil 
        if i == 1 then
            _partnerid = 0
        else
            _partnerid = tonumber(self.m_partneridlist[i-1]) 
            print("------_partnerid",_partnerid,i,"self.m_partnerconut=",self.m_partnerconut)
        end 
        self.m_partneridList[i] = _partnerid
        if _partnerid == 0 then
            local data            = self : getPartnerParams(0)
            self.m_equiplist[i] = data

            local m_mainProperty             = _G.g_characterProperty :getMainPlay()
            self.m_partnerProNo[i].pro       = m_mainProperty : getPro()   --猪脚职业属性
            self.m_partnerProNo[i].partnerid = _partnerid
        else
            local index = tostring( self.m_uid..tostring( _partnerid))                                     --伙伴id
            local m_roleProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
            if m_roleProperty == nil then
                self.m_equiplist[i]  = {}
                print( "第"..i.."个位置没有对应伙伴")
                return
            else
                self.m_equiplist[i]  = {}
                self.m_equiplist[i]  = m_roleProperty : getEquipList()
                print("XXXXXXXXX@@@:",i,self.m_equiplist[i],#self.m_equiplist[i] )
                for k,v in pairs(self.m_equiplist[i]) do
                    print("$$$$$$$---->",k,v)
                end
                self.m_partnerProNo[i].pro       = m_roleProperty : getPro()   --职业属性
                self.m_partnerProNo[i].partnerid = _partnerid
            end
        end
        self : addRoleIcon(i,self.m_equiplist[i],_partnerid)
        if i == 1 then     --默认第一个头像
            self.TeamerBtn[i] : setImageWithSpriteFrameName( "general_role_head_frame_click.png" )
            self.theOldSpriteBtnId = i
            self : createCCBI(i,_partnerid)
        end
    end
end

function CEquipStrengthenLayer.createCCBI( self, _value,_partnerid)
    print("createCCBI _value = ",_value)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end

    if  self.roleCCBIContainer  ~= nil then
        self.roleCCBIContainer : removeFromParentAndCleanup(true)
        self.roleCCBIContainer = nil 
    end

    if self.m_partnerProNo[_value] ~= nil then
        self.roleCCBIContainer = CContainer : create()
        self.roleCCBIContainer : setPosition(200+5,120-10+1)
        self.m_leftBackGround  : addChild(self.roleCCBIContainer)

        local pro = nil 
        if _partnerid ~= nil and  tonumber(_partnerid) == 0 then 
            pro = "1000"..self.m_partnerProNo[_value].pro 
        else
            local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
            local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]")
            if  node : isEmpty() == false then
                pro = node : getAttribute("skin")
            else
                pro = 10404                
            end
        end



        print("createCCBI pro = ",pro)
        --self.roleCCBI        = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
        self.roleCCBI        = CMovieClip:create( "CharacterMovieClip/"..pro.."_normal.ccbi" )
        self.roleCCBI         : setControlName( "this CSelectRoleScene roleCCBI 84")
        self.roleCCBI         : registerControlScriptHandler( animationCallFunc)
        self.roleCCBIContainer: addChild(self.roleCCBI)
    end
end


--创建人物头像列表
function CEquipStrengthenLayer.addRoleIcon( self,_no,_EquipList,_partnerid)
    print("CGemInlayView.addRoleIcon",_no)  
    local list = _EquipList
    local no   = _no
    -- local function CallBack( eventType, obj, x, y)
    --     return self :clickRoleCallBack( eventType, obj, x, y)
    -- end  
    --角色头像部分
    local function teamerCallBack(eventType,obj,x,y)
       return self:teamerCallBack(eventType,obj,x,y)
    end  
    if  _partnerid == 0 then
        local IconNo = self : getMainPlayerIconNo(0)
        print("职业序号",IconNo)
        local icon_url = "HeadIconResources/role_head_0"..IconNo..".jpg"
        table.insert(  self.HeadIconUrlList, icon_url )
        self.TeamerBtnImage[_no] = CButton : create("",icon_url)
        self.TeamerBtnImage[_no] : setControlName( "this is CEquipStrengthenLayer self.TeamerBtnImage[_no] 1104" )
        self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
        self.TeamerBtnImage[_no] : setTag(_no)
        self.TeamerBtnImage[_no] : setTouchesPriority( -100 )
        self.TeamerBtn[_no]      : addChild( self.TeamerBtnImage[_no],-1 ) 
    else
        print("self.m_partnerProNo[_no].partnerid",_partnerid) 
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]")
        local icon_url = nil 
        if node : isEmpty() ==false then  
            local node_head = node : getAttribute("head")
            if tonumber( node_head ) == 10001 then
                icon_url = "HeadIconResources/role_head_10402.jpg"
                table.insert(  self.HeadIconUrlList, icon_url )
            else
                icon_url = "HeadIconResources/role_head_"..node_head..".jpg"
                table.insert(  self.HeadIconUrlList, icon_url )
            end
        else
            icon_url = "HeadIconResources/role_head_10411.jpg"
            table.insert(  self.HeadIconUrlList, icon_url )
        end
        --local icon_url = "HeadIconResources/role_head_0"..no..".jpg"
        self.TeamerBtnImage[_no] = CButton : create("",icon_url)
        self.TeamerBtnImage[_no] : setControlName( "this is CEquipStrengthenLayer self.TeamerBtnImage[_no] 1124" )
        self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
        self.TeamerBtnImage[_no] : setTag(_no)
        self.TeamerBtnImage[_no] : setTouchesPriority( -100 )
        self.TeamerBtn[_no]      : addChild( self.TeamerBtnImage[_no],-1 ) 
    end

    local minIndex = nil
    if list ~= nil and #list > 0 then
        for k,v in pairs(list) do
            if k == 1 then
                minIndex = tonumber(v.index) 
            end
            if tonumber(v.index) < minIndex then
                minIndex = tonumber(v.index)
            end
        end
        self.TheFirstIndex[no] = tonumber(minIndex) 
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TheFirstIndex",no,self.TheFirstIndex[no])
    end
end

function CEquipStrengthenLayer.getMainPlayerIconNo(self,index)
    local mainplay = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    local m_pro    = mainplay :getPro()       --玩家职业
    return m_pro
end

function CEquipStrengthenLayer.teamerCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local valueTag = obj:getTag()
        print("小伙伴回调   "..valueTag)

        if self.theOldSpriteBtnId ~= nil and self.theOldSpriteBtnId > 0  then
            local oldid  = self.theOldSpriteBtnId
            self.TeamerBtn[oldid] : setImageWithSpriteFrameName( "general_role_head_frame_normal.png" )
            self.theOldSpriteBtnId = nil
        end

        if valueTag ~= nil then
            print("要换图片")
            self.TeamerBtn[valueTag] : setImageWithSpriteFrameName( "general_role_head_frame_click.png" )

            -- if self.PeopleSprite ~= nil then
            --     self.PeopleSprite : removeFromParentAndCleanup(true)
            --     self.PeopleSprite = nil
            -- end
            -- local icon_url    = "HeadIconResources/role_body_0"..valueTag..".png"
            -- self.PeopleSprite = CSprite :create(icon_url) --人物全身图
            -- self.PeopleSprite : setScale(0.6)
            -- self.PeopleSprite : setPosition(220,200)
            -- self.m_leftBackGround : addChild(self.PeopleSprite)

            self : createCCBI(valueTag,self.m_partneridList[valueTag])

            print("换图片了")
            self.theOldSpriteBtnId = valueTag

            if   self.m_equiplist[valueTag] ~= nil then
                print("按小伙伴按钮切换信息",self.m_partneridList[valueTag])
                self : update(self.m_equiplist[valueTag]) --更新数据以及界面
                self : DefaultFirstEquip(self.m_equiplist[valueTag],valueTag)
                self.thepartnerId = self.m_partneridList[valueTag] --将id传递到强化界面
                self.pushDataId   = self.m_partneridList[valueTag]
                self.TheFirstIndexNo = tonumber(valueTag)
                print("self.pushDataId",self.pushDataId)
            end
        end 
    end
end

function CEquipStrengthenLayer.pushData(self)
    print("pushData id ",self.pushDataId)
    local partnerId =tonumber(self.pushDataId) 
    local data = {}
    if partnerId ~= nil then
        if partnerId == 0 then
            data  = self : getPartnerParams(0)
            for k,v in pairs(data) do
                print("---77>>>",k,v)
            end
            print("mianplayer data")
            --data  =  _G.g_GameDataProxy :getRoleEquipListByPartner( 0)--主将的身上装备数据
        else
            local uid = _G.g_LoginInfoProxy:getUid()           --uid
            local index = tostring( uid..tostring( partnerId))                                     --伙伴id
            local m_roleProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
            data  = m_roleProperty : getEquipList()
        end
        if data ~= nil then
            print("更更新",data,#data)
            for k,v in pairs(data) do
                print("---88>>>",k,v)
            end
            self : update (data)
        end
    end
end

function CEquipStrengthenLayer.NetWorkReturn_MAKE_STREN_MAX( self )
    local msg = "不可强化或已达最高级"
    print("00001")
    -- local function fun1()
    --     print("设置你可以按1")
    --     self.m_StrengthenBtn:setTouchesEnabled(true) 
    -- end
    self : createMessageBox(msg)
end

function CEquipStrengthenLayer.NetWorkReturn_MAKE_STRENGTHEN_OK(self)
    print("强化播放音效")
    self : playEffectSound() --成功特效

    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.StrengthenEquBtn   : removeChild(self.THEccbi,false)
            self.THEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
            if self.THEccbi ~= nil then
                if self.THEccbi  : retainCount() >= 1 then
                    --self.StrengthenEquBtn   : removeChild(self.THEccbi,false)
                    self.THEccbi : removeFromParentAndCleanup(true)
                    self.THEccbi = nil 
                end
            end
            self.m_StrengthenBtn       : setTouchesEnabled(true)
            self.m_OnekeyStrengthenBtn : setTouchesEnabled(true)
            self.m_scenelayer          : setFullScreenTouchEnabled(false)
        end
    end
    if self.THEccbi ~= nil then
        self.THEccbi : removeFromParentAndCleanup(true)
        self.THEccbi = nil 
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
   --self.THEccbi : setPosition(-100,-160)
    self.StrengthenEquBtn  : addChild(self.THEccbi,1000)
end


function CEquipStrengthenLayer.getPartnerParams( self, _partnerid)
    m_roleProperty = nil
    if _partnerid == 0 then
        --玩家自己
        self.m_uid     = _G.g_LoginInfoProxy :getUid()
        m_roleProperty = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    else
        --伙伴 索引为uid..id
        local index    = tostring( _G.g_LoginInfoProxy :getUid())..tostring( _partnerid)
        m_roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if m_roleProperty == nil then
            print( "没有对应伙伴")
            return
        end
        --self.m_stata  = self.m_roleProperty :getStata()
    end
    --self.m_powerful   = self.m_roleProperty :getPowerful()
    self.m_equipcount = m_roleProperty :getEquipCount()
    local m_equiplist  = m_roleProperty : getEquipList()
    print("XXXXXXXXX@@@11:",self.m_equipcount, #m_equiplist )
    return m_equiplist
end

function CEquipStrengthenLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    local sureBtn   = ErrorBox:getBoxEnsureBtn()
    if sureBtn ~= nil then
        sureBtn :setTouchesPriority( -200000-30 )
    end
    self.m_scenelayer : addChild(BoxLayer,1000)
end

function CEquipStrengthenLayer.unloadHeadIcon( self )
    if  self.HeadIconUrlList ~= nil then
         _G.g_unLoadIconSources : unLoadAllIconsByNameList ( self.HeadIconUrlList )
    end
end

function CEquipStrengthenLayer.exchangeDataTable(self,_listdata,_Count) --数据交互
    print("交互一下",_listdata,_Count)
    local temp = {}
    if _listdata ~= nil then
        for i=1,_Count do
            for j=1,_Count-i do
                if tonumber(_listdata[j+1].attr_base_type)  < tonumber(_listdata[j].attr_base_type) then
                    temp = _listdata[j+1]
                    _listdata[j+1] =  _listdata[j]
                    _listdata[j]   = temp
                    print("交互完毕")
                end
            end
        end
    end
    return _listdata
end

function CEquipStrengthenLayer.playEffectSound(self) --成功特效
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
    end
end