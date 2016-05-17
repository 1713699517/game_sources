require "view/view"
require "view/DuplicateLayer/RewardPickUpCopyView"


CRewardCopyView = class( view, function ( self , _exp, _exploits, _gold, _technologyScore, _timeScore, _killScore, _comboScore, _eva,  _goods )
    CCLOG("副本奖励界面被实例化")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("DuplicateResources/DuplicateResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/ChallengeResources.plist")
    self.m_exp = _exp
    self.m_exploits = _exploits
    self.m_gold = _gold
    self.m_technologyScore = _technologyScore
    self.m_timeScore = _timeScore
    self.m_killScore = _killScore
    self.m_comboScore = _comboScore
    self.m_goods = _goods
    self.m_eva = _eva
    self.m_allScore = _technologyScore + _timeScore + _killScore + _comboScore


    --self.m_nPro = 1
    self.m_nPro = _G.Constant.CONST_PRO_SUNMAN
    local property = _G.g_characterProperty : getMainPlay()
    self.m_nPro = property : getPro()
    self.m_nPro = self.m_nPro <= 0 and _G.Constant.CONST_PRO_SUNMAN or self.m_nPro


    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/grade.mp3", false)
    end
end)

CRewardCopyView.FONT_NAME = "Marker Felt"
CRewardCopyView.FONT_SIZE24 = 20
CRewardCopyView.FONT_SIZE48 = 48
CRewardCopyView.BUTTON_OK = 100

function CRewardCopyView.scene( self )
-- body _exploits潜能 _technologyScore技巧  _timeScore时间 _killScore杀敌 _comboScore连击
    self.m_lpContainer = CCScene : create() -- 总层
    self : initView()
    self : layoutView()
    return self.m_lpContainer
end

--{返回一个层}
function CRewardCopyView.container( self )
    -- body _exploits潜能 _technologyScore技巧  _timeScore时间 _killScore杀敌 _comboScore连击
    self.m_lpContainer = CContainer :create() -- 总层
    self.m_lpContainer : setControlName( "this is CRewardCopyView self.m_lpContainer 63" )
    self.m_lpContainer : setFullScreenTouchEnabled(true)
    self : initView()
    self : layoutView()
    return self.m_lpContainer
end

