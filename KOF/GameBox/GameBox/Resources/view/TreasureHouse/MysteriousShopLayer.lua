

require "controller/command"
require "view/view"

require "mediator/MysteriousShopMediator"



CMysteriousShopLayer = class(view,function (self)

                          end)

CMysteriousShopLayer.m_GoodBuyBtnTag    = {}
CMysteriousShopLayer.m_GoodBuyBtnTag[1] = 1
CMysteriousShopLayer.m_GoodBuyBtnTag[2] = 2
CMysteriousShopLayer.m_GoodBuyBtnTag[3] = 3
CMysteriousShopLayer.m_GoodBuyBtnTag[4] = 4
CMysteriousShopLayer.m_GoodBuyBtnTag[5] = 5
CMysteriousShopLayer.m_GoodBuyBtnTag[6] = 6

CMysteriousShopLayer.RefreshBtnTag      = 7
CMysteriousShopLayer.closeBtnTag        = 8

function CMysteriousShopLayer.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CMysteriousShopLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (winSize,self.Scenelayer)   

    -- self.Scenelayer : setFullScreenTouchEnabled(true)
    -- self.Scenelayer : setTouchesEnabled(true)
    -- self.Scenelayer : setTouchesPriority(-1)

    return self.Scenelayer
end

function CMysteriousShopLayer.loadResources(self)
    _G.Config:load("config/goods.xml")
    _G.Config:load("config/hidden_store.xml")
    print("珍宝阁资源释放钱")
    --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
end

function CMysteriousShopLayer.layout(self, winSize)  --适配布局
    local IpadSizeWidth  = 854
    local IpadSizeHeight = 640
    if winSize.height == 640 then
        self.m_allBackGroundSprite        : setPosition(IpadSizeWidth/2+25,IpadSizeHeight/2-5)         --总底图
        --self.CloseBtn                     : setPosition(winSize.width-30,winSize.height-30)          --关闭按钮
        -- self.MysteriousBusinessmanLabel   : setPosition(winSize.width/2,winSize.height-30)          --神秘商人
        -- self.EquipmentManufactureSprite   : setPosition(winSize.width/2,winSize.height-30)          --顶端背景图  
        self.GoodsLayout                  : setPosition(-103,IpadSizeHeight/2*1.5-10)                  --物品列表

        --self.m_partingLine              : setPosition(winSize.width/2,winSize.height/2*0.3)        --淫荡分割线
        self.RefreshBtn                   : setPosition(470,35)     --刷新按钮
        self.RefreshMoneyLabel            : setPosition(650,35)     --刷新花费
        self.RefreshTimeLabel             : setPosition(120,55)     --1小时1刷新
        self.RefreshLeftTimeLabel         : setPosition(120,25)     --刷新剩余时间

    elseif winSize.height == 768 then
        print("768")
    end
end

function CMysteriousShopLayer.initParameter(self)
    --mediator注册
    print("CMysteriousShopLayer.mediatorRegister 79")
    _G.g_MysteriousShopMediator = CMysteriousShopMediator (self)
    controller : registerMediator(  _G.g_MysteriousShopMediator )
 
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_TREASURE_SHOP_REQUEST" --商店面板数据协议发送
    local msg = REQ_TREASURE_SHOP_REQUEST()
    CNetwork : send(msg)
    print("CMysteriousShopLayer页面发送数据请求,完毕 88")

    self.GoodBuyBtnNo = nil
end

