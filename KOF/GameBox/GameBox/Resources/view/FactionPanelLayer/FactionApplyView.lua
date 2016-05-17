--[[
 --CFactionApplyView
 --社团申请主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/FactionMediator"
require "view/FactionPanelLayer/FactionInfomationView"

CFactionApplyView = class(view, function( self)
    print("CFactionApplyView:社团申请主界面")
    self.m_createButton          = nil   --创建按钮
    self.m_applyButton           = nil   --申请按钮
    self.m_cancleButton          = nil   --取消按钮
    self.m_examineButton         = nil   --查看按钮
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_factionApplyViewContainer  = nil  --人物面板的容器层
    self.m_factionlist           = nil
end)
--Constant:
CFactionApplyView.TAG_CREATE       = 200  --创建
CFactionApplyView.TAG_APPLY        = 201  --申请
CFactionApplyView.TAG_CANCLE       = 202  --取消
CFactionApplyView.TAG_EXAMINE      = 203  --查看
CFactionApplyView.TAG_CLOSED       = 205  --关闭

CFactionApplyView.FONT_SIZE        = 23

CFactionApplyView.ITEM_HEIGHT      = 800
CFactionApplyView.PER_PAGE_COUNT   = 6

--加载资源
function CFactionApplyView.loadResource( self)

end
--释放资源
function CFactionApplyView.unLoadResource( self)
end
--初始化数据成员
function CFactionApplyView.initParams( self, layer)
    print("CFactionApplyView.initParams")
    require "mediator/FactionMediator"
    self.m_mediator = CFactionApplyMediator( self)       
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionApplyView.realeaseParams( self)
end

--布局成员
function CFactionApplyView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团申请主界面")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local background              = self.m_factionApplyViewContainer :getChildByTag( 102)
        local panelbackgroundfirst    = self.m_factionApplyViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_factionApplyViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton :getPreferredSize()
        local createButtonSize        = self.m_createButton :getPreferredSize()   

        background :setPreferredSize( CCSizeMake( winSize.width, winSize.height))    
        panelbackgroundfirst :setPreferredSize( backgroundSize)
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.75)) 

        background :setPosition( ccp( winSize.width/2, winSize.height/2))      
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2, winSize.height-closeButtonSize.height-backgroundSize.height*0.75/2-5))
        --字段名部分
        self.m_fieldContainer :setPosition( ccp( winSize.width/2, winSize.height-closeButtonSize.height-40))

        --标签Button部分
        --self.m_tagLayout :setPosition( 10, winSize.height-createButtonSize.height/2-10)
        --页数/总页数
        --self.m_pagecountLabel :setPosition( winSize.width/2, 30)
        --界面名称
        self.m_viewnameLabel :setPosition( winSize.width/2, winSize.height-createButtonSize.height/2-10)
        self.m_factionListContainer :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+20, 93))   
        self.m_createButton :setPosition( ccp( winSize.width*0.5, createButtonSize.height/2+20))
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团申请主界面")
        
    end
end

--主界面初始化
function CFactionApplyView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self)
    --布局成员
    self.layout(self, winSize)  
end

function CFactionApplyView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionApplyView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionApplyView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionApplyView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionApplyView.requestService ( self)
    -- (手动) -- [33010]请求社团面板 -- 社团
    print("--未创建社团时请求社团列表")
    require "common/protocol/auto/REQ_CLAN_ASL_CLANLIST"
    local msg = REQ_CLAN_ASL_CLANLIST()
    msg :setPage( 1)
    _G.CNetwork :send( msg)
end

--创建图片Sprite
function CFactionApplyView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionApplyView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionApplyView.createLabel( self, _string, _color)
    print("CFactionApplyView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionApplyView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--创建按钮Button
function CFactionApplyView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionApplyView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CFactionApplyView ".._controlname)
    m_button :setFontSize( CFactionApplyView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CFactionApplyView ".._controlname.."CallBack")
    return m_button
end



--初始化排行榜界面
function CFactionApplyView.initView(self, layer)
    print("CFactionApplyView.initView")
    --副本界面容器
    self.m_factionApplyViewContainer = CContainer :create()
    self.m_factionApplyViewContainer : setControlName("this is CFactionApplyView self.m_factionApplyViewContainer 94 ")
    layer :addChild( self.m_factionApplyViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local background             = self :createSprite( "peneral_background.jpg", "background")
    local panelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "panelbackgroundfirst")     --背景Img
    local panelbackgroundsecond  = self :createSprite( "general_second_underframe.png", "panelbackgroundsecond")   --背景二级Img

    --创建各种Button
    self.m_createButton      = self :createButton( "创建社团", "general_button_normal.png", CallBack, CFactionApplyView.TAG_CREATE, "self.m_createButton")   
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionApplyView.TAG_CLOSED, "self.m_closedButton")                    
    --标签Button布局
    self.m_tagLayout     = CHorizontalLayout :create()
    --local cellButtonSize = self.m_applyButton :getContentSize()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setCellHorizontalSpace( 10)
    self.m_tagLayout :setLineNodeSum(4)
    --self.m_tagLayout :setCellSize( cellButtonSize)
    --字段名字Label
    self.m_fieldContainer        = CContainer :create()
    self :createField()

    --页数/总页数
    --self.m_pagecountLabel = CCLabelTTF :create( "0/0", "Arial", CFactionApplyView.FONT_SIZE)
    --社团列表 界面标题
    self.m_viewnameLabel  = CCLabelTTF :create( "社团列表", "Arial", CFactionApplyView.FONT_SIZE)
    self.m_factionListContainer = CContainer :create()

    --self.m_factionApplyViewContainer :addChild( self.m_tagLayout)
    self.m_factionApplyViewContainer :addChild( self.m_fieldContainer)
    --self.m_factionApplyViewContainer :addChild( self.m_pagecountLabel)
    self.m_factionApplyViewContainer :addChild( self.m_viewnameLabel)
    self.m_factionApplyViewContainer :addChild( self.m_factionListContainer, 1)
    self.m_factionApplyViewContainer :addChild( background, -1, 102)
    self.m_factionApplyViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_factionApplyViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_factionApplyViewContainer :addChild( self.m_createButton)
    self.m_factionApplyViewContainer :addChild( self.m_closedButton, 2)

    --
    --self :setLocalList()         
end

function CFactionApplyView.createField( self)
    local _fieldcolor         = ccc3(90,152,225)
    local _itembackground     = self :createSprite( "team_titlebar_underframe.png", " createField _itembackground")
    local _itemrankingLabel   = self :createLabel( "排名", _fieldcolor)
    local _itemlvLabel        = self :createLabel( "等级", _fieldcolor)
    local _itemnameLabel      = self :createLabel( "社团名称", _fieldcolor)
    local _itemmemberLabel    = self :createLabel( "成员", _fieldcolor)
    local _itemoperatingLabel = self :createLabel( "操作", _fieldcolor)

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-30, winSize.height*0.75/7)
    _itembackground :setPreferredSize( backgroundSize)

    _itemrankingLabel :setPosition( ccp( -backgroundSize.width*0.43, 0))
    _itemlvLabel :setPosition( ccp( -backgroundSize.width*0.3, 0))
    _itemnameLabel :setPosition( ccp( -backgroundSize.width*0.05, 0))
    _itemmemberLabel :setPosition( ccp( backgroundSize.width*0.15, 0))        
    _itemoperatingLabel :setPosition( ccp( backgroundSize.width*0.35, 0))

    self.m_fieldContainer :addChild( _itembackground)
    _itembackground :addChild( _itemrankingLabel)
    _itembackground :addChild( _itemlvLabel)
    _itembackground :addChild( _itemnameLabel)
    _itembackground :addChild( _itemmemberLabel)    
    _itembackground :addChild( _itemoperatingLabel) 
end

function CFactionApplyView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--显示排行榜玩家
function CFactionApplyView.showAllFaction( self)
    if self.m_factionListContainer ~= nil then
        print("删除社团列表")
        self.m_factionListContainer :removeAllChildrenWithCleanup( true)
    end
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_factioncount, CFactionApplyView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    local winSize         = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize  = CCSizeMake( winSize.height/3*4, winSize.height)
    local m_bgCell        = CCSizeMake( backgroundSize.width-50,backgroundSize.height*0.75/7-1)
    local viewSize        = CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.75/7*6-5)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CFactionApplyView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_factionListContainer :addChild( self.m_pScrollView )

    self.m_roleBtn = {}
    local tempfactioncount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CFactionApplyView pageContainerList 186 ")       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width+10, 170)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 1)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionApplyView.PER_PAGE_COUNT
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
    --self.m_curentPageCount = self.m_pageCount-1
    --self.m_pagecountLabel :setString( "1/"..self.m_pageCount)
    print("========================================end")
end

function CFactionApplyView.getState( self, _clanid)
    local flag = false
    if self.m_applylist ~= nil then 
        for k,v in pairs( self.m_applylist) do
            if _clanid == v.value then
                print( "AAAAAAA")
                flag = true
            end
        end
    end
    return flag
end

function CFactionApplyView.getColorByRank( self, _rank)
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
function CFactionApplyView.createItem( self, _faction)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CFactionApplyView.createItem itemContainer :".._faction.clan_id)
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
        return self :clickExamineCallBack( eventType, obj, x, y)
    end
    local _itemexamineButton  = self :createButton( "查看", "general_smallbutton_normal.png", examineCallBack, _faction.clan_id, "self.m_examineButton") 
    --申请 
    local function applyCallBack( eventType, obj, x, y)
        return self :clickApplyCallBack( eventType, obj, x, y)
    end
    local _itemapplyButton    = self :createButton( "申请", "general_smallbutton_normal.png", applyCallBack, _faction.clan_id, "self.m_applyButton")
    --取消
    local function cancleCallBack( eventType, obj, x, y)
        return self :clickCancleCallBack( eventType, obj, x, y)
    end
    local _itemcancleButton   = self :createButton( "取消", "general_smallbutton_normal.png", cancleCallBack, _faction.clan_id, "self.m_cancleButton  ") 

    local flag  = self :getState( _faction.clan_id)
    if flag == false then
        _itemapplyButton :setVisible( true)
        _itemclickSprite :setVisible( false)
        _itemcancleButton :setVisible( false)
        _itemnormalSprite :setVisible( true)
    elseif flag == true then
        _itemapplyButton :setVisible( false)
        _itemclickSprite :setVisible( true)
        _itemcancleButton :setVisible( true)
        _itemnormalSprite :setVisible( false)
    end 

    _itemrankingLabel :setAnchorPoint( ccp( 0,0.5))
    --_itemnameLabel :setAnchorPoint( ccp( 0,0.5))
    --_itemmemberLabel :setAnchorPoint( ccp( 0,0.5))
    _itemlvLabel :setAnchorPoint( ccp( 0,0.5))

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-40, winSize.height*0.75/7-1)
    _itemnormalSprite :setPreferredSize( backgroundSize)
    _itemclickSprite :setPreferredSize( backgroundSize)

    _itemrankingLabel :setPosition( ccp( backgroundSize.width*0.05, 0))
    _itemlvLabel :setPosition( ccp( backgroundSize.width*0.2, 0))
    _itemnameLabel :setPosition( ccp( backgroundSize.width*0.45, 0))
    _itemmemberLabel :setPosition( ccp( backgroundSize.width*0.65, 0))
    _itemapplyButton :setPosition( ccp( backgroundSize.width*0.8, 0))   
    _itemcancleButton :setPosition( ccp( backgroundSize.width*0.8, 0))  
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
    itemContainer :addChild( _itemapplyButton)
    itemContainer :addChild( _itemcancleButton)
    itemContainer :addChild( _itemexamineButton)
    return itemContainer
end


--更新本地list数据
function CFactionApplyView.setLocalList( self, _factioncount, _factionlist)
    print("CFactionApplyView.setLocalList")
    self.m_factioncount = _factioncount
    self.m_factionlist  = _factionlist
    self :showAllFaction()
    self.m_curentPageCount = self.m_pageCount-1
    print("默认当前页: setLocalList"..self.m_curentPageCount)
end

function CFactionApplyView.setFactionList( self, _factioncount, _factionlist )
    print("CFactionApplyView.setFactionList")
    local function sortrank( _faction1, _faction2)
        if _faction1.clan_rank < _faction2.clan_rank then
            return true
        else
            return false
        end
    end
    self.m_factioncount = _factioncount
    self.m_factionlist  = _factionlist
    table.sort( self.m_factionlist, sortrank)
    self :showAllFaction()
    --self.m_pScrollView :setPage( self.m_curentPageCount)
    self.m_curentPageCount = self.m_pageCount-1
    self.m_pScrollView :setPage( self.m_curentPageCount, false)
    print("默认当前页: setFactionList"..self.m_curentPageCount)
end

function CFactionApplyView.setApplyList( self, _iscome, _applycount, _applylist)
    print("CFactionApplyView.setApplyList ".._iscome)
    self.m_iscome     = _iscome
    self.m_applycount = _applycount
    self.m_applylist  = _applylist
    self :showAllFaction()  
    if tonumber(self.m_iscome) == 1 then
        self.m_createButton :setTouchesEnabled( false)
    end
    self.m_curentPageCount = self.m_pageCount-1  
    self.m_pScrollView :setPage( self.m_curentPageCount, false)
    print("默认当前页: setApplyList"..self.m_curentPageCount)
end

function CFactionApplyView.setApplyOrCancle( self, _type, _clanid)
    -- {操作类型0取消| 1申请}
    print("CFactionApplyView.setApplyOrCancle")
    if _type == 0 then
        for k,v in pairs( self.m_applylist) do
            print(k,v)
            if v.value == _clanid then
                table.remove( self.m_applylist, k) 
            end
        end
    elseif _type == 1 then 
        table.insert( self.m_applylist, {value=_clanid})
    end
    self :showAllFaction()
    self.m_pScrollView :setPage( self.m_curentPageCount, false)
    print("默认当前页: setApplyOrCancle "..self.m_curentPageCount)
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
function CFactionApplyView.clickExamineCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 查看:",obj :getTag())
        require "view/FactionPanelLayer/FactionApplyCheckView"
        local pFactionApplyCheckView = CFactionApplyCheckView()
        CCDirector :sharedDirector() :pushScene( pFactionApplyCheckView :scene( obj :getTag()))
    end 
end

function CFactionApplyView.clickApplyCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 申请:",obj :getTag())
        require "common/protocol/auto/REQ_CLAN_ASK_CANCEL"
        local msg = REQ_CLAN_ASK_CANCEL()
        msg :setType( 1)
        msg :setClanId( obj :getTag())
        _G.CNetwork :send( msg)
    end 
end

function CFactionApplyView.clickCancleCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 取消:",obj :getTag())
        require "common/protocol/auto/REQ_CLAN_ASK_CANCEL"
        local msg = REQ_CLAN_ASK_CANCEL()
        msg :setType( 0)
        msg :setClanId( obj :getTag())
        _G.CNetwork :send( msg)
    end 
end
--单击回调
function CFactionApplyView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = currentPage 
            print( "XXXXXXXXGGG:",self.m_curentPageCount)
            --self.m_pagecountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
        end
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionApplyView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                --controller :unregisterMediatorByName( "CtoplistEquipInfoMediator")
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CFactionApplyView.TAG_CREATE then
            print(" 创建社团")
            require "view/FactionPanelLayer/FactionCreateView"
            local pCreateFactionView = CFactionCreateView()
            --CCDirector :sharedDirector() :pushScene( pCreateFactionView :scene())
            self.m_scenelayer :addChild( pCreateFactionView :layer())
        end    
    end
end
