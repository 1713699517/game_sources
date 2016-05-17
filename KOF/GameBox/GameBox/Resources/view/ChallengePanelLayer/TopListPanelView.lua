--[[
 --CTopListPanelView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

CTopListPanelView = class(view, function( self)
    print("CTopListPanelView:角色信息主界面")
    self.m_athleticsButton       = nil   --竞技按钮
    self.m_fightingButton        = nil   --战力按钮
    self.m_rankingButton         = nil   --等级按钮
    self.m_honourButton          = nil   --荣誉按钮
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_toplistPageContainer= nil   --4个标签容器公用
    self.m_toplistPanelViewContainer  = nil  --人物面板的容器层
end)
--Constant:
CTopListPanelView.TAG_ATHLETICS    = 201  --竞技
CTopListPanelView.TAG_FIGHTING     = 202  --战力
CTopListPanelView.TAG_RANKING      = 203  --等级
CTopListPanelView.TAG_HONOUR       = 204  --荣誉
CTopListPanelView.TAG_CLOSED       = 205  --关闭

CTopListPanelView.TAG_EXAMINE      = 1500 --查看

CTopListPanelView.FONT_SIZE        = 20
CTopListPanelView.FONT_SIZE_BUTTON = 24

CTopListPanelView.ITEM_HEIGHT      = 800
CTopListPanelView.PER_PAGE_COUNT   = 6

CTopListPanelView.COLOR_YERROW     = ccc4( 255,255,0,255 )
CTopListPanelView.COLOR_BLUE       = ccc4( 0,180,255,255 )

CTopListPanelView.SIZE_MAIN        = CCSizeMake( 854,640 )
CTopListPanelView.SIZE_LIST        = CCSizeMake( 823,55 )

--加载资源
function CTopListPanelView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
end
--释放资源
function CTopListPanelView.unLoadResource( self)
end
--初始化数据成员
function CTopListPanelView.initParams( self, layer)
    print("CTopListPanelView.initParams")
    require "mediator/TopListPanelMediator"
    self.m_mediator = CTopListPanelMediator( self)       
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错

    --当前选中的排行类型
    self.m_touchType = _G.Constant.CONST_TOP_TYPE_ARENA
end
--释放成员
function CTopListPanelView.realeaseParams( self)
    if self.m_toplistPageContainer ~= nil then
        self.m_toplistPageContainer :removeAllChildrenWithCleanup( true)
    end
end

--布局成员
function CTopListPanelView.layout( self, winSize)

    local mainSize = CTopListPanelView.SIZE_MAIN
    self.m_background    :setPosition( ccp( winSize.width/2, winSize.height/2 ) )
    self.m_mainContainer :setPosition( ccp( winSize.width/2 - mainSize.width/2, 0 ) )

    local toplistpanelbackgroundfirst    = self.m_toplistPanelViewContainer :getChildByTag( 100)
    local toplistpanelbackgroundsecond   = self.m_toplistPanelViewContainer :getChildByTag( 101)
    local closeSize                      = self.m_closedButton: getPreferredSize()
    local tagbuttonSize                  = self.m_athleticsButton :getPreferredSize()       
    toplistpanelbackgroundfirst  :setPreferredSize( mainSize )
    toplistpanelbackgroundsecond :setPreferredSize( CCSizeMake( 825, 550 ))        
    toplistpanelbackgroundfirst  :setPosition( ccp( mainSize.width/2, mainSize.height/2))
    toplistpanelbackgroundsecond :setPosition( ccp( mainSize.width/2, 290 ))
    self.m_listTitleBg           :setPosition( ccp( mainSize.width/2, 538 ))

    --标签Button部分
    self.m_tagLayout :setPosition( 20, 597 )
    --页数/总页数
    self.m_pagecountBg    :setPosition( mainSize.width/2, 55)
    self.m_pagecountLabel :setPosition( mainSize.width/2, 55)
    --我的排名
    self.m_myRankingLabel :setPosition( 613, 55)
    self.m_closedButton: setPosition( ccp(mainSize.width-closeSize.width/2, mainSize.height-closeSize.height/2))
end


--主界面初始化
function CTopListPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self, self.m_touchType)
    --布局成员
    self.layout(self, winSize)  
end

function CTopListPanelView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CTopListPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CTopListPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CTopListPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CTopListPanelView.requestService ( self , _type)
    -- require "common/protocol/auto/REQ_ARENA_KILLER"
    -- local msg = REQ_ARENA_KILLER()
    -- _G.CNetwork :send( msg)
    
    require "common/protocol/auto/REQ_TOP_RANK"
    local msg = REQ_TOP_RANK()
    msg : setType( _type )
    _G.CNetwork :send( msg)
end


--创建按钮Button
function CTopListPanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CTopListPanelView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CTopListPanelView ".._controlname)
    m_button :setFontSize( CTopListPanelView.FONT_SIZE_BUTTON)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CTopListPanelView ".._controlname.."CallBack")
    return m_button
end

--创建排行榜内单项
function CTopListPanelView.createItem( self, _player)
    local function CallBack( eventType, obj, x, y)
        return self :chaKanCallBack( eventType, obj, x, y)
    end
    local mainSize = CTopListPanelView.SIZE_MAIN

    local itemContainer      = CContainer :create()
    local clan_name = _player.clan_name
    if clan_name == nil then
        clan_name = "无"
    end

    local _itemrankingLabel  = CCLabelTTF :create( _player.rank, "Arial", CTopListPanelView.FONT_SIZE)
    local _itemnameLabel     = CCLabelTTF :create( _player.name, "Arial", CTopListPanelView.FONT_SIZE)
    local _itembangpaiLabel  = CCLabelTTF :create( clan_name, "Arial", CTopListPanelView.FONT_SIZE)
    local _itemlvLabel       = CCLabelTTF :create( "LV.".._player.lv, "Arial", CTopListPanelView.FONT_SIZE)
    local _itemexamineButton = CButton :createWithSpriteFrameName( "查看", "general_smallbutton_click.png")

    itemContainer :setControlName( "this is CTopListPanelView.createItem itemContainer ")
    _itemexamineButton :setControlName( "this is CTopListPanelView.createItem _itemexamineButton")

    _itemexamineButton :setFontSize( CTopListPanelView.FONT_SIZE_BUTTON)
    _itemexamineButton :setTag( _player.uid )
    _itemexamineButton :registerControlScriptHandler( CallBack)

    _itemrankingLabel  :setPosition( ccp( mainSize.width*0.1, 0))
    _itemnameLabel     :setPosition( ccp( mainSize.width*0.26, 0))
    _itembangpaiLabel  :setPosition( ccp( mainSize.width*0.5, 0))
    _itemlvLabel       :setPosition( ccp( mainSize.width*0.72, 0))
    _itemexamineButton :setPosition( ccp( mainSize.width*0.9, 0))
    itemContainer      :setPosition( ccp( 0, mainSize.height/2))

    itemContainer :addChild( _itemrankingLabel,10)
    itemContainer :addChild( _itemnameLabel,10)
    itemContainer :addChild( _itembangpaiLabel,10)
    itemContainer :addChild( _itemlvLabel,10)
    itemContainer :addChild( _itemexamineButton,10)

    local isOther = false
    local _itemOtherLabel
    if self.m_touchType == _G.Constant.CONST_TOP_TYPE_POWER then --战力
        _itemOtherLabel  = CCLabelTTF :create( _player.power, "Arial", CTopListPanelView.FONT_SIZE)
        itemContainer :addChild( _itemOtherLabel,10)
        isOther = true
    elseif self.m_touchType == CTopListPanelView.TAG_HONOUR then --荣誉
        _itemOtherLabel  = CCLabelTTF :create( "99999", "Arial", CTopListPanelView.FONT_SIZE)
        itemContainer :addChild( _itemOtherLabel,10)
        isOther = true
    end

    if isOther then
         --重设位置
        _itemrankingLabel :setPosition( ccp( mainSize.width*0.08 , 0))
        _itemnameLabel    :setPosition( ccp( mainSize.width*0.22, 0))
        _itembangpaiLabel :setPosition( ccp( mainSize.width*0.42, 0))
        _itemlvLabel      :setPosition( ccp( mainSize.width*0.60, 0))
        _itemOtherLabel   :setPosition( ccp( mainSize.width*0.74, 0))
    end

    print("CTopListPanelView  ---- ",_player.name,_player.rank,_player.uid,_G.g_LoginInfoProxy :getUid())

    local color = _G.g_ColorManager:getRGBA(1)
    if tonumber( _player.rank ) == 1 then
        color = _G.g_ColorManager:getRGBA(5)
    elseif tonumber( _player.rank ) == 2 then
        color = _G.g_ColorManager:getRGBA(4)
    elseif tonumber( _player.rank ) == 3 then
        color = _G.g_ColorManager:getRGBA(3)
    end

    if tonumber(_player.uid) == tonumber(_G.g_LoginInfoProxy :getUid()) then
        --玩家自己
        if tonumber( _player.rank ) > 3 then
            color = _G.g_ColorManager:getRGBA(2)
        end

        _itemexamineButton :setVisible( false )
    end

    _itemrankingLabel :setColor( color )
    _itemnameLabel    :setColor( color )
    _itembangpaiLabel :setColor( color )
    _itemlvLabel      :setColor( color )

    if isOther then
        _itemOtherLabel :setColor( color )
    end

    return itemContainer
end

function CTopListPanelView.createTitle( self )

    if self.m_fieldContainer ~= nil then 
        self.m_fieldContainer : removeFromParentAndCleanup( true )
        self.m_fieldContainer = nil
    end

    self.m_fieldContainer     = CContainer :create()
    local _itemrankingLabel   = CCLabelTTF :create( "排名", "Arial", CTopListPanelView.FONT_SIZE)
    local _itemnameLabel      = CCLabelTTF :create( "角色名字", "Arial", CTopListPanelView.FONT_SIZE)
    local _itembangpaiLabel   = CCLabelTTF :create( "所在社团", "Arial", CTopListPanelView.FONT_SIZE)
    local _itemlvLabel        = CCLabelTTF :create( "等级", "Arial", CTopListPanelView.FONT_SIZE)
    local _itemoperatingLabel = CCLabelTTF :create( "操作", "Arial", CTopListPanelView.FONT_SIZE)

    _itemrankingLabel   : setColor( CTopListPanelView.COLOR_BLUE )
    _itemnameLabel      : setColor( CTopListPanelView.COLOR_BLUE )
    _itembangpaiLabel   : setColor( CTopListPanelView.COLOR_BLUE )
    _itemlvLabel        : setColor( CTopListPanelView.COLOR_BLUE )
    _itemoperatingLabel : setColor( CTopListPanelView.COLOR_BLUE )

    self.m_fieldContainer :addChild( _itemrankingLabel)
    self.m_fieldContainer :addChild( _itemnameLabel)
    self.m_fieldContainer :addChild( _itembangpaiLabel)
    self.m_fieldContainer :addChild( _itemlvLabel)
    self.m_fieldContainer :addChild( _itemoperatingLabel) 

    self.m_toplistPanelViewContainer :addChild( self.m_fieldContainer)

    local mainSize = CTopListPanelView.SIZE_MAIN

    --字段名部分
    self.m_fieldContainer :setPosition( ccp( 0, 0))
    _itemrankingLabel     :setPosition( ccp( mainSize.width*0.1, 538))
    _itemnameLabel        :setPosition( ccp( mainSize.width*0.26, 538))
    _itembangpaiLabel     :setPosition( ccp( mainSize.width*0.5, 538))
    _itemlvLabel        :setPosition( ccp( mainSize.width*0.72, 538))
    _itemoperatingLabel :setPosition( ccp( mainSize.width*0.9, 538))

    if self.m_touchType == _G.Constant.CONST_TOP_TYPE_POWER then --战力
        local _itemZhanLiLabel  = CCLabelTTF :create( "战斗力", "Arial", CTopListPanelView.FONT_SIZE)
        _itemZhanLiLabel        : setColor( CTopListPanelView.COLOR_BLUE )
        self.m_fieldContainer   :addChild( _itemZhanLiLabel,10)

        --重设位置
        _itemrankingLabel :setPosition( ccp( mainSize.width*0.08, 538))
        _itemnameLabel    :setPosition( ccp( mainSize.width*0.22, 538))
        _itembangpaiLabel :setPosition( ccp( mainSize.width*0.42, 538))
        _itemlvLabel      :setPosition( ccp( mainSize.width*0.60, 538))
        _itemZhanLiLabel  :setPosition( ccp( mainSize.width*0.74, 538))

    elseif self.m_touchType == CTopListPanelView.TAG_HONOUR then --荣誉
        local _itemRongYuLabel  = CCLabelTTF :create( "荣誉", "Arial", CTopListPanelView.FONT_SIZE)
        _itemRongYuLabel        : setColor( CTopListPanelView.COLOR_BLUE )
        self.m_fieldContainer   :addChild( _itemRongYuLabel,10)

        --重设位置
        _itemrankingLabel :setPosition( ccp( mainSize.width*0.08, 538))
        _itemnameLabel    :setPosition( ccp( mainSize.width*0.22, 538))
        _itembangpaiLabel :setPosition( ccp( mainSize.width*0.42, 538))
        _itemlvLabel      :setPosition( ccp( mainSize.width*0.60, 538))
        _itemRongYuLabel  :setPosition( ccp( mainSize.width*0.74, 538))
    end

end

function CTopListPanelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

--显示排行榜玩家
function CTopListPanelView.showAllRole( self)

    self :createTitle()

    local mainSize = CTopListPanelView.SIZE_MAIN
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_playercount, CTopListPanelView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    self.m_roleListContainer = CContainer :create()
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_roleListContainer :setPosition( ccp(  17, 95))
    self.m_fieldContainer :addChild( self.m_roleListContainer, 1)

    local m_bgCell  = CCSizeMake( mainSize.width*0.9, 69)
    local viewSize  = CCSizeMake( mainSize.width*0.96, 415)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView : setControlName("this is CTopListPanelView self.m_pScrollView 179 ")
    self.m_pScrollView : registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_roleListContainer :addChild( self.m_pScrollView )

    self.m_roleBtn = {}
    local rolecount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CTopListPanelView pageContainerList 186 ")
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width+10, 172)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 0 )
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        layout :setHorizontalDirection(true)
        
        local tempnum = CTopListPanelView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        self.m_roleBtn[k] = {}
        for i =1 , tempnum do
            rolecount = rolecount + 1
            local temprole = self :createItem( self.m_playerlist[rolecount])--
            local temoImgBg = CSprite    :createWithSpriteFrameName( "team_list_normal.png" , CCRectMake( 10,0,10,30 ) )
            temoImgBg :setPreferredSize( CCSizeMake(viewSize.width+40,m_bgCell.height) )
            temoImgBg :setPosition( ccp( viewSize.width/2+10,0 ) )
            temprole  :addChild( temoImgBg, 1 ,999)
            layout :addChild( temprole )
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
    self.m_curentPageCount = self.m_pageCount-1
    self.m_pagecountLabel :setString( "1/"..self.m_pageCount)
