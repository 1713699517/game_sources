--[[
 --CVindictivePanelView
 --斗气面板主界面
 --]] 

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/VindictiveMediator"
require "view/VindictivePanelLayer/VindictivePopupView"

CVindictivePanelView = class(view, function( self)
    print("CVindictivePanelView:斗气面板主界面")
    self.m_diamondSavvyContainer        = nil   -- 钻石领悟
    self.m_oneKeySavvyButton         = nil   -- 一键领悟
    self.m_convertVindictiveButton   = nil   -- 兑换斗气
    self.m_equipVindictiveButton     = nil   -- 装备斗气
    self.m_oneKeySwallowButton       = nil   -- 一键吞噬
    self.m_oneKeyPickUpButton        = nil   -- 一键拾取
    self.m_closedButton              = nil   -- 关闭

    self.m_clickVindictive           = nil   --存放当前选中斗气

    self.m_tagLayout                 = nil   --5种普通领悟按钮的水平布局
    self.m_vindictivePanelContainer  = nil   -- 斗气面板的容器层
    self.m_partnerId                 = 0     --主角属性
    self.m_vindictivecount           = 0
    self.m_vindictivelist            = {}
    self.m_vindictiveContainer       = {}
    self.m_vindictiveButton          = {}
    self.m_savvytime                 = 0
    self.m_detectIndex               = -1
end)
--Constant:
CVindictivePanelView.TAG_GENERALSAVVY       = 150   -- 普通领悟
CVindictivePanelView.TAG_DIAMONDSAVVY       = 202   -- 钻石领悟
CVindictivePanelView.TAG_ONEKEYSAVVY        = 203   -- 一键领悟
CVindictivePanelView.TAG_CONVERTVINDICTIVE  = 204   -- 兑换斗气
CVindictivePanelView.TAG_EQUIPVINDICTIVE    = 205   -- 装备斗气
CVindictivePanelView.TAG_ONEKEYPICKUP       = 206   -- 一键拾取
CVindictivePanelView.TAG_ONEKEYSWALLOW      = 207   -- 一键吞噬
CVindictivePanelView.TAG_CLOSED             = 208   -- 关闭

CVindictivePanelView.TAG_ICON               = 209   --物品图片tag
CVindictivePanelView.TAG_FARME_ICON         = 210   --选中效果图片
CVindictivePanelView.TAG_PRICELABEL         = 211

CVindictivePanelView.PER_PAGE_COUNT         = 24

--字体大小
CVindictivePanelView.FONT_SIZE        = 20
--一键领悟斗气出现时间间隔
CVindictivePanelView.TIME_SIZE        = 0.3--0.15  --s

--加载资源
function CVindictivePanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("VindictiveResources/VindictiveResources.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")    --货币

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Fight_gas.plist")

end
--释放资源
function CVindictivePanelView.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("VindictiveResources/VindictiveResources.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Fight_gas.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("VindictiveResources/VindictiveResources.pvr.ccz")
    --CCTextureCache :sharedTextureCache():removeTextureForKey("Fight_gas.pvr.ccz")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

--初始化数据成员
function CVindictivePanelView.initParams( self, layer)
    print("CVindictivePanelView.initParams")
    _G.Config:load("config/fight_gas_total.xml")
    local roleProperty = _G.g_characterProperty :getMainPlay()
    self.m_roleVipLv   = roleProperty :getVipLv()
    self.m_mediator  = CVindictiveSavvyMediator( self)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --注册时间回调 用于一键领悟斗气出现时间控制
    self :registerEnterFrameCallBack()

    self :REQ_SYS_DOUQI_ASK_GRASP_DOUQI()

    local roleProperty = _G.g_characterProperty : getMainPlay()
    self.m_gold        = roleProperty :getGold()
    self.m_rmb         = roleProperty :getRmb() + roleProperty :getBindRmb()

    self.m_uid       = _G.g_LoginInfoProxy :getUid()
    self.m_partnerId = 0

    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local tempSize = CCSizeMake( winSize.height/3*4, winSize.height)
end
--释放成员
function CVindictivePanelView.realeaseParams( self)
    if self.m_vindictivePanelContainer ~= nil then
        self.m_vindictivePanelContainer :removeAllChildrenWithCleanup( true)
    end
end

function CVindictivePanelView.getVindictiveXML( self, _index)
    local _node  = _G.Config.fight_gas_totals : selectSingleNode("fight_gas_total[@gas_id2="..tostring( _index).."]")
    print("%%%%%:",_node : getAttribute("gas_name") , _node : getAttribute("gas_id2") , _node : getAttribute("color") )
    if _node : isEmpty() == false then
        return _node
    end
    return nil
end
function CVindictivePanelView.registerEnterFrameCallBack(self)
    print( "CVindictivePanelView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset()
        --local nowTime = _G.pDateTime : getTotalMilliseconds() --毫秒数
        self :updataSavvyTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

--主界面初始化--布局成员
function CVindictivePanelView.layout( self, winSize)
    --640
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        print("640--斗气面板主界面5")
        --背景
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst                  = self.m_vindictivePanelContainer :getChildByTag( 99)
        local vindictivebackgroundfirst        = self.m_vindictivePanelContainer :getChildByTag( 101)
        local vindictivebackgroundup           = self.m_vindictivePanelContainer :getChildByTag( 102)
        local closeButtonSize                  = self.m_closedButton: getPreferredSize()
        local buttonSize                       = self.m_oneKeySavvyButton :getPreferredSize()

        vindictivebackgroundfirst :setPreferredSize( backgroundSize)
        vindictivebackgroundup :setPreferredSize( CCSizeMake( backgroundSize.width-30, winSize.height*0.55))
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        vindictivebackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        vindictivebackgroundup :setPosition( ccp( winSize.width/2, winSize.height*(1-0.55/2)-closeButtonSize.height))
        --按钮Button
        local temp = 0.2*backgroundSize.width --Button之间的间距
        self.m_oneKeySavvyButton :setPosition( ccp( winSize.width/2-1.5*temp, winSize.height*0.28))
        self.m_oneKeySwallowButton :setPosition( ccp( winSize.width/2-0.5*temp, winSize.height*0.28))
        self.m_oneKeyPickUpButton :setPosition( ccp( winSize.width/2+0.5*temp, winSize.height*0.28))
        self.m_equipVindictiveButton :setPosition( ccp( winSize.width/2+1.5*temp, winSize.height*0.28))

        self.m_diamondSavvyContainer :setPosition( ccp( winSize.width/2+2*temp, winSize.height*0.18))

        self.m_convertVindictiveButton :setPosition( ccp( winSize.width/2+temp*1.5, backgroundSize.height-closeButtonSize.height/2-5))
        self.m_closedButton: setPosition( ccp(winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))


        self.m_diamondnumbers :setPosition( ccp( winSize.width/2+backgroundSize.width*0.4-35, winSize.height*0.1-10))

        self.m_pricegold2 :setPosition( ccp( winSize.width/2-backgroundSize.width/2+backgroundSize.width*0.1, backgroundSize.height-closeButtonSize.height/2))
        self.m_pricegold1 :setPosition( ccp( winSize.width/2-backgroundSize.width/2+backgroundSize.width*0.3, backgroundSize.height-closeButtonSize.height/2))
        self.m_pricegold3 :setPosition( ccp( winSize.width/2-backgroundSize.width/2+backgroundSize.width*0.5, backgroundSize.height-closeButtonSize.height/2))

        self.m_vindictiveBackpackContainer :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+30, backgroundSize.height-closeButtonSize.height*2))
        self.m_tagLayout :setPosition( winSize.width/2-backgroundSize.width/2, 35)
        self.m_tagLayout :setCellHorizontalSpace( 32)
    --768
    elseif winSize.height == 768 then
        CCLOG("768--斗气面板主界面")
    end
