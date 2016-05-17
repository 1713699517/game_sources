require "mediator/mediator"

require "proxy/SkillDataProxy"
require "proxy/CharacterPropertyProxy"
require "proxy/SystemSettingProxy"

require "controller/KeyBoardCommand"
require "controller/StageREQCommand"
require "controller/SkillDataCommand"
require "controller/CharacterUpadteCommand"
require "controller/GotoSceneCommand"
require "controller/FlyItemCommand"


require "view/KeyBoard/KeyBoardView"
require "view/Stage/CharacterManager"
require "view/Loading/Loading"
require "view/Character/Player"
require "view/ChallengePanelLayer/ChallengePanelView"
require "view/ChallengePanelLayer/ArenaFinishView"
require "view/DuplicateLayer/DeadCopyView"
require "view/Stage/PKReceiveManager"


require "view/XmlManager/SkillXmlManager"
require "view/XmlManager/SkillEffectXmlManager"
require "view/XmlManager/SkillColliderXmlManager"


require "common/Scheduler"
require "common/MessageProtocol"
require "common/protocol/auto/ACK_SCENE_ENTER_OK"
require "common/protocol/auto/REQ_SCENE_ENTER_FLY"
require "common/protocol/auto/REQ_SCENE_ENTER"
require "common/protocol/auto/REQ_SCENE_REQUEST_PLAYERS"
require "common/protocol/auto/REQ_SCENE_REQ_PLAYERS_NEW"

require "common/protocol/auto/REQ_SCENE_REQUEST_MONSTER"
require "common/protocol/auto/REQ_SCENE_MOVE"
require "common/protocol/auto/REQ_SCENE_CAROM_TIMES"
require "common/protocol/auto/REQ_SCENE_KILL_MONSTER"
require "common/protocol/auto/REQ_SCENE_HIT_TIMES"
require "common/protocol/auto/REQ_SCENE_DIE"
require "common/protocol/auto/REQ_COPY_COPY_EXIT"
require "common/protocol/auto/REQ_COPY_NOTICE_OVER"
require "common/protocol/auto/REQ_ARENA_BATTLE"
require "common/protocol/auto/REQ_ARENA_FINISH"
require "common/protocol/auto/REQ_WORLD_BOSS_DATA"
require "common/protocol/auto/REQ_WORLD_BOSS_EXIT_S"
require "common/protocol/auto/REQ_WORLD_BOSS_REVIVE"
require "common/protocol/auto/REQ_WAR_HARM"
require "common/protocol/auto/REQ_WAR_HARM_NEW"
require "common/protocol/auto/REQ_WORLD_BOSS_WAR_DIE"
require "common/protocol/auto/REQ_WAR_USE_SKILL"
require "common/protocol/auto/REQ_SCENE_DIE_PARTNER"
require "common/protocol/auto/REQ_SCENE_MOVE_NEW"
require "common/protocol/auto/REQ_SCENE_RELIVE_REQUEST"
require "common/protocol/auto/REQ_WAR_PK"
require "common/protocol/auto/REQ_WAR_PK_REPLY"
require "common/protocol/auto/REQ_WAR_PK_CANCEL"
require "common/protocol/auto/REQ_SCENE_ENTER_CITY"



CStageMediator = class(mediator, function(self, _view)
    self.name = "StageMediator"
    self.view = _view
end)

