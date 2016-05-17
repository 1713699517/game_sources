--jun
require "controller/GemInlayCommand"
require "controller/command"

require "mediator/mediator"
require "mediator/GemInlayMediator"
require "mediator/BackpackMediator"

require "view/view"
require "view/BackpackLayer/BackpackView"

require "model/VO_BackpackModle"

require "view/Character/BaseCharacter"

CGemInlayView =class(view,function (self)
                        self.TheFirstIndex   = {}
                        self.TheFirstIndexNo = 1
                        self.pushDataId      = 0 
                        self.effectsCCBI     = {} --物品特效
                     end)
CGemInlayView.FONTFAMILY = "Arial"
CGemInlayView.FONTSIZE = 20

function CGemInlayView.loadResources(self)
    _G.Config:load("config/goods.xml")
    _G.Config:load("config/partner_init.xml")
end
--适配布局
function CGemInlayView.layout(self, winSize)
    if winSize.height == 640 then

        self.m_leftBackGround     : setPosition(250,358-5)    --左底图
        self.m_leftdownBackGround : setPosition(250,80-9+2)   --左底图
        self.m_rightBackGround    : setPosition(665,290-3)    --右底图
   
        --self.m_pScrollView        : setPosition(60,167)     --活动页0.052
        --self.m_NameTextLabel    : setPosition(winSize.width/2*0.55 ,winSize.height/2*0.42)
        
    elseif winSize.height == 768 then
        self.m_leftBackGround     : setPosition(250,358)    --左底图
        self.m_leftdownBackGround : setPosition(250,80)     --左底图
        self.m_rightBackGround    : setPosition(670,290)    --右底图
   
        --self.m_pScrollView        : setPosition(60,167)     --活动页0.052
        --self.m_NameTextLabel    : setPosition(winSize.width/2*0.55 ,winSize.height/2*0.42)
    end
end

function CGemInlayView.init(self, winSize,_layer)
    self : loadResources()                         --资源初始化
    self : initGemInlayView(winSize,_layer)        --界面初始化
    self : initParameter()                         --参数初始化
    self : layout(winSize)                         --适配布局初始化
    self : getTeamersData()                        --小伙伴初始化
    self : DefaultFirstEquip()                     --默认第一个装备
end

function CGemInlayView.layer(self)
    local winSize     = CCDirector:sharedDirector():getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CGemInlayView _layer 70  " )
    print("layer.",self)
    self:init(winSize,self.m_scenelayer)                                       --此为镶嵌初始化
    return self.m_scenelayer
end

function CGemInlayView.initParameter(self)--参数初始化
    --数据初始化前先判断是否是有界面更新，再从从缓存获取道具数据
    if(self.ReNewData_EquipmentList ~= nil)then
        print("检测到界面更新，从新获取道具列表",self.ReNewData_EquipmentList)
        local data  = self.ReNewData_EquipmentList
        local data2 = self.ReNewData_GemList
        local gold  = self.ReNewData_Gold
        self:GetBagData(data,data2,gold)     --此为页面从缓存获取的初始数据
    else
        print("界面无更新，直接拿缓存中的装备数据",_G.g_GameDataProxy:getEquipmentList())
        local data   = self : getPartnerParams(0)--人物身上的装备 0为主将
        local data2  = _G.g_GameDataProxy : getGemstoneList()  --获取宝石数据表       
        local gold   = _G.g_GameDataProxy : getGold()          --获取背包金币
        self:GetBagData(data,data2,gold)                       --此为页面从缓存获取的初始数据
    end
    self.thepartnerId = 0
end

function CGemInlayView.initGemInlayView(self,winSize,_layer)--界面初始化
    --_G.CNetwork : pause()  --暂停TCP接受

    self.m_leftBackGround     = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_leftdownBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround    = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图
    
    --self.m_allBackGround    : setPreferredSize(CCSizeMake(winSize.width*0.93,winSize.height*0.82))      --530 890
    self.m_leftBackGround     : setPreferredSize(CCSizeMake(410,425)) --420 260
    self.m_leftdownBackGround : setPreferredSize(CCSizeMake(410,130-5)) --420 260
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(410,550+5)) --400 500
    
    --_layer : addChild(self.m_allBackGround,-1)
    _layer : addChild(self.m_leftBackGround,-10)
    _layer : addChild(self.m_leftdownBackGround,-10)
    _layer : addChild(self.m_rightBackGround,-10)

     local function selectedEquIconCallBack(eventType,obj,x,y)
       return self:selectedEquipIconCallBack(eventType,obj,x,y)
    end   
    --活动页
    self.m_BagEquipBtn       = {} --背包装备物品按钮
    self.m_BagEquipBtnSprite = {} --背包装备物品按钮图
    self.BagEquipArrSprites  = {} --装备可镶嵌箭头图片
    -- self.effectsCCBI         = {} --物品特效

    local iconLayout   = CHorizontalLayout : create()
    iconLayout         : setControlName( "this is CEquipEnchantView iconLayout 76" )

    iconLayout   : setLineNodeSum(2)
    iconLayout   : setCellSize(CCSizeMake(293-30,140-10))
    iconLayout   : setVerticalDirection(false)
    --iconLayout   : setPosition(-45+32+380,358+140-13)
    iconLayout   : setPosition(-45+32,358+140-13)
    --iconLayout   : setPosition(-296,140)
    _layer       : addChild(iconLayout,50000)

    for k=1,6 do
        -- num = (i-1)*6+k   
        self.m_BagEquipBtn[k]    = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
        self.m_BagEquipBtn[k]    : setControlName( "this is CEquipEnchantView.initView m_BagEquipBtn 108" )
        self.m_BagEquipBtn[k]    : registerControlScriptHandler(selectedEquIconCallBack,"this is CEquipEnchantView.initView m_BagEquipBtn 108")
        self.m_BagEquipBtn[k]    : setTouchesPriority( -100 )
        iconLayout :  addChild(self.m_BagEquipBtn[k],1000)

        self.m_BagEquipBtnSprite[k] = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
        self.m_BagEquipBtn[k]      :  addChild(self.m_BagEquipBtnSprite[k],3)  

        self.BagEquipArrSprites[k] = CSprite :createWithSpriteFrameName("equip_arrow_up2.png")
        self.BagEquipArrSprites[k] : setVisible( false )
        self.BagEquipArrSprites[k] : setPosition(34,-28)
        self.m_BagEquipBtn[k]      :  addChild(self.BagEquipArrSprites[k],50)  

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
        self.teamerlayout : addChild( self.TeamerBtn[w] )    

        local TeamerBtnSprite = CSprite : createWithSpriteFrameName("general_role_head_underframe.png")
        self.TeamerBtn[w]     : addChild(TeamerBtnSprite,-2)
    end
    ----宝石栏
    self.GemBag_layout = CVerticalLayout :create() --宝石布局
    self.GemBag_layout : setVerticalDirection(false)
    self.GemBag_layout : setPosition(760,590)
    self.GemBag_layout : setCellSize(CCSizeMake(435,182))
    _layer :addChild(self.GemBag_layout,-5)

    self.GemContainer         = {} --容器
    self.unUpgradeGemBtn      = {} --升级前
    self.unPropertyNameLabel  = {} --升级前+的属性
    self.unUpgradeLvLabel     = {} --升级前+lv    
    self.UpgradeGemBtn        = {} --升级后
    self.PropertyNameLabel    = {} --升级后+的属性
    self.UpgradeLvLabel       = {} --升级后+lv
    self.ArrowSprite          = {} --大箭头
    self.SmallArrowSprite     = {} --小箭头
    self.ConsumptionLabel     = {} --消费美刀
    self.theUpgradeBtn        = {} --升级按钮

    --特效层
    self.effectsCCBIBackGroundSprite = CSprite : createWithSpriteFrameName("transparent.png")
    self.effectsCCBIBackGroundSprite : setPreferredSize(CCSizeMake(100,100))
    self.effectsCCBIBackGroundSprite : setPosition(300+244,300+197)
    _layer :addChild(self.effectsCCBIBackGroundSprite,50)

    -- _G.CNetwork    : resume()  --继续接受TCP
