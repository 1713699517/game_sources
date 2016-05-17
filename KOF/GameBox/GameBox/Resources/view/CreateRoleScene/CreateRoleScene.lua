
require "common/RequestMessage"
require "common/protocol/auto/REQ_ROLE_LOGIN"
require "common/protocol/auto/REQ_ROLE_RAND_NAME"
require "common/protocol/auto/REQ_ROLE_CREATE"
require "common/Network"

require "common/WordFilter"
-- require "proxy/LoginInfoProxy"
require "mediator/CreateRoleMediator"

--setLuaCallback
CCreateRoleScene = class(view,function(self)

end)

--TAG
CCreateRoleScene.TAG_CREATE  = 102
CCreateRoleScene.TAG_GOBACK  = 103
CCreateRoleScene.TAG_SAIZI   = 104

CCreateRoleScene.TAG_EFFECT = 159999

CCreateRoleScene.SIZE_MAIN = CCSizeMake( 854,640 )

function CCreateRoleScene.initView(self, _winSize)
    self.m_pContainer     = CContainer :create()
    self.m_pContainer     : setControlName( "this is CCreateRoleScene self.m_pContainer 125")
    self.m_scene  :addChild(self.m_pContainer)

    local function local_btnTouchCallBack( eventType,obj,x,y )
        return self:btnTouchCallBack(eventType,obj,x,y)
    end

    --背景
    self.m_pBackground = CSprite :create("loginResources/login_background_02.jpg",CCRectMake( (1136-_winSize.width)/2,0,_winSize.width,_winSize.height ))--
    self.m_pBackground : setControlName( "this CCreateRoleScene self.m_pBackground 34 ")
    self.m_pContainer  :addChild( self.m_pBackground , -100 )

    self.m_titleBg  = CSprite :createWithSpriteFrameName ("login_word_underframe.png")
    self.m_titleImg = CSprite :createWithSpriteFrameName ("login_word_cjjs.png")
    self.m_titleBg    : setControlName( "this CCreateRoleScene self.m_titleBg 43 ")
    self.m_titleImg   : setControlName( "this CCreateRoleScene self.m_titleImg  44 ")
    self.m_pContainer : addChild( self.m_titleBg , 200 )
    self.m_pContainer : addChild( self.m_titleImg , 210 )

    self.m_createPlayerBtn = CButton :createWithSpriteFrameName("创建角色","login_button_click_02.png")
    self.m_createPlayerBtn : setControlName( "this CCreateRoleScene self.m_createPlayerBtn 49 ")
    self.m_createPlayerBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CCreateRoleScene. self.m_moreServerBtn 43" )
    self.m_createPlayerBtn : setTag( CCreateRoleScene.TAG_CREATE )
    self.m_createPlayerBtn : setFontSize( 30 )
    self.m_createPlayerBtn : setPreferredSize( CCSizeMake(225,70) )
    self.m_pContainer :addChild( self.m_createPlayerBtn , 0 )

    self.m_goBackBtn = CButton :createWithSpriteFrameName("","login_return_click.png")
    self.m_goBackBtn : setControlName( "this CCreateRoleScene self.m_goBackBtn 57 ")
    self.m_goBackBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CCreateRoleScene. self.m_moreServerBtn 43" )
    self.m_goBackBtn : setTag( CCreateRoleScene.TAG_GOBACK )
    self.m_pContainer :addChild( self.m_goBackBtn , 0 )

    self.m_editBoxBg = CSprite:createWithSpriteFrameName("login_input_underframe.png",CCRectMake( 40,0,2,76 ))
    self.m_editBoxBg : setControlName( "this CCreateRoleScene self.m_editBoxBg 63 ")
    self.m_editBoxBg : setPreferredSize( CCSizeMake( 330,75 ) )
    self.m_pContainer:addChild( self.m_editBoxBg )

    local function local_editBoxCallBack( eventType, obj_ceditbox, str_string )
        return self:editBoxCallBack( eventType, obj_ceditbox, str_string )
    end

    --过滤敏感字初始化
    _G.g_WordFilter :initialize()

    local _editBg = CCScale9Sprite:createWithSpriteFrameName("transparent.png")
    self.m_editBox = CEditBox:create( CCSizeMake(230,70), _editBg, 30, "", kEditBoxInputFlagSensitive)
    self.m_editBox : registerControlScriptHandler(local_editBoxCallBack, "this CCreateRoleScene self.m_btnSaiZi 97")
    self.m_editBox : setFont( "Arial",30)
    -- self.m_editBox : setFontColor( color_white )
    self.m_pContainer:addChild( self.m_editBox )

    self.m_saiZiBtn = CButton :createWithSpriteFrameName("","login_dice.png")
    self.m_saiZiBtn : setControlName( "this CCreateRoleScene self.m_saiZiBtn 73 ")
    self.m_saiZiBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CCreateRoleScene. self.m_moreServerBtn 75" )
    self.m_saiZiBtn : setTag( CCreateRoleScene.TAG_SAIZI )
    self.m_pContainer :addChild( self.m_saiZiBtn , 0 )

    -- self.m_createPlayerBtn : setTouchesEnabled( false )
    -- self.m_saiZiBtn        : setTouchesEnabled( false )

    self:createRoleBtn()
