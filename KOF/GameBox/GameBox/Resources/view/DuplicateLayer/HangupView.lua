--[[--HangupView--挂机界面--]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "model/GameDataProxy"
require "mediator/HangupMediator"
require "view/LuckyLayer/PopBox"

CHangupView = class(view, function( self, _rewardData)
    print("CHangupView：挂机啦")
    self.PopBox = nil

    if _rewardData == nil then
        self.m_rewardData = {}
        self.m_isUnloadResources = false
    else
        self.m_rewardData = _rewardData
        self.m_isUnloadResources = true
    end

    print("««««««««««««««««««««««««««««««")
    for i,v in ipairs(self.m_rewardData) do
        print(i,v.nowtimes,v.sumtimes,v.count)
    end
    print("««««««««««««««««««««««««««««««")

end)
--Constant:

CHangupView.TAG_CLOSED     = 207
CHangupView.TAG_HANGUP     = 208
CHangupView.TAG_SPEEDUP    = 209
CHangupView.TAG_RADIO_USER = 210
CHangupView.TAG_RADIO_ALL  = 211

CHangupView.TYPE_STOP    = 1
CHangupView.TYPE_HUANGUP = 2
CHangupView.TYPE_SPEED   = 3

--颜色
CHangupView.COLOR_GREEN    = ccc4(91,200,19,255)
CHangupView.COLOR_BLUE     = ccc4(0,155,255,255)
CHangupView.COLOR_GOLD     = ccc4(255,155,0,255)
CHangupView.COLOR_YERROW   = ccc4(255,255,0,255)

--加载资源
function CHangupView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("DuplicateResources/DuplicateResources.plist") 

    
end

--释放资源
function CHangupView.unloadResource( self)
    
    if self.m_isUnloadResources then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("DuplicateResources/DuplicateResources.plist")
        CCTextureCache :sharedTextureCache():removeTextureForKey("DuplicateResources/DuplicateResources.pvr.ccz")

        local r = CCTextureCache :sharedTextureCache():textureForKey(self.m_copyImgStr)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
        
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
    end

    local r1 = CCTextureCache :sharedTextureCache():textureForKey("LuckyResources/general_pages_normal.png")
    if r1 ~= nil then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r1)
        CCTextureCache :sharedTextureCache():removeTexture(r1)
        r1 = nil
    end

    local r2 = CCTextureCache :sharedTextureCache():textureForKey("LuckyResources/general_pages_pressing.png")
    if r2 ~= nil then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r2)
        CCTextureCache :sharedTextureCache():removeTexture(r2)
        r2 = nil
    end

    -- CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()



end

--初始化数据成员
function CHangupView.initParams( self , _copyId , _isUseAll, _time , _hangUpTimes , _nowTimes, _maxTimes )
    print("CHangupView.initParams ".._hangUpTimes)
    --全局变量  
    self.m_hangupCdTime = _G.Constant.CONST_COPY_UP_TIME         --初始化挂机CD时间
    self.m_totalTime    = _time     --倒计时总时间
    self.m_HangupNumber = _hangUpTimes --挂机总次数
    self.m_isUseAll     = _isUseAll --是否选择了(使用全部体力)
    self.m_hangUpTimes  = _hangUpTimes --离线挂机返回的总挂机次数
    self.m_nowTimes     = _nowTimes --当前挂机->第几轮
    self.m_maxTimesCanUse = _maxTimes or self :getHangupTimesByCopyId( _copyId )
    -- self.m_btnState     = 0 

    --挂机数据
    self.m_sceneCopyInfo   = self:getSceneCopys(_copyId)
    self.m_copyRewardsInfo = self:getCopyRewards(_copyId)

    local goodsId = self.m_copyRewardsInfo:children():get(0,"b_goods"):children():get(0,"goods"):getAttribute("goods_id")
    if goodsId == nil then 
        local function isEmpty()
            return true
        end
        self.m_goodsInfo = {}
        self.m_goodsInfo.isEmpty = isEmpty
    else
        self.m_goodsInfo = self:getGoodsById(goodsId)
    end

    --注册Mediator
    self.m_hangupMediator = CHangupMediator(self)
    controller :registerMediator(self.m_hangupMediator)--先注册后发送 否则会报错

end

--释放成员
function CHangupView.realeaseParams( self)
    
end

