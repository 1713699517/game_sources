--[[
 --CFactionVerifyListView
 --社团同意主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

CFactionVerifyListView = class(view, function( self)
    print("CFactionVerifyListView:社团同意主界面")
    self.m_applyButton           = nil   --同意按钮
    self.m_cancleButton          = nil   --拒绝按钮
    self.m_examineButton         = nil   --查看按钮
    self.m_verifyListViewContainer  = nil  --人物面板的容器层
    self.m_m_applylist           = nil
    --self.m_verifylistbyuid       = {}
end)
--Constant:
CFactionVerifyListView.TAG_CLOSED       = 999
CFactionVerifyListView.TAG_BUTTON_START = 1000  --
CFactionVerifyListView.TAG_APPLY        = 1  --同意
CFactionVerifyListView.TAG_CANCLE       = 2  --拒绝
CFactionVerifyListView.TAG_EXAMINE      = 3  --查看

CFactionVerifyListView.FONT_SIZE        = 23

CFactionVerifyListView.ITEM_HEIGHT      = 800
CFactionVerifyListView.PER_PAGE_COUNT   = 7

--加载资源
function CFactionVerifyListView.loadResource( self)

end
--释放资源
function CFactionVerifyListView.unLoadResource( self)
end
--初始化数据成员
function CFactionVerifyListView.initParams( self, layer)
    print("CFactionVerifyListView.initParams")
    require "mediator/FactionMediator"
    --self.m_mediator = CFactionApplyMediator( self) 
    _G.g_CFactionVerifyListMediator = CFactionVerifyListMediator( self)      
    controller :registerMediator( _G.g_CFactionVerifyListMediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionVerifyListView.realeaseParams( self)
    --注销mediator
    controller :unregisterMediator( _G.g_CFactionVerifyListMediator)
    --释放资源
    self :unLoadResource()
    --移除界面
    if self.m_scenelayer ~= nil then
        self.m_scenelayer :removeFromParentAndCleanup( true)
        self.m_scenelayer = nil
    end
end
--布局成员
function CFactionVerifyListView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团同意主界面")
        --背景部分
        -- local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        -- local closeButtonSize         = CCSizeMake( 200, 100) --self.m_createButton :getPreferredSize()  
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst         = self.m_verifyListViewContainer :getChildByTag( 99)
        local panelbackgroundfirst    = self.m_verifyListViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_verifyListViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton: getPreferredSize() 

        panelbackgroundfirst :setPreferredSize( backgroundSize)
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87))        
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2, winSize.height*0.87/2+15))     
        --字段名部分
        self.m_fieldContainer :setPosition( ccp( winSize.width/2, winSize.height-105))
        --页数/总页数
        self.m_pagecountLabel :setPosition( winSize.width/2, 30)
        --界面名称
        self.m_roleListContainer :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+25, 20)) 
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团同意主界面")
        
    end
end

--主界面初始化
function CFactionVerifyListView.init(self, winSize, layer)
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

function CFactionVerifyListView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionVerifyListView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionVerifyListView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionVerifyListView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionVerifyListView.requestService ( self)
    -- (手动) -- [33070]请求入帮申请列表 -- 社团
    require "common/protocol/auto/REQ_CLAN_ASK_JOIN_LIST"
    local msg = REQ_CLAN_ASK_JOIN_LIST()
    _G.CNetwork :send( msg)
end


--创建按钮Button
function CFactionVerifyListView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionVerifyListView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CFactionVerifyListView ".._controlname)
    m_button :setFontSize( CFactionVerifyListView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CFactionVerifyListView ".._controlname.."CallBack")
    return m_button
end

--创建图片Sprite
function CFactionVerifyListView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionVerifyListView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionVerifyListView.createLabel( self, _string, _color)
    print("CFactionVerifyListView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionVerifyListView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--初始化排行榜界面
function CFactionVerifyListView.initView(self, layer)
    print("CFactionVerifyListView.initView")
    --副本界面容器
    self.m_verifyListViewContainer = CContainer :create()
    self.m_verifyListViewContainer : setControlName("this is CFactionVerifyListView self.m_verifyListViewContainer 94 ")
    layer :addChild( self.m_verifyListViewContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local backgroundfirst        = self :createSprite( "peneral_background.jpg", "backgroundfirst")
    local panelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "panelbackgroundfirst")
    local panelbackgroundsecond  = self :createSprite( "general_second_underframe.png", "panelbackgroundsecond")
    --创建各种Button
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionVerifyListView.TAG_CLOSED, "self.m_closedButton")    

    self.m_verifyListViewContainer :addChild( backgroundfirst, -1, 99)
    self.m_verifyListViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_verifyListViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_verifyListViewContainer :addChild( self.m_closedButton, 2)               
    --字段名字Label
    self.m_fieldContainer   = CContainer :create()
    self :createField()

    --页数/总页数
    self.m_pagecountLabel    = CCLabelTTF :create( "0/0", "Arial", CFactionVerifyListView.FONT_SIZE)
    --人员列表
    self.m_roleListContainer = CContainer :create()

    self.m_verifyListViewContainer :addChild( self.m_fieldContainer)
    self.m_verifyListViewContainer :addChild( self.m_pagecountLabel)
    self.m_verifyListViewContainer :addChild( self.m_roleListContainer, 1)
    --
    --self :setLocalList()         
end


function CFactionVerifyListView.createField( self)
    local _fieldcolor         = ccc3(90,152,225)
    local _itembackground     = self :createSprite( "team_titlebar_underframe.png", " createField _itembackground")
    local _itemrolenameLabel  = self :createLabel( "角色名字", _fieldcolor)
    local _itemlvLabel        = self :createLabel( "等级", _fieldcolor)
    local _itemproLabel       = self :createLabel( "职业", _fieldcolor)
    local _itemtimeLabel      = self :createLabel( "申请时间", _fieldcolor)
    local _itemoperatingLabel = self :createLabel( "操作", _fieldcolor)

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-30, winSize.height*0.87/8)
    _itembackground :setPreferredSize( backgroundSize)

    _itemrolenameLabel :setPosition( ccp( -backgroundSize.width*0.39, 0))
    _itemlvLabel :setPosition( ccp( -backgroundSize.width*0.23, 0))
    _itemproLabel :setPosition( ccp( -backgroundSize.width*0.1, 0))
    _itemtimeLabel :setPosition( ccp( backgroundSize.width*0.15, 0))        
    _itemoperatingLabel :setPosition( ccp( backgroundSize.width*0.36, 0))

    self.m_fieldContainer :addChild( _itembackground)
    _itembackground :addChild( _itemrolenameLabel)
    _itembackground :addChild( _itemlvLabel)
    _itembackground :addChild( _itemproLabel)
    _itembackground :addChild( _itemtimeLabel)    
    _itembackground :addChild( _itemoperatingLabel) 
end

function CFactionVerifyListView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

--显示排行榜玩家
function CFactionVerifyListView.showAllRole( self)
    if self.m_roleListContainer ~= nil then
        self.m_roleListContainer :removeAllChildrenWithCleanup( true)
        --self.m_verifylistbyuid       = {}
    end
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_verifycount, CFactionVerifyListView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    local winSize         = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize  = CCSizeMake( winSize.height/3*4, winSize.height)
    local m_bgCell        = CCSizeMake( backgroundSize.width-50,(backgroundSize.height*0.87-10)/8)
    local viewSize        = CCSizeMake( backgroundSize.width-30, (backgroundSize.height*0.87-10)/8*7)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CFactionVerifyListView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_roleListContainer :addChild( self.m_pScrollView )

    self.m_roleBtn = {}
    local tempfactioncount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CFactionVerifyListView pageContainerList 186 ")       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width, viewSize.height/2-30)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 1)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionVerifyListView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        self.m_roleBtn[k] = {}
        for i =1 , tempnum do
            tempfactioncount = tempfactioncount + 1
            local temprole = self :createItem( self.m_verifylist[tempfactioncount])
            layout :addChild( temprole)
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
    self.m_curentPageCount = self.m_pageCount-1
    self.m_pagecountLabel :setString( "1/"..self.m_pageCount)