end

function CGemInlayView.selectedEquipIconCallBack(self,eventType,obj,x,y)
    _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    --self.GemBag_Iconslayout : removeAllChildrenWithCleanup(true)
    if self.GemBag_layout ~= nil then
        self.GemBag_layout : removeAllChildrenWithCleanup(true)
    end

    print("按装备回调-->宝石",obj : getTag())
    -- print("装备回调",equ_id)
    local  i      = obj : getTag()      --传递过来的ID
           equ_id = tonumber(self.theTransId[i])  
    print("装备回调",equ_id)

    self : chagneBagEquipBtnSprites(i)

    -- local  equ_id  = obj : getTag()
    if equ_id ~=nil and equ_id > 0 then
        self.transfId  = equ_id
        self : GetPearl_comXmlData(equ_id)
    end

    _G.pCGuideManager:sendStepFinish()
    end
end

function CGemInlayView.chagneBagEquipBtnSprites(self, _i)
    local i = tonumber (_i) 
    if self.oldno ~= nil and self.oldno > 0 then
        self.m_BagEquipBtnSprite[self.oldno] :  setImageWithSpriteFrameName( "general_props_frame_normal.png" )
    end
    if i ~= nil and i > 0 then
        self.m_BagEquipBtnSprite[i] : setImageWithSpriteFrameName("general_props_frame_click.png")  
        self.oldno = i   
    end 
end

function CGemInlayView.GetPearl_comXmlData(self,equ_id)
    local  theEquData = self.Equip_Data[equ_id]
    print("GetPearl_comXmlData",equ_id,theEquData)
    local equ_index   = theEquData["index"]           --装备位置(服务器)
    print("GetPearl_comXmlData11",equ_index) 
    self.change_equ_index = equ_index
    local winSize  = CCDirector:sharedDirector():getVisibleSize()
    if theEquData["slots_count"] ~= nil then
        loops = theEquData["slots_count"]
    else
        loops = 3
    end
    print("loops->>>",loops,theEquData["slots_count"])

    local function theUpGradeBtnCallBack(eventType,obj,x,y)
        return    self:theUpGradeBtnCallBack(eventType,obj,x,y)
    end

    local function theunUpgradeGemBtnCallBack(eventType, obj, touches)
        return self : theunUpgradeGemBtnCallBack(eventType, obj, touches)
    end 
    for g=1,loops do
        self.GemContainer[g] = CContainer : create ()
        self.GemBag_layout   : addChild(self.GemContainer[g])

        self.unUpgradeGemBtn[g] = CButton : createWithSpriteFrameName("","general_equip_frame.png")
        self.ArrowSprite[g]     = CSprite : createWithSpriteFrameName("equip_strengthen_sjh.png")
        self.SmallArrowSprite[g]= CSprite : createWithSpriteFrameName("equip_arrow_right.png")
        self.UpgradeGemBtn[g]   = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
        self.UpgradeGemBtn[g] : registerControlScriptHandler(theunUpgradeGemBtnCallBack,"this unUpgradeGemBtn CallBack")
        --self.UpgradeGemBtn[g] : setTouchesEnabled( true)
        self.UpgradeGemBtn[g] : setTouchesMode( kCCTouchesAllAtOnce )
        self.UpgradeGemBtn[g] : setTag( g )

        self.theUpgradeBtn[g]   = CButton : createWithSpriteFrameName("升级","general_smallbutton_click.png")

        self.unUpgradeGemBtn[g]: setControlName( "this is CGemInlayView self.unUpgradeGemBtn[g] 77" )
        self.UpgradeGemBtn[g]  : setControlName( "this is CGemInlayView self.UpgradeGemBtn[g] 77" )
        self.theUpgradeBtn[g]  : setControlName( "this is CGemInlayView self.theUpgradeBtn[g] 77" )
        self.unUpgradeGemBtn[g]  :setTouchesPriority( -100 )
        self.UpgradeGemBtn[g]    :setTouchesPriority( -100 )
        self.theUpgradeBtn[g]    :setTouchesPriority( -100 )

        self.unPropertyNameLabel[g]  = CCLabelTTF : create("属性名称 +9999999","Arial",18)
        self.PropertyNameLabel[g]    = CCLabelTTF : create("+9999999","Arial",18)
        self.ConsumptionLabel[g]     = CCLabelTTF : create("","Arial",18)
        self.unUpgradeLvLabel[g]     = CCLabelTTF : create("LV2","Arial",18)
        self.UpgradeLvLabel[g]       = CCLabelTTF : create("LV3","Arial",18)

        -- if g == 2 or g == 3 then
        if g < 3 then
            local line = CSprite : createWithSpriteFrameName("general_dividing_line.png") 
            line : setPosition(0,-40)
            self.SmallArrowSprite[g] : addChild(line)
        end

        self.PropertyNameLabel[g]    : setColor(ccc3(94,208,18))
        self.unPropertyNameLabel[g]  : setAnchorPoint(ccp(0,0.5))
        self.ConsumptionLabel[g]     : setColor(ccc3(255,0,0))
        self.ConsumptionLabel[g]     : setAnchorPoint(ccp(0,0.5))
        self.theUpgradeBtn[g]        : setFontSize(20)
        self.theUpgradeBtn[g]        : registerControlScriptHandler(theUpGradeBtnCallBack,"this CGemInlayView 438")    --宝石按钮回调

        self.unUpgradeGemBtn[g] : setPosition(0,0)
        self.ArrowSprite[g]     : setPosition(120+15,0)
        self.SmallArrowSprite[g]: setPosition(-10-10,-65-10)
        self.UpgradeGemBtn[g]   : setPosition(240,0)
        self.theUpgradeBtn[g]   : setPosition(40,-80)

        self.unPropertyNameLabel[g]  : setPosition(-50+15,-65-10)
        self.PropertyNameLabel[g]    : setPosition(-77+15,-65-10)
        self.ConsumptionLabel[g]     : setPosition(-50+15,-90-10)
        self.unUpgradeLvLabel[g]     : setPosition(-22,28)
        self.UpgradeLvLabel[g]       : setPosition(-22,28)
      
        self.GemContainer[g] : addChild(self.unUpgradeGemBtn[g],-2)
        self.GemContainer[g] : addChild(self.ArrowSprite[g],-2)
        self.GemContainer[g] : addChild(self.UpgradeGemBtn[g],-2)

        self.ArrowSprite[g]  : addChild(self.SmallArrowSprite[g]) --小箭头

        self.unUpgradeGemBtn[g] : addChild(self.unPropertyNameLabel[g])
        self.unUpgradeGemBtn[g] : addChild(self.ConsumptionLabel[g])
        self.unUpgradeGemBtn[g] : addChild(self.unUpgradeLvLabel[g],10)

        self.UpgradeGemBtn[g] : addChild(self.PropertyNameLabel[g])
        self.UpgradeGemBtn[g] : addChild(self.theUpgradeBtn[g])
        self.UpgradeGemBtn[g] : addChild(self.UpgradeLvLabel[g],10)
    end

    self.selectIconGemBtnTable  = {}
    self.selectIconGemBtnSprite = {}
    self.isGray                 = {}
    self.ishaveBagGem           = {}

    self.unUpgradeGemBtnSprite = {}
    self.UpgradeGemBtnSprite   = {}

    for w = 1,loops do
        local isvalue = self : ischeoseGemData(theEquData,w,loops)
        if isvalue ~= 0 then --一个个孔判断
           self.isGray[w] = 0
           theEquData["theslot"..w] = theEquData["slothavegem"..isvalue]
           self.theSlotData         = theEquData["theslot"..w]
           print("slothavegem--->",w,self.theSlotData)

            self.theUpgradeBtn[w] : setText("升级")
        else
           self.isGray[w] = 1
           self.theSlotData   =  theEquData["theslot"..w]
           print("theslot--->",w,theEquData["theslot"..w])

            self.theUpgradeBtn[w] : setText("镶嵌")
           print("按钮改名")
        end

        -- self.gem_LVTextLabel[w]        : setString(self.theSlotData["slot_pearl_name"].."LV"..self.theSlotData["slot_pearl_lv"]) --等级
        -- self.gem_BloodTextLabel[w]     : setString(self.theSlotData["slot_pearl_remark"])                                        --属性
        -- self.gem_NextLVTextLabel[w]    : setString("下一等级".."LV"..self.theSlotData["slot_pearl_nextlv"])                       --下一等级
        -- self.gem_NextBloodTextLabel[w] : setString(self.theSlotData["slot_pearl_nextremark"])                                    --下一属性

        self.unUpgradeLvLabel[w]     : setString("LV"..self.theSlotData["slot_pearl_lv"])
        if  self.theSlotData["slot_pearl_nextlv"] ~= nil then
            self.UpgradeLvLabel[w]       : setString("LV"..self.theSlotData["slot_pearl_nextlv"])
        else
            self.UpgradeLvLabel[w]       : setString("")
        end

        self.unPropertyNameLabel[w]  : setString(self.theSlotData["slot_pearl_remark"])

        if  self.theSlotData["slot_pearl_nextremark"] ~= nil then
            self.PropertyNameLabel[w]    : setString(self.theSlotData["slot_pearl_nextremark"])
        else
            self.PropertyNameLabel[w]    : setString("")
        end

        -- self.selectIconGemBtn[w]       : setTag(w)
        self.selectIconGemBtnTable[w] = {} 
        self.selectIconGemBtnTable[w].slot_pearl_id       = self.theSlotData["slot_pearl_id"]       --宝石id
        self.selectIconGemBtnTable[w].equ_idx             = theEquData["index"]                     --装备idx
        self.selectIconGemBtnTable[w].price               = self.theSlotData["slot_pearl_price"]    --宝石价格
        self.selectIconGemBtnTable[w].slot_pearl_type     = self.theSlotData["slot_pearl_type"]     --宝石类型           
        self.selectIconGemBtnTable[w].slot_pearl_nextlvid = self.theSlotData["slot_pearl_nextlvid"] --宝石nextid
        self.selectIconGemBtnTable[w].slot_pearl_nextname = self.theSlotData["slot_pearl_nextname"] --宝石nextname

        if self.isGray[w] == 1 then
            self.selectIconGemBtnTable[w].slot_pearl_nextlvid = self.selectIconGemBtnTable[w].slot_pearl_id
            self.selectIconGemBtnTable[w].slot_pearl_nextname = self.theSlotData["slot_pearl_name"] --宝石name

            local unUpgradeicon_url     = "Icon/i"..self.theSlotData["slot_pearl_icon"]..".jpg"
            _G.g_unLoadIconSources : addIconData( self.theSlotData["slot_pearl_icon"] )
            self.UpgradeGemBtnSprite[w] = CSprite :create(unUpgradeicon_url)
            self.UpgradeGemBtn[w]       : addChild(self.UpgradeGemBtnSprite[w],-1)

            self.unUpgradeLvLabel[w]     : setString("")
            self.UpgradeLvLabel[w]       : setString("LV"..self.theSlotData["slot_pearl_lv"])

            self.unPropertyNameLabel[w]  : setString("")
            self.PropertyNameLabel[w]    : setString(self.theSlotData["slot_pearl_remark"])  --未镶嵌时候 镶嵌后的属性

        else

            local unUpgradeicon_url       = "Icon/i"..self.theSlotData["slot_pearl_icon"]..".jpg"
            _G.g_unLoadIconSources : addIconData( self.theSlotData["slot_pearl_icon"] )
            self.unUpgradeGemBtnSprite[w] = CSprite :create(unUpgradeicon_url)
            self.unUpgradeGemBtn[w]       : addChild(self.unUpgradeGemBtnSprite[w],-1)

            if self.theSlotData["slot_pearl_nexticon"] ~= nil then
                local Upgradeicon_url       = "Icon/i"..self.theSlotData["slot_pearl_nexticon"]..".jpg"
                _G.g_unLoadIconSources : addIconData( self.theSlotData["slot_pearl_nexticon"] )
                self.UpgradeGemBtnSprite[w] = CSprite :create(Upgradeicon_url)
                self.UpgradeGemBtn[w]       : addChild(self.UpgradeGemBtnSprite[w],-1)   
            end 
        end
        --是否背包有宝石
        self.ishaveBagGem[w] = 0
        for j,v in pairs(self.m_GemlistListData) do    --查找背包宝石
            print("穷举背包宝石",j,v,v.goods_id)
            if (self.theSlotData["slot_pearl_nextlvid"] == tonumber(v.goods_id))then
                self.ishaveBagGem[w] = 1 
                break
            end
        end
        self : JudgeUpgradeBtnAndLael(w)--判断是否有升级按钮
    end
end

function CGemInlayView.ischeoseGemData(self,_theEquData,_no,_Count) --通过类型找宝石 看是否有镶嵌
    local isvalue = 0
    local Solttype =  _theEquData["slot_type".._no] --孔的类型的宝石的类型

    for i=1,_Count do
        if Solttype == _theEquData["slothavegem_type"..i] then
           isvalue = i
           break
        end
    end 

    return isvalue
end

function CGemInlayView.selectedGemIconCallBack(self,eventType,obj,x,y)
  if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
  elseif eventType == "TouchEnded" then
    print("按宝石触发回调-->升级",obj : getTag())
  end
end

