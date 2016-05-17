--[[
 --CFactionCheckListView
 --社团列表主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "common/protocol/auto/REQ_CLAN_ASL_CLANLIST"

require "mediator/FactionMediator"
require "view/FactionPanelLayer/FactionInfomationView"

CFactionCheckListView = class(view, function( self)
    print("CFactionCheckListView:社团列表主界面")
    self.m_examineButton         = nil   --查看按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_factionApplyViewContainer  = nil  --人物面板的容器层
    self.m_m_applylist           = nil
end)
--Constant:
CFactionCheckListView.FONT_SIZE        = 23

CFactionCheckListView.ITEM_HEIGHT      = 800
CFactionCheckListView.PER_PAGE_COUNT   = 7

--加载资源
function CFactionCheckListView.loadResource( self)

end
--释放资源
function CFactionCheckListView.unLoadResource( self)
end
--初始化数据成员
function CFactionCheckListView.initParams( self, layer)
    print("CFactionCheckListView.initParams")
    require "mediator/FactionMediator"
    --self.m_mediator = CFactionApplyMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionCheckListView.realeaseParams( self)
end

--布局成员
function CFactionCheckListView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团列表主界面")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local closeButtonSize         = CCSizeMake( 200, 100) --self.m_createButton :getPreferredSize()       
        --字段名部分
        --字段名部分
        self.m_fieldContainer :setPosition( ccp( winSize.width/2, winSize.height-105))

        --页数/总页数
        --self.m_pagecountLabel :setPosition( winSize.width/2, 30)
        --界面名称
        self.m_factionListContainer :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+25, 20))   
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团列表主界面")
        
    end
end

--主界面初始化
function CFactionCheckListView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self, 1)
    --布局成员
    self.layout(self, winSize)  
end

function CFactionCheckListView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionCheckListView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionCheckListView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionCheckListView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionCheckListView.requestService ( self, _page)
   -- (手动) -- [33030]请求社团列表 -- 社团 
    local msg = REQ_CLAN_ASL_CLANLIST()
    msg :setPage( _page)  --第几页
    _G.CNetwork :send( msg)
end

