require "controller/command"
require "view/view"


require "mediator/ShopLayerMediator"




CShopLayer = class(view,function (self)
                            self.Count = 0
                            -- self.Gem_GoodListData       = {}
                            -- self.Equipment_GoodListData = {}
                            -- self.Material_GoodListData  = {}
                            self.mall_id                = nil
                            end)

CShopLayer.ShopBtnTag       = 1
CShopLayer.closeBtnTag      = 2
CShopLayer.RechargeBtnTag   = 3

CShopLayer.TAG_GemPage         = 11
CShopLayer.TAG_EquipmentPage   = 22
CShopLayer.TAG_MaterialPage    = 33

CShopLayer.TAG_ShopPage    = {}
CShopLayer.TAG_ShopPage[1] = 11
CShopLayer.TAG_ShopPage[2] = 22
CShopLayer.TAG_ShopPage[3] = 33
CShopLayer.TAG_ShopPage[4] = 44
CShopLayer.TAG_ShopPage[5] = 55

function CShopLayer.scene(self,_mall_id)
    local function CContainerCallBack(eventType, obj, x, y)
        return self : onCContainerCallBack(eventType,obj,x,y)
    end

    self.mall_id = _mall_id
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.m_layer  : registerControlScriptHandler(CContainerCallBack,"this is m_layer  295")
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层
    return self.scene
end

function CShopLayer.onCContainerCallBack(self,eventType, obj, x, y)
    print("场景2",eventType, obj, x, y)
    if eventType == "TransitionFinish" then

        print("场景切换结束----")
        self : initParameter()                 --参数初始化
        self : layout()                        --适配布局初始化
    end
end

function CShopLayer.layer(self,_winSize)
    --local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)

    return self.Scenelayer
end

function CShopLayer.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")    --货币

    _G.Config:load("config/goods.xml")
    _G.Config:load("config/mall_class.xml")
    _G.Config:load("config/mall_name.xml")
end

function CShopLayer.unloadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("Shop/ShopReSources.pvr.ccz")

    _G.Config:unload("config/mall_class.xml")
    _G.Config:unload("config/mall_name.xml")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CShopLayer.layout(self)  --适配布局
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   
    if winSize.height == 640 then
        self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)              --总底图
        self.m_allSecondBackGroundSprite : setPosition(IpadSizeWidth/2,IpadSizeheight/2)              --总底图
        self.m_allFirstBackGroundSprite  : setPosition(IpadSizeWidth/2,550/2+15)                      --总底图

        local closeSize                  = self.CloseBtn: getContentSize()
        self.CloseBtn                    : setPosition(IpadSizeWidth-closeSize.width/2, IpadSizeheight-closeSize.height/2)  --关闭按钮
        self.RechargeBtn                 : setPosition(IpadSizeWidth-200, IpadSizeheight-closeSize.height/2-5)
        self.tab                         : setPosition(20,IpadSizeheight-45)
        self.m_pageLabel                 : setPosition(IpadSizeWidth/2-10,40) 
        self.pageLabelSprite             : setPosition(IpadSizeWidth/2,40)  
        self.m_MoneyLabel                : setPosition(IpadSizeWidth/8,40) 
        self.MoneySprite                 : setPosition(IpadSizeWidth/8-20,40) 

    elseif winSize.height == 768 then
        print("768")
    end
end

function CShopLayer.initParameter(self)
    if self.mall_id ~= nil and self.mall_id > 0 then
        self : getMallDataFromXML(self.mall_id) --获取商城数据
    else
        self : getMallDataFromXML(10)           --获取默认的商城数据 10
    end
    --mediator注册
    print("CShopLayer.mediatorRegister 57")
    _G.g_ShopLayerMediator = CShopLayerMediator (self)
    controller :registerMediator(  _G.g_ShopLayerMediator )

    if self.MallListData ~= nil then
        local  loop = tonumber(self.MallListData.loop)

        self : initTabPageView (loop,self.MallListData) --初始化page界面

        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local id      = tonumber(self.MallListData[i].class_id)  
                print("gettheid = ",id)
                if  id > 0 then
                    self : PageNetWorkSend(10,id)   --netwrok面板协议发送(初始化)
                end
            end
        end
    end

    self.nPlayLv   = 0
    local mainplay = _G.g_characterProperty :getMainPlay()
    self.nPlayLv   = tonumber(mainplay : getLv()) 
    self.PageGoodListData  = {}
    self.PageGoodListCount = {}

    
end

function CShopLayer.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : initParameter()                        --参数初始化
    self : layout(_winSize)                       --适配布局初始化
end