function CMysteriousShopLayer.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CMysteriousShopLayer.initView(self,_winSize,_layer)
    --底图
    self.m_allBackGroundSprite  = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --总底图
    self.m_allBackGroundSprite  : setPreferredSize(CCSizeMake(825,485))  
    _layer                      : addChild(self.m_allBackGroundSprite)  

    local function BtnCallBack(eventType, obj, x, y)
       return self : ButtonCallBack(eventType,obj,x,y)
    end
    local function GoodsBtnCallBack(eventType, obj, touches)
       return self : TouchesCallback(eventType, obj, touches)
    end
    --关闭按钮
    -- self.CloseBtn   = CButton : createWithSpriteFrameName("","general_close_normal.png")
    -- self.CloseBtn   : setTag(CMysteriousShopLayer.closeBtnTag)        
    -- self.CloseBtn   : setTouchesPriority(-3)    
    -- self.CloseBtn   : registerControlScriptHandler(BtnCallBack,"this CMysteriousShopLayer CloseBtnCallBack 89")
    -- self.Scenelayer : addChild (self.CloseBtn,2)
    --神秘商人Label
    -- self.MysteriousBusinessmanLabel = CCLabelTTF :create("神秘商人","Arial",25)
    -- _layer                          : addChild (self.MysteriousBusinessmanLabel,2)

    -- self.EquipmentManufactureSprite  = CSprite : createWithSpriteFrameName("Equip_BackSecondBox.png") --顶端背景图
    -- self.EquipmentManufactureSprite  : setPreferredSize(CCSizeMake(_winSize.width-10,_winSize.height*0.1-10)) 
    -- _layer                           : addChild (self.EquipmentManufactureSprite,1) 
    --------------------------------------------------------------------------------------------------

    --物品列表
    self.GoodsLayout = CHorizontalLayout : create()
    self.GoodsLayout : setControlName("CMysteriousShopLayer  GoodsLayout 93")
    self.GoodsLayout : setLineNodeSum(2)
    self.GoodsLayout : setVerticalDirection(false)
    self.GoodsLayout : setCellSize(CCSizeMake(410,155))
    _layer : addChild(self.GoodsLayout)

    self.GoodsBtn       = {} --物品按钮
    self.GoodsNameLael  = {} --物品名字
    self.GoodsPriceLael = {} --物品价格
    self.GoodsCountLael = {} --物品数量    
    self.GoodsBuyBtn    = {} --物品购买按钮
    self.GoodsBtnSpriteBtn = {}

    for i=1,6 do
        self.GoodsBtn[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
        --self.GoodsBtn[i] : setTouchesMode( kCCTouchesAllAtOnce )
        self.GoodsBtn[i] : setTouchesEnabled( true)
        self.GoodsBtn[i] : setTouchesPriority(-10)
        self.GoodsBtn[i] : setTag(CMysteriousShopLayer.m_GoodBuyBtnTag[i]*10)
        self.GoodsBtn[i] : registerControlScriptHandler(BtnCallBack,"this CMysteriousShopLayer GoodsBuyBtn[i]CallBack 120")       
        self.GoodsLayout : addChild(self.GoodsBtn[i])

        self.GoodsBtnSpriteBtn[i] = CSprite : createWithSpriteFrameName("general_underframe_normal.png")
        self.GoodsBtnSpriteBtn[i] : registerControlScriptHandler(GoodsBtnCallBack,"this GoodsBtnSpriteBtni GoodsBuyBtn[i]CallBack 120")
        self.GoodsBtnSpriteBtn[i] : setTag(CMysteriousShopLayer.m_GoodBuyBtnTag[i]*10)
        self.GoodsBtnSpriteBtn[i] : setPosition(145,0) 
        self.GoodsBtnSpriteBtn[i] : setTouchesMode( kCCTouchesAllAtOnce )
        self.GoodsBtnSpriteBtn[i] : setTouchesEnabled(true)
        self.GoodsBtnSpriteBtn[i] : setTouchesPriority(-5)
        self.GoodsBtnSpriteBtn[i] : setPreferredSize(CCSizeMake(400,145))
        self.GoodsBtn[i]          : addChild(self.GoodsBtnSpriteBtn[i],-5)        

        self.GoodsNameLael[i]  = CCLabelTTF :create("物品名","Arial",20)
        self.GoodsPriceLael[i] = CCLabelTTF :create("物品价格","Arial",20)
        self.GoodsCountLael[i] = CCLabelTTF :create("物品数量","Arial",18)

        self.GoodsBuyBtn[i]    = CButton : createWithSpriteFrameName("购买","general_smallbutton_click.png") 
        self.GoodsBuyBtn[i]    : registerControlScriptHandler(BtnCallBack,"this CMysteriousShopLayer GoodsBuyBtn[i]CallBack 120")
        self.GoodsBuyBtn[i]    : setTag(CMysteriousShopLayer.m_GoodBuyBtnTag[i])
        self.GoodsBuyBtn[i]    : setTouchesPriority(-7)

        self.GoodsNameLael[i]  : setAnchorPoint( ccp(0.0, 0.5)) 
        self.GoodsPriceLael[i] : setAnchorPoint( ccp(0.0, 0.5))
        self.GoodsCountLael[i] : setAnchorPoint( ccp(0.5, 0.5))  
        self.GoodsPriceLael[i] : setColor(ccc3(255,255,0))
        self.GoodsBuyBtn[i]    : setFontSize(24)

        self.GoodsNameLael[i]  : setPosition(60,20)
        self.GoodsPriceLael[i] : setPosition(60,-10)
        self.GoodsCountLael[i] : setPosition(30,-30)
        self.GoodsBuyBtn[i]    : setPosition(280,0) 
              
        self.GoodsBtn[i]      : addChild(self.GoodsPriceLael[i],1)
        self.GoodsBtn[i]      : addChild(self.GoodsNameLael[i],1)
        self.GoodsBtn[i]      : addChild(self.GoodsBuyBtn[i])
        self.GoodsBtn[i]      : addChild(self.GoodsCountLael[i],1)
    end
    --分割线-------------------------------------------------------------------------------------
    -- self.m_partingLine  = CSprite : createWithSpriteFrameName("Equip_BackSecondBox.png") --分割线
    -- self.m_partingLine  : setScaleY(0.5)
    -- self.m_partingLine  : setScaleX(27)
    -- _layer              : addChild(self.m_partingLine)    

    --花费label
    self.RefreshTimeLabel      = CCLabelTTF :create("每小时刷新一次","Arial",18)
    self.RefreshLeftTimeLabel  = CCLabelTTF :create("00:00:00","Arial",18)  

    self.RefreshTimeLabel     : setAnchorPoint( ccp(0.0, 0.5)) 
    self.RefreshLeftTimeLabel : setAnchorPoint( ccp(0.0, 0.5))
    self.RefreshLeftTimeLabel : setColor(ccc3(255,255,0)) 

    _layer              : addChild(self.RefreshTimeLabel)
    _layer              : addChild(self.RefreshLeftTimeLabel)
    --刷新按钮
    self.RefreshBtn = CButton :createWithSpriteFrameName("立即刷新","general_button_normal.png")
    self.RefreshBtn : setFontSize(24)
    self.RefreshBtn : registerControlScriptHandler(BtnCallBack,"this CMysteriousShopLayer RefreshBtnCallBack 145")
    self.RefreshBtn : setTouchesPriority(-2)
    self.RefreshBtn : setTag(CMysteriousShopLayer.RefreshBtnTag)
    _layer          : addChild(self.RefreshBtn)
    --花费label
    self.RefreshMoneyLabel  = CCLabelTTF :create("","Arial",18)
    self.RefreshMoneyLabel  : setColor(ccc3(255,255,0)) 
    _layer                  : addChild(self.RefreshMoneyLabel)
end

function CMysteriousShopLayer.ButtonCallBack(self,eventType,obj,x,y)  --页面按钮回调
   if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        print("ButtonCallBack tagvalue= ",tagvalue)
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if tagvalue == CMysteriousShopLayer.closeBtnTag  then
                print("关闭按钮回调")
                self : removeGoodsBtnSpriteBtnCCBI() --删除ccbi
                controller : unregisterMediator(_G.g_MysteriousShopMediator)
                _G.g_MysteriousShopMediator = nil
                self.Scenelayer : removeFromParentAndCleanup(true)

            elseif tagvalue == CMysteriousShopLayer.RefreshBtnTag  then 
                print("刷新按钮回调")
                ------------------------------------------------
                -- require "view/LuckyLayer/PopBox"
                -- self.RefreshPopBox = CPopBox() --初始化
                -- local function PopBoxbtnCallBack( )
                --     require "common/protocol/auto/REQ_TREASURE_MONEY_REFRESH" --金元刷新面板
                --     local msg = REQ_TREASURE_MONEY_REFRESH()
                --     CNetwork : send(msg)
                -- end
                -- self.RefreshPopBoxPopBoxLayer = self.RefreshPopBox :create(PopBoxbtnCallBack,"是否确认花费50钻石刷新")
                -- self.RefreshPopBoxPopBoxLayer : setPosition(0,0)
                -- self.Scenelayer  : addChild(self.RefreshPopBoxPopBoxLayer,101) 
                -- print("生出了那个框框了")
                
                local msg = "是否确认花费".._G.Constant.CONST_TREASURE_STORE_REFRESH_RMB.."美刀刷新?"
                local function fun1()
                    require "common/protocol/auto/REQ_TREASURE_MONEY_REFRESH" --金元刷新面板
                    local msg = REQ_TREASURE_MONEY_REFRESH()
                    CNetwork : send(msg)
                end
                local function fun2()
                    print("不要了")
                end
                self : createMessageBox(msg,fun1,fun2)
                -------------------------------------------------
            end

            for i=1,6 do
                if tagvalue == CMysteriousShopLayer.m_GoodBuyBtnTag[i] then
                    print("6件物品中第"..i.."件购买回调")
                    _G.g_PopupView :reset()
                    self.GoodBuyBtnNo = tagvalue
                    ------------------------------------------------
                    -- require "view/LuckyLayer/PopBox"
                    -- self.GoodBuyPopBox = CPopBox() --初始化
                    -- local function PopBoxbtnCallBack( )
                    --     self : GoodDataSend(i) --单个物品数据传输到制作界面
                    -- end
                    -- self.GoodBuyPopBoxLayer = self.GoodBuyPopBox :create(PopBoxbtnCallBack,"是否确认购买")
                    -- self.GoodBuyPopBoxLayer : setPosition(0,0)
                    -- self.Scenelayer  : addChild(self.GoodBuyPopBoxLayer,101) 
                    -- print("生出了那个框框了")
                    if self.theGoodsBtnSpriteBtnNo ~= nil then
                        local no  = self.theGoodsBtnSpriteBtnNo
                        self.GoodsBtnSpriteBtn[no] :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                        self.GoodsBtnSpriteBtn[no] :  setPreferredSize(CCSizeMake(400,145))     
                        self :  removeGoodsBtnSpriteBtnCCBI() --删除特效                  
                    end

                    self.GoodsBtnSpriteBtn[tagvalue] :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                    self.GoodsBtnSpriteBtn[tagvalue] :  setPreferredSize(CCSizeMake(400,145))
                    self.theGoodsBtnSpriteBtnNo = tagvalue
                    self : createGoodsBtnSpriteBtnCCBI(tagvalue)  --创建特效
                

                    local msg = "是否确认购买?"
                    local function fun1()
                        self : GoodDataSend(i) 
                    end
                    local function fun2()
                        print("不要了")
                    end
                    self : createMessageBox(msg,fun1,fun2)
                    -------------------------------------------------
                end
                if tagvalue == CMysteriousShopLayer.m_GoodBuyBtnTag[i]*10 then
                    --删除Tips
                    print("Tips")
                    _G.g_PopupView :reset()
                    local _position = {}
                    _position.x = x
                    _position.y = y
                    no = tagvalue / 10
                    local  temp =  _G.g_PopupView :createByGoodsId(self.GoodListData[no].goods_id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
                    self.Scenelayer :addChild( temp)

                    --if  self.isSceletedTheTips ~= nil and self.isSceletedTheTips ~= tagvalue then
                        if self.theGoodsBtnSpriteBtnNo ~= nil then
                            local no  = self.theGoodsBtnSpriteBtnNo
                            self.GoodsBtnSpriteBtn[no] :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                            self.GoodsBtnSpriteBtn[no] :  setPreferredSize(CCSizeMake(400,145)) 
                            self :  removeGoodsBtnSpriteBtnCCBI() --删除特效                       
                        end
                    
                        self.GoodsBtnSpriteBtn[i] :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                        self.GoodsBtnSpriteBtn[i] :  setPreferredSize(CCSizeMake(400,145))
                        self.theGoodsBtnSpriteBtnNo = i
                        self : createGoodsBtnSpriteBtnCCBI(i)  --创建特效
                        --self.isSceletedTheTips      =  tagvalue
                   -- end
                end
            end
        end
    end
end

function CMysteriousShopLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end

function CMysteriousShopLayer.TouchesCallback(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(),self.touchID)
    _G.g_PopupView :reset()

    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchGoodId = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.touchGoodId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                local value =  obj :getTag() 
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then


                    for i=1,6 do
                        print("准备换图片")
                        if value == CMysteriousShopLayer.m_GoodBuyBtnTag[i]*10 then
                            print("换图片拉")
                            if self.theGoodsBtnSpriteBtnNo ~= nil then
                                local no  = self.theGoodsBtnSpriteBtnNo
                                self.GoodsBtnSpriteBtn[no] :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                                self.GoodsBtnSpriteBtn[no] :  setPreferredSize(CCSizeMake(400,145))       
                                self :  removeGoodsBtnSpriteBtnCCBI() --删除特效                  
                            end
                            self.GoodsBtnSpriteBtn[i] :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                            self.GoodsBtnSpriteBtn[i] :  setPreferredSize(CCSizeMake(400,145))
                            self.theGoodsBtnSpriteBtnNo = i 
                            self : createGoodsBtnSpriteBtnCCBI(i)  --创建特效 
                        end
                        print("换图片了")
                    end
                    self.thetouchID     = nil
                    self.thetouchGoodId = nil
                end
            end
        end
        print( eventType,"END")
    end
end

--单个物品数据购买协议发送
function CMysteriousShopLayer.GoodDataSend(self,_i) 
             
    local   TheGood  = self.GoodListData[_i]                                   --选中物品
    print("TransmissionGoodData==",TheGood.name,"gold and rmb ",self.m_GoldNum,self.m_RmbNum)

    local  isOKtoSend = 0 
    if tonumber(TheGood.price_type) == 1 then
        if self.m_GoldNum > tonumber(TheGood.price) then
            isOKtoSend = 1 
        end
    elseif tonumber(TheGood.price_type) == 2 then
        if self.m_RmbNum > tonumber (TheGood.price )  then
            isOKtoSend = 1 
        end
    end

    if isOKtoSend == 1 then
        --向服务器发送页面数据请求
        require "common/protocol/auto/REQ_TREASURE_PURCHASE" --商店面板数据协议发送
        local msg = REQ_TREASURE_PURCHASE()
        msg       : setGoodsId (TheGood.goods_id)
        CNetwork  : send(msg)
        print("CMysteriousShopLayer页面发送购买请求,完毕 243",TheGood.goods_id)

        self : lockScene() --锁屏
    elseif isOKtoSend == 0 then
        local msg = "美刀不足,招财可获得美刀！"
        self : createMessageBox(msg)
    end
end

--mediator传送过来的数据（同时也是初始化）
function CMysteriousShopLayer.pushData(self,_Time,_GoodsData,_Count)   
    self : removeIconResources()
    local LeftTime   = 0   
    LeftTime         = _Time
    local Count      = _Count     --物品数量
    local GoodsData  = _GoodsData  --6个物品表（sever）

    self.GoodListData   = {}
    self.OneGoodsSprite = {}
    for k,v in pairs(GoodsData) do
        self.GoodListData[k] = {}
        --self.GoodListData[k] = self : OneGoodsXmlData(v.goods_id,v.goods_count,v.state)  
        self.GoodListData[k] = self : OneGoodsXmlData(v)  

        local  OneGoods = self : OneGoodsXmlData (v) --单个物品xml解析
        --local  OneGoods = self : OneGoodsXmlData (v.goods_id,v.goods_count,v.state) --单个物品xml解析
        self : initOneEquipmentParameter (k,OneGoods)                 --单个物品view初始化   
    end

    print("_G.Constant.CONST_TREASURE_STORE_REFRESH_RMB",_G.Constant.CONST_TREASURE_STORE_REFRESH_RMB)
    local refresh_rmb = _G.Constant.CONST_TREASURE_STORE_REFRESH_RMB
    self.RefreshMoneyLabel : setString ("(立即刷新需花费 "..refresh_rmb.." 美刀)","Arial",18)

   --倒计时
    self : setReceiveAwardsTime(LeftTime)
    self : registerEnterFrameCallBack()


    local mainProperty = _G.g_characterProperty : getMainPlay()
    --获取美刀
    self.m_GoldNum   = tonumber(mainProperty :getGold()) 
    if self.m_GoldNum  == nil then
        self.m_GoldNum = 0
    end
    --获取钻石
    self.m_RmbNum     = tonumber(mainProperty :getBindRmb()) 
    if self.m_RmbNum  == nil then
        self.m_RmbNum = 0
    end

    if self.theGoodsBtnSpriteBtnNo ~= nil then
        local no  = self.theGoodsBtnSpriteBtnNo
        self.GoodsBtnSpriteBtn[no] :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
        self.GoodsBtnSpriteBtn[no] :  setPreferredSize(CCSizeMake(400,145))                        
    end
end

--单个物品xml解析
--function CMysteriousShopLayer.OneGoodsXmlData(self,_goodId,_count,_state)
function CMysteriousShopLayer.OneGoodsXmlData(self,_data)
    local _goodId = nil 
    local _count  = nil 
    local _state  = nil 


    _goodId = _data.goods_id
    if _data.goods_count ~= nil then
        _count  = _data.goods_count
    end
    _state  = _data.state

    print("248 OneEquipmentXmlData,id=",_goodId,_state)
    local OneGoodNode1       =   _G.Config.hidden_stores : selectSingleNode("hidden_store[@goods_id="..tostring(_goodId).."]") --装备节点
    local OneGoodData        = {}
    if OneGoodNode1 : isEmpty() == false then
        OneGoodData.goods_id     = OneGoodNode1: getAttribute("goods_id")    
        OneGoodData.goods_count  = OneGoodNode1: getAttribute("goods_count")
        OneGoodData.price_type   = OneGoodNode1: getAttribute("price_type")
        OneGoodData.price        = OneGoodNode1: getAttribute("price")
    end
    
    local OneGoodNode2       = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_goodId).."]")
    if OneGoodNode2 : isEmpty() == false then
        OneGoodData.name         = OneGoodNode2: getAttribute("name")      
        OneGoodData.icon         = OneGoodNode2: getAttribute("icon")   
    end

    if  _count ~= nil then
        OneGoodData.count        = _count --(From sever)
    end
    OneGoodData.state            = _state --(From sever)
    
    return OneGoodData
