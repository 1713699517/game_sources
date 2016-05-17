
require "controller/command"
require "controller/TreasureHouseInfoViewCommand"
require "view/view"

require "mediator/EquipmentManufactureMediator"

require "view/TreasureHouse/MysteriousShopLayer"

require "common/protocol/auto/REQ_TREASURE_GOODS_ID" 
require "common/protocol/auto/REQ_TREASURE_GOODS_ID" --制作协议发送

--require "view/LuckyLayer/PopBox"
CEquipmentManufactureLayer = class(view,function (self)
                            self.AllNeedMaterialMoney = nil 
                          end)

CEquipmentManufactureLayer.MaterialBtnTag         ={}
CEquipmentManufactureLayer.MaterialBtnTag[1]      = 1
CEquipmentManufactureLayer.MaterialBtnTag[2]      = 2
CEquipmentManufactureLayer.MaterialBtnTag[3]      = 3
CEquipmentManufactureLayer.MaterialBtnTag[4]      = 4
CEquipmentManufactureLayer.MaterialBtnTag[5]      = 5
CEquipmentManufactureLayer.MaterialBtnTag[6]      = 6

CEquipmentManufactureLayer.OneManufactureBtnTag   = 7
CEquipmentManufactureLayer.ManufactureBtnTag      = 8
CEquipmentManufactureLayer.closeBtnTag            = 9

function CEquipmentManufactureLayer.scene(self,_transmissionGood)
    self.OneGoodData =  _transmissionGood  --传递过来选中的物品
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CEquipmentManufactureLayer.layer(self,_winSize,_transmissionGood)

    --self.OneGoodData =  _transmissionGood  --传递过来选中的物品
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()
    self.Scenelayer  : setControlName("this is CEquipmentManufactureLayer.layer self.Scenelayer 37 ")
    self : init (winSize,self.Scenelayer)   

    self.Scenelayer : setFullScreenTouchEnabled(true)
    self.Scenelayer : setTouchesEnabled(true)
    self.Scenelayer : setTouchesPriority(-1000)

    return self.Scenelayer
end

