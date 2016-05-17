
require "view/view"

require "controller/command"
require "controller/TreasureHouseInfoViewCommand"

require "mediator/TreasureHouseMediator"
require "model/VO_TreasureHouseModel"

require "view/TreasureHouse/EquipmentManufactureLayer"
require "view/TreasureHouse/MysteriousShopLayer"
require "view/TreasureHouse/TreasureHousePopBox"


CTreasureHouseScene = class(view,function (self)

                          end)
CTreasureHouseScene.m_EquipBtnTag    = {}
CTreasureHouseScene.m_EquipBtnTag[1] = 1
CTreasureHouseScene.m_EquipBtnTag[2] = 2
CTreasureHouseScene.m_EquipBtnTag[3] = 3
CTreasureHouseScene.m_EquipBtnTag[4] = 4
CTreasureHouseScene.m_EquipBtnTag[5] = 5
CTreasureHouseScene.m_EquipBtnTag[6] = 6
CTreasureHouseScene.m_EquipBtnTag[7] = 7
CTreasureHouseScene.m_EquipBtnTag[8] = 8

CTreasureHouseScene.ShopBtnTag      = 9
CTreasureHouseScene.UpLayerBtnTag   = 10
CTreasureHouseScene.DownLayerBtnTag = 11
CTreasureHouseScene.closeBtnTag     = 12

function CTreasureHouseScene.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()

    self.scene   = CCScene :create()
    self.m_layer = CContainer :create()
    self.scene   : addChild(self.m_layer)
    self.scene   : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CTreasureHouseScene.layer(self)
    local winSize   = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CTreasureHouseScene.loadResources(self)
    print("loadResources 32")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TreasureHouseResource/TreasureHouseResource.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist") --借用两个钱的图标

    --CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("EquipmentResources/Equip.plist")
   -- CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("Joystick/keyBoardResources.plist")
    _G.Config:load("config/hidden_describe.xml")
end

function CTreasureHouseScene.unloadResources(self)
end

function CTreasureHouseScene.layout(self, winSize)  --适配布局
    if winSize.height == 640 then
      --self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)                --总底图
      -- local closeSize                  = self.CloseBtn: getContentSize()
      -- self.CloseBtn                    : setPosition(winSize.width-closeSize.width*2/3, winSize.height-closeSize.height*2/3)  --关闭按钮
      self.m_leftBackGround           : setPosition(315,285)     --左底图
      self.m_rightBackGround          : setPosition(730+2,285)     --左底图
      --self.m_partingLine              : setPosition(winSize.width/2*1.35,winSize.height/2)           --淫荡分割线
      self.EquipmentContainer         : setPosition(315,160)      --八件装备区域
      --self.ShopBtn                    : setPosition(winSize.width/2*1.1,winSize.height/2*1.8+25)        --商店按钮
      self.ExplanationLayout          : setPosition(508,460)       --珍宝阁说明
      self.ExplanationHeadSprite      : setPosition(730,530)       --珍宝阁说明     

    elseif winSize.height == 768 then
        print("768768")
    end
end

function CTreasureHouseScene.initParameter(self)
    --mediator注册
    print("CTreasureHouseScene.mediatorRegister 68")
     _G.g_CTreasureHouseMediator = CTreasureHouseMediator (self)
    controller :registerMediator(  _G.g_CTreasureHouseMediator )
 
    self : TreasureLevelSend(0)  --netwrok面板协议发送

    --获取人物Vip等级
    self.m_mainPlay_Viplv = _G.g_characterProperty : getMainPlay() : getVipLv()
    print("CLuckyLayer.initParameter 80",self.m_mainPlay_Viplv)
end

