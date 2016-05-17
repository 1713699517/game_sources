require "view/view"

CRewardPickUpCopyView = class( view, function ( self ,_goods )
    CCLOG("副本拾取界面被实例化")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("DuplicateResources/DuplicateResources.plist")

    self.m_gold = _goods[3]
	self.m_upGoods = _goods[1] -- { {goods_id=xxx,count =xxx }}
    self.m_downGoods = _goods[2]

end)

CRewardPickUpCopyView.FONT_NAME = "Marker Felt"
CRewardPickUpCopyView.FONT_SIZE24 = 24
CRewardPickUpCopyView.FONT_SIZE48 = 48
CRewardPickUpCopyView.BUTTON_OK = 100


function CRewardPickUpCopyView.container( self )
    self.m_lpContainer = CContainer :create() -- 总层
    self.m_lpContainer : setControlName( "this is CRewardPickUpCopyView self.m_lpContainer 33" )
    self.m_lpContainer : setFullScreenTouchEnabled(true)
    self : initView()
    self : layoutView()

    return self.m_lpContainer
end
function CRewardPickUpCopyView.scene( self )
    self.m_lpContainer = CCScene :create() -- 总层
    self : initView()
    self : layoutView()

    return self.m_lpContainer
end

--初始化 成员
function CRewardPickUpCopyView.initView( self )
    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    --底图 319 * 365
    self.m_backgroundMain  = CSprite :createWithSpriteFrameName( "general_first_underframe.png")
    self.m_backgroundMain : setControlName( "this CRewardPickUpCopyView self.m_backgroundMain 47 " )

    --钱底图
    self.m_goldSpritebackground = CSprite :createWithSpriteFrameName( "general_underframe_normal.png")
    self.m_goldSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_goldSpritebackground 50 " )
    self.m_backgroundMain : addChild( self.m_goldSpritebackground )
    --上底图
    if self.m_upGoods ~= nil then
        self.m_upSpritebackground = CSprite :createWithSpriteFrameName( "general_underframe_normal.png")
        self.m_upSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_upSpritebackground 50 " )
        self.m_backgroundMain : addChild( self.m_upSpritebackground )
    end
    if self.m_downGoods ~= nil then
        --下底图
        self.m_downSpritebackground = CSprite :createWithSpriteFrameName( "general_underframe_normal.png")
        self.m_downSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_downSpritebackground 52 " )
        self.m_backgroundMain : addChild( self.m_downSpritebackground )
    end
    --标题
    self.m_title = CCSprite : createWithSpriteFrameName("copy_word_sqwp.png")
    self.m_backgroundMain : addChild( self.m_title )
    --按钮
    self.m_button = CButton : createWithSpriteFrameName("拾取","general_button_normal.png")
    self.m_button : setControlName( "this CRewardPickUpCopyView self.m_button 61 " )
    self.m_button : setTag( self.BUTTON_OK )
    self.m_button : registerControlScriptHandler( CellCallBack, "this CRewardPickUpCopyView self.m_button 67")
    self.m_button : setTouchesPriority( -100 )
    self.m_button : setTouchesEnabled( true )

    self.m_backgroundMain : addChild( self.m_button )

    self.m_goldGoodsSpritebackground =  CSprite :createWithSpriteFrameName( "general_props_underframe.png")
    self.m_goldGoodsSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_goldGoodsSpritebackground 65 " )
    self.m_goldSpritebackground : addChild( self.m_goldGoodsSpritebackground )
    --上物品底图
    if self.m_upGoods ~= nil then
        self.m_upGoodsSpritebackground =  CSprite :createWithSpriteFrameName( "general_props_underframe.png")
        self.m_upGoodsSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_upGoodsSpritebackground 65 " )
        self.m_upSpritebackground : addChild( self.m_upGoodsSpritebackground )
    end
    if self.m_downGoods ~= nil then
        --下物品底图
        self.m_downGoodsSpritebackground =  CSprite :createWithSpriteFrameName( "general_props_underframe.png")
        self.m_downGoodsSpritebackground : setControlName( "this CRewardPickUpCopyView self.m_downGoodsSpritebackground 69 " )
        self.m_downSpritebackground : addChild( self.m_downGoodsSpritebackground )
    end

    if self.m_gold ~= nil then
        local goods_id = self.m_gold.goods_id
        local count = self.m_gold.count
        local path,goodsName = self : getIconPathAndNameByGoodsID( goods_id )
        if path ~= nil then
            self.m_goldGoodsIcon = CCSprite : create( path )
            self.m_goldGoodsStr = CCLabelTTF : create( goodsName.." * "..tostring(count) , self.FONT_NAME , self.FONT_SIZE24 )
            self.m_goldGoodsSpritebackground : addChild( self.m_goldGoodsIcon )
            self.m_goldSpritebackground : addChild( self.m_goldGoodsStr )
        end
    end
    --上下物品icon
    if self.m_upGoods ~= nil then
        local goods_id = self.m_upGoods.goods_id
        local count = self.m_upGoods.count
        local path,goodsName = self : getIconPathAndNameByGoodsID( goods_id )
        if path ~= nil then
            self.m_upGoodsIcon = CCSprite : create( path )
            self.m_upGoodsStr = CCLabelTTF : create( goodsName.." * "..tostring(count) , self.FONT_NAME , self.FONT_SIZE24 )
            self.m_upGoodsSpritebackground : addChild( self.m_upGoodsIcon )
            self.m_upSpritebackground : addChild( self.m_upGoodsStr )
        end
    end
    if self.m_downGoods ~= nil then
        local goods_id = self.m_downGoods.goods_id
        local count = self.m_downGoods.count
        local path,goodsName = self : getIconPathAndNameByGoodsID( goods_id )
        if path ~= nil then
            self.m_downGoodsIcon = CCSprite : create( path )
            self.m_downGoodsStr = CCLabelTTF : create( goodsName.." * "..tostring(count) , self.FONT_NAME , self.FONT_SIZE24 )
            self.m_downGoodsSpritebackground : addChild( self.m_downGoodsIcon )
            self.m_downSpritebackground : addChild( self.m_downGoodsStr )
        end
    end



    self.m_goldBianSprite = CCSprite :createWithSpriteFrameName( "general_props_frame_normal.png")
    self.m_goldGoodsSpritebackground : addChild( self.m_goldBianSprite )
    --上边框
    if self.m_upGoods ~= nil then
        self.m_upBianSprite = CCSprite :createWithSpriteFrameName( "general_props_frame_normal.png")
        self.m_upGoodsSpritebackground : addChild( self.m_upBianSprite )
    end
    if self.m_downGoods ~= nil then
        --下边框
        self.m_downBianSprite = CCSprite :createWithSpriteFrameName( "general_props_frame_normal.png")
        self.m_downGoodsSpritebackground : addChild( self.m_downBianSprite )
    end


    self.m_lpContainer : addChild( self.m_backgroundMain )
