require "view/view"
require "controller/TaskNewDataCommand"
require "model/VO_TaskNewModel"
require "controller/TaskDialogCommand"
require "mediator/TaskDialogMediator"
require "controller/GuideCommand"



CTaskDialogView = class( view, function( self, _npcId, _nType )
	print("npc对话UI(10打开任务界面， 20打开npc普通界面)", _npcId, _nType)
    if _nType == nil then
        return
    end
                    
    _G.g_Stage : getPlay() :cancelMove()
    --local npcArr = _G.CharacterManager : getNpc()
    self.m_szName = ""
    if _npcId == nil then
        return true
    end
    self.m_type     = _nType
    self.m_npcId    = tonumber( _npcId )
        
    self :initNpcInfo( tostring( _npcId ) )           --初始化npc信息
                        
    self.m_winSize = CCSizeMake( 687.0, 361.0 )      --默认窗口大小
    
    --获取人物信息： 等级 
    local mainProperty  = _G.g_characterProperty : getMainPlay()
    if mainProperty == nil then
        print("mainProperty==", mainProperty)
        return
    end
    self.m_nLv = mainProperty :getLv() or 0


end)

CTaskDialogView.MARK_UNACCEPTED     = 1         --不可接受
CTaskDialogView.MARK_ACCEPT         = 2         --可接
CTaskDialogView.MARK_UNIFINISHED    = 3         --已接未完成
CTaskDialogView.MARK_FINISH         = 4         --完成未提交
CTaskDialogView.TAG_REQUEST_TASK    = 999       --任务请求tag

function CTaskDialogView.addMediator( self)
    self : removeMediator()
    
    _G.g_CTaskDialogMediator = CTaskDialogMediator( self)
    controller :registerMediator( _G.g_CTaskDialogMediator)
end

function CTaskDialogView.removeMediator( self)
    if _G.g_CTaskDialogMediator ~= nil then
        controller :unregisterMediator( _G.g_CTaskDialogMediator)
        _G.g_CTaskDialogMediator = nil
        
    end
    print("注销mediator", _G.g_CTaskDialogMediator)
end

--初始化界面
function CTaskDialogView.init( self, _winSize, _layer )

    self.m_createResStrList = {}

    self.m_talkCount = 0                            --计数谈话次数 等于1时，确认按钮，并关闭界面
	self : loadResources()
    self : initContainer( _layer)
    self : initBgAndCloseBtn( _layer )               --初始化背景及关闭按钮
    
    if self.m_szName ~= "" or self.m_szName ~= nil then
        self.m_szNpcName  = self.m_szName
    end
    --print("self.m_szName", self.m_szName)
    --初始化界面
    if self.m_type == 20 then                       
        --print("进入普通对话 或者功能界面")
        --需要更新的层
        if self.m_updataLayer ~= nil then
            self.m_updataLayer :removeFromParentAndCleanup( true)
            self.m_updataLayer = nil
        end
        self.m_updataLayer	= CContainer :create()
        self.m_pBackground 	:addChild( self.m_updataLayer )
        
        self :gotoNpcDialog()
    end
    self : addMediator()

    
    
end

function CTaskDialogView.gotoNpcDialog( self)
    self :addNpcName()
    self :addNpcSays()
    self :addNpcFunctionById()
end

function CTaskDialogView.initNpcInfo( self, _npcId )
    _npcId = tonumber( _npcId )
    local npcNode = _G.g_CTaskNewDataProxy : getNpcNodeById( self.m_npcId )
    local szay = "says"..math.random( 1, 3)
    
    self.m_szSays = npcNode :getAttribute( szay ) or ""    --npcNode[szay]               --初始化随机说话
    self.m_szName = npcNode :getAttribute( "npc_name" )--npcNode["npc_name"]
        
    self.m_funcId = 0
    self.m_funcLv = 0
    self.m_funcName = nil
    if not npcNode :isEmpty() then
        self.m_funcId = tonumber( _G.g_CTaskNewDataProxy :getFunAttribute( npcNode, "id") )     --npcNode.funs[1].fun[1].id )
        self.m_funcLv = tonumber( _G.g_CTaskNewDataProxy :getFunAttribute( npcNode, "lv") )     --npcNode.funs[1].fun[1].lv )
        self.m_funcName = _G.g_CTaskNewDataProxy :getFunAttribute( npcNode, "name")      --npcNode.funs[1].fun[1].name
        self.m_funIconName = _G.g_CTaskNewDataProxy :getFunAttribute( npcNode, "fun_icon" ) or "0"      --功能图标图片名
    end

    self : initTaskData( _npcId )
end

