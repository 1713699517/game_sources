--*********************************
--2013-9-12 by 陈元杰
--游戏攻略界面-CStrategyView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/ActivitiesMediator"

CStrategyView = class(view, function(self)

end)

--************************
--常量定义
--************************
-- button的Tag值
CStrategyView.TAG_CLOSE           = 201

CStrategyView.ONE_HEIGHT  = 128

-- ccColor4B 常量
CStrategyView.RED   = ccc4(255,0,0,255)
CStrategyView.GOLD  = ccc4(255,255,0,255)
CStrategyView.GREEN = ccc4(120,222,66,255)

CStrategyView.FONT_SIZE = 20


function CStrategyView.initView( self, _mainSize )

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CStrategyView self.m_mainContainer 39 ")
    self.m_scenceLayer   : addChild( self.m_mainContainer )

    self.m_mainBackground = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBackground : setControlName( "this CStrategyView self.m_mainBackground 39 ")
	self.m_mainBackground : setPreferredSize( _winSize )
	self.m_mainContainer  : addChild( self.m_mainBackground )

	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CStrategyView self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer  : addChild( self.m_background )


	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	  = self:createButton("", "general_close_normal.png",CStrategyView.TAG_CLOSE,24,local_closeBtnCallback,"self.m_closeBtn")
    self.m_mainContainer :addChild( self.m_closeBtn )


    ----------------------------
    --主界面
    ----------------------------
    self.m_leftBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_leftBg : setControlName( "this CStrategyView self.m_leftBg 39 ")
	self.m_leftBg : setPreferredSize( CCSizeMake( 260,554 ) )

	self.m_rightBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_rightBg : setControlName( "this CStrategyView self.m_rightBg 39 ")
	self.m_rightBg : setPreferredSize( CCSizeMake( 560,554 ) )

	self.m_mainContainer  : addChild( self.m_leftBg )
	self.m_mainContainer  : addChild( self.m_rightBg )

    --标题
    self.m_titleImg = CSprite :create("ActivitiesResources/gospel_word_yxgl.png")
    self.m_titleImg : setControlName( "this CStrategyView self.m_titleImg 39 ")

    self.m_mainContainer  : addChild( self.m_titleImg )

	self:loadMainView()
    
end


function CStrategyView.loadResources(self)
	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("ActivitiesResources/ActivitiesResources.plist")

    --加载xml资源
    self :loadXml()
end

function CStrategyView.unloadResources( self )
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ActivitiesResources/ActivitiesResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("ActivitiesResources/ActivitiesResources.pvr.ccz")

    local r = CCTextureCache :sharedTextureCache():textureForKey("ActivitiesResources/gospel_word_yxgl.png")
    if r ~= nil then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
        CCTextureCache :sharedTextureCache():removeTexture(r)
        r = nil
    end

    self :unloadXml()
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

    -- CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
end

function CStrategyView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBackground :setPosition(ccp( _mainSize.width/2 , _mainSize.height/2))
	self.m_mainContainer  :setPosition(ccp( _winSize.width/2 - _mainSize.width/2 , 0))

	----------------------------
	--活动背景
	----------------------------
	local backgroundSize = self.m_background : getPreferredSize()
	self.m_background    : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.5))

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(backgroundSize.width-closeBtnSize.width/2,backgroundSize.height-closeBtnSize.height/2)) 

	----------------------------
    --主界面
    ----------------------------
    local titleImgSize = self.m_titleImg:getPreferredSize()
    self.m_leftBg  : setPosition(ccp( 145 , 293 ))
    self.m_rightBg : setPosition(ccp( 560 , 293 ))
    self.m_titleImg: setPosition(ccp( _mainSize.width/2,_mainSize.height-titleImgSize.height/2-10 ))
end

