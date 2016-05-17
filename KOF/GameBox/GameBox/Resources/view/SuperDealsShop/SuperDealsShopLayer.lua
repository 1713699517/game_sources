require "controller/command"
require "view/view"


require "mediator/SuperDealsShopLayerMediator"




CSuperDealsShopLayer = class(view,function (self)

                            end)

CSuperDealsShopLayer.ShopBtnTag       = 1
CSuperDealsShopLayer.closeBtnTag      = 2
CSuperDealsShopLayer.RechargeBtnTag   = 3

CSuperDealsShopLayer.TAG_ShopPage    = {}
CSuperDealsShopLayer.TAG_ShopPage[1] = 11
CSuperDealsShopLayer.TAG_ShopPage[2] = 22
CSuperDealsShopLayer.TAG_ShopPage[3] = 33
CSuperDealsShopLayer.TAG_ShopPage[4] = 44
CSuperDealsShopLayer.TAG_ShopPage[5] = 55

CSuperDealsShopLayer.TAG_LVPage             = 2000
CSuperDealsShopLayer.TAG_VIPPage            = 2010
CSuperDealsShopLayer.TAG_EveryDayDealsPage  = 2020

function CSuperDealsShopLayer.scene(self,_mall_id)
    -- self.mall_id  = _mall_id
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层
    return self.scene
end

function CSuperDealsShopLayer.layer(self,_winSize)
    --local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)

    return self.Scenelayer
end

function CSuperDealsShopLayer.loadResources(self)

    self : tsetstest()

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("SuperDealsShopResources/SuperDealsShopResources.plist")

    CCSpriteFrameCache : sharedSpriteFrameCache():addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")

    _G.Config:load("config/goods.xml")
    _G.Config:load("config/mall_class.xml")
    _G.Config:load("config/mall_name.xml")
    _G.Config:load("config/mail_id_count.xml")
end

function CSuperDealsShopLayer.unloadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("SuperDealsShopResources/SuperDealsShopResources.plist")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("SuperDealsShopResources/SuperDealsShopResources.pvr.ccz")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("CharacterPanelResources/RoleResurece.plist")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("CharacterPanelResources/RoleResurece.pvr.ccz")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("Shop/ShopReSources.pvr.ccz")

    _G.Config:unload("config/mall_class.xml")
    _G.Config:unload("config/mall_name.xml")
    _G.Config:unload("config/mail_id_count.xml")

    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CSuperDealsShopLayer.layout(self, winSize)  --适配布局
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   
    if winSize.height == 640 then
        self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)              --总底图
        self.m_allSecondBackGroundSprite : setPosition(IpadSizeWidth/2,IpadSizeheight/2)              --总底图
        --self.m_allFirstBackGroundSprite  : setPosition(IpadSizeWidth/2,550/2+15)                    --总底图

        local closeSize                  = self.CloseBtn: getContentSize()
        self.CloseBtn                    : setPosition(IpadSizeWidth-closeSize.width/2, IpadSizeheight-closeSize.height/2)  --关闭按钮
        self.RechargeBtn                 : setPosition(IpadSizeWidth-200, IpadSizeheight-closeSize.height/2-5)
        self.tab                         : setPosition(20,IpadSizeheight-45)
        --self.m_pageLabel                 : setPosition(IpadSizeWidth/2-10-10,40-10)  
        --self.pageLabelSprite             : setPosition(IpadSizeWidth/2,40-10)  
        self.m_MoneyLabel                : setPosition(IpadSizeWidth/8,40) 
        self.MoneySprite                 : setPosition(IpadSizeWidth/8-20,40) 

    elseif winSize.height == 768 then
        self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)              --总底图

        local closeSize                  = self.CloseBtn: getContentSize()
        self.CloseBtn                    : setPosition(winSize.width-closeSize.width*2/3, winSize.height-closeSize.height*2/3)  --关闭按钮
        self.RechargeBtn                 : setPosition(winSize.width-200, winSize.height-closeSize.height*2/3-5)
        self.tab                         : setPosition(20,winSize.height-55)
        --self.m_pageLabel                 : setPosition(winSize.width/2-15,20)  
    end
end

function CSuperDealsShopLayer.initParameter(self)

    self : getMallDataFromXML(20)           --获取默认的商城数据 20

    --mediator注册
    print("CShopLayer.mediatorRegister 57")
    _G.g_SuperDealsShopLayerMediator = CSuperDealsShopLayerMediator (self)
    controller :registerMediator(  _G.g_SuperDealsShopLayerMediator )

    if self.MallListData ~= nil then
        local  loop = tonumber(self.MallListData.loop)

        self : initTabPageView (loop,self.MallListData) --初始化page界面

        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local id      = tonumber(self.MallListData[i].class_id)  
                print("gettheid = ",id)
                if  id > 0 then
                    self : PageNetWorkSend(20,id)   --netwrok面板协议发送(初始化)
                end
            end
        end
    end

    self.nPlayLv   = 0
    local mainplay = _G.g_characterProperty :getMainPlay()
    self.nPlayLv   = tonumber(mainplay : getLv()) 
    self.PageGoodListData  = {}
    self.PageGoodListCount = {}  
    self.EveryDayDealsData = {} --保存每日特惠的数据

    self.PageScrollView   = {}

    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据

    --获取人物Vip等级
    self.m_mainPlay_Viplv = 0 
    self.m_mainPlay_Lvlv  = 0 
    self.m_mainPlay_Viplv = tonumber(_G.g_characterProperty : getMainPlay() : getVipLv()) 
    self.m_mainPlay_Lvlv  = tonumber(_G.g_characterProperty : getMainPlay() : getLv()) 
    print("人物的等级以及vIP==",self.m_mainPlay_Viplv,self.m_mainPlay_Lvlv)
end

function CSuperDealsShopLayer.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : initParameter()                        --参数初始化
    self : layout(_winSize)                       --适配布局初始化

    
end

function CSuperDealsShopLayer.tsetstest(self)
    local retFirst  = ""
    local retSecond = ""

    local _str    ="沧海一声笑，大地一阵吼，世界Boss#出现了！"
    local _target ="#"

    local isFind = false

    if _str ~= nil then
        print("---------00000008----",string.len( _str ))
        local nCount = 1        --计数，去除第二个 _target
        for i=1, string.len( _str ) do
            local tmpStr = string.sub( _str, i, i )
            print("---------88888888888----",tmpStr)

            if tmpStr == _target then

                isFind = true
         
                tmpStr = ""
                retFirst  = string.sub( _str, 1, i-1 )
                retSecond = string.sub( _str, i+1, -1 )
                print("---->true")
                break
            end
        end

        if isFind == false then
                retFirst = retFirst
        else
                retSecond = retSecond 
        end
    end
    
    print( "返回的最终sss-->", retFirst, " -->   ", retSecond )
end

function CSuperDealsShopLayer.initView(self,_winSize,_layer)
    local IpadSize =854
    self.BackContainer = CContainer : create()
    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)
    _layer             : addChild(self.BackContainer)
    --底图
    self.m_allBackGroundSprite   = CSprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))
    _layer :addChild(self.m_allBackGroundSprite,-2)

    -- self.m_allFirstBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --第一底图
    -- self.m_allFirstBackGroundSprite   : setPreferredSize(CCSizeMake(820,550)) 
    -- self.BackContainer : addChild(self.m_allFirstBackGroundSprite)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,640)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite,-1)
    
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    --关闭按钮
    self.CloseBtn         = CButton : createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn         : setTouchesPriority(-3)   
    self.CloseBtn         : setTag(CSuperDealsShopLayer.closeBtnTag)
    self.CloseBtn         : registerControlScriptHandler(CallBack,"this CSuperDealsShopLayer CloseBtnCallBack 83")
    self.BackContainer    : addChild (self.CloseBtn)

    --充值按钮
    self.RechargeBtn   = CButton :createWithSpriteFrameName("","shop_button_recharge_normal.png")
    self.RechargeBtn   : setTouchesPriority(-3)   
    self.RechargeBtn   : registerControlScriptHandler(CallBack,"this CSuperDealsShopLayer DownLayerBtnCallBack 172")
    self.RechargeBtn   : setTag(CSuperDealsShopLayer.RechargeBtnTag)
    self.BackContainer : addChild(self.RechargeBtn,10000)

    self : Create_effects_button(self.RechargeBtn)

    --美刀钻石数量显示
    self.MoneySprite = CSprite : createWithSpriteFrameName("menu_icon_diamond.png")
    self.BackContainer   : addChild(self.MoneySprite,5)

    self.m_MoneyLabel   = CCLabelTTF :create( "", "Arial", 18)
    self.m_MoneyLabel   : setAnchorPoint( ccp(0.0, 0.5))
    self.BackContainer : addChild(self.m_MoneyLabel,100)

