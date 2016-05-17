require "view/view"
require "model/VO_KeyBoardModel"
require "controller/KeyBoardCommand"

CKeyBoardView = class(view)

--constant
CKeyBoardView.BUTTON_ATTACK = 10
CKeyBoardView.BUTTON_JUMP   = 20
CKeyBoardView.BUTTON_SKILL1 = 30
CKeyBoardView.BUTTON_SKILL2 = 40
CKeyBoardView.BUTTON_SKILL3 = 50
CKeyBoardView.BUTTON_SKILL4 = 60
CKeyBoardView.BUTTON_SKILL5 = 70
CKeyBoardView.BUTTON_SKILL6 = 80


function CKeyBoardView.loadResources( self, winSize )
    --老的  待删除
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("skillsResources/skillResources.plist")

    --新 替换  2013.07.04
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Joystick/keyBoardResources.plist")
end

function CKeyBoardView.layout( self, winSize )

    if winSize.height == 640 then
        local nPosX = winSize.width
        local nPosY = winSize.height

        local nNormalSize = self.m_btnAttack :getContentSize()      --普通攻击大小
        local nJumpSize   = self.m_btnJump :getContentSize()        --跳跃按钮大小
        local nUp = 10

        local nJumpPosX = nPosX-80
        local nJumpPosY = 80
        self.m_btnJump  :setPosition( nJumpPosX, nJumpPosY)

        self.m_btnAttack :setPosition( nJumpPosX - 145, nJumpPosY)


        --local nSkillSize  = self.m_btnSkill[1] :getContentSize()
        if self.m_btnSkill[1] ~= nil then
          self.m_btnSkill[1] :setPosition( nJumpPosX - 145*2, nJumpPosY )
        end
        if self.m_btnSkill[2] ~= nil then
          self.m_btnSkill[2] :setPosition( nJumpPosX - 145/2 - 145, 205 )
        end
        if self.m_btnSkill[3] ~= nil then
          self.m_btnSkill[3] :setPosition( nJumpPosX - 145/2, 205 )
        end
        --self.m_btnSkill[4] :setPosition( nPosX-nSkillSize.width/2-5, nNormalSize.height*8/5 )

        for i=1, #self.m_btnSkill do
            self.m_cdSkill[i]:setPosition( ccp(self.m_btnSkill[i]:getPosition()) )
        end

        if self.m_bCould == true then
            if self.m_btnSkill[5] ~= nil then
                self.m_btnSkill[5] :setPosition( nPosX-45, nPosY-70 )
            end
            if self.m_btnSkill[6] ~= nil then
                self.m_btnSkill[6] :setPosition( nPosX-150, nPosY-130 )
            end
        end
        --]]
    elseif winSize.height == 768 then

    end

end


function CKeyBoardView.init( self, winSize, layer )

    CKeyBoardView:loadResources()

    CKeyBoardView.initView( self, layer )

    CKeyBoardView.layout( self, winSize )

end


