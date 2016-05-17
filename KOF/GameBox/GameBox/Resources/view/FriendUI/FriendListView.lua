require "view/view"
require "controller/FriendListCommand"
require "view/FriendUI/PopTips"

require "model/VO_FriendModel"

CFriendListView = class( view, function( self )
	CCLOG("CFriendListView 构造")
    --注册好友mediator 并请求好友面板
    
    self.currentType            = 1  --当前界面  1-4
end)

function CFriendListView.setCurrentType( self, value)
    self.currentType  = value
end
function CFriendListView.getCurrentType( self)
    return self.currentType
end

CFriendListView.SCROLLTAG       = 1001

CFriendListView.SEARCH_TAG      = 2001
CFriendListView.ADDSCROLL_TAG   = 3001

function CFriendListView.scene( self )
	local winSize	= CCDirector :sharedDirector() :getVisibleSize()
    local scene		= CCScene :create()

    self :init( winSize, scene)
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup(false)
    end

    scene :addChild( self.m_pContainer)
    return scene
end

function CFriendListView.init( self, _winSize, _layer )
    self :setCurrentType(1)
    
    if self.m_pContainer~=nil then
        self.m_pContainer :removeFromParentAndCleanup(true)
        self.m_pContainer = nil
    end
    
    self.m_pContainer = CContainer :create()
	-- body
    self :loadResources()
    self :initBgAndCloseBtn( _layer,_winSize)
    
    self :initView( _layer)
    
    
    self :requestFriendInfo( 1)
    
    self :registerMyMediator()
    self :layout( _winSize)
    
end

function CFriendListView.loadResources( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("FriendListViewResources/FriendListViewResources.plist") 
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TeamViewResources/TeamViewResources.plist")  --借用淫荡分割线
end

function CFriendListView.initBgAndCloseBtn( self, _layer,_winSize)
    local IpadWidthSize =854
    --底图
    self.m_allBackGroundSprite   = CSprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))
    _layer :addChild(self.m_allBackGroundSprite,-100)

    self.m_ViewContainer = CContainer :create()
    self.m_ViewContainer : setPosition(_winSize.width/2-IpadWidthSize/2,0)
    self.m_ViewContainer : setControlName( "this is CBuildTeamView self.m_buildTeamViewContainer 127")
    _layer :addChild( self.m_ViewContainer, -100)

	--背景
    self.m_pBackground    = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_pBackground    : setControlName("this CFriendListView. self.m_pBackground 36")
    self.m_ViewContainer  : addChild( self.m_pBackground,-2)
    
    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack( eventType, obj, x, y)
    end
    --关闭按钮
    self.m_pCloseBtn     = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn     : setControlName("this CFriendListView. self.m_pCloseBtn 53")
    self.m_pCloseBtn     : registerControlScriptHandler( closeCallBack, "this CFriendListView. self.m_pCloseBtn 45" )
    self.m_ViewContainer : addChild( self.m_pCloseBtn,10)
end

function CFriendListView.registerMyMediator( self)
    require "mediator/FriendListMediator"
    _G.pCFriendListMediator = CFriendListMediator( self)
    controller :registerMediator( _G.pCFriendListMediator)
    print("注册_G.pCFriendListMediator", _G.pCFriendListMediator)
    
end

function CFriendListView.requestFriendInfo( self, _nType)
    _nType = tonumber( _nType)
    print("请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）, _nType==", _nType)
    
    if _nType ~= nil then
        require "common/protocol/auto/REQ_FRIEND_REQUES"
        local msg = REQ_FRIEND_REQUES()
        msg :setType( _nType)
        CNetwork :send( msg)
    end
end

function CFriendListView.unregisterMyMediator( self)
    
    if _G.pCFriendListMediator then
        print("注销_G.pCFriendListMediator", _G.pCFriendListMediator)
        controller :unregisterMediator( _G.pCFriendListMediator)
        _G.pCFriendListMediator = nil
    end
    
end

function CFriendListView.initView( self)
    self.m_hLayout = CHorizontalLayout :create()
    self.m_ViewContainer :addChild( self.m_hLayout, -99)
    self.m_hLayout  :setControlName("this CFriendListView. self.m_hLayout 70")
    self.m_hLayout  :setHorizontalDirection( true)
    self.m_hLayout  :setLineNodeSum( 4)
    
    local function topBtnCallback( eventType, obj, x, y)
        return self :onTopBtnCallback( eventType, obj, x, y)
    end
    local nFontSize = 24
    --好友 最近联系人 黑名单 搜索玩家  按钮
    local szNormolSpr = "general_label_normal.png"
    local szBtnName = "好友"
    self.btnFriend  = CButton :createWithSpriteFrameName( tostring( szBtnName), tostring( szNormolSpr ) )
    self.FriendOnlineLabel = CCLabelTTF : create("好友在线:[0/0]","Arial",18)
    szBtnName = "最近联系"
    local btnContact    = CButton :createWithSpriteFrameName( tostring( szBtnName), tostring( szNormolSpr ) )
    szBtnName = "黑名单"
    --local btnBlackList  = CButton :createWithSpriteFrameName( tostring( szBtnName), "general_label_click.png")
    szBtnName = "搜索玩家"
    local btnSearck     = CButton :createWithSpriteFrameName( tostring( szBtnName), tostring( szNormolSpr ) )
    
    
    
    self.btnFriend :registerControlScriptHandler( topBtnCallback, "this CFriendListView.  self.btnFriend 162" )
    btnContact     :registerControlScriptHandler( topBtnCallback, "this CFriendListView.  btnContact 163" )
    --btnBlackList   :registerControlScriptHandler( topBtnCallback, "this CFriendListView.  btnBlackList 164" )
    btnSearck      :registerControlScriptHandler( topBtnCallback, "this CFriendListView.  btnSearck 165" )
    
    self.btnFriend :setControlName("this CFriendListView. self.btnFriend 147")
    btnContact     :setControlName("this CFriendListView. btnContact 148")
    --btnBlackList   :setControlName("this CFriendListView. btnBlackList 149")
    btnSearck      :setControlName("this CFriendListView. btnSearck 150")

    self.m_hLayout :addChild( self.btnFriend, -99)
    self.btnFriend :addChild(self.FriendOnlineLabel)
    self.m_hLayout :addChild( btnContact, -99)
    --self.m_hLayout :addChild( btnBlackList, -99)
    self.m_hLayout :addChild( btnSearck, -99)
    
    self.btnFriend :setFontSize( nFontSize)
    btnContact     :setFontSize( nFontSize)
    --btnBlackList   :setFontSize( nFontSize)
    btnSearck      :setFontSize( nFontSize)
    
    self.btnFriend :setTag( 1)
    btnContact     :setTag( 2)
    --btnBlackList   :setTag( 3)
    btnSearck      :setTag( 4)
    self.FriendOnlineLabel :setPosition(565,0)
    ---------------------
    self :addHighLightSpr( self.btnFriend )     --默认第一个好友界面
    -- self.m_hBottemLayout = CHorizontalLayout :create()
    -- self.m_pContainer :addChild( self.m_hBottemLayout, -99)
    
    -- self.m_hBottemLayout  :setControlName("this CFriendListView. self.m_hBottemLayout 108")
    -- self.m_hBottemLayout  :setHorizontalDirection( true)
    -- --self.m_hLayout  :setVerticalDirection( false)
    -- self.m_hBottemLayout  :setCellHorizontalSpace( 30)
    -- self.m_hBottemLayout  :setLineNodeSum( 2)
    --左右方向箭头
    -- local btnArrow = {}
    -- for i=1, 2 do
    --     local szSprName = ""
    --     if i==1 then
    --         szSprName = "general_reduce_normal.png"
    --     elseif i==2 then
    --         szSprName = "general_add_normal.png"
    --     end
        
    --     btnArrow[i]    = CButton :createWithSpriteFrameName( "",tostring( szSprName))
    --     btnArrow[i]    :setControlName("this CFriendListView. btnArrow[i] 123"..i)
    --     btnArrow[i]    :setTag( i*10)
    --     btnArrow[i]    :registerControlScriptHandler( topBtnCallback, "this CFriendListView. btnArrow[i] 125" )
    --     self.m_hBottemLayout      :addChild( btnArrow[i], -99)
    -- end
    --编辑按钮
    local function editCallback( eventType, obj, x, y)
        return self :oneditCallback( eventType, obj, x, y)
    end
    self.EditBtn = CButton : createWithSpriteFrameName("编辑","general_button_normal.png")
    self.EditBtn : registerControlScriptHandler( editCallback, "this CFriendListView self.EditBtn 202" )
    self.EditBtn : setFontSize(24)
    self.m_ViewContainer : addChild(self.EditBtn)
    
    --页数
    self.m_pageLabel = CCLabelTTF :create( "0/0", "Arial", 22)
    self.m_pageLabel : setAnchorPoint( ccp(0.0, 0.5))
    self.m_ViewContainer : addChild( self.m_pageLabel, 110)
    --页数背景图
    self.m_pageSprite = CSprite : createWithSpriteFrameName("general_pagination_underframe.png")
    self.m_pageSprite : setPosition(15,14)
    self.m_pageLabel: addChild( self.m_pageSprite, -1)
    
    --第二背景图
    self.m_secBg  = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_secBg  :setControlName("this CFriendListView. self.m_secBg 144")
    self.m_ViewContainer      :addChild( self.m_secBg, -1)
end

function CFriendListView.sortDataByOnline( self, _data )
    
end