end

function CSuperDealsShopLayer.initTabPageView(self,_pageCount,_data)

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
            local name       = _data[i].class_name
            self.ShopPage[i] = CTabPage : createWithSpriteFrameName(name,"general_label_normal.png",name,"general_label_click.png")
            self.ShopPage[i] : setFontSize(20)
            self.ShopPage[i] : setTouchesPriority(-3)
            self.ShopPage[i] : setTag (CSuperDealsShopLayer.TAG_ShopPage[i])
            self.ShopPage[i] : registerControlScriptHandler(CallBack,"this is CSuperDealsShopLayer ShopPage[i] 225 ")

            self.m_ShopPageContainer[i] = CContainer : create()
            self.m_ShopPageContainer[i] : setControlName( "this is CSuperDealsShopLayer m_ShopPageContainer 228" )

            self.tab : addTab(self.ShopPage[i],self.m_ShopPageContainer[i])  
        end
    end
 
    self.tab : onTabChange(self.ShopPage[1])                   --设置初始页
    --self.thePageCallBcakTypeBb =tonumber(_data[1].class_id )   --设置初始页的子店铺类型
    self : setNowStayPage( _data[1].class_id) --设置当前所在页
end

function CSuperDealsShopLayer.CallBack(self,eventType,obj,x,y)  --页面按钮回调
    if eventType == "TouchBegan" then
        print("CallBack TouchBegan",obj : getTag(),self.nPlayLv)
        local tagvalue = obj : getTag()
        -- if self.MallListData ~= nil then
        --     local  loop = tonumber(self.MallListData.loop)
        --     if loop ~= nil and loop > 0 then
        --         for i=1,loop do
        --             if tagvalue == CSuperDealsShopLayer.TAG_ShopPage[i]  then
        --                 print("pagepage")   
        --                 local id    = self.MallListData[i].class_id
        --                 local lv    = self.MallListData[i].open_lv 
        --                 if  self.nPlayLv < tonumber(lv) then
        --                     local msg = "宝石按钮开放等级为"..lv.."级"
        --                     self : createMessageBox(msg)
        --                     return false
        --                 end
        --             end
        --         end
        --     end
        -- end
        return true        
    elseif eventType == "TouchEnded" then
        local  tagvalue = obj : getTag()
        print("ButtonCallBack tagvalue= ",tagvalue)
        local winSize = CCDirector:sharedDirector():getVisibleSize()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if tagvalue == CSuperDealsShopLayer.closeBtnTag  then
                print("关闭按钮回调")
                _G.g_PopupView :reset()
                --mediator反注册
                if _G.g_SuperDealsShopLayerMediator ~= nil then
                    controller :unregisterMediator(_G.g_SuperDealsShopLayerMediator)
                    _G.g_SuperDealsShopLayerMediator = nil
                    print("CSuperDealsShopLayer unregisterMediator.g_CSuperDealsShopLayerMediator 182")
                end
                ---------
                self : removeAllCCBI () --删除所有的CCBI 


                _G.pCSuperDealsShopLayer  = nil
                self.Scenelayer : removeFromParentAndCleanup(true)
                CCDirector : sharedDirector () : popScene()
                self:unloadResources()
                _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon
                return
            elseif tagvalue == CSuperDealsShopLayer.RechargeBtnTag  then
                print("冲值回调")
                --local msg = "是否进行充值?"
                --local function fun1()
                    --local _rechargeScene = CRechargeScene:create()
                    --CCDirector:sharedDirector():pushScene(_rechargeScene)
                    
                    --退出界面
                    _G.g_PopupView :reset()
                    --mediator反注册
                    if _G.g_SuperDealsShopLayerMediator ~= nil then
                        controller :unregisterMediator(_G.g_SuperDealsShopLayerMediator)
                        _G.g_SuperDealsShopLayerMediator = nil
                        print("CSuperDealsShopLayer unregisterMediator.g_CSuperDealsShopLayerMediator 182")
                    end
                    ---------
                    self : removeAllCCBI () --删除所有的CCBI 


                    _G.pCSuperDealsShopLayer  = nil
                    self.Scenelayer : removeFromParentAndCleanup(true)
                    CCDirector : sharedDirector () : popScene()
                    self:unloadResources()
                    _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon

                    local command = CPayCheckCommand( CPayCheckCommand.ASK )
                    controller :sendCommand( command )
                --end
               -- local function fun2()
                    --print("不要了")
                --end
                --self : createMessageBox(msg,fun1,fun2)
            end
            if self.MallListData ~= nil then
                local  loop = tonumber(self.MallListData.loop)
                if loop ~= nil and loop > 0 then
                    for i=1,loop do
                        if tagvalue == CSuperDealsShopLayer.TAG_ShopPage[i]  then   
                             print("page按钮切换回调",self.MallListData[i].class_id)  
                             self : setNowStayPage( self.MallListData[i].class_id) --设置当前所在页

                            -- self.thePageCallBcakTypeBb = tonumber(self.MallListData[i].class_id)  
                            -- print("339 pageCount",pageCount)     
                            -- self.m_pageLabel : setString( "1".."/"..self.PageGoodListCount[i]) 
                            if tonumber(self.MallListData[i].class_id)  == CSuperDealsShopLayer.TAG_LVPage and self.theLVPageBtnLabel~=nil  and self.PageGoodListCount ~= nil  then 
                                
                                self.theLVPageBtnLabel : setText("1".."/"..self.PageGoodListCount[CSuperDealsShopLayer.TAG_LVPage])
                                
                            elseif tonumber(self.MallListData[i].class_id)  == CSuperDealsShopLayer.TAG_VIPPage and self.theLVPageBtnLabel~=nil  and self.PageGoodListCount ~= nil  then 
                            
                                self.theVIPPageBtnLabel : setText("1".."/"..self.PageGoodListCount[CSuperDealsShopLayer.TAG_VIPPage])
                            end
                        end
                    end
                end
            end
        end
    end
end

function CSuperDealsShopLayer.getNowStayPage( self) --获取当前所在页
    return self.NowStayPage
end
function CSuperDealsShopLayer.setNowStayPage( self,_page) --设置当前所在页
    self.NowStayPage = tonumber(_page) 
end

function CSuperDealsShopLayer.getNowStayPageCount( self) --获取当前所在页页数
    return self.NowStayPageCount
end
function CSuperDealsShopLayer.setNowStayPageCount( self,_pageCount) --设置当前所在页页数
    self.NowStayPageCount = tonumber(_pageCount) 
end

function CSuperDealsShopLayer.getNowClickBuyBtn( self) --获取当前所按购买按钮
    print("取出那个按钮",self.NowClickBuyBtn)
    return self.NowClickBuyBtn
end
function CSuperDealsShopLayer.setNowClickBuyBtn( self,obj) --设置当前所按购买按钮
    print("设置那个按钮",obj)
    self.NowClickBuyBtn = obj
end

function CSuperDealsShopLayer.getLvDayDealsDataFromServer( self) --获取Lv优惠数据或是等级优惠数据
    return self.LvDayDealsData
end
function CSuperDealsShopLayer.getVipDayDealsDataFromServer( self) --获取Vip优惠数据或是等级优惠数据
    return self.VipDayDealsData
end