function CGemInlayView.JudgeUpgradeBtnAndLael(self,_no)
    print("升级按钮判断")
    local no =tonumber(_no) 
    --self.m_thegemPrice =tonumber(self.selectIconGemBtnTable[no].price) 
    --self.m_theequIdx   = self.selectIconGemBtnTable[no].equ_idx
    --self.m_thegemType  = self.selectIconGemBtnTable[no].slot_pearl_type
    self.m_thegemId    = self.selectIconGemBtnTable[no].slot_pearl_nextlvid
    self.m_thenextname = self.selectIconGemBtnTable[no].slot_pearl_nextname

    print("dddd-->",self.m_thegemPrice,self.m_theequIdx,self.m_thegemType,self.m_thegemId,self.m_GemlistListData)

    self.gem_thenum = 0
    local goods_num = 0 
    for k,v in pairs(self.m_GemlistListData) do  --从缓存获取宝石表
        if (self.m_thegemId ~= nil and tonumber(self.m_thegemId)  == v.goods_id )then
            goods_num = goods_num + v.goods_num
           --print("获取宝石数量-》》",self.m_thegemId,self.gem_thenum)
        end
    end
    self.gem_thenum = tonumber(goods_num)        --获取宝石数量

    if self.gem_thenum > 0 then
        --self.theUpgradeBtn[no] : setTouchesEnabled(true)
        self.theUpgradeBtn[no] : setVisible( true )  
        self.theUpgradeBtn[no] : setTag(no)
    else
        print("第"..no.."个升级按钮不能升级")
        --self.theUpgradeBtn[no] :setTouchesEnabled(false)
        self.theUpgradeBtn[no] : setVisible( false ) 
        if self.m_thenextname ~= nil then
            self.ConsumptionLabel[no] :setString ("需要"..self.m_thenextname)
        else
            self.ConsumptionLabel[no] :setString ("满级")
        end
    end

end

function CGemInlayView.theUpGradeBtnCallBack(self,eventType,obj,x,y)
    _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local no = obj : getTag()
        print("升级回调",no,value,self.thepartnerId)
        if no ~= nil and no > 0 and self.thepartnerId ~= nil  then

            local m_theequIdx   = self.selectIconGemBtnTable[no].equ_idx
            local m_thegemType  = self.selectIconGemBtnTable[no].slot_pearl_type
            local partnerId     = self.thepartnerId

            local theno               = self.TheFirstIndexNo
            self.TheFirstIndex[theno] = tonumber(m_theequIdx)
            print("theUpGradeBtnCallBackthenothenotheno",theno,self.TheFirstIndex[theno])

            require "common/protocol/auto/REQ_MAKE_PEARL_INSET" --宝石数据协议发送
            local msg = REQ_MAKE_PEARL_INSET()
            msg : setType(2) --1背包2装备栏
            msg : setId(partnerId)
            msg : setIdx(m_theequIdx)
            msg : setPearlType(m_thegemType)
            CNetwork : send(msg)
            _G.pCGuideManager:sendStepFinish()

            self.transCCBINo = tonumber(no)
            --self : CommandChange_MAKE_PEARL_INSET()
            self : setUpgradeBtnTrueAndFalse()
        end
    end
end

function CGemInlayView.setUpgradeBtnTrueAndFalse( self )

    local actarr = CCArray:create()
    local function t_callback1()
        for i=1,3 do
            if  self.theUpgradeBtn[i] ~= nil then
              -- self.theUpgradeBtn[i] : setTouchesEnabled(false)
            end
        end
        self.m_scenelayer : setFullScreenTouchEnabled(true)
       -- self.m_scenelayer : setTouchesEnabled(true)
        self.m_scenelayer : setTouchesPriority(-100)
    end

    local function t_callback2()
        -- for i=1,3 do
        --     if  self.theUpgradeBtn[i] ~= nil then
        --     --   self.theUpgradeBtn[i] : setTouchesEnabled(true)
        --     end
        -- end
        self.m_scenelayer : setFullScreenTouchEnabled(false)
    end
    local delayTime = 1.5
    actarr:addObject( CCCallFunc:create(t_callback1) )
    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(t_callback2) )
    self.m_scenelayer:runAction( CCSequence:create(actarr) )
end