--_nType  1 2  3 4
function CFriendListView.initPageScrollView( self, _friendData)
    print("----self.currentType-----",self.currentType)
    if self.m_pScrollView ~= nil then
        self.m_pScrollView :removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
    print("_friendData", _friendData)
    if _friendData == nil then
        --self.btnFriend :setText( "好友(0/0)")
        print("空的")
        --CCMessageBox("无玩家","initPageScrollView")
        return 
    end
    
    --对数据进行排序  在线的排前面
    if _friendData ~= nil  then
        local func = function( lValue, rValue)
            if lValue == nil or rValue == nil then
                return
            end
            if lValue.isonline < rValue.isonline then
                return true
            else
                return false
            end
        end
        table.sort( _friendData, func)
    end
    --[[
    for k, v in pairs( _friendData) do
        --打印排序后的数据
        print("sdfsfsdfs", k, v.fid, v.fname, v.isonline)
    end
    --]]

    local nLineCount = #_friendData
    local nPage      = self :getFriendPages( nLineCount)
    local nnCount    = nLineCount      --有多少条好友信息
    ------
    self.m_pageCount   = nPage
    self.m_currentPage = self.m_pageCount-1         --当前页
    -----
    if nPage <= 0 or nLineCount<=0 then          --如果一行内容都没有 就返回
        print("没有信息", nPage, nLineCount)
        return
    end
    self.m_pageLabel :setString( "1/"..self.m_pageCount)

    
    local nOnlineCount = 0
    if self.m_friendData then
        for k, v in pairs( self.m_friendData) do
            if v.isonline == 1 then
                nOnlineCount = nOnlineCount + 1
            end
        end
        print("在线人数为", nOnlineCount)
        
        local szFriend = "好友在线:["
        if self.m_friendData then
            szFriend = szFriend..nOnlineCount.."/"..#self.m_friendData.."]"
            else
            szFriend = szFriend.."0/0]"
        end
        --self.btnFriend :setText( szFriend )
        self.FriendOnlineLabel : setString(szFriend)
    end
    
    ----------------------
    local function pageCallback( eventType, obj, x, y)
        return self :onPageCallback( eventType, obj, x, y)
    end
    ----------------------
    
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    
    local viewSize = CCSizeMake( 854-20, 480)
    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this CFriendListView. self.m_pScrollView 220")
    self.m_pScrollView :registerControlScriptHandler( pageCallback, "this CFriendListView. self.m_pScrollView 221")
    self.m_ViewContainer : addChild( self.m_pScrollView, 2)
    
    -- local lineHeight = (winSize.height*2/3-10)/5
    -- print("行高＝", lineHeight)
    
    ----------------
    local function friendCallback( eventType, obj, touches )
        return self :onFriendCallback( eventType, obj, touches)
    end
    -----------------
    local function delelteCallback( eventType, obj, touches )
        return self :onDeleteCallback( eventType, obj, touches)
    end
    -----------------
    local function watchCallback( eventType, obj, touches )
        return self :onWatchCallback( eventType, obj, touches)
    end
    -----------------
    
    local _pageContainer = {}               --页容器
    self.reduceBtn       = {}  
    self.ReduceLayout    = {}
    self.tempContainer   = CContainer : create()
    self.thenPage = nPage    

    local nReduceCount = nLineCount
    self.issetVisible  = 0
    for iPage=1, nPage do
        _pageContainer[iPage] = CContainer :create()
        _pageContainer[iPage] :setControlName("this CFriendListView. _pageContainer[i] 166") 
        
        --线条

        local nLineCount = 1
        if self.currentType == 1  or self.currentType == 2  then
            nLineCount = 5
        elseif self.currentType == 4 then
            nLineCount = 4
        end
        for ii=1, nLineCount do
            local hNameLayout = CHorizontalLayout :create()
            _pageContainer[iPage] :addChild( hNameLayout, -99)
            
            hNameLayout  :setControlName("this CFriendListView. hNameLayout 246"..ii)
            hNameLayout  :setHorizontalDirection( true)
            --hNameLayout  :setVerticalDirection( false)
            hNameLayout  :setCellHorizontalSpace( 60)
            hNameLayout  :setLineNodeSum( 2)
            hNameLayout  :setPosition(-90+40, 270+57+10-(ii*96))

            local pLineSpr = CSprite :createWithSpriteFrameName( "team_dividing_line.png")
            hNameLayout    :addChild( pLineSpr, -98)
            pLineSpr :setPreferredSize( CCSizeMake( 854-30, 1 ))
            --pLineSpr :setPosition( winSize.width/2, nLabelY-18)
        end
        
        --内容
        local nCount = 1
        if self.currentType == 1  or self.currentType == 2   then
            nCount = 5
        elseif self.currentType == 4 then
            nCount = 4
        end

        for ii=1, nCount do
            local num = (iPage-1)*5 + nCount
            local hNameLayout = CHorizontalLayout :create()
            _pageContainer[iPage] : addChild( hNameLayout, -99)
            
            hNameLayout  :setControlName("this CFriendListView. hNameLayout 265"..ii)
            hNameLayout  :setHorizontalDirection( true)
            hNameLayout  :setCellHorizontalSpace( 100)
            hNameLayout  :setLineNodeSum( 2)
            if self.currentType == 1 or self.currentType == 2  then
                hNameLayout  :setPosition(-480+100+40, 230+57+8-(ii*96))    
            elseif self.currentType == 4 then
                hNameLayout  :setPosition(-480+100+40, 230+57+8-(ii*96))    
                --hNameLayout  :setPosition(-winSize.width/2+100+40, 230+57+8-96-(ii*96))
            end
            
            
            for iii=1, 2 do
                local szSprName = ""
                if iii==1 then
                    local _fname = "有问题"
                    if _friendData[nnCount].fname ~= nil then
                        _fname = _friendData[nnCount].fname
                    end
                    
                    szSprName = _fname.."               LV ".._friendData[nnCount].flv
                elseif iii==2 then
                    if  _friendData[nnCount].fclan == nil then
                        szSprName = "无社团"
                    else
                        szSprName = _friendData[nnCount].fclan
                    end
                end
                
                
                local  btnFriendName   = CButton :create( tostring(szSprName), "Loading/transparent.png") 
                btnFriendName    :setControlName("this CFriendListView. btnFriendName 123"..iii)
                btnFriendName    :setPreferredSize( CCSizeMake(600, 96))
                btnFriendName    :setFontSize( 18)
                btnFriendName    :setTag( _friendData[nnCount].fid ) -- CFriendListView.SCROLLTAG)
                --btnFriendName.touchID  = nil
                --btnFriendName.touchTime  = nil
                --btnFriendName.btnTag = _friendData[nnCount].fid      --给当前uid作为tag标志
                --btnFriendName.fname  = _friendData[nnCount].fname
                --print("btnFriendName.btnTag", btnFriendName.btnTag)
                if _friendData[nnCount].isonline == 0 then
                    btnFriendName :setColor( ccc4( 150, 150, 150, 255) );
                    --joblabel      :setColor( ccc3( 150, 150, 150) );
                end
                btnFriendName    :setTouchesMode( kCCTouchesAllAtOnce )     --
                btnFriendName    :setTouchesEnabled( true)
                btnFriendName    :setTouchesPriority( btnFriendName :getTouchesPriority()-1)
                btnFriendName    :registerControlScriptHandler( friendCallback, "this CFriendListView. btnFriendName 125" )
                hNameLayout      :addChild( btnFriendName, -99)
                if iii == 2 then
                    print("职业职业---》",_friendData[nnCount].pro)
                    local job      = self : jobChoose(_friendData[nnCount].pro)
                    local joblabel = CCLabelTTF :create("", "Arial", 18)
                    joblabel       : setString(job)
                    joblabel       : setPosition(150,0)
                    
                    if _friendData[nnCount].isonline == 0 then
                        --btnFriendName :setColor( ccc4( 150, 150, 150, 255) );
                        joblabel      :setColor( ccc3( 150, 150, 150) );
                    end
                    
                    btnFriendName  : addChild( joblabel, 10)
                end
            end
            
        ------------------------------------------
            --右边的 - +
            local hAddReduceLayout = CHorizontalLayout :create()
            self.ReduceLayout[num] = CHorizontalLayout :create()          
            _pageContainer[iPage] : addChild( hAddReduceLayout, -99)
            _pageContainer[iPage] : addChild( self.ReduceLayout[num],-98)

            print("iPage====",iPage)
            hAddReduceLayout  :setControlName("this CFriendListView. hAddReduceLayout 108")
            self.ReduceLayout[num] :setControlName("this CFriendListView. ReduceLayout 108")
            hAddReduceLayout  :setHorizontalDirection( true)            
            self.ReduceLayout[num] :setHorizontalDirection( true)
            --hNameLayout  :setVerticalDirection( false)
            hAddReduceLayout  :setCellHorizontalSpace( 20)
            self.ReduceLayout[num] :setCellHorizontalSpace( 20)
            hAddReduceLayout  :setLineNodeSum( 2)
            self.ReduceLayout[num] :setLineNodeSum( 1)
            -- hAddReduceLayout  :setPosition(854/3-80+40, 230+57+8-(ii*96))

            ----------------------------删除好友按钮
            local  szSprLabel = "--- ".." "..nnCount
            local  szSprName  = "friend_delete.png"
            
            self.reduceBtn[nnCount]  = nil
            if self :getCurrentType() == 4 or self :getCurrentType() == 2 then     --如果是4界面
                szSprName   = "friend_add.png"
                self.reduceBtn[nnCount] = CButton :createWithSpriteFrameName( "", tostring(szSprName))
                
            else
                self.reduceBtn[nnCount] = CButton :createWithSpriteFrameName( "", tostring(szSprName))
                
            end
            --reduceBtn    :setTag( CFriendListView.SCROLLTAG)
            self.reduceBtn[nnCount]    :setControlName("this CFriendListView. reduceBtn 355")
            -- self.reduceBtn[nnCount]    :setVisible(false)
            self.reduceBtn[nnCount]    :setFontSize( 23)
            self.reduceBtn[nnCount]    :setTag( _friendData[nnCount].fid) --CFriendListView.SCROLLTAG)
            --reduceBtn.touchID  = nil
            --reduceBtn.touchTime  = nil
            --reduceBtn.btnTag = _friendData[nnCount].fid
            if self.currentType == 1 or self.currentType == 2   then
                hAddReduceLayout       :setPosition(854/3-80+40, 230+57+8-(ii*96))
                self.ReduceLayout[num] :setPosition(854/3-80+40, 230+57+8-(ii*96))
                self.reduceBtn[nnCount]    :setVisible(false)
            elseif self.currentType == 4 then
                -- hAddReduceLayout  :setPosition(854/3+40, 230+57+8-96-(ii*96))
                -- self.ReduceLayout[num] :setPosition(854/3-20, 230+57+8-96-(ii*96))
                hAddReduceLayout       :setPosition(854/3+40, 230+57+8-(ii*96))
                self.ReduceLayout[num] :setPosition(854/3-80+40, 230+57+8-(ii*96))
                self.reduceBtn[nnCount]    :setVisible(true)
            end
            
            self.reduceBtn[nnCount]    :setTouchesMode( kCCTouchesAllAtOnce )     --
            self.reduceBtn[nnCount]    :setTouchesEnabled( true)
            self.reduceBtn[nnCount]    :setTouchesPriority( -20)
            self.reduceBtn[nnCount]    :registerControlScriptHandler( delelteCallback, "this CFriendListView. reduceBtn 333" )
            self.ReduceLayout[num]     :addChild( self.reduceBtn[nnCount], -99)
            
            ----------------------------查看好友信息
            szSprLabel = ">>>"
            szSprName  = "friend_information.png"
            local addBtn    = CButton :createWithSpriteFrameName( "", tostring(szSprName))
            addBtn    :setControlName("this CFriendListView. reduceBtn 355")
            addBtn    :setFontSize( 23)
            addBtn    :setTag( _friendData[nnCount].fid) -- CFriendListView.SCROLLTAG)
            --addBtn.touchID  = nil
            --addBtn.touchTime  = nil
            --addBtn.btnTag = _friendData[nnCount].fid
            addBtn    :setTouchesMode( kCCTouchesAllAtOnce )     --
            addBtn    :setTouchesEnabled( true)
            addBtn    :setTouchesPriority( -1)
            addBtn    :registerControlScriptHandler( watchCallback, "this CFriendListView. addBtn 333" )
            hAddReduceLayout     :addChild( addBtn, -99)
       ------------------------------------------   
            if nnCount <= 1 then
                break
            else
                nnCount = nnCount-1
            end
        end
    end

    for i=nPage, 1, -1 do
        self.m_pScrollView :addPage( _pageContainer[i])
    end

    if nPage <=1 then
        nPage = 1
    end

    self.m_pScrollView :setPage( nPage-1, false)
    ---position
    if winSize.height==640 then
        if self.currentType == 1 or self.currentType == 2   then
            self.m_pScrollView      : setPosition( 10, 80)
        elseif self.currentType == 4 then
            self.m_pScrollView      : setPosition( 10, 80-96)
        end
    elseif winSize.height==768 then
        print("winSize.height==768 507")
    end
    print("更新成功-----------------------------")