function CSuperDealsShopLayer.setDataFromServer( self,Count,TypeBb,Type,Msg)  --设置vIP优惠数据或是等级优惠数据
    local data = {}
    data.theCount  = Count
    data.theTypeBb = TypeBb
    data.theType   = Type
    data.theMsg    = {}
    data.theMsg    = self : changeDataLocationByLv(Msg,2) --从小到大的全数据排序Msg   

    if tonumber(TypeBb) == CSuperDealsShopLayer.TAG_LVPage then
        self.LvDayDealsData = data
    elseif tonumber(TypeBb) == CSuperDealsShopLayer.TAG_VIPPage then
         self.VipDayDealsData = data
    end
end

function CSuperDealsShopLayer.setEveryDayDealsData( self,Msg)
    self.EveryDayDealsData = Msg 
end
function CSuperDealsShopLayer.getEveryDayDealsData( self)
    return self.EveryDayDealsData 
end

function CSuperDealsShopLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end

function CSuperDealsShopLayer.TipsCallBack(self,eventType,obj,x,y)  --页面tips回调
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

        local data = nil 
        local isNowPage = tonumber(self : getNowStayPage()) 
        if  isNowPage == CSuperDealsShopLayer.TAG_LVPage then
            data = self : getLvDayDealsDataFromServer()
        elseif isNowPage == CSuperDealsShopLayer.TAG_VIPPage then
            data = self : getVipDayDealsDataFromServer()
        end

        local theno = nil 
        print("----",tagvalue)
        if data ~= nil then
            print("321")
            
            for k,v in pairs(data.theMsg) do
                print("322",k,v.goods_id)
                if tonumber(tagvalue) == tonumber(v.goods_id) then
                    print("333",v.goods_id,k)
                    theno = k 
                    break
                end
            end
        end
        --print("theno-----",theno,isNowPage..theno,self.GoodsBtnSpriteBtn[isNowPage..theno])
        if self.theOldSpriteBtnId ~= nil  then
            self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
            self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(375,115))

            self :  removeGoodsBtnSpriteBtnCCBI() --删除特效

            self.theOldSpriteBtnId = nil
        end

        if theno ~= nil then
            --if obj : getChildByTag( isNowPage..theno )  ~= nil then
            if self["GoodsBtnSpriteBtn"..isNowPage][theno]  ~= nil then
                --local obj = obj : getChildByTag( isNowPage..theno ) 
                local objs  = self["GoodsBtnSpriteBtn"..isNowPage][theno]
   
                objs :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                objs :  setPreferredSize(CCSizeMake(375,115))

                self : createGoodsBtnSpriteBtnCCBI(theno)  --创建特效

                self.theOldSpriteBtnId = objs
            end
        end

        self.GoodsBtnSpriteBtnCallBackId = nil
    end
end

--多点触控
function CSuperDealsShopLayer.GoodsBtnSpriteBtnCallBack(self, eventType, obj, touches)
    print("多点触控一下",eventType,obj)
    _G.g_PopupView :reset()
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
                        self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(375,115))

                        self :  removeGoodsBtnSpriteBtnCCBI() --删除特效

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

                    print("设你透明11",obj)

                    if self.theOldSpriteBtnId ~= nil  then
                        --local oldid  = self.theOldSpriteBtnId
                        self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                        self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(375,115))

                        self :  removeGoodsBtnSpriteBtnCCBI() --删除特效

                        self.theOldSpriteBtnId = nil
                    end

                   
                    local value        = obj:getTag()
                    local isNowPage = tonumber(self : getNowStayPage())
                    if self["GoodsBtnSpriteBtn"..isNowPage][value] ~= nil then
                        local objs = self["GoodsBtnSpriteBtn"..isNowPage][value]

                        objs :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                        objs :  setPreferredSize(CCSizeMake(375,115))

                        self : createGoodsBtnSpriteBtnCCBI(value)  --创建特效

                        self.theOldSpriteBtnId = objs
                    end
                    self.touchID = nil
                    self.GoodsBtnSpriteBtnCallBackId = nil
                end
            end
        end
    end
end

--超值优惠商店面板数据协议发送请求
function CSuperDealsShopLayer.PageNetWorkSend(self,_type,_type_bb)
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_SHOP_REQUEST"
    local msg = REQ_SHOP_REQUEST()
    msg :setArguments(_type) --商店类型
    msg :setTypeBb(_type_bb) --商店子类型    
    CNetwork : send(msg)
    print("CSuperDealsShopLayer PageNetWorkSend页面发送数据请求,完毕 204")
end

function CSuperDealsShopLayer.BuyNetWorkSend(self,_type,_type_bb,_idx,_goodsId,_Count,_ctype)
    print("---超值优惠商店购买发送请求--->",_type,_type_bb,_idx,_goodsId,_Count,_ctype)
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_SHOP_BUY"
    local msg = REQ_SHOP_BUY()
    msg :setType    (_type)    --商店类型
    msg :setTypeBb  (_type_bb) --商店子类型 
    msg :setIdx     (_idx)     --物品数据索引
    msg :setGoodsId (_goodsId) --物品id 
    msg :setCount   (_Count)   --购买数量
    msg :setCtype   (_ctype)   --货币类型
    CNetwork : send(msg)
    print("CSuperDealsShopLayer NetWorkSend页面发送数据请求,完毕 203")
end

function CSuperDealsShopLayer.NetWorkReturn_SHOP_BUY_SUCC(self) 
    local msg = "购买成功"
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(msg)
    self.Scenelayer : addChild(BoxLayer,1000)

    local obj = self : getNowClickBuyBtn() --当前按的按钮
    if obj ~= nil then
        obj : setText("已购买")
        obj : setTouchesEnabled(false)
    end

    self : setMainPropertyMoney() --金钱显示
end

--初始 PageScrollView 界面
function CSuperDealsShopLayer.initPageScrollView( self,Count,_TypeBb,Type ,Msg)
    if self.MallListData ~= nil then
        local  loop = tonumber(self.MallListData.loop)
        if loop ~= nil and loop > 0 then
            for i=1,loop do
                local   id  = tonumber(self.MallListData[i].class_id)
               if tonumber(_TypeBb)  == id  then   
                    if id == CSuperDealsShopLayer.TAG_LVPage  then
                        --页数
                        self.theLVPageBtnLabel      = CButton : createWithSpriteFrameName("0/0","general_pagination_underframe.png")
                        self.theLVPageBtnLabel      : setPosition(854/2-25,40-10-595)  
                        self.m_ShopPageContainer[i] : addChild(self.theLVPageBtnLabel,5)

                        --界面初始化
                        local count,data  = self : getLvTypeFromMsg(Count,Msg)          --获取LV的类型个数
                        local LvData      =  self : getEveryLvCountData(count,data,Msg) --获取每一个Lv的个数

                        self.PageScrollView[i]      = self : initOnePageView(count,Count,_TypeBb,LvData)
                        self.m_ShopPageContainer[i] : addChild(self.PageScrollView[i])

                        --界面数据初始化
                        self : initOnePageData(_TypeBb,data,Msg)
                    elseif id == CSuperDealsShopLayer.TAG_VIPPage then
                        --页数
                        self.theVIPPageBtnLabel     = CButton : createWithSpriteFrameName("0/0","general_pagination_underframe.png")
                        self.theVIPPageBtnLabel     : setPosition(854/2-25,40-10-595)  
                        self.m_ShopPageContainer[i] : addChild(self.theVIPPageBtnLabel,5)

                        local count,data  = self : getLvTypeFromMsg(Count,Msg)          --获取VIP的类型个数
                        local LvData      =  self : getEveryLvCountData(count,data,Msg) --获取每一个Lv的个数

                        self.PageScrollView[i]      = self : initOnePageView(count,Count,_TypeBb,LvData)
                        self.m_ShopPageContainer[i] : addChild(self.PageScrollView[i])

                        --界面数据初始化
                        self : initOnePageData(_TypeBb,data,Msg)

                    elseif id == CSuperDealsShopLayer.TAG_EveryDayDealsPage then
                        print("初始第三个每日特惠界面")
                        self.PageScrollView[i]  = self : initEveryDayDealsView()
                        self.m_ShopPageContainer[i] : addChild(self.PageScrollView[i])
                    end
                end
            end
        end
    end
end