function CKeyBoardView.initView(self, layer)

    local function buttonCallBack(eventType, obj, touches)
        return self:btnCallback(eventType, obj, touches)
    end
    print("CKeyBoardView.initView")
    --普通攻击
    self.m_btnAttack = CButton :createWithSpriteFrameName("", "joyStick_common_skill.png", "", "joyStick_gray.png")
    self.m_btnAttack : setControlName( "this CKeyBoardView self.m_btnAttack 77 ")
    self.m_btnAttack:setTag(CKeyBoardView.BUTTON_ATTACK)
    self.m_btnAttack:setTouchesMode(kCCTouchesAllAtOnce)
    local szAttackImg = "IconSkill/is999.png"
    local _attackSpr  = CSprite :create( tostring( szAttackImg ) )
    if _attackSpr ~= nil then
        self.m_btnAttack  : addChild( _attackSpr, 10 )
    end
    layer :addChild( self.m_btnAttack,10 )

    self.m_btnJump = CButton :createWithSpriteFrameName("", "joyStick_common_skill.png", "", "joyStick_gray.png")
    self.m_btnJump : setControlName( "this CKeyBoardView self.m_btnJump 83 ")
    self.m_btnJump:setTag(CKeyBoardView.BUTTON_JUMP)
    self.m_btnJump:setTouchesMode(kCCTouchesAllAtOnce)
    local szJumpImg = "IconSkill/is998.png"
    local _jumpSpr  = CSprite :create( tostring( szJumpImg ) )
    if _jumpSpr ~= nil then
        self.m_btnJump  : addChild( _jumpSpr, 10 )
    end
    layer :addChild( self.m_btnJump,9 )


    local roleProperty  = _G.g_characterProperty : getMainPlay()
    if roleProperty == nil then
        CCLOG("codeError!!!! CKeyBoardView.initView 103"..roleProperty)
    end
    local skillData     = roleProperty :getSkillData()

    local nMark = tostring( skillData : getSkillIdByIndex( 5 ) )

    self.m_btnSkill = {}
    self.m_cdSkill = {}


    local szPngName =  "joyStick_gray.png"


    local isbtn1 = true
    if _G.g_LoginInfoProxy:getFirstLogin() == true and _G.g_Stage : getCheckPointID() < 2 then
        isbtn1 = false
    end
    if isbtn1 == true then
        self.m_btnSkill[1] = CButton:createWithSpriteFrameName( nMark, "joyStick_common_skill.png", "", szPngName)
        self.m_btnSkill[1] : setControlName( "this CKeyBoardView self.m_btnSkill[1] 94 ")
        CKeyBoardView.BUTTON_SKILL1 = tonumber( nMark )
        self.m_btnSkill[1] :setTag( CKeyBoardView.BUTTON_SKILL1 )
        layer:addChild( self.m_btnSkill[1],8 )
        self :addSkillIconById( nMark, self.m_btnSkill[1] )
        if _G.g_Stage : getCheckPointID() == 2 and _G.g_LoginInfoProxy:getFirstLogin() == true then
            local tipsSprite = CSprite : create("FirstWarResources/first_tips_hand.png")
            tipsSprite : setAnchorPoint(ccp(0,0))
            local tipsSpriteSize = tipsSprite : getPreferredSize()
            tipsSprite : setPosition(ccp(tipsSpriteSize.width/2,0-tipsSpriteSize.height/2))
            local tipsSpriteFram = CSprite : create("FirstWarResources/first_tips_fram.png")
            local ttfString = CCLabelTTF : create( "使用新技能", "Marker Felt", 21 )
            tipsSpriteFram : addChild( ttfString )
            tipsSpriteFram : setPosition( 0, 65 )
            tipsSprite : setTag(500)
            tipsSpriteFram : setTag(600)
            self.m_btnSkill[1] : addChild( tipsSprite,100 )
            self.m_btnSkill[1] : addChild( tipsSpriteFram,200 )
            
            local _pFrameEffictsCCBI = self :getEfficts_guide_by_tag( 3 )
            if _pFrameEffictsCCBI ~= nil then
                tipsSpriteFram :addChild( _pFrameEffictsCCBI, 50 )
            end
            
            local _pBtnEffictsCCBI = self :getEfficts_guide_by_tag( 2 )
            if _pBtnEffictsCCBI ~= nil then
                self.m_btnSkill[1] :addChild( _pBtnEffictsCCBI, 150 )
            end
            
            local act1 = CCMoveBy:create(0.8,ccp(30,-30))
            local _callBacks = CCArray:create()
            _callBacks:addObject(act1)
            _callBacks:addObject(act1 : reverse() )
            tipsSprite:runAction( CCRepeatForever : create( CCSequence:create(_callBacks) ) )
        end
    end

    local isbtn2 = true
    if _G.g_LoginInfoProxy:getFirstLogin() == true and _G.g_Stage : getCheckPointID() < 3 then
        isbtn2 = false
    end
    if isbtn2 == true then
        nMark = tostring(skillData : getSkillIdByIndex( 6 ))
        self.m_btnSkill[2] = CButton:createWithSpriteFrameName( nMark, "joyStick_common_skill.png", "", szPngName)
        self.m_btnSkill[2] : setControlName( "this CKeyBoardView self.m_btnSkill[2] 100 ")

        CKeyBoardView.BUTTON_SKILL2 = tonumber( nMark )
        print("nMarknMark222", nMark, CKeyBoardView.BUTTON_SKILL2)
        self.m_btnSkill[2] :setTag(CKeyBoardView.BUTTON_SKILL2)
        layer:addChild( self.m_btnSkill[2],7 )

        self :addSkillIconById( nMark, self.m_btnSkill[2] )

        if _G.g_Stage : getCheckPointID() == 3 and _G.g_LoginInfoProxy:getFirstLogin() == true then
            local tipsSprite = CSprite : create("FirstWarResources/first_tips_hand.png")
            tipsSprite : setAnchorPoint(ccp(0,0))
            local tipsSpriteSize = tipsSprite : getPreferredSize()
            tipsSprite : setPosition(ccp(tipsSpriteSize.width/2,0-tipsSpriteSize.height/2))
            local tipsSpriteFram = CSprite : create("FirstWarResources/first_tips_fram.png")
            local ttfString = CCLabelTTF : create( "使用新技能", "Marker Felt", 21 )
            tipsSpriteFram : addChild( ttfString )
            tipsSpriteFram : setPosition( 0, 65 )
            tipsSprite : setTag(500)
            tipsSpriteFram : setTag(600)
            self.m_btnSkill[2] : addChild( tipsSprite,100 )
            self.m_btnSkill[2] : addChild( tipsSpriteFram,200 )
            
            local _pFrameEffictsCCBI = self :getEfficts_guide_by_tag( 3 )
            if _pFrameEffictsCCBI ~= nil then
                tipsSpriteFram :addChild( _pFrameEffictsCCBI, 50 )
            end
            
            local _pBtnEffictsCCBI = self :getEfficts_guide_by_tag( 2 )
            if _pBtnEffictsCCBI ~= nil then
                self.m_btnSkill[2] :addChild( _pBtnEffictsCCBI, 150 )
            end
            
            local act1 = CCMoveBy:create(0.8,ccp(30,-30))
            local _callBacks = CCArray:create()
            _callBacks:addObject(act1)
            _callBacks:addObject(act1 : reverse() )
            tipsSprite:runAction( CCRepeatForever : create( CCSequence:create(_callBacks) ) )
        end

    end

    nMark = tostring( skillData : getSkillIdByIndex( 7 ) )
    self.m_btnSkill[3] = CButton:createWithSpriteFrameName( nMark, "joyStick_common_skill.png", "", szPngName)
    self.m_btnSkill[3] : setControlName( "this CKeyBoardView self.m_btnSkill[3] 106 ")

    print("nMarknMark333", nMark)
    CKeyBoardView.BUTTON_SKILL3 = tonumber( nMark )
    self.m_btnSkill[3] :setTag( CKeyBoardView.BUTTON_SKILL3 )
    layer:addChild( self.m_btnSkill[3],8 )

    self :addSkillIconById( nMark, self.m_btnSkill[3] )

    nMark = tostring( skillData : getSkillIdByIndex( 8 ) )
    --self.m_btnSkill[4] = CButton:createWithSpriteFrameName( nMark, "joyStick_common_skill3.png")
    --self.m_btnSkill[4] : setControlName( "this CKeyBoardView self.m_btnSkill[4] 112 ")
    --self.m_btnSkill[4]:setTag(CKeyBoardView.BUTTON_SKILL4)
    --layer:addChild( self.m_btnSkill[4] )

    for i=1, #self.m_btnSkill do
        local _sprite = CCSprite:createWithSpriteFrameName("joyStick_gray.png")
        self.m_cdSkill[i] = CCProgressTimer:create(_sprite)
        self.m_cdSkill[i]:setType(kCCProgressTimerTypeRadial)
        self.m_cdSkill[i]:setReverseProgress(true)
        self.m_cdSkill[i]:setTag(0)
        layer:addChild( self.m_cdSkill[i], 1000 )
    end

    for i=1, #self.m_btnSkill do
        self.m_btnSkill[i] :setFontSize( 30)
    end

    self.m_bCould = false       --需要达到一定级别 才能显示 第五第六 技能按钮
    local nBtn = 3              --默认显示4个技能按钮
    if self.m_bCould == true then
        self.m_btnSkill[5] = CButton:createWithSpriteFrameName( tostring(nIndex), "joyStick_common_skill.png", "", szPngName)
        self.m_btnSkill[5] : setControlName( "this CKeyBoardView self.m_btnSkill[5] 124 ")
        self.m_btnSkill[5]:setTag(CKeyBoardView.BUTTON_SKILL5)
        layer:addChild( self.m_btnSkill[5] )

        self.m_btnSkill[6] = CButton:createWithSpriteFrameName( tostring(nIndex), "joyStick_common_skill.png", "", szPngName)
        self.m_btnSkill[6] : setControlName( "this CKeyBoardView self.m_btnSkill[6] 129 ")
        self.m_btnSkill[6]:setTag(CKeyBoardView.BUTTON_SKILL6)
        layer:addChild( self.m_btnSkill[6] )

        nBtn = 6
    end

    self.m_btnAttack :registerControlScriptHandler( buttonCallBack , "this CKeyBoardView self.m_btnAttack 136")
    self.m_btnJump :registerControlScriptHandler( buttonCallBack , "this CKeyBoardView self.m_btnJump 137")


    for i = 1,nBtn do
        if self.m_btnSkill[i] ~= nil then
            self.m_btnSkill[i]:setTouchesMode(kCCTouchesAllAtOnce)
            self.m_btnSkill[i]:registerControlScriptHandler( buttonCallBack , "this CKeyBoardView self.m_btnSkill[i] 142")
        end
    end

    self.m_touchedBtn = nil
    self.m_touchedID = 0