end

--布局成员
function CVindictivePanelView.backpackLayout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--斗气面板主界面5")

    elseif winSize.height == 768 then
        CCLOG("768--斗气面板主界面")
    end
end
function CVindictivePanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化界面
    self.initView(self, layer, winSize)
    --初始化数据
    self.initParams(self,layer)
    --成员布局移到initView中调用

end

function CVindictivePanelView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CVindictivePanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CVindictivePanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CVindictivePanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CVindictivePanelView.initView(self, layer, winSize)
    print("CVindictivePanelView.initView")
    --副本界面容器
    self.m_vindictivePanelContainer = CContainer :create()
    self.m_vindictivePanelContainer : setControlName("this is CVindictivePanelView self.m_vindictivePanelContainer 94 ")
    layer :addChild( self.m_vindictivePanelContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCallBack( eventType, obj, x, y)
    end
    --添加背景， 二级背景
    local backgroundfirst               = self :addSprite( self.m_vindictivePanelContainer, "peneral_background.jpg", 99, "backgroundfirst")
    local vindictivebackgroundfirst     = self :addSprite( self.m_vindictivePanelContainer, "general_first_underframe.png", 101, "vindictivebackgroundfirst")
    local vindictivebackgroundup        = self :addSprite( self.m_vindictivePanelContainer, "general_second_underframe.png", 102, "vindictivebackgroundup")
    --添加单击Button
    self.m_oneKeySavvyButton            = self :addButton( self.m_vindictivePanelContainer, "一键领悟", "general_button_normal.png", CallBack, CVindictivePanelView.TAG_ONEKEYSAVVY, "self.m_oneKeySavvyButton")
    self.m_oneKeySwallowButton          = self :addButton( self.m_vindictivePanelContainer, "一键吞噬", "general_button_normal.png", CallBack, CVindictivePanelView.TAG_ONEKEYSWALLOW, "self.m_oneKeySwallowButton")
    self.m_oneKeyPickUpButton           = self :addButton( self.m_vindictivePanelContainer, "一键拾取", "general_button_normal.png", CallBack, CVindictivePanelView.TAG_ONEKEYPICKUP, "self.m_oneKeyPickUpButton")
    self.m_convertVindictiveButton      = self :addButton( self.m_vindictivePanelContainer, "兑换", "general_smallbutton_click.png", CallBack, CVindictivePanelView.TAG_CONVERTVINDICTIVE, "self.m_convertVindictiveButton")
    --self.m_diamondSavvyContainer           = self :addButton( self.m_vindictivePanelContainer, "", "star_god_click.png", CallBack, CVindictivePanelView.TAG_DIAMONDSAVVY, "self.m_diamondSavvyContainer")
    self.m_equipVindictiveButton        = self :addButton( self.m_vindictivePanelContainer, "装备斗气", "general_button_normal.png", CallBack, CVindictivePanelView.TAG_EQUIPVINDICTIVE, "self.m_equipVindictiveButton")

    self.m_closedButton                 = self :addButton( self.m_vindictivePanelContainer, "", "general_close_normal.png", CallBack, CVindictivePanelView.TAG_CLOSED, "self.m_closedButton")
    --默认属性界面
    --add:
    --背包部分
    self.m_vindictiveBackpackContainer = CContainer :create()
    self.m_vindictiveBackpackContainer :setControlName("this is CVindictivePanelView self.m_vindictiveBackpackContainer ")
    layer :addChild( self.m_vindictiveBackpackContainer)
    --self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)

    self.m_pricegold2, self.m_pricegoldlabel2 = self :createPrice( 2, "99999")
    self.m_pricegold1, self.m_pricegoldlabel1 = self :createPrice( 1, "99999")
    self.m_pricegold3, self.m_pricegoldlabel3 = self :createPrice( 3, "斗魂 *9999")

    self.m_vindictivePanelContainer :addChild( self.m_pricegold2)
    self.m_vindictivePanelContainer :addChild( self.m_pricegold1)
    self.m_vindictivePanelContainer :addChild( self.m_pricegold3)

    self.m_diamondnumbers = self :addLabel( self.m_vindictivePanelContainer, "0/0")

    self.m_diamondSavvyContainer = self :createGeneralSavvy( "star_god_click.png", 1, (self :getGraspXML( 107)) : getAttribute("price") , CallBack, CVindictivePanelView.TAG_DIAMONDSAVVY)

    self.m_tagLayout     = CHorizontalLayout :create()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setLineNodeSum(6)
    --local cellButtonSize = CCSizeMake( 150, 100)
    --self.m_tagLayout :setCellSize( cellButtonSize)
    self.m_generalSavvyContainer = {}
    self.m_generalSavvyButton    = {}
    for i=_G.Constant.CONST_DOUQI_MIN_GRASP_LV, _G.Constant.CONST_DOUQI_MAX_GRASP_LV do  --
        local _imagename = "star_0"..tostring(i-_G.Constant.CONST_DOUQI_MIN_GRASP_LV+1).."_click.png"
        local _flag      = true
        if i == _G.Constant.CONST_DOUQI_MAX_GRASP_LV then
            _flag = false
        end
        self.m_generalSavvyContainer[i] = nil
        self.m_generalSavvyContainer[i], self.m_generalSavvyButton[i] = self :createGeneralSavvy( _imagename, 2, (self :getGraspXML( i)): getAttribute("price"), CallBack, CVindictivePanelView.TAG_GENERALSAVVY, _flag)
        self.m_generalSavvyButton[i] :setTouchesEnabled( false)
        self.m_tagLayout :addChild( self.m_generalSavvyContainer[i])
    end
    self.m_tagLayout :addChild( self.m_diamondSavvyContainer)

    self.m_vindictivePanelContainer :addChild( self.m_tagLayout)

    --布局成员
    self :layout( winSize)
end

--背包部分
function CVindictivePanelView.createBackpackVindictiveView( self, layer)
    --背包仓库部分
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer :setControlName( "this CVindictivePanelView.createBackpackVindictiveView self.m_goodsContainer")
    layer :addChild( self.m_goodsContainer)
    self :addAllGoods( self.m_goodsContainer, CVindictivePanelView.PER_PAGE_COUNT)
    self.m_clickVindictive = nil
end

--根据位置获取相应斗气，没有为nil
function CVindictivePanelView.getVindictiveByLanid( self, _lanid)
    if self.m_vindictivecount <= 0 then
        return nil
    end
    print("查找相应斗气:",_lanid)
    for k,v in pairs( self.m_vindictivelist) do
        --print(k.."v.lan_id"..v.lan_id)
        if v.lan_id == _lanid then
            print("找到斗气:",v.lan_id)
            return v
        end
    end
    return nil
end

--根据TAG获取斗气
 function CVindictivePanelView.getVindictiveByTag( self, _tag)

 end
 function CVindictivePanelView.getGraspXML( self, _type)
    _G.Config :load("config/fight_gas_grasp.xml")
    local _vindictivenode  = _G.Config.fight_gas_grasps : selectSingleNode("fight_gas_grasp[@grasp_id="..tostring( _type).."]")
    if _vindictivenode : isEmpty() == false then
        return _vindictivenode
    end
    return nil
end

--创建所有物品
function CVindictivePanelView.addAllGoods(self, goodscontainer, pagecount)
    print("CVindictivePanelView.addAllGoods")

    local pagegoodscount      = pagecount
    print("aaaaaaaaaaaaaaa",pagegoodscount)

    local m_bgCell  = CCSizeMake(99,110)

    local layout = CHorizontalLayout :create()
    goodscontainer :addChild( layout)
    layout :setVerticalDirection(false)
    layout :setLineNodeSum(8)
    layout :setCellSize(m_bgCell)

    for i =1 , pagegoodscount do
        local _lanid        = i+_G.Constant.CONST_DOUQI_STORAGE_START-1
        local goodItem, goodButton  = self :createGoodItem( _lanid)
        self.m_vindictiveContainer[ _lanid] = goodItem
        self.m_vindictiveButton[ _lanid]    = goodButton
        layout :addChild( goodButton,1)
    end
end

function CVindictivePanelView.createGoodItem( self, _lanid)
    local function touchesCallback(eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    local _vindictinve   = self :getVindictiveByLanid( _lanid)
    print("创建斗气================LanId:",_lanid, _vindictinve)
    local _itemButton = CButton :createWithSpriteFrameName("","star_underframe.png")
    _itemButton :setControlName( "this CVindictivePanelView _itemButton 271 ")
    _itemButton :setTouchesMode( kCCTouchesAllAtOnce )
    _itemButton :setTouchesEnabled( true)
    _itemButton :setTag( _lanid)
    _itemButton :registerControlScriptHandler( touchesCallback, "this CVindictivePanelView _itemButton CallBack 290")
    --goodContainer :addChild( _itemButton)   
    local _itembackground  = self :addSprite( _itemButton, "star_texture02.png", 0," _itembackground".._lanid)
    local _itemframesprite = self :addSprite( _itemButton, "star_underfram_click.png", CVindictivePanelView.TAG_FARME_ICON , " _itemframesprite".._lanid)
    _itemframesprite :setVisible( false)
    _itemframesprite :setZOrder(2)
    _itembackground :setZOrder(1)
    --斗气部分
    local goodContainer = CContainer :create()
    _itemButton : addChild( goodContainer, 3)
    if _vindictinve ~= nil then
        print("创建斗气CCBI")
        local _itemGoodCCBI   = self :addCCBI( goodContainer, "FightGas/fightgas_".._vindictinve.dq_type..".ccbi", 0, "_itemGoodCCBI")
        local _itemnamesprite = self :addSprite( goodContainer, "star_name_underframe.png",0," _itemnamesprite".._lanid)
        _itemnamesprite :setZOrder( 0)
        _itemnamesprite :setPreferredSize( CCSizeMake( 90, 25))
        _itemnamesprite :setPosition( ccp( 0, -45))        
        --数量标签
        local index  = _vindictinve.dq_type.._vindictinve.dq_lv
        local dqinfo = self :getVindictiveXML( index)
        local _itemprice = CCLabelTTF :create( tostring( dqinfo : getAttribute("gas_name") ),"Arial",15)
        local rgb  = self :getRGB( dqinfo : getAttribute("color") )
        _itemprice :setColor( rgb)
        _itemprice :setFontSize( CVindictivePanelView.FONT_SIZE)
        --_itemprice :setPosition( ccp( 0, -45))
        _itemnamesprite :addChild( _itemprice)
    end
    return goodContainer, _itemButton
end

--创建金钱图标和数量
function CVindictivePanelView.createPrice( self, _type, _string)
    --根据_type创建图标
    local _imagename = nil
    if _type == 1 then    --钻石
        _imagename = "menu_icon_diamond.png"
    elseif _type == 2 then--美刀
        _imagename = "menu_icon_dollar.png"
    elseif _type == 3 then--斗魂
        _imagename = "star_soul_cion.png"
    end

    local _container = CContainer :create()
    _container :setControlName( "this CVindictivePanelView.createPrice _container")
    local _itempricesprite = self :addSprite( _container, _imagename, 0, "_itempricesprite")
    --_itempricesprite :setScale(0.7)
    local _itempriceslabel = self :addLabel( _container, _string)
    _itempriceslabel :setTag( CVindictivePanelView.PER_PAGE_COUNT+_type)
    _itempriceslabel :setPosition( ccp( 25, 0))
    return _container, _itempriceslabel
end

--创建普通领悟Button
function CVindictivePanelView.createGeneralSavvy( self, _image, _type, _string, _func, _tag, _isarrow)
    local _container      = CContainer :create()
    _container :setControlName( "this CVindictivePanelView.createGeneralSavvy _container")
    local _itembackfirst  = self :addSprite( _container, "star_frame.png", 0, "createGeneralSavvy._itembackfirst".._type)
    local _itembackground = self :addSprite( _container, "star_underframe_small.png", 0, "createGeneralSavvy._itembackground".._type)
    if _isarrow == true then
        local _itemstararrow  = self :addSprite( _container, "star_arrow.png", 0, "createGeneralSavvy._itemstararrow".._type)
        _itemstararrow :setPosition( ccp( 115, 60))
    end
    local _itemprice      = self :createPrice( _type, _string)
    _container :addChild( _itemprice)
    local _itembutton     = self :addButton( _container, "", _image, _func, _tag, "普通领悟button")
    --_itembutton :setScale(1.2)
    local firstSize = _itembackfirst : getPreferredSize()
    _itembackfirst :setPosition( ccp(firstSize.width/2-5,firstSize.height/2-20))
    _itembackground :setPosition( ccp( 50, 60))
    _itembutton :setPosition( ccp( 50, 60))
    _itemprice :setPosition(ccp( 20,0))
    return _container, _itembutton
end

--创建按钮Button
function CVindictivePanelView.addButton( self, _container, _string, _image, _func, _tag, _controlname)
    if _string == nil then
        _string = " "
    end
    print( "CVindictivePanelView.addButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CVindictivePanelView ".._controlname)
    _itembutton :setFontSize( CVindictivePanelView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CVindictivePanelView ".._controlname.."CallBack")
    _container :addChild( _itembutton)
    return _itembutton
end

--创建图片Sprite
function CVindictivePanelView.addSprite( self, _container, _image, _tag, _controlname)
    print("CVindictivePanelView.addSprite".._controlname)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this CVindictivePanelView ".._controlname)
    _itemsprite :setTag( _tag)
    _container :addChild( _itemsprite)
    return _itemsprite
end

--创建图片Sprite
function CVindictivePanelView.addCCBI( self, _container, _ccbi, _tag, _controlname)
    print("CVindictivePanelView.addSprite".._controlname)

    local _itemccbi = CMovieClip:create( _ccbi)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "AnimationComplete" then
            --self:onAnimationCompleted( eventType, arg0 )
        elseif eventType == "Enter" then
            _itemccbi : play("run")
        end
    end
    _itemccbi :setControlName( "this CVindictivePanelView ".._controlname)
    _itemccbi :registerControlScriptHandler( animationCallFunc)
    _itemccbi :setTag( _tag)
    _container :addChild( _itemccbi)
    return _itemccbi
end

--创建Label
function CVindictivePanelView.addLabel( self, _container, _string)
    print("CVindictivePanelView.addLabel")
    local _itemlabel =  CCLabelTTF :create( _string, "Arial", CVindictivePanelView.FONT_SIZE)
    _itemlabel :setAnchorPoint( ccp( 0, 0.5))
    _container :addChild( _itemlabel,1)
    return _itemlabel
end

function CVindictivePanelView.getRGBA( self, _color)
    local rgb4  = nil
    if _color ~= nil then
        print( "COLOR: ".._color)      
        rgb4   = _G.g_ColorManager :getRGBA( _color)
    else
        print("_color error")
        rgb4 = ccc4( 255,255,255,255)     
    end
    return rgb4
end
function CVindictivePanelView.getColorString( self, _color)
    local rgbstr = nil
    if _color ~= nil then
        print( "COLOR: ".._color)      
        rgbstr = _G.g_ColorManager :getColorString( _color)
    else
        print("_color error")
        rgbstr = "<color:255, 255,255,255>"    
    end
    return rgbstr
end
function CVindictivePanelView.getRGB( self, _color)
    local rgb  = nil
    if _color ~= nil then
        print( "COLOR: ".._color)      
        rgb    = _G.g_ColorManager :getRGB( _color)
    else
        print("_color error")
        rgb  = ccc3( 255,255,255)         --颜色-白  -->         
    end
    return rgb
end

function CVindictivePanelView.removeVindictiveByLanid( self, _lanid)
    if _lanid == nil then
        print(" 该位置没有斗气")
        return
    end
    print("=======Remove S ",_lanid)
    for k,v in pairs(self.m_vindictivelist) do
        if _lanid == v.lan_id then
            print("remove:",_lanid)
            table.remove( self.m_vindictivelist, k)
            self.m_vindictivecount = self.m_vindictivecount - 1
            break
        end
    end
    print("=======Remove E ",_lanid)
end


-----------------------------------------------------
--mediator更新本地数据
-----------------------------------------------------
--更新本地list数据
function CVindictivePanelView.setLocalList( self)
    print("CVindictivePanelView.setLocalList")

end

function CVindictivePanelView.setSavvyState( self, _generaltype, _oktimes, _alltimes, _adamwar)
    self.m_generaltype     = _generaltype
    self.m_diamondoktimes  = _oktimes
    self.m_diamondalltimes = _alltimes
    self.m_adamwarcounts   = _adamwar
    print( "XXXXXXXX@:"..self.m_generaltype..","..self.m_adamwarcounts)

    for i=_G.Constant.CONST_DOUQI_MIN_GRASP_LV,_G.Constant.CONST_DOUQI_MAX_GRASP_LV do
        self.m_generalSavvyButton[i] :setTouchesEnabled( false)
    end
    self.m_generalSavvyButton[self.m_generaltype] :setTouchesEnabled( true)--self.m_generaltype

    self.m_pricegoldlabel2 :setString( self.m_gold or 1)
    self.m_pricegoldlabel1 :setString( self.m_rmb or 1)
    self.m_pricegoldlabel3 :setString( "斗魂 *"..self.m_adamwarcounts)

    --if self.m_diamondoktimes >= self.m_diamondalltimes then
        --self.m_diamondSavvyContainer :getChildByTag( CVindictivePanelView.TAG_DIAMONDSAVVY) :setTouchesEnabled( false)
    --end
    self.m_diamondnumbers :setString( self.m_diamondoktimes.."/"..self.m_diamondalltimes)
end

--一键领悟斗气
function CVindictivePanelView.setOneKeySavvy( self, _count, _msgdata)
    --锁住屏幕
    CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)

    self.m_savvycount = _count   --一键领悟斗气个数
    self.m_savvydata  = _msgdata --一键领悟斗气信息
    self.m_savvytime  = CVindictivePanelView.TIME_SIZE
    --斗气更新在时间处理函数里面  CVindictivePanelView.updataSavvyTime
end

function CVindictivePanelView.updataSavvyTime( self, _duration)
    if self.m_savvytime == nil or self.m_savvytime <= 0 then
        return
    end
    self.m_savvytime = self.m_savvytime - _duration
    --解锁屏幕
    if self.m_savvycount <= 0 then
        local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
        if isdis == false then
            CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
        end
    end
    --产生斗气
    if self.m_savvytime <= 0 and self.m_savvycount > 0 then  --出现斗气 飘字 重置时间
        local tempSize = CCSizeMake( self.m_winSize.height/3*4, self.m_winSize.height)
        for k,v in pairs( self.m_savvydata) do
            print(k," 更新斗气", v.type_grasp, v.msg_dq.lan_id)
            local index  = v.msg_dq.dq_type..v.msg_dq.dq_lv
            local dqinfo = self :getVindictiveXML( index)
            local lan_id = v.msg_dq.lan_id
            table.remove( self.m_savvydata, k)
            table.insert( self.m_vindictivelist, v.msg_dq)
            self.m_vindictivecount = self.m_vindictivecount + 1
            print("###########!:",#self.m_savvydata,#self.m_vindictivelist)
            self.m_savvycount = self.m_savvycount - 1
            self.m_savvytime  = CVindictivePanelView.TIME_SIZE
            --更新美刀消耗
            local roleProperty = _G.g_characterProperty : getMainPlay()
            self.m_gold        = roleProperty :getGold()
            self.m_rmb         = roleProperty :getRmb() + roleProperty :getBindRmb()
            self.m_pricegoldlabel2 :setString( self.m_gold or 1)
            self.m_pricegoldlabel1 :setString( self.m_rmb or 1)
            --更新领悟方式
            for i=_G.Constant.CONST_DOUQI_MIN_GRASP_LV,_G.Constant.CONST_DOUQI_MAX_GRASP_LV do
                self.m_generalSavvyButton[i] :setTouchesEnabled( false)
            end
            self.m_generalSavvyButton[ v.type_grasp] :setTouchesEnabled( true) --v.type_grasp
            --飘字
            local _position = self : getStartPos()
            local _string   = dqinfo : getAttribute("gas_name") 
            local _color    = self :getColorString( dqinfo : getAttribute("color") )
            _string         = _color.._string
            local lpString  = CLabelColor : create(  )
            lpString : appendText(_string, "Marker Felt", 21)
            local nowScene = CCDirector : sharedDirector() : getRunningScene() 
            nowScene : addChild( lpString, 10000)
            lpString : setPosition( ccp( _position.x, _position.y) )
            local function onCallBack()
                lpString : removeFromParentAndCleanup(true)
                lpString = nil
            end
            local _callBacks = CCArray:create()
            _callBacks:addObject(CCMoveTo:create( 2.5, ccp( _position.x, _position.y+200) ))
            _callBacks:addObject(CCCallFunc:create(onCallBack))
            lpString : runAction( CCSequence:create(_callBacks) )
            self.m_generaltype = v.type_grasp
            --移动斗气
            local _lpCCBI = self :addCCBI( nowScene, "FightGas/fightgas_"..v.msg_dq.dq_type..".ccbi", 0, "_itemGoodCCBI")
            _lpCCBI :setPosition( ccp( _position.x, _position.y-50))
            local function onCCBICallBack()
                if self.m_vindictiveContainer[ lan_id] ~= nil then
                    print("创建斗气CCBI")
                    local _itemGoodCCBI   = self :addCCBI( self.m_vindictiveContainer[ lan_id], "FightGas/fightgas_"..v.msg_dq.dq_type..".ccbi", 0, "_itemGoodCCBI")
                    local _itemnamesprite = self :addSprite( self.m_vindictiveContainer[ lan_id], "star_name_underframe.png",0," _itemnamesprite"..lan_id)
                    _itemnamesprite :setZOrder( 0)
                    _itemnamesprite :setPreferredSize( CCSizeMake( 90, 25))
                    _itemnamesprite :setPosition( ccp( 0, -45))
                    --数量标签
                    local index  = v.msg_dq.dq_type..v.msg_dq.dq_lv
                    local dqinfo = self :getVindictiveXML( index)
                    local _itemprice = CCLabelTTF :create( tostring( dqinfo : getAttribute("gas_name") ),"Arial",15)
                    local rgb  = self :getRGB( dqinfo : getAttribute("color") )
                    _itemprice :setColor( rgb)
                    _itemprice :setFontSize( CVindictivePanelView.FONT_SIZE)
                    --_itemprice :setPosition( ccp( 0, -45))
                    _itemnamesprite :addChild( _itemprice)
                end
                --删除移动的斗气
                _lpCCBI : removeFromParentAndCleanup(true)
                _lpCCBI = nil
            end
            local _position2 = self : getDQPosByLanid( lan_id)
            local _callCCBIBacks = CCArray:create()
            _callCCBIBacks:addObject(CCMoveTo:create( CVindictivePanelView.TIME_SIZE, ccp( _position2.x, _position2.y) ))
            _callCCBIBacks:addObject(CCCallFunc:create(onCCBICallBack))
            _lpCCBI : runAction( CCSequence:create(_callCCBIBacks) )

            self.m_clickVindictive = nil
            break
        end
    end
end

--仓库斗气监听
function CVindictivePanelView.setVindictiveBackpackChange( self, _count, _dqlist)
    self.m_vindictivecount  = _count
    self.m_vindictivelist   = _dqlist
    print("##########:"..self.m_vindictivecount..#self.m_vindictivelist)

    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    local roleProperty = _G.g_characterProperty : getMainPlay()
    self.m_gold        = roleProperty :getGold()
    self.m_rmb         = roleProperty :getRmb() + roleProperty :getBindRmb()
    self.m_pricegoldlabel2 :setString( self.m_gold or 1)
    self.m_pricegoldlabel1 :setString( self.m_rmb or 1)
end

--一键拾取更新
function CVindictivePanelView.setGetVindictiveOK( self, _count, _lanmsg)
    for k,v in pairs( _lanmsg) do
        print(k,v.lan_id)
        self :removeVindictiveByLanid( v.lan_id)
    end
    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
end


--移动斗气成功
function CVindictivePanelView.setMoveVindictiveOK( self, _startid, _endid, _count, _newdata)
    self :removeVindictiveByLanid( _startid)
    self :removeVindictiveByLanid( _endid)
    print("Count:",_count,"#lsit:",#_newdata)
    table.insert( self.m_vindictivelist, _newdata[1])
    self.m_vindictivecount = self.m_vindictivecount + 1
    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    if self.m_vindictiveButton[ _endid]  ~= nil then
        self.m_clickVindictive = self.m_vindictiveButton[ _endid] 
        self.m_clickVindictive : getChildByTag(  CVindictivePanelView.TAG_FARME_ICON) : setVisible( true)
    end
    if self.m_nodeccbi ~= nil then
        self.m_scenelayer:removeChild( self.m_nodeccbi )
        self.m_nodeccbi = nil
    end
end

--一键吞噬更新
function CVindictivePanelView.setOneKeySwallow( self, _count, _swallowdata)
    print("CVindictivePanelView.setOneKeySwallow")
    for i=1,_count do
        local nodedata = _swallowdata[i]
        local endid = nodedata.lan_id
        print("EndId:",endid)
        for i=1,nodedata.count do
            local startid = nodedata.id_data[i].lan_id
            print( i,"startid:",startid)
            --移动该对象至nodedata.lan_id
        end
    end

    --local action = CCMoveTo:create( 0.5, endPosition)
    --self.m_scenelayer :runAction( action )
end

--分解成功
function CVindictivePanelView.setDecomposeVindictiveOK( self, _lanid, _adamwar)
    for i,t in pairs( self.m_vindictivelist) do
        print(i,t.lan_id)
        if _lanid == t.lan_id then
            print("remove:",t.lan_id, _lanid)
            table.remove( self.m_vindictivelist, i)
            self.m_vindictivecount = self.m_vindictivecount - 1
        end
    end
    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    --更新斗魂数量
    self.m_adamwarcounts = self.m_adamwarcounts + _adamwar
    self.m_pricegoldlabel3 :setString( "斗魂 *"..self.m_adamwarcounts)

end

function CVindictivePanelView.getIsFullLv( self, _dq)
    local index  = _dq.dq_type.._dq.dq_lv
    local dqinfo = self :getVindictiveXML( index)
    if tonumber(_dq.dq_lv) == 10 and tonumber(_dq.dq_exp) == tonumber(dqinfo : getAttribute("next_lv_exp")) then
        return true
    end
    return false
end

function CVindictivePanelView.getDqColor( self, _dq)
    local index  = _dq.dq_type.._dq.dq_lv
    local dqinfo = self :getVindictiveXML( index)
    return tonumber(dqinfo :getAttribute("color"))
end

function CVindictivePanelView.getIsSwallow( self, _dq1, _dq2)
    if self :getIsFullLv( _dq1) or self :getIsFullLv( _dq2) then
        if  self :getIsFullLv( _dq1) == true then
            if self :getIsFullLv( _dq2) == false and (self :getDqColor( _dq1) < self :getDqColor( _dq2)) then
                return true
            end
            return false
        end
        if self :getIsFullLv( _dq2) == true then
            if self :getIsFullLv( _dq1) == false and (self :getDqColor( _dq2) < self :getDqColor( _dq1)) then
                return true
            end
            return false
        end
    else
        return true
    end    
end

function CVindictivePanelView.getFormatString( self, _dq1, _dq2)
    local dqinfobegin,dqinfoend   = nil, nil
    local dqbegin, dqend  = nil, nil
    local index1  = _dq1.dq_type.._dq1.dq_lv
    local dqinfo1 = self :getVindictiveXML( index1)
    local index2  = _dq2.dq_type.._dq2.dq_lv
    local dqinfo2 = self :getVindictiveXML( index2)
    if tonumber(dqinfo1 :getAttribute("color")) > tonumber(dqinfo2 : getAttribute("color")) then
        dqinfobegin = dqinfo2
        dqinfoend   = dqinfo1
        dqbegin     = _dq2
        dqend       = _dq1
    elseif tonumber(dqinfo1 :getAttribute("color")) < tonumber(dqinfo2 : getAttribute("color")) then
        dqinfobegin = dqinfo1
        dqinfoend   = dqinfo2
        dqbegin     = _dq1
        dqend       = _dq2
    else
        if tonumber(_dq1.dq_exp) > tonumber(_dq2.dq_exp) then
            dqinfobegin = dqinfo2
            dqinfoend   = dqinfo1
            dqbegin     = _dq2
            dqend       = _dq1
        else
            dqinfobegin = dqinfo1
            dqinfoend   = dqinfo2
            dqbegin     = _dq1
            dqend       = _dq2
        end
    end
    local temp = {}
    temp[1] = {}
    temp[1].string = tostring( dqinfobegin : getAttribute("gas_name") ).."lv"..dqbegin.dq_lv
    temp[1].color  = self :getRGBA( tonumber(dqinfobegin : getAttribute("color") ))
    temp[2] = {}
    temp[2].string = "即将被 "
    temp[3] = {}
    temp[3].string = tostring( dqinfoend :getAttribute("gas_name") ).."lv"..dqend.dq_lv
    temp[3].color  = self :getRGBA( tonumber(dqinfoend :getAttribute("color") ))
    temp[4] = {}
    temp[4].string = " 吞噬!  是否需要吞噬？"
    --temp = tostring( dqinfobegin : getAttribute("gas_name") ).." 即将被 "..tostring( dqinfoend :getAttribute("gas_name") ).." 吞噬! \n是否需要吞噬？"
    return temp    
end

-----------------------------------------------------
--回调函数
-----------------------------------------------------
--多点触控
function CVindictivePanelView.viewTouchesCallback(self, eventType, obj, touches)
    --print("eventType :",eventType)
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print("XXXXXXXX",self.touchID,obj :getTag())
                    _G.pDateTime :reset()
                    self.touchID     = touch :getID()
                    self.touchLanId  = obj :getTag()
                    self.touchTime   = _G.pDateTime:getTotalMilliseconds()
                    self.m_startposition = self : getDQPosByLanid(obj:getTag())
                    local vindictinenode = self :getVindictiveByLanid( obj :getTag())
                    if  vindictinenode ~= nil then
                        print("产生移动斗气:",obj :getTag())
                        if self.m_clickVindictive ~= nil then
                            self.m_clickVindictive : getChildByTag(  CVindictivePanelView.TAG_FARME_ICON) : setVisible( false)
                        end
                        self.m_clickVindictive = self.m_vindictiveButton[ obj :getTag()] 
                        self.m_clickVindictive : getChildByTag(  CVindictivePanelView.TAG_FARME_ICON) : setVisible( true)
                        local dq_container = self.m_vindictiveButton[ obj:getTag() ]
                        local dq = self.m_vindictiveContainer[ obj:getTag() ]
                        dq:retain()
                        dq:removeFromParentAndCleanup(false)
                        --dq_container:removeChild( dq , false )
                        self.m_scenelayer:addChild( dq )
                        dq:release()
                        dq:setPosition( self : getDQPosByLanid(obj:getTag()) )
                        self.m_nodeccbi = dq
                        self.m_detectIndex = -1
                    end
                    --obj :getParent():getChildByTag( CVindictivePanelView.TAG_ICON)
                    break
                end
        end
    elseif eventType == "TouchesMoved" then
        if self.touchID == nil then
            return
        end
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at(i - 1)
            if touch:getID() == self.touchID and self.touchLanId == obj :getTag() then
                local touchPoint = touch :getLocation()
                --add:原斗气图标扣出，移动斗气图标位于鼠标中心，
                if self.m_nodeccbi ~= nil then
                    self.m_nodeccbi :setPosition( touchPoint)
                end
                print("yidong, "..obj :getTag().."X："..touchPoint.x.."Y："..touchPoint.y)
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
            return
        end
        self.m_detectIndex = self.m_detectIndex + 1
        self.m_detectFlag  = true
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if touch:getID() == self.touchID and self.touchLanId ~= obj :getTag() then
                print("CCCC Name",obj:getControlName())
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print("END obj:",obj :getTag())
                    local vindictinenode  = self :getVindictiveByLanid( self.touchLanId)
                    local endvindictine   = self :getVindictiveByLanid( obj :getTag())
                    if vindictinenode ~= nil then
                        if endvindictine ~= nil then --吞噬
                            local function fun1()--确认吞噬
                                self :playSound( "inventory_items")
                                self :REQ_SYS_DOUQI_ASK_USE_DOUQI( 0, vindictinenode.dq_id,self.touchLanId, obj :getTag())
                                if self.m_nodeccbi ~= nil then
                                    self.m_nodeccbi : removeFromParentAndCleanup(true)
                                    self.m_nodeccbi = nil
                                    self.touchID    = nil
                                    self.touchLanId = nil
                                    self.touchTime  = nil
                                end
                            end
                            local function fun2()--取消吞噬
                                if self.m_nodeccbi ~= nil then
                                    --锁住屏幕
                                    CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                                    local function movedCallBack()
                                        local dq_container = self.m_vindictiveButton[ self.touchLanId ]
                                        self.m_nodeccbi:retain()
                                        self.m_scenelayer:removeChild( self.m_nodeccbi , false )
                                        --self.m_nodeccbi : removeFromParentAndCleanup(true)
                                        dq_container : addChild( self.m_nodeccbi,3)
                                        self.m_nodeccbi : setPosition( ccp(0,0))
                                        self.m_nodeccbi:release()
                                        print("eeeeeee:", self.touchLanId, self.m_startposition.x, self.m_startposition.y)
                                        local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                                        if isdis == false then
                                            print("XXXXXXXXXXX")
                                            CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                                        end
                                        self.m_nodeccbi = nil
                                        self.touchID    = nil
                                        self.touchLanId = nil
                                        self.touchTime  = nil
                                    end
                                    local arr2 = CCArray:create()
                                    arr2:addObject(CCMoveTo:create( 0.5, self.m_startposition))
                                    arr2:addObject(CCCallFunc:create(movedCallBack))                                
                                    self.m_nodeccbi :runAction( CCSequence:create(arr2) )
                                end
                            end
                            local function fun3()--取消
                            end
                            if self : getIsSwallow( vindictinenode, endvindictine) == true then
                                require "view/ErrorBox/ErrorBox"
                                local ErrorBox = CErrorBox()
                                local BoxLayer = ErrorBox : create( nil,fun1,fun2,true) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                for k,v in pairs( self :getFormatString( vindictinenode, endvindictine)) do
                                    print(k,v.string,v.color)
                                    ErrorBox :addString( v.string, v.color)
                                end
                                local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                nowScene : addChild(BoxLayer,1000)
                                self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT
                            else
                                require "view/ErrorBox/ErrorBox"
                                local ErrorBox = CErrorBox()
                                local BoxLayer = ErrorBox : create( "斗气已达最高等级，不能吞噬其他斗气！",fun2,nil) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                nowScene : addChild(BoxLayer,1000)
                                self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT
                            end                            
                        else --移动
                            self :playSound( "inventory_items")
                            self :REQ_SYS_DOUQI_ASK_USE_DOUQI( 0, vindictinenode.dq_id,self.touchLanId, obj :getTag())
                            self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT
                            if self.m_nodeccbi ~= nil then
                                self.m_scenelayer:removeChild( self.m_nodeccbi )
                                self.m_nodeccbi = nil
                            end
                        end
                    end
                    break
                end
            end
        end
        for i=1, touchesCount do
            local touch = touches :at(i - 1)
            if touch:getID() == self.touchID and self.touchLanId == obj :getTag() then
                local touchPoint = touch :getLocation()
                if ccpDistance( touchPoint, touch :getStartLocation()) < 10 then
                    print("dianji"..obj :getTag())
                    --add:弹出斗气Tips
                    local vindictinenode = self :getVindictiveByLanid( obj :getTag())
                    if  vindictinenode ~= nil then
                        print("===================================")
                        if self.m_nodeccbi ~= nil then
                            self.m_detectFlag = false
                            local lan_id = self.touchLanId
                            --锁住屏幕
                            CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                            local function movedCallBack()
                                --self.m_nodeccbi:
                                local dq_container = self.m_vindictiveButton[ lan_id ]
                                self.m_nodeccbi:retain()
                                self.m_nodeccbi : removeFromParentAndCleanup(false)
                                dq_container:addChild(self.m_nodeccbi,3)
                                self.m_nodeccbi : setPosition( ccp(0,0))
                                self.m_nodeccbi:release()
                                self.m_nodeccbi = nil
                                print("eeeeeee", lan_id)
                                local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                                if isdis == false then
                                    CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                                end
                            end
                            local arr = CCArray:create()
                            arr:addObject(CCMoveTo:create( 0, self.m_startposition))
                            arr:addObject(CCCallFunc:create(movedCallBack))
                            self.m_nodeccbi :runAction( CCSequence:create(arr) )
                        end

                        local _position = {}
                        _position.x = touchPoint.x
                        _position.y = touchPoint.y
                        local  temp =   _G.g_VindictivePopupView :create( vindictinenode, _G.Constant.CONST_DOUQI_STORAGE_TYPE_TEMP, _position)
                        self.m_scenelayer :addChild( temp)
                    end
                    self.touchID    = nil
                    self.touchLanId = nil
                    self.touchTime  = nil
                end
            end
        end
        print("yesyese",self.m_detectIndex)
        if self.m_detectIndex == CVindictivePanelView.PER_PAGE_COUNT - 1 and self.m_detectFlag == true then
            print("nonononononononononononononononono",self.m_detectIndex)
            if self.m_nodeccbi ~= nil then
                --锁住屏幕
                CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                local function movedCallBack()
                    --self.m_nodeccbi:
                    local dq_container = self.m_vindictiveButton[ self.touchLanId ]
                    self.m_nodeccbi:retain()
                    self.m_nodeccbi : removeFromParentAndCleanup(false)
                    dq_container:addChild(self.m_nodeccbi,3)
                    self.m_nodeccbi : setPosition( ccp(0,0))
                    self.m_nodeccbi:release()
                    print("eeeeeee", self.touchLanId)
                    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                    if isdis == false then
                        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                    end
                    self.m_nodeccbi = nil
                    self.touchID    = nil
                    self.touchLanId = nil
                    self.touchTime  = nil
                end
                local arr = CCArray:create()
                arr:addObject(CCMoveTo:create( 0.5, self.m_startposition))
                arr:addObject(CCCallFunc:create(movedCallBack))
                self.m_nodeccbi :runAction( CCSequence:create(arr) )
            end
        end
    end
end

function CVindictivePanelView.getDQPosByLanid( self, _lanid)
    if self.m_vindictiveButton[ _lanid] ~= nil and _lanid ~= nil then
        local tempSize = CCSizeMake( self.m_winSize.height/3*4, self.m_winSize.height)
        local _positionXX,_positionYY = self.m_vindictiveButton[ _lanid] : getPosition()
        local _position2 = self.m_scenelayer : convertToNodeSpaceAR( ccp(_positionXX+self.m_winSize.width/2-tempSize.width/2+30, _positionYY+505))
        return _position2
    end
    return ccp(0,0)
end

function CVindictivePanelView.getStartPos( self)
    local tempSize = CCSizeMake( self.m_winSize.height/3*4, self.m_winSize.height)
    local _positionX,_positionY = self.m_generalSavvyContainer[self.m_generaltype] :getPosition()--self.m_generaltype
    local _position = self.m_scenelayer : convertToNodeSpaceAR( ccp(_positionX+self.m_winSize.width/2-tempSize.width/2+50, _positionY+150))  --
    return _position
end

--BUTTON类型切换buttonCallBack
--单击回调
function CVindictivePanelView.clickCallBack(self,eventType, obj, x, y)
    --删除Tips
    _G.g_VindictivePopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CVindictivePanelView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                controller :unregisterMediator( self.m_mediator)
                CCDirector :sharedDirector() :popScene( )
                self : unloadResources()
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() >= CVindictivePanelView.TAG_GENERALSAVVY and obj :getTag() <= CVindictivePanelView.TAG_GENERALSAVVY+6 then
            print(" 普通领悟")
            self :playSound( "comprehend")
            self :REQ_SYS_DOUQI_ASK_START_GRASP( 1)
        elseif obj :getTag() == CVindictivePanelView.TAG_DIAMONDSAVVY then
            print(" 钻石领悟")
            if self.m_roleVipLv < _G.Constant.CONST_DOUQI_VIP_LIMIT then
                local function okCallBack(  )
                    CCLOG("确认")
                    --跳转到充值界面
                    local command = CPayCheckCommand( CPayCheckCommand.ASK )
                    controller :sendCommand( command )
                end
                local function cancelCallBack()--取消
                    CCLOG("取消")
                end
                require "view/ErrorBox/ErrorBox"
                local box = CErrorBox()
                local BoxLayer = box : create( "神级领悟需要vip ".._G.Constant.CONST_DOUQI_VIP_LIMIT..",是否现在去充值？", okCallBack,cancelCallBack )
                local scene = CCDirector : sharedDirector() : getRunningScene()
                scene:addChild( BoxLayer, 10000 )
            else                
                local function okCallBack(  )
                    CCLOG("确认")
                    self :playSound( "comprehend")
                    self :REQ_SYS_DOUQI_ASK_START_GRASP( 0 )
                end
                local function cancelCallBack()--取消
                    CCLOG("取消")
                end
                require "view/ErrorBox/ErrorBox"
                local box = CErrorBox()
                local BoxLayer = box : create( "钻石领悟需要消耗200钻石", okCallBack,cancelCallBack )
                local scene = CCDirector : sharedDirector() : getRunningScene()
                scene:addChild( BoxLayer, 10000 )
            end
        elseif obj :getTag() == CVindictivePanelView.TAG_ONEKEYSAVVY then
            print(" 一键领悟")
            self :playSound( "comprehend")
            self :REQ_SYS_DOUQI_ASK_START_GRASP( 2)
        elseif obj :getTag() == CVindictivePanelView.TAG_ONEKEYSWALLOW then
            print(" 一键吞噬")
            self :REQ_SYS_DOUQI_ASK_EAT( 0)
        elseif obj :getTag() == CVindictivePanelView.TAG_ONEKEYPICKUP then
            print(" 一键拾取")
            self :REQ_SYS_DOUQI_ASK_GET_DQ( 0)
        elseif obj :getTag() == CVindictivePanelView.TAG_CONVERTVINDICTIVE then
            print(" 兑换斗气")
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
            end
            local BoxLayer = ErrorBox : create("兑换斗气暂未开启！",func1)
            self.m_scenelayer: addChild(BoxLayer,1000)
        elseif obj :getTag() == CVindictivePanelView.TAG_EQUIPVINDICTIVE then
            print(" 装备斗气")
            self :enterRoleEquipVindictive()
        end
    end
end

--装备斗气
function CVindictivePanelView.enterRoleEquipVindictive( self)
    print( "斗气装备系统\n######################################")
    require "view/VindictivePanelLayer/VindictiveRoleView"
    _G.pVindictiveRoleEquipView = CVindictiveRoleEquipView()
    CCDirector :sharedDirector() :pushScene( _G.pVindictiveRoleEquipView :scene())
end

-----------------------------------------------------
--请求服务器
-----------------------------------------------------
--请求斗气界面
function CVindictivePanelView.REQ_SYS_DOUQI_ASK_GRASP_DOUQI( self)
    print("-- (手动) -- [48210]请求斗气界面 -- 斗气系统")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_GRASP_DOUQI"
    local msg = REQ_SYS_DOUQI_ASK_GRASP_DOUQI()
    _G.CNetwork :send( msg)
end

-- (手动) -- [48220]请求开始领悟 -- 斗气系统
function CVindictivePanelView.REQ_SYS_DOUQI_ASK_START_GRASP( self, _type)
    print("-- (手动) -- [48220]请求开始领悟 -- 斗气系统 ")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_START_GRASP"
    local msg = REQ_SYS_DOUQI_ASK_START_GRASP()
    -- {0 钻石| 1美金 |2美金一键领悟}
    msg :setType( _type)
    _G.CNetwork :send( msg)
end

--请求一键吞噬
function CVindictivePanelView.REQ_SYS_DOUQI_ASK_EAT( self, _type)
    print("-- (手动) -- [48280]请求一键吞噬 -- 斗气系统")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_EAT"
    local msg = REQ_SYS_DOUQI_ASK_EAT()
    msg :setType( _type) -- {仓库类型  0领悟仓库| 1装备仓库}
    _G.CNetwork :send( msg)
end

--请求一键拾取
function CVindictivePanelView.REQ_SYS_DOUQI_ASK_GET_DQ( self, _id)
    print("-- (手动) -- [48300]请求拾取斗气 -- 斗气系统 ")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_GET_DQ"
    local msg = REQ_SYS_DOUQI_ASK_GET_DQ()
    msg :setLanId( _id)  -- {0 一键拾取| ID 唯一ID}
    _G.CNetwork :send( msg)
end

--请求移动斗气位置
function CVindictivePanelView.REQ_SYS_DOUQI_ASK_USE_DOUQI( self, _roleid, _dqid, _startid, _endid)
    print("-- (手动) -- [48280]请求移动斗气位置 -- 斗气系统 ")
    print("StartId:".._startid.."EndId:".._endid.."StartDouQiId:".._dqid)
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_USE_DOUQI"
    local msg = REQ_SYS_DOUQI_ASK_USE_DOUQI()
    msg :setRoleId( _roleid)
    msg :setDqId( _dqid)
    msg :setLanidStart( _startid)
    msg :setLanidEnd( _endid)
    _G.CNetwork :send( msg)
end


function CVindictivePanelView.playSound( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end





--getColorByIndex