function CShopLayer.initView(self,_winSize,_layer)
    local IpadSize =854
    self.BackContainer = CContainer : create()
    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)
    _layer             : addChild(self.BackContainer)
    --底图
    self.m_allBackGroundSprite   = CSprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))
    _layer :addChild(self.m_allBackGroundSprite,-2)

    self.m_allFirstBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --第一底图
    self.m_allFirstBackGroundSprite   : setPreferredSize(CCSizeMake(820,550)) 
    self.BackContainer : addChild(self.m_allFirstBackGroundSprite)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,640)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite,-1)
    
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    --关闭按钮
    self.CloseBtn         = CButton : createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn         : setTouchesPriority(-3)   
    self.CloseBtn         : setTag(CShopLayer.closeBtnTag)
    self.CloseBtn         : registerControlScriptHandler(CallBack,"this CShopLayer CloseBtnCallBack 83")
    self.BackContainer    : addChild (self.CloseBtn)
    --充值按钮
    self.RechargeBtn   = CButton :createWithSpriteFrameName("","shop_button_recharge_normal.png")
    self.RechargeBtn   : setTouchesPriority(-3)   
    self.RechargeBtn   : registerControlScriptHandler(CallBack,"this CShopLayer DownLayerBtnCallBack 172")
    self.RechargeBtn   : setTag(CShopLayer.RechargeBtnTag)
    self.BackContainer : addChild(self.RechargeBtn)

    self : Create_effects_button(self.RechargeBtn)


    --页数
    self.m_pageLabel   = CCLabelTTF :create( "0/0", "Arial", 22)
    self.m_pageLabel   : setAnchorPoint( ccp(0.0, 0.5))
    self.BackContainer : addChild(self.m_pageLabel,100)

    self.pageLabelSprite = CSprite : createWithSpriteFrameName("general_pagination_underframe.png")
    self.BackContainer   : addChild(self.pageLabelSprite,5)

    --美刀钻石数量显示
    self.MoneySprite = CSprite : createWithSpriteFrameName("menu_icon_dollar.png")
    self.BackContainer   : addChild(self.MoneySprite,5)

    self.m_MoneyLabel   = CCLabelTTF :create( "", "Arial", 18)
    self.m_MoneyLabel   : setAnchorPoint( ccp(0.0, 0.5))
    self.BackContainer : addChild(self.m_MoneyLabel,100)

end

function CShopLayer.Create_effects_button( self,obj)

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    if obj ~= nil then
        self.RechargeBtneffectsCCBI       = CMovieClip:create( "CharacterMovieClip/effects_button.ccbi" )
        self.RechargeBtneffectsCCBI       : setControlName( "this CCBI Create_effects_activity CCBI")
        self.RechargeBtneffectsCCBI       : registerControlScriptHandler( animationCallFunc)
        obj               : addChild(self.RechargeBtneffectsCCBI,1000) 
    end
end

function CShopLayer.initTabPageView(self,_pageCount,_data)

    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    --Tab
    self.tab = CTab : create (eLD_Horizontal, CCSizeMake(130, 60))--按钮间距
    self.BackContainer   : addChild (self.tab)
    --TabPage
    self.ShopPage ={}
    self.m_ShopPageContainer = {}
    if _pageCount ~= nil and _pageCount > 0 then
        for i=1,_pageCount do
            print("wsm 出错了 了 ",i)
            local name       = _data[i].class_name
            self.ShopPage[i] = CTabPage : createWithSpriteFrameName(name,"general_label_normal.png",name,"general_label_click.png")
            self.ShopPage[i] : setFontSize(20)
            self.ShopPage[i] : setTouchesPriority(-3)
            self.ShopPage[i] : setTag (CShopLayer.TAG_ShopPage[i])
            self.ShopPage[i] : registerControlScriptHandler(CallBack,"this is CShopLayer ShopPage[i] 225 ")

            self.m_ShopPageContainer[i] = CContainer : create()
            self.m_ShopPageContainer[i] : setControlName( "this is CShopLayer m_ShopPageContainer 228" )

            self.tab : addTab(self.ShopPage[i],self.m_ShopPageContainer[i])  
        end
    end
 
    self.tab : onTabChange(self.ShopPage[1])                   --设置初始页
    self.thePageCallBcakTypeBb =tonumber(_data[1].class_id )   --设置初始页的子店铺类型
end