function CFactionCheckListView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--创建按钮Button
function CFactionCheckListView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionCheckListView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionCheckListView ".._controlname)
    _itembutton :setFontSize( CFactionCheckListView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CFactionCheckListView ".._controlname.."CallBack")
    return _itembutton
end

--创建图片Sprite
function CFactionCheckListView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionCheckListView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionCheckListView.createLabel( self, _string, _color)
    print("CFactionCheckListView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionCheckListView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--初始化排行榜界面
function CFactionCheckListView.initView(self, layer)
    print("CFactionCheckListView.initView")
    --副本界面容器
    self.m_factionApplyViewContainer = CContainer :create()
    self.m_factionApplyViewContainer : setControlName("this is CFactionCheckListView self.m_factionApplyViewContainer 94 ")
    layer :addChild( self.m_factionApplyViewContainer)
                
    --字段名字Label
    self.m_fieldContainer        = CContainer :create()
    self :createField()
    --页数/总页数
    --self.m_pagecountLabel = CCLabelTTF :create( "0/0", "Arial", CFactionCheckListView.FONT_SIZE)
    self.m_factionListContainer = CContainer :create()

    self.m_factionApplyViewContainer :addChild( self.m_fieldContainer)
    --self.m_factionApplyViewContainer :addChild( self.m_pagecountLabel)
    self.m_factionApplyViewContainer :addChild( self.m_factionListContainer, 1)
    --
    --self :setLocalList()         
end

function CFactionCheckListView.createField( self)
    local _fieldcolor         = ccc3(90,152,225)
    local _itembackground     = self :createSprite( "team_titlebar_underframe.png", " createField _itembackground")
    local _itemrankingLabel   = self :createLabel( "排名", _fieldcolor)
    local _itemlvLabel        = self :createLabel( "等级", _fieldcolor)
    local _itemnameLabel      = self :createLabel( "社团名称", _fieldcolor)
    local _itemmemberLabel    = self :createLabel( "成员", _fieldcolor)
    local _itemoperatingLabel = self :createLabel( "操作", _fieldcolor)

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-30, winSize.height*0.87/8)
    _itembackground :setPreferredSize( backgroundSize)

    _itemrankingLabel :setPosition( ccp( -backgroundSize.width*0.43, 0))
    _itemlvLabel :setPosition( ccp( -backgroundSize.width*0.3, 0))
    _itemnameLabel :setPosition( ccp( -backgroundSize.width*0.05, 0))
    _itemmemberLabel :setPosition( ccp( backgroundSize.width*0.2, 0))        
    _itemoperatingLabel :setPosition( ccp( backgroundSize.width*0.4, 0))

    self.m_fieldContainer :addChild( _itembackground)
    _itembackground :addChild( _itemrankingLabel)
    _itembackground :addChild( _itemlvLabel)
    _itembackground :addChild( _itemnameLabel)
    _itembackground :addChild( _itemmemberLabel)    
    _itembackground :addChild( _itemoperatingLabel) 
end


--显示排行榜玩家
function CFactionCheckListView.showAllFaction( self)
    if m_factionListContainer ~= nil then
        m_factionListContainer :removeAllChildrenWithCleanup( true)
    end
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_factioncount, CFactionCheckListView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    local winSize         = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize  = CCSizeMake( winSize.height/3*4, winSize.height)
    local m_bgCell        = CCSizeMake( backgroundSize.width-50,(backgroundSize.height*0.87-10)/8)
    local viewSize        = CCSizeMake( backgroundSize.width-30, (backgroundSize.height*0.87-10)/8*7)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CFactionCheckListView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_factionListContainer :addChild( self.m_pScrollView )

    self.m_roleBtn = {}
    local tempfactioncount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CFactionCheckListView pageContainerList 187 ")       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width, viewSize.height/2-30)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        --layout :setCellVerticalSpace( 1)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionCheckListView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        self.m_roleBtn[k] = {}
        for i =1 , tempnum do
            tempfactioncount = tempfactioncount + 1
            local temprole = self :createItem( self.m_factionlist[tempfactioncount])
            layout :addChild( temprole)
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
    self.m_curentPageCount = self.m_pageCount-1
    --self.m_pagecountLabel :setString( "1/"..self.m_pageCount)
end

function CFactionCheckListView.getColorByRank( self, _rank)
    local _color = _G.g_ColorManager :getRGB( _G.Constant.CONST_COLOR_WHITE)--白色
    _rank = tonumber( _rank) or 0
    if _rank == 3 then
        _color = _G.g_ColorManager :getRGB( _G.Constant.CONST_COLOR_BLUE)--金色
    elseif _rank == 2 then
        _color = _G.g_ColorManager :getRGB( _G.Constant.CONST_COLOR_VIOLET)--紫色
    elseif _rank == 1 then
        _color = _G.g_ColorManager :getRGB( _G.Constant.CONST_COLOR_GOLD)--蓝色
    end
    return _color
end

--创建社团列表单项
function CFactionCheckListView.createItem( self, _faction)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CFactionCheckListView.createItem itemContainer :".._faction.clan_id)
    if _faction.clan_name == nil then
        _faction.clan_name = "社团名为空"
    end
    local _itemColor = self : getColorByRank( _faction.clan_rank)
    local _itemrankingLabel  = self :createLabel( _faction.clan_rank, _itemColor)
    local _itemlvLabel       = self :createLabel( _faction.clan_lv, _itemColor)
    local _itemnameLabel     = self :createLabel( _faction.clan_name, _itemColor)
    local _itemmemberLabel   = self :createLabel( _faction.clan_members.."/".._faction.clan_all_members, _itemColor)
    local _itemnormalSprite  = self :createSprite( "team_list_normal.png", " createItem _itemnormalSprite:".._faction.clan_id)
    local _itemclickSprite   = self :createSprite( "team_list_click.png", " createItem _itemclickSprite".._faction.clan_id)
    --创建各种Button
    --查看
    local function examineCallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local _itemexamineButton  = self :createButton( "查看", "general_smallbutton_normal.png", examineCallBack, _faction.clan_id, "self.m_examineButton") 

    local flag  = false
    if flag == false then
        _itemclickSprite :setVisible( false)
        _itemnormalSprite :setVisible( true)
    elseif flag == true then
        _itemclickSprite :setVisible( true)
        _itemnormalSprite :setVisible( false)
    end 

    _itemrankingLabel :setAnchorPoint( ccp( 0,0.5))
    _itemlvLabel :setAnchorPoint( ccp( 0,0.5))

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-40, (winSize.height*0.87-10)/8)
    _itemnormalSprite :setPreferredSize( backgroundSize)
    _itemclickSprite :setPreferredSize( backgroundSize)

    _itemrankingLabel :setPosition( ccp( backgroundSize.width*0.05, 0))
    _itemlvLabel :setPosition( ccp( backgroundSize.width*0.2, 0))
    _itemnameLabel :setPosition( ccp( backgroundSize.width*0.45, 0))
    _itemmemberLabel :setPosition( ccp( backgroundSize.width*0.7+10, 0))
    _itemexamineButton :setPosition( ccp( backgroundSize.width*0.92, 0))
    _itemnormalSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    _itemclickSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    itemContainer :setPosition( ccp( 0, backgroundSize.height/2))

    itemContainer :addChild( _itemnormalSprite)
    itemContainer :addChild( _itemclickSprite)
    itemContainer :addChild( _itemrankingLabel)
    itemContainer :addChild( _itemnameLabel)
    itemContainer :addChild( _itemmemberLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemexamineButton)
    return itemContainer