--多点触控
function CGemInlayView.theunUpgradeGemBtnCallBack(self, eventType, obj, touches)
    print("多点触控一下",eventType,obj,obj:getTag())
    -- _G.g_PopupView :reset()
    if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do

            local touch = touches :at( i - 1 )
            if tonumber(obj:getTag())  > 0 then

                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.GoodsBtnSpriteBtnCallBackId = tonumber(obj:getTag()) 
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
            print("obj: tag",obj:getTag())
            if touch2:getID() == self.touchID and tonumber (self.GoodsBtnSpriteBtnCallBackId) == tonumber(obj:getTag())  then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local no = obj:getTag()
                    if self.selectIconGemBtnTable[no] ~= nil then  
                        local id   = self.selectIconGemBtnTable[no].slot_pearl_nextlvid
                        local name = self.selectIconGemBtnTable[no].slot_pearl_nextname
                        print("我是宝石===",no,id,name)
                         local winSize = CCDirector:sharedDirector():getVisibleSize()
                        _G.g_PopupView :reset()
                        _position   = {}
                        _position.x = touch2Point.x
                        _position.y = touch2Point.y
                        print("x-y",_position.x,_position.y)
                        if id ~= nil then
                            local  temp =  _G.g_PopupView :createByGoodsId(id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
                            local   posx,posy = temp : getPosition()

                            temp : setPosition(posx-60,posy)
                            self.m_scenelayer :addChild(temp)
                        end
                    end
                                        self.touchID = nil
                    self.GoodsBtnSpriteBtnCallBackId = nil
                end
            end
        end
    end
end

function CGemInlayView.GetBagData(self,_EquipmentList,_GemstoneList,gold)
    self.m_bag_gold          = gold               --从缓存获取金币数量
    -- self.m_EquipmentListData = _EquipmentList  --从缓存获取到道具表
    self.m_GemlistListData   = _GemstoneList      --从缓存获取宝石表
    if _EquipmentList == nil then
        print("xxx44")
        self.m_EquipmentListData = self : getPartnerParams(0)--人物身上的装备 0为主将
    else
        print("xxx55")
        self.m_EquipmentListData = _EquipmentList
    end

    for a,equ_p in pairs(self.m_EquipmentListData) do
        j = math.mod(a-1,6)+1          --第几个
        i = math.floor(a/6)+1          --第几页math.floor(a/6)+1
    end

    self.m_PageCount       = i         --页数
    self.m_GoodCounts      = j         --最后一页装备个数
    self.iconnamelabels    = {}
 
    self.BaseIconS         = {}
    self.BaseBoxIconS      = {}
    self.OneiconLayout     = {}
    iconWenZiLayout        = {}
    self.m_iconLvLabel     = {}
    self.m_iconNameLabel   = {}
    self.icon_PhotoNames   = {}
    self.Equip_Data        = {}
    self.BagEquipBtnSprites = {}  --装备图片

    self.iconLayout        = {}
    self.theTransId        = {}

    if(self.m_PageCount == nil)then
        print("报空",self.m_PageCount)
        self.m_PageCount=1
    end

    print("2---------开始拿装备------------------开始拿装备------------------开始拿装备---------2")
    --先清除一些东西
    for i=1,6 do
        --  print("删除之前装备图片0000",i)
        -- if  self.BagEquipBtnSprites[i] ~= nil then
        --     self.BagEquipBtnSprites[i] : removeFromParentAndCleanup(true)
        --     self.BagEquipBtnSprites[i] = nil
        --     print("删除之前装备图片",i)
        -- end
        self.m_BagEquipBtn[i] : setTag(-1)                         --传递背包装备的ID
        self.theTransId[i]    = nil
    end
    --获取道具
    for a,equ_p in pairs(self.m_EquipmentListData) do
        self.equipment_No                = a                --物品序数
        self.Equip_Data[equ_p.goods_id]                = {}
        self.Equip_Data[equ_p.goods_id]["goods_id"  ]  = equ_p.goods_id   --装备id
        self.Equip_Data[equ_p.goods_id]["index"     ]  = equ_p.index      --装备索引位置idx
        self.Equip_Data[equ_p.goods_id]["goods_type"]  = equ_p.goods_type --装备大类
        self.Equip_Data[equ_p.goods_id]["price"     ]  = equ_p.price      --装备价格
        self.Equip_Data[equ_p.goods_id]["strengthen"]  = equ_p.strengthen --装备强化等级 
        self.Equip_Data[equ_p.goods_id]["slots_count"] = equ_p.slots_count --插槽数量 
        print("388--->",a,equ_p.index,equ_p.goods_id,equ_p.slots_count)
        --读取goods.xml的装备数据
        print("equ_p.goods_id=====>",equ_p.goods_id)
        --local taskNode = _G.Config.goodss:selectNode("goods","id",tostring(equ_p.goods_id))
        local taskNode =_G.Config.goodss : selectSingleNode("goods[@id="..tostring(equ_p.goods_id).."]")
        local taskNode_child     = taskNode : children()
        local taskNode_nextchild = taskNode_child : get(0,"slots")
        local taskNode_nextchildCount = taskNode_nextchild : children() : getCount("slot")      

        self.Equip_Data[equ_p.goods_id]["lv"]            = taskNode : getAttribute("lv")               --装备等级
        self.Equip_Data[equ_p.goods_id]["name"]          = taskNode : getAttribute("name")             --装备名称
        self.Equip_Data[equ_p.goods_id]["type_sub_name"] = taskNode : getAttribute("type_sub_name")    --类型名字() 

        -- for i,v in pairs(taskNode_nextchild) do  --找符合装备的宝石类型
        for i=0,taskNode_nextchildCount-1  do
            self.Equip_Data[equ_p.goods_id]["slot_type"..i+1] = taskNode_nextchild : children()  : get(i,"slot") : getAttribute("type")                           --孔的类型的宝石的类型
            self.Equip_Data[equ_p.goods_id]["theslot"..i+1]   = {}
            self.Equip_Data[equ_p.goods_id]["theslot"..i+1]   = self : getGemDataByType(taskNode_nextchild : children()  : get(i,"slot") : getAttribute("type")) --孔的类型的宝石的数据
            --print("theslot type ",i,v.type,self : getGemDataByType(v.type),self.Equip_Data[equ_p.goods_id]["theslot"..i].slot_pearl_name)     
        end
        -- for i,v in pairs(taskNode.slots[1].slot) do  --找符合装备的宝石类型
        --     self.Equip_Data[equ_p.goods_id]["slot_type"..i] = v.type                          --孔的类型的宝石的类型
        --     self.Equip_Data[equ_p.goods_id]["theslot"..i]   = {}
        --     self.Equip_Data[equ_p.goods_id]["theslot"..i]   = self : getGemDataByType(v.type) --孔的类型的宝石的数据
        --     print("theslot type ",i,v.type,self : getGemDataByType(v.type),self.Equip_Data[equ_p.goods_id]["theslot"..i].slot_pearl_name)     
        -- end

        --获取插槽数据
        for b , equ_p_solt_gem in pairs(equ_p.slot_group) do
            self.Equip_Data[equ_p.goods_id][b]    = {}              --获取插槽里面的宝石数据

            if(equ_p_solt_gem.slot_flag == true )then  --如果道具的插槽不为空
                
                if(equ_p_solt_gem.slot_pearl_id ~= 0 and equ_p_solt_gem.slot_pearl_id ~= nil)then

                    local DataById =  self : getGemDataById( equ_p_solt_gem.slot_pearl_id )
                    self.Equip_Data[equ_p.goods_id]["slothavegem_type"..b] = DataById.slot_pearl_type --镶嵌了的宝石的类型
                    self.Equip_Data[equ_p.goods_id]["slothavegem"..b]      = {} 
                    self.Equip_Data[equ_p.goods_id]["slothavegem"..b]      = DataById                 --镶嵌了的宝石的数据   
                    print("slothavegem type ",DataById.slot_pearl_type,b)               
                end    
            end
        end 

        local type_sub = tonumber(taskNode : getAttribute("type_sub"))
        if    type_sub  == 11 then
                a = 2
        elseif type_sub == 12 then
                a = 3
        elseif type_sub == 13 then
                a = 6
        elseif type_sub == 14 then
                a = 4
        elseif type_sub == 15 then
                a = 5
        else
                a = 1
        end
        self.Equip_Data[equ_p.goods_id]["real_Position"] = a                --真实的位置
        --self.m_BagEquipBtn[a] : setTag(tonumber(equ_p.goods_id))          --传递背包装备的ID
        self.m_BagEquipBtn[a] : setTag(tonumber(a))                         --传递背包装备的ID
        self.theTransId[a]    = equ_p.goods_id
        --------------------------------------------------------------------------------------------------------
        local taskNode_icon = taskNode : getAttribute("icon")
        local ion_url       = "Icon/i"..taskNode_icon..".jpg"
        _G.g_unLoadIconSources : addIconData( taskNode_icon )
        self.BagEquipBtnSprites[a]       = CCSprite :create(ion_url)
        self.m_BagEquipBtn[a] : addChild(self.BagEquipBtnSprites[a],-2)

        self : Create_effects_equip(a,self.m_BagEquipBtn[a],taskNode : getAttribute("name_color"))

        --self.BagEquipArrSprites[a] : setVisible( false )
        --判断小箭头是否显示
        self : isBagEquipArrSpritesVisible( equ_p.goods_id,a)
     end
end

function CGemInlayView.isBagEquipArrSpritesVisible(self,equ_id,position_no)
    local  theEquData  = self.Equip_Data[equ_id]
    local  theSlotData = {}
    local  isEmpty     = {}
    print("isBagEquipArrSpritesVisible",equ_id,theEquData,position_no)

    if theEquData["slots_count"] ~= nil then
        loops = theEquData["slots_count"]
    else
        loops = 3
    end
    print("loops----------->>>",loops,theEquData["slots_count"])

    local ishaveBagGem = 0
    for w = 1,loops do
        local isvalue = self : isBagEquipArrSpritesCheoseGemData(theEquData,w,loops)
        if isvalue ~= 0 then --一个个孔判断
           isEmpty[w] = 0
           theEquData["theslot"..w] = theEquData["slothavegem"..isvalue]
           theSlotData         = theEquData["theslot"..w]
        else
           isEmpty[w] = 1
           theSlotData    =  theEquData["theslot"..w]
           print("theslot--->",w,theEquData["theslot"..w])

        end

        if isEmpty[w] == 1 then
            theSlotData["slot_pearl_nextlvid"] = theSlotData["slot_pearl_id"]
        end
        --是否背包有宝石
        if self.m_GemlistListData ~= nil then
            for j,v in pairs(self.m_GemlistListData) do    --查找背包宝石
                print("穷举-------------",j,v,v.goods_id,"==",theSlotData["slot_pearl_nextlvid"])
                if theSlotData["slot_pearl_nextlvid"] ~= nil and tonumber(theSlotData["slot_pearl_nextlvid"])   == tonumber(v.goods_id)then
                    ishaveBagGem = ishaveBagGem + 1 
                    break
                end
            end
        end
    end
    local  a = position_no
    print("判定要不要小箭头",a,ishaveBagGem)
    if ishaveBagGem > 0 then
        if self.BagEquipArrSprites[a] ~= nil then
            self.BagEquipArrSprites[a] : setVisible(true)
        end
    else
        if self.BagEquipArrSprites[a] ~= nil then
            self.BagEquipArrSprites[a] : setVisible( false )
        end
    end

end

function CGemInlayView.isBagEquipArrSpritesCheoseGemData(self,_theEquData,_no,_Count) --通过类型找宝石 看是否有镶嵌
    local isvalue = 0
    local Solttype =  _theEquData["slot_type".._no] --孔的类型的宝石的类型
    for i=1,_Count do
        if Solttype == _theEquData["slothavegem_type"..i] then
           isvalue = i
           break
        end
    end 
    return isvalue
end


function CGemInlayView.Create_effects_equip ( self,no,obj,name_color)
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
            if  self.effectsCCBI[no] ~= nil then
                self.effectsCCBI[no] : removeFromParentAndCleanup(true)
                self.effectsCCBI[no] = nil
            end

            self.effectsCCBI[no] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self.effectsCCBI[no] : setControlName( "this CCBI Create_effects_activity CCBI")
            self.effectsCCBI[no] : registerControlScriptHandler( animationCallFunc)
            obj                  : addChild(self.effectsCCBI[no],1000) 
        end
    end
end

function CGemInlayView.removeeffectsCCBI(self)
    for i=1,6 do
        if self.effectsCCBI[i] ~= nil then
            if self.effectsCCBI[i]  : retainCount() >= 1 then
                print("镶嵌界面关闭的时候删除 effectsCCBI",i)
                self.effectsCCBI[i] : removeChild(self.effectsCCBI[i],false)
                self.effectsCCBI[i] = nil 
            end
        end
    end

    print("累干不爱")
    if self.m_scenelayer ~= nil then
        self.m_scenelayer : removeFromParentAndCleanup(true)
        self.m_scenelayer = nil 
    end
end


function CGemInlayView.getGemDataByType(self,_type)
    --local node    = _G.Config.goodss:selectNode("goods","type_sub",tostring(_type))--通过孔类型找宝石
    local node           = _G.Config.goodss : selectSingleNode("goods[@type_sub="..tostring(_type).."]")
    local node_child     = node : children()
    local node_nextchild = node_child : get(0,"d")

    local Gemdata = {}
    Gemdata.node  = node: getAttribute("name")
    Gemdata["slot_pearl_name"]       = node: getAttribute("name")            --宝石名称
    Gemdata["slot_pearl_id"]        = tonumber(node: getAttribute("id"))    --灰宝石id

    Gemdata["slot_pearl_lv"]         = node_nextchild : getAttribute("as1")     --宝石等级
    Gemdata["slot_pearl_remark"]     = node: getAttribute("remark")          --宝石属性 如物攻+400
    Gemdata["slot_pearl_price"]      = node: getAttribute("price")           --宝石价格
    Gemdata["slot_pearl_type"]       = node: getAttribute("type_sub")        --宝石类型
    Gemdata["slot_pearl_icon"]       = node: getAttribute("icon")            --宝石图标

    -- Gemdata["slot_pearl_nextlvid"]   = node.d[1].as2        --宝石下一等级(宝石ID)
    Gemdata["slot_pearl_nextlvid"]   = node_nextchild : getAttribute("as2")        --宝石下一等级(宝石ID)
    --local nextnode = _G.Config.goodss:selectNode("goods","id",tostring(Gemdata["slot_pearl_nextlvid"]))
    local nextnode           = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(Gemdata["slot_pearl_nextlvid"]).."]")   
    local nextnode_child     = nextnode : children()
    local nextnode_nextchild = nextnode_child : get(0,"d")

    Gemdata["slot_pearl_nextlv"]          = node_nextchild : getAttribute("as1")     --下一宝石等级
    Gemdata["slot_pearl_nextremark"]      = nextnode : getAttribute("remark")        --下一等级宝石属性
    Gemdata["slot_pearl_nextremarkvalue"] = nextnode_nextchild: getAttribute("as5")  --下一等级宝石属性value
    Gemdata["slot_pearl_nexticon"]        = nextnode: getAttribute("icon")           --下一级宝石图标
    Gemdata["slot_pearl_nextname"]        = nextnode: getAttribute("name")           --下一级宝石名称

    return Gemdata