function CSuperDealsShopLayer.getEveryLvCountData(self,count,data,Msg) --获取每一个Lv的个数
    local LvData = {}
    if data ~= nil and count ~= nil  then
        LvData.count = count

        for i=1,count do
            local loops  = 0 
            for k,v in pairs(Msg) do
                if tonumber(data[i]) == tonumber(v.etra_value) then
                    loops = loops + 1
                end  
            end
            LvData[i]       = {}
            LvData[i].loops = loops
            LvData[i].lv    = data[i]
            print("每个LV==",data[i],"个数是===",loops)
        end
    end

    return  LvData
end

--初始initOnePage的数据
function CSuperDealsShopLayer.initOnePageData(self,TypeBb,LvData,Msg)
    if LvData ~= nil then 
        if tonumber(TypeBb) == CSuperDealsShopLayer.TAG_LVPage  then
            for k,v in pairs(LvData) do
                if self.LvLabel ~= nil and self.LvLabel[k] ~= nil  then 
                    self.LvLabel[k] : setString(v)
                end
            end
        elseif tonumber(TypeBb) == CSuperDealsShopLayer.TAG_VIPPage  then
            for k,v in pairs(LvData) do
                local Vip = tonumber(v)
                print("KANKAN VIP ==",Vip)
        
                    --local VipSprite = CSprite  : createWithSpriteFrameName("role_vip_0"..Vip..".png")
                    --self.LvBackGroundSprite[k] : addChild(VipSprite)
                local _vipname = CSprite :createWithSpriteFrameName( "role_vip.png" )
                local viplv    = tostring( Vip )
                local length   = string.len( Vip)
                local vipnameSize  = _vipname :getPreferredSize()
                local vipWidth     = 0
                local vipContainer = CContainer : create()
                for i=1, length do
                    local _tempvip = CSprite :createWithSpriteFrameName( "role_vip_0"..string.sub(viplv,i,i)..".png")
                    vipContainer :addChild( _tempvip )
                    local _tempvipSize = _tempvip : getPreferredSize()
                    vipWidth = vipWidth + _tempvipSize.width / 2
                    _tempvip : setPosition( vipWidth,-3.5)
                    vipWidth = vipWidth + _tempvipSize.width / 2
                end
                _vipname : addChild( vipContainer )
                vipContainer : setPosition(50+length*5-vipWidth/2, 4)

                _vipname : setPosition(-50,0)
                self.LvBackGroundSprite[k] : addChild(_vipname)

                -- _vipname : setPosition( ccp( 0-stringWidth/2 - vipnameSize.width/2, 0) )

            end
        end
    end


    local  data = self : changeDataLocationByLv(Msg,2) --从小到大的全数据排序
    for k,v in pairs(data) do
        print("排序后的全数据=======",k,v.goods_id,v.etra_value)

        if self.GoodsNameLael[k] ~= nil then
            --物品图片以及特效
            local node =  _G.Config.goodss : selectSingleNode("goods[@id="..tostring(v.goods_id).."]")
            if node : isEmpty() == false then
                self.GoodsNameLael[k]     : setString(node : getAttribute("name"))
                local node_icon = node : getAttribute("icon")
                local icon_url  = "Icon/i"..node_icon..".jpg"
                _G.g_unLoadIconSources : addIconData( node_icon ) --释放icon图用的方法

                local GoodsSprite = CSprite : create(icon_url) --物品图
                self.GoodsBtn[k]  : addChild(GoodsSprite,-2)

                --特效特效
                if v ~= nil then
                    local goodnode = _G.g_GameDataProxy :getGoodById( v.goods_id)
                    -- local theType  = tonumber(goodnode.type)
                    local theType  = tonumber(goodnode : getAttribute("type"))
                    if theType == 1 or theType == 2 then
                        self : Create_effects_equip(nil,self.GoodsBtn[k],goodnode : getAttribute("name_color"),v.goods_id,v.index)
                    end
                end
            end

            --物品数量
            local CountNode       =  _G.Config.mail_id_counts : selectSingleNode("mids[0]"):children()
            local CountNode_Count = CountNode : getCount("mid")
            if CountNode_Count ~= nil then
                for i=0,CountNode_Count-1 do
                    local node =  CountNode : get(i,"mid") 
                    if tonumber(v.idx)  == tonumber(node : getAttribute("id")) and self.GoodsNoLabel[k] ~= nil  then
                        self.GoodsNoLabel[k] : setString("x"..node : getAttribute("count"))
                        break
                    end
                end
            end


            --价格
            local PriceType = nil 
            if tonumber(v.type) == _G.Constant.CONST_CURRENCY_GOLD then --美刀
                PriceType = "美刀"
            else
                PriceType = "钻石"
            end
            self.GoodsPriceLael[k]    : setString("原价 : "..v.s_price..PriceType)
            self.GoodsVIPPriceLael[k] : setString("现价 : "..v.v_price..PriceType)
            self.GoodsBtn[k]          : setTag(v.goods_id)
            self.GoodsBuyBtn[k]       : setTag(v.idx)

            --判断等级
            local issetFalse = 0 
            if tonumber(TypeBb) == CSuperDealsShopLayer.TAG_LVPage  then

                if self.m_mainPlay_Lvlv >= tonumber(v.etra_value) then
                    self.GoodsBuyBtn[k]     : setTouchesEnabled(true)
                elseif self.m_mainPlay_Lvlv < tonumber(v.etra_value) then
                    self.GoodsBuyBtn[k]     : setTouchesEnabled(false)
                    issetFalse = 1
                end
            elseif tonumber(TypeBb) == CSuperDealsShopLayer.TAG_VIPPage  then

                if self.m_mainPlay_Viplv >= tonumber(v.etra_value) then
                    self.GoodsBuyBtn[k]     : setTouchesEnabled(true)
                elseif self.m_mainPlay_Viplv < tonumber(v.etra_value) then
                    self.GoodsBuyBtn[k]     : setTouchesEnabled(false)
                    issetFalse = 1
                end
            end

            local isTouchState = tonumber(v.state) --1:可以购买|0:不可购买
            if isTouchState == 1 and issetFalse == 0 then
               self.GoodsBuyBtn[k]     : setTouchesEnabled(true)
            elseif isTouchState == 0 then
               self.GoodsBuyBtn[k]     : setText("已购买")
               self.GoodsBuyBtn[k]     : setTouchesEnabled(false)
            end

        end
    end
end

function CSuperDealsShopLayer.getLvTypeFromMsg( self,Count,Msg) --获取LV的类型个数
    local no   = tonumber(Count)
    local data = {}
    loop = 0  
    if no > 0 and Msg then
        --先初始一个数据给data
        --if tonumber(Msg[1].etra_type) == _G.Constant.CONST_MALL_TYPE_LV then
        if tonumber(Msg[1].etra_type) == _G.Constant.CONST_MALL_TYPE_LV or tonumber(Msg[1].etra_type) == _G.Constant.CONST_MALL_TYPE_VIP  then
            loop = loop + 1 
            data[loop] = tonumber(Msg[1].etra_value) 
        end

        if data ~= nil then 
            for i=1,no do
                local etra_type  =  tonumber(Msg[i].etra_type) 
                local etra_value =  tonumber(Msg[i].etra_value) 
                local isNew      = 0 
                local isSame     = 0 

                if etra_type == _G.Constant.CONST_MALL_TYPE_LV or etra_type == _G.Constant.CONST_MALL_TYPE_VIP  then
                    for k,v in pairs(data) do

                        if tonumber(v) ~= etra_value then
                            isNew = 1
                        else
                            isSame = 1 
                        end
                    end
                end

                if isNew == 1 and isSame == 0 then
                    loop = loop + 1 
                    data[loop] = tonumber(etra_value) 
                end
            end
        end
    end
    print("有多少中类型",loop)
    data = self : changeDataLocationByLv(data,1) --从小到大的排序

    return loop,data
end

function CSuperDealsShopLayer.changeDataLocationByLv(self,_data,_type) --从小到大的排序 type 1为纯等级 2为整个数据的
    data  = _data
    count = #_data
    temp  = {}
    if  data ~= nil and count > 0  then
        if _type == 1 then 

            for i = 1,count do
                for j=1,count-i do
                    if tonumber(data[j]) > tonumber(data[j+1]) then
                        temp      = data[j]
                        data[j]   = data[j+1] 
                        data[j+1] = temp
                    end
                end
            end
        elseif _type == 2 then 

            for i = 1,count do
                for j=1,count-i do
                    if tonumber(data[j].etra_value) > tonumber(data[j+1].etra_value) then
                        temp      = data[j]
                        data[j]   = data[j+1] 
                        data[j+1] = temp
                    end
                end
            end
        end
    end
    
    return data