function CTreasureHouseScene.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CTreasureHouseScene.initView(self,_winSize,_layer)
    --底图
    -- self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("Equip_BackBox.png") --总底图
    -- self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    -- _layer :addChild(self.m_allBackGroundSprite) 

    self.m_leftBackGround  = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_rightBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图 

    self.m_leftBackGround     : setPreferredSize(CCSizeMake(550+8,550+8)) --420 260
    self.m_rightBackGround    : setPreferredSize(CCSizeMake(265,550+8)) --420 260

    _layer : addChild(self.m_leftBackGround)
    _layer : addChild(self.m_rightBackGround)

    local function BtnCallBack(eventType, obj, x, y)
       return self : ButtonCallBack(eventType,obj,x,y)
    end
    local function goodsTouchCallback(eventType, obj, touches)
        print("goodsTouchCallback22")
       return self : goodsTouchCallback(eventType, obj, touches)
    end
    --关闭按钮
    -- self.CloseBtn    = CButton : createWithSpriteFrameName("","Equip_CloseBtn.png")
    -- self.CloseBtn    : setTag(CTreasureHouseScene.closeBtnTag)            
    -- self.CloseBtn    : registerControlScriptHandler(BtnCallBack,"this CTreasureHouseScene CloseBtnCallBack 83")
    -- self.Scenelayer  : addChild (self.CloseBtn)
    --八件装备区域----
    self.EquipmentContainer = CContainer :create() --装备容器
    self.EquipmentContainer : setControlName("CTreasureHouseScene  EquipmentContainer 87")
    _layer                  : addChild(self.EquipmentContainer)

    self.m_EquipBtn      = {} --八件装备
    self.m_EquipPoint    = {} --八件装备的小点点
    self.m_EquipBtnLabel = {} --属性说明
    self.m_PropertySprite= {} --属性图片
    self.m_FourPropertyBackSprite = {} --四大属性区域低图
    self.LineSprite_ColorLine     = {} --线条上的实体大线
    self.BackPropertyCCBI1        = {} --属性快ccbi
    self.BackPropertyCCBI2        = {} --属性快ccbi
    self.BackPropertyCCBI3        = {} --属性快ccbi
    for i=1,8 do
        self.m_EquipBtn[i]      = CButton :createWithSpriteFrameName("","general_props_frame_normal.png")
        --self.m_EquipBtn[i]      : setVisible(false)
        self.m_EquipBtn[i]      : setTouchesMode( kCCTouchesAllAtOnce )      
        self.m_EquipBtn[i]      : registerControlScriptHandler(goodsTouchCallback,"this CTreasureHouseScene m_EquipBtn[i]CallBack 93")
        self.m_EquipBtn[i]      : setTag(CTreasureHouseScene.m_EquipBtnTag[i])
        self.EquipmentContainer : addChild(self.m_EquipBtn[i],10)

        --一个小点点
        if i%2 == 0  then
            self.m_EquipPoint[i] = CSprite : createWithSpriteFrameName("hidden_dot2.png")
        else
            self.m_EquipPoint[i] = CSprite : createWithSpriteFrameName("hidden_dot3.png")
        end
        self.m_EquipBtn[i] : addChild(self.m_EquipPoint[i])
    end
    --小点点的位置
    self.m_EquipPoint[1] : setPosition(0,-70)
    self.m_EquipPoint[2] : setPosition(-50,-50)  
    self.m_EquipPoint[3] : setPosition(-70,0)   
    self.m_EquipPoint[4] : setPosition(-50,50)
    self.m_EquipPoint[5] : setPosition(0,70)                       
    self.m_EquipPoint[6] : setPosition(50,50) 
    self.m_EquipPoint[7] : setPosition(70,0) 
    self.m_EquipPoint[8] : setPosition(50,-50) 

    self.m_EquipBtn[1] : setPosition(0,300+5)
    self.m_EquipBtn[2] : setPosition(125+5,245+5+5)  
    self.m_EquipBtn[3] : setPosition(175+5,115+5+5)   
    self.m_EquipBtn[4] : setPosition(125+5,-5-5+5)
    self.m_EquipBtn[5] : setPosition(0,-60+5)                       
    self.m_EquipBtn[6] : setPosition(-125-5,-5-5+5) 
    self.m_EquipBtn[7] : setPosition(-175-5,115+5+5) 
    self.m_EquipBtn[8] : setPosition(-125-5,245+5+5) 


    --四大属性
    self.m_EquipBtnLabel[1] = CCLabelTTF :create("智力+0","Arial",24) 
    self.m_EquipBtnLabel[3] = CCLabelTTF :create("减伤+0","Arial",24)
    self.m_EquipBtnLabel[5] = CCLabelTTF :create("武力+0","Arial",24)
    self.m_EquipBtnLabel[7] = CCLabelTTF :create("破甲+0","Arial",24)

    -- self.m_EquipBtnLabel[1] : setColor(ccc4(0,0,0,0))
    -- self.m_EquipBtnLabel[3] : setColor(ccc4(0,0,0,0))
    -- self.m_EquipBtnLabel[5] : setColor(ccc4(0,0,0,0))
    -- self.m_EquipBtnLabel[7] : setColor(ccc4(0,0,0,0))

    self.m_EquipBtnLabel[1] : setPosition(40-165,40)
    self.m_EquipBtnLabel[3] : setPosition(40+5,60+160)
    self.m_EquipBtnLabel[5] : setPosition(40+180,-10-30)
    self.m_EquipBtnLabel[7] : setPosition(40+20,60-160-120)

    self.m_EquipBtn[1] : addChild(self.m_EquipBtnLabel[1],5)
    self.m_EquipBtn[3] : addChild(self.m_EquipBtnLabel[3],5)   
    self.m_EquipBtn[5] : addChild(self.m_EquipBtnLabel[5],5)
    self.m_EquipBtn[7] : addChild(self.m_EquipBtnLabel[7],5)

    --生命进度条显示
    self.LiveValueBtn        = CButton :createWithSpriteFrameName("","transparent.png")
    self.LiveValueBtn        : setPreferredSize(CCSizeMake(110,110))
    self.LiveValueBtn        : setPosition(0,120+5)
    self.EquipmentContainer  : addChild(self.LiveValueBtn,8)

    self.LiveNameSprite      = CSprite : createWithSpriteFrameName("hidden_word_sm.png")
    self.LiveNameSprite      : setPosition (0,20)
    self.LiveValueBtn        : addChild(self.LiveNameSprite,100) 

    self.LiveHpLabel         = CCLabelTTF : create("+9527","Arial",24)
    self.LiveHpLabel         : setPosition (0,-20)
    self.LiveValueBtn        : addChild(self.LiveHpLabel,10) 

    --圆盘背景
    self.LiveValueBtnSprite  = CSprite : createWithSpriteFrameName("hidden_treasure_underframe_01.png")
    self.LiveValueBtn        : addChild(self.LiveValueBtnSprite,-2)

    --四条四分之一圆的线条
    self.LineSprite_Blue   = CSprite : createWithSpriteFrameName("hidden_underframe1.png")
    self.LineSprite_Green  = CSprite : createWithSpriteFrameName("hidden_underframe2.png")
    self.LineSprite_Yellow = CSprite : createWithSpriteFrameName("hidden_underframe3.png")
    self.LineSprite_Red    = CSprite : createWithSpriteFrameName("hidden_underframe4.png")

    self.LineSprite_Blue   : setPosition(110,110)
    self.LineSprite_Green  : setPosition(-110,110)
    self.LineSprite_Yellow : setPosition(-110,-110)
    self.LineSprite_Red    : setPosition(110,-110)

    self.LiveValueBtn : addChild(self.LineSprite_Blue,2)
    self.LiveValueBtn : addChild(self.LineSprite_Red,2)
    self.LiveValueBtn : addChild(self.LineSprite_Yellow,2)
    self.LiveValueBtn : addChild(self.LineSprite_Green,2)

    --四分之一圆的线条上的实体
    -- self.LineSprite_ColorLine[1] = CSprite : createWithSpriteFrameName("hidden_underframe1_small1.png")
    -- self.LineSprite_ColorLine[2] = CSprite : createWithSpriteFrameName("hidden_underframe1_small.png")
    -- self.LineSprite_ColorLine[3] = CSprite : createWithSpriteFrameName("hidden_underframe2_small1.png")
    -- self.LineSprite_ColorLine[4] = CSprite : createWithSpriteFrameName("hidden_underframe2_small.png")
    -- self.LineSprite_ColorLine[5] = CSprite : createWithSpriteFrameName("hidden_underframe3_small1.png")
    -- self.LineSprite_ColorLine[6] = CSprite : createWithSpriteFrameName("hidden_underframe3_small.png")
    -- self.LineSprite_ColorLine[7] = CSprite : createWithSpriteFrameName("hidden_underframe4_small1.png")
    -- self.LineSprite_ColorLine[8] = CSprite : createWithSpriteFrameName("hidden_underframe4_small.png")
    self.LineSprite_ColorLine[2] = CSprite : createWithSpriteFrameName("hidden_underframe1_small1.png")
    self.LineSprite_ColorLine[1] = CSprite : createWithSpriteFrameName("hidden_underframe1_small.png")
    self.LineSprite_ColorLine[8] = CSprite : createWithSpriteFrameName("hidden_underframe2_small1.png")
    self.LineSprite_ColorLine[7] = CSprite : createWithSpriteFrameName("hidden_underframe2_small.png")
    self.LineSprite_ColorLine[6] = CSprite : createWithSpriteFrameName("hidden_underframe3_small1.png")
    self.LineSprite_ColorLine[5] = CSprite : createWithSpriteFrameName("hidden_underframe3_small.png")
    self.LineSprite_ColorLine[4] = CSprite : createWithSpriteFrameName("hidden_underframe4_small1.png")
    self.LineSprite_ColorLine[3] = CSprite : createWithSpriteFrameName("hidden_underframe4_small.png")


    self.LineSprite_ColorLine[2] : setPosition(110+50-1,110-25-1)
    self.LineSprite_ColorLine[1] : setPosition(110-30,110+45)

    self.LineSprite_ColorLine[8] : setPosition(-110+30,110+45)
    self.LineSprite_ColorLine[7] : setPosition(-110-50,110-30)

    self.LineSprite_ColorLine[6] : setPosition(-110-50,-110+30)
    self.LineSprite_ColorLine[5] : setPosition(-110+30,-110-45)

    self.LineSprite_ColorLine[4] : setPosition(110-30,-110-50)
    self.LineSprite_ColorLine[3] : setPosition(110+50-1,-110+25)

    self.LineSprite_ColorLine[2] : setVisible(false)
    self.LineSprite_ColorLine[1] : setVisible(false)
    self.LineSprite_ColorLine[8] : setVisible(false)
    self.LineSprite_ColorLine[7] : setVisible(false)
    self.LineSprite_ColorLine[6] : setVisible(false)
    self.LineSprite_ColorLine[5] : setVisible(false)
    self.LineSprite_ColorLine[4] : setVisible(false)
    self.LineSprite_ColorLine[3] : setVisible(false)

    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[1],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[2],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[3],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[4],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[5],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[6],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[7],3)
    self.LiveValueBtn : addChild(self.LineSprite_ColorLine[8],3)

    --四大底图
    for i=1,4 do
        local icon = "hidden_underframe_new"..i..".png" 
       self.m_FourPropertyBackSprite[i] = CSprite : createWithSpriteFrameName(icon) 
       self.m_FourPropertyBackSprite[i] : setGray(true)
       self.LiveValueBtn  : addChild(self.m_FourPropertyBackSprite[i],-3)
    end
    local PositionValue = 137+2
    self.m_FourPropertyBackSprite[1]  : setPosition(PositionValue-1,PositionValue) 
    self.m_FourPropertyBackSprite[2]  : setPosition(-PositionValue+1,PositionValue) 
    self.m_FourPropertyBackSprite[3]  : setPosition(-PositionValue+1,-PositionValue) 
    self.m_FourPropertyBackSprite[4]  : setPosition(PositionValue-1,-PositionValue) 

    -- self.hidden_arrowSprite = {}
    -- for i=1,4 do
    --     self.hidden_arrowSprite[i] = CSprite : createWithSpriteFrameName("hidden_arrow_red.png")
    --     --self.hidden_arrowSprite[i] : setVisible(false)
    --     self.LiveValueBtn          : addChild(self.hidden_arrowSprite[i],-3)
    -- end
    -- self.hidden_arrowSprite[1] : setPosition(170,170)
    -- self.hidden_arrowSprite[2] : setPosition(170,-170)
    -- self.hidden_arrowSprite[3] : setPosition(-170,-170)
    -- self.hidden_arrowSprite[4] : setPosition(-170,170)

    -- self.hidden_arrowSprite[1] : setRotation(90)
    -- self.hidden_arrowSprite[2] : setRotation(180)
    -- self.hidden_arrowSprite[3] : setRotation(270)


    --商店button
    -- self.ShopBtn = CButton :createWithSpriteFrameName("前往小日百货","general_button_normal.png")
    -- self.ShopBtn : registerControlScriptHandler(BtnCallBack,"this CTreasureHouseScene ShopBtnCallBack 131")
    -- self.ShopBtn : setTag(CTreasureHouseScene.ShopBtnTag)
    -- _layer : addChild(self.ShopBtn)
    --当前层数
    self.m_layerNoBtn = CButton :createWithSpriteFrameName("2","hidden_pagination_underframe.png")
    self.m_layerNoBtn : setFontSize(18)
    self.m_layerNoBtn : setPosition(80+240-5,40-5)
    _layer            : addChild(self.m_layerNoBtn)
    --分割线--------------------------------------------------------------------------------------
    -- self.m_partingLine   = CSprite : createWithSpriteFrameName("Equip_BackSecondBox.png") --分割线
    -- self.m_partingLine   : setScaleY(18)
    -- self.m_partingLine   : setScaleX(0.6)
    -- _layer :addChild(self.m_partingLine)    

    --layout
    self.ExplanationLayout = CHorizontalLayout : create()
    self.ExplanationLayout : setLineNodeSum(1)
    self.ExplanationLayout : setVerticalDirection(false)
    self.ExplanationLayout : setCellSize(CCSizeMake(200,80))
    _layer : addChild(self.ExplanationLayout)
    self.ExplanationHeadSprite = CSprite : createWithSpriteFrameName("hidden_word_zbgsm.png")
    _layer                     : addChild(self.ExplanationHeadSprite)
    self.ExplanationLabel = {} --1条条藏宝阁说明
    for i=1,8 do
        self.ExplanationLabel[i] = CCLabelTTF :create("","Arial",18) 
        self.ExplanationLabel[i] : setAnchorPoint( ccp(0.0, 0.5)) 
        self.ExplanationLabel[i] : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐
        self.ExplanationLayout   : addChild(self.ExplanationLabel[i])
    end

    --上一层按钮
    self.UpLayerBtn = CButton :createWithSpriteFrameName("上一层","general_button_normal.png")
    self.UpLayerBtn : setFontSize(24)
    self.UpLayerBtn : registerControlScriptHandler(BtnCallBack,"this CTreasureHouseScene UpLayerBtnCallBack 166")
    self.UpLayerBtn : setTag(CTreasureHouseScene.UpLayerBtnTag)
    self.UpLayerBtn : setPosition(665,50)
    _layer : addChild(self.UpLayerBtn)

    --下一层按钮
    self.DownLayerBtn = CButton :createWithSpriteFrameName("下一层","general_button_normal.png")
    self.DownLayerBtn : setFontSize(24)
    self.DownLayerBtn : registerControlScriptHandler(BtnCallBack,"this CTreasureHouseScene DownLayerBtnCallBack 172")
    self.DownLayerBtn : setTag(CTreasureHouseScene.DownLayerBtnTag)
    self.DownLayerBtn : setPosition(795,50)
    _layer : addChild(self.DownLayerBtn)