end

--布局
function CRewardPickUpCopyView.layoutView( self )
    local winSize = CCDirector      : sharedDirector() :getVisibleSize()

    --主底图位置 和大小

    local mainGroundSize = CCSizeMake( 319 , 250 )
    if self.m_upGoods ~= nil then
        mainGroundSize = CCSizeMake( 319 , 365 )
    end
    if self.m_downGoods ~= nil then
        mainGroundSize = CCSizeMake( 319 , 480 )
    end
    self.m_backgroundMain           : setPreferredSize( mainGroundSize )
    self.m_backgroundMain           : setPosition(  winSize.width/2, winSize.height/2 )

    --上底图
    local groundSize =  CCSizeMake( 277, 106 )


    self.m_goldSpritebackground : setPreferredSize( groundSize )
    self.m_goldSpritebackground : setPosition( 0, mainGroundSize.height / 2 - 115 )
    if self.m_upGoods ~= nil then
        self.m_upSpritebackground : setPreferredSize( groundSize )
        self.m_upSpritebackground : setPosition( 0, mainGroundSize.height / 2 - 228 )
    end
    if self.m_downGoods ~= nil then
        --下底图
        self.m_downSpritebackground : setPreferredSize( groundSize )
        self.m_downSpritebackground : setPosition( 0, mainGroundSize.height / 2 - 341 )
    end
    --按钮
        self.m_button : setPosition( 0, mainGroundSize.height / 2 - 200 )
    if self.m_upGoods ~= nil then
        self.m_button : setPosition( 0, mainGroundSize.height / 2 - 323 )
    end
    if self.m_downGoods ~= nil then
        self.m_button : setPosition( 0, mainGroundSize.height / 2 - 446 )
    end
    --标题
    self.m_title : setPosition( 0, mainGroundSize.height / 2 - 32 )


    self.m_goldGoodsSpritebackground : setPosition( 0 - groundSize.width / 2 + 50, 0)
    if self.m_upGoods ~= nil then
        --物品上底图
        self.m_upGoodsSpritebackground : setPosition( 0 - groundSize.width / 2 + 50, 0)
    end
    if self.m_downGoods ~= nil then
        --物品下底图
        self.m_downGoodsSpritebackground : setPosition( 0 - groundSize.width / 2 + 50, 0)
    end

    if self.m_goldGoodsStr ~= nil then
        self.m_goldGoodsStr           : setAnchorPoint( ccp( 0, 0.5 ) )
        self.m_goldGoodsStr : setPosition( 0 - groundSize.width / 2 + 110, 0)
    end
    --上物品文字
    if self.m_upGoodsStr ~= nil then
        self.m_upGoodsStr           : setAnchorPoint( ccp( 0, 0.5 ) )
        self.m_upGoodsStr : setPosition( 0 - groundSize.width / 2 + 110, 0)

    end
    --下物品文字
    if self.m_downGoodsStr ~= nil then
        self.m_downGoodsStr           : setAnchorPoint( ccp( 0, 0.5 ) )
        self.m_downGoodsStr : setPosition( 0 - groundSize.width / 2 + 110, 0)
    end



    local function onLastFunc()
        self : clickOkButton()
    end
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(_G.Constant.CONST_COPY_AUTO_EXIT))
    _callBacks:addObject(CCCallFunc:create(onLastFunc))
    self.m_lpContainer:runAction( CCSequence:create(_callBacks) )

end

--事件响应
function CRewardPickUpCopyView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.BUTTON_OK then
                --确认
                self : clickOkButton()
            end
        end
    end
end

--{退出副本}
function CRewardPickUpCopyView.clickOkButton( self )
    _G.g_Stage : exitCopy()
end


--得到物品路劲
function CRewardPickUpCopyView.getIconPathAndNameByGoodsID( self, _id )
    --local goodsXml = _G.Config.goodss : selectNode( "goods", "id", tostring( _id ) )
    local goodnode = _G.g_GameDataProxy :getGoodById( _id )
    local path = "Icon/i"..goodnode : getAttribute("icon")..".jpg"
    return path ,goodnode : getAttribute("name")
end




















