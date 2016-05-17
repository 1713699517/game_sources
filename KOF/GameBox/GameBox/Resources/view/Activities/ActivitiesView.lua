--*********************************
--2013-9-12 by 陈元杰
--精彩活动主界面-CActivitiesView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/ActivitiesMediator"

--两个参数都是提供给 需要打开那个活动那个奖励用的
--参数:   _activityId->活动ID    _subId->该活动奖励的ID
CActivitiesView = class(view, function(self,_activityId,_subId)

    self.m_initActivity = _activityId
    self.m_initSubId    = _subId or 0
    if self.m_initActivity == nil or self.m_initSubId == nil then
        self.m_hasInitGoods = false
    else
        self.m_hasInitGoods = true
    end

end)

--************************
--常量定义
--************************
-- button的Tag值
CActivitiesView.TAG_CLOSE           = 201

-- ccColor4B 常量
CActivitiesView.RED   = ccc4(255,0,0,255)
CActivitiesView.GOLD  = ccc4(255,255,0,255)
CActivitiesView.GREEN = ccc4(120,222,66,255)

CActivitiesView.FONT_SIZE = 20


function CActivitiesView.initView( self, _mainSize )

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	
    self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CActivitiesView self.m_viewContainer 39 ")
    self.m_scenceLayer   : addChild( self.m_viewContainer )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CActivitiesView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_mainBackground = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBackground : setControlName( "this CActivitiesView self.m_mainBackground 39 ")
	self.m_mainBackground : setPreferredSize( _winSize )
	self.m_mainContainer  : addChild( self.m_mainBackground )

	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CActivitiesView self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer  : addChild( self.m_background )


	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	  = self:createButton("", "general_close_normal.png",CActivitiesView.TAG_CLOSE,24,local_closeBtnCallback,"self.m_closeBtn")
    self.m_closeBtn   : setTouchesEnabled( false )
    self.m_mainContainer :addChild( self.m_closeBtn )
    
    local function closeBtnReset()
        self.m_closeBtn : setTouchesEnabled( true )
    end
    
    self.m_viewContainer : performSelector( 10,closeBtnReset )


    ----------------------------
    --主界面
    ----------------------------
    self.m_leftBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_leftBg : setControlName( "this CActivitiesView self.m_leftBg 39 ")
	self.m_leftBg : setPreferredSize( CCSizeMake( 260,554 ) )

	self.m_rightBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_rightBg : setControlName( "this CActivitiesView self.m_rightBg 39 ")
	self.m_rightBg : setPreferredSize( CCSizeMake( 560,554 ) )

	self.m_mainContainer  : addChild( self.m_leftBg )
	self.m_mainContainer  : addChild( self.m_rightBg )

    self.m_titleImg = CSprite :create("ActivitiesResources/events_word_jchd.png")
    self.m_titleImg : setControlName( "this CActivitiesView self.m_titleImg 39 ")
    self.m_mainContainer  : addChild( self.m_titleImg )

    table.insert(self.m_createResStr,"ActivitiesResources/events_word_jchd.png")
end


function CActivitiesView.loadResources(self)
	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("ActivitiesResources/ActivitiesResources.plist")

    --加载xml资源
    self :loadXml()
end

function CActivitiesView.unloadResources( self )

    if self.m_rewardBG_ccbi_List ~= nil then
        for i,v in ipairs(self.m_rewardBG_ccbi_List) do
            v:removeFromParentAndCleanup( true )
        end
    end

    if self.m_tabPageCCBI ~= nil then
        for i,v in ipairs(self.m_tabPageCCBI) do
            if v : getChildByTag( 901 ) ~= nil then
                v : removeChildByTag( 901 )
            end

            if v : getChildByTag( 902 ) ~= nil then
                v : removeChildByTag( 902 )
            end
            v:removeFromParentAndCleanup( true )
        end
    end

    self.m_rewardBG_ccbi_List = nil

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ActivitiesResources/ActivitiesResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("ActivitiesResources/ActivitiesResources.pvr.ccz")

    for i,v in ipairs(self.m_createResStr) do
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end

    self :unloadXml()
    
end

function CActivitiesView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBackground :setPosition(ccp( _mainSize.width/2 , _mainSize.height/2))
	self.m_mainContainer  :setPosition(ccp( _winSize.width/2 - _mainSize.width/2 , 0))

	----------------------------
	--活动背景
	----------------------------
	local backgroundSize = self.m_background : getPreferredSize()
	self.m_background    : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.5))

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(backgroundSize.width-closeBtnSize.width/2,backgroundSize.height-closeBtnSize.height/2)) 

	----------------------------
    --主界面
    ----------------------------
    self.m_leftBg  : setPosition(ccp( 145 , 293 ))
    self.m_rightBg : setPosition(ccp( 560 , 293 ))

    self.m_titleImg : setPosition( ccp( _mainSize.width/2, 597 ) )
end