end

function CGemInlayView.getGemDataById(self,_id)
    local node           = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_id).."]") --宝石ID
    local node_child     = node : children()
    local node_nextchild = node_child : get(0,"d")
    local Gemdata = {}
    Gemdata.node  = node: getAttribute("name")  
    Gemdata["slot_pearl_name"]       = node: getAttribute("remark")            --宝石名称
    Gemdata["slot_pearl_id"]        = tonumber(node: getAttribute("id"))     --灰宝石id

    Gemdata["slot_pearl_lv"]         = node_nextchild : getAttribute("as1")        --宝石等级
    Gemdata["slot_pearl_remark"]     = node: getAttribute("remark")          --宝石属性 如物攻+400
    Gemdata["slot_pearl_price"]      = node: getAttribute("price")           --宝石价格
    Gemdata["slot_pearl_type"]       = node: getAttribute("type_sub")        --宝石类型
    Gemdata["slot_pearl_icon"]       = node: getAttribute("icon")            --宝石图标

    Gemdata["slot_pearl_nextlvid"]   = node_nextchild : getAttribute("as2")         --宝石下一等级(宝石ID)
    --local nextnode = _G.Config.goodss:selectNode("goods","id",tostring(Gemdata["slot_pearl_nextlvid"]))
    local nextnode           = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(Gemdata["slot_pearl_nextlvid"]).."]") --宝石ID
    local nextnode_child     = nextnode : children()
    local nextnode_nextchild = nextnode_child : get(0,"d")

     
    if nextnode : isEmpty() == false  then
        Gemdata["slot_pearl_nextlv"]          = nextnode_nextchild: getAttribute("as1")  --下一宝石等级
        Gemdata["slot_pearl_nextremark"]      = nextnode: getAttribute("remark")         --下一等级宝石属性
        Gemdata["slot_pearl_nextremarkvalue"] = nextnode_nextchild: getAttribute("as5")  --下一等级宝石属性value
        Gemdata["slot_pearl_nexticon"]        = nextnode: getAttribute("icon")           --下一级宝石图标
        Gemdata["slot_pearl_nextname"]        = nextnode: getAttribute("name")           --下一级宝石名称
    else
        Gemdata["slot_pearl_nextlv"]          = nil      --下一宝石等级
        Gemdata["slot_pearl_nextremark"]      = nil      --下一等级宝石属性
        Gemdata["slot_pearl_nextremarkvalue"] = nil      --下一等级宝石属性value
        Gemdata["slot_pearl_nexticon"]        = nil      --下一级宝石图标
        Gemdata["slot_pearl_nextname"]        = nil      --下一级宝石名称        
    end 
    return Gemdata
end
--更新数据表
function CGemInlayView.setReNewData_EquipmentList(self,data) --装备表
    self.ReNewData_EquipmentList = data
end
function CGemInlayView.setReNewData_GemList(self,data)       --宝石表
    self.ReNewData_GemList = data
end
function CGemInlayView.setReNewData_Gold(self,data)          --金币
    self.ReNewData_Gold = data
end
--更新函数
function CGemInlayView.update(self,_EquipmentList)

    local partnerId = tonumber(self.pushDataId) 
    if    partnerId ~= nil then
        if partnerId == 0 then
            print("还是原来的数据，还是原来的那个人")
        else
            local uid            = _G.g_LoginInfoProxy:getUid()                                            --uid
            local index          = tostring( uid..tostring( partnerId))                                    --伙伴id
            local m_roleProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
            _EquipmentList       = m_roleProperty : getEquipList()
        end
    end
    
    self : cleanViewData() --更新清空

    self.m_EquipmentListDatas = _EquipmentList

    local GemstoneList   = _G.g_GameDataProxy : getGemstoneList()  --获取宝石数据表       
    local gold           = _G.g_GameDataProxy : getGold()          --获取背包金币
    self:GetBagData(_EquipmentList,GemstoneList,gold)              --此为页面从缓存获取的初始数据

    local equ_id = nil
    for k,v in pairs(_EquipmentList) do
        print("the update index",v.index)
        if tonumber(v.index)  == tonumber(self.change_equ_index)  then
            equ_id = v.goods_id
        end
    end

    -- local id = self.transfId              --获取之前保存的装备序数
    print("ididid--529",id)
    if equ_id ~= nil and equ_id > 0 then
        self : GetPearl_comXmlData(equ_id)  --装备XML表解析
    end
end

function CGemInlayView.cleanViewData(self)
    --更新清空
    for a=1,6 do
        -- for k=1,6 do
        --     a = (i-1)*6+k
            if self.m_iconNameLabel[a] ~= nil then
                self.m_iconNameLabel[a] : removeFromParentAndCleanup(true)
                self.m_iconNameLabel[a] = nil
            end
            if  self.m_iconLvLabel[a] ~= nil then
                self.m_iconLvLabel[a]   : removeFromParentAndCleanup(true)
                self.m_iconLvLabel[a] = nil
            end
            if  self.BagEquipBtnSprites[a] ~= nil then
                self.BagEquipBtnSprites[a]  : removeFromParentAndCleanup(true)
                self.BagEquipBtnSprites[a] = nil
            end
            if self.effectsCCBI[a] ~= nil then
                if self.effectsCCBI[a]    : retainCount() >= 1 then
                    self.m_BagEquipBtn[a] : removeChild(self.effectsCCBI[a],false)
                    self.effectsCCBI[a]   = nil 
                end
            end
        -- end
    end


    if self.GemBag_layout ~= nil then
        self.GemBag_layout : removeAllChildrenWithCleanup(true)
    end

    for i=1,3 do
        -- if self.theUpgradeBtn[i] ~= nil then
        --     self.theUpgradeBtn[i] : removeAllChildrenWithCleanup(true)
         self.theUpgradeBtn[i]    = nil
        -- end

        -- if self.UpgradeGemBtn[i] ~= nil then
        --     self.UpgradeGemBtn[i] : removeAllChildrenWithCleanup(true)
        self.UpgradeGemBtn[i]    = nil
        -- end

        -- if self.unUpgradeGemBtn[i] ~= nil then
        --     self.unUpgradeGemBtn[i] : removeAllChildrenWithCleanup(true)
        --     self.unUpgradeGemBtn[i]    = nil
        -- end
    end
end
--默认第一个物品
function CGemInlayView.DefaultFirstEquip(self,_EquipmentList,_no)
    local no = nil 
    local EquipmentList = {}
    if self.GemBag_layout ~= nil then
        self.GemBag_layout : removeAllChildrenWithCleanup(true)
    end

    if _EquipmentList == nil then
        EquipmentList = self : getPartnerParams(0)--人物身上的装备 0为主将
    else
        EquipmentList = _EquipmentList
    end
    if _no == nil then
        no = 1
    else
        no = tonumber(_no)
    end

    if EquipmentList ~= nil  then
        for k,v in pairs(EquipmentList) do
            if self.TheFirstIndex[no] ==tonumber(v.index) then
                self.theFirstId = v.goods_id  --获取第一个装备id
                print("DefaultFirstEquip=",v.goods_id)
                local equipNode = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(v.goods_id).."]") --宝石ID --装备xml信息

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

    print("镶嵌默认第一个装备 551",self.theFirstId)   
    if self.theFirstId ~= nil and tonumber(self.theFirstId)  > 0 then 
        self.transfId  = self.theFirstId        --将ID传递到更新函数
        local equ_id   = self.theFirstId
        self:GetPearl_comXmlData(equ_id)        --装备XML表解析
    end
    self.theFirstId = nil
end


--mediator注册
function CGemInlayView.mediatorRegister(self)
    if _G.g_GemInlayMediator == nil then
        print("CGemInlayView.mediatorRegister")
        _G.g_GemInlayMediator = GemInlayMediator( self )
        controller :registerMediator(  _G.g_GemInlayMediator )
    end
end