end

--判定技能按钮是否显示
function CKeyBoardView.decideDisplayByObj( self, _btn )
    if _btn ~= nil then
        local _szString = _btn :getText() or "0"
        if _szString == "0" then
            _btn :setVisible( false )
        end
    end
end

function CKeyBoardView.addSkillIconById( self, _skillId, _layer )
    self :decideDisplayByObj( _layer )

    if _skillId ~= nil and _layer ~= nil then
        local skillNode1 = _G.g_SkillDataProxy :getSkillById( tostring( _skillId ) )
        if skillNode1 ~= nil and skillNode1 :isEmpty() == false then
            local szIconSprName = "IconSkill/is101.png"
            if skillNode1 :getAttribute("icon") ~= nil then
                szIconSprName = "IconSkill/is".. skillNode1 :getAttribute("icon") ..".png"
            end

            --print("iconicon", skillNode1 :getAttribute("icon"), szIconSprName, _skillId)
            self["lpSprIcon" .. tostring( _skillId ) ] = CSprite :create( szIconSprName )
            self["lpSprIcon" .. tostring( _skillId ) ]   :setControlName( "this is CKeyBoardView lpSprIcon 210  "..tostring( _skillId ) )
            _layer :addChild( self["lpSprIcon" .. tostring( _skillId ) ], 10 )
            _layer :setText( "" )
        end

    end