function CActivitiesView.loadMainView( self, _data )

    --重新排序
    local newData = {}
    for i,v in ipairs(_data) do
        -- print("CActivitiesView.loadMainView---",i,v.id)
        local one  = v
        local node = self:getSalesInfoNodeById( v.id )
        if not node:isEmpty() then
            one.order  = tonumber(node:children():get(0,"a"):getAttribute("order"))
            table.insert( newData, one )
        end
        
    end

    local function sortfunc( activity1, activity2)

        if activity1.order < activity2.order then
            return true
        end
        return false
    end
    table.sort( newData, sortfunc)

    print("«««««««««««««««««««««««««««««««««««")
    for i,v in ipairs(newData) do
        print(i,v.id,v.id)
    end
    print("«««««««««««««««««««««««««««««««««««")

	local function local_pageTabCallBack(eventType, obj, x, y)
       return self : pageTabCallBack(eventType,obj,x,y)
    end

    local _winSize = CCDirector:sharedDirector():getVisibleSize()
    local maxCount = #newData + 1
    if maxCount > 8 then 
        maxCount = #newData
    end

    local pageCount = #newData
    local _height   = 545-65*(maxCount)  -- 565-52*(pageCount+1) 
    local _width    = 145+215/2
    local tabPage   = {}
    local pageContainer = {}

    self.m_tab = CTab : create (eLD_Vertical, CCSizeMake(216, 65))--按钮间距
    self.m_tab : registerControlScriptHandler(local_pageTabCallBack)
    self.m_tab : setPosition(ccp(  _width, _height ))
    self.m_mainContainer : addChild (self.m_tab,1)

    local tabLayout = self.m_tab:getLayout()
    tabLayout:setLineNodeSum(1)
    tabLayout:setColumnNodeSum(12)
    
    self.m_tabPageImg  = {}
    self.m_tabPageCCBI = {}
    local tabPageIdx  = 0
	for i=1,pageCount do

        local id = newData[i].id
        local salesInfo   = self:getSalesInfoNodeById( id )
		tabPage[i]  = CTabPage : createWithSpriteFrameName( salesInfo:children():get(0,"a"):getAttribute("tag"),"transparent.png")
		tabPage[i] : setControlName( "this CActivitiesView tabPage[i] 39 ")
        tabPage[i] : setPreferredSize( CCSizeMake( 215,52 ) )
	    tabPage[i] : setTag ( id )
	    tabPage[i] : setFontSize(24)
	    tabPage[i] : registerControlScriptHandler(local_pageTabCallBack,"this CActivitiesView tabPage[i] 39 ")

	    pageContainer[i] = self:createContainerById( newData[i] )
        pageContainer[i] : setPosition( ccp( -_width, -_height ) )

        self.m_tabPageImg[id] = CSprite :createWithSpriteFrameName( "events_page_normal.png" )
        self.m_tabPageImg[id] : setControlName( "this CActivitiesView self.m_tabPageImg[id] 39 ")
        self.m_tabPageImg[id] : setPreferredSize( CCSizeMake( 215,52 ) )
        tabPage[i] : addChild( self.m_tabPageImg[id], 10 )

        if self:getRewardCountById( id ) > 0 then
            self.m_tabPageImg[id] : setImageWithSpriteFrameName( "events_page_new.png" )
            self.m_tabPageImg[id] : setPreferredSize( CCSizeMake( 215,52 ) )

            self.m_tabPageCCBI[id] = CContainer:create()
            self:createTabPageCCBI( id, CCSizeMake( 215,52 ) )
            self.m_tabPageImg[id]  : addChild( self.m_tabPageCCBI[id], 5 )
        end

        if self.m_hasInitGoods then
            if id == self.m_initActivity then
                tabPageIdx = i
            end
        end

	end

    if pageCount < 8 then
        tabPage[pageCount+1]  = CTabPage : createWithSpriteFrameName( "敬请期待","events_page_normal.png")--,"敬请期待","events_page_click.png")
        tabPage[pageCount+1] : setControlName( "this CActivitiesView tabPage[pageCount+1] 39 ")
        tabPage[pageCount+1] : setPreferredSize( CCSizeMake( 215,52 ) )
        tabPage[pageCount+1] : setTag ( 0 )
        tabPage[pageCount+1] : setFontSize(24)
        -- tabPage[pageCount+1] : registerControlScriptHandler(local_pageTabCallBack,"this CActivitiesView tabPage[i] 39 ")

        pageContainer[pageCount+1] = CContainer :create()
        pageContainer[pageCount+1] : setControlName( "this CActivitiesView container 39 ")
        pageContainer[pageCount+1] : setPosition( ccp( -_width, -_height ) )

    end

    if tabPageIdx == 0 then
        tabPageIdx = 1
        if self.m_hasInitGoods then
            self:createMessageBox("此活动已结束")
        end
    end

    

    for i=maxCount,1,-1 do
        self.m_tab : addTab( tabPage[i], pageContainer[i] )
    end

    self.m_tab : onTabChange( tabPage[tabPageIdx] )

    local activityId = tabPage[tabPageIdx] : getTag()
    self:setActivityId( activityId )
    self:setHightLineSpr( self.m_tabPageImg[activityId] )
    
    self.m_closeBtn   : setTouchesEnabled( true )

end

function CActivitiesView.goToReward( self, _activityId, _goodsId )

    if _activityId == nil or _goodsId == nil then
        return
    end



end


function CActivitiesView.createContainerById( self, _data )

	local id        = tonumber( _data.id )
    local container = CContainer :create()
    container : setControlName( "this CActivitiesView container 39 ")

	if id == _G.Constant.CONST_SALES_ID_CDKEY then 
        return self : createContainer_XSK(container,id)
	elseif id == 0 then 
        return container
    else
        self.m_goodsIdList[id] = {}
		return self : createContainer_DBCZSHL(container,_data)
	end
    -- return container
end