function CTaskDialogView.initTaskData( self, _npcId )
    --判断是否有任务
    if _G.g_CTaskNewDataProxy :getInitialized() == true then
        if self.m_taskInfo ~= nil then
            table.remove( self.m_taskInfo )
            self.m_taskInfo = nil
        end
        
        --print("sdfsfsfdsfsdfsfdfsdsf", debug.traceback() )
        local l_task_list = _G.g_CTaskNewDataProxy :getTaskDataList()
        --print("sdfsdfsdf111sfs", l_task_list)
        --for k, v in pairs( l_task_list ) do
            --print("sdfsdfsd222fsfs", v.id, v.state)
        --end
        if l_task_list ~= nil then
            for key, value in pairs( l_task_list ) do
                
                local taskNode = _G.g_CTaskNewDataProxy :getTaskDataById( value.id )
               -- print("taskNodetaskNode", taskNode :isEmpty())
                if taskNode :isEmpty() == false then
                    local nBeginNpcId = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "s", "npc" ) )
                    local nEndNpcId   = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "e", "npc" ) )
                    
                    --print("taskNodetaskNodetaskNodetaskNode",nBeginNpcId, nEndNpcId, _npcId )
                    if nBeginNpcId == _npcId or nEndNpcId == _npcId then

                        if self.m_taskInfo == nil then
                            self.m_taskInfo = {}
                        end
                        
                        value.name  = taskNode :getAttribute( "name" )
                        value.lv    = taskNode :getAttribute( "lv" )
                        value.type  = taskNode :getAttribute( "type" )
                        --print("value.namevalue.name", value.name)
                        self.m_taskInfo[ #self.m_taskInfo + 1 ] = value
                    end
                end
            
            end
        end
    end

end

function CTaskDialogView.addNpcName( self)
	local nFontSize = 20
	local szFontName= "Arial"
	--npc名字
    local szNpcName = self.m_szNpcName or ""
	local pNpcNameLabel = CCLabelTTF :create( tostring( szNpcName), szFontName, nFontSize )
	self.m_pBackground :addChild( pNpcNameLabel)
    pNpcNameLabel 	:setPosition( - self.m_winSize.width * 0.3268, self.m_winSize.height * 0.5 - 25)
    
    local szNpcSays = self.m_szSays or ""
    self.m_pNpcSaysLabel = CCLabelTTF :create( tostring( szNpcSays), szFontName, nFontSize )
    self.m_pNpcSaysLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.m_pNpcSaysLabel :setDimensions( CCSizeMake(self.m_winSize.width * 0.75, 100 ))
	self.m_pBackground :addChild( self.m_pNpcSaysLabel )
    self.m_pNpcSaysLabel 	:setPosition( - self.m_winSize.width * 0.0068, self.m_winSize.height * 0.3 - 25)
end

function CTaskDialogView.addNpcSays( self)
    
end

--增加任务按钮
function CTaskDialogView.addTaskBtnByPos( self )
    if self.m_taskInfo ~= nil then
        for key, value in pairs( self.m_taskInfo ) do
            if self["m_pBtnTask"..key] ~= nil then
                self["m_pBtnTask"..key] : removeFromParentAndCleanup( true )
                self["m_pBtnTask"..key] = nil
            end
            
            if key >= 4 then
                break
            end
            
            --print("self.m_nTaskBtnCount", self.m_nTaskBtnCount)
            --任务按钮计数
            if self.m_nTaskBtnCount == nil then
                self.m_nTaskBtnCount = 1
            elseif self.m_nTaskBtnCount >= 3 then
                return
            elseif self.m_nTaskBtnCount >=1 and self.m_nTaskBtnCount <3 then
                self.m_nTaskBtnCount = self.m_nTaskBtnCount + 1
            end
        
            local szType = ""
            if value.type ~= nil then
                if tonumber( value.type ) == 1 then
                    szType = "[主]"
                elseif tonumber( value.type ) == 2 then
                    szType = "[支]"
                end
            end
            local szBtnName = szType..value.name            --.."[lv:"..value.lv.."]"
            self["m_pBtnTask"..key] = CButton :createWithSpriteFrameName( "", "task_talk_normal.png" )
            self["m_pBtnTask"..key] : setControlName("this CTaskDialogView.addTaskBtnByPos m_pBtnTaskKey 190"..key)
            
            --如果人物等级小于人物等级 任务按钮不可点击
            if self.m_nLv < tonumber( value.lv ) then
                self["m_pBtnTask"..key] :setChecked( true )
                self["m_pBtnTask"..key] :setTouchesEnabled( false )
                szBtnName = szBtnName .. "   (" .. value.lv .. "级可接)"
            else    --任务名称后加入当前任务状态（可接，进行中，可完成，等）
                local nState = tonumber( value.state )
                if nState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then
                    szTails = "   (可接)"
                elseif nState == _G.Constant.CONST_TASK_STATE_UNFINISHED then
                    szTails = "   (进行中)"
                elseif nState == _G.Constant.CONST_TASK_STATE_FINISHED then
                    szTails = "   (可完成)"
                end
                szBtnName = szBtnName .. szTails
            end
            
            self :createBtnByData( self["m_pBtnTask"..key], szBtnName, value.state, key, true )
            local nTag = tonumber( value.id ) or 100
            self["m_pBtnTask"..key] :setTag( nTag )
            
            print("创建一个按钮成功", key)
        end
    end
end

function CTaskDialogView.addNpcFunctionIcon( self, _szIconName )
    local npcArr = _G.CharacterManager : getNpc()
    if npcArr ~= nil then
        for idx, npcValue in pairs( npcArr ) do
            --print( "-0-0-0-0-0-0-0->", npcValue.m_nID, _szIconName, self.m_npcId )
            if tonumber( npcValue.m_nID ) == tonumber( self.m_npcId ) then
                npcValue :setFuncIcon( _szIconName )
            end
        end
    end
end

--{根据id开放 npc功能按钮} 
function CTaskDialogView.addNpcFunctionById( self)
    --print("CTaskDialogView.addNpcFunctionById", debug.traceback(), self.m_taskInfo, self.m_nTaskBtnCount , self.m_nLv, self.m_funcLv)
    local nPos = 1
    if self.m_taskInfo ~= nil then
        self : addTaskBtnByPos()
        
        if self.m_nTaskBtnCount ~= nil  then            --最多前三个显示任务， 第四个显示功能按钮
            nPos = self.m_nTaskBtnCount + 1
        end
    end

    if self.m_nLv ~= nil and self.m_funcLv ~= nil then
        if self.m_nLv < self.m_funcLv then
            --print("级别不够，不能打开相应功能开放", self.m_nLv)
            return
        end
    end
    --if nPos == 1 and self.m_funIconName ~= nil and self.m_funcId ~= 0 then
        --说明没有任务的时候 显示有功能的npc的图标
        --self :addNpcFunctionIcon( "menu_npcbar.png" )
    --end
    
    local szBtnImageName = "task_talk_normal.png"
    if self.m_funcId == _G.Constant.CONST_NPC_FUN_DEPOT then
        self.m_isTaskOrFunc = true
        self.m_funcBtn = CButton :createWithSpriteFrameName( "", szBtnImageName)
        self :createBtnByData( self.m_funcBtn, tostring( self.m_funcName ), 0, nPos, true)
    
    elseif self.m_funcId == _G.Constant.CONST_NPC_FUN_SHOP then
        self.m_isTaskOrFunc = true
        self.m_funcBtn = CButton :createWithSpriteFrameName( "", szBtnImageName)
        self :createBtnByData( self.m_funcBtn, tostring( self.m_funcName ), 0, nPos, true)
        
    elseif self.m_funcId == _G.Constant.CONST_NPC_FUN_PREFEREN_SHOP then
        self.m_isTaskOrFunc = true
        self.m_funcBtn = CButton :createWithSpriteFrameName( "", szBtnImageName)
        self :createBtnByData( self.m_funcBtn, tostring( self.m_funcName ), 0, nPos, true)
    end
    if self.m_funcBtn then
        self.m_funcBtn :setTag( self.m_funcId )
    end
end

function CTaskDialogView.initContainer( self, _layer)
    self.m_pContainer   = CContainer :create()
    _layer :addChild( self.m_pContainer )

end

--多点触摸 关闭tips
function CTaskDialogView.onCloseTipsCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        return true
    end
end

function CTaskDialogView.loadResources( self )
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("taskInfo/taskResourcesNew.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/ChallengeResources.plist")
end

function CTaskDialogView.unloadResources( self )

    CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("taskInfo/taskResourcesNew.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("taskInfo/taskResourcesNew.pvr.ccz")


    if self.m_createResStrList ~= nil and _G.g_unLoadIconSources ~= nil then 
        _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
    end
    self.m_createResStrList = {}

    --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end


function CTaskDialogView.createLabel(self, _pLabel, _layer)
	if _pLabel ~= nil then 
		_layer :addChild( _pLabel )
	else
		CCLOG("_pLabel nil!")
	end
end

--{按钮扩展}   按钮CButton， 内容sz， 状态n， 位置n, 是否第一次_isFirst
function CTaskDialogView.createBtnByData( self, _dialogBtn, _szBtnContent, _nState, _nPos, _isFirst )
    print("gView.crea{按钮扩展 ", _dialogBtn, _szBtnContent, _nState, _nPos, _isFirst, debug.traceback() )
    if _nState ~= nil then
        local function talkCallback( eventType, obj, x, y )
            return self :onTalkCallback( eventType, obj, x, y)
        end
        
        _nPos = _nPos - 1
        local l_pos = self.m_winSize.height * ( 0.065 - ( 0.15 * _nPos))
                                       print("_nPos", _nPos, l_pos)
        _dialogBtnSize = _dialogBtn :getPreferredSize()
        --print("_dialogBtnSize ",_dialogBtnSize.width)
        self.m_updataLayer  :addChild( _dialogBtn)
        _dialogBtn    :setPreferredSize( CCSizeMake( self.m_winSize.width, _dialogBtnSize.height) )
        _dialogBtn    :registerControlScriptHandler( talkCallback, "this CTaskDialogView. self.m_secondBtn 180")
        _dialogBtn    :setTouchesPriority( self.m_pBackground :getTouchesPriority() -2)
        --_dialogBtn    :setPosition( ccp( 0, l_pos))     --  减去0.11   -0.03  -0.17  -0.31
    
        local iconSpr = self :getStateIcon( _nState)
        if iconSpr ~= nil then
            _dialogBtn :addChild( iconSpr, 10)
        end
    
        --根据状态设置颜色，默认白色
        local _colorByState = ccc3( 255, 255, 255 )
        if _isFirst == true then
            if _nState == 1 then
                _colorByState = ccc3( 255, 0, 0 )       --红色
            elseif _nState == 2 or _nState == 3 then
                _colorByState = ccc3( 255, 255, 0 )     --黄色
            elseif _nState == 4 then
                _colorByState = ccc3( 94, 208, 18 )     --绿色
            end
        end
         _dialogBtn    :setPosition( ccp( 0, l_pos))                              
        if self.m_isTaskOrFunc ~= nil and self.m_isTaskOrFunc == true  then
            _dialogBtn :setText( _szBtnContent)
            _dialogBtn :setFontSize( 22 )
            self.m_isTaskOrFunc = false
            return true
        end
    
        --_szBtnContent = "啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"
        print("_szBtnContent", _szBtnContent)
        local _label = CCLabelTTF :create( _szBtnContent or "", "Arial", 20 )
        _label :setDimensions( CCSizeMake( 398, 0 ))
        local _nlabelSize = _label :getContentSize()
        --print( "labelSize", _nlabelSize.width, _nlabelSize.height )
                                       
        --如果npc对话内容高度大于 1行字
        local _nLabelY = 0
        if _nlabelSize.height >= 50 then --_dialogBtnSize.height then
            _dialogBtn :setPreferredSize( CCSizeMake( _dialogBtnSize.width, _nlabelSize.height + 18 )  )
            --print("_dialogBtn_dialogBtn")
            l_pos = l_pos - 9
            _nLabelY = -4.5

        end
        _dialogBtn    :setPosition( ccp( 0, l_pos))     --  减去0.11   -0.03  -0.17  -0.31
        --print("_nPos_nPos", _nPos, l_pos)
        _label :setAnchorPoint( ccp( 0.0, 0.5))
        _label :setHorizontalAlignment( kCCTextAlignmentLeft )
        _label :setPosition( -self.m_winSize.width * 0.20, _nLabelY )
        _dialogBtn :addChild( _label, 10)
    
        _label :setColor( _colorByState )
    
        if _dialogBtn : getChecked() == true then
            _label :setColor( ccc3( 255, 0, 0 ) )
        end
        print("创建了一个按钮")
    end
end

function CTaskDialogView.getStateIcon( self, _nState)
    if _nState == nil or _nState <= 0 or _nState > 4 then
        return nil
    end
    
    --print("icon状态", _nState)
    local l_return_spr = nil
    if _nState == CTaskDialogView.MARK_UNACCEPTED then          --1
        l_return_spr = CSprite :createWithSpriteFrameName("task_exclamation_mark_unaccepted.png")
    elseif _nState == CTaskDialogView.MARK_ACCEPT then          --2
        l_return_spr = CSprite :createWithSpriteFrameName("task_exclamation_mark_accept.png")
    elseif _nState == CTaskDialogView.MARK_UNIFINISHED then     --3
        l_return_spr = CSprite :createWithSpriteFrameName("task_question_mark_unfinished.png")
    elseif _nState == CTaskDialogView.MARK_FINISH then          --4
        l_return_spr = CSprite :createWithSpriteFrameName("task_question_mark_finish.png")
    end
    
    if l_return_spr ~= nil then
        l_return_spr :setPosition( -self.m_winSize.width * 0.2448, 0)
    end
    return l_return_spr
end

function CTaskDialogView.layout( self )
    local _winSize      = CCDirector:sharedDirector():getVisibleSize()
	local winX          = _winSize.width
    local winY          = _winSize.height
    local sizeBg   		= self.m_pBackground :getPreferredSize()
    local sizeCloseBtn  = self.m_pCloseBtn   :getPreferredSize()
    local sizeNpcSpr    = self.m_pNpcSpr :getPreferredSize()
    ----------
    if winY == 640 then
                                                
        self.m_pNpcNameLabel    :setPosition( - self.m_winSize.width * 0.3268, self.m_winSize.height * 0.5 - 25)
    	self.m_pNpcTalkLabel	:setPosition( 0, sizeBg.height * 0.2601)
    	self.m_pNpcTalkLabel 	:setDimensions( CCSizeMake( sizeBg.width * 0.75, 70) )
    elseif winY == 768 then
         
    end	
    ----------
end
--


function CTaskDialogView.initBgAndCloseBtn( self, _layer )
	
    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack(eventType, obj, x, y)
    end

    local function closeTipsCallback( eventType, obj, x, y )
        return self : onCloseTipsCallback( eventType, obj, x, y )
    end

--背景
    self.m_pBackground 	= CSprite :createWithSpriteFrameName("task_NPC_talk_unframe.png", CCRectMake( 221, 0, 18, 361))
    self.m_pBackground  :setPreferredSize( self.m_winSize )
    self.m_pBackground  :setControlName("this CTaskDialogView. self.m_pBackground 228")
    self.m_pContainer 	:addChild( self.m_pBackground, -100 )
    self.m_pContainer   :setTouchesPriority( -29 )
    self.m_pBackground  :setTouchesPriority( -30 )
    self.m_pBackground  :registerControlScriptHandler( closeTipsCallback, "this CTaskDialogView. self.m_pBackground 575" )
    self.m_pBackground  :setTouchesEnabled( true )
    self.m_pBackground  :setFullScreenTouchEnabled( true )

 --关闭按钮--
    self.m_pCloseBtn 	= CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CTaskDialogView. self.m_pCloseBtn 236") 
    self.m_pCloseBtn 	:registerControlScriptHandler( closeCallBack, "this CTaskDialogView. self.m_pCloseBtn 237" )
    self.m_pBackground	:addChild( self.m_pCloseBtn, 10)
    self.m_pCloseBtn 	:setTouchesPriority( self.m_pBackground :getTouchesPriority() -2)
    self.m_pCloseBtn    :setTag( 102)

    if true then
        local szNpcSprName = "taskDialog/taskNpcResources/so_10310.png"
        
        local npcNode = _G.Config.scene_npcs :selectSingleNode( "scene_npc[@id=" .. self.m_npcId .."]" )
        print("sdfsfsfsdf", npcNode :isEmpty())
        if npcNode :isEmpty() == false then
            
            szNpcSprName = "taskDialog/taskNpcResources/so_" .. tostring( npcNode :getAttribute("head") ) .. ".png"
        end
        
        self.m_pNpcSpr    = CSprite :create( tostring( szNpcSprName ) )
        self.m_pNpcSpr    : setControlName( "this CTaskDialogView. self.m_pNpcSpr 579" .. szNpcSprName )
        self.m_pBackground :addChild( self.m_pNpcSpr, 10 )

        table.insert( self.m_createResStrList, szNpcSprName )
    end

    local _winSize	= CCDirector:sharedDirector():getVisibleSize()
    local winX      = _winSize.width
    local winY      = _winSize.height
    local sizeBg   		= self.m_pBackground :getPreferredSize()
    local sizeCloseBtn  = self.m_pCloseBtn   :getPreferredSize()
    self.m_pCloseBtn        :setPosition( ccp( sizeBg.width / 2 - sizeCloseBtn.width / 2, sizeBg.height / 2 - sizeCloseBtn.height / 2))
    self.m_pBackground      :setPosition( ccp( winX / 2 + 40, sizeBg.height * 0.71))
    
    local sizeNpcSpr = self.m_pNpcSpr :getPreferredSize()
    self.m_pNpcSpr   :setPosition( ccp( -sizeBg.width / 2 - sizeNpcSpr.width / 7 , sizeBg.height * 0.0 ))
end

function CTaskDialogView.scene( self )

	local winSize	= CCDirector:sharedDirector():getVisibleSize()
    self.m_scene		= CContainer :create()
    self.m_scene : setControlName(" this CTaskDialogView self.m_scene 617")

	self:init( winSize, self.m_scene)

    if self.m_pContainer:getParent() ~= nil then
        self.m_pContainer:removeFromParentAndCleanup(false)
    end

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_scene :registerControlScriptHandler(local_onEnter,"CTaskDialogView self.m_scene self.m_pContainer 628")

	self.m_scene:addChild( self.m_pContainer)
	return self.m_scene

end

function CTaskDialogView.onEnter( self,eventType, obj, x, y )
    print("CTaskDialogView.onEnter  --->"..eventType)
    if eventType == "Enter" then
        --初始化指引
        --初始化指引

        local function runInitGuide()
            _G.pCGuideManager:initGuide( self.m_scene,self.m_npcId)
        end
        _G.pCGuideManager:lockScene() --initGuide( self.m_scene,self.m_npcId)
        self.m_scene:performSelector(0.08,runInitGuide)
        print("CTaskDialogView.Enter  ")
    elseif eventType == "Exit" then
        print("CTaskDialogView.Exit  ")
        _G.pCGuideManager:exitView( self.m_npcId )
    end
end

--奖励物品 界面
function CTaskDialogView.addTaskRewardView( self, _xmlData)
    if _xmlData == nil then
        return
    end
                                                
    local _winSize	= CCDirector :sharedDirector() :getVisibleSize()
    local sizeBg   	= self.m_pBackground :getPreferredSize()
    
    self.m_lineSpr = CSprite :createWithSpriteFrameName( "task_dividing_line.png")
    self.m_lineSprSize = self.m_lineSpr :getPreferredSize()
    self.m_lineSpr :setPreferredSize( CCSizeMake( self.m_winSize.width * 0.6348, self.m_lineSprSize.height))
    self.m_updataLayer :addChild( self.m_lineSpr)
    self.m_lineSpr  :setPosition( 0, -self.m_winSize.height * 0.06 )
    
    self.m_taskRewardLabel = CCLabelTTF :create( "任务奖励:", "Arial", 20 )
    self.m_taskRewardLabel :setColor( ccc3( 226, 215, 118))
	self :createLabel( self.m_taskRewardLabel, self.m_updataLayer)
    
                                                
    local szGold = _xmlData :getAttribute( "gold" )           --_xmlData.gold or ""
    local szExp  = _xmlData :getAttribute( "exp" )           --_xmlData.exp  or ""
    print("--->szGold", szGold, szExp .. "dddd" )
    local nGoodsCount  = nil
    local szGoodsId    = nil
    local szGoodsIcon  = nil
                                                
    --if _xmlData.goods[1].good ~= nil then
    if _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "count" ) ~= nil then
        nGoodsCount  = tonumber( _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "count" ) )    --tonumber( _xmlData.goods[1].good[1].count ) or nil --奖励物品数量
        szGoodsId    = tonumber( _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "id" ) )    --_xmlData.goods[1].good[1].id or "40081"            --奖励物品id  "1001"
        
        if szGoodsId ~= nil then
            szGoodsIcon  = _G.g_CTaskNewDataProxy :getGoodsXmlIcon( szGoodsId )      --goodsNode.icon                                 --物品icon
        end
    end
    self.m_sliverLabel = CCLabelTTF :create( szGold.."美刀   "..szExp.."经验", "Arial", 20 )
    self.m_sliverLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
	self :createLabel( self.m_sliverLabel, self.m_updataLayer)
		
    self.m_taskRewardLabel :setPosition( -self.m_winSize.width * 0.21, -self.m_winSize.height * 0.14 )
    self.m_sliverLabel	   :setPosition( -self.m_winSize.width * 0.01, -self.m_winSize.height * 0.14 )
    
    if nGoodsCount ~= nil then
        local _hBtnLayout   = {}         --奖励icon的水平布局控件
        local _hSprLayout   = {}   
        local cellSize      = CCSizeMake( 96, 96)
        
        _hBtnLayout = CHorizontalLayout :create()  --btn水平控件
                
            _hBtnLayout :setVerticalDirection( true )
            _hBtnLayout :setCellVerticalSpace( 27 )
            _hBtnLayout :setCellHorizontalSpace( 10 )
            _hBtnLayout :setHorizontalDirection( true )
            _hBtnLayout :setVerticalDirection( false )
            _hBtnLayout :setCellSize( cellSize )
            _hBtnLayout :setPosition( -self.m_winSize.width * 0.27, -self.m_winSize.height * 0.31 )
                
        _hSprLayout = CHorizontalLayout :create()  --spr水平控件   背景框控件
        
            _hSprLayout :setVerticalDirection( true )
            _hSprLayout :setCellVerticalSpace( 27 )
            _hSprLayout :setCellHorizontalSpace( 10 )
            _hSprLayout :setHorizontalDirection( true )
            _hSprLayout :setVerticalDirection( false )
            _hSprLayout :setCellSize( cellSize )
            _hSprLayout :setPosition( -self.m_winSize.width * 0.27, -self.m_winSize.height * 0.31 )

            local nRow = nGoodsCount  --一行 的数量
            _hBtnLayout :setLineNodeSum( nRow )
            _hSprLayout :setLineNodeSum( nRow )

            self.m_updataLayer :addChild( _hSprLayout )
            self.m_updataLayer :addChild( _hBtnLayout )

        local function rewardCallback(  eventType, obj, x, y )
            return self :onRewardCallback(  eventType, obj, x, y )
        end

        local rewardBtn    = {}    --奖励物品的按钮
        for i=1, nRow do
            local sprBg = CSprite :createWithSpriteFrameName( "general_props_frame_normal.png" )
            sprBg :setPreferredSize( cellSize)
            _hSprLayout :addChild( sprBg)
            
            local btn = CButton :create( "", "Icon/i"..szGoodsIcon..".jpg" )
            local _szsz = "Icon/i"..szGoodsIcon..".jpg"
            print( "sadadasdasdasdsa-->", _szsz, btn )
            btn :setTag( tonumber( szGoodsId ) )
            btn :setPreferredSize( CCSizeMake( cellSize.width-16, cellSize.height-16 ) )

            table.insert( self.m_createResStrList, "Icon/i"..szGoodsIcon..".jpg" )
                                                
            btn :registerControlScriptHandler( rewardCallback, "this CTaskDialogView. btn 693"..i )
            btn :setTouchesPriority( self.m_pBackground :getTouchesPriority() -1 )
            _hBtnLayout :addChild( btn )

            rewardBtn[i] = {}
            rewardBtn[i] = btn
        end
    else
        print("-------else nil")
    end

