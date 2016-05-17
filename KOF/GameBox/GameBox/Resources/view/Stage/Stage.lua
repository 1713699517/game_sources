require "view/view"
require "view/Map/Maptable"
require "view/MainUILayer/MainUIScene"
require "view/KeyBoard/KeyBoardView"
require "view/Stage/CharacterManager"
require "view/Stage/StageXMLManager"
require "view/Stage/BattleView"

require "controller/ChatCommand"
require "controller/command"

require "mediator/StageMediator"
require "mediator/KeyBoardMediator"
require "mediator/NpcMediator"
require "mediator/LogsMediator"
require "mediator/MarqueeMediator"

require "view/Logs/Logs"
require "view/Marquee/Marquee"


require "common/Constant"

require "view/DuplicateLayer/DeadCopyView"

require "common/protocol/auto/REQ_COPY_IS_UP"
require "view/Character/Partner"
require "view/Stage/TouchPlayView"

require "view/Plot/PlotManager" --剧情管理

CStage = class(view, function ( self )
    self.m_bIsInit = false
end)
_G.g_Stage = CStage()

function CStage.create( self )
    _G.g_FirstCaoZuoZhiyinIndex = 1

    local director = CCDirector :sharedDirector()
    self.winSize = director : getWinSize()

    -- 场景
    self.m_lpScene = CCScene : create()
    self : removeKeyBoardAndJoyStick()

    -- 层
    self.m_lpContainer              = CContainer :create() -- 总层
    self.m_lpMapContainer           = CContainer :create() --地表层
    self.m_lpMapDisContainer        = CContainer :create() --远地表
    self.m_lpCharacterContainer     = CContainer :create() --角色层
    self.m_lpUIContainer            = CContainer :create() -- UI层
    self.m_lpRemainingTimeContainer = CContainer :create() -- 倒计时层
    self.m_lpMessageContainer       = CContainer :create() --信息层  比如:本奖励/死亡/时间到
    self.m_lpComboContainer         = CContainer :create() --连击 图片层
    self.m_lpLogsContainer          = CContainer :create() --日志层
    self.m_lpMarqueeContainer       = CContainer :create() --跑马灯层
    self.m_lpDPSContainer           = CContainer :create() --DPS层
    self.m_lpTouchPlayContainer     = CContainer :create() --查看信息层
    self.m_lpPKFlashContainer       = CContainer :create() --PK闪耀层
    self.m_lpPKReceiveContainer     = CContainer :create() --PK邀请层
    self.m_lpKOFContainer           = CContainer :create() --模式层

    --setControlName
    self.m_lpContainer : setControlName( "this CStage self.m_lpContainer " )
    self.m_lpMapContainer : setControlName( "this CStage self.m_lpMapContainer " )
    self.m_lpMapDisContainer : setControlName( "this CStage self.m_lpMapDisContainer " )
    self.m_lpCharacterContainer : setControlName( "this CStage self.m_lpCharacterContainer " )
    self.m_lpUIContainer : setControlName( "this CStage self.m_lpUIContainer " )
    self.m_lpRemainingTimeContainer : setControlName( "this CStage self.m_lpRemainingTimeContainer " )
    self.m_lpMessageContainer : setControlName( "this CStage self.m_lpMessageContainer " )
    self.m_lpComboContainer : setControlName( "this CStage self.m_lpComboContainer " )
    self.m_lpLogsContainer : setControlName( "this CStage self.m_lpLogsContainer " )
    self.m_lpMarqueeContainer : setControlName( "this CStage self.m_lpMarqueeContainer")
    self.m_lpDPSContainer : setControlName( "this CStage self.m_lpDPSContainer " )
    self.m_lpTouchPlayContainer : setControlName( "this CStage self.m_lpTouchPlayContainer " )
    self.m_lpPKFlashContainer : setControlName( "this CStage self.m_lpPKFlashContainer " )
    self.m_lpPKReceiveContainer : setControlName( "this CStage self.m_lpPKReceiveContainer " )
    self.m_lpKOFContainer : setControlName( "this CStage self.m_lpKOFContainer " )



    self.m_lpContainer : setPosition(0,0)
    self.m_lpMapContainer : setPosition(0,0)
    self.m_lpCharacterContainer : setPosition(0,0)
    self.m_lpUIContainer : setPosition(0,0)
    self.m_lpDPSContainer : setPosition(0,0)


    self.m_lpContainer : addChild( self.m_lpMapContainer, 100 )
    self.m_lpContainer : addChild( self.m_lpCharacterContainer, 200 )

    self.m_lpScene : addChild( self.m_lpMapDisContainer, 99 )
    self.m_lpScene : addChild( self.m_lpContainer,100 )
    --200按键
    self.m_lpScene : addChild( self.m_lpUIContainer, 300 )
    self.m_lpScene : addChild( self.m_lpRemainingTimeContainer, 400 )
    self.m_lpScene : addChild( self.m_lpMessageContainer, 500 )
    self.m_lpScene : addChild( self.m_lpComboContainer, 600 )
    self.m_lpScene : addChild( self.m_lpLogsContainer, 700 )
    self.m_lpScene : addChild( self.m_lpDPSContainer, 800 )
    self.m_lpScene : addChild( self.m_lpTouchPlayContainer, 900 )
    self.m_lpScene : addChild( self.m_lpPKFlashContainer, 1000 )
    self.m_lpScene : addChild( self.m_lpPKReceiveContainer, 1100 )
    self.m_lpScene : addChild( self.m_lpKOFContainer, 1200 )
    self.m_lpScene : addChild( self.m_lpMarqueeContainer, 1300)
    return self.m_lpScene
end

function CStage.init( self, _nScenesID,_x, _y)
    _G.g_BattleView : cleanupDPS()


    --取出场景数据
    local scenesXML = _G.StageXMLManager : getXMLScenes( _nScenesID )
    if scenesXML == nil then
        CCMessageBox("scenesXML is nil", "GET ID ERROR")
        CCLOG("codeError!!!! scenesXML is nil")
        return
    end
    self.m_lpScenesXML = scenesXML
    --取出资源数据
    mapTable : load( tonumber( self.m_lpScenesXML:getAttribute("material_id") ) )
    self.m_lpMapData = mapTable : getClone()

    self : initMainPlay(_x, _y)

    self.m_lpPlay = _G.g_lpMainPlay

    --{ 副本时间 倒计时 }
    self.m_nRemainingTime = nil

    --{ 是否开场动画中 }
    self.m_isStartStageAction = false

    --控制模式
    self : addControlMode()

    -- --加入主玩家
    self : addCharacter( self.m_lpPlay )

    --地图块精灵
    self.m_lpArrayMapSprite = {}
    self.m_lpArrayMapDisSprite = {}--远景的

    --{ 地图加载间隔时间 }
    self.m_nLoadMapTime = 0

    --{人物移动时间}
    self.m_nLastRoleMove = 0

    --地图加载
    self : initMapPos(_x,_y)

    --剧情播放
    self._isPlotIng = false

    --世界BOSS倒计时
    self.m_BossTime = nil


    self.hit_times = 0  -- {被击数}
    self.carom_times  = 0  -- {最高连击数}
    self.mons_hp   = 0  -- {对怪物伤害(所有怪物杀出的血)}
    self.m_nCombo = 0 --{当前连击数}
    self.m_nComboTime = nil --{连击时间}

    self.m_bIsInit = true
    SimpleAudioEngine:sharedEngine():unloadAllEffects()
    SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
    CCLOG("background music "..tostring(scenesXML:getAttribute("mbg") ))
    local mbg = scenesXML:getAttribute("mbg")
    if mbg ~= nil and string.len(mbg) > 0
        and _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC_BG) == 1 then
        SimpleAudioEngine:sharedEngine():playBackgroundMusic("Sound@mp3/"..tostring(mbg)..".mp3", true)
    end

    --之后再做的事情
    local function onInitializeStage()
        self : WaitMomentInitializeStage()
    end
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(0.5))
    _callBacks:addObject(CCCallFunc:create(onInitializeStage))
    self.m_lpScene:runAction( CCSequence:create(_callBacks) )

    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        _G.g_nLastScenesID = _nScenesID
        _G.g_nLastX,_G.g_nLastY = _x, _y
    end
    onInitializeStage = nil
    --self : runStrartStageAction(30)
    return self.m_lpScene
end

function CStage.getBackgroundMusicId(self)
    return self.m_lpScenesXML:getAttribute("mbg")
end

function CStage.initMainPlay( self,_x, _y )
    local property = _G.g_characterProperty : getMainPlay()
    local uid = property : getUid()
    local name = property : getName()
    local pro = property : getPro()
    local hp = property : getAttr() : getHp()
    local maxHP = property : getAttr() : getMaxHp()
    local sp = property : getAttr() : getSp()
    local lv = property : getLv()
    local sex = property : getSex()
    local country = property : getCountry()
    local skinId = property : getSkinArmor()

    local clanId = property : getClan()
    local clanName = property : getClanName()
    local magicId = property : getMagicId()
    _G.g_lpMainPlay = nil
    _G.g_lpMainPlay = CPlayer( Constant.CONST_PLAYER )
    _G.g_lpMainPlay : playerInit( uid, name, sex, pro, lv, country, false, skinId )

    print("MAINPLAY__INIT", _G.g_Stage:getScenesType(), hp, maxHP)
    if _G.g_Stage:getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        hp = hp * 5
        maxHP = maxHP * 5
    end
    _G.g_lpMainPlay : init( uid , name, maxHP,hp, sp, sp, _x, _y, skinId )
    _G.g_lpMainPlay : setClanInfo( clanId, clanName)
    _G.g_lpMainPlay : setLocationXY( _x, _y )
    if _G.g_Stage:getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        _G.g_lpMainPlay : setMagicSkinId(magicId)
    end

    local skillData     = property :getSkillData()
    if skillData ~= nil then
        _G.g_lpMainPlay:setSkillID(
            skillData:getSkillIdByIndex(1),
            skillData:getSkillIdByIndex(2),
            skillData:getSkillIdByIndex(3),
            skillData:getSkillIdByIndex(4),
            skillData:getSkillIdByIndex(5),
            skillData:getSkillIdByIndex(6),
            skillData:getSkillIdByIndex(7),
            skillData:getSkillIdByIndex(8),
            skillData:getSkillIdByIndex(9),
            skillData:getSkillIdByIndex(10)
            )
    else
        CCLOG("更新技能数据")
    end
end

function CStage.setBossTime( self, _time )
    self.m_BossTime = _time
end

function CStage.getTouchPlayContainer( self )
    return self.m_lpTouchPlayContainer
end
function CStage.removeTouchPlayContainerChild( self )
    self.m_lpTouchPlayContainer : removeAllChildrenWithCleanup( true )
end
function CStage.getPKFlashContainer( self )
    return self.m_lpPKFlashContainer
end
function CStage.removePKFlashContainerChild( self )
    self.m_lpPKFlashContainer : removeAllChildrenWithCleanup( true )
end
function CStage.getPKReceiveContainer( self )
    return self.m_lpPKReceiveContainer
end
function CStage.removePKReceiveContainerChild( self )
    self.m_lpPKReceiveContainer : removeAllChildrenWithCleanup( true )
end

function CStage.getScene( self )
    return self.m_lpScene
end


--振屏
function CStage.vibrate(self)
    local vSize = CCDirector:sharedDirector():getVisibleSize()
    local vWidth = vSize.width / 100 * 1
    local vHeight = vSize.height / 100 * 1
    local vibrateArr = CCArray:create()
    vibrateArr:addObject( CCMoveBy:create(0.05, ccp( vWidth , vHeight )) )
    vibrateArr:addObject( CCMoveBy:create(0.05, ccp( -vWidth, -vHeight )) )
    vibrateArr:addObject( CCMoveBy:create(0.05, ccp( vWidth, -vHeight )) )
    vibrateArr:addObject( CCMoveBy:create(0.05, ccp( -vWidth , vHeight )) )

    local vibrateArr2 = CCArray:create()
    vibrateArr2:addObject( CCMoveBy:create(0.05, ccp( vWidth , vHeight )) )
    vibrateArr2:addObject( CCMoveBy:create(0.05, ccp( -vWidth, -vHeight )) )
    vibrateArr2:addObject( CCMoveBy:create(0.05, ccp( vWidth, -vHeight )) )
    vibrateArr2:addObject( CCMoveBy:create(0.05, ccp( -vWidth , vHeight )) )
    self.m_lpMapContainer:runAction( CCSequence:create(vibrateArr) )
    self.m_lpCharacterContainer:runAction( CCSequence:create(vibrateArr2) )
    CDevice : sharedDevice() : vibrate( 200 )
end

--æææææææææææææææææææææææææææææææææææææææ
--陈元杰 添加剧情接口         START
--æææææææææææææææææææææææææææææææææææææææ

function CStage.checkPlotHas( self )
    --陈元杰   添加剧情判断  Start  ææææææææææææææææ
    if self : getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY
        or self : getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL
        or self : getScenesType() ~= _G.Constant.CONST_MAP_TYPE_BOSS
        or self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then

        local property = _G.g_characterProperty : getMainPlay()
        if property : getIsTeam() == false then
            --非组队才有剧情
            local copyId   = tonumber(self.m_lpScenesXML:getAttribute("copy_id"))
            local plotData = _G.pCPlotManager :checkPlotHas( _G.Constant.CONST_DRAMA_GETINTO,copyId ) -- 1表示进入副本触发
            print("ææææææææææææææææ  copyId="..copyId,plotData)
            if plotData ~= false then
                -- local function local_callBack( )
                --     comm = CStageREQCommand(_G.Protocol["REQ_SCENE_REQUEST_MONSTER"])
                --     _G.controller : sendCommand( comm )
                -- end
                print("ææææææææææææææææshowPlotæææææææææææææææææ")
                local function funRun()
                    self : runStrartStageAction()
                end
                _G.pCPlotManager :showPlot( plotData, funRun )
                funRun = nil
                return true
            end
        end
    end
    --陈元杰   添加剧情判断  End    ææææææææææææææææ
end

--启动剧情 隐藏该隐藏的东西  _visible{false:隐藏,true:显示}
function CStage.visibleForPlot( self, _visible )

    if _visible == false then
        self._isPlotIng = true
    else
        self._isPlotIng = false
    end

    for i,v in ipairs(_G.CharacterManager :getCharacter()) do
        if v.m_lpContainer ~= nil then
            print("getCharacter")
            if self :isMainPlay(v) == false then
                v.m_lpContainer :setVisible( _visible )
                v:cancelMove()
            else
                local player      = self : getPlay()
                player :setMoveClipContainerScalex(1)
                player :cancelMove()
            end
        end
    end

    self.m_lpUIContainer :setVisible( _visible )
    self.m_lpRemainingTimeContainer :setVisible( _visible )
    self.m_lpMessageContainer :setVisible( _visible )
    self.m_lpComboContainer :setVisible( _visible )
    self.m_lpLogsContainer :setVisible( _visible )
    self.m_lpDPSContainer :setVisible( _visible )

    if _G.pJoyStick ~= nil then
        _G.pJoyStick :setVisible( _visible )
    end

    if self.m_lpKeyBoard ~= nil then
        self.m_lpKeyBoard :setVisible( _visible )
    end

end

--添加剧情怪物 _id:tag值    _pos:出现的位置
function CStage.addPlotMonster( self, _id, _name, _pos, _dir )
    local monster = _G.StageXMLManager :addPlotMonsterByID( _id, _name )
    if monster ~= nil then

        if tonumber( _dir ) == 9 then
            monster : setMoveClipContainerScalex(1)
        else
            monster : setMoveClipContainerScalex(-1)
        end

        monster : setStage( self )
        monster : getContainer() : setTag( _id )
        self.m_lpCharacterContainer :addChild( monster: getContainer() )
        monster : setLocationX( _pos.x )
        monster : setLocationY( _pos.y )
        monster : setLocationZ( 0 )
        _G.CharacterManager : add( monster )
    end
    return monster
end

--根据tag值 移除剧情怪物
function CStage.removePlotMonster( self, _monster )
    if _monster ~= nil then
        if _monster :getContainer() ~= nil then
            self.m_lpCharacterContainer:removeChild( _monster :getContainer() )
        end
        _G.CharacterManager : remove( _monster )
    end
end
--æææææææææææææææææææææææææææææææææææææææ
--添加剧情接口         END
--æææææææææææææææææææææææææææææææææææææææ


function CStage.addPartnerByProperty( self, _property, _isENDUCE, _isCHALLENGEPANEL )--_isENDUCE 是否霸体 --_isCHALLENGEPANEL是否竞技场
    local listID = _property : getPartner()
    for _,partnerID in pairs(listID) do
        local index      = tostring( _property : getUid())..tostring(partnerID)
        local partnerProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if partnerProperty ~= nil then
            if partnerProperty : getStata() == _G.Constant.CONST_INN_STATA3 and partnerProperty:getAttr():getHp() > 0 then
                local characterPartner = CPartner(_G.Constant.CONST_PARTNER)
                characterPartner : partnerInit(partnerProperty)
                print("添加了伙伴")
                self : addCharacter( characterPartner )
                if _isENDUCE == true then
                    local invBuff1 = _G.buffManager:getBuffNewObject( "601", 0 )
                    characterPartner : addBuff( invBuff1 )
                end
                if _isCHALLENGEPANEL == true then
                    characterPartner : setArenaHp()
                end
            end
        end
    end
end





--之后做的事情
function CStage.WaitMomentInitializeStage( self )
    CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents( true )
    --主城
    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        --登陆获取是否打开挂机界面
        local req_msg = REQ_COPY_IS_UP()
        _G.CNetwork : send( req_msg )


        --请求场景内人物数据
        self : reqStagePeople()

        --切换场景后是否继续寻路到npc
        self : autoSearchRoad()


        ----------------------
        --发送指引 命令  陈元杰
        ----------------------
        require "controller/GuideCommand"
        local _guideCommand = CGuideSceneCammand( CGuideSceneCammand.SCENE_CHUANGE )
        controller:sendCommand(_guideCommand)

        if _G.g_CFunOpenManager ~= nil then
            _G.g_CFunOpenManager:showOneNotic( 4 )
        end
    --竞技场
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        local mainPlayProperty = _G.g_characterProperty : getMainPlay()
        local challengePanePlayProperty = _G.g_characterProperty : getChallengePanePlayInfo()
        self : addPartnerByProperty( mainPlayProperty, true, true )
        self : addPartnerByProperty( challengePanePlayProperty, true, true )
    --BOSS
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        --请求BOSS战数据
        local comm = CStageREQCommand(_G.Protocol["REQ_WORLD_BOSS_DATA"])
        _G.controller : sendCommand( comm )

        comm = CStageREQCommand(_G.Protocol["REQ_SCENE_REQUEST_MONSTER"])
        _G.controller : sendCommand( comm )


        --请求场景内人物数据
        self : reqStagePeople()
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_KOF then
        CCLOG("fff")
        self : reqStagePeople()
    --其他副本
    else
        --请求场景内人物数据
        self : reqStagePeople()
        --添加伙伴
        local mainPlayProperty = _G.g_characterProperty : getMainPlay()
        self : addPartnerByProperty( mainPlayProperty, false )

        comm = CStageREQCommand(_G.Protocol["REQ_SCENE_REQUEST_MONSTER"])
        _G.controller : sendCommand( comm )

    end
    CCLOG("STAGE 最后的通牒")
end

--清空stage所占纹理资源
function CStage.releaseResource( self )
    if self.m_lpContainer ~= nil then
        self.m_lpContainer : removeChild( self.m_lpMapContainer, false )
        for k,v in pairs(self.m_lpMapData:getMapPath() ) do
            CCTextureCache:sharedTextureCache():removeTextureForKey(v)
        end
    end
    self : releaseLoadResource()
end
function CStage.releaseLoadResource( self )
    CCTextureCache:sharedTextureCache():removeTextureForKey("Loading/loading2_underframe.jpg")
    CCTextureCache:sharedTextureCache():removeTextureForKey("Loading/loading2_strip_frame.png")
    CCTextureCache:sharedTextureCache():removeTextureForKey("transparent.png")
    CCTextureCache:sharedTextureCache():removeTextureForKey("Loading/loading2_strip.png")
end

--{自动寻路查找npc}
function CStage.autoSearchRoad( self )
    if _G.g_CTaskNewDataProxy ~= nil then
        local posData = _G.g_CTaskNewDataProxy :getAutoList()
        if posData ~= nil then
            local nPos = _G.g_CTaskNewDataProxy :getNpcPos( posData.npcId, posData.sceneId )
            _G.g_Stage :getRole() :setMovePos( nPos )
            _G.g_CTaskNewDataProxy :setAutoList( nil )
        end
    end
end

function CStage.cleanupCombo( self )
    self.m_lpComboContainer : removeAllChildrenWithCleanup( true )
end
function CStage.addCombo( self )
    self.m_nCombo = self.m_nCombo + 1
    --如果大于最大连击
    if self.m_nCombo > self.carom_times then
        self.carom_times = self.m_nCombo

        if self : getScenesPassType() == _G.Constant.CONST_COPY_PASS_COMBO then
            _G.g_BattleView : showLJTZ( self.carom_times, self : getScenesPassValue(), self.m_lpKOFContainer )
        end
    end
    _G.pDateTime : reset()
    self.m_nComboTime = _G.pDateTime : getTotalMilliseconds() --毫秒数
    self : cleanupCombo()
    _G.g_BattleView : showCombo( self.m_nCombo, self.m_lpComboContainer)
end


function CStage.autoHideCombo( self, _nowTime )
    if self.m_nComboTime == nil or _nowTime - self.m_nComboTime < _G.Constant.CONST_BATTLE_COMBO_TIME*1000 then
        return
    end
    self : cleanupCombo()
    self.m_nComboTime = nil
    self.m_nCombo = 0
end

--{是否已经初始化}
function CStage.isInit( self )
    return self.m_bIsInit
end

--{添加日志,}
function CStage.addLogs( self, _lp )
    if self.m_lpLogsContainer ~= nil then
        self.m_lpLogsContainer : addChild( _lp )
    end
end

--{添加跑马灯}
function CStage.addMarquee( self, _lp )
    if self.m_lpMarqueeContainer ~= nil then
        self.m_lpMarqueeContainer : addChild( _lp )
    end
end

--添加 信息层
function CStage.addMessageView( self, _container )
    self : removeMessageView()
    self.m_lpMessageContainer : addChild( _container )
end
function CStage.removeMessageView( self )
    self.m_lpMessageContainer : removeAllChildrenWithCleanup(true)
end

function CStage.addControlMode( self )
    --设置可否控制
    self.m_canControl = true

    --主城
    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        local function menucallBack( eventType, obj, _x, _y  )
            --场景事件
            --过场玩家失去控制

            if eventType == "TouchBegan" then
                return true
            end
            if(eventType == "TouchEnded") then
                if self : getCanControl() == false or self.m_isStartStageAction == true then
                    return
                end
                self : removeTouchPlayContainerChild()

                local tempPos = self : convertStageSpace( ccp( _x, _y ) )
                local x,y = self.m_lpPlay : convertLimitPos(tempPos.x,tempPos.y)
                self.m_lpPlay : setMovePos(  ccp(x,y) )
                _G.pmainView : setMenuStatus( false )
                --关闭左上角的tips
                local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
                controller :sendCommand( closeCommand )

                local _wayCommand = CChatWindowedCommand(CChatWindowedCommand.SHOW)
                controller:sendCommand(_wayCommand)
            end
        end
        --注册地图点击事件
    --[[]]
        --self.m_lpContainer.view = self
        self.m_lpContainer : setFullScreenTouchEnabled(true)
        self.m_lpContainer : setTouchesPriority(1)
        self.m_lpContainer : setTouchesEnabled(true)
        self.m_lpContainer : registerControlScriptHandler( menucallBack, "this CStage self.m_lpContainer 143")
        menucallBack = nil
        if _G.pmainView ~= nil  then
            CCLOG("add ui 1 ")
            self.m_lpUIContainerChild =  _G.pmainView : container()
            CCLOG("add ui 2 ")
            self.m_lpUIContainer : addChild( self.m_lpUIContainerChild )
            CCLOG("add ui 3 ")
        end


        self:registerEnterFrameCallBack(false)


        --设置关卡左右x --主城就是一个大关卡
        self.m_nMaplx = 0
        self.m_nMaprx = self.m_lpMapData : getWidth()
        local scenesID = self : getScenesID()

        --添加Npc
        _G.StageXMLManager : addNPC( scenesID )

        --添加传送门
        _G.StageXMLManager : addTransport( scenesID )




    --竞技场
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        self.m_nMaplx = 0
        self.m_nMaprx = self.m_lpMapData : getWidth()
        --注册AI回调
        self:registerEnterFrameCallBack(true)
        --退出副本
        _G.g_BattleView : addExitCopyButton( self.m_lpMessageContainer )


        local pkPlayInfo = _G.g_characterProperty : getChallengePanePlayInfo()
        if pkPlayInfo ~= nil then
            local attr = pkPlayInfo : getAttr()
            local Player =  CPlayer( _G.Constant.CONST_PLAYER )
            Player : playerInit( pkPlayInfo : getUid(), pkPlayInfo : getName(), pkPlayInfo : getSex(), pkPlayInfo : getPro(), pkPlayInfo : getLv(), 0, false, pkPlayInfo :getSkinArmor() )
            Player : init( pkPlayInfo : getUid() , pkPlayInfo : getName(), attr.hp, attr.hp, attr.sp, attr.sp, _G.Constant.CONST_ARENA_RIGHT_X, _G.Constant.CONST_ARENA_SENCE_RIGHT_Y, pkPlayInfo :getSkinArmor() )
            Player : setClanInfo( pkPlayInfo:getClan(), pkPlayInfo:getClanName() )
            Player : addBigHpView( 1 , false)
            _G.g_Stage : addCharacter( Player )
            local mainPlay = _G.g_Stage : getPlay()

            --pkPlayInfo : getPro()
            local mainPlayAI_ID = tonumber(mainPlay.xmlChar:getAttribute("ai_id"))
            mainPlay : setAI(mainPlayAI_ID)
            local PlayerAI_ID = tonumber(Player.xmlChar:getAttribute("ai_id"))
            Player : setAI(PlayerAI_ID)

            mainPlay : setArenaHp()
            Player : setArenaHp()

            local invBuff1 = _G.buffManager:getBuffNewObject( "601", 0 )
            mainPlay:addBuff(invBuff1)
            Player:addBuff(invBuff1)


        end




        --设置时间
        self : setRemainingTime( _G.Constant.CONST_ARENA_BATTLE_TIME )
    --世界BOSS
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        --[[CONST_MAP_TYPE_BOSS
        添加鼓舞按钮
        安全区域
        BOSS不能走到安全区域
        BOSS不能攻击安全区域的人物
        ]]
        self.m_lpDpsList = {} --DPS排名
        self.m_nSelfDps = 0 --自己的DPS伤害
        self.m_bBossVipRmb = false --是否开启鼓舞
        self.m_lpBossCharacter = nil --世界BOSS
        self.m_nBossDeadTime = 0--re复活时间


        --场景ID
        local scenesID = self : getScenesID()

        --默认关卡 为第一关
        self.m_nCheckPointID = 1

        --注册手柄事件
        self : removeKeyBoard()
        self : addJoyStick()
        self : addKeyBoard()

        self.m_nMaplx = 0
        self.m_nMaprx = self.m_lpMapData : getWidth()
        --注册AI回调
        self:registerEnterFrameCallBack(true)
        --退出副本
        _G.g_BattleView : addExitCopyButton( self.m_lpMessageContainer )

        --托管
        _G.g_BattleView : addhostingBtn( self.m_lpUIContainer )


        -- --添加Monster
        -- local property = _G.g_characterProperty : getMainPlay()
        -- local teamID = property : getTeamID()
        -- if teamID == nil or teamID == property:getUid() then
        --     _G.StageXMLManager : addMonster( scenesID, self.m_nCheckPointID )
        -- end


        --显示DPS
        _G.g_BattleView : showDps(  )
    --PK
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        --注册手柄事件
        self : removeKeyBoard()
        self : addJoyStick()
        self : addKeyBoard()
        --场景ID
        local scenesID = self : getScenesID()
        --默认关卡 为第一关
        self.m_nCheckPointID = 1

        self.m_nMaplx = 0
        self.m_nMaprx = self.m_lpMapData : getWidth()
        --注册AI回调
        self:registerEnterFrameCallBack(true)
        --退出副本
        _G.g_BattleView : addExitCopyButton( self.m_lpMessageContainer )

        --托管
        --_G.g_BattleView : addhostingBtn( self.m_lpUIContainer )

        --设置时间
        self : setRemainingTime( _G.Constant.CONST_ARENA_BATTLE_TIME )
    --格斗之王
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_KOF then
        --注册手柄事件
        self : removeKeyBoard()
        self : addJoyStick()
        self : addKeyBoard()
        --场景ID
        local scenesID = self : getScenesID()
        --默认关卡 为第一关
        self.m_nCheckPointID = 1

        self.m_nMaplx = 0
        self.m_nMaprx = self.m_lpMapData : getWidth()
        --注册AI回调
        self:registerEnterFrameCallBack(true)
        --退出副本
        _G.g_BattleView : addExitCopyButton( self.m_lpMessageContainer )
        print("asfcccccc")
        --托管
        --_G.g_BattleView : addhostingBtn( self.m_lpUIContainer )

    --副本战斗
    else
        --场景ID
        local scenesID = self : getScenesID()
        print("self : getScenesID()====1111",self : getScenesID(),self : getScenesType())

        --默认关卡 为第一关
        self.m_nCheckPointID = 1

        --设置关卡左右x
        local checkpoint = _G.StageXMLManager : getXMLScenesCheckpoint( scenesID, self.m_nCheckPointID)
        if checkpoint:isEmpty() then
            CCLOG("this is stage fun :addControlMode checkpoint is nil ")
            return
        end

        self.m_nMaplx = tonumber(checkpoint:getAttribute("lx"))
        self.m_nMaprx = tonumber(checkpoint:getAttribute("rx"))
        if self.m_nMaplx == nil or  self.m_nMaprx == nil then
            CCLOG("codeError!!!! 副本关卡 x,y 错误")
        end

        --添加Monster
        local property = _G.g_characterProperty : getMainPlay()
        if property : getIsTeam() == false then
            _G.StageXMLManager : addMonster( scenesID, self.m_nCheckPointID )
        end

        --注册AI回调
        self:registerEnterFrameCallBack(true)
        if scenesID ~= _G.Constant.CONST_COPY_FIRST_SCENE then
            --退出副本
            _G.g_BattleView : addExitCopyButton( self.m_lpMessageContainer )

            --托管
            _G.g_BattleView : addhostingBtn( self.m_lpMessageContainer )
        end
        --注册手柄事件
        self : removeKeyBoard()
        self : addJoyStick()
        self : addKeyBoard()
    end

    local passType = self : getScenesPassType()
    --限时 在时间内,击败所有怪物
    if passType == _G.Constant.CONST_COPY_PASS_TIME then
        _G.g_BattleView : showXSTZ( self.m_lpKOFContainer )
        self : setRemainingTime(tonumber(self : getScenesPassValue()))
    --连击 击败所有怪物,并且最高连击数量达到要求
    elseif passType == _G.Constant.CONST_COPY_PASS_COMBO then
        _G.g_BattleView : showLJTZ( 0,self : getScenesPassValue(), self.m_lpKOFContainer )
    --生存模式 在限定时间内,HP大于0,并且场景内所有怪物消除
    elseif passType == _G.Constant.CONST_COPY_PASS_ALIVE then
        _G.g_BattleView : showSCTZ( self.m_lpKOFContainer )
        self : setRemainingTime(tonumber(self : getScenesPassValue()))
    end

end
function CStage.getBossDeadTime( self )
    return self.m_nBossDeadTime
end
function CStage.setBossDeadTime( self, _time )
    self.m_nBossDeadTime = _time
end
function CStage.setBoss( self, _lpCharacter )
    self.m_lpBossCharacter = _lpCharacter
end
function CStage.getBoss( self )
    return self.m_lpBossCharacter
end
function CStage.setBossHp( self, _hp )
    if self.m_lpBossCharacter == nil then
        return
    end
    self.m_lpBossCharacter : setHP( _hp )
    _G.g_BattleView : updateDps()
end
function CStage.setBossHurtString( self, _hp )
    if self.m_lpBossCharacter == nil then
        return
    end
    self.m_lpBossCharacter : addHurtString( -_hp )
end
function CStage.getBossMaxHp( self )
    if self.m_lpBossCharacter == nil then
        return 1000000
    end
    return self.m_lpBossCharacter : getMaxHp()
end
function CStage.getDspContainer( self )
    return self.m_lpDPSContainer
end
function CStage.setDpsList( self, _dpsList )
    self.m_lpDpsList = _dpsList
    _G.g_BattleView : updateDps()
end
function CStage.getDpsList( self )
    return self.m_lpDpsList
end
function CStage.setSelfDps( self, _dps )
    self.m_nSelfDps = _dps
    _G.g_BattleView : updateDps()
end
function CStage.getSelfDps( self )
    return self.m_nSelfDps
end
function CStage.setBossVipRmb( self, _isOpen )
    self.m_bBossVipRmb = _isOpen
end
function CStage.getBossVipRmb( self )
    return self.m_bBossVipRmb
end



function CStage.reqStagePeople(self)
    local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_REQ_PLAYERS_NEW"])
    _G.controller : sendCommand( comm )
end

function CStage.isOnline( self )
    --是否在线模式
    if self.m_nLeaderUid ~= nil and self.m_nLeaderUid > 0 then
        return true
    end
    return false
end

function CStage.getCheckPointID( self )
    --关卡ID
    return self.m_nCheckPointID
end
function CStage.setCheckPointID( self, _nID )
    self.m_nCheckPointID = _nID
end

function CStage.getScenesID( self )
    return tonumber(self.m_lpScenesXML:getAttribute("scene_id"))
end
function CStage.getScenesCopyID( self )
    return tonumber(self.m_lpScenesXML:getAttribute("copy_id"))
end

function CStage.getScenesType( self )
    if self.m_lpScenesXML == nil then
        return
    end
    return tonumber(self.m_lpScenesXML:getAttribute("scene_type"))
end
function CStage.getScenesStartAction( self )
    return tonumber( self.m_lpScenesXML:getAttribute("is_matte") )
end

function CStage.getScenesPassType( self )
    return tonumber(self.m_lpScenesXML:getAttribute("pass_type"))
end
function CStage.getScenesPassValue( self )
    return tonumber(self.m_lpScenesXML:getAttribute("pass_value"))
end

function CStage.isMainPlay( self , _lpCharacter)
    if _lpCharacter == self : getPlay() then
        return true
    end
    return false
end

function CStage.getStartStageAction( self )
    return self.m_isStartStageAction
end

function CStage.getPlay( self )
    return self.m_lpPlay
end

function CStage.getRole( self )
    return self.m_lpPlay
end
function CStage.setRole( self, _lpCharacter )
    self : setPlay( _lpCharacter )
end
function CStage.setPlay( self, _lpCharacter )
    self.m_lpPlay = _lpCharacter
end

function CStage.getMapData( self )
    return self.m_lpMapData
end

function CStage.getMaplx( self )
    return self.m_nMaplx
end
function CStage.getMaprx( self )
    return self.m_nMaprx
end

function CStage.setCanControl( self, _canControl )
    self.m_canControl = _canControl
end
function CStage.getCanControl( self )
    return self.m_canControl
end

function CStage.exitCopy( self )
    print("1033副本类型，id====",self : getScenesType(),self : getScenesID())
    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        if _G.pStageMediator ~= nil then
            local property = _G.g_characterProperty : getChallengePanePlayInfo()
            local mainProperty = _G.g_characterProperty : getMainPlay()
            if property ~= nil and mainProperty ~= nil then
                local resTemp = 0
                local command = CStageREQCommand(_G.Protocol["REQ_ARENA_FINISH"])
                command : setOtherData({uid=property:getUid(),ranking=property:getRank(),res=resTemp})
                _G.controller : sendCommand( command )
            end
            _G.g_characterProperty : setChallengePanePlayInfo(nil)
            _G.pStageMediator : gotoScene(_G.g_nLastScenesID, _G.g_nLastX, _G.g_nLastY )
        else
            --CCMessageBox("pStageMediator == nil","ERROR")
            CCLOG("codeError!!!! pStageMediator == nil")
        end
    elseif  self : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        local comm = CStageREQCommand(_G.Protocol["REQ_WORLD_BOSS_EXIT_S"])
        _G.controller : sendCommand( comm )
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        print("发送出去")
        local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_CITY"])
        _G.controller : sendCommand( comm )
    elseif self : getScenesType() == _G.Constant.CONST_MAP_TYPE_KOF then --格斗之王
        print("发送出去")
        print("为什么是这样？")
        local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_CITY"])
        _G.controller : sendCommand( comm )
    else
        local comm = CStageREQCommand(_G.Protocol["REQ_COPY_COPY_EXIT"])
        _G.controller : sendCommand( comm )
    end
end

function CStage.registerEnterFrameCallBack(self,_isBattle)
    local function onEnterFrame( _duration )
        if self.m_lpScene ~= CCDirector : sharedDirector() : getRunningScene() then
            return
        end
        _G.pDateTime : reset()
        local nowTime = _G.pDateTime : getTotalMilliseconds() --毫秒数
        if _isBattle == true and self._isPlotIng == false and self.m_isStartStageAction == false then
            self : onProcessAI( _duration, nowTime )
        end
        if self.m_isStartStageAction == false then
            self : updateCharacter( _duration , nowTime )
        end
        self : showRemainingTime( _duration ,nowTime )
        self : autoHideCombo( nowTime )
        -- if _G.g_Logs ~= nil then
        --     _G.g_Logs : show( nowTime )
        -- end
        if _G.g_Marquee ~= nil then
            _G.g_Marquee : show( nowTime )
        end
        self : updateBossDeadTime( _duration, nowTime )
        if _G.g_pkReceiveManager ~= nil then
            _G.g_pkReceiveManager : update()
        end
        self : loadMap( nowTime )
        nowTime = nil
    end
    --self.m_lpContainer : scheduleUpdateWithPriorityLua( onEnterFrame, 1/10 )
    _G.g_ScheduleUpdateHandle =  _G.Scheduler : schedule( onEnterFrame, 1/30)
    onEnterFrame = nil
end

function CStage.updateCharacter( self, _duration, _nowTime )
    local list = _G.CharacterManager : getCharacter()
    if list == nil then
        return
    end
    for _,character in pairs(list) do
        character : onUpdate( _duration, _nowTime )
    end
end

function CStage.getUIContainerChild( self )
    return self.m_lpUIContainerChild
end
function CStage.getUIContainer( self )
    return self.m_lpUIContainer
end

function CStage.addStageMediator( self )
    --场景
    _G.pStageMediator = CStageMediator( self )
    _G.controller:registerMediator( _G.pStageMediator )

    --注册NPC mediator
    _G.pNpcMediator = CNpcMediator( self )
    _G.controller:registerMediator( _G.pNpcMediator )

    -- --日志
    -- _G.g_Logs = CLogs()
    -- _G.pLogsMediator = CLogsMediator( _G.g_Logs )
    -- _G.controller:registerMediator( _G.pLogsMediator )

    -- --跑马灯
    -- _G.g_Marquee = CMarquee()
    -- _G.pMarqueeMediator = CMarqueeMediator( _G.g_Marquee)
    -- _G.controller :registerMediator( _G.pMarqueeMediator)
end

function CStage.removeStageMediator( self )
    if _G.pStageMediator ~= nil then
        _G.controller:unregisterMediator( _G.pStageMediator )
        _G.pStageMediator = nil
    end

    if _G.pNpcMediator ~= nil then
        _G.controller:unregisterMediator( _G.pNpcMediator )
        _G.pNpcMediator = nil
    end

    -- if _G.pLogsMediator ~= nil then
    --     _G.controller:unregisterMediator( _G.pLogsMediator )
    --     _G.pLogsMediator = nil
    --     _G.g_Logs = nil
    -- end

    -- if _G.pMarqueeMediator ~= nil then --注销跑马灯
    --     _G.controller:unregisterMediator( _G.pMarqueeMediator )
    --     _G.pMarqueeMediator = nil
    --     _G.g_Marquee = nil
    -- end
end

function CStage.addKeyBoard( self )
    if _G.pKeyBoardView == nil then
        _G.pKeyBoardView = CKeyBoardView()
        _G.pKeyBoardMediator = CKeyBoardMediator( _G.pKeyBoardView )
        controller:registerMediator( _G.pKeyBoardMediator )

        self.m_lpKeyBoard = _G.pKeyBoardView:container()
        self.m_lpScene:addChild( self.m_lpKeyBoard ,200)
    end
end



function CStage.removeKeyBoard(self)
    if _G.pKeyBoardView ~= nil then
        --self.m_lpScene : removeChild( self.m_lpKeyBoard )
        if self.m_lpKeyBoard ~= nil then
            self.m_lpKeyBoard : removeFromParentAndCleanup( true )
        end
        self.m_lpKeyBoard = nil

        controller : unregisterMediator(_G.pKeyBoardMediator)
        _G.pKeyBoardMediator = nil
        _G.pKeyBoardView = nil
    end
end

function CStage.removeKeyBoardAndJoyStick( self )
    self : removeKeyBoard()
    self : removeJoyStick()
    if self.m_lpPlay ~= nil then
        self.m_lpPlay : cancelMove()
    end
end

function CStage.addJoyStick( self )
    _G.pJoyStick = nil
    _G.pJoyStick = CJoyStick:create("joyStick_Background.png", "joyStick_Stick.png", "joyStick_Stick_bottom_drop_02.png");
    pJoyStick : setFireMode(eJSTM_Fixed);--eJSTM_Fixed eJSTM_HalfScreenTouchPoint
    pJoyStick : setMaxRadius(175.9+175.9/2)
    pJoyStick : setMaxStickRadius(99.9)
    pJoyStick : setAutoHide(false)
    pJoyStick : setFireInterval(1/4.0)
    --local winSize = CCDirector:sharedDirector():getVisibleSize()
    pJoyStick : setFirePosition(ccp(175,175))

    self.m_lpScene : addChild(_G.pJoyStick, 100000)

    local tipsSprite = nil
    local tipsSpriteFram = nil
    if _G.g_LoginInfoProxy:getFirstLogin() == true and _G.g_Stage : getCheckPointID() == 1 and _G.g_FirstCaoZuoZhiyinIndex == 1 then
        tipsSprite = CSprite : create("FirstWarResources/first_tips_hand.png")
        tipsSprite : setAnchorPoint(ccp(0,0))
        local tipsSpriteSize = tipsSprite : getPreferredSize()
        tipsSprite : setPosition(ccp(175+tipsSpriteSize.width/2,175-tipsSpriteSize.height/2))
        tipsSpriteFram = CSprite : create("FirstWarResources/first_tips_fram.png")
        local ttfString = CCLabelTTF : create( "触碰方向键移动", "Marker Felt", 21 )
        tipsSpriteFram : addChild( ttfString )
        _G.pJoyStick : addChild( tipsSpriteFram )
        tipsSpriteFram : setPosition(ccp(175,175+120))
        _G.pJoyStick : addChild( tipsSprite,1000 )

        local _pEffictsBtn = self :getEffictsByTag( 1 )
        if _pEffictsBtn ~= nil then
            _pEffictsBtn :setPosition( ccp(175,175) )
            _G.pJoyStick :addChild( _pEffictsBtn, 500 )
        end

        local _pEffictsFrame = self :getEffictsByTag( 3 )
        if _pEffictsFrame ~= nil then
            tipsSpriteFram :addChild( _pEffictsFrame, 50 )
        end

        local act1 = CCMoveBy:create(0.8,ccp(30,0))
        local _callBacks = CCArray:create()
        _callBacks:addObject(act1)
        _callBacks:addObject(act1 : reverse() )
        tipsSprite:runAction( CCRepeatForever : create( CCSequence:create(_callBacks) ) )

    end

    local function delayRemoveSprite()
        if tipsSprite ~= nil and tipsSpriteFram ~= nil then
            for k=1, 3 do
                self :removeEffictsByTag( k )
            end

            tipsSprite : removeFromParentAndCleanup( true )
            tipsSpriteFram : removeFromParentAndCleanup( true )
            tipsSprite = nil
            tipsSpriteFram = nil
        end
    end
    --(事件类型, 弧度, 半径)
    local function callBack(eventType, radian, radius)
        if self : getPlay() : getHP() <= 0 then
            return
        end
        --过场玩家失去控制
        if eventType ==  "JoyStickCallBack" then
            if self : getCanControl() == false or self.m_isStartStageAction == true then
                return
            end
            if radius <= 0 then
                return
            end
            local characterPosX,characterPosY = self.m_lpPlay : getLocationXY()
            local x = characterPosX - 200 * math.cos(radian)
            local y = characterPosY - 200 * math.sin(radian)
            self.m_lpPlay : setMovePos(ccp(x,y))
            if tipsSprite ~= nil and tipsSpriteFram ~= nil then
                local a1 = CCDelayTime:create(1.0)
                local drs = CCCallFunc:create(delayRemoveSprite)
                local actarr = CCArray:create()
                actarr:addObject(a1)
                actarr:addObject(drs)
                local seq = CCSequence:create(actarr)
                tipsSprite:runAction( seq )

                -- tipsSprite : removeFromParentAndCleanup( true )
                -- tipsSpriteFram : removeFromParentAndCleanup( true )
                if _G.g_LoginInfoProxy:getFirstLogin() == true and _G.g_FirstCaoZuoZhiyinIndex == 1 and _G.g_Stage : getCheckPointID() == 1 then
                    _G.g_FirstCaoZuoZhiyinIndex = _G.g_FirstCaoZuoZhiyinIndex + 1
                    _G.pKeyBoardView : jumpTips()
                end
                -- tipsSprite = nil
                -- tipsSpriteFram = nil
            end
        elseif eventType == "JoyStickEnded" then
            if self : getCanControl() == false or self.m_isStartStageAction == true then
                return
            end
            self.m_lpPlay : cancelMove()
        end
    end

    _G.pJoyStick : registerControlScriptHandler(callBack, "this CStage _G.pJoyStick 388")
    callBack = nil
    return true;
end

function CStage.getEffictsByTag( self, _tag )
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

function CStage.removeEffictsByTag( self, _tag )
    if _tag ~= nil and self[ "m_lpEfficts" .. _tag ] ~= nil then
        self[ "m_lpEfficts" .. _tag ] :removeFromParentAndCleanup( true )
        self[ "m_lpEfficts" .. _tag ] = nil
    end
end


function CStage.removeJoyStick( self )
    if _G.pJoyStick ~= nil then
        print("111")
        _G.pJoyStick : removeFromParentAndCleanup( true )
        print("222")
        _G.pJoyStick = nil
    end
end

function CStage.initMapPos( self,_x,_y )
    --初始化地图位置
    self : moveArea(_x,_y)
    --self : loadMap()

end

function CStage.loadMap( self, nowTime )
    if self.m_lpContainer == nil then
        CCLOG("This is CStage loadMap  self.m_lpContainer == nil")
        return
    end

    if self.m_nLoadMapTime + 330 > nowTime then
        return
    end
    self.m_nLoadMapTime = nowTime
    local y = self.winSize.height / 2
    local winPiece = self.winSize.width / 6
    local currPosX, currPosY = self.m_lpContainer : getPosition()
    local currLeftX = math.abs(currPosX)
    local winRect = CCRect( currLeftX - winPiece , 0, self.winSize.width + winPiece * 2, self.winSize.height )

    local currDisPosX, currDisPosY = self.m_lpMapDisContainer : getPosition()
    local currDisLeftX = math.abs(currDisPosX)
    local winDisRect = CCRect( currDisLeftX - winPiece , 0, self.winSize.width + winPiece * 2, self.winSize.height )


    local function loc_hidMap( _index, _path, _lpPieceWidth, _spriteArray, _container, _winRect )
        local pieceX = 0
        -- for i=1,_index do
        --     pieceX = pieceX + _lpPieceWidth
        -- end
        pieceX = _index * _lpPieceWidth
        pieceX = pieceX - _lpPieceWidth
        local pieceRect = CCRect(pieceX, 0, _lpPieceWidth, self.winSize.height )
        if _spriteArray[_index] == nil and _winRect : intersectsRect( pieceRect ) then
            local x = pieceX + _lpPieceWidth / 2
            local mapSprite = CSprite : create( _path )
            mapSprite : setPosition( x , y )
            _container : addChild( mapSprite )
            _spriteArray[_index] = mapSprite
        else
            if _spriteArray[_index] ~= nil and _winRect:intersectsRect(pieceRect) == false then
                _container : removeChild(_spriteArray[_index])
                _spriteArray[_index] = nil
            end
        end
    end


    for index,path in pairs( self.m_lpMapData : getMapPiece() ) do
        loc_hidMap( index, path, self.m_lpMapData:getPieceWidth(), self.m_lpArrayMapSprite, self.m_lpMapContainer, winRect )
    end
    -- for index,path in pairs( self.m_lpMapData : getMapDisPiece() ) do
    --     loc_hidMap( index, path, self.m_lpMapData:getMapDisPieceWidth(), self.m_lpArrayMapDisSprite, self.m_lpMapDisContainer, winDisRect )
    -- end
    loc_hidMap = nil
end


    -- local function loc_hidMap( _index, _path, _lpPieceWidth, _spriteArray, _container, _winRect )
    --     local pieceX = 0
    --     for i=1,_index do
    --         pieceX = pieceX + _lpPieceWidth[i]
    --     end
    --     pieceX = pieceX - _lpPieceWidth[_index]
    --     local pieceRect = CCRect(pieceX, 0, _lpPieceWidth[_index], self.winSize.height )
    --     if _spriteArray[_index] == nil and _winRect : intersectsRect( pieceRect ) then
    --         local x = pieceX + _lpPieceWidth[_index] / 2
    --         local mapSprite = CCSprite : create( _path )
    --         mapSprite : setPosition( x , y )
    --         _container : addChild( mapSprite )
    --         _spriteArray[_index] = mapSprite
    --     else
    --         if _spriteArray[_index] ~= nil and _winRect:intersectsRect(pieceRect) == false then
    --             _container : removeChild(_spriteArray[_index])
    --             _spriteArray[_index] = nil
    --         end
    --     end
    -- end



-- function CStage.loadMap( self )
--     if self.m_lpContainer == nil then
--         CCLOG("This is CStage loadMap  self.m_lpContainer == nil")
--         return
--     end

--     local director = CCDirector :sharedDirector()
--     local winSize = director : getWinSize();
--     local y = winSize.height / 2
--     local currPosX, currPosY = self.m_lpContainer : getPosition()
--     self.m_fMapMaxX = self.m_lpMapData : getWidth()


--     local leftShowX = math.abs(currPosX)
--     local rightShowX =  leftShowX + winSize.width
--     local pieceWidth = self.m_lpMapData : getPieceWidth()

--     local function loc_hidMap( index ,path)
--         local winRect = CCRect( leftShowX-pieceWidth/2, 0, winSize.width+pieceWidth, winSize.height )
--         pieceRect = CCRect((index-1)*pieceWidth, 0, pieceWidth, winSize.height )
--         if self.m_lpArrayMapSprite[index] == nil and winRect:intersectsRect(pieceRect) then
--             local x = (index-0.5) * pieceWidth
--             local mapSprite = CCSprite : create( path )
--             mapSprite : setPosition( x , y )
--             self.m_lpMapContainer : addChild( mapSprite )
--             self.m_lpArrayMapSprite[index] = mapSprite
--         else
--             if self.m_lpArrayMapSprite[index] ~= nil and winRect:intersectsRect(pieceRect) == false then
--                 self.m_lpMapContainer : removeChild(self.m_lpArrayMapSprite[index])
--                 self.m_lpArrayMapSprite[index] = nil
--             end
--         end
--     end
--     for k,v in pairs( self.m_lpMapData : getMapPiece() ) do
--         loc_hidMap(k,v)
--     end
-- end

function CStage.addCharacter( self, _lpPlayer )
    if self.m_lpCharacterContainer == nil then
        CCMessageBox("addCharacter","addCharacter,ERROR")
        CCLOG("codeError!!!! addCharacter".."addCharacter,ERROR")
        return
    end
    local x,y = _lpPlayer : getLocationXY()
    if _lpPlayer : getContainer():getParent() ~= self.m_lpCharacterContainer then
        _lpPlayer : getContainer() : removeFromParentAndCleanup(false)
        self.m_lpCharacterContainer : addChild( _lpPlayer : getContainer() , -y )
    end
    characterType = _lpPlayer : getType()
    if characterType == _G.Constant.CONST_TRANSPORT then --假如是传送点
        _lpPlayer : setZOrder( -100000 )
    end
    _G.CharacterManager : add( _lpPlayer )
    _lpPlayer : setStage( self )

end

function CStage.removeCharacter( self, _lpPlayer )
    -- if _lpPlayer : getContainer():getParent() == self.m_lpCharacterContainer then
    --     self.m_lpCharacterContainer : removeChild( _lpPlayer : getContainer(), false )
    -- end
    _G.CharacterManager : remove( _lpPlayer )
    local mapType =  self : getScenesType()
    if _lpPlayer == self : getPlay()  then
        if mapType == _G.Constant.CONST_MAP_TYPE_COPY_NORMAL
            or mapType == _G.Constant.CONST_MAP_TYPE_COPY_HERO
            or mapType == _G.Constant.CONST_MAP_TYPE_COPY_FIEND
            or mapType == _G.Constant.CONST_MAP_TYPE_COPY_FIGHTERS then
            self : copyLose()
            return
        end
    end
    if  mapType == _G.Constant.CONST_MAP_TYPE_COPY_NORMAL
        or mapType == _G.Constant.CONST_MAP_TYPE_COPY_HERO
        or mapType == _G.Constant.CONST_MAP_TYPE_COPY_FIEND
        or  mapType == _G.Constant.CONST_MAP_TYPE_COPY_FIGHTERS then
        if _lpPlayer : getType() == _G.Constant.CONST_MONSTER and _G.CharacterManager: isMonsterEmpty() == true and self : getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY  then
            --怪物被清除
            self : runNextCheckPoint()
        end
    elseif mapType == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then -- 竞技场
        local property = _G.g_characterProperty : getChallengePanePlayInfo()
        local mainProperty = _G.g_characterProperty : getMainPlay()
        if property ~= nil and mainProperty ~= nil then
            if mainProperty : getUid() == _lpPlayer : getID() or property : getUid() == _lpPlayer : getID() then
                local resTemp = 1
                if _lpPlayer == self: getPlay() then
                    resTemp = 0
                end
                local command = CStageREQCommand(_G.Protocol["REQ_ARENA_FINISH"])
                command : setOtherData({uid=property:getUid(),ranking=property:getRank(),res=resTemp})
                _G.controller : sendCommand( command )
                _G.g_characterProperty : setChallengePanePlayInfo( nil )

                --删除伙伴
                local masterProperty = mainProperty
                if property : getUid() == _lpPlayer : getID() then
                    masterProperty = property
                end
                local listPartner = masterProperty : getPartner()
                for _,Partner_id in pairs(listPartner) do
                    local indexID = tostring(masterProperty : getUid())..tostring(Partner_id)
                    local tempCharacter = _G.CharacterManager : getCharacterByTypeAndID( _G.Constant.CONST_PARTNER, indexID )
                    if tempCharacter ~= nil then
                        tempCharacter : setHP(0)
                    end
                end

            end
        end
    elseif mapType == _G.Constant.CONST_MAP_TYPE_BOSS or mapType == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then --世界BOSS

        local property = _G.g_characterProperty : getChallengePanePlayInfo()
        local mainProperty = _G.g_characterProperty : getMainPlay()
        if mainProperty : getUid() == _lpPlayer : getID() then
            local command = CStageREQCommand(_G.Protocol["REQ_WORLD_BOSS_WAR_DIE"])
            --_G.controller : sendCommand( command )
            -- _G.g_BattleView : showBossDeadView()
        end
        local bossCharacter = self : getBoss()
        if _lpPlayer == bossCharacter then
            self : addBossOverTips("BOSS已被击杀，本次活动结束，请查看邮件奖励")
        end
    else --其他副本类型
        --自己的伙伴死亡
        local characterType = _lpPlayer : getType()
        if characterType == _G.Constant.CONST_PARTNER then
            local property = _G.g_characterProperty : getOneByUid( _lpPlayer : getID(), characterType )
            if property ~= nil and property : getUid() == _G.g_characterProperty : getMainPlay() : getUid() then
                local command = CStageREQCommand(_G.Protocol["REQ_SCENE_DIE_PARTNER"])
                command : setOtherData({partner_id= property : getPartner()})
                _G.controller : sendCommand( command )
            end
        end
    end



    _lpPlayer : releaseResource()


    local characterType = _lpPlayer : getType()
    if characterType == _G.Constant.CONST_MONSTER then
        local monsterRank = _lpPlayer : getMonsterRank()
        if monsterRank ~= nil and monsterRank >= _G.Constant.CONST_MONSTER_RANK_BOSS_SUPER then
            local list = _G.CharacterManager : getMonster()
            for _,monsterC in pairs(list) do
                monsterC : setHP(0)
            end
        end
    end
