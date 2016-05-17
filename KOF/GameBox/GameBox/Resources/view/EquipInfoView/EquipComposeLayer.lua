

CEquipComposeLayer = class(view,function (self)
                    self.initnum      = 0 
                    self.confirmvalue = 0
                    self.theGemIsMax  = 0 
                           end)

function CEquipComposeLayer.layer(self)
        self.touchID = nil
    local winSize   = CCDirector:sharedDirector():getVisibleSize()
    local _layer    = CContainer :create()
    _layer : setControlName( "this is CEquipComposeLayer _layer 11" )
    self.sencelayer = _layer
    self : init(winSize, _layer)
    print("CEquipComposeLayer.layer",self)
    return _layer
end
CEquipComposeLayer.FONTFAMILY = "Arial"
CEquipComposeLayer.FONTSIZE = 20
CEquipComposeLayer.BagGemBtnTag = 1


function CEquipComposeLayer.loadResources(self)
   --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("EquipmentResources/Equip.plist")
   _G.Config:load("config/pearl_com.xml")
   _G.Config:load("config/goods.xml")
end

function CEquipComposeLayer.layout(self, winSize)  --适配布局
    if winSize.height == 640 then
        --self.m_allBackGround      : setPosition(winSize.width/2,winSize.height/2)              --总底图
        self.m_leftupBackGround   : setPosition(250,358)    --左底图
        self.m_leftdownBackGround : setPosition(250,80)     --左底图
        self.m_rightBackGround    : setPosition(665,290)    --右底图
         
        self.composeArea_layer    : setPosition(105,500)  --合成区域
        self.mixBtnArea_layer     : setPosition(250,60)   --合成按钮区域
        self.gemBagArea_layer     : setPosition(490, 320) --背包区域
        self.m_pScrollView        : setPosition(-15,-290) --活动页0.052
   
        
        elseif winSize.height == 768 then
        --self.m_allBackGround      : setPosition(winSize.width/2,winSize.height/2)              --总底图
        self.m_leftupBackGround   : setPosition(250,358)    --左底图
        self.m_leftdownBackGround : setPosition(250,80)     --左底图
        self.m_rightBackGround    : setPosition(665,290)    --右底图
         
        self.composeArea_layer    : setPosition(105,500)  --合成区域
        self.mixBtnArea_layer     : setPosition(250,60)   --合成按钮区域
        self.gemBagArea_layer     : setPosition(490, 320) --背包区域
        self.m_pScrollView        : setPosition(-15,-180) --活动页0.052
    end
end