end

--创建角色按钮
function CCreateRoleScene.createRoleBtn( self )
    function local_selectRoleCallBack( eventType,obj,x,y )
        return self:selectRoleCallBack( eventType,obj,x,y )
    end

    self.m_roleCCBIActionName = {}
    self.m_roleCCBIeffectName = {}
    self.m_roleBtnList = {}
    for i=1,6 do
        self.m_roleBtnList[i] = CButton :createWithSpriteFrameName("","login_small_player"..i..".png")
        self.m_roleBtnList[i] : setControlName( "this CCreateRoleScene self.m_roleBtnList[i] 94 ")
        self.m_roleBtnList[i] : setTag( i )
        self.m_pContainer :addChild( self.m_roleBtnList[i] , 0 )
        if i<=4 then
            self.m_roleBtnList[i] : registerControlScriptHandler( local_selectRoleCallBack, "this CCreateRoleScene. self.m_moreServerBtn 98" )
        end
        local actionNameTable = {}
        self.m_roleCCBIActionName[i] = actionNameTable
        actionNameTable[1] = tonumber("100"..tostring(i).."0")
        actionNameTable[2] = tonumber("100"..tostring(i).."1")
        actionNameTable[3] = tonumber("100"..tostring(i).."2")
        actionNameTable[4] = tonumber("100"..tostring(i).."4")
        actionNameTable[5] = tonumber("100"..tostring(i).."5")
        actionNameTable[6] = tonumber("100"..tostring(i).."6")


        local roleBg = CSprite:createWithSpriteFrameName("login_player_underframe_normal.png")
        roleBg : setControlName( "this CCreateRoleScene roleBg 102 ")
        self.m_roleBtnList[i]:addChild( roleBg,-10 )
    end

    self:setHightLineSpr(self.m_roleBtnList[1])
    self:setPro(1)
end

function CCreateRoleScene.layout(self, _winSize)

    local nX = _winSize.width/2 - 854/2

    --背景
    self.m_pBackground : setPreferredSize( _winSize )
    self.m_pBackground : setPosition( ccp(_winSize.width/2, _winSize.height/2) )
    local goBackBtnSize = self.m_goBackBtn:getPreferredSize()
    local editBoxBgSize = self.m_editBoxBg:getPreferredSize()
    local saiZiBtnSize  = self.m_saiZiBtn:getPreferredSize()
    self.m_titleBg       : setPosition( ccp(_winSize.width/2, _winSize.height*0.92) )
    self.m_titleImg      : setPosition( ccp(_winSize.width/2, _winSize.height*0.92) )
    self.m_goBackBtn     : setPosition( ccp(_winSize.width-goBackBtnSize.width/2-15, _winSize.height-goBackBtnSize.height/2-20) )
    self.m_createPlayerBtn : setPosition( ccp(665+nX, _winSize.height*0.09) )

    --编辑框
    self.m_editBoxBg     : setPosition( ccp(665+nX, 135 ) )
    self.m_editBox       : setPosition( ccp(665+nX-32, 135 ) )
    self.m_saiZiBtn      : setPosition( ccp(665+nX+editBoxBgSize.width/2-saiZiBtnSize.width/2-10, 135 ) )

    self.m_roleBtnList[1] : setPosition( ccp(455+nX, 395 ) )
    self.m_roleBtnList[2] : setPosition( ccp(575+nX, 464 ) )
    self.m_roleBtnList[3] : setPosition( ccp(575+nX, 328 ) )
    self.m_roleBtnList[4] : setPosition( ccp(692+nX, 395 ) )
    self.m_roleBtnList[5] : setPosition( ccp(692+nX, 530 ) )
    self.m_roleBtnList[6] : setPosition( ccp(692+nX, 258 ) )
end


