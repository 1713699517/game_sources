--待上传svn  VipLayer  vip显示
require "view/view"
require "view/LuckyLayer/PopBox"


--临时按钮 及 GM界面开关  ==1时,内网才打开
_G.g_bGMSwitch = LUA_NETWORK()
--_G.g_bGMSwitch = 1
--]]


CVipView = class( view, function( self)
    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
end)


function CVipView.scene(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CContainer :create()
    scene : setControlName( "this is CVipView scene 208  " )

    self.m_layer = CCLayer :create()
    self :init(winSize, self.m_layer)

    scene :addChild(self.m_layer)
    return scene
end


function CVipView.loadResource(self)
    --[[
    if _G.Config.energy_buys == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/energy_buy.xml")
    end
    if _G.Config.vips == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/vip.xml")
    end
    --]]
    _G.Config : load( "config/energy_buy.xml" )
    _G.Config : load( "config/vip.xml" )

    self.m_szIconFrame = "menu_icon_frame.png"          --底框
    self.m_szSprLine   = "general_dividing_line.png"    --淫荡的分割线
end

function CVipView.onLoadedResource(self)

end

function CVipView.realeaseParams( self )
    -- body
end

--{请求购买体力}
function CVipView.requestBuyEnergy( self)
    require "common/protocol/auto/REQ_ROLE_ASK_BUY_ENERGY"
    local msg = REQ_ROLE_ASK_BUY_ENERGY()
    CNetwork :send( msg)
    print("请求购买体力[1265]", msg)
end

--适配布局
function CVipView.layout(self, winSize)
    --640
    if winSize.height == 640 then

    elseif winSize.height == 768 then
        CCLOG("768--资源")
    end
end


--判断_retNum是否大于 _toNum
function CVipView.getMoneyNum(self, _retNum, _toNum)
    if _retNum==nil or _toNum==nil then
        return
    end
    if  _retNum >= _toNum then
        _retNum = math.modf( _retNum/_toNum ) .. "万"
    end
    return _retNum
end

function CVipView.addMediator( self )
    self :removeMediator()

    require "mediator/VipMediator"
    _G.pVipMediator = CVipMediator( self )
    controller :registerMediator( _G.pVipMediator )

end

function CVipView.removeMediator( self)
    if _G.pVipMediator then
        controller :unregisterMediator( _G.pVipMediator)
        _G.pVipMediator = nil
    end
end

--初始化
function CVipView.init(self, winSize, layer)

    --self :addMediator()
    --加载资源
    CVipView.loadResource(self)
    --------ui更新
    self :initParams()
    self :addNewUI( layer)
    -------------

    --布局
    self.layout(self, winSize)
end

function CVipView.addStrengthLine( self, _num )
    if self.m_lpLine ~= nil then
        self.m_lpLine :removeFromParentAndCleanup( true)
        self.m_lpLine = nil
    end

    if _num <= 0 then
        return
    elseif _num >= 1 then
        _num = 1
    end

    --体力条
    self.m_lpLine       = CSprite :createWithSpriteFrameName("menu_line.png")       --154 10
    self.m_pContainer   :addChild( self.m_lpLine )

    self.m_lpLineSize   = self.m_lpLine :getPreferredSize()
    self.m_lpLineSize   = CCSizeMake( 154 * _num, self.m_lpLineSize.height )
    self.m_lpLine       :setPreferredSize( self.m_lpLineSize )

    self.m_lpLine       :setPosition( ccp( 116 + self.m_lpLineSize.width / 2, self.m_winSize.height - 52 - self.m_lpLineSize.height / 2 ) )
end

function CVipView.addNewUI( self, layer)
    self.m_pContainer = CContainer :create()
    layer :addChild( self.m_pContainer)

    --左上背景框
    self.m_roleBg       = CSprite :createWithSpriteFrameName("menu_role_frame02.png")
    self.m_roleFrame    = CSprite :createWithSpriteFrameName("menu_role_frame01.png")
    self.m_dollerSpr    = CSprite :createWithSpriteFrameName("menu_icon_dollar.png")
    self.m_diamondSpr   = CSprite :createWithSpriteFrameName("menu_icon_diamond.png")

    self.m_roleBg       : setControlName( "this CVipView self.m_roleBg 139 ")
    self.m_roleFrame    : setControlName( "this CVipView self.m_roleFrame 111 ")
    self.m_dollerSpr    : setControlName( "this CVipView self.m_dollerSpr 140 ")
    self.m_diamondSpr   : setControlName( "this CVipView self.m_diamondSpr 141 ")

    local function plusCallback( eventType, obj, x, y )
        return self :onPlusCallback( eventType, obj, x, y)
    end


    local function roleCallback( eventType, obj, x, y)
        return self :onRoleCallback( eventType, obj, x, y)
    end

    local nJob = self.m_pro
    if nJob == nil or nJob > 4 or nJob < 1 then
        nJob = 1
    end
    print("nJobnJob", nJob, self.m_nMaxStr, self.m_nCurStr)
    local szRoleSpr = "menu_role_0"..nJob..".png"
    self.m_btnHead     = CButton :createWithSpriteFrameName("", tostring( szRoleSpr ))
    self.m_btnHead     : setControlName( "this CVipView self.m_diamondSpr 142 ")
    self.m_btnHead     : setTag( 20)
    self.m_btnHead     : registerControlScriptHandler( plusCallback, "this CVipView self.m_btnHead 157")
    
    local szTipSpr = "Loading/transparent.png"
    self.m_btnTips     = CButton :create("", tostring( szTipSpr ))
    self.m_btnTipsSize = CCSizeMake( 255, 64 )
    self.m_btnTips     : setPreferredSize( self.m_btnTipsSize )
    self.m_btnTips     : setControlName( "this CVipView self.m_btnTips 172 ")
    self.m_btnTips     : setTag( 20)
    self.m_btnTips     : registerControlScriptHandler( plusCallback, "this CVipView self.m_btnTips 177")

    --充值按钮
    self.m_lpChargeBtn = CButton :createWithSpriteFrameName( "", "menu_cz.png" )
    self.m_lpChargeBtn :setControlName( "this CVipView self.m_lpChargeBtn 158 ")
    self.TAG_CHARGE    = 5000
    self.m_lpChargeBtn :setTag( self.TAG_CHARGE )
    self.m_lpChargeBtn :registerControlScriptHandler( plusCallback, "this CVipView self.m_lpChargeBtn 161")

    
        

    local szFontName = "Arial"
    local nFontSize  = 14

    --self.m_pRoleName    = CCLabelTTF :create( tostring(self.m_szName) or 0, szFontName, nFontSize + 6 )
    local szLv = "LV:"--..self.m_nRoleLv

    self.m_pRoleLv      = CCLabelTTF :create( tostring(szLv) or 0, szFontName, nFontSize+2)
    self.m_pRoleLv      :setColor( ccc3(0, 255, 255))
    self.m_pRoleDoller  = CCLabelTTF :create( tostring(self.m_nDoller) or 0, szFontName, nFontSize + 4)
    self.m_pRoleDiamond = CCLabelTTF :create( tostring(self.m_nDiamond) or 0, szFontName, nFontSize+ 4)

    local szStrength = ( self.m_nCurStr or 0 ).."/"..( self.m_nMaxStr or 0)
    self.m_pRoleStrength  = CCLabelTTF :create( tostring(szStrength) or 0, szFontName, nFontSize-2)

    self.m_pContainer :addChild( self.m_roleBg)

    local _num = self.m_nCurStr / self.m_nMaxStr
    self :addStrengthLine( _num )                         --添加体力条
    self.m_pContainer :addChild( self.m_btnHead)
    self.m_pContainer :addChild( self.m_roleFrame, 10)
    self.m_pContainer :addChild( self.m_dollerSpr)
    self.m_pContainer :addChild( self.m_diamondSpr)
    --self.m_pContainer :addChild( self.m_btnPlus)
    --self.m_pContainer :addChild( self.m_btnStrength)

    self.m_pContainer :addChild( self.m_lpChargeBtn, 10)
    --self.m_pContainer :addChild( self.m_pRoleName)
    self.m_pContainer :addChild( self.m_pRoleLv)
    self.m_pContainer :addChild( self.m_pRoleDoller)
    self.m_pContainer :addChild( self.m_pRoleDiamond)
    self.m_pContainer :addChild( self.m_pRoleStrength, 20)
    self.m_pContainer :addChild( self.m_btnTips, 20)

    ---------------------------------------------------------------------------
    local scale = 1.0
    --self.m_roleBg   :setScale( scale)
    --self.m_btnPlus  :setScale( 0.4)
    --self.m_btnHead  :setScale( scale)

    local lSize = self.m_roleBg :getPreferredSize()
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local moneySize = self.m_diamondSpr :getPreferredSize()
    local headSize  = self.m_btnHead :getPreferredSize()
    local sprSize = CCSizeMake( lSize.width * scale, lSize.height * scale)

    print("size11", sprSize.height, sprSize.width)
    local sprHY = sprSize.height / 2

    --
    ------
    local nXXXX = 0
    self.m_roleBg           :setPosition( sprSize.width / 2 + nXXXX, winSize.height - sprHY - nXXXX )

    local nMicX = 12
    self.m_roleFrame        :setPosition( sprSize.width / 2 + nXXXX+ nMicX, winSize.height - sprHY - nXXXX- nMicX)

    self.m_dollerSprSize    = self.m_dollerSpr :getPreferredSize()
    self.m_dollerSpr        :setPosition( 123 + self.m_dollerSprSize.width /2 , winSize.height - 31 - self.m_dollerSprSize.height / 2)

    self.m_diamondSprSize   = self.m_diamondSpr :getPreferredSize()
    self.m_diamondSpr       :setPosition( 236 + self.m_diamondSprSize.width / 2, winSize.height - 31 - self.m_diamondSprSize.height / 2)

    -------  -------  -------

    -------  -------  -------
    self.m_lpChargeBtnSize = self.m_lpChargeBtn :getPreferredSize()
    self.m_lpChargeBtn      :setPosition( 130 + self.m_lpChargeBtnSize.width / 2 , winSize.height - 70 - self.m_lpChargeBtnSize.height /2 )
    -------  -------  -------

    -------  -------  -------
    self.m_btnHead          :setPosition( headSize.width * 0.5, winSize.height - headSize.height * 0.5 )
    --self.m_pRoleName       :setPosition( sprSize.width * 0.5032, winSize.height - sprSize.height * 0.12)
    self.m_pRoleDoller      :setPosition( 185, winSize.height - 41)
    self.m_pRoleDiamond     :setPosition( 300, winSize.height - 41)
    self.m_pRoleStrength    :setPosition( 185, winSize.height - 58)
    self.m_pRoleLv          :setPosition( 51, winSize.height - 102)
    self.m_btnTips          :setPosition( 106 + self.m_btnTipsSize.width / 2, winSize.height - self.m_btnTipsSize.height / 2)

    self :parseNumber( tonumber( self.m_nRoleLv) )

    --总战斗力
    self.m_pContainer : addChild( self :getFightlayer( self.m_nPowerful ), 100 )

    self :addTestBtn( winSize )
    
    --经验条
    self :addExperienceLine()
end

function CVipView.setExpLine( self )
    self :initParams()
    local _szExp    = tostring( self.m_nExp or "" ) .. "/" .. tostring( self.m_nExpn or "" )
    self.m_lpExpLabel :setString( _szExp )
    
    local _nPercent = self.m_nExp / self.m_nExpn
    if _nPercent ~= nil and _nPercent <= 0 or _nPercent > 1.0 then
        _nPercent = 1.0
        self.m_lpExpProgressSpr :setVisible( false )
        
    else
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end
        --ccbi 特效
        if self.m_lploadingCCBI ~= nil then
            self.m_lploadingCCBI :removeFromParentAndCleanup( true )
            self.m_lploadingCCBI = nil
        end
        --
        self.m_lploadingCCBI = CMovieClip :create("CharacterMovieClip/effects_exp.ccbi")
        self.m_lploadingCCBI :setControlName( "this CCBI CVipView.addExperienceLine CCBI")
        self.m_lploadingCCBI :registerControlScriptHandler( animationCallFunc)
        --]]
         
        self.m_lpExpProgressSpr :setVisible( true )
        local _lSize = CCSizeMake( self.m_nBestSize.width * _nPercent, self.m_nBestSize.height )
        self.m_lpExpProgressSpr   :setPreferredSize( _lSize )
        self.m_lpExpProgressSpr :setPosition( ccp( -self.m_lpBackgroundFrameSize.width / 2 + 12 + _lSize.width / 2, 0 ) )
        self.m_lpExpProgressSpr :addChild( self.m_lploadingCCBI )
        self.m_lploadingCCBI :setPosition( ccp( _lSize.width / 2, 0 ))
    end
    
end

--根据百分比显示经验条
function CVipView.addExperienceLine( self )
    if self.m_lpExpContainer ~= nil then
        self.m_lpExpContainer :removeFromParentAndCleanup( true )
        self.m_lpExpContainer = nil
    end
    
    self.m_lpExpContainer = CContainer :create()
    self.m_pContainer :addChild( self.m_lpExpContainer )
    
    local _winSize = CCDirector :sharedDirector() :getVisibleSize()
   
    self.m_lpBackgroundFrame  = CSprite :create("update/exp_frame.png")
    self.m_lpBackgroundFrameSize = self.m_lpBackgroundFrame :getPreferredSize()
    self.m_lpBackgroundFrame  :setPosition( ccp( _winSize.width / 2, self.m_lpBackgroundFrameSize.height / 2 + 1 ) )
    
    self.m_lpExpProgressSpr   = CSprite :create("update/exp_line.png")     -- 900 12
    local _lineSize = self.m_lpExpProgressSpr :getPreferredSize()
    self.m_nBestSize = CCSizeMake( self.m_lpBackgroundFrameSize.width - 24, _lineSize.height) --最大的size

    local _szExp    = tostring( self.m_nExp or "" ) .. "/" .. tostring( self.m_nExpn or "" )
    self.m_lpExpLabel = CCLabelTTF :create( _szExp, "Arial", 16 )
    --self.m_lpExpLabel :setPosition( ccp( self.m_lpBackgroundFrameSize.width / 2, 9 ) )
    
    self.m_lpBackgroundFrame :addChild( self.m_lpExpProgressSpr, 9)
    self.m_lpBackgroundFrame :addChild( self.m_lpExpLabel, 10 )
    
    self.m_lpExpContainer :addChild( self.m_lpBackgroundFrame )
    
    self :setExpLine()
end

function CVipView.getFightlayer( self, _nPowerful )
    if self.m_pFightSpr ~= nil then
        self.m_pFightSpr :removeFromParentAndCleanup( true )
        self.m_pFightSpr = nil
    end

    local _winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_pFightSpr = CSprite :createWithSpriteFrameName( "menu_word_zzdl.png" )
    self.m_pFightSprSize = self.m_pFightSpr :getPreferredSize()
    self.m_pFightSpr : setPosition( ccp( 143.0 + self.m_pFightSprSize.width / 2, _winSize.height - 6 - self.m_pFightSprSize.height / 2) )

    print( "_nPowerful_nPowerful", _nPowerful)
    if _nPowerful == nil then
        _nPowerful = "0"
    end
    local strPowerful = tostring( _nPowerful )
    for i=1, string.len( strPowerful ) do
        local currNum = string.sub( strPowerful, i, i )
        print("当前数字 图片", currNum)
        local currSprName = "battle_hurt_0" .. ( currNum or "1" ) .. ".png"
        local currSprite = CSprite :createWithSpriteFrameName( currSprName )

        self.m_pFightSpr :addChild( currSprite )
        currSprite :setPosition( ccp( self.m_pFightSprSize.width * 0.5 + 20 * i, 0) )
    end

    return self.m_pFightSpr
end

--测试按钮
function CVipView.addTestBtn( self, winSize )
    if _G.g_bGMSwitch ~= nil and _G.g_bGMSwitch == 1 then
        local function testClick( eventType, obj, x, y )
            return self :onTestCallback( eventType, obj, x, y)
        end

        if self.m_tempBtn ~= nil then
            self.m_tempBtn :removeFromParentAndCleanup( true )
            self.m_tempBtn = nil
        end
        self.m_tempBtn = CButton :createWithSpriteFrameName( "临时", "transparent.png" )
        self.m_tempBtn :setFontSize( 30 )
        self.m_tempBtn :setColor( ccc4( 173, 216, 230, 255 ) )
        self.m_tempBtn :setPreferredSize( CCSizeMake( 144, 88 ) )
        self.m_tempBtn :registerControlScriptHandler( testClick, "this CVipView self.m_tempBtn 207")
        self.m_tempBtn :setPosition( 100, winSize.height / 4 )
        self.m_pContainer :addChild( self.m_tempBtn, 1, 10 )

        if self.m_tempGMBtn ~= nil then
            self.m_tempGMBtn :removeFromParentAndCleanup( true )
            self.m_tempGMBtn = nil
        end
        self.m_tempGMBtn = CButton :createWithSpriteFrameName( "GM", "transparent.png" )
        self.m_tempGMBtn :setFontSize( 30 )
        self.m_tempGMBtn :setColor( ccc4( 173, 216, 230, 255 ) )
        self.m_tempGMBtn :setPreferredSize( CCSizeMake( 144, 88 ) )
        self.m_tempGMBtn :registerControlScriptHandler( testClick, "this CVipView self.m_tempGMBtn 207")
        self.m_tempGMBtn :setPosition( 100, winSize.height / 4 + 100 )
        self.m_pContainer :addChild( self.m_tempGMBtn, 1, 20 )
    end

end



function CVipView.parseNumber( self, _nLv)
    local nHun =nil
    local nTen =nil       --取得十位
    local nBit =nil

    if _nLv >0 and _nLv <1000 then
        nHun = math.modf( _nLv / 100)
        nTen = math.modf( _nLv / 10 % 10)       --取得十位
        nBit = math.modf( _nLv % 10)          --取得个位
    end

    if nBit == nil then
        return
    end
    local lSize = self.m_roleBg :getPreferredSize()
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    sprSize = CCSizeMake( lSize.width, lSize.height)
    local sprHY = sprSize.height/2
    ------
    if self.lvContainer~=nil then
        self.lvContainer :removeFromParentAndCleanup( true)
        self.lvContainer = nil
    end
    self.lvContainer = CContainer :create()
    self.m_pContainer :addChild( self.lvContainer)

    local bSpr  = CSprite :createWithSpriteFrameName( "battle_"..(nBit or 0)..".png")
    local numSize = bSpr :getPreferredSize()
    bSpr :setPosition( sprSize.width*0.0899+numSize.width*3, winSize.height-sprHY-sprSize.height*0.33)
    self.lvContainer :addChild( bSpr)

    if nHun==nil or nHun==0 then
    else
        local tSpr  = CSprite :createWithSpriteFrameName( "battle_"..(nHun or 0)..".png")
        self.lvContainer :addChild( tSpr)
        tSpr :setPosition( sprSize.width*0.0899+numSize.width, winSize.height-sprHY-sprSize.height*0.33)
    end

    if nHun==nil or nHun==0 and nTen==0 or nTen==nil then
    else
        local hSpr  = CSprite :createWithSpriteFrameName( "battle_"..(nTen or 0)..".png")
        self.lvContainer :addChild( hSpr)
        hSpr :setPosition( sprSize.width*0.0899+numSize.width*2, winSize.height-sprHY-sprSize.height*0.33)
    end

    self.lvContainer :setPosition( ccp( 10, -7) )
    ------
end

function CVipView.initParams( self)
    --获取人物信息： 等级 名字 美刀 钻石 体力值
    local mainProperty  = _G.g_characterProperty : getMainPlay()
    if mainProperty==nil then
        CCMessageBox( "mainProperty==", mainProperty)
        CCLOG( "mainProperty=="..mainProperty)
    end

    --额外精力值显示
    self.m_buffValue = tonumber( mainProperty : getBuffValue() ) or 0
    self.m_pro       = tonumber( mainProperty : getPro() ) or 1

    print("uid", mainProperty :getUid())
    self.m_szName      =   mainProperty : getName() or 0
    self.m_nRoleLv     =   mainProperty : getLv() or 0
    self.m_nDoller     =   mainProperty : getGold() or 0
    self.m_nDoller     =   self : getMoneyNum( tonumber( self.m_nDoller), 10000)

    self.m_nDiamond    =   mainProperty : getRmb() + mainProperty :getBindRmb()  or 0
    self.m_nCurStr     =   mainProperty : getSum() or 0      --当前体力值
    self.m_nMaxStr     =   mainProperty : getMax() or 0     --最大体力值
    self.m_nVipLv      =   mainProperty : getVipLv() or 0
    self.m_nPowerful   =   mainProperty : getAllsPower() or 0
    
    self.m_nExp        =   mainProperty : getExp() or 0
    self.m_nExpn       =   mainProperty : getExpn() or 0

    print("体力值打印", self.m_nCurStr, self.m_nMaxStr, self.m_nVipLv, self.m_nRoleLv, debug.traceback())

end

function CVipView.cleanTempByNode( self, _node )
    if _node ~= nil then
        _node :removeFromParentAndCleanup( true )
        _node = nil
    end
end

--弹出tips
function CVipView.getPushBuffTipsView( self )
    CCLOG("弹出tips view")
    local function clickCallback( eventType, obj, x, y )
        return self :onClickTipsCallback( eventType, obj, x, y)
    end

    --pos 106 72
    self.m_lpTipslayer = CSprite :createWithSpriteFrameName( self.m_szIconFrame, CCRectMake( 33, 33, 1, 1) )
    self.m_nTipsTag    = 900
    self.m_lpTipslayer :setTouchesPriority( - 30 )
    self.m_lpTipslayer :setTag( self.m_nTipsTag )
    self.m_lpTipslayer :registerControlScriptHandler( clickCallback, "this CVipView self.m_lpTipslayer 387")


    self.m_lpTipslayerSize = CCSizeMake( 252.0, 104.0 )
    self.m_lpTipslayer :setPreferredSize( self.m_lpTipslayerSize )

    local nX = 106 + self.m_lpTipslayerSize.width / 2
    local nY = self.m_winSize.height - 70 - self.m_lpTipslayerSize.height / 2
    self.m_lpTipslayer :setPosition( ccp( nX * 1.0, nY * 1.0 ) )
    ------------------------------------------------------
    local _lineSpr = CSprite :createWithSpriteFrameName( self.m_szSprLine )
    _lineSprSize   = _lineSpr :getPreferredSize()
    _lineSpr :setPreferredSize( CCSizeMake( self.m_lpTipslayerSize.width, _lineSprSize.height ) )
    self.m_lpTipslayer :addChild( _lineSpr )
    ------------------------------------------------------
    --透明按钮
    local _clickBtn = CButton :create( "", "Loading/transparent.png" )
    _clickBtn :setPreferredSize( CCSizeMake( 230.0, 40.0 ) )
    self.m_lpTipslayer :addChild( _clickBtn )
    _clickBtn  : setTouchesPriority( -31 )
    _clickBtn  : registerControlScriptHandler( clickCallback, "this CVipView _clickBtn 407")
    self.TAG_TIPS = 1010
    _clickBtn  : setTag( self.TAG_TIPS )

    nX = 0.0
    nY = 20.0
    _clickBtn :setPosition( ccp( nX, nY) )

    self.m_lpTipslayer :addChild( self :getLabel( "menu_tl.png", "半小时自动回复5点体力", 1, 0), 10 )
    self :setBuffValueSpr()

    return self.m_lpTipslayer
end

function CVipView.setBuffValueSpr( self )
    --self.m_lpTipslayer :addChild( self :getLabel( "menu_tl_buff.png", "12点和18点自动获得", 2, self.m_buffValue ), 10 )
    self.m_lpTipslayer :addChild( self :getLabel( "menu_tl_buff.png", "12点和18点可领取体力", 2, "" ), 10 )
end

function CVipView.getLabel( self, _szSpr, _string, _count, _buff )
    --体力按钮   230 * 40
    local _pSprTemp  = CSprite :createWithSpriteFrameName( _szSpr )
    _pSprTemp  : setControlName( "this CVipView _pBuyBtn 406")
    _pSprTempSize = _pSprTemp :getPreferredSize()
    
    if _buff == nil or _buff == 0 then
        _buff = ""
    end
    local _pLabel = CCLabelTTF :create( tostring( _buff ), "Arial", 18 )
    _pSprTemp :addChild( _pLabel, 10 )
    
    local nX = -self.m_lpTipslayerSize.width / 2 + 15 + _pSprTempSize.width /2
    local nY = _pSprTempSize.height / 2 + 6 - ( _count - 1) * ( _pSprTempSize.height + 17 )
    _pSprTemp  : setPosition( ccp( nX, nY ) )    --15, 17

    local _pLabel = CCLabelTTF :create( _string or "", "Arial", 18 )
    _pLabel :setHorizontalAlignment( kCCTextAlignmentLeft )
    _pLabel :setAnchorPoint( ccp( 0.0, 0.5 ))
    _pLabel :setColor( ccc3( 150, 150, 150))

    nX = ( _pSprTempSize.width or 0 ) * 0.9
    nY = 0.0
    _pLabel :setPosition( ccp( nX, nY) )
    _pSprTemp :addChild( _pLabel )

    return _pSprTemp
end

function CVipView.onClickTipsCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("'sdfsfssfsf")
        if obj :getTag() == self.m_nTipsTag then
            return true
        elseif obj :getTag() == self.TAG_TIPS then              --体力
            self :requestBuyEnergy()
        end

        return true
    end
end

--关闭tips按钮
function CVipView.closeTipsView( self )
    if self.m_isView ~= nil and self.m_isView == true then
        self :cleanTempByNode( self.m_lpTipslayer )
        self.m_isView = false
    end
end

--测试回调
function CVipView.onTestCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if _G.g_bGMSwitch ~= nil and _G.g_bGMSwitch == 2 then
            return
        end

        if obj :getTag() == 10 then
            self :addFunctionId( )
        elseif obj :getTag() == 20 then
            require "view/GMWin/DevelopTool"
            local tool = CDevelopTool : scene();
            CCDirector : sharedDirector () : pushScene(tool)
        end

        return true
    end
end

--按钮回调
function CVipView.onPlusCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then

        if obj :getTag() == 20 then                                 --头像
            if self.m_isView == nil then
                self.m_isView = false
            end

            if self.m_isView == false then

                if self :getPushBuffTipsView() ~= nil then
                    self.m_pContainer : addChild( self :getPushBuffTipsView(), 1000 )
                end
                self.m_isView = true
            elseif self.m_isView == true then
                self :closeTipsView()
            end


        elseif obj :getTag() == self.TAG_STRENGTH then              --体力
            self :requestBuyEnergy()        --请求购买体力

        elseif obj :getTag() == self.TAG_CHARGE then
            --CCMessageBox( "充值", "" )
            self :checkRecharge()
        elseif obj :getTag() == 10 then
            print("sdfdsfs")
            --临时测试  可删


         --]]

        end
        obj :setHightLight()
        return true
    end

end

function CVipView.addFunctionId( self )
    local l_data = _G.pCFunctionOpenProxy :getSysId()
    if l_data ~= nil then

        local data = {}
        data[1] = 10009
        data[#data + 1] = _G.Constant.CONST_FUNC_OPEN_ROLE
        data[#data + 1] = 10040
        --data[#data + 1] = 10120
        data[#data + 1] = 10140
        data[#data + 1] = 10150
        data[#data + 1] = 10160
        data[#data + 1] = 10190
        data[#data + 1] = 10200
        data[#data + 1] = 10210
        data[#data + 1] = 10220
        data[#data + 1] = 10230
        data[#data + 1] = 10250
        data[#data + 1] = 10260
        data[#data + 1] = 10310

        data[#data + 1] = 10080
        data[#data + 1] = 10300
        data[#data + 1] = 10360
        data[#data + 1] = 10390
        --data[#data + 1] = 10130
        data[#data + 1] = 10110
        data[#data + 1] = 10180
        data[#data + 1] = 10270
        data[#data + 1] = 10210
        data[#data + 1] = _G.Constant.CONST_FUNC_OPEN_SYSTEM
        data[#data + 1] = 11020
        --data[#data + 1] = 11000
        data[#data + 1] = _G.Constant.CONST_FUNC_OPEN_DISCOVER_STORE --宝箱探秘
         print( "目前个数", #data )

        for k, value in pairs( data ) do
            if l_data[#l_data + 1] == nil then
                local num = #l_data
                l_data[num + 1] = {}
                print("valuevalue", value, num)
                l_data[num + 1].id  = value
                l_data[num + 1].use = 1
            end
        end
        --data[#data + 1] = 11000


        for k, v in pairs( l_data) do
            print("添加的id", k, v.id)
        end
        _G.pCFunctionOpenProxy :setIsVisible( 1)
        require "controller/FunctionOpenCommand"
        local command = CFunctionOpenCommand( CFunctionOpenCommand.UPDATE)
        controller :sendCommand( command)
        print("发信息")
    end
end

function CVipView.charge( self )
    local function topUpYesCallBack( )
        self :checkRecharge()
    end

    self.PopBox = CPopBox() --初始化
    self.m_topUpPopBoxLayer = self.PopBox : create( topUpYesCallBack, "是否进行充值?", 0 )
    self.m_topUpPopBoxLayer : setPosition(-20,0)
    self.m_pContainer       : addChild( self.m_topUpPopBoxLayer )
end

function CVipView.onRoleCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj :containsPoint( obj :convertToNodeSpaceAR( ccp( x, y ) ) )
    elseif eventType == "TouchEnded" then
        print("人物信息")
    end
end

function CVipView.setVipView( self, _data )
    CCLOG("VIP金钱 体力")
    self :initParams()

    --self.m_pRoleName    :setString( tostring(self.m_szName) or 0)
    self.m_pRoleDoller  :setString( tostring(self.m_nDoller) or 0)
    self.m_pRoleDiamond :setString( tostring(self.m_nDiamond) or 0)

    if _data ~= nil then
        self.m_nCurStr = tostring( _data.sum )
        self.m_nMaxStr = tostring( _data.max )
    end

    self :addStrengthLine( self.m_nCurStr / self.m_nMaxStr )
    local szStrength = ( self.m_nCurStr or 0 ).."/"..( self.m_nMaxStr or 0)
    self.m_pRoleStrength  :setString( tostring(szStrength) or 0)
end

function CVipView.setLvView( self, _data)
    print("vip_data", _data )
    self.m_nRoleLv = tonumber( _data )
    self :parseNumber( tonumber( _data ) )
end

function CVipView.checkRecharge( self )
    local command = CPayCheckCommand( CPayCheckCommand.ASK )
    controller :sendCommand( command )
end

function CVipView.setBuyEnergyView( self, _data)
    self :initParams()

    CCLOG("传过来的数据为--> ".._data.type)
    if _data == nil then
        return
    end

    --{购买体力请求}
    local function gotoBuyEnergy()
        require "common/protocol/auto/REQ_ROLE_BUY_ENERGY"
        local msg = REQ_ROLE_BUY_ENERGY()
        CNetwork :send( msg)
    end

    --{进入充值界面}
    local function gotoChargeView()
        CCLOG("进入充值界面")
        self :checkRecharge()
    end

    local szRmb     = tostring( _data.rmb)      -- {购买需花费的元宝数}
    local szSumnum  = tostring( _data.sumnum)   -- {可购买总次数}
    local nType     = _data.type                -- {购买精力类型-[ 见常量CONST_ENERGY_REQUEST_TYPE 购买精力类型]}
    local szNum     = tostring( _data.num)      -- {第几次购买}
    local szRemaining = tostring( _data.sumnum - _data.num +1)        --剩余次数

    --local buyNodes = _G.Config.energy_buys :selectNode( "energy_buy", "times", szNum)
    local strEnergy_buys = "energy_buy[@times=" .. szNum .. "]"
    local buyNodes = _G.Config.energy_buys :selectSingleNode( strEnergy_buys )
    print( "energy_buy.xmml-->", strEnergy_buys , buyNodes :isEmpty() )
    --local vipNodes = _G.Config.vips :selectNode( "vip", "lv", tostring( self.m_nVipLv ) )

    CCLOG("打印次数 "..szNum.."  vip等级="..self.m_nVipLv)

    local szContent = nil
    local szBtnName = nil
    local _func     = nil

    CCLOG("剩余次数-->"..szRemaining)
    if tonumber( szRemaining) <= 0 or self.m_nVipLv == 0 then
        szContent = "您的体力购买次数已用完\n请提高vip等级后继续购买！"
        szBtnName = "充值"
        _func     = gotoChargeView

    elseif tonumber( szRemaining) > 0 then
        if buyNodes ~= nil and not buyNodes :isEmpty() then
            local _szAdd_energy = buyNodes :getAttribute( "add_energy" ) or ""
            szContent = "花费"..szRmb.."钻石获得".. _szAdd_energy .."点体力".."\n\n".."剩余购买次数("..szRemaining.."/"..szSumnum.."次)"
            szBtnName = "确认"
            _func     = gotoBuyEnergy
        end
    end

    if szContent ==nil or szBtnName == nil or _func == nil then
        CCLOG("异常 处理-->"..szContent)
        return
    end
    local l_popBox = CPopBox()
    local l_tips   = l_popBox :create( _func, szContent or "", 0)
    l_popBox       :setButtonName( szBtnName )
    --self.m_pContainer :addChild( l_tips,1000)
    CCDirector :sharedDirector() :getRunningScene() :addChild( l_tips, 10000)
     --]]
end






function CVipView.setVipBtn( self)

end

function CVipView.setPowerfulView( self )
    self :initParams()
    self.m_pContainer : addChild( self :getFightlayer( self.m_nPowerful  ), 100 )
end

function CVipView.setEnergyView( self)
    self :initParams()
    --加号按钮

    local isVis = true
    if self.m_buffValue <= 0 or self.m_buffValue == nil or self.m_buffValue > 50 then
        isVis = false
    end
    print("self.m_buffValue", self.m_buffValue)
    --self :setBuffValueSpr()
end

function CVipView.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    --self.m_pContainer   : addChild(BoxLayer,1000)
    CCDirector :sharedDirector() :getRunningScene() :addChild( BoxLayer, 10000 )
end

