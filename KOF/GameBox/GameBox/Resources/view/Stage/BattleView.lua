require "view/view"
require "view/LuckyLayer/PopBox"

CBattleView = class( view, function (self)


    self : loadRes()
    local hosting = CSprite : createWithSpriteFrameName( "battle_hosting_normal.png" )
    hosting : setControlName( "this CBattleView hosting 9 " )

    self.m_lphostingSize = hosting : getPreferredSize()
    self.m_lpHeadSize  = CCSizeMake(110,110)--head : getPreferredSize()

    self.winSize = CCDirector :sharedDirector() :getVisibleSize()
    --是否显示DPS排行
    self.m_bIsShowAllDps = false
    --BOSS死亡界面
    self.m_lpSpriteBossDead = nil

    self.m_dps = nil
end)

function CBattleView.loadRes( self )
    --战斗通用界面
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")

    --按钮和底图通用界面
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")

    --拳皇生涯
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KofCareerResource/KofCareer.plist")
end


--{连击}
function CBattleView.showCombo( self, _nCombo, _container )
    if _nCombo <= 0 then
        return
    end
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    local strCombo = tostring( _nCombo )
    local lenStrCombo = string.len(strCombo)

    local hitsBg = CSprite :createWithSpriteFrameName( "battle_hits_hits_frame.png" )
    hitsBg : setControlName( "this CBattleView hitsBg 48 " )

    local hitsSprite = CSprite : createWithSpriteFrameName( "battle_hits_hits.png" )
    hitsSprite : setControlName( "this CBattleView hitsSprite 21 ")
    local hitsSpriteSize = hitsSprite : getPreferredSize()
    local x = -(hitsSpriteSize.width / 2)
    for i=lenStrCombo,1,-1 do
        local strCurrent = string.sub(strCombo,i,i)
        local numSprite = CSprite : createWithSpriteFrameName( "battle_hits_number_"..strCurrent..".png" )
        numSprite : setControlName( "this CBattleView numSprite 27 ")
        hitsSprite : addChild( numSprite )
        local numSpriteSize = numSprite : getPreferredSize()
        x = x - numSpriteSize.width / 2
        numSprite : setPosition( ccp( x, 0 ) )
        x = x - numSpriteSize.width / 2
    end
    _container : addChild( hitsBg )
    hitsBg : addChild( hitsSprite, 10 )

    local hitsBgSize = hitsBg :getPreferredSize()
    local hitsX = self.winSize.width - hitsBgSize.width / 2
    local hitsY = self.winSize.height - self.winSize.height * 0.296875 - hitsBgSize.height / 2
    --hitsX = hitsX - self.m_lphostingSize.width - hitsSpriteSize.width / 2
    --hitsY = hitsY - self.m_lphostingSize.height / 2

    --hitsSprite : setPosition( ccp( hitsX, hitsY ))
    hitsBg : setPosition( ccp( hitsX, hitsY ))

    hitsSprite : setScale(1.5)
    local _callBacks = CCArray:create()
    _callBacks:addObject( CCDelayTime:create(0.5) )
    _callBacks:addObject( CCScaleTo:create(0.02,1) )
    hitsSprite:runAction( CCSequence:create(_callBacks) )




end

--{退出副本按钮}
function CBattleView.addExitCopyButton( self, _container )
    local exitBtn      = CButton: createWithSpriteFrameName("","battle_back_normal.png")
    exitBtn : setControlName( "this CBattleView exitBtn 57 ")
    local exitBtnsize  = exitBtn : getPreferredSize()
    exitBtn : setTouchesPriority( -99 )
    local function callBack( eventType, obj, x, y)
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) )
        end
        if(eventType == "TouchEnded") then
            self : addExitCopyOKButton( _container )
        end
    end
    exitBtn :registerControlScriptHandler( callBack, "this CBattleView exitBtn 68")
    _container : addChild( exitBtn)

    local exitX = self.m_lpHeadSize.width / 2
    local exitY = self.winSize.height - self.m_lpHeadSize.height - exitBtnsize.height / 2
    exitBtn : setPosition( ccp( exitX, exitY - 10 ))
end

function CBattleView.addExitCopyOKButton( self, _container )
    -- body
    local function callBack()
        _G.g_Stage : exitCopy()
    end
    local str = ""
    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        str = "确定要退出BOSS战吗?"
    elseif _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        str = "您确定要退出切磋场景吗?"
    elseif _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        str = "退出竞技会以失败一场计算,\n您是否确定退出？"
    else
        str = "退出副本需要重新闯关"
    end

    local btn = CPopBox() : create(callBack,str,false)
    _container : addChild( btn )
end

--{托管}
function CBattleView.addhostingBtn( self, _container )
    local hostingBtn      = CButton: createWithSpriteFrameName("","battle_hosting_normal.png")
    local HostSpr         = CSprite :createWithSpriteFrameName( "battle_word_tgz.png")      --托管中 字样
    local HostNoSpr       = CSprite :createWithSpriteFrameName( "battle_word_tg.png" )      --托管 字样
    hostingBtn : setControlName( "this CBattleView hostingBtn 79 ")
    local hostingBtnsize  = hostingBtn : getPreferredSize()
    hostingBtn : setTouchesPriority( -99 )
    local function callBack( eventType, obj, x, y)
        if obj ~= hostingBtn then
            return
        end
        if eventType == "TouchBegan" then
            return hostingBtn:containsPoint( hostingBtn:convertToNodeSpaceAR( ccp( x, y ) ) )
        end
        if(eventType == "TouchEnded") then
            if hostingBtn:containsPoint( hostingBtn:convertToNodeSpaceAR( ccp( x, y ) ) ) then
                local mainCharacter = _G.g_Stage : getPlay()
                if mainCharacter ~= nil then
                    local isAi = mainCharacter : getAI()
                    local ai = 0
                    if isAi == nil or isAi == 0 then
                        ai = tonumber(mainCharacter.xmlChar:getAttribute("ai_id"))
                        _G.g_Stage : removeKeyBoardAndJoyStick()
                        HostSpr : setVisible( true )
                        HostNoSpr :setVisible( false )
                    else
                        _G.g_Stage : addJoyStick()
                        _G.g_Stage : addKeyBoard()
                        HostSpr : setVisible( false )
                        HostNoSpr :setVisible( true )
                    end
                    mainCharacter : setAI( ai )
                end
            end
        end
    end
    hostingBtn :registerControlScriptHandler( callBack, "this CBattleView hostingBtn 90")
    _container : addChild( hostingBtn )
    local hostingX = self.winSize.width - self.m_lpHeadSize.width / 2
    local hostingY = self.winSize.height - self.m_lpHeadSize.height - hostingBtnsize.height / 2
    hostingBtn : setPosition( ccp( hostingX, hostingY - 10 ))


    hostingBtn : addChild( HostSpr, 100 )
    hostingBtn : addChild( HostNoSpr, 100 )
    local _sprSize   = HostSpr :getPreferredSize()
    local sprX = 0
    local sprY = -hostingBtnsize.height / 2 + _sprSize.height / 5
    HostSpr :setPosition( ccp( sprX, sprY ))
    HostSpr : setVisible( false )
    
    local _hostNoSprSize = HostNoSpr :getPreferredSize()
    local pX = 0
    local pY = -hostingBtnsize.height / 2 + _hostNoSprSize.height / 5
    HostNoSpr :setPosition( ccp( pX, pY ) )
    HostNoSpr :setVisible( true )

end

--{显示 剩余时间}
function CBattleView.showRemainingTime( self, _time , _container )

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    _time = _time < 0 and 0 or _time
    local min  = math.floor( _time /  60 )
    min = min < 0 and 0 or min
    local sec  = math.floor( _time -  min * 60 )
    sec = sec < 0 and 0 or sec
    min = self: toTimeString( min )
    sec = self: toTimeString( sec )

    local timeSprite = CSprite : createWithSpriteFrameName( "battle_maohao.png" )
    timeSprite : setControlName( "this CBattleView timeSprite 21 ")
    local timeSpriteSize = timeSprite : getPreferredSize()

    --时间框  08.15
    self.m_lpTimeBg  = CCSprite :createWithSpriteFrameName( "battle_timer_frame.png")
    self.m_lpTimeBgSize = self.m_lpTimeBg : getContentSize()
    timeSprite : addChild( self.m_lpTimeBg)
    self.m_lpTimeBg : setPosition( 2, -4)

    self : addTimeString( timeSprite, min, true, timeSpriteSize )
    self : addTimeString( timeSprite, sec, false, timeSpriteSize )
    _container : addChild( timeSprite )
    local x = self.winSize.width / 2
    local y = self.winSize.height - self.m_lpHeadSize.height / 2
    timeSprite : setPosition( ccp( x, y ) )
end

