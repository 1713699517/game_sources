require "view/view"
--require "controller/TaskDownloadCommand"
require "mediator/TaskDownloadMediator"


CTaskDownloadView = class( view, function( self )
    CCLOG("分包下载!")
    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
end)

function CTaskDownloadView.addMediator( self )
    self :removeMediator()
    
    require "mediator/TaskDownloadMediator"
    _G.g_CTaskDownloadMediator = CTaskDownloadMediator( self )
    controller :registerMediator( _G.g_CTaskDownloadMediator )
end

function CTaskDownloadView.removeMediator( self )
    if _G.g_CTaskDownloadMediator ~= nil then
        controller :unregisterMediator( _G.g_CTaskDownloadMediator )
        _G.g_CTaskDownloadMediator = nil
    end
end

function CTaskDownloadView.layer( self )
    
    self.m_lpLayer		= CContainer :create()
    self.m_lpLayer : setControlName(" this CTaskDialogView self.m_lpLayer 16")
    
	self:init( self.m_lpLayer )
    
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup( false )
    end
    
	self.m_lpLayer :addChild( self.m_pContainer )
	return self.m_lpLayer

end

function CTaskDownloadView.init( self, _layer )
    self : loadResources()
    
    self.m_pContainer = CContainer :create()
    _layer :addChild( self.m_pContainer )

    self : initBackground( self.m_pContainer )
    self : initView( self.m_pBackground )
    self : addMediator()
    self : layout()
end

function CTaskDownloadView.loadResources( self )
    self.m_szBackgroundName  = "general_thirdly_underframe.png"                        --背景图
    self.m_szLeftRoleSprName = "taskDialog/taskNpcResources/so_10323.png"              --左边的人物图 
    self.m_szTitleSprName    = "taskDialog/downTips.png"                               --标题图片 
    self.m_szNormalBtnName   = "taskDialog/download_normal.png"                        --正常按钮图片
    self.m_szClickBtnName    = "taskDialog/download_click.png"                         --点击按钮图片
    self.m_szGoodsSprName    = "general_props_frame_normal.png"                        --物品底框
end

function CTaskDownloadView.unloadResources( self )
    self :removeMediator()
    
    if _G.g_unLoadIconSources ~= nil then
        _G.g_unLoadIconSources :unLoadCreateResByName( self.m_szLeftRoleSprName )
        _G.g_unLoadIconSources :unLoadCreateResByName( self.m_szTitleSprName )
        _G.g_unLoadIconSources :unLoadCreateResByName( self.m_szNormalBtnName )
        _G.g_unLoadIconSources :unLoadCreateResByName( self.m_szClickBtnName )
        
        if self.m_unloadIconList ~= nil then
            _G.g_unLoadIconSources :unLoadAllIconsByNameList( self.m_unloadIconList )
            self.m_unloadIconList = nil 
        end
    end
    
end

function CTaskDownloadView.initBackground( self, _container )
    self.m_pBackground      = CSprite :createWithSpriteFrameName( self.m_szBackgroundName )
    
    self.m_nTouchesPriority = -50
    self.m_pBackground      :setTouchesPriority( self.m_nTouchesPriority )
    self.m_pBackground      :setTouchesEnabled( true )
    self.m_pBackground      :setFullScreenTouchEnabled( true )
    
    local function btnCallback( eventType, obj, x, y )
        return self :onBtnCallback( eventType, obj, x, y)
    end

    self.m_pBackground      :registerControlScriptHandler( btnCallback, "this CTaskDownloadView. self.m_pBackground 84" )
    
    self.m_pBackgroundSize  = CCSizeMake( 620.0, 390.0 )
    self.m_pBackground : setPreferredSize( self.m_pBackgroundSize )
    _container :addChild( self.m_pBackground, 100 )
    
end