end

function CTreasureHouseScene.ButtonCallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        print("ButtonCallBack tagvalue= ",tagvalue)
        local winSize = CCDirector:sharedDirector():getVisibleSize()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if tagvalue == CTreasureHouseScene.closeBtnTag  then
                print("关闭按钮回调")
                if _G.g_CTreasureHouseMediator ~= nil then
                    controller : unregisterMediator(_G.g_CTreasureHouseMediator)
                    _G.g_CTreasureHouseMediator = nil
                end
                CCDirector : sharedDirector () : popScene()
                self : unloadResources()
                return
            elseif tagvalue == CTreasureHouseScene.ShopBtnTag  then 
                print("商店按钮回调")
                self.ShopLayer = CMysteriousShopLayer : layer(winSize)
                self.Scenelayer : addChild(self.ShopLayer)

            elseif tagvalue == CTreasureHouseScene.UpLayerBtnTag  then 
                print("上一层按钮回调")
                local golevel = 0 
                print("self.TreasureLevel=",self.TreasureLevel)
                golevel = self.TreasureLevel - 1  
                if golevel ~= nil and golevel > 0 then
                   golevelId = golevel*100 + 1
                   print("上一层的层ID=",golevelId)
                   self : TreasureLevelSend(golevelId)
                else
                    local msg = "没有上一层"
                    self : createMessageBox(msg)
                end

            elseif tagvalue == CTreasureHouseScene.DownLayerBtnTag  then 
                print("下一层按钮回调")

                if self.is_OKtoNextLevel == 4 then
                    -- local golevel = 0
                    -- print("self.TreasureLevel=",self.TreasureLevel)
                    -- golevel = self.TreasureLevel + 1 
                    -- if golevel ~= nil and golevel < 10 then
                    --    golevelId = golevel*100 + 1
                    --    print("下一层的层ID=",golevelId)
                    --    self : TreasureLevelSend(golevelId)
                    -- end

                    if self.m_NowLevel ~= nil then
                        local nextLevel  = self.m_NowLevel + 1
                        if  nextLevel <= 6 then
                            self : isNextLevelOKtoGo(nextLevel)
                        end
                    end
                else
                    local msg = "当前层道具未全部激活"
                    self : createMessageBox(msg)
                end
            end

            -- for i=1,8 do
            --     if tagvalue == CTreasureHouseScene.m_EquipBtnTag[i] then
            --         print("八装备中第"..i.."件回调")
            --         if self.EquipListData ~= nil then 
            --             local state = tonumber(self.EquipListData[i].state)
            --             if state ~= nil and  state == 0 then
            --                 self : TransmissionGoodData( i,winSize ) --单个物品数据传输到制作界面
            --             elseif state ~= nil and state == 1 then
            --             end
            --         end 
            --     end
            -- end
        end
    end
