--[[
 --CCharacterSellView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "mediator/CharacterMediator"
require "controller/CharacterUpadteCommand"

require "view/CharacterPanelLayer/CharacterBackpackView"

CCharacterSellView = class(view, function( self)
    print("CCharacterSellView:角色信息主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_characterPageContainer= nil   --4个标签容器公用
    self.m_characterSellViewContainer  = nil  --人物面板的容器层
    self.m_partnerId             = 0     --主角属性
    self.m_sellgoodscount        = 0
    self.m_sellgoodslist         = {}
    self.m_sellallprice          = 0
end)
--Constant:
CCharacterSellView.TAG_SELL         = 201
CCharacterSellView.TAG_CLOSED       = 202

CCharacterSellView.FONT_SIZE        = 25
CCharacterSellView.SELL_GOOGS_MAX   = 16
CCharacterSellView.TAB_BUTTON_SIZE  = CCSizeMake( 130, 60)

--加载资源
function CCharacterSellView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    
end
--释放资源
function CCharacterSellView.unLoadResource( self)
end
--初始化数据成员
function CCharacterSellView.initParams( self, layer)
    print("CCharacterSellView.initParams")
    self.m_uid       = _G.g_LoginInfoProxy :getUid()
    self.m_partnerId = 0

    self.m_mymediator  = CCharacterSellMediator( self)
    controller :registerMediator( self.m_mymediator)--先注册后发送 否则会报错

end
--释放成员
function CCharacterSellView.realeaseParams( self)
    if self.m_characterPageContainer ~= nil then
        self.m_characterPageContainer :removeAllChildrenWithCleanup( true)
    end
end

--布局成员
function CCharacterSellView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面5")
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local characterpanelbackgroundfirst    = self.m_characterSellViewContainer :getChildByTag( 100)
        local closeButtonSize                  = self.m_closedButton: getPreferredSize()

        characterpanelbackgroundfirst :setPreferredSize( backgroundSize)

        self.m_characterTab : setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height-closeButtonSize.height*0.7))
        --默认显示属性
        self.m_characterTab : setSelectedTabIndex( 0)

        characterpanelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        self.m_closedButton: setPosition( ccp(winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
        
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

function CCharacterSellView.sellGoodsLayout( self)
    --640
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        print("640--角色信息主界面5")
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local buttonSize                       = self.m_sellButton :getPreferredSize()
        local sellbackgroundSize               = CCSizeMake( backgroundSize.width*0.48, winSize.height*0.7)
        local sellbackground                   = self.m_sellViewContainer :getChildByTag( 100)

        sellbackground :setPreferredSize( sellbackgroundSize)

        sellbackground :setPosition( ccp( winSize.width/2, winSize.height*0.52+15))
        self.m_layout :setPosition( winSize.width/2-sellbackgroundSize.width/2+5, winSize.height*0.7+25)
        self.m_priceContainer :setPosition( ccp( winSize.width/2-sellbackgroundSize.width/2+ buttonSize.width+100, winSize.height*0.09+15))
        self.m_sellButton :setPosition( ccp( winSize.width/2-sellbackgroundSize.width/2+ buttonSize.width/2+30, winSize.height*0.09+15))
        self.m_sellViewContainer :setPosition( ccp( -backgroundSize.width/2+sellbackgroundSize.width/2+15, 0))    
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

--主界面初始化
function CCharacterSellView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CCharacterSellView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterSellView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CCharacterSellView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterSellView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CCharacterSellView.initView(self, layer)
    print("CCharacterSellView.initView")
    --副本界面容器
    self.m_characterSellViewContainer = CContainer :create()
    self.m_characterSellViewContainer : setControlName("this is CCharacterSellView self.m_characterSellViewContainer 94 ")
    layer :addChild( self.m_characterSellViewContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local characterpanelbackgroundfirst   = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    characterpanelbackgroundfirst : setControlName( "this CCharacterSellView characterpanelbackgroundfirst 124 ")

    self.m_closedButton     = self :createButton( " ", "general_close_normal.png", CallBack, CCharacterSellView.TAG_CLOSED, "self.m_closedButton")

    self.m_characterSellViewContainer :addChild( characterpanelbackgroundfirst, -1, 100)
    self.m_characterSellViewContainer :addChild( self.m_closedButton, 2, CCharacterSellView.TAG_CLOSED)

    --出售界面出售容器部分
    self.m_sellViewContainer = CContainer :create()
    self.m_sellViewContainer :setControlName( "this is CCharacterSellView self.m_sellViewContainer 134")
    self.m_characterSellViewContainer :addChild( self.m_sellViewContainer)
    self :addSellGoods()

    --默认背包界面
    --add:
    local tempinfoview       = CCharacterBackpackView()
    self.m_characterSellViewContainer :addChild( tempinfoview :layer( 4, self.m_partnerId))
    self.m_backpackmediator  = CCharacterSellBackpackMediator( tempinfoview)
    controller :registerMediator( self.m_backpackmediator)--先注册后发送 否则会报错

    ----[[
    --Tab
    self.m_characterTab = CTab : create (eLD_Horizontal, CCharacterSellView.TAB_BUTTON_SIZE)--按钮间距
    self.m_characterSellViewContainer : addChild (self.m_characterTab)

    local tempTabPage        = nil
    local tempPageContainer  = nil
    --角色属性页面
    tempTabPage         = self :createTabPage( "出售", CallBack, CCharacterSellView.TAG_ATTRIBUTE, "characterInfomationPage")
    tempPageContainer   = self :createContainer( "characterInfomationContainer")
    self.m_characterTab : addTab( tempTabPage, tempPageContainer)
    --]]

end

function CCharacterSellView.addSellGoods( self)
    if self.m_sellViewContainer ~= nil then
        self.m_sellViewContainer :removeAllChildrenWithCleanup( true)
    end
    --背景图片
    local sellbackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")     --背景Img
    sellbackground : setControlName( "this CCharacterSellView sellbackground 124 ")
    self.m_sellViewContainer :addChild( sellbackground, -1, 100)
    --出售按钮
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    self.m_sellButton       = self :createButton( "出售", "general_button_normal.png", CallBack, CCharacterSellView.TAG_SELL, "self.m_sellButton")    --出售按钮 伙伴
    self.m_sellViewContainer :addChild( self.m_sellButton)
    --出售总价格
    self.m_priceContainer   = self :createPrice( 2, self.m_sellallprice)
    self.m_sellViewContainer :addChild( self.m_priceContainer)
    --添加物品
    self.m_layout = CHorizontalLayout :create()
    self.m_sellViewContainer :addChild(self.m_layout)
    self.m_layout :setVerticalDirection(false)
    self.m_layout :setCellVerticalSpace( -2)
    self.m_layout :setLineNodeSum( 4)
    --self.m_layout :setCellSize(m_bgCell)

    for i=1,CCharacterSellView.SELL_GOOGS_MAX do
        local num = #self.m_sellgoodslist
        local goodcontainer = nil
        if i <= num then
            goodcontainer = self :createGoodsItem( self.m_sellgoodslist[i])
        else
            goodcontainer = self :createGoodsItem()
        end        
        self.m_layout :addChild( goodcontainer)        
    end

    self :sellGoodsLayout()
end

--创建金钱图标和数量
function CCharacterSellView.createPrice( self, _type, _string)
    --根据_type创建图标
    local _imagename = nil
    if _type == 1 then    --钻石
        _imagename = "menu_icon_dollar.png"
    elseif _type == 2 then--美刀
        _imagename = "menu_icon_dollar.png"
    elseif _type == 3 then--斗魂
        _imagename = "menu_icon_dollar.png"
    end
    local _container       = self :createContainer( "createPrice _container")
    local _itempricesprite = self :createSprite( _imagename, "createSprite _itempricesprite")
    _container :addChild( _itempricesprite)
    local _itempriceslabel = CCLabelTTF :create( _string, "Arial", CCharacterInfoView.FONT_SIZE)
    _itempriceslabel :setColor( ccc3( 226,215,118))
    _itempriceslabel :setAnchorPoint( ccp( 0, 0.5))
    _itempriceslabel :setPosition( ccp( 30, 0))
    _container :addChild( _itempriceslabel)
    return _container
end

function CCharacterSellView.createGoodsItem( self, _good)
    print("CGoodsInfoView.createGoodsItem")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickGoodsCallBack( eventType, obj, x, y)
    end
    if _good == nil then
        _goodname = "没有物品"
    end
    local goodcontainer      = self :createContainer( "createGoodsItem goodcontainer:".._goodname)
    local background         = self :createSprite( "general_props_underframe.png", "createGoodsItem background 160")
    local backgroundframe    = self :createSprite( "general_props_frame_normal.png", "createGoodsItem backgroundframe 160")    
    goodcontainer :addChild( background)
    if _good ~= nil then
        local goodbutton = nil
        local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        print( "CCCCC:", _good.index,_good.goods_id,goodnode : getAttribute("icon"))
        goodbutton = self :createGoodsButton( "", "Icon/i"..goodnode : getAttribute("icon")..".jpg", CallBack, _good.index, "createGoodsItem goodbutton :".._good.index)
        --goodbutton :setScale( 1.3)      
        goodcontainer :addChild( goodbutton)
    end    
    goodcontainer :addChild( backgroundframe)
    return goodcontainer
end

--创建TabPage
function CCharacterSellView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CCharacterSellView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CCharacterSellView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end

--创建按钮GoodsButton  散图
function CCharacterSellView.createGoodsButton( self, _string, _image, _func, _tag, _controlname)
    print( "CCharacterSellView.createGoodsButton buttonname:".._string.._controlname)

    if _G.g_CharacterPanelView ~= nil then
        _G.g_CharacterPanelView:insertCreateResStr( "Icon/i"..tostring(goodnode.icon)..".jpg" )
    end
    if _G.g_CCharacterCheckPanelView ~= nil then 
        _G.g_CCharacterCheckPanelView:insertCreateResStr( "Icon/i"..tostring(goodnode.icon)..".jpg" )
    end

    local m_button = CButton :create( _string, _image)
    m_button :setControlName( "this CCharacterSellView createGoodsButton:".._controlname)
    m_button :setFontSize( CCharacterSellView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CCharacterSellView ".._controlname.."CallBack")
    return m_button
end

--创建按钮Button   plist 合图
function CCharacterSellView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CCharacterSellView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CCharacterSellView createButton:".._controlname)
    m_button :setFontSize( CCharacterSellView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CCharacterSellView ".._controlname.."CallBack")
    return m_button
end

--创建CSprite
function CCharacterSellView.createSprite( self, _image, _controlname)
    print( "CCharacterSellView.createSprite:".._image)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this is CCharacterSellView createSprite:".._controlname)
    return _itemsprite
end

--创建CContainer
function CCharacterSellView.createContainer( self, _controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( "this is CCharacterSellView createContainer:".._controlname)
    return _itemcontainer
end

function CCharacterSellView.removeGoodsByIndex( self, _index)
    for i=1, self.m_sellgoodscount do
        if self.m_sellgoodslist[i].index == _index then
            self.m_sellallprice = self.m_sellallprice - self.m_sellgoodslist[i].price
            table.remove( self.m_sellgoodslist, i)
            self.m_sellgoodscount = self.m_sellgoodscount - 1
            --放回背包中
            local command = CCharacterSellCancleCommand( _index)
            controller :sendCommand( command)
            break
        end
    end
    self :addSellGoods()
end

--卖掉所有goods
function CCharacterSellView.sellAllGoods(self)
    if self.m_sellgoodscount <= 0 then
        --提示没有东西出售
        --add:
        print("没有东西出售",self.m_sellgoodscount)
    else    --self.m_sellnumber = 1       
        local sellNum = table.maxn(self.m_sellgoodslist)
        local i = 1
        while i <= self.m_sellgoodscount do
            local idx = self.m_sellgoodslist[i].index 
            local num = self.m_sellgoodslist[i].goods_num
            i = i + 1
            --请求卖掉good
            print("idx:",idx,"num:",num)      
            require "common/protocol/auto/REQ_GOODS_SELL"
            local msg = REQ_GOODS_SELL()
            msg :setArguments( idx, num)
            CNetwork :send( msg)
        end
        self.m_sellgoodscount = 0
        self.m_sellallprice   = 0
        self.m_sellgoodslist  = {}
        self :addSellGoods()       
    end
end

-----------------------------------------------------
--更新本地list数据
----------------------------------------------------
--更新本地list数据
function CCharacterSellView.setLocalList( self, _good)
    print("CCharacterSellView.setLocalList:",_good.goods_id.."/".._good.index)
    table.insert( self.m_sellgoodslist, _good) 
    self.m_sellgoodscount = self.m_sellgoodscount + 1
    self.m_sellallprice = self.m_sellallprice + _good.price
    self :addSellGoods()

end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CCharacterSellView.clickGoodsCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        self :removeGoodsByIndex( obj :getTag())
    end
end

function CCharacterSellView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CCharacterSellView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                --self :resetPageContainer()
                controller :unregisterMediator( self.m_mymediator)
                controller :unregisterMediator( self.m_backpackmediator)
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CCharacterSellView.TAG_SELL then
            print(" 出售")
            self :sellAllGoods()
        end
    end
end





