--加载 tab
function CStrategyView.loadMainView( self )

    --重新排序
    local newData = _G.Config.strategy:selectSingleNode("strategys[0]"):children()
    local dataCount = newData:getCount("strategy")

    print("«««««««««««««««««««««««««««««««««««")
    for i=0,dataCount-1 do
        local strategy = newData:get(i,"strategy")
        print(i,strategy:getAttribute("id") ,strategy:getAttribute("type_name"))
    end
    print("«««««««««««««««««««««««««««««««««««")

	local function local_pageTabCallBack(eventType, obj, x, y)
       return self : pageTabCallBack(eventType,obj,x,y)
    end

    local pageCount = dataCount
    local _height   = 545-65*(pageCount)  -- 565-52*(pageCount+1) 
    local _width    = 145+215/2
    local tabPage   = {}
    local pageContainer = {}

    self.m_tab = CTab : create (eLD_Vertical, CCSizeMake(216, 65))--按钮间距
    self.m_tab : registerControlScriptHandler(local_pageTabCallBack)
    self.m_tab : setPosition(ccp(  _width, _height ))
    self.m_mainContainer : addChild (self.m_tab,100)

    local tabLayout = self.m_tab:getLayout()
    tabLayout:setLineNodeSum(1)
    tabLayout:setColumnNodeSum(8)
    
	for i=1,pageCount do

		local data = newData:get(i-1,"strategy")
        local id   = tonumber(data:getAttribute("type_id"))
		tabPage[i]  = CTabPage : createWithSpriteFrameName( data:getAttribute("type_name"),"events_page_normal.png",data:getAttribute("type_name"),"events_page_click.png")
		tabPage[i] : setControlName( "this CStrategyView tabPage[i] 39 ")
        tabPage[i] : setPreferredSize( CCSizeMake( 215,52 ) )
	    tabPage[i] : setTag ( id )
	    tabPage[i] : setFontSize(24)
	    tabPage[i] : registerControlScriptHandler(local_pageTabCallBack,"this CStrategyView tabPage[i] 39 ")

	    pageContainer[i] = self:createPageContainer( data )
        pageContainer[i] : setPosition( ccp( -_width, -_height ) )


        if i == 1 then
            self.m_nowPage = tonumber(id)
        end

	end

    for i=pageCount,1,-1 do
        self.m_tab : addTab( tabPage[i], pageContainer[i] )
    end

    self.m_tab : onTabChange( tabPage[1] )

    -- CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

end


--创建一个类型的  TabPage的Container
function CStrategyView.createPageContainer( self, _data )
	local container = CContainer :create()
    container : setControlName( "this CStrategyView container 39 ")

    local pos_Y     = 542
    local oneHeight = CStrategyView.ONE_HEIGHT
    local jianGeHei = 10
    local minCount  = 4
    local itemCount = 0

    local cellSize   = CCSizeMake( 542-10, oneHeight )
    local itemLayout = CHorizontalLayout:create()
	itemLayout : setCellSize( cellSize )
	itemLayout : setCellHorizontalSpace( 0 )
	itemLayout : setCellVerticalSpace( jianGeHei )
	itemLayout : setVerticalDirection( false)
    itemLayout : setHorizontalDirection( true)
	itemLayout : setLineNodeSum(1)
	itemLayout : setColumnNodeSum(20)
	
	local strategysList  = _data:children():get(0,"strategyss"):children()
    local strategysCount = strategysList:getCount("strategys")
	for i=0,strategysCount - 1 do
        local strategys = strategysList:get(i,"strategys")

        if tonumber(strategys:getAttribute("sub_id")) == 0 then
            break
        end

		local item = self:createItem( itemLayout, strategys, cellSize )

		if i == 0 then
			self:setHightLineSpr( item, tonumber( _data:getAttribute("type_id") ) )
		end

        itemCount = itemCount + 1
	end

    local container_Y = 0
    if itemCount > minCount then
        pos_Y = pos_Y + (itemCount - minCount)*(oneHeight + jianGeHei + 2)
        container_Y = - (itemCount - minCount)*(oneHeight + jianGeHei + 2)
    end


    print("createPageContainer   -> ",itemCount,pos_Y)


    local scrollViewContainer = CContainer :create()
    scrollViewContainer : setControlName( "this CStrategyView scrollViewContainer 39 ")
    scrollViewContainer : setPosition( ccp( 0, container_Y ) )

    local ScrollView     = CCScrollView :create()
    ScrollView : setPosition( ccp( 292,21 ) )
    ScrollView : setDirection(kCCScrollViewDirectionVertical)
    ScrollView : setContentOffset( CCPointMake( 0,-pos_Y ) )
    ScrollView : setContainer( scrollViewContainer )
    ScrollView : setViewSize( CCSizeMake( 542,542 ) )
    ScrollView : setContentSize(CCSizeMake( 542,pos_Y ))
    container  : addChild( ScrollView,100 )

    itemLayout : setPosition( 0,  pos_Y - oneHeight/2 )
    scrollViewContainer : addChild( itemLayout )


    return container