end

function CKeyBoardView.btnCallback( self, eventType, obj, touches )
    if eventType == "TouchesBegan" then
        if self.m_touchedID ~= 0 or self.m_touchedBtn ~= nil then --已点击则退出
            return
        end

        for i = 1, touches:count() do
            local touch = touches:at( i - 1 )
            if obj:containsTouch(touch) then                    --其中一点击中则退出循环
                self.m_touchedID = touch:getID()
                self.m_touchedBtn = obj
                --判断是否CD中.
                local bCD = false
                for j = 1, #self.m_btnSkill do
                    if self.m_btnSkill[j]:getTag() == obj:getTag() then
                        if self.m_cdSkill[j]:getTag() == 1 then
                            bCD = true

                            break
                        end
                    end
                end
                if bCD == false then
                    --if obj :getText() ~= "0" then     --没有装备的技能 不会有点击效果
                    self :clickFadeoutImg( obj )
                    print("sdssddsfsfsf", obj :getTag())
                    self :isBlackOrColor( )
                    print("sdssddsfddddssss2222f", obj :getTag())
                    --end
                    self:fireKeyCode( obj:getTag() )
                    self : handlerTips( obj )
                end
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        self.m_touchedBtn = nil
        self.m_touchedID = 0
    end
end

function CKeyBoardView.fireKeyCode( self, nKeyCode )
    print("CKeyBoardView.fireKeyCode", nKeyCode)
    local fireKeyCode = VO_KeyBoardModel()
    fireKeyCode:setKeyCode( nKeyCode )
    local keyBoardCommand = CKeyBoardCommand(fireKeyCode)
    controller:sendCommand(keyBoardCommand)

    print("fire", nKeyCode)
end

