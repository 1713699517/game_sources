require "view/view"
require "controller/TaskNewDataCommand"
require "model/VO_TaskNewModel"
require "mediator/TaskNewMediator"

CTaskNewView = class( view, function( self )
	-- body
	print("任务UI  self==", self, view)
    self.m_winSize = CCSizeMake( 854.0, 640.0)
                     
    local mainProperty    = _G.g_characterProperty :getMainPlay()
    self.role_lv          = mainProperty : getLv()
end)

CTaskNewView.TAG_CURRENTTASKBTN     = 100           --当前任务tag
CTaskNewView.TAG_DONOTTASKBTN       = 200           --未接任务tag

--加载资源
function CTaskNewView.loadResources( self )
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("taskInfo/taskResourcesNew.plist")
    if _G.Config.scene_copys == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/scene_copy.xml")
    end
    if _G.Config.scene_npcs == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/scene_npc.xml")
    end
    if _G.Config.tasks == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/tasks.xml")
    end
    if _G.Config.scenes == nil then
        CConfigurationManager :sharedConfigurationManager() :load( "config/scene.xml")
    end
end

function CTaskNewView.unloadResources( self )

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("taskInfo/taskResourcesNew.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("taskInfo/taskResourcesNew.pvr.ccz")

    if _G.g_unLoadIconSources ~= nil then
        _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
        self.m_createResStrList = {}
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

end

--初始化界面
function CTaskNewView.init( self, _winSize, _layer )
    self.m_pContainer = CContainer :create()
    
    self : addMediator()                             --注册任务界面的mediator
	self : loadResources()                           --加载资源
	self : initParams()                              --初始化参数
	self : initBgAndCloseBtn( _layer )               --初始化背景及关闭按钮
	self : initView( _winSize, _layer)               --初始化界面
	self : layout( _winSize )                        --布局
end

function CTaskNewView.addMediator( self)
    self : removeMediator()
    
    _G.g_CTaskNewMediator = CTaskNewMediator( self)
    controller : registerMediator( _G.g_CTaskNewMediator)
end

function CTaskNewView.removeMediator( self)
    if _G.g_CTaskNewMediator ~= nil then
        controller : unregisterMediator( _G.g_CTaskNewMediator)
        _G.g_CTaskNewMediator = nil
    end
end

function CTaskNewView.initParams( self )
    --print( "CTaskNewView.initParam==", _G.g_CTaskNewDataProxy :getInitialized())
    
    self.m_createResStrList = {}

    if _G.g_CTaskNewDataProxy :getInitialized() == true then
        self.m_taskInfoList = _G.g_CTaskNewDataProxy :getTaskDataList()     --所有的任务数据
        self.m_isCurOrDonot = true                                          --区分当前任务(true) 还是 未接任务界面(false)
        --分解出 当前任务 ／ 未接任务
        if self.m_taskInfoList ~= nil then
    
            for key, value in pairs( self.m_taskInfoList ) do
                if tonumber( value.state ) == 1 or tonumber( value.state ) == 2  then
                    if self.m_donotList == nil then         --未接任务
                        self.m_donotList = {}
                    end
                    self.m_donotList[ #self.m_donotList + 1 ] = value
                    
                elseif tonumber( value.state ) == 3 or tonumber( value.state ) == 4 then    
                    if self.m_curInfoList == nil then       --已接任务
                        self.m_curInfoList = {}
                    end
                    self.m_curInfoList[ #self.m_curInfoList + 1 ] = value
                end
            end
        end
    end
end

function CTaskNewView.setCurrentTag( self, _bValue)
   self.m_isCurOrDonot = _bValue
end

function CTaskNewView.getCurrentTag( self)
   return self.m_isCurOrDonot
end

function CTaskNewView.setCurrentBtnData( self, _btnData)
    self.currentBtnData  = _btnData
end

function CTaskNewView.getCurrentBtnData( self)
    return self.currentBtnData
end

--总行数，每行的页数
function CTaskNewView.getTaskPages( self, _nCount, _nPageLine )
    --默认页数   --  对行数 进行取余，如果有余数，nRetPage+1
    _nCount = tonumber( _nCount)
    if _nCount ~= 0 then
        local nnn = _nCount % _nPageLine
        if nnn > 0 then
            _nCount = math.modf( _nCount / _nPageLine) + 1
        else    --  nnn==0
            _nCount = _nCount / _nPageLine
        end
    else
        _nCount = 1
    end
        
    return _nCount
end

--
function CTaskNewView.initBgAndCloseBtn( self, _layer )
    --底图
    self.m_sprBottem  = CSprite :createWithSpriteFrameName( "peneral_background.jpg")
    self.m_sprBottem  :setControlName("this CEmailView. sprBottem 40")
    self.m_pContainer :addChild( self.m_sprBottem, -100)

    
	--背景
    self.m_pBackground  = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_pBackground  :setControlName("this CTaskNewView. self.m_pBackground 245")
    self.m_pContainer   :addChild( self.m_pBackground, -100 )

    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack(eventType, obj, x, y)
    end
    
 --关闭按钮
    self.m_pCloseBtn    = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CTaskNewView. self.m_pCloseBtn 254")
    self.m_pCloseBtn    :registerControlScriptHandler( closeCallBack, "this CTaskNewView. self.m_pCloseBtn 255" )
    self.m_pBackground   :addChild( self.m_pCloseBtn, 10)
    
end

function CTaskNewView.initView( self, _winSize, _layer )
    
    local function taskCallback( eventType, obj, x, y)
        return self :onTaskCallback( eventType, obj, x, y)
    end
    
    local nBtnLabelSize = 24
    
    local szTaskImageName = "general_label_normal.png"
    --当前任务按钮
    self.m_pCurrentTaskBtn  = CButton :createWithSpriteFrameName("当前任务", szTaskImageName)
    self.m_pCurrentTaskBtn  :setControlName("this CTaskNewView. self.m_pCurrentTaskBtn 271")
    self.m_pContainer       :addChild( self.m_pCurrentTaskBtn, -99, CTaskNewView.TAG_CURRENTTASKBTN )
    self.m_pCurrentTaskBtn  :registerControlScriptHandler( taskCallback, "this CTaskNewView. self.m_pCurrentTaskBtn 273" )
    self.m_pCurrentTaskBtn  :setFontSize( nBtnLabelSize )
    
    --未接任务按钮
    self.m_pDonotTaskBtn    = CButton :createWithSpriteFrameName("未接任务", szTaskImageName)
    self.m_pDonotTaskBtn    :setControlName("this CTaskNewView. self.m_pDonotTaskBtn 278")
    self.m_pContainer       :addChild( self.m_pDonotTaskBtn, -99, CTaskNewView.TAG_DONOTTASKBTN )
    self.m_pDonotTaskBtn    :registerControlScriptHandler( taskCallback, "this CTaskNewView. self.m_pDonotTaskBtn 280" )
    self.m_pDonotTaskBtn    :setFontSize( nBtnLabelSize )
    
    local nCurBtnSize   = self.m_pCurrentTaskBtn :getPreferredSize()
    
    self.m_pBgSize = CCSizeMake( self.m_winSize.width * 0.4766, self.m_winSize.height * 0.8609)
    --左边的滑动背景图
    self.m_pLeftTaskListBg  = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_pLeftTaskListBg  :setControlName("this CTaskNewView. self.m_pLeftTaskListBg 293")
    self.m_pLeftTaskListBg  :setPreferredSize( self.m_pBgSize )
    self.m_pContainer       :addChild( self.m_pLeftTaskListBg, -99)
    
    --右边的技能信息背景图
    self.m_pRightTaskInfoBg = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_pRightTaskInfoBg :setControlName("this CTaskNewView. self.m_pRightTaskInfoBg 299")
    self.m_pRightTaskInfoBg :setPreferredSize( self.m_pBgSize )
    self.m_pContainer       :addChild( self.m_pRightTaskInfoBg, -99)

    self : initFirstView()
    
end

--{初始化首次界面}
function CTaskNewView.initFirstView( self )
    --print( "CTaskNewView.initFirstView", self.m_curInfoList, self.m_donotList )
    if self.m_curInfoList ~= nil then
        self : pageScrollView( self.m_curInfoList )
        self : createRightView( self.m_curInfoList[1])
        self : addHightLightByTag( self.m_pCurrentTaskBtn )
        
    elseif self.m_curInfoList == nil and self.m_donotList ~= nil then
        self : pageScrollView( self.m_donotList )
        self : createRightView( self.m_donotList[1] )
        self : addHightLightByTag( self.m_pDonotTaskBtn )
    end
end

function CTaskNewView.createRightView( self, _taskDataList)
    if self.stateBtn ~= nil then
        self.m_pRightContainer :removeChild( self.stateBtn )
        self.stateBtn = nil
    end
    
    if self.m_pRightContainer ~= nil then
        self.m_pRightContainer :removeFromParentAndCleanup( true)
        self.m_pRightContainer = nil
    end
    if _taskDataList == nil then
        print("_taskDataList", _taskDataList)
        return true
    end
    --print("_taskDataList==", _taskDataList.id)
    
    self.m_uFontSize = 20
    local szFontName = "Arial"
    
    self.m_pRightContainer = CContainer :create()
    self.m_pRightContainer :setControlName("this CTaskNewView. self.m_pRightContainer 336")
    self.m_pContainer :addChild( self.m_pRightContainer)
    
    local nWinSize = CCDirector :sharedDirector() :getVisibleSize()
    
    --透明图背景
    local l_transparentContainer = CSprite :create( "Loading/transparent.png" )
    l_transparentContainer  :setPreferredSize( self.m_pBgSize )
    self.m_pRightContainer  :addChild( l_transparentContainer )

    local function stateCallback( eventType, obj, x, y )
        return self :onStateCallback( eventType, obj, x, y)
    end
    
    --状态按钮
    self.stateBtn = CButton :createWithSpriteFrameName( "状态按钮", "general_button_normal.png")
    self.stateBtn :setControlName("this CTaskNewView. self.stateBtn 346")                                           
    self.stateBtn :setTag( tonumber( _taskDataList.id ) )
    self.stateBtn :registerControlScriptHandler( stateCallback, "this CTaskNewView. self.stateBtn 347")
    self.stateBtn :setTouchesPriority( self.stateBtn :getTouchesPriority() -100 )
    self.m_pRightContainer :addChild( self.stateBtn)
    
    
    local szState = "自动寻路"
    nState = tonumber( _taskDataList.state )
    --
    local szAddLabel = ""  --任务状态
    if nState == _G.Constant.CONST_TASK_STATE_INACTIVE then
        szAddLabel = "(未激活)"
        
    elseif nState == _G.Constant.CONST_TASK_STATE_ACTIVATE then
        szAddLabel = "(不可接)"
   
    elseif nState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then
        szAddLabel = "(可接受)"
   
    elseif nState == _G.Constant.CONST_TASK_STATE_UNFINISHED then
        szAddLabel = "(进行中)"
   
    elseif nState == _G.Constant.CONST_TASK_STATE_FINISHED then
        szAddLabel = "(可完成)"
   
    elseif nState == _G.Constant.CONST_TASK_STATE_SUBMIT then
        szAddLabel = "(已提交)"
   
    end
     --]]
    
    if szState ~= nil then
        self.stateBtn :setText( szState )
        self.stateBtn :setFontSize( 20 )
        self.stateBtn :setHightLight()
    end
    
    for i=1, 3 do
       local l_line_fir = CSprite :createWithSpriteFrameName( "task_dividing_line.png")
        l_line_fir :setControlName( "this CTaskNewView. l_line_fir 272"..i )
       local l_line_fir_Size = l_line_fir :getPreferredSize()
       l_line_fir :setPreferredSize( CCSizeMake( self.m_pBgSize.width, l_line_fir_Size.height))
       self.m_pRightContainer :addChild( l_line_fir)
       l_line_fir  :setPosition( self.m_pBgSize.width * 0.10, self.m_winSize.height * ( 0.37 - 0.23 * (i-1)) )
    end
    
    --任务名字
    local szTaskName = "[主线]:"      --.._taskDataList[1].name
    local szTaskInfo = "任务信息描述"  
    local szBeginNpcName = ""        --开始npc名字
    local szEndNpcName = ""          --完成npc名字
    local nGoodsCount  = nil         --奖励物品数量
    local nGoodsId     = nil         --物品id
    
    local taskInfo = ""
    local szTaskProgress = ""
    local szAlwaysDid = ""
    local isRed = false
        
    --根据xml表 初始化数据
    --local readNode = _G.Config.tasks:selectNode("task", "id", tostring( _taskDataList.id ) )
    local readNode = _G.g_CTaskNewDataProxy  :getTaskDataById( _taskDataList.id )
    if readNode ~= nil then
        if _taskDataList.target_type == _G.Constant.CONST_TASK_TARGET_TALK then     -- [1]对话类 -- 任务
            
        elseif _taskDataList.target_type == _G.Constant.CONST_TASK_TARGET_COPY then -- [7]通关副本 -- 任务
            local copy_id = _G.g_CTaskNewDataProxy :getTargetAttribute( readNode, "copy_id", _taskDataList.target_type )       --readNode.target_7[1].copy_id    --副本id
            local times   = _G.g_CTaskNewDataProxy :getTargetAttribute( readNode, "times", _taskDataList.target_type )       --readNode.target_7[1].times      --需要打的次数
            local currentTimes = tostring( _taskDataList.current )
            local copy_name = ""
            
            --local copyNode = _G.Config.scene_copys :selectNode( "scene_copy", "copy_id", copy_id)
            local copyNode = _G.g_CTaskNewDataProxy :getScenesCopysNodeByCopyId( copy_id )
            if copyNode ~= nil then
                copy_name = copyNode :getAttribute( "copy_name" )   --copyNode.copy_name
            end
             
             
            taskInfo = "任务进度 "
            szTaskProgress = "通关 "..(copy_name or "").." 副本"
            szAlwaysDid = (copy_name or "").."副本".."("..(currentTimes or "").."/"..(times or "")..")"
        end
        
        local _ssszName = readNode :getAttribute( "name" ) or ""
        local _ssszLv   = readNode :getAttribute( "lv" ) or ""
        
        print("_ssszName", _ssszName, _ssszLv)
        if tonumber( readNode :getAttribute( "type") ) == 1 then
            szTaskName = "[主线]:".. _ssszName .." [lv:".. _ssszLv .."]" .. szAddLabel
        elseif tonumber( readNode :getAttribute( "type") ) == 2 then
            szTaskName = "[支线]:".. _ssszName .." [lv:".. _ssszLv .."]" .. szAddLabel
        end
        
        szTaskInfo = _G.g_CTaskNewDataProxy :getTipAttribute( readNode, "desc")
        
        if _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "count" ) ~= nil then
            nGoodsCount  = tonumber( _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "count" ) )    --readNode.goods[1].good[1].count )
            nGoodsId     = tonumber( _G.g_CTaskNewDataProxy :getGoodsAttribute( _xmlData, 0, "id" ) )       --readNode.goods[1].good[1].id )
        end

        local beginNpcNode = _G.g_CTaskNewDataProxy :getNpcNodeById( tostring( _G.g_CTaskNewDataProxy:getNpcAttribute( readNode, "s", "npc")) )
        if beginNpcNode ~= nil and not beginNpcNode :isEmpty() then
            szBeginNpcName  = beginNpcNode :getAttribute( "npc_name" )      --beginNpcNode.npc_name
        end

        local endNpcNode = _G.g_CTaskNewDataProxy :getNpcNodeById( tostring( _G.g_CTaskNewDataProxy:getNpcAttribute( readNode, "e", "npc")) )
        if endNpcNode ~= nil and not endNpcNode :isEmpty() then
            szEndNpcName  = endNpcNode :getAttribute( "npc_name" )          --endNpcNode.npc_name
        end
        
        if self.role_lv < tonumber( readNode :getAttribute( "lv" ) or 0 ) then
            isRed = true
        end
    else
        print("right__taskDataList.id", _taskDataList.id)
    end
    
    local pTaskNameLabel = CCLabelTTF :create( tostring( szTaskName ), szFontName, self.m_uFontSize )
    print("pTaaskNameLabel", szTaskName)
    if isRed == true then
        pTaskNameLabel :setColor( ccc3( 255, 0, 0 ) )
    end
    pTaskNameLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    l_transparentContainer :addChild( pTaskNameLabel)
    
    --任务信息
    local pTaskInfoLabel = CCLabelTTF :create( tostring( szTaskInfo ), szFontName, self.m_uFontSize )
    pTaskInfoLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    l_transparentContainer :addChild( pTaskInfoLabel)
    
    ---------可以加入一个控件
    local vLayout = CVerticalLayout :create()
    vLayout :setCellSize( CCSizeMake( 280,60))
    vLayout :setVerticalDirection( false)
    vLayout :setHorizontalDirection( true)
    vLayout :setLineNodeSum(1)
    vLayout :setColumnNodeSum(10)
    vLayout :setCellVerticalSpace(8)
    vLayout :setCellHorizontalSpace(0)
    self.m_pRightContainer :addChild( vLayout)
    
    vLayout :setPosition( nWinSize.width * 0.1042, nWinSize.height * 0.1719)

    local yellowColor = ccc3( 255, 255, 0)
    --发布npc
    local pBeginNpc = CCLabelTTF :create( "发布NPC ", szFontName, self.m_uFontSize )
    pBeginNpc :setHorizontalAlignment( kCCTextAlignmentLeft)
    l_transparentContainer :addChild( pBeginNpc )
   
    
    local pBeginNpcName = CCLabelTTF :create( szBeginNpcName, szFontName, self.m_uFontSize)
    pBeginNpcName :setHorizontalAlignment( kCCTextAlignmentLeft )
    pBeginNpcName :setColor( yellowColor )
    l_transparentContainer :addChild( pBeginNpcName )
    
    --完成npc
    local pEndNpc = CCLabelTTF :create( "完成NPC ", szFontName, self.m_uFontSize )
    pEndNpc :setHorizontalAlignment( kCCTextAlignmentLeft )
    l_transparentContainer :addChild( pEndNpc)
    
    local pEndNpcName = CCLabelTTF :create( szEndNpcName, szFontName, self.m_uFontSize)
    pEndNpcName :setHorizontalAlignment( kCCTextAlignmentLeft )
    pEndNpcName :setColor( yellowColor )
    l_transparentContainer :addChild( pEndNpcName )
    
    --任务进度
    local pTaskProgress = CCLabelTTF :create( tostring( taskInfo) or "", szFontName, self.m_uFontSize )
    pTaskProgress :setHorizontalAlignment( kCCTextAlignmentLeft)
    l_transparentContainer :addChild( pTaskProgress)
    --任务进度详细 黄色显示
    local pTaskProgressLabel = CCLabelTTF :create( tostring( szTaskProgress) or "", szFontName, self.m_uFontSize)
    pTaskProgressLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    pTaskProgressLabel :setColor( yellowColor)
    l_transparentContainer :addChild( pTaskProgressLabel)
    --已经完成的 红色显示
    local pRedLabel = CCLabelTTF :create( tostring( szAlwaysDid) or "", szFontName, self.m_uFontSize)
    pRedLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    pRedLabel :setColor( ccc3( 255, 0, 0))
    l_transparentContainer :addChild( pRedLabel)
    
    local _szReward = "0"
    local _szExp    = "0"
    if readNode ~= nil then
        _szReward = readNode :getAttribute("gold") or "0"
        _szExp    = readNode :getAttribute("exp") or "0"
    end
    
    
    
    --任务奖励
    local pTaskReward = CCLabelTTF :create( "任务奖励  美刀"..( _szReward ) .."  经验"..( _szExp ), "Arial", self.m_uFontSize )
    pTaskReward :setHorizontalAlignment( kCCTextAlignmentLeft)
    l_transparentContainer :addChild( pTaskReward)
                                               
    --nGoodsCount
    if nGoodsCount ~= nil then
        local _hBtnLayout   = {}         --奖励icon的水平布局控件
        local _hSprLayout   = {}   
        local cellSize      = CCSizeMake( 96, 96)

        _hBtnLayout = CHorizontalLayout :create()  --btn水平控件
                
            _hBtnLayout :setVerticalDirection( true)
            _hBtnLayout :setCellVerticalSpace(27)
            _hBtnLayout :setCellHorizontalSpace(10)
            _hBtnLayout :setHorizontalDirection(true)
            _hBtnLayout :setVerticalDirection(false)
            _hBtnLayout :setCellSize( cellSize)
            local nlayoutX = - 106 * 1.2  --(nWinSize.width - self.m_winSize.width) * 0.4
            _hBtnLayout :setPosition( nlayoutX, -nWinSize.height * 0.010)
                
        _hSprLayout = CHorizontalLayout :create()  --spr水平控件   背景框控件
        
            _hSprLayout :setVerticalDirection( true)
            _hSprLayout :setCellVerticalSpace(27)
            _hSprLayout :setCellHorizontalSpace(10)
            _hSprLayout :setHorizontalDirection(true)
            _hSprLayout :setVerticalDirection(false)
            _hSprLayout :setCellSize( cellSize)
            _hSprLayout :setPosition( nlayoutX, -nWinSize.height * 0.010)

            local nRow = nGoodsCount  --一行 的数量
            _hBtnLayout :setLineNodeSum( nRow)
            _hSprLayout :setLineNodeSum( nRow)

            self.m_pRightContainer :addChild( _hSprLayout)
            self.m_pRightContainer :addChild( _hBtnLayout)

        local function rewardCallback( eventType, obj, x, y )
            return self :onRewardCallback( eventType, obj, x, y)
        end

        local rewardBtn    = {}    --奖励物品的按钮
        for i=1, nRow do
            local szGoodId = "1001"
            if nGoodsId ~= nil then
                print("nGoodsId", nGoodsId )
                if _G.Config.goodss == nil then
                    CConfigurationManager :sharedConfigurationManager() :load( "config/goods.xml")
                end
                local goodsNode  = _G.Config.goodss :selectNode( "goods", "id", tostring( nGoodsId ) )
                if goodsNode ~= nil then
                    szGoodId = tostring( goodsNode.icon )                                 --物品icon
                end
            end
            
            --local sprBg = CSprite :create("Icon/i"..( szGoodId or "1001" )..".png")
            local sprBg = CSprite :create("Icon/i"..(szGoodId or "1001")..".jpg")
            --sprBg :setPreferredSize( cellSize)
            _hSprLayout :addChild( sprBg)

            table.insert( self.m_createResStrList, "Icon/i"..(szGoodId or "1001")..".jpg" )
            
            local btn = CButton :createWithSpriteFrameName( "", "general_props_frame_normal.png")
            btn :setTag( nGoodsId )
            --btn :setPreferredSize( CCSizeMake( cellSize.width-16, cellSize.height-16))
            btn :registerControlScriptHandler( rewardCallback )
            btn :setTouchesPriority( btn : getTouchesPriority() - 10 )
            _hBtnLayout :addChild( btn )

            rewardBtn[i] = {}
            rewardBtn[i] = btn
        end
    end

    pTaskNameLabel :setPosition( - 10, nWinSize.height * 0.550)
    pTaskInfoLabel :setDimensions( CCSizeMake( self.m_pBgSize.width - 30, 100))
    pTaskInfoLabel :setPosition( nWinSize.width / 15, nWinSize.height * 0.43)

    local nX = -8
    local nNpcX = -94.67 --    - nWinSize.width / 12.0
    local nExtendedX = 90           --延长距离

    local  labelXXX = 261.28
    pBeginNpc   :setPosition( nNpcX, nWinSize.height * 0.33)
    pBeginNpcName :setPosition( nNpcX + nExtendedX, nWinSize.height * 0.33)

    pEndNpc     :setPosition( nNpcX, nWinSize.height * 0.28)
    pEndNpcName :setPosition( nNpcX + nExtendedX, nWinSize.height * 0.28)

    pTaskProgress :setPosition( nNpcX, nWinSize.height * 0.23)
    pTaskProgressLabel :setPosition( nNpcX + nExtendedX + 73, nWinSize.height * 0.23)
    pRedLabel :setPosition( nNpcX + nExtendedX+ 65, nWinSize.height * 0.18)

    pTaskReward    :setPosition( nX + 16, nWinSize.height * 0.09)

    local btnSize = self.stateBtn :getPreferredSize()
    l_transparentContainer :setPosition( 10, 0 )
    self.stateBtn          :setPosition( 0.0525 * nWinSize.width, - btnSize.height * 2.0)
    self.m_pRightContainer :setPosition( nWinSize.width * 0.5 + 170, nWinSize.height / 2 - 140)
    --print("\n创建成功！_taskDataList[1].goodsId", #_taskDataList, nWinSize.width, nWinSize.height, debug.traceback() )
end


function CTaskNewView.layout( self, _winSize )
    local sizeCloseBtn  = self.m_pCloseBtn :getContentSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local nCurBtnSize   = self.m_pCurrentTaskBtn :getPreferredSize()
    
    if winY == 640 then
        self.m_sprBottem        :setPosition( winX / 2, winY / 2)
        self.m_pBackground      :setPreferredSize( CCSizeMake( self.m_winSize.width, self.m_winSize.height))
        self.m_pCloseBtn        :setPosition( ccp( self.m_winSize.width / 2-sizeCloseBtn.width / 2, self.m_winSize.height / 2-sizeCloseBtn.height/2) )
        self.m_pBackground      :setPosition(ccp( winX / 2, winY / 2))
        
        self.m_pCurrentTaskBtn  :setPosition( winX / 2 - self.m_winSize.width / 2 + nCurBtnSize.width * 0.7, winY-nCurBtnSize.height * 0.81)
        self.m_pDonotTaskBtn    :setPosition( winX / 2 - self.m_winSize.width / 2 + nCurBtnSize.width * 1.7 + 6, winY-nCurBtnSize.height * 0.81)
        
        self.m_pLeftTaskListBg  :setPosition( winX / 2 - self.m_pBgSize.width / 2 - 8, winY / 2 - 25)
        self.m_pRightTaskInfoBg :setPosition( winX / 2 + self.m_pBgSize.width / 2 + 7, winY / 2 - 25)
        
    elseif winY == 768 then
          
    end
end

function CTaskNewView.pageScrollView( self, _taskDataList )
        
    if self.m_pScrollView ~= nil then
        self.m_pScrollView :removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
    
    if _taskDataList == nil then
        return
    end
    
    local _nLine = 5
    local _nPage = self : getTaskPages( #_taskDataList, _nLine )   --计算左边滑动显示的任务页数
    --print("页数。。", _nPage, #_taskDataList)
    
    _page = _nPage
    --print(".._taskDataList==", _taskDataList[1].id)
    if _page == nil or _page == 0 then
        return
    end
    --print("页页数", _page)
    
    local _winSize = CCDirector :sharedDirector() :getVisibleSize()
    local nLeftBgSize   = self.m_pLeftTaskListBg  :getPreferredSize()
    local viewSize      = CCSizeMake( nLeftBgSize.width, nLeftBgSize.height- 15)
    
    self.m_pScrollView  = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this CTaskNewView. self.m_pScrollView 522") 
    
    local l_winSize = CCDirector :sharedDirector() :getVisibleSize()
    
    self.m_pContainer   :addChild( self.m_pScrollView )
    --self.m_pScrollView  :setPosition( l_winSize.width / 2 - viewSize.width * 1.07 , 30)  self.m_winSize
    self.m_pScrollView  :setPosition( ( l_winSize.width -self.m_winSize.width) *0.5  , 30)
    --print("viewSize.width*0.05",( l_winSize.width -self.m_winSize.width) *0.5)
    
    local _pageContainer = {}
    local _nCount =1
    
    local function taskClickCallback( eventType, obj, touches)
        return self :onTaskClickCallback( eventType, obj, touches)
    end
    
    --默认两页
    local nPage = _page
    
    self.m_lineBgSize = CCSizeMake( viewSize.width - 30, viewSize.height / 5.2 )
    
    for i=1, nPage do
        _pageContainer[i] = CContainer :create()
        _pageContainer[i] :setControlName("this CTaskNewView. _pageContainer[i] 538")
        
        local vLayout = CVerticalLayout :create()
        vLayout :setVerticalDirection( false)
        vLayout :setHorizontalDirection( true)
        vLayout :setLineNodeSum( 1 )
        vLayout :setColumnNodeSum( 10 )
        vLayout :setCellVerticalSpace( 7 )
        vLayout :setCellHorizontalSpace( 0 )
        _pageContainer[i] :addChild( vLayout, -97 )
        
        local vX = ( _winSize.width - self.m_winSize.width ) * 0.5 - 80  --53 * _winSize.width / 960.0
        if _winSize.width == 960 then
            vX = 63
        end
        
        vLayout :setPosition( vX, _winSize.height * 0.40625 )
        --print("vXvX", vX)
    
        --local btnTask = {}
        
        --默认每页4条信息
        for ii=1, _nLine do
            local typeName = "[主线] "
            local taskName = "打妖怪"
            local isRed = false 

            --print("_taskDataList[_nCount].id", _taskDataList[_nCount].id)
            --local readNode = _G.Config.tasks :selectNode("task", "id", tostring( _taskDataList[_nCount].id))
            local readNode = _G.g_CTaskNewDataProxy  :getTaskDataById( _taskDataList[_nCount].id )
            if readNode ~= nil then
                if tonumber( readNode :getAttribute("type") ) == 1 and readNode :getAttribute("lv") ~= nil then
                    taskName = (readNode :getAttribute("name")) .." [lv:".. (readNode :getAttribute("lv")) .."]"
                    
                elseif tonumber( readNode :getAttribute("type") ) == 2 and readNode :getAttribute("lv") ~= nil and readNode :getAttribute("name") ~= nil then
                    typeName = "[支线]"
                    taskName = (readNode :getAttribute("name")) .." [lv:".. (readNode :getAttribute("lv")) .."]"
                end
                
                if self.role_lv < tonumber( readNode :getAttribute("lv") ) then
                    isRed = true
                end
            end
            
            local taskId   = _taskDataList[_nCount].id
            
            local btnName  = tostring( typeName .. taskName )
            
            local btnTask  = CSprite :createWithSpriteFrameName( "general_second_underframe.png" )
            btnTask :setControlName("this CTaskNewView. btnTask 574")
            btnTask :setTag( taskId )           --可以考虑用任务id做 tag
            btnTask :setTouchesMode( kCCTouchesAllAtOnce )     --
            btnTask :setTouchesEnabled( true)
            btnTask :setPreferredSize( self.m_lineBgSize )
            btnTask :registerControlScriptHandler( taskClickCallback, "this CTaskNewView. btnTask 579")
            
            btnTask :setTouchesPriority( btnTask :getTouchesPriority()-1)
            vLayout     :addChild( btnTask, -98)
            --任务名字
            local pTaskNameLabel = CCLabelTTF :create( btnName, "Arial", 20)
            pTaskNameLabel :setHorizontalAlignment( kCCTextAlignmentLeft )
            pTaskNameLabel :setPosition( self.m_lineBgSize.width * 0.15, 0)
            if isRed == true then
                pTaskNameLabel :setColor( ccc3( 255, 0, 0 ) )
            end
            btnTask :addChild( pTaskNameLabel, 10)
            --任务图标
            local pTaskIcon = CSprite :createWithSpriteFrameName( "task_icon.png")
            pTaskIcon   :setPosition( - self.m_lineBgSize.width * 0.35, 0)
            btnTask :addChild( pTaskIcon, 10)
            
            if _nCount < #_taskDataList then
                _nCount     = _nCount + 1
            else
                break
            end
        end
    end
    
    for i=nPage, 1, -1 do
        self.m_pScrollView :addPage( _pageContainer[i])
    end
    
    if nPage <= 1 then
       nPage = 1
    end
    self.m_pScrollView :setPage( nPage-1, false)
    
end

function CTaskNewView.scene( self )
	local winSize	= CCDirector:sharedDirector():getVisibleSize()
	local scene		= CCScene:create()

	self:init( winSize, scene)
	if self.m_pContainer:getParent() ~= nil then
		self.m_pContainer:removeFromParentAndCleanup(false)
	end

	scene:addChild(self.m_pContainer)
	return scene
    
end

--任务信息高亮显示
function CTaskNewView.addHightLightLineByTag( self, _obj)
    if _obj == nil then
        return
    end
    if self.m_clickTaskImg ~= nil then
        self.m_clickTaskImg :removeFromParentAndCleanup( true)
        self.m_clickTaskImg = nil
    end
    self.m_clickTaskImg = CSprite :createWithSpriteFrameName( "general_underframe_click.png")
    _obj :addChild( self.m_clickTaskImg, 9)
    if self.m_lineBgSize then
        self.m_clickTaskImg :setPreferredSize( self.m_lineBgSize)
    end
    
end

--当前、未接任务 高亮显示
function CTaskNewView.addHightLightByTag( self, _obj)
    if _obj == nil then
        return
    end
    if self.m_clickBtnImg ~= nil then
        self.m_clickBtnImg :removeFromParentAndCleanup( true)
        self.m_clickBtnImg = nil
    end
    self.m_clickBtnImg = CSprite :createWithSpriteFrameName( "general_label_click.png")
    _obj :addChild( self.m_clickBtnImg, 1 )
    
    --[[
    local plabel = nil
    local szFontName = "Arial"
    local nFontSize = 24
    
    if _obj :getTag() == CTaskNewView.TAG_CURRENTTASKBTN then
        plabel = CCLabelTTF :create( "当前任务", szFontName, nFontSize)
    elseif _obj :getTag() == CTaskNewView.TAG_DONOTTASKBTN then
        plabel = CCLabelTTF :create( "未接任务", szFontName, nFontSize)
    end
    
    if plabel ~= nil then
        self.m_clickBtnImg :addChild( plabel)
    end
     --]]
end

function CTaskNewView.cleanImg( self)
    if self.m_clickTaskImg ~= nil then
        self.m_clickTaskImg :removeFromParentAndCleanup( true)
        self.m_clickTaskImg = nil
    end
    if self.m_clickEquipBtn ~= nil then
        self.m_clickEquipBtn :removeFromParentAndCleanup( true)
        self.m_clickEquipBtn = nil
    end
end

----------------callback函数 begin
function CTaskNewView.onCloseCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        --注销
        print("@@@@@@@@@@@@@@@@关闭任务界面@@@@@@@@@@@@@@@@")
        self :removeMediator()

        CCDirector :sharedDirector() :popScene()

        self:unloadResources()
    end
end

function CTaskNewView.onTaskCallback( self, eventType, obj, x, y)
    
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print( "\n 当前任务or未接任务==", obj :getTag(), eventType )
        
        local _nPage = nil
        local _taskDataList = {}
        self : cleanImg()
        --测试
        self :createRightView( nil )    --先清空 
        if obj :getTag() == CTaskNewView.TAG_CURRENTTASKBTN then
            _taskDataList = self.m_curInfoList
            self :setCurrentTag( true)
            
        elseif obj :getTag() == CTaskNewView.TAG_DONOTTASKBTN then
            _taskDataList = self.m_donotList
            self :setCurrentTag( false)
        end
        self :addHightLightByTag( obj)
        self :pageScrollView(  _taskDataList )
        local _rightData = nil
        if _taskDataList ~= nil then
            _rightData = _taskDataList[1]
            self :createRightView(  _rightData )
        end
        
    end
end

--多点触控 
function CTaskNewView.onTaskClickCallback( self, eventType, obj, touches)
    if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchTaskTag = obj :getTag()
                break
            end
        end
        elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
            return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.touchTaskTag == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    --print("self.touchTaskTag", self.touchTaskTag)
                    self :addHightLightLineByTag( obj)
                    
                    if self.m_taskInfoList ~= nil then
                        for key, value in pairs( self.m_taskInfoList ) do
                            if tonumber( value.id ) == self.touchTaskTag then
                                self :createRightView( value )
                                
                                self.touchID     = nil
                                self.touchTaskTag = nil
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

--处理点击的任务
function CTaskNewView.onHandleByTaskData( self, _data )
    if _data == nil then
        return
    end
    --print( "_处理data", _data.id, _data.state )
    print("CTaskNewView.onHandleByTaskData")
    --设置当前追踪任务
    _G.g_CTaskNewDataProxy : setMainTask( _data )
    
    self :removeMediator()
    if self.m_pContainer ~= nil then
        self.m_pContainer :removeFromParentAndCleanup( true )
        self.m_pContainer = nil
    end
    
    CCDirector :sharedDirector() :popScene()
    self : unloadResources()
    
    require "controller/TaskDialogCommand"
    local command = CTaskDialogUpdateCommand( CTaskDialogUpdateCommand.GOTO_TASK )
    controller :sendCommand( command )
end

function CTaskNewView.onStateCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        --print("\n 任务状态 tag==", obj:getTag(), eventType)
        if self.m_taskInfoList ~= nil then
            for key, value in pairs( self.m_taskInfoList ) do
                if tonumber( value.id ) == obj : getTag() then
                    self : onHandleByTaskData( value )
                    return true
                end
            end
        end
    end
end

function CTaskNewView.onRewardCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local goodsId = obj :getTag()
        local _position = {}
        _position.x = x
        _position.y = y
        local temp = _G.g_PopupView :createByGoodsId( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
        self.m_pContainer :addChild( temp )
        return true
    end
end
----------------callback函数 end
-----------------------------------
-----------------------------------
----------------set		函数 end


function CTaskNewView.setTaskNewView( self )
    CCLOG("CTaskNewView.setTaskNewView")
    
    self : initParams()
    
    self : initFirstView()
end