end

--mediator传送过来的数据（同时也是初始化）
function CSuperDealsShopLayer.pushData(self,Msg,Count,TypeBb,Type)

    print("CSuperDealsShopLayer ----->----->",Count,TypeBb,Type)

    self : setDataFromServer( Count,TypeBb,Type,Msg) --数据存储

    self : initPageScrollView(Count,TypeBb,Type,Msg) --初始 PageScrollView 界面 以及数据

    self : setMainPropertyMoney() --金钱显示
end

function CSuperDealsShopLayer.initOnePageView(self,_Count,_GoodsCount,_TypeBb,_LvData) --初始化每个页面  _Count为LV的等级类型
    print("initOnePageView 1115",_Count,_GoodsCount,_TypeBb)
    local function ScrollViewCallBack(eventType, obj, x, y)
        print("----->",eventType,obj)
        return self : ScrollViewCallBack(eventType,obj,x,y)
    end

    local m_ViewSize      = CCSizeMake(825,600)
    local m_pScrollView   = CPageScrollView :create(1,m_ViewSize)
    m_pScrollView    : registerControlScriptHandler(ScrollViewCallBack,"this is CSuperDealsShopLayer ScrollViewCallBack 295")
    m_pScrollView    : setTouchesPriority(1)
    m_pScrollView    : setPosition(-17.5+17-5,-550-20)

    self.GoodsBtn          = {} --物品按钮
    self.oneContainerSprite= {} --一个容器背景
    self["GoodsBtnSpriteBtn".._TypeBb] = {} --物品按钮背景图
    self.GoodsNameLael     = {} --物品名字
    self.GoodsPriceLael    = {} --物品价格
    self.GoodsNoLabel      = {} --物品数量
    self.GoodsVIPPriceLael = {} --物品VIP价格
    self.GoodsBuyBtn       = {} --物品购买按钮
    self.GoodsLayout       = {}
    self.LvLabel           = {} --物品的等级
    self.LvBackGroundSprite= {} --物品等级的背景图

    local function GoodsBuyBtnCallBack(eventType, obj, x, y)
        return self : GoodsBuyButtonCallBack(eventType,obj,x,y)
    end

    local function GoodsBtnSpriteBtnCallBack(eventType, obj, touches)
        return self:GoodsBtnSpriteBtnCallBack(eventType, obj, touches)
    end  

    local function TipsCallBack(eventType, obj, x, y)
        return self : TipsCallBack(eventType,obj,x,y)
    end 

    local pageCount = 1
    if _Count ~=nil and  _Count > 0 then
        if math.mod( _Count,2 ) == 0 then
            pageCount = math.floor(_Count/2)
        else
            pageCount = math.floor(_Count/2)+1
        end 
    end
    m_pScrollView    : setTag(pageCount)

    local   theFirstTypeid  = tonumber(self.MallListData[1].class_id)
    -- if _TypeBb == theFirstTypeid then
    --     self.m_pageLabel : setString( "1".."/"..pageCount )   
    -- end
    --print("1111pageCount",pageCount)

    --初始页数
     if tonumber(_TypeBb)  == CSuperDealsShopLayer.TAG_LVPage then

        self.theLVPageBtnLabel : setText("1".."/"..pageCount)
        self.PageGoodListCount[CSuperDealsShopLayer.TAG_LVPage] = pageCount

    elseif tonumber(_TypeBb)  == CSuperDealsShopLayer.TAG_VIPPage then

        self.theVIPPageBtnLabel : setText("1".."/"..pageCount)
        self.PageGoodListCount[CSuperDealsShopLayer.TAG_VIPPage] = pageCount

    end   

    local loop      = 0 
    local goodsloop = 0
    for j=1,pageCount do
        local pageContiner = CContainer : create()
        pageContiner       : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        m_pScrollView      : addPage(pageContiner)
        --物品列表
        self.GoodsLayout[j] = CHorizontalLayout : create()
        self.GoodsLayout[j] : setControlName("CSuperDealsShopLayer  GoodsLayout ")
        self.GoodsLayout[j] : setPosition(-580+25+420-282,150-160)
        self.GoodsLayout[j] : setLineNodeSum(2)
        self.GoodsLayout[j] : setVerticalDirection(false)
        self.GoodsLayout[j] : setCellSize(CCSizeMake(415,510))
        pageContiner        : addChild(self.GoodsLayout[j])

        for k=1,2 do
            loop = loop + 1 
            print("initOnePageView loop",loop)
            if loop <= tonumber(_Count) then

                self.oneContainerSprite[loop] = CSprite : createWithSpriteFrameName("general_second_underframe.png")
                self.oneContainerSprite[loop] : setPreferredSize(CCSizeMake(405,510))
                self.GoodsLayout[j]           : addChild(self.oneContainerSprite[loop])

                if tonumber(_TypeBb)  == CSuperDealsShopLayer.TAG_LVPage then
                    self.LvBackGroundSprite[loop]  =  CSprite : createWithSpriteFrameName("superstore_lv_underframe.png")
                    local  LvSprite                =  CSprite : createWithSpriteFrameName("login_LV.png")
                    self.LvLabel[loop]             = CCLabelTTF : create("","Arial",24)

                    self.LvBackGroundSprite[loop] : setPosition(-20,205)
                    LvSprite                      : setPosition(-50,0)

                    self.oneContainerSprite[loop]  : addChild(self.LvBackGroundSprite[loop]) 
                    self.LvBackGroundSprite[loop]  : addChild(LvSprite) 
                    self.LvBackGroundSprite[loop]  : addChild(self.LvLabel[loop]) 
                elseif tonumber(_TypeBb)  == CSuperDealsShopLayer.TAG_VIPPage then
                    self.LvBackGroundSprite[loop]  =  CSprite : createWithSpriteFrameName("superstore_vip_underframe.png")
                    local  LvSprite                =  CSprite : createWithSpriteFrameName("superstore_vip_icon.png")
                    self.LvLabel[loop]             = CCLabelTTF : create("","Arial",24)

                    self.LvBackGroundSprite[loop]  : setPosition(-20,205)
                    LvSprite                       : setPosition(-50-70,8)

                    self.oneContainerSprite[loop]  : addChild(self.LvBackGroundSprite[loop]) 
                    self.LvBackGroundSprite[loop]  : addChild(LvSprite) 
                    self.LvBackGroundSprite[loop]  : addChild(self.LvLabel[loop]) 
                end
                ----------------------------------------------------------------------
                local layout = CHorizontalLayout : create()
                layout : setLineNodeSum(1)
                layout : setVerticalDirection(false)
                layout : setCellSize(CCSizeMake(400,140-5))
                layout : setPosition(-200-130,110-10)
                self.oneContainerSprite[loop] : addChild(layout)

                local OneLvCount = nil 
                if _LvData ~= nil then
                    OneLvCount = tonumber(_LvData[loop].loops)
                    if OneLvCount == nil or OneLvCount == 0  then
                        OneLvCount = 1
                    end
                end
                print("创建一个LV之前看看个数先,",_LvData[loop].loops,_LvData[loop].lv)
                for i=1,OneLvCount do
                    --一块按钮的背景图
                    goodsloop = goodsloop + 1

                    if goodsloop <= tonumber(_GoodsCount) then
                        print("创建的物品序号为===",_TypeBb..goodsloop,goodsloop)
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] = CSprite : createWithSpriteFrameName("general_underframe_normal.png")
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setTouchesEnabled(true)
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setTouchesPriority(-4)
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setTag(goodsloop)
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setTouchesMode( kCCTouchesAllAtOnce )
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : registerControlScriptHandler(GoodsBtnSpriteBtnCallBack,"GoodsBtnSpriteBtnCallBack 893") 
                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setPreferredSize(CCSizeMake(375,115))
           
                        --物品按钮
                        self.GoodsBtn[goodsloop]           = CSprite : createWithSpriteFrameName("general_props_frame_normal.png")
                        self.GoodsBtn[goodsloop]           : registerControlScriptHandler(TipsCallBack,"TipsCallBack 916") 
                        self.GoodsBtn[goodsloop]           : setTouchesEnabled(true)
                        self.GoodsBtn[goodsloop]           : setTouchesPriority(-4)
                        self.GoodsBtn[goodsloop]           : setPosition(-130,0)
                        layout : addChild(self.GoodsBtn[goodsloop])
                        -- self.GoodsBtnSpriteBtn[goodsloop]  : addChild(self.GoodsBtn[goodsloop])
                        self.GoodsNoLabel[goodsloop]      = CCLabelTTF :create("x1","Arial",18)
                        self.GoodsNameLael[goodsloop]     = CCLabelTTF :create("200万美刀","Arial",18)
                        self.GoodsPriceLael[goodsloop]    = CCLabelTTF :create("原价 : 1200钻石","Arial",18)
                        self.GoodsVIPPriceLael[goodsloop] = CCLabelTTF :create("现价 : 1000钻石","Arial",18)

                        self.GoodsNoLabel[goodsloop]      : setAnchorPoint( ccp(0.0, 0.5))
                        self.GoodsNameLael[goodsloop]     : setAnchorPoint( ccp(0.0, 0.5)) 
                        self.GoodsPriceLael[goodsloop]    : setAnchorPoint( ccp(0.0, 0.5)) 
                        self.GoodsVIPPriceLael[goodsloop] : setAnchorPoint( ccp(0.0, 0.5))           

                        self.GoodsBuyBtn[goodsloop]    = CButton : createWithSpriteFrameName("购买","general_smallbutton_click.png")
                        self.GoodsBuyBtn[goodsloop]    : setFontSize(24)
                        self.GoodsBuyBtn[goodsloop]    : setTouchesEnabled( true) 
                        self.GoodsBuyBtn[goodsloop]    : setTag(goodsloop)              
                        self.GoodsBuyBtn[goodsloop]    : registerControlScriptHandler(GoodsBuyBtnCallBack,"this CMysteriousShopLayer GoodsBuyBtn[i]CallBack 120")
                        self.GoodsBuyBtn[goodsloop]    : setTouchesPriority(-4)

                        self["GoodsBtnSpriteBtn".._TypeBb][goodsloop] : setPosition(130,0)
                        self.GoodsNoLabel[goodsloop]      : setPosition(170,30)
                        self.GoodsNameLael[goodsloop]     : setPosition(55,30)
                        self.GoodsPriceLael[goodsloop]    : setPosition(55,-0)
                        self.GoodsVIPPriceLael[goodsloop] : setPosition(55,-30)
                        self.GoodsBuyBtn[goodsloop]       : setPosition(280-35,0) 


                        self.GoodsBtn[goodsloop]      : addChild(self["GoodsBtnSpriteBtn".._TypeBb][goodsloop],-2)  
                        self.GoodsBtn[goodsloop]      : addChild(self.GoodsNoLabel[goodsloop],2)    
                        self.GoodsBtn[goodsloop]      : addChild(self.GoodsPriceLael[goodsloop],2)
                        self.GoodsBtn[goodsloop]      : addChild(self.GoodsVIPPriceLael[goodsloop],2)
                        self.GoodsBtn[goodsloop]      : addChild(self.GoodsNameLael[goodsloop],2)
                        self.GoodsBtn[goodsloop]      : addChild(self.GoodsBuyBtn[goodsloop])
                    end
                end

            end
        end
    end

    m_pScrollView : setPage(0, false)--设置起始页[0,1,2,3...]

    return m_pScrollView