function CStageMediator.processCommand(self, _command)
    --接收服务端下发
    if _command:getType() == CNetworkCommand.TYPE then
        local msgID = _command:getProtocolID()
        local ackMsg = _command:getAckMessage()
        CCLOG("********************************************************")
        CCLOG( "start CStageMediator msgID:   "..msgID)
        local isH = false
        if msgID == _G.Protocol["ACK_SCENE_ENTER_OK"] then --进入场景 5030
            self : ACK_SCENE_ENTER_OK( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_PLAYER_LIST"] then --[5045]玩家信息列表 -- 场景
            self : ACK_SCENE_PLAYER_LIST( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_PARTNER_LIST"] then -- [5052]地图伙伴列表 -- 场景
            self : ACK_SCENE_PARTNER_LIST( ackMsg )
            isH =  true
        -- elseif msgID == _G.Protocol["ACK_SCENE_ROLE_DATA"] then --场景内玩家数据 - 5050
        --     self : ACK_SCENE_ROLE_DATA( ackMsg )
        --     isH =  true
        -- elseif msgID == _G.Protocol["ACK_SCENE_PARTNER_DATA"] then --场景怪物数据 - 5055
        --     self : ACK_SCENE_PARTNER_DATA( ackMsg )
        --     isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_IDX_MONSTER"] then --场景怪物数据 - 5065
            self : ACK_SCENE_IDX_MONSTER( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_MONSTER_DATA"] then --怪物数据(刷新) - 5070
            self : ACK_SCENE_MONSTER_DATA( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_MOVE_RECE"] then --行走数据(地图广播) - 5090
            self : ACK_SCENE_MOVE_RECE( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_SET_PLAYER_XY"] then --强设玩家坐标 - 5100
            self : ACK_SCENE_SET_PLAYER_XY( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_OUT"] then --离开场景 - 5110
            self : ACK_SCENE_OUT( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_RELIVE"] then --玩家可以复活 - 5160
            self : ACK_SCENE_RELIVE( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_RELIVE_OK"] then --玩家复活成功 - 5180
            self : ACK_SCENE_RELIVE_OK( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_HP_UPDATE"] then --玩家|伙伴|怪物 血量更新 - 5190
            self : ACK_SCENE_HP_UPDATE( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_CHANGE_ARTIFACT"] then --场景广播-神器 5310
            self : ACK_SCENE_CHANGE_ARTIFACT( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_CHANGE_CLAN"] then --场景广播-社团 - 5930
            self : ACK_SCENE_CHANGE_CLAN( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_LEVEL_UP"] then --场景广播-升级 - 5940
            self : ACK_SCENE_LEVEL_UP( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_CHANGE_TEAM"] then --场景广播-改变组队 - 5950
            self : ACK_SCENE_CHANGE_TEAM( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_CHANGE_MOUNT"] then --场景广播--改变坐骑 - 5960
            self : ACK_SCENE_CHANGE_MOUNT( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_CHANGE_STATE"] then --场景广播-改变战斗状态 - 5970
            self : ACK_SCENE_CHANGE_STATE( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_SCENE_COLLECT_DATA"] then --采集怪数据 - 5990
            self : ACK_SCENE_COLLECT_DATA( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_WAR_PK_RECEIVE"] then -- [6060]接收PK邀请 -- 战斗
            self : ACK_WAR_PK_RECEIVE( ackMsg )
            isH =  true
        elseif msgID == _G.Protocol["ACK_WAR_PK_LOSE"] then -- [6080]PK结束死亡广播 -- 战斗
            self : ACK_WAR_PK_LOSE( ackMsg )
            isH =  true


        elseif msgID == _G.Protocol["ACK_COPY_SCENE_OVER"] then --场景目标完成 - 7790 --下层副本
            self : ACK_COPY_SCENE_OVER( ackMsg )
            isH =  true

        elseif msgID == _G.Protocol["ACK_COPY_OVER"] then -- [7800]副本完成 -- 副本
            self : ACK_COPY_OVER( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_COPY_FAIL"] then -- [7810]副本失败 -- 副本
            self : ACK_COPY_FAIL( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_COPY_SCENE_TIME"] then -- [7060]场景时间同步(生存,限时类型) -- 副本
            self : ACK_COPY_SCENE_TIME( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_ARENA_WAR_DATA"] then -- [23831]战斗信息块 -- 逐鹿台
            self : ACK_ARENA_WAR_DATA( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_ARENA_WAR_REWARD"] then -- [23835]挑战奖励 -- 逐鹿台
            self : ACK_ARENA_WAR_REWARD( ackMsg )
            isH = true

        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_MAP_DATA"] then -- [37020]返回地图数据 -- 世界BOSS
            self : ACK_WORLD_BOSS_MAP_DATA( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_SELF_HP"] then -- [37053]玩家当前血量 -- 世界BOSS
            self : ACK_WORLD_BOSS_SELF_HP( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_DPS"] then -- [37060]DPS排行 -- 世界BOSS
            self : ACK_WORLD_BOSS_DPS( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_VIP_RMB"] then -- [37051]是否开启鼓舞 -- 世界BOSS
            self : ACK_WORLD_BOSS_VIP_RMB( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_HARM_S"] then -- [37071]伤害值广播 -- 世界BOSS boss收到伤害的
            self : ACK_WORLD_BOSS_HARM_S( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_WAR_RS"] then -- [37090]返回结果 -- 世界BOSS  返回复活时间和需要多少钱
            self : ACK_WORLD_BOSS_WAR_RS( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WORLD_BOSS_REVIVE_OK"] then -- [37120]复活成功 -- 世界BOSS
            self : ACK_WORLD_BOSS_REVIVE_OK( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_WAR_SKILL"] then -- [6030]释放技能广播 -- 战斗
            self : ACK_WAR_SKILL( ackMsg )
            isH = true
        elseif msgID == _G.Protocol["ACK_ROLE_LOGIN_AG_ERR"] then -- [1012]断线重连返回 -- 角色
            self : ACK_ROLE_LOGIN_AG_ERR( ackMsg )
            isH = true
        end


        CCLOG( "end CStageMediator msgID:   "..msgID)
        CCLOG("********************************************************")
        return isH
    end

    --接收自己客户端,然后发给服务器端 请求
    if _command:getType() == CStageREQCommand.TYPE then
        local msgID = _command : getData()
        local otherData = _command : getOtherData()

        CCLOG("********************************************************")
        CCLOG(" start client msgID "..msgID )
        local isH = false
        if msgID == _G.Protocol["REQ_SCENE_ENTER_FLY"] then --请求进入场景(飞) 5010
            self : REQ_SCENE_ENTER_FLY( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_ENTER"] then --请求进入场景 5020
            self : REQ_SCENE_ENTER( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_REQUEST_PLAYERS"] then --请求场内玩家数据 5040
            self : REQ_SCENE_REQUEST_PLAYERS( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_REQ_PLAYERS_NEW"] then --[5042]请求场景玩家列表(new) -- 场景
            self : REQ_SCENE_REQ_PLAYERS_NEW( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_REQUEST_MONSTER"] then --请求怪物数据 5060
            self : REQ_SCENE_REQUEST_MONSTER( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_MOVE"] then --发送人物移动 5080
            self : REQ_SCENE_MOVE( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_MOVE_NEW"] then --发送人物移动 5080
            self : REQ_SCENE_MOVE_NEW( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_CAROM_TIMES"] then --发送杀怪连击 5120
            self : REQ_SCENE_CAROM_TIMES( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_KILL_MONSTER"] then --发送击杀怪物 5130
            self : REQ_SCENE_KILL_MONSTER( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_HIT_TIMES"] then --发送被怪物击中 5140
            self : REQ_SCENE_HIT_TIMES( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_DIE"] then --发送玩家死亡 5150
            self : REQ_SCENE_DIE( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_ENTER_CITY"] then -- [5200]退出场景 -- 场景
            self : REQ_SCENE_ENTER_CITY( otherData )
            isH =  true

        elseif msgID == _G.Protocol["REQ_WAR_PK"] then -- [6050]邀请PK -- 战斗
            self : REQ_WAR_PK( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WAR_PK_CANCEL"] then -- [6055]取消邀请 -- 战斗
            self : REQ_WAR_PK_CANCEL( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WAR_PK_REPLY"] then -- [6070]邀请回复 -- 战斗
            self : REQ_WAR_PK_REPLY( otherData )
            isH =  true


        elseif msgID == _G.Protocol["REQ_SCENE_RELIVE_REQUEST"] then --发送玩家请求复活 5170
            self : REQ_SCENE_RELIVE_REQUEST( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_COPY_COPY_EXIT"] then --发送 退出副本 7820
            self : REQ_COPY_COPY_EXIT( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_COPY_NOTICE_OVER"] then -- 发送 [7795]通知副本完成 -- 副本
            self : REQ_COPY_NOTICE_OVER( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_ARENA_BATTLE"] then -- [23830]挑战 -- 逐鹿台
            self : REQ_ARENA_BATTLE( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_ARENA_FINISH"] then -- [23840]挑战结束 -- 逐鹿台
            self : REQ_ARENA_FINISH( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WORLD_BOSS_DATA"] then -- [37010]请求世界boss数据 -- 世界BOSS
            self : REQ_WORLD_BOSS_DATA( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WORLD_BOSS_EXIT_S"] then -- [37100]退出世界BOSS -- 世界BOSS
            self : REQ_WORLD_BOSS_EXIT_S( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WORLD_BOSS_REVIVE"] then -- [37110]复活 -- 世界BOSS
            self : REQ_WORLD_BOSS_REVIVE( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WAR_HARM"] then -- [6020]战斗伤害
            self : REQ_WAR_HARM( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WAR_HARM_NEW"] then -- [6021]战斗伤害
            self : REQ_WAR_HARM_NEW( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WORLD_BOSS_WAR_DIE"] then -- [37080]玩家死亡 -- 世界BOSS
            self : REQ_WORLD_BOSS_WAR_DIE( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_WAR_USE_SKILL"] then -- [6040]释放技能 -- 战斗
            self : REQ_WAR_USE_SKILL( otherData )
            isH =  true
        elseif msgID == _G.Protocol["REQ_SCENE_DIE_PARTNER"] then -- [5155]伙伴死亡 -- 场景
            self : REQ_SCENE_DIE_PARTNER( otherData )
            isH =  true





        end

        CCLOG(" end client msgID  ".. msgID )
        CCLOG("********************************************************")
        return isH
    end

    --接收自己客户端
    if _command:getType() == CKeyBoardCommand.TYPE then --手柄按钮
        CCLOG("********************************************************")
        CCLOG(" start joyStick " )
        local VO_data = _command:getData()
        local keyCode = VO_data:getKeyCode()
        local temp_play = self : getView() : getPlay()
        if temp_play : getHP() <=0 then
            CCLOG(" end joyStick " )
            CCLOG("********************************************************")
            return
        end
        if _G.g_Stage : getCanControl() == false or _G.g_Stage : getStartStageAction() == true then
            return
        end
        local skillID = nil
        local  isH = false
        if keyCode == CKeyBoardView.BUTTON_ATTACK then
            skillID = temp_play : getAttackSkillID()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_JUMP then
            self : getView() : getPlay() : jump()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL1 then
            skillID = temp_play : getSkillID1()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL2 then
            skillID = temp_play : getSkillID2()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL3 then
            skillID = temp_play : getSkillID3()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL4 then
            skillID = temp_play : getSkillID4()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL5 then
            skillID = temp_play : getSkillID5()
            isH = true
        elseif keyCode == CKeyBoardView.BUTTON_SKILL6 then
            skillID = temp_play : getSkillID6()
            isH = true
        end
        CCLOG("keyCode,skillID "..tostring(skillID))
        if skillID ~= nil and skillID ~= 0 then
            temp_play : useSkill( skillID )
        end
        CCLOG(" end joyStick " )
        CCLOG("********************************************************")
        return isH

    end

    if _command :getType() == CFlyItemCommand.TYPE then --飞物品
        if _G.g_lpMainPlay ~= nil then
            _G.g_lpMainPlay:onGetItem( _command:getData(), 0, 0 )
        end
    end
    if _command :getType() == CClanIdOrNameUpdateCommand.TYPE then        -- 帮派改变更新人物头上帮派名
        self : clanNameUpdate( _command : getData() )
    elseif _command :getType() == CCharacterPropertyACKCommand.TYPE then  -- 查看其他玩家信息
        self : openCharacterView( _command : getData() )
    end

    return false
end

--[[
                    R           E           Q
]]

function CStageMediator.REQ_SCENE_ENTER_FLY( self, _otherData ) --请求进入场景 5010
    local msg = REQ_SCENE_ENTER_FLY()
    msg : setArguments( _otherData.mapID or 0 )
    CCLOG("_otherData.mapID ".._otherData.mapID)
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_ENTER( self, _otherData ) --请求进入场景 5020
    local msg = REQ_SCENE_ENTER()
    msg : setArguments( _otherData.mapID or 0 )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_REQUEST_PLAYERS( self, _otherData )--请求场内玩家数据 5040
    local msg = REQ_SCENE_REQUEST_PLAYERS()
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_REQ_PLAYERS_NEW( self, _otherData ) -- [5042]请求场景玩家列表(new) -- 场景
    local msg = REQ_SCENE_REQ_PLAYERS_NEW()
    _G.CNetwork : send(msg)
end


function CStageMediator.REQ_SCENE_REQUEST_MONSTER( self, _otherData )--请求怪物数据 5060
    local msg = REQ_SCENE_REQUEST_MONSTER()
    _G.CNetwork : send(msg)
end

--{这个是已经移动到某个点,服务器只保存}
function CStageMediator.REQ_SCENE_MOVE( self, _otherData )--发送人物移动 5080
    local msg = REQ_SCENE_MOVE()
    local characterType = _otherData.characterType --CONST_PLAYER
    local uid = _otherData.uid
    local x = _otherData.x
    local y = _otherData.y
    x = x <= 0 and 0 or x
    y = y <= 0 and 0 or y
    local move_type = _otherData.move_type
    msg : setArguments( characterType, uid, move_type, x, y )
    _G.CNetwork : send(msg)
end

--{这个是要移动到某个点,服务器会广播}
function CStageMediator.REQ_SCENE_MOVE_NEW( self, _otherData )--发送人物移动 5085
    local msg = REQ_SCENE_MOVE_NEW()
    local characterType = _otherData.characterType --CONST_PLAYER
    local uid = _otherData.uid
    local x = _otherData.x
    local y = _otherData.y
    x = x <= 0 and 0 or x
    y = y <= 0 and 0 or y
    CCLOG("REQ_SCENE_MOVE_NEW "..x.."   "..y)
    local move_type = _otherData.move_type
    msg : setArguments( characterType, uid, move_type, x, y )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_CAROM_TIMES( self, _otherData )--发送杀怪连击 5120
    local times = _otherData.times
    local msg = REQ_SCENE_CAROM_TIMES()
    msg : setArguments( times )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_KILL_MONSTER( self, _otherData )--发送击杀怪物 5130
    local monster_mid = _otherData.monster_mid
    local msg = REQ_SCENE_KILL_MONSTER()
    msg : setArguments( monster_mid )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_HIT_TIMES( self, _otherData )--发送被怪物击中 5140
    local times = _otherData.times
    local msg = REQ_SCENE_HIT_TIMES()
    msg : setArguments( times )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_DIE( self, _otherData )--发送玩家死亡 5150
    local msg = REQ_SCENE_DIE()
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_ENTER_CITY( self, _otherData )-- [5200]退出场景 -- 场景
    local msg = REQ_SCENE_ENTER_CITY()
    _G.CNetwork : send(msg)
    print("发送出去2")
end

function CStageMediator.REQ_WAR_PK( self, _otherData ) -- [6050]邀请PK -- 战斗
    local msg = REQ_WAR_PK()
    msg : setUid( _otherData.uid )
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_WAR_PK_CANCEL( self, _otherData ) -- [6055]取消邀请 -- 战斗
    local msg = REQ_WAR_PK_CANCEL()
    _G.CNetwork : send(msg)
end



function CStageMediator.REQ_WAR_PK_REPLY( self, _otherData )-- [6070]邀请回复 -- 战斗
    local msg = REQ_WAR_PK_REPLY()
    msg : setRes( _otherData.res )
    msg : setUid( _otherData.uid )
    local property = _G.g_characterProperty : getMainPlay()
    local uid = property : getUid()
    --print("_otherData.res",_otherData.res,_otherData.uid,uid)
    _G.CNetwork : send(msg)
end

function CStageMediator.REQ_SCENE_RELIVE_REQUEST( self, _otherData ) --发送玩家请求复活 5170
    local msg = REQ_SCENE_RELIVE_REQUEST()
    _G.CNetwork : send(msg)
end


--退出副本－Test
function CStageMediator.REQ_COPY_COPY_EXIT( self, _otherData ) --离开副本
    local msg = REQ_COPY_COPY_EXIT()
    _G.CNetwork : send(msg)
end

-- 发送 [7795]通知副本完成 -- 副本
function CStageMediator.REQ_COPY_NOTICE_OVER( self, _otherData )
    local msg = REQ_COPY_NOTICE_OVER()
    msg : setArguments( _otherData.hit_times, _otherData.carom_times, _otherData.mons_hp )

    -- self.hit_times = 10  -- {被击数}
    -- self.carom_times  = 10  -- {最高连击数}
    -- self.mons_hp   = 10  -- {对怪物伤害(所有怪物杀出的血)}

    _G.CNetwork : send(msg)
    print("发送 [7795]通知副本完成 -- 副本")
end

-- [23830]挑战 -- 逐鹿台
function CStageMediator.REQ_ARENA_BATTLE( self, _otherData )
    local msg = REQ_ARENA_BATTLE()
    msg : setArguments( _otherData.uid, _otherData.rank )
    _G.CNetwork : send(msg)
end

-- [23840]挑战结束 -- 逐鹿台
function CStageMediator.REQ_ARENA_FINISH( self, _otherData )
    local msg = REQ_ARENA_FINISH()
    msg : setArguments( _otherData.uid, _otherData.ranking, _otherData.res )
    _G.CNetwork : send(msg)
end

-- [37010]请求世界boss数据 -- 世界BOSS
function CStageMediator.REQ_WORLD_BOSS_DATA( self, _otherData )
    local msg = REQ_WORLD_BOSS_DATA()
    _G.CNetwork : send(msg)
end

-- [37100]退出世界BOSS -- 世界BOSS
function CStageMediator.REQ_WORLD_BOSS_EXIT_S( self, _otherData )
    local msg = REQ_WORLD_BOSS_EXIT_S()
    _G.CNetwork : send(msg)
end


-- [37110]复活 -- 世界BOSS
function CStageMediator.REQ_WORLD_BOSS_REVIVE( self, _otherData )
    local msg = REQ_WORLD_BOSS_REVIVE()
    msg : setArguments( _otherData.type )
    _G.CNetwork : send(msg)
end


-- [6020]战斗伤害
function CStageMediator.REQ_WAR_HARM( self, _otherData )
    local msg = REQ_WAR_HARM()
    msg : setType( tonumber(_otherData.type) )
    msg : setOneType( tonumber(_otherData.one_type) )
    msg : setOneMid( tonumber(_otherData.one_mid) )
    msg : setOneId( tonumber(_otherData.one_id) )
    msg : setFoeType( tonumber(_otherData.foe_type) )
    msg : setAttrType( tonumber(_otherData.attr_type) )
    msg : setId( tonumber(_otherData.id) )
    msg : setMid( tonumber(_otherData.mid) )
    msg : setSkillId( tonumber(_otherData.skill_id) )
    msg : setLv( tonumber(_otherData.lv) )
    msg : setHarm( tonumber(_otherData.harm) )
    msg : setStata( tonumber(_otherData.stata) )
    -- msg : setArguments(
    --                    tonumber(_otherData.type),
    --                    tonumber(_otherData.one_type),
    --                    tonumber(_otherData.one_mid),
    --                    tonumber(_otherData.one_id),
    --                    tonumber(_otherData.foe_type),
    --                    tonumber(_otherData.attr_type),
    --                    tonumber(_otherData.mid),
    --                    tonumber(_otherData.id),
    --                    tonumber(_otherData.skill_id),
    --                    tonumber(_otherData.lv),
    --                    tonumber(_otherData.stata),
    --                    tonumber(_otherData.harm)
    --                    )
    print("_otherData.type",_otherData.type,
"_otherData.one_type",_otherData.one_type,
"_otherData.one_mid",_otherData.one_mid,
"_otherData.one_id",_otherData.one_id,
"_otherData.foe_type",_otherData.foe_type,
"_otherData.attr_type",_otherData.attr_type,
"_otherData.id",_otherData.id,
"_otherData.mid",_otherData.mid,
"_otherData.skill_id",_otherData.skill_id,
"_otherData.lv",_otherData.lv,
"_otherData.harm",_otherData.harm,
"_otherData.stata",_otherData.stata)
    _G.CNetwork : send(msg)
end
-- [6021]战斗伤害
function CStageMediator.REQ_WAR_HARM_NEW( self, _otherData )
    local msg = REQ_WAR_HARM_NEW()
    msg : setType( tonumber(_otherData.type) )
    msg : setOneType( tonumber(_otherData.one_type) )
    msg : setOneMid( tonumber(_otherData.one_mid) )
    msg : setOneId( tonumber(_otherData.one_id) )
    msg : setFoeType( tonumber(_otherData.foe_type) )
    msg : setAttrType( tonumber(_otherData.attr_type) )
    msg : setId( tonumber(_otherData.id) )
    msg : setMid( tonumber(_otherData.mid) )
    msg : setSkillId( tonumber(_otherData.skill_id) )
    msg : setLv( tonumber(_otherData.lv) )
    msg : setHarm( tonumber(_otherData.harm) )
    msg : setStata( tonumber(_otherData.stata) )
    -- msg : setArguments(
    --                    tonumber(_otherData.type),
    --                    tonumber(_otherData.one_type),
    --                    tonumber(_otherData.one_mid),
    --                    tonumber(_otherData.one_id),
    --                    tonumber(_otherData.foe_type),
    --                    tonumber(_otherData.attr_type),
    --                    tonumber(_otherData.mid),
    --                    tonumber(_otherData.id),
    --                    tonumber(_otherData.skill_id),
    --                    tonumber(_otherData.lv),
    --                    tonumber(_otherData.stata),
    --                    tonumber(_otherData.harm)
    --                    )
    print("_otherData.type",_otherData.type,
"_otherData.one_type",_otherData.one_type,
"_otherData.one_mid",_otherData.one_mid,
"_otherData.one_id",_otherData.one_id,
"_otherData.foe_type",_otherData.foe_type,
"_otherData.attr_type",_otherData.attr_type,
"_otherData.id",_otherData.id,
"_otherData.mid",_otherData.mid,
"_otherData.skill_id",_otherData.skill_id,
"_otherData.lv",_otherData.lv,
"_otherData.harm",_otherData.harm,
"_otherData.stata",_otherData.stata)
    _G.CNetwork : send(msg)
end



-- [37080]玩家死亡 -- 世界BOSS
function CStageMediator.REQ_WORLD_BOSS_WAR_DIE( self, _otherData )
    local msg = REQ_WORLD_BOSS_WAR_DIE()
    _G.CNetwork : send(msg)
end




-- [6040]释放技能 -- 战斗
function CStageMediator.REQ_WAR_USE_SKILL( self, _otherData )
    local msg = REQ_WAR_USE_SKILL()
    msg : setArguments( _otherData.type,_otherData.id,_otherData.skill_id,_otherData.skill_lv )
    _G.CNetwork : send(msg)
end


-- [5155]伙伴死亡 -- 场景
function CStageMediator.REQ_SCENE_DIE_PARTNER( self, _otherData )
    local msg = REQ_WAR_USE_SKILL()
    msg : setArguments( _otherData.partner_id )
    _G.CNetwork : send(msg)
end















--[[
                    A           C           K
]]
function CStageMediator.ACK_SCENE_ENTER_OK( self, _ackMsg )--进入场景 5030
    if _G.pCreateRoleSceneMediator ~= nil then
        _G.controller : unregisterMediator(_G.pCreateRoleSceneMediator)
        _G.pCreateRoleSceneMediator = nil
        _G.pSelectRoleView = nil
    end
    _G.g_isGotoScene = true
    local property = _G.g_characterProperty : getMainPlay()
    property : setTeamID( _ackMsg : getTeamId() )
    print("_ackMsg : getTeamId()",_ackMsg : getTeamId())
    local isTeam = _ackMsg : getTeamId() ~= 0
    print("_ackMsg : getTeamId()",_ackMsg : getTeamId(),isTeam)
    property : setIsTeam( isTeam )
    if property : getPartner() ~= nil then
        for _,partner_id in pairs( property : getPartner() ) do
            local index = tostring(property : getUid())..tostring(partner_id)
            local partnerProperty = _G.g_characterProperty : getOneByUid(index, _G.Constant.CONST_PARTNER )
            if partnerProperty ~= nil then
                partnerProperty : setTeamID( property : getTeamID()  )
                partnerProperty : setIsTeam( isTeam )
            end
        end
    end


    self : gotoScene(  _ackMsg : getMapId(),
                       _ackMsg : getPosX(),
                       _ackMsg : getPosY(),
                       _ackMsg : getHpNow(),
                       _ackMsg : getHpMax() )

end

function CStageMediator.ACK_SCENE_PLAYER_LIST( self, _ackMsg ) --[5045]玩家信息列表 -- 场景
    if _G.pCSystemSettingProxy : getStateByType(_G.Constant.CONST_SYS_SET_SHOW_ROLE) == 1 then
        local scenesType = _G.g_Stage : getScenesType()
        if scenesType == _G.Constant.CONST_MAP_TYPE_CITY
            or scenesType == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS
            or scenesType == _G.Constant.CONST_MAP_TYPE_BOSS then
            return
        end
    end
    for _,data in pairs( _ackMsg : getData() ) do
        self : ACK_SCENE_ROLE_DATA(data)
    end
end

function CStageMediator.ACK_SCENE_PARTNER_LIST( self, _ackMsg ) --场景怪物数据 - 5055
    if _G.pCSystemSettingProxy : getStateByType(_G.Constant.CONST_SYS_SET_SHOW_ROLE) == 1 then
        local scenesType = _G.g_Stage : getScenesType()
        if scenesType == _G.Constant.CONST_MAP_TYPE_CITY
            or scenesType == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS
            or scenesType == _G.Constant.CONST_MAP_TYPE_BOSS then
            return
        end
    end
    for _,data in pairs( _ackMsg : getData() ) do
        self : ACK_SCENE_PARTNER_DATA(data)
    end
end


function CStageMediator.ACK_SCENE_ROLE_DATA( self, _ackMsg ) --场景内玩家数据 5050
    CCLOG(" ACK_SCENE_ROLE_DATA 场景人物加载 START")
    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        return
    end

    local uid = _ackMsg : getUid()
    local characterType = _ackMsg : getType()
    if uid == nil then
        CCLOG("下发场景内玩家数据  uid为空")
        return
    end
    for k,v in pairs(_ackMsg) do
        print(k,v)
    end
    if uid == _G.g_characterProperty : getMainPlay() : getUid() then
        local petSkinID =  _ackMsg : getSkinPet()
        local mainCharacter = _G.g_Stage : getPlay()
        mainCharacter : setPetSkinId(petSkinID)
        CCMessageBox("下发自己","ffff")

        return
    end
    print("ACK_SCENE_ROLE_DATA2222",characterType)
    local property =  _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER )
    if property == nil then
        property = CCharacterProperty()
        property : setUid( uid )
        _G.g_characterProperty : addOne( property ,_G.Constant.CONST_PLAYER )
    else
        CCLOG("5050 已经存在同一个场景了")
        local temp_play =  _G.CharacterManager : getPlayerByID(uid)
        if temp_play ~= nil then
            _G.g_Stage : removeCharacter( temp_play )
        end
    end
    property : updateProperty( _G.Constant.CONST_ATTR_VIP , _ackMsg:getVip() )
    property : setPro( _ackMsg:getPro() )
    local temp_play = nil--_G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        temp_play = CPlayer( _G.Constant.CONST_PLAYER )
        local uID = _ackMsg : getUid()
        local szName = _ackMsg:getName()
        local sex = _ackMsg:getSex()
        local pro = _ackMsg:getPro()
        local lv = _ackMsg:getLv()
        local country = _ackMsg:getCountry()
        local x = _ackMsg : getPosX()
        local y = _ackMsg : getPosY()
        local skinID = _ackMsg : getSkinArmor()
        local hp = _ackMsg : getHpNow()
        local hpMax = _ackMsg : getHpMax()
        local clanId = _ackMsg : getClan()
        local clanName = _ackMsg : getClanName()

        local petSkinID = _ackMsg : getSkinPet()--10901
        if skinID == 0 or skinID == nil then
            --CCMessageBox("服务器下发皮肤ID为0,过去找服务器","皮肤错误")
            CCLOG("codeError!!!! 服务器下发皮肤ID为0,过去找服务器")
            return
        end
        temp_play : playerInit( uID, szName, sex, pro, lv, country, false, skinID )
        temp_play : init( uID , szName, hpMax, hp, 100, 100, x, y, skinID)
        temp_play : setClanInfo(  clanId, clanName )
        temp_play : setPetSkinId(petSkinID)
    end
    property : setTeamID( _ackMsg : getLeaderUid() )
    _G.g_Stage : addCharacter( temp_play )

    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        temp_play : initTouchSelf()
        temp_play : setMagicSkinId(_ackMsg :getArtifactId())
    end
    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        temp_play : addBigHpView(1,false)
    end
    CCLOG(" ACK_SCENE_ROLE_DATA 场景人物加载 END")


    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        CCLOG(" 5050 之后.请求对战玩家属性")
        local msg = REQ_ROLE_PROPERTY()
        msg: setSid( _G.g_LoginInfoProxy :getServerId() )
        msg: setUid( uid )
        msg: setType( 0 )
        _G.CNetwork : send( msg)
        CCLOG(" 5050 之后.请求对战玩家属性 2")
    end

    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        local mainPlay = _G.g_characterProperty : getMainPlay()
        if mainPlay ~= nil then
            property : setTeamID( mainPlay : getTeamID() )
        end
    end
end


--更新伙伴的名字和颜色
function CStageMediator.getPartnerXMLInfo( self, _partnerid)
    local _partnerid = tostring( _partnerid)
    _G.Config:load("config/partner_init.xml")
    local node = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
    local partnerinfo =  node : selectSingleNode("partner_init[@id=".._partnerid.."]")
    return partnerinfo
end

function CStageMediator.ACK_SCENE_PARTNER_DATA( self, _ackMsg ) -- [5055]地图伙伴数据 -- 场景
    print("ACK_SCENE_PARTNER_DATA")
    local index      = tostring( _ackMsg : getUid() )..tostring( _ackMsg : getPartnerId() )
    local property = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )

    local partnerinfo = self :getPartnerXMLInfo( _ackMsg : getPartnerId() )
    if partnerinfo : isEmpty() then
        return
    end
    print("ACK_SCENE_PARTNER_DATA",partnerinfo:getAttribute("partner_name"))
    if property == nil then
        property = CCharacterProperty()
        property : setUid( _ackMsg : getUid() )
        property : setPartner( _ackMsg : getPartnerId() )
        property : updateProperty( _G.Constant.CONST_ATTR_NAME,  partnerinfo:getAttribute("partner_name"))
        property : updateProperty( _G.Constant.CONST_ATTR_NAME_COLOR,  partnerinfo:getAttribute("name_colour"))
        property : setSkinArmor( partnerinfo:getAttribute("skin"))
        property : setAI( partnerinfo:getAttribute("ai_id") )
        _G.g_characterProperty : addOne( property, _G.Constant.CONST_PARTNER )
    end

    property : setPro( partnerinfo:getAttribute("pro") )
    property : updateProperty( _G.Constant.CONST_ATTR_LV,  _ackMsg : getPartnerLv() )
    --property : updateProperty( _G.Constant.CONST_ATTR_POWERFUL,  _ackMsg : getPowerful() )
    property : setPartner( _ackMsg : getPartnerId() )
    property : setStata( _G.Constant.CONST_INN_STATA3 ) --出战状态



    local teamID = _ackMsg : getTeamId()
    if teamID == 0 then
        teamID = _ackMsg : getUid()
    end
    property : setTeamID( teamID )

        --print("ACK_SCENE_PARTNER_DATA1",_ackMsg : getStata(),property : getStata())
    if property : getStata() == _G.Constant.CONST_INN_STATA3 then
        local characterPartner = CPartner(_G.Constant.CONST_PARTNER)
        characterPartner : partnerInit(property)
        characterPartner : setMaxHp( _ackMsg : getHpMax() )
        characterPartner : setHP( _ackMsg : getHpNow() )
        _G.g_Stage : addCharacter( characterPartner )
    end

    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_BOSS or _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CLAN_BOSS then
        local mainPlay = _G.g_characterProperty : getMainPlay()
        if mainPlay ~= nil then
            property : setTeamID( mainPlay : getTeamID() )
        end
    end
end

function CStageMediator.ACK_SCENE_IDX_MONSTER( self, _ackMsg ) --场景怪物数据 - 5065
    --print("进来了,,,,,,,5065")
    local monsterList = _ackMsg : getData()
    local idList = {}
    for _,monsterData in pairs(monsterList) do
        local data = {}
        data.monster_id = monsterData : getMonsterId()
        data.uid = monsterData : getMonsterMid()
        data.x = monsterData : getOriginX()
        data.y = monsterData : getOriginY()
        data.hp_now = monsterData : getNowHp()
        data.hp_max = monsterData : getMaxHp()
        table.insert(idList, data)
    end
    local checkpoint = _ackMsg : getIdx() -1
    _G.g_Stage : setCheckPointID(checkpoint)
    _G.StageXMLManager : addMonsterByIDList(idList)
    _G.g_Stage : runNextCheckPoint()
end


function CStageMediator.ACK_SCENE_MONSTER_DATA( self, _ackMsg ) --怪物数据(刷新)--5070
    local characterMonster = _G.CharacterManager : getCharacterByTypeAndID( _G.Constant.CONST_MONSTER, _ackMsg : getMonsterMid())
    if characterMonster == nil then
        return
    end
    CCLOG("已经发送怪物刷新")
    characterMonster : setHP( tonumber( _ackMsg : getNowHp() ) )
end



function CStageMediator.ACK_SCENE_MOVE_RECE( self, _ackMsg ) --行走数据(地图广播) - 5090
    local uid = _ackMsg : getUid()
    local characterType = _ackMsg : getType()
    if _G.g_Stage == nil or _G.g_Stage : getPlay() == nil then
        return
    end

    if uid == _G.g_Stage : getPlay() : getID() then
        return
    end
    local temp_play = _G.CharacterManager : getCharacterByTypeAndID( characterType, uid )
    if temp_play == nil then

        return
    end
    local x = _ackMsg : getPosX()
    local y = _ackMsg : getPosY()
    if _G.Constant.CONST_MAP_MOVE_STOP == _ackMsg : getMoveType() then
        temp_play : cancelMove()
        --temp_play : setMovePos( ccp( x, y ) )
        temp_play : setLocationX(x)
        temp_play : setLocationY(y)
        --temp_play : setMoveClipContainerScalex()
        CCLOG("STOP ACK_SCENE_MOVE_RECE,"..x.."  "..y)
        return
    end
    CCLOG("ACK_SCENE_MOVE_RECE "..x.."    "..y)
    print("移动")
    temp_play : setMovePos( ccp( x, y ) )
    if _G.Constant.CONST_MAP_MOVE_JUMP == _ackMsg : getMoveType() then
        print("跳跃")
        temp_play : jump()
    end
end

function CStageMediator.ACK_SCENE_SET_PLAYER_XY( self, _ackMsg ) --强设玩家坐标 - 5100
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setLocationXY( _ackMsg : getPosX(), _ackMsg : getPosY() )
end

function CStageMediator.ACK_SCENE_OUT( self, _ackMsg ) --离开场景 - 5110
    local uid = _ackMsg : getUid()
    local characterType = _ackMsg : getType()
    if characterType == _G.Constant.CONST_PARTNER then
        uid = tostring(_ackMsg : getOwnerUid())..tostring(uid)
    end
    -- print("ACK_SCENE_OUT",uid,characterType,"ffffff","dddddd")
    local temp_play = _G.CharacterManager : getCharacterByTypeAndID( characterType, uid )
    if temp_play == nil then
        --print("跳出")
        return
    end
    if characterType == _G.Constant.CONST_PARTNER or characterType == _G.Constant.CONST_MONSTER then
        temp_play : setHP(0)
        -- print("设置了。。。")
    else
        --print("delete")
        _G.g_Stage : removeCharacter(temp_play)
    end



end

function CStageMediator.ACK_SCENE_RELIVE( self, _ackMsg ) --玩家可以复活 - 5160
    --self : reviveMain()
    -- local obj = CDeadCopyView()
    -- _G.g_Stage : addMessageView( obj : container( _ackMsg : getRmb() ) )

    local tipsString = "还有很长一段路要走，回去好好锻炼吧!/n使用"..tostring(_ackMsg : getRmb()).."钻石可以复活"

    local function outCopy()
        _G.g_Stage : exitCopy()
    end
    local function relive( )
        local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_RELIVE_REQUEST"])
        _G.controller : sendCommand( comm )
    end


    require "view/ErrorBox/ErrorBox"
    local errorBox = CErrorBox()
    local BoxLayer = errorBox : create(tipsString,outCopy,relive)
    local btn = BoxLayer : getBoxCancelBtn()
    if btn ~= nil then
        btn : setString("复活")
    end
    _G.g_Stage : addMessageView( BoxLayer )
end

function CStageMediator.ACK_SCENE_RELIVE_OK( self, _ackMsg ) --玩家复活成功 - 5180
    self : reviveMain()
    _G.g_Stage : removeMessageView()
end
function CStageMediator.ACK_SCENE_HP_UPDATE( self, _ackMsg ) --玩家|伙伴|怪物 血量更新 - 5190
    local uid = _ackMsg : getUid()
    local characterType = _ackMsg : getType()
    if characterType == _G.Constant.CONST_PARTNER then
        uid = tostring( _ackMsg : getUid() )..tostring( _ackMsg : getPartnerId() )
    end
    local temp_play = _G.CharacterManager : getCharacterByTypeAndID( characterType, uid )
    if temp_play == nil then
        print("ACK_SCENE_HP_UPDATE BACK",characterType, uid)
        return
    end
    print("ACK_SCENE_HP_UPDATE",uid,temp_play : getHP(),_ackMsg : getHpNow())
    local subHp = temp_play : getHP() - _ackMsg : getHpNow()
    if subHp > 0 then
        --未完成 要添加暴击效果
        temp_play : addHurtString(subHp, _ackMsg : getStata())
    end
    temp_play : setHP( _ackMsg : getHpNow() )
end


function CStageMediator.ACK_SCENE_CHANGE_ARTIFACT( self, _ackMsg ) --场景广播-神器 - 5310
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setMagicSkinId(  _ackMsg : getArtifactId() )
    local property = _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER )
    if property ~= nil then
        property : setMagicId( _ackMsg : getArtifactId() )
    end
end

function CStageMediator.ACK_SCENE_CHANGE_CLAN( self, _ackMsg ) --场景广播-社团 - 5930
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setClanInfo(  _ackMsg : getClanId(), _ackMsg : getClanName() )
end

function CStageMediator.ACK_SCENE_LEVEL_UP( self, _ackMsg ) --场景广播-升级 - 5940
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setLv( _ackMsg : getLevel() )
end

function CStageMediator.ACK_SCENE_CHANGE_TEAM( self, _ackMsg ) --场景广播-改变组队 - 5950
    -- local uid = _ackMsg : getUid()
    -- local temp_play = _G.CharacterManager : getPlayerByID(uid)
    -- if temp_play == nil then
    --     return
    -- end
    -- temp_play : setLeaderUID( _ackMsg : getNewLeaderUid() )
end

function CStageMediator.ACK_SCENE_CHANGE_MOUNT( self, _ackMsg ) --场景广播--改变坐骑 - 5960
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setSkinMount( _ackMsg : getMount() )
end

function CStageMediator.ACK_SCENE_CHANGE_STATE( self, _ackMsg ) --场景广播-改变战斗状态 - 5970
    local uid = _ackMsg : getUid()
    local temp_play = _G.CharacterManager : getPlayerByID(uid)
    if temp_play == nil then
        return
    end
    temp_play : setIsWar( _ackMsg : getStateNew() )
end

function CStageMediator.ACK_SCENE_COLLECT_DATA( self, _ackMsg ) --采集怪数据 - 5990

end

function CStageMediator.ACK_WAR_PK_RECEIVE( self, _ackMsg ) -- [6060]接收PK邀请 -- 战斗
    _G.g_pkReceiveManager : addReceive( _ackMsg : getUid(), _ackMsg : getName(), _ackMsg : getTime() + 30 )
end

function CStageMediator.ACK_WAR_PK_LOSE( self, _ackMsg ) -- [6080]PK结束死亡广播 -- 战斗
    local property = _G.g_characterProperty : getMainPlay()
    local uid = property : getUid()
    local res = 1
    if uid == _ackMsg : getUid() then
        res = 0
    end
    local view = CArenaFinishView( res, 0, 0,0 )
    _G.g_Stage : addMessageView(view : container() )
    _G.g_Stage : removeKeyBoardAndJoyStick()
end


function CStageMediator.ACK_COPY_SCENE_OVER( self, _ackMsg )  --场景目标完成 - 7790 --下层副本
    _G.g_Stage : finishCopy()
    --添加传送门
    local function waitingFunc()
        local scenesID = _G.g_Stage : getScenesID()
        _G.StageXMLManager : addTransport( scenesID )
    end
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(_G.Constant.CONST_FIGHTERS_DOOR_DELAY_TIME))
    _callBacks:addObject(CCCallFunc:create(waitingFunc))
    local nowScene = CCDirector : sharedDirector() : getRunningScene()
    nowScene : runAction( CCSequence:create(_callBacks) )
end

-- [7800]副本完成 -- 副本
function CStageMediator.ACK_COPY_OVER( self, _ackMsg )
    local sceneType = _G.g_Stage : getScenesType()
    print("stage的格斗之王副本成功,场景类型为====",sceneType)
    if sceneType == _G.Constant.CONST_MAP_TYPE_COPY_FIGHTERS then
        print("成功成功")
        _G.g_KOFCopyID = _G.g_Stage : getScenesCopyID()
        _G.g_KOFisWin = true
        print("成功成功2121")
    end

    local copyID = _ackMsg : getCopyId()-- {副本ID}
    local copyType = _ackMsg : getCopyType()-- {副本类型}
    local copyHitScore = _ackMsg : getHitScore()-- {无损得分}
    local copyTimeScore = _ackMsg : getTimeScore()-- {时间得分}
    local copyCaromScore = _ackMsg : getCaromScore()-- {连击得分}
    local copyKillScore = _ackMsg : getKillScore()-- {杀敌得分}
    local copyEva = _ackMsg : getEva()-- {副本评价}
    local copyExp = _ackMsg : getExp()-- {经验}
    local copyGold = _ackMsg : getGold()-- {铜钱}
    local copyPower = _ackMsg : getPower()-- {潜能}
    local copyGoodsCount = _ackMsg : getCount()-- {物品数量}
    local copyGoods = _ackMsg : getData()-- {物品信息块(7805)}

    local mainPlay = _G.g_characterProperty:getMainPlay()
    local rewardView = CRewardCopyView(  copyExp, copyPower, copyGold, copyHitScore, copyTimeScore, copyKillScore, copyCaromScore, copyEva, copyGoods)
    local container = rewardView : container()
    _G.g_Stage : addMessageView( container )
    _G.g_Stage :removeKeyBoardAndJoyStick()

end

-- [7810]副本失败 -- 副本
function CStageMediator.ACK_COPY_FAIL( self, _ackMsg )
    local sceneType = _G.g_Stage : getScenesType()
    print("stage的格斗之王副本失败,场景类型为====",sceneType)
    if sceneType == _G.Constant.CONST_MAP_TYPE_COPY_FIGHTERS then
        print("失败失败")
        _G.g_KOFCopyID = _G.g_Stage : getScenesCopyID()
        _G.g_KOFisWin = false
        print("失败失败2121")
    end

    _G.g_Stage :removeKeyBoardAndJoyStick()

    local function outCopy()
        _G.g_Stage : exitCopy()
    end
    -- local tipsString = "还有很长一段路要走，回去好好锻炼吧"
    -- local passType = _G.g_Stage : getScenesPassType()
    -- --限时 在时间内,击败所有怪物
    -- if passType == _G.Constant.CONST_COPY_PASS_TIME then
    --     tipsString = "时间已到，闯关失败"
    -- --连击 击败所有怪物,并且最高连击数量达到要求
    -- elseif passType == _G.Constant.CONST_COPY_PASS_COMBO then
    --     tipsString = "时连击数没有达到，闯关失败"
    -- --生存模式 在限定时间内,HP大于0,并且场景内所有怪物消除
    -- elseif passType == _G.Constant.CONST_COPY_PASS_ALIVE then
    --     tipsString = "还有很长一段路要走，回去好好锻炼吧"
    -- end

    -- require "view/ErrorBox/ErrorBox"
    -- local errorBox = CErrorBox()
    -- local BoxLayer = errorBox : create(tipsString,outCopy)

    local container = CContainer : create()
    local bgSprite = CSprite : createWithSpriteFrameName( "battle_underframe.png" )
    local strSprite = CSprite : createWithSpriteFrameName( "battle_word_sw.png" )
    bgSprite : addChild( strSprite )
    container : addChild ( bgSprite )
    local winSize = CCDirector :sharedDirector(): getWinSize()
    local spSize = CCSizeMake( winSize.width, winSize.height )
    bgSprite :setPreferredSize( spSize )
    --bgSprite :setContentSize( spSize )


    container : setPosition( winSize.width/2, winSize.height/2)
    _G.g_Stage : addMessageView( container )

    -- local _fadeout = CCFadeIn :create( 3 )
    -- container : runAction( _fadeout )

    local _callBacks = CCArray:create()
    _callBacks:addObject(CCDelayTime:create(_G.Constant.CONST_BATTLE_DIE))
    _callBacks:addObject(CCCallFunc:create(outCopy))
    container:runAction( CCSequence:create(_callBacks) )


    require "controller/GuideCommand"
    local _guideCommand = CGuideNoticCammand( CGuideNoticCammand.ADD, _G.Constant.CONST_LOGS_7000 )
    _G.controller:sendCommand(_guideCommand)

end

-- [7060]场景时间同步(生存,限时类型) -- 副本
function CStageMediator.ACK_COPY_SCENE_TIME( self, _ackMsg )
    local remainingTime = _ackMsg : getTime() --剩余时间 秒数
    _G.g_Stage : setRemainingTime( remainingTime )
end

-- [23831]战斗信息块 -- 逐鹿台
function CStageMediator.ACK_ARENA_WAR_DATA( self, _ackMsg )
    data = _ackMsg : getData()
    if data == nil then
        --CCMessageBox("逐鹿台 信息块","ERROR")
        CCLOG("codeError!!!! 逐鹿台 信息块")
        return
    end
    property = CCharacterProperty()
    property : setUid( data : getUid() )
    property : updateProperty( _G.Constant.CONST_ATTR_NAME,  data : getName() )
    property : setPro( data : getPro() )
    property : setSex( data : getSex() )
    property : updateProperty( _G.Constant.CONST_ATTR_LV,  data : getLv() )
    property : updateProperty( _G.Constant.CONST_ATTR_WEAPON, data : getSkinWeapon() )
    property : updateProperty( _G.Constant.CONST_ATTR_ARMOR, data : getSkinArmor() )
    property : updateProperty( _G.Constant.CONST_ATTR_RANK, data : getRank() )


    --attr 角色基本属性块2002
    local attr = data : getAttr()
    if attr.is_data == true then
        property.attr : setIsData( attr.is_data )
        property : updateProperty( _G.Constant.CONST_ATTR_SP ,attr.sp )
        property : updateProperty( _G.Constant.CONST_ATTR_SP_UP ,attr.sp_speed )
        property : updateProperty( _G.Constant.CONST_ATTR_ANIMA ,attr.anima )
        property : updateProperty( _G.Constant.CONST_ATTR_HP ,attr.hp )
        property : updateProperty( _G.Constant.CONST_ATTR_HP_GRO ,attr.hp_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG ,attr.strong )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_GRO ,attr.strong_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC ,attr.magic )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC_GRO ,attr.magic_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_ATT ,attr.strong_att )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_DEF ,attr.strong_def )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_ATT ,attr.skill_att )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_DEF ,attr.skill_def )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT ,attr.crit )
        property : updateProperty( _G.Constant.CONST_ATTR_RES_CRIT ,attr.crit_res )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT_HARM ,attr.crit_harm )
        property : updateProperty( _G.Constant.CONST_ATTR_DEFEND_DOWN ,attr.wreck )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT ,attr.light )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT_DEF ,attr.light_def )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK ,attr.dark )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK_DEF ,attr.dark_def )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD ,attr.god )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD_DEF ,attr.god_def )
        property : updateProperty( _G.Constant.CONST_ATTR_BONUS ,attr.bonus )
        property : updateProperty( _G.Constant.CONST_ATTR_REDUCTION ,attr.reduction )
        property : updateProperty( _G.Constant.CONST_ATTR_IMM_DIZZ ,attr.imm_dizz )
    end
    _G.g_characterProperty : setChallengePanePlayInfo( property )

    local skillData = CSkillData()
    local skillList = data  : getSkillData()
    for _,data in pairs(skillList) do
        local pos = data : getEquipPos()
        local skillID = data : getSkillId()
        skillData : setSkillIdByIndex( skillID, pos )
    end
    --_G.g_SkillDataProxy : setCharacterSkill( data : getUid(), skillData )
    property : setSkillData( skillData )


    print("请求 角色数据")
    local msg = REQ_ROLE_PROPERTY()
    msg: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg: setUid( data : getUid() )
    msg: setType(0)
    _G.CNetwork : send( msg)

    -- if property :getCount() <= 0 then
    --     self : gotoScene( _G.Constant.CONST_ARENA_THE_ARENA_ID, _G.Constant.CONST_ARENA_SENCE_LEFT_X,_G.Constant.CONST_ARENA_SENCE_LEFT_Y )
    -- end


end

-- [23835]挑战奖励 -- 逐鹿台
function CStageMediator.ACK_ARENA_WAR_REWARD( self, _ackMsg )
    if _G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
        return
    end
    local res = _ackMsg : getRes( )
    local gold =_ackMsg : getGold( )
    local renown = _ackMsg : getRenown( ) --声望
    local view = CArenaFinishView( res, gold, renown )
    _G.g_Stage : addMessageView(view : container() )

    _G.g_Stage :removeKeyBoardAndJoyStick()
end

-- [37020]返回地图数据 -- 世界BOSS
function CStageMediator.ACK_WORLD_BOSS_MAP_DATA( self, _ackMsg )
    local now = _G.g_ServerTime : getServerTimeSeconds()
    local endTime = _ackMsg : getStime() --结束时间
    local startTime = _ackMsg : getTime()--开始时间
    local stime = endTime - now
    local scene = _G.g_Stage : getScene()
    if now < startTime then --如果开始时间比现在时间大..
        local function waitingFunc( )
            _G.g_Stage : setRemainingTime( endTime-startTime )
        end
        local _callBacks = CCArray:create()
        local waitingTime = startTime - now
        _callBacks:addObject(CCDelayTime:create(waitingTime))
        _callBacks:addObject(CCCallFunc:create(waitingFunc))
        scene :runAction( CCSequence:create(_callBacks) )
        waitingTime = startTime - now
        _G.g_Stage : setRemainingTime( waitingTime )
        _G.g_Stage : setBossTime(waitingTime-1)
        _G.g_Stage : runStrartStageAction()
    else
        if stime > 0 then
            _G.g_Stage : setRemainingTime( stime )
        else
            CCMessageBox("37020  时间错误","ERROR")
            CCLOG("codeError!!!! 37020  时间错误")
        end
    end
end

-- [37053]自己的DPS伤害 -- 世界BOSS
function CStageMediator.ACK_WORLD_BOSS_SELF_HP( self, _ackMsg )
    -- body
    -- local selfHarm = _ackMsg : getHarm()
    -- _G.g_Stage : setSelfDps( selfHarm )
    local selfPlayCharacter = _G.g_Stage : getPlay()
    selfPlayCharacter : setHP( _ackMsg : getHp() or 0 )
    -- print("ACK_WORLD_BOSS_SELF_HP",selfHarm,_ackMsg : getHp())
end
-- [37060]DPS排行 -- 世界BOSS
function CStageMediator.ACK_WORLD_BOSS_DPS( self, _ackMsg )
    if tonumber( _G.g_LoginInfoProxy:getUid() ) == _ackMsg : getUid() then
        local selfHarm = _ackMsg : getSelfHarm()
        _G.g_Stage : setSelfDps( selfHarm )
    end

    local dpsList = _ackMsg : getData()
    _G.g_Stage : setDpsList( dpsList )

end
-- [37051]是否开启鼓舞 -- 世界BOSS
function CStageMediator.ACK_WORLD_BOSS_VIP_RMB( self, _ackMsg )
    _G.g_Stage : setBossVipRmb( true )
end
-- [37071]伤害值广播 -- 世界BOSS boss收到伤害
function CStageMediator.ACK_WORLD_BOSS_HARM_S( self, _ackMsg )
    local harm = _ackMsg : getHarm()
    local bossHp = _ackMsg : getBossHp()
    _G.g_Stage : setBossHp( bossHp )
    _G.g_Stage : setBossHurtString( harm )
end
-- [37090]返回结果 -- 世界BOSS  返回复活时间和需要多少钱
function CStageMediator.ACK_WORLD_BOSS_WAR_RS( self, _ackMsg )
    --CCMessageBox("AAAAAAAAA  "..tostring(_ackMsg : getTime()).."   "..tostring(_ackMsg : getRmb()),"ccccc")
    _G.g_BattleView : showBossDeadView()
    _G.g_Stage : setBossDeadTime( _ackMsg : getTime() )
    _G.g_BattleView : setBossDeadTipsRMB( _ackMsg : getRmb() )
    local selfPlayCharacter = _G.g_Stage : getPlay()
    selfPlayCharacter : setHP( 0 )
    _G.g_Stage : removeKeyBoardAndJoyStick()
end
-- [37120]复活成功 -- 世界BOSS
function CStageMediator.ACK_WORLD_BOSS_REVIVE_OK( self, _ackMsg )
    self : reviveMain()
end
function CStageMediator.reviveMain( self )
    if _G.g_lpMainPlay : getHP() > 0 then
        return
    end
    local property = _G.g_characterProperty : getMainPlay()
    local uid = property : getUid()
    local name = property : getName()
    local pro = property : getPro()
    local hp = property : getAttr() : getHp()
    local sp = property : getAttr() : getSp()
    local lv = property : getLv()
    local sex = property : getSex()
    local country = property : getCountry()
    local skinId = property : getSkinArmor()
    local clanId = property : getClan()
    local clanName = property : getClanName()

    _G.g_lpMainPlay = nil
    _G.g_lpMainPlay = CPlayer( Constant.CONST_PLAYER )
    _G.g_lpMainPlay : playerInit( uid, name, sex, pro, lv, country, false, skinId )
    local x = _G.g_Stage : getMaplx() + 50
    local y = 100
    _G.g_lpMainPlay : init( uid , name, hp, hp, sp, sp, x, y, skinId )
    _G.g_lpMainPlay : setClanInfo(  clanId, clanName )

    -- local petSkinID = 10901
    -- _G.g_lpMainPlay : setPetSkinId( petSkinID )

    --if _G.g_SkillDataProxy : getInitialized() then --判断技能Proxy是否已初始化
        --local skillData = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )

        ----0831 change
        local roleProperty  = _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER)
        local skillData     = roleProperty :getSkillData()
        -------- end

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
            --发送数据,更新SkillDataProxy
            CCLOG("更新技能数据")
        end

    --end
    _G.g_Stage : addCharacter( _G.g_lpMainPlay )
    _G.g_Stage : setPlay( _G.g_lpMainPlay )
    _G.g_lpMainPlay : addBigHpView()
    _G.g_BattleView : hideBossDeadView()
    _G.g_Stage :addKeyBoard()
    _G.g_Stage :addJoyStick()
    _G.g_Stage : moveArea( x, y )

end

 -- [1012]断线重连返回 -- 角色
function CStageMediator.ACK_ROLE_LOGIN_AG_ERR(self, _ackMsg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create("连接成功")
        --BoxLayer : setPosition(-235,0)
    CCDirector:sharedDirector():getRunningScene():addChild(BoxLayer,100000)
end

-- [6030]释放技能广播 -- 战斗
function CStageMediator.ACK_WAR_SKILL( self, _ackMsg )
    local id = _ackMsg : getId()
    if _ackMsg : getType() == _G.Constant.CONST_PARTNER then
        id = tostring(_ackMsg : getUid())..tostring(id)
    end
    local lpCharacter = _G.CharacterManager : getCharacterByTypeAndID( _ackMsg : getType() ,id )
    if lpCharacter == nil then
        return
    end
    print("_ackMsg : getSkillId()",_ackMsg : getSkillId(),lpCharacter : getJumpAttackSkillID(),lpCharacter : getLocationZ())

    if( _ackMsg : getSkillId() == lpCharacter : getJumpAttackSkillID() )  and lpCharacter : getLocationZ() <= 0 then
        return
    end
    lpCharacter : useSkill( _ackMsg : getSkillId() )
end


--清除转场景的Mediator
function CStageMediator.cleanUpMediator( self )
    if _G.pmainView ~= nil then
        _G.pmainView :unregisterMainMediator()
    end

    if _G.pVipMediator ~= nil then
        _G.controller :unregisterMediator( _G.pVipMediator )
    end
    --副本 注销
    if _G.g_DuplicateMediator ~= nil then
        _G.controller : unregisterMediator( _G.g_DuplicateMediator )
        _G.g_DuplicateMediator = nil
    end
    --逐鹿台界面 注销
    if _G.pChallengePanelView ~= nil then
        _G.pChallengePanelView : cleanUpMediator()
        _G.pChallengePanelView = nil
    end
    --功能开放界面注销
    if _G.g_CFunctionMenuMediator ~= nil then
        controller :unregisterMediator( _G.g_CFunctionMenuMediator)
        _G.g_CFunctionMenuMediator = nil
    end
    --组队界面
    if _G.g_CGenerateTeamMediator ~= nil then
        _G.controller : unregisterMediator( _G.g_CGenerateTeamMediator )
        _G.g_CGenerateTeamMediator = nil
    end
    if _G.g_CBuildTeamMediator ~= nil then
        _G.controller : unregisterMediator( _G.g_CBuildTeamMediator )
        _G.g_CBuildTeamMediator = nil
    end
    if _G.g_CInviteTeammatesMediator ~= nil then
        _G.controller : unregisterMediator( _G.g_CInviteTeammatesMediator )
        _G.g_CInviteTeammatesMediator = nil
    end

    if _G.g_dialogView ~= nil then
        _G.g_dialogView :closeWindow()
        _G.g_dialogView = nil
    end
    if _G.tmpMainUi ~= nil then
        --_G.tmpMainUi :removeFromParentAndCleanup(true)
        --_G.tmpMainUi = nil
    end
    --拳皇生涯
    if _G.g_CKofCareerLayerMediator ~= nil then
         _G.controller : unregisterMediator( _G.g_CKofCareerLayerMediator )
        _G.g_CKofCareerLayerMediator = nil
    end
    --创建角色
    if _G.pCreateRoleSceneMediator ~= nil then
        _G.controller :unregisterMediator(_G.pCreateRoleSceneMediator)
        _G.pCreateRoleSceneMediator = nil
    end
    --活动
    if _G.g_worldBossPanelMediator ~= nil then
        _G.controller :unregisterMediator(_G.g_worldBossPanelMediator)
        _G.g_worldBossPanelMediator = nil
    end

    -- --活动图标
    -- if _G.pActivityIconMediator then
    --     controller :unregisterMediator( _G.pActivityIconMediator)
    --     _G.pActivityIconMediator = nil
    -- end
    --招财面板
    if _G.g_CLuckyLayerMediator ~= nil then
       controller :unregisterMediator(_G.g_CLuckyLayerMediator)
       _G.g_CLuckyLayerMediator = nil
       print("CStageMediator unregisterMediator.g_CLuckyLayerMediator 149")
    end
end

function CStageMediator.closeSomeView( self )
    if _G.g_CKingOfFlightersInfoView ~= nil then
        print("dddddddddd03",_G.g_CKingOfFlightersInfoView)
        _G.g_CKingOfFlightersInfoView : removeScene()
        _G.g_CKingOfFlightersInfoView = nil
        print("eeeeeee")
    end
end

function CStageMediator.unregisterAllScheduler( self )
    --删除所有帧回调
    if _G.g_ScheduleUpdateHandle ~= nil then
        _G.Scheduler : unschedule( _G.g_ScheduleUpdateHandle )
        _G.g_ScheduleUpdateHandle = nil
    end
    _G.Scheduler :unAllschedule()
end

function CStageMediator.cleanXML( self )
    _G.g_SkillXmlManager : clean()
    _G.g_SkillEffectXmlManager : clean()
    _G.g_SkillColliderXmlManager : clean()
end

function CStageMediator.gotoScene( self,  _ScenesID, _x, _y, _hp, _maxHp )
    self : unregisterAllScheduler()
    self : cleanXML()
    local mgscommand = CGotoSceneCommand()
    _G.controller:sendCommand(mgscommand)
    self : closeSomeView()
    --
    CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
    --暂停TCP接受
    _G.CNetwork : pause()
    CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents(false)
    local lastScenesType =  _G.g_Stage : getScenesType()

    local loading = CLoadingScenes()
    local function loadScenes( evenType, _schedule, _allSchedule )
        if evenType == "LoadProgress" then
            local Percentage = _schedule / _allSchedule
            loading : setPercentage( Percentage )
        elseif evenType == "LoadComplete" then
            self : finishGotScene( _ScenesID, _x, _y, lastScenesType )
        end
    end
    _G.g_Stage : removeStageMediator()
    local meaterialID = _G.StageXMLManager : getMaterialIDByScenesID( _ScenesID )
    if meaterialID == nil then
        CCMessageBox("进入场景meaterialID为空","Error")
        CCLOG("进入场景meaterialID为空")
        return
    end
    local scenes  = loading : create( meaterialID, loadScenes )
    CCDirector : sharedDirector() : pushScene( scenes )
    CResourceLoader:sharedResourceLoader():clearUnusedResources()

    --开启TCP接受
    --_G.CNetwork : resume()
    --CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents( true )

    self : cleanUpMediator()
end


function CStageMediator.clanNameUpdate( sefl, data )
    --更新帮派名字 --会进行两次更新
    local play = _G.g_Stage : getPlay()
    local playProperty = _G.g_characterProperty : getMainPlay()
    if play == nil or playProperty == nil then
        return
    end
    print("fuck fuck")
    play : setClanInfo( playProperty:getClan(),playProperty:getClanName() )
end

function CStageMediator.openCharacterView( self, data)
    print( "请求打开其他玩家 UID:",data)
    require "view/CharacterPanelLayer/CharacterCheckPanelView"
    CCDirector :sharedDirector() :pushScene( CCTransitionShrinkGrow:create(0.5,_G.g_CCharacterCheckPanelView :scene( data))) --self.m_role.uid
end

function CStageMediator.finishGotScene( self, _ScenesID, _x, _y, lastScenesType )

    local xml = _G.StageXMLManager : getXMLScenes( _ScenesID )
    local nowSceneType = tonumber(xml : getAttribute("scene_type"))
    _G.CNetwork : resume()
    local function isAction( _isact)
        _G.g_characterProperty : cleanUp()
        -- {一定要做这个操作.不然你会死定}
        CResourceLoader : sharedResourceLoader() : removeLuaAllEventListener()

        _G.g_Stage : releaseResource()
        --end
        _G.g_Stage = nil
        _G.g_Stage = CStage()
        local newScenes = _G.g_Stage : create()
        _G.g_Stage : addStageMediator()

        CCDirector : sharedDirector () : popToRootScene()
        if _isact == true then  --连跳场景
            CCDirector:sharedDirector():replaceScene( CCTransitionSplitCols:create(0.5, newScenes))
        elseif _isact == false then
            CCDirector:sharedDirector():replaceScene(  newScenes )
        end
        _G.CharacterManager : init() -- 每次都要初始一次角色管理
        _G.g_Stage : init( _ScenesID, _x, _y )

        if _G.g_Stage :checkPlotHas() ~= true then
            _G.g_Stage : runStrartStageAction()
        end
    end
    --逐鹿台弹出
    if lastScenesType == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL then
        isAction( false)
        _G.pChallengePanelView = CChallengePanelView()
        CCDirector :sharedDirector() : pushScene( CCTransitionSplitCols:create(0.5,_G.pChallengePanelView :scene()) )
        CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents( true )
    elseif lastScenesType == _G.Constant.CONST_MAP_TYPE_KOF then
    --发信息给服务器。请求格斗之王
        isAction( false)
        require "common/protocol/auto/REQ_WRESTLE_BOOK"
        local msg = REQ_WRESTLE_BOOK()
        CNetwork  : send(msg)
    elseif nowSceneType == _G.Constant.CONST_MAP_TYPE_CITY and _G.g_IsKofCareer ~= nil and _G.g_IsKofCareer == true then
        _G.g_characterProperty : resetMainPlayHp()
        isAction( false)
        CCDirector : sharedDirector () : pushScene(CKofCareerLayer () :scene())
        _G.g_IsKofCareer = false
    else
        isAction( true)
    end
end