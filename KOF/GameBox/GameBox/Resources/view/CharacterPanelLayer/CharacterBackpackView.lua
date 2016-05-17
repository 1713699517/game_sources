--[[
 --CCharacterBackpackView
 --角色道具道具神器主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"


CCharacterBackpackView = class(view, function( self)
    print("CCharacterBackpackView:角色信息主界面")
    self.m_curentPageCount   = 0
    self.m_backpacktype   = 1
    self.m_sellgoodslist  = {}
    self.m_sellgoodscount = 0

    self.CreateEffectsList = {} --存放创建ccbi的数据
end)
--Constant:
CCharacterBackpackView.TAG_SHOP             = 200
CCharacterBackpackView.TAG_SELL             = 201
CCharacterBackpackView.TAG_ROLE             = 202

CCharacterBackpackView.TAG_GOODS_LOCK       = 1111
CCharacterBackpackView.TAG_SMALLPOINT_START = 1100
CCharacterBackpackView.TAG_GOODS_START      = 1500

CCharacterBackpackView.GOODS_ICON           = 1000

CCharacterBackpackView.PER_PAGE_COUNT       = 16    --每页物品的个数
CCharacterBackpackView.MAX_GOODS_COUNT      = 100   --背包最大格数

CCharacterBackpackView.FONT_SIZE            = 25  --字体大小

--加载资源
function CCharacterBackpackView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    
end
--释放资源
function CCharacterBackpackView.unLoadResource( self)
end

--初始化数据成员
function CCharacterBackpackView.initParams( self)
    print("CCharacterBackpackView.initParams")
    --更新本地数据
    self.m_curgoodsnum       = _G.g_GameDataProxy :getGoodsCount()
    self.m_maxgoodsnum       = _G.g_GameDataProxy :getMaxCapacity()
    self.m_backpackgoodslist = _G.g_GameDataProxy :getBackpackList()
    self.m_equipmentlist     = _G.g_GameDataProxy :getEquipmentList()
    self.m_artifactlist      = _G.g_GameDataProxy :getArtifactList()
    self.m_gemstonelist      = _G.g_GameDataProxy :getGemstoneList()
    self.m_materiallist      = _G.g_GameDataProxy :getMaterialList()
    self.m_propslist         = _G.g_GameDataProxy :getPropsList()
    self.m_equipandexplist   = _G.g_GameDataProxy :getEquipAndExpList()

    for i,v in ipairs(self.m_equipandexplist) do
        print("æææææææææææææææææææææææææææ"..i)
    end

end
--释放成员
function CCharacterBackpackView.realeaseParams( self)
    --controller :unregisterMediator( self.mediator)--ByName( "CCharacterMediator")
    if self.m_scenelayer ~= nil then
        self : removeAllCCBI() --ccbi清除
        self.m_scenelayer :removeAllChildrenWithCleanup( true)  --removeFromParentAndCleanup
    end
end

--布局成员
function CCharacterBackpackView.layout( self)
    --640
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        print("640--角色信息主界面")
        --人物属性
        local backgroundSize               = CCSizeMake( winSize.height/3*4, winSize.height)
        local backpackbackgroundSize       = CCSizeMake( backgroundSize.width*0.48, winSize.height*0.7)
        local buttonSize                   = self.m_shopButton :getPreferredSize()
        self.m_characterpropsbackground :setPreferredSize( backpackbackgroundSize)      
        self.m_characterpropsbackground :setPosition( ccp( winSize.width/2, winSize.height*0.52+15)) -- +260 -32
        self.m_shopButton :setPosition( ccp( winSize.width/2, winSize.height*0.09+15)) ---buttonSize.width/2-30
        --self.m_sellButton :setPosition( ccp( winSize.width/2+buttonSize.width/2+30, winSize.height*0.09+15))
        self.m_roleButton :setPosition( ccp( winSize.width/2+buttonSize.width/2+30, winSize.height*0.09+15))
        self.m_goodsContainer :setPosition( ccp( winSize.width/2-backpackbackgroundSize.width/2+10, winSize.height*0.52-backpackbackgroundSize.height/2+25))
        
        self.m_characterPropsViewContainer :setPosition( ccp( backgroundSize.width/2-backpackbackgroundSize.width/2-15, 0))  -- -backgroundSize.width/2+equipupSize.width/2+15, 0
        --768
        elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")
        
    end
end

--主界面初始化
function CCharacterBackpackView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    
    --require "mediator/CharacterMediator"
    --self.mediator = CCharacterMediator(self)
    --controller :registerMediator(self.mediator)--先注册后发送 否则会报错
    
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CCharacterBackpackView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterBackpackView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CCharacterBackpackView.layer( self, _type, _partnerid, _uid)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local function touchesCallback(eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    self.m_backpacktype = _type
    self.m_uid          = _uid
    self.m_partnerid    = _partnerid
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterBackpackView self.m_scenelayer 107 ")
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( touchesCallback, "this is CCharacterBackpackView self.m_scenelayer touchesCallBack 110")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化界面
function CCharacterBackpackView.initView(self, layer)
    print("CCharacterBackpackView.initView")
    --角色道具主界面
    self.m_characterPropsViewContainer = CContainer :create()
    layer :addChild( self.m_characterPropsViewContainer)

    --背景图片
    self.m_characterpropsbackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    self.m_characterpropsbackground :setControlName("this is CCharacterBackpackView self.m_characterpropsbackground 124 ")
    self.m_characterPropsViewContainer :addChild( self.m_characterpropsbackground, -1)
    
    --背包容器总层
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer :setControlName("this is CCharacterBackpackView self.m_goodsContainer 160 ")
    self.m_characterPropsViewContainer :addChild( self.m_goodsContainer, 1)
    --显示所有道具
    self :showAllGoods( self :getShowList())
    --按纽相关
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end    
    self.m_shopButton       = self :createButton( "商店", "general_button_normal.png", CallBack, CCharacterBackpackView.TAG_SHOP, "self.m_shopButton")    --商店按钮 伙伴
    self.m_sellButton       = self :createButton( "出售", "general_button_normal.png", CallBack, CCharacterBackpackView.TAG_SELL, "self.m_sellButton")    --出售按钮 伙伴
    self.m_roleButton       = self :createButton( "角色", "general_button_normal.png", CallBack, CCharacterBackpackView.TAG_ROLE, "self.m_roleButton")    --角色按钮 返回角色面板

    self.m_characterPropsViewContainer :addChild( self.m_shopButton)
    self.m_characterPropsViewContainer :addChild( self.m_sellButton)
    self.m_characterPropsViewContainer :addChild( self.m_roleButton)

    if self.m_backpacktype == 1 then
        self.m_sellButton :setVisible( false)
        self.m_roleButton :setVisible( true)
    elseif self.m_backpacktype == 2 then
        self.m_sellButton :setVisible( false)
        self.m_roleButton :setVisible( false)
    elseif self.m_backpacktype == 3 then
        self.m_sellButton :setVisible( false)
        self.m_roleButton :setVisible( false)
    end
end

function CCharacterBackpackView.getShowList( self)
    local templist = nil
    if self.m_backpacktype == 1 then
        templist = self.m_propslist
    elseif self.m_backpacktype == 2 then
        templist = self.m_equipandexplist
    elseif self.m_backpacktype == 3 then 
        templist = self.m_artifactlist
    elseif self.m_backpacktype == 4 then
        templist = self.m_backpackgoodslist
    end
    -- templist = self.m_backpackgoodslist
    return templist
end

function CCharacterBackpackView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

--创建所有物品
function CCharacterBackpackView.showAllGoods(self, goods)
    print("CCharacterBackpackView.showAllGoods"..#goods)
    
    --清除容器中原有对象
    if self.m_goodsContainer ~= nil then
        self : removeAllCCBI() --ccbi清除
        self.m_goodsContainer :removeAllChildrenWithCleanup( true)
    end
    local function btnCallBack( eventType, obj, x, y )
        return self : clickCellCallBack(eventType, obj, x, y)
    end
    --更新背包中物品数量和最大值Lable
    --self.m_lableCount: setString( string.format("%d/%d",self.m_curgoodsnum,self.m_maxgoodsnum))
    
    local curtaggoods         = #goods
    local curTagallgoodscount = CCharacterBackpackView.MAX_GOODS_COUNT-self.m_curgoodsnum + curtaggoods
    local lockgoods           = CCharacterBackpackView.MAX_GOODS_COUNT-self.m_maxgoodsnum     --未开锁背包
    local curtagunlockgoods   = curTagallgoodscount-lockgoods
    print("aaaaaaaaaaaaaaa", curtaggoods,curtagunlockgoods,lockgoods,curTagallgoodscount) --0, 7, -10, -3
        
    local m_bgCell  = CCSizeMake(98,98)
    --local equipCell = CCSizeMake(88,88)
    local viewSize  = CCSizeMake( 98*4, 99*4)
    local goodscount = 0
    
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( curTagallgoodscount, CCharacterBackpackView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :setControlName("this is CCharacterBackpackView self.m_pScrollView 179 ")
    self.m_pScrollView : setTouchesPriority(1)
    self.m_pScrollView :registerControlScriptHandler( btnCallBack, "this is CCharacterBackpackView.showAllGoods  self.m_pScrollView  CallBack")
    self.m_goodsContainer :addChild( self.m_pScrollView )
    
    self.m_smallPoint = {}
    self.m_goodBtn = {}
    self.m_pageState = {}
    for k=1,self.m_pageCount do
        local pageContainer = CContainer :create()
        pageContainer :setControlName("this is CCharacterBackpackView pageContainer 186 ")
        self.m_pScrollView :addPage( pageContainer, true)
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-55)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setLineNodeSum( 4)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)
        --状态翻页按钮
        self.m_smallPoint[k] = {}
        self.m_smallPoint[k].redbutton   = self :createButton( "", "general_pages_pressing.png", btnCallBack, CCharacterBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]") 
        self.m_smallPoint[k].blackbutton = self :createButton( "", "general_pages_normal.png", btnCallBack, CCharacterBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]")      
        if k == 1 then
            print( "AAAAAAA")
            self.m_smallPoint[1].redbutton :setVisible( true)
            self.m_smallPoint[1].blackbutton :setVisible( false)  
        elseif k ~= 1 then
            print( "BBBBBBBB")
            self.m_smallPoint[k].redbutton :setVisible( false)
            self.m_smallPoint[k].blackbutton :setVisible( true)   
        end
        self.m_smallPoint[k].redbutton :setPosition(140+(k-1)*35,410)
        self.m_smallPoint[k].blackbutton :setPosition(140+(k-1)*35,410)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].redbutton,1)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].blackbutton,1)

        self.m_pageState[k] = self :createPageState()
        self.m_pageState[k] :setPosition(140+(k-1)*35,410)
        self.m_goodsContainer :addChild( self.m_pageState[k])
        
        local tempnum = CCharacterBackpackView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            goodscount = goodscount + 1 
            local goodItem = nil       
            if goodscount <= curtagunlockgoods then
                --装备图片
                if goodscount <= curtaggoods then
                    print( "createGoodItem1有物品的Button")
                    goodItem = self :createGoodItem( true, goods[goodscount])
                else
                    print( "createGoodItem没有物品已解锁")
                    goodItem = self :createGoodItem( true)
                end                  
            else
                print( "createGoodItem没有物品未解锁")
                goodItem = self :createGoodItem()
            end          
            layout :addChild( goodItem,1)                                            
        end
    end
    self.m_pScrollView :setPage( 0, false)
        