function CShopLayer.CallBack(self,eventType,obj,x,y)  --页面按钮回调
    if eventType == "TouchBegan" then
        print("CallBack TouchBegan",obj : getTag(),self.nPlayLv)
        local tagvalue = obj : getTag()
        if self.MallListData ~= nil then
            local  loop = tonumber(self.MallListData.loop)
            if loop ~= nil and loop > 0 then
                for i=1,loop do
                    if tagvalue == CShopLayer.TAG_ShopPage[i]  then
                        print("pagepage")   
                        local id    = self.MallListData[i].class_id
                        local lv    = self.MallListData[i].open_lv 
                        if  self.nPlayLv < tonumber(lv) then
                            local msg = "宝石按钮开放等级为"..lv.."级"
                            self : createMessageBox(msg)
                            return false
                        end
                    end
                end
            end
        end
        return true        
    elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        print("ButtonCallBack tagvalue= ",tagvalue)
        local winSize = CCDirector:sharedDirector():getVisibleSize()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if tagvalue == CShopLayer.closeBtnTag  then
                print("关闭按钮回调")
                _G.g_PopupView :reset()
                --mediator反注册
                if _G.g_ShopLayerMediator ~= nil then
                    controller :unregisterMediator(_G.g_ShopLayerMediator)
                    _G.g_ShopLayerMediator = nil
                    print("CShopLayer unregisterMediator.g_CShopLayerMediator 182")
                end
                ---------
                self : removeAllCCBI () --删除所有的CCBI 


                _G.pCShopLayer  = nil
                self.Scenelayer : removeFromParentAndCleanup(true)
                CCDirector : sharedDirector () : popScene()
                self:unloadResources()
                _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon
                return
            elseif tagvalue == CShopLayer.RechargeBtnTag  then
                print("冲值回调")
                --local msg = "是否进行充值?"
                --local function fun1()
                    --local _rechargeScene = CRechargeScene:create()
                    --CCDirector:sharedDirector():pushScene(_rechargeScene)
                
                _G.g_PopupView :reset()
                --mediator反注册
                if _G.g_ShopLayerMediator ~= nil then
                    controller :unregisterMediator(_G.g_ShopLayerMediator)
                    _G.g_ShopLayerMediator = nil
                    print("CShopLayer unregisterMediator.g_CShopLayerMediator 182")
                end
                ---------
                self : removeAllCCBI () --删除所有的CCBI
                
                
                _G.pCShopLayer  = nil
                self.Scenelayer : removeFromParentAndCleanup(true)
                CCDirector : sharedDirector () : popScene()
                self:unloadResources()
                _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon
                
                    local command = CPayCheckCommand( CPayCheckCommand.ASK )
                    controller :sendCommand( command )
                --end
                --local function fun2()
                    --print("不要了")
                --end
                --self : createMessageBox(msg,fun1,fun2)
            end
            if self.MallListData ~= nil then
                local  loop = tonumber(self.MallListData.loop)
                if loop ~= nil and loop > 0 then
                    for i=1,loop do
                        if tagvalue == CShopLayer.TAG_ShopPage[i]  then   

                            self.thePageCallBcakTypeBb = tonumber(self.MallListData[i].class_id)  

                            self : setMainPropertyMoney(self.MallListData[i].class_id) --金钱显示
 
                            self.m_pageLabel : setString( "1".."/"..self.PageGoodListCount[i]) 
                        end
                    end
                end
            end
        end
    end
end

function CShopLayer.removeAllCCBI(self) 

    if self.RechargeBtneffectsCCBI ~= nil then
        print("要在关闭的时候关了")
        self.RechargeBtneffectsCCBI : removeFromParentAndCleanup(true)
        print("要在关闭的时候关了11")
        self.RechargeBtneffectsCCBI = nil 
    end
    if self.Count > 0 then
        local no = tonumber(self.Count)
        for i=1,no do
            if self["ccbi"..i] ~= nil then
                print("要在关闭的时候关了22-------")
                self["ccbi"..i] : removeFromParentAndCleanup(true)
                print("要在关闭的时候关了33")
                self["ccbi"..i] = nil 
            end 
        end
    end

    self : removeGoodsBtnSpriteBtnCCBI() --删除选框的ccbi
end

function CShopLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end

function CShopLayer.GoodsBuyButtonCallBack(self,eventType,obj,x,y)  --页面购买按钮回调
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()
        local  tagvalue = obj : getTag()


        if self.theOldSpriteBtnId ~= nil  then
            self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
            self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(400,115))

            self :  removeGoodsBtnSpriteBtnCCBI() --删除特效
            self.theOldSpriteBtnId = nil
        end

        local nowPage = self.thePageCallBcakTypeBb
        if self["GoodsBtnSpriteBtn"..nowPage][tagvalue] ~= nil then
            local objs = self["GoodsBtnSpriteBtn"..nowPage][tagvalue]
            print("要换图片")
            objs :  setImageWithSpriteFrameName( "general_underframe_click.png" )
            objs :  setPreferredSize(CCSizeMake(400,115))

            self : createGoodsBtnSpriteBtnCCBI(tagvalue)  --创建特效
            print("换图片了")
            self.theOldSpriteBtnId = objs
        end

        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("第"..tagvalue.."个购买按钮回调")

            if self.MallListData  ~= nil then
                local  loop = tonumber(self.MallListData.loop)
                if loop ~= nil and loop > 0 then
                    for i=1,loop do
                        local id =tonumber(self.MallListData[i].class_id) 

                        if self.thePageCallBcakTypeBb  == id  then   
                            theGoodListData = self.PageGoodListData[i]
                        end
                    end
                end
            end
            theGoodData = theGoodListData[tagvalue] 

            -- print("------>>>>>>>>>>",theGoodData.name,theGoodData.icon,theGoodData.idx,theGoodData.total_remaider_Num)
            ------------------------------------------------
            require "view/Shop/AdditionAndsubtractionPopBox"
            self.PopBox = CAdditionAndsubtractionPopBox() --初始化

            ThePopBox = self.PopBox : create(nil,nil,theGoodData)
            ThePopBox : setPosition(-20,0)

            self.Scenelayer : addChild(ThePopBox) 
            print("生出了那个框框了")
            -------------------------------------------------
        end
    end
end