end

function CTreasureHouseScene.goodsTouchCallback(self, eventType, obj, touches)
    print("goodsTouchCallback33")
    if eventType == "TouchesBegan" then
        --删除Tips
        --_G.g_PopupView :reset()
        if self.temp ~= nil then
            self.temp : removeFromParentAndCleanup(true)
            self.temp = nil 
        end 
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID1     = touch :getID()
                self.goodstag1    = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID1 == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID1 and self.goodstag1 == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    local tag = obj:getTag()

                    for i=1,8 do
                        if tag == CTreasureHouseScene.m_EquipBtnTag[i] then
                            print("八装备中第"..i.."件回调")
                            if self.EquipListData ~= nil then 
                                local state = tonumber(self.EquipListData[i].state)
                                local id    = self.EquipListData[i].id
                                if state ~= nil and  state == 0 then
                                    self : TransmissionGoodData( i,winSize ) --单个物品数据传输到制作界面
                                elseif state ~= nil and state == 1 then
                                    ---------------------------------------
                                    local _position = {}
                                    _position.x = touch2Point.x-245-80 ---240 -45,-590
                                    _position.y = touch2Point.y---590+60 --+15

                                    self.temp = nil 
                                    --temp        = _G.g_PopupView :createByGoodsId( id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position,0,nil,true )  
                                    self.temp   = CTreasureHousePopBox : create( id, _position)  
                                    if self.temp ~= nil then
                                        self.Scenelayer : addChild( self.temp )
                                    end 
                                end
                            end 
                        end
                    end

                    self.touchID1    = nil
                    self.goodstag1   = nil
                end
            end
        end
        print( eventType,"END")
    end
end