function CTaskDownloadView.initView( self, _container )
    local _bgSize = self.m_pBackgroundSize
    
    self.m_lpTitleSpr    = CSprite :create( self.m_szTitleSprName )         --标题
    self.m_lpLeftRoleSpr = CSprite :create( self.m_szLeftRoleSprName )
    
    self.m_lpTitleSpr      :setControlName("this CTaskDownloadView. self.m_lpTitleSpr 80")
    self.m_lpLeftRoleSpr   :setControlName("this CTaskDownloadView. self.m_lpLeftRoleSpr 81")
    
    _container :addChild( self.m_lpTitleSpr, 101 )
    _container :addChild( self.m_lpLeftRoleSpr, 101 )
    
    local nDistance = 40
    self.m_lpTitleSpr    :setPosition( ccp( 40, self.m_pBackgroundSize.height / 2 - nDistance) )
    self.m_lpLeftRoleSpr :setPosition( ccp( -( self.m_pBackgroundSize.width / 2 ), 0) )
    
    -----------------
    local function btnCallback( eventType, obj, x, y )
        return self :onBtnCallback( eventType, obj, x, y)
    end
    self.m_lpLeftBtn     = CButton :create( "稍后下载", self.m_szClickBtnName )
    self.m_lpRightBtn    = CButton :create( "马上下载", self.m_szClickBtnName )
    
    _container :addChild( self.m_lpLeftBtn, 101, 1000 )
    _container :addChild( self.m_lpRightBtn, 101, 2000 )
    
    self.m_lpLeftBtn  :setTouchesPriority( self.m_nTouchesPriority - 1 )
    self.m_lpRightBtn :setTouchesPriority( self.m_nTouchesPriority - 1 )
    
    self.m_lpLeftBtn  :setPosition( ccp( -150, -self.m_pBackgroundSize.height / 2 + nDistance) )
    self.m_lpRightBtn :setPosition( ccp( 150, -self.m_pBackgroundSize.height / 2 + nDistance) )
    
    self.m_lpLeftBtn  :registerControlScriptHandler( btnCallback, "this CTaskDownloadView. self.m_lpLeftBtn 103" )
    self.m_lpRightBtn :registerControlScriptHandler( btnCallback, "this CTaskDownloadView. self.m_lpRightBtn 104" )
    
    
    --奖励物品
    _G.Config :load( "config/tasks.xml" )
    
    local readNode = _G.g_CTaskNewDataProxy :getTaskDataById( "105610" )

    print("readNode :isEmpty()", readNode :isEmpty())
    if readNode ~= nil and readNode :isEmpty() == false then
        local verifyId = _G.g_CTaskNewDataProxy : getTargetAttribute( readNode, "id", 6 )
        print( "dddddd", verifyId )
        if  verifyId ~= nil and tonumber( verifyId ) == 21 then
            
            print( "60sdfssd", _G.g_CTaskNewDataProxy :getGoodsAttribute( readNode, 0, "id") )
            if _G.g_CTaskNewDataProxy :getGoodsAttribute( readNode, 0, "id") ~= nil then
                
                local goodsIdList = nil
                
                local goodsCount = 0
                
                local _goodsNode = readNode :children() :get( 0, "goods" )
                if _goodsNode ~= nil and _goodsNode :isEmpty() == false and _goodsNode :children() :getCount() > 0 then
                    goodsCount = _goodsNode :children() :getCount()
                end
                
                print("goodsCountgoodsCount", goodsCount)
                
                for i=1, goodsCount do
                    local idx = i - 1
                    local _id = _G.g_CTaskNewDataProxy :getGoodsAttribute( readNode, idx, "id")
                    if _id ~= nil then
                        if goodsIdList == nil then
                            goodsIdList = {}
                        end
                        goodsIdList[i] = {}
                        goodsIdList[i] = tonumber( _id )
                    end
                end
                self :addGoodsBtn( goodsCount, goodsIdList )      --奖励按钮
            end
            
        end
    end
    
    self.m_lplabelInfo = CCLabelTTF  :create( "60级后的游戏内容需下载资源包才可以体验哦！\n更新后完成任务[下载后续内容]可获豪华礼包！\n建议使用wifi或3G网络下载！", "Arial", 20 )
    self.m_lplabelInfo :setHorizontalAlignment( kCCTextAlignmentLeft )
    self.m_lplabelInfo :setDimensions( CCSizeMake( 451, 113) )
    self.m_lplabelInfo :setPosition( ccp ( 10, -50) )
    _container :addChild( self.m_lplabelInfo, 103 )
    
end