--布局成员
function CHangupView.layout( self, mainSize)
    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    self.m_hangupViewContainer :setPosition( ccp( winSize.width/2-mainSize.width/2, 0 ) )
    self.m_background          :setPosition( ccp( winSize.width/2, winSize.height/2 ) )

    local hangupbackgroundfirst     = self.m_hangupViewContainer :getChildByTag( 100)
    local hanguppromptbackground    = self.m_hangupViewContainer :getChildByTag( 101)
    local functionbackground        = self.m_hangupFunctionContainer :getChildByTag( 102)
    local duplicatenamebackground   = self.m_hangupFunctionContainer :getChildByTag( 103)
    local duplicaterewardbackground = self.m_hangupFunctionContainer :getChildByTag( 104)
    local closedButtonSize          = self.m_closedButton :getContentSize()

    
    hangupbackgroundfirst     :setPreferredSize( CCSizeMake( mainSize.width, mainSize.height))
    hanguppromptbackground    :setPreferredSize( CCSizeMake( 495, 608))
    functionbackground        :setPreferredSize( CCSizeMake( 325, 608))
    duplicatenamebackground   :setPreferredSize( CCSizeMake( 290, 180))
    duplicaterewardbackground :setPreferredSize( CCSizeMake( 295, 125))
    hangupbackgroundfirst     :setPosition( ccp( mainSize.width/2, mainSize.height/2))
    hanguppromptbackground    :setPosition( ccp( 263, mainSize.height/2))
    self.m_hangupViewCenterContainer : setPosition( ccp( 0, 0))

    -----------------------------------
    --挂机提示
    -----------------------------------
    self.m_hangupPromptLabel1 :setAnchorPoint( ccp( 0 , 0.5) )
    self.m_hangupPromptLabel2 :setAnchorPoint( ccp( 0 , 0.5) )
    self.m_hangupPromptLabel3 :setAnchorPoint( ccp( 0 , 0.5) )
    self.m_hangupPromptLabel4 :setAnchorPoint( ccp( 0 , 0.5) )
    self.m_hangupPromptLabel5 :setAnchorPoint( ccp( 0 , 0.5) )
    self.m_hangupPromptLabel1 :setPosition( ccp( 25, mainSize.height*0.94))
    self.m_hangupPromptLabel2 :setPosition( ccp( 25, mainSize.height*0.88))
    self.m_hangupPromptLabel3 :setPosition( ccp( 25, mainSize.height*0.825))
    self.m_hangupPromptLabel4 :setPosition( ccp( 25, mainSize.height*0.77))
    self.m_hangupPromptLabel5 :setPosition( ccp( 25, mainSize.height*0.715))

    self.m_nameBackgroundTopBg     :setPreferredSize( CCSizeMake( 200, 39 ) )
    functionbackground             :setPosition( ccp( 678, mainSize.height/2))
    duplicatenamebackground        :setPosition( ccp( 678, 480))
    duplicaterewardbackground      :setPosition( ccp( 678, 170))
    self.m_nameBackgroundTopBg     :setPosition( ccp( 678, 570))
    self.m_nameBackgroundCenterBg  :setPosition( ccp( 678, 490))
    self.m_nameBackgroundCenterImg :setPosition( ccp( 678, 475))
    self.m_duplicateNameLabel1     :setPosition( ccp( 678, 570))
    self.m_duplicateNameLabel2     :setPosition( ccp( 678, 427))
    self.m_hangupStartButton       :setPosition( ccp( 598, mainSize.height*0.1))
    self.m_speedupButton           :setPosition( ccp( 760, mainSize.height*0.1))
    self.m_closedButton            :setPosition( ccp( mainSize.width-closedButtonSize.width/2, mainSize.height-closedButtonSize.height/2))

    --挂机奖励
    self.m_rewardLb  :setAnchorPoint( ccp( 0,0.5 ) )
    self.m_rewardLb1 :setAnchorPoint( ccp( 0,0.5 ) )
    self.m_rewardLb2 :setAnchorPoint( ccp( 0,0.5 ) )
    self.m_rewardLb3 :setAnchorPoint( ccp( 0,0.5 ) )
    self.m_rewardLb  :setPosition( ccp( 540, 200))
    self.m_rewardLb1 :setPosition( ccp( 540, 167))
    self.m_rewardLb2 :setPosition( ccp( 690, 167))
    self.m_rewardLb3 :setPosition( ccp( 540, 135))
    if self.m_goodsInfo:isEmpty() == false then 
        self.m_rewardLb4 :setAnchorPoint( ccp( 0,0.5 ) )
        self.m_rewardLb2 :setPosition( ccp( 675, 167))
        self.m_rewardLb4 :setPosition( ccp( 675, 135))
    end

    -----------------------------------
    --挂机类型
    -----------------------------------
    self.m_userUsedTiLiLabel :setAnchorPoint( ccp( 0 ,0.5))
    self.m_userRadioBoxLabel :setAnchorPoint( ccp( 0 ,0.5))
    self.m_allRadioBoxLabel  :setAnchorPoint( ccp( 0 ,0.5))
    self.m_userRadioBox      :setPosition( ccp( mainSize.width*0.645,mainSize.height*0.55))
    self.m_allRadioBox       :setPosition( ccp( mainSize.width*0.645,mainSize.height*0.48))
    self.m_userRadioBoxLabel :setPosition( ccp( mainSize.width*0.68,mainSize.height*0.55))
    self.m_allRadioBoxLabel  :setPosition( ccp( mainSize.width*0.68,mainSize.height*0.48))
    self.m_userNumEditBox    :setPosition( ccp( mainSize.width*0.813, mainSize.height*0.55))
    self.m_userUsedTiLiLabel :setPosition( ccp( mainSize.width*0.855, mainSize.height*0.55))

    -----------------------------------
    --挂机CD
    -----------------------------------
    local cdY = mainSize.height*0.41
    local cdX = mainSize.width*0.845
    
    self.m_hangupCDTimeLabel : setPosition( ccp( cdX ,cdY) )
    self.m_hangupCDLabel     : setAnchorPoint( ccp( 1 , 0.5))
    self.m_hangupCDLabel     : setPosition( ccp( cdX - 50, cdY) )

end

--主界面初始化
function CHangupView.init(self, _mainSize, _layer, _copyId , _isUseAll, _time , _hangUpTimes , _nowTimes, _maxTimes)
    print("viewID:",self._viewID)
    --加载资源
    self :loadResource()
    --初始化数据
    self :initParams( _copyId , _isUseAll, _time , _hangUpTimes , _nowTimes, _maxTimes)
    --初始化界面
    self :initView( _layer, _mainSize)
    --布局成员
    self :layout(_mainSize)  

    --更新界面显示(主要用于离线时)
    self :showCheckPointView() 
end
--pushScene(_G.pHangupView:scene(_ackMsg:getCopyId() , _ackMsg:getUseAll() , _ackMsg:getTime() , _ackMsg:getSumtimes() , _ackMsg:getNowtimes(), _ackMsg:getNum()))
function CHangupView.scene( self, _copyId , _isUseAll, _time , _hangUpTimes , _nowTimes, _maxTimes)
    print("create scene")
    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    local mainSize = CCSizeMake( 854, winSize.height )

    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CHangupView self.m_scenelayer 162" )
    self :init(mainSize, self.m_scenelayer, _copyId , _isUseAll, _time , _hangUpTimes , _nowTimes, _maxTimes)

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_scenelayer :registerControlScriptHandler(local_onEnter,"CHangupView scene self.m_scenelayer 58")

    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CHangupView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        _G.pCGuideManager:initGuide( self.m_scenelayer, 0 )
        -- print("CHangupView.onEnter  ")
        -- local function runInitGuide()
            
        -- end
        -- _G.pCGuideManager:lockScene()
        -- self.m_scenelayer:performSelector(0.08,runInitGuide)
        
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( 0 ) --tonumber(self.m_sceneCopyInfo:getAttribute("copy_id"))
    end
end

function CHangupView.getHangupBtn( self )
    if self.m_hangupStartButton:isVisible() then
        return self.m_hangupStartButton
    else
        return nil
    end
end

function CHangupView.getSpeedBtn( self )
    if self.m_speedupButton:isVisible() then
        return self.m_speedupButton
    else
        return nil
    end
end