function CEquipmentManufactureLayer.loadResources(self)
    print("loadResources 32")
    --CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("EquipmentResources/Equip.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("Joystick/keyBoardResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TreasureHouseResource/TreasureHouseResource.plist")  
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TreasureHouseResource/TreasureHouseResource.plist")   --返回按钮

    _G.Config:load("config/goods.xml")
    _G.Config:load("config/hidden_make.xml")
end

function CEquipmentManufactureLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_allBackGroundSprite      : setPosition(winSize.width/2-195,winSize.height/2)      --总底图
        local closeSize                 = self.CloseBtn: getContentSize()
        self.CloseBtn                   : setPosition(IpadSize-closeSize.width/2-328+20, winSize.height-closeSize.height/2-150+45+20)  --关闭按钮

        self.m_leftBackGround           : setPosition(265-30,320)     --左底图
        --self.m_rightBackGround          : setPosition(680-30,320)   --左底图

        --self.CloseBtn                     : setPosition(winSize.width-60,winSize.height-30)            --关闭按钮
        --self.EquipmentManufactureLabel    : setPosition(winSize.width/2,winSize.height-30)             --道具制作
        --self.EquipmentManufactureSprite   : setPosition(winSize.width/2,winSize.height-30)             --顶端背景图  
        self.SelectedEquipBtn             : setPosition(265-30-1-120,320+13+20)     --选中的装备
        self.SelectedEquipBtnSprite       : setPosition(265-30-120,320+30)     --选中的装备背景
        self.SelectedEquipLabel           : setPosition(520-30-420,520-10)
        self.SelectedEquipInfoLabel       : setPosition(520-30-200,420+15)
        self.MaterialLabel                : setPosition(660-30-195-27,330+65)
        self.MaterialLayout               : setPosition(505-30-195,260+70)             --材料列表

        --self.m_partingLine                : setPosition(winSize.width/2,winSize.height/2*0.35)        --淫荡分割线
        self.OneManufactureBtn            : setPosition(560-30-215,40+95)
        self.OneManufactureLabel          : setPosition(700-30-215,40+95)
        self.ManufactureBtn               : setPosition(380-30-215,40+95)
    elseif winSize.height == 768 then
        print("81 768")
    end
end

function CEquipmentManufactureLayer.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CEquipmentManufactureLayer.initParameter(self)
    --mediator注册
    print("CTreasureHouseScene.mediatorRegister 68")
     _G.g_EquipmentManufactureMediator = CEquipmentManufactureMediator (self)
     controller :registerMediator(  _G.g_EquipmentManufactureMediator )
 
    --self : initViewParameter () --页面参数初始化

    --获取人物Vip等级
    self.isok_viplv = nil
    local m_mainPlay_Viplv = tonumber( _G.g_characterProperty : getMainPlay() : getVipLv() ) 
    print("CEquipmentManufactureLayer.initParameter 85",m_mainPlay_Viplv,_G.Constant.CONST_TREASURE_ONCE_MAKE_VIP)
    local viplimitedlv =tonumber( _G.Constant.CONST_TREASURE_ONCE_MAKE_VIP )  -- VIP6增加一键制作功能
    if m_mainPlay_Viplv >= viplimitedlv then
        self.isok_viplv = 1
        self.OneManufactureLabel : setString("")
    else
        self.isok_viplv = 0 
        self.OneManufactureLabel : setString("(VIP等级".._G.Constant.CONST_TREASURE_ONCE_MAKE_VIP.."开放)")
    end
end

function CEquipmentManufactureLayer.initView(self,_winSize,_layer)
    local IpadSize =854
    self.BackContainer = CContainer : create()
    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)  
    _layer             : addChild(self.BackContainer)

    local function m_allBackGroundSpriteTouchCallback(eventType, obj, x, y)
       return self : onm_allBackGroundSpriteTouchCallback(eventType, obj, x, y)
    end
    --透明大底图
    self.m_allBackGroundSprite = CSprite :createWithSpriteFrameName("transparent.png") --总底图
    self.m_allBackGroundSprite : setTouchesPriority(-1001)
    self.m_allBackGroundSprite : setTouchesEnabled(true)
    self.m_allBackGroundSprite : registerControlScriptHandler(m_allBackGroundSpriteTouchCallback,"this CEquipmentManufactureLayer SelectedEquipBtnSprite")
    self.m_allBackGroundSprite : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    _layer : addChild(self.m_allBackGroundSprite,-3)    

    -- self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    -- --self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.height/3*4,_winSize.height))  
    -- self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,_winSize.height)) 
    -- self.BackContainer : addChild(self.m_allSecondBackGroundSprite)  
    --self.m_allSecondBackGroundSprite   : setPosition(IpadSize/2,_winSize.height/2) 

    self.m_leftBackGround  = CCScale9Sprite :createWithSpriteFrameName("general_thirdly_underframe.png") --左底图
    --self.m_rightBackGround = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --右底图 

    self.m_leftBackGround     : setPreferredSize(CCSizeMake(590+20,440+20)) --420 260
    --self.m_leftBackGround     : setPreferredSize(CCSizeMake(440,480+12)) --420 260
    --self.m_rightBackGround    : setPreferredSize(CCSizeMake(370,480+12)) --420 260

    self.BackContainer : addChild(self.m_leftBackGround)
    --self.BackContainer : addChild(self.m_rightBackGround)

    local function BtnCallBack(eventType, obj, x, y)
       return self : ButtonCallBack(eventType,obj,x,y)
    end
    local function goodsTouchCallback(eventType, obj, x, y)
        print("goodsTouchCallback22")
       return self : goodsTouchCallback(eventType, obj, x, y)
    end

    --关闭按钮

    
    self.CloseBtn    = CButton : createWithSpriteFrameName("","transparent.png")
    self.CloseBtn    : setPreferredSize(CCSizeMake(80,80))
    self.CloseBtn    : setTag(CEquipmentManufactureLayer.closeBtnTag)        
    self.CloseBtn    : setTouchesPriority(-1003)    
    self.CloseBtn    : registerControlScriptHandler(BtnCallBack,"this CEquipmentManufactureLayer CloseBtnCallBack 83")
    self.BackContainer  : addChild (self.CloseBtn,2)

    local CloseBtnSprite = CSprite : createWithSpriteFrameName("general_close_normal.png")
    CloseBtnSprite       : setScale(0.7)
    self.CloseBtn : addChild(CloseBtnSprite)
    --道具制作
    -- self.EquipmentManufactureLabel = CCLabelTTF :create("道具制作","Arial",25)
    -- _layer                         : addChild (self.EquipmentManufactureLabel,2)

    -- self.EquipmentManufactureSprite   = CSprite : createWithSpriteFrameName("Equip_BackSecondBox.png") --顶端背景图
    -- self.EquipmentManufactureSprite   : setPreferredSize(CCSizeMake(_winSize.width-10,_winSize.height*0.1-10)) 
    -- _layer                         : addChild (self.EquipmentManufactureSprite,1) 
    --------------------------------------------------------------------------------------------------
    --选中的装备
    self.SelectedEquipBtn = CButton : createWithSpriteFrameName("","transparent.png")
    self.SelectedEquipBtn : setPreferredSize(CCSizeMake(110,110))
    --self.SelectedEquipBtn = CButton : createWithSpriteFrameName("","transparent.png")
    self.BackContainer                : addChild (self.SelectedEquipBtn,5)
    --选中装备背景
    self.SelectedEquipBtnSprite = CSprite : createWithSpriteFrameName("hidden_props_underframe.png")
    self.BackContainer : addChild (self.SelectedEquipBtnSprite,2)   

    self.SelectedEquipLabel = CCLabelTTF :create("九龙化衍台","Arial",24)
    self.SelectedEquipLabel : setAnchorPoint(ccp(0.0, 0.5))  
    self.BackContainer                  : addChild (self.SelectedEquipLabel,4)
    
    self.SelectedEquipInfoLabel = CCLabelTTF :create("九龙之诞,聚于一台","Arial",18)
    self.SelectedEquipInfoLabel : setAnchorPoint( ccp(0.0, 0.5))       
    self.SelectedEquipInfoLabel : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐 
    -- self.SelectedEquipInfoLabel : setDimensions( CCSizeMake(330,150))          --设置文字区域
    self.SelectedEquipInfoLabel : setDimensions( CCSizeMake(235,105))          --设置文字区域
    self.BackContainer                      : addChild (self.SelectedEquipInfoLabel)

    self.MaterialLabel = CCLabelTTF :create("所需材料:(单击材料自动寻路)","Arial",18)
    self.BackContainer             : addChild (self.MaterialLabel)

    --材料列表
    self.MaterialLayout = CHorizontalLayout : create()
    self.MaterialLayout : setControlName("CEquipmentManufactureLayer  MaterialLayout 93")
    self.MaterialLayout : setLineNodeSum(2)
    self.MaterialLayout : setVerticalDirection(false)
    self.MaterialLayout : setCellSize(CCSizeMake(115,110))
    self.BackContainer : addChild(self.MaterialLayout)

    self.MaterialBtn     = {} --所需材料按钮table
    self.MaterialBtnLael = {} --所需材料数量Label
    for i=1,4 do
        self.MaterialBtn[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
        self.MaterialBtn[i] : setTouchesPriority(-1004)
        self.MaterialBtn[i] : setTouchesEnabled(true)
        --self.MaterialBtn[i] : setTouchesMode( kCCTouchesAllAtOnce )
        self.MaterialBtn[i] : registerControlScriptHandler(goodsTouchCallback,"this CEquipmentManufactureLayer MaterialBtn[i]CallBack 140")
        self.MaterialBtn[i] : setTag(CEquipmentManufactureLayer.MaterialBtnTag[i])
        self.MaterialLayout : addChild(self.MaterialBtn[i])

        self.MaterialBtnLael[i] = CCLabelTTF :create("","Arial",20) 
        self.MaterialBtnLael[i] : setPosition(25,-30)      
        self.MaterialBtn[i]     : addChild(self.MaterialBtnLael[i],10)

        local MaterialBtnSprite = CSprite : createWithSpriteFrameName("general_props_underframe.png")
        self.MaterialBtn[i]     : addChild(MaterialBtnSprite,-2)
    end
    -- --分割线--------------------------------------------------------------------------------------
    -- self.m_partingLine  = CSprite : createWithSpriteFrameName("Equip_BackSecondBox.png") --分割线
    -- self.m_partingLine  : setScaleY(0.5)
    -- self.m_partingLine  : setScaleX(27)
    -- _layer              : addChild(self.m_partingLine)    

    --制作按钮
    self.ManufactureBtn = CButton :createWithSpriteFrameName("制作","general_button_normal.png")
    self.ManufactureBtn : setFontSize(24)
    self.ManufactureBtn : setTouchesPriority(-1002)
    self.ManufactureBtn : setTag(CEquipmentManufactureLayer.ManufactureBtnTag)
    self.BackContainer              : addChild(self.ManufactureBtn)
    --一键制作按钮
    self.OneManufactureBtn = CButton :createWithSpriteFrameName("一键制作","general_button_normal.png")
    self.OneManufactureBtn : setFontSize(24)
    self.OneManufactureBtn : registerControlScriptHandler(BtnCallBack,"this CEquipmentManufactureLayer OneManufactureBtnCallBack 172")
    self.OneManufactureBtn : setTouchesPriority(-1002)
    self.OneManufactureBtn : setTag(CEquipmentManufactureLayer.OneManufactureBtnTag)
    self.BackContainer                 : addChild(self.OneManufactureBtn)

    self.OneManufactureLabel = CCLabelTTF :create("","Arial",20)
    self.BackContainer                   : addChild (self.OneManufactureLabel)
end

function CEquipmentManufactureLayer.ButtonCallBack(self,eventType,obj,x,y)  --页面按钮回调
   if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        print("ButtonCallBack tagvalue= ",tagvalue)
        local winSize = CCDirector:sharedDirector():getVisibleSize()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if tagvalue == CEquipmentManufactureLayer.closeBtnTag  then
                print("关闭按钮回调")
                _G.g_PopupView :reset()
                if _G.g_EquipmentManufactureMediator ~= nil then
                    controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
                    _G.g_EquipmentManufactureMediator = nil
                end
               self : removeEffactCCBI() --删除ccbi
               self.Scenelayer : removeFromParentAndCleanup(true)
               self : removeIconResources()
               --return    CCDirector : sharedDirector () : popScene()
            elseif tagvalue == CEquipmentManufactureLayer.ShopBtnTag  then 
                print("商店按钮回调")

            elseif tagvalue == CEquipmentManufactureLayer.ManufactureBtnTag  then 
                print("制作按钮回调")
                self : ManufactureBtnSend() --制作协议发送

            elseif tagvalue == CEquipmentManufactureLayer.OneManufactureBtnTag  then 
                print("一键制作按钮回调")
                if self.AllNeedMaterialMoney ~= nil and self.AllNeedMaterialMoney > 0 then
                    ------------------------------------------------
                    self.PopBox = CPopBox() --初始化
                    local function PopBoxbtnCallBack( )
                        self : OneManufactureBtnSend() --一键制作协议发送
                    end
                    self.PopBoxLayer = self.PopBox :create(PopBoxbtnCallBack,"是否花费"..self.AllNeedMaterialMoney.."钻石\n替代材料进行合成")
                    self.PopBoxLayer : setTouchesPriority(-2001)
                    self.PopBoxLayer : setPosition(-192,0)
                    self.Scenelayer  : addChild(self.PopBoxLayer,101) 
                    print("生出了那个框框了")
                    -------------------------------------------------
                end
            end

            for i=1,6 do
                if tagvalue == CEquipmentManufactureLayer.MaterialBtnTag[i] then
                    print("材料中第"..i.."件回调")
                    --self : LookForTheMaterial(i) --单击材料自动寻路
                    local sceneid = tonumber(self.MaterialListData[i].sceneid) 
                    local Box = CPopBox() --初始化
                    local function BoxbtnCallBack( )
                        self : LookForTheMaterial(i)
                    end
                    if sceneid ~= nil and sceneid > 0 then
                        PopBoxLayer = Box :create(BoxbtnCallBack,"是否自动寻路 ?")
                    elseif sceneid == 0 then
                        PopBoxLayer = Box :create(BoxbtnCallBack,"是否去神秘商店购买 ?")
                    end
                    Box               : setFontSize()
                    PopBoxLayer       : setPosition(0,0)
                    self.Scenelayer   : addChild(PopBoxLayer,101) 
                end
            end

        end
    end
end

function CEquipmentManufactureLayer.goodsTouchCallback(self,eventType,obj,x,y)  --材料按钮按钮回调
   if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return true
    elseif eventType == "TouchEnded" then
        --self : addEffactCCBI()

        local tag = obj:getTag()
        for i=1,6 do
            if tag == CEquipmentManufactureLayer.MaterialBtnTag[i] then 
                print("物品制作的物品按钮回调",i )
                local function BoxbtnCallBack( )
                    self : LookForTheMaterial(i)
                end
                local id = self.MaterialListData[i].id 
                local _position = {}
                _position.x = x-240-50
                _position.y = y+15

                local isValue  =  self : getIsJumboReels(id)
                local  temp = nil 
                if isValue == 0 then
                    print("为什么这么慢0011")
                    temp   = _G.g_PopupView :createByGoodsId( id, _G.Constant.CONST_GOODS_SITE_TREASUREUNLOAD, _position,0,BoxbtnCallBack)  --自动寻路按钮
                elseif isValue == 1 then
                    print("为什么这么慢0022")
                    temp   = _G.g_PopupView :createByGoodsId( id, _G.Constant.CONST_GOODS_SITE_TREASURELOAD, _position,0,BoxbtnCallBack)  --购买按钮
                end
                if temp ~= nil then
                    print("为什么这么慢")
                    temp : setTouchesEnabled(true)
                    temp : setTouchesPriority(-1010)
                    self.Scenelayer : addChild( temp,1000)
                end 
            end
        end

    end
end

function CEquipmentManufactureLayer.onm_allBackGroundSpriteTouchCallback(self,eventType,obj,x,y)  --大透明按钮回调
   if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return true
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()
    end
end
-- function CEquipmentManufactureLayer.onSelectedEquipBtnSpriteTouchCallback(self, eventType, obj, touches)
--     print("goodsTouchCallback3300000", eventType)
--     if eventType == "TouchesBegan" then
--         --删除Tips
--         _G.g_PopupView :reset()
--         local touchesCount = touches:count()
--         for i=1, touchesCount do
--             local touch = touches :at( i - 1 )
--             local touchPoint = touch :getLocation()
--             if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
--                 self.touchID1     = touch :getID()
--                 break
--             end
--         end
--     elseif eventType == "TouchesEnded" then
--         if self.touchID1 == nil then
--            return
--         end
--         local touchesCount2 = touches:count()
--         for i=1, touchesCount2 do
--             local touch2 = touches :at(i - 1)
--             if touch2:getID() == self.touchID1 and self.goodstag1 == obj :getTag() then
--                 _G.g_PopupView :reset()
--                 local touch2Point = touch2 :getLocation()
--                 if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

--                     self.touchID1    = nil
--                     self.goodstag1   = nil
--                 end
--             end
--         end

--     end
-- end

function CEquipmentManufactureLayer.getIsJumboReels(self,_id)
    local isValue = 0 
    local Node = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_id).."]")
    if Node : isEmpty() == false then
        local type_sub = tonumber(Node : getAttribute("type_sub"))
        if type_sub == 72 then
            isValue = 1
        end
    end
    return isValue