function CTaskDownloadView.getGoodsXmlNode( self, _id )
    _G.Config :load( "config/goods.xml")

    local node = _G.Config.goodss :selectSingleNode( "goods[@id=" .. tostring( _id ) .. "]" )
    return node 
end

function CTaskDownloadView.addGoodsBtn( self, _nCount, _idList )
    if _nCount == nil or _idList == nil then
        return
    end

    self :cleanNode( self.m_lpGoodsContainer )
    
    if self.m_lpGoodsBtn ~= nil then
        table.remove( self.m_lpGoodsBtn )
        self.m_lpGoodsBtn = nil
    end

    --print("奖励物品--->~~~", _nCount)
    if _nCount == nil or _nCount <= 0 then
        return
    end
    
    _nCount = tonumber( _nCount )
    
    self.m_lpGoodsContainer = CContainer :create()
    self.m_pContainer :addChild( self.m_lpGoodsContainer, 101 )
    self.m_lpGoodsContainer :setPosition( ccp( self.m_winSize.width / 2 - 130, self.m_winSize.height * 0.55) )
    
    local function goodsCallback( eventType, obj, x, y)
        return self :onGoodsCallback( eventType, obj, x, y)
    end
    
    self.m_lpGoodsBtn = {}
    for i=1, _nCount do
        local btn = CButton :createWithSpriteFrameName( "", self.m_szGoodsSprName )
        btn  :setTouchesPriority( self.m_nTouchesPriority - 1)
        btn  :registerControlScriptHandler( goodsCallback, "this CTaskDownloadView. btn 131" .. i )
        local nTag = i
        
        local btnSize = btn :getPreferredSize()
        btn  :setPosition( ccp( (btnSize.width + 28) * (i - 1), 0) )
        
        if _idList[i] ~= nil then
            local iconNode = self :getGoodsXmlNode( tostring( _idList[i] ) )
            nTag = tonumber( _idList[i] or i)
            
            if iconNode ~= nil and iconNode :isEmpty() == false then
                local szIconName = "Icon/i" .. ( iconNode :getAttribute( "icon" ) or "1001") .. ".jpg"
                
                local spr = CSprite :create( szIconName )
                btn :addChild( spr, 0 )
                
                if self.m_unloadIconList == nil then
                    self.m_unloadIconList = {}
                end
                table.insert( self.m_unloadIconList, szIconName )
            end
        end
        self.m_lpGoodsContainer :addChild( btn, 102, nTag )
        
        self.m_lpGoodsBtn[i] = {}
        self.m_lpGoodsBtn[i] = btn
    end
end

function CTaskDownloadView.layout( self )
    if self.m_winSize.height == 640 then
        self.m_pBackground : setPosition( ccp( self.m_winSize.width /2 + 30, self.m_winSize.height * 0.44) )
    else
        self.m_pBackground : setPosition( ccp( self.m_winSize.width /2 + 30, self.m_winSize.height * 0.44) ) 
    end
end

function CTaskDownloadView.gotoUpdateScene( self )
    local _updateScene = CGameUpdateScene :create( 60 )
    CCDirector :sharedDirector() :pushScene( _updateScene )
end

function CTaskDownloadView.cleanNode( self, _node )
    if _node ~= nil then
        _node :removeFromParentAndCleanup( true )
        _node = nil
    end
end

function CTaskDownloadView.onBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        
        if obj :getTag() == 1000 then           --稍后
            self :cleanNode( self.m_lpGoodsContainer )
            self :cleanNode( self.m_lpLayer )
            self :unloadResources()
            CCLOG("直接关闭")
        elseif obj :getTag() == 2000 then       --马上
            self :cleanNode( self.m_lpGoodsContainer )
            self :cleanNode( self.m_lpLayer )
            self :unloadResources()
            CCLOG("去下载")
            self :gotoUpdateScene()
        end
        
        return true
    end
end

function CTaskDownloadView.onGoodsCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        
        local _position = {}
        _position.x = x
        _position.y = y
        local nTag   = obj:getTag()
        print("self.m_ugoodsMsg", nTag)
        
        local goodsData = self :getGoodsXmlNode( tostring( nTag ))
        local temp = _G.g_PopupView :createByGoodsId( nTag, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
        self.m_pContainer :addChild( temp, 10000 )
        
        return true
    end
end