end

--单个物品view初始化
function CMysteriousShopLayer.initOneEquipmentParameter(self,_no,_OneGoodsData) 

    local OneGoodsData       = _OneGoodsData 
    local icon_url           = "Icon/i"..OneGoodsData.icon..".jpg"
    self.OneGoodsSprite[_no] = CSprite : create(icon_url)            
    self.GoodsBtn[_no]       : addChild(self.OneGoodsSprite[_no],-2)
    self.GoodsBuyBtn[_no]    : setTouchesEnabled(true) --刷新变为可按

    self.GoodsNameLael[_no]  : setString( OneGoodsData.name )

    if tonumber(OneGoodsData.price_type) == 1 then
        --self.MoneySprite         = CSprite : createWithSpriteFrameName("menu_icon_dollar.png")
        self.GoodsPriceLael[_no] : setString( "价格 :"..OneGoodsData.price.."美刀")
    elseif tonumber(OneGoodsData.price_type) == 2 then
        --self.MoneySprite         = CSprite : createWithSpriteFrameName("menu_icon_diamond.png")
        self.GoodsPriceLael[_no] : setString( "价格 :"..OneGoodsData.price.."钻石")
    end

    if OneGoodsData.count ~= nil then
        self.GoodsCountLael[_no] : setString(OneGoodsData.count)
    end

    if OneGoodsData.state == 1 then   --1:可以购买|0:不可购买
       self.GoodsBuyBtn[_no] : setTouchesEnabled(true) --刷新变为可按
    elseif OneGoodsData.state == 0 then
        self.GoodsBuyBtn[_no] : setTouchesEnabled(false) --刷新变为可按
    end
    --self.MoneySprite         : setPosition (-55,50)          
    --self.GoodsBuyBtn[_no]    : addChild(self.MoneySprite,1)
