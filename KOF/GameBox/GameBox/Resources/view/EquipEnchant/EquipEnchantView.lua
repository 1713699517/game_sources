
--jun
require "view/baginfo/pointView"
require "controller/EquipEnchantCommand"
require "controller/command"
require "view/view"
require "mediator/mediator"
require "mediator/EquipEnchantMediator"


CEquipEnchantView = class(view,function (self)
                            self.TheFirstIndex   = {}
                            self.TheFirstIndexNo = 1
                            self.iswindowscheckBoxChecked = 0

                            self.effectsCCBI         = {} --物品特效
                           end)


function CEquipEnchantView.layer(self)
    self.IpadSize      = 854
    local winSize      = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    
    self.Scenelayer : setControlName( "this is CEquipEnchantView _layer 14" )
    print("CEquipEnchantView.layer",self)
    self : init(winSize, self.Scenelayer)

    return self.Scenelayer
end

function CEquipEnchantView.loadResources(self)

    --CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("EquipmentResources/equipSystemResource.plist")

    _G.Config:load("config/goods.xml")
    _G.Config:load("config/equip_enchant.xml")
    _G.Config:load("config/partner_init.xml")
end

function CEquipEnchantView.unloadResources(self)

end

function CEquipEnchantView.layout(self, winSize)  --适配布局
    if winSize.height == 640 then
        self.m_leftBackGround     : setPosition(250,358-5)    --左底图
        self.m_leftdownBackGround : setPosition(250,80-9+2)   --左底图
        self.m_rightBackGround    : setPosition(665,290-3)    --右底图
        self.equipInfoArea_layer  : setPosition(460,230)  --宝石区域

    elseif winSize.height == 768 then
        self.m_leftBackGround     : setPosition(250,358)    --左底图
        self.m_leftdownBackGround : setPosition(250,80)     --左底图
        self.m_rightBackGround    : setPosition(670,290)    --右底图
        self.equipInfoArea_layer  : setPosition(460,230)  --宝石区域
    end
end

function CEquipEnchantView.init(self, winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(winSize,_layer)              --界面初始化
    self : layout(winSize)                       --适配布局初始化
    self : initParameter()                       --参数初始化
    self : getTeamersData()                      --小伙伴初始化
    self : DefaultFirstEquip()                   --默认第一个装备
end

function CEquipEnchantView.initView(self,winSize,_layer)

    self.m_leftBackGround     = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_leftdownBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround    = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图
    
    self.m_leftBackGround     : setPreferredSize(CCSizeMake(410,425)) --420 260
    self.m_leftdownBackGround : setPreferredSize(CCSizeMake(410,130-5)) --420 260
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(410,550+5)) --400 500
    
    _layer : addChild(self.m_leftBackGround)
    _layer : addChild(self.m_leftdownBackGround)
    _layer : addChild(self.m_rightBackGround)

    local function BagEquipButtonCallBack(eventType,obj,x,y)
        return self:BagEquipBtnCallBack(eventType,obj,x,y)
    end
 
    self.m_BagEquipBtn       = {} --背包装备物品按钮
    self.m_BagEquipBtnSprite = {} --背包装备物品按钮图
    self.BagEquipBtnSprites  = {} --背包装备物品按钮图
    -- self.effectsCCBI         = {} --物品特效

    local iconLayout   = CHorizontalLayout : create()
    iconLayout         : setControlName( "this is CEquipEnchantView iconLayout 76" )

    iconLayout   : setLineNodeSum(2)
    iconLayout   : setCellSize(CCSizeMake(293-30,140-10))
    iconLayout   : setVerticalDirection(false)
    iconLayout   : setPosition(-45+32,358+140-13)
    --iconLayout   : setPosition(-296,140)
    _layer       : addChild(iconLayout)

    for k=1,6 do
        self.m_BagEquipBtn[k] = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
        self.m_BagEquipBtn[k] : registerControlScriptHandler(BagEquipButtonCallBack,"this is CEquipEnchantView.initView m_BagEquipBtn 108")
        iconLayout            :  addChild(self.m_BagEquipBtn[k])

        self.BagEquipBtnSprites[k] = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
        self.m_BagEquipBtn[k]      :  addChild(self.BagEquipBtnSprites[k],3)   

        --框底图
        local BlackSprite          = CSprite :createWithSpriteFrameName("general_props_underframe.png")
        self.m_BagEquipBtn[k]      :  addChild(BlackSprite,-2)  
    end

    --小伙伴区域
    local function teamerCallBack(eventType,obj,x,y)
       return self:teamerCallBack(eventType,obj,x,y)
    end   
    self.teamerlayout = CHorizontalLayout : create()
    self.teamerlayout : setLineNodeSum(4)
    self.teamerlayout : setCellSize(CCSizeMake(100,100))
    self.teamerlayout : setVerticalDirection(false)
    local m_leftdownBackGroundSize = self.m_leftdownBackGround : getPreferredSize()
    self.teamerlayout : setPosition((m_leftdownBackGroundSize.width-400)/2,(m_leftdownBackGroundSize.height-100)/2+50)
    self.m_leftdownBackGround : addChild(self.teamerlayout,10)

    self.TeamerBtn      = {} --小伙伴按钮
    self.TeamerBtnImage = {} --小伙伴按钮头像
    for w=1,4 do
        self.TeamerBtn[w] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
        self.teamerlayout : addChild( self.TeamerBtn[w] )  

        local TeamerBtnSprite = CSprite : createWithSpriteFrameName("general_role_head_underframe.png")
        self.TeamerBtn[w]     : addChild(TeamerBtnSprite,-2) 
    end

    --物品信息区域
    self.equipInfoArea_layer = CContainer :create()
    self.equipInfoArea_layer : setControlName( "this is CEquipEnchantView self.equipInfoArea_layer 98" )
    _layer                   : addChild(self.equipInfoArea_layer,2)
    --装备图标
    local function EquipInButtonCallBack(eventType, obj,x,y)
        return   self:EquipInfoBtCallBack(eventType,obj,x,y)
    end
    self.m_EquipInfoBtn      = CButton :createWithSpriteFrameName("","general_equip_frame.png")
    self.m_EquipInfoBtn      : registerControlScriptHandler(EquipInButtonCallBack)
    self.m_EquipInfoBtn      : setTouchesEnabled(true)
    self.m_EquipInfoBtn      : setPosition(200,270)
    self.equipInfoArea_layer :  addChild(self.m_EquipInfoBtn)

    self.m_EquipNameBtnLabel = CCLabelTTF :create("","Arial",20)
    self.m_EquipNameBtnLabel : setPosition(0,-70)
    self.m_EquipInfoBtn      : addChild(self.m_EquipNameBtnLabel)
    --属性描述
    self.iconInfoLayout       = CHorizontalLayout : create()
    self.iconInfoLayout       : setControlName( "this is CEquipEnchantView self.iconInfoLayout 108" )
    self.iconInfoLayout       : setLineNodeSum(1)
    self.iconInfoLayout       : setCellSize(CCSizeMake(200,27))
    self.iconInfoLayout       : setVerticalDirection(false)
    self.iconInfoLayout       : setPosition(125,150)
    self.equipInfoArea_layer  : addChild(self.iconInfoLayout)

    self.iconInfoLabel = {} --信息label
    for i=1,3 do
        self.iconInfoLabel[i] = CCLabelTTF :create("","Arial",20)
        self.iconInfoLabel[i] : setAnchorPoint( ccp(0.0, 0.5)) 
        self.iconInfoLayout   : addChild (self.iconInfoLabel[i])
    end
    self.iconInfoLabel[1] : setColor(ccc3(0,180,255))
    self.iconInfoLabel[2] : setColor(ccc3(255,255,0))
    self.iconInfoLabel[3] : setColor(ccc3(94,208,18))

    self.LabelInfoLabel = {} --信息label
    for i=1,3 do
        self.LabelInfoLabel[i] = CCLabelTTF :create("","Arial",20)
        self.LabelInfoLabel[i] : setAnchorPoint( ccp(0.0, 0.5)) 
        self.LabelInfoLabel[i] : setPosition(-180,10)
        self.iconInfoLabel[i]  : addChild (self.LabelInfoLabel[i])
    end   

    --魔石图标
    local function StoneButtonCallBack(eventType, obj, touches)
     return   self:StoneBtnCallBack(eventType, obj, touches)
    end
    self.m_StoneBtn          = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
    self.m_StoneBtn          : registerControlScriptHandler(StoneButtonCallBack)
    self.m_StoneBtn          : setTouchesEnabled( true)
    self.m_StoneBtn          : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_StoneBtn          : setPosition(200,-5) --  -5
    self.equipInfoArea_layer :  addChild(self.m_StoneBtn)

    self.m_StoneCountLabel = CCLabelTTF :create("","Arial",18)
    self.m_StoneNameLabel  = CCLabelTTF :create("","Arial",18)
    --self.m_StoneCountLabel : setAnchorPoint( ccp(0.0, 0.5)) 
    self.m_StoneNameLabel  : setAnchorPoint( ccp(0.0, 0.5)) 
    self.m_ConsumeLabel    = CCLabelTTF :create("","Arial",18)
    self.m_ConsumeLabel    : setColor(ccc3(255,255,0))

    self.m_StoneCountLabel : setPosition(-5+30,-30)
    self.m_StoneNameLabel  : setPosition(-35,-60)
    self.m_ConsumeLabel    : setPosition(0,-90)

    self.m_StoneBtn :  addChild(self.m_StoneCountLabel,2)
    self.m_StoneBtn :  addChild(self.m_StoneNameLabel,2)
    self.m_StoneBtn :  addChild(self.m_ConsumeLabel,2)

    --附魔按钮
    local function EnchantButtonCallBack(eventType,obj,x,y)
     return   self:EnchantBtnCallBack(eventType,obj,x,y)
    end
    self.m_EnchantBtn         = CButton :createWithSpriteFrameName("附魔","general_button_normal.png")
    self.m_EnchantBtn         : registerControlScriptHandler(EnchantButtonCallBack)
    self.m_EnchantBtn         : setFontSize(20)
    self.m_EnchantBtn         : setPosition(115,-150)
    self.equipInfoArea_layer  : addChild(self.m_EnchantBtn)

    --钻石附魔
    local function YBEnchantButtonCallBack(eventType,obj,x,y)
     return   self:YBEnchantBtnCallBack(eventType,obj,x,y)
    end
    self.m_YBEnchantBtn      = CButton :createWithSpriteFrameName("钻石附魔","general_button_normal.png")
    self.m_YBEnchantBtn      : registerControlScriptHandler(YBEnchantButtonCallBack)
    self.m_YBEnchantBtn      : setFontSize(20)
    self.m_YBEnchantBtn      : setPosition(310,-150)
    self.equipInfoArea_layer : addChild(self.m_YBEnchantBtn)