----------------单笔充值送好礼  以及类似的---------------
function CActivitiesView.createContainer_DBCZSHL( self,container,data )
    print( "CREATE ----   createContainer_DBCZSHL  单笔充值送好礼  -- "..data.id,data.start_time,data.exit_time )
    local function local_DBCZSHL_getRewardCallback(eventType, obj, x, y)
       return self : DBCZSHL_getRewardCallback(eventType,obj,x,y)
    end

    local function local_goodsTouchCallBack( eventType, obj, touches )
       return self : goodsTouchCallback(eventType,obj,touches)
    end

    local id          = tonumber(data.id)
    local startTime   = self:getTimeStrByTimeCuo( data.start_time )
    local exitTime    = self:getTimeStrByTimeCuo( data.exit_time ) 
    local salesInfo   = self:getSalesInfoNodeById( id )
    local rewardList  = self:getXmlRewardListById( id )
    local rewardCount = #rewardList
    local oneHeight   = 115
    local cellSize    = CCSizeMake( 547, oneHeight - 6 )
    local _Y          = (rewardCount-2)*oneHeight

    if _Y < 0 then 
        _Y = 0
    end

    local container_Y 
    if rewardCount > 1 then 
        container_Y = -(rewardCount-2)*oneHeight
    else
        container_Y = 0
    end

    local viewHeight  = 542 + _Y


    local scrollViewContainer = CContainer :create()
    scrollViewContainer : setControlName( "this CActivitiesView scrollViewContainer 39 ")

    local ScrollView     = CCScrollView :create()
    ScrollView : setPosition( ccp( 287,21 ) )
    ScrollView : setDirection(kCCScrollViewDirectionVertical)
    ScrollView : setContentOffset( CCPointMake( 0,-viewHeight ) )
    ScrollView : setContainer( scrollViewContainer )
    ScrollView : setViewSize( CCSizeMake( 550,542 ) )
    ScrollView : setContentSize(CCSizeMake( 550,viewHeight ))
    container  : addChild( ScrollView,100 )

    local _imgName      = "ActivitiesResources/"..salesInfo:children():get(0,"a"):getAttribute("pic")..".png"
    local titleImg      = CSprite:create(_imgName)
    local timeTitleLb   = CCLabelTTF :create( "活动时间 : ", "Arial", CActivitiesView.FONT_SIZE )
    local roluTitleLb   = CCLabelTTF :create( "活动规则 : ", "Arial", CActivitiesView.FONT_SIZE )
    local rewardTitleLb = CCLabelTTF :create( salesInfo:children():get(0,"a"):getAttribute("stage_word").." : ", "Arial", CActivitiesView.FONT_SIZE )

    table.insert(self.m_createResStr,_imgName)

    timeTitleLb   : setAnchorPoint( ccp( 0,1 ) )
    roluTitleLb   : setAnchorPoint( ccp( 0,1 ) )
    rewardTitleLb : setAnchorPoint( ccp( 0,1 ) )
    timeTitleLb   : setColor( CActivitiesView.GOLD )
    roluTitleLb   : setColor( CActivitiesView.GOLD )
    rewardTitleLb : setColor( CActivitiesView.GOLD )

    local timeLabel = CCLabelTTF :create( "                   "..startTime.." - "..exitTime, "Arial", CActivitiesView.FONT_SIZE )
    local roluLabel = CCLabelTTF :create( "                   "..salesInfo:children():get(0,"a"):getAttribute("content"), "Arial", CActivitiesView.FONT_SIZE )

    timeLabel : setAnchorPoint( ccp( 0,1 ) )
    roluLabel : setAnchorPoint( ccp( 0,1 ) )
    timeLabel : setDimensions( CCSizeMake( 513,100 ) )
    roluLabel : setDimensions( CCSizeMake( 513,100 ) )
    timeLabel : setHorizontalAlignment( kCCTextAlignmentLeft )
    roluLabel : setHorizontalAlignment( kCCTextAlignmentLeft )


    scrollViewContainer : addChild( titleImg )
    scrollViewContainer : addChild( timeTitleLb )
    scrollViewContainer : addChild( roluTitleLb )
    scrollViewContainer : addChild( rewardTitleLb )
    scrollViewContainer : addChild( timeLabel )
    scrollViewContainer : addChild( roluLabel )

    titleImg      : setPosition( ccp( 262, viewHeight-40 ) )
    timeTitleLb   : setPosition( ccp( 5, viewHeight-90 ) )
    roluTitleLb   : setPosition( ccp( 5, viewHeight-126 ) )--308
    rewardTitleLb : setPosition( ccp( 5, viewHeight-284 ) )
    timeLabel     : setPosition( ccp( 5, viewHeight-90 ) )
    roluLabel     : setPosition( ccp( 5, viewHeight-126 ) )

    local function local_bgTouchCallBack( eventType, obj, touches )
        return self:bgTouchCallBack( eventType, obj, touches )
    end

    local firstGet = 0
    local index    = 1
    local isInit_here    = false
    local initGoods_here = false

    if self.m_hasInitGoods then
        if id == self.m_initActivity then
            isInit_here = true
        end
    end

    for i=1,rewardCount do

        local id_sub      = tonumber(rewardList[i]:getAttribute("id_sub"))
        local desc_value  = rewardList[i]:children():get(0,"a"):getAttribute("desc_value")
        local rewardNotic = self:getNewRewardNotic( desc_value )

        if isInit_here then
            print("isInit_here---------------->  ",id_sub,self.m_initSubId)
            if id_sub == self.m_initSubId   then
                print("isInit_here---------------->  22")
                initGoods_here = true
            end
        end

        local cellBg = CButton :createWithSpriteFrameName("","general_underframe_normal.png")
        cellBg : setControlName( "this CArtifactShopView cellBg 217 ")
        cellBg : setPreferredSize( cellSize )
        cellBg : setTouchesPriority(-100)
        cellBg : setTag( i )
        cellBg : setTouchesMode( kCCTouchesAllAtOnce )
        cellBg : registerControlScriptHandler( local_bgTouchCallBack, "this CArtifactShopView cellBg 227 ")

        local virtueList  = rewardList[i]:children():get(0,"virtues"):children()
        local virtueCount = virtueList:getCount("virtue")
        print(i.."  desc_value="..desc_value,"  count="..virtueCount)
        local rewordTitleLb   = CCLabelTTF :create( rewardNotic, "Arial", CActivitiesView.FONT_SIZE )
        rewordTitleLb : setAnchorPoint( ccp( 0,0.5 ) )

        local _Layout = CHorizontalLayout:create()
        _Layout : setCellSize( CCSizeMake( 90,90 ) )
        _Layout : setCellHorizontalSpace(9)
        _Layout : setCellVerticalSpace(0)
        _Layout : setLineNodeSum(3)
        _Layout : setColumnNodeSum(1)
        _Layout : setHorizontalDirection(true)
        _Layout : setVerticalDirection(false)     --垂直  从上至下

        local goodsCount = virtueCount
        for j=1,3,1 do
            if goodsCount >= j then
                local IconBg = CSprite:createWithSpriteFrameName( "general_props_frame_normal.png" )
                IconBg : setControlName( "this CActivitiesView IconBg 39 ")

                local goodsId   = virtueList:get(j-1,"virtue"):getAttribute("id")
                local count     = "*"..virtueList:get(j-1,"virtue"):getAttribute("count")
                local goodsNode = self:getGoodsNodeByGoodsId( goodsId )
                self.m_goodsIdList[id][index] = goodsId

                local goodsBtn  = self:createIconButton("","Icon/i"..goodsNode:getAttribute("icon")..".jpg",index,24,local_goodsTouchCallBack,"goodsBtn")
                goodsBtn : setTouchesMode( kCCTouchesAllAtOnce )
                goodsBtn : setTouchesEnabled( true)
                IconBg : addChild( goodsBtn, -10 )
                _Layout : addChild( IconBg, 100 )

                print("  CActivitiesView    ",count)
                local btnSize    = IconBg:getPreferredSize()
                local countLabel = CCLabelTTF :create( count,"Arial",18 )
                countLabel :setAnchorPoint( ccp(1,0) )
                countLabel :setPosition( ccp( btnSize.width/2-5, -btnSize.height/2+5 ) )
                goodsBtn :addChild( countLabel , 10 )

                index = index + 1

                --特效特效

                local theType  = tonumber(goodsNode:getAttribute("type"))
                if theType == 1 or theType == 2 then
                    self : Create_effects_equip(IconBg,goodsNode:getAttribute("name_color"),goodsNode:getAttribute("id"))
                end


            else
                local IconBg = CSprite:createWithSpriteFrameName( "general_props_frame_normal.png" )
                IconBg  : setControlName( "this CActivitiesView IconBg 39 ")
                _Layout : addChild( IconBg, 100 )

                local Icon = CSprite:createWithSpriteFrameName( "general_props_underframe.png" )
                Icon   : setControlName( "this CActivitiesView Icon 39 ")
                IconBg : addChild( Icon, -10 )
            end
        end

        local id_sub = tonumber(rewardList[i]:getAttribute("id_sub"))

        local getButton = self:createButton("","general_button_normal.png",id_sub,24,local_DBCZSHL_getRewardCallback,"getButton")
        getButton : setTouchesPriority( -102 )
        getButton : setTouchesEnabled( false )

        local btnName = CCLabelTTF:create( "领取奖励", "Arial", 26 )
        getButton : addChild( btnName, 10, 999 )

        if isInit_here then         --要求打开此活动
            if initGoods_here then  --需要的物品是否在这里
                if firstGet == 0 then
                    firstGet = i
                    self:chuangItemBgForObj( cellBg, id )
                end
            end
        end
        
        local canGet = false
        for jj,vv in ipairs(data.sub_date) do
            if vv.id_sub == id_sub then 
                --可以领取
                canGet = true
                
                local listIdx = #self.m_rewardCountGetList + 1
                self.m_rewardCountGetList[listIdx] = {}
                self.m_rewardCountGetList[listIdx].activityId = id
                self.m_rewardCountGetList[listIdx].subId      = id_sub

                self:createRewardCCBI( cellBg )

                getButton : setTouchesEnabled( true )

                if firstGet == 0 then --没有要求打开此活动
                    --第一个可领取的 奖励
                    firstGet = i
                    self:chuangItemBgForObj( cellBg, id )
                end
            end
        end
        
        if not canGet then
            if _G.pCFunctionOpenProxy :isSubIdHere( id_sub ) then
                --已领取过
                btnName : setString("已领取")
            end
        end

        local _height = viewHeight-362-(i-1)*oneHeight
        rewordTitleLb : setPosition( ccp( -cellSize.width/2+7, 0 ) )
        _Layout       : setPosition( -cellSize.width/2 + 115, 0 )
        getButton     : setPosition( cellSize.width/2 - getButton:getPreferredSize().width/2-10, 0 )

        local rewardContainer = CContainer:create()
        rewardContainer : setControlName( "this CActivitiesView rewardContainer 433" )
        rewardContainer : addChild( _Layout, 10 )

        cellBg : addChild( rewordTitleLb, 10 )
        cellBg : addChild( getButton, 10 )
        cellBg : addChild( rewardContainer, 20 )

        cellBg : setPosition( ccp( 550/2-2, _height ) )
        scrollViewContainer : addChild( cellBg )

        
    end

    local getPos_Y = 0 
    if firstGet > 2 then
        getPos_Y = ( firstGet - 2 )*oneHeight
    elseif firstGet == 0 then
        if isInit_here and self.m_initSubId ~= 0 then
            self:createMessageBox("此奖励已移除")
        end
    end

    scrollViewContainer : setPosition( ccp( 0, container_Y + getPos_Y ) )

    return container