end

function  CFriendListView.jobChoose( self, _pro)
    local prostring = CLanguageManager :sharedLanguageManager() :getString("Role_ProName_0" .. tostring( _pro ))
    return prostring
end

function CFriendListView.initParams( self)
    self.m_pageCount = 1
    
    self.m_friendCount = 0
    if _G.pCFriendDataProxy :getInitialized() then
        self.m_friendType   = _G.pCFriendDataProxy :getFriendType()         --类型  1:好友列表  2:最近联系
        print("CFriendListView.initParams", self.m_friendType)
        if self.m_friendType == _G.Constant.CONST_FRIEND_FRIEND then
            self.m_friendData   = _G.pCFriendDataProxy :getFriendData()
            self.m_friendCount  = _G.pCFriendDataProxy :getFriendCount()
        elseif self.m_friendType == _G.Constant.CONST_FRIEND_RECENT then
            self.m_recentlyData = _G.pCFriendDataProxy :getRecentlyData()
            self.m_recentlyCount  = _G.pCFriendDataProxy :getRecentlyCount()
        end
    end
    
    if self.m_friendCount >0  then
        if self.m_friendData == nil then
            print("self.m_friendData", self.m_friendData, self.m_friendCount)
            return
        end
        for k, v in pairs( self.m_friendData) do
            print("self.m_friendData", self.m_friendCount, k, v, #self.m_friendData)
        end
        
        for i=1, self.m_friendCount do
            print("self.m_friendData", self.m_friendData[i].fid, self.m_friendData[i].fname, self.m_friendData[i].fclan, self.m_friendData[i].flv, self.m_friendData[i].isonline)
        end
        self.m_pageCount = self :getFriendPages( self.m_friendCount)     --计算页数
        
    else
        self.m_pageLabel :setString( "1/1")
        return
    end
    print("CFriendListView.initParams", self.m_pageCount, _G.pCFriendDataProxy :getInitialized(), self.m_friendCount)
end

function CFriendListView.layout( self, _winSize)
    local sizeCloseBtn  = self.m_pCloseBtn :getPreferredSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local btnSize       = self.btnFriend :getPreferredSize()
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640  
    
    if winY == 640 then
        self.m_allBackGroundSprite : setPosition(winX/2,winY/2)              --总底图
        self.m_pBackground         : setPreferredSize(CCSizeMake( IpadSizeWidth, IpadSizeheight))
        self.m_pBackground         : setPosition(IpadSizeWidth/2,IpadSizeheight/2)
        self.m_pCloseBtn           : setPosition(ccp( IpadSizeWidth-sizeCloseBtn.width/2, IpadSizeheight-sizeCloseBtn.height/2))
        self.m_hLayout          :setCellHorizontalSpace( 10 )
        self.m_hLayout          :setCellSize(btnSize)
        self.m_hLayout          :setPosition( IpadSizeWidth/10-50, IpadSizeheight-btnSize.height/2-20)
        
        self.EditBtn            :setPosition( 770, 45)
        --self.m_hBottemLayout    :setPosition( winX*8/21, winY/14.2)
        self.m_pageLabel        :setPosition( 410, 45)
        self.isUpOrDown = true
        self.m_secBg            :setPreferredSize( CCSizeMake(IpadSizeWidth-30, 480))--(winX-26, winY*2/3))
        self.m_secBg            :setPosition( IpadSizeWidth/2, IpadSizeheight/2 + 8)
    elseif winY ==768 then
        print("winY ==768 593")
    end