end
--单个物品数据传输到制作界面
function CEquipmentManufactureLayer.LookForTheMaterial(self,_i)

    local  TheMaterial  = self.MaterialListData[_i]     --选中材料
    print("232 LookForTheMaterial--->",TheMaterial,TheMaterial.id,TheMaterial.sceneid)
    local id      = tonumber(TheMaterial.id)
    local sceneid = tonumber(TheMaterial.sceneid) 
    if sceneid ~= nil and sceneid > 0   then
        self : REQ_TREASURE_IS_COPY(sceneid) --判断要去的传送门开了没
        self.thesceneid = sceneid
        self.thematerialBagCount  = TheMaterial.materialBagCount
        self.thematerialNeedCount = TheMaterial.materialNeedCount
        self.thematerialId        = TheMaterial.id       
        -----------------------------------------------------------------------------------
        -- --mediator
        -- if _G.g_EquipmentManufactureMediator ~= nil then
        --     controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
        --     _G.g_EquipmentManufactureMediator = nil
        -- end
        -- if _G.g_CTreasureHouseMediator ~= nil then
        --     controller : unregisterMediator(_G.g_CTreasureHouseMediator)
        --     _G.g_CTreasureHouseMediator = nil
        -- end

        -- local roleProperty  = _G.g_characterProperty : getMainPlay()

        -- --得到副本所在章节id
        -- local _chapId = nil
        -- if _G.pCDailyTaskProxy ~= nil then
        --     local sceneCopysNode = _G.pCDailyTaskProxy :getSceneCopys( sceneid )
        --     if sceneCopysNode ==nil then
        --         CCLOG(" 副本id空了 "..sceneid)
        --         return
        --     end
        --     _chapId = tonumber( sceneCopysNode.belong_id)
        -- end
        -- _G.g_PopupView :reset()

        -- roleProperty :setTaskInfo( 2, sceneid, _chapId )

        -- local NowSenceId = _G.g_Stage : getScenesID()

        -- CCDirector : sharedDirector () : popScene()
        -- _G.g_CTaskNewDataProxy : gotoDoorsPos( NowSenceId, 1 )          --跑到当前场景的传送门
        -----------------------------------------------------------------------------------
    elseif sceneid == 0 then
        print("商店弹出")
        _G.g_PopupView :reset()
        if _G.g_EquipmentManufactureMediator ~= nil then
            controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
            _G.g_EquipmentManufactureMediator = nil
        end
        self.Scenelayer : removeFromParentAndCleanup(true)
        self : removeIconResources()

        local command = CTreasureHouseInfoViewCommand(3,nil)
        controller    : sendCommand( command)

       -- return    CCDirector : sharedDirector () : popScene()
    end