end

function CStage.slowMotion( self )
    local function CallbackFun(  )
        local lpScheduler = CCDirector:sharedDirector():getScheduler()
        lpScheduler : setTimeScale(_G.Constant.CONST_BATTLE_END_SHOWDOWN)
        -- local array = self : getArrayMapSprite()
        -- for _,v in pairs(array) do
        --     v : shaderDotColor(1255,1255,1255,255)
        -- end
        local layerColor = CCLayerColor:create(ccc4(255, 255, 255, 255))
        local szie = CCSizeMake( self.winSize.width*4, self.winSize.height )
        layerColor : setContentSize(szie)
        layerColor : setPosition(self : convertStageSpace( ccp(-self.winSize.width*2,0)))
        self.m_lpContainer : addChild( layerColor, 101 )

        local function callbacksetTimeScale(  )
            lpScheduler : setTimeScale(1)
            -- for _,v in pairs(array) do
            --     v : shaderResetNull()
            -- end
            layerColor : removeFromParentAndCleanup( true )
            _G.CNetwork : resume()
        end
        _G.Scheduler : performWithDelay( _G.Constant.CONST_BATTLE_END_SHOWTIME, callbacksetTimeScale )
        callbacksetTimeScale = nil
    end


    _G.CNetwork : pause()
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/KO.mp3", false)
    end

    local koCCbi = CMovieClip : create("CharacterMovieClip/effects_ko.ccbi")
    koCCbi : setPosition(self.winSize.width/2,self.winSize.height/2)
    self.m_lpScene : addChild( koCCbi, 10000 )
    koCCbi : play("run")
    local function finishCCBI( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "AnimationComplete" and arg0 == "run" then
            koCCbi : removeFromParentAndCleanup( true )
        end
    end
    koCCbi : registerControlScriptHandler( finishCCBI )
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(0))
    _callBacks:addObject(CCCallFunc:create(CallbackFun))
    self.m_lpScene : runAction( CCSequence:create(_callBacks) )

end


function CStage.getArrayMapSprite( self )
    return self.m_lpArrayMapSprite
end

--{副本失败}
function CStage.copyLose( self )
    local command = CStageREQCommand(_G.Protocol["REQ_SCENE_DIE"])
    _G.controller : sendCommand( command )
    self : removeKeyBoardAndJoyStick()
end

function CStage.runNextCheckPoint( self )
    local currentCheckpoint = self : getCheckPointID()
    local nextCheckpoint = currentCheckpoint + 1
    local scenesID  = self : getScenesID()
    print("nextCheckpoint",nextCheckpoint)
    local nextXmlCheckpoint = _G.StageXMLManager : getXMLScenesCheckpoint( scenesID, nextCheckpoint )
    if nextXmlCheckpoint == nil or nextXmlCheckpoint:isEmpty() then
        -- 找不到下个关卡,即通关
        self : passWar()
        --CCMessageBox("哇, 屌丝,你完成了任务了","Message")
        return
    end
    self : setCanControl( false )

    local moveToX = tonumber(nextXmlCheckpoint:getAttribute("born_x"))
    --取消之前的动作,和BUFF
    for _,character in pairs( _G.CharacterManager : getCharacter() ) do
        local characterType = character : getType()
        if characterType == _G.Constant.CONST_PET or
        characterType == _G.Constant.CONST_PLAYER or
        characterType == _G.Constant.CONST_PARTNER then

            character : cancelMove()
            character : setXSpeedZero()
            local x,y = character : getLocationXY()
            if x < moveToX then
                character : setMovePos( ccp( moveToX, y ) )
            end
        end
    end

    local lx = tonumber(nextXmlCheckpoint:getAttribute("lx"))

    local mapMaxLx = self: getMapData(): getWidth() - self.winSize.width
    if lx > mapMaxLx then
        lx = mapMaxLx
    end
    local ContainerX, ContainerY = self.m_lpContainer : getPosition()
    local characterDistance = ccpDistance( ccp(ContainerX, ContainerY), ccp( -lx, 0 ) )
    local distanceTime = characterDistance / _G.Constant.CONST_INIT_MOVE_X_SPEED
    --移动场景
    local function move()
        self : finishMoveCheckpoint()
    end

    local arry = CCArray:create()
    arry : addObject( CCMoveTo:create( distanceTime, ccp( -lx, 0 ) ) )
    arry : addObject( CCCallFuncN:create( move )    )
    local action = CCSequence:create(arry)

    self.m_lpContainer : runAction( action )

    self : setCheckPointID( nextCheckpoint )

    if _G.g_LoginInfoProxy : getFirstLogin() == true then
        --注册手柄事件

        self : removeKeyBoardAndJoyStick()
        self : addJoyStick()
        self : addKeyBoard()
    end

    local currentCheckpoint = self : getCheckPointID()
    local scenesID  = self : getScenesID()
    --添加当前怪物
    local property = _G.g_characterProperty : getMainPlay()
    if property : getIsTeam() == false then
        _G.StageXMLManager : addMonster( scenesID, currentCheckpoint )
    end
    move = nil
end

function CStage.passWar( self )
    --通关 发放奖励之类的

    local property = _G.g_characterProperty : getMainPlay()
    if property : getIsTeam() == false then

        --陈元杰   添加剧情判断  Start  ææææææææææææææææ
        local copyId   = tonumber(self.m_lpScenesXML:getAttribute("copy_id"))
        local plotData = _G.pCPlotManager :checkPlotHas( _G.Constant.CONST_DRAMA_FINISHE,copyId )
        if plotData ~= false then
            local function local_finishCopy( )
                return self:finishCopy()
            end
            _G.pCPlotManager :showPlot( plotData, local_finishCopy )
            local_finishCopy = nil
            return
        end
        --陈元杰   添加剧情判断  End    ææææææææææææææææ

        self: finishCopy()
    end
end

function CStage.addHitTimes( self )
    self.hit_times = self.hit_times + 1
end
function CStage.addMonsHp( self, _hp )
    self.mons_hp = self.mons_hp + _hp
end
function CStage.finishCopy( self )
    self : copy_fighters()
    local comm = CStageREQCommand(_G.Protocol["REQ_COPY_NOTICE_OVER"])

    local data = { hit_times = self.hit_times,
                    carom_times = self.carom_times,
                    mons_hp = self.mons_hp}
    comm : setOtherData( data )
    _G.controller : sendCommand( comm )
end

function CStage.copy_fighters( self )
    --如果是拳皇生涯的副本.则保留当前所有血量
    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_COPY_FIGHTERS then
        local play = self : getRole()
        local playHp = play : getHP()
        local mainProperty = _G.g_characterProperty : getMainPlay()
        mainProperty : getAttr() : setHp(playHp)
        local partnerID_List = mainProperty : getPartner()
        for k,partnerID_Property in pairs(partnerID_List) do
            local index = tostring(mainProperty : getUid())..tostring(partnerID_Property)
            local partnerCharacter = _G.CharacterManager : getCharacterByTypeAndID(_G.Constant.CONST_PARTNER,index)
            local partnerProperty = _G.g_characterProperty : getOneByUid( index ,_G.Constant.CONST_PARTNER)
            if partnerCharacter ~= nil then
                if partnerProperty ~= nil then
                    partnerProperty : getAttr() : setHp( partnerCharacter : getHP() )
                end
            else
                if partnerProperty ~= nil then
                    partnerProperty : getAttr() : setHp( 0 )
                end
            end
        end
    end
end

function CStage.finishMoveCheckpoint( self )
    --自动滚动地图后
    local currentCheckpoint = self : getCheckPointID()
    local scenesID  = self : getScenesID()

    --放开控制
    self : setCanControl( true )
    local currentXmlCheckpoint  = _G.StageXMLManager : getXMLScenesCheckpoint( scenesID, currentCheckpoint )
    if currentXmlCheckpoint:isEmpty() then
        CCLOG("codeError!!!! this is stage fun :finishMoveCheckpoint currentXmlCheckpoint is nil ")
    end

    self.m_nMaplx = tonumber(currentXmlCheckpoint:getAttribute("lx"))
    self.m_nMaprx = tonumber(currentXmlCheckpoint:getAttribute("rx"))
end

function CStage.addMap( self, _lpMap )
    self : removeMap( _lpMap )
    self.m_lpMapContainer : addChild( _lpMap )
end

function CStage.removeMap( self, _lpMap )
    self.m_lpMapContainer : removeChild( _lpMap )
end

function CStage.convertStageSpace( self, _ccpPos ) -- ccp()
    --转换成舞台坐标
    return self.m_lpContainer : convertToNodeSpace( _ccpPos )
end