function CEquipComposeLayer.init(self, winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(winSize,_layer)              --界面初始化
    self : layout(winSize)                       --适配布局初始化
    self : initParameter()                       --参数初始化
    self : DefaultFirstGem()                     --默认第一个物品
end

function CEquipComposeLayer.initView(self,winSize,_layer)
    
    --self.m_allBackGround      = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --总底图
    self.m_leftupBackGround   = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左上底图
    self.m_leftdownBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左下底图
    self.m_rightBackGround    = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图
    
    --self.m_allBackGround      : setPreferredSize(CCSizeMake(winSize.width*0.93,winSize.height*0.82))  --530 890
    -- self.m_leftupBackGround   : setPreferredSize(CCSizeMake(winSize.width/2*0.87,winSize.height/2*0.8125))  --420 260
    -- self.m_leftdownBackGround : setPreferredSize(CCSizeMake(winSize.width/2*0.87,winSize.height/2*0.66)) --420 210

    self.m_leftupBackGround   : setPreferredSize(CCSizeMake(410,410)) --420 260
    self.m_leftdownBackGround : setPreferredSize(CCSizeMake(410,130)) --420 260
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(410,550)) --400 500
    
    --_layer : addChild(self.m_allBackGround,-1)
    _layer : addChild(self.m_leftupBackGround)
    _layer : addChild(self.m_leftdownBackGround)
    _layer : addChild(self.m_rightBackGround)
    
    --合成区域--------
    self.composeArea_layer = CContainer :create()
    self.composeArea_layer : setControlName( "this is CEquipComposeLayer self.composeArea_layer 75" )
    _layer                 : addChild(self.composeArea_layer,2)
    
    local function GemButtonCallBack(eventType,obj,x,y)
        return self:GemBtnCallBack(eventType,obj,x,y)
    end
    
    local function ReelButtonCallBack(eventType,obj,x,y)
        return self:ReelBtnCallBack(eventType,obj,x,y)
    end
    local function composeGemButtonCallBack(eventType,obj,x,y)
        return self:composeGemBtnCallBack(eventType,obj,x,y)
    end
    
    --宝石
    self.m_GemBtn          = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
    self.m_GemBtn          : setControlName( "this CEquipComposeLayer self.m_GemBtn 91 ")
    self.m_GemBtn          : registerControlScriptHandler(GemButtonCallBack, "this CEquipComposeLayer self.m_GemBtn 92")
    --self.m_GemLv_Label     = CCLabelTTF :create("LV ".."99","Arial",20)
    self.m_GemCount_Label  = CCLabelTTF :create("99","Arial",18)
    self.m_GemName_Label   = CCLabelTTF :create("黄宝石".."LV99","Arial",18)
    local m_GempropSen     = "物理攻击".."999"
    self.m_Gemprop_Label   = CCLabelTTF :create(m_GempropSen,"Arial",18)

    --self.m_GemLv_Label       : setAnchorPoint( ccp(0,0.5) )
    self.m_GemName_Label     : setAnchorPoint( ccp(0,0.5) )
    self.m_Gemprop_Label     : setAnchorPoint( ccp(0,0.5) )   

    self.m_GemBtn            : setPosition(0+20,0)
    self.m_GemCount_Label    : setPosition(20,-30)
    --self.m_GemLv_Label       : setPosition(175,20)
    self.m_GemName_Label     : setPosition(70,20)
    self.m_Gemprop_Label     : setPosition(70,-20)
    
    self.composeArea_layer : addChild(self.m_GemBtn)
    --self.m_GemBtn          : addChild(self.m_GemLv_Label,2)
    self.m_GemBtn          : addChild(self.m_GemCount_Label,2)
    self.m_GemBtn          : addChild(self.m_GemName_Label)
    self.m_GemBtn          : addChild(self.m_Gemprop_Label)

    --宝石框的底图
    local m_GemBtnBackSprite = CSprite : createWithSpriteFrameName("equip_underframe02.png")
    self.m_GemBtn            : addChild(m_GemBtnBackSprite,-20)
    
    --卷轴
    self.m_ReelBtn         = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
    self.m_ReelBtn : setControlName( "this CEquipComposeLayer self.m_ReelBtn 113 ")
    self.m_ReelBtn         : registerControlScriptHandler(ReelButtonCallBack, "this CEquipComposeLayer self.m_ReelBtn 114")
    self.m_ReelName_Label  = CCLabelTTF :create("","Arial",18)
    self.m_ReelCount_Label = CCLabelTTF :create("99","Arial",18)
    
    self.m_ReelBtn         : setPosition(290-20,0)
    self.m_ReelName_Label  : setPosition(0,-60)
    self.m_ReelCount_Label : setPosition(30-10,-30)
    
    self.composeArea_layer : addChild(self.m_ReelBtn)
    self.m_ReelBtn         : addChild(self.m_ReelName_Label,2)
    self.m_ReelBtn         : addChild(self.m_ReelCount_Label,2)

    --卷轴框的底图
    local m_ReelBtnBackSprite = CSprite : createWithSpriteFrameName("equip_underframe03.png")
    self.m_ReelBtn            : addChild(m_ReelBtnBackSprite,-20)

    --箭头
    self.m_arrow_leftSprite  = CSprite : createWithSpriteFrameName("compos_arrow_left.png")
    self.m_arrow_rightSprite = CSprite : createWithSpriteFrameName("compos_arrow_right.png")

    self.m_arrow_leftSprite     : setPosition(55,-90-10)
    self.m_arrow_rightSprite    : setPosition(235,-90-10)

    self.composeArea_layer : addChild(self.m_arrow_leftSprite)
    self.composeArea_layer : addChild(self.m_arrow_rightSprite)
    
    --合成宝石
    self.m_composeGemBtn          = CButton :createWithSpriteFrameName("","general_equip_frame.png")
    self.m_composeGemBtn          : setControlName( "this CEquipComposeLayer self.m_composeGemBtn 128 ")
    self.m_composeGemBtn          : registerControlScriptHandler(composeGemButtonCallBack, "this CEquipComposeLayer self.m_composeGemBtn 129")
    --self.m_composeGemLv_Label     = CCLabelTTF :create("LV ".."99","Arial",20)
    self.m_composeGemCount_Label  = CCLabelTTF :create("99","Arial",18)
    self.m_composeGemName_Label   = CCLabelTTF :create("青绿宝石".."LV99","Arial",18)
    local m_composeGempropSen     = "物理攻击".."999"
    self.m_composeGemprop_Label   = CCLabelTTF :create(m_GempropSen,"Arial",18)

    --self.m_composeGemLv_Label     : setAnchorPoint( ccp(0,0.5) )
    self.m_composeGemName_Label   : setAnchorPoint( ccp(0,0.5) )
    self.m_composeGemprop_Label   : setAnchorPoint( ccp(0,0.5) )   
    
    self.m_composeGemBtn          : setPosition(145,-180-10)
    self.m_composeGemCount_Label  : setPosition(30,-30)
    --self.m_composeGemLv_Label     : setPosition(40,-80)
    self.m_composeGemName_Label   : setPosition(-70+30,-80)
    self.m_composeGemprop_Label   : setPosition(-70+30,-120)
    
    self.composeArea_layer : addChild(self.m_composeGemBtn)
    --self.m_composeGemBtn          : addChild(self.m_composeGemLv_Label,2)
    self.m_composeGemBtn          : addChild(self.m_composeGemCount_Label,2)
    self.m_composeGemBtn          : addChild(self.m_composeGemName_Label)
    self.m_composeGemBtn          : addChild(self.m_composeGemprop_Label)

    --卷轴框的底图
    local m_composeGemBtnBackSprite = CSprite : createWithSpriteFrameName("equip_underframe01.png")
    self.m_composeGemBtn            : addChild(m_composeGemBtnBackSprite,-20)
    
    --合成按钮区域-------
    self.mixBtnArea_layer = CContainer :create()
    self.mixBtnArea_layer : setControlName( "this is CEquipComposeLayer self.mixBtnArea_layer 147" )
    _layer                : addChild(self.mixBtnArea_layer,2)

    local function MixButtonCallBack(eventType,obj,x,y)
        return self:MixBtnCallBack(eventType,obj,x,y)
    end

    local function checkBoxCallBack(eventType,obj,x,y)
        return self:checkBoxCallBack(eventType,obj,x,y)
    end

    --自动购买卷轴勾选框
    self.checkBox = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "自动购买宝石卷轴")
    self.checkBox : setColor( ccc4(255,255,255,255) )
    self.checkBox : setPosition(-110,50)
    self.checkBox : setFontSize( 18 )
    self.checkBox : registerControlScriptHandler(checkBoxCallBack,"this CEquipComposeLayer checkBox 115")
    self.checkBox : setTouchesEnabled(true)
    --self.checkBox : setVisible(false)
    self.checkBox : setTouchesPriority(-200)

    --local m_explainSen    = "" --键合成：需要VIP6的玩家才可以使用
    --local m_explainLabel  = CCLabelTTF :create(m_explainSen,"Arial",18)
    self.m_MixBtn         = CButton :createWithSpriteFrameName("合成","general_button_normal.png")
    self.m_MixBtn         : setTouchesEnabled(false)
    self.m_MixBtn         : setControlName( "this CEquipComposeLayer self.m_MixBtn 160 ")
    self.m_MixBtn         : registerControlScriptHandler(MixButtonCallBack, "this CEquipComposeLayer self.m_MixBtn 161")

    self.m_MixBtn         : setFontSize(24)
    self.m_MixBtn         : setPosition(0,0)
    --m_explainLabel        : setPosition(80,80)
    
    --self.mixBtnArea_layer : addChild(m_explainLabel)
    self.mixBtnArea_layer : addChild(self.checkBox)
    self.mixBtnArea_layer : addChild(self.m_MixBtn)


    
    --宝石背包区域-------
    self.gemBagArea_layer = CContainer :create()
    self.gemBagArea_layer : setControlName( "this is CEquipComposeLayer self.gemBagArea_layer 168" )
    _layer                : addChild(self.gemBagArea_layer,2)
    
    self.general_pagesSprite          = {}
    self.general_pages_pressingSprite = {}

    for i=1,4 do
        self.general_pagesSprite[i] = CSprite : createWithSpriteFrameName("general_pages_normal.png")
        self.general_pagesSprite[i] : setPosition(80+(i-1)*60,210)
        self.gemBagArea_layer : addChild(self.general_pagesSprite[i],10)

    end

    self.general_pages_pressingSprite[1] = CSprite :createWithSpriteFrameName("general_pages_pressing.png")
    self.general_pagesSprite[1]          : addChild(self.general_pages_pressingSprite[1])
    self.thepagingNo = 1 
    -- local function BagGemButtonCallBack(eventType,obj,x,y)
    --     return self:BagGemBtnCallBack(eventType,obj,x,y)
    -- end
    local function BagGemButtonCallBack(eventType, obj, touches)
        return self:BagGemBtnCallBack(eventType, obj, touches)
    end 
    local function ScrollViewCallBack(eventType, obj, x, y)
        print("----->",eventType,obj)
        return self : ScrollViewCallBack(eventType,obj,x,y)
    end  
    --活动页
    local m_ViewSize      = CCSizeMake(385,500)
    self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    self.m_pScrollView    : registerControlScriptHandler(ScrollViewCallBack,"this is CEquipComposeLayer ScrollViewCallBack 295")
    self.m_pScrollView    : setTouchesPriority(1)
    self.gemBagArea_layer : addChild(self.m_pScrollView)
    
    self.m_BagGemBtn         = {} --背包宝石物品按钮
    self.m_BagEquipBtnSprite = {} --背包装备物品按钮图
    self.m_iconCountLabel    = {}
    for i=1,4 do
        local pageContiner = CContainer : create()
        pageContiner : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        local iconLayout   = CHorizontalLayout : create()
        iconLayout   : setLineNodeSum(4)
        iconLayout   : setCellSize(CCSizeMake(96,96))
        iconLayout   : setVerticalDirection(false)
        iconLayout   : setPosition(-190,180)
        pageContiner : addChild(iconLayout)
        self.m_pScrollView : addPage(pageContiner)
        for k=1,20 do
            num = (i-1)*20+k
            self.m_BagGemBtn[num]   = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
            self.m_BagGemBtn[num] : setControlName( "this CEquipComposeLayer self.m_BagGemBtn[num] 198 "..tostring(num))
            --self.m_BagGemBtn[num] : setTouchesPriority(-1)
            --self.m_BagGemBtn[num] : setTouchesEnabled(true)
            self.m_BagGemBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
            self.m_BagGemBtn[num] : setTouchesEnabled( true)
            self.m_BagGemBtn[num] : registerControlScriptHandler(BagGemButtonCallBack, "this CEquipComposeLayer self.m_BagGemBtn[num] 201")
            iconLayout :  addChild(self.m_BagGemBtn[num])

            self.m_iconCountLabel[num] = CCLabelTTF :create("","Arial",18)          
            self.m_iconCountLabel[num] : setPosition(25,-25)
            self.m_BagGemBtn[num]      : addChild(self.m_iconCountLabel[num],2)
        end
    end
    self.m_pScrollView : setPage(0, false)--设置起始页[0,1,2,3...]
    
