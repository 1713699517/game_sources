require "view/view"

CBigHpView = class(view, function( self, _headID,  _hpNum,  _lv, _left , _container, _szBossName, _hp, _maxHp, _sp, _maxSp, _monsterID, _monsterType )
    self.winSize = CCDirector :sharedDirector() :getVisibleSize()

    self.m_headID = _headID
    self.m_hpNum = _hpNum
    self.m_lv = _lv
    self.m_left = _left or false
    self.m_type = _monsterType
    --new add
    self.m_bossName = _szBossName or ""
    print("bossname", _szBossName, self.m_hpNum, _left, self.m_headID, _monsterID)

    local mainProperty  = _G.g_characterProperty : getMainPlay()
    if mainProperty==nil then
        --CCMessageBox( "mainProperty==", mainProperty)
        CCLOG("codeError!!!! mainProperty=="..mainProperty)
    end
    self.m_szName  = mainProperty :getName() or 0

    self : loadResources()

    _container : addChild( self : initView( _hp, _maxHp, _sp, _maxSp, _monsterID ) )
    self : initlayout()
    print("_hp, _maxHp",_hp, _maxHp)
    self : setHpValue( _hp-1, _maxHp )
end)

-- 级别字样大小 缩放
CBigHpView.LV_SPR_SCALE = 0.90

function CBigHpView.loadResources( self )
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")
end

--{初始化}
function CBigHpView.initView( self, _hp, _maxHp, _sp, _maxSp, _monsterID )
print("CBigHpView.initView--------")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    self.m_lpHead = CCSprite : createWithSpriteFrameName( "battle_role_frame_02.png" )
    self.m_lpHeadSize = self.m_lpHead : getContentSize()
    --头像
    local mainProperty          = _G.g_characterProperty:getMainPlay()
    local nJob = mainProperty :getPro()
    if nJob == nil or nJob > 4 or nJob < 1 then
        nJob = 1
    end
    print("nJobnJob", nJob, self.m_left, self.m_type, _G.Constant.CONST_MONSTER, _G.Constant.CONST_PLAYER)
    local szRoleSpr = "menu_role_0" .. tostring( nJob or "3" ) .. ".png"

    --boss 头像
    if self.m_left == false or self.m_type == _G.Constant.CONST_PLAYER then
        print("sdfsdfsdfbnJob", _monsterID)
        if self.m_type == _G.Constant.CONST_MONSTER then
            local monsterNode = _G.MonsterXMLManager :getXMLMonster( _monsterID )
            if monsterNode ~= nil then
                local _nHeadId = monsterNode:getAttribute("head")
                if _nHeadId == nil or _nHeadId == "0" then
                    _nHeadId = "10301"
                end
                szRoleSpr = "BossResources/hn" .. ( _nHeadId or "10301" ).. ".png"
            end
            self.m_lpRoleHead = CSprite :create( tostring( szRoleSpr ))
        elseif self.m_type == _G.Constant.CONST_PLAYER then
            local player = _G.g_characterProperty :getOneByUid( _monsterID, _G.Constant.CONST_PLAYER )
            if player ~= nil then
                szRoleSpr = "menu_role_0"  .. tostring( player :getPro() or "3" ) .. ".png"
            end
            self.m_lpRoleHead = CSprite :createWithSpriteFrameName( tostring( szRoleSpr ))
        end

    else
        self.m_lpRoleHead = CSprite :createWithSpriteFrameName( tostring( szRoleSpr ))
    end

    print("szRoleSprszRoleSprszRoleSpr", szRoleSpr)

    self.m_lpRoleHeadSize = self.m_lpRoleHead : getPreferredSize()
    self.m_lpHead   : addChild( self.m_lpRoleHead, 100 )
    --名字
    self.m_lpRoleName  = CCLabelTTF :create( tostring(self.m_szName), "Arial", 20)
    self.m_lpHead   :addChild( self.m_lpRoleName)
    --hp底图
    self.m_lpHpBackGround = CCSprite : createWithSpriteFrameName( "battle_player_hp_back.png" )
    self.m_lpHpBackGroundSize = self.m_lpHpBackGround : getContentSize()
    self.m_lpHead : addChild( self.m_lpHpBackGround )

    --蓝条
    self.m_lpSpProgress = CSprite : createWithSpriteFrameName( "battle_player_sp.png", CCRectMake( 8, 0, 1, 12) )
    self.m_lpSpProgress : setAnchorPoint( ccp( 0.0, 0.5))
    local spSize = CCSizeMake( 153.0, 9.0 )
    self.m_lpSpProgress : setPreferredSize( spSize )
    self.m_lpSpProgressSize = self.m_lpSpProgress :getPreferredSize()
    self.m_lpHead : addChild( self.m_lpSpProgress )


    --红条
    self.m_lpHpProgressArray = {}
    --hp血量的size
    self.m_lpHpProgressArraySize = {}
    print("self.m_hpNum", self.m_hpNum)
    for i=1,self.m_hpNum do
        local pngIndex = i % 7
        pngIndex = pngIndex == 0 and 7 or pngIndex
        print(" pngIndex", pngIndex)
        self.m_lpHpProgressArray[i] = CSprite : createWithSpriteFrameName( "battle_player_hp"..pngIndex..".png", CCRectMake( 10, 0, 1, 15))
        self.m_lpHpProgressArray[i] : setAnchorPoint( ccp( 0.0, 0.5))
        local progressArraySize     = self.m_lpHpProgressArray[i] : getPreferredSize()
        self.m_lpHpProgressArraySize[i] = CCSizeMake( 317, progressArraySize.height )
        self.m_lpHpProgressArray[i] : setPreferredSize( self.m_lpHpProgressArraySize[i] )
        self.m_lpHead               : addChild( self.m_lpHpProgressArray[i] )

    end

    --最上层的框
    self.m_lpTopFrame = CSprite : createWithSpriteFrameName( "battle_role_frame_01.png" )
    self.m_lpTopFrameSize = self.m_lpTopFrame :getPreferredSize()
    self.m_lpHead : addChild( self.m_lpTopFrame )

    self.m_lpLv = CCLabelTTF :create( "LV:", "Arial", 16)
    self.m_lpLv :setColor( ccc3( 0, 255, 255))
    self.m_lpLvSize = self.m_lpLv : getContentSize()
    self.m_lpTopFrame : addChild( self.m_lpLv )

    --等级数字 -在这里已经做好了位置布局
    local strLvNum = tostring( self.m_lv )
    local strX = self.m_lpLvSize.width
    self.m_nLvSpriteOffset  = 0
    for i=1,string.len(strLvNum) do
        local currStr = string.sub(strLvNum,i,i)
        local currNumSprite = CCSprite : createWithSpriteFrameName( "battle_"..currStr..".png" )
        local currNumSpriteSize = currNumSprite : getContentSize()
        self.m_lpLv : addChild( currNumSprite )
        strX = strX + currNumSpriteSize.width / 2
        currNumSprite :setScale( CBigHpView.LV_SPR_SCALE )
        currNumSprite : setPosition( strX, currNumSpriteSize.height * 0.6 )
        strX = strX + currNumSpriteSize.width / 2
        self.m_nLvSpriteOffset = self.m_nLvSpriteOffset + currNumSpriteSize.width
    end


    --红条数量字
    self : addHpNumSprite( self.m_hpNum )

    self.m_lpHpString = CCLabelTTF : create( tostring(_hp+1).."/"..tostring(_maxHp), "Marker Felt", 20 )
    self.m_lpTopFrame : addChild( self.m_lpHpString )

    self.m_lpSpString = CCLabelTTF : create( tostring(_sp).."/"..tostring(_maxSp), "Marker Felt", 18 )
    self.m_lpTopFrame : addChild( self.m_lpSpString )

    return self.m_lpHead