end

function CMysteriousShopLayer.registerEnterFrameCallBack(self)
    --获取服务器时间
    self.startServerTime    = _G.g_ServerTime : getServerTimeSeconds()
    self.ishaveResetTime    = 0 
    print( "CMysteriousShopLayer.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset() 
        self :updataReceiveAwardsTime( _duration)
    end
    self.Scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CMysteriousShopLayer.updataReceiveAwardsTime( self, _duration)


    -- if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
    --     --倒计时时间到了再重新向服务器请求
    --     require "common/protocol/auto/REQ_TREASURE_INTERVAL_REFRESH" -- [47275]定时刷新 -- 珍宝阁系统
    --     local msg = REQ_TREASURE_INTERVAL_REFRESH()
    --     CNetwork : send(msg)
    --     print("CMysteriousShopLayer 定时刷新,完毕 88")
    --     return
    -- end

    --self.m_receiveawardstime = self.m_receiveawardstime - _duration
    local time = self.startServerTime + self.m_receiveawardstime - _G.g_ServerTime : getServerTimeSeconds()

    if time ~= nil and time == 0 then
        --倒计时时间到了再重新向服务器请求
        if self.ishaveResetTime ~= nil and   self.ishaveResetTime == 0 then
            require "common/protocol/auto/REQ_TREASURE_INTERVAL_REFRESH" -- [47275]定时刷新 -- 珍宝阁系统
            local msg = REQ_TREASURE_INTERVAL_REFRESH()
            CNetwork : send(msg)
            print("CMysteriousShopLayer 定时刷新,完毕 88")
            self.ishaveResetTime = 1  
            return
        end
    end

    if time <= 0 then
        print("完毕")
    else
        -- local time = self.startServerTime + self.m_receiveawardstime - _G.g_ServerTime : getServerTimeSeconds()
        local fomarttime = self :turnTime( time)
        --local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.RefreshLeftTimeLabel :setString("下次刷新时间 : "..fomarttime)
        --self.isResetTime = time
    end
end

--倒计时
function CMysteriousShopLayer.setReceiveAwardsTime(self, _time)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
    local fomarttime = self :turnTime( self.m_receiveawardstime)
    self.RefreshLeftTimeLabel :setString(fomarttime)
end

function CMysteriousShopLayer.turnTime( self, _time)
    _time = _time < 0 and 0 or _time
    local hor  = math.floor( _time/(60*60))
    hor = hor < 0 and 0 or hor
    local min  = math.floor( _time/60-hor*60)
    min = min < 0 and 0 or min
    local sec  = math.floor( _time-hor*60*60-min*60)
    sec = sec < 0 and 0 or sec    
    hor = self :toTimeString( hor)
    min = self :toTimeString( min )
    sec = self :toTimeString( sec )
    return hor..":"..min..":"..sec
end
--{时间转字符串}
function CMysteriousShopLayer.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end

function CMysteriousShopLayer.isBuyOk(self,_State)
    if  _State    == 1 then
        print("ACK_TREASURE_PURCHASE_STATE购买成功")

        local msg = "购买成功"
        self : createMessageBox(msg)

        self : unlockScene() --解屏

        if self.GoodBuyBtnNo ~= nil and self.GoodBuyBtnNo > 0 then
            local no = self.GoodBuyBtnNo
            self.GoodsBuyBtn[no] : setTouchesEnabled(false)
        end

    elseif _State == 0 then
        print("ACK_TREASURE_PURCHASE_STATE购买失败")

        local msg = "购买失败"
        self : createMessageBox(msg)

        self : unlockScene() --解屏
    end
end

function CMysteriousShopLayer.removeIconResources(self)
    print("释放前前前")

    if self.GoodListData ~= nil then
        local count = #self.GoodListData
        for i=1,count do
            if self.OneGoodsSprite[i] ~= nil then
                self.OneGoodsSprite[i] : removeFromParentAndCleanup(true)
                self.OneGoodsSprite[i] = nil
            end
            local icon_url = "Icon/i"..self.GoodListData[i].icon..".jpg"
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
    print("释放后后后")
end

function CMysteriousShopLayer.createGoodsBtnSpriteBtnCCBI( self, _no  )

    self.nowTheSpriteBtnCCBINo = _no
    local function local_animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_animationCallFunc  "..eventType )
            arg0 : play("run")
        end
    end

    _size = self.GoodsBtnSpriteBtn[_no] : getPreferredSize()
    local n_Y     = 3
    local n_X     = 5
    self.ccbi_up = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    self.ccbi_up : setControlName( "this CActivitiesView ccbi_up 84")
    self.ccbi_up : registerControlScriptHandler( local_animationCallFunc )
    self.ccbi_up : setPosition( -_size.width/2 + n_X, _size.height/2 - n_Y)
    self.GoodsBtnSpriteBtn[_no] : addChild( self.ccbi_up,1,901 )

    self.ccbi_down = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    self.ccbi_down : setControlName( "this CActivitiesView ccbi_down 84")
    self.ccbi_down : registerControlScriptHandler( local_animationCallFunc )
    self.ccbi_down : setPosition( _size.width/2 - n_X, - _size.height/2 + n_Y)
    self.GoodsBtnSpriteBtn[_no] : addChild( self.ccbi_down,1,902 )

    local function local_moveActionCallBack()
        self : removeGoodsBtnSpriteBtnCCBI() --删除ccbi

        self:createGoodsBtnSpriteBtnCCBI( _no )
    end

    --移动CCBI
    local actionTime = 0.66
    local _action_up = CCArray:create()
    _action_up:addObject(CCMoveTo:create( actionTime, ccp( _size.width/2 - n_X,_size.height/2 - n_Y ) ))
    _action_up:addObject(CCCallFunc:create(local_moveActionCallBack))
    self.ccbi_up : runAction( CCSequence:create(_action_up) )

    local _action_down = CCArray:create()
    _action_down:addObject(CCMoveTo:create( actionTime, ccp( -_size.width/2 + n_X,-_size.height/2 + n_Y ) ))
    -- _action_down:addObject(CCCallFunc:create(local_moveActionCallBack))
    self.ccbi_down : runAction( CCSequence:create(_action_down) )
end

function CMysteriousShopLayer.removeGoodsBtnSpriteBtnCCBI( self )  --删除ccbi
    if self.ccbi_up ~= nil then
        self.ccbi_up : removeFromParentAndCleanup( true )
        self.ccbi_up = nil
    end

    if self.ccbi_down ~= nil then
        self.ccbi_down : removeFromParentAndCleanup( true )
        self.ccbi_down = nil
    end 
end

function CMysteriousShopLayer.resetGoodsBtnSpriteBtnCCBI( self )  --回复ccbi所在的背景图
    if  self.nowTheSpriteBtnCCBINo ~= nil  then
        local no = self.nowTheSpriteBtnCCBINo 
        if self.GoodsBtnSpriteBtn[no] ~= nil then
            self.GoodsBtnSpriteBtn[no] :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
            self.GoodsBtnSpriteBtn[no] :  setPreferredSize(CCSizeMake(400,145))  
        end
    end
end

--锁住屏幕
function CMysteriousShopLayer.lockScene( self )
    print("锁住屏幕 CMysteriousShopLayer.lockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end
end
--解锁屏幕点击
function CMysteriousShopLayer.unlockScene( self )

    print("解锁屏幕点击 CMysteriousShopLayer.lockScene   unlockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end
end