end

--初始化排行榜界面
function CTopListPanelView.initView(self, layer)
    print("CTopListPanelView.initView")

    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CTopListPanelView self.m_background 26 ")
    self.m_background : setPreferredSize( winSize )
    layer : addChild( self.m_background )

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CTopListPanelView self.m_mainContainer 104" )
    layer : addChild( self.m_mainContainer)

    --副本界面容器
    self.m_toplistPanelViewContainer = CContainer :create()
    self.m_toplistPanelViewContainer : setControlName("this is CTopListPanelView self.m_toplistPanelViewContainer 94 ")
    self.m_mainContainer :addChild( self.m_toplistPanelViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local toplistpanelbackgroundfirst   = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    local toplistpanelbackgroundsecond  = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    toplistpanelbackgroundfirst  : setControlName( "this CTopListPanelView toplistpanelbackgroundfirst 124 ")
    toplistpanelbackgroundsecond : setControlName( "this CTopListPanelView toplistpanelbackgroundsecond 125 ")
    --创建各种Button
    self.m_athleticsButton   = self :createButton( "竞技排行", "general_label_normal.png", CallBack, CTopListPanelView.TAG_ATHLETICS, "self.m_athleticsButton")  --领取奖励
    self.m_fightingButton    = self :createButton( "战力排行", "general_label_normal.png", CallBack, CTopListPanelView.TAG_FIGHTING, "self.m_fightingButton")    --抓苦工
    self.m_rankingButton     = self :createButton( "等级排行", "general_label_normal.png", CallBack, CTopListPanelView.TAG_RANKING, "self.m_rankingButton")      --竞技排行
    self.m_honourButton      = self :createButton( "荣誉排行", "general_label_normal.png", CallBack, CTopListPanelView.TAG_HONOUR, "self.m_honourButton")        --清除CD
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CTopListPanelView.TAG_CLOSED, "self.m_closedButton")                    --关闭X
    --标签Button布局
    self.m_tagLayout     = CHorizontalLayout :create()
    local cellButtonSize = self.m_athleticsButton :getContentSize()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setCellHorizontalSpace( 6 )
    self.m_tagLayout :setLineNodeSum(4)
    self.m_tagLayout :setCellSize( cellButtonSize)
    self.m_tagLayout :addChild( self.m_athleticsButton)
    self.m_tagLayout :addChild( self.m_fightingButton)
    -- self.m_tagLayout :addChild( self.m_rankingButton)
    self.m_tagLayout :addChild( self.m_honourButton)

    self.m_touchTypeImg = CSprite :createWithSpriteFrameName( "general_label_click.png")
    self.m_athleticsButton :addChild( self.m_touchTypeImg,1 )

    --功能为做,先隐藏掉
    -- self.m_rankingButton :setVisible( false )
    self.m_honourButton  :setVisible( false )

    self.m_listTitleBg = CSprite :createWithSpriteFrameName( "team_titlebar_underframe.png",CCRectMake( 10,0,10,59 ))
    self.m_listTitleBg : setPreferredSize( CTopListPanelView.SIZE_LIST )
    self.m_toplistPanelViewContainer :addChild( self.m_listTitleBg )

    --页数/总页数
    self.m_pagecountBg    = CSprite :createWithSpriteFrameName( "general_pagination_underframe.png")
    self.m_pagecountLabel = CCLabelTTF :create( "0/0", "Arial", CTopListPanelView.FONT_SIZE)
    --我的排名
    self.m_myRankingLabel = CCLabelTTF :create( "我的排名 : "..self.m_myinfo.ranking, "Arial", CTopListPanelView.FONT_SIZE)
    self.m_myRankingLabel :setAnchorPoint( ccp( 0, 0.5))
    self.m_myRankingLabel :setColor( CTopListPanelView.COLOR_YERROW )

    self.m_toplistPanelViewContainer :addChild( self.m_tagLayout)
    self.m_toplistPanelViewContainer :addChild( self.m_pagecountBg)
    self.m_toplistPanelViewContainer :addChild( self.m_pagecountLabel)
    self.m_toplistPanelViewContainer :addChild( self.m_myRankingLabel)
    self.m_toplistPanelViewContainer :addChild( toplistpanelbackgroundfirst, -1, 100)
    self.m_toplistPanelViewContainer :addChild( toplistpanelbackgroundsecond, -1, 101)
    self.m_toplistPanelViewContainer :addChild( self.m_closedButton, 2, CTopListPanelView.TAG_CLOSED)

    --字段名字Label
    self :createTitle()     