function CShopLayer.TipsCallBack(self,eventType,obj,x,y)  --页面tips回调
    if eventType == "TouchBegan" then
        return true
        elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("弹tips的回调",tagvalue)
            _G.g_PopupView :reset()
            _position   = {}
            _position.x = x
            _position.y = y
            if tagvalue ~= nil then
                local  temp =  _G.g_PopupView :createByGoodsId(tagvalue, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
                self.Scenelayer :addChild(temp)
            end
        end

        local theno = nil 
        print("----",tagvalue)
        if self.GoodListData ~= nil then
            print("321")
            local data = self.GoodListData
            for k,v in pairs(data) do
                print("322",k,v.equipId)
                if tonumber(tagvalue) == tonumber(v.equipId) then
                    print("333",v.equipId,k)
                    theno = k 
                    break
                end
            end
        end
        print("theno-----",theno)
        if self.theOldSpriteBtnId ~= nil  then
            self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
            self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(400,115))

            self :  removeGoodsBtnSpriteBtnCCBI() --删除特效 
            self.theOldSpriteBtnId = nil
        end
        local nowPage = self.thePageCallBcakTypeBb
        if self["GoodsBtnSpriteBtn"..nowPage][theno] ~= nil then

            local objs = self["GoodsBtnSpriteBtn"..nowPage][theno]
            print("要换图片")
            objs :  setImageWithSpriteFrameName( "general_underframe_click.png" )
            objs :  setPreferredSize(CCSizeMake(400,115))

            self : createGoodsBtnSpriteBtnCCBI(theno)  --创建特效
            print("换图片了")
            self.theOldSpriteBtnId = objs
        end
        self.GoodsBtnSpriteBtnCallBackId = nil

    end
end
--多点触控
function CShopLayer.GoodsBtnSpriteBtnCallBack(self, eventType, obj, touches)
    print("多点触控一下",eventType,obj)
    _G.g_PopupView :reset()
    ----[[

    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.GoodsBtnSpriteBtnCallBackId = obj:getTag()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)

                    break
                else
                    if self.theOldSpriteBtnId ~= nil  then
                        --local oldid  = self.theOldSpriteBtnId
                        self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                        self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(400,115))

                        self : removeGoodsBtnSpriteBtnCCBI() --删除ccbi
                        self.theOldSpriteBtnId = nil
                    end
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
            if touch2:getID() == self.touchID and self.GoodsBtnSpriteBtnCallBackId == obj:getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    

                    if self.theOldSpriteBtnId ~= nil  then
                        print("设你透明")
                        --local oldid  = self.theOldSpriteBtnId
                        self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                        self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(400,115))

                        self :  removeGoodsBtnSpriteBtnCCBI() --删除特效
                        self.theOldSpriteBtnId = nil
                    end

                    --local id = self.GoodsBtnSpriteBtnCallBackId
                    local no      = self.GoodsBtnSpriteBtnCallBackId
                    local nowPage = self.thePageCallBcakTypeBb
                    if self["GoodsBtnSpriteBtn"..nowPage][no] ~= nil then
                        print("要换图片")
                        self["GoodsBtnSpriteBtn"..nowPage][no] : setImageWithSpriteFrameName("general_underframe_click.png")
                        self["GoodsBtnSpriteBtn"..nowPage][no] : setPreferredSize(CCSizeMake(400,115))

                        self : createGoodsBtnSpriteBtnCCBI(no)  --创建特效
                        print("换图片了")
                        self.theOldSpriteBtnId = self["GoodsBtnSpriteBtn"..nowPage][no]
                    end
                    self.touchID = nil
                    self.GoodsBtnSpriteBtnCallBackId = nil
                end
            end
        end
    end

   ----]]
end
--藏宝阁面板数据协议发送请求
function CShopLayer.PageNetWorkSend(self,_type,_type_bb)


    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_SHOP_REQUEST"
    local msg = REQ_SHOP_REQUEST()
    msg :setArguments(_type) --商店类型
    msg :setTypeBb(_type_bb) --商店子类型    
    CNetwork : send(msg)
    print("CShopLayer PageNetWorkSend页面发送数据请求,完毕 204")
end

--mediator传送过来的数据（同时也是初始化）
function CShopLayer.pushData(self,_vo_data,_Count,_TypeBb,_Type)
    --ScrollView的View初始化
    print("----->----->",_TypeBb,_Count,_Type)

    self.PageScrollView   = {}
    if self.MallListData ~= nil then
        local  loop = tonumber(self.MallListData.loop)

        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local   id  = tonumber(self.MallListData[i].class_id)
                if _TypeBb == id  then   
                    print("创建PageScrollView",CShopLayer.TAG_ShopPage[i],i)
                    self.PageScrollView[i]  = self : initOnePageView(_Count,_TypeBb)
                    self.m_ShopPageContainer[i] : addChild(self.PageScrollView[i])
                end
            end
        end
    end
    -------------------------------------------------------------------------
    local vo_data = _vo_data
    self.Type     = vo_data : getType    () --店铺类型
    self.TypeBb   = vo_data : getTypeBb  () --子店铺类型
    self.Count    = vo_data : getCount   () --物品数量
    self.Msg      = vo_data : getMsg     () --信息块
    self.EndTime  = vo_data : getEndTime () --结束时间

    print("CShopLayer.pushData --->>>>",self.Type,self.TypeBb,self.Count,self.Msg,self.EndTime)

    self.OneGoodsSprite ={}
    --物品
    self.GoodListData   = {}
    if self.Msg ~= nil then
        for k,v in pairs(self.Msg) do
            print("物品--5858---",k,v,v.total_remaider_Num,v.idx,v.goods_num)
            self.GoodListData[k] = {}
            self.GoodListData[k] = self : OneGoodsXmlData (v.goods_id,v.idx,v.type,v.s_price,v.v_price,v.total_remaider_Num,_TypeBb,_Type) --单个物品xml解析
             
            local  OneGoods = self : OneGoodsXmlData (v.goods_id,v.idx,v.type,v.s_price,v.v_price)    --单个物品xml解析
            self : initOneEquipmentParameter (k,OneGoods)                                             --单个物品view初始化
        end
    end
    --self.GoodListData = self : exchangeDataTable(self.GoodListData,_Count)
    if _Count ~=nil and  _Count > 0 then
        if math.mod( _Count,8 ) == 0 then
            thepageCount = math.floor(_Count/8)
        else
            thepageCount = math.floor(_Count/8)+1
        end 
    end

    if self.MallListData  ~= nil then
        local  loop = tonumber(self.MallListData.loop)
        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local id   = tonumber(self.MallListData[i].class_id) 
                if _TypeBb == id  then  
                    print("tybbbbb",_TypeBb,CShopLayer.TAG_ShopPage[i]) 
                    self.PageGoodListData[i]   = self.GoodListData 
                    self.PageGoodListCount[i]  = thepageCount
                    print("----thepageCount",thepageCount,_Count,i)
                end
            end
        end

        local   theFirstTypeid  = tonumber(self.MallListData[1].class_id)
        self : setMainPropertyMoney(theFirstTypeid) --金钱显示
    end