end

--
function CFriendListView.searchBar( self)
    CCLOG("搜索玩家界面的 搜索栏")
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640  
    self :setArrowPosition( false)
    
    self.m_searchContainer = CContainer :create()
    self.m_ViewContainer : addChild( self.m_searchContainer)
    
    self.m_pageLabel :setString("1/1")
    ----查询回调
    local function searchCallback( eventType, obj, x, y)
        return self :onSearchCallback( eventType, obj, x, y)
    end
    
    local _winSize      = CCDirector :sharedDirector() :getVisibleSize()
    local m_bgEditBox   = CCScale9Sprite :createWithSpriteFrameName("transparent.png")
    self.m_ediBox       = CEditBox :create( CCSizeMake( 600, 60), m_bgEditBox, 100, "", kEditBoxInputFlagSensitive)
    self.m_searchContainer :addChild( self.m_ediBox, -97)

    local m_bgEditBoxSprite = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png")
    m_bgEditBoxSprite       : setPreferredSize(CCSizeMake(650,60))
    m_bgEditBoxSprite       : setPosition( IpadSizeWidth/2-80, IpadSizeheight-120)
    self.m_searchContainer  : addChild( m_bgEditBoxSprite, -98)


    --self.m_ediBox       :setPosition( 100, 0)
    self.m_ediBox       :setPosition( IpadSizeWidth/2-50, IpadSizeheight-120)
    self.m_ediBox       :registerControlScriptHandler( searchCallback, "this CFriendListView. self.m_ediBox 416")
    ------
    self.m_beginSearch    = CButton :createWithSpriteFrameName( "搜索","general_button_normal.png")
    local btnSize         = self.m_beginSearch :getPreferredSize()
    self.m_beginSearch    :setPosition( IpadSizeWidth*0.8125+btnSize.width/2, IpadSizeheight-120)
    self.m_beginSearch    :setControlName("this CFriendListView. self.m_beginSearch 394")
    self.m_beginSearch    :setTag( CFriendListView.SEARCH_TAG)
    self.m_beginSearch    :setFontSize( 28)
    self.m_beginSearch    :registerControlScriptHandler( searchCallback, "this CFriendListView. self.m_beginSearch 397" )
    self.m_beginSearch :setGray()
    self.m_searchContainer      :addChild( self.m_beginSearch, -97)
    
    ------
    -- local searchLabel = CCLabelTTF :create( "搜索", "Arial", 28)
    -- searchLabel     :setAnchorPoint( ccp(0.0, 0.5))
    -- searchLabel     :setPosition(IpadSizeWidth*0.155-btnSize.width/2, IpadSizeheight-120 )
    -- self.m_searchContainer :addChild( searchLabel, -97)
    
    --放大镜图标
    local sprBoost  = CSprite :createWithSpriteFrameName("friend_seek.png")
    sprBoost        :setControlName("this CFriendListView. sprBoost 420")
    sprBoost        :setPosition(IpadSizeWidth*0.155-btnSize.width/2-25, IpadSizeheight-120 )
    self.m_searchContainer    :addChild( sprBoost, -97)