end



--更新本地list数据
function CTopListPanelView.setLocalList( self, _type, _playercount, _playerlist, _myRank)
    print("CTopListPanelView.setLocalList")

    if tonumber(_type) ~= self.m_touchType then
        return
    end

    self.m_playercount = _playercount
    self.m_playerlist  = _playerlist

    

    self :showAllRole()

    local rank = _myRank or 0
    if rank > 500 then 
        rank = "500名外"
    end
    self.m_myRankingLabel :setString( "我的排名 : "..rank )

end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CTopListPanelView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = self.m_pageCount-currentPage 
            self.m_pagecountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
        end
    elseif eventType == "TouchEnded" then
        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CTopListPanelView.TAG_CLOSED then
            --关闭
            print("关闭")
            if self ~= nil then
                --controller :unregisterMediatorByName( "CtoplistEquipInfoMediator")
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CTopListPanelView.TAG_EXAMINE then
            print(" 查看玩家信息")
            self :chuangListBg( obj )

        else
            self :chuangTypeButtonBg( obj )
            self.m_myRankingLabel :setString( "我的排名 : 0" )
            self.m_touchListImg = nil

            if obj :getTag() == CTopListPanelView.TAG_ATHLETICS then
                print(" 竞技排行界面")
                self.m_touchType = _G.Constant.CONST_TOP_TYPE_ARENA
                self :requestService( _G.Constant.CONST_TOP_TYPE_ARENA )
            elseif obj :getTag() == CTopListPanelView.TAG_FIGHTING then
                print(" 战力排行界面")
                self.m_touchType = _G.Constant.CONST_TOP_TYPE_POWER
                self :requestService( _G.Constant.CONST_TOP_TYPE_POWER )
            elseif obj :getTag() == CTopListPanelView.TAG_RANKING then
                print(" 等级排行界面")
                self.m_touchType = _G.Constant.CONST_TOP_TYPE_LV
                self :requestService( _G.Constant.CONST_TOP_TYPE_LV )
            elseif obj :getTag() == CTopListPanelView.TAG_HONOUR then
                print(" 荣誉排行界面")
            end
        end    
    end