function CTreasureHouseScene.isNextLevelOKtoGo(self,nextLevel) 
    local mainplay = _G.g_characterProperty :getOneByUid( 0, _G.Constant.CONST_PARTNER)
    local m_lv     = tonumber(mainplay :getLv()) 
    local isok     = 0 
    local msg = ""
    print("m_lvm_lv=",m_lv,nextLevel)
    if nextLevel == 2 then
        msg = "珍宝阁第二层开发等级为".._G.Constant.CONST_TREASURE_OPEN_SECOND.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_SECOND then
            isok     = 1
            print("可以进入到第二层00000")
        end
    elseif nextLevel == 3 then
        msg = "珍宝阁第三层开发等级为".._G.Constant.CONST_TREASURE_OPEN_THIRD.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_THIRD then
            isok     = 1
        end
    elseif nextLevel == 4 then
        msg = "珍宝阁第四层开发等级为".._G.Constant.CONST_TREASURE_OPEN_FOUR.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_FOUR then
            isok     = 1
            print("可以进到第四层000")
        end
    elseif nextLevel == 5 then
        msg = "珍宝阁第五层开发等级为".._G.Constant.CONST_TREASURE_OPEN_FIVE.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_FIVE then
            isok     = 1
        end
    elseif nextLevel == 6 then
        msg = "珍宝阁第六层开发等级为".._G.Constant.CONST_TREASURE_OPEN_SIX.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_SIX then
            isok     = 1
        end
    elseif nextLevel == 7 then
        msg = "珍宝阁第七层开发等级为".._G.Constant.CONST_TREASURE_OPEN_SEVEN.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_SEVEN then
            isok     = 1
        end
    elseif nextLevel == 8 then
        msg = "珍宝阁第八层开发等级为".._G.Constant.CONST_TREASURE_OPEN_EIGHT.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_EIGHT then
            isok     = 1
        end
    elseif nextLevel == 9 then
        msg = "珍宝阁第九层开发等级为".._G.Constant.CONST_TREASURE_OPEN_NIGHT.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_NIGHT then
            isok     = 1
        end
    elseif nextLevel == 10 then
        msg = "珍宝阁第十层开发等级为".._G.Constant.CONST_TREASURE_OPEN_TEN.."级"
        if m_lv >= _G.Constant.CONST_TREASURE_OPEN_TEN then
            isok     = 1
        end
    elseif nextLevel > 10 then
        msg = "此为珍宝阁最后一层"
        -- if m_lv >= _G.Constant.CONST_TREASURE_OPEN_SIX+10 then
            isok     = 1
        -- end
    end

    if isok == 0 then
        self : createMessageBox(msg)
    elseif isok == 1 then
        local golevel = 0
        print("self.TreasureLevel=",self.TreasureLevel)
        golevel = self.TreasureLevel + 1 
        if golevel ~= nil and golevel < 10 then
           golevelId = golevel*100 + 1
           print("下一层的层ID=",golevelId)
           self : TreasureLevelSend(golevelId)
        end
    end

end

--藏宝阁面板数据协议发送请求
function CTreasureHouseScene.TreasureLevelSend(self,_levelid) 
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_TREASURE_LEVEL_ID" 
    local msg = REQ_TREASURE_LEVEL_ID()
    msg :setLevelId(_levelid)
    CNetwork : send(msg)
    print("CTreasureHouseScene页面发送数据请求,完毕 253")
end

--单个物品数据传输到制作界面
function CTreasureHouseScene.TransmissionGoodData(self,_i,_winSize) 

    local  transmissionGood  = self.EquipListData[_i]                                   --选中物品
    print("TransmissionGoodData==",transmissionGood.name)
    if transmissionGood ~= nil then
        local Layer = CEquipmentManufactureLayer() : layer()
        --local scene = Layer:scene()
        --CCDirector : sharedDirector () : pushScene(scene)
        Layer           : setPosition(165,0)
        self.Scenelayer : addChild(Layer)

        if transmissionGood ~= nil then
            local command = CTreasureHouseInfoViewCommand(2,transmissionGood)
            controller    : sendCommand( command)
            -- self.EquipmentLayer      = CEquipmentManufactureLayer : layer(_winSize,transmissionGood) --制作界面初始化
            -- self.Scenelayer          : addChild(self.EquipmentLayer)        
        else
            print("要传过去的物品拿不到数据")
        end
        --local EquipmentLayer      = Layer : scene(_winSize,transmissionGood) --制作界面初始化
        --Layer : pushData(transmissionGood)
        --self.Scenelayer : addChild(EquipmentLayer)
    else

    end 

    -- --发送命令的方法
    -- if transmissionGood ~= nil then
    --     local command = CTreasureHouseInfoViewCommand(2,transmissionGood)
    --     controller    : sendCommand( command)
    --     -- self.EquipmentLayer      = CEquipmentManufactureLayer : layer(_winSize,transmissionGood) --制作界面初始化
    --     -- self.Scenelayer          : addChild(self.EquipmentLayer)        
    -- else
    --     print("要传过去的物品拿不到数据")
    -- end
end