----[[

function CGemInlayView.getTeamersData(self)
    local roleProperty   = _G.g_characterProperty : getMainPlay() --猪脚
    self.m_partnerconut  = roleProperty :getCount()               --猪脚的伙伴数量
    self.m_partnerid     = roleProperty :getPartner()             --伙伴ID列表
    self.m_uid           = _G.g_LoginInfoProxy:getUid()           --uid

    self.m_equiplist     = {}
    self.m_partneridList = {}
    self.m_partnerProNo  = {}
        -- self.TeamerBtnImage[w] = CSprite : create("HeadIconResources/role_head_01.jpg")
        -- self.TeamerBtn[w]      : addChild( self.TeamerBtnImage[w],-1 )   
    for i=1,4 do
        self.m_partnerProNo[i] = {}
        local _partnerid = nil 
        if i == 1 then
            _partnerid = 0
        else
            _partnerid = self.m_partnerid[i-1]
            print("伙伴列表拿到的id",_partnerid,i)
        end 
        self.m_partneridList[i] = _partnerid
        if _partnerid == 0 then
            local data   = self : getPartnerParams(0)--人物身上的装备 0为主将
            self.m_equiplist[i] = data

            local m_mainProperty             = _G.g_characterProperty :getMainPlay()
            self.m_partnerProNo[i].pro       = m_mainProperty : getPro()   --猪脚职业属性
            self.m_partnerProNo[i].partnerid = _partnerid
        else
            local index                      = tostring( self.m_uid..tostring( _partnerid))                            --伙伴id
            print("indexindex===112",index)
            self.m_roleProperty              = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER ) --伙伴信息
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
function CGemInlayView.addRoleIcon( self,_no,_EquipList,_partnerid)
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
        self.TeamerBtnImage[_no] = CButton : create("",icon_url)
        self.TeamerBtnImage[_no] : setControlName( "this is CEquipEnchantView TeamerBtnImage[_no] 906" )
        self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
        self.TeamerBtnImage[_no] : setTag(_no)
        self.TeamerBtnImage[_no] : setTouchesPriority( -100 )
        self.TeamerBtn[_no]      : addChild( self.TeamerBtnImage[_no],-1 ) 
    else
        print("self.m_partnerProNo[_no].partnerid",_partnerid) 
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]")
        local icon_url = nil 
        if node : isEmpty() == false then  
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
        self.TeamerBtnImage[_no] : setControlName( "this is CEquipEnchantView TeamerBtnImage[_no] 926" )
        self.TeamerBtnImage[_no] : registerControlScriptHandler(teamerCallBack,"CGemInlayView teamerCallBack ")
        self.TeamerBtnImage[_no] : setTag(_no)
        self.TeamerBtnImage[_no]    :setTouchesPriority( -100 )
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

function CGemInlayView.getMainPlayerIconNo(self,index)
    local mainplay = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    local m_pro    = mainplay :getPro()       --玩家职业
    return m_pro
end

function CGemInlayView.teamerCallBack(self,eventType,obj,x,y)
    _G.g_PopupView :reset()
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
        self : createCCBI(valueTag,self.m_partneridList[valueTag])

        print("换图片了")
        self.theOldSpriteBtnId = valueTag

        if   self.m_equiplist[valueTag] ~= nil  then
            print("按小伙伴按钮切换信息",self.m_partneridList[valueTag])
            self.pushDataId   = self.m_partneridList[valueTag]
            self : update(self.m_equiplist[valueTag])          --更新数据以及界面
            self : DefaultFirstEquip(self.m_equiplist[valueTag],valueTag)
            self.thepartnerId = self.m_partneridList[valueTag] --将id传递到镶嵌界面
            self.TheFirstIndexNo = tonumber(valueTag)
            print("self.pushDataId",self.pushDataId)
        end
    end 
 end
end

function CGemInlayView.createCCBI( self, _value,_partnerid)
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
            local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]")--伙伴节点
            if  node :isEmpty() == false then
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

function CGemInlayView.getPartnerParams( self, _partnerid)
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

-- function CGemInlayView.CommandChange_MAKE_PEARL_INSET( self )
--     print("11")
--     -- self : setUpgradeBtnTrueAndFalse()
--     print("221")
--     if self.oldCCBINo ~=nil then
--         local no = self.oldCCBINo
--         if self.THEccbi ~= nil then
--             if self.THEccbi  : retainCount() >= 1 then
--                 --self.unUpgradeGemBtn[no]   : removeChild(self.THEccbi,false)
--                 self.THEccbi : removeFromParentAndCleanup(true)
--                 self.THEccbi = nil 
--                 print("331")
--             end
--         end
--     end
--     print("4411")
--     local  no = self.transCCBINo   
--     if no ~= nil then
--         local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
--             if eventType == "Enter" then
--                 arg0 : play("run")
--             end
--             if eventType == "AnimationComplete" then
--                 if self.THEccbi ~= nil then
--                     if self.THEccbi  : retainCount() >= 1 then
--                         --if self.unUpgradeGemBtn[no] ~= nil then 

--                             --self.unUpgradeGemBtn[no]   : removeChild(self.THEccbi,false)
--                             self.THEccbi : removeFromParentAndCleanup(true)
--                             self.THEccbi = nil 
--                                 print("551")
--                         --end
--                     end
--                 end
--             end
--         end

--         if self.THEccbi ~= nil then
--             self.THEccbi : removeFromParentAndCleanup(true)
--             self.THEccbi = nil 
--                 print("661")
--         end
--   print("771")
--         --self.THEccbi : setPosition(-220,0)
--         if self.unUpgradeGemBtn[no] ~= nil then 
--             self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
--             print("debug.traceback", self.THEccbi, debug.traceback() )
--             self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
--             self.THEccbi : registerControlScriptHandler( animationCallFunc)
--             self.unUpgradeGemBtn[no]  : addChild(self.THEccbi,1000)
--         end
--         print("self.unUpgradeGemBtn[no]", self.unUpgradeGemBtn[no])
--         self.oldCCBINo = no
--     end
-- end

function CGemInlayView.CommandChange_MAKE_PEARL_INSET( self )
    print("镶嵌播放音效")
    self : playEffectSound() --成功特效
    print("11")
    -- self : setUpgradeBtnTrueAndFalse()
    print("221")
    if self.oldCCBINo ~=nil then
        local no = tonumber(self.oldCCBINo) 
        if self.THEccbi ~= nil then
            if self.THEccbi  : retainCount() >= 1 then
                --self.unUpgradeGemBtn[no]   : removeChild(self.THEccbi,false)
                self.THEccbi : removeFromParentAndCleanup(true)
                self.THEccbi = nil 
                print("331")
            end
        end
    end
    print("4411")
    local  no = self.transCCBINo   
    if no ~= nil then
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                arg0 : play("run")
            end
            if eventType == "AnimationComplete" then
                if self.THEccbi ~= nil then
                    if self.THEccbi  : retainCount() >= 1 then
                        --if self.unUpgradeGemBtn[no] ~= nil then 

                            --self.unUpgradeGemBtn[no]   : removeChild(self.THEccbi,false)
                            self.THEccbi : removeFromParentAndCleanup(true)
                            self.THEccbi = nil 
                                print("551")
                        --end
                    end
                end
            end
        end

        if self.THEccbi ~= nil then
            self.THEccbi : removeFromParentAndCleanup(true)
            self.THEccbi = nil 
                print("661")
        end
        print("771")
        --self.THEccbi : setPosition(-220,0)
        if self.m_BagEquipBtn[1] ~= nil then 
            self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
            print("debug.traceback", self.THEccbi, debug.traceback() )
            self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
            self.THEccbi : registerControlScriptHandler( animationCallFunc)
            --self.m_rightBackGround : addChild(self.THEccbi,1000)
            self.effectsCCBIBackGroundSprite  : addChild(self.THEccbi,1000)
            self.THEccbi : setPosition(0,0-(no-1)*185)
            --self.m_BagEquipBtn[1]  : addChild(self.THEccbi,1000)
            --self.THEccbi : setPosition(425,15-(no-1)*185)

            --self.THEccbi : setPosition(20,445-(no-1)*185)
        end
        print("self.unUpgradeGemBtn[no]", self.m_BagEquipBtn[1])
        self.oldCCBINo = no
    end
end

function CGemInlayView.playEffectSound(self) --成功特效
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
    end
end