end

function CTopListPanelView.chaKanCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then

            print(" 查看玩家信息")
            self :chuangListBg( obj )

            local roleUid = obj:getTag()

            --请求玩家身上装备 --本玩家
            print("请求玩家身上装备开始")
            local msg = REQ_GOODS_EQUIP_ASK()
            msg :setUid( roleUid )
            msg :setPartner( 0 )
            _G.CNetwork :send( msg )
            print("请求玩家身上装备结束")

            print("请求玩家属性开始:"..roleUid)
            local msg_role = REQ_ROLE_PROPERTY()
            msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
            msg_role: setUid( roleUid )
            msg_role: setType( 0 )
            _G.CNetwork : send( msg_role )
        end
    end
end

--选中角色 高亮
function CTopListPanelView.chuangListBg( self, _obj )
    -- if self.m_touchListImg ~= nil then
    --     self.m_touchListImg :setImageWithSpriteFrameName( "team_list_normal.png" , CCRectMake( 10,0,10,30 ) )
    --     self.m_touchListImg :setPreferredSize( CCSizeMake( 860, 69) )
    -- end
    -- local obj = _obj:getParent():getChildByTag(999)
    -- if obj ~= nil then
    --     obj :setImageWithSpriteFrameName( "team_list_click.png" , CCRectMake( 10,0,10,30 ) )
    --     obj :setPreferredSize( CCSizeMake( 860, 69) )
    --     self.m_touchListImg = obj
    -- end

    if self.m_touchListImg ~= nil then
        self.m_touchListImg : removeFromParentAndCleanup(true)
        self.m_touchListImg = nil
    end

    local obj = _obj:getParent():getChildByTag(999)
    if obj ~= nil then
        self.m_touchListImg = CSprite:createWithSpriteFrameName( "team_list_click.png" , CCRectMake( 10,0,10,30 ) )
        self.m_touchListImg : setPreferredSize( CCSizeMake( 860, 69) )
        obj : addChild( self.m_touchListImg, 10 )
    end
end

--当前选择的类型 高亮
function CTopListPanelView.chuangTypeButtonBg( self, _obj )
    if self.m_touchTypeImg ~= nil then 
        self.m_touchTypeImg : removeFromParentAndCleanup( true )
        self.m_touchTypeImg = nil
    end
    self.m_touchTypeImg = CSprite :createWithSpriteFrameName( "general_label_click.png")
    _obj : addChild( self.m_touchTypeImg,1 )
end



