end

----------------新手卡---------------
function CActivitiesView.createContainer_XSK( self,container,_id )
    print( "CREATE ----   createContainer_XSK  新手卡" )

    local function local_XSK_duiHuanCallback(eventType, obj, x, y)
       return self : XSK_duiHuanCallback(eventType,obj,x,y)
    end

    local salesInfo = self:getSalesInfoNodeById( _id )
    local _imgName  = "ActivitiesResources/"..salesInfo:children():get(0,"a"):getAttribute("pic")..".png"
    local titleImg  = CSprite:create(_imgName)
    titleImg : setControlName( "this CActivitiesView titleImg 39 ")

    table.insert(self.m_createResStr,_imgName)

    local DuiHuanButton = self:createButton("兑换","general_button_normal.png",0,24,local_XSK_duiHuanCallback,"DuiHuanButton") 
    local _editBg  = CCScale9Sprite:createWithSpriteFrameName("general_second_underframe.png")
    self.m_editBox = CEditBox:create( CCSizeMake(475,46), _editBg, 100, "请输入新手卡兑换码", kEditBoxInputFlagSensitive)
    self.m_editBox : setFont( "Arial",24)

    container : addChild( titleImg )
    container : addChild( DuiHuanButton )
    container : addChild( self.m_editBox )

    titleImg       : setPosition( ccp( 383, 522 ) )
    DuiHuanButton  : setPosition( ccp( 560, 375 ) )
    self.m_editBox : setPosition( ccp( 560, 465 ) )

    return container