end

function CBigHpView.addHpNumSprite( self, _hpNum )
    if self.m_left == true then
        return
    end
    if self.m_lpHpNum ~= nil then
        self.m_lpHpNum : removeFromParentAndCleanup( true )
        self.m_lpHpNum = nil
    end

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    self.m_lpHpNum = CCSprite : createWithSpriteFrameName("battle_×.png")
    self.m_lpHpNumSize = self.m_lpHpNum : getContentSize()
    local stringNum = _hpNum
    local strX = self.m_lpHpNumSize.width
        print( "CBigHpView.addHpNumSprite-->", stringNum, strX)
    for i=1,string.len(stringNum) do
        local currStr = string.sub(stringNum,i,i)
        local currSprite = CCSprite : createWithSpriteFrameName("battle_"..currStr..".png")
        print( "currSprite"..i,  "  battle_"..currStr..".png" )
        local currSpriteSize = currSprite : getContentSize()
        self.m_lpHpNum : addChild( currSprite )
        strX = strX + currSpriteSize.width / 2
        currSprite : setPosition( strX, currSpriteSize.height-4 )
        strX = strX + currSpriteSize.width / 2
    end
    self.m_lpHpBackGround : addChild( self.m_lpHpNum )

    self.m_lpHpNum : setScaleX( -1 )
    local hpNumX = self.m_lpHpBackGroundSize.width - self.m_lpHpNumSize.width / 2 - 15
    local hpNumY = -self.m_lpHpNumSize.height
    self.m_lpHpNum : setPosition( ccp(hpNumX, hpNumY) )
end