end

function CEquipEnchantView.initParameter(self)
    self.thepartnerId = 0
    self.pushDataId   = 0 
    self : EquipmentListAnalyzed() --装备表解析
end

function CEquipEnchantView.EquipmentListAnalyzed(self,_EquipmentList)  --装备表解析
    print("EquipmentListAnalyzed 进来了")

    require "view/EquipInfoView/EquipXmlAnalyzed"
    require "proxy/GoodsProperty"

    if _EquipmentList == nil then
        self.EquipmentList = self : getPartnerParams(0)--人物身上的装备 0为主将
    else
        self.EquipmentList = _EquipmentList
    end

    self.EquipListData       = {}  --装备数据表
    self.theTransId          = {}
    self.EquipCount          = nil

    --先清除一些东西
    for i=1,6 do
         print("删除之前装备图片0000",i)
        if  self.m_BagEquipBtnSprite[i] ~= nil then
            self.m_BagEquipBtnSprite[i] : removeFromParentAndCleanup(true)
            self.m_BagEquipBtnSprite[i] = nil

            if self.effectsCCBI[i] ~= nil then
                if self.effectsCCBI[i]    : retainCount() >= 1 then
                    self.m_BagEquipBtn[i] : removeChild(self.effectsCCBI[i],false)
                    self.effectsCCBI[i]   = nil 
                end
            end
            print("删除之前装备图片",i)
        end
        self.m_BagEquipBtn[i] : setTag(-1)                         --传递背包装备的ID
        self.theTransId[i]    = nil
    end
    --装备
    print("self.EquipmentList==196==",self.EquipmentList)
    if self.EquipmentList ~= nil  then
        for i,Equip in ipairs(self.EquipmentList) do
            self.EquipCount = i
            self.EquipListData[Equip.goods_id] = {}
            self.EquipListData[Equip.goods_id]["goods_id"  ] = Equip.goods_id        --装备id
            self.EquipListData[Equip.goods_id]["index"     ] = Equip.index           --装备索引位置idx
            self.EquipListData[Equip.goods_id]["goods_num" ] = Equip.goods_num       --装备叠加数量
            self.EquipListData[Equip.goods_id]["goods_type"] = Equip.goods_type      --装备大类
            self.EquipListData[Equip.goods_id]["price"     ] = Equip.price           --装备价格
            self.EquipListData[Equip.goods_id]["strengthen"] = Equip.strengthen      --装备强化等级   
            self.EquipListData[Equip.goods_id]["fumo"      ] = Equip.fumo            --附魔
            self.EquipListData[Equip.goods_id]["fumoz"     ] = Equip.fumoz           --附魔值        
            print("装备==",Equip,Equip.goods_id,Equip.goods_num,self.EquipListData[Equip.goods_id])

            -- equipNode = _G.Config.goodss :selectNode("goods","id",tostring(Equip.goods_id)) --装备xml信息
            local equipNode                                 = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(Equip.goods_id).."]") --装备xml信息
            local equipNode_child_base_types                = equipNode : children() : get(0,"base_types")
            local equipNode_child_attr                      = equipNode : children() : get(0,"attr")
            local equipNode_child_base_types_base_typeCount = equipNode_child_base_types : children() : getCount("base_type")

            for i = 0, equipNode_child_base_types_base_typeCount-1 do
                self.EquipListData[Equip.goods_id]["base_type_count"]      = i + 1
                self.EquipListData[Equip.goods_id]["base_type"..i+1]       = {}

                local Onebase_type = equipNode_child_base_types  : children() : get(i,"base_type")
                self.EquipListData[Equip.goods_id]["base_type"..i+1]["type"] = Onebase_type : getAttribute("type")
                self.EquipListData[Equip.goods_id]["base_type"..i+1]["v"]    = Onebase_type : getAttribute("v")   
            end

            -- for i,base_type in pairs(equipNode.base_types[1].base_type) do           --装备的基础属性
            --     self.EquipListData[Equip.goods_id]["base_type_count"]      = i
            --     self.EquipListData[Equip.goods_id]["base_type"..i]         = {}
            --     self.EquipListData[Equip.goods_id]["base_type"..i]["type"] = base_type.type
            --     self.EquipListData[Equip.goods_id]["base_type"..i]["v"]    = base_type.v    
            -- end

            self.EquipListData[Equip.goods_id]["name"]       = equipNode: getAttribute("name")                --装备名字(xml)
            self.EquipListData[Equip.goods_id]["name_color"] = tonumber(equipNode: getAttribute("name_color"))--装备名字颜色(xml)
            self.EquipListData[Equip.goods_id]["class"]      = equipNode: getAttribute("class")               --装备阶级class(xml)
            self.EquipListData[Equip.goods_id]["type_sub"]   = equipNode: getAttribute("type_sub")            --装备类型(xml)

            self.EquipListData[Equip.goods_id]["strong_att"] = equipNode_child_attr : getAttribute("strong_att")  --装备物理攻击(xml)
            self.EquipListData[Equip.goods_id]["skill_att"]  = equipNode_child_attr : getAttribute("skill_att")   --装备技能攻击(xml)
            self.EquipListData[Equip.goods_id]["equ_lv"]     = equipNode: getAttribute("lv")                  --装备等级()
            self.EquipListData[Equip.goods_id]["icon"]       = equipNode: getAttribute("icon")                --装备图标()
            self.EquipListData[Equip.goods_id]["type_sub_name"] = equipNode: getAttribute("type_sub_name")    --类型名字() 

            --------------------------------------------------------------------------------------------------------
            local type_sub = tonumber(equipNode: getAttribute("type_sub") )
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
            local equipNode_icon  =  equipNode : getAttribute("icon")
            local ion_url         = "Icon/i"..equipNode_icon..".jpg"
            _G.g_unLoadIconSources : addIconData( equipNode_icon )
            self.m_BagEquipBtnSprite[i]       = CCSprite :create(ion_url)
            self.m_BagEquipBtn[i] : addChild(self.m_BagEquipBtnSprite[i],-1)

            self : Create_effects_equip(i,self.m_BagEquipBtn[i],equipNode : getAttribute("name_color"),1)
        end
    end