end

function CEquipComposeLayer.ScrollViewCallBack(self,eventType,obj,x,y)
    print("eventTypeeventType=",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        local currentPage = x
    
        print("CShopLayer.ScrollViewCallBack---->>>",currentPage)
        -- if currentPage ~= self.m_currentPage then
            --self.m_currentPage = pageCount-currentPage
            if self.thepagingNo ~= nil and self.thepagingNo > 0 then
                self.general_pages_pressingSprite[self.thepagingNo] : removeFromParentAndCleanup(true)
            end

            local i  = currentPage + 1
            self.general_pages_pressingSprite[i] = CSprite :createWithSpriteFrameName("general_pages_pressing.png")
            self.general_pagesSprite[i] : addChild(self.general_pages_pressingSprite[i])
            self.thepagingNo = i 
            --self.m_pageLabel :setString( self.m_currentPage.."/"..pageCount)
        -- end
    end
end

function CEquipComposeLayer.initParameter(self)
    self : GemListAnalyzed() --宝石表解析
    --mediator注册
    --require "mediator/mediator"
    --require "mediator/EquipComposeMediator"
    --_G.g_EquipComposeMediator = EquipComposeMediator(self)
    --controller :registerMediator(  _G.g_EquipComposeMediator )
    self.is_auto      = 0
    self.isCheckToBuy = 0  
    --self : ShopNetWorkSend(10,1010)   --netwrok面板协议发送(初始化)
end

function CEquipComposeLayer.GemListAnalyzed(self)  --宝石表解析
    require "view/EquipInfoView/EquipXmlAnalyzed"
    require "proxy/GoodsProperty"

    self : cleanBagGem()
     --local  m_ReNewData_MaterialList  = self : getReNewData_MaterialList()
     local  m_ReNewData_GemList       = self : getReNewData_GemList()

     -- if m_ReNewData_MaterialList ~= nil then
     --    print("拿的是更新后的材料表")
     --    self.MaterialList = m_ReNewData_MaterialList
     --    local aaa= 0
     --    for k,v in pairs(m_ReNewData_MaterialList) do
     --        if tonumber(v.goods_id) == 33876 then
     --            aaa = aaa + v.goods_num
     --            print("00001")
     --        end
     --    end
     --    print("自己去拿那个耳机卷走的数量===",aaa)
     -- else 
    self.MaterialList =  _G.g_GameDataProxy : getMaterialList()
    -- end

    if m_ReNewData_GemList ~= nil then
        print("拿的是更新后的宝石表")
        self.GemstoneList = m_ReNewData_GemList
     else 
        self.GemstoneList =  _G.g_GameDataProxy : getGemstoneList()
     end

    -- local function BagGemButtonCallBack(eventType,obj,x,y)
    --     return self:BagGemBtnCallBack(eventType,obj,x,y)
    -- end
    self.GemListData       = {}
    self.MaterialListData  = {}
    self.BagGemBtnSprites  = {}
    -- self.m_iconCountLabel  = {}
    self.gemCount          = nil
    --宝石
    if self.GemstoneList ~= nil then
        for i,gem in ipairs(self.GemstoneList) do
            self.gemCount = i
            self.GemListData[gem.goods_id] = {}
            self.GemListData[gem.goods_id]["goods_id"  ] = gem.goods_id   --装备id
            self.GemListData[gem.goods_id]["index"     ] = gem.index      --装备索引位置idx
            local allgoods_num = 0 
            for k,v in pairs(self.GemstoneList) do
                if tonumber(gem.goods_id) == tonumber(v.goods_id) then
                    allgoods_num = allgoods_num + v.goods_num
                end
            end
            self.GemListData[gem.goods_id]["goods_num" ] = allgoods_num  --装备叠加数量

            self.GemListData[gem.goods_id]["goods_type"] = gem.goods_type --装备大类
            self.GemListData[gem.goods_id]["price"     ] = gem.price      --装备价格
            print("宝石==",gem,gem.goods_id,gem.goods_num,self.GemListData[gem.goods_id])
            self.m_BagGemBtn[i] : setTag(tonumber(gem.goods_id))      --传递背包宝石的ID
            
            if  self.BagGemBtnSprites[i] ~= nil then
                self.BagGemBtnSprites[i] : removeFromParentAndCleanup(true)
                self.BagGemBtnSprites[i] = nil
            end
            -- local gemNode = _G.Config.goodss:selectNode("goods","id",tostring(gem.goods_id))
            local gemNode      = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(gem.goods_id).."]")
            local gemNode_icon =  gemNode : getAttribute("icon") 
            local ion_url         = "Icon/i"..gemNode_icon..".jpg"
            _G.g_unLoadIconSources   : addIconData( gemNode_icon )
            self.BagGemBtnSprites[i] = CCSprite :create(ion_url)
            self.m_BagGemBtn[i] : addChild(self.BagGemBtnSprites[i],-1)

            -- if self.m_iconCountLabel[i] ~= nil then
            --     self.m_iconCountLabel[i] :removeFromParentAndCleanup (true)
            --     self.m_iconCountLabel[i] = nil                
            -- end          
            -- self.m_iconCountLabel[i] = CCLabelTTF :create("","Arial",18)          
            self.m_iconCountLabel[i] : setString(gem.goods_num)
            -- self.m_iconCountLabel[i] : setPosition(25,-25)
            -- self.m_BagGemBtn[i]      : addChild(self.m_iconCountLabel[i],2)
            --self.m_BagGemBtn[i] : registerControlScriptHandler(BagGemButtonCallBack)
        end

    end
    --卷轴
    if self.MaterialList ~= nil then
        for k,material in ipairs(self.MaterialList) do
            self.materialCount = k
            self.MaterialListData[material.goods_id] = {}
            self.MaterialListData[material.goods_id]["goods_id"  ] = material.goods_id   --卷轴id
            self.MaterialListData[material.goods_id]["index"     ] = material.index      --卷轴索引位置idx
            self.MaterialListData[material.goods_id]["goods_num" ] = material.goods_num  --卷轴叠加数量
            self.MaterialListData[material.goods_id]["goods_type"] = material.goods_type --卷轴大类
            self.MaterialListData[material.goods_id]["price"     ] = material.price      --卷轴价格
            print("卷轴==",material,material.goods_id,material.goods_num )
        end
    end