end

--创建按钮Button
function CCharacterBackpackView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CCharacterBackpackView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CCharacterBackpackView ".._controlname)
    m_button :setFontSize( CCharacterBackpackView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CCharacterBackpackView ".._controlname.."CallBack")
    return m_button
end

function CCharacterBackpackView.createPageState( self)
    local pagestatecontainer = CContainer :create()
    local _itembackground    = CSprite: createWithSpriteFrameName("general_pages_normal.png")
    pagestatecontainer :addChild( _itembackground)
    local _itemclick         = CSprite: createWithSpriteFrameName("general_pages_pressing.png")
    _itemclick :setTag( 1)
    pagestatecontainer :addChild( _itemclick)
    return pagestatecontainer
end

function CCharacterBackpackView.createGoodItem( self, _islock, _good) 
    local goodContainer = CContainer :create()
    local m_bgCell  = CCSizeMake(96,96)
    local equipCell = CCSizeMake(88,88)
    --装备外框图片            
    local _itembackground = CSprite :createWithSpriteFrameName("general_props_underframe.png")
    --_itembackground :setPreferredSize(m_bgCell)
    _itembackground :setPosition( -_itembackground: getContentSize().width/2, -_itembackground: getContentSize().height/2)
    goodContainer :addChild( _itembackground) 
    local _itemButton   = nil
    if _islock == nil then
        local function btnCallBack( eventType, obj, x, y )
            return self : clickCellCallBack(eventType, obj, x, y)
        end
        _itemButton = CButton :createWithSpriteFrameName("","general_the_props_close.png")
        _itemButton :setTag( CCharacterBackpackView.TAG_GOODS_LOCK)
        _itemButton :registerControlScriptHandler( btnCallBack, "this CCharacterBackpackView _itemButton CallBack 368")
    else
        print( "createGoodItem@@@@@@@2")
        _itemButton = CButton :createWithSpriteFrameName("","general_props_underframe.png")        
    end
    _itemButton :setControlName( "this CCharacterBackpackView _itemButton 271 ")
    --_itemButton :setPreferredSize(equipCell)
    goodContainer :addChild( _itemButton)
    if _good ~= nil then
        print( "createGoodItem@@@@@@@3")
        local goodnode        = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        local _itemGoodSprite = nil
        if goodnode : isEmpty() == true then
            _itemGoodSprite = CSprite: createWithSpriteFrameName("iconsprite.png")
        else
            _itemGoodSprite = CSprite: create( "Icon/i"..goodnode : getAttribute("icon")..".jpg")                
            if _G.g_CharacterPanelView ~= nil then
                _G.g_CharacterPanelView:insertCreateResStr( "Icon/i"..tostring(goodnode : getAttribute("icon"))..".jpg" )
            end
            if _G.g_CCharacterCheckPanelView ~= nil then 
                _G.g_CCharacterCheckPanelView:insertCreateResStr( "Icon/i"..tostring(goodnode : getAttribute("icon"))..".jpg" )
            end
        end
        _itemGoodSprite : setControlName( "this CCharacterBackpackView _itemGoodSprite 281 ")
        _itemGoodSprite :setTag(  CCharacterBackpackView.GOODS_ICON)
        goodContainer :addChild( _itemGoodSprite)
        local function touchesCallback(eventType, obj, touches)
            return self :viewTouchesCallback( eventType, obj, touches)
        end

        _itemButton :setFontSize(20)
        _itemButton :setTouchesMode( kCCTouchesAllAtOnce )
        _itemButton :setTouchesEnabled( true)
        _itemButton :setTag( _good.index)
        _itemButton :registerControlScriptHandler( touchesCallback, "this CCharacterBackpackView _itemButton CallBack 290")
        _itemButton :setText( tostring( _good.goods_id.."*".._good.index))
        --数量标签
        local _itemprice = CCLabelTTF :create( _good.goods_num,"Arial",15)
        _itemprice :setPosition( _itemButton: getContentSize().width/2-10, -_itemButton :getContentSize().height/2+10)
        goodContainer :addChild( _itemprice)


        --特效特效·
        local theType  = tonumber(goodnode : getAttribute("type"))
        if theType == 1 or theType == 2 then
            self : Create_effects_equip(goodContainer,goodnode : getAttribute("name_color"),_good.goods_id,_good.index)
        end


    end
    --装备外框图片            
    local _itemFarmeOutSprite = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
    --_itemFarmeOutSprite :setPreferredSize(m_bgCell)
    _itemFarmeOutSprite :setPosition( -_itemFarmeOutSprite: getContentSize().width/2, -_itemFarmeOutSprite: getContentSize().height/2)
    goodContainer :addChild( _itemFarmeOutSprite) 
    return goodContainer
end

--根据物品ID取得物品
function CCharacterBackpackView.getGoodsByIndex( self, _index)
    for k,v in pairs( self.m_backpackgoodslist) do
        if v.index == _index then
            return v
        end
    end
    return false
end
-----------------------------------------------------
--通过mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CCharacterBackpackView.setLocalList( self)
    self : removeAllCCBI() --ccbi清除
    print("CCharacterBackpackView.setLocalList")
    self :initParams()
    --显示所有道具
    self :showAllGoods( self :getShowList())
    self :layout()
    local k = 1
    while k <= self.m_pageCount do
        self.m_smallPoint[k].blackbutton :setVisible( true)
        k = k + 1
    end
    k = self.m_curentPageCount+1
    self.m_smallPoint[k].redbutton :setVisible( true)
    self.m_smallPoint[k].blackbutton :setVisible( false)
    self.m_pScrollView :setPage( self.m_curentPageCount , false)
end

function CCharacterBackpackView.setCancleSell( self, _index)

end
--使用伙伴经验丹成功
function CCharacterBackpackView.setUsePExpOK( self)
    local msg = "使用伙伴经验丹成功！"
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(msg)
    --BoxLayer : setPosition(-235,0)
    _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,100000)
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--多点触控
function CCharacterBackpackView.viewTouchesCallback(self, eventType, obj, touches)
    print("CCharacterBackpackView.viewTouchesCallback eventType",eventType, obj :getTag())
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        if obj :isVisibility() == false then
            return
        end
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print("XXXXXXXX",self.touchID,obj :getTag())
                    self.touchID     = touch :getID()
                    self.touchIndex  = obj :getTag()                    
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
            print("touch2:getID():",touch2:getID(),"")
            if touch2:getID() == self.touchID and self.touchIndex == obj :getTag() then
                --check distance
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    print("dianji")
                    if self.m_backpacktype == 4 then
                        print("ErrorBoxtgthh")
                    else
                        --非出售界面弹出Tips
                        local _position = {}
                        _position.x = touch2Point.x
                        _position.y = touch2Point.y
                        local  temp =   _G.g_PopupView :create( self :getGoodsByIndex( obj :getTag()), _G.Constant.CONST_GOODS_SITE_ROLEBACKPACK , _position, self.m_partnerid)
                        self.m_scenelayer :addChild( temp)
                    end
                    self.touchID   = nil
                    self.touchIndex = nil
                end
            end
        end
    end