end

function CEquipmentManufactureLayer.ManufactureBtnSend(self) ---制作协议发送

    local GoodsId     = tonumber(self.OneGoodData.id)
    local LevelId     = tonumber(self.OneGoodData.level + 100)
    print("ManufactureBtnSend=",GoodsId,LevelId)

    --向服务器发送制作请求
    if GoodsId ~= nil and GoodsId > 0 and LevelId ~= nil and LevelId > 0 then
       local msg = REQ_TREASURE_GOODS_ID()

        msg : setType(0)  --0:普通打造|1:一键打造
        msg : setLevelId(LevelId)  --层次ID
        msg : setGoodsId(GoodsId)  --物品id  
        CNetwork : send(msg)
        print("CEquipmentManufactureLayersend ManufactureBtnSend,完毕 207")
    end
end

function CEquipmentManufactureLayer.OneManufactureBtnSend(self) --一键制作协议发送

    local GoodsId     = tonumber(self.OneGoodData.id)
    local LevelId     = tonumber(self.OneGoodData.level + 100) 
    
    print("OneManufactureBtnSend=",GoodsId,LevelId)
    --向服务器发送制作请求
    if GoodsId ~= nil and GoodsId > 0 and LevelId ~= nil and LevelId > 0 then
        local msg = REQ_TREASURE_GOODS_ID()

        msg : setType(1)  --0:普通打造|1:一键打造
        msg : setLevelId(LevelId)  --层次ID
        msg : setGoodsId(GoodsId)  --物品id  
        CNetwork : send(msg)
        print("CEquipmentManufactureLayersend OneManufactureBtnSend,完毕 207")
    end