--mediator传送过来的数据（同时也是初始化）
function CTreasureHouseScene.pushData(self,_LevelId,_Level,_GoodsData,_Count)   
    self : removeIconResources()               --资源释放
    self : setAllEquipBtnTouchesEnabledFalse() --设置八个所有装备不可按
    self : RemoveAllCCBI() --关闭前删除所有ccbi

    --self : resetEquipPoint() --重置小点点的状态
    self.TreasureLevel = 0
    local Level        = _Level
    self.TreasureLevel = Level --用于上下层
    local Count        = _Count   
    local GoodsData    = _GoodsData  --八个物品表（sever）
    --八个装备
    self.EquipListData  = {}
    self.OneGoodsSprite = {}
    if GoodsData ~= nil then 
        for k,v in pairs(GoodsData) do
            print("八件装备-----",k,v.goods_id,v.state)
            self.EquipListData[k] = {}
            self.EquipListData[k] = self : OneGoodsXmlData (v.goods_id,v.state,_LevelId)  -- 层次的物品xml(id,物品状态)

            local  OneGoods = self : OneGoodsXmlData (v.goods_id,v.state,_LevelId)        --单个物品xml解析
            self : initOneEquipmentParameter (k,OneGoods)                                 --单个物品view初始化

            --小点点变亮
            if tonumber(v.state) == 1 then
                
                if k % 2 == 0 then
                    print("正的点亮",k)
                    self.m_EquipPoint[k] :  setImageWithSpriteFrameName( "hidden_dot4.png" )
                else
                    print("斜的的点亮",k)
                    self.m_EquipPoint[k] :  setImageWithSpriteFrameName( "hidden_dot1.png" )
                end

                self.LineSprite_ColorLine[k] : setVisible(true)
            else
                if k % 2 == 0 then
                    print("正的点亮",k)
                    self.m_EquipPoint[k] :  setImageWithSpriteFrameName( "hidden_dot2.png" )
                else
                    print("斜的的点亮",k)
                    self.m_EquipPoint[k] :  setImageWithSpriteFrameName( "hidden_dot3.png" )
                end
                self.LineSprite_ColorLine[k] : setVisible(false)
            end
        end

        --当前合成到的那个装备
        for k,v in pairs(GoodsData) do
            if tonumber(v.state) == 0 then
                self.m_EquipBtn[k]     : setTouchesEnabled (true)
                self : Create_effects_equip(self.m_EquipBtn[k],1,nil)  --当前制作的装备ccbi
                break
            end
        end
    end

    --四个属性图片
    self : createFourPropertySprite(self.EquipListData)

    -- self.m_PropertySprite[1] : setImageWithSpriteFrameName("hidden_word_"..self.EquipListData[1].attr_type..".png")
    -- self.m_PropertySprite[3] : setImageWithSpriteFrameName("hidden_word_"..self.EquipListData[3].attr_type..".png")
    -- self.m_PropertySprite[5] : setImageWithSpriteFrameName("hidden_word_"..self.EquipListData[5].attr_type..".png")
    -- self.m_PropertySprite[7] : setImageWithSpriteFrameName("hidden_word_"..self.EquipListData[7].attr_type..".png")
    --四个属性值
    local attrName1 = "+"..self.EquipListData[1].attr
    local attrName3 = "+"..self.EquipListData[3].attr
    local attrName5 = "+"..self.EquipListData[5].attr
    local attrName7 = "+"..self.EquipListData[7].attr

    self.m_EquipBtnLabel[1] : setString(attrName1)
    self.m_EquipBtnLabel[3] : setString(attrName3)
    self.m_EquipBtnLabel[5] : setString(attrName5)
    self.m_EquipBtnLabel[7] : setString(attrName7)

    local percents = 0
    local addpart1 = self : changeColor(7,8,1)
    local addpart2 = self : changeColor(1,2,3)
    local addpart3 = self : changeColor(3,4,5)
    local addpart4 = self : changeColor(5,6,7)
    percents       = addpart1 + addpart2 + addpart3 + addpart4

    self.is_OKtoNextLevel = 0 

    --1个中间球
    local liveHp =  self.EquipListData[1].hp
    --local liveHp =  self.EquipListData[1].hp * 0.25 * percents
    self.LiveHpLabel : setString("+"..liveHp)
    -- if percents ~= 0 then 
        self : chooseLiveValueSprite (percents)
        self.is_OKtoNextLevel = percents  --去下一层的判断
    -- end

    self.m_layerNoBtn : setText(tostring(Level))    --层数
    self.m_NowLevel   = tonumber(Level)

    if self.m_NowLevel ~= nil and self.m_NowLevel == 1 then
        self.UpLayerBtn : setTouchesEnabled (false)
    else
        self.UpLayerBtn : setTouchesEnabled (true)
    end

    if self.m_NowLevel ~= nil and self.m_NowLevel == _G.Constant.CONST_TREASURE_OPEN_MAX_LEVEL then
        self.DownLayerBtn : setTouchesEnabled (false)
    else
        self.DownLayerBtn : setTouchesEnabled (true)
    end

    --箭头显示判断
    --self : changeArrowVisible (addpart1,addpart2,addpart3,addpart4)
    --底图（圆形）切换判断
    -- if percents == 4 then
    --     self.LiveValueBtnSprite : setImageWithSpriteFrameName( "hidden_treasure_underframe_02.png" )
    -- else
    --     self.LiveValueBtnSprite : setImageWithSpriteFrameName( "hidden_treasure_underframe_01.png" )
    -- end
    --珍宝贝阁说明
    self.ExplanationLabel[1] : setString("1.收集材料与合成卷轴\n可进行珍宝合成。")    
    self.ExplanationLabel[2] : setString("2.点击相应珍宝可查看\n合成该珍宝所需材料和卷轴。")
    self.ExplanationLabel[3] : setString("3.收集圆盘上相同颜色上三个\n珍宝可增加相应属性。")
    self.ExplanationLabel[4] : setString("4.当层珍宝收集满且达到等级后\n自动开启下一层珍宝。")
    self.ExplanationLabel[5] : setString("5.VIP6以上开启一键制作功能\n可使用钻石替代材料。")
end

function CTreasureHouseScene.setAllEquipBtnTouchesEnabledFalse( self ) --设置八个所有装备不可按
    for i=1,8 do
        self.m_EquipBtn[i]  : setTouchesEnabled(false)
    end
end

function CTreasureHouseScene.getTheRealNo( self,_no)  --获取属性块背景的序号
    local reealNo = nil 
    if _no~= nil then
        if _no == 1 then
               reealNo = 2 
        elseif _no == 3 then
               reealNo = 1 
        elseif _no == 5 then
               reealNo = 4 
        elseif _no == 7 then
               reealNo = 3 
        end
    end

    return reealNo
end


