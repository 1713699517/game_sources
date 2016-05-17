--------vip显示界面
require "view/view"
require "controller/VipUICommand"
require "model/VO_VipUIModel"

CVipUI = class( view, function( self)
     CCLOG("CVipUI构造")
               
     self.m_winSize = CCSizeMake( 854.0, 640.0 )
    
     local mainProperty = _G.g_characterProperty : getMainPlay()
     if mainProperty ~= nil then
        self.m_nVipLv = mainProperty :getVipLv() or 0
     end
     print( "self.m_nVipLv ", self.m_nVipLv )
end)

local labelColor = ccc3( 255, 255, 255 )

--初始化界面
function CVipUI.init( self, _winSize, _layer )
    print("CVipUI.init begin")
	self :loadResources()
	self :initParams()                              --初始化参数
	self :initBgAndCloseBtn( _winSize, _layer )               --初始化背景及关闭按钮
	self :initView( _winSize, _layer)               --初始化界面
    
    self :addPageScrollView()                       --滑动界面
    self :addMediator()
	self :layout()                        --布局
end

function CVipUI.addMediator( self)
    require "mediator/VipDataMediator"
    self :removeMediator()
    
    _G.pVipDataMediator = CVipDataMediator( self)
    controller :registerMediator( _G.pVipDataMediator)
    
    require "common/protocol/auto/REQ_ROLE_VIP_MY"
    local msg = REQ_ROLE_VIP_MY()
    CNetwork :send( msg)
end

function CVipUI.removeMediator( self)
    if _G.pVipDataMediator then
        controller :unregisterMediator( _G.pVipDataMediator)
        _G.pVipDataMediator = nil
    end
end

function CVipUI.loadResources( self )
    _G.Config :load( "config/vip.xml")
    _G.Config :load( "config/vip_show.xml")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ActivenessResources/ActivenessResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TreasureHouseResource/TreasureHouseResource.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CVipUI.unloadResources(self)
    _G.Config :unload( "config/vip_show.xml")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ActivenessResources/ActivenessResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TreasureHouseResource/TreasureHouseResource.plist")
    -- CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("CharacterPanelResources/RoleResurece.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("ActivenessResources/ActivenessResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("TreasureHouseResource/TreasureHouseResource.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("Shop/ShopReSources.pvr.ccz")

    _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
    self.m_createResStrList = {}
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CVipUI.initParams( self )

    self.m_createResStrList = {}

	self.m_pContainer  = CContainer :create()
end

function CVipUI.initBgAndCloseBtn( self, _winSize, _layer )
	
    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack( eventType, obj, x, y)
    end
    
    local _sprBg = CSprite :createWithSpriteFrameName( "peneral_background.jpg" )
    _layer :addChild( _sprBg, -100 )
    _sprBg :setPreferredSize( _winSize )
    _sprBg :setPosition( _winSize.width / 2, _winSize.height / 2 )
    
    --背景
    self.m_pBackground 	= CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_pBackground  :setControlName("this CVipUI. self.m_pBackground 228")
    self.m_pContainer 	:addChild( self.m_pBackground, -100 )
    ----第二层背景上
    self.m_pUpBg        = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_pUpBg        :setControlName("this CVipUI. self.m_pUpBg 75")
    self.m_pContainer 	:addChild( self.m_pUpBg, -100 )
    ----第二层背景下
    self.m_pSecBg       = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_pSecBg       :setControlName("this CVipUI. self.m_pSecBg 80")
    self.m_pContainer 	:addChild( self.m_pSecBg, -100 )
    
    --关闭按钮--
    self.m_pCloseBtn 	= CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CVipUI. self.m_pCloseBtn 236")
    self.m_pCloseBtn 	:registerControlScriptHandler( closeCallBack, "this CVipUI. self.m_pCloseBtn 237" )
    self.m_pContainer	:addChild( self.m_pCloseBtn, -99)
    self.m_pCloseBtn 	:setTouchesPriority( self.m_pCloseBtn :getTouchesPriority() -2)
    
    local winX          = _winSize.width
    local winY          = _winSize.height
    
    self.m_pBackground  :setPreferredSize( self.m_winSize )
    self.m_pUpBgSize    = CCSizeMake( self.m_winSize.width * 0.96252, self.m_winSize.height * 0.334375 )
    self.m_pUpBg        :setPreferredSize( self.m_pUpBgSize )
    
    self.m_pSecBgSize   = CCSizeMake( self.m_winSize.width * 0.96252, self.m_winSize.height * 0.59688 )
    self.m_pSecBg       :setPreferredSize( self.m_pSecBgSize )
    
    self.m_vipContainer = self :createVipViewByLv( self.m_nVipLv )
    self.m_pContainer   :addChild( self.m_vipContainer, -99 )
    
    --背景条
    self.m_activenessBg = CSprite :createWithSpriteFrameName("active_exp_underframe.png", CCRectMake( 45,0,1,26 ))
    self.m_activenessBg : setControlName( "this CActivenessView self.m_activenessBg 39 ")
	self.m_activenessBg : setPreferredSize( CCSizeMake( 481, 25 ) )
    self.m_activenessBgSize = self.m_activenessBg :getPreferredSize()
    self.m_pContainer   :addChild( self.m_activenessBg, -99 )
    
    --vip经验条
    self.m_activenessSpr = CSprite : createWithSpriteFrameName( "active_exp_frame.png", CCRectMake( 11,0,2,16 ) )
    self.m_activenessSprSize = CCSizeMake( self.m_activenessBgSize.width - 13 , self.m_activenessBgSize.height - 8 )
    self.m_activenessSpr     :setAnchorPoint( ccp( 0.0, 0.5 ) )
    self.m_activenessSpr     :setVisible( false )
    self.m_activenessSpr     :setPreferredSize( self.m_activenessSprSize )
    self.m_pContainer    :addChild( self.m_activenessSpr )
end

function CVipUI.layout( self )
    local _winSize      = CCDirector:sharedDirector():getVisibleSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    
    local sizeBg   		= self.m_pBackground :getPreferredSize()
    local sizeCloseBtn  = self.m_pCloseBtn :getPreferredSize()
    local sizeSec       = self.m_pSecBg    :getPreferredSize()
    
    self.m_pBackground  :setPosition( ccp( winX / 2, winY / 2) )
    self.m_pUpBg        :setPosition( ccp( winX / 2, self.m_pUpBgSize.height / 2 + self.m_pSecBgSize.height + 20 ) )
    self.m_pSecBg       :setPosition( ccp( winX / 2, self.m_pSecBgSize.height / 2 + 15 ))
    self.m_pCloseBtn    :setPosition( ccp( (winX+sizeBg.width-sizeCloseBtn.width)/2, (winY+sizeBg.height-sizeCloseBtn.height)/2))
    self.m_vipContainer :setPosition( ccp( winX / 2, self.m_pUpBgSize.height * 0.8 + self.m_pSecBgSize.height + 20 ) )
    
    self.m_activenessBg :setPosition( ccp( winX / 2, self.m_pUpBgSize.height * 0.6 + self.m_pSecBgSize.height + 20 ) )
    self.m_activenessSpr :setPosition( ccp( winX / 2 - self.m_activenessBgSize.width / 2  , self.m_pUpBgSize.height * 0.6 + self.m_pSecBgSize.height + 20 ) )
    
    self.m_hArrowLayout :setPosition( ( winX - self.m_winSize.width ) * 0.5, self.m_pSecBgSize.height * 0.62 )
    self.m_pageLabel    :setPosition( winX/2-18, winY/14.2 )
    self.m_pageSpr      :setPosition( winX/2, winY/14.2 )
    
    
    ----------
    if winY == 640 then
    elseif winY == 768 then
    end
    ----------
end

--{vip等级}
function CVipUI.createVipViewByLv( self, _vipLv )
    
    local vipcontainer  = CContainer :create()
    vipcontainer :setControlName( "this is CVipUI. createVipView CContainer")
    if _vipLv ~= nil then
        local _vipname      = CSprite :createWithSpriteFrameName( "role_vip.png")
        vipcontainer :addChild( _vipname )
        local viplv  = tostring( _vipLv )
        local length = string.len( viplv )
        
        --角色头像部分
        local _vipLayout     = CHorizontalLayout :create()
        local cellButtonSize = CCSizeMake( 15,30)
        _vipLayout :setVerticalDirection(false)
        --_vipLayout :setCellHorizontalSpace()
        _vipLayout :setLineNodeSum( length)
        _vipLayout :setCellSize( cellButtonSize)
        local vipnameSize  = _vipname :getPreferredSize()
        _vipLayout :setPosition( vipnameSize.width / 2 + 5, 0 )
        
        print( "WWWWWWW:",viplv )
        for i=1, length do
            print( "WWWWWWW:", "role_vip_0".. string.sub( viplv, i, i ).. ".png" )
            local _tempvip = CSprite :createWithSpriteFrameName( "role_vip_0".. string.sub( viplv, i, i ) ..".png")
            _vipLayout :addChild( _tempvip)
        end
        vipcontainer :addChild( _vipLayout)
    end
    return vipcontainer
end

--{下面的 左右箭头按钮}
function CVipUI.addArrowBtn( self)
    local function arrowBtnCallback( eventType, obj, x, y)
        return self :onArrowBtnCallback( eventType, obj, x, y)
    end
    
    self.m_hArrowLayout = CHorizontalLayout :create()
    self.m_pContainer :addChild( self.m_hArrowLayout, -99)
    
    self.m_hArrowLayout  :setControlName("this CVipUI. self.m_hArrowLayout 108")
    self.m_hArrowLayout  :setHorizontalDirection( true)
    --self.m_hLayout  :setVerticalDirection( false)
    self.m_hArrowLayout  :setCellHorizontalSpace( self.m_winSize.width * 0.765 )
    self.m_hArrowLayout  :setLineNodeSum( 2)
    --左右方向箭头

    for i=1, 2 do
        local szSprName = ""
        if i==1 then
            szSprName = "hidden_arrow_left.png"
        elseif i==2 then
            szSprName = "hidden_arrow_right.png"
        end
        
        if szSprName =="" then
            error("szSprName=空", szSprName)
            return
        end
        local btnArrow  = CButton :createWithSpriteFrameName( "", tostring( szSprName))
        --btnArrow :setPosition( ccp( -self.m_winSize.width / 2, 0 ) )
        btnArrow        :setControlName("this CVipUI. btnArrow[i] 123"..i)
        btnArrow        :setTag( i*10)
        btnArrow        :registerControlScriptHandler( arrowBtnCallback, "this CVipUI. btnArrow[i] 125" )
        self.m_hArrowLayout  :addChild( btnArrow, -99)
    end
    
    --页数底框
    self.m_pageSpr    = CSprite :createWithSpriteFrameName( "hidden_pagination_underframe.png", CCRectMake( 28, 0, 1, 31) )
    self.m_pageSpr    :setPreferredSize( CCSizeMake( 100, 35 ) )
    self.m_pContainer :addChild( self.m_pageSpr, -99 )
    --页数 文字
    self.m_pageLabel = CCLabelTTF :create( "0".."/".."0", "Arial", 22)
    self.m_pageLabel :setAnchorPoint( ccp(0.0, 0.5))
    self.m_pContainer :addChild( self.m_pageLabel, 10)
    
end

function CVipUI.addPageScrollView( self)
    if self.m_pScrollView ~= nil then
        self.m_pScrollView :removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
    
    local nPage         = 14
    self.m_pageCount    = nPage           --所有页数
    self.m_currentPage  = 1         --当前页数
    
    if nPage <=0 then
        print(" 页数为0", nPage)
        self.m_pageLabel :setString( "1/1")
        return
    end
        
    self.m_pageLabel :setString( "1/"..self.m_pageCount)
    
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local viewSize   = self.m_pSecBgSize
    viewSize = CCSizeMake( viewSize.width - 100, viewSize.height - 100 )
                           
    local function pageCallback( eventType, obj, x, y)
      return self :onPageCallback( eventType, obj, x, y)
    end
    self.m_pScrollView = CPageScrollView :create( 2, viewSize)
    self.m_pScrollView :setControlName("this CVipUI. self.m_pScrollView 220")
    self.m_pScrollView :registerControlScriptHandler( pageCallback, "this CVipUI. self.m_pScrollView 221")
    self.m_pContainer  :addChild( self.m_pScrollView)
    
    print("viewSize.", viewSize.width, viewSize.height )
                                              
    ---内容
    local _pageContainer = {}
    for iPage=1, nPage do
        
        _pageContainer[iPage] = CContainer :create()
        _pageContainer[iPage] :setControlName("this CVipUI. _pageContainer[i] 166")
                                              
        
        local _vipLvContainer = self :createVipViewByLv( tonumber( iPage ) )
        _pageContainer[iPage]  :addChild( _vipLvContainer )
        local whiteSpace = "              "  --空格
        if iPage >= 10 then
            whiteSpace = whiteSpace .. "  "
        end
        _vipLvContainer        :setPosition( ccp( -265 , winSize.height / 5.2 ) )
        --读取vip.xml
        local vipNode = _G.Config.vips : selectSingleNode( "vip[@lv="..tostring( iPage ).."]" )
        --print("vip.xml-->", "vip[@lv="..tostring( iPage ).."]")
        if vipNode:isEmpty() then
            print("vipNode==nil", iPage)
          --CCMessageBox("vipNode==nil", iPage)
          --self : createMessageBox(iPage)
          return
        end

        print("vipNode:getAttribute(lv)", vipNode:getAttribute("lv"), vipNode:getAttribute("sub_rmb"))

        local vLayout = CVerticalLayout :create()
        _pageContainer[iPage] :addChild( vLayout, -97)
        vLayout :setCellSize( CCSizeMake( viewSize.width, viewSize.height/10))
        vLayout :setControlName("this CVipUI. vLayout 189")
        vLayout :setVerticalDirection( false)
        vLayout :setHorizontalDirection( true)
        vLayout :setLineNodeSum( 1)
        vLayout :setColumnNodeSum( 12)
        vLayout :setCellVerticalSpace( 1)
        vLayout :setCellHorizontalSpace( 0)                                     
        vLayout :setPosition( 20 , winSize.height / 4.7)
    
        local szVipLv       = "升级".. whiteSpace .."  即可享受以下特权"
        local szStrength    = ""
        local szSpacial     = ""
        local szAgate       = ""
        local szGold        = ""
        local szDevils      = ""
        local szTask        = ""
        local szRenown      = ""
        local sz8Label      = ""        --第8行
    
        local vip_show_node = _G.Config.vip_shows : selectSingleNode( "vip_show[@lv="..tostring( iPage ).."]" )
        local szLv = vip_show_node:getAttribute("lv")
        local szVipSum = vip_show_node:getAttribute("sum")
        local nVipSum  = tonumber( szVipSum)
    
        for iXml=1, nVipSum do
            local szXmlId = szLv.."_"..iXml
            --print("szXmlId==", szXmlId)
            
            local vipShowXmlInfo = _G.Config.vip_shows : selectSingleNode( "vip_show[@id="..tostring( szXmlId ).."]" )
            if vipShowXmlInfo:isEmpty() then
                print("查看vip配置表"..szXmlId)
                --CCMessageBox( "查看vip配置表", szXmlId )
                --self : createMessageBox("查看vip配置表"..szXmlId )
                break
            end
            local l_begin         = ""
            local l_mid_1         = ""
            local l_mid_1_word    = ""
            local l_mid_2         = ""
            local l_end           = ""
            local vipInf_a = vipShowXmlInfo:children():get(0,"a")
            if not vipInf_a:isEmpty() then

                l_end      = vipInf_a:getAttribute("end")
                l_begin    = vipInf_a:getAttribute("begin")
                l_mid_1      = vipInf_a:getAttribute("mid_1")
                l_mid_1_word = vipInf_a:getAttribute("mid_1_word")
                l_mid_2      = vipInf_a:getAttribute("mid_2")

                --print("vipShow----------------------->", l_begin, l_mid_1, l_mid_1_word, l_mid_2, l_end)

            end
            
            local sz_begin        = ""
            local sz_mid_1        = ""
            local sz_mid_1_word   = ""
            local sz_mid_2        = ""
            local sz_end          = ""
            
            if l_begin ~= "-1" then
                sz_begin          = l_begin
            end
            
                                                                          
            if l_mid_1 ~= "-1" then
                --print("l_mid_1l_mid_1", l_mid_1, vipNode:getAttribute(l_mid_1))
                if vipNode:getAttribute(l_mid_1) ~= nil then
                    sz_mid_1          = vipNode:getAttribute(l_mid_1)
                end
            end
            
            if l_mid_1_word ~= "-1" then
                sz_mid_1_word     = l_mid_1_word
            end
            
            if l_mid_2 ~= "-1" then
                --print("l_mid_2l_mid_2", l_mid_2, vipNode:getAttribute( l_mid_2))
                if vipNode:getAttribute(l_mid_2) ~= nil then
                    sz_mid_2          = vipNode:getAttribute(l_mid_2)
                end
            end
            
            if l_end ~= "-1" then
                sz_end     = l_end
            end
                
            local szWord = sz_begin..sz_mid_1..sz_mid_1_word..sz_mid_2..sz_end
            --print("具体begin", sz_begin, sz_mid_1, sz_mid_1_word, sz_mid_2, sz_end,  " 最终::",szWord)
            
            
            if iXml<=1 then
                szStrength    = "1、"..szWord
            elseif iXml ==2 then
                szSpacial     = "2、"..szWord
            elseif iXml ==3 then
                szAgate       = "3、"..szWord
            elseif iXml ==4 then
                szGold        = "4、"..szWord
            elseif iXml ==5 then
                szDevils      = "5、"..szWord
            elseif iXml ==6 then
                szTask        = "6、"..szWord
            elseif iXml ==7 then
                szRenown      = "7、"..szWord
            elseif iXml >=8 then
                sz8Label      = "8、"..szWord
            end
        end
    
        local pVipLabel     = CCLabelTTF :create( szVipLv, "Arial", 22)
        local pStrengthLabel= CCLabelTTF :create( szStrength, "Arial", 22)
        local pSpacialLabel = CCLabelTTF :create( szSpacial, "Arial", 22)
        local pAgateLabel   = CCLabelTTF :create( szAgate, "Arial", 22)
        local pGoldLabel    = CCLabelTTF :create( szGold, "Arial", 22)
        local pDevilsLabel  = CCLabelTTF :create( szDevils, "Arial", 22)
        local pTaskLabel    = CCLabelTTF :create( szTask, "Arial", 22)
        local pRenownLabel  = CCLabelTTF :create( szRenown, "Arial", 22)
        local p8Label       = CCLabelTTF :create( sz8Label, "Arial", 22)
    
        local color = ccc3( 255, 255, 255 )
        pVipLabel :setColor( color )
        pStrengthLabel :setColor( color )
        pSpacialLabel :setColor( color )
        pAgateLabel :setColor( color )
        pGoldLabel :setColor( color )
        pDevilsLabel :setColor( color )
        pTaskLabel :setColor( color )
        pRenownLabel :setColor( color )
        p8Label :setColor( color )
    
        pVipLabel       :setAnchorPoint( ccp(0.0, 0.5))
        pStrengthLabel  :setAnchorPoint( ccp(0.0, 0.5))
        pSpacialLabel   :setAnchorPoint( ccp(0.0, 0.5))
        pAgateLabel     :setAnchorPoint( ccp(0.0, 0.5))
        pGoldLabel      :setAnchorPoint( ccp(0.0, 0.5))
        pDevilsLabel    :setAnchorPoint( ccp(0.0, 0.5))
        pTaskLabel      :setAnchorPoint( ccp(0.0, 0.5))
        pRenownLabel    :setAnchorPoint( ccp(0.0, 0.5))
        p8Label         :setAnchorPoint( ccp(0.0, 0.5))
    
        vLayout :addChild( pVipLabel)
        vLayout :addChild( pStrengthLabel)
        vLayout :addChild( pSpacialLabel)
        vLayout :addChild( pAgateLabel)
        vLayout :addChild( pGoldLabel)
        vLayout :addChild( pDevilsLabel)
        vLayout :addChild( pTaskLabel)
        vLayout :addChild( pRenownLabel)
        vLayout :addChild( p8Label)
    end
    
    --添加进scrollView
    for i=nPage, 1, -1 do
        self.m_pScrollView :addPage( _pageContainer[i])
        print("nPage==", i)
    end
    
    if nPage <=1 then
        nPage = 1
    end
    --设置为第一页显示
    self.m_pScrollView :setPage( nPage-1, false)
    
    if winSize.height==640 then
        self.m_pScrollView      :setPosition( winSize.width / 2 - self.m_winSize.width / 2 + 90 , winSize.height*0.145)
    elseif winSize.height==768 then
        
    end
    
end

function CVipUI.initView( self, _winSize, _layer)
    --当前VIP等级
    local currentVipLabel   = CCLabelTTF :create( "您当前级别   ", "Arial", 22)
    --currentVipLabel   :setColor( labelColor)
    currentVipLabel   :setAnchorPoint( ccp(0.0, 0.5))
    
    --self.m_LvLabel   = CCLabelTTF :create( "0.0", "Arial", 22)
    --self.m_LvLabel   :setAnchorPoint( ccp(0.0, 0.5))

    --vip logo
    local szVipSprName = "VipResources/VIP_picture.png"
    self.vipSpr             = CSprite :create( szVipSprName )
    self.vipSpr             : setControlName(" this CVipUI.initView self.vipSpr " .. szVipSprName )
    --self.lineSprBg          = CSprite :create("update/progressBackground.png")
    self.progressLineSpr    = CSprite :createWithSpriteFrameName("active_exp_underframe.png")
    
    
    table.insert( self.m_createResStrList, szVipSprName )
    
    --self.vipSlider          = CVolumeControl :create("update/progressBackground.png", "update/progressProcess.png", "Loading/transparent.png")
    
    
    local function chargeBtnCallback( eventType, obj, x, y)
        return self :onChargeBtnCallback( eventType, obj, x, y)
    end
    self.m_chargeBtn        = CButton :createWithSpriteFrameName( "", "shop_button_recharge_normal.png" )
    self : Create_effects_button(self.m_chargeBtn)
    --当前vip  10/50 label
    local nCurrent = 1
    self.m_currentExpLabel  = CCLabelTTF :create( nCurrent.."/".."50", "Arial", 22)
    self.m_currentExpLabel  :setAnchorPoint( ccp( 0.5, 0.5))
    
    self.m_chargeBtn        :setControlName("this CVipUI. self.m_chargeBtn 279")
    self.CHARGE_BUTTON_TAG  = 101
    self.m_chargeBtn        :setFontSize( 30)
    self.m_chargeBtn        :setTag( self.CHARGE_BUTTON_TAG)
    self.m_chargeBtn        :registerControlScriptHandler( chargeBtnCallback, "this CVipUI. self.m_chargeBtn 282" )
    
    self.m_pContainer       :addChild( currentVipLabel, -99)
    self.m_pContainer       :addChild( self.m_currentExpLabel, 10)
    self.m_pContainer       :addChild( self.m_chargeBtn, -99)
    self.m_pContainer       :addChild( self.vipSpr,  -99)

    --self.m_pContainer       :addChild( self.lineSprBg, -99)
    --self.m_pContainer       :addChild( self.m_LvLabel, -99)
    --self.m_pContainer       :addChild( self.vipSlider, -98)
    --self.m_pContainer       :addChild( self.progressLineSpr, -98)
    
    --local lineSize          = self.lineSprBg :getPreferredSize()
    
    local lineProSize       = self.progressLineSpr :getPreferredSize()
    local chargeSize        = self.m_chargeBtn :getPreferredSize()
    --self.lineSprBg          :setPreferredSize( CCSizeMake( _winSize.width/2, lineSize.height))
    print("lineProSize", lineProSize.width, lineProSize.height)
    self.progressLineSpr    :setPreferredSize( CCSizeMake( 0/lineProSize.width, lineProSize.height) )
   
    
    
    currentVipLabel         :setPosition( _winSize.width / 3,  self.m_pUpBgSize.height * 0.8 + self.m_pSecBgSize.height + 20)
    --self.m_LvLabel          :setPosition( _winSize.width/2,  _winSize.height-60)
    --self.lineSprBg          :setPosition( _winSize.width/2,  _winSize.height-90)
    --self.progressLineSpr    :setPosition( _winSize.width/4+lineProSize.width/2,  _winSize.height-90)
    
    self.m_currentExpLabel  :setPosition( _winSize.width/2,  _winSize.height-110)
    
    local vipSprSize = self.vipSpr :getPreferredSize()
    self.vipSpr             :setPosition( ( _winSize.width - self.m_winSize.width)/2 + vipSprSize.width * 0.7, _winSize.height-vipSprSize.height * 0.8 )
    self.m_chargeBtn        :setPosition( _winSize.width /2 + self.m_winSize.width / 2 - chargeSize.width * 0.85 ,  _winSize.height - vipSprSize.height * 0.8 )
    --self.vipSlider          :setPosition(  _winSize.width/2,  _winSize.height-90)
    
    --添加 箭头按钮及 页数label
    self :addArrowBtn()
end

function CVipUI.Create_effects_button( self,obj)
    
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    if obj ~= nil then
        local effectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_button.ccbi" )
        effectsCCBI       : setControlName( "this CCBI Create_effects_activity CCBI")
        effectsCCBI       : registerControlScriptHandler( animationCallFunc)
        obj               : addChild(effectsCCBI,1000)
    end
end

function CVipUI.scene( self )
    local winSize	= CCDirector:sharedDirector():getVisibleSize()
    local scene		= CCScene :create()
    self:init( winSize, scene)
    if self.m_pContainer:getParent() ~= nil then
        self.m_pContainer:removeFromParentAndCleanup(false)
    end
    scene:addChild(self.m_pContainer)
    return scene
end

--获取页数
function CVipUI.getPages( self, _nCount )
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
    return _nCount
end

-------------回调
function CVipUI.onCloseCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("@@@@@@@@@@@@@@@@关闭vip界面@@@@@@@@@@@@@@@@")
        if self.m_pContainer ~= nil then
            self.m_pContainer :removeFromParentAndCleanup( true)
            self.m_pContainer = nil
        end
        self :removeMediator()
        CCDirector :sharedDirector() :popScene()
        self :unloadResources()
    end
end

function CVipUI.onArrowBtnCallback( self, eventType, obj, x, y)
    --print(self.m_currentPage)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local isAddOrReduce = false
        
        if obj :getTag() == 10 then
            if self.m_currentPage > 1 then
                isAddOrReduce   = true      --说明进行了运算
                self.m_currentPage = self.m_currentPage -1
            end
        elseif obj :getTag() == 20 then
            if self.m_currentPage < self.m_pageCount then
                isAddOrReduce   = true     --说明进行了运算
                self.m_currentPage = self.m_currentPage +1
            end
        end
       -- print("加减 tag", obj: getTag(), self.m_currentPage, self.m_pageCount, isAddOrReduce)
        
        if  self.m_pScrollView ~= nil and isAddOrReduce== true then
            self.m_pScrollView  :setPage( self.m_pageCount-self.m_currentPage, false)
            self.m_pageLabel    :setString( self.m_currentPage.."/"..self.m_pageCount)
        end
        return true
    end
end

function CVipUI.onPageCallback( self, eventType, obj, x, y)
    --print("onPageCallback", eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print("currentPage", currentPage, self.m_currentPage, self.m_pageCount)
       
        self.m_currentPage = self.m_pageCount-currentPage
        self.m_pageLabel :setString( self.m_currentPage.."/"..self.m_pageCount)
        return true
    end
    
end

function CVipUI.onChargeBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        print("chargeBtn", obj :getTag())
        --self :setServerView(11, 30)
        --return true
        print("冲值回调")
        --local msg = "是否进行充值?"
        --local function fun1()
        --local _rechargeScene = CRechargeScene:create()
        --CCDirector:sharedDirector():pushScene(_rechargeScene)
            local command = CPayCheckCommand( CPayCheckCommand.ASK )
            controller :sendCommand( command )
        --end
        --local function fun2()
            --print("不要了")
        --end
        --self : createMessageBox(msg,fun1,fun2)
    end
end

function CVipUI.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.m_pContainer : addChild(BoxLayer)
end

-----根据服务器数据更新界面
function CVipUI.setServerView( self, _vo_data)
    print("CVipUI.setServerView", _vo_data :getLv(), _vo_data :getVipUp())
    self.m_nVipLv        = _vo_data :getLv()
    self.m_nCurrentVipUp = _vo_data :getVipUp()
 
    local nReadLv = self.m_nVipLv
    if self.m_nVipLv == 0 then
        nReadLv = 1
    end
    local vipNode = _G.Config.vips : selectSingleNode( "vip[@lv="..tostring( nReadLv ).."]" )
    local maxVipUp = tonumber (vipNode:getAttribute("vip_up"))
    if self.m_nCurrentVipUp >= tonumber( vipNode:getAttribute("vip_up")) and  nReadLv<14 then   --如果当前经验大于 当前等级的经验 并且小于最大等级14
        local maxNode = _G.Config.vips : selectSingleNode( "vip[@lv="..tostring( nReadLv+1 ).."]" )
        maxVipUp = maxNode:getAttribute("vip_up")
    end
    
    --self.m_LvLabel :setString(self.m_nVipLv)
    self.m_currentExpLabel :setString( self.m_nCurrentVipUp.."/"..maxVipUp)
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local _nPercent = tonumber( self.m_nCurrentVipUp ) / tonumber( maxVipUp )
    if _nPercent >= 0 then
        local isVis = false 
        self.m_activenessSprSize = CCSizeMake(  self.m_activenessSprSize.width * _nPercent, self.m_activenessSprSize.height )
        if self.m_activenessSprSize.width > 16 then
            isVis = true
            self.m_activenessSpr :setPreferredSize( self.m_activenessSprSize )
        else
            --self.m_activenessSpr :setVisible( false )
        end
        self.m_activenessSpr :setVisible( isVis )
        self.m_activenessSpr :setPosition( ccp( winSize.width / 2 - self.m_activenessBgSize.width / 2 + self.m_activenessSprSize.width / 2 + 6  , self.m_pUpBgSize.height * 0.6 + self.m_pSecBgSize.height + 20 ) )
    end
    --self.progressLineSpr  :setPreferredSize( CCSizeMake( tonumber(self.m_nCurrentVipUp)/tonumber( vipNode.vip_up), 5))
    
    self :addPageScrollView( )
    --设置为当前级别的页数
    local nPage = self.m_nVipLv
    if self.m_nVipLv == 0 then
        nPage = 1
    end
    self.m_pScrollView :setPage( self.m_pageCount-(nPage), false)
    self.m_pageLabel   :setString( (nPage).."/"..self.m_pageCount)
    self.m_currentPage  = nPage
    
   
    print("maxVipUp", maxVipUp)
    --[[
    self.vipSlider          :setSliderMaximumValue( maxVipUp)
    self.vipSlider          :setSliderValue( self.m_nCurrentVipUp)
    self.vipSlider          :setSliderMaximumAllowedValue( self.m_nCurrentVipUp)
    self.vipSlider          :setSliderMinimumAllowedValue( self.m_nCurrentVipUp)
    --]]
    --[["menu_vip_".._nVipLevel..".png"
    if self.vipSpr then
        if self.m_nVipLv < 10 then
            self.vipSpr :setImageWithSpriteFrameName("menu_vip_"..self.m_nVipLv..".png")
        else
            self.vipSpr :setImageWithSpriteFrameName("menu_vip_9.png")
        end
    end
    --]]
end



