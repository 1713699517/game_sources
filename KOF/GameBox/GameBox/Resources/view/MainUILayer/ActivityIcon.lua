--活动图标

require "view/view"

--08.08 日常任务
require "view/DailyTaskUI/DailyTaskUI"
require "proxy/FunctionOpenProxy"
require "view/TaskUI/TaskDialogView"
require "view/LuckyLayer/LuckyLayer"
require "view/SignIn/SignInView"
require "view/ChallengePanelLayer/ChallengePanelView"
require "view/Furinkazan/FurinkazanView"
require "view/EquipInfoView/EquipInfoView"
require "view/VipUI/VipUI"
require "view/OneArrowEveryDay/OneArrowEveryDayView"
require "view/KofCareer/KofCareerLayer"
require "view/Shikigami/ShikigamifoView"
require "view/KingOfFlighters/KingOfFlightersInfoView"
require "controller/GuideCommand"

CActivityIcon = class(view, function( self )
-- body
    self.m_GLOpen = true --游戏攻略开关
end)


function CActivityIcon.layout(self, winSize)
    
    if winSize.height == 640 then
        
        
        local nIconSize = self.m_iconLayout : getCellSize();
        self.m_iconLayout :setPosition( winSize.width - 510, winSize.height - nIconSize.height / 2 - 7 )
        
        elseif winSize.height == 768 then
        CCLOG("768--activi")
    end
    
end


function CActivityIcon.addMediator( self )
    require "mediator/ActivityIconMediator"
    self :removeMediator()
    
    _G.pActivityIconMediator = CActivityIconMediator(self)
    controller :registerMediator( _G.pActivityIconMediator)
end

--注销mediator
function CActivityIcon.removeMediator( self)
    if _G.pActivityIconMediator then
        controller :unregisterMediator( _G.pActivityIconMediator)
        _G.pActivityIconMediator = nil
    end
end

function CActivityIcon.releaseParams(self)
    
end

function CActivityIcon.init(self, winSize, layer)
    --self :addMediator()
    self :loadResources()
    
    self :initView( layer )
    self :layout( winSize )
    
    self :setRoleBuffIcon()
    self :setDailyTaskTimes()
    self :sendNetWork_LuckyTimes() --jun
end

function CActivityIcon.loadResources( self )
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("GuiderBtnResources/GuiderResources.plist")
end

function CActivityIcon.initFunctionParams( self)  --根据功能按钮参数初始化
    if _G.pCFunctionOpenProxy :getInited() then
        self.m_count = _G.pCFunctionOpenProxy :getCount()
        
        if self.m_count ~= nil and self.m_count > 0 then            --功能按钮个数
            self.m_sysId = _G.pCFunctionOpenProxy :getSysId()       --功能按钮id
            --[[
             for k, v in pairs( self.m_sysId) do
             print( "活动按钮开放ID-->", k, v)
             end
             --]]
        end
    end
    
end

function CActivityIcon.addIconBtnById( self, _layer, _id, _use )
    
    local nFuncId = tonumber( _id or 0 )
    local bUse    = tonumber( _use or 0 )        -- 1:使用过  0:未使用
    print("1990", bUse)
    
    print("活动按钮id", nFuncId)
    local szSprName = nil
    local szBtnName = nil
    
    if nFuncId == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then                    -- 任务指引     10011 CONST_FUNC_OPEN_TASK_GUIDE
        if self.btnTaskGuider then
            self.btnTaskGuider :setVisible( true)       --需要修改显示方式
        end
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ELITE then                -- 精英副本     10120 CONST_FUNC_OPEN_ELITE
        szSprName = nil    --"menu_activity_assistant.png"
        szBtnName = nil    --"背包"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_INLAY then                -- 每日签到     10140 CONST_FUNC_OPEN_INLAY
        szSprName = "menu_activity_sign_icon.png"
        szBtnName = "每日签到"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_LISTS then                -- 竞技场｀     10150 CONST_FUNC_OPEN_LISTS
        szSprName = "menu_activity_arena.png"
        szBtnName = "竞技场"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_MONEYTREE then            -- 招财 ｀    10160 CONST_FUNC_OPEN_MONEYTREE
        szSprName = "menu_activity_wealth_icon.png"
        szBtnName = "招财"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_DEVIL then                -- 魔王副本     10200 CONST_FUNC_OPEN_DEVIL
        --szSprName = "menu_activity_sign.png"
        --szBtnName = "魔王副本"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_STRENGTH then                -- 日常任务     10220 CONST_FUNC_OPEN_STRENGTH
        szSprName = "menu_activity_dailytask.png"
        szBtnName = "每日任务"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_GAMBLE then                -- 翻翻乐     10250 CONST_FUNC_OPEN_GAMBLE
        szSprName = "menu_activity_ffl_icon.png"
        szBtnName = "翻翻乐"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_WEAPON then                -- 每日一箭       10260 CONST_FUNC_OPEN_WEAPON
        szSprName = "menu_activity_arrow_icon.png"
        szBtnName = "每日一箭"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_OVERCOME then                -- 拳皇生涯     10310 CONST_FUNC_OPEN_OVERCOME
        szSprName = "menu_activity_career_icon.png"
        szBtnName = "拳皇生涯"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_CHAPER_SHOP then             -- 特惠商店     10009
        szSprName = "menu_activity_superstore.png"
        szBtnName = "特惠商店"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_DISCOVER_STORE then          -- 宝箱探秘     10008
        szSprName = "menu_activity_draw_cion.png"
        szBtnName = "宝箱探秘"
        
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_BOSS then
        szSprName = "menu_activity_many_icon.png"
        szBtnName = "多人活动"
        elseif nFuncId == 10180 then
        --szSprName = "menu_activity_sign.png"
        --szBtnName = "vip界面"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ELIMINATE then                --
        szSprName = "menu_activity_wonderful_icon.png"
        szBtnName = "精彩活动"
        elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ACTIVE then
        szSprName = "menu_activity_active_icon.png"
        szBtnName = "活跃度"
        elseif nFuncId == 11020 then
        
        elseif nFuncId == 11000 then
        szSprName = "menu_activity_sign.png"
        szBtnName = "格斗之王"
    end
    
    if nFuncId ~= nil then
        --self :createActivityBtnByIndex( nFuncId, szSprName, szBtnName, _layer)
        self :createActivityBtnByIndex( nFuncId, szSprName, szBtnName, _layer,bUse) --jun
    end
    

end

--{根据功能开放id添加活动图标}
function CActivityIcon.addBtnBySysId( self, _layer)
    if self.m_count ~= nil  and self.m_sysId ~= nil and _layer ~= nil then
        for key, value in pairs( self.m_sysId) do
            self :addIconBtnById( _layer, value.id, value.use )
        end
    end
end