end

function CShopLayer.NetWorkReturn_SHOP_BUY_SUCC(self) --初始化每个页面
    local msg = "购买成功"
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(msg)
    self.Scenelayer : addChild(BoxLayer,1000)

    self : setMainPropertyMoney(self.thePageCallBcakTypeBb)
end

function CShopLayer.initOnePageView(self,_Count,_TypeBb) --初始化每个页面

    local function ScrollViewCallBack(eventType, obj, x, y)
        return self : ScrollViewCallBack(eventType,obj,x,y)
    end

    local m_ViewSize      = CCSizeMake(815,600)
    self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    self.m_pScrollView    : registerControlScriptHandler(ScrollViewCallBack,"this is CShopLayer ScrollViewCallBack 295")
    self.m_pScrollView    : setTouchesPriority(1)
    self.m_pScrollView    : setPosition(-17.5+17,-550)

    self.GoodsBtn          = {} --物品按钮
    --self.GoodsBtnSprite    = {} --物品按钮背景图
    self["GoodsBtnSpriteBtn".._TypeBb] = {} --物品按钮背景图
    self.GoodsNameLael     = {} --物品名字
    self.GoodsPriceLael    = {} --物品价格
    self.GoodsVIPPriceLael = {} --物品VIP价格
    self.GoodsBuyBtn       = {} --物品购买按钮
    self.GoodsLayout       = {}

    local function GoodsBuyBtnCallBack(eventType, obj, x, y)
        return self : GoodsBuyButtonCallBack(eventType,obj,x,y)
    end

    local function GoodsBtnSpriteBtnCallBack(eventType, obj, touches)
        return self:GoodsBtnSpriteBtnCallBack(eventType, obj, touches)
    end   

    local pageCount = 1
    if _Count ~=nil and  _Count > 0 then
        if math.mod( _Count,8 ) == 0 then
            pageCount = math.floor(_Count/8)
        else
            pageCount = math.floor(_Count/8)+1
        end 
    end
    self.m_pScrollView    : setTag(pageCount)

    local   theFirstTypeid  = tonumber(self.MallListData[1].class_id)
    if _TypeBb == theFirstTypeid then
        self.m_pageLabel : setString( "1".."/"..pageCount )   
    end
    for j=1,pageCount do
        local pageContiner = CContainer : create()
        pageContiner       : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        self.m_pScrollView : addPage(pageContiner)
        --物品列表
        self.GoodsLayout[j] = CHorizontalLayout : create()
        self.GoodsLayout[j] : setControlName("CShopLayer  GoodsLayout ")
        self.GoodsLayout[j] : setPosition(-580+25,150)
        self.GoodsLayout[j] : setLineNodeSum(2)
        self.GoodsLayout[j] : setVerticalDirection(false)
        self.GoodsLayout[j] : setCellSize(CCSizeMake(410,125))
        pageContiner        : addChild(self.GoodsLayout[j])

        for k=1,8 do
            i = (j-1)*8 + k
            if i <= _Count then
                self.GoodsBtn[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
                self.GoodsLayout[j]        : addChild(self.GoodsBtn[i])

                self["GoodsBtnSpriteBtn".._TypeBb][i]    = CSprite : createWithSpriteFrameName("general_underframe_normal.png")
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setTouchesPriority(-100)
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setTouchesEnabled( true)
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setTouchesMode( kCCTouchesAllAtOnce )
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setTag(i)            
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : registerControlScriptHandler (GoodsBtnSpriteBtnCallBack,"GoodsBtnSpriteBtn CallBack")
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setPosition(145,0)  
                self["GoodsBtnSpriteBtn".._TypeBb][i]    : setPreferredSize(CCSizeMake(400,115))
                self.GoodsBtn[i]             : addChild(self["GoodsBtnSpriteBtn".._TypeBb][i],-1)

                self.GoodsNameLael[i]     = CCLabelTTF :create("物品名","Arial",20)
                self.GoodsPriceLael[i]    = CCLabelTTF :create("价格: 120钻石","Arial",20)
                self.GoodsVIPPriceLael[i] = CCLabelTTF :create("VIP价格: 120钻石","Arial",20)

                self.GoodsNameLael[i]     : setAnchorPoint( ccp(0.0, 0.5)) 
                self.GoodsPriceLael[i]    : setAnchorPoint( ccp(0.0, 0.5)) 
                self.GoodsVIPPriceLael[i] : setAnchorPoint( ccp(0.0, 0.5)) 
                self.GoodsVIPPriceLael[i] : setColor(ccc3(255,255,0))             

                self.GoodsBuyBtn[i]    = CButton : createWithSpriteFrameName("购买","general_smallbutton_click.png")
                self.GoodsBuyBtn[i]    : setFontSize(20)
                -- self.GoodsBuyBtn[i]    : setTouchesMode( kCCTouchesAllAtOnce )
                self.GoodsBuyBtn[i]    : setTouchesEnabled( true) 
                self.GoodsBuyBtn[i]    : setTag(i)              
                self.GoodsBuyBtn[i]    : registerControlScriptHandler(GoodsBuyBtnCallBack,"this CMysteriousShopLayer GoodsBuyBtn[i]CallBack 120")
                self.GoodsBuyBtn[i]    : setTouchesPriority(-4)

                self.GoodsNameLael[i]     : setPosition(60,30)
                self.GoodsPriceLael[i]    : setPosition(60,-0)
                self.GoodsVIPPriceLael[i] : setPosition(60,-30)
                self.GoodsBuyBtn[i]       : setPosition(280,-0) 
                      
                self.GoodsBtn[i]      : addChild(self.GoodsPriceLael[i],1)
                self.GoodsBtn[i]      : addChild(self.GoodsVIPPriceLael[i],1)
                self.GoodsBtn[i]      : addChild(self.GoodsNameLael[i],1)
                self.GoodsBtn[i]      : addChild(self.GoodsBuyBtn[i])
            end
        end
    end

    self.m_pScrollView : setPage(0, false)--设置起始页[0,1,2,3...]

    return self.m_pScrollView
end

function CShopLayer.getNowStayPage( self) --获取当前所在页
    return self.NowStayPage
end
function CShopLayer.setNowStayPage( self,_page) --设置当前所在页
    self.NowStayPage = tonumber(_page) 
end

function CShopLayer.ScrollViewCallBack(self,eventType,obj,x,y)
    print("eventTypeeventType=",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        local currentPage = x
        local pageCount = obj : getTag()

        print("CShopLayer.ScrollViewCallBack---->>>",currentPage,pageCount)
        -- if currentPage ~= self.m_currentPage then
            --self.m_currentPage = pageCount-currentPage
            self.m_currentPage = currentPage + 1
            print("699 pageCount",pageCount)
            self.m_pageLabel :setString( self.m_currentPage.."/"..pageCount)
        -- end
    end
end

--单个物品xml解析
function CShopLayer.OneGoodsXmlData(self,_equipId,_idx,_price_type,_s_price,_v_price,_total_remaider_Num,_TypeBb,_Type,_goods_num)
    print("-----294 OneGoodsXmlData,id=",_equipId,"_idx = ",_idx,_price_type,_s_price,_v_price)
    --local OneGoodNode      = _G.Config.goodss:selectNode("goods","id",tostring(_equipId)) --装备节点
    local OneGoodNode      = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_equipId).."]")
    local OneEGoodData     = {}
    OneEGoodData.id        = OneGoodNode : getAttribute("id") 
    OneEGoodData.name      = OneGoodNode : getAttribute("name") 
    OneEGoodData.icon      = OneGoodNode : getAttribute("icon") 
    OneEGoodData.type      = OneGoodNode : getAttribute("type")   
    OneEGoodData.name_color= OneGoodNode : getAttribute("name_color")   
    -- print("OneEGoodData",OneGoodNode.id,OneGoodNode.name,OneGoodNode.icon)

    OneEGoodData.idx                = _idx                 --索引         (sever)
    OneEGoodData.price_type         = _price_type          --价格类型      (sever)
    OneEGoodData.s_price            = _s_price             --物品现价      (sever)
    OneEGoodData.v_price            = _v_price             --物品VIP价格   (sever)
    OneEGoodData.total_remaider_Num = _total_remaider_Num  --剩余总数量    (sever)
    OneEGoodData.mall_typebb        = _TypeBb              --所属商城类型   (sever)   
    OneEGoodData.mall_type          = _Type                --所属子店铺类型 (sever)
    OneEGoodData.goods_num          = _goods_num           --兑换物品数量   (sever)
    OneEGoodData.equipId            = _equipId

    return OneEGoodData