end
--BUTTON类型切换buttonCallBack
--单击回调
function CCharacterBackpackView.clickCellCallBack(self,eventType, obj, x, y)
    print( "CCharacterBackpackView.clickCellCallBack",eventType, obj, x, y)
    --删除Tips
    _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then        
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = currentPage 
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            k = self.m_curentPageCount+1
            self.m_smallPoint[k].redbutton :setVisible( true)
            self.m_smallPoint[k].blackbutton :setVisible( false)
        end
    elseif eventType == "TouchEnded" then
        if obj :getTag() > CCharacterBackpackView.TAG_SMALLPOINT_START and obj :getTag() <= CCharacterBackpackView.TAG_SMALLPOINT_START + self.m_pageCount then
            --翻页状态点回调
            print("Clicked smollpoint!")
            print(obj: getTag())
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            k = obj :getTag()-CCharacterBackpackView.TAG_SMALLPOINT_START
            self.m_curentPageCount = k-1
            self.m_smallPoint[k].redbutton :setVisible( true)
            self.m_smallPoint[k].blackbutton :setVisible( false)
            self.m_pScrollView :setPage( self.m_curentPageCount , false)
        end
        if obj :getTag() == CCharacterBackpackView.TAG_SHOP then
            print( "进入商店")
            local isok,lv = self : isShopOpen()
            if isok == 1 then
                require "view/Shop/ShopLayer"
                CCDirector : sharedDirector () : pushScene(CCTransitionShrinkGrow:create(0.5,CShopLayer () :scene()))
                print("商店没问题，妥妥的")
            elseif isok == 0 then
                local msg = "商店开放等级为"..lv.."级","商店"
                require "view/ErrorBox/ErrorBox"
                local ErrorBox  = CErrorBox()
                local BoxLayer  = ErrorBox : create(msg)
                --BoxLayer : setPosition(-235,0)
                _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,100000)
            end

        elseif obj :getTag() == CCharacterBackpackView.TAG_SELL then
            print( "进入出售")
            _G.g_CharacterPanelView :closeAll()
            require "view/BackpackPanelLayer/BackpackPanelView"
            CCDirector :sharedDirector() :pushScene( _G.g_CBackpackPanelView :scene( true))
        elseif obj :getTag() == CCharacterBackpackView.TAG_GOODS_LOCK then
            print("锁住的背包")
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
                print(" VIP: 跳转到VIP")
                require "view/VipUI/VipUI"
                local vipUI = CVipUI()
                CCDirector :sharedDirector() :pushScene( vipUI:scene())
            end
            local function func2()
                print("取消")
            end
            local BoxLayer = ErrorBox : create("开启背包需要提升VIP等级，是否去提升？",func1,func2)
            _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,1000)
            --self.m_scenelayer : addChild(BoxLayer,1000)

        end
    end