--{布局}
function CBigHpView.initlayout( self )
    --头部
    local headX = self.m_lpHeadSize.width / 2
    local headY = self.winSize.height - self.m_lpHeadSize.height / 2
    headX = self.m_left == false and self.winSize.width - headX or headX
    self.m_lpHead : setPosition( ccp( headX, headY ) )

    --最上层
    local frameX = self.m_lpTopFrameSize.width / 2
    local frameY = self.m_lpTopFrameSize.height / 2
    self.m_lpTopFrame : setPosition( ccp( frameX * 1.10, frameY * 1.13 ) )

    local fontX = self.m_lpHeadSize.width * 0.4
    local fontY = self.m_lpHeadSize.height * 0.9
    self.m_lpRoleName :setPosition( fontX, fontY)

    local roleHeadX = self.m_lpRoleHeadSize.width / 2
    local roleHeadY = self.m_lpRoleHeadSize.height *0.8
    --self.m_lpRoleHead :setScale( 1.0 )
    self.m_lpRoleHead :setPosition( ccp( roleHeadX, roleHeadY))
    --hp底图
    local hpBackGroundX = self.m_lpHeadSize.width*0.231 + self.m_lpHpBackGroundSize.width /2
    local hpBackGroundY = self.m_lpHeadSize.height*0.631 + self.m_lpHpBackGroundSize.height / 2
    self.m_lpHpBackGround : setPosition( ccp( hpBackGroundX, hpBackGroundY ) )
    --hp字
    self.m_lpHpString : setPosition( self.m_lpTopFrameSize.width * 0.10, self.m_lpTopFrameSize.height * 0.30 )

    --sp字
    self.m_lpSpString : setPosition( -self.m_lpTopFrameSize.width * 0.105,  self.m_lpTopFrameSize.height * 0.11 )

    ----------------------

    local lvX = -self.m_lpHeadSize.width * 0.3851
    local lvY = -self.m_lpHeadSize.height * 0.2813
    self.m_lpLv : setPosition ( lvX, lvY )
    --print("--等级", lvX, lvY )
    --蓝条
    local spX = self.m_lpSpProgressSize.width * 0.5 + self.m_lpHeadSize.width * 0.251
    local spY = self.m_lpSpProgressSize.height * 0.5 + self.m_lpHeadSize.height * 0.491
    self.m_lpSpProgress : setPosition( ccp( spX, spY ) )

    self.m_distanceX = 108
    for i=1, self.m_hpNum do
        --红条
        local hpX = self.m_lpHpProgressArraySize[i].width / 2 + self.m_distanceX --self.m_lpHeadSize.width * 0.241
        local hpY = self.m_lpHpProgressArraySize[i].height / 2 + self.m_lpHeadSize.height * 0.551
        self.m_lpHpProgressArray[i] : setPosition( ccp( hpX, hpY ) )
    end

    if self.m_left == false then
        self.m_lpHead : setScaleX( -1 )
        self.m_lpRoleName :setScaleX( -1)

        self.m_lpRoleName :setString( self.m_bossName or "")
        self.m_lpLv : setScaleX( -1 )
        self.m_lpHpString : setScaleX( -1 )
        self.m_lpSpString : setScaleX( -1 )
        self.m_lpLv : setPosition( lvX+self.m_nLvSpriteOffset+10, lvY )
    end
end