function CTreasureHouseScene.createFourPropertySprite( self ,_data) --四个属性图片
    if _data ~= nil then
        for i=1,4 do
            if self.m_PropertySprite[i] ~= nil then
                self.m_PropertySprite[i] : removeFromParentAndCleanup(true)
                self.m_PropertySprite[i] = nil 
            end
        end
        print("----->>>34343434343",_data[1].attr_type,_data[3].attr_type,_data[5].attr_type,_data[7].attr_type)
        self.m_PropertySprite[1] = CSprite : createWithSpriteFrameName("hidden_word_".._data[1].attr_type..".png")
        self.m_PropertySprite[2] = CSprite : createWithSpriteFrameName("hidden_word_".._data[3].attr_type..".png")
        self.m_PropertySprite[3] = CSprite : createWithSpriteFrameName("hidden_word_".._data[5].attr_type..".png")
        self.m_PropertySprite[4] = CSprite : createWithSpriteFrameName("hidden_word_".._data[7].attr_type..".png")

        self.m_EquipBtn[1] : addChild(self.m_PropertySprite[1],5)
        self.m_EquipBtn[3] : addChild(self.m_PropertySprite[2],5)   
        self.m_EquipBtn[5] : addChild(self.m_PropertySprite[3],5)
        self.m_EquipBtn[7] : addChild(self.m_PropertySprite[4],5)

        self.m_PropertySprite[1] : setPosition(-210,40)
        self.m_PropertySprite[2] : setPosition(-40,220)
        self.m_PropertySprite[3] : setPosition(140,-40)
        self.m_PropertySprite[4] : setPosition(-40+15,-220)
    end
end

--小点点重置
function CTreasureHouseScene.resetEquipPoint( self )
    if self.m_EquipPoint ~= nil then
        for i=1,8 do
            if i%2 == 0  then
                print("重置为原始 正",i)
                self.m_EquipPoint[i] = CSprite : createWithSpriteFrameName("hidden_dot2.png")
            else
                print("重置为原始 邪",i)
                self.m_EquipPoint[i] = CSprite : createWithSpriteFrameName("hidden_dot3.png")
            end 

            self.LineSprite_ColorLine[i] : setVisible(false)
        end
    end
end

--判断箭头显示
function CTreasureHouseScene.changeArrowVisible(self,_no4,_no1,_no2,_no3) 
    -- if _no1 == 1 then
    --     self.hidden_arrowSprite[1] : setVisible(true)
    -- else 
    --     self.hidden_arrowSprite[1] : setVisible(false)
    -- end
    -- if _no2 == 1 then
    --     self.hidden_arrowSprite[2] : setVisible(true)
    -- else
    --     self.hidden_arrowSprite[2] : setVisible(false)
    -- end
    -- if _no3 == 1 then
    --     self.hidden_arrowSprite[3] : setVisible(true)
    -- else
    --     self.hidden_arrowSprite[3] : setVisible(false)
    -- end
    -- if _no4 == 1 then
    --     self.hidden_arrowSprite[4] : setVisible(true)
    -- else
    --     self.hidden_arrowSprite[4] : setVisible(false)
    -- end
end

--判断四个属性是否高亮
function CTreasureHouseScene.changeColor(self,num1,num2,num3)  

    if self.EquipListData[num1].state == 1 and  self.EquipListData[num2].state == 1 and self.EquipListData[num3].state == 1 then
        self.m_EquipBtnLabel[num3] : setColor(ccc4(255,255,255,255))

        local realNo = self :  getTheRealNo(num3)              --获得属性快的真正序号
        self.m_FourPropertyBackSprite[realNo] : setGray(false) --属性快高亮

        self : Create_effects_equip(self.m_FourPropertyBackSprite[realNo],2,realNo)  --属性快ccbi
        
        return 1
    else 
        self.m_EquipBtnLabel[num3] : setColor(ccc4(150,150,150,150))

        local realNo = self :  getTheRealNo(num3)             --获得属性快的真正序号
        self.m_FourPropertyBackSprite[realNo] : setGray(true) --属性快高亮

        return 0
    end
end
--判断中间球百分比所用图片
function CTreasureHouseScene.chooseLiveValueSprite(self,_percents)  
    if  self.LiveValueSprite ~= nil then
        self.LiveValueSprite : removeFromParentAndCleanup(true)
        self.LiveValueSprite = nil 
    end
    print("_percents_percents",_percents)
    if _percents == 0 then
         if  self.LiveValueSprite ~= nil then
            self.LiveValueSprite : removeFromParentAndCleanup(true)
            self.LiveValueSprite = nil 
        end        
    elseif _percents == 1 then
        self.LiveValueSprite = CSprite : createWithSpriteFrameName ("hidden_hp.png",CCRectMake( 0, 0, 120 , 90))
        self.LiveValueSprite : setPreferredSize(CCSizeMake(120,30))
        self.LiveValueSprite : setPosition(-2,-45)
    elseif _percents == 2 then
        self.LiveValueSprite = CSprite : createWithSpriteFrameName ("hidden_hp.png",CCRectMake( 0, 0, 120 , 60))
        self.LiveValueSprite : setPreferredSize(CCSizeMake(120,60))
        self.LiveValueSprite : setPosition(-2,-30)
    elseif _percents == 3 then
        self.LiveValueSprite = CSprite : createWithSpriteFrameName ("hidden_hp.png",CCRectMake( 0, 0, 120 , 30))
        self.LiveValueSprite : setPreferredSize(CCSizeMake(120,90))
        self.LiveValueSprite : setPosition(-2,-15)
    elseif _percents == 4 then
        self.LiveValueSprite = CSprite : createWithSpriteFrameName ("hidden_hp.png")
        --self.LiveValueSprite : setPreferredSize(CCSizeMake(120,120))
    end
    if self.LiveValueSprite ~= nil then
        self.LiveValueBtn        : addChild(self.LiveValueSprite,2)
    end
end
--单个物品xml解析
function CTreasureHouseScene.OneGoodsXmlData(self,_equipId,_state,_LevelId) 
    print("228 OneEquipmentXmlData,id=",_equipId,"_state = ",_state)
    local OneEquipNode     = _G.Config.hiddens : selectSingleNode("hidden[@id="..tostring(_equipId).."]")
    local OneEquipData     = {}
    OneEquipData.level     = OneEquipNode: getAttribute("level")    
    OneEquipData.id        = OneEquipNode: getAttribute("id")
    OneEquipData.name      = OneEquipNode: getAttribute("name")
    OneEquipData.icon      = OneEquipNode: getAttribute("icon")
    OneEquipData.attr_type = OneEquipNode: getAttribute("attr_type") 
    OneEquipData.attr      = OneEquipNode: getAttribute("attr")     
    OneEquipData.hp        = OneEquipNode: getAttribute("hp")
    OneEquipData.describe  = OneEquipNode: getAttribute("describe")

    OneEquipData.levelid   = _LevelId --物品所在楼层的层ID（sever）

    if _state ~= nil then 
        OneEquipData.state  = _state --物品状态(sever) 
    else 
        OneEquipData.state  = 0 
    end

    if OneEquipData.attr_type ~= nil or OneEquipNode.attr_type > 0 then 
        local attr_type_id          = "goodss_goods_base_types_base_type_type"..OneEquipData.attr_type                --拼接属性名称ID
        local attr_type_name        =  CLanguageManager:sharedLanguageManager():getString(tostring(attr_type_id))     --属性名称名字
        OneEquipData.attr_type_name = attr_type_name
        print("OneEquipData.attr_type_name====",OneEquipData.attr_type_name,attr_type_name)
    end  
    
    return OneEquipData