function CBattleView.addTimeString( self, _timeSprite, _str, _isleft, _timeSpriteSize)
    local strlen = string.len(_str)
    local startIndex = _isleft == true and strlen or 1
    local endIndex   = _isleft == true and 1 or strlen
    local steps      = _isleft == true and -1 or 1

    local x = _timeSpriteSize.width / 2
    x = _isleft == true and -x or x
    for i = startIndex,endIndex,steps do
        local strCurrent = string.sub(_str,i,i)
        local numSprite = CSprite : createWithSpriteFrameName( "battle_"..strCurrent..".png" )
        numSprite : setControlName( "this CBattleView numSprite 131 ")
        local numSpriteSize = numSprite : getPreferredSize()
        _timeSprite : addChild( numSprite )
        local addx = numSpriteSize.width/2
        addx = _isleft == true and -addx or addx
        x = x + addx
        numSprite : setPosition( ccp( x, 0 ) )
        x = x + addx
    end
end


--{时间转字符串}
function CBattleView.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end















---{BOSS}
function CBattleView.loadBossResources( self )
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist")
end

--世界BOSS祝福按钮
function CBattleView.addVipLuckBtn( self, _container )

end

function CBattleView.cleanupDPS( self )
    self.m_dps = nil
    self.m_bIsShowAllDps = false

    self.m_lpSpriteBossDead = nil
    self.m_lpTipsTTF = nil
    self.m_lpTimeTTF = nil
end







function CBattleView.showDps( self )
    self : loadBossResources()
    local container = _G.g_Stage : getDspContainer()
    if container == nil then
        return
    end

    local bigSize = CCSizeMake( 375, 518 )
    local smallSize = CCSizeMake( 375, 48 )
    self.m_dps = CSprite : createWithSpriteFrameName( "worldBoss_hurt_frame.png" )
    self.m_dps : setPreferredSize( smallSize )

    local x = self.winSize.width - smallSize.width / 2 + 10
    local y = self.winSize.height - smallSize.height / 2 - self.m_lpHeadSize.height
    self.m_dps : setPosition( x, y )

    local lime = CSprite : createWithSpriteFrameName( "worldBoss_hurt_dividing_01.png" )
    lime : setPosition(0,bigSize.height/2 - 46)
    self.m_dps : addChild( lime )
    lime : setVisible( false )

    local function dpsCallBack( eventType, obj, x, y )
        return self : allDpsCallBack( eventType, obj, x, y )
    end

    local dpbtn = CButton : create( "", "transparent.png")
    self.m_dps : addChild( dpbtn )
    dpbtn : setPreferredSize( smallSize )
    dpbtn : setTouchesPriority(-100)
    dpbtn : setTouchesEnabled( true )
    dpbtn : registerControlScriptHandler( dpsCallBack, "CBattleView.showDps dpsBtn 281" )

    local selfDps = _G.g_Stage : getSelfDps()
    if selfDps == nil then
        selfDps = 0
    end

    local tempCCSprite_right = CCSprite :createWithSpriteFrameName("worldBoss_hurt_arrow_right.png")
    self.m_dps : addChild( tempCCSprite_right )
    tempCCSprite_right : setPosition(0-smallSize.width / 2 + 15, 0 )

    local tempCCSprite_down = CCSprite :createWithSpriteFrameName("worldBoss_hurt_arrow_down.png")
    self.m_dps : addChild( tempCCSprite_down )
    tempCCSprite_down : setPosition(0-bigSize.width / 2 + 15, bigSize.height / 2 - 24 )
    tempCCSprite_down : setVisible( false )

    local dpslist = _G.g_Stage : getDpsList()
    if dpslist == nil then
        dpslist = {}
    end
    local uid = tonumber(_G.g_LoginInfoProxy : getUid())
    local tempRank = nil
    for rank,dpsData in pairs(dpslist) do
        if dpsData : getUid() == uid then
            tempRank = rank
            break
        end
    end

    local bossHp = _G.g_Stage : getBossMaxHp()
    local ttf = nil
    local harmString = tostring(selfDps/bossHp *100)
    harmString = string.sub(harmString,1,5)

    if tempRank == nil then
        ttf = CCLabelTTF : create( "你造成的伤害("..harmString..")", "Marker Felt", 20 )
    else
        ttf = CCLabelTTF : create( "你造成的伤害("..harmString..")".."排名"..tostring(tempRank), "Marker Felt", 20 )
    end
    ttf : setAnchorPoint(ccp(0,0.5))
    ttf : setPosition(0-smallSize.width/2+29, 0)
    self.m_dps : addChild( ttf )


    local zeroX = 0-bigSize.width/2 + 29
    local zeroY = bigSize.height/2 - 78
    self.m_dps_stringTTF={}
    for i=1,10 do
        self.m_dps_stringTTF[i] = CCLabelTTF : create( "", "Marker Felt", 20 )
        self.m_dps : addChild( self.m_dps_stringTTF[i] )
        local tag = 200 + i
        self.m_dps_stringTTF[i] : setTag( tag )
        self.m_dps_stringTTF[i] : setAnchorPoint( ccp(0,0.5) )
        self.m_dps_stringTTF[i] : setPosition( zeroX , zeroY)
        zeroY = zeroY - 28
        self.m_dps_stringTTF[i] : setVisible( false )
    end

    --设置TAG 值
    dpbtn : setTag( 100 )
    tempCCSprite_right : setTag( 101 )
    tempCCSprite_down : setTag( 102 )
    ttf : setTag( 103 )
    lime : setTag( 104 )

    self.m_dps_dpbtn = dpbtn
    self.m_dps_tempCCSprite_right = tempCCSprite_right
    self.m_dps_tempCCSprite_down = tempCCSprite_down
    self.m_dps_ttf = ttf
    self.m_dps_lime = lime


    container : addChild( self.m_dps )