end

function CEquipmentManufactureLayer.initViewParameter(self)
    --self : removeIconResources()
    local Goodname     = self.OneGoodData.name
    local Gooddescribe = self.OneGoodData.describe 
    print("CEquipmentManufactureLayer.initViewParameter==",Gooddescribe)
    self.SelectedEquipLabel      : setString (Goodname)     --物品名字
    self.SelectedEquipInfoLabel  : setString(Gooddescribe)  --物品描述

    local icon_url        = "Icon/i"..self.OneGoodData.icon..".jpg"
    self.GoodsSprite_URL  = icon_url
    self.GoodsSprite      = CSprite : create(icon_url)
    self.GoodsSprite      : setGray(true)
    --self.GoodsSprite      : setPosition(0,15)
    self.SelectedEquipBtn : addChild(self.GoodsSprite,-2)

    --local  GoodId           = 1001
    local  GoodId           = self.OneGoodData.id
    local MaterialNeedNode            = _G.Config.hidden_makes : selectSingleNode("hidden_make[@items_id="..tostring(GoodId).."]")
    local MaterialNeedNode_makes      = MaterialNeedNode : children() : get(0,"makes")
    local MaterialNeedNode_makesCount = MaterialNeedNode_makes : children() : getCount("make")

    self.NeedMaterialCount    = 0  --计数所需材料的个数
    self.NeddMaterialOKCount  = 0  --计数符合所需材料的个数
    self.AllNeedMaterialMoney = 0  --计数所缺材料替换成元宝的总价格
    local OneNeedMoney        = 0  --单件所需元宝
    --print("lalallala ==",GoodId,MaterialNeedNode,MaterialNeedNode.makes[1],MaterialNeedNode.makes[1].make)
    -- if MaterialNeedNode_makesCount > 0 then
    --     for i=0,MaterialNeedNode_makesCount-1 do

    --          self.NeedMaterialCount = self.NeedMaterialCount + 1  --计数所需材料的个数
    --     end
    -- end
    -- if MaterialNeedNode.makes[1].make ~= nil then
    --     for k,v in pairs(MaterialNeedNode.makes[1].make) do
    --         self.NeedMaterialCount = self.NeedMaterialCount + 1  --计数所需材料的个数
    --         print(k,v)
    --     end
    -- end

    --合成一件装备所需材料  
    self.MaterialListData = {}
    self.MaterialSprite   = {}
    print("监听==",self.NeedMaterialCount,MaterialNeedNode_makesCount)
    if MaterialNeedNode_makesCount > 0 then
        self.NeedMaterialCount    = MaterialNeedNode_makesCount 
        -- local itemNode = MaterialNeedNode.makes[1].make
        local itemNode = MaterialNeedNode_makes : children()
        for i=1,MaterialNeedNode_makesCount do
            print("监听2==",MaterialNeedNode_makesCount)
            local itemNode_make     = itemNode : get(i-1,"make")
            local MaterialId        = tonumber(itemNode_make : getAttribute("ietm") )      --材料id
            local MaterialSceneId   = tonumber(itemNode_make : getAttribute("copy_id"))    --材料所在场景id        
            local MaterialPrice     = tonumber(itemNode_make : getAttribute("rmb"))        --单件材料的价格元宝
            local MaterialNeedCount = tonumber(itemNode_make : getAttribute("count"))      --所需材料数量
            if MaterialId ~= nil and MaterialId > 0 then
                local MaterialBagCount   = self : MaterialCountfromBagData (MaterialId) --背包数量
                self.MaterialListData[i] = {}
                self.MaterialListData[i] = self : OneMaterialfromGoodsXmlData (MaterialId,MaterialSceneId,MaterialBagCount,MaterialNeedCount) --单个材料数据


                local MaterialData = self : OneMaterialfromGoodsXmlData (MaterialId,MaterialSceneId) --单个材料数据

                local icon_url          = "Icon/i"..MaterialData.icon..".jpg"
                self.MaterialSprite[i]  = CSprite : create(icon_url)
                self.MaterialBtn[i]     : addChild(self.MaterialSprite[i],-2)

                self.MaterialBtnLael[i] : setString(MaterialBagCount.."/"..MaterialNeedCount)

                local leftCount = tonumber(MaterialBagCount)  - tonumber(MaterialNeedCount)  
                print("leftCount-----",leftCount)
                if tonumber(MaterialBagCount) ~= nil and leftCount >= 0  then 
                    self.NeddMaterialOKCount = self.NeddMaterialOKCount + 1 --计数符合所需材料的个数
                end

                local leftNeedCount = MaterialNeedCount - MaterialBagCount  --离收集完1件材料所需数量的差数
                if leftNeedCount > 0 then
                    OneNeedMoney =  leftNeedCount * MaterialPrice --单件材料所查价格可以替代的元宝数量
                    self.AllNeedMaterialMoney = self.AllNeedMaterialMoney + OneNeedMoney
                end
            end
        end
    end
    -- for i=1,6 do
    --     local item     = tostring("item"..i)  
    --     if MaterialNeedNode[item] ~= nil and tonumber(MaterialNeedNode[item])  > 0  then
    --         self.NeedMaterialCount = self.NeedMaterialCount + 1  --计数所需材料的个数
    --     end
    -- end
    -- --合成一件装备所需材料  
    -- self.MaterialListData = {}
    -- for i=1,self.NeedMaterialCount do

    --     local item      = tostring("item"..i)  
    --     local count     = "count"..i 
    --     local rmb_item  = "rmb_item"..i 
    --     local item_copy = item.."_copy"

    --     local MaterialId        = tonumber(MaterialNeedNode[item])       --材料id
    --     local MaterialSceneId   = tonumber(MaterialNeedNode[item_copy])  --材料所在场景id        
    --     local MaterialPrice     = MaterialNeedNode[rmb_item]             --单件材料的价格元宝
    --     local MaterialNeedCount = tonumber(MaterialNeedNode[count])      --所需材料数量
    --     if MaterialId ~= nil and MaterialId > 0 then
    --         self.MaterialListData[i] = {}
    --         self.MaterialListData[i] = self : OneMaterialfromGoodsXmlData (MaterialId,MaterialSceneId) --单个材料数据

    --         local MaterialData = self : OneMaterialfromGoodsXmlData (MaterialId,MaterialSceneId) --单个材料数据

    --         local icon_url          = "Icon/i"..MaterialData.icon..".jpg"
    --         self.MaterialSprite     = CSprite : create(icon_url)
    --         self.MaterialBtn[i]     : addChild(self.MaterialSprite,-2)

    --         local MaterialBagCount  = self : MaterialCountfromBagData (MaterialId) --背包数量
    --         self.MaterialBtnLael[i] : setString(MaterialBagCount.."/"..MaterialNeedCount)

    --         local leftCount =  MaterialBagCount - MaterialNeedCount 
    --         if leftCount >= 0 then 
    --             self.NeddMaterialOKCount = self.NeddMaterialOKCount + 1 --计数符合所需材料的个数
    --         end

    --         local leftNeedCount = MaterialNeedCount - MaterialBagCount  --离收集完1件材料所需数量的差数
    --         if leftNeedCount > 0 then
    --             OneNeedMoney =  leftNeedCount * MaterialPrice --单件材料所查价格可以替代的元宝数量
    --             self.AllNeedMaterialMoney = self.AllNeedMaterialMoney + OneNeedMoney
    --         end
    --     end
    -- end
    print("s合成一件装备所需材料.NeddMaterialOKCount",self.NeddMaterialOKCount,self.NeedMaterialCount)
    local function BtnCallBack(eventType, obj, x, y)
       return self : ButtonCallBack(eventType,obj,x,y)
    end
    if self.isok_viplv == 1 then
        self.OneManufactureBtn : setGray( false )          --一键制作按钮变灰
        self.OneManufactureBtn : setTouchesEnabled( true ) --一键制作按钮可按   
    elseif self.isok_viplv == 0 then
        self.OneManufactureBtn : setGray( true )            --一键制作按钮变灰
        self.OneManufactureBtn : setTouchesEnabled( false ) --一键制作按钮变灰
    end
    --判断材料齐了没
    if  self.NeddMaterialOKCount == self.NeedMaterialCount and self.NeddMaterialOKCount ~= 0 and self.NeedMaterialCount ~= 0 then    
        self.ManufactureBtn    : registerControlScriptHandler(BtnCallBack,"this CEquipmentManufactureLayer ManufactureBtnCallBack 278") --注册制作按钮回调

        self.OneManufactureBtn : setGray( true )            --一键制作按钮变灰
        self.OneManufactureBtn : setTouchesEnabled( false ) --一键制作按钮不可按

        self.ManufactureBtn    : setGray( false )              --制作按钮变灰
        self.ManufactureBtn    : setTouchesEnabled( true ) --制作按钮可按
        print("材料齐了")
    else
        self.ManufactureBtn    : setGray( true )            --制作按钮变灰
        self.ManufactureBtn    : setTouchesEnabled( false ) --制作按钮不可按

        --self.OneManufactureBtn : setGray( false )            --制作按钮变灰
        --self.OneManufactureBtn : setTouchesEnabled( true ) --一键制作按钮可按       
        print(" 281 材料未集齐，制作按钮不能按")
    end  