--初始化 成员
function CRewardCopyView.initView( self )
    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    --底图
    self.m_backgroundMain  = CSprite :createWithSpriteFrameName( "arena_underframe.png" )

    self.m_backgroundMain : setControlName( "this CRewardCopyView self.m_backgroundMain 80 ")
    --按钮
    self.m_button = CButton :createWithSpriteFrameName( "确认", "general_button_normal.png")
    self.m_button : setControlName( "this CRewardCopyView self.m_button 86 " )
    self.m_button : setTag( self.BUTTON_OK )
    self.m_button : registerControlScriptHandler( CellCallBack, "this CRewardCopyView self.m_button 92")
    self.m_button : setTouchesPriority( -100 )
    self.m_button : setTouchesEnabled(true)
    self.m_backgroundMain : addChild( self.m_button )

    --标题
    self.m_title = CCSprite :createWithSpriteFrameName( "copy_word_fbtg.png" )
    self.m_backgroundMain : addChild( self.m_title )
    --获得经验底图
    self.m_getExpBackground = CSprite :createWithSpriteFrameName( "copy_dividing.png" )
    self.m_getExpBackground : setControlName( "this CRewardCopyView self.m_getExpBackground 107 ")
    self.m_backgroundMain : addChild( self.m_getExpBackground )
    --获得经验文字
    self.m_getExpString = CCLabelTTF : create( "获得奖励" , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_getExpBackground : addChild( self.m_getExpString )
    --评分底图
    self.m_getScoreBackground = CSprite :createWithSpriteFrameName( "copy_dividing.png" )
    self.m_getScoreBackground : setControlName( "this CRewardCopyView self.m_getExpBackground 114 ")
    self.m_backgroundMain : addChild( self.m_getScoreBackground )
    --评分文字
    self.m_getScoreString = CCLabelTTF : create( "评分" , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_getScoreBackground : addChild( self.m_getScoreString )
    --人物图片
    self.m_roleSprite = CSprite : createWithSpriteFrameName("role_body_0"..tostring(self.m_nPro)..".png")
    self.m_roleSprite : setControlName( "this CArenaFinishView self.m_roleSprite 67 " )
    self.m_backgroundMain : addChild( self.m_roleSprite )
    --经验
    self.m_expString = CCLabelTTF : create( "经验  "..tostring(self.m_exp) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_expString )
    --潜能
    self.m_exploitsString = CCLabelTTF : create( "潜能  "..tostring(self.m_exploits) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_exploitsString )
    --美刀
    -- self.m_goldString = CCLabelTTF : create( "美刀 "..tostring( self.m_gold), self.FONT_NAME, self.FONT_SIZE24 )
    -- self.m_backgroundMain : addChild( self.m_goldString )
    --技巧
    self.m_technologyScoreString = CCLabelTTF : create( "技巧  "..tostring(self.m_technologyScore) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_technologyScoreString )
    --时间
    self.m_timeScoreString = CCLabelTTF : create( "时间  "..tostring(self.m_timeScore) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_timeScoreString )
    --连击
    self.m_comboScoreString = CCLabelTTF : create( "连击  "..tostring(self.m_comboScore) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_comboScoreString )
    --杀敌
    self.m_killScoreString = CCLabelTTF : create( "杀敌  "..tostring(self.m_killScore) , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_killScoreString )
    --总分图
    self.m_allScoreSprite = CCSprite :createWithSpriteFrameName( "copy_word_total.png" )
    self.m_backgroundMain : addChild( self.m_allScoreSprite )
    --总分文字
    self.m_allScoreString = CCLabelTTF : create( tostring(self.m_allScore) , self.FONT_NAME , self.FONT_SIZE48 )
    self.m_backgroundMain : addChild( self.m_allScoreString )
    --SAB评分图
    --local path = "s"
    -- if self.m_eva == _G.Constant.CONST_COPY_EVA_B then
    --     path = "a"
    -- elseif self.m_eva == _G.Constant.CONST_COPY_EVA_C then
    --     path = "b"
    -- end

    -- self.m_sabSprite = CCSprite : createWithSpriteFrameName( "copy_word_"..path..".png" )
    -- self.m_backgroundMain : addChild( self.m_sabSprite )


    self.m_lpContainer : addChild( self.m_backgroundMain )
end


--布局
function CRewardCopyView.layoutView( self )
--该界面不需要根据屏幕大小来调整
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --主底图位置 和大小
    local mainGroundSize = CCSizeMake( 800, 340 )
    self.m_backgroundMain : setPreferredSize( mainGroundSize )
    self.m_backgroundMain : setPosition( winSize.width / 2 , winSize.height / 2 )
    --按钮
    self.m_button : setPosition( mainGroundSize.width / 2 -100 , 0 - mainGroundSize.height / 2 + 48 )
    --标题
    self.m_title : setPosition( 0, mainGroundSize.height / 2 )
    --获得经验底图
    self.m_getExpBackground : setPosition( -50, mainGroundSize.height / 2 - 78)

    local expBackgroundSize = self.m_getExpBackground : getPreferredSize()
    --获得经验文字
    self.m_getExpString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_getExpString : setPosition(0-expBackgroundSize.width/2 +20 ,0)
    --评分底图
    self.m_getScoreBackground : setPosition( -50, mainGroundSize.height / 2 - 170)
    --评分文字
    self.m_getScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_getScoreString : setPosition(0-expBackgroundSize.width/2 +20 ,0)
    --人物图片
    self.m_roleSprite : setPosition( 0-mainGroundSize.width / 2, 0 )
    --经验
    self.m_expString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_expString : setPosition( 0-mainGroundSize.width / 2 + 183, mainGroundSize.height /2 - 120 )
    --潜能
    self.m_exploitsString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_exploitsString : setPosition( 0-mainGroundSize.width / 2 + 318, mainGroundSize.height /2 - 120 )
    --美刀
    -- self.m_goldString : setAnchorPoint( ccp( 0, 0.5 ))
    -- self.m_goldString : setPosition( ccp( 0-mainGroundSize.width / 2 + 458, mainGroundSize.height /2 - 120 ))
    --技巧
    self.m_technologyScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_technologyScoreString : setPosition( 0-mainGroundSize.width / 2 + 183, mainGroundSize.height /2 - 218 )
    --时间
    self.m_timeScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_timeScoreString : setPosition( 0-mainGroundSize.width / 2 + 318, mainGroundSize.height /2 - 218 )
    --连击
    self.m_comboScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_comboScoreString : setPosition( 0-mainGroundSize.width / 2 + 183, mainGroundSize.height /2 - 250 )
    --杀敌
    self.m_killScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_killScoreString : setPosition( 0-mainGroundSize.width / 2 + 318, mainGroundSize.height /2 - 250 )
    --总分图
    self.m_allScoreSprite : setPosition( 0-mainGroundSize.width / 2 + 210, mainGroundSize.height / 2 - 300)
    --总分文字
    self.m_allScoreString : setAnchorPoint( ccp( 0, 0.5 ) )
    self.m_allScoreString : setPosition( 0-mainGroundSize.width / 2 + 260, mainGroundSize.height / 2 - 300 )
    --SAB评分图
    --self.m_sabSprite : setPosition( mainGroundSize.width / 2 -100, mainGroundSize.height / 2 - 132)

    self : action()
end

function CRewardCopyView.action( self )
    local isVisible = false
    local function expFun(  )
        self.m_expString : setVisible(isVisible)
        self.m_exploitsString : setVisible(isVisible)
        --self.m_goldString : setVisible(isVisible)
    end
    expFun()

    local function techFun(  )
        self.m_technologyScoreString : setVisible( isVisible )
        self.m_timeScoreString : setVisible( isVisible )
        self.m_comboScoreString : setVisible( isVisible )
        self.m_killScoreString : setVisible( isVisible )
    end
    techFun()

    local function allScoreFun(  )
        self.m_allScoreSprite : setVisible( isVisible )
        self.m_allScoreString : setVisible( isVisible )
    end
    allScoreFun()

    local function asbSFun(  )
        if isVisible ~= true then
            return
        end
        local mainGroundSize = CCSizeMake( 800, 340 )
        local background = CMovieClip:create( "CharacterMovieClip/effects_rate2.ccbi" )
        local dong = CMovieClip:create( "CharacterMovieClip/effects_rate1.ccbi" )
        dong : setPosition(0,10)
        background : addChild(dong)
        dong : play("run")
        local eva = CMovieClip:create( "CharacterMovieClip/effects_rate3.ccbi" )
        background : addChild( eva )
        eva : play("run"..tostring(self.m_eva))
        print("self.m_eva",self.m_eva)
        background : play("run")
        background : setPosition( mainGroundSize.width / 2 -100, mainGroundSize.height / 2 - 132)
        self.m_backgroundMain : addChild( background )
    end
    asbSFun()
    local function btnFun(  )
        self.m_button : setVisible( isVisible )
    end
    btnFun()

    isVisible = true
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFuncN:create(expFun))
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFuncN:create(techFun))
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFuncN:create(allScoreFun))
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFuncN:create(asbSFun))
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFuncN:create(btnFun))
    local act = CCSequence:create(_callBacks)

    self.m_backgroundMain : runAction( act )