--{创建活动按钮}
function CActivityIcon.createActivityBtnByIndex( self, _index, _szSprName, _szBtnName, _layer,_bUse)
    print("CActivityIcon.createActivityBtnByIndex==",_index, _szSprName, _szBtnName, _layer,_bUse)
    if _index == nil or _szSprName == nil or _szBtnName == nil or _layer == nil then
        return
    end
    
    print("vvv1")
    
    _btnIndex   = tostring( _index )
    _szBtnName  = tostring( _szBtnName )
    _szSprName  = tostring( _szSprName )
    _bUse       = tonumber( _bUse )
    --
    local nNum = nil
    if self["m_activityNum_".._btnIndex] ~= nil then
        print("vvv12")
        nNum = tonumber( self["m_activityNum_".._btnIndex] )
    end
    
    print("vvv5")
    if self["m_activiBtn".._btnIndex] ~= nil then
        _layer :removeChild( self["m_activiBtn".._btnIndex])
        self["m_activiBtn".._btnIndex]   = nil
        self["effectsCCBI" .. _btnIndex] = nil 
    end
    print("vvv6")
    local function activityBtnCallback( eventType, obj, x, y)
        return self :onActivityBtnCallback( eventType, obj, x, y)
    end
    
    self["m_activiBtn".._btnIndex] = CButton :createWithSpriteFrameName( "", tostring( _szSprName ) )
    self["m_activiBtn".._btnIndex] :setFontSize( 17)
    self["m_activiBtn".._btnIndex] :setControlName("this CSystemMenu self[m_activiBtn.._btnIndex]".. _szSprName .." 169")
    self["m_activiBtn".._btnIndex] :setTag( tonumber( _index))
    self["m_activiBtn".._btnIndex] :registerControlScriptHandler( activityBtnCallback, "this CSystemMenu self[m_activiBtn.._btnIndex] 169")
    
    if self["m_activiBtn".._btnIndex] ~= nil then
        _layer :addChild( self["m_activiBtn".._btnIndex], 10 )
    end
    
    print("asdadada", _btnIndex)
    
    
    if nNum ~= nil and nNum >= 0 then        --添加小图片
        self :addSmallSpr( _btnIndex, nNum )
    end
    print("asdasqweqasdfsdf", nNum)
    print("创建 CActivityIcon的按钮-->", _index, _szSprName,  _szBtnName, self["m_activiBtn".._btnIndex], "\n")

    if _index == _G.Constant.CONST_FUNC_OPEN_BOSS then
        require "common/protocol/auto/REQ_ACTIVITY_REQUEST" -- [30510]请求活动数据 -- 活动面板  --判断是否有活动显示图标特效
        local msg4 = REQ_ACTIVITY_REQUEST()
        CNetwork : send( msg4 )
    end

    if _bUse ==  0  then       -- 1:使用过  0:未使用
        self : Create_effects_activity(self["m_activiBtn".._btnIndex],_btnIndex,1) --ICON图标特效
    end

    local isCCBIcreate =  _G.g_GameDataProxy : getIsActivityIconCCBIcreate() 
    if isCCBIcreate == 0  then 
        if tonumber(_btnIndex)  == tonumber(_G.Constant.CONST_FUNC_OPEN_ELIMINATE)  then
            self : NetWorkReturn_CARD_NOTICE() --精彩活动特效添加
        end
    end

    if _G.g_GameDataProxy : getIsActivenessCCBIHere() then
        if tonumber(_btnIndex) == _G.Constant.CONST_FUNC_OPEN_ACTIVE then
            self:createActivenessCCBI()
        end
    end
end

function CActivityIcon.getActivityBtnByIndex( self, _index )
    return self.m_iconLayout : getChildByTag( tonumber(_index) )
end

--{根据 _index按钮id 和 _num数字 显示小图标}
function CActivityIcon.addSmallSpr( self, _btnIndex, _num )
    --按钮上的小叔子缓存
    --if _btnIndex == _G.Constant.CONST_FUNC_OPEN_STRENGTH then
    --    print("debuggg", debug.traceback() )
    --
    if _num == nil then
        self :moveActivityButton(_btnIndex)
        return
    end

    if _num ~= nil and _num > 0 and self["m_activityNum_".._btnIndex] == nil and self["m_activiBtn" .. _btnIndex] == nil then
        self :addIconBtnById( self.m_iconLayout, _btnIndex, 0 )
    end
    
    if _num ~= nil then
        self["m_activityNum_".._btnIndex] = tonumber( _num )
    end
    
    --print("CActivityIcon.addSmallSpr11111", _btnIndex, _num  )
    --如果都存在就清除
    if self["m_spr".._btnIndex] ~= nil and self["m_activiBtn".._btnIndex] ~= nil then
        self["m_activiBtn".._btnIndex] : removeChild( self["m_spr".._btnIndex] )
        self["m_spr".._btnIndex] = nil
    end
    --print("清除缓存", self["m_spr".._btnIndex])
    if _btnIndex == nil or _num == nil or self["m_activiBtn".._btnIndex] == nil or tonumber( _num ) <= 0 then
        return
    end
    
    local _szSprName = "menu_tag.png"
    self["m_spr".._btnIndex]      = CSprite :createWithSpriteFrameName( tostring( _szSprName ) )
    self["m_spr".._btnIndex]      : setControlName( "this CActivityIcon.addSmallSpr _btnIndex".._btnIndex)
    
    local _sprSize  = self["m_spr".._btnIndex] :getPreferredSize()
    _num = tonumber( _num )
    local nlength = string.len( _num )
    
    local nDistanceX = 0
    if nlength >= 3 then
        self["m_spr".._btnIndex] :setPreferredSize( CCSizeMake( _sprSize.width * 1.12 *( nlength / 3), _sprSize.height) )
        nDistanceX = 5 * ( nlength / 3 )
    end
    
    --self["m_spr".._btnIndex]  :setPreferredSize( CCSizeMake( _sprSize.width / 2, _sprSize.height / 2 ) )
    self["m_activiBtn".._btnIndex] :addChild( self["m_spr".._btnIndex], 20 )
    local _btnSize  = self["m_activiBtn".._btnIndex] :getPreferredSize()
    self["m_spr".._btnIndex]  :setPosition(  ( _btnSize.width - _sprSize.width / 1.0 ) * 0.5, ( _btnSize.height - _sprSize.height / 2 ) * 0.5 )
    
    --计算num 图片的size
    
    for i=1, nlength do
        local theNum = string.sub( _num, i, i )
        
        local _szTagNumName = "menu_tag_0" .. tostring( theNum ) .. ".png"
        
        local _sprNum  = CSprite :createWithSpriteFrameName( tostring( _szTagNumName ) )
        self["m_spr".._btnIndex] :addChild( _sprNum, 20 )
        
        local _sprNumSize = _sprNum :getPreferredSize()
        if nlength <= 1 then
            break
        end
        _sprNum :setPosition( ccp( -( _sprNumSize.width ) * ( nlength - i) + _sprNumSize.width / 2 + nDistanceX, 0 ) )
    end
    
    --打印信息
    print("CActivityIcon.addSmallSpr2222", _btnIndex, _num, self["m_activiBtn".._btnIndex] :getText(), self["m_spr".._btnIndex] )
end

--删除按钮
function CActivityIcon.moveActivityButton( self, _btnIndex )
    print("----3333-----",_btnIndex,debug.traceback())
    if self.m_iconLayout == nil then
        return
    end

    if self["m_activiBtn".._btnIndex] ~= nil then
        self : removeFirstClickCCBI( _btnIndex )
        
        self.m_iconLayout : removeChild( self["m_activiBtn".._btnIndex] )
        self["m_activiBtn".._btnIndex] = nil
        
        --按钮上得标识小数字 也 赋值为nil
        self["m_activityNum_".._btnIndex] = nil
    end
end