end

function CEquipmentManufactureLayer.OneMaterialfromGoodsXmlData(self,_materialId,_materialSceneId,_MaterialBagCount,_MaterialNeedCount)

    local OneGoodNode =_G.Config.goodss : selectSingleNode("goods[@id="..tostring(_materialId).."]")
        print("OneMaterialfromGoodsXmlData",_materialId,OneGoodNode)
    local OneGood     = {}
    OneGood.name      = OneGoodNode: getAttribute("name") 
    OneGood.icon      = OneGoodNode: getAttribute("icon") 
    OneGood.id        = OneGoodNode: getAttribute("id")

    OneGood.sceneid   = _materialSceneId   --所需材料所在场景ID  

    if _MaterialBagCount ~=nil then
        OneGood.materialBagCount = _MaterialBagCount
    end
    if _MaterialNeedCount ~= nil then
        OneGood.materialNeedCount = _MaterialNeedCount
    end

    return  OneGood
end

function CEquipmentManufactureLayer.MaterialCountfromBagData(self,_materialId)

    local m_MaterialListData =  _G.g_GameDataProxy : getMaterialList() --材料列表
    local bag_material_count = 0
    if m_MaterialListData ~=nil then
        for k,v in pairs(m_MaterialListData) do
            if(_materialId == v.goods_id)then
                bag_material_count =tonumber(v.goods_num)             --背包材料数量
                break
            end
        end

    end
    return bag_material_count
end

function CEquipmentManufactureLayer.TriggerPropertyAdd(self,_Goodid,_State)

    local  Goodid  = _Goodid
    local  State   = _State
    print("TriggerPropertyAdd 349 =",Goodid,State,self)
    if State == true then
        local levelId = tonumber(self.OneGoodData.levelid) 
        if levelId ~= nil and levelId > 0 then
            require "common/protocol/auto/REQ_TREASURE_LEVEL_ID" 
            local msg = REQ_TREASURE_LEVEL_ID()
            msg       : setLevelId(levelId)
            CNetwork  : send(msg)
            print("CEquipmentManufactureLayer页面发送数据请求,完毕 356")
        end

        --制作成功
        -- local command = CTreasureHouseInfoViewCommand(1,nil)
        -- controller    : sendCommand( command)

        self : addEffactCCBI() 

        self.OneManufactureBtn : setTouchesEnabled( false ) --一键制作按钮变灰
        self.ManufactureBtn    : setTouchesEnabled( false )  --制作按钮变灰
        --button版本
        -- if _G.g_EquipmentManufactureMediator ~= nil then
        --     controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
        --     _G.g_EquipmentManufactureMediator = nil
        -- end
        -- self.Scenelayer : removeFromParentAndCleanup(true)

    else
        -- local msg = "制作失败了"
        -- self : createMessageBox(msg)
    end
end


function CEquipmentManufactureLayer.pushData(self,_data)
    self.OneGoodData = _data
    print("pushData",self.OneGoodData,self,self.OneGoodData.levelid)
    self : initViewParameter () --页面参数初始化
end

function CEquipmentManufactureLayer.REQ_TREASURE_IS_COPY(self,sceneId)
    if sceneId ~= nil then
        require "common/protocol/auto/REQ_TREASURE_IS_COPY" 
        local msg = REQ_TREASURE_IS_COPY()
        msg : setCopyId(sceneId)
        CNetwork  : send(msg)
        print("REQ_TREASURE_IS_COPY -- [47310]请求副本时候开启 -- 珍宝阁系统  发送完毕 ")
    end
end

function CEquipmentManufactureLayer.NetWorkReturn_TREASURE_COPY_STATE( self, State )
    print("判断完是否开通的副本返回了 609 ")
    if State ~= nil and State == 1 then
        if self.thesceneid ~= nil then
            local sceneid = self.thesceneid

            if _G.g_EquipmentManufactureMediator ~= nil then
                controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
                _G.g_EquipmentManufactureMediator = nil
            end
            if _G.g_CTreasureHouseMediator ~= nil then
                controller : unregisterMediator(_G.g_CTreasureHouseMediator)
                _G.g_CTreasureHouseMediator = nil
            end

            local roleProperty  = _G.g_characterProperty : getMainPlay()

            --得到副本所在章节id
            local _chapId = nil
            if _G.pCDailyTaskProxy ~= nil then
                local sceneCopysNode = _G.pCDailyTaskProxy :getSceneCopys( sceneid )
                if sceneCopysNode : isEmpty() == true then
                    CCLOG(" 副本id空了 "..sceneid)
                    return
                end
                _chapId = tonumber( sceneCopysNode : getAttribute("belong_id"))
            end
            _G.g_PopupView :reset()

            if  self.thematerialBagCount ~= nil and self.thematerialNeedCount ~= nil and self.thematerialId ~= nil  then
                roleProperty :setTaskInfo( _G.Constant.CONST_TASK_TRACE_MATERIAL, sceneid, _chapId ,self.thematerialBagCount,self.thematerialNeedCount,self.thematerialId)
            end

            local NowSenceId = _G.g_Stage : getScenesID()

            local command = CTreasureHouseInfoViewCommand(1) --发送协议去清资源
            controller    : sendCommand( command)

            self : removeIconResources()

            self.Scenelayer : removeFromParentAndCleanup(true)

            -- CCDirector : sharedDirector () : popScene()
            _G.g_CTaskNewDataProxy : gotoDoorsPos( NowSenceId, 1 )          --跑到当前场景的传送门
        end
    elseif State ~= nil and State == 0 then
        local msg = "材料所掉落副本暂未开放"
        self : createMessageBox(msg)
    end
end

function CEquipmentManufactureLayer.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end