end

function  CEquipComposeLayer.cleanBagGem(self)
    for num=1,80 do
        self.m_BagGemBtn[num] : setTag("")  

        if self.BagGemBtnSprites ~= nil and  self.BagGemBtnSprites[num] ~= nil then
            self.BagGemBtnSprites[num] : removeFromParentAndCleanup(true)
            self.BagGemBtnSprites[num] = nil
        end
        if self.m_iconCountLabel ~= nil and self.m_iconCountLabel[num] ~= nil then
            self.m_iconCountLabel[num] : setString("")
        end
    end

end

-- function CEquipComposeLayer.BagGemBtnCallBack(self,eventType,obj,x,y)  --背包宝石回调
--     print("eventType",eventType)
--     if eventType == "TouchBegan" then
--         return obj:containsPoint( obj:convertToNodeSpaceAR( ccp(x,y) ) )
--     elseif eventType == "TouchEnded" then
--         self : CleanPearl_comXmlData ()
--         print("宝石按钮回调")
--         local  id = obj : getTag()  --传递过来的ID
--         if id ~= nil and id > 0 then 
--             self.confirmvalue =  1      --通过这个参数判断是否弹出加减框
--             local ion_url         = "Icon/i"..id..".jpg"
--             self.BagGemBtnSprite  = nil
--             self.BagGemBtnSprite  = CCSprite :create(ion_url)
--             self.m_GemBtn         : addChild(self.BagGemBtnSprite,1)
--             self.m_GemBtn         : setTag(tonumber(id)) --传递背包宝石的ID
--             self.m_MixBtn         : setTag(tonumber(id)) --传递背包宝石的ID
--             print("id====",id)
--             self : GetPearl_comXmlData(id) --宝石相关宝石卷轴下一级合成解析
--         else
--             self.confirmvalue =  0      --通过这个参数判断是否弹出加减框
--         end
--     end
-- end

function CEquipComposeLayer.GetPearl_comXmlData(self,_gemId) --宝石相关宝石卷轴下一级合成解析
    print("GetPearl_comXmlData-id=",_gemId )
    ------------------------------------------------------------------------------------------------------------------------------------------
    --local pearl_comsNode = _G.Config.pearl_coms : selectNode( "pearl_com", "pear_id" , tostring(_gemId) )  --宝石合成信息节点
    local pearl_comsNode           =  _G.Config.pearl_coms : selectSingleNode("pearl_com[@pear_id="..tostring(_gemId).."]")  --宝石合成信息节点
    local pearl_comsNode_child     = pearl_comsNode : children()
    local pearl_comsNode_nextchild = pearl_comsNode_child : get(0,"items") 



    if _gemId~= nil and pearl_comsNode : isEmpty() == false then
        --local pearl_comsNode = _G.Config.pearl_coms : selectNode( "pearl_com", "mat_one" , tostring(_gemId) )  --宝石合成信息节点
        local bagGemNum        = 0
        if self.GemListData ~= nil and self.GemListData[_gemId] ~= nil then
            bagGemNum              = tonumber(self.GemListData[_gemId]["goods_num" ])                               --背包宝石数量
        end
        local pear_GemCount    = 0                                                                              --所需宝石数量
        local pear_ReelCount   = 0                                                                              --所需宝石卷轴数量
        local ReelNodeId       = nil 

        local pearl_comsNode_pear_id = pearl_comsNode : getAttribute("pear_id")
        local GemNode          = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(pearl_comsNode_pear_id).."]")     --宝石节点
        local GemColor         = tonumber(GemNode : getAttribute("name_color")) 
        --self.m_GemLv_Label     : setString("LV"..GemNode.d[1].as1)


        -- if pearl_comsNode.items[1].item ~= nil then
        --     local pear_id = tonumber(pearl_comsNode_pear_id)
        --     local data    = pearl_comsNode.items[1].item
        --     for k,v in pairs(data) do
        --         if tonumber(v.id) == pear_id then
        --             pear_GemCount = tonumber(v.count ) 
        --         end
        --         if tonumber(v.id) ~= pear_id then 
        --             ReelNodeId     = v.id    --找到所需合成卷轴id
        --             pear_ReelCount = tonumber (v.count) --找到所需合成卷轴数量

        --             self.transToCheckBoxReelNodeId = v.id 
        --         end 
        --     end
        -- end

        if pearl_comsNode_nextchild : isEmpty() == false then
            local pear_id    = tonumber(pearl_comsNode_pear_id)
            local data       = pearl_comsNode_nextchild : children()
            local data_count = data : getCount("item")

            for i= 0 , data_count-1 do 
                local id    = data  : get(i,"item") : getAttribute("id")
                local count = data  : get(i,"item") : getAttribute("count")

                if tonumber( id ) == pear_id then
                    pear_GemCount = tonumber(count ) 
                end
                if  tonumber(id ) ~= pear_id then
                    ReelNodeId     = id               --找到所需合成卷轴id
                    pear_ReelCount = tonumber (count) --找到所需合成卷轴数量

                    self.transToCheckBoxReelNodeId = id 
                end 
            end
        end



        self.m_GemCount_Label  : setString(bagGemNum.."/"..pear_GemCount)
        self.transToCheckBoxBuy = pear_GemCount --传递到购买成功哪里
        self.m_GemName_Label   : setString(GemNode : getAttribute("name"))
        self.m_Gemprop_Label   : setString(GemNode : getAttribute("remark"))

        ---设置宝石名称颜色
        if GemColor ~= nil and GemColor > 0 then
            if(GemColor == 1)then
                self.m_GemName_Label : setColor(ccc3(255,255,255))
            elseif(GemColor == 2)then
                self.m_GemName_Label : setColor(ccc3(91,200,19))
            elseif(GemColor == 3)then
                self.m_GemName_Label : setColor(ccc3(0,155,255))
            elseif(GemColor == 4)then
                self.m_GemName_Label : setColor(ccc3(155,0,188))
            elseif(GemColor == 5)then
                self.m_GemName_Label : setColor(ccc3(255,255,0))
            elseif(GemColor == 6)then
                self.m_GemName_Label : setColor(ccc3(255,155,0))
            elseif(GemColor == 7)then
                self.m_GemName_Label : setColor(ccc3(255,0,0))
            else
                print("无")
            end
        end
        ------------------------------------------------------------------------------------------------------------------------------------------
        --local ReelNode = _G.Config.goodss:selectNode("goods","id",tostring(ReelNodeId))       --卷轴节点
        local ReelNode = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(ReelNodeId).."]")

        self.m_ReelName_Label    : setString(ReelNode: getAttribute("name"))
        if self.MaterialListData[tonumber(ReelNodeId)] ~= nil then
             self.bagMaterialNum   = tonumber(self.MaterialListData[tonumber(ReelNodeId)]["goods_num" ]) --背包卷轴数量
        else 
            self.bagMaterialNum  = 0  --背包卷轴数量
        end
        self.m_ReelCount_Label : setString(self.bagMaterialNum.."/"..pear_ReelCount)

        if  bagGemNum >= pear_GemCount and self.bagMaterialNum < pear_ReelCount then
            --self.checkBox : setVisible( true )
            self.checkBox : setTouchesEnabled(true)
        else
            --self.checkBox : setVisible( false )
            self.checkBox : setTouchesEnabled(false)
        end

        if  bagGemNum >= pear_GemCount and self.bagMaterialNum >= pear_ReelCount then
            self.m_MixBtn : setTouchesEnabled(true )
        else
            self.m_MixBtn : setTouchesEnabled( false )
        end

        
        -- local composeGemNode         = _G.Config.goodss:selectNode("goods","id",tostring(pearl_comsNode.id))      --合成宝石节点
        local composeGemNode         = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(pearl_comsNode : getAttribute("id")).."]")     --合成宝石节点
        self.Trans_composeGemNode    = composeGemNode
        local composeGemColor        = tonumber(composeGemNode : getAttribute("name_color")) 
        --self.m_composeGemLv_Label    : setString("LV"..composeGemNode.d[1].as1)
        self.m_composeGemName_Label  : setString(composeGemNode : getAttribute("name"))
        self.m_composeGemprop_Label  : setString(composeGemNode : getAttribute("remark"))

        ---设置宝石名称颜色
        if composeGemColor ~= nil and composeGemColor > 0 then
            if(composeGemColor == 1)then
                self.m_composeGemName_Label : setColor(ccc3(255,255,255))
            elseif(composeGemColor == 2)then
                self.m_composeGemName_Label : setColor(ccc3(91,200,19))
            elseif(composeGemColor == 3)then
                self.m_composeGemName_Label : setColor(ccc3(0,155,255))
            elseif(composeGemColor == 4)then
                self.m_composeGemName_Label : setColor(ccc3(155,0,188))
            elseif(composeGemColor == 5)then
                self.m_composeGemName_Label : setColor(ccc3(255,255,0))
            elseif(composeGemColor == 6)then
                self.m_composeGemName_Label : setColor(ccc3(255,155,0))
            elseif(composeGemColor == 7)then
                self.m_composeGemName_Label : setColor(ccc3(255,0,0))
            else
                print("无")
            end
        end

        --可合成的最大宝石个数
        local maxnum = math.floor(bagGemNum/pear_GemCount)
        print("maxcooposenum=,",maxnum,"self.bagMaterialNum",self.bagMaterialNum)
        if maxnum > self.bagMaterialNum then
            self.m_composeGemCount_Label : setString(self.bagMaterialNum)
            self.initnum       = self.bagMaterialNum
            self.maxcooposenum = self.bagMaterialNum
        else
            self.m_composeGemCount_Label : setString(maxnum)
            self.initnum       = maxnum
            self.maxcooposenum = maxnum
        end

        self.GemListData[tonumber(pearl_comsNode: getAttribute("pear_id"))]["Materialid"]     = ReelNodeId     --合成一个所需卷轴id
        self.GemListData[tonumber(pearl_comsNode: getAttribute("pear_id"))]["count_one"]      = pear_GemCount  --合成一个所需宝石数量
        self.GemListData[tonumber(pearl_comsNode: getAttribute("pear_id"))]["count_two"]      = pear_ReelCount --合成一个所需卷轴数量

        local Gemicon_url           = "Icon/i"..GemNode: getAttribute("icon")..".jpg"
        local Reelicon_url          = "Icon/i"..ReelNode: getAttribute("icon")..".jpg"
        local composeGemicon_url    = "Icon/i"..composeGemNode: getAttribute("icon")..".jpg"

        _G.g_unLoadIconSources : addIconData( GemNode: getAttribute("icon") )
        _G.g_unLoadIconSources : addIconData( ReelNode: getAttribute("icon") )
        _G.g_unLoadIconSources : addIconData( composeGemNode: getAttribute("icon") )

         self.m_GemBtnSprite        = nil
         self.m_ReelBtnSprite       = nil
         self.m_composeGemBtnSprite = nil       

        self.m_GemBtnSprite              = CCSprite :create(Gemicon_url)
        self.m_ReelBtnSprite             = CCSprite :create(Reelicon_url)
        self.m_composeGemBtnSprite       = CCSprite :create(composeGemicon_url)

        if self.m_ReelBtnSprite == nil then
            CCLOG("找不到卷轴图片")
            --self.m_ReelBtnSprite       = CCSprite :create("Icon/i60001.png")
        end

        self.m_GemBtn                : addChild(self.m_GemBtnSprite,-1)
        self.m_ReelBtn               : addChild(self.m_ReelBtnSprite,-1)
        self.m_composeGemBtn         : addChild(self.m_composeGemBtnSprite,-1)

        self.theGemIsMax = 0 
    else
        self.theGemIsMax = 1 
        print("此宝石已为最高等级,不能合成")
    end