end

--创建一个 攻略项
function CStrategyView.createItem( self, _parent, _data, _cellSize )

	local function local_cellBgTouchCallback( eventType, obj, touches )
		return self : cellBgTouchCallback( eventType, obj, touches )
	end

	local function local_goOnBtnCallback( eventType, obj, x, y )
		return self : goOnBtnCallback( eventType, obj, x, y )
	end

	local cellBg = CButton :createWithSpriteFrameName("","general_underframe_normal.png")
    cellBg : setControlName( "this CArtifactShopView cellBg 217 ")
	cellBg : setPreferredSize( _cellSize )
	cellBg : setTouchesPriority(-1000)
	cellBg : setTag( tonumber( _data:getAttribute("sub_id") ) )
	cellBg : setTouchesMode( kCCTouchesAllAtOnce )
	cellBg : registerControlScriptHandler( local_cellBgTouchCallback, "this CArtifactShopView cellBg 227 ")
	_parent : addChild( cellBg )


	local cellIcon  = CSprite:createWithSpriteFrameName( _data:getAttribute("sub_pic")..".png" )

    local noticLabel = CCLabelTTF :create( "开启条件 : ".._data:getAttribute("terms"), "Arial", 20 )
    noticLabel : setAnchorPoint( ccp( 0,0.5 ) )
    noticLabel : setDimensions( CCSizeMake( 330, 0 ) )
    noticLabel : setHorizontalAlignment( kCCTextAlignmentLeft )

	local infoLabel = CCLabelTTF :create( _data:getAttribute("sub_dec"), "Arial", 20 )
	infoLabel : setAnchorPoint( ccp( 0,0.5 ) )
    infoLabel : setDimensions( CCSizeMake( 330, 0 ) )
	infoLabel : setHorizontalAlignment( kCCTextAlignmentLeft )

	local button = CButton :createWithSpriteFrameName( "前往", "general_smallbutton_click.png" )
	button    : registerControlScriptHandler( local_goOnBtnCallback, "this CArtifactShopView button 296 ")
	button    : setTag( tonumber( _data:getAttribute("open") ) )

    print("createItem---->".._data:getAttribute("enter"),"   open->".._data:getAttribute("open"))

    local openId = tonumber( _data:getAttribute("enter") )
    if openId ~= nil then
        if openId ~= 0 then
            local funOpen = self:isFunOpen( openId )
            if funOpen == false then
                button : setTouchesEnabled( false )

                noticLabel : setColor(ccc4(255,0,0,255))
            else
                noticLabel : setString("开启条件 : 已开启")
                noticLabel : setColor(ccc4(0,255,0,255))
            end
        else
            noticLabel : setString("开启条件 : 已开启")
            noticLabel : setColor(ccc4(0,255,0,255))
        end
    else
        button : setTouchesEnabled( false )
    end

	cellBg    : addChild( cellIcon , 10 )
    cellBg    : addChild( noticLabel, 10 )
	cellBg    : addChild( infoLabel, 10 )
	cellBg    : addChild( button   , 10 )

	local iconSize = cellIcon:getPreferredSize()
	local btnSize  = button:getPreferredSize()
	cellIcon  : setPosition( ccp( -_cellSize.width/2 + iconSize.width/2 + 10 , 0 ) )
    noticLabel : setPosition( ccp( -_cellSize.width/2 + iconSize.width + 20   , 30 ) )
	infoLabel : setPosition( ccp( -_cellSize.width/2 + iconSize.width + 20   , -15 ) )
	button    : setPosition( ccp( _cellSize.width/2 - btnSize.width/2 - 10   , 0 ) )

	return cellBg

end


function CStrategyView.createButton( self, _str, _imgName, _tag, _fontSize, _fun, _controlName )
    local button = CButton:createWithSpriteFrameName( _str,_imgName )
    button : setControlName( "this CStrategyView ".._controlName)
    button : setFontSize( _fontSize )
    if _fun ~= nil then
        button : registerControlScriptHandler( _fun, "this CStrategyView ".._controlName)
    end
    if _tag ~= nil then
        button : setTag( _tag )
    end
    return button