--角色信息
function CCreateRoleScene.createProInfo( self, _pro )

    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local nX = winSize.width/2 - 854/2

    if self.m_proInfoContainer ~= nil then
        print("self.m_proInfoContainer   reomove !!!")
        self.m_proInfoContainer : removeFromParentAndCleanup( true )
        self.m_proInfoContainer = nil

        if self.m_roleActionCCBI ~= nil then
            self.m_roleActionCCBI : removeFromParentAndCleanup( true )
            self.m_roleActionCCBI = nil
        end
    end

    self.m_proInfoContainer     = CContainer :create()
    self.m_proInfoContainer     : setControlName( "this is CCreateRoleScene self.m_proInfoContainer 153")
    self.m_scene  :addChild(self.m_proInfoContainer)

    self.m_roleContainer = nil

    local pro     = "1000"..tostring( _pro )
    local proNode = self:getPreXmlNodeForPre( pro )
    if proNode == nil then
        --CCMessageBox( "player_part 找不到职业信息 职业ID="..pro,"提示" )
        CCLOG("codeError!!!! player_part 找不到职业信息 职业ID="..pro)
    end
    local nodeChild = proNode:children()
    local attack   = tonumber( nodeChild:get(0,"a"):getAttribute("attack") )
    local defense  = tonumber( nodeChild:get(0,"a"):getAttribute("defense") )
    local skill    = tonumber( nodeChild:get(0,"a"):getAttribute("skill") )
    local describe = nodeChild:get(0,"a"):getAttribute("describe")

    local name = CLanguageManager:sharedLanguageManager():getString(tostring("Role_ProName_0".._pro))

    local mainBgSize = CCSizeMake( 415,267 )
    local mainBg = CSprite  : createWithSpriteFrameName ("login_second_underframe.png")
    mainBg : setControlName( "this CCreateRoleScene mainBg 160 ")
    mainBg : setPreferredSize( mainBgSize )
    self.m_proInfoContainer : addChild( mainBg, -1, 999 )

    local nameBgSize = CCSizeMake( 212,43 )
    local nameBg = CSprite  : createWithSpriteFrameName( "login_name_underframe.png", CCRectMake( 51,0,5,43 ) )
    nameBg : setControlName( "this CCreateRoleScene nameBg 166 ")
    nameBg : setPreferredSize( nameBgSize )
    local nameLabel = CCLabelTTF:create( name,"Arial",24 )
    nameBg : addChild( nameLabel )

    local powerTitle = CSprite : createWithSpriteFrameName ("login_word_gjfycz.png")
    powerTitle : setControlName( "this CCreateRoleScene powerTitle 172 ")

    local InfoLabel = CCLabelTTF:create( describe,"Arial",18 )
    InfoLabel : setAnchorPoint( ccp( 0,1 ) )
    InfoLabel : setDimensions( CCSizeMake( 350,85 ) )
    InfoLabel : setHorizontalAlignment( kCCTextAlignmentLeft )

    local GJPowerBg = CSprite:createWithSpriteFrameName( "login_attribute_underframe.png" )
    local FYPowerBg = CSprite:createWithSpriteFrameName( "login_attribute_underframe.png" )
    local SDPowerBg = CSprite:createWithSpriteFrameName( "login_attribute_underframe.png" )
    local playBg    = CSprite:createWithSpriteFrameName( "login_player_underframe.png" )

    local GJPower = CSprite:createWithSpriteFrameName( "login_attribute_02.png" )
    local FYPower = CSprite:createWithSpriteFrameName( "login_attribute_01.png" )
    local SDPower = CSprite:createWithSpriteFrameName( "login_attribute_03.png" )

    GJPowerBg : setControlName( "this CCreateRoleScene GJPowerBg 187 ")
    FYPowerBg : setControlName( "this CCreateRoleScene FYPowerBg 188 ")
    SDPowerBg : setControlName( "this CCreateRoleScene SDPowerBg 189 ")
    GJPower   : setControlName( "this CCreateRoleScene GJPower 190 ")
    FYPower   : setControlName( "this CCreateRoleScene FYPower 191 ")
    SDPower   : setControlName( "this CCreateRoleScene SDPower 192 ")
    playBg    : setControlName( "this CCreateRoleScene playBg 230 ")

    GJPower : setPreferredSize( CCSizeMake( 56.2*attack,7 ) )
    FYPower : setPreferredSize( CCSizeMake( 56.2*defense,7 ) )
    SDPower : setPreferredSize( CCSizeMake( 56.2*skill,7 ) )


    
    
    

    local powerBgSize = GJPowerBg:getPreferredSize()
    local GJPowerSize = GJPower:getPreferredSize()
    local FYPowerSize = FYPower:getPreferredSize()
    local SDPowerSize = SDPower:getPreferredSize()

    GJPowerBg : addChild( GJPower, -10 )
    FYPowerBg : addChild( FYPower, -10 )
    SDPowerBg : addChild( SDPower, -10 )

    GJPower : setPosition( ccp( -powerBgSize.width/2+GJPowerSize.width/2+11.5,0 ) )
    FYPower : setPosition( ccp( -powerBgSize.width/2+FYPowerSize.width/2+11.5,0 ) )
    SDPower : setPosition( ccp( -powerBgSize.width/2+SDPowerSize.width/2+11.5,0 ) )
    playBg  : setPosition( ccp( 0, 0 ) )

    mainBg : addChild( nameBg, 10 )
    mainBg : addChild( powerTitle, 10, 901 )
    mainBg : addChild( InfoLabel , 10, 902 )
    mainBg : addChild( GJPowerBg , 10, 903 )
    mainBg : addChild( FYPowerBg , 10, 904 )
    mainBg : addChild( SDPowerBg , 10, 905 )
    -- mainBg : addChild( playBg, 9, 910  )

    nameBg : setPosition( ccp( -mainBgSize.width/2+nameBgSize.width/2,mainBgSize.height/2-nameBgSize.height/2 ) )
    powerTitle: setPosition( ccp( -mainBgSize.width/2+35+18,mainBgSize.height*0.13 ) )
    InfoLabel : setPosition( ccp( -mainBgSize.width/2+35,-mainBgSize.height*0.1 ) )
    GJPowerBg : setPosition( ccp( 26,mainBgSize.height*0.26 ) )
    FYPowerBg : setPosition( ccp( 26,mainBgSize.height*0.13 ) )
    SDPowerBg : setPosition( ccp( 26,0 ) )

    mainBg : setPosition( ccp( 240+nX,-158 ) )

    local function local_infoActionCallBack()
        -- self:createRoleCCBIAction()
        self:chuangeInfoType( false )
    end

    local _actionInfo = CCArray:create()
    _actionInfo:addObject(CCMoveTo:create( 0.5, ccp( 0,158*2 ) ))
    -- _actionInfo:addObject(CCCallFunc:create(local_infoActionCallBack))
    self.m_proInfoContainer : runAction( CCSequence:create(_actionInfo) )

    if self.m_bigPlayerImg ~= nil then
        self.m_bigPlayerImg : removeFromParentAndCleanup( true )
        self.m_bigPlayerImg = nil
    end

    self.m_bigPlayerImg = CSprite :create("loginResources/login_big_player".._pro..".png")
    self.m_bigPlayerImg : setControlName( "this CSelectServerScene self.m_bigPlayerImg 38 ")
    self.m_pContainer :addChild( self.m_bigPlayerImg , -50 )

    local playerSize    = self.m_bigPlayerImg:getPreferredSize()
    self.m_bigPlayerImg  : setPosition( ccp( -playerSize.width/2,playerSize.height/2 ) )

    local _actionPlayer = CCArray:create()
    _actionPlayer:addObject(CCMoveTo:create( 0.5, ccp( playerSize.width/2, playerSize.height/2 ) ))
    self.m_bigPlayerImg : runAction( CCSequence:create(_actionPlayer) )

    -- self:setInfoVisible( false )