end

function CSuperDealsShopLayer.GoodsBuyButtonCallBack(self,eventType,obj,x,y)  --页面购买按钮回调
    if eventType == "TouchBegan" then
        return true
        elseif eventType == "TouchEnded" then
        local  tagvalue = tonumber(obj : getTag()) 
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("第"..tagvalue.."个购买按钮回调")

            local NowStayPage  = self : getNowStayPage () --获取当前页
            local data         = {}
            if NowStayPage ~= nil and NowStayPage == CSuperDealsShopLayer.TAG_LVPage then
                data = self : getLvDayDealsDataFromServer() --LV数据
            elseif NowStayPage ~= nil and NowStayPage == CSuperDealsShopLayer.TAG_VIPPage  then
                data = self : getVipDayDealsDataFromServer() --VIP数据
            end

            if data ~= nil then
                print("准备发送特惠购买协议",tagvalue)

                if data.theType ~= nil and   data.theTypeBb  ~= nil and data.theMsg ~= nil then
                    local Msg = data.theMsg
                    local idx = nil 

                    for k,v in pairs(Msg) do
                        if tonumber(v.idx) == tagvalue then

                            -- local actarr = CCArray:create()
                            -- local function t_callback1()
                            --     if obj ~= nil then
                            --         obj : setTouchesEnabled(false)
                            --     end
                            -- end
                            -- actarr:addObject( CCCallFunc:create(t_callback1) )
                            -- self.m_layer : runAction( CCSequence:create(actarr) )
                            self : setNowClickBuyBtn(obj) --当前按的按钮

                            local CountNode       =  _G.Config.mail_id_counts : selectSingleNode("mids[0]"):children()
                            local CountNode_Count = CountNode : getCount("mid")
                            local buyCount        = 0
                            if CountNode_Count ~= nil then
                                for i=0,CountNode_Count-1 do
                                    local node =  CountNode : get(i,"mid") 
                                    if tonumber(v.idx)  == tonumber(node : getAttribute("id")) then
                                        buyCount = tonumber(node : getAttribute("count")) 
                                        break
                                    end
                                end
                            end

                            print("买了多少件物品-------》",k,buyCount)

                            if self.theOldSpriteBtnId ~= nil  then
                                self.theOldSpriteBtnId :  setImageWithSpriteFrameName( "general_underframe_normal.png" )
                                self.theOldSpriteBtnId :  setPreferredSize(CCSizeMake(375,115))

                                self :  removeGoodsBtnSpriteBtnCCBI() --删除特效

                                self.theOldSpriteBtnId = nil
                            end
                            local isNowPage = tonumber(self : getNowStayPage()) 
                            if self["GoodsBtnSpriteBtn"..isNowPage][k]  ~= nil then

                                local objs  = self["GoodsBtnSpriteBtn"..isNowPage][k]
                   
                                objs :  setImageWithSpriteFrameName( "general_underframe_click.png" )
                                objs :  setPreferredSize(CCSizeMake(375,115))

                                self : createGoodsBtnSpriteBtnCCBI(k)  --创建特效

                                self.theOldSpriteBtnId = objs
                            end


                            if buyCount > 0 then
        
                                local msg = "是否确定购买?"
                                local function fun1()
                                    self : BuyNetWorkSend(data.theType,data.theTypeBb,v.idx,0,buyCount,v.type)
                                end
                                local function fun2()
                                    print("不要了")
                                end
                                self : createMessageBox(msg,fun1,fun2) 

                            end

                            break
                        end
                    end
                end
            end
        end
    end
end