--{调整血量}
function CBigHpView.setHpValue( self, _hp, _maxHp )
    if _hp > _maxHp then
        _hp = _maxHp
    end
    if _hp <= 0 then
        self.m_lpHead : removeFromParentAndCleanup( true )
        self.m_lpHead = nil
        return
    end
    local num = 1
    local oneHp      = _maxHp / self.m_hpNum
    local lastHp     = _hp % oneHp
    local nowHP_page = math.floor( _hp / oneHp )
    if ( _hp % oneHp ) > 0 then
        nowHP_page = nowHP_page + 1
    end

    --print("CBigHpView.setHpValue   ",_maxHp,oneHp,"lastHp->"..lastHp,"  nowHP_page->"..nowHP_page,"  hp->".._hp,"self.m_hpNum->"..self.m_hpNum)
    for i=self.m_hpNum, 1, -1 do
        if nowHP_page < i then
            if self.m_lpHpProgressArray[i] ~= nil then
                self.m_lpHpProgressArray[i] : setVisible( false )
            end
        elseif nowHP_page == i then
            local lastHpScale = lastHp / oneHp
            local lastHpSize  = CCSizeMake( self.m_lpHpProgressArraySize[i].width * lastHpScale, self.m_lpHpProgressArraySize[i].height )

            --print("æææææææææææææææ   ",lastHpScale,lastHpSize.width,lastHpSize.height,self.m_lpHpProgressArraySize[i].width,self.m_lpHpProgressArraySize[i].height)

            local scale_X = 1.0
            if lastHpSize.width <= 50 then
                lastHpSize  = CCSizeMake( 50, self.m_lpHpProgressArraySize[i].height )
                scale_X = lastHpSize.width / 50
                self.m_lpHpProgressArray[i] : setScaleX(scale_X)
            end

            self.m_lpHpProgressArray[i] : setPreferredSize( lastHpSize )
            self.m_lpHpProgressArray[i] : setPosition( self.m_distanceX + lastHpSize.width/2*scale_X, lastHpSize.height/2 + self.m_lpHeadSize.height * 0.551 )

            break
        end
    end

    self : addHpNumSprite( nowHP_page )
    self.m_lpHpString : setString(tostring(_hp+1).."/"..tostring(_maxHp) )

    --[[
    for i=self.m_hpNum, 1, -1 do
        local nowSize = self.m_lpHpProgressArray[i] : getPreferredSize()
        if nowSize.width <= self.m_lpHpProgressArraySize[i].width and nowSize.width >= 0 then
            local oneHp = _maxHp / self.m_hpNum
            local value = 0
            if (oneHp * (i - 1)) <= _hp then
                value = (_hp - (oneHp * (i - 1))) / oneHp
            end
            --print("hpsize==", nowSize.width, nowSize.height, value, self.m_lpHpProgressArraySize[i].width)

            if value > 1 then
                value = 1
            end
            local changeSize = CCSizeMake( self.m_lpHpProgressArraySize[i].width * value, self.m_lpHpProgressArraySize[i].height)


            --if changeSize.width < 20 then
                --self.m_lpHpProgressArray[i] :setVisible( false )

            --else
                if changeSize.width > 50 then
                    self.m_lpHpProgressArray[i] : setPreferredSize( changeSize )
                else
                    print( "changeSize.width", changeSize.width, value )
                    local _percent = changeSize.width / 50
                    self.m_lpHpProgressArray[i] :setScaleX( _percent )
                end
                self.m_lpHpProgressArray[i] :setVisible( true )
                local changeX = changeSize.width/2 + self.m_distanceX
                local changeY = changeSize.height/2 + self.m_lpHeadSize.height * 0.551
                self.m_lpHpProgressArray[i] :setPosition( changeX, changeY )
            --end

            if value > 0 then
                if i > num then
                    num = i
                end
            end
            --num =  self.m_hpNum - i + 1
        end
    end
    ]]

    --[[
    if _hp <= 0 then
        self.m_lpHead : removeFromParentAndCleanup(true)
        return
    end
    local num = 1
    for i=self.m_hpNum, 1, -1 do
        local percentage = self.m_lpHpProgressArray[i] : getPercentage()
        if percentage > 0 then
            local oneHp = _maxHp / self.m_hpNum
            local value = 0
            if (oneHp * (i - 1)) <= _hp then
                value = (_hp - (oneHp * (i - 1))) / oneHp * 100
            end
            self.m_lpHpProgressArray[i] : setPercentage(value)
            if i > num then
                num = i
            end
        end
    end
    self : addHpNumSprite( num )
     --]]
end

--{调整蓝条}
function CBigHpView.setSpValue( self, _sp, _maxSp )
    --self.m_lpSpProgress : setPercentage( _value )
    --print("蓝条值", _value)
    if _G.pKeyBoardView ~= nil then
        _G.pKeyBoardView :isBlackOrColor()
    end

    local _value = _sp / _maxSp * 100

    if _value==nil or _value < 0 or _value > 100 then
        print("蓝条", _value)
        return
    end
    local nPercent = tonumber( _value) / 100
    if nPercent >= 1 then
        self :addHightLightLine( self.m_lpSpProgress )
    end

    local changeSize = CCSizeMake( self.m_lpSpProgressSize.width * nPercent, self.m_lpSpProgressSize.height)
    --if changeSize.width > 16 then
    self.m_lpSpProgress : setPreferredSize( changeSize)        --print("蓝条大小", changeSize.width)
    --end

    local spSize = self.m_lpSpProgress : getPreferredSize()
    local spX = changeSize.width * 0.5 + self.m_lpHeadSize.width * 0.251
    local spY = changeSize.height * 0.5 + self.m_lpHeadSize.height * 0.471
    self.m_lpSpProgress : setPosition( ccp( spX, spY ) )

    self.m_lpSpString : setString( tostring( _sp ).."/"..tostring( _maxSp ))
end

--{蓝条满时 高亮蓝条}
function CBigHpView.addHightLightLine( self, _layer )
    if _layer ~= nil then
        if self.m_lpHightLine ~= nil then
          self.m_lpHightLine :removeFromParentAndCleanup( true )
          self.m_lpHightLine = nil
        end

        CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
        self.m_lpHightLine = CCSprite :createWithSpriteFrameName( "joyStick_sp_shine.png" )
        _layer :addChild( self.m_lpHightLine, 10 )

        local _fadeout = CCFadeOut :create( 0.6 )
        self.m_lpHightLine :runAction( _fadeout )
    end
end