end


function CCharacterBackpackView.isShopOpen(self) --判断商店开放
    local mainplay = _G.g_characterProperty :getMainPlay()
    local nPlayLv  = tonumber(mainplay : getLv())
    
    _G.Config:load("config/mall_class.xml")

    local GemNode  =  _G.Config.mall_classs : selectSingleNode("mall_class[@class_id="..tostring(1000).."]") --宝石节点
    local EquNode  =  _G.Config.mall_classs : selectSingleNode("mall_class[@class_id="..tostring(1010).."]") --装备节点
    local MatNode  =  _G.Config.mall_classs : selectSingleNode("mall_class[@class_id="..tostring(1020).."]") --材料节点
    local temp = 0 
    temp       = tonumber(GemNode : getAttribute("open_lv"))
    if tonumber(EquNode : getAttribute("open_lv")) <= temp then
        temp = tonumber(EquNode : getAttribute("open_lv"))
        if tonumber(MatNode : getAttribute("open_lv")) <= temp then
            temp = tonumber(MatNode : getAttribute("open_lv"))
        end
    else
        if tonumber(MatNode : getAttribute("open_lv")) <= temp then
            temp = tonumber(MatNode : getAttribute("open_lv"))
        end
    end
    
    if  nPlayLv < temp  then
        return 0,temp
    else
        return 1,temp
    end
end


function CCharacterBackpackView.Create_effects_equip ( self,obj,name_color,id,index) 
    print("CCharacterBackpackView.Create_effects_equip-------",self,obj,name_color,id,index)
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

        if obj ~= nil and index ~= nil  then

            self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..index],1000)

            self : setSaveCreateEffectCCBIList(index,id)
        end
    end
end

function CCharacterBackpackView.setSaveCreateEffectCCBIList ( self,index,id) 
    print("CCharacterBackpackView 存表----",index,id)
    local data = {}
    data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
    print("CCharacterBackpackView 村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CCharacterBackpackView.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CCharacterBackpackView.removeAllCCBI ( self) 
    print("CCharacterBackpackView 开始调用删除CCBI")
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
                    print("CCharacterBackpackView 删除了CCBI,其名为=========",index)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
end