function CKeyBoardView.container(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()


    local _layer = CContainer:create()
    _layer : setControlName( "this is CKeyBoardView _layer 178  " )
    -- _layer:registerNetworkMessageScriptHandler(networkMessageProcess)
    self :init(winSize, _layer)

    return _layer
end

--设置技能按钮样式
function CKeyBoardView.setSkill( self, nIndex, nSkillId )

end

--获得技能sp 与 所有sp得比较结果
function CKeyBoardView.getCompareSpResult( self, _Id )
    if _Id == nil then
        return
    end
    _G.Config :load( "config/skill_effect.xml" )

    local skillNode = _G.g_SkillEffectXmlManager : getByID( _Id )

    local bColor = true
    if skillNode ~= nil  and self["lpSprIcon" .. tostring( _Id ) ] ~= nil then
        local sp = skillNode.sp
        bColor = _G.g_Stage :getPlay() :canSubSp( -sp )

    end

    return bColor
end

--判断点击后是否黑白 or 彩色
function CKeyBoardView.isBlackOrColor( self )
    for i=1, 3 do
        local id = CKeyBoardView["BUTTON_SKILL" .. i ]
        local isColor = self :getCompareSpResult( id )

        print( "iscoooolor", isColor)
        --选择 !isColor
        if isColor == true then
            isColor = false
        elseif isColor == false then
            isColor = true
        end
        if self["lpSprIcon" .. tostring( id ) ] ~= nil  then
            --如果是黑白的 转为 彩色 则高亮
            -- if isColor == false and self["lpSprIcon" .. tostring( id ) ] :getGray() == true then
            --     self :addHightSpr( self.m_cdSkill[i], i)
            -- end

            self["lpSprIcon" .. tostring( id ) ] :setGray( isColor )

        end
    end
end


--设置技能CD
function CKeyBoardView.setSkillCD(self, nIndex, fCooldownInterval)
    if nIndex > 0 and nIndex < 5 then
        local function local_onCooldownCompleted( _node )
            print( "nIIII", nIndex )
            self:onCooldDownCompleted( _node, nIndex, _zzz )
        end

        print( "第几个按钮", nIndex)
        self.m_cdSkill[nIndex] :setTag( 1 )
        self.m_cdSkill[nIndex] :setPercentage( 99.9 )
        local _array = CCArray :create()
        _array :addObject( CCProgressTo :create( fCooldownInterval, 0) )
        _array :addObject( CCCallFuncN :create( local_onCooldownCompleted ) )
        self.m_cdSkill[nIndex] :runAction( CCSequence :create( _array ) )
    end
end

function CKeyBoardView.clickFadeoutImg( self, _obj )
    if _obj == nil then
        return
    end
    local nTag = _obj :getTag()
    if self["shine_"..tostring( nTag)] ~= nil then
       self["shine_"..tostring( nTag)] :removeFromParentAndCleanup( true)
       self["shine_"..tostring( nTag)] = nil
    end
    self["shine_"..tostring( nTag)] = CCSprite :createWithSpriteFrameName( "joyStick_click_shine.png")
    _obj :addChild( self["shine_"..tostring( nTag)], 10)

    local _fadeout = CCFadeOut :create( _G.Constant.CONST_SKILL_CLICK_SHINE )        --0.6
    self["shine_"..tostring( nTag)] :runAction( _fadeout )

end

function CKeyBoardView.onCooldDownCompleted( self, _node, _index )
    self :addHightSpr( _node, _index)
    _node :setTag(0)
    print("冷却完成", _node :getTag() )

end

function CKeyBoardView.addHightSpr( self, _obj, _index )
    if _obj ~= nil and _index ~= nil then
        local id = CKeyBoardView["BUTTON_SKILL" .. _index ]
        local bRun = self :getCompareSpResult( id )

        if bRun == false then
            return
        end

        local function local_onHightLightCompleted( _node )
           self :onHightLightCompleted( _node, _zzz )
        end

        local _hightSpr = CCSprite :createWithSpriteFrameName( "joyStick_cd_shine.png" )
        _hightSpr :setAnchorPoint( ccp( 0.0, 0.0 ) )
        _hightSpr :setPosition( ccp( 5.0, 2.5 ) )
        _obj :addChild( _hightSpr, 10 )

        local _array = CCArray :create()
        _array :addObject( CCFadeOut :create( _G.Constant.CONST_SKILL_CD_SHINE ) )
        _array :addObject( CCCallFuncN :create( local_onHightLightCompleted ) )
        _hightSpr :runAction( CCSequence :create( _array ) )
    end
end

function CKeyBoardView.onHightLightCompleted( self, _node )
    if _node ~= nil then
       _node :removeFromParentAndCleanup( true )
       _node = nil
    end
end

function CKeyBoardView.handlerTips( self, obj )
    if obj == self.m_btnJump then
        local tipsSprite = obj : getChildByTag( 300 )
        local tipsSpriteFram = obj : getChildByTag( 400 )

        if tipsSprite ~= nil and tipsSpriteFram ~= nil and _G.g_FirstCaoZuoZhiyinIndex == 2 then
            local function delayRemoveSpriteJump()
                if tipsSprite ~= nil then
                tipsSprite : removeFromParentAndCleanup( true )
                end
                if tipsSpriteFram ~= nil then
                    tipsSpriteFram : removeFromParentAndCleanup( true )
                end
            end
            local a1 = CCDelayTime:create(1.0)
            local drs1 = CCCallFunc:create(delayRemoveSpriteJump)
            local actarr1 = CCArray:create()
            actarr1:addObject(a1)
            actarr1:addObject(drs1)
            local seq1 = CCSequence:create(actarr1)
            obj:runAction(seq1)
            if _G.g_FirstCaoZuoZhiyinIndex == 2 then
                _G.g_FirstCaoZuoZhiyinIndex = _G.g_FirstCaoZuoZhiyinIndex + 1
            end
            self : attackTips()
        end
    elseif obj == self.m_btnSkill[1] or obj == self.m_btnSkill[2] or obj == self.m_btnAttack then
        --如果为普通攻击  第一个技能攻击  第二个技能攻击
        local tipsSprite2 = obj : getChildByTag( 500 )
        local tipsSpriteFram2 = obj : getChildByTag( 600 )

        if tipsSprite2 ~= nil and tipsSpriteFram2 ~= nil then
            local function delayRemoveSpriteAttack()
                --清理ccbi
                for i=1, 3 do
                    self :removeEffictsByTag( i )
                end
            
                local tipsSprite3 = obj : getChildByTag( 500 )
                if tipsSprite3 ~= nil then
                    tipsSprite3 : removeFromParentAndCleanup( true )
                    tipsSprite3 = nil
                end
                local tipsSpriteFram3 = obj : getChildByTag( 600 )
                if tipsSpriteFram3 ~= nil then
                    tipsSpriteFram3 : removeFromParentAndCleanup( true )
                    tipsSpriteFram3 = nil
                end
            
            end
    
            local a2 = CCDelayTime:create(1.0)
            local drs2 = CCCallFunc:create(delayRemoveSpriteAttack)
            local actarr2 = CCArray:create()
            actarr2:addObject(a2)
            actarr2:addObject(drs2)
            local seq2 = CCSequence:create(actarr2)
            obj:runAction(seq2)
        end

        -- if tipsSprite ~= nil then
        --     tipsSprite : removeFromParentAndCleanup( true )
        -- end
        -- if tipsSpriteFram ~= nil then
        --     tipsSpriteFram : removeFromParentAndCleanup( true )
        -- end
    end
end

-- 1 摇杆特效   2 按钮特效   3 底框特效
function CKeyBoardView.getEfficts_guide_by_tag( self, _tag )
    self :removeEffictsByTag( _tag )
    
    local retNode = nil
    if _tag ~= nil then
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "-- 1 摇杆特效   2 按钮特效   3 底框特效" .. _tag )
                arg0 : play("run")
            end
        end
        
        self[ "m_lpEfficts" .. _tag ] = CMovieClip:create( "CharacterMovieClip/effects_guide" .. tostring( _tag or 1 ) .. ".ccbi" )
        self[ "m_lpEfficts" .. _tag ] : setControlName( "this CCBI CKeyBoardView.getEfficts_guide_by_tag CCBI 556" .. _tag )
        self[ "m_lpEfficts" .. _tag ] : registerControlScriptHandler( animationCallFunc)
    
        return self[ "m_lpEfficts" .. _tag ]
    end
    return retNode