end

function CTaskDialogView.closeWindow( self)
    self : removeMediator()
                                             
    if self.m_updataLayer ~= nil then
        self.m_updataLayer :removeFromParentAndCleanup( true )
        self.m_updataLayer = nil
    end
    if self.m_pContainer ~= nil then
        self.m_pContainer :removeFromParentAndCleanup( true)
        self.m_pContainer = nil
    end
    if _G.t_dialog ~= nil then
        _G.t_dialog :removeFromParentAndCleanup( true)
        _G.t_dialog = nil
    end

    if self.m_scene ~= nil then
        self.m_scene :removeFromParentAndCleanup( true )
        self.m_scene = nil
    end

    self:unloadResources()
end

----------------callback函数 begin
function CTaskDialogView.onRewardCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )

    elseif eventType == "TouchEnded" then
        local nGoodsId = obj :getTag()
        print("nGoodsIdnGoodsId", nGoodsId)
        local _position = ccp( x, y * 1.5 )
        local temp = _G.g_PopupView :createByGoodsId( nGoodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
        self.m_pContainer :addChild( temp )
        return true 
    end

end

function CTaskDialogView.onCloseCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_ClickNpc = false
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:getTag() == 101 then
        	--print( "屏蔽背后")
        elseif obj:getTag() == 102 then
	        self :closeWindow()
            return true
	    end
	        
    end
end

function CTaskDialogView.onTalkCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
    	
        local nTag = obj :getTag()
        print("谈话按钮===", nTag, CTaskDialogView.TAG_REQUEST_TASK, _G.Constant.CONST_NPC_FUN_DEPOT)
        
        _G.pCGuideManager:stepFinish(0)
        if nTag == 10 then
            return true

        elseif nTag == CTaskDialogView.TAG_REQUEST_TASK then    --如果为任务请求tag

            -- _G.pCGuideManager:sendStepFinish()

            nTag = nTag / 100
            self : requestTaskByState( nTag )
            self : clickBtnAndUpdate( nTag )
            return true

        elseif nTag == _G.Constant.CONST_NPC_FUN_DEPOT then     --酒吧
            self :closeWindow()
            require "view/BarPanelLayer/BarPanelView"
            _G.pBarPanelView  = CBarPanelView()
            CCDirector :sharedDirector() :pushScene( _G.pBarPanelView :scene())
            return true
            
        elseif nTag == _G.Constant.CONST_NPC_FUN_SHOP then      --商店
            self :closeWindow()
            require "view/Shop/ShopLayer"
            CCDirector : sharedDirector () : pushScene(CShopLayer () :scene())
            return true

        elseif nTag == _G.Constant.CONST_NPC_FUN_PREFEREN_SHOP then      --超值优惠商店
            self :closeWindow()
            require "view/SuperDealsShop/SuperDealsShopLayer"
            CCDirector : sharedDirector () : pushScene(CSuperDealsShopLayer () :scene())
            return true
        end
        
        

        self : clickBtnAndUpdate( nTag )

        
        return true
    end
end

function CTaskDialogView.clickBtnAndUpdate( self, _nTag )
    if _nTag ~= nil or self.m_taskInfo ~= nil then
        for key, value in pairs( self.m_taskInfo ) do
            if tonumber( value.id ) == _nTag then
                print("CTaskDialogView.clickBtnAndUpdate", value.id, _nTag )
                self : onUpdateTaskViewByData( value )
                return
            end
        end
    end
end

--{根据任务数据显示任务界面}
function CTaskDialogView.onUpdateTaskViewByData( self, _data )
    if _data == nil then
        return
    end

    if self.m_pBtnClick ~= nil then
        self.m_pBtnClick :removeFromParentAndCleanup( true )
        self.m_pBtnClick = nil
    end
    if self.m_updataLayer ~= nil then
		self.m_updataLayer :removeFromParentAndCleanup( true)
		self.m_updataLayer = nil
	end
    local function func_create()
        --需要更新的层
        self.m_updataLayer	= CContainer :create()
        self.m_pBackground 	:addChild( self.m_updataLayer )
       
        local nState = tonumber( _data.state )
        self.m_currentTaskId = tonumber( _data.id )
        self.m_currentData   = _data
        local szNpcSays     = nil
        local szRoleSays    = nil
        
        --以下为点击后改变的界面
        local xmlData = _G.g_CTaskNewDataProxy :getTaskDataById( tonumber( _data.id ) )
        print( "xmllllData", xmlData )
        if xmlData ~= nil then
            
            if nState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then
                szNpcSays     = _G.g_CTaskNewDataProxy :getDialogAttribute( xmlData, "s" ) or ""
                szRoleSays    = _G.g_CTaskNewDataProxy :getDialogAttribute( xmlData, "sr" ) or ""   --xmlData.dialog[1].sr
                
            elseif nState == _G.Constant.CONST_TASK_STATE_UNFINISHED then 
                szNpcSays     = _G.g_CTaskNewDataProxy :getDialogAttribute( xmlData, "m" ) or ""   --xmlData.dialog[1].m
                szRoleSays    = _G.g_CTaskNewDataProxy :getDialogAttribute( xmlData, "mr" ) or ""   --xmlData.dialog[1].mr
                
            elseif nState == _G.Constant.CONST_TASK_STATE_FINISHED then
                szNpcSays     = _G.g_CTaskNewDataProxy :getDialogAttribute( xmlData, "e" ) or ""   --xmlData.dialog[1].e
                szRoleSays    = _G.g_CTaskNewDataProxy :getDialogErAttribute( xmlData, "d" ) or ""    --xmlData.dialog[1].er[1].d
                self : addTaskRewardView( xmlData )
                
            end
            
            self.m_nTaskState = tonumber( _data.target_type )
            
            self.m_pNpcSaysLabel :setString( szNpcSays )
            self.m_pBtnClick    = CButton :createWithSpriteFrameName( "", "task_talk_normal.png" )
            CTaskDialogView.TAG_REQUEST_TASK = tonumber( _data.state ) * 100
            self.m_pBtnClick    :setTag( CTaskDialogView.TAG_REQUEST_TASK )
            
            self : createBtnByData( self.m_pBtnClick, szRoleSays, nState, 1, false )
        end
    end
    
    local actarr = CCArray :create()
    local dela = CCDelayTime :create( 0.01 )
    local temp = CCCallFunc : create( func_create )
    actarr :addObject( dela)
    actarr :addObject( temp)
    local seq = CCSequence:create(actarr)
    self.m_pContainer :runAction( seq )
end

function CTaskDialogView.getTaskState( self )
    return self.m_nTaskState
end

function CTaskDialogView.requestTaskByState( self, _nState )
    if _nState == nil or self.m_currentTaskId == nil then
        return
    end
    
    --设置当前任务为追踪任务
    _G.g_CTaskNewDataProxy :setMainTask( self.m_currentData )
    
    print("_nState_nState_nState", _nState, self.m_currentTaskId, self.m_currentData.target_type)
    if _nState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then
        require "common/protocol/REQ_TASK_ACCEPT"          --请求接受任务 3230
        local msg = REQ_TASK_ACCEPT()
        msg :setId( self.m_currentTaskId )
        CNetwork :send( msg )
        self : removeMediator()
        self : closeWindow()
        
       -- self : TaskEffectsCommandSend(1) -- 1是接受任务 2是完成任务
       --把当前的任务数据保存道proxy 在proxy等返回时判断一下
       _G.g_CTaskNewDataProxy :setNowTaskEffectsData( self.m_currentTaskId, _nState )
        
        local guiderTask = _G.g_CTaskNewDataProxy :getMainTask()
        if guiderTask ~= nil then
            local nBeginNpcId   = tonumber( guiderTask.beginNpc)
            local nEndNpcId     = tonumber( guiderTask.endNpc)
            local nBeginSceneId = tonumber( guiderTask.beginNpcScene)
            local nEndSceneId   = tonumber( guiderTask.endNpcScene)
            local nTarget_type  = tonumber( guiderTask.target_type)
            local nTarget_id    = nil               
            if guiderTask.target_id ~= nil then
                nTarget_id = tonumber( guiderTask.target_id )
            end
            
            print("判断类型为6的任务 ", nTarget_id)
            
            local nPos = nil 
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
                        CCDirector :sharedDirector() :pushScene( _G.pFactionApplyView :scene())
                    else
                        --print( "玩家已经加入社团", myclan)
                        _G.pFactionPanelView = CFactionPanelView()
                        CCDirector :sharedDirector() :pushScene( _G.pFactionPanelView :scene())
                    end
                    
                elseif nTarget_id ~= nil and nTarget_id == 21 then      --打开下载界面
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
            
            if nPos ~= nil then
                --print("CTaskDialogView跑的位置-->", nPos.x, nPos.y )
                _G.g_Stage :getRole() :setMovePos( nPos )
            end
        end
    elseif _nState == _G.Constant.CONST_TASK_STATE_UNFINISHED then
        self :gotoTask()
    elseif _nState == _G.Constant.CONST_TASK_STATE_FINISHED then
        CCLOG("已完成，提交任务")

        -- _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK, self.m_currentTaskId )

        self : removeMediator()
        self : closeWindow()
        require "common/protocol/REQ_TASK_SUBMIT"
        local msg = REQ_TASK_SUBMIT()
        msg :setId( self.m_currentTaskId )
        msg :setArg( 0 )
        CNetwork :send( msg )

        --self : TaskEffectsCommandSend(2)
        
    end
end

-- function CTaskDialogView.TaskEffectsCommandSend(self,value)
--     require "controller/TaskEffectsCommand"
--     local TaskEffectsCommand = CTaskEffectsCommand(value) -- 1是接受任务 2是完成任务
--     controller:sendCommand(TaskEffectsCommand)
-- end

function CTaskDialogView.gotoTask( self )
    self : removeMediator()
    self : closeWindow()
    local command = CTaskDialogUpdateCommand( CTaskDialogUpdateCommand.GOTO_TASK )
    controller :sendCommand( command )
end

----------------set		函数 end
-----------------------------------
function CTaskDialogView.setTaskDialogView( self)
    
    --print("CTaskDialogView.setTaskDialogView")
end

function CTaskDialogView.setUpdateView( self )
    self : initTaskData( self.m_npcId )
    
    --print("CTaskDialogView.setUpdateView", debug.traceback(), self.m_npcId )
    
    if self.m_currentTaskId ~= nil then
        self : clickBtnAndUpdate( self.m_currentTaskId )
    end
end