end
--单个物品view初始化
function CShopLayer.initOneEquipmentParameter(self,_no,_OneGoodsData)
    local function TipsCallBack(eventType, obj, x, y)
        return self : TipsCallBack(eventType,obj,x,y)
    end

    if self.OneGoodsSprite[_no] ~= nil then
        self.OneGoodsSprite[_no] : removeFromParentAndCleanup(true)
        self.OneGoodsSprite[_no] = nil
    end
    
    local OneGoodsData       = _OneGoodsData
    local price_type         = tonumber( OneGoodsData.price_type )  --价格类型
    print("price_type--->",price_type)
    local s_price            = OneGoodsData.s_price                 --物品现价    
    local v_price            = OneGoodsData.v_price                 --物品VIP价格 

    local icon_url           = "Icon/i"..OneGoodsData.icon..".jpg"
    _G.g_unLoadIconSources : addIconData( OneGoodsData.icon )
    self.OneGoodsSprite[_no] = CSprite : create(icon_url)          
    self.OneGoodsSprite[_no] : setTouchesEnabled( true)  
    self.OneGoodsSprite[_no] : setTag(OneGoodsData.id)              
    self.OneGoodsSprite[_no] : registerControlScriptHandler(TipsCallBack,"this CMysteriousShopLayer OneGoodsSpritei]CallBack ")
    self.GoodsBtn[_no]       : addChild(self.OneGoodsSprite[_no],-1)

    --特效
    local theType = tonumber(OneGoodsData.type)
    if theType == 1 or theType == 2 then
        self : Create_effects_equip(self.GoodsBtn[_no],OneGoodsData.name_color,_no)
    end

    self.GoodsNameLael[_no]     : setString(OneGoodsData.name,"Arial",20)
    if price_type == 1 then
        CurrencyType = "美刀"
    elseif price_type == 2 then
        CurrencyType = "钻石"
    end

    self.GoodsPriceLael[_no]    : setString("价格 : "..s_price..CurrencyType,"Arial",20)
    self.GoodsVIPPriceLael[_no] : setString("VIP : "..v_price..CurrencyType,"Arial",20)
end

function CShopLayer.Create_effects_equip ( self,obj,name_color,_no) --type=1是左边装备栏 2是未强化 3是强化后的
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
            -- if eventType == "Exit" then
            --     if  self["ccbi".._no] ~= nil then
            --         print("self[ccbi.._no]删除了你～～")
            --         self["ccbi".._no] : removeFromParentAndCleanup(true)
            --         self["ccbi".._no] = nil
            --     end
            -- end
        end
        if self["ccbi".._no] ~= nil then
            self["ccbi".._no] : removeFromParentAndCleanup(true)
            self["ccbi".._no] = nil            
        end

        if obj ~= nil then
            self["ccbi".._no] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["ccbi".._no] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["ccbi".._no] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["ccbi".._no],1000)
        end
    end
end

function CShopLayer.exchangeDataTable(self,_listdata,_Count)
    local temp = {}
    for i=1,_Count do
        for j=1,_Count-i do
            if tonumber(_listdata[j+1].id)  > tonumber(_listdata[j].id) then
                temp = _listdata[j+1]
                _listdata[j+1] =  _listdata[j]
                _listdata[j]   = temp
            end
        end
    end
    return _listdata
end

function CShopLayer.open(self)
    _G.pCShopLayer         = CShopLayer()
    _G.g_ShopLayerMediator = CShopLayerMediator(_G.pCShopLayer)
    controller:registerMediator( _G.g_ShopLayerMediator )
    --open
    local scene = _G.pCShopLayer : scene()
    CCDirector : sharedDirector() : pushScene(scene)
end

