--[[
 --CFactionMemberListView
 --社团成员主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "view/FactionPanelLayer/FactionPopupView"

CFactionMemberListView = class(view, function( self)
    print("CFactionMemberListView:社团成员主界面")
    self.m_applyButton           = nil   --同意按钮
    self.m_cancleButton          = nil   --拒绝按钮
    self.m_examineButton         = nil   --查看按钮
    self.m_verifyListViewContainer  = nil  --人物面板的容器层
    self.m_m_applylist           = nil
    self.myrole    = nil
end)
--Constant:
CFactionMemberListView.TAG_EXAMINE      = 201  --查看

CFactionMemberListView.FONT_SIZE        = 23

CFactionMemberListView.ITEM_HEIGHT      = 800
CFactionMemberListView.PER_PAGE_COUNT   = 7

--加载资源
function CFactionMemberListView.loadResource( self)

end
--释放资源
function CFactionMemberListView.unLoadResource( self)
end
--初始化数据成员
function CFactionMemberListView.initParams( self, layer)
    print("CFactionMemberListView.initParams")
    require "mediator/FactionMediator"
    --self.m_mediator = CFactionApplyMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionMemberListView.realeaseParams( self)
end

--布局成员
function CFactionMemberListView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团成员主界面")   
        local backgroundSize     = CCSizeMake( winSize.height/3*4, winSize.height)
        --字段名部分
        self.m_fieldContainer :setPosition( ccp( winSize.width/2, winSize.height-105))
        --页数/总页数
        self.m_pagecountLabel :setPosition( winSize.width/2, 30)
        --界面名称
        self.m_roleListContainer :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+25, 20)) 
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团成员主界面")
        
    end
end

--主界面初始化
function CFactionMemberListView.init(self, winSize, layer)
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

function CFactionMemberListView.scene(self, _myInfo)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionMemberListView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionMemberListView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()

    local function touchesCallback(eventType, obj, touches)
        print( "层多点")
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionMemberListView self.m_scenelayer 105 ")
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( touchesCallback ,"this CFactionMemberListView self.m_scenelayer 152")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionMemberListView.requestService ( self)
    -- (手动) -- [33130]请求社团成员列表 -- 社团 
    require "common/protocol/auto/REQ_CLAN_ASK_MEMBER_MSG"
    local msg = REQ_CLAN_ASK_MEMBER_MSG()
    _G.CNetwork :send( msg)
end


--创建按钮Button
function CFactionMemberListView.createExamineButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionMemberListView.createExamineButton buttonname:".._string.._controlname)
    local m_button = CButton :create( _string, _image)
    m_button :setControlName( "this CFactionMemberListView ".._controlname)
    m_button :setFontSize( CFactionMemberListView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :setTouchesMode( kCCTouchesAllAtOnce )
    m_button :setTouchesEnabled( true)
    m_button :registerControlScriptHandler( _func, "this CFactionMemberListView ".._controlname.."touchesCallback")
    return m_button
end


function CFactionMemberListView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
    pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
                                                          
--初始化排行榜界面
function CFactionMemberListView.initView(self, layer)
    print("CFactionMemberListView.initView")
    --副本界面容器
    self.m_verifyListViewContainer = CContainer :create()
    self.m_verifyListViewContainer : setControlName("this is CFactionMemberListView self.m_verifyListViewContainer 94 ")
    layer :addChild( self.m_verifyListViewContainer)                
    --字段名字Label
    --字段名字Label
    self.m_fieldContainer        = CContainer :create()
    self :createField()

    --页数/总页数
    self.m_pagecountLabel    = CCLabelTTF :create( "", "Arial", CFactionMemberListView.FONT_SIZE)
    self.m_roleListContainer = CContainer :create()

    self.m_verifyListViewContainer :addChild( self.m_fieldContainer)
    self.m_verifyListViewContainer :addChild( self.m_pagecountLabel)
    self.m_verifyListViewContainer :addChild( self.m_roleListContainer, 1)
    --
    --self :setLocalList()         
end

function CFactionMemberListView.createField( self)
    local _fieldcolor         = ccc3(90,152,225)
    local _itembackground     = self :createSprite( "team_titlebar_underframe.png", " createField _itembackground")
    local _itemrankingLabel   = self :createLabel( "角色名字", _fieldcolor)
    local _itemlvLabel        = self :createLabel( "等级", _fieldcolor)
    local _itemnameLabel      = self :createLabel( "职位", _fieldcolor)
    local _itemmemberLabel    = self :createLabel( "今天/总贡献", _fieldcolor)
    local _itemoperatingLabel = self :createLabel( "最后在线", _fieldcolor)

    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-30, winSize.height*0.75/7)
    _itembackground :setPreferredSize( backgroundSize)

    _itemrankingLabel :setPosition( ccp( -backgroundSize.width*0.4, 0))
    _itemlvLabel :setPosition( ccp( -backgroundSize.width*0.25+10, 0))
    _itemnameLabel :setPosition( ccp( -backgroundSize.width*0.1+15, 0))
    _itemmemberLabel :setPosition( ccp( backgroundSize.width*0.15-20, 0))        
    _itemoperatingLabel :setPosition( ccp( backgroundSize.width*0.37, 0))

    self.m_fieldContainer :addChild( _itembackground)
    _itembackground :addChild( _itemrankingLabel)
    _itembackground :addChild( _itemlvLabel)
    _itembackground :addChild( _itemnameLabel)
    _itembackground :addChild( _itemmemberLabel)    
    _itembackground :addChild( _itemoperatingLabel) 
end

--显示排行榜玩家
function CFactionMemberListView.showAllRole( self)
    if self.m_roleListContainer ~= nil then
        self.m_roleListContainer :removeAllChildrenWithCleanup( true)
    end
    local function CallBack( eventType, obj, npage, y)
        print( "Scroll单点")
        return self :clickCellCallBack( eventType, obj, npage, y)
    end

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_memberscount, CFactionMemberListView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize  = CCSizeMake( winSize.height/3*4, winSize.height)
    local m_bgCell        = CCSizeMake( backgroundSize.width-50,(backgroundSize.height*0.87-10)/8)
    local viewSize        = CCSizeMake( backgroundSize.width-30, (backgroundSize.height*0.87-10)/8*7)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CFactionMemberListView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_roleListContainer :addChild( self.m_pScrollView )

    self.m_roleContainerList = {}
    local tempfactioncount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CFactionMemberListView pageContainerList 186 ")       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width, viewSize.height/2-30)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 1)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionMemberListView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            tempfactioncount = tempfactioncount + 1
            local _role = self.m_memberlist[tempfactioncount]
            self.m_roleContainerList[_role.uid] = self :createItem( _role)
            layout :addChild( self.m_roleContainerList[_role.uid])
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
    self.m_curentPageCount = self.m_pageCount-1
    self.m_pagecountLabel :setString( ""..self.m_pageCount)
end