end

function CActivitiesView.getTimeStrByTimeCuo( self, _shiJianCuo )
    if tonumber(_shiJianCuo) == 0 then 
        return "永久"
    else
        local time = os.date("*t",_shiJianCuo)
        local str  = time.year.."年"..time.month.."月"..time.day.."日"
        return str
    end
end

function CActivitiesView.createTabPageCCBI( self, _id, _size )

    if self.m_tabPageCCBI[_id] == nil then
        return
    end

    local _container = self.m_tabPageCCBI[_id]

    local function local_animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_animationCallFunc  "..eventType )
            arg0 : play("run")
        end
    end


    local n_Y     = 3
    local n_X     = 5
    local ccbi_up = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    ccbi_up : setControlName( "this CActivitiesView ccbi_up 84")
    ccbi_up : registerControlScriptHandler( local_animationCallFunc )
    ccbi_up : setPosition( -_size.width/2 + n_X, _size.height/2 - n_Y)
    _container : addChild( ccbi_up,1,901 )

    local ccbi_down = CMovieClip:create( "CharacterMovieClip/effects_frame1.ccbi" )
    ccbi_down : setControlName( "this CActivitiesView ccbi_down 84")
    ccbi_down : registerControlScriptHandler( local_animationCallFunc )
    ccbi_down : setPosition( _size.width/2 - n_X, - _size.height/2 + n_Y)
    _container : addChild( ccbi_down,1,902 )

    local function local_moveActionCallBack()
        if ccbi_up ~= nil then

            ccbi_up : removeFromParentAndCleanup( true )
            ccbi_up = nil
        end

        if ccbi_down ~= nil then

            ccbi_down : removeFromParentAndCleanup( true )
            ccbi_down = nil
        end

        self:createTabPageCCBI( _id, _size )
    end


    --移动CCBI
    local actionTime = 0.66
    local _action_up = CCArray:create()
    _action_up:addObject(CCMoveTo:create( actionTime, ccp( _size.width/2 - n_X,_size.height/2 - n_Y ) ))
    _action_up:addObject(CCCallFunc:create(local_moveActionCallBack))
    ccbi_up : runAction( CCSequence:create(_action_up) )

    local _action_down = CCArray:create()
    _action_down:addObject(CCMoveTo:create( actionTime, ccp( -_size.width/2 + n_X,-_size.height/2 + n_Y ) ))
    -- _action_down:addObject(CCCallFunc:create(local_moveActionCallBack))
    ccbi_down : runAction( CCSequence:create(_action_down) )

end