function CShopLayer.getMallDataFromXML(self,_mall_id)
    --local Node    =  _G.Config.mall_ids:selectNode("mall_id","mall_id",tostring(_mall_id)) --节点 
    local Node    =  _G.Config.mall_ids : selectSingleNode("mall_id[@mall_id="..tostring(_mall_id).."]")
    local open_lv = Node : getAttribute("open_lv")  --商城开发等级
    local explain = Node : getAttribute("explain")  --商城名称
    local loop    = 0 
    self.MallListData = {}

    local Node_c1 = Node : children() : get(0,"c1")
    local Node_c2 = Node : children() : get(0,"c2")
    local Node_c3 = Node : children() : get(0,"c3")
    local Node_c4 = Node : children() : get(0,"c4")
    local Node_c5 = Node : children() : get(0,"c5")

    if Node_c1 : isEmpty() == false then
        local CNode    = Node_c1
        local class_id = tonumber(CNode : getAttribute("class1_id"))
        if class_id > 0 then
            loop = loop + 1
            self.MallListData[loop] = {}
            self.MallListData[loop].class_id    = CNode : getAttribute("class1_id")
            self.MallListData[loop].class_name  = CNode : getAttribute("class1_name")
            self.MallListData[loop].open_lv     = CNode : getAttribute("open1_lv")
            self.MallListData[loop].is_discount = CNode : getAttribute("is1_discount")    
        end 
    end
    if Node_c2 : isEmpty() == false then
        local CNode    = Node_c2
        local class_id = tonumber(CNode : getAttribute("class2_id"))
        if class_id > 0 then
            loop = loop + 1
            self.MallListData[loop] = {}
            self.MallListData[loop].class_id    = CNode : getAttribute("class2_id")
            self.MallListData[loop].class_name  = CNode : getAttribute("class2_name")
            self.MallListData[loop].open_lv     = CNode : getAttribute("open2_lv")
            self.MallListData[loop].is_discount = CNode : getAttribute("is2_discount")    
        end 
    end
    if Node_c3 : isEmpty() == false then
        local CNode    = Node_c3
        local class_id = tonumber(CNode : getAttribute("class3_id"))
        if class_id > 0 then
            loop = loop + 1
            self.MallListData[loop] = {}
            self.MallListData[loop].class_id    = CNode : getAttribute("class3_id")
            self.MallListData[loop].class_name  = CNode : getAttribute("class3_name")
            self.MallListData[loop].open_lv     = CNode : getAttribute("open3_lv")
            self.MallListData[loop].is_discount = CNode : getAttribute("is3_discount")    
        end 
    end
    if Node_c4 : isEmpty() == false then
        local CNode    = Node_c4
        local class_id = tonumber(CNode : getAttribute("class4_id"))
        if class_id > 0 then
            loop = loop + 1
            self.MallListData[loop] = {}
            self.MallListData[loop].class_id    = CNode : getAttribute("class4_id")
            self.MallListData[loop].class_name  = CNode : getAttribute("class4_name")
            self.MallListData[loop].open_lv     = CNode : getAttribute("open4_lv")
            self.MallListData[loop].is_discount = CNode : getAttribute("is4_discount")    
        end 
    end
    if Node_c5 : isEmpty() == false then
        local CNode    = Node_c5
        local class_id = tonumber(CNode : getAttribute("class5_id"))
        if class_id > 0 then
            loop = loop + 1
            self.MallListData[loop] = {}
            self.MallListData[loop].class_id    = CNode : getAttribute("class5_id")
            self.MallListData[loop].class_name  = CNode : getAttribute("class5_name")
            self.MallListData[loop].open_lv     = CNode : getAttribute("open5_lv")
            self.MallListData[loop].is_discount = CNode : getAttribute("is5_discount")    
        end 
    end

    self.MallListData.loop = loop --计算子商店个数
    print("why loops ===",loop)
    --print("loops = ",loop,self.MallListData[4].class4_name,#self.MallListData,self.MallListData.loop)
end



function CShopLayer.createGoodsBtnSpriteBtnCCBI( self, _no  )

    --self.nowTheSpriteBtnCCBINo = _no
    local nowPage = self.thePageCallBcakTypeBb
    local function local_animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_animationCallFunc  "..eventType )
            arg0 : play("run")
        end
    end

    _size = self["GoodsBtnSpriteBtn"..nowPage][_no] : getPreferredSize()
    local n_Y     = 3
    local n_X     = 5
    self.ccbi_up = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    self.ccbi_up : setControlName( "this CActivitiesView ccbi_up 84")
    self.ccbi_up : registerControlScriptHandler( local_animationCallFunc )
    self.ccbi_up : setPosition( -_size.width/2 + n_X, _size.height/2 - n_Y)
    --self.GoodsBtnSpriteBtn[_no] : addChild( self.ccbi_up,1,901 )
    self["GoodsBtnSpriteBtn"..nowPage][_no]  : addChild( self.ccbi_up,1,901 )

    self.ccbi_down = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    self.ccbi_down : setControlName( "this CActivitiesView ccbi_down 84")
    self.ccbi_down : registerControlScriptHandler( local_animationCallFunc )
    self.ccbi_down : setPosition( _size.width/2 - n_X, - _size.height/2 + n_Y)
  
    self["GoodsBtnSpriteBtn"..nowPage][_no]  : addChild( self.ccbi_down,1,902 )
    --self.GoodsBtnSpriteBtn[_no] : addChild( self.ccbi_down,1,902 )

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

function CShopLayer.removeGoodsBtnSpriteBtnCCBI( self )  --删除ccbi
    if self.ccbi_up ~= nil then
        self.ccbi_up : removeFromParentAndCleanup( true )
        self.ccbi_up = nil
    end

    if self.ccbi_down ~= nil then
        self.ccbi_down : removeFromParentAndCleanup( true )
        self.ccbi_down = nil
    end 
end




function CShopLayer.setMainPropertyMoney(self,_mailType) --设置现在的金额显示
    local Data            = {}
    local price_type      = nil 

    if self.MallListData  ~= nil then
        local  loop = tonumber(self.MallListData.loop)
        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local id =tonumber(self.MallListData[i].class_id) 
     
                if tonumber(_mailType)  == id  then   
                    if self.PageGoodListData[i]~= nil then
                        Data = self.PageGoodListData[i]
                    end
                    break
                end
            end
        end
    end
   
    if Data ~= nil then
        price_type = tonumber(Data[1].price_type) 
    end

    if price_type ~= nil then 

        local mainProperty = _G.g_characterProperty : getMainPlay()
        local money        = 0 
    
        if price_type ~= nil and price_type == _G.Constant.CONST_CURRENCY_GOLD then
            --获取美刀
            money    = tonumber(mainProperty :getGold()) 
            self.m_MoneyLabel : setString("美刀:"..money)
            self.MoneySprite  : setImageWithSpriteFrameName("menu_icon_dollar.png")
        elseif price_type ~= nil and price_type == _G.Constant.CONST_CURRENCY_RMB then
            --获取钻石
            money    = tonumber(mainProperty :getBindRmb()) 
            self.m_MoneyLabel : setString("钻石:"..money)
            self.MoneySprite  : setImageWithSpriteFrameName("menu_icon_diamond.png")
        end
    end
end