end



function CBattleView.allDpsCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) )
    elseif (eventType == "TouchEnded") then
        if (obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) == true) then
            if obj : getTag() == 100 then
                self.m_bIsShowAllDps = not( self.m_bIsShowAllDps )
                self : changeDPsLayout()
            end
        end
    end
end

function CBattleView.changeDPsLayout( self )
    if self.m_dps == nil then
        return
    end
    local bigSize = CCSizeMake( 375, 518 )
    local smallSize = CCSizeMake( 375, 48 )
    local dpbtn = self.m_dps_dpbtn
    local tempCCSprite_right = self.m_dps_tempCCSprite_right
    local tempCCSprite_down = self.m_dps_tempCCSprite_down
    local ttf = self.m_dps_ttf
    local lime = self.m_dps_lime
    local dpslist = _G.g_Stage : getDpsList()
    if dpslist == nil then
        dpslist = {}
    end

    local selfDps = _G.g_Stage : getSelfDps()
    if selfDps == nil then
        selfDps = 0
    end

    local uid = tonumber(_G.g_LoginInfoProxy : getUid())
    local tempRank = nil
    for rank,dpsData in pairs(dpslist) do
        if dpsData : getUid() == uid then
            tempRank = rank
            break
        end
    end

    local bossHp = _G.g_Stage : getBossMaxHp()
    local harmString = tostring(selfDps/bossHp *100)
    harmString = string.sub(harmString,1,5)

    if tempRank == nil then
        ttf : setString("你造成的伤害("..harmString..")")
    else
        ttf : setString("你造成的伤害("..harmString..")".."排名"..tostring(tempRank))
    end

    if self.m_bIsShowAllDps == true then
        local x = self.winSize.width - bigSize.width / 2 + 10
        local y = self.winSize.height - bigSize.height / 2 - self.m_lpHeadSize.height
        self.m_dps : setPosition( x, y )

        self.m_dps : setPreferredSize( bigSize )
        for i=1,10 do
            local tempString = ""
            tempString = tempString..tostring(i).."."
            if dpslist[i] ~= nil then
                local percent = tostring(dpslist[i] : getHarm()/ bossHp * 100 )
                percent = string.sub(percent,1,5)
                tempString = tempString..dpslist[i] : getName().." 造成的伤害 "..tostring( dpslist[i]: getHarm() ).." ("..percent..")"
            end
            -- local tag = 200 + i
            -- local stringTTF = self.m_dps : getChildByTag( tag )
            if self.m_dps_stringTTF[i] ~= nil then
                self.m_dps_stringTTF[i] : setString(tempString)
                self.m_dps_stringTTF[i] : setVisible( true )
            end
        end
        tempCCSprite_down : setVisible( true )
        tempCCSprite_right : setVisible( false )

        ttf : setPosition(0-bigSize.width/2+29, bigSize.height / 2 - 24)
        lime : setVisible( true )
        dpbtn : setPosition(0,bigSize.height/2 - smallSize.height /2)
    else
        self.m_dps : setPreferredSize( smallSize )
        local x = self.winSize.width - smallSize.width / 2 + 10
        local y = self.winSize.height - smallSize.height / 2 - self.m_lpHeadSize.height
        self.m_dps : setPosition( x, y )
        for i=1,10 do
            -- local tag = 200 + i
            -- local stringTTF = self.m_dps : getChildByTag( tag )
            if self.m_dps_stringTTF[i] ~= nil then
                self.m_dps_stringTTF[i] : setVisible( false )
            end
        end
        tempCCSprite_down : setVisible( false )
        tempCCSprite_right : setVisible( true )

        ttf : setPosition(0-smallSize.width/2+29, 0)
        dpbtn : setPosition(0,0)
        lime : setVisible( false )
    end