end

function CCreateRoleScene.setInfoVisible( self, _bool )
    if self.m_proInfoContainer ~= nil then
        if self.m_proInfoContainer : getChildByTag( 999 ) ~= nil then
            local bgNode = self.m_proInfoContainer : getChildByTag( 999 )
            for i=901,905 do
                if bgNode : getChildByTag( i ) ~= nil then
                    bgNode : getChildByTag( i ) :setVisible( _bool )
                end
            end
            if bgNode : getChildByTag( 910 ) ~= nil then
                local value = true
                if _bool then
                    value = false
                end
                bgNode : getChildByTag( 910 ) :setVisible( value )
            end
        end
    end
end

function CCreateRoleScene.chuangeInfoType( self, _isInfoNow )

    -------------------------------------
    -- _isInfoNow : true   <转换到角色动作>
    -- _isInfoNow : false  <转换到角色信息>
    -------------------------------------

    local function playAction()
        --隐藏角色信息
        self:setInfoVisible(false)
        --创建人物动画
        self:createRoleCCBIAction()
    end

    local function infoAction()


        if self.m_roleActionCCBI ~= nil then
            self.m_roleActionCCBI : removeFromParentAndCleanup( true )
            self.m_roleActionCCBI = nil
        end

        if self.m_roleActionBattleCCBI ~= nil then
            self.m_roleActionBattleCCBI : removeFromParentAndCleanup( true )
            self.m_roleActionBattleCCBI = nil
        end

        if self.m_roleContainer ~= nil then
            self.m_roleContainer : removeFromParentAndCleanup( true )
            self.m_roleContainer = nil
        end

        --显示角色信息
        self:setInfoVisible(true)

        self:chuangeInfoType( true )
    end

    if _isInfoNow then
        if self.m_proInfoContainer ~= nil then
            self.m_proInfoContainer : performSelector( 4, playAction )
        end
    else
        infoAction()
    end

end