end

function CFriendListView.setArrowPosition( self, _bValue)
    if _bValue == self.isUpOrDown then
       --CCMessageBox("相等，不用调整位置", _bValue)
        return 
    end
    self.isUpOrDown = _bValue
    local _winSize      = CCDirector :sharedDirector() :getVisibleSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
   
    local nY = winY/14.2
    
    if _bValue == false then
        nY = winY/5      --箭头上移
    end
    
    --self.m_hBottemLayout    :setPosition( winX*8/21, nY)
    --self.m_pageLabel        :setPosition( winX/2-18, nY)
end

function CFriendListView.setArrowData( self, _bValue)
    self.isUpOrDown = _bValue
end

function CFriendListView.getArrowData( self)
    return self.isUpOrDown
end

function CFriendListView.getFriendPages( self, _nCount )
    --默认页数   --  对行数 进行取余，如果有余数，nRetPage+1
    local everCount = _nCount
    _nCount = tonumber( _nCount)
    if _nCount ~= 0 then
        local nnn = _nCount%5
        if nnn > 0 then
            _nCount = math.modf(_nCount/5) + 1
        else    
            _nCount = _nCount/5
        end
    else
        _nCount = 1
    end
    
    print("默认页数=", _nCount, everCount)
    return tonumber(_nCount)
end


----------callback

function CFriendListView.oneditCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        print("编辑按钮回调回调回调", self.issetVisible, self.reduceBtn, self.m_recentlyData, self.m_friendType )
        --[[
        local no =tonumber(self.thenPage)*5 
        if no ~= nil and no > 0 then
            for i=1,no do
                print("---->>>---",self.reduceBtn[i])
                if self.reduceBtn[i] ~= nil then
                    print("---->>>---",i)
                    self.reduceBtn[i] : setVisible( false )
                end
            end
        end
        --]]
        if self.m_recentlyData == nil and self.m_friendType == _G.Constant.CONST_FRIEND_RECENT then
            return true
        end
        print("asdadadasd")
        if self.issetVisible  == 1 then
            if self.reduceBtn ~= nil then
                for key, value in pairs( self.reduceBtn) do
                    if value ~= nil then
                        value :setVisible( false)
                    end
                end
                self.issetVisible = 0
            end
        elseif self.issetVisible  == 0 then
            if self.reduceBtn ~= nil then
                for key, value in pairs( self.reduceBtn) do
                    if value ~= nil then
                        value :setVisible( true )
                    end
                end
                self.issetVisible = 1
            end
        end
    end
end

function CFriendListView.onCloseCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        
        self :unregisterMyMediator()
        if self.m_clickSpr ~= nil then
            self.m_clickSpr :removeFromParentAndCleanup( true )
            self.m_clickSpr = nil
        end
        
        if self.m_searchContainer ~= nil then
            self.m_searchContainer :removeFromParentAndCleanup( true)
            self.m_searchContainer = nil
        end
        if self.m_pScrollView ~= nil then
            self.m_pScrollView :removeFromParentAndCleanup( true)
            self.m_pScrollView = nil
        end
        if self.m_pContainer then
            self.m_pContainer :removeFromParentAndCleanup( true)
            self.m_pContainer = nil
        end
        
        CCLOG("关闭好友界面")
        CCDirector :sharedDirector() :popScene()
        return true
    end
end

function CFriendListView.addHighLightSpr( self, _obj )
    if _obj ~= nil then
        if self.m_clickSpr ~= nil then
            self.m_clickSpr :removeFromParentAndCleanup( true )
            self.m_clickSpr = nil
        end
        
        local nTag      = _obj :getTag()
        local szLabel   = nil
        
        if nTag == 1 then           
            szLabel = "好友"
        elseif nTag == 2 then       --
            szLabel = "最近联系"
        elseif nTag == 4 then       --
            szLabel = "搜索玩家"
        end
        
        local szSprName = "general_label_click.png"
        self.m_clickSpr = CSprite :createWithSpriteFrameName( tostring( szSprName ) )
        _obj :addChild( self.m_clickSpr, 10 )
        
        if szLabel ~= nil then
            local _pLabel = CCLabelTTF :create( szLabel, "Arial", 24 )
            self.m_clickSpr :addChild( _pLabel, 15 )
        end
    end
end