----------------------------------------每日特惠--------------每日特惠--------------每日特惠-------------------------------------------
--每日特惠数据返回
function CSuperDealsShopLayer.NetWrokReturn_EveryDayDealsView( self,Msg,Count,TypeBb,Type )

    self : initPageScrollView(Count,TypeBb,Type,Msg) --初始 PageScrollView 界面

   if Msg ~= nil then
        self : setEveryDayDealsData(Msg) --保存数据

        if self.EveryDayDeals_GoodsSprite ~= nil then
            self.EveryDayDeals_GoodsSprite : removeFromParentAndCleanup(true)
            self.EveryDayDeals_GoodsSprite = nil 
        end

        --local Node =  _G.Config.goodss:selectNode("goods","id",tostring(Msg[1].goods_id)) --装备节点
        local Node = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(Msg[1].goods_id).."]")
        if Node : isEmpty() == false then
            local Node_icon  = Node : getAttribute("icon")
            local Node_color = Node : getAttribute("name_color")            
            local icon_url   = "Icon/i"..Node_icon..".jpg"
            self.EveryDayDeals_GoodsSprite = CSprite : create(icon_url) --物品图
            self.EveryDayDeals_GoodsBoxSprite : addChild(self.EveryDayDeals_GoodsSprite,-2)

            --特效特效
            local theType  = tonumber(Node : getAttribute("type"))
            if theType == 1 or theType == 2 then
                self : Create_effects_equip(CSuperDealsShopLayer.TAG_EveryDayDealsPage,self.EveryDayDeals_GoodsBoxSprite,Node_color,Msg[1].goods_id,Msg[1].index)
            end


            --物品数量
            local CountNode       =  _G.Config.mail_id_counts : selectSingleNode("mids[0]"):children()
            local CountNode_Count = CountNode : getCount("mid")
            if CountNode_Count ~= nil then
                for i=0,CountNode_Count-1 do
                    local node =  CountNode : get(i,"mid") 
                    if tonumber(Msg[1].idx)  == tonumber(node : getAttribute("id")) and self.EveryDayDeals_GoodsCountLabel ~= nil  then
                         print("每日特惠的物品数量是===",node : getAttribute("count"),Msg[1].idx,Msg[1].goods_id)
                        self.EveryDayDeals_GoodsCountLabel : setString("x"..node : getAttribute("count"))
                        break
                    end
                end
            end


            self.EveryDayDeals_GoodsNameLabel     : setString(Node : getAttribute("name"))
            self.EveryDayDeals_GoodsYPriceLabel   : setString("原价 : "..Msg[1].s_price.."钻石")
            self.EveryDayDeals_GoodsNPriceLabel   : setString("现价 : "..Msg[1].v_price.."钻石")

            local isTouchState = tonumber(Msg[1].state) --1:可以购买|0:不可购买
            if isTouchState == 1 then
                self.EveryDayDeals_GoodsBuyButton     : setTouchesEnabled(true)
            elseif isTouchState == 0 then
                self.EveryDayDeals_GoodsBuyButton     : setText("已购买")
                self.EveryDayDeals_GoodsBuyButton     : setTouchesEnabled(false)
            end
        end
    end
end

--初始化每日特惠界面
function CSuperDealsShopLayer.initEveryDayDealsView(self)
    print("每日特惠准备创建")
    local function EveryDayDealsBtnCallBack(eventType, obj, x, y)
        return self : EveryDayDealsButtonCallBack(eventType,obj,x,y)
    end

    local EveryDayDealsContiner = CContainer : create()
    EveryDayDealsContiner       : setPosition(405,-300)
    EveryDayDealsContiner       : setControlName( "this is CSuperDealsShopLayer pageContiner 593" )

    local EveryDayDeals_BackGroundSprite  = CSprite : createWithSpriteFrameName("general_second_underframe.png") --背景图
    local EveryDayDeals_GirlSprite        = CSprite : create("loginResources/login_big_player4.png")   --妹纸图片
    local EveryDayDeals_LogoSprite        = CSprite : createWithSpriteFrameName("superstore_word_mrlc.png") --Logo
    local EveryDayDeals_ColorSprite       = CSprite : createWithSpriteFrameName("battle_hits_hits_frame.png") -- 紫色备图
    local EveryDayDeals_InfoSprite        = CSprite : createWithSpriteFrameName("superstore_word_jsth.png") --今日特惠
    local EveryDayDeals_InfoLabel         = CCLabelTTF : create("海量斗气经验","Arial",24)
    local EveryDayDeals_GoodsBackSprite   = CSprite : createWithSpriteFrameName("general_thirdly_underframe.png") --物品底框

    self.EveryDayDeals_GoodsBoxSprite     = CSprite : createWithSpriteFrameName("general_props_frame_normal.png") -- 物品框框
    local EveryDayDeals_LineSprite        = CSprite : createWithSpriteFrameName("team_dividing_line.png") --淫荡的直线
    self.EveryDayDeals_GoodsNameLabel     = CCLabelTTF : create("200万美刀","Arial",18)
    self.EveryDayDeals_GoodsCountLabel    = CCLabelTTF : create("","Arial",18)
    self.EveryDayDeals_GoodsYPriceLabel   = CCLabelTTF : create("原价 : 1200钻石","Arial",18)
    self.EveryDayDeals_GoodsNPriceLabel   = CCLabelTTF : create("现价 : 1000钻石","Arial",18)
    self.EveryDayDeals_GoodsBuyButton     = CButton : createWithSpriteFrameName("购买","general_smallbutton_normal.png")
    self.EveryDayDeals_GoodsBuyButton     : registerControlScriptHandler(EveryDayDealsBtnCallBack,"this CMysteriousShopLayer GoodsBuyBtn[i]CallBack 120")

    EveryDayDeals_BackGroundSprite       : setPreferredSize(CCSizeMake(810,540))
    EveryDayDeals_GirlSprite             : setScaleX(-1)
    EveryDayDeals_ColorSprite            : setPreferredSize(CCSizeMake(420,100))
    EveryDayDeals_GoodsBackSprite        : setPreferredSize(CCSizeMake(435,225))
    self.EveryDayDeals_GoodsNameLabel    : setAnchorPoint( ccp(0.0, 0.5))
    self.EveryDayDeals_GoodsCountLabel   : setAnchorPoint( ccp(0.0, 0.5))  
    self.EveryDayDeals_GoodsYPriceLabel  : setAnchorPoint( ccp(0.0, 0.5)) 
    self.EveryDayDeals_GoodsNPriceLabel  : setAnchorPoint( ccp(0.0, 0.5)) 
    self.EveryDayDeals_GoodsNPriceLabel  : setColor(ccc3(0,150,255))
    self.EveryDayDeals_GoodsYPriceLabel  : setColor(ccc3(150,150,150))
    self.EveryDayDeals_GoodsBuyButton    : setFontSize(24)
    EveryDayDeals_LineSprite             : setPreferredSize(CCSizeMake(120,2))

    EveryDayDeals_GirlSprite             : setPosition(200,0)
    EveryDayDeals_LogoSprite             : setPosition(-40,200)
    EveryDayDeals_ColorSprite            : setPosition(-110,100)    
    EveryDayDeals_InfoSprite             : setPosition(0,5) 
    EveryDayDeals_InfoLabel              : setPosition(0,-60) 
    EveryDayDeals_GoodsBackSprite        : setPosition(-140,-100) 

    self.EveryDayDeals_GoodsBoxSprite    : setPosition(-280,-65)
    self.EveryDayDeals_GoodsNameLabel    : setPosition(80,40)
    self.EveryDayDeals_GoodsCountLabel   : setPosition(200,40)
    self.EveryDayDeals_GoodsYPriceLabel  : setPosition(80,0)
    self.EveryDayDeals_GoodsNPriceLabel  : setPosition(80,-40)
    self.EveryDayDeals_GoodsBuyButton    : setPosition(120,-95)
    EveryDayDeals_LineSprite             : setPosition(50,10)

    EveryDayDealsContiner               : addChild(EveryDayDeals_BackGroundSprite,10)
    EveryDayDealsContiner               : addChild(EveryDayDeals_GirlSprite,11)
    EveryDayDealsContiner               : addChild(EveryDayDeals_LogoSprite,12)
    EveryDayDealsContiner               : addChild(EveryDayDeals_ColorSprite,12)
    EveryDayDeals_ColorSprite           : addChild(EveryDayDeals_InfoSprite)
    EveryDayDeals_ColorSprite           : addChild(EveryDayDeals_InfoLabel,12)
    EveryDayDealsContiner               : addChild(EveryDayDeals_GoodsBackSprite,12)

    EveryDayDealsContiner               : addChild(self.EveryDayDeals_GoodsBoxSprite,12)
    self.EveryDayDeals_GoodsBoxSprite   : addChild(self.EveryDayDeals_GoodsNameLabel,12)
    self.EveryDayDeals_GoodsBoxSprite   : addChild(self.EveryDayDeals_GoodsCountLabel,12)
    self.EveryDayDeals_GoodsBoxSprite   : addChild(self.EveryDayDeals_GoodsYPriceLabel,12)
    self.EveryDayDeals_GoodsBoxSprite   : addChild(self.EveryDayDeals_GoodsNPriceLabel ,12)
    self.EveryDayDeals_GoodsBoxSprite   : addChild(self.EveryDayDeals_GoodsBuyButton ,12)
    self.EveryDayDeals_GoodsYPriceLabel : addChild(EveryDayDeals_LineSprite ,12)

    return EveryDayDealsContiner