function CCreateRoleScene.createRoleCCBIAction( self )

    if self.m_roleContainer ~= nil then
        self.m_roleContainer : removeFromParentAndCleanup( true )
        self.m_roleContainer = nil
    end

    self.m_roleContainer    = CContainer :create()
    self.m_roleContainer    : setControlName( "this is CCreateRoleScene self.m_proInfoContainer 153")
    self.m_proInfoContainer : addChild(self.m_roleContainer,1)

    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local nX = winSize.width/2 - 854/2


    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
        elseif eventType == "Exit" then
            print("animationCallFunc  Exit")
        elseif eventType == "AnimationComplete" then
            print("AnimationComplete",arg0)
            if self.m_roleCCBIActionNameIndex == nil then
                self.m_roleCCBIActionNameIndex = 0
            end
            if self.m_roleCCBIActionNameIndex > 6 then
                if self.m_roleCCBIActionNameIndex == 9 then
                    self:chuangeInfoType( false )
                    return
                end

                self.m_roleCCBIActionNameIndex = self.m_roleCCBIActionNameIndex + 1
                self.m_roleActionBattleCCBI:setVisible( false )
                self.m_roleActionCCBI : setVisible( true )
                self.m_roleActionCCBI : play( "idle" )

                return
            end
            self.m_roleActionCCBI : setVisible( false )
            if self.m_roleActionBattleCCBI == nil then
                self.m_roleActionBattleCCBI = CMovieClip:create( "CharacterMovieClip/1000"..tostring(self.m_rolePro).."_battle.ccbi" )
                self.m_roleActionBattleCCBI : setControlName( "this CSelectRoleScene self.m_roleActionBattleCCBI 84")
                self.m_roleActionBattleCCBI : registerControlScriptHandler( animationCallFunc )
                self.m_roleActionBattleCCBI : setPosition( 240+nX, -265 )
                self.m_roleContainer : addChild( self.m_roleActionBattleCCBI, 10 )
            end
            self.m_roleActionBattleCCBI : setVisible( true )
            if self.m_roleCCBIActionNameIndex >= 3 then
                if arg0 == "idle" then
                    if self.m_isRunDongHua == true then
                        return
                    end
                    self.m_isRunDongHua = true
                    local function onAnimtionComplete(  )
                        self : runDonghua()
                    end
                    local _actionInfo = CCArray:create()
                    _actionInfo:addObject(CCDelayTime:create(2))
                    _actionInfo:addObject(CCCallFunc:create(onAnimtionComplete))
                    self.m_roleActionBattleCCBI : runAction( CCSequence:create(_actionInfo) )
                else
                    self.m_roleActionBattleCCBI:setVisible( false )
                    self.m_roleActionCCBI : setVisible( true )
                    self.m_roleActionCCBI : play( "idle" )
                end

            else
                self : runDonghua()
            end
        end
    end

    self.m_isRunDongHua = false
    self.m_roleActionCCBI = CMovieClip:create( "CharacterMovieClip/1000"..tostring(self.m_rolePro).."_normal.ccbi" )
    self.m_roleActionCCBI : setControlName( "this CSelectRoleScene self.m_roleActionCCBI 84")
    self.m_roleActionCCBI : registerControlScriptHandler( animationCallFunc)
    self.m_roleActionCCBI : setPosition( 240+nX, -265 )
    self.m_roleContainer : addChild( self.m_roleActionCCBI, 10 )
    self.m_roleCCBIActionNameIndex = 0
    self.m_roleActionCCBI : play( "idle" )
end

--选择角色 高亮
function CCreateRoleScene.setHightLineSpr( self, _obj )
    if self.m_hightLineSpr ~= nil then
        print("self.m_hightLineSpr   reomove !!!")
        self.m_hightLineSpr : removeFromParentAndCleanup( true )
        self.m_hightLineSpr = nil
    end
    self.m_hightLineSpr = CSprite:createWithSpriteFrameName( "login_player_underframe_click.png" )
    self.m_hightLineSpr : setControlName( "this CCreateRoleScene self.m_hightLineSpr 236 ")
    _obj:addChild( self.m_hightLineSpr,2 )
end

function CCreateRoleScene.removeCCBI( self )
    if self.m_roleActionCCBI ~= nil then
        self.m_roleActionCCBI : removeFromParentAndCleanup( true )
         self.m_roleActionCCBI = nil
    end
    if self.m_roleActionBattleCCBI ~= nil then
        self.m_roleActionBattleCCBI : removeFromParentAndCleanup( true )
        self.m_roleActionBattleCCBI = nil
    end
end

function CCreateRoleScene.setPro( self, _pro )

    self:removeCCBI()

    self:createProInfo( _pro )
    self.m_rolePro = _pro

    --不是用户输入的则请求随机名
    if self.m_isUserWrite == false then
        local sex = self:getSex( self.m_rolePro )
        self:randomName( sex )
    end
end

function CCreateRoleScene.getSex( self, _pro )
    local pro = tonumber( _pro )
    if pro == _G.Constant.CONST_PRO_ICEGIRL or pro == _G.Constant.CONST_PRO_BIGSISTER or pro == _G.Constant.CONST_PRO_LOLI then
        return _G.Constant.CONST_SEX_MM
    else
        return _G.Constant.CONST_SEX_GG
    end
end

function CCreateRoleScene.setSelectedUid( self, _uid )
    _G.g_LoginInfoProxy:setUid(_uid)
end

function CCreateRoleScene.loadResources(self)
    print( "nnnnnnnnnnnnnnnn x CCreateRoleScene.loadResources")

end

function CCreateRoleScene.initParameter(self)

    self.m_isUserWrite    = false
    self.m_preEditBoxWord = ""
    self.m_isInit         = false

    self.m_rolePro  = nil
    self.m_firstUid = _G.g_LoginInfoProxy:getUid()

    self.Mediator = CCreateRoleMediator( self )
    controller :registerMediator(self.Mediator)
    self:askNewRole()

    _G.pSelectRoleView :unRegistMediator()

    self:loadXml()
end

function CCreateRoleScene.init(self, _winSize)
    self:loadResources()
    self:initParameter()
    self:initView(_winSize)
    self:layout(_winSize)
end

function CCreateRoleScene.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.m_scene = CCScene:create()
    self  :init(winSize)
    return self.m_scene
end

function CCreateRoleScene.loadXml( self )
    _G.Config:load("config/player_part.xml")
end