end





function CFactionCheckListView.sortRank( self, _factionlist)
    local function sortrank( _faction1, _faction2)
        if _faction1.clan_rank < _faction2.clan_rank then
            return true
        else
            return false
        end
    end
    table.sort( _factionlist, sortrank )
    -- body
end
--更新本地list数据
function CFactionCheckListView.setLocalList( self, _factioncount, _factionlist)
    print("CFactionCheckListView.setLocalList")
    self.m_factioncount = _factioncount
    self.m_factionlist  = _factionlist
    self :sortRank( self.m_factionlist)
    self :showAllFaction()
end

function CFactionCheckListView.setFactionList( self, _factioncount, _factionlist )
    print("CFactionCheckListView.setFactionList")
    self.m_factioncount = _factioncount
    self.m_factionlist  = _factionlist
    self :sortRank( self.m_factionlist)
    self :showAllFaction()
end

function CFactionCheckListView.setApplyList( self, _applycount, _applylist)
    print("CFactionCheckListView.setApplyList")  
end

function CFactionCheckListView.setApplyOrCancle( self, _type, _clanid)
    print("-- {操作类型0取消| 1申请}XXXXXXX")
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionCheckListView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = self.m_pageCount-currentPage 
            --self.m_pagecountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
        end
    elseif eventType == "TouchEnded" then
        print(" 查看:",obj: getTag())
--[[
        require "controller/FactionCommand"
        local command = CFactionInfoCommand( self.theFaction.clan_id)
        controller :sendCommand( command)
]]
        if self.m_factionApplyViewContainer ~= nil then
            self.m_factionApplyViewContainer :removeAllChildrenWithCleanup( true)
        end
        local tempinfoview          = CFactionInfomationView()     
        self.m_mediator             = CFactionInfomationMediator( tempinfoview)
        controller :registerMediator( self.m_mediator)
        self.m_factionApplyViewContainer :addChild( tempinfoview :layer( obj: getTag()))
    end
end





