end
--每日特惠购买回调
function CSuperDealsShopLayer.EveryDayDealsButtonCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        --local  tagvalue = obj : getTag()
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("每日特惠购买按钮回调")

            -- local actarr = CCArray:create()
            -- local function t_callback1()
            --     if self.EveryDayDeals_GoodsBuyButton ~= nil then
            --         self.EveryDayDeals_GoodsBuyButton : setTouchesEnabled(false)
            --     end
            -- end
            -- actarr:addObject( CCCallFunc:create(t_callback1) )
            -- obj:runAction( CCSequence:create(actarr) )

            local data = self : getEveryDayDealsData() --获取从服务器发过来的数据
            if data ~= nil then
                print("准备发送每日特惠购买协议")
                self : setNowClickBuyBtn(obj) --当前按的按钮

                --物品数量

                local CountNode       =  _G.Config.mail_id_counts : selectSingleNode("mids[0]"):children()
                local CountNode_Count = CountNode : getCount("mid")
                local buyCount        = nil 
                if CountNode_Count ~= nil then
                    for i=0,CountNode_Count-1 do
                        local node =  CountNode : get(i,"mid") 
                        if tonumber(data[1].idx)  == tonumber(node : getAttribute("id"))   then
                            buyCount = node : getAttribute("count")
                            break
                        end
                    end
                end

                if buyCount ~= nil then
                    
                    local msg = "是否确定购买?"
                    local function fun1()
                        self : BuyNetWorkSend(20,2020,data[1].idx,data[1].goods_id,buyCount,data[1].type)
                    end
                    local function fun2()
                        print("不要了")
                    end
                    self : createMessageBox(msg,fun1,fun2) 

                end
            end
        end
    end
end
----------------------------------------每日特惠--------------每日特惠--------------每日特惠-------------------------------------------

function CSuperDealsShopLayer.ScrollViewCallBack(self,eventType,obj,x,y)
    print("eventTypeeventType=",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        local currentPage = x
        local pageCount   = obj : getTag()

        print("CSuperDealsShopLayer.ScrollViewCallBack---->>>",currentPage,pageCount)
        -- if currentPage ~= self.m_currentPage then
            --self.m_currentPage = pageCount-currentPage
            self.m_currentPage = currentPage + 1
            print("699 pageCount",pageCount)
            --self.m_pageLabel :setString( self.m_currentPage.."/"..pageCount)
            if self : getNowStayPage() == CSuperDealsShopLayer.TAG_LVPage then
                self.theLVPageBtnLabel : setText(self.m_currentPage.."/"..pageCount)
            elseif CSuperDealsShopLayer.TAG_VIPPage  then
                self.theVIPPageBtnLabel : setText(self.m_currentPage.."/"..pageCount)
            end
        -- end
    end
end

function CSuperDealsShopLayer.exchangeDataTable(self,_listdata,_Count)
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

function CSuperDealsShopLayer.open(self)
    _G.pCSuperDealsShopLayer         = CSuperDealsShopLayer()
    _G.g_SuperDealsShopLayerMediator = CSuperDealsShopLayerMediator(_G.pCSuperDealsShopLayer)
    controller:registerMediator( _G.g_SuperDealsShopLayerMediator )
    --open
    local scene = _G.pCSuperDealsShopLayer : scene()
    CCDirector : sharedDirector() : pushScene(scene)
end

function CSuperDealsShopLayer.getMallDataFromXML(self,_mall_id)
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
    --print("loops = ",loop,self.MallListData[4].class4_name,#self.MallListData,self.MallListData.loop)
end

function CSuperDealsShopLayer.Create_effects_button( self,obj) --充值特效添加

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    if obj ~= nil then
        self.RechargeBtneffectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_button.ccbi" )
        self.RechargeBtneffectsCCBI : setControlName( "this CCBI Create_effects_activity CCBI")
        self.RechargeBtneffectsCCBI : registerControlScriptHandler( animationCallFunc)
        obj                         : addChild(self.RechargeBtneffectsCCBI,1000) 
    end
end

function CSuperDealsShopLayer.Create_effects_equip ( self,pageType,obj,name_color,id,index) 
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

        if pageType == CSuperDealsShopLayer.TAG_EveryDayDealsPage then
            --单独的每日特惠的特效
            if obj ~= nil and index ~= nil  then

                self.EveryDayDealsCCBI = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self.EveryDayDealsCCBI : setControlName( "this CCBI Create_effects_activity CCBI")
                self.EveryDayDealsCCBI : registerControlScriptHandler( animationCallFunc)
                obj  : addChild(self.EveryDayDealsCCBI,1000)
            end

        else
            
            if obj ~= nil and index ~= nil  then

                self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
                self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
                self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
                obj  : addChild(self["effect_ccbi"..index],1000)

                self : setSaveCreateEffectCCBIList(index,id)
            end

        end

    end
end

function CSuperDealsShopLayer.setSaveCreateEffectCCBIList ( self,index,id) 
    print("CSuperDealsShopLayer 存表----",index,id)
    local data = {}
    data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
    print("CSuperDealsShopLayer 村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CSuperDealsShopLayer.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CSuperDealsShopLayer.removeAllCCBI ( self) 
    print("CSuperDealsShopLayer 开始调用删除CCBI")
    -- local data = self :getShowList() 
    local data = self :getSaveCreateEffectCCBIList() 
    print("1")
    if  data ~= nil then
        print("2")
        for k,goods in pairs(data) do
            print("3")
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                --local id = goods.goods_id
                local index = goods.index
                if  self["effect_ccbi"..index] ~= nil then
                    print("4")
                    self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..index] = nil 
                    print("CSuperDealsShopLayer 删除了CCBI,其名为=========",index)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据

    if self.RechargeBtneffectsCCBI ~= nil then
        self.RechargeBtneffectsCCBI : removeFromParentAndCleanup(true)
        self.RechargeBtneffectsCCBI = nil 
    end

    if self.EveryDayDealsCCBI ~= nil then
        self.EveryDayDealsCCBI : removeFromParentAndCleanup(true)
        self.EveryDayDealsCCBI = nil 
    end

    self : removeGoodsBtnSpriteBtnCCBI() --删除背景的特效
end

function CSuperDealsShopLayer.createGoodsBtnSpriteBtnCCBI( self, _no  )

    -- self.nowTheSpriteBtnCCBINo = _no
    local nowPage = tonumber(self : getNowStayPage()) 

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
    self["GoodsBtnSpriteBtn"..nowPage][_no] : addChild( self.ccbi_up,1,901 )

    self.ccbi_down = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    self.ccbi_down : setControlName( "this CActivitiesView ccbi_down 84")
    self.ccbi_down : registerControlScriptHandler( local_animationCallFunc )
    self.ccbi_down : setPosition( _size.width/2 - n_X, - _size.height/2 + n_Y)
    self["GoodsBtnSpriteBtn"..nowPage][_no] : addChild( self.ccbi_down,1,902 )

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

function CSuperDealsShopLayer.removeGoodsBtnSpriteBtnCCBI( self )  --删除ccbi
    if self.ccbi_up ~= nil then
        self.ccbi_up : removeFromParentAndCleanup( true )
        self.ccbi_up = nil
    end

    if self.ccbi_down ~= nil then
        self.ccbi_down : removeFromParentAndCleanup( true )
        self.ccbi_down = nil
    end 
end

function CSuperDealsShopLayer.setMainPropertyMoney(self) --设置现在的金额显示

    local mainProperty = _G.g_characterProperty : getMainPlay()
    local money        = 0 
    
    --获取钻石
    money    = tonumber(mainProperty :getBindRmb()) 
    self.m_MoneyLabel : setString("钻石:"..money)
end


