function CCreateRoleScene.getPreXmlNodeForPre( self, _pre )

    return _G.Config.player_parts :selectSingleNode( "player_part[@type="..tostring(_pre).."]" )

end

--请求随机名返回
function CCreateRoleScene.setEditBoxString( self, _name )
    self.m_editBox :setTextString(_name)
    self.m_preEditBoxWord = _name
    self.m_isUserWrite    = false
end

function CCreateRoleScene.editBoxCallBack( self, eventType, obj_ceditbox, str_string )
    if eventType == "EditBoxReturn" then
        local roleName = string.match(str_string,"%s*(.-)%s*$")
        print( "roleName", roleName, _G.g_WordFilter :hasBanWord( roleName ) )
        if _G.g_WordFilter :hasBanWord( roleName ) == true then
            self.m_editBox :setTextString( self.m_preEditBoxWord )

            require "view/ErrorBox/ErrorBox"
            local errorBox = CErrorBox()
            local BoxLayer = errorBox : create("内容包含敏感字符，请重新输入")
            self.m_scene :addChild( BoxLayer, 10000 )
            return
        end

        if roleName == self.m_preEditBoxWord then
            self.m_isUserWrite = false
        else
            self.m_isUserWrite = true
        end

        self.m_editBox :setTextString( roleName )
    end
end


function CCreateRoleScene.btnTouchCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            if self.m_isInit == false then
                return
            end
            local tag = obj:getTag()
            if tag == CCreateRoleScene.TAG_CREATE then
                CCLOG("CCreateRoleScene----CREATE")
                _G.pSelectServerView:createJuHua()
                CNetwork :setReconnect(true)

                --第一次进入游戏
                _G.g_LoginInfoProxy :setFirstLogin( true )

                return self:startGameCallBack( )
            elseif tag == CCreateRoleScene.TAG_SAIZI then
                CCLOG("CCreateRoleScene----RAND-NAME")
                _G.pSelectServerView:createJuHua()
                local sex = self:getSex( self.m_rolePro )
                return self:randomName( sex )
            elseif tag == CCreateRoleScene.TAG_GOBACK then
                CCLOG("CCreateRoleScene----GOBACK")
                _G.pCreateRoleScene = nil
                self:removeCCBI()
                self:setSelectedUid( self.m_firstUid )
                -- self.m_proInfoContainer : removeFromParentAndCleanup( true )
                -- self.m_proInfoContainer = nil
                if self.Mediator ~= nil then
                    controller :unregisterMediator(self.Mediator)
                    self.Mediator = nil
                    self = nil
                end

                _G.pSelectRoleView :registMediator()

                CNetwork :setReconnect(true)
                _G.g_WordFilter :destory()
                CCDirector:sharedDirector():popScene()
            end
        end
    end
end


function CCreateRoleScene.selectRoleCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()

            if tag == self.m_rolePro then
                return
            end

            self:setHightLineSpr(obj)
            self:setPro(tag)
        end
    end
end

function CCreateRoleScene.startGameCallBack( self )

    local roleName = self.m_editBox :getTextString()
    local charNum  = self:getCharCountByUTF8(roleName)
    if charNum < 3 or #roleName < 6 then
        --字符个数小于3或者大于12 字节长度大于15或小于6都不符合长度需求
        self:showErrorBox("角色名称太短")
        _G.pSelectServerView:removeJuHua()
    elseif #roleName >18 or charNum >12 then
        --字符个数大于12或字节长度大于15都不符合长度需求
        self:showErrorBox("角色名称太长")
        _G.pSelectServerView:removeJuHua()
    elseif #roleName%charNum == 0 and #roleName/charNum == 3 and charNum >6 then
        --输入的是同种类型字符 , 中文 且字符数大于6
        self:showErrorBox("角色名称太长")
        _G.pSelectServerView:removeJuHua()

    --[[elseif charNum > 8 and #roleName < 18
        --输入的不是同种字符
     ]]
    else
        self :onStartGameCallBack(self)
    end

end

function CCreateRoleScene.showErrorBox( self, _msg )
    local msg = _msg
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(msg)
    self.m_scene : addChild( BoxLayer )
end

function CCreateRoleScene.randomName( self, sex )
    print("sex="..sex)
    local msg = REQ_ROLE_RAND_NAME()
    msg :setSex( tonumber(sex) )
    CNetwork :send(msg)
end


--获取string的字符个数
function CCreateRoleScene.getCharCountByUTF8( self, str )
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end