function CActivityIcon.openActivityViewById( self, _nId, _noClear)
    CCLOG("点击了活动按钮  "..tostring( _nId))
    nFuncId = tonumber( _nId)
    
    if nFuncId == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then               -- 任务指引     10011 CONST_FUNC_OPEN_TASK_GUIDE\
        --任务指引
        CCLOG("任务指引")
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ELITE then                -- 精英副本     10120 CONST_FUNC_OPEN_ELITE\
        CCLOG("临时的背包界面")
        require "view/BackpackLayer/BackpackView"
        _G.pBackpackView = CBackpackView :scene()
        self :pushLuaScene( _G.pBackpackView ) 
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_INLAY then                -- 每日登录     10140 CONST_FUNC_OPEN_INLAY\
        self :pushLuaScene(  CSignInView () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_LISTS then                -- 竞技场     10150 CONST_FUNC_OPEN_LISTS\
        local mainProperty  = _G.g_characterProperty : getMainPlay()
        if mainProperty ~= nil then
            if mainProperty : getLv() < _G.Constant.CONST_ARENA_YES_ARENA then
                --CCMessageBox(_G.Constant.CONST_ARENA_YES_ARENA.."级即可进入竞技场", "")
                local msg = _G.Constant.CONST_ARENA_YES_ARENA.."级即可进入竞技场"
                self : createMessageBox(msg)
                return
            end
        end
        _G.pChallengePanelView = CChallengePanelView()
        self :pushLuaScene( _G.pChallengePanelView :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_MONEYTREE then            -- 招财     10160 CONST_FUNC_OPEN_MONEYTREE\
        CCLOG("招财")

        _G.pLuckyLayer = CLuckyLayer ()
        _G.tmpMainUi   : addChild(_G.pLuckyLayer :layer() , 22)
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_DEVIL then                -- 魔王副本     10200 CONST_FUNC_OPEN_DEVIL\
        --CCLOG("在魔王副本界面")
        --CCDirector : sharedDirector () : pushScene(CShikigamiInfoView () :scene())
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_STRENGTH then                -- 日常任务     10220 CONST_FUNC_OPEN_STRENGTH\
        self :openDailyTaskView()
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_GAMBLE then                -- 翻翻乐     10250 CONST_FUNC_OPEN_GAMBLE\
        
        if self.m_FurinkazanTimes ~= nil and self.m_FurinkazanIsGet ~= nil then
            if tonumber(self.m_FurinkazanTimes) == 0 then
                --CCMessageBox( "今天没有剩余次数了", "翻翻乐" )
                local msg = "今天没有剩余次数了"
                self : createMessageBox(msg)
            else
                self :pushLuaScene( CFurinkazanView () :scene( self.m_FurinkazanTimes, self.m_FurinkazanIsGet ))
            end
        end
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_WEAPON then                -- 每日一箭、10260 CONST_FUNC_OPEN_WEAPON\
        self :pushLuaScene( COneArrowEveryDayView () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_OVERCOME then                -- 拳皇生涯     10310 CONST_FUNC_OPEN_OVERCOME\
        self :pushLuaScene( CKofCareerLayer () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_BOSS then
        CCLOG("多人活动")

        require "view/WorldBossPanelLayer/WorldBossPanelView"
        _G.pWorldBossPanelView = CWorldBossPanelView()
        self :pushLuaScene( _G.pWorldBossPanelView :scene() )
        --[[
         --BOSS
         local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_FLY"])
         tempCommand : setOtherData({mapID = _G.Constant.CONST_BOSS_HUMAN_SENCE})
         _G.controller: sendCommand(tempCommand)
         ]]
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == 10180 then
        CCLOG("--测试vip界面")
        --local vipUI = CVipUI()
        --CCDirector :sharedDirector() :pushScene( vipUI:scene())
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_WEAPON then
        --CCDirector : sharedDirector () : pushScene(COneArrowEveryDayView () :scene())
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ACTIVE then
        CCLOG("活跃度")
        require "view/Activeness/ActivenessView"
        self :pushLuaScene( CActivenessView () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ELIMINATE then
        CCLOG("精彩活动")
        
        _G.g_GameDataProxy : setIsActivityIconCCBIcreate(1) --精彩活动特效   

        self : removeCONST_FUNC_OPEN_ELIMINATE_CCBI() --删除精彩活动ccbi

        require "view/Activities/ActivitiesView"
        self :pushLuaScene( CActivitiesView () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == 11000 then
        CCLOG("格斗之王")
        require "view/Activities/ActivitiesView"
        --CCDirector : sharedDirector () : pushScene(CKingOfFlightersInfoView () :scene())
        ----[[
        require "common/protocol/auto/REQ_WRESTLE_BOOK"
        local msg = REQ_WRESTLE_BOOK()
        CNetwork  : send(msg)
        print("REQ_WRESTLE_BOOK 54801 发送完毕 ")
        --]]--
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_CHAPER_SHOP then      --特惠商店
        CCLOG("特惠商店！")
        require "view/SuperDealsShop/SuperDealsShopLayer"
        self :pushLuaScene( CSuperDealsShopLayer () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_DISCOVER_STORE then      --宝箱探秘
        CCLOG("宝箱探秘！")
        require "view/TreasureQuest/TreasureQuestView"
        self :pushLuaScene( CTreasureQuestView () :scene() )
        ------------------------------------------------------------------------------------------------------------------------------
    elseif nFuncId == _G.Constant.CONST_FUNC_OPEN_ENERGY_TIME then      --请求体力物品
        CCLOG( "请求请求领取buff 1375")
        require "common/protocol/REQ_ROLE_BUFF_REQUEST"
        local msg = REQ_ROLE_BUFF_REQUEST()
        CNetwork :send( msg )
        CCLOG( "请求成功")
    end

    if _noClear == nil then
        self : IsremoveFirstClickCCBI( nFuncId ) --先判断是不是多人活动 然后在判断是不是第一次 如果是第一次按的就删了你
        self : NetWorkSend_REQ_ROLE_USE_SYS(nFuncId)
    end

    return true
end

function CActivityIcon.onActivityBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local nId = obj :getTag()
        
        self :openActivityViewById( tonumber( nId ) )
        --关闭功能按钮
        if _G.pCFunctionMenuView ~= nil and _G.pCFunctionMenuView :getMenuStatus() == true then
            _G.pCFunctionMenuView :setMenuStatus( false )
        end
        
        local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
        controller :sendCommand( closeCommand )
        return true
    end
end

--{任务指引按钮}
function CActivityIcon.addTaskGuideBtn( self )
    local function taskGuiderCallback( eventType, obj, x, y )
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
            
        elseif eventType == "TouchEnded" then
            print("taskGuider!", eventType, obj :getTag())
            self :onGuiderTask()
            self :setGuideStepFinish()
            local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
            controller :sendCommand( closeCommand )
            return true
        end
    end
    
    if self.btnTaskGuider ~= nil then
        self.btnTaskGuider :removeFromParentAndCleanup( true )
        self.btnTaskGuider = nil
    end
    
    local _szSprName = "menu_task_guide.png"
    local _firstSpr = "menu_task_guide.png"
    local _secondSpr = nil
    local _thirdSpr = nil
    
    --如果当前任务存在则 根据任务显示相应按钮图片        调查副本,寻找npc,击杀boss
    if _G.g_CTaskNewDataProxy ~= nil then
        local guiderTask = _G.g_CTaskNewDataProxy :getMainTask()
        if guiderTask ~= nil then
            local _target_type = tonumber( guiderTask.target_type or -1 )
            local _beginNpc    = tonumber( guiderTask.beginNpc or -1 )
            local _endNpc      = tonumber( guiderTask.endNpc or -1 )
            local _state       = tonumber( guiderTask.state or -1 )
            
            
            print( "状态打印", _target_type, _state, _beginNpc, _endNpc )
            if _state == _G.Constant.CONST_TASK_STATE_ACTIVATE or _state == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then       --可接受 2
                --找beginNpc  1
                _firstSpr, _thirdSpr = self :getFirstSpriteName( 1)
                _secondSpr = self :getSecondSpriteName( self :getNpcHeadId( _beginNpc ) )
                
            elseif _state == _G.Constant.CONST_TASK_STATE_FINISHED then         --已完成 4
                --找endNpc 1
                _firstSpr, _thirdSpr = self :getFirstSpriteName( 1)
                _secondSpr = self :getSecondSpriteName( self :getNpcHeadId( _endNpc ) )
                
            elseif _state == _G.Constant.CONST_TASK_STATE_UNFINISHED then       --未完成 3
                if _target_type == _G.Constant.CONST_TASK_TARGET_TALK then          --1   1     --3,4 找endNpc
                    --找endNpc 1
                    _firstSpr, _thirdSpr = self :getFirstSpriteName( 1)
                    _secondSpr = self :getSecondSpriteName( self :getNpcHeadId( _endNpc ) )
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_COLLECT then   --2   0
                
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_KILL then      --3   0
                
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_PK then        --4   0
                
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_ASK then       --5   0
                
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_OTHER then     --6   1     --1,2, 4 都找npc
                    --其他
                elseif _target_type == _G.Constant.CONST_TASK_TARGET_COPY then      --7   1     --1,2,4找npc,3找副本
                    local _copyId = tonumber( guiderTask.copy_id or - 1 )
                    --通过副本id 拿 .desc值("0" 则调查副本，否则 击杀boss)
                    local _sceneCopyNode = _G.g_CTaskNewDataProxy :getScenesCopysNodeByCopyId( _copyId )
                    local _desc = 0
                    if _sceneCopyNode ~= nil and not _sceneCopyNode :isEmpty() then
                        _desc = tonumber( _sceneCopyNode :getAttribute("desc") or 0 )
                    end
                    
                    local _firstTag = 3
                    if _desc == 0 then
                        _firstTag = 2
                    end
                    _firstSpr, _thirdSpr = self :getFirstSpriteName( _firstTag )
                    --拿到第二张图
                    _secondSpr = self :getSecondSpriteName( _desc )
                    
                end
            end
            
                
        end
    end
    
    print( "--0-0---0>1", _firstSpr, "   2---", _secondSpr,"   3---", _thirdSpr )
    --任务指引
    self.btnTaskGuider = CButton :createWithSpriteFrameName("", _firstSpr )
    self.btnTaskGuider : setControlName( "this CActivityIcon self.btnTaskGuider 159 ")
    self.btnTaskGuider :registerControlScriptHandler( taskGuiderCallback, "this CActivityIcon self.btnTaskGuider 160")
    self.btnTaskGuider :setTouchesPriority( - 29 )
    
    self.m_layer :addChild( self.btnTaskGuider)
    
    local winSize       = CCDirector :sharedDirector() :getVisibleSize()
    local nBtnSize      = self.btnTaskGuider : getContentSize()
    self.btnTaskGuider  : setPosition( winSize.width - nBtnSize.width / 2, winSize.height - nBtnSize.height * 3.5)
    
    if _secondSpr ~= nil then
        local _pmiddleSpr = CSprite :createWithSpriteFrameName( _secondSpr )
        self.btnTaskGuider :addChild( _pmiddleSpr, 9 )
    end
    
    if _thirdSpr ~= nil then
        local _pwordSpr = CSprite :createWithSpriteFrameName( _thirdSpr )
        self.btnTaskGuider :addChild( _pwordSpr, 10 )
        
        _pwordSpr :setPosition( ccp( 0, -nBtnSize.height / 2))
    end
end

function CActivityIcon.getNpcHeadId( self, _npcId )
    local _sceneNpcNode = _G.g_CTaskNewDataProxy :getNpcNodeById( _npcId or 0 )
    
    local _retHeadId = nil
    if _sceneNpcNode ~= nil and _sceneNpcNode :isEmpty() == false then
        _retHeadId = _sceneNpcNode :getAttribute( "head" )
    end
    
    return _retHeadId
end

function CActivityIcon.getFirstSpriteName( self, _index )
    --底图
    local ret1Name = nil
    local ret3Name = nil
    if  _index == 1 then                      --寻找
            ret1Name = "guide_xzframe.png"
            ret3Name = "guide_word_xz.png"
        elseif _index == 2 then               --调查
            ret1Name = "guide_dcframe2.png"
            ret3Name = "guide_word_dc.png"
        elseif _index == 3 then               --击杀
            ret1Name = "guide_jsframe2.png"
            ret3Name = "guide_word_js.png"
    end
    return ret1Name, ret3Name
end

function CActivityIcon.getSecondSpriteName( self, _desc )
    ---中间logo
    local retName = nil
    if  _desc ~= nil and _desc ~= 0 then
       retName = "sg" .. tostring( _desc or "10301") .. ".png"
    end
    return retName
end


--新手引导点击命令
function CActivityIcon.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end

function CActivityIcon.getTaskGuideBtn( self )
    if self.btnTaskGuider ~= nil then
        return self.btnTaskGuider
    end
    return nil
end

function CActivityIcon.initView(self, _layer)
    
    self :addTaskGuideBtn( )
    self.btnTaskGuider :setVisible( false )
    
    if self.m_pContainer ~= nil then
        self.m_pContainer :removeFromParentAndCleanup( true)
        self.m_pContainer = nil
    end
    self.m_pContainer = CContainer :create()
    _layer :addChild( self.m_pContainer)
    
    self :addIconLayout()
    
    self.m_bOpenOrClose = false
    
    if self.m_iconLayout ~= nil then
        self :initFunctionParams( )
        self :addBtnBySysId( self.m_iconLayout)
    end
    
    --print("_G.pCDailyTaskProxy1111", _G.pCDailyTaskProxy, _G.pCDailyTaskProxy :getInited())
    if _G.pCDailyTaskProxy ~= nil and _G.pCDailyTaskProxy :getInited() == true then
        local l_dailyData = _G.pCDailyTaskProxy :getDailyTaskData()
        if l_dailyData == nil then
            return
        end
        --[[  hlc 0906 注释diao
         if l_dailyData.state == 1 then
         self :openDailyTaskView()
         end
         --]]
    end
end

function CActivityIcon.addIconLayout( self)
    --设置水平数量
    if self.m_iconLayout ~= nil then
        self.m_iconLayout :removeFromParentAndCleanup( true)
        self.m_iconLayout = nil
    end
    self.m_iconLayout = CHorizontalLayout :create()
    
    self.m_iconLayout :setLineNodeSum( 5 )
    --self :setIconCellSize( 90, 90 )
    
    --self.m_iconLayout :setHorizontalDirection( false ) --水平  从右至左
    self.m_iconLayout :setVerticalDirection( false )  --垂直  从上至下
    self.m_iconLayout :setCellHorizontalSpace( 2 )
    
    self.m_pContainer :addChild( self.m_iconLayout )
    
    local nIconSize = self.m_iconLayout : getCellSize()
    local winSize   = CCDirector :sharedDirector() :getVisibleSize()
    self.m_iconLayout :setPosition( winSize.width - 510, winSize.height - nIconSize.height / 2 - 7 )
end



function CActivityIcon.getIconState( self )
    print( self.m_bOpenOrClose )
    return self.m_bOpenOrClose;
    
end


--设置显示图标数量
function CActivityIcon.setIconNumber(self, _nIconNumber)
    
end



function CActivityIcon.setIconCellSize( self, _nWidth, _nHeight )
    -- body
    self.m_iconLayout :setCellSize( CCSizeMake( _nWidth, _nHeight) )
end

--icon映射事件
function CActivityIcon.iconSelectCallback(eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        
        local nTag = obj :getTag()
        print(nTag)
        
        --local objSelf = obj.view
        
        if nTag == 8 then
            else
            
        end
        
    end
end



-----------------
--06.28图标点击回调
function CActivityIcon.onIconCallback( self, eventType, obj, x, y ) --招财按钮回调
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        CCLOG("onIconCallback, %d", obj:getTag())
        CCLOG("招财活动")
        
        require "view/LuckyLayer/LuckyLayer"
        _G.pLuckyLayer = CLuckyLayer ()
        _G.tmpMainUi   : addChild(_G.pLuckyLayer :layer(),100000)
        print("招财按钮没问题，妥妥的")
    end
end

function CActivityIcon.TreasureHouseCallback( self, eventType, obj, x, y ) --藏宝阁按钮回调
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        CCLOG("TreasureHouseCallback", obj:getTag())
        CCLOG("珍宝阁")
        
        --require "view/TreasureHouse/TreasureHouseScene"
        --CCDirector : sharedDirector () : pushScene(CTreasureHouseScene () :scene())
        require "view/TreasureHouse/TreasureHouseInfoView"
        self :pushLuaScene( CTreasureHouseInfoView () :scene() )
        print("珍宝阁没问题，妥妥的")
    end
end

function CActivityIcon.ShopCallback( self, eventType, obj, x, y ) --商店按钮回调
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        CCLOG("ShopCallback", obj:getTag())
        CCLOG("商店")
        local isok,lv = self : isShopOpen()
        if isok == 1 then
            require "view/Shop/ShopLayer"
            self :pushLuaScene( CShopLayer () :scene() )
            print("商店没问题，妥妥的")
            elseif isok == 0 then
            print("商店开放等级为"..lv.."级","商店")
        end
    end
end

function CActivityIcon.isShopOpen(self) --判断商店开放
    local mainplay = _G.g_characterProperty :getMainPlay()
    local nPlayLv  = tonumber(mainplay : getLv())
    
    _G.Config:load("config/mall_class.xml")
        
    local GemNode  =  _G.Config.mall_classs:selectNode("mall_class","class_id",tostring(1010)) --宝石节点
    local EquNode  =  _G.Config.mall_classs:selectNode("mall_class","class_id",tostring(1010)) --装备节点
    local MatNode  =  _G.Config.mall_classs:selectNode("mall_class","class_id",tostring(1010)) --材料节点
    local temp = 0
    temp       = tonumber(GemNode.open_lv)
    if tonumber(EquNode.open_lv) <= temp then
        temp = tonumber(EquNode.open_lv)
        if tonumber(MatNode.open_lv) <= temp then
            temp = tonumber(MatNode.open_lv)
        end
        else
        if tonumber(MatNode.open_lv) <= temp then
            temp = tonumber(MatNode.open_lv)
        end
    end
    
    if  nPlayLv < temp  then
        return 0,temp
    else
        return 1,temp
    end
end

function CActivityIcon.taskGuiderCallback(eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        CCLOG("taskGuider")
    end
end


function CActivityIcon.scene(self)
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CContainer :create()
    scene : setControlName( "this is CActivityIcon scene 228  " )
    
    self.m_layer = CCLayer :create()
    self :init( winSize, self.m_layer)
    
    scene :addChild( self.m_layer)
    return scene
end

--2013.07.26 郭俊志 向服务器发送招财页面数据请求
function CActivityIcon.sendNetWork_LuckyTimes(self)

    self : NetWorkSend_REQ_WEAGOD_REQUEST() -- --招财面板协议发送 加多个等级判断
    
    require "common/protocol/auto/REQ_CARD_SALES_ASK" --请求促销活动可领取状态
    local msg2 = REQ_CARD_SALES_ASK()
    CNetwork : send(msg2)
    
    require "common/protocol/auto/REQ_FLSH_TIMES_REQUEST" --[50210]    请求剩余次数 - 风林山火
    local msg3 = REQ_FLSH_TIMES_REQUEST()
    CNetwork : send( msg3 )

    require "common/protocol/auto/REQ_SHOOT_REQUEST"      --请求每日一箭 数据(获得剩余次数)
    local msg = REQ_SHOOT_REQUEST()
    CNetwork : send( msg )

    require "common/protocol/auto/REQ_ACTIVITY_ASK_LINK_DATA"  --请求活跃度
    local msg = REQ_ACTIVITY_ASK_LINK_DATA()
    CNetwork : send( msg )
    
end

function CActivityIcon.NetWorkSend_REQ_WEAGOD_REQUEST(self )
    local mainplay = _G.g_characterProperty :getMainPlay()
    local nPlayLv  = tonumber(mainplay : getLv())
    if nPlayLv >= _G.Constant.CONST_WEAGOD_OPEN_LV then  --12级
        require "common/protocol/auto/REQ_WEAGOD_REQUEST" --招财面板协议发送
        local msg1 = REQ_WEAGOD_REQUEST()
        CNetwork : send(msg1)
    end
end

function CActivityIcon.setLuckyTimes(self,_data)  --招财图标上的剩余数字更新
    local LuckyTimes = _data
    print ("CActivityIcon.setLuckyTimes 332 ",LuckyTimes)
    if self.LuckyIconLabel == nil then
        return
    end
    self.LuckyIconLabel : setString(LuckyTimes)
end

function CActivityIcon.setDailyTaskTimes( self )
    --print("CActivityIcon.setDailyTaskTimesCActivityIcon.setDailyTaskTimes")
    local _num = 0
    if _G.pCDailyTaskProxy ~= nil then
        local _dailyData = _G.pCDailyTaskProxy : getDailyTaskData()
        if _dailyData ~= nil then
            if _dailyData.count == 0 and _dailyData.state == 3 and _dailyData.left == 0 and _dailyData.node == 0 and _dailyData.value == 0 then
                _num = nil
            else
                _num = ( _dailyData.count or 0 )
            end
            
        end
    end
    print("今天还剩的刷新次数", _num )
    
    local _sysIdList = _G.pCFunctionOpenProxy :getSysId()
    if _sysIdList ~= nil then
        for key, value in pairs( _sysIdList ) do
            if value.id ~= nil and value.id == _G.Constant.CONST_FUNC_OPEN_STRENGTH then
                self :addSmallSpr( _G.Constant.CONST_FUNC_OPEN_STRENGTH, _num )
                break
            end
        end
    end
end



--Mediator回调
--[24932]  促销活动状态返回
function CActivityIcon.activityDataResponse( self , _data )
    print("_data-->", _data)
    if _data == nil then
        return
    end
    -- body
    local hasFirstGift = false
    for i,v in ipairs(_data) do
        print("CActivityIcon  "..i,v.id)
        if v.id == _G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID then
            --首充礼包
            local tag = v.id
            if self.m_iconLayout:getChildByTag(tag) ~= nil then
                return
            end
            self.m_firstGiftSubId = 0
            if v.count > 0 then
                self.m_firstGiftSubId = v.sub_date[1].id_sub -- 说明可以领取
            end
            local btn = self : addOneButtonToLayer(tag,"menu_activity_gift_pay_icon.png")
            local btnSize = btn:getPreferredSize()
            btn:setPosition( ccp( btnSize.width/2 + 20,530-btnSize.height/2 ) )

            --jun 2013.10.21
            if _G.isCONST_RECHARGE_SALES_FIRST_PREPAID_CCBICreate == nil then
                self : Create_effects_activity(btn,_G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID,2) --ICON图标特效
            end

            if self.m_GLOpen then
            --添加游戏略按钮
                local GL_Btn = self : addOneButtonToLayer( 999,"menu_activity_help.png")
                GL_Size = GL_Btn:getPreferredSize()
                GL_Btn  : setPosition( ccp( GL_Size.width/2 + 20,530-btnSize.height-GL_Size.height/2-3 ) )
            end

            hasFirstGift = true

            
        end
    end

    if self.m_GLOpen then
        if hasFirstGift == false then
            local GL_Btn = self : addOneButtonToLayer( 999,"menu_activity_help.png")
            GL_Size = GL_Btn:getPreferredSize()
            GL_Btn  : setPosition( ccp( GL_Size.width/2 + 20,530-GL_Size.height/2 - 10 ) )
        end
    end
end

--移除首充按钮后  调整游戏攻略的位置
function CActivityIcon.resetGLBtnPos( self )

    if self.m_layer ~= nil then
        local GL_Btn = self.m_layer:getChildByTag( 999 )
        if GL_Btn ~= nil then
            local GL_Size = GL_Btn:getPreferredSize()
            GL_Btn:setPosition( ccp( GL_Size.width/2 + 20,530-GL_Size.height/2 - 10 ) )
        end
    end

end



---------------------------
--添加一个活动 参数: _tag->按钮的tag值  _btn->所添加的按钮
function CActivityIcon.addOneButtonToLayer( self, _tag , _szSprName )
    -- body
    local function IconCallback( eventType, obj, x, y )
        return self :layerBtnCallBack( eventType, obj, x, y)
    end
    
    if self.m_layer:getChildByTag( _tag ) ~= nil then
        self.m_layer:removeChildByTag( _tag )
    end
    
    local _btn = CButton :createWithSpriteFrameName("", _szSprName)
    _btn : setControlName( "this CActivityIcon _btn 394 ".._szSprName)
    _btn : registerControlScriptHandler( IconCallback , "this CActivityIcon _btn 396")
    
    
    self.m_layer : addChild( _btn, 0, _tag)
    return _btn
end

function CActivityIcon.layerBtnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        
        local nTag = obj: getTag()
        
        if nTag == _G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID then
            self : firstGiftCallback( nTag)
        elseif nTag == 999 then 
            require "view/Strategy/StrategyView"
            self :pushLuaScene( CStrategyView () :scene() )
        end
    end
end

---------------------------
--移除一个活动 参数: _tag->按钮的tag值
function CActivityIcon.removOneActivity( self , _activityId )
    -- body
    print("------removOneActivity-----",_activityId)
    local activityId = tonumber(_activityId)
    if self.m_iconLayout:getChildByTag(activityId) ~= nil then
        self.m_iconLayout:removeChildByTag(activityId)
        print("removOneActivity-----  111")
        return
    end
    if self.m_layer:getChildByTag(activityId) ~= nil then
        self.m_layer:removeChildByTag(activityId)
        print("removOneActivity-----  222")
        return
    end
end


--每日签到回调
function CActivityIcon.signInCallback( self )
    require "view/SignIn/SignInView"
    self :pushLuaScene( CSignInView () :scene() )
end

--首充礼包回调
function CActivityIcon.firstGiftCallback( self , _id)

    _G.isCONST_RECHARGE_SALES_FIRST_PREPAID_CCBICreate = 1 
    self : removeCONST_SALES_ID_PAY_ONCE_CCBI() --删除首充礼包特效

    require "view/FirstTopupGift/FirstTopupGiftView"
    self :pushLuaScene( CFirstTopupGiftView () :scene(_id,self.m_firstGiftSubId) )
    
    --关闭功能按钮
    if _G.pCFunctionMenuView ~= nil and  _G.pCFunctionMenuView :getMenuStatus() == true then
        _G.pCFunctionMenuView :setMenuStatus( false )
    end
end

function CActivityIcon.btnCallBack( self, eventType, obj, x, y )
    local nTag = obj: getTag()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if nTag ==1 then
                local _vo_data = {}
                require "view/FriendUI/RecommendFriendView"
                local recommendView = CRecommendFriendView( _vo_data)
                print("_G.tmpMainUi222", _G.tmpMainUi)
                if _G.tmpMainUi then
                    _G.tmpMainUi : addChild ( recommendView :scene(), 10000)
                end
                elseif nTag == 2 then
                return self :signInCallback( )
                elseif nTag == 3 then
                return self :onIconCallback( eventType, obj, x, y )
                elseif nTag == 4 then
                return self :TreasureHouseCallback( eventType, obj, x, y )
                elseif nTag == 5 then
                return self :ShopCallback( eventType, obj, x, y )
                
                --add--
                elseif nTag == 6 then
                
                print( "酒吧系统\n######################################")
                require "view/BarPanelLayer/BarPanelView"
                _G.pBarPanelView = CBarPanelView()
                self :pushLuaScene( _G.pBarPanelView :scene() )
                return true
                elseif nTag == 7 then
                --self :openDailyTaskView()
                
                elseif nTag == 8 then
                if self.m_FurinkazanTimes ~= nil and self.m_FurinkazanIsGet ~= nil then
                    if tonumber(self.m_FurinkazanTimes) == 0 then
                        --CCMessageBox( "今天没有剩余次数了", "翻翻乐" )
                        local msg = "今天没有剩余次数了"
                        self : createMessageBox(msg)
                    else
                        require "view/Activeness/ActivenessView"
                        self :pushLuaScene( CActivenessView () :scene())
                        -- require "view/Furinkazan/FurinkazanView"
                        -- CCDirector : sharedDirector () : pushScene(CFurinkazanView () :scene( self.m_FurinkazanTimes, self.m_FurinkazanIsGet ))
                    end
                end
                return true
                elseif nTag == 9 then
                --BOSS
                local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_FLY"])
                tempCommand : setOtherData({mapID = _G.Constant.CONST_BOSS_HUMAN_SENCE})
                _G.controller: sendCommand(tempCommand)
                elseif nTag == 10 then
                require "view/OneArrowEveryDay/OneArrowEveryDayView"
                self :pushLuaScene( COneArrowEveryDayView () :scene())
                return true
            end
        end
    end
    
end




function CActivityIcon.openDailyTaskView( self)
    if _G.pDailyView ~= nil and _G.tmpMainUi ~= nil then
        --CCLOG("CActivityIcon.openDailyTaskView1", _G.pDailyView)
        _G.tmpMainUi :removeChild( _G.pDailyView)
        _G.pDailyView = nil
    end
    
    _G.pDailyView = CDailyTaskUI() :container()
    if _G.tmpMainUi ~= nil  and _G.pDailyView ~= nil  then
        _G.tmpMainUi : addChild ( _G.pDailyView)
    end
end

function CActivityIcon.HideGuiderBtn( self, _bValue)
    self.btnTaskGuider :setVisible( _bValue)
end

--风林山火Mediator回调
function CActivityIcon.FurinkazanCallBack( self, _times, _is_get )
    self.m_FurinkazanTimes = _times
    self.m_FurinkazanIsGet = _is_get
    self["m_activityNum_".._G.Constant.CONST_FUNC_OPEN_GAMBLE] = _times
    self:addSmallSpr(_G.Constant.CONST_FUNC_OPEN_GAMBLE,_times)
    -- if self.CFurinkazanLabel == nil then
    --     return
    -- end
    -- self.CFurinkazanLabel :setString( _times )
end

--根据当前追踪任务跑动
function CActivityIcon.onGuiderTask( self )
    if _G.g_CTaskNewDataProxy :getInitialized() then
        local guiderTask = _G.g_CTaskNewDataProxy :getMainTask()
        
        if guiderTask == nil then
            local testData = _G.g_CTaskNewDataProxy :getTaskDataList()
                        
            if testData ~= nil and #testData > 1 then

                --10.28修改{任务追踪按钮规则修改为，任务状态优先}
                local func = function( lValue, rValue)
                    if lValue.state > rValue.state then
                        return true
                    elseif lValue.state < rValue.state then
                        return false
                    elseif lValue.state == rValue.state then
                        if tonumber( lValue.type ) < tonumber( rValue.type ) then
                            return true
                        else
                            return false
                        end
                    end
                end
            
                table.sort( testData, func)
            
            end
        
            if testData ~= nil then
                _G.g_CTaskNewDataProxy :setMainTask( testData[1] )
                
                guiderTask = _G.g_CTaskNewDataProxy :getMainTask()
            end
            
        end
    
        if guiderTask ~= nil then
            --再设置一次，副本接口
            local copyInfo = {}
            copyInfo[1] = {}
            copyInfo[1] = guiderTask
            _G.g_CTaskNewDataProxy :setMainTask( copyInfo[1] )
            
            self :trackTaskByData( guiderTask )
        end
    end
end
    
--{追踪任务}
function CActivityIcon.trackTaskByData( self, guiderTask )
    CCLOG("\n[进入了 追踪任务]" )
    local nBeginNpcId   = tonumber( guiderTask.beginNpc)
    local nEndNpcId     = tonumber( guiderTask.endNpc)
    local nBeginSceneId = tonumber( guiderTask.beginNpcScene)
    local nEndSceneId   = tonumber( guiderTask.endNpcScene)
    local nTarget_type  = tonumber( guiderTask.target_type)
    local nTarget_id    = nil
    print("", nBeginNpcId, nEndNpcId, nBeginSceneId, nEndSceneId)
    CCLOG("[数据初始化]")
    if guiderTask.target_id ~= nil then
        nTarget_id = tonumber( guiderTask.target_id )
    end
    local nState = tonumber( guiderTask.state )
    print("guiderTask.state=", nState, "nTarget_type=", nTarget_type,   "trackId", guiderTask.id)
    local nPos = nil
    
    if nState == _G.Constant.CONST_TASK_STATE_ACTIVATE then                 --1
        nPos = _G.g_CTaskNewDataProxy :getNpcPos( nBeginNpcId, nBeginSceneId )
    elseif nState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then                       --2
        nPos = _G.g_CTaskNewDataProxy :getNpcPos( nBeginNpcId, nBeginSceneId )
        
    elseif nState == _G.Constant.CONST_TASK_STATE_UNFINISHED then           --3
        if nTarget_type == 7 then
            _G.g_CTaskNewDataProxy :gotoDoorsPos( nBeginSceneId, 1 )
            return
        elseif nTarget_type == 6 then     
            if nTarget_id ~= nil and nTarget_id == 3 then           --"加入社团" 特别  target_type == 6 时
                local mainplay = _G.g_characterProperty :getMainPlay()
                local myclan   = mainplay :getClan()      --玩家家族ID  无 ：0  有 ：ID
                if myclan == 0 then
                    --print( "玩家当前没有加入社团", myclan)
                    _G.pFactionApplyView = CFactionApplyView()
                    self :pushLuaScene( _G.pFactionApplyView :scene() )
                else
                    --print( "玩家已经加入社团", myclan)
                    _G.pFactionPanelView = CFactionPanelView()
                    self :pushLuaScene( _G.pFactionPanelView :scene())
                end
                
            elseif nTarget_id ~= nil and nTarget_id == 21 then      --"任务" 打开下载界面
                require "view/TaskUI/TaskDownloadView"
                if _G.tmpMainUi ~= nil then
                    local _pView = CTaskDownloadView() :layer()
                    _G.tmpMainUi : addChild( _pView, 10000 )
                end
            end
            return
        else
            nPos = _G.g_CTaskNewDataProxy :getNpcPos( nEndNpcId, nEndSceneId )
            
        end
        
    elseif nState == _G.Constant.CONST_TASK_STATE_FINISHED then             --4
        nPos = _G.g_CTaskNewDataProxy :getNpcPos( nEndNpcId, nEndSceneId )
        
    elseif nState == _G.Constant.CONST_TASK_STATE_SUBMIT then               --5
        nPos = _G.g_CTaskNewDataProxy :getNpcPos( nEndNpcId, nEndSceneId )
        
    end
    
    --如果就站在一起，直接打开
    --CCMessageBox("nPosnPos", nState )
    if nPos ~= nil and nState ~= 3 then

        local distance = ccpDistance( ccp( _G.g_Stage :getRole() :getLocationXY() ), ccp( nPos.x, nPos.y ) )
         print("nRadiusnRadius", nPos.x, nPos.y, nRadius)
        local nRadius = 50
        print( "nPos-->", nPos.x, nPos.y, distance, _G.g_Stage :getRole() :getLocationX(), _G.g_Stage :getRole() :getLocationY())
        
        if distance < nRadius then  --如果距离小于20 就打开界面 不移动
            local nTaskNpcId = nBeginNpcId
            if nBeginNpcId == nEndNpcId then
                print("~~~")
                else
                if nState <= 3 then
                    nTaskNpcId = nBeginNpcId
                else
                    nTaskNpcId = nEndNpcId
                end
            end
            
            if _G.g_dialogView ~= nil then
                _G.g_dialogView :closeWindow()
                _G.g_dialogView = nil
            end
            CCLOG("去找的npc为"..nTaskNpcId )
            _G.g_dialogView = CTaskDialogView( nTaskNpcId, 20)
            _G.tmpMainUi : addChild ( _G.g_dialogView :scene())
            return
        end
        
        print("跑的位置-->", nPos.x, nPos.y)
        _G.g_Stage :getRole() :setMovePos( nPos )
    end
end
    
function CActivityIcon.setUpdateView( self)
    self : removeAllIconCCBI()
    --self :addIconLayout()
    if self.m_iconLayout ~= nil then
        --self.m_iconLayout :removeAllChildrenWithCleanup( true)
        self :initFunctionParams( )
        self :addBtnBySysId( self.m_iconLayout)
    end
end
--郭俊志 2013.09.17
function CActivityIcon.NetWorkReturn_WRESTLE_AREANK_RANK( self,Rank)
    local msg = ""
    if Rank ~= nil and Rank > 0 then
        msg = "你的竞技场排名是"..Rank.."名\n请问是否需要报名参加比赛"
        else
        msg = "你无竞技场排名\n请问是否需要报名参加比赛"
    end
    require "view/ErrorBox/ErrorBox"
    local ErrorBox = CErrorBox()
    local function func1()
        print("你的竞技场排名是")
        
        require "common/protocol/auto/REQ_WRESTLE_APPLY"
        local msg = REQ_WRESTLE_APPLY() -- [54803]格斗之王报名 -- 格斗之王
        CNetwork  : send(msg)
        print("REQ_WRESTLE_APPLY 格斗之王报名 54803 发送完毕 ")
    end
    local function func2()
        print("bad2")
    end
    local BoxLayer = ErrorBox : create(msg,func1,func2)
    self.m_layer : addChild(BoxLayer)
end
    
function CActivityIcon.NetWorkReturn_WRESTLE_APPLY_STATE( self)
    CCMessageBox("报名成功","提示")
    local msg = "报名成功"
    self : createMessageBox(msg)
end




function CActivityIcon.NetWorkReturn_WRESTLE_PLAYER(self,Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail)
    print("进入了格斗之王的页面",Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail)
    if _G.g_CKingOfFlightersInfoView == nil then
        _G.g_CKingOfFlightersInfoView = CKingOfFlightersInfoView()
        --local KingOfFlightersInfoView = CKingOfFlightersInfoView ()
    
        local sceneTemp = _G.g_CKingOfFlightersInfoView :getScene()
        self :pushLuaScene( sceneTemp)    --打开格斗之王的页面
        _G.g_CKingOfFlightersInfoView        : pushData(Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail) --pushData
    else
        _G.g_CKingOfFlightersInfoView        : pushData(Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail) --pushData
    end
end

function CActivityIcon.NetWorkReturn_ACTIVITY_OK_ACTIVE_DATA( self, count, activeData)
    local _btnIndex  = _G.Constant.CONST_FUNC_OPEN_BOSS
    local btn        = self["m_activiBtn".._btnIndex]

    local loops = 0 
    if activeData ~= nil then
        for k,v in pairs(activeData) do
            print("判断多人活动的特效实现=====",k,v.id,v.state)
            if tonumber(v.state) == 1 then
                loops = loops + 1 
            end
        end
    end

    if loops > 0 then
        if btn ~= nil then 
            print("又要开始创建了")
           self : Create_effects_activity(btn,_btnIndex,1) --ICON图标特效
           self.CONST_FUNC_OPEN_BOSS_isOpen = 1
        end
    else
        self.CONST_FUNC_OPEN_BOSS_isOpen = 0
        self : IsremoveFirstClickCCBI(_btnIndex)
    end
end

function CActivityIcon.NetWorkReturn_ACTIVITY_ACTIVE_DATA(  self,State )
    local _btnIndex  = _G.Constant.CONST_FUNC_OPEN_BOSS
    local btn        = self["m_activiBtn".._btnIndex]

    if State ==1 or State ==2  or State ==4 then
        if btn ~= nil then 
            print("又要开始创建了")
           self : Create_effects_activity(btn,_btnIndex,1) --ICON图标特效
           self.CONST_FUNC_OPEN_BOSS_isOpen = 1
        end
    else
        self.CONST_FUNC_OPEN_BOSS_isOpen = 0
        self : IsremoveFirstClickCCBI(_btnIndex)
    end
end


---特效CCBI
function CActivityIcon.Create_effects_activity( self,obj,value,types)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end

    if value == _G.Constant.CONST_FUNC_OPEN_ACTIVE then
        if self.m_ActivenessCCBI ~= nil then
            return
        end
    end

    if obj ~= nil then
         print("why111")
        if obj ~= nil and self["effectsCCBI" .. value] ~= nil then
            self["effectsCCBI" .. value] : removeFromParentAndCleanup(true)
            self["effectsCCBI" .. value] = nil 
        end

        if value == _G.Constant.CONST_FUNC_OPEN_BOSS then
            print("为什么你又呗创建了")
        end

        if types == 1 then
            self["effectsCCBI" .. value] = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
            self["effectsCCBI" .. value]       : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effectsCCBI" .. value]       : registerControlScriptHandler( animationCallFunc)
            self["effectsCCBI" .. value]       : setPosition(3,15)
            obj               : addChild( self["effectsCCBI" .. value],1000)  
        else
            self.CONST_SALES_ID_PAY_ONCE_CCBI  = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
            self.CONST_SALES_ID_PAY_ONCE_CCBI  : setControlName( "this CCBI Create_effects_activity CCBI")
            self.CONST_SALES_ID_PAY_ONCE_CCBI  : registerControlScriptHandler( animationCallFunc)
            self.CONST_SALES_ID_PAY_ONCE_CCBI  : setPosition(3,15)
            obj               : addChild( self.CONST_SALES_ID_PAY_ONCE_CCBI,1000) 
        end

    end
end

function CActivityIcon.NetWorkSend_REQ_ROLE_USE_SYS( self,sys_id) --使用功能协议发送
    if tonumber(sys_id)  ~= nil then
        require "common/protocol/auto/REQ_ROLE_USE_SYS"
        local msg = REQ_ROLE_USE_SYS()
        msg :setSysId(sys_id)  -- {功能ID}
        CNetwork :send(msg)
    end
end
    
function CActivityIcon.IsremoveFirstClickCCBI( self, value ) --如果是第一次按的就删了你
    if value == _G.Constant.CONST_FUNC_OPEN_BOSS then
        if self.CONST_FUNC_OPEN_BOSS_isOpen == 1 then
            return
        end
    elseif value == _G.Constant.CONST_FUNC_OPEN_STRENGTH then
        if _G.pCDailyTaskProxy :getInited() == true then
            local dailyData = _G.pCDailyTaskProxy :getDailyTaskData()
            if dailyData ~= nil then
                if dailyData.state == 1 then
                    return
                end
            end
        end
    end
    
    self : removeFirstClickCCBI( value )
end
   

function CActivityIcon.removeFirstClickCCBI( self,value ) --如果是第一次按的就删了你

    if  self["m_activiBtn"..value] ~= nil and self["effectsCCBI" .. value] ~= nil then
        --self["m_activiBtn"..value]  :  removeChild( self["effectsCCBI" .. value] )
        self["effectsCCBI" .. value] : removeFromParentAndCleanup(true)
        self["effectsCCBI" .. value]= nil 
    end

    if self.m_sysId ~= nil then
        for key, value in pairs( self.m_sysId  )  do
            if value.id == nFuncId then
                value.use = 1
                table.remove( self.m_sysId, key)
                table.insert( self.m_sysId, key, value )
                break
            end
        end
    end
    _G.pCFunctionOpenProxy :setSysId( self.m_sysId )
end 

function CActivityIcon.removeAllIconCCBI( self) --干掉所有的CCBI
    print("CActivityIcon准备干掉所有的CCBI")

    if self.m_sysId ~= nil then
        for key, value in pairs( self.m_sysId  )  do
           local  nFuncId =  value.id 
            print("ooxx",nFuncId)
            if  self["m_activiBtn"..nFuncId] ~= nil and self["effectsCCBI" .. nFuncId] ~= nil then
                self["effectsCCBI" .. nFuncId] : removeFromParentAndCleanup(true)
                self["effectsCCBI" .. nFuncId]= nil 
                print("killing----")
            end
        end
    end

    self : removeCONST_SALES_ID_PAY_ONCE_CCBI()   --删除首充礼包特效
    self : removeCONST_FUNC_OPEN_ELIMINATE_CCBI() --删除精彩活动ccbi
    self : removeActivenessCCBI()                 --删除
end 

function CActivityIcon.removeCONST_SALES_ID_PAY_ONCE_CCBI( self )  --删除首充礼包特效
    local _tag = _G.Constant.CONST_SALES_ID_PAY_ONCE
    if self.m_layer:getChildByTag( _tag ) ~= nil then
        if self.CONST_SALES_ID_PAY_ONCE_CCBI ~= nil then
            self.CONST_SALES_ID_PAY_ONCE_CCBI : removeFromParentAndCleanup(true)
            self.CONST_SALES_ID_PAY_ONCE_CCBI = nil 
        end
    end
end

    
function CActivityIcon.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end
    
function CActivityIcon.setDailyCCBIView( self )
    self : Create_effects_activity( self["m_activiBtn".. _G.Constant.CONST_FUNC_OPEN_STRENGTH], _G.Constant.CONST_FUNC_OPEN_STRENGTH, 1) --ICON图标特效
    if _G.pCDailyTaskProxy :getInited() == true then
        local dailyData = _G.pCDailyTaskProxy :getDailyTaskData()
        if dailyData ~= nil then
            if dailyData.state ~= 1 then
                self : removeFirstClickCCBI( _G.Constant.CONST_FUNC_OPEN_STRENGTH )
            end
        end
    end
end
    
function CActivityIcon.NetWorkReturn_CARD_NOTICE( self )  --精彩活动的ccbi添加
    print("创建有活动特效===================》》》》》")
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end

    local value = _G.Constant.CONST_FUNC_OPEN_ELIMINATE --精彩活动

    self : removeCONST_FUNC_OPEN_ELIMINATE_CCBI() --删除精彩活动ccbi

    if  self["m_activiBtn"..value] ~= nil and self["effectsCCBI" .. value] == nil then
        print("创建有活动特效")
        self.CONST_FUNC_OPEN_ELIMINATE_CCBI = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
        self.CONST_FUNC_OPEN_ELIMINATE_CCBI : setControlName( "this CCBI Create_effects_activity CCBI")
        self.CONST_FUNC_OPEN_ELIMINATE_CCBI : registerControlScriptHandler( animationCallFunc)
        self.CONST_FUNC_OPEN_ELIMINATE_CCBI : setPosition(3,15)
        self["m_activiBtn"..value] : addChild( self.CONST_FUNC_OPEN_ELIMINATE_CCBI,1000)  
    end
end    
    
function CActivityIcon.removeCONST_FUNC_OPEN_ELIMINATE_CCBI( self )  --删除精彩活动特效
    print("删除精彩活动特效3030")
    -- local _tag = _G.Constant.CONST_FUNC_OPEN_ELIMINATE
    -- if self.m_layer:getChildByTag( _tag ) ~= nil then
        if self.CONST_FUNC_OPEN_ELIMINATE_CCBI ~= nil then
            self.CONST_FUNC_OPEN_ELIMINATE_CCBI : removeFromParentAndCleanup(true)
            self.CONST_FUNC_OPEN_ELIMINATE_CCBI = nil 
            print("删除精彩活动特效3030---------")
        end
    -- end
end

function CActivityIcon.pushLuaScene( self, _scene )
    if _scene ~= nil and _G.pCFunctionOpenProxy ~= nil then
        
        local pScene = CCTransitionCrossFade :create( 0.5, _scene) 
        _G.pCFunctionOpenProxy :pushEffectScene( pScene, 0.5 )
        
    else
        CCLOG("CActivityIcon肿么了，传个空场景进来啊！！！！")
    end
end
    

function CActivityIcon.createActivenessCCBI( self )
    print("创建有奖励特效===================》》》》》")

    print("ActivenessCCBI ææææææææææ,",debug.traceback())

    local curScenesType = _G.g_Stage :getScenesType()
    if curScenesType ~= _G.Constant.CONST_MAP_TYPE_CITY then
        return
    end


    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        -- elseif eventType == "Exit" then
        --     self.m_ActivenessCCBI = nil
        end
    end

    local value = _G.Constant.CONST_FUNC_OPEN_ACTIVE --活跃度

    self:removeActivenessCCBI()

    if  self["m_activiBtn"..value] ~= nil then

        if self["effectsCCBI" .. value] ~= nil then
            self["effectsCCBI" .. value] : removeFromParentAndCleanup( true ) 
            self["effectsCCBI" .. value] = nil 
        end

        print("创建有活动特效")
        self.m_ActivenessCCBI = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
        self.m_ActivenessCCBI : setControlName( "this CCBI createActivenessCCBI CCBI")
        self.m_ActivenessCCBI : registerControlScriptHandler( animationCallFunc)
        self.m_ActivenessCCBI : setPosition(3,15)
        self["m_activiBtn"..value] : addChild( self.m_ActivenessCCBI,1000)  
    end
end

function CActivityIcon.removeActivenessCCBI( self )

    print("ActivenessCCBI ææææææææææ,    22222  ",debug.traceback())
    if self.m_ActivenessCCBI ~= nil then
        self.m_ActivenessCCBI : removeFromParentAndCleanup( true )
        self.m_ActivenessCCBI = nil
    end
end

function CActivityIcon.setRoleBuffIcon( self )
    CCLOG("通知加bufff")
    local _buffData = _G.pCFunctionOpenProxy :getRoleBuff()
    if _buffData ~= nil then
        print( "根据数据创建icon-->", _buffData.id, _buffData.state, _G.Constant.CONST_FUNC_OPEN_ENERGY_TIME )
        if _buffData.id ~= nil and _buffData.state ~= nil and _buffData.id == _G.Constant.CONST_FUNC_OPEN_ENERGY_TIME then
            self :createActivityBtnByIndex( _buffData.id, "menu_activity_tllq.png", "体力buff按钮", self.m_iconLayout, _buffData.state)
            
            if _buffData.state == 1 then
                self.m_iconLayout :removeChild( self["m_activiBtn" .. _buffData.id ])
            end
        end
    end
    --
end
    