end

function CKeyBoardView.removeEffictsByTag( self, _tag )
    --print( "来源-->", _tag, debug.traceback() )
    if _tag ~= nil and self[ "m_lpEfficts" .. _tag ] ~= nil then
        self[ "m_lpEfficts" .. _tag ] :removeFromParentAndCleanup( true )
        self[ "m_lpEfficts" .. _tag ] = nil
    end
end

function CKeyBoardView.jumpTips( self )
    if _G.g_LoginInfoProxy : getFirstLogin() == true and _G.g_Stage : getCheckPointID() == 1 and _G.g_FirstCaoZuoZhiyinIndex == 2 then
        local tipsSprite = CSprite : create("FirstWarResources/first_tips_hand.png")
        local tipsSpriteSize = tipsSprite : getPreferredSize()
        local tipsSpriteFram = CSprite : create("FirstWarResources/first_tips_fram.png")
        local ttfString = CCLabelTTF : create( "点击进行跳跃", "Marker Felt", 21 )
        tipsSprite : setPosition(ccp(tipsSpriteSize.width/2,0-tipsSpriteSize.height/2))
        tipsSpriteFram : setPosition(ccp(-68,64))
        tipsSpriteFram : addChild(ttfString)
        tipsSprite : setTag(300)
        tipsSpriteFram : setTag(400)
        self.m_btnJump : addChild(tipsSprite,300)
        self.m_btnJump : addChild(tipsSpriteFram,400)

        --新增特效 跳跃得
        local _pBtnEffictsCCBI = self :getEfficts_guide_by_tag( 2 )
        if _pBtnEffictsCCBI ~= nil then
            self.m_btnJump :addChild( _pBtnEffictsCCBI, 350 )
        end
        
        local _pFrameEffictsCCBI = self :getEfficts_guide_by_tag( 3 )
        if _pFrameEffictsCCBI ~= nil then
            tipsSpriteFram :addChild( _pFrameEffictsCCBI, 50 )
        end
        
        local act1 = CCMoveBy:create(0.8,ccp(30,-30))
        local _callBacks = CCArray:create()
        _callBacks:addObject(act1)
        _callBacks:addObject(act1 : reverse() )
        tipsSprite:runAction( CCRepeatForever : create( CCSequence:create(_callBacks) ) )
    end