function CFriendListView.onTopBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        local nI = tonumber(obj:getTag())
        local szBtnName = nil
        
        local isAddOrReduce = false
        if nI < 10 then
            
            self :setArrowPosition( true)
            
            if self.m_searchContainer ~= nil then
                self.m_searchContainer :removeFromParentAndCleanup( true)
                self.m_searchContainer = nil
            end
            
            if nI==1 then
                szBtnName = "好友()"
                self :requestFriendInfo(1)
            elseif nI==2 then
                szBtnName = "最近联系人"
                self :requestFriendInfo(2)
            elseif nI==3 then
                szBtnName = "黑名单"
            elseif nI==4 then
                szBtnName = "搜索玩家"
                self :searchBar()
            end
            
            self :setCurrentType( nI)
            --
            if self.m_pageCount and self.m_pageCount > 0 and self :getCurrentType() ~= 4 then
                self :initPageScrollView( self.m_friendData)
            else
                self :initPageScrollView( nil)
            end
             --]]
        elseif nI==10 then
            szBtnName = "减"
            if self.m_currentPage > 1 then
                isAddOrReduce   = true      --说明进行了运算
                self.m_currentPage = self.m_currentPage -1
            end
        elseif nI==20 then
            szBtnName = "加"
            if self.m_currentPage < self.m_pageCount then
                isAddOrReduce   = true     --说明进行了运算
                self.m_currentPage = self.m_currentPage +1
            end
        end
        if  self.m_pScrollView ~= nil and isAddOrReduce== true then
            self.m_pScrollView :setPage( self.m_pageCount-self.m_currentPage, false)
            self.m_pageLabel :setString( self.m_currentPage.."/"..self.m_pageCount)
        end
        print( szBtnName, nI, self.m_currentPage, self.m_pageCount, isAddOrReduce)

        local IpadSizeWidth  = 854
        local IpadSizeheight = 640 
        if nI == 1 or nI == 2 then 
            self.m_secBg : setPreferredSize( CCSizeMake(IpadSizeWidth-30, 480))--(winX-26, winY*2/3))
            self.m_secBg : setPosition( IpadSizeWidth/2, IpadSizeheight/2 + 8)
            self.EditBtn : setVisible(true)
            --self.m_pScrollView : setPosition( 10, 80)
        elseif nI == 4 then
            self.m_secBg : setPreferredSize( CCSizeMake(IpadSizeWidth-30, 384))--(winX-26, winY*2/3))
            self.m_secBg : setPosition( IpadSizeWidth/2, IpadSizeheight/2-46 + 8)
            self.EditBtn : setVisible(false)
            --self.m_pScrollView : setPosition( 10, 80-96)
        end
        
        --添加高亮选项
        self :addHighLightSpr( obj )
        if true then
            return
        end

    end
end
---
function CFriendListView.onFriendCallback( self, eventType, obj, touches)
    if eventType == "TouchesBegan" then
        --删除Tips
        --_G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchFId = obj :getTag()
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
            if touch2:getID() == self.touchID and self.touchFId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local nRequestId = obj :getTag()
                    
                    print("察看信息 FriendCallback id=", nRequestId, obj)
                    local szName = nil
                    if self.m_friendData then
                        for k, v in pairs( self.m_friendData) do
                            if tonumber(v.fid) == nRequestId then
                                print("v.fname", v.fid, v.fname)
                                szName = v.fname
                                break
                            end
                        end
                    end
                    
                    if szName == nil or nRequestId==nil then
                        --CCMessageBox("没有该id对应的名字，查查看", nRequestId)
                        return 
                    end
                    print("进入私聊界面", nRequestId, szName)
                    
                    local _wayCommand = CFriendOpenChatCommand( szName)
                    controller:sendCommand(_wayCommand)
                    
                    self.touchID     = nil
                    self.touchFId = nil
                    break
                end
            end
        end
        print( eventType,"END")
    end
    --[[
     if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() == CFriendListView.SCROLLTAG then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR( ccp(touchPoint.x, touchPoint.y))) then
                    obj.touchID = touch :getID()
                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if obj.touchID == nil then
            return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == obj.touchID then
                --check distance
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local nRequestId = obj.btnTag
                    local fname      = obj.fname
                    print("进入私聊界面", nRequestId, fname)
                    
                    local _wayCommand = CFriendOpenChatCommand( fname)
                    controller:sendCommand(_wayCommand)
                   
                    break
                end
            end
        end
        obj.touchID = nil
    end
     --]]
end

--删除用户
function CFriendListView.onDeleteCallback( self, eventType, obj, touches)
    if eventType == "TouchesBegan" then
            --删除Tips
            --_G.g_PopupView :reset()
            local touchesCount = touches:count()
            for i=1, touchesCount do
                local touch = touches :at( i - 1 )
                    local touchPoint = touch :getLocation()
                    if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                        self.touchID     = touch :getID()
                        self.deleteID = obj :getTag()
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
                if touch2:getID() == self.touchID and self.deleteID == obj :getTag() then
                    local touch2Point = touch2 :getLocation()
                    if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                        local nRequestId = obj :getTag()
                        
                        if self :getCurrentType() == 4 or self :getCurrentType() == 2 then
                            local sendList = {}
                            sendList[1] = nRequestId
                            require "common/protocol/auto/REQ_FRIEND_ADD"
                            local msg = REQ_FRIEND_ADD()
                            msg :setType( 1)
                            msg :setCount( 1)
                            msg :setDetail( sendList)
                            CNetwork :send( msg)
                            print("搜索界面 添加好友 id=", nRequestId, obj :getTag())
                            
                        else
                            local function ensurebtnCallBack( )
                                require "common/protocol/auto/REQ_FRIEND_DEL"
                                local msg = REQ_FRIEND_DEL()
                                
                                msg :setFid( nRequestId)
                                msg :setType( self: getCurrentType())
                                CNetwork :send( msg)
                                --CCMessageBox("删除好友成功", nRequestId)
                                local msg = "删除好友成功"
                                self : createMessageBox(msg)
                            end
                        
                            local l_popTips = CPopTips()
                            local popDelTips = l_popTips :create(ensurebtnCallBack, "确认删除该好友吗", 0)
                        
                            self.m_pContainer :addChild( popDelTips)
                            print("其他界面 删除好友 id=", nRequestId, obj :getTag(), self:getCurrentType())
                        end

                        self.touchID     = nil
                        self.deleteID = nil
                        break
                    end
                end
            end
            print( eventType,"END")
    end
end