end

--事件响应
function CRewardCopyView.clickCellCallBack( self, eventType, obj, x, y )
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


function CRewardCopyView.clickOkButton( self )
    -- if self.m_goods == nil or #self.m_goods <= 0 then
    --     _G.g_Stage : exitCopy()
    --     return
    -- end
    self.parent = self.m_lpContainer :getParent()
    if self.parent == nil then
        CCMessage("okButton parent"," Error ")
        return
    end
    local function CallFunc( eventType, arg0, arg1, arg2, arg3 )
        self : ccbiAnimationCallFunc(eventType, arg0, arg1, arg2, arg3)
    end

    self.m_lpContainer : removeFromParentAndCleanup( true )

    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_ccbi = CMovieClip:create("CharacterMovieClip/effects_bag.ccbi")
    self.parent : addChild( self.m_ccbi )
    self.m_ccbi : setPosition( winSize.width/4*3, winSize.height )
    self.m_ccbi : registerControlScriptHandler( CallFunc )

    local function callback(  )
        self.m_ccbi : play( "run1" )
    end

    local _callBacks = CCArray:create()
    _callBacks:addObject(CCMoveTo:create(0.1,ccp(winSize.width/4*3, winSize.height/2-80) ))
    _callBacks:addObject(CCCallFunc:create(callback))
    self.m_ccbi : runAction( CCSequence:create(_callBacks) )

end

function CRewardCopyView.ccbiAnimationCallFunc( self,eventType, arg0, arg1, arg2, arg3 )
    if eventType == "AnimationComplete" then
        local function clickBagFun( eventType, obj, x, y)
            if eventType == "TouchBegan" then
                return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) )
            end
            if eventType == "TouchEnded" then
                local function CallFunc( _eventType, _arg0, _arg1, _arg2, _arg3 )
                    if _eventType == "AnimationComplete" then
                        self.m_goods[3] = {goods_id = 43001, count=self.m_gold }
                        local PickUpobj = CRewardPickUpCopyView(  self.m_goods )
                        local container = PickUpobj : container()
                        self.parent : addChild( container )
                    end
                end
                self.m_ccbi : registerControlScriptHandler( CallFunc )
                self.m_ccbi : play( "run2" )
            end
        end
        self.m_ccbi : setTouchesPriority( -26 )
        self.m_ccbi : setTouchesEnabled (true)
        self.m_ccbi : registerControlScriptHandler ( clickBagFun )
    end
end