function CActivitiesView.createRewardCCBI( self, _bgNode )

    if _bgNode == nil then
        return
    end

    if self.m_rewardBG_ccbi_Idx == nil then
        self.m_rewardBG_ccbi_Idx = 1
    end

    if self.m_rewardBG_ccbi_List == nil then
        self.m_rewardBG_ccbi_List = {}
    end

    local function local_animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_animationCallFunc  "..eventType )
            arg0 : play("run")
        elseif eventType == "Exit" then
            self:removeRewardCCBIByIdx( arg0 : getTag() )
        end
    end


    local n_Y       = 3
    local bgSize    = _bgNode:getPreferredSize()
    local bgCCBI_up = CMovieClip:create( "CharacterMovieClip/effects_frame.ccbi" )
    bgCCBI_up : setControlName( "this CActivitiesView bgCCBI_up 84")
    bgCCBI_up : registerControlScriptHandler( local_animationCallFunc )
    bgCCBI_up : setTag( self.m_rewardBG_ccbi_Idx )
    bgCCBI_up : setPosition( -bgSize.width/2, bgSize.height/2 - n_Y)
    _bgNode : addChild( bgCCBI_up , 10 , 661 )

    local bgCCBI_down = CMovieClip:create( "CharacterMovieClip/effects_frame.ccbi" )
    bgCCBI_down : setControlName( "this CActivitiesView bgCCBI_down 84")
    bgCCBI_down : registerControlScriptHandler( local_animationCallFunc )
    bgCCBI_down : setTag( self.m_rewardBG_ccbi_Idx+1 )
    bgCCBI_down : setPosition( bgSize.width/2, -bgSize.height/2 + n_Y)
    _bgNode : addChild( bgCCBI_down , 10 , 662 )

    table.insert( self.m_rewardBG_ccbi_List, bgCCBI_up )
    table.insert( self.m_rewardBG_ccbi_List, bgCCBI_down )

    local function local_moveActionCallBack()
        if bgCCBI_up ~= nil then
            self:removeRewardCCBIByIdx( bgCCBI_up:getTag() )

            bgCCBI_up : removeFromParentAndCleanup( true )
            bgCCBI_up = nil
        end

        if bgCCBI_down ~= nil then
            self:removeRewardCCBIByIdx( bgCCBI_down:getTag() )

            bgCCBI_down : removeFromParentAndCleanup( true )
            bgCCBI_down = nil
        end

        self:createRewardCCBI( _bgNode )
    end


    --移动CCBI
    local actionTime = 0.66
    local _action_up = CCArray:create()
    _action_up:addObject(CCMoveTo:create( actionTime, ccp( bgSize.width/2,bgSize.height/2 - n_Y ) ))
    _action_up:addObject(CCCallFunc:create(local_moveActionCallBack))
    bgCCBI_up : runAction( CCSequence:create(_action_up) )

    local _action_down = CCArray:create()
    _action_down:addObject(CCMoveTo:create( actionTime, ccp( -bgSize.width/2,-bgSize.height/2 + n_Y ) ))
    -- _action_down:addObject(CCCallFunc:create(local_moveActionCallBack))
    bgCCBI_down : runAction( CCSequence:create(_action_down) )

    self.m_rewardBG_ccbi_Idx = self.m_rewardBG_ccbi_Idx + 2

end

function CActivitiesView.removeRewardCCBIByIdx( self, _idx )

    if _idx == nil or self.m_rewardBG_ccbi_List == nil then 
        return
    end

    local list = self.m_rewardBG_ccbi_List
    for i,v in ipairs(list) do
        if v:getTag() == tonumber( _idx ) then
            table.remove( self.m_rewardBG_ccbi_List, i )
            return
        end
    end

end

function CActivitiesView.setActivityId( self, _id )
    print("setActivityId  _id=".._id)
    self.m_nowActivityId = _id
end

function CActivitiesView.getActivityId( self )
    return self.m_nowActivityId
end


function CActivitiesView.createButton( self, _str, _imgName, _tag, _fontSize, _fun, _controlName )
    local button = CButton:createWithSpriteFrameName( _str,_imgName )
    button : setControlName( "this CActivitiesView ".._controlName)
    button : setFontSize( _fontSize )
    if _fun ~= nil then
        button : registerControlScriptHandler( _fun, "this CActivitiesView ".._controlName)
    end
    if _tag ~= nil then
        button : setTag( _tag )
    end
    return button
end

function CActivitiesView.createIconButton( self, _str, _imgName, _tag, _fontSize, _fun, _controlName )

    table.insert(self.m_createResStr,_imgName)
    local button = CButton:create( _str,_imgName )
    button : setControlName( "this CActivitiesView ".._controlName or "")
    button : setFontSize( _fontSize )
    button : setTouchesPriority( -101 )
    if _fun ~= nil then
        button : registerControlScriptHandler( _fun, "this CActivitiesView ".._controlName or "")
    end
    if _tag ~= nil then
        button : setTag( _tag )
    end


    return button
end

function CActivitiesView.setHightLineSpr( self, _obj )

    if _obj == nil then
        return
    end

    if self.m_hightLineSpr ~= nil then 
        print("setm_HightLineSpr   remove !!!")
        self.m_hightLineSpr : removeFromParentAndCleanup( true )
        self.m_hightLineSpr = nil
    end

    self.m_hightLineSpr = CSprite:createWithSpriteFrameName( "events_page_click.png" )
    self.m_hightLineSpr : setControlName( "this CActivitiesView self.m_hightLineSpr 207"  )
    self.m_hightLineSpr : setPreferredSize( CCSizeMake( 215,52 ) )
    _obj : addChild( self.m_hightLineSpr, 1)

    -- self.hightLineSpr = CSprite:createWithSpriteFrameName( "general_label_click.png.png" )
    -- self.hightLineSpr : setControlName( "this is CActivitiesView self.hightLineSpr 125")
    -- _obj:addChild( self.hightLineSpr )
end

--初始化数据成员
function CActivitiesView.initParams( self)

	--注册mediator
    _G.pCActivitiesMediator = CActivitiesMediator(self)
    controller :registerMediator(_G.pCActivitiesMediator)--先注册后发送 否则会报错       
 	--请求界面信息

    --背景高亮
    self.m_touchBg     = {}

    --物品Id列表
    self.m_goodsIdList = {}

    --可领取奖励数量 列表
    self.m_rewardCountGetList = {}

    --清除create出来的资源
    self.m_createResStr = {}

    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据

    self.bgLineCCBIList = {}

 	

end

--释放成员
function CActivitiesView.realeaseParams( self)
    --反注册mediator
    if _G.pCActivitiesMediator ~= nil then
        controller :unregisterMediator(_G.pCActivitiesMediator)
        _G.pCActivitiesMediator = nil
    end
end



function CActivitiesView.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--加载主界面
	-- self:loadMainView()
	--布局成员
	self:layout(_mainSize)
    
end

function CActivitiesView.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenceLayer = CCScene:create()
    
    local function containerCallBack(eventType,obj,x,y)
        if eventType == "TransitionFinish" then
            print("containerCallBack")
            self :sendRquestViewMessage()
        end
    end
    
    self.m_bigContainer = CContainer:create()
    self.m_bigContainer : setControlName("this CActivitiesView self.m_bigContainer 919")
    self.m_bigContainer : registerControlScriptHandler(containerCallBack,"this CActivitiesView self.m_bigContainer 919")
    self.m_scenceLayer  : addChild(self.m_bigContainer)
    
	self:init( _mainSize, _data)
	return self.m_scenceLayer