end


--创建社团列表单项
function CFactionVerifyListView.createItem( self, _role)
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local temptime = os.date("%x",_role.time).." "..os.date("%H",_role.time)..":"..os.date("%S",_role.time)

    local itemContainer        = CContainer :create()
    local _itemnameLabel       = self :createLabel( _role.name)
    local _itemlvLabel         = self :createLabel( _role.lv) 
    local _itemprofessionLabel = self :createLabel( self :getProString( _role.pro))
    local _itemtimesLabel      = self :createLabel( temptime)  
    local _itemnormalSprite    = self :createSprite( "team_list_normal.png", " createItem _itemnormalSprite:".._role.uid)
    local _itemclickSprite     = self :createSprite( "team_list_click.png", " createItem _itemclickSprite".._role.uid)
    --创建各种Button
    local function examineCallBack(eventType, obj, touches)
        return self :onExamineCallBack( eventType, obj, touches)
    end
    --查看 多点触控
    local _itemexamineButton     = self :createButton( "", "transparent.png", examineCallBack, _role.uid, "self.m_examineButton")  
    _itemexamineButton :setTouchesMode( kCCTouchesAllAtOnce )
    _itemexamineButton :setTouchesEnabled( true)
    local function applyCallBack( eventType, obj, x, y)
        return self :onApplyCallBack( eventType, obj, x, y)
    end
    local _itemapplyButton       = self :createButton( "同意", "general_smallbutton_normal.png", applyCallBack, _role.uid, "self.m_applyButton")
    local function cancleCallBack( eventType, obj, x, y)
        return self :onCancleCallBack( eventType, obj, x, y)
    end
    local _itemcancleButton      = self :createButton( "拒绝", "general_smallbutton_normal.png", cancleCallBack, _role.uid, "self.m_cancleButton  ") 
    --self.m_verifylistbyuid[_role.uid] = _role
    itemContainer :setControlName( "this is CFactionVerifyListView.createItem itemContainer ")

    _itemnameLabel :setAnchorPoint( ccp( 0,0.5))
    _itemprofessionLabel :setAnchorPoint( ccp( 0,0.5))
    --_itemtimesLabel :setAnchorPoint( ccp( 0,0.5))
    _itemlvLabel :setAnchorPoint( ccp( 0,0.5))

    local flag  = false
    if flag == false then
        _itemclickSprite :setVisible( false)
        _itemnormalSprite :setVisible( true)
    elseif flag == true then
        _itemclickSprite :setVisible( true)
        _itemnormalSprite :setVisible( false)
    end 

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-40, (winSize.height*0.87-10)/8)
    _itemexamineButton :setPreferredSize( backgroundSize)
    _itemnormalSprite :setPreferredSize( backgroundSize)
    _itemclickSprite :setPreferredSize( backgroundSize)

    _itemnameLabel :setPosition( ccp( backgroundSize.width*0.05, 0))
    _itemlvLabel :setPosition( ccp( backgroundSize.width*0.25, 0))
    _itemprofessionLabel :setPosition( ccp( backgroundSize.width*0.35, 0))
    _itemtimesLabel :setPosition( ccp( backgroundSize.width*0.65, 0))
    _itemapplyButton :setPosition( ccp( backgroundSize.width*0.8+30, 0)) 
    _itemcancleButton :setPosition( ccp( backgroundSize.width*0.9+30, 0))   
    _itemexamineButton :setPosition( ccp( backgroundSize.width*0.42+30, 0))
    _itemnormalSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    _itemclickSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    itemContainer :setPosition( ccp( 0, backgroundSize.height/2))

    itemContainer :addChild( _itemnormalSprite)
    itemContainer :addChild( _itemclickSprite)
    itemContainer :addChild( _itemexamineButton)
    itemContainer :addChild( _itemnameLabel)
    itemContainer :addChild( _itemprofessionLabel)
    itemContainer :addChild( _itemtimesLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemapplyButton)
    itemContainer :addChild( _itemcancleButton)
    return itemContainer
end

function  CFactionVerifyListView.getProString( self, _pro)
    local prostring = nil
    if _pro == _G.Constant.CONST_PRO_NULL then
        prostring = "所有"
    elseif _pro == _G.Constant.CONST_PRO_SUNMAN then
        prostring = "阳光男"
    elseif _pro == _G.Constant.CONST_PRO_ZHENGTAI then
        prostring = "正太"
    elseif _pro == _G.Constant.CONST_PRO_ICEGIRL then
        prostring = "冰女"
    elseif _pro == _G.Constant.CONST_PRO_BIGSISTER then
        prostring = "御姐"
    elseif _pro == _G.Constant.CONST_PRO_LOLI then
        prostring = "罗莉"
    elseif _pro == _G.Constant.CONST_PRO_MONSTER then
        prostring = "猛男"
    else
        prostring = "没有找到相应职业"
    end
    return prostring
end
--更新本地list数据
function CFactionVerifyListView.setLocalList( self, _verifycount, _verifylist)
    print("CFactionVerifyListView.setLocalList")
    self.m_verifycount = _verifycount
    self.m_verifylist  = _verifylist
    ----[[
    --]]
    self :showAllRole()
end

function CFactionVerifyListView.setVerifyList( self, _verifycount, _verifylist)
    print("CFactionVerifyListView.setVerifyList")
    self.m_verifycount = _verifycount
    self.m_verifylist  = _verifylist
    self :showAllRole()    
end

function CFactionVerifyListView.setApplyOrCancle( self, _roleuid)
    -- {操作类型0拒绝| 1同意}
    for k,v in pairs( self.m_verifylist) do
        print(k,v)
        if v.uid == _roleuid then
            print( "remove ", v.uid)
            table.remove( self.m_verifylist, k) 
            self.m_verifycount = self.m_verifycount - 1
        end
    end
    self :showAllRole()
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionVerifyListView.onExamineCallBack( self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID)
    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print( "XXXXXXXXSs"..obj :getTag())
                    self.touchID   = touch :getID()
                    self.touchUid  = obj :getTag()
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
            if touch2:getID() == self.touchID and obj :getTag() == self.touchUid then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    print("dianji",obj :getTag())  
                    --人物接口
                    print("请求玩家身上装备开始")
                    local msg = REQ_GOODS_EQUIP_ASK()
                    msg :setUid( obj :getTag())
                    msg :setPartner( 0)
                    _G.CNetwork :send( msg)
                    print("请求玩家身上装备结束")
                    print("请求玩家属性开始:"..(obj :getTag()))
                    local msg_role = REQ_ROLE_PROPERTY()
                    msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
                    msg_role: setUid( obj :getTag() )
                    msg_role: setType( 0 )
                    _G.CNetwork : send( msg_role )
                    print("请求玩家属性结束")
                    self.touchID   = nil
                    self.touchUid  = nil          
                end
            end
        end

    end
end

function CFactionVerifyListView.onApplyCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 同意:",obj: getTag())
        require "common/protocol/auto/REQ_CLAN_ASK_AUDIT"
        local msg = REQ_CLAN_ASK_AUDIT()
        msg :setUid( obj: getTag())
        msg :setState( 1)
        _G.CNetwork :send( msg)
        self :setApplyOrCancle( obj: getTag())
    end
end

function CFactionVerifyListView.onCancleCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 拒绝:",obj: getTag())
        require "common/protocol/auto/REQ_CLAN_ASK_AUDIT"
        local msg = REQ_CLAN_ASK_AUDIT()
        msg :setUid( obj: getTag())
        msg :setState( 0)
        _G.CNetwork :send( msg)
        self :setApplyOrCancle( obj: getTag())
    end
end

function CFactionVerifyListView.clickCellCallBack(self,eventType, obj, x, y)        
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
        print("obj: getTag()", obj: getTag()) 
        if obj : getTag() == CFactionVerifyListView.TAG_CLOSED then
            self :realeaseParams()
            require "view/FactionPanelLayer/FactionPanelView"
            CCDirector :sharedDirector() :popScene()
            _G.pFactionPanelView = CFactionPanelView()
            CCDirector :sharedDirector() :pushScene( _G.pFactionPanelView :scene())
        end
    end
end





