end

function CBattleView.updateDps( self )
    self : changeDPsLayout()
end


--人物死亡后的提示 414 280
function CBattleView.showBossDeadView( self )
    container = _G.g_Stage : getDspContainer()
    if container == nil then
        return
    end
    self : loadRes()
    container : setFullScreenTouchEnabled(true)
    container : setTouchesEnabled(true)
    container : setTouchesPriority(-99)

    self : hideBossDeadView()
    self.m_lpSpriteBossDead = CSprite:createWithSpriteFrameName("general_first_underframe.png")
    local size = CCSizeMake( 414, 280)
    self.m_lpSpriteBossDead : setPreferredSize( size )

    local nowBtn = CButton :createWithSpriteFrameName("立即复活","general_button_normal.png")
    -- local btn = CButton :createWithSpriteFrameName("复活","general_button_normal.png")
    nowBtn : setTouchesPriority(-99)
    -- btn : setTouchesPriority(-99)
    self.m_lpTipsTTF = CCLabelTTF : create( "提示:立即复活需要消耗钻石", "Marker Felt", 20 )
    local showTipsTTF = CCLabelTTF : create( "等待复活", "Marker Felt", 30 )
    self.m_lpTipsTTF : setAnchorPoint(ccp(0,0.5))
    local function callBack( eventType, obj, x, y)
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) )
        elseif(eventType == "TouchEnded") and  (obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) == true) then
            if obj == nowBtn then
                local command = CStageREQCommand(_G.Protocol["REQ_WORLD_BOSS_REVIVE"])
                command : setOtherData({type=1})
                _G.controller : sendCommand( command )
            end
        end
    end
    nowBtn : registerControlScriptHandler(callBack, "this is CBattleView nowBtn 294")
    -- btn : registerControlScriptHandler(callBack, "this is CBattleView btn 295")

    self.m_lpSpriteBossDead : addChild(nowBtn)
    -- self.m_lpSpriteBossDead : addChild(btn)
    self.m_lpSpriteBossDead : addChild(self.m_lpTipsTTF)
    self.m_lpSpriteBossDead : addChild(showTipsTTF)

    nowBtn : setPosition( 0, 0 - size.height/2/2 )
    -- btn : setPosition( size.width/2/2, 0- size.height/2/2)
    self.m_lpTipsTTF : setPosition( 0-size.width/2 +10, 0 - size.height/2.5 )
    showTipsTTF : setPosition( 0, size.height / 3   )

    container : addChild( self.m_lpSpriteBossDead )
    self.m_lpSpriteBossDead : setPosition( self.winSize.width / 2, self.winSize.height / 2)
end
function CBattleView.setBossDeadTipsRMB( self, _num )
    if self.m_lpTipsTTF == nil then
        return
    end
    self.m_lpTipsTTF : setString("提示:立即复活需要消耗钻石"..tostring(_num) )
end
--删除BOSS死亡界面
function CBattleView.hideBossDeadView( self )
    if self.m_lpSpriteBossDead == nil then
        return
    end
    container = _G.g_Stage : getDspContainer()
    if container ~= nil then
        container : setFullScreenTouchEnabled(false)
        container : setTouchesEnabled(false)
    end

    self.m_lpSpriteBossDead : removeFromParentAndCleanup( true )
    self.m_lpSpriteBossDead = nil
    self.m_lpTipsTTF  = nil
    self.m_lpTimeTTF = nil