end

function CKeyBoardView.attackTips( self )
    local tipsSprite = self.m_btnAttack : getChildByTag(300)

    if tipsSprite == nil and _G.g_LoginInfoProxy : getFirstLogin() == true and _G.g_Stage : getCheckPointID() == 1 and _G.g_FirstCaoZuoZhiyinIndex == 3 then
        tipsSprite = CSprite : create("FirstWarResources/first_tips_hand.png")
        local tipsSpriteSize = tipsSprite : getPreferredSize()
        local tipsSpriteFram = CSprite : create("FirstWarResources/first_tips_fram.png")
        local ttfString = CCLabelTTF : create( "点击进行攻击", "Marker Felt", 21 )
        tipsSprite : setPosition(ccp(tipsSpriteSize.width/2,0-tipsSpriteSize.height/2))
        tipsSpriteFram : setPosition(ccp(72,64))
        tipsSpriteFram : addChild(ttfString)
        tipsSprite : setTag(500)
        tipsSpriteFram : setTag(600)
        self.m_btnAttack : addChild(tipsSprite,300)
        self.m_btnAttack : addChild(tipsSpriteFram,400)
        
        --新增特效 攻击
        local _pBtnEffictsCCBI = self :getEfficts_guide_by_tag( 2 )
        if _pBtnEffictsCCBI ~= nil then
            self.m_btnAttack :addChild( _pBtnEffictsCCBI, 350 )
        end
        
        local _pFrameEffictsCCBI = self :getEfficts_guide_by_tag( 3 )
        if _pFrameEffictsCCBI ~= nil then
            tipsSpriteFram :addChild( _pFrameEffictsCCBI, 50 )
        end
        
        local act1 = CCMoveBy:create(0.8,ccp(30,-30))
        local _callBacks = CCArray:create()
        _callBacks:addObject(act1)
        _callBacks:addObject(act1 : reverse() )
        tipsSprite:runAction( CCRepeatForever : create( CCSequence:create(_callBacks) ) )
    end
end