end

function CEquipComposeLayer.CleanPearl_comXmlData(self) --合成区域数据清理

        --self.m_GemLv_Label     : setString("")
        self.m_GemCount_Label  : setString("")
        self.m_GemName_Label   : setString("")
        self.m_Gemprop_Label   : setString("")
        self.m_ReelName_Label  : setString("")
        self.m_ReelCount_Label : setString("")
        
        --self.m_composeGemLv_Label    : setString("")
        self.m_composeGemCount_Label : setString("")
        self.m_composeGemName_Label  : setString("")
        self.m_composeGemprop_Label  : setString("")
  
        if self.BagGemBtnSprite ~= nil then
            self.BagGemBtnSprite               : removeFromParentAndCleanup(true)
            self.BagGemBtnSprite = nil
        end
        if  self.m_GemBtnSprite ~= nil then
            self.m_GemBtnSprite                : removeFromParentAndCleanup(true)
            self.m_GemBtnSprite = nil
        end
        if  self.m_ReelBtnSprite ~= nil then
            self.m_ReelBtnSprite              : removeFromParentAndCleanup(true)
            self.m_ReelBtnSprite = nil 
        end
        if self.m_composeGemBtnSprite ~= nil then
           self.m_composeGemBtnSprite          : removeFromParentAndCleanup(true)
           self.m_composeGemBtnSprite =nil
        end
end

--合成区域宝石回调
function CEquipComposeLayer.GemBtnCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    print("合成区域宝石暂无回调")
    end
end

--合成区域卷轴回调
function CEquipComposeLayer.ReelBtnCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    print("合成区域卷轴暂无回调")
    end
end