--创建社团列表单项
function CFactionMemberListView.createItem( self, _role)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local function touchesCallback(eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    --职位
    local tmpStr = CLanguageManager:sharedLanguageManager():getString("faction_post_"..tostring(_role.post) )
    if tmpStr == nil then
        tmpStr = "未找到职位"
    end
    --在线时间
    local temptime = nil
    if _role.time == 1 then
        temptime = "在线"
    else
        temptime = os.date("%x",_role.time).." "..os.date("%H",_role.time)..":"..os.date("%M",_role.time)
    end
    --是否是自己
    local _color = ccc3( 255,255,255)
    if tonumber(_G.g_LoginInfoProxy:getUid()) == tonumber(_role.uid) then
        _color = ccc3( 255,255,0)
    end

    --------------------------------------------------------
    local itemContainer          = CContainer :create()
    itemContainer :setControlName( "this is CFactionMemberListView.createItem itemContainer :".._role.uid)
    local _itemnameLabel         = self :createLabel( _role.name,_color) --名字
    local _itemlvLabel           = self :createLabel( _role.lv,_color)   --等级
    local _itempostLabel         = self :createLabel( tmpStr,_color)
    local _itemcontributionLabel = self :createLabel( _role.today_gx.."/".._role.all_gx,_color) --贡献
    local _itemtimesLabel        = self :createLabel( temptime,_color)   --时间
    local _itemnormalSprite      = self :createSprite( "team_list_normal.png", " createItem _itemnormalSprite:".._role.uid)
    local _itemclickSprite       = self :createSprite( "team_list_click.png", " createItem _itemclickSprite".._role.uid)
    --创建各种Button
    local _itemexamineButton     = self :createExamineButton( "", "transparent.png", touchesCallback, _role.uid, "self.m_examineButton")  
 
    local winSize             = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize      = CCSizeMake( winSize.height/3*4-40, (winSize.height*0.87-10)/8)
    _itemexamineButton :setPreferredSize( backgroundSize)
    _itemnormalSprite :setPreferredSize( backgroundSize)
    _itemclickSprite :setPreferredSize( backgroundSize)

    if flag == false then
        _itemclickSprite :setVisible( false)
        _itemnormalSprite :setVisible( true)
    elseif flag == true then
        _itemclickSprite :setVisible( true)
        _itemnormalSprite :setVisible( false)
    end 
    if _role.time ~= 1 then
        _itemclickSprite :setGray( true)
        _itemnormalSprite :setGray( true)
    end

    _itemnameLabel :setAnchorPoint( ccp( 0,0.5))
    --_itempostLabel :setAnchorPoint( ccp( 0,0.5))
    --_itemtimesLabel :setAnchorPoint( ccp( 0,0.5))
    _itemlvLabel :setAnchorPoint( ccp( 0,0.5))

    _itemnameLabel :setPosition( ccp( backgroundSize.width*0.05, 0))
    _itemlvLabel :setPosition( ccp( backgroundSize.width*0.25, 0))
    _itempostLabel :setPosition( ccp( backgroundSize.width*0.4+20, 0))
    _itemcontributionLabel :setPosition( ccp( backgroundSize.width*0.65-20, 0))
    _itemtimesLabel :setPosition( ccp( backgroundSize.width*0.85+20, 0))  
    _itemexamineButton :setPosition( ccp( backgroundSize.width*0.5, 0))
    _itemnormalSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    _itemclickSprite :setPosition( ccp( backgroundSize.width*0.5, 0))
    itemContainer :setPosition( ccp( 0, backgroundSize.height/2))

    itemContainer :addChild( _itemnormalSprite)
    itemContainer :addChild( _itemclickSprite)
    itemContainer :addChild( _itemnameLabel)
    itemContainer :addChild( _itempostLabel)
    itemContainer :addChild( _itemcontributionLabel)
    itemContainer :addChild( _itemtimesLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemexamineButton)
    return itemContainer
end

--创建图片Sprite
function CFactionMemberListView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionMemberListView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionMemberListView.createLabel( self, _string, _color)
    print("CFactionMemberListView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionMemberListView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--[[
1. 职位由高到低
2. 在线-》不在线
3. 等级由高到低
4. 贡献由高到低
--]]
function CFactionMemberListView.SortMemberList( self, _memberlist)
    print(" Start =======SortMemberList", #_memberlist)
    local function _sortComparer( _member1, _member2 )
        if _member1 ~=nil and _member2 ~= nil then
            if tonumber(_member1.post) > tonumber(_member2.post) then --职位越大越前
                return true
            elseif tonumber(_member1.post) == tonumber(_member2.post) then
                if tonumber(_member1.time) == 1 and  tonumber(_member2.time) ~= 1 then --在线大于离线
                    return true
                elseif tonumber(_member1.time) ~= 1 and  tonumber(_member2.time) == 1 then --在线大于离线
                    return false
                else
                    if tonumber(_member1.lv) > tonumber(_member2.lv) then --等级大的越前
                        return true
                    elseif tonumber(_member1.lv) == tonumber(_member2.lv) then
                        if tonumber(_member1.all_gx) > tonumber(_member2.all_gx) then --贡献大的越前
                            return true
                        elseif tonumber(_member1.all_gx) == tonumber(_member2.all_gx) then
                            return false
                        else
                            return false
                        end
                    else
                        return false
                    end
                end
            else
                return false
            end
        else
            print("4444:")
            return false
        end
    end
    table.sort( _memberlist, _sortComparer)
    print(" End =======SortMemberList")
end

--更新本地list数据
function CFactionMemberListView.setLocalList( self, _memberscount, _memberlist)
    print("CFactionMemberListView.setLocalList")
    self.m_memberscount = _memberscount
    self.m_memberlist   = _memberlist
    self :SortMemberList( self.m_memberlist)
    self :showAllRole()
end

function CFactionMemberListView.setMembersData( self, _memberscount, _memberlist)
    print("CFactionMemberListView.setMembersData")
    self.m_memberscount = _memberscount
    self.m_memberlist   = _memberlist
    for k,v in pairs(self.m_memberlist) do
        print(k,v.all_gx)
    end
    print("==================")
    self :SortMemberList( self.m_memberlist)
    local mainplay = _G.g_characterProperty :getMainPlay()
    local myuid    = mainplay :getUid()      --玩家Uid
    for k,v in pairs( self.m_memberlist) do
        print(k,v)
        if v.uid == myuid then
            print( "remove ", v.uid)
            self.m_myinfo = v
        end
    end
    self :showAllRole()    
end

function CFactionMemberListView.setApplyOrCancle( self, _roleuid)
    -- {操作类型0拒绝| 1同意}
    for k,v in pairs( self.m_memberlist) do
        print(k,v)
        if v.uid == _roleuid then
            print( "remove ", v.uid)
            table.remove( self.m_memberlist, k) 
            self.m_memberscount = self.m_memberscount - 1
        end
    end
    self :showAllRole()
end

function CFactionMemberListView.getRoleByUid( self, _roleuid)
    for k,v in pairs( self.m_memberlist) do
        print(k,v)
        if v.uid == _roleuid then
            return v
        end
    end
    return false
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--多点触控
function CFactionMemberListView.viewTouchesCallback(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_FactionPopupView :reset()
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
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 and obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touch2Point.x, touch2Point.y)))  then
                    print("dianji",obj :getTag())  
                    --self.m_roleContainerList[_role.uid]  
                    local _roleinfo = self :getRoleByUid( obj :getTag())
                    local mainplay = _G.g_characterProperty :getMainPlay()
                    local myuid    = mainplay :getUid()      --玩家Uid
                    if tonumber(_roleinfo.uid) ~= tonumber(myuid) then
                        local _postion = {}
                        _postion.x = touch2Point.x
                        _postion.y = touch2Point.y
                        self.m_scenelayer :addChild( _G.g_FactionPopupView :create( _roleinfo, self.m_myinfo, _postion))   
                    end
                    self.touchID   = nil
                    self.touchUid  = nil          
                end
            end
        end

    end
end
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionMemberListView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        --删除Tips
        _G.g_FactionPopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = self.m_pageCount-currentPage 
            self.m_pagecountLabel :setString( "")--self.m_curentPageCount.."/"..self.m_pageCount
        end
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag()) 
    end
end





