function CEquipmentManufactureLayer.removeIconResources(self)
    if self.MaterialListData ~= nil then
        local count = #self.MaterialListData
        print("要删除的图片资源个数",count)
        for i=1,count do
            if  self.MaterialSprite[i] ~= nil then
                -- self.MaterialSprite[i] : removeFromParentAndCleanup(true)
                -- self.MaterialSprite[i] = nil

                local icon_url = "Icon/i"..self.MaterialListData[i].icon..".jpg"
                print("11好多icon",icon_url)
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
    -- print("self.GoodsSprite_URL === ",self.GoodsSprite_URL)
    -- if  self.GoodsSprite ~= nil then
    --     self.GoodsSprite : removeFromParentAndCleanup(true)
    --     self.GoodsSprite = nil
    -- end
    -- local icon_url = self.GoodsSprite_URL
    -- if icon_url ~= nil then
    --     print("the icon_url === ",icon_url)
    --     local r        = CCTextureCache :sharedTextureCache():textureForKey(icon_url)
    --     if r ~= nil then
    --         CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
    --         CCTextureCache :sharedTextureCache():removeUnusedTextures(r)
    --         r = nil
    --     end 
    -- end   
end

function CEquipmentManufactureLayer.addEffactCCBI(self)

    self : removeEffactCCBI() --删除ccbi
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
    end
    local function animationCallFunc2( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
          
            self : setGoodsSpriteLight() --点亮
        end
    end


    local actarr = CCArray:create()

    local function ccbi_callback1()
        self["effects_hidden1CCBI_"..1] = CMovieClip:create( "CharacterMovieClip/effects_hidden1.ccbi" )
        self["effects_hidden1CCBI_"..1] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..1] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..1],1000)

        
        self["effects_hidden1CCBI_"..1] : setPosition(-80,60-2)
    end
    local function ccbi_callback2()
        self["effects_hidden1CCBI_"..2] = CMovieClip:create( "CharacterMovieClip/effects_hidden1.ccbi" )
        self["effects_hidden1CCBI_"..2] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..2] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..2],1000)

        self["effects_hidden1CCBI_"..2] : setScaleX(-1)
        self["effects_hidden1CCBI_"..2] : setPosition(80,60-2)
    end
    local function ccbi_callback3()
        self["effects_hidden1CCBI_"..3] = CMovieClip:create( "CharacterMovieClip/effects_hidden1.ccbi" )
        self["effects_hidden1CCBI_"..3] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..3] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..3],1000)

        self["effects_hidden1CCBI_"..3] : setScaleX(-1)
        self["effects_hidden1CCBI_"..3] : setPosition(80,-50)
    end
    local function ccbi_callback4()
        self["effects_hidden1CCBI_"..4] = CMovieClip:create( "CharacterMovieClip/effects_hidden1.ccbi" )
        self["effects_hidden1CCBI_"..4] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..4] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..4],1000)

        self["effects_hidden1CCBI_"..4] : setPosition(-80,-50)
    end

    local function ccbi_callback5()
        self["effects_hidden1CCBI_"..5] = CMovieClip:create( "CharacterMovieClip/effects_hidden2.ccbi" )
        self["effects_hidden1CCBI_"..5] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..5] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..5],1000)

        self["effects_hidden1CCBI_"..5] : setPosition(-50,0)
    end
    local function ccbi_callback6()
        self["effects_hidden1CCBI_"..6] = CMovieClip:create( "CharacterMovieClip/effects_hidden2.ccbi" )
        self["effects_hidden1CCBI_"..6] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..6] : registerControlScriptHandler( animationCallFunc)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..6],1000)

        self["effects_hidden1CCBI_"..6] : setPosition(50,0)
    end
    local function ccbi_callback7()
        self["effects_hidden1CCBI_"..7] = CMovieClip:create( "CharacterMovieClip/effects_hidden3.ccbi" )
        self["effects_hidden1CCBI_"..7] : setControlName( "this CCBI effects_hidden_1 CCBI")
        self["effects_hidden1CCBI_"..7] : registerControlScriptHandler( animationCallFunc2)
        self.SelectedEquipBtn  : addChild(self["effects_hidden1CCBI_"..7],1000)

        --self["effects_hidden1CCBI_"..7] : setPosition(50,0)
    end



    local delayTime = 0.5

    actarr:addObject( CCCallFunc:create(ccbi_callback1) )

    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback2) )

    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback3) )

    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback4) )

    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback5) )
    actarr:addObject( CCCallFunc:create(ccbi_callback6) )

    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback7) )

    self.Scenelayer:runAction( CCSequence:create(actarr) )

end

function CEquipmentManufactureLayer.removeEffactCCBI ( self )
    for i =1,7 do
        if self["effects_hidden1CCBI_"..i] ~= nil then
            if self["effects_hidden1CCBI_"..i]  : retainCount() >= 1 then
                self.SelectedEquipBtn   : removeChild(self["effects_hidden1CCBI_"..i],false)
                self["effects_hidden1CCBI_"..i] = nil 
            end
        end
    end
end

function CEquipmentManufactureLayer.setGoodsSpriteLight( self )
    print("播放完毕")

    local actarr = CCArray:create()

    local function ccbi_callback1()
        self.GoodsSprite      : setGray(false)
        print("设你变回彩色的")
    end

    local function ccbi_callback2()

        self : removeEffactCCBI() --删除ccbi
        _G.g_PopupView : reset()
        if _G.g_EquipmentManufactureMediator ~= nil then
            controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
            _G.g_EquipmentManufactureMediator = nil
        end
       self.Scenelayer : removeFromParentAndCleanup(true)
       self : removeIconResources()
    end

    local delayTime = 0.75

    actarr:addObject( CCCallFunc:create(ccbi_callback1) )
    actarr:addObject( CCDelayTime:create(delayTime) )
    actarr:addObject( CCCallFunc:create(ccbi_callback2) )

    self.Scenelayer:runAction( CCSequence:create(actarr) )
end




