end

function CEquipEnchantView.Create_effects_equip ( self,no,obj,name_color,types) --type=1是左边装备栏 2是装备显示图标 
    name_color = tonumber(name_color)
    if name_color > 0 and name_color < 8 then 
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end

        if obj ~= nil then
            if types == 1 then
                if  self.effectsCCBI[no] ~= nil then
                    self.effectsCCBI[no] : removeFromParentAndCleanup(true)
                    self.effectsCCBI[no] = nil
                end

                self.effectsCCBI[no] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self.effectsCCBI[no] : setControlName( "this CCBI Create_effects_activity CCBI")
                self.effectsCCBI[no] : registerControlScriptHandler( animationCallFunc)
                obj                  : addChild(self.effectsCCBI[no],1000)
            end 
            if types == 2 then
                if  self.EquipInfo_effectsCCBI ~= nil then
                    self.EquipInfo_effectsCCBI : removeFromParentAndCleanup(true)
                    self.EquipInfo_effectsCCBI = nil
                end
                self.EquipInfo_effectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self.EquipInfo_effectsCCBI : setControlName( "this CCBI Create_effects_activity CCBI")
                self.EquipInfo_effectsCCBI : registerControlScriptHandler( animationCallFunc)
                obj                       : addChild(self.EquipInfo_effectsCCBI,1000)
            end
        end
    end
end

function CEquipEnchantView.removeeffectsCCBI(self)
    for i=1,6 do
        if self.effectsCCBI[i] ~= nil then
            if self.effectsCCBI[i]  : retainCount() >= 1 then
                print("附魔界面关闭的时候删除 effectsCCBI",i)
                self.effectsCCBI[i] : removeChild(self.effectsCCBI[i],false)
                self.effectsCCBI[i] = nil 
            end
        end
    end

    if self.EquipInfo_effectsCCBI ~= nil then
        if self.EquipInfo_effectsCCBI  : retainCount() >= 1 then
            print("附魔界面关闭的时候删除 EquipInfo_effectsCCBI",i)
            self.EquipInfo_effectsCCBI : removeChild(self.effectsCCBI[i],false)
            self.EquipInfo_effectsCCBI = nil 
        end
    end

    print("累干不爱")
    if self.Scenelayer ~= nil then
        self.Scenelayer : removeFromParentAndCleanup(true)
        self.Scenelayer = nil 
    end
end


--方法回调-----
function CEquipEnchantView.BagEquipBtnCallBack(self,eventType,obj,x,y)  --背包装备回调
   
    print("eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR( ccp(x,y) ) )
    elseif eventType == "TouchEnded" then
        self : CleanPearl_comXmlData () --数据清空

        local  i      = tonumber(obj : getTag()) --传递过来的ID
        if i ~= nil and i > 0 then
            print("装备回调",equ_id)
            self : BagEquipBtnCallBackMethond(i )
        end

    end
end

--多点触控
function CEquipEnchantView.StoneBtnCallBack(self, eventType, obj, touches)

    _G.g_PopupView :reset()

    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.StoneBtnSpriteBtnCallBackId = obj:getTag()
                    
                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        _G.g_PopupView :reset()
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)

            if touch2:getID() == self.touchID and self.StoneBtnSpriteBtnCallBackId == obj:getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local id = obj:getTag() 

                    _position   = {}
                    _position.x = touch2Point.x-150
                    _position.y = touch2Point.y
                    if id ~= nil then
                        local  temp =  _G.g_PopupView :createByGoodsId(id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
                        self.Scenelayer :addChild(temp,10000)
                    end
                    self.StoneBtnSpriteBtnCallBackId = nil 
                end
            end
        end
    end
end

function CEquipEnchantView.EquipInfoBtCallBack(self,eventType,obj,x,y)  --选中装备 显示图片的回调
   
    print("eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR( ccp(x,y) ) )
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()

        local id = tonumber(obj:getTag())  

        _position   = {}
        _position.x = x-150
        _position.y = y

        if id ~= nil and id > 0 then
            local  temp =  _G.g_PopupView :createByGoodsId(id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
            self.Scenelayer :addChild(temp,10000)
        end

    end
end

function CEquipEnchantView.BagEquipBtnCallBackMethond(self,i)
    _G.g_PopupView :reset()

    local equ_id  = tonumber(self.theTransId[i])  

    print("装备的方法回调",equ_id)

    self : chagneBagEquipBtnSprites(i)

    if equ_id ~= nil and equ_id > 0  then
        self.transferId = equ_id      --将ID传递到更新函数
        print("302 equ_id",equ_id)

        local equipNode      = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(equ_id).."]") --装备xml信息
        local equipNode_icon = equipNode : getAttribute("icon")
        local ion_url            = "Icon/i"..equipNode_icon..".jpg"
        _G.g_unLoadIconSources : addIconData( equipNode_icon )
        self.EquipInfoBtnSprites = CSprite :create(ion_url)
        self.m_EquipInfoBtn      : addChild(self.EquipInfoBtnSprites,-1) --装备信息栏装备图标
        self.m_EquipInfoBtn      : setTag(equ_id)

        self : Create_effects_equip(nil,self.m_EquipInfoBtn,equipNode : getAttribute("name_color"),2) --装备特效

        self:GetEquipXmlData(equ_id)                                     --装备XML表解析
    end
end

function CEquipEnchantView.chagneBagEquipBtnSprites(self, _i)
    local i = tonumber (_i) 
    if self.oldno ~= nil and self.oldno > 0 then
        self.BagEquipBtnSprites[self.oldno] :  setImageWithSpriteFrameName( "general_props_frame_normal.png" )
    end
    if i ~= nil and i > 0 then
        self.BagEquipBtnSprites[i] : setImageWithSpriteFrameName("general_props_frame_click.png")  
        self.oldno = i   
    end 
end

function CEquipEnchantView.CleanPearl_comXmlData(self) --显示区域数据清理
    self.m_EquipNameBtnLabel : setString("")

    for i=1,3 do
        self.iconInfoLabel[i]  : setString("")
        self.LabelInfoLabel[i] : setString("")
    end

    self.m_StoneCountLabel    : setString("")
    self.m_StoneNameLabel     : setString("")
    self.m_ConsumeLabel       : setString("")
    self.explabel             : setString("")

    if self.EquipInfoBtnSprites ~= nil then
        self.EquipInfoBtnSprites : removeFromParentAndCleanup(true) 
        self.EquipInfoBtnSprites = nil
    end
    if  self.m_StoneBtnSprite ~= nil then
        self.m_StoneBtnSprite : removeFromParentAndCleanup(true)
        self.m_StoneBtnSprite = nil
    end
    if self.frame  ~= nil then
        self.frame : removeFromParentAndCleanup(true)
        self.frame = nil
    end
    print("CleanPearl_comXmlDataok",self.EquipInfoBtnSprites,self.m_StoneBtnSprite)

    if self.EquipInfo_effectsCCBI ~= nil then
        if self.EquipInfo_effectsCCBI  : retainCount() >= 1 then
            self.m_EquipInfoBtn   : removeChild(self.EquipInfo_effectsCCBI,false)
            self.EquipInfo_effectsCCBI = nil 
        end
    end
end

function CEquipEnchantView.GetEquipXmlData(self,equ_id)
 
   -- print("--------------9999---------",self.EquipListData[equ_id]["type_sub"],self.EquipListData[equ_id]["name"])
    print("GetEquipXmlData",equ_id,self,self.EquipListData,#self.EquipListData,self.EquipListData[equ_id])
    local name              = self.EquipListData[equ_id]["name"]            --装备名字
    local typesub           = self.EquipListData[equ_id]["type_sub"]        --装备类型(xml)
    local fumo              =tonumber(self.EquipListData[equ_id]["fumo" ])  --附魔(服务器) =step
    local fumoz             = self.EquipListData[equ_id]["fumoz"]           --附魔值（服务器） =value
    local equ_index         = self.EquipListData[equ_id]["index"]           --装备位置(服务器)
    local icon              = self.EquipListData[equ_id]["icon"] 
    local name_color        = self.EquipListData[equ_id]["name_color"]
    self.change_equ_index   = equ_index

    local allgoods_num      = 0  --背包魔石数量
    if fumo == 0 then

        Equip_enchantID         = typesub.."_".."1"                   --附魔节点ID
        print("Equip_enchantID",Equip_enchantID)
        --local equip_enchantNode = _G.Config.equip_enchants:selectNode("equip_enchant","id",tostring(Equip_enchantID)) --附魔节点
        local equip_enchantNode = _G.Config.equip_enchants : selectSingleNode("equip_enchant[@id="..tostring(Equip_enchantID).."]") --附魔节点
        equip_enchantNode_goods =  equip_enchantNode : children() : get(0,"goods")
        step                    = 0              --附魔等阶    
        step_name               = "0阶"           --附魔等阶名字
        step_value              = equip_enchantNode : getAttribute("step_value")         --附魔等阶值
        need_money              = equip_enchantNode : getAttribute("money")              --附魔价格
        need_goods_id           = equip_enchantNode : getAttribute("goods")    --附魔所需物品id
        --need_goods_count        = equip_enchantNode_goods : getAttribute("count")       --附魔所需物品数量  

        self.EquipListData[equ_id]["need_money"]       = need_money     --附魔价格
        self.EquipListData[equ_id]["need_goods_id"]    = need_goods_id  --附魔所需物品id
        --self.EquipListData[equ_id]["need_goods_count"] = need_goods_count  --附魔所需物品数量  

        local nextstep              = step + 1 
        nextEquip_enchantID         = typesub.."_"..nextstep                   --下一附魔节点ID

        local nextequip_enchantNode = _G.Config.equip_enchants : selectSingleNode("equip_enchant[@id="..tostring(nextEquip_enchantID).."]") --附魔节点
        nextstep_name               = nextequip_enchantNode: getAttribute("step_name")           --附魔等阶名字
        nextstep_value              = nextequip_enchantNode: getAttribute("step_value")          --附魔等阶值

        local needStoneCount = tonumber(nextstep_value) 

        --背包的魔石数量
        local MaterialList = _G.g_GameDataProxy : getMaterialList() 
        if MaterialList ~= nil then
            for k,v in pairs(MaterialList) do
                if tonumber(need_goods_id) == tonumber(v.goods_id) then
                    allgoods_num = allgoods_num + v.goods_num
                end
            end
        end

        if  needStoneCount > allgoods_num then --所缺经验点大于 背包魔石数量
            self.EquipListData[equ_id]["need_money"]       = allgoods_num * need_money       --附魔价格
        else
            self.EquipListData[equ_id]["need_money"]       = needStoneCount * need_money      --附魔价格
        end

    else
        Equip_enchantID         = typesub.."_"..fumo                   --附魔节点ID
        print("Equip_enchantID",Equip_enchantID)
        local equip_enchantNode = _G.Config.equip_enchants : selectSingleNode("equip_enchant[@id="..tostring(Equip_enchantID).."]") --附魔节点

        -- local equip_enchantNode_goods =  equip_enchantNode : children() : get(0,"goods")
        step                    =tonumber(equip_enchantNode: getAttribute("step"))        --附魔等阶    
        step_name               = equip_enchantNode: getAttribute("step_name")            --附魔等阶名字
        step_value              = equip_enchantNode: getAttribute("step_value")           --附魔等阶值
        need_money              = equip_enchantNode: getAttribute("money")                --单个物品的附魔价格
        need_goods_id           = equip_enchantNode: getAttribute("goods")                --附魔所需物品id
        --need_goods_count        = equip_enchantNode_goods: getAttribute("count")          --附魔所需物品数量  


        -- self.EquipListData[equ_id]["need_money"]       = need_money       --附魔价格
        self.EquipListData[equ_id]["need_goods_id"]    = need_goods_id    --附魔所需物品id
        --self.EquipListData[equ_id]["need_goods_count"] = need_goods_count --附魔所需物品数量      

        local nextstep              = step + 1 
        nextEquip_enchantID         = typesub.."_"..nextstep                   --下一附魔节点ID
        print("11322 nextstep",need_money,nextstep,nextEquip_enchantID)
        -- local nextequip_enchantNode = _G.Config.equip_enchants:selectNode("equip_enchant","id",tostring(nextEquip_enchantID)) --附魔节点
        local nextequip_enchantNode = _G.Config.equip_enchants : selectSingleNode("equip_enchant[@id="..tostring(nextEquip_enchantID).."]") --附魔节点
        nextstep_name               = nextequip_enchantNode: getAttribute("step_name")           --附魔等阶名字
        nextstep_value              = nextequip_enchantNode: getAttribute("step_value")          --附魔等阶值

        local needStoneCount = tonumber(nextstep_value) - tonumber(fumoz)

        --背包的魔石数量
        local MaterialList = _G.g_GameDataProxy : getMaterialList() 
        if MaterialList ~= nil then
            for k,v in pairs(MaterialList) do
                if tonumber(need_goods_id) == tonumber(v.goods_id) then
                    allgoods_num = allgoods_num + v.goods_num
                end
            end
        end

        if  needStoneCount > allgoods_num then --所缺经验点大于 背包魔石数量
            self.EquipListData[equ_id]["need_money"]       = allgoods_num * need_money       --附魔价格
        else
            self.EquipListData[equ_id]["need_money"]       = needStoneCount * need_money      --附魔价格
        end
    end    
    
    self.m_EquipNameBtnLabel : setString(name)
    if name_color ~= nil and name_color > 0 then
        if(name_color == 1)then
            self.m_EquipNameBtnLabel : setColor(ccc3(255,255,255))
        elseif(name_color == 2)then
            self.m_EquipNameBtnLabel : setColor(ccc3(91,200,19))
        elseif(name_color == 3)then
            self.m_EquipNameBtnLabel : setColor(ccc3(0,155,255))
        elseif(name_color == 4)then
            self.m_EquipNameBtnLabel : setColor(ccc3(155,0,188))
        elseif(name_color == 5)then
            self.m_EquipNameBtnLabel : setColor(ccc3(255,255,0))
        elseif(name_color == 6)then
            self.m_EquipNameBtnLabel : setColor(ccc3(255,155,0))
        elseif(name_color == 7)then
            self.m_EquipNameBtnLabel : setColor(ccc3(255,0,0))
        else
            print("无")
        end
    end
    self.LabelInfoLabel[1] : setString("当前附魔   ")
    self.LabelInfoLabel[2] : setString("当前附魔加成")
    self.LabelInfoLabel[3] : setString("下级附魔   ")

    self.m_labelStr  = {
                        step_name,
                        step.."%",
                        nextstep_name
                        }
    for i=1,3 do
        self.iconInfoLabel[i] : setString(self.m_labelStr[i])
    end
    --进度条
    local  winSize  = CCDirector:sharedDirector():getVisibleSize()
    if  self.frame == nil then
        print("self.frame建立了了了了了了了")
        self.frame      = CSprite : createWithSpriteFrameName("equip_exp_frame_short.png")
        print("*************--->>>00",self)
        self.frame      : setPosition(60,-205)  
        local frameSize = self.frame   : getPreferredSize()
        self.m_EquipInfoBtn : addChild(self.frame)

        if fumoz > 0 then
            local exp       = CSprite : createWithSpriteFrameName( "therole_exp.png",CCRectMake( 11, 0, 1 , 21)) 
            self.frame      : addChild(exp,10) 
            local value  = math.floor(fumoz/nextstep_value*(236-18)) + 18
            exp             : setPreferredSize( CCSizeMake(value , 21)) --18 ～236
            local sprSize   = exp : getPreferredSize()
            exp             : setPosition(-(frameSize.width/2 - sprSize.width/2)+4,0)
        end
    end

    if self.explabel == nil then
        self.explabel   = CCLabelTTF : create("经验","Arial",20)
        self.explabel   : setPosition(-135,-205)  
        self.m_EquipInfoBtn : addChild(self.explabel,12) 
    else
        self.explabel : setString("经验")
    end  

    self.explabel2 = CCLabelTTF : create(fumoz.."/"..nextstep_value,"Arial",20)
    self.frame      : addChild(self.explabel2,12) 

    --魔石图片
    if self.m_StoneBtnSprite == nil then
        --local equip_needenchantNode = _G.Config.goodss:selectNode("goods","id",tostring(need_goods_id)) --附魔所需物品节点
        local equip_needenchantNode = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(need_goods_id).."]") --附魔所需物品节点
        local equip_needenchantNode_icon =  equip_needenchantNode : getAttribute("icon")
        if  equip_needenchantNode : isEmpty() == false then
            local needicon_url     = "Icon/i"..equip_needenchantNode_icon..".jpg"
            _G.g_unLoadIconSources : addIconData( equip_needenchantNode_icon )
            self.m_StoneBtnSprite  = CSprite :create(needicon_url)
            self.m_StoneBtn        : addChild(self.m_StoneBtnSprite,-1)
            self.m_StoneBtn        : setTag(need_goods_id)
            if  tonumber(allgoods_num) > 0 then  
                self.m_StoneBtnSprite :setGray( false)
            else
                self.m_StoneBtnSprite :setGray( true)
            end
            self.m_StoneNameLabel  : setString(equip_needenchantNode: getAttribute("name"))
        end
    end

    if self.EquipInfoBtnSprites == nil  then
        local the_url            = "Icon/i"..icon..".jpg"
        _G.g_unLoadIconSources   : addIconData( icon )
        self.EquipInfoBtnSprites = CSprite :create(the_url)
        self.m_EquipInfoBtn      : addChild(self.EquipInfoBtnSprites,-1) --装备信息栏装备图标
        self.m_EquipInfoBtn      : setTag(equ_id)
        self : Create_effects_equip(nil,self.m_EquipInfoBtn,name_color,2) --装备特效
    end

    --self.m_StoneCountLabel : setString(allgoods_num.."/"..need_goods_count)
    self.m_StoneCountLabel : setString(allgoods_num)
    self.m_ConsumeLabel    : setString("消费美刀  "..self.EquipListData[equ_id]["need_money"])
    print("522522----->?")
    self.m_EnchantBtn      : setTag(tonumber(equ_id))                         --传递背包装备的ID  
    self.m_YBEnchantBtn    : setTag(tonumber(equ_id))                         --传递背包装备的ID  
end

function CEquipEnchantView.EnchantBtnCallBack(self,eventType,obj,x,y)

  if eventType == "TouchBegan" then
    return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    _G.g_PopupView :reset()

    self : setFullScreen(1) --设置全屏可按
    local  equ_id = obj : getTag()      --传递过来的ID
    print("附魔回调",obj : getTag())

    if equ_id ~= nil and equ_id > 0  then
        local need_money       = tonumber(self.EquipListData[equ_id]["need_money"])            --附魔价格
        local need_goods_id    = tonumber(self.EquipListData[equ_id]["need_goods_id"])          --附魔所需物品id
        --local need_goods_count = tonumber(self.EquipListData[equ_id]["need_goods_count"])       --附魔所需物品数量   
        local index            = self.EquipListData[equ_id]["index"]

        local mainProperty     = _G.g_characterProperty : getMainPlay()
        local gold             =tonumber(mainProperty : getGold())                      --获取背包金币 
        local m_nGoldNum       = mainProperty :getBindRmb()

        local theno               = self.TheFirstIndexNo
        self.TheFirstIndex[theno] = tonumber(index)
        print("thenothenothenothenotheno",theno,self.TheFirstIndex[theno])

        print("gold，need_money，m_nGoldNum",gold,need_money,m_nGoldNum)

        if gold == nil then
            gold = 0
        end
        m_MaterialListData      =  _G.g_GameDataProxy : getMaterialList()   --材料列表
        bag_goods_count = 0
        for k,v in pairs(m_MaterialListData) do
            if(need_goods_id == v.goods_id)then
                bag_goods_count =tonumber(v.goods_num)      --背包魔石数量
                break
            end
        end
        print("all value = ",need_money,need_goods_id,gold,index,bag_goods_count,self.thepartnerId)
        print("------->",bag_goods_count)
        if bag_goods_count > 0 then
            if gold >= need_money and self.thepartnerId ~= nil then
                require "common/protocol/auto/REQ_MAKE_ENCHANT"
                local msg = REQ_MAKE_ENCHANT()
                msg :setType(2)    -- 1背包2装备栏
                msg :setId(self.thepartnerId)      --主将0|武将ID
                msg :setIdx(index) --物品idx
                msg :setArg(0) -- 1:金元附魔 0:普通附魔
                CNetwork :send(msg)
                print("附魔成功")
            else
                print("背包金币不足") 
                local msg = "美刀不足，招财可获得美刀！"
                self : createMessageBox(msg)
            end
        else
            print("魔石数量不足")
            local msg = "魔石不足，魔王副本可获得魔石！"
            self : createMessageBox(msg)
        end
    end

  end
end

function CEquipEnchantView.YBEnchantBtnCallBack(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
    return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    _G.g_PopupView :reset()

    self : setFullScreen()                   --设置全屏可按

    local  equ_id = tonumber(obj : getTag()) --传递过来的ID
    if equ_id ~= nil and equ_id ~= 0 then
        self.YBEnchantequ_id = tonumber(equ_id)
        print("钻石附魔回调",obj : getTag(),self.EnchantRmb)
        self : MAKE_ENCHANT_S()              --钻石附魔消耗请求
    end
  end
end

function CEquipEnchantView.setFullScreen( self,_type)
    local actarr = CCArray:create()
    local function t_callback1()
        if _type == 1 then
            self.m_EnchantBtn : setTouchesEnabled(false)
        elseif _type == 2 then
            self.m_YBEnchantBtn : setTouchesEnabled(false)
        end

        self.Scenelayer : setFullScreenTouchEnabled(true)
        self.Scenelayer : setTouchesPriority(-100)
        self.Scenelayer : setTouchesEnabled(true)
    end
    local function t_callback2()
        self.m_EnchantBtn : setTouchesEnabled(true)
        self.m_YBEnchantBtn : setTouchesEnabled(true)

        self.Scenelayer : setFullScreenTouchEnabled(false)
    end
    local delayTime = 1
    actarr:addObject( CCCallFunc:create(t_callback1) )
    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(t_callback2) )
    self.Scenelayer:runAction( CCSequence:create(actarr) )
end

function CEquipEnchantView.MAKE_ENCHANT_S(self)
    require "common/protocol/auto/REQ_MAKE_ENCHANT_S"
    local msg = REQ_MAKE_ENCHANT_S()
    CNetwork :send(msg)
    print("钻石附魔消耗请求")
end
function CEquipEnchantView.GetEnchantRmb(self,_rmb)

    print("钻石附魔消耗RMB",_rmb)
    local EnchantRmb = 0 
    EnchantRmb =tonumber(_rmb) 
    print("钻石附魔消耗self.EnchantRmb",EnchantRmb)
    local equ_id = self.YBEnchantequ_id
    if equ_id ~=nil and equ_id > 0 then
        local need_money       = tonumber(self.EquipListData[equ_id]["need_money"])            --附魔价格
        local need_goods_id    = tonumber(self.EquipListData[equ_id]["need_goods_id"] )        --附魔所需物品id
        --local need_goods_count = tonumber(self.EquipListData[equ_id]["need_goods_count"] )     --附魔所需物品数量   
        --print("737  33",need_goods_count)
        local index            = self.EquipListData[equ_id]["index"]

        local mainProperty     = _G.g_characterProperty : getMainPlay()
        local gold             =tonumber( mainProperty : getGold() )                    --获取背包金币 
        local m_nGoldNum       = mainProperty :getBindRmb()

        local theno               = self.TheFirstIndexNo
        self.TheFirstIndex[theno] = tonumber(index)
        print("thenothenothenothenotheno",theno,self.TheFirstIndex[theno])

        if gold == nil then
            gold = 0
        end
        m_MaterialListData     =  _G.g_GameDataProxy : getMaterialList()   --材料列表
        bag_goods_count = 0
        for k,v in pairs(m_MaterialListData) do
            if(need_goods_id == v.goods_id)then
                bag_goods_count =tonumber( v.goods_num)     --背包魔石数量
                break
            end
        end

        if gold >= need_money and self.thepartnerId ~= nil then

            if self.PopBox ~= nil then
                self.iswindowscheckBoxChecked = self.PopBox.iswindowscheckBoxChecked
            end
            if self.iswindowscheckBoxChecked ~= 1 then
                ------------------------------------------------
                require "view/LuckyLayer/PopBox"
                self.PopBox = CPopBox() --初始化
                local function btnCallBack( )
                    self : setFullScreen(2) --设置全屏可按

                    require "common/protocol/auto/REQ_MAKE_ENCHANT"
                    local msg = REQ_MAKE_ENCHANT()
                    msg :setType(2)    -- 1背包2装备栏
                    msg :setId(self.thepartnerId)      --主将0|武将ID
                    msg :setIdx(index) --物品idx
                    msg :setArg(1)     -- 1:金元附魔 0:普通附魔
                    CNetwork :send(msg)
                end
                print("self.EnchantRmb",EnchantRmb)
                if EnchantRmb  ~= nil and EnchantRmb > 0 then
                    print("3301")
                    StrengthenLayer = self.PopBox :create(btnCallBack,"是否花费"..EnchantRmb.."钻石附魔，\n钻石附魔有大击率出现暴击",1)
                else
                    StrengthenLayer = self.PopBox :create(btnCallBack,"是否花费".."10钻石附魔，\n钻石附魔有大击率出现暴击",1)
                end

                StrengthenLayer : setPosition(-20,0)
                self.Scenelayer : addChild(StrengthenLayer,11) 
                print("生出了那个框框了")
                -------------------------------------------------
            else
                self : setFullScreen(2) --设置全屏可按

                require "common/protocol/auto/REQ_MAKE_ENCHANT"
                local msg = REQ_MAKE_ENCHANT()
                msg :setType(2)    -- 1背包2装备栏
                msg :setId(self.thepartnerId)      --主将0|武将ID
                msg :setIdx(index) --物品idx
                msg :setArg(1)     -- 1:金元附魔 0:普通附魔
                CNetwork :send(msg)
            end
        else
            print("背包金币不足") 
            local msg = "钻石不足，充值可获得钻石！"
            self : createMessageBox(msg)
        end
    end
end

function CEquipEnchantView.enSBtn_CallBacks(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
    return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
      local  equ_id = obj : getTag()      --传递过来的ID
      print("钻石附魔确定按钮",obj : getTag())
      
      self : IngotEnchantAlertDialog(equ_id)
  end
end

function CEquipEnchantView.cancelBtn_CallBacks(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
    return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
      local  equ_id = obj : getTag()      --传递过来的ID
      print("钻石附魔取消按钮",obj : getTag())   
      self : IngotEnchantAlertDialog(equ_id)
  end
end

--更新数据表
function CEquipEnchantView.setReNewData_EqiupList(self,m_ReNewData_MaterialList)
        self.m_ReNewData_EquipmentList =  m_ReNewData_MaterialList
end
function CEquipEnchantView.getReNewData_EqiupList(self)
       return self.m_ReNewData_EquipmentList
end

--更新函数
function CEquipEnchantView.update(self,_EquipmentList)
    self : CleanPearl_comXmlData ()  --清理面板
    print("CEquipEnchantView.update，523==",self.transferId,self.change_equ_index)
    -- if  #_EquipmentList > 0 then 
        self : EquipmentListAnalyzed(_EquipmentList) --装备表解析
    -- end
    local equ_id = nil
    for k,v in pairs(_EquipmentList) do
        print("the update index",v.index)
        if tonumber(v.index)  == tonumber(self.change_equ_index)  then
            equ_id = v.goods_id
        end
    end

    if equ_id ~= nil and equ_id > 0 then
        self : GetEquipXmlData(equ_id)  --装备XML表解析
    end
end

--默认第一个物品
function CEquipEnchantView.DefaultFirstEquip(self,_EquipmentList,_no)
    local no = nil
    local EquipmentList = {}
    if _EquipmentList == nil then
        EquipmentList = self : getPartnerParams(0)--人物身上的装备 0为主将
    else
        self : CleanPearl_comXmlData ()  --清理面板
        EquipmentList = _EquipmentList
    end
    if _no == nil then
        no = 1
    else
        no = tonumber(_no)
    end

    print("4444444rrrrr",self.TheFirstIndex[no],no)
    if EquipmentList ~= nil  then
        for k,v in pairs(EquipmentList) do
            if self.TheFirstIndex[no] ==tonumber(v.index) then
                self.theFirstId    = v.goods_id  --获取第一个装备id
                print("DefaultFirstEquip5566=",v.goods_id,v.index)

                -- local equipNode = _G.Config.goodss :selectNode("goods","id",tostring(v.goods_id)) --装备xml信息
                local equipNode = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(v.goods_id).."]") --装备xml信息
                local type_sub  = tonumber(equipNode : getAttribute("type_sub"))
                local no        = nil 
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
    print("附魔默认第一个装备 510",self.theFirstId)   
    if self.theFirstId ~= nil and tonumber(self.theFirstId)  > 0 then 
        self.transferId = self.theFirstId        --将ID传递到更新函数
        local equ_id    = self.theFirstId

        self:GetEquipXmlData(equ_id)             --装备XML表解析
    else
        self.transferId = nil
        self.m_EnchantBtn      : setTag("")      --传递背包装备的ID  
        self.m_YBEnchantBtn    : setTag("")      --传递背包装备的ID  
    end
    self.theFirstId = nil
end

--mediator注册
function CEquipEnchantView.mediatorRegister(self)
    _G.g_EquipEnchantMediator = EquipEnchantMediator( self )
    controller :registerMediator(  _G.g_EquipEnchantMediator )
end
----[[

function CEquipEnchantView.getTeamersData(self)
    local roleProperty   = _G.g_characterProperty : getMainPlay() --猪脚
    self.m_partnerconut  = roleProperty :getCount()               --猪脚的伙伴数量
    self.m_partnerid     = roleProperty :getPartner()             --伙伴ID列表
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
            _partnerid = tonumber(self.m_partnerid[i-1]) 
            print("------_partnerid",_partnerid,i,"self.m_partnerconut=",self.m_partnerconut)
        end 
        self.m_partneridList[i] = _partnerid
        if _partnerid == 0 then
            local data   = self : getPartnerParams(0)--人物身上的装备 0为主将
            self.m_equiplist[i] = data

            local m_mainProperty             = _G.g_characterProperty :getMainPlay()
            self.m_partnerProNo[i].pro       = m_mainProperty : getPro()   --猪脚职业属性
            self.m_partnerProNo[i].partnerid = _partnerid
        else
            local index = tostring( self.m_uid..tostring( _partnerid))                                    --伙伴id
            self.m_roleProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
            if self.m_roleProperty == nil then
                self.m_equiplist[i]  = nil
                print( "第"..i.."个位置没有对应伙伴")
                return
            else
                self.m_equiplist[i]  = {}
                self.m_equiplist[i]  = self.m_roleProperty :getEquipList()
                print("XXXXXXXXX@@@:",i,self.m_equiplist[i],#self.m_equiplist[i] )

                self.m_partnerProNo[i].pro       = self.m_roleProperty : getPro()   --职业属性
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

--创建人物头像列表
function CEquipEnchantView.addRoleIcon( self,_no,_EquipList,_partnerid)
    print("CGemInlayView.addRoleIcon",_no)  
    local list = _EquipList
    local no   = _no
    --角色头像部分
    local function teamerCallBack(eventType,obj,x,y)
       return self:teamerCallBack(eventType,obj,x,y)
    end  
    if _partnerid ~= nil then
        if  _partnerid == 0 then
            local IconNo = self : getMainPlayerIconNo(0)
            print("职业序号",IconNo)
            local icon_url = "HeadIconResources/role_head_0"..IconNo..".jpg"
            self.TeamerBtnImage[_no] = CButton : create("",icon_url)
            self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
            self.TeamerBtnImage[_no] : setTag(_no)
            self.TeamerBtn[_no]      : addChild( self.TeamerBtnImage[_no],-1 ) 
        else
            print("self.m_partnerProNo[_no].partnerid",_partnerid) 
            local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
            local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]") --伙伴节点
            local icon_url = nil 
            if node : isEmpty() ==false then  
                local node_head = node : getAttribute("head")
                if tonumber(node_head) == 10001 then
                    icon_url = "HeadIconResources/role_head_10402.jpg"
                else
                    icon_url = "HeadIconResources/role_head_"..node_head..".jpg"
                end
            else
                icon_url = "HeadIconResources/role_head_10411.jpg"
            end
            --local icon_url = "HeadIconResources/role_head_0"..no..".jpg"
            self.TeamerBtnImage[_no] = CButton : create("",icon_url)
            self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
            self.TeamerBtnImage[_no] : setTag(_no)
            self.TeamerBtn[_no]      : addChild( self.TeamerBtnImage[_no],-1 ) 
        end

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

function CEquipEnchantView.getMainPlayerIconNo(self,index)
    local mainplay = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    local m_pro    = mainplay :getPro()       --玩家职业
    return m_pro
end

function CEquipEnchantView.teamerCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()
        
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

            if   self.m_equiplist[valueTag] ~= nil  then
                self : CleanPearl_comXmlData ()  --清理面板
                print("按小伙伴按钮切换信息",self.m_partneridList[valueTag])
                self : update(self.m_equiplist[valueTag])          --更新数据以及界面
                self : DefaultFirstEquip(self.m_equiplist[valueTag],valueTag)
                self.thepartnerId = self.m_partneridList[valueTag] --将id传递到强化界面
                self.pushDataId   = self.m_partneridList[valueTag]
                self.TheFirstIndexNo = tonumber(valueTag)
                print("self.pushDataId",self.pushDataId)
            end
        end 
    end
end

function CEquipEnchantView.createCCBI( self, _value,_partnerid)
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
            local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]") --伙伴节点
            if  node : isEmpty() == false then
                pro = node : getAttribute("skin")
            else
                pro = 10404                
            end  
        end

        print("createCCBI pro = ",pro)
        --self.roleCCBI        = CMovieClip:create( "CharacterMovieClip/1000"..pro.."_normal.ccbi" )
        self.roleCCBI        = CMovieClip:create( "CharacterMovieClip/"..pro.."_normal.ccbi" )
        self.roleCCBI         : setControlName( "this CSelectRoleScene roleCCBI 840011")
        self.roleCCBI         : registerControlScriptHandler( animationCallFunc)
        self.roleCCBIContainer: addChild(self.roleCCBI)
    end
end

function CEquipEnchantView.pushData(self)
    print("pushData id ",self.pushDataId,self)
    local partnerId =tonumber(self.pushDataId) 
    local data = {}
    if partnerId ~= nil then
        if partnerId == 0 then
            data  =  self : getPartnerParams(0)--主将的身上装备数据
        else
            local uid = _G.g_LoginInfoProxy:getUid()           --uid
            local index = tostring( uid..tostring( partnerId))                                     --伙伴id
            local m_roleProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
            data  = m_roleProperty : getEquipList()
            print("小伙伴的信息终于来了",data,#data)
        end
        if data ~= nil then
            print("更更新",#data)
            self : update (data)
        end
    end
end
function CEquipEnchantView.NetWorkReturn_MAKE_ENCHANT_OK(self)
    print("附魔播放音效")
    self : playEffectSound() --成功特效

    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.m_EquipInfoBtn   : removeChild(self.THEccbi,false)
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
                    self.m_EquipInfoBtn   : removeChild(self.THEccbi,false)
                    self.THEccbi = nil 
                end
            end
        end
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    --self.THEccbi : setPosition(220,150)
    self.m_EquipInfoBtn  : addChild(self.THEccbi,1000)
end


function CEquipEnchantView.getPartnerParams( self, _partnerid)
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

function CEquipEnchantView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end

function CEquipEnchantView.playEffectSound(self) --成功特效
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
    end
end