end



function CActivitiesView.getNewRewardNotic( self, _str )

    -- print("getNewRewardNotic----->",_str,#_str)

    local newString = ""

    local posStart = 1
    -- local posEnd   = 1
    -- local strEnd   = 1

    for i=1,10 do
        
        local posEnd,strEnd = string.find(_str,"#", posStart)

        if posEnd ~= nil then
            newString = newString..string.sub( _str, posStart, posEnd-1 ).."\n"
            posStart =  strEnd + 1
            
        elseif posStart == 1 then
            return _str
        else
            return newString..string.sub( _str, posStart, #_str )
        end
    end

    return newString

end


--*****************
--xml管理
--*****************
--加载xml文件
function CActivitiesView.loadXml( self )
	_G.Config :load( "config/sales_sub.xml")
	_G.Config :load( "config/goods.xml")
    _G.Config :load( "config/sales_total.xml")
end

function CActivitiesView.unloadXml( self )
    _G.Config :unload( "config/sales_sub.xml")
    _G.Config :unload( "config/sales_total.xml")
end

--根据物品Id查找<普通物品>节点
function CActivitiesView.getGoodsNodeByGoodsId( self, _goodsId )
    return _G.Config.goodss :selectSingleNode( "goods[@id="..tostring( _goodsId ).."]" )
end

function CActivitiesView.getSalesInfoNodeById( self, _id )
    return _G.Config.sales_totals :selectSingleNode( "sales_total[@id="..tostring( _id ).."]" )
end

function CActivitiesView.getXmlRewardListById( self, _id )

    local list = {}
    local subsList  = _G.Config.sales_sub :selectSingleNode( "sales_subs[0]" ):children()
    local subsCount = subsList:getCount("sales_sub")
    for i=0,subsCount-1 do
        if tonumber(_id) == tonumber(subsList:get(i,"sales_sub"):getAttribute("id")) then
            table.insert(list,subsList:get(i,"sales_sub"))
        end
    end

    return list

end

function CActivitiesView.removeOneRewardGet( self, _subId, _activityId )
    
    if _subId == nil or _activityId == nil then
        return
    end

    local activityId = tonumber( _activityId )

    for i,v in ipairs(self.m_rewardCountGetList) do
        if v.activityId == activityId and v.subId == tonumber( _subId ) then
            table.remove( self.m_rewardCountGetList, i )
        end
    end

    print("removeOneRewardGet----------->"..self:getRewardCountById( _activityId ))

    if self:getRewardCountById( _activityId ) == 0 then
        if self.m_tabPageImg[activityId] ~= nil then
            self.m_tabPageImg[activityId] : setImageWithSpriteFrameName( "events_page_normal.png" )
            self.m_tabPageImg[activityId] : setPreferredSize( CCSizeMake( 215,52 ) )
        end

        if self.m_tabPageCCBI[activityId] ~= nil then

            if self.m_tabPageCCBI[activityId] : getChildByTag( 901 ) ~= nil then
                self.m_tabPageCCBI[activityId] : removeChildByTag( 901 )
            end

            if self.m_tabPageCCBI[activityId] : getChildByTag( 902 ) ~= nil then
                self.m_tabPageCCBI[activityId] : removeChildByTag( 902 )
            end

            self.m_tabPageCCBI[activityId] : removeFromParentAndCleanup( true )
            self.m_tabPageCCBI[activityId] = nil
        end
    end

end

function CActivitiesView.getRewardCountById( self, _activityId )

    if _activityId == nil then
        return 0 
    end

    local activityId = tonumber( _activityId )
    local count = 0 

    for i,v in ipairs(self.m_rewardCountGetList) do
        if v.activityId == activityId then
            count = count + 1
        end
    end

    return count

end





--************************
--按钮回调
--************************
--关闭 单击回调
function CActivitiesView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            
            obj : setTouchesEnabled(false)
            
            print("CActivitiesView.closeBtnCallback   ")

			self :realeaseParams()

            self : removeAllCCBI() --删除所有特效

            self : unloadResources()
			CCDirector:sharedDirector():popScene()

            self : sendRquestViewMessage() --重新请求数据(缓存更新)

            self = nil

		end
	end
end


function CActivitiesView.pageTabCallBack(self,eventType,obj,x,y)   --Page页面按钮回调
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        print("更换界面了 tag="..pageTag)
        self:setActivityId( pageTag )

        if self.m_tabPageImg[pageTag] ~= nil then
            print("æææææææææææææææææææææ--->ok")

            self:setHightLineSpr( self.m_tabPageImg[pageTag] )
        else
            print("æææææææææææææææææææææ--->nil")
        end
        
    end
end

--单笔充值送好礼  领取奖励按钮回调
function CActivitiesView.DBCZSHL_getRewardCallback(self,eventType,obj,x,y)   --Page页面按钮回调
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local  tag = obj : getTag()
            print("单笔充值送好礼  领取奖励按钮回调 tag="..tag)
            if self.m_touchBtn ~= nil then
                return
            end

            if obj.setText == nil then
                print("~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!!!!!!    不是button",obj:getControlName())
                -- return
            end
            
            self:sendDBCZSHL_getRewardMessage( tag )
            self.m_touchBtn = obj

            self:chuangItemBgForObj( obj:getParent(),self:getActivityId() )


            self:removeOneRewardGet( tag, self:getActivityId() )
        end
    end
end

--新手卡  兑换按钮回调
function CActivitiesView.XSK_duiHuanCallback(self,eventType,obj,x,y)   --Page页面按钮回调
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("新手卡  兑换按钮回调 ")
        if self.m_editBox ~= nil then 
            local _string = self.m_editBox : getTextString()
            local xskStr  = string.match(_string,"%s*(.-)%s*$") 
            if xskStr ~= "" then
                self : sendXSK_DuiHuangMessage( xskStr )
            end
        end
    end
end


--物品展示 单击回调
function CActivitiesView.goodsTouchCallback(self, eventType, obj, touches)
	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID1    = touch :getID()
                    self.index       = obj   :getTag()
                    break
                end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID1 == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID1 and self.index == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    print("添加Tips   tag="..obj:getTag(),self:getActivityId())
                    local index     = tonumber(obj:getTag())
                    local goodsId   = self.m_goodsIdList[self:getActivityId()][index]
                    local _winSize  = CCDirector:sharedDirector():getVisibleSize()
					local _mainSize = CCSizeMake( 854, _winSize.height )

                    local _position = {}
                    _position.x = touch2Point.x - (_winSize.width/2 - _mainSize.width/2)
                    _position.y = touch2Point.y

					local temp = _G.g_PopupView :createByGoodsId( goodsId, 10, _position)
					self.m_mainContainer :addChild( temp , 2000 )

                    self:chuangItemBgForObj( obj:getParent():getParent(),self:getActivityId() )

                    self.touchID1     = nil
                    self.index       = nil
                end
            end
        end
        print( eventType,"END")
    end
end

--背景 单击回调
function CActivitiesView.bgTouchCallBack( self, eventType , obj , touches )
    if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID2 = touch :getID()
                self.touchIdx = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID2 == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID2 and self.touchIdx == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    self :chuangItemBgForObj( obj, self:getActivityId() )

                    self.touchID2  = nil
                    self.touchIdx  = nil
                end
            end
        end
    end
end


function CActivitiesView.chuangItemBgForObj( self, _obj, _type )

    if _obj == nil or _type == nil then 
        return
    end

    local cellSize = CCSizeMake( 547, 109 )
    if self.m_touchBg[_type] ~= nil then
        self.m_touchBg[_type] : removeFromParentAndCleanup( true )
        self.m_touchBg[_type] = nil 
    end

    self.m_touchBg[_type] = CSprite :createWithSpriteFrameName("general_underframe_click.png")
    self.m_touchBg[_type] : setPreferredSize( cellSize )
    _obj :addChild( self.m_touchBg[_type],2,999 )

end





--************************
--发送协议
--************************
--请求界面
function CActivitiesView.sendRquestViewMessage( self )
	require "common/protocol/auto/REQ_CARD_SALES_ASK"
	local msg = REQ_CARD_SALES_ASK()
	CNetwork : send( msg )
end

--发送领取<单笔充值送好礼>奖励
function CActivitiesView.sendDBCZSHL_getRewardMessage( self, _id )
    require "common/protocol/auto/REQ_CARD_SALES_GET"
    local getId = self:getActivityId()
    local msg = REQ_CARD_SALES_GET()
    msg : setId( getId )
    msg : setIdStep( _id )
    CNetwork : send( msg )
end


--发送兑换<新手卡>
function CActivitiesView.sendXSK_DuiHuangMessage( self, _str )
    require "common/protocol/auto/REQ_CARD_GETS"
    print("领取新手卡 ---- ".._str)
    local msg = REQ_CARD_GETS()
    msg : setIds( _str )
    CNetwork : send( msg )
end


function CActivitiesView.geRewardCallBack( self )

    if self.m_touchBtn ~= nil then 


        if self.m_touchBtn : getChildByTag("999") ~= nil then--setText("已领取")
            self.m_touchBtn : removeChildByTag("999")
        end

        local btnName = CCLabelTTF:create( "已领取", "Arial", 26 )
        self.m_touchBtn : addChild( btnName, 10, 999 )

        self.m_touchBtn : setTouchesEnabled( false )
        
        local bgCell = self.m_touchBtn:getParent()
        if bgCell : getChildByTag(661) ~= nil then
            bgCell : removeChildByTag(661)
        end

        if bgCell : getChildByTag(662) ~= nil then
            bgCell : removeChildByTag(662)
        end

        self.m_touchBtn = nil
    end
end


function CActivitiesView.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenceLayer   : addChild(BoxLayer,1000)
end



function CActivitiesView.Create_effects_equip ( self,obj,name_color,id) 
    name_color = tonumber(name_color)
    if name_color > 0 and name_color < 8 then 
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end
  
        if obj ~= nil and id ~= nil  then
            self["effect_ccbi"..id] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..id] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..id] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..id],1000)

            self : setSaveCreateEffectCCBIList(id)
        end
    end
end

function CActivitiesView.setSaveCreateEffectCCBIList ( self,id) 
    print("CActivitiesView 存表----",id)
    local data = {}
    -- data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
    print("CActivitiesView 村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CActivitiesView.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CActivitiesView.removeAllCCBI ( self) 
    print("CActivitiesView 开始调用删除CCBI")
    -- local data = self :getShowList() 
    local data = self :getSaveCreateEffectCCBIList() 
    print("1")
    if  data ~= nil then
        print("2")
        for k,goods in pairs(data) do
            print("3")
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                local id = goods.id
                --local index = goods.index
                if  self["effect_ccbi"..id] ~= nil then
                    print("4")
                    self["effect_ccbi"..id] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..id] = nil 
                    print("CActivitiesView 删除了CCBI,其名为=========",id)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
end