function CCreateRoleScene.onStartGameCallBack(self)
    print( "nnnnnnnnnnnnnnnn 4 CCreateRoleScene.onStartGameCallBack")
    CCLOG("开始游戏")

    print("CCreateRoleScene.onStartGameCallBack",self.m_tableNewRoleResult[0]["login_time"],self.m_editBox :getTextString(),self.m_tableNewRoleResult[0]["uid"])
    local msg = REQ_ROLE_CREATE()
    msg:setUid(self.m_tableNewRoleResult[0]["uid"])
    msg:setCid(tonumber(_G.LoginConstant.CID))
    msg:setSid(tonumber(_G.g_LoginInfoProxy:getServerId()))
    msg:setUuid(_G.LoginInfo.uuid)
    msg:setLoginTime(self.m_tableNewRoleResult[0]["login_time"])
    msg:setSex( 1 ) --self:getSex(self.m_rolePro)
    msg:setUname(self.m_editBox :getTextString())
    msg:setPro(self.m_rolePro)
    msg:setSource(1)
    msg:setExt2(1)
    msg:setExt1(1)
    msg:setSource("temp")
    msg:setSourceSub("temp")
    msg:setVersions(1.34)
    msg:setOs("ios")
    CNetwork :send(msg)

    _G.g_LoginInfoProxy:setUid( self.m_tableNewRoleResult[0]["uid"] )

    CRechargeScene:setRechargeData("username", tostring( CUserCache:sharedUserCache():getObject("userName")))
    CRechargeScene:setRechargeData("roleid", tostring(self.m_tableNewRoleResult[0]["uid"]))
    CRechargeScene:setRechargeData("serverid", tostring(_G.g_LoginInfoProxy:getServerId()))
end

--请求新建角色
function CCreateRoleScene.askNewRole(self)
    print( "nnnnnnnnnnnnnnnn 4 CCreateRoleScene.askNewRole")
    local function local_role_return(response)
        print( "nnnnnnnnnnnnnnnn 5 response")
        return self:newRoleReturn(response)
    end
    local _request = CCHttpRequest()

    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping
    local fcm = "0";  -- by:yiping
    local fcmId = "";  -- by:yiping

    local strTemp  = "cid="..tostring(_G.LoginConstant.CID).."&sid="..tostring(_G.g_LoginInfoProxy:getServerId()).."&uuid="..tostring(_G.LoginInfo.uuid).."&fcm="..fcm.."&fcm_id="..fcmId.."&session="..sessionId.."&time="..tostring(timeLong)
    local strTemp2 = strTemp.."&key="..tostring(_G.LoginConstant.KEY)
    local lpcszMd5 = CMD5Crypto :md5(strTemp2, string.len(strTemp2))

    print("««««««««««««««  "..strTemp)

    local str = _G.netWorkUrl.."/api/Phone/RoleCreate?"..strTemp.."&sign="..tostring(lpcszMd5)
    print(str)
    _request :setUrl(str)
    _request :setRequestType(1)
    _request :setLuaCallback(local_role_return)
    --CCHttpClient:getInstance():setTimeoutForConnect(3.0)
    --CCHttpClient:getInstance():setTimeoutForRead(3.0)
    _request :setTag("GET test3")
    CCHttpClient :getInstance() :send(_request)
end


function CCreateRoleScene.newRoleReturn(self,response)
    print( "nnnnnnnnnnnnnnnn 5 CCreateRoleScene.newRoleReturn")
    print("CCreateRoleScene.RoleReturn",response :getResponseText())

    print("self.m_tableNewRoleResult",self)
    local strResult  = response :getResponseText()


    self.m_tableNewRoleResult = parseJSonObjects(strResult)
    self.m_isInit             = true

    --不是用户输入的则请求随机名
    if self.m_isUserWrite == false then
        local sex = self:getSex( self.m_rolePro )
        self:randomName( sex )
    end

    --[[
    if(m_tableNewRoleResult[1]["ref"] ==0)then
        CCLOG("创建角色验证失败")
        return
    end
]]
    print("------newRoleReturn-------")
    for k, v in pairs(self.m_tableNewRoleResult) do
        print(k,v["uid"])
        -- for i, j in pairs(v) do
        --     print(i,"uid---"..j["uid"])
        -- end
    end
    print("------newRoleReturn-------")
    --[[
    local SocketConnectSeverCommand = CSocketConnectSeverCommand(nil)
    controller: sendCommand(SocketConnectSeverCommand)
     ]]

    -- local msg = REQ_ROLE_LOGIN()
    -- print("m_tableNewRoleResult[0]",self.m_tableNewRoleResult[0]["uid"],self.m_tableNewRoleResult[0]["pwd"],self.m_tableNewRoleResult[0]["login_time"])

    -- self :setSelectedUid(self.m_tableNewRoleResult[0]["uid"])
    -- msg: setUid(self.m_tableNewRoleResult[0]["uid"])
    -- msg: setUuid(_G.LoginInfo.uuid)
    -- msg: setSid(_G.g_LoginInfoProxy:getServerId())
    -- msg: setCid(217)
    -- msg: setOs("ios")
    -- msg: setPwd(tostring(self.m_tableNewRoleResult[0]["pwd"]))
    -- msg: setVersions(1.34)
    -- msg: setFmc(0)
    -- msg: setRelink(false)
    -- msg: setDebug(false)
    -- msg: setLoginTime(self.m_tableNewRoleResult[0]["login_time"])
    -- CNetwork :send(msg)
    -- CRechargeScene:setRechargeData("username", tostring( CUserCache:sharedUserCache():getObject("userName")))
    -- CRechargeScene:setRechargeData("roleid", tostring(self.m_tableNewRoleResult[0]["uid"]))
    -- CRechargeScene:setRechargeData("serverid", tostring(_G.g_LoginInfoProxy:getServerId()))

    -- self.m_createPlayerBtn : setTouchesEnabled( true )
    -- self.m_saiZiBtn        : setTouchesEnabled( true )

end


function CCreateRoleScene.runDonghua( self )
    if self.m_roleActionBattleCCBI == nil then
        return
    end
    if self.m_roleCCBIActionName[self.m_rolePro] == nil  then
    self.m_roleCCBIActionNameIndex = self.m_roleCCBIActionNameIndex + 1
        return
    end
    if self.m_roleCCBIActionName[self.m_rolePro][self.m_roleCCBIActionNameIndex+1] == nil  then
    self.m_roleCCBIActionNameIndex = self.m_roleCCBIActionNameIndex + 1
        return
    end
    self.m_roleCCBIActionNameIndex = self.m_roleCCBIActionNameIndex + 1
    local currentIndex = self.m_roleCCBIActionNameIndex
    local currentActionName = self.m_roleCCBIActionName[self.m_rolePro][currentIndex]
    print("runDonghua",currentActionName,currentIndex)
    self.m_roleActionBattleCCBI : play("skill_"..currentActionName)



    local continer = CContainer : create()
    continer : setTag( self.TAG_EFFECT )
    self.m_roleActionBattleCCBI : addChild( continer )

    _G.Config : load("config/skill_effect.xml")
    local skillNode = _G.Config.skill_effect : selectSingleNode("skill[@id="..currentActionName.. "]")
    if skillNode : isEmpty() then
        return
    end
    local child = skillNode : children()
    local frameCount = child : getCount("frame")
    for i=0, frameCount -1 do
        local frameNode = child : get(i,"frame")
        if frameNode : isEmpty() == false then
            local frameChild = frameNode : children()
            local effectCount = frameChild : getCount("effect")
            local vitroCount = frameChild : getCount("addvitro")
            for k=0, effectCount - 1 do
                local effectNode = frameChild : get(k,"effect")
                if effectNode :isEmpty() == false then
                    local function addEffectCallback(  )
                        local effectCCBI = CMovieClip : create("CharacterMovieClip/"..effectNode:getAttribute("fileName").."_battle.ccbi")
                        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
                            if eventType == "AnimationComplete" then
                                effectCCBI : removeFromParentAndCleanup( true )
                            end
                        end
                        print("skill_"..effectNode:getAttribute("fileName"))
                        continer : addChild( effectCCBI )
                        effectCCBI : setPosition(tonumber(effectNode:getAttribute("posX")),tonumber(effectNode:getAttribute("posY")))
                        effectCCBI : registerControlScriptHandler(animationCallFunc)
                        effectCCBI : play( "skill_"..effectNode:getAttribute("fileName") )


                    end
                    local time = tonumber(frameNode:getAttribute("time"))
                    local _actionInfo = CCArray:create()
                    _actionInfo:addObject(CCDelayTime:create(time))
                    _actionInfo:addObject(CCCallFunc:create(addEffectCallback))
                    continer : runAction( CCSequence:create(_actionInfo) )
                end
            end
            for v=0, vitroCount -1 do
                local vitroNode = frameChild : get(v,"vitro")
                if vitroNode :isEmpty() == false then
                    local function addvitroCallback(  )
                        local vitroCCBI = CMovieClip : create("CharacterMovieClip/"..vitroNode:getAttribute("id").."_battle.ccbi")
                        local function delself(  )
                            vitroCCBI : removeFromParentAndCleanup( true )
                        end
                        continer : addChild( vitroCCBI )
                        vitroCCBI : setPosition(tonumber(vitroNode:getAttribute("startX")),tonumber(vitroNode:getAttribute("startY"))+tonumber(vitroNode:getAttribute("startZ")))
                        vitroCCBI : play( "skill_"..vitroNode:getAttribute("id") )

                        local useTime = tonumber(vitroNode:getAttribute("useTime"))/1000
                        local pos = ccp(tonumber(vitroNode:getAttribute("endX")),tonumber(vitroNode:getAttribute("endY"))+tonumber(vitroNode:getAttribute("endZ")))

                        local _action = CCArray:create()
                        _action:addObject(CCMoveTo:create(useTime,pos))
                        _action:addObject(CCCallFunc:create(delself))
                        vitroCCBI : runAction( CCSequence:create(_action) )
                    end
                    local _actionInfo = CCArray:create()
                    _actionInfo:addObject(CCDelayTime:create(tonumber(frameNode:getAttribute("time"))))
                    _actionInfo:addObject(CCCallFunc:create(addvitroCallback))
                    continer : runAction( CCSequence:create(_actionInfo) )
                end
            end
        end
    end

    self.m_isRunDongHua = false
end
                    -- local _actionInfo = CCArray:create()
                    -- _actionInfo:addObject(CCDelayTime:create(2))
                    -- _actionInfo:addObject(CCCallFunc:create(onAnimtionComplete))
                    -- self.m_roleActionBattleCCBI : runAction( CCSequence:create(_actionInfo) )