function CStage.moveArea( self, characterPosX,characterPosY  )

    if self.m_lpContainer == nil then
        return
    end
    -- if self : getCanControl() == false then
    --     return
    -- end
    local director = CCDirector :sharedDirector()
    local winSize = director : getWinSize()
    local winSizePiece = winSize.width/5
    local winSizeLPiece = winSize.width/5*4
    if self : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        winSizePiece = winSize.width / 2
        winSizeLPiece = winSize.width / 2
    end

    --local characterPosX,characterPosY = self.m_lpPlay : getLocationXY()
    local mapX,mapY = self.m_lpContainer : getPosition()
    local characterWinPos = ccp(characterPosX + mapX , characterPosY)

    local mapMaxLx = self: getMapData(): getWidth() - winSize.width

    local lx = self : getMaplx()
    local rx = self : getMaprx()

    if characterWinPos.x < winSizePiece then
        local moveX = winSizePiece - characterWinPos.x
        mapX = mapX + moveX
        mapX = mapX > -lx and -lx or mapX
    end
    if characterWinPos.x >  winSizeLPiece then
        local moveX = characterWinPos.x - winSizeLPiece
        mapX = mapX - moveX
        local rmaxX = -(rx - winSize.width)
        mapX = mapX < rmaxX  and rmaxX or mapX
    end
    self.m_lpContainer : setPosition( mapX, mapY )

    -- local mapXPercent = mapX / self: getMapData(): getWidth()
    -- local mapDisX = self : getMapData() : getDisWidth() * mapXPercent
    -- self.m_lpMapDisContainer : setPosition( mapDisX, 0 )

    --self : loadMap()
end

function CStage.onRoleMove( self, _lpCharacter, _fx, _fy, _fz, _isNew, _isStop )
    --人物移动时 发送数据到服务端
    _isNew = false
    local property = _G.g_characterProperty : getOneByUid( _lpCharacter : getID(), _lpCharacter : getType() )
    if property == nil then
        return
    end
    if _lpCharacter ~= self.m_lpPlay and property : getUid() ~= self.m_lpPlay : getID() then
        return
    end
    local copyType = self : getScenesType()
    if property : getIsTeam() == false and
        ( copyType == _G.Constant.CONST_MAP_TYPE_COPY_NORMAL
            or copyType == _G.Constant.CONST_MAP_TYPE_COPY_HERO
            or copyType == _G.Constant.CONST_MAP_TYPE_COPY_FIEND
            or copyType == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL) then
        return
        --没有组队.并且是普通,英雄,魔王副本.就不发送
    end
    local comm = nil
    if _isNew == true then
        comm = CStageREQCommand(_G.Protocol["REQ_SCENE_MOVE_NEW"])
    else
        comm = CStageREQCommand(_G.Protocol["REQ_SCENE_MOVE"])
    end

    local data = {}
    data.x = _fx
    data.y = _fy
    CCLOG("onRoleMove ".._fx.."    ".._fy)
    data.uid = self.m_lpPlay : getID()
    data.characterType = _lpCharacter : getType()
    if _fz > 0 then
        data.move_type = _G.Constant.CONST_MAP_MOVE_JUMP
    else
        data.move_type = _G.Constant.CONST_MAP_MOVE_MOVE
    end
    if _isStop == true then
        data.move_type = _G.Constant.CONST_MAP_MOVE_STOP
    end

    _G.pDateTime : reset()
    local nowTime = _G.pDateTime : getTotalMilliseconds() --毫秒数
    if self.m_nLastRoleMove + 330 < nowTime or _isStop == true then
        comm : setOtherData( data )
        controller : sendCommand( comm )
        self.m_nLastRoleMove = nowTime
    end
    data = nil
    comm = nil
end

function CStage.checkCollisionNPC( self, _lpCharacter, _fx, _fy )
    --检查 进入NPC区域
    if _lpCharacter ~= self.m_lpPlay then
        return
    end
    local npcList = _G.CharacterManager : getNpc()
    if npcList ~= nil then
        for k,npcCharacter in pairs( npcList ) do
            npcCharacter : onRoleEnter( _fx, _fy )
            npcCharacter : onRoleExit( _fx, _fy )
        end
    end
    local transportList = _G.CharacterManager : getTransport()
    if transportList ~= nil then
        for k,transporCharacter in pairs( transportList ) do
            transporCharacter : onRoleEnter( _fx, _fy )
            transporCharacter : onRoleExit( _fx, _fy )
        end
    end
end

function CStage.onProcessAI( self , _duration, _nowTime )
    --AI回调
    local list = _G.CharacterManager : getCharacter()
    if list == nil then
        return
    end
    for _,character in pairs(list) do
        if character.think ~= nil then
            character : think(_nowTime)
        end
    end
end

--{ 副本剩余时间 }
function CStage.setRemainingTime( self, _time )
    self.m_nRemainingTime = _time
end
function CStage.showRemainingTime( self, _duration , _nowTime )
    if self.m_nRemainingTime == nil or self.m_nRemainingTime <= 0 then
        return
    end
    self.m_nRemainingTime = self.m_nRemainingTime - _duration
    self.m_lpRemainingTimeContainer : removeAllChildrenWithCleanup( true )
    _G.g_BattleView : showRemainingTime( self.m_nRemainingTime, self.m_lpRemainingTimeContainer )
    if self.m_nRemainingTime <= 0 then
        self : timeOut()
    end
end

--{超出时间处理}
function CStage.timeOut( self )
    self.m_nRemainingTime = nil
    local sceneType = self : getScenesType()
    if sceneType == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        local mainPlay = _G.g_Stage : getPlay()
        mainPlay : setHP(0)
    elseif sceneType == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        self : addBossOverTips("时间不足,挑战失败")
    end



    local passType = self : getScenesPassType()
    if passType == _G.Constant.CONST_COPY_PASS_ALIVE then
        local list = _G.CharacterManager : getMonster()
        for _,monsterC in pairs(list) do
            monsterC : setHP(0)
        end
    elseif passType == _G.Constant.CONST_COPY_PASS_TIME and _G.CharacterManager:isMonsterEmpty() == false then
        local mainPlay = _G.g_Stage : getPlay()
        mainPlay : setHP(0)
    else
        self : finishCopy()
    end

end
--{更新复活时间}
function CStage.updateBossDeadTime( self, _duration, _nowTime )
    local deadTime = self : getBossDeadTime()
    if deadTime == nil or deadTime <= 0 then
        return
    end
    deadTime = deadTime - _duration
    deadTime = deadTime <=0 and 0 or deadTime
    _G.g_BattleView : showBossDeadViewString( deadTime )
    self : setBossDeadTime( deadTime )
    if deadTime <= 0 then
        --自动复活
        local command = CStageREQCommand(_G.Protocol["REQ_WORLD_BOSS_REVIVE"])
        command : setOtherData({type=0})
        _G.controller : sendCommand( command )
    end
end

function CStage.addBossOverTips( self, _tipsString )
    require "view/ErrorBox/ErrorBox"
    local errorBox = CErrorBox()
    local function okFunc(  )
        self : exitCopy()
    end
    local BoxLayer = errorBox : create( _tipsString, okFunc )
    okFunc = nil
    self.m_lpMessageContainer : addChild( BoxLayer )
end

--开场动画
function CStage.runStrartStageAction( self )
    local actionTime = self : getScenesStartAction()
    if actionTime == nil or actionTime == 0 then
        actionTime = self.m_BossTime
    end
    if actionTime == nil or actionTime == 0 then
        return
    end
    self.m_isStartStageAction = true
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General_battle.plist")
    self.m_startStageActionTime = actionTime
    local function run(  )
        local timeString = tostring(self.m_startStageActionTime)
        self.m_startStageActionTime = self.m_startStageActionTime - 1
        local container = CContainer :create()
        local width = 0
        if timeString ~= "0" then
            local length = string.len( timeString )
            for i=1, length do
                local sprite = CSprite:createWithSpriteFrameName("battle_countdown_0"..string.sub(timeString,i,i)..".png")
                spriteSize = sprite : getPreferredSize()
                sprite : setPosition(width + spriteSize.width / 2,0)
                width = width + spriteSize.width
                container : addChild( sprite )
            end
        else
            local sprite = CSprite:createWithSpriteFrameName("battle_countdown_go.png")
            spriteSize = sprite : getPreferredSize()
            container : addChild( sprite )
        end
        local function delself(  )
            print(" 如果 见不到 下面 有 delself 就报错，找卢炳坚")
            container : removeFromParentAndCleanup( true )
            print("aaaaa fuck  delself")
        end
        local function changeThink(  )
            delself()
            self.m_isStartStageAction = false
        end
        self.m_lpScene : addChild( container, 10000 )
        container : setPosition( self.winSize.width / 2 - width / 2 , self.winSize.height / 2)
        local _callBacks = CCArray:create()
        _callBacks:addObject( CCDelayTime:create( 1 ) )
        if timeString ~= "0" then
            _callBacks:addObject(CCCallFunc:create(delself))
        else
            _callBacks:addObject(CCCallFunc:create(changeThink))
        end
        self.m_lpScene:runAction( CCSequence:create(_callBacks) )

        container : setScale(10)
        local scaleAct = CCScaleTo : create(0.15, 1)
        container : runAction( scaleAct )
    end

    for i = actionTime,0, -1 do
        local _callBacks = CCArray:create()
        _callBacks:addObject( CCDelayTime:create( math.abs( i - actionTime ) ) )
        _callBacks:addObject(CCCallFunc:create(run))
        self.m_lpScene:runAction( CCSequence:create(_callBacks) )
    end
    run = nil
end