--checkbox回调
function CEquipComposeLayer.checkBoxCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    print("checkbox回调")
    if self.is_auto == 0 then
        print("勾选了",self.is_auto)
       self.is_auto = 1
       self.checkBox : setChecked (true)

        -- if self.transToCheckBoxReelNodeId  ~= nil  then
        --     local ReelNodeId  = self.transToCheckBoxReelNodeId
        --     local Price,index = self : getCheckBoxPriceById(ReelNodeId)
        --     if index ~= nil then
        --         self : BuyNetWorkSend(index,ReelNodeId)
        --     end
        -- end

        if self.transToCheckBoxReelNodeId  ~= nil  then
            local ReelNodeId = self.transToCheckBoxReelNodeId
            --local data       = self.MaterialListData[tonumber(ReelNodeId)]["goods_num" ]--背包卷轴数量 
            local ReelNode   = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(ReelNodeId).."]") --卷轴节点
            local Price      = self : getCheckBoxPriceById(ReelNodeId)
            local msg = "花费"..Price.."钻石购买"..ReelNode : getAttribute("name")
            self.checkBox         : setText(msg)      

            self.m_MixBtn : setTouchesEnabled(true)
            self.isCheckToBuy = 1         
        end
        -- self.m_MixBtn : setTouchesEnabled(true)
        -- self.isCheckToBuy = 1
    elseif self.is_auto == 1 then
        print("取消勾选",self.is_auto)
       self.is_auto = 0
       self.checkBox : setChecked (false)

        local msg = "自动购买宝石卷轴"
        self.checkBox         : setText(msg) 
        self.isCheckToBuy = 0   
        self.m_MixBtn : setTouchesEnabled(false)          
    end
    end
end

function CEquipComposeLayer.ShopNetWorkSend(self,_type,_type_bb)
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_SHOP_REQUEST"
    local msg = REQ_SHOP_REQUEST()
    msg :setArguments(_type) --商店类型
    msg :setTypeBb(_type_bb) --商店子类型    
    CNetwork : send(msg)
    print("CEquipComposeLayer ShopNetWorkSend 页面发送数据请求,完毕 204")
end
--商城购买发送请求
function CEquipComposeLayer.BuyNetWorkSend(self,_idx,_goodsId)
    print("---CEquipComposeLayer 购买发送请求--->",_idx,_goodsId)
    require "common/protocol/auto/REQ_SHOP_BUY"
    local msg = REQ_SHOP_BUY()
    msg :setType    (10)       --商店类型
    msg :setTypeBb  (1010)     --商店子类型 
    msg :setIdx     (_idx)     --物品数据索引
    msg :setGoodsId (_goodsId) --物品id 
    msg :setCount   (1)        --购买数量
    msg :setCtype   (2)        --货币类型
    CNetwork : send(msg)
    print("CEquipComposeLayer BuyNetWorkSend 页面发送数据请求,完毕 203")
end
function CEquipComposeLayer.NetWorkReturn_SHOP_REQUEST_OK(self,_vo_data,_Count,_TypeBb,_Type) --商店数据返回
    self.transFromShop_TypeBb = _TypeBb
    self.transFromShop_Type   = _Type
    self.transFromShop_Data   = _vo_data
    self.transFromShop_Count  = tonumber(_Count) 
    print("卷轴商铺数据接受完毕++")
end
function CEquipComposeLayer.getCheckBoxPriceById(self,_id ) --拿卷轴的价格
    local price = 0 
    local index = nil 
    -- if self.transFromShop_Data ~= nil then
    --     local data = self.transFromShop_Data
    --     for k,v in pairs(data) do
    --         if tonumber(_id) == tonumber(v.goods_id) then
    --             price = v.s_price
    --             index = v.idx
    --         end
    --     end
    -- end
    -- local node = _G.Config.pearl_coms : selectNode( "pearl_com", "scroll_id" , tostring(_id) )  --宝石合成信息节点
    local node            = _G.Config.pearl_coms : selectSingleNode("pearl_com[@scroll_id="..tostring(_id).."]") --宝石合成信息节点
    node_child            = node : children () 
    node_child_items      = node_child : get(0,"items")
    node_child_items_item = node_child_items : children()
    node_child_itemsCount = node_child_items_item : getCount("item")


    if node : isEmpty() == false then
        for i = 0 ,node_child_itemsCount -1 do 
            if tonumber(_id) == tonumber(node_child_items_item : get(i,"item") : getAttribute("id")) then
                price = tonumber(node_child_items_item : get(i,"item") : getAttribute("rep"))
                break                
            end
        end
    end
    return price 
end
function CEquipComposeLayer.NetWorkReturn_SHOP_BUY_SUCC(self ) --购买成功
    print("卷轴购买成功了")
    -- if self.transToCheckBoxReelNodeId  ~= nil  then
    --     local ReelNodeId  = self.transToCheckBoxReelNodeId
    --     local ReelNode    = _G.Config.goodss:selectNode("goods","id",tostring(ReelNodeId)) --卷轴节点
    --     local Price,index = self : getCheckBoxPriceById(ReelNodeId)
    --     local msg = "花费"..Price.."钻石购买"..ReelNode.name
    --     self : createMessageBox(msg)
    -- end


    -- local data  = _G.g_GameDataProxy : getMaterialList()
    -- local count = 0 
    -- if self.transToCheckBoxReelNodeId  ~= nil  then
    --     local ReelNodeId  = tonumber(self.transToCheckBoxReelNodeId) 
    --     if data ~= nil then
    --         for k,v in pairs(data) do
    --             if ReelNodeId == tonumber(v.goods_id) then
    --                 count = v.goods_num
    --             end
    --         end
    --     end
    -- end
    -- if self.transToCheckBoxBuy ~= nil then
    --     self.m_GemCount_Label  : setString(count.."/"..pear_GemCount)
    --     print("刷了一下那个卷轴数量")
    -- end


    --self : update()
    -- if self.transToCheckBuyOK_GemId ~= nil then
    --     local id = self.transToCheckBuyOK_GemId
    --     self : CleanPearl_comXmlData ()
    --     self : GetPearl_comXmlData(id) --宝石相关宝石卷轴下一级合成解析  
    -- end


    -- self.is_auto = 0
    -- self.checkBox : setChecked (false)

    local id = nil 
    if self.transToCheckBuyOK_GemId ~= nil then
       id = self.transToCheckBuyOK_GemId
    end    
    if id ~= nil and 
           self.GemListData[id] ~= nil then
            require "common/protocol/auto/REQ_MAKE_MAKE_COMPOSE" --宝石合成协议发送
            local msg = REQ_MAKE_MAKE_COMPOSE()
            index = self.GemListData[id]["index"]      --获取宝石位置
            msg   : setArg(index)                      -- {普通的是idx|全部的是等级}

            if self.initnum == 0 then
                self.initnum = 1
            end
            
            if self.initnum ~= 0 then
                local material_id      = tonumber(self.GemListData[id]["Materialid"])                --合成一个所需卷轴id

                local OneneedGemCount  = self.GemListData[id]["count_one"]    --合成一个所需宝石数量
                local OneneedReelCount = self.GemListData[id]["count_two"]    --合成一个所需卷轴数量

                if self.GemListData[id] ~= nil then
                    self.GemCount = tonumber(self.GemListData[id]["goods_num"] )  --背包宝石数量
                else   
                    self.GemCount = 0
                end
                if self.MaterialListData[material_id] ~= nil then
                    self.ReelCount = tonumber(self.MaterialListData[material_id]["goods_num"])  --背包卷轴数量
                else   
                    self.ReelCount = 0
                end

                local  allneedGemCount  = tonumber(OneneedGemCount) * self.initnum          --总所需宝石数量
                local  allneedReelCount = tonumber(OneneedReelCount) * self.initnum          --总所需卷轴数量
                print("allneedGemCount=",allneedGemCount,"allneedReelCount=",allneedReelCount)
                print("self.GemCount=",self.GemCount,"self.ReelCount=",self.ReelCount)
                local sendnum = tonumber(self.initnum)

                -- if self.GemCount  >= allneedGemCount and
                --    self.ReelCount >= allneedReelCount then

               msg : setCount(sendnum)        -- {需要合成的数量(一键则为0)}
               msg : setType(1)                    -- {合成方式:1:普通|2:全部}
               CNetwork : send(msg)

                   --CCMessageBox("合成成功","REQ_MAKE_MAKE_COMPOSE")
                   -- self : CleanPearl_comXmlData() --清空合成区域
                    --self.UpGradeBtn :setTouchesEnabled(false)
                -- else
                --     print("总所需宝石数量或总所需卷轴数量不足")
                --     local msg = "总所需宝石数量或总所需卷轴数量不足"
                --     self:createMessageBox(msg)
                -- end
            elseif self.initnum == 0 then
                if  self.theGemIsMax ==  1 then
                    --CCMessageBox("此宝石已为最高等级,不能合成!","提示")
                else
                    print("缺乏合成宝石或卷轴")    
                    -- CCMessageBox("缺乏合成宝石或卷轴！","提示")
                    local msg = "缺乏合成宝石或卷轴"
                    self:createMessageBox(msg)
                end
            else
                print("没有选择要合成的宝石数量")    
                --CCMessageBox("没有选择要合成的宝石数量","initnum")
                local msg = "没有选择要合成的宝石数量"
                self:createMessageBox(msg)
            end
    end 