function CHangupView.layer( self)
    print("create m_scenelayer")
    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    local mainSize = CCSizeMake( 854, winSize.height )
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CHangupView self.m_scenelayer 173" )
    self :init(mainSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化挂机界面
function CHangupView.initView(self, layer, _mainSize)
    print("CHangupView.initHangupView")
    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CFirstTopupGiftView self.m_background 26 ")
    self.m_background : setPreferredSize( winSize )
    layer : addChild( self.m_background )

    --挂机界面容器
    self.m_hangupViewContainer = CContainer :create()
    self.m_hangupViewContainer : setControlName( "this is CHangupView self.m_hangupViewContainer 185" )
    layer :addChild( self.m_hangupViewContainer)
    
    local function CellCallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local hangupbackgroundfirst  = CSprite :createWithSpriteFrameName( "general_first_underframe.png")      --副本背景Img
    local hanguppromptbackground = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --副本背景二级Img
    hangupbackgroundfirst  : setControlName( "this CHangupView hangupbackgroundfirst 193 ")
    hanguppromptbackground : setControlName( "this CHangupView hanguppromptbackground 194 ")
    
    self.m_closedButton          = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
    self.m_closedButton : setControlName( "this CHangupView self.m_closedButton 197 " )
    
    self.m_closedButton :setTag( CHangupView.TAG_CLOSED)    
    self.m_closedButton :registerControlScriptHandler( CellCallBack, "this CHangupView self.m_closedButton 200")
    
    self.m_hangupViewContainer :addChild( hangupbackgroundfirst, -1, 100)
    self.m_hangupViewContainer :addChild( hanguppromptbackground, -1, 101)
    self.m_hangupViewContainer :addChild( self.m_closedButton, 2)
    
    -----------------------------------
    --挂机提示
    -----------------------------------
    self.m_hangupViewCenterContainer = CContainer :create()
    self.m_hangupViewCenterContainer : setControlName( "this is CHangupView self.m_hangupViewCenterContainer 208" )
    self.m_hangupViewContainer       : addChild( self.m_hangupViewCenterContainer,10)
    
    self.m_noticContainer = CContainer :create()
    self.m_noticContainer : setControlName( "this is CHangupView self.m_noticContainer 208" )
    self.m_hangupViewCenterContainer : addChild( self.m_noticContainer,10)

    self.m_hangupPromptLabel1        = self :createLabel(  self.m_noticContainer, "挂机提示:", "Arial", 20 )
    self.m_hangupPromptLabel2        = self :createLabel(  self.m_noticContainer, "1.挂机前查看背包是否有空位可拾取奖励.", "Arial", 20 )
    self.m_hangupPromptLabel3        = self :createLabel(  self.m_noticContainer, "2.挂机不需要保持在线.", "Arial", 20 )
    self.m_hangupPromptLabel4        = self :createLabel(  self.m_noticContainer, "3.VIP玩家挂机可获得“S”级奖励.", "Arial", 20 )
    self.m_hangupPromptLabel5        = self :createLabel(  self.m_noticContainer, "4.VIP4免精英副本挂机CD.", "Arial", 20 )

    -----------------------------------
    --挂机功能界面
    -----------------------------------
    self.m_hangupFunctionContainer = CContainer :create()
    self.m_hangupFunctionContainer : setControlName( "this is CHangupView self.m_hangupFunctionContainer 230" )
    self.m_hangupViewContainer     : addChild( self.m_hangupFunctionContainer)

    local copyImg = self.m_sceneCopyInfo:getAttribute("desc")
    self.m_copyImgStr  = "DuplicateResources/fb_"..copyImg..".png"
    if _G.PathCheck : check( self.m_copyImgStr ) == false then
        self.m_copyImgStr  = "DuplicateResources/fb_10110.png"
    end

    local functionbackground        = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    local duplicatenamebackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    local duplicaterewardbackground = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    self.m_nameBackgroundTopBg      = CSprite :createWithSpriteFrameName( "copy_title_frame.png", CCRectMake(52,0,8,39))
    self.m_nameBackgroundCenterImg  = CSprite :createWithSpriteFrameName( "copy_frame_normal11.png")
    self.m_nameBackgroundCenterBg   = CSprite :create( self.m_copyImgStr )
    self.m_duplicateNameLabel1      = self :createLabel(  self.m_hangupFunctionContainer, self.m_sceneCopyInfo:getAttribute("copy_name"), "Arial", 20 )
    self.m_duplicateNameLabel2      = self :createLabel(  self.m_hangupFunctionContainer, self.m_sceneCopyInfo:getAttribute("copy_name"), "Arial", 20 )
    self.m_duplicateNameLabel1      : setZOrder( 100 )
    self.m_duplicateNameLabel2      : setZOrder( 100 )
-- \n经验 "..tostring(self.m_copyRewardsInfo:getAttribute("b_exp")).." 潜能 "..tostring(self.m_copyRewardsInfo:getAttribute("b_power")).."\n银币 "..tostring(self.m_copyRewardsInfo:getAttribute("b_money"))..\n"
    self.m_rewardLb     = self :createLabel(  self.m_hangupFunctionContainer, "挂机单次奖励:", "Arial", 20, CHangupView.COLOR_GOLD )
    self.m_rewardLb1    = self :createLabel(  self.m_hangupFunctionContainer, "经验  "..tostring(self.m_copyRewardsInfo:getAttribute("b_exp")), "Arial", 20 )
    self.m_rewardLb2    = self :createLabel(  self.m_hangupFunctionContainer, "潜能  "..tostring(self.m_copyRewardsInfo:getAttribute("b_power")), "Arial", 20 )
    self.m_rewardLb3    = self :createLabel(  self.m_hangupFunctionContainer, "美刀  "..tostring(self.m_copyRewardsInfo:getAttribute("b_money")), "Arial", 20 )
    if self.m_goodsInfo:isEmpty() == false then 
        self.m_rewardLb4    = self :createLabel(  self.m_hangupFunctionContainer, "物品 "..self.m_goodsInfo:getAttribute("name").."x"..self.m_copyRewardsInfo:children():get(0,"b_goods"):children():get(0,"goods"):getAttribute("goods_count"), "Arial", 20 )
    end

    self.m_hangupStartButton        = CButton :createWithSpriteFrameName( "挂机", "general_button_normal.png")
    self.m_speedupButton            = CButton :createWithSpriteFrameName( "加速", "general_button_normal.png")

    functionbackground        : setControlName( "this CHangupView functionbackground 240 ")
    duplicatenamebackground   : setControlName( "this CHangupView duplicatenamebackground 241 ")
    duplicaterewardbackground : setControlName( "this CHangupView duplicaterewardbackground 242 ")
    self.m_hangupStartButton  : setControlName( "this CHangupView self.m_hangupStartButton 243 " )
    self.m_speedupButton      : setControlName( "this CHangupView self.m_speedupButton 243 " )

    self.m_hangupStartButton :setFontSize( 30)
    self.m_hangupStartButton :setTag( CHangupView.TAG_HANGUP)
    self.m_hangupStartButton :registerControlScriptHandler( CellCallBack, "this CHangupView self.m_hangupStartButton 250")

    self.m_speedupButton :setFontSize( 30)
    self.m_speedupButton :setTag( CHangupView.TAG_SPEEDUP)
    self.m_speedupButton :registerControlScriptHandler( CellCallBack, "this CHangupView self.m_speedupButton 254")

    self.m_hangupFunctionContainer :addChild( functionbackground, -1, 102)
    self.m_hangupFunctionContainer :addChild( duplicatenamebackground, -1, 103)
    self.m_hangupFunctionContainer :addChild( duplicaterewardbackground, -1, 104)
    self.m_hangupFunctionContainer :addChild( self.m_nameBackgroundTopBg)
    self.m_hangupFunctionContainer :addChild( self.m_nameBackgroundCenterImg)
    self.m_hangupFunctionContainer :addChild( self.m_nameBackgroundCenterBg)
    self.m_hangupFunctionContainer :addChild( self.m_hangupStartButton)
    self.m_hangupFunctionContainer :addChild( self.m_speedupButton)

    self.m_speedupButton :setTouchesEnabled(false)

    -----------------------------------
    --挂机类型
    -----------------------------------
    self.m_userRadioBoxLabel        = self :createLabel(  self.m_hangupFunctionContainer, "挂机次数", "Arial", 20 )
    self.m_allRadioBoxLabel         = self :createLabel(  self.m_hangupFunctionContainer, "消耗所有体力", "Arial", 20,CHangupView.COLOR_YERROW )
    self.m_userRadioBox             = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "")
    self.m_allRadioBox              = CCheckBox :create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "")

    self.m_userRadioBox : setControlName( "this CHangupView m_userRadioBox 262 ")
    self.m_allRadioBox  : setControlName( "this CHangupView m_allRadioBox 263 ")

    self.m_userRadioBox :setTag( CHangupView.TAG_RADIO_USER)
    self.m_allRadioBox  :setTag( CHangupView.TAG_RADIO_ALL)
    self.m_userRadioBox :setFontSize(20)
    self.m_allRadioBox  :setFontSize(20)
    self.m_userRadioBox :registerControlScriptHandler( CellCallBack, "this CHangupView self.m_userRadioBox 269")
    self.m_allRadioBox  :registerControlScriptHandler( CellCallBack, "this CHangupView self.m_allRadioBox 270")

    local _editBg                   = CCScale9Sprite:createWithSpriteFrameName("general_second_underframe.png")
    self.m_userNumEditBox           = CEditBox:create( CCSizeMake( 60, 30 ), _editBg, 3, "", kEditBoxInputFlagSensitive)
    self.m_userUsedTiLiLabel        = self :createLabel(  self.m_hangupFunctionContainer, "次30体力", "Arial", 20 )

    self.m_userNumEditBox : setEditBoxInputMode( kEditBoxInputModePhoneNumber)
    self.m_userNumEditBox : registerControlScriptHandler( CellCallBack, "this CHangupView self.m_userNumEditBox 276")

    self.m_userRadioBox   : setChecked( true )
    self.m_userNumEditBox : setTextString( tostring( self.m_HangupNumber )) 
    self.m_userNumEditBox : setFontColor( CHangupView.COLOR_YERROW )
    self.m_hangupFunctionContainer : addChild(self.m_userRadioBox)
    self.m_hangupFunctionContainer : addChild(self.m_allRadioBox)
    self.m_hangupFunctionContainer : addChild( self.m_userNumEditBox )

    -----------------------------------
    --挂机CD
    -----------------------------------
    self.m_hangupCDLabel            = self :createLabel(  self.m_hangupFunctionContainer, "挂机时间:", "Arial", 20,CHangupView.COLOR_YERROW )
    self.m_hangupCDTimeLabel        = self :createLabel(  self.m_hangupFunctionContainer, "00:00:00", "Arial", 20,CHangupView.COLOR_YERROW )

end

function CHangupView.showCheckPointView( self)

    if self.m_isUseAll == 1 then
        self.m_userRadioBox : setChecked( false )
        self.m_allRadioBox  : setChecked( true )   
        self.m_userUsedTiLiLabel : setString("次".. tostring(self.m_HangupNumber*tonumber(self.m_sceneCopyInfo:getAttribute("use_energy"))).."体力")
    else
        self.m_userUsedTiLiLabel : setString("次".. tostring(self.m_HangupNumber*tonumber(self.m_sceneCopyInfo:getAttribute("use_energy"))).."体力")
    end

    if self.m_totalTime >= 0 then 
        --存在离线挂机
        self.m_isLiXian = true

        --清楚奖励信息界面的控件
        -- self : clearRewardView()

        --非离线时打开的 self.m_totalTime=-1

        print("showCheckPointView-->",#self.m_rewardData)
        

        if self.m_totalTime == 0 then
            --离线挂机已完成
            local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
            if copyType == _G.Constant.CONST_COPY_TYPE_HERO or copyType == _G.Constant.CONST_COPY_TYPE_FIEND then
                self.m_maxTimesCanUse = 0
            end

            self:setHuangUpType( CHangupView.TYPE_STOP )

            self : clearRewardView()
            self : showRewardView()
        else
            --离线挂机还未完成
            local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
            if copyType == _G.Constant.CONST_COPY_TYPE_HERO or copyType == _G.Constant.CONST_COPY_TYPE_FIEND then
                self.m_maxTimesCanUse = 1
            end

            --继续挂机 重置<挂机>按钮为<取消>按钮
            self : setHuangUpType( CHangupView.TYPE_HUANGUP )
            --获取挂机CD时间
            self.m_hangupCdTime = self:getCDTimes( self.m_sceneCopyInfo:getAttribute("copy_type") )

            self : setTime(self.m_totalTime)

            self : clearRewardView()
            self : showRewardView()
        end
        --重设 EditBox 的输入数字
        self.m_userNumEditBox : setTextString(tostring(self.m_HangupNumber))
    else
        self.m_isLiXian = false
        self:setHuangUpType( CHangupView.TYPE_STOP )
    end

    self :resetViewFromCopyType(  )

end

function CHangupView.resetViewFromCopyType( self )
    --根据副本类型改变界面   主要是能不能选择全部体力挂机

    local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
    if copyType == _G.Constant.CONST_COPY_TYPE_FIEND then --copyType == _G.Constant.CONST_COPY_TYPE_HERO or
        self.m_allRadioBox    :setTouchesEnabled( false )
        self.m_userNumEditBox :setTouchesEnabled( false )

        local mainSize = CCSizeMake( 854, 640 )
        local XLabel = self :createLabel(  self.m_hangupFunctionContainer, "X", "Arial", 39, ccc4( 255,0,0,255 ) )
        XLabel : setPosition( ccp( mainSize.width*0.646+1,mainSize.height*0.48-1 ) )
    end
end

--*****************
--清除奖励信息范围的控件
--*****************
function CHangupView.clearRewardView( self )

    if self.m_noticContainer ~= nil then
        self.m_noticContainer : removeFromParentAndCleanup( true )
        self.m_noticContainer = nil
    end

end


--*****************
--展示奖励信息
--*****************
function CHangupView.showRewardView( self )
    -- body
    print("function CHangupView.showRewardView( self )  ",debug.traceback())


    if self.m_rewardData == nil then
        print("#self.m_rewardData < 1")
        return
    end

    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    local mainSize = CCSizeMake( 854, winSize.height )

    self:clearRewardView()

    local viewSize = CCSizeMake( mainSize.width*0.55 , mainSize.height*0.9 )
    
    self.m_noticContainer = CContainer :create()
    self.m_noticContainer : setControlName( "this is CHangupView self.m_noticContainer 208" )
    self.m_hangupViewCenterContainer : addChild( self.m_noticContainer,10)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView : setTouchesPriority(-1)
    self.m_pScrollView : setPosition( ccp(mainSize.width*0.02 , mainSize.height*0.05))
    self.m_noticContainer :addChild( self.m_pScrollView )

    local data = self.m_rewardData

    local dataCount = #data

    if self.m_nowStateType == CHangupView.TYPE_HUANGUP then
        local myVip  = tonumber( _G.g_characterProperty : getMainPlay() :getVipLv() )
        local minVip = tonumber(self.m_sceneCopyInfo:getAttribute("fast_vip"))
        if myVip < minVip then
            --非vip加速中
            if #self.m_rewardData > 0 then
                if tonumber( self.m_rewardData[#self.m_rewardData].nowtimes ) < tonumber( self.m_rewardData[#self.m_rewardData].sumtimes ) then
                --不是最后一轮
                    dataCount = dataCount + 1
                end
            else
                dataCount = dataCount + 1
            end
            
        end
        
    end

    local totalCount = dataCount
    local pageNum    = 0
    if totalCount > 0 and totalCount <=5 then 
        pageNum = 1
    elseif totalCount > 5 and totalCount <=10 then
        pageNum = 2
    end


    local index = 0
    if dataCount > #data then
        index = -1
    end
    for i = 1, pageNum, 1 do

        local tempContainer = CContainer : create()
        tempContainer       : setControlName("this is CHangupView tempContainer 463")

        local tempLayout = CVerticalLayout : create()
        tempLayout :setControlName("this is CHangupView tempLayout 468")
        tempLayout :setCellSize( CCSizeMake( mainSize.width*0.65, mainSize.height*0.4))
        tempLayout :setVerticalDirection( true)
        tempLayout :setHorizontalDirection( false)
        tempLayout :setLineNodeSum( 1)
        tempLayout :setColumnNodeSum( 2)
        tempLayout :setCellVerticalSpace( 0)
        tempLayout :setCellHorizontalSpace( 0)
        tempLayout :setAnchorPoint( ccp(0,0))
        tempLayout :setPosition( -mainSize.width*0.6,-mainSize.height*0.25)

        tempContainer : addChild(tempLayout)

        
        print("pageNum,i ,totalCount%5",pageNum,i,totalCount%5)
        if i == 1 and totalCount%5 == 0 then
            self : addReward( tempLayout , index,5)
            index = index + 5
        elseif i == 1 then
            self : addReward( tempLayout , index,totalCount%5)
            index = index + totalCount%5
        else
            self : addReward( tempLayout , index,5)
            index = index + 5
        end

        self.m_pScrollView  : addPage(tempContainer , true)
    end
    if pageNum == 1 then 
        self.m_pScrollView : setPage(0,false)
    end
end

--*****************
--添加一页奖励信息
--*****************
function CHangupView.addReward( self , tempNode, idx, num)


    local tempContainer = CContainer :create()
    tempContainer       : setControlName( "this is CHangupView tempContainer 506" )


    local winSize  = CCDirector :sharedDirector() :getVisibleSize() 
    local mainSize = CCSizeMake( 854, winSize.height )
    local startIndex = #self.m_rewardData - idx - num + 1
    

    -- print("CHangupView.addReward  ----- >  ",idx,num,startIndex,#self.m_rewardData)

    for i=1,num,1 do
        --local titleLabel       = CCLabelTTF :create( string.format("第%d轮战斗",tonumber(whichTimes)),"Arial", 25)

        if self.m_rewardData[startIndex] == nil then
            --添加正在挂机中
            local function local_containerCallBack( eventType, obj, x, y )
                if eventType == "Enter" then
                    self.m_actionTime = 0
                    self.m_actionStr  = self.m_hangupINGLabel:getString()
                elseif eventType == "Exit" then
                    self.m_actionTime     = nil
                    self.m_hangupINGLabel = nil
                end
            end

            local whichTimes = 1
            if self.m_rewardData[startIndex - 1] ~= nil then
                whichTimes = self.m_rewardData[startIndex - 1].nowtimes + 1
            end

            self.m_hangupINGLabel = self :createLabel( tempContainer, string.format("第%d轮战斗: 正在挂机中",tonumber(whichTimes)),"Arial", 25,CHangupView.COLOR_GOLD)
            self.m_hangupINGLabel : setAnchorPoint( ccp( 0,0.5))
            self.m_hangupINGLabel : setPosition( ccp(mainSize.width*0.016,mainSize.height*0.48 - mainSize.height*0.18*(i-1)))

            tempContainer:registerControlScriptHandler( local_containerCallBack, "this CHangupView.addReward self.m_hangupINGLabel 649" )
            break
        end

        local timesLabel        = self :createLabel( tempContainer, string.format("第%d轮战斗:",tonumber(self.m_rewardData[startIndex].nowtimes)),"Arial", 25,CHangupView.COLOR_GOLD)
        local timesEXPLabel     = self :createLabel( tempContainer, "经验","Arial", 20)
        local timesGoldLabel    = self :createLabel( tempContainer, "美刀","Arial", 20)
        local timesPowerLabel   = self :createLabel( tempContainer, "潜能","Arial", 20)
        local addEXPLabel       = self :createLabel( tempContainer, "+"..self.m_rewardData[startIndex].exp,"Arial", 20,CHangupView.COLOR_GREEN)
        local addGoldLabel      = self :createLabel( tempContainer, "+"..self.m_rewardData[startIndex].gold,"Arial", 20,CHangupView.COLOR_GREEN)
        local addPowerLabel     = self :createLabel( tempContainer, "+"..self.m_rewardData[startIndex].power,"Arial", 20,CHangupView.COLOR_GREEN)

        timesLabel      : setAnchorPoint( ccp( 0,0.5))
        timesEXPLabel   : setAnchorPoint( ccp( 0,0.5))
        timesGoldLabel  : setAnchorPoint( ccp( 0,0.5))
        timesPowerLabel : setAnchorPoint( ccp( 0,0.5))

        timesLabel      : setPosition( ccp(mainSize.width*0.016,mainSize.height*0.48 - mainSize.height*0.18*(i-1)))
        timesEXPLabel   : setPosition( ccp(mainSize.width*0.016,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        timesGoldLabel  : setPosition( ccp(mainSize.width*0.206,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        timesPowerLabel : setPosition( ccp(mainSize.width*0.396,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        timesLabel      : setPosition( ccp(mainSize.width*0.016,mainSize.height*0.48 - mainSize.height*0.18*(i-1)))
        addEXPLabel     : setPosition( ccp(mainSize.width*0.016+73,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        addGoldLabel    : setPosition( ccp(mainSize.width*0.206+70,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        addPowerLabel   : setPosition( ccp(mainSize.width*0.396+65,mainSize.height*0.43 - mainSize.height*0.18*(i-1)))
        
        -- if self.m_rewardData[startIndex].count ~= 0 then 
        --     print("CHangupView.addReward-------",self.m_rewardData[startIndex].data.goods_id)
        --     local goodsNode = self:getGoodsById( self.m_rewardData[startIndex].data.goods_id )
        --     local timesGoodsLabel   = self :createLabel( tempContainer, goodsNode.name.." x "..self.m_rewardData[startIndex].count,"Arial", 20,CHangupView.COLOR_BLUE)
        --     timesGoodsLabel : setAnchorPoint( ccp( 0,0.5))
        --     timesGoodsLabel : setPosition( ccp(mainSize.width*0.016,mainSize.height*0.38 - mainSize.height*0.18*(i-1)))
        -- end

        for j=1,self.m_rewardData[startIndex].count do
            print("CHangupView.addReward-------",self.m_rewardData[startIndex].data[j].goods_id,goodsNode)
            local goodsNode = self:getGoodsById( self.m_rewardData[startIndex].data[j].goods_id )
            local timesGoodsLabel   = self :createLabel( tempContainer, goodsNode:getAttribute("name").." x "..self.m_rewardData[startIndex].count,"Arial", 20,CHangupView.COLOR_BLUE)
            timesGoodsLabel : setAnchorPoint( ccp( 0,0.5))
            timesGoodsLabel : setPosition( ccp(mainSize.width*0.016+(j-1)*mainSize.width*0.190,mainSize.height*0.38 - mainSize.height*0.18*(i-1)))
        end

        startIndex = startIndex + 1
    end

    tempNode : addChild( tempContainer )
end

function CHangupView.createHangupINGLabel( self, _node )

    self.m_hangupINGLabel = self:createLabel( _node, "", "Arial",20, ccc4( 255,255,255,255 ) )

    return self.m_hangupINGLabel

end

function CHangupView.createLabel( self, _parent, _str, _fontName, _fontSize, _fontColor )
    local temp = CCLabelTTF :create( _str, _fontName, _fontSize )
    if _fontColor ~= nil then
        temp :setColor( _fontColor )
    end
    _parent :addChild( temp )
    return temp
end

function CHangupView.showSureBox( self, _msg )

    local surebox  = CErrorBox()
    local BoxLayer = surebox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)

end

--*****************
--提供给HangupMediator使用
--*****************
function CHangupView.autoArchiveMessage( self , isFreeTimes)
    print("CHangupView.autoArchiveMessage" )

    if self.m_totalTime >= 0 then
        --离线挂机时打开界面不处理 正常打开界面时self.m_totalTime=-1
        return
    end

    -- if self.m_btnState == 0 then
    --     self.m_btnState = 1
    -- else 
    --     --已经处理过的不再重新处理 , 挂机完成或取消挂机时self.m_btnState重设为0
    --     return
    -- end 

    self:clearRewardView()
    self:setHuangUpType( CHangupView.TYPE_HUANGUP )

    local myVip  = tonumber( _G.g_characterProperty : getMainPlay() :getVipLv() )
    local minVip = tonumber(self.m_sceneCopyInfo:getAttribute("fast_vip"))
    
    if myVip < minVip then
        self.m_hangupCdTime = self :getCDTimes( self.m_sceneCopyInfo:getAttribute("copy_type") )
        self : setTime( self.m_hangupCdTime*self.m_HangupNumber)
        self : showRewardView()
    end
end

function CHangupView.addOneReward( self, _oneData )
    
    if #self.m_rewardData >= 10 then
        table.remove( self.m_rewardData, 1 )
    end
    table.insert( self.m_rewardData, _oneData )
    self :showRewardView()

    if _oneData.nowtimes == _oneData.sumtimes then
        --最后一条数据
        self:setHuangUpType( CHangupView.TYPE_STOP )
    end

end

function CHangupView.getCDTimes( self, _type )

    local cdTimes = 0

    if tonumber(_type) == _G.Constant.CONST_COPY_TYPE_NORMAL then
        cdTimes = _G.Constant.CONST_COPY_NORMAL_CD
    elseif tonumber(_type) == _G.Constant.CONST_COPY_TYPE_HERO then
        cdTimes = _G.Constant.CONST_COPY_HERO_CD
    elseif tonumber(_type) == _G.Constant.CONST_COPY_TYPE_FIEND then 
        cdTimes = _G.Constant.CONST_COPY_FIEND_CD
    end

    return cdTimes
end

function CHangupView.autoSpeedMessageCallBack( self )
    --加速完成
    self : setHuangUpType( CHangupView.TYPE_SPEED ) 
end


--*****************
--根据副本Id读取副本信息
--*****************
function CHangupView.getCopyRewards( self, _copyid)
    local copy_id = tostring( _copyid) 
    _G.Config :load( "config/copy_reward.xml")
    local copyrewards = _G.Config.copy_rewards :selectSingleNode( "copy_reward[@copy_id="..copy_id.."]")
    return copyrewards
end

function CHangupView.getSceneCopys( self, _copyid)
    local copy_id = tostring( _copyid)
    _G.Config :load( "config/scene_copy.xml")
    local sceneCopys = _G.Config.scene_copys :selectSingleNode( "scene_copy[@copy_id="..copy_id.."]")
    return sceneCopys
end

function CHangupView.getGoodsById( self, _goodsid)
    local goodsid = tostring( _goodsid)
    _G.Config :load( "config/goods.xml")
    local goods = _G.Config.goodss :selectSingleNode( "goods[@id="..goodsid.."]")
    return goods
end

function CHangupView.getHangupTimesByCopyId( self, _copyid )
    local sceneCopyNode = self:getSceneCopys( _copyid )
    if sceneCopyNode:isEmpty() then
        return nil
    end
    local buff      = _G.g_characterProperty:getMainPlay():getBuffValue() or 0
    local energyHas = _G.g_characterProperty:getMainPlay():getSum() + buff
    local useEnergy = tonumber(sceneCopyNode:getAttribute("use_energy"))
    local times = math.floor( energyHas/useEnergy )
    return times
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CHangupView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "EditBoxReturn" then
        local num = tonumber(string.match(x, "%d+"))
        local maxTimes  = self.m_maxTimesCanUse
        if num == nil then
            obj :setTextString( tostring(self.m_hangUpTimes) )
            self.m_userUsedTiLiLabel : setString("次".. tostring(self.m_sceneCopyInfo:getAttribute("use_energy")*self.m_hangUpTimes) .."体力")
        else
            
            if tonumber(num) > tonumber(maxTimes) then
                num = maxTimes
                self:showSureBox( "可挂机次数不足!\n可挂机最大次数为 "..num.." 次")
            end
            obj :setTextString( tostring(num) )
            self.m_userUsedTiLiLabel : setString("次".. tostring(self.m_sceneCopyInfo:getAttribute("use_energy")*num) .."体力")
        end

        self.m_hangupStartButton : setTouchesEnabled(true)
        

    elseif eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    
        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CHangupView.TAG_CLOSED then
            --关闭
            local function local_exitHangup()
                self : sendStopHangupMessage()
                controller :unregisterMediator( self.m_hangupMediator)
                CCDirector :sharedDirector() :popScene( self._scene)
                self : unloadResource()
                
                _G.g_CHangupView = nil

                if self.m_isLiXian == false then
                    --非离线打开   及重新打开副本界面
                    local typeInt  = 101
                    local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
                    if copyType == _G.Constant.CONST_MAP_FIEND_COPY then
                        typeInt = 103
                    elseif copyType == _G.Constant.CONST_MAP_HERO_COPY then
                        typeInt = 102
                    end


                    local tempview = CDuplicateSelectPanelView()
                    CCDirector :sharedDirector() :pushScene( tempview :scene( typeInt ))
                end

                self = nil
            end
            
            if self.m_nowStateType ~= CHangupView.TYPE_STOP then

                local myVip  = tonumber( _G.g_characterProperty : getMainPlay() :getVipLv() )
                local minVip = tonumber(self.m_sceneCopyInfo:getAttribute("fast_vip"))

                if self.m_nowStateType == CHangupView.TYPE_SPEED or myVip >= minVip then
                    return
                end

                self.exitPopBox = CPopBox() --初始化
                self.m_exitPopBoxLayer = self.exitPopBox : create(local_exitHangup,"是否退出挂机?",0)
                self.exitPopBox.windowsInfoLabel :setColor( CHangupView.COLOR_YERROW )
                self.m_exitPopBoxLayer : setPosition(-20,0)
                self.m_scenelayer      : addChild(self.m_exitPopBoxLayer)
            else
                local_exitHangup()
            end
            

            
        elseif obj :getTag() == CHangupView.TAG_HANGUP then
            if self.m_nowStateType ~= CHangupView.TYPE_HUANGUP then
                print( "开始挂机啦")

                _G.pCGuideManager:sendStepFinish()
                
                --判断背包是否已满
                local surplusCount = _G.g_GameDataProxy :getMaxCapacity() - _G.g_GameDataProxy :getGoodsCount() --背包剩余空间
                if surplusCount == 0 then
                    self:showSureBox( "背包已满,请先清理" )
                else
                    --判断挂机类型
                    local buff      = _G.g_characterProperty:getMainPlay():getBuffValue() or 0
                    local energyHas = _G.g_characterProperty:getMainPlay():getSum() + buff
                    local numSet
                    if self.m_userRadioBox : getChecked() then
                        --自定义次数挂机
                        numSet = tonumber(self.m_userNumEditBox : getTextString())

                        if numSet == 0 then
                            self:showSureBox( "挂机次数不能为0" )
                            return
                        end

                        copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
                        if copyType == _G.Constant.CONST_COPY_TYPE_HERO or copyType == _G.Constant.CONST_COPY_TYPE_FIEND then
                            if self.m_maxTimesCanUse == 0 then
                                self:showSureBox( "没有剩余次数" )
                                return
                            end
                        end

                        if energyHas >= self.m_sceneCopyInfo:getAttribute("use_energy")*numSet then
                            self : sendHuangupMessage(false, numSet)
                            self.m_hangupStartButton :setTouchesEnabled( false )
                            self.m_totalTime = -1           -- -1为非离线
                        else
                            self:showSureBox( "        您不够体力挂机" )
                        end
                    elseif self.m_allRadioBox : getChecked() then
                        --挂机所有体力
                        if energyHas >= tonumber(self.m_sceneCopyInfo:getAttribute("use_energy")) then
                            numSet = math.floor(energyHas/self.m_sceneCopyInfo:getAttribute("use_energy"))
                            self : sendHuangupMessage(true, numSet)
                            self.m_hangupStartButton :setTouchesEnabled( false )
                            self.m_totalTime = -1           -- -1为非离线
                        else
                            self:showSureBox( "        您不够体力挂机" )
                        end
                    end
                end


            else 
                --停止挂机
                self : sendStopHangupMessage()
                self : setHuangUpType( CHangupView.TYPE_STOP )
            end
        elseif obj :getTag() == CHangupView.TAG_SPEEDUP  then
            --挂机加速
            _G.pCGuideManager:sendStepFinish()

            local rmb = tonumber(_G.g_characterProperty:getMainPlay():getRmb()) + tonumber(_G.g_characterProperty:getMainPlay():getBindRmb())
            local oneMinRmb = tonumber(_G.Constant.CONST_COPY_SPEED_UP_CD)
            local needRmb = math.floor(self.m_resetHangupCdtime/self.m_hangupCdTime)
            if self.m_resetHangupCdtime%self.m_hangupCdTime > 0 then 
                needRmb = needRmb+1
            end
            print("现有钻石:"..rmb.."   所需钻石"..needRmb)
            
            local function speedUpCallBack( )

                if rmb<needRmb then 
                    self:showSureBox( "钻石不足!" )
                    return
                end

                self.m_hangupStartButton :setTouchesEnabled( false )
                self.m_speedupButton     :setTouchesEnabled( false )
                self : sendSpeedUpMessage()
            end

            if self.PopBox ~= nil then 
                if self.PopBox.iswindowscheckBoxChecked == 1 then 
                    speedUpCallBack()
                    return
                end
            end

            self.PopBox = CPopBox() --初始化
            self.m_speedUpPopBoxLayer = self.PopBox : create(speedUpCallBack,"挂机加速需消耗 "..needRmb.." 钻石",1)
            self.PopBox.windowsInfoLabel :setColor( CHangupView.COLOR_YERROW )
            self.m_speedUpPopBoxLayer : setPosition(-20,0)
            self.m_scenelayer         : addChild(self.m_speedUpPopBoxLayer)

        elseif obj :getTag() == CHangupView.TAG_RADIO_USER then
            --选择自动次数挂机
            self.m_userRadioBox : setChecked( true )
            self.m_allRadioBox  : setChecked( false )
        elseif obj :getTag() == CHangupView.TAG_RADIO_ALL then
            --选择全部体力挂机
            self.m_userRadioBox : setChecked( false )
            self.m_allRadioBox  : setChecked( true )   
        end
    end
end

--*****************
--更改挂机(停止挂机)按钮的文字内容
--*****************
function CHangupView.setHuangUpType( self, _type )

    local myVip  = tonumber( _G.g_characterProperty : getMainPlay() :getVipLv() )
    local minVip = tonumber(self.m_sceneCopyInfo:getAttribute("fast_vip"))

    if _type == CHangupView.TYPE_STOP then
        self.m_hangupStartButton :setVisible( true )
        self.m_hangupStartButton :setText("挂机")
        self.m_hangupStartButton :setTouchesEnabled( true )

        self.m_speedupButton :setVisible( true )
        self.m_speedupButton :setTouchesEnabled( false )


        if self.m_hangupINGLabel ~= nil then
            self.m_hangupINGLabel : removeFromParentAndCleanup( true )
            self.m_hangupINGLabel = nil
        end

        self : setTime(0)
        self.m_rewardData = {}
    elseif _type == CHangupView.TYPE_HUANGUP then
        self.m_speedupButton :setTouchesEnabled( true )
        if myVip >= minVip then
            self.m_hangupStartButton :setVisible( false )
        else
            self.m_hangupStartButton :setText("取消")
            self.m_hangupStartButton :setTouchesEnabled( true )
        end
    elseif _type == CHangupView.TYPE_SPEED then
        self.m_speedupButton :setVisible( false )
        self.m_hangupStartButton :setVisible( false )

        self : setTime(0)

        if self.m_hangupINGLabel ~= nil then
            self.m_hangupINGLabel : removeFromParentAndCleanup( true )
            self.m_hangupINGLabel = nil
        end
    end

    if myVip >= minVip then
        self.m_speedupButton :setVisible( false )
        self.m_hangupStartButton     :setPosition( ccp( 678, 64))
    end

    self.m_nowStateType = _type

end

--*****************
--发送挂机协议
--*****************
function CHangupView.sendHuangupMessage( self , _isUsedAllTiLi , _num)
    require "common/protocol/auto/REQ_COPY_UP_START"
    self.m_HangupNumber = _num
    local msg = REQ_COPY_UP_START()
    msg : setCopyId( self.m_sceneCopyInfo:getAttribute("copy_id") )
    msg : setNum( _num )
    if _isUsedAllTiLi then
        msg : setUseAll(1)
        CNetwork : send(msg)
    else 
        msg : setUseAll(0)
        msg : setNum(tonumber(self.m_userNumEditBox : getTextString()))
        CNetwork : send(msg)
    end
end

function CHangupView.sendStopHangupMessage( self )

    require "common/protocol/auto/REQ_COPY_UP_STOP"
    local msg = REQ_COPY_UP_STOP()
    CNetwork : send(msg)
end

function CHangupView.sendSpeedUpMessage( self )
    require "common/protocol/auto/REQ_COPY_UP_SPEED"
    --self:showSureBox( "加速" )
    local msg = REQ_COPY_UP_SPEED()
    CNetwork : send(msg)
end

----------------------------------------------------
--倒计时处理
----------------------------------------------------
function CHangupView.registerEnterFrameCallBack(self)
    print( "CHangupView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        self :updataResetHangupCDTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CHangupView.updataResetHangupCDTime( self, _duration)
    if self.m_resetHangupCdtime == nil or self.m_resetHangupCdtime <= 0 then
        return
    end

    if self.m_actionTime ~= nil then

        self.m_actionTime = self.m_actionTime + _duration
        local actionTime = 0.2
        if self.m_actionTime >= actionTime*5 then
            self.m_actionTime = 0
            self.m_hangupINGLabel : setString( self.m_actionStr.."....." )
        elseif self.m_actionTime >= actionTime*4 then
            self.m_hangupINGLabel : setString( self.m_actionStr.."...." )
        elseif self.m_actionTime >= actionTime*3 then
            self.m_hangupINGLabel : setString( self.m_actionStr.."..." )
        elseif self.m_actionTime >= actionTime*2 then
            self.m_hangupINGLabel : setString( self.m_actionStr..".." )
        elseif self.m_actionTime >= actionTime then
            self.m_hangupINGLabel : setString( self.m_actionStr.."." )
        end
    end

    local time = _G.g_ServerTime:getHangUpTime()
    if time >= 0 then
        local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
        if copyType ~= _G.Constant.CONST_COPY_TYPE_NORMAL then
            
            if self.m_resetHangupCdtime ~= time then
                self.m_resetHangupCdtime = time
                local fomarttime         = self :turnTime( self.m_resetHangupCdtime)
                self.m_hangupCDTimeLabel  : setString( fomarttime )
            end
            
        end
    else
        self.m_hangupCDTimeLabel  : setString( "00:00:00" )
        self.m_scenelayer:unscheduleUpdate()
    end
    
    -- local fomarttime         = self :turnTime( self.m_resetHangupCdtime)
    -- self.m_hangupCDTimeLabel  : setString( fomarttime )

    -- self.m_resetHangupCdtime = self.m_resetHangupCdtime - _duration
    
    
end

--冷却CD时间
function CHangupView.setTime( self, _time)

    self.m_resetHangupCdtime  = _time
    
    if _time <= 0 then
        self.m_hangupCDTimeLabel  : setString( "00:00:00" )
        self.m_scenelayer:unscheduleUpdate()
        return
    end

    _G.g_ServerTime:setHangUpTime( _time )
    
    local fomarttime          = self :turnTime( self.m_resetHangupCdtime)
    
    local copyType = tonumber(self.m_sceneCopyInfo:getAttribute("copy_type"))
    if copyType ~= _G.Constant.CONST_COPY_TYPE_NORMAL then
        self.m_hangupCDTimeLabel  : setString( fomarttime)
    end


    --注册AI回调
    self :registerEnterFrameCallBack()
        
end

--{时间拆分为 00:00:00}
function CHangupView.turnTime( self, _time)
    _time = _time < 0 and 0 or _time
    local hor  = math.floor( _time/(60*60))
    hor = hor < 0 and 0 or hor
    local min  = math.floor( _time/60-hor*60)
    min = min < 0 and 0 or min
    local sec  = math.floor( _time-hor*60*60-min*60)
    sec = sec < 0 and 0 or sec    
    hor = self :toTimeString( hor)
    min = self :toTimeString( min )
    sec = self :toTimeString( sec )
    return hor..":"..min..":"..sec
end

--{时间转字符串}
function CHangupView.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end

function CHangupView.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenelayer   : addChild(BoxLayer,1000)
end