--察看用户信息
function CFriendListView.onWatchCallback( self, eventType, obj, touches)
    if eventType == "TouchesBegan" then
        --删除Tips
        --_G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchFriendId = obj :getTag()
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
                if touch2:getID() == self.touchID and self.touchFriendId == obj :getTag() then
                    local touch2Point = touch2 :getLocation()
                    if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                        local nRequestId = obj :getTag()
                        
                        print("察看信息 id1111=", nRequestId, obj)
                        -- CCMessageBox("需要跳到人物信息","好友信息")

                        print("请求玩家身上装备开始")
                        local msg = REQ_GOODS_EQUIP_ASK()
                        msg :setUid( nRequestId )
                        msg :setPartner( 0 )
                        _G.CNetwork :send( msg )
                        print("请求玩家身上装备结束")

                        print("请求玩家属性开始:"..nRequestId)
                        local msg_role = REQ_ROLE_PROPERTY()
                        msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
                        msg_role: setUid( nRequestId )
                        msg_role: setType( 0 )
                        _G.CNetwork : send( msg_role )
                        
                        self.touchID     = nil
                        self.touchFriendId = nil
                    break
                end
            end
        end
        print( eventType,"END")
    end
    
end

function CFriendListView.onPageCallback( self, eventType, obj, x, y)
    --print("onPageCallback", eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print("currentPage", currentPage, self.m_currentPage, self.m_pageCount)
        if currentPage ~= self.m_currentPage then
            self.m_currentPage = self.m_pageCount-currentPage
            self.m_pageLabel :setString( self.m_currentPage.."/"..self.m_pageCount)
        end
    end
 
end

function CFriendListView.onSearchCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "EditBoxReturn" then
        local szSearchName = tostring( self.m_ediBox :getTextString())
        if szSearchName ~= "" then          -- (手动) -- [4050]查找好友 -- 好友
            self.m_beginSearch :setTouchesEnabled(true)
            self.m_ediBox :setTextString(szSearchName)
        else
            self.m_beginSearch :setTouchesEnabled(false)
        end
        
    elseif eventType == "TouchEnded" then
        
        if self.m_ediBox then
            local szSearchName = tostring( self.m_ediBox :getTextString())
            print("onSearchCallback发送名字请求==", szSearchName)
            
            if szSearchName ~= "" then          -- (手动) -- [4050]查找好友 -- 好友
                require "common/protocol/auto/REQ_FRIEND_SEARCH_ADD"
                local msg = REQ_FRIEND_SEARCH_ADD()
                msg :setFuname( szSearchName)
                CNetwork :send( msg)
            else
                self.m_beginSearch :setTouchesEnabled(false)
            end
        end
        
        return true
    end
end
-----

--设置搜索界面
function CFriendListView.setSearchView( self, _vo_data)
    print("CFriendListView.setSearchView 数量", _vo_data:getSearchCount() )
    --self :initPageScrollView( nil)
    if _vo_data :getSearchCount() >0 then
        self.searchData = _vo_data :getSearchData()
        self :initPageScrollView( self.searchData)
    else
        self :initPageScrollView( nil)
    end
    
    
end

function CFriendListView.setFriendView( self)
    self :initParams()

    print("跳转到1界面", self.m_friendType)
    self :setCurrentType( self.m_friendType)
    if self.m_friendData and self.m_friendType == _G.Constant.CONST_FRIEND_FRIEND then
        local nOnlineCount = 0
        if self.m_friendData then
            for k, v in pairs( self.m_friendData) do
                if v.isonline == 1 then
                    nOnlineCount = nOnlineCount + 1
                end
            end
            print("在线人数为", nOnlineCount)
            self :initPageScrollView( self.m_friendData)
            
            local szFriend = "好友在线:["
            if self.m_friendData then
                szFriend = szFriend..nOnlineCount.."/"..#self.m_friendData.."]"
            else
                szFriend = szFriend.."0/0]"
            end
            --self.btnFriend :setText( szFriend)
            self.FriendOnlineLabel : setString(szFriend)
        end
        self :addHighLightSpr( self.btnFriend )
        
    elseif self.m_friendType == _G.Constant.CONST_FRIEND_RECENT then
        if self.m_recentlyData then
            --CCMessageBox("self.m_recentlyData", #self.m_recentlyData)
            self :initPageScrollView( self.m_recentlyData)
        else
            self :initPageScrollView( nil)
        end
    elseif self.m_friendData and self.m_friendType == 3 then
        
    end
    
    print("self.m_friendDataself.m_friendData", self.m_friendData, self.m_friendType, _G.Constant.CONST_FRIEND_FRIEND, _G.Constant.CONST_FRIEND_RECENT)
    self :setArrowPosition( true)
    
    if self.m_searchContainer then
        self.m_searchContainer :removeFromParentAndCleanup( true)
        self.m_searchContainer = nil
    end
end

--删除好友 或者最近联系人 根据type
function CFriendListView.delFreindByType( self, _id, _table )
    if _id and _table then
        for k, v in pairs( _table) do
            if tonumber( v.fid) == tonumber( _id) then
                table.remove( _table, k)
                print("删除的位置及id", k, _id, #_table)
                
                if #_table==0 then
                    self :initPageScrollView( nil)
                    return
                end
            end
        end
    end
end

function CFriendListView.setDelView( self, _vo_data)
    local delId = _vo_data :getDelFid()
    print("delId",  delId)
    
    
    local tempTabel = nil
    if self :getCurrentType() == 1 then 
        if self.m_friendData ~= nil then
            self :delFreindByType( delId, self.m_friendData )
            tempTabel = self.m_friendData
        end
    elseif self :getCurrentType() == 2 then
        if self.m_recentlyData ~= nil then
            self :delFreindByType( delId, self.m_recentlyData )
            tempTabel = self.m_recentlyData
        end
    end
    
    self :initPageScrollView( tempTabel )
end

function CFriendListView.setRecentlyView( self)
  -- CCMessageBox("最近联系人界面", nil)
  CCLOG("最近联系人界面")
end



function CFriendListView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end