end

function CEquipComposeLayer.setLayerFullScreenTouchEnabled( self )
    local actarr = CCArray:create()
    local function t_callback1()
        --self.composeArea_layer : setFullScreenTouchEnabled(false)
        self : lockScene()
    end
    local function t_callback2()
        self : unlockScene()
        --self.composeArea_layer : setFullScreenTouchEnabled(false)
    end
    local delayTime = 2
    actarr:addObject( CCCallFunc:create(t_callback1) )
    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(t_callback2) )
    self.composeArea_layer:runAction( CCSequence:create(actarr) )
end

--合成区域合成宝石回调
function CEquipComposeLayer.composeGemBtnCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if self.maxcooposenum == nil then
            self.maxcooposenum = 0
        end

        if self.Trans_composeGemNode ~=nil  and  self.Trans_composeGemNode : isEmpty() == false then
            print("self.confirmvalue= ",self.confirmvalue,obj : getTag())
            local id = nil 
            id       = obj : getTag()  --传递过来的ID
            if id ~= nil and self.confirmvalue == 1 then
                require "view/EquipInfoView/EquipTipsBox"
                self.EquipTipsBox = CEquipTipsBox :create(nil,nil,self.Trans_composeGemNode,self.maxcooposenum)
                local winSize     = CCDirector:sharedDirector():getVisibleSize()
                self.EquipTipsBox : setPosition(854/2-400,320-300)
                self.sencelayer   : addChild(self.EquipTipsBox,100)  
                -- self.confirmvalue = 0
            else
                print("无ID传递过来,而且不弹出框")
            end
        end
    end
end
--合成按钮区域合成按钮回调
function CEquipComposeLayer.MixBtnCallBack(self,eventType,obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local id = nil 
        id       = self.transToCheckBoxReelNodeId                    --传递过来背包宝石卷轴ID
        -- if self.isCheckToBuy == 1 then
        --     print("买宝石卷轴")
        --     if id  ~= nil  then
        --         print("买宝石卷轴11")
        --         local ReelNodeId  = id
        --         local Price,index = self : getCheckBoxPriceById(ReelNodeId)
        --         if index ~= nil then
        --             print("买宝石卷轴22")
        --             self : BuyNetWorkSend(index,ReelNodeId)
        --         end
        --     end
        --elseif self.isCheckToBuy == 0 then
        -- self.composeArea_layer : setFullScreenTouchEnabled(true)
        -- self.composeArea_layer : setTouchesPriority(-10000)
        -- self.composeArea_layer : setTouchesEnabled(true)
        self : setLayerFullScreenTouchEnabled() --可按

        self : NetWorkReturn_SHOP_BUY_SUCC()
        --end

        print("合成回调",id)
    end
end

function CEquipComposeLayer.lockScene( self )
    --锁住屏幕

    print("CGuideManager.lockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end
end
--解锁屏幕点击
function CEquipComposeLayer.unlockScene( self )

    print("CGuideManager.lockScene   unlockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end
end


-- function CEquipComposeLayer.MixBtnCallBack(self,eventType,obj,x,y)
--     if eventType == "TouchBegan" then
--         return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
--     elseif eventType == "TouchEnded" then
--         require "common/protocol/auto/REQ_MAKE_MAKE_COMPOSE" --宝石合成协议发送
--         local msg = REQ_MAKE_MAKE_COMPOSE()

--         local id = nil 
--         id       = obj : getTag()                      --传递过来背包宝石ID
--         if id ~= nil and 
--            self.GemListData[id] ~= nil then
--             index = self.GemListData[id]["index"]      --获取宝石位置
--             msg   : setArg(index)                      -- {普通的是idx|全部的是等级}
            
--             if self.initnum ~= 0 then
--                 local material_id      = tonumber(self.GemListData[id]["Materialid"])                --合成一个所需卷轴id

--                 local OneneedGemCount  = self.GemListData[id]["count_one"]    --合成一个所需宝石数量
--                 local OneneedReelCount = self.GemListData[id]["count_two"]    --合成一个所需卷轴数量

--                 if self.GemListData[id] ~= nil then
--                     self.GemCount = tonumber(self.GemListData[id]["goods_num"] )  --背包宝石数量
--                 else   
--                     self.GemCount = 0
--                 end
--                 if self.MaterialListData[material_id] ~= nil then
--                     self.ReelCount = tonumber(self.MaterialListData[material_id]["goods_num"])  --背包卷轴数量
--                 else   
--                     self.ReelCount = 0
--                 end

--                 local  allneedGemCount  = tonumber(OneneedGemCount) * self.initnum          --总所需宝石数量
--                 local  allneedReelCount = tonumber(OneneedReelCount) * self.initnum          --总所需卷轴数量
--                 print("allneedGemCount=",allneedGemCount,"allneedReelCount=",allneedReelCount)
--                 print("self.GemCount=",self.GemCount,"self.ReelCount=",self.ReelCount)
--                 local sendnum = tonumber(self.initnum)
--                 if self.GemCount  >= allneedGemCount and
--                    self.ReelCount >= allneedReelCount then

--                    msg : setCount(sendnum)        -- {需要合成的数量(一键则为0)}
--                    msg : setType(1)                    -- {合成方式:1:普通|2:全部}
--                    CNetwork : send(msg)
--                    --CCMessageBox("合成成功","REQ_MAKE_MAKE_COMPOSE")
--                    -- self : CleanPearl_comXmlData() --清空合成区域
--                     --self.UpGradeBtn :setTouchesEnabled(false)
--                 else
--                     print("总所需宝石数量或总所需卷轴数量不足")
--                     local msg = "总所需宝石数量或总所需卷轴数量不足"
--                     self:createMessageBox(msg)
--                 end

--             elseif self.initnum == 0 then
--                 if  self.theGemIsMax ==  1 then
--                     --CCMessageBox("此宝石已为最高等级,不能合成!","提示")
--                 else
--                     print("缺乏合成宝石或卷轴")    
--                     -- CCMessageBox("缺乏合成宝石或卷轴！","提示")
--                     local msg = "缺乏合成宝石或卷轴"
--                     self:createMessageBox(msg)
--                 end
--             else
--                 print("没有选择要合成的宝石数量")    
--                 --CCMessageBox("没有选择要合成的宝石数量","initnum")
--                 local msg = "没有选择要合成的宝石数量"
--                 self:createMessageBox(msg)
--             end
--         end 

--         print("合成回调",id)
--     end
-- end

--多点触控
function CEquipComposeLayer.BagGemBtnCallBack(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > CEquipComposeLayer.BagGemBtnTag or obj:getTag() == -1 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.BagGemBtnCallBackId = obj:getTag()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)

                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
 
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            --self : CleanPearl_comXmlData ()
            if touch2:getID() == self.touchID then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
 
                    --self : CleanPearl_comXmlData ()
                     self.checkBox : setText("自动购买宝石卷轴")   
                     self.checkBox : setChecked (false)
                     self.is_auto  = 0

                    local  id =tonumber(self.BagGemBtnCallBackId)   --传递过来的ID
                    if id ~= nil and id > 0 then 
                        self : CleanPearl_comXmlData ()
                        self.confirmvalue =  1      --通过这个参数判断是否弹出加减框
                        local node      =  _G.Config.goodss : selectSingleNode("goods[@id="..tostring(id).."]")
                        local node_icon = node : getAttribute("icon")
                        local ion_url         = "Icon/i"..node_icon..".jpg"
                        _G.g_unLoadIconSources : addIconData( node_icon )

                        self.BagGemBtnSprite  = nil
                        self.BagGemBtnSprite  = CCSprite :create(ion_url)
                        self.m_GemBtn         : addChild(self.BagGemBtnSprite,-1)
                        self.m_GemBtn         : setTag(tonumber(id)) --传递背包宝石的ID
                        self.m_MixBtn         : setTag(tonumber(id)) --传递背包宝石的ID
                        print("id====",id)
                        self.transToCheckBuyOK_GemId = id
                        --self : GemListAnalyzed()
                        self : GetPearl_comXmlData(id) --宝石相关宝石卷轴下一级合成解析
                    else
                        self.confirmvalue =  0      --通过这个参数判断是否弹出加减框
                        --self : CleanPearl_comXmlData ()
                    end 

                end
            end
        end
        self.touchID = nil
    end
end
--获取从mediator传过来的数据
function CEquipComposeLayer.setEquipinitnum(self,_data)
    self.initnum =tonumber(_data)
    print("CEquipComposeLayer.setEquipinitnum",_data,self.initnum)
    if self.initnum ~= 0 then
        print("self.m_composeGemCount_Label",self,self.m_composeGemCount_Label,self.m_composeGemName_Label,self.m_composeGemBtn,self.m_MixBtn)
        self.m_composeGemCount_Label : setString ( self.initnum )
    end
end
--更新后获取材料列表
function CEquipComposeLayer.setReNewData_MaterialList(self,m_ReNewData_MaterialList)
        self.m_ReNewData_MaterialList =  m_EquipmentListData
end
function CEquipComposeLayer.getReNewData_MaterialList(self)
       return self.m_ReNewData_MaterialList
end
--更新后获取宝石列表
function CEquipComposeLayer.setReNewData_GemList(self,m_GemListData)
        self.m_ReNewData_GemList = m_GemListData
end
function CEquipComposeLayer.getReNewData_GemList(self)
       return self.m_ReNewData_GemList 
end

--更新函数

function CEquipComposeLayer.update(self)
    print("CEquipComposeLayer.update")
    self : GemListAnalyzed() --宝石表解析
end

function CEquipComposeLayer.NetWorkReturn_MAKE_COMPOSE_OK(self)
    print("合成播放音效")
    self : playEffectSound() --成功特效

    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.m_composeGemBtn   : removeChild(self.THEccbi,false)
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
                    self.m_composeGemBtn   : removeChild(self.THEccbi,false)
                    self.THEccbi = nil 
                end
            end
            self : CleanPearl_comXmlData() --清空合成区域
            self.m_MixBtn : setTouchesEnabled(false)
            self.is_auto = 0
            self.checkBox : setChecked (false)
            --self.checkBox : setVisible (false)
            self.checkBox : setText("自动购买宝石卷轴")
            self.checkBox : setTouchesEnabled(false)
            self.confirmvalue =  0 

           -- self.sencelayer : setFullScreenTouchEnabled(false)
        end
    end

    if self.THEccbi ~= nil then
        self.THEccbi : removeFromParentAndCleanup(true)
        self.THEccbi = nil 
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    --self.THEccbi : setPosition(220,150)
    self.m_composeGemBtn  : addChild(self.THEccbi,1000)
end

--默认第一个物品
function CEquipComposeLayer.DefaultFirstGem(self)

    local GemstoneList =  _G.g_GameDataProxy : getGemstoneList()
    if GemstoneList ~= nil  then
        for k,v in pairs(GemstoneList) do
            if k == 1 and v.goods_id ~= nil then
                self.theFirstId = v.goods_id  --获取第一个装备id
                print("DefaultFirstGem=",v.goods_id)
                break
            end
        end
    end

    print("默认第一个物品 581",self.theFirstId)   
    self : CleanPearl_comXmlData ()
    if self.theFirstId ~= nil and self.theFirstId > 0 then 
        self.confirmvalue =  1      --通过这个参数判断是否弹出加减框

        -- local GemNode          = _G.Config.goodss:selectNode("goods","id",tostring(self.theFirstId))     --宝石节点
        local GemNode         = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(self.theFirstId).."]")     --宝石节点
        local GemNode_icon    = GemNode : getAttribute("icon")
        local ion_url         = "Icon/i"..GemNode_icon..".jpg"
        _G.g_unLoadIconSources : addIconData( GemNode_icon )

        self.BagGemBtnSprite  = nil
        self.BagGemBtnSprite  = CCSprite :create(ion_url)
        self.m_GemBtn         : addChild(self.BagGemBtnSprite,-1)
        self.m_GemBtn         : setTag(tonumber(self.theFirstId)) --传递背包宝石的ID
        self.m_MixBtn         : setTag(tonumber(self.theFirstId)) --传递背包宝石的ID

        self.transToCheckBuyOK_GemId = self.theFirstId
        self : GetPearl_comXmlData(self.theFirstId) --宝石相关宝石卷轴下一级合成解析
    else
        self.confirmvalue =  0         --通过这个参数判断是否弹出加减框
    end
end

--mediator
function CEquipComposeLayer.mediatorRegister(self)
    require "mediator/EquipComposeMediator"
    if _G.g_EquipComposeMediator == nil  then
        print("CEquipComposeLayer.mediatorRegister")
        _G.g_EquipComposeMediator = EquipComposeMediator(self)
        controller :registerMediator(  _G.g_EquipComposeMediator )
    end
end


function CEquipComposeLayer.createMessageBox(self,_msg,fun1,fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,fun1,fun2)
    self.sencelayer : addChild(BoxLayer,1000)
end


function CEquipComposeLayer.playEffectSound(self) --成功特效
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
    end
end