end
--单个物品view初始化
function CTreasureHouseScene.initOneEquipmentParameter(self,_no,_OneGoodsData) 

    -- if self.OneGoodsSprite[_no] ~= nil then
    --     self.OneGoodsSprite[_no] : removeFromParentAndCleanup(true)
    --     self.OneGoodsSprite[_no] = nil
    -- end

    local OneGoodsData       = _OneGoodsData 
    local icon_url           = "Icon/i"..OneGoodsData.icon..".jpg"
    self.OneGoodsSprite[_no] = CSprite : create(icon_url)
    if OneGoodsData.state  == 0 then  --状态判断 未合成则为灰
        self.OneGoodsSprite[_no] : setGray( true )
        --self.m_EquipBtn[_no]     : setTouchesEnabled (true)
    elseif OneGoodsData.state == 1 then
        self.m_EquipBtn[_no]     : setTouchesEnabled (true)
        --self.m_EquipBtn[_no]     : setTouchesEnabled (false)
    end             
    self.m_EquipBtn[_no]    : addChild(self.OneGoodsSprite[_no],-2)
end

function CTreasureHouseScene.TriggerPropertyAdd(self,_Goodid,_State)
    local  Goodid  = _Goodid
    local  State   = _State
    print("TriggerPropertyAdd 417 =",Goodid,State)

    for i,v in ipairs(self.EquipListData) do
        print("--->",i,v.id)
        if tonumber(v.id ) == Goodid then
            if State == true then
                self.OneGoodsSprite[i] : setGray( false )
                self.m_EquipBtn[i]     : setTouchesEnabled (true)
                --self.m_EquipBtn[i]     : setTouchesEnabled (false)
                print("TriggerPropertyAdd 里面进来了 ",i)
            end
            break 
        end
    end
end

function CTreasureHouseScene.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end


function CTreasureHouseScene.removeIconResources(self)
    if self.EquipListData ~= nil then
        local count = #self.EquipListData
        for i=1,count do
            if self.OneGoodsSprite[i] ~= nil then
                self.OneGoodsSprite[i] : removeFromParentAndCleanup(true)
                self.OneGoodsSprite[i] = nil
            end
            local icon_url = "Icon/i"..self.EquipListData[i].icon..".jpg"
            print("好多icon",icon_url)
            local r = CCTextureCache :sharedTextureCache():textureForKey(icon_url)
            if r ~= nil then
                CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
                CCTextureCache :sharedTextureCache():removeUnusedTextures(r)
                --CCTextureCache :sharedTextureCache():removeTexture(r)
                r = nil
            end
        end
    end
end


function CTreasureHouseScene.Create_effects_equip ( self,obj,_type,_no) --当前制作的装备ccbi _type==1 当前装备的ccbi ， _type = 2 为背景块的特效

    print("当前制作的装备ccbi添加")
    local function animationCallFunction( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end

    if obj ~= nil then
        if _type == 1 then
            if  self.NoweffectsCCBI ~= nil then
                self.NoweffectsCCBI : removeFromParentAndCleanup(true)
                self.NoweffectsCCBI = nil
            end

            self.NoweffectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_hidden5.ccbi" )
            self.NoweffectsCCBI : setControlName( "this CCBI NoweffectsCCBI CCBI")
            self.NoweffectsCCBI : registerControlScriptHandler( animationCallFunction)
            obj                 : addChild(self.NoweffectsCCBI,1000)
        elseif _type == 2 then
            for i=1,3 do

                if  self["BackPropertyCCBI"..i][_no] ~= nil then
                    self["BackPropertyCCBI"..i][_no] : removeFromParentAndCleanup(true)
                    self["BackPropertyCCBI"..i][_no] = nil
                end
                self["BackPropertyCCBI"..i][_no] = CMovieClip:create( "CharacterMovieClip/effects_hidden4.ccbi" )
                self["BackPropertyCCBI"..i][_no] : setControlName( "this CCBI NoweffectsCCBI CCBI")
                self["BackPropertyCCBI"..i][_no] : registerControlScriptHandler( animationCallFunction)
                obj                            : addChild(self["BackPropertyCCBI"..i][_no] ,10)
            end  

            if _no == 1 or _no == 4 then
                self["BackPropertyCCBI"..1][_no] : setPosition(0,0)
                self["BackPropertyCCBI"..2][_no] : setPosition(0,130)
                self["BackPropertyCCBI"..3][_no] : setPosition(90,70)
            end
            if _no == 2 or _no == 3 then
                self["BackPropertyCCBI"..1][_no] : setPosition(0,0)
                self["BackPropertyCCBI"..2][_no] : setPosition(0,130)
                self["BackPropertyCCBI"..3][_no] : setPosition(-90,70)
            end



        end

    end
end

function CTreasureHouseScene.RemoveAllCCBI ( self) --关闭前删除所有ccbi
    print("在自动寻路的时候发来的删除所有ccbi")
    if  self.NoweffectsCCBI ~= nil then
        self.NoweffectsCCBI : removeFromParentAndCleanup(true)
        self.NoweffectsCCBI = nil
    end

    for i=1,4 do
        for k=1,3 do
            if  self["BackPropertyCCBI"..k][i] ~= nil then
                self["BackPropertyCCBI"..k][i] : removeFromParentAndCleanup(true)
                self["BackPropertyCCBI"..k][i] = nil
            end
        end
    end
end