end

function CStrategyView.createIconButton( self, _str, _imgName, _tag, _fontSize, _fun, _controlName )

    table.insert(self.m_createResStr,_imgName)
    local button = CButton:create( _str,_imgName )
    button : setControlName( "this CStrategyView ".._controlName)
    button : setFontSize( _fontSize )
    if _fun ~= nil then
        button : registerControlScriptHandler( _fun, "this CStrategyView ".._controlName)
    end
    if _tag ~= nil then
        button : setTag( _tag )
    end
    return button
end

function CStrategyView.setHightLineSpr( self, _obj, _type )

    if _type == nil or _obj == nil then
        return
    end

    if self.hightLineSpr == nil then
        self.hightLineSpr = {}
    end

    if self.hightLineSpr[_type] ~= nil then 
        print("setHightLineSpr   remove !!!")
        self.hightLineSpr[_type] : removeFromParentAndCleanup( true )
        self.hightLineSpr[_type] = nil
    end
    self.hightLineSpr[_type] = CSprite:createWithSpriteFrameName( "general_underframe_click.png" )
    self.hightLineSpr[_type] : setControlName( "this is CStrategyView self.hightLineSpr[_type] 125")
    self.hightLineSpr[_type] : setPreferredSize( CCSizeMake( 542-10, CStrategyView.ONE_HEIGHT ) )
    _obj:addChild( self.hightLineSpr[_type], 2 , 999 )

end

--初始化数据成员
function CStrategyView.initParams( self)

    --功能开放列表
    self.m_openFunList = {}
    if _G.pCFunctionOpenProxy :getInited() then
        self.m_openFunList = _G.pCFunctionOpenProxy :getSysId()
    end

end

--释放成员
function CStrategyView.realeaseParams( self)
    --反注册mediator
    if _G.pCActivitiesMediator ~= nil then
        controller :unregisterMediator(_G.pCActivitiesMediator)
        _G.pCActivitiesMediator = nil
    end
end



function CStrategyView.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function CStrategyView.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenceLayer = CCScene:create()
	self:init( _mainSize, _data)
	return self.m_scenceLayer
end

function CStrategyView.isFunOpen( self, _funId )

    print( "isFunOpen--->".._funId )
    

    if _funId == _G.Constant.CONST_FUNC_OPEN_MAIL then 
        --普通副本
        return true
    end

    for i,v in ipairs(self.m_openFunList) do
        print("isFunOpen 11->",v.id,_funId)
        if tonumber(v.id) == tonumber(_funId) then 
            return true
        end
    end
    return false
end


--*****************
--xml管理
--*****************
--加载xml文件
function CStrategyView.loadXml( self )
    _G.Config :load( "config/strategy.xml")
end

function CStrategyView.unloadXml( self )
    _G.Config :unload( "config/strategy.xml")
end

function CStrategyView.closeView( self )
    self :realeaseParams()
    CCDirector:sharedDirector():popScene()
    self : unloadResources()
    self = nil
end



--************************
--按钮回调
--************************
--关闭 单击回调
function CStrategyView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			self:closeView()
		end
	end
end

--Page页面按钮回调
function CStrategyView.pageTabCallBack(self,eventType,obj,x,y)   
    if eventType == "TouchBegan" then
        -- _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        self.m_nowPage = pageTag
        print("更换界面了 tag="..pageTag)
    end
end


--前往按钮回调
function CStrategyView.goOnBtnCallback(self,eventType,obj,x,y)  
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("前往-----> "..obj:getTag())
        local tag = obj:getTag()

        self:closeView()
        _G.g_CFunOpenManager:openActivityById( tag )

    end
end


--背景 单击回调
function CStrategyView.cellBgTouchCallback(self, eventType, obj, touches)
	if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.index       = obj   :getTag()
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
            if touch2:getID() == self.touchID and self.index == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                	
                	print( "点击背景   -----   高亮!!! ",obj:getTag() )
                	self:setHightLineSpr( obj,self.m_nowPage )

                    self.touchID = nil
                    self.index   = nil
                end
            end
        end
        print( eventType,"END")
    end
end



function CStrategyView.createMessageBox( self, _msg ) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenceLayer : addChild(BoxLayer,1000)
end