end
--显示复活时间
function CBattleView.showBossDeadViewString( self, _Time )
    if self.m_lpSpriteBossDead == nil then
        return
    end

    _Time = _Time < 0 and 0 or _Time
    local min  = math.floor( _Time /  60 )
    min = min < 0 and 0 or min
    local sec  = math.floor( _Time -  min * 60 )
    sec = sec < 0 and 0 or sec
    min = self: toTimeString( min )
    sec = self: toTimeString( sec )

    if self.m_lpTimeTTF ~= nil then
        self.m_lpTimeTTF : setString( min.." : "..sec )
    else
        self.m_lpTimeTTF = CCLabelTTF : create( min.." : "..sec, "Marker Felt", 30 )
        local size = CCSizeMake( self.winSize.width / 4, self.winSize.height / 4)
        self.m_lpTimeTTF : setPosition( 0, size.height / 2- 40)
        self.m_lpSpriteBossDead : addChild( self.m_lpTimeTTF )
    end
end












--{连击模式}
function CBattleView.showLJTZ( self, _value, _maxValue, _container )
    self : loadRes()
    _container : removeAllChildrenWithCleanup( true )

    local backgroundSprite = CSprite : createWithSpriteFrameName( "career_word_frame.png" )
    backgroundSprite : setControlName( "this CBattleView backgroundSprite 570 ")
    _container : addChild( backgroundSprite )
    local ljSprite = CCSprite : createWithSpriteFrameName( "career_word_ljtz.png" )
    backgroundSprite : addChild( ljSprite )

--左
    local leftstrCombo = tostring( _value )
    local leftLenStrCombo = string.len(leftstrCombo)

    local leftTempContainer = CContainer : create()
    leftTempContainer : setControlName( "this CBattleView leftTempContainer 565 ")
    local x = 0
    for i=leftLenStrCombo,1,-1 do
        local strCurrent = string.sub(leftstrCombo,i,i)
        local numSprite = CSprite : createWithSpriteFrameName( "battle_hits_number_"..strCurrent..".png" )
        numSprite : setControlName( "this CBattleView numSprite 27 ")
        leftTempContainer : addChild( numSprite )
        local numSpriteSize = numSprite : getPreferredSize()
        x = x - numSpriteSize.width / 2
        numSprite : setPosition( ccp( x, 0 ) )
        x = x - numSpriteSize.width / 2
    end
    backgroundSprite : addChild( leftTempContainer )
    backgroundSpriteSize = backgroundSprite : getPreferredSize()
    leftTempContainer : setPosition( 0- backgroundSpriteSize.width /2, 0  )

--右

    local strCombo = tostring( _maxValue )
    local lenStrCombo = string.len(strCombo)

    local tempContainer = CContainer : create()
    tempContainer : setControlName( "this CBattleView tempContainer 565 ")
    local x = 0
    for i=lenStrCombo,1,-1 do
        local strCurrent = string.sub(strCombo,i,i)
        local numSprite = CSprite : createWithSpriteFrameName( "battle_hits_number_"..strCurrent..".png" )
        numSprite : setControlName( "this CBattleView numSprite 27 ")
        tempContainer : addChild( numSprite )
        local numSpriteSize = numSprite : getPreferredSize()
        x = x - numSpriteSize.width / 2
        numSprite : setPosition( ccp( x, 0 ) )
        x = x - numSpriteSize.width / 2
    end
    backgroundSprite : addChild( tempContainer )
    backgroundSpriteSize = backgroundSprite : getPreferredSize()
    tempContainer : setPosition( backgroundSpriteSize.width /2 - x,  0 )

    backgroundSprite : setPosition(self.winSize.width/2, self.winSize.height  - 101)
end

--{限时模式}
function CBattleView.showXSTZ( self, _container )
    self : loadRes()
    _container : removeAllChildrenWithCleanup( true )
    local backgroundSprite = CSprite : createWithSpriteFrameName( "career_word_frame.png" )
    backgroundSprite : setControlName( "this CBattleView backgroundSprite 612 ")
    _container : addChild( backgroundSprite )
    local xsSprite = CCSprite : createWithSpriteFrameName( "career_word_xstz.png" )
    backgroundSprite : addChild( xsSprite )
    backgroundSprite : setPosition(self.winSize.width/2, self.winSize.height  - 101)
end

--{生存模式}
function CBattleView.showSCTZ( self, _container )
    self : loadRes()
    _container : removeAllChildrenWithCleanup( true )
    local backgroundSprite = CSprite : createWithSpriteFrameName( "career_word_frame.png" )
    backgroundSprite : setControlName( "this CBattleView backgroundSprite 624 ")
    _container : addChild( backgroundSprite )
    local scSprite = CCSprite : createWithSpriteFrameName( "career_word_sctz.png" )
    backgroundSprite : addChild( scSprite )

    backgroundSprite : setPosition(self.winSize.width/2, self.winSize.height - 101)
end


_G.g_BattleView = CBattleView()