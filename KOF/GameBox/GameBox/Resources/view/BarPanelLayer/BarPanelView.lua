--[[
 --CBarPanelView
 --酒吧面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "controller/CharacterUpadteCommand"

require "view/BarPanelLayer/BarPromptView"
require "controller/GuideCommand"

CBarPanelView = class(view, function( self)
    print("CBarPanelView:酒吧面板主界面")
    CBarPanelView.readxml        = nil
    self.m_applyButton           = nil   --申请按钮
    self.m_cancleButton          = nil   --取消按钮
    self.m_examineButton         = nil   --查看按钮
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_barPanelViewContainer = nil  --酒吧面板的容器层
    self.m_m_applylist           = nil
    self.m_clickItemTag          = nil
    self.m_clickItem             = nil
    self.m_partnerlist           = {}
    self.m_renown                = 0
end)
--Constant:
CBarPanelView.TAG_APPLY        = 201  --申请
CBarPanelView.TAG_CANCLE       = 202  --取消
CBarPanelView.TAG_EXAMINE      = 203  --查看
CBarPanelView.TAG_CLOSED       = 205  --关闭

CBarPanelView.TAG_ROLE_ICON    = 250  --250~255

CBarPanelView.FONT_SIZE        = 25

CBarPanelView.ITEM_HEIGHT      = 800
CBarPanelView.PER_PAGE_COUNT   = 3

--加载资源
function CBarPanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
end
--释放资源
function CBarPanelView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("HeadIconResources/HeadIconResources.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("BarResources/BarResources.pvr.ccz")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end
--初始化数据成员
function CBarPanelView.initParams( self, layer)
    print("CBarPanelView.initParams")
    local mainplay = _G.g_characterProperty :getMainPlay()
    self.m_rolelv           = mainplay :getLv()     --玩家等级
    self.m_rolepartnercount = mainplay :getCount()  -- 伙伴数量
    self.m_renown           = mainplay :getRenown() -- 玩家声望
    self.m_rolemoney        = mainplay :getGold()   --美刀

    print("玩家声望:", self.m_renown)

    require "mediator/BarMediator"
    self.m_mediator = CBarMediator( self)       
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CBarPanelView.realeaseParams( self)
end

--布局成员
function CBarPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--酒吧面板主界面")
        --背景部分
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst        = self.m_barPanelViewContainer :getChildByTag( 100)
        local backgroundsecond       = self.m_barPanelViewContainer :getChildByTag( 102)
        local barbackgrounddown      = self.m_barPanelViewContainer :getChildByTag( 101)        
        local barbackgroundup        = self.m_barPanelViewContainer :getChildByTag( 103)
        local closeButtonSize        = self.m_closedButton :getPreferredSize() 

        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))
        backgroundsecond :setPreferredSize( backgroundSize)
        barbackgrounddown :setPreferredSize( CCSizeMake( backgroundSize.width-30, winSize.height*0.14)) 
        
        barbackgroundup :setPreferredSize( CCSizeMake( backgroundSize.width-30, winSize.height*0.8)) 

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        backgroundsecond :setPosition( ccp( winSize.width/2, winSize.height/2))
        barbackgrounddown :setPosition( ccp( winSize.width/2, winSize.height*0.07+15))
        
        barbackgroundup :setPosition( ccp( winSize.width/2, winSize.height*(1-0.8/2)-15))

        self.m_partnerListContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height*0.14+30))
        self.m_closedButton: setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
        self.m_currentreownLabel :setPosition( ccp( winSize.width*0.15, winSize.height*0.1-5))
        self.m_partnermembersLabel :setPosition( ccp( winSize.width*0.7, winSize.height*0.1-5))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--酒吧面板主界面")
        
    end
end

--主界面初始化
function CBarPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource( self)
    --初始化数据
    self.initParams( self,layer)
   --读取XML
    self.readXml( self)
    --初始化界面
    self.initView( self, layer)
    --请求服务端消息
    self.requestService( self)
    --布局成员
    self.layout( self, winSize)  
    --初始化指引
    _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_PARTNER)
end

function CBarPanelView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBarPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    --self.m_scenelayer :registerControlScriptHandler(local_onEnter,"CBarPanelView scene self.m_scenelayer 136")

    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBarPanelView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CBarPanelView.onEnter  ")
        -- _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_PARTNER)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_PARTNER )
    end
end

function CBarPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBarPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CBarPanelView.requestService ( self)
    -- [31110]请求客栈 -- 客栈 
    require "common/protocol/REQ_INN_ENJOY_INN"
    local msg = REQ_INN_ENJOY_INN()
    _G.CNetwork :send( msg)
end

--read XML 
function CBarPanelView.readXml( self)
    print( "CBarPanelView.readXml:")
    _G.Config:load("config/partner_lv.xml")
    _G.Config:load("config/partner_init.xml")
    local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
    local child = partner_inits_temp : children()
    local partnerlist = {}
    for i=0, child :getCount("partner_init")-1 do
        print("XXXXXXXXXX:",i)
        local tempnode = child : get(i, "partner_init")
        table.insert( partnerlist, tempnode) 
    end
    local function sortUseLv( partner1, partner2)
        print("======:",partner1 : getAttribute("use_lv"),partner2 : getAttribute("use_lv"))
        if tonumber(partner1 : getAttribute("use_lv")) < tonumber(partner2 : getAttribute("use_lv")) then
            print("true")
            return true
        end
        print("false")
        return false
    end
    table.sort( partnerlist, sortUseLv )
    for k,v in pairs(partnerlist) do
        local use_lv = v : getAttribute("use_lv")
        print(k,use_lv)
        if tonumber(use_lv) <= tonumber(self.m_rolelv) then
            table.insert( self.m_partnerlist, v)
        else
            table.insert( self.m_partnerlist, v)
            break
        end
    end
    self.m_partnercount = #self.m_partnerlist
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_partnercount, CBarPanelView.PER_PAGE_COUNT)
    self.m_curentPageCount = self.m_pageCount -1
    print("self.m_rolelv:"..self.m_rolelv)
    local lvchild  = _G.Config.partner_lvs : selectSingleNode("partner_lv[@lv="..tostring(self.m_rolelv).."]")
    local allchild = lvchild : children()
    local tempnode = allchild :get(0,"a")
    self.m_partnermaxcount = tonumber(tempnode : getAttribute("carry_count"))

end

function CBarPanelView.getPartnerById( self, _id)
    for index,node in pairs( self.m_partnerlist) do
        local nodea = node : get(0,"a")
        print( index, node : getAttribute("partner_name"), nodea : getAttribute("hp"))
        if node : getAttribute("id")  == tostring(_id) then
            return node
        end
    end
    return false
end


--初始化排行榜界面
function CBarPanelView.initView(self, layer)
    print("CBarPanelView.initView")
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --副本界面容器
    self.m_barPanelViewContainer = CContainer :create()
    self.m_barPanelViewContainer : setControlName("this is CBarPanelView self.m_barPanelViewContainer 94 ")
    layer :addChild( self.m_barPanelViewContainer)    
    --创建背景
    local backgroundfirst       = self :createBackground( "peneral_background.jpg", "backgroundfirst")
    local backgroundsecond      = self :createBackground( "general_first_underframe.png", "backgroundsecond")
    local barbackgrounddown     = self :createBackground( "general_second_underframe.png", "barbackgrounddown")    
    local barbackgroundup       = self :createBackground( "general_second_underframe.png", "barbackgroundup")
    --创建各种Button
    self.m_closedButton         = self :createButton( "", "general_close_normal.png", CallBack, CBarPanelView.TAG_CLOSED, "self.m_closedButton")
    --创建角色相关信息Label
    self.m_currentreownLabel    = CCLabelTTF :create( "当前声望: "..self.m_renown, "Arial", CBarPanelView.FONT_SIZE) 
    self.m_partnermembersLabel  = CCLabelTTF :create( "伙伴数量: "..self.m_rolepartnercount.."/"..self.m_partnermaxcount, "Arial", CBarPanelView.FONT_SIZE)   

    self.m_currentreownLabel :setAnchorPoint( ccp( 0, 0.5))
    self.m_partnermembersLabel :setAnchorPoint( ccp( 0, 0.5))
 
    self.m_partnerListContainer = CContainer :create()
    self.m_barPanelViewContainer :addChild( self.m_partnerListContainer, 1)
    self.m_barPanelViewContainer :addChild( backgroundfirst, -1, 100)
    self.m_barPanelViewContainer :addChild( backgroundsecond, -1, 102)
    self.m_barPanelViewContainer :addChild( barbackgrounddown, -1, 101)    
    self.m_barPanelViewContainer :addChild( barbackgroundup, -1, 103)
    self.m_barPanelViewContainer :addChild( self.m_closedButton, 2)
    self.m_barPanelViewContainer :addChild( self.m_currentreownLabel)
    self.m_barPanelViewContainer :addChild( self.m_partnermembersLabel)

    --
    --self :setLocalList()         

    self.m_guideButton                   = CButton :createWithSpriteFrameName( "", "transparent.png")
    self.m_guideButton : setControlName( "this CBarPanelView self.m_guideButton 134 " )
    self.m_guideButton :registerControlScriptHandler( CallBack, "this CBarPanelView self.m_guideButton 147")
    layer :addChild( self.m_guideButton, 2000)
end

--创建图片Sprite
function CBarPanelView.createBackground( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CBarPanelView createBackground _background".._controlname)
    return _background
end

--创建按钮Button
function CBarPanelView.createButton( self, _string, _image, _func, _tag, _controlname, _flag)
    print( "CBarPanelView.createButton buttonname:".._controlname.._image)
    local m_button = nil 
    if _flag == true then
        m_button = CButton :create( _string, _image)
    else
        m_button = CButton :createWithSpriteFrameName( _string, _image)
    end
    m_button :setControlName( "this CBarPanelView ".._controlname)
    m_button :setFontSize( CBarPanelView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CBarPanelView ".._controlname.."CallBack")
    return m_button
end

function CBarPanelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--显示排行榜玩家
function CBarPanelView.showAllPartner( self)
    if self.m_partnerListContainer ~= nil then
        self.m_partnerListContainer :removeAllChildrenWithCleanup( true)
    end

    self : SortPartnerByState()

    self.m_currentreownLabel :setString( "当前声望: "..self.m_renown) 
    self.m_partnermembersLabel :setString( "伙伴数量: "..self.m_rolepartnercount.."/"..self.m_partnermaxcount)  
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end    

    local winSize   = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize   = CCSizeMake( winSize.height/3*4, winSize.height)
    
    local m_bgCell  = CCSizeMake( backgroundSize.width-60,(winSize.height*0.8-40)/3)
    local viewSize  = CCSizeMake( backgroundSize.width, winSize.height*0.8-20)

    self.m_itemBackgroundSize = m_bgCell

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CBarPanelView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_partnerListContainer :addChild( self.m_pScrollView )

    local rolecount = 0
    local pageContainerList = {}
    self.m_roleList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CBarPanelView pageContainerList 186 "..tostring(k))       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-m_bgCell.height/2)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 6)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CBarPanelView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            rolecount = rolecount + 1
            local _partnerid = self.m_partnerlist[rolecount] :getAttribute("id") 
            self.m_roleList[ _partnerid] = self :createParnterItem( self.m_partnerlist[rolecount], m_bgCell)
            print("%%%%%%%%:",self.m_clickItemTag, self.m_partnerlist[i]:getAttribute("id") )
            if i == 1 and self.m_clickItemTag == nil then  -- 第一次进入
                print("XXXXXX111",self.m_clickItemTag)
                self.m_clickItemTag = self.m_partnerlist[i]:getAttribute("id")
            end
            layout :addChild( self.m_roleList[_partnerid])
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
    self :resetItemIsClick( self.m_clickItemTag, true)
end


--创建社团列表单项
function CBarPanelView.createParnterItem( self, _partner , _cellsize)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CBarPanelView.createParnterItem itemContainer ")
    local function CallBack( eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    local _itempartnerbutton = CButton :create( "", "transparent.png")
    _itempartnerbutton :setTouchesMode( kCCTouchesAllAtOnce )
    _itempartnerbutton :setTouchesEnabled( true)
    _itempartnerbutton :setTag( _partner : getAttribute("id"))
    _itempartnerbutton :registerControlScriptHandler( CallBack, "this is CBarPanelView.createParnterItem _itempartnerbutton CallBack")

    local _itembackground    =  self :createBackground( "general_underframe_normal.png", "_itembackground")
    local _itemrolecontainer = self :createRoleButton( _partner)
    local _itemlvLabel       = CCLabelTTF :create( "1 级", "Arial", CBarPanelView.FONT_SIZE)
    local _itemnameLabel     = CCLabelTTF :create( _partner : getAttribute("partner_name") , "Arial", CBarPanelView.FONT_SIZE)
    local _itemlineSprite    = self :createBackground( "bar_dividing_normal.png", "_itemlineSprite")
    local _itemmoneyLabel    = CCLabelTTF :create( "需要美刀: ".._partner : getAttribute("pay") , "Arial", CBarPanelView.FONT_SIZE)
    local _itemrenownLabel   = CCLabelTTF :create( "需要声望: ".._partner : getAttribute("use_renown") , "Arial", CBarPanelView.FONT_SIZE)
    local _itemishaveLabel   = CCLabelTTF :create( "(已拥有)", "Arial", CBarPanelView.FONT_SIZE)
    print("============>",_partner : getAttribute("id"))

    _itembackground :setPreferredSize( _cellsize)
    _itembackground :setTag( CBarPanelView.TAG_ROLE_ICON)
    _itemrolecontainer :setTag( CBarPanelView.TAG_ROLE_ICON+1)
    _itemlineSprite :setTag( CBarPanelView.TAG_ROLE_ICON+2)
    _itempartnerbutton :setPreferredSize( _cellsize)

    _itemnameLabel :setAnchorPoint( ccp( 0,0.5))
    _itemlvLabel :setAnchorPoint( ccp( 0,0.5))
    _itemmoneyLabel :setAnchorPoint( ccp( 0,0.5))
    _itemrenownLabel :setAnchorPoint( ccp( 0,0.5))
    _itemishaveLabel :setAnchorPoint( ccp( 0,0.5))

    local remowncolor = ccc3( 0, 255, 0)
    if tonumber(self.m_renown) < tonumber(_partner : getAttribute("use_renown") ) then
        remowncolor = ccc3( 255, 0, 0)
    end
    local moneycolor = ccc3( 0, 255, 0)
    if tonumber(self.m_rolemoney) < tonumber(_partner : getAttribute("pay") ) then
        moneycolor = ccc3( 255, 0, 0)
    end
    --创建相应状态
    local _itemstate   = nil
    if tonumber(_partner : getAttribute("use_lv") ) <= self.m_rolelv then
        local partnerstate = self :getPartnerStateById( _partner : getAttribute("id") )
        if partnerstate == false then            
            --可招募，未招募
            print( "XXXXXXXX:")
            if tonumber(_partner : getAttribute("open_kind") ) == 0 then --首充礼包可以获得
                local function CallBack( eventType, obj, x, y)
                    return self :clickRechargeCallBack( eventType, obj, x, y)
                end
                _itemstate     = self :createButton( "充值", "general_button_normal.png", CallBack, _partner : getAttribute("id") , "_itemstate")  
                _itemrenownLabel :setString( " ")
                _itemmoneyLabel :setString( " ")
                _itemishaveLabel :setString( "首充礼包可获得")
                _itemishaveLabel :setColor( ccc3( 255, 0, 0))

            elseif tonumber(_partner : getAttribute("open_kind") ) == 2 then -- 满足美刀 声望 等级 可以获得
                local function CallBack( eventType, obj, x, y)
                    return self :clickRechargeSSSSCallBack( eventType, obj, x, y)
                end
                _itemstate     = self :createButton( "充值", "general_button_normal.png", CallBack, _partner : getAttribute("id") , "_itemstate")  
                _itemrenownLabel :setString( " ")
                _itemmoneyLabel :setString( " ")
                _itemishaveLabel :setString( "充值可获得")
                _itemishaveLabel :setColor( ccc3( 255, 0, 0))
            elseif tonumber(_partner : getAttribute("open_kind") ) == 1 then -- 满足美刀 声望 等级 可以获得
                local function CallBack( eventType, obj, x, y)
                    return self :clickRecruitCallBack( eventType, obj, x, y)
                end
                _itemstate     = self :createButton( "招募", "general_button_normal.png", CallBack, _partner : getAttribute("id") , "_itemstate")  
                _itemrenownLabel :setColor( remowncolor)
                _itemmoneyLabel :setColor( moneycolor)
                _itemishaveLabel :setString( " ")
            else -- 其他情况
                print("伙伴获得条件：",_partner : getAttribute("open_kind") )
            end
        else
            if _G.Constant.CONST_INN_STATA2 == partnerstate.stata then
                --已招募在酒吧
                local function CallBack( eventType, obj, x, y)
                    return self :clickRejoinCallBack( eventType, obj, x, y)
                end
                _itemstate     = self :createButton( "归队", "general_button_normal.png", CallBack, _partner : getAttribute("id") , "_itemstate")
            elseif _G.Constant.CONST_INN_STATA0 == partnerstate.stata or _G.Constant.CONST_INN_STATA3 then
                _itemstate     = self :createBackground( "bar_strengthen_yzm.png", "_itemstate")
                --CCLabelTTF :create( "已招募", "Arial", CBarPanelView.FONT_SIZE)
            end
            _itemlvLabel :setString( partnerstate.lv.." 级")
            _itemrenownLabel :setString( " ")
            _itemmoneyLabel :setString( " ")
            _itemishaveLabel :setColor( ccc3( 0, 0, 255))
        end
    elseif tonumber(_partner : getAttribute("use_lv") ) > self.m_rolelv then
        --人物等级不足
        _itemstate     = CCLabelTTF :create( "需要等级 ".._partner : getAttribute("use_lv") , "Arial", CBarPanelView.FONT_SIZE)
        _itemstate :setColor( ccc3( 255,0,0))
        _itemrenownLabel :setColor( remowncolor)
        _itemmoneyLabel :setColor( moneycolor)
        _itemishaveLabel :setString( " ")
    end

    _itemrolecontainer :setPosition( ccp( -_cellsize.width*0.4, 0))
    _itemstate :setPosition( ccp( _cellsize.width*0.35, 0))
    _itemnameLabel :setPosition( ccp( -_cellsize.width*0.3, 25))    
    _itemlvLabel :setPosition( ccp( -_cellsize.width*0.3, -25))
    _itemlineSprite :setPosition( ccp( -_cellsize.width*0.1, 0))
    _itemrenownLabel :setPosition( ccp( -20, 25))
    _itemmoneyLabel :setPosition( ccp( -20, -25))

    itemContainer :addChild( _itembackground)
    itemContainer :addChild( _itempartnerbutton)
    itemContainer :addChild( _itemrolecontainer)
    itemContainer :addChild( _itemnameLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemlineSprite)
    itemContainer :addChild( _itemrenownLabel)
    itemContainer :addChild( _itemmoneyLabel)
    itemContainer :addChild( _itemishaveLabel)
    itemContainer :addChild( _itemstate)
    return itemContainer
end

function CBarPanelView.createRoleButton( self, _role)
    print("CGoodsInfoView.createRoleButton")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickExamineCallBack( eventType, obj, x, y)
    end
    local rolecontainer = CContainer :create()
    rolecontainer : setControlName("this is CBarPanelView rolecontainer 158 ")
    --角色头像背景
    local background    = CSprite :createWithSpriteFrameName( "general_role_head_underframe.png")
    background : setControlName( "this CBarPanelView background 160 ")
    rolecontainer :addChild( background)  
    --角色头像
    local backgroundsize = background :getPreferredSize()
    if _role : getAttribute("id") ~= nil then
        local temp = "01"
        if _role : getAttribute("head") ~= "10001" then
            temp = _role : getAttribute("head") 
        end
        local imgname            = "HeadIconResources/role_head_"..(temp)..".jpg"--tostring(math.mod( _roleid,4)+1)
        print("imgnamea:",imgname)
        local roleIconButton = self :createButton( "", imgname, CallBack, _role : getAttribute("id") , "roleIconButton", true)
        rolecontainer :addChild( roleIconButton)       
    end
    --角色头像外框
    local roleframe = CSprite :createWithSpriteFrameName( "general_role_head_frame_normal.png")
    roleframe : setControlName( "this CBarPanelView roleframe 160 ")
    roleframe : setTag( CBarPanelView.TAG_ROLE_ICON+1)
    rolecontainer :addChild( roleframe) 
    return rolecontainer
end


function CBarPanelView.getPartnerStateById( self, _id)
    for k,v in pairs( self.m_partnerstatelist) do
        print(k,v.partner_id, _id)
        if tonumber(v.partner_id) == tonumber(_id) then
            print("已招募")
            return v
        end
    end
    print("可招募，未招募")
    return false
end

function CBarPanelView.getStateById( self, _id)
    for k,v in pairs( self.m_partnerstatelist) do
        print(k,v.partner_id, _id)
        if tonumber(v.partner_id) == tonumber(_id) then
            print("已招募")
            return true
        end
    end
    print("可招募，未招募")
    return false
end


--[[
1. 已招募在前，未招募在后
2. 等级高在前，等级低在后
--]]
function CBarPanelView.SortPartnerByState( self)
    print(" Start =======SortMemberList", #self.m_partnerlist)
    local function _sortComparer( _member1, _member2 )
        if _member1 ~=nil and _member2 ~= nil then
            local partnerstate1 = self :getPartnerStateById( _member1 : getAttribute("id") )
            local partnerstate2 = self :getPartnerStateById( _member2 : getAttribute("id") )
            local state1 = self : getStateById(_member1 : getAttribute("id")) 
            local state2 = self : getStateById(_member2 : getAttribute("id")) 
            if state1 == true and state2 == false then --职位越大越前
                return true
            elseif state1 == false and state2 == true then
                return false
            elseif state1 == true and state2 == true then
                if tonumber(partnerstate1.lv) > tonumber(partnerstate2.lv) then --贡献大的越前
                    return true
                elseif tonumber(partnerstate1.lv) == tonumber(partnerstate2.lv) then
                    return false
                else
                    return false
                end
            else
                return false
            end
        else
            print("4444:")
            return false
        end
    end
    table.sort( self.m_partnerlist, _sortComparer)
    print(" End =======SortMemberList")
end

--更新本地list数据
function CBarPanelView.setLocalList( self, _partnercount, _partnerlist)
    print("CBarPanelView.setLocalList")
    --self.m_partnercount = _partnercount
    --self.m_partnerlist  = _partnerlist
    self :showAllPartner()
end

function CBarPanelView.setPartnerStateList( self, _renown, _partnerstatecount, _partnerstatelist )
    print("CBarPanelView.setFactionList")
    self.m_partnerstatecount = _partnerstatecount
    self.m_partnerstatelist  = _partnerstatelist
    self.m_renown            = _renown

    --该段代码转移至人物属性缓存请求 
    for k,v in pairs( self.m_partnerstatelist) do
        print(k,v.stata,v.partner_id)
        if v.stata == 2 then
            self :requestPartnerInfo( v.partner_id)
        end
    end
    
    self :showAllPartner()
end

function CBarPanelView.requestPartnerInfo( self, _partnerid)
    --请求伙伴属性
    local msg = REQ_ROLE_PROPERTY()
    msg: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg: setUid( _G.g_LoginInfoProxy :getUid() )
    msg: setType( _partnerid)
    _G.CNetwork : send( msg)
    --请求伙伴身上装备 
    msg = REQ_GOODS_EQUIP_ASK()
    msg :setUid( _G.g_LoginInfoProxy :getUid())
    msg :setPartner( _partnerid)
    _G.CNetwork :send( msg)
end

function CBarPanelView.updateCharacterPartnerInfo( self, _partnerid)
    --更新缓存的伙伴数量和伙伴ID列表
    local mainProperty = _G.g_characterProperty : getMainPlay()
    local templist = mainProperty :getPartner()
    table.insert( templist, _partnerid )
    mainProperty : setPartner( templist)
    mainProperty : setCount( mainProperty :getCount()+1)
    self :requestPartnerInfo( _partnerid)
end

function CBarPanelView.setPartnerStateChange( self , _type, _partnerid)
    -- {操作类型0取消| 1申请}
    ----[[
    print("XCXCXC过去:",self.m_curentPageCount)
    if _type == 0 then   --离队成功 到酒吧 归队
    elseif _type == 1 then --归队成功 到身上 已招
        print("===================1")
        for k,v in pairs( self.m_partnerstatelist) do
            print(k,v.partner_id,_partnerid)
            if v.partner_id == _partnerid then
                v.stata = 0 
                print("===================1")
                self.m_rolepartnercount = self.m_rolepartnercount + 1
                --更新缓存伙伴数量，和数量列表，请求伙伴属性
                self :updateCharacterPartnerInfo( _partnerid)
                local command = CCharacterRoleIconCommand()
                controller :sendCommand( command)
            end
        end
    elseif _type == 2 then --出战成功 身上 已招--出战
    elseif _type == 3 then --休息成功 身上 出战--已招
    elseif _type == 4 then --招募成功 身上or酒吧 已招or归队
        print("招募成功VVVVVVVVV：",_type,self.m_rolepartnercount, self.m_partnermaxcount)
        if self.m_rolepartnercount < self.m_partnermaxcount then
            print("MMMM:0")
            table.insert( self.m_partnerstatelist, {partner_id=_partnerid,lv=1,stata=0})
            self.m_rolepartnercount = self.m_rolepartnercount + 1
            --更新缓存伙伴数量，和数量列表，请求伙伴属性
            self :updateCharacterPartnerInfo( _partnerid)
            local command = CCharacterRoleIconCommand()
            controller :sendCommand( command)
        elseif self.m_rolepartnercount == self.m_partnermaxcount then
            print("MMMM:2")
            table.insert( self.m_partnerstatelist, {partner_id=_partnerid,lv=1,stata=2})
        end 
        self:setGuideStepFinish()
    end
    --]]
    self :showAllPartner()
    print("CXCXCX现在:",self.m_curentPageCount)
    self.m_pScrollView :setPage( self.m_curentPageCount, false)
end

function CBarPanelView.resetItemIsClick( self, _itempartnerid, _isclick)
    print("  CBarPanelView.resetItemIsClick",self.m_clickItemTag,_isclick,_itempartnerid,type(_itempartnerid))
    --取消选中
    for k,v in pairs(self.m_roleList) do
        print(k,v)
    end

    local itemContainer = self.m_roleList[tostring(_itempartnerid)]
    if _isclick == false then
        --伙伴背景
        print("1")
        local backgroundsprite = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON)
        if backgroundsprite ~= nil then            
            backgroundsprite :setImageWithSpriteFrameName( "general_underframe_normal.png")
            backgroundsprite :setPreferredSize( self.m_itemBackgroundSize)
        end
        --伙伴头像
        local roleContainer        = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+1)
        local roleframe            = roleContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+1)
        if roleframe ~= nil then
            roleframe :setImageWithSpriteFrameName( "general_role_head_frame_normal.png")
        end
        --分割线
        local linesprite           = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+2)
        if linesprite ~= nil then
            linesprite :setImageWithSpriteFrameName( "bar_dividing_normal.png")
        end
    elseif _isclick == true then
        --选中
        print("2")
        --伙伴背景
        local backgroundsprite = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON)
        if backgroundsprite ~= nil then            
            backgroundsprite :setImageWithSpriteFrameName( "general_underframe_click.png")
            backgroundsprite :setPreferredSize( self.m_itemBackgroundSize)
        end
        --伙伴头像
        local roleContainer        = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+1)
        local roleframe            = roleContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+1)
        if roleframe ~= nil then
            roleframe :setImageWithSpriteFrameName( "general_role_head_frame_click.png")
        end
        --分割线
        local linesprite           = itemContainer :getChildByTag( CBarPanelView.TAG_ROLE_ICON+2)
        if linesprite ~= nil then
            linesprite :setImageWithSpriteFrameName( "bar_dividing_click.png") 
        end
    end
end
-----------------------------------------------------
--回调函数
----------------------------------------------------

--多点触控
function CBarPanelView.viewTouchesCallback(self, eventType, obj, touches)
    --print("viewTouchesCallback eventType",eventType, obj :getTag(), touches,self.touchID)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.pBarPromptView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print( "XXXXXXXXSs"..obj :getTag())
                    self.touchID         = touch :getID()
                    self.touchPartnerID  = obj :getTag()
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
            if touch2:getID() == self.touchID and obj :getTag() == self.touchPartnerID and self.m_clickItemTag ~= self.touchPartnerID then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    print(" 点击伙伴:",obj :getTag())
                    self :resetItemIsClick( self.m_clickItemTag, false)
                    self.m_clickItemTag = obj :getTag()
                    self :resetItemIsClick( self.m_clickItemTag, true)
                    --local role = self :getPartnerById( obj :getTag())                    
                    --self.m_scenelayer :addChild( _G.g_FactionPopupView :create( self :getRoleByUid( obj :getTag()), self.m_myinfo, _postion))   
                    self.touchID         = nil
                    self.touchPartnerID  = nil         
                end
            end
        end

    end
end
--BUTTON类型切换buttonCallBack
function CBarPanelView.clickRecruitCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pBarPromptView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 招募:",obj :getTag())
        self :resetItemIsClick( self.m_clickItemTag, false)
        self.m_clickItemTag = obj :getTag()
        self :resetItemIsClick( self.m_clickItemTag, true)
        
        require "common/protocol/auto/REQ_INN_CALL_PARTNER"
        local msg = REQ_INN_CALL_PARTNER()
        msg :setPartnerId( obj :getTag())
        _G.CNetwork :send( msg)
        
    end 
end

--充值
function CBarPanelView.clickRechargeCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pBarPromptView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 招募:",obj :getTag())
        self :resetItemIsClick( self.m_clickItemTag, false)
        self.m_clickItemTag = obj :getTag()
        self :resetItemIsClick( self.m_clickItemTag, true)
        --打开充值界面
        --local command = CPayCheckCommand( CPayCheckCommand.ASK )
        --controller :sendCommand( command )
        require "view/FirstTopupGift/FirstTopupGiftView"
        CCDirector:sharedDirector():pushScene(CCTransitionShrinkGrow:create( 0.5,CFirstTopupGiftView () :scene(101,0) )) 
    end 
end

--充值获得  

function CBarPanelView.clickRechargeSSSSCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pBarPromptView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 招募:",obj :getTag())
        self :resetItemIsClick( self.m_clickItemTag, false)
        self.m_clickItemTag = obj :getTag()
        self :resetItemIsClick( self.m_clickItemTag, true)
        --打开充值界面
        --local command = CPayCheckCommand( CPayCheckCommand.ASK )
        --controller :sendCommand( command )

        require "view/Activities/ActivitiesView"
        local view = CActivitiesView(501,5022)
        CCDirector:sharedDirector():pushScene(CCTransitionShrinkGrow:create( 0.5,view :scene() )) 
        -- require "view/FirstTopupGift/FirstTopupGiftView"
        -- CCDirector : sharedDirector () : pushScene(CFirstTopupGiftView () :scene(101,0))
    end 
end

function CBarPanelView.clickRejoinCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pBarPromptView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 归队:",obj :getTag())
        self :resetItemIsClick( self.m_clickItemTag, false)
        self.m_clickItemTag = obj :getTag()
        self :resetItemIsClick( self.m_clickItemTag, true)
        require "common/protocol/auto/REQ_INN_ENJOY"
        local msg = REQ_INN_ENJOY()
        msg :setPartnerId( obj :getTag())
        _G.CNetwork :send( msg)
    end 
end

function CBarPanelView.clickExamineCallBack( self, eventType, obj, x, y)
    --删除Tips
    _G.pBarPromptView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(" 查看:",obj :getTag())
        self :resetItemIsClick( self.m_clickItemTag, false)
        self.m_clickItemTag = obj :getTag()
        self :resetItemIsClick( self.m_clickItemTag, true)
        local _isrecruit = self :getPartnerStateById(  obj :getTag())
        if _isrecruit ~= false then
            _isrecruit = true  -- true已招募 fasle未招募
        end
        self.m_scenelayer :addChild( _G.pBarPromptView :layer( obj :getTag(), _isrecruit))
    end 
end
--单击回调
function CBarPanelView.clickCellCallBack(self,eventType, obj, x, y)  
    print( "eventType",eventType)     
    --删除Tips
    _G.pBarPromptView :reset() 
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then        
        local currentPage = x
        print( "eventType",eventType, "当前页：",currentPage, "过去页：",self.m_curentPageCount)
        self.m_curentPageCount = currentPage 
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CBarPanelView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                controller :unregisterMediator( self.m_mediator)
                CCDirector :sharedDirector() :popScene( )
                self:unloadResource()

                self:setGuideStepFinish()
            else
                print("objSelf = nil", self)
            end
        end    
    end
end

--新手引导点击命令
function CBarPanelView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end
