require "view/view"
require "mediator/mediator"
require "controller/command"
require "mediator/DuplicateMediator"

require "view/Stage/StageXMLManager"
require "view/DuplicateLayer/BuildTeamView"
require "view/DuplicateLayer/DuplicatePromptView"
require "view/DuplicateLayer/DuplicateAllSView"

CDuplicateView = class(view, function( self )
    CCLOG("副本界面被实例化")
    self.m_buttonstate = {}
    self.m_currentClickCopy    = nil
    self.m_flagbool    = false
end)
--常量:
CDuplicateView.TAG_PREV_PAGE    = 202
CDuplicateView.TAG_NEXT_PAGE    = 203
CDuplicateView.TAG_ALLSEVA      = 204
CDuplicateView.TAG_PREV_CHAPTER = 205
CDuplicateView.TAG_NEXT_CHAPTER = 206
CDuplicateView.TAG_HEROBUY      = 207

CDuplicateView.CLICK_ICON       = 208
CDuplicateView.BOSS_ICON        = 209
CDuplicateView.NORMAL_ICON      = 210
CDuplicateView.LOCK_ICON        = 211
CDuplicateView.BOSS_ICON_BG     = 212

CDuplicateView.PER_PAGE_COUNT   = 8
CDuplicateView.FONT_SIZE        = 23
CDuplicateView.VIEW_SIZE        = CCSizeMake( 640/3*4-50, 640*0.54)

--这个单机是 不连接网络的单机 true==联机版
_G.g_isOnline = true

--加载资源
function CDuplicateView.loadResource( self)

end
--释放资源
function CDuplicateView.unloadResource( self)

end

--副本类型
--scene_door.xml中的transfer_id字段
--普通副本 101  --英雄副本  102  --魔王副本 103
function CDuplicateView.scene(self, _transferID,_gotoSceneId)
    self.gotoSceneId = _gotoSceneId
    self.m_transferID = tonumber( _transferID )--101 --
    print("4444444444444444444副本类型：", self.m_transferID)
    -----------------------------------------
    local newScene = CCScene : create()
    self.m_sceneContainer = self :createContainer( "CDuplicateView scene self.m_sceneContainer 54")
    self : init()
    newScene : addChild( self.m_sceneContainer )
    return newScene
end

function CDuplicateView.layer( self, _transferID,_gotoSceneId)
    print("create m_sceneContainer")
    self.gotoSceneId = _gotoSceneId
    self.m_transferID = tonumber( _transferID )--101 --
    print("4444444444444444444副本类型：", self.m_transferID)
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_sceneContainer = self :createContainer( "layer self.m_sceneContainer")

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_sceneContainer :registerControlScriptHandler(local_onEnter,"CDuplicateView scene self.m_sceneContainer 58")

    self :init(winSize, self.m_sceneContainer)
    return self.m_sceneContainer
end

function CDuplicateView.container( self , _transferID )
    self.m_transferID = tonumber( _transferID )--101 --
    self.m_sceneContainer = self :createContainer( "container self.m_sceneContainer")
    self :init()
    return self.m_sceneContainer
end

function CDuplicateView.getContainer( self )
    return self.m_sceneContainer
end

--副本界面初始化
function CDuplicateView.init(self )
    --加载资源
    -- self : loadResource()
    --初始化界面
    self : initView()
    --初始化数据
    self : initParams()
    --布局成员
    self : layoutView()

end

function CDuplicateView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        --print("CDuplicateView.onEnter  ")
        --local function runInitGuide()
            --_G.pCGuideManager:initGuide(self.m_sceneContainer, _G.Constant.CONST_FUNC_OPEN_SENCE )
        --end
        if _G.pCGuideManager:getNowGuideState() == 20 then
            print("aaaaasssssssaaaaaasssssaaaasssss")
            _G.pCGuideManager:lockScene()
        end
        --self.m_sceneContainer:performSelector(0.08,runInitGuide)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_SENCE )
    end
end

function CDuplicateView.initGuideView( self )
    print("aaaaasssssssaaaaaasssssaaaasssss   12121212  ")
    local function runInitGuide()
        _G.pCGuideManager:initGuide(self.m_sceneContainer, _G.Constant.CONST_FUNC_OPEN_SENCE )
    end
    _G.pCGuideManager:lockScene()
    self.m_sceneContainer:performSelector(0.08,runInitGuide)
end

--初始化数据成员
function CDuplicateView.initParams( self )
    if _G.g_DuplicateMediator ~= nil then
        _G.controller : unregisterMediator( _G.g_DuplicateMediator )
        _G.g_DuplicateMediator = nil
    end
    _G.g_DuplicateMediator = CDuplicateMediator(self)
    _G.controller : registerMediator(_G.g_DuplicateMediator) -- CDuplicateMediator中接收以下请求的数据

    _G.Config:load("config/copy_times_pay.xml")

    local property = _G.g_characterProperty :getOneByUid( tonumber(_G.g_LoginInfoProxy:getUid()), _G.Constant.CONST_PLAYER)
    self.m_roleLv  = property :getLv()
    print( "玩家等级:",self.m_roleLv)

    local roleProperty = _G.g_characterProperty : getMainPlay()--玩家自己
    self.m_taskType, self.m_taskCopyId, self.m_chapterId = roleProperty :getTaskInfo()
    self.m_haveCount, self.m_allCount = roleProperty :getTaskCount()
    local chapterType = 101
    if self.m_taskCopyId ~= nil then
        _G.Config : load("config/scene_copy.xml")
        local sceneCopys = _G.Config.scene_copys : selectSingleNode("scene_copy[@copy_id="..tostring( self.m_taskCopyId).."]")
        if sceneCopys : isEmpty() == false then
            chapterType = 101+tonumber(sceneCopys:getAttribute("copy_type"))-1
        end
    end
    if self.m_chapterId ~= nil  and self.m_transferID == chapterType then  --
        self : requestChapterByChapId( self.m_chapterId) --有任务副本去任务章节
    else
        self : requestChapterByChapId( 0)                --无任务副本去最新章节
    end

    --{单机}
    if _G.g_isOnline == false then
        _G.g_DuplicateDataProxy :setCurrentChapter( 11100 )
        _G.g_DuplicateDataProxy :setNextChapterIsGoing( 0 )
        _G.g_DuplicateDataProxy :setDuplicateCount( 2 )
        _G.g_DuplicateDataProxy :setDuplicateList( {{copy_id=20010,1},{copy_id=20010,1} } )
        local tempCommand = CDuplicateCommand()
        _G.controller :sendCommand( tempCommand )
    end

end

--布局
function CDuplicateView.layoutView( self )
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        local backgroundSize    = CCSizeMake( winSize.height/3*4, winSize.height)
        local buttonSize        = self.m_prevChapterButton : getPreferredSize()

        local chapternameSize   = self.m_chapterNameSprite :getPreferredSize()

        self.m_backgroundsecond :setPreferredSize( ccp(backgroundSize.width-30, backgroundSize.height*0.75))
        self.m_chapterNameSprite :setPreferredSize( ccp( chapternameSize.width*2, chapternameSize.height))
        self.m_evaAllSButton :setPreferredSize( ccp( buttonSize.width*1.5, buttonSize.height))
        self.m_backgroundsecond :setPosition( ccp( winSize.width/2, winSize.height/2+10))

        self.m_prevChapterButton :setPosition( ccp(  winSize.width/2+backgroundSize.width/2-buttonSize.width*3/2-40, buttonSize.height/2+20))
        self.m_nextChapterButton :setPosition( ccp(  winSize.width/2+backgroundSize.width/2-buttonSize.width/2-20, buttonSize.height/2+20))
        self.m_prevPageButton :setPosition( ccp(  winSize.width/2-backgroundSize.width/2+buttonSize.width/2+20, buttonSize.height+70))
        self.m_nextPageButton :setPosition( ccp(  winSize.width/2+backgroundSize.width/2-buttonSize.width/2-20, buttonSize.height+70))         
        self.m_pScrollView :setPosition(ccp( winSize.width/2-backgroundSize.width/2+25, buttonSize.height+80))
        self.m_chapterNameSprite :setPosition( ccp( winSize.width/2, winSize.height*0.8+10))
        self.m_chapterNameLabel :setPosition( ccp(  winSize.width/2, winSize.height*0.8+10))
        self.m_evaAllSButton :setPosition( ccp( winSize.width/2+300, winSize.height*0.8+10))
        self.m_pageCountSprite :setPosition( ccp( winSize.width/2, winSize.height*0.2))
        self.m_pageCountLabel :setPosition( ccp( winSize.width/2, winSize.height*0.2))
        self.m_specialContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+buttonSize.width/2+30, winSize.height*0.05+10))
    elseif winSize.height == 768 then
        CCLOG("768--副本界面")
    end
end

--初始化界面
function CDuplicateView.initView(self)
    --副本界面容器
    self.m_duplicateViewContainer = self :createContainer( "self.m_duplicateViewContainer 141")
    self.m_sceneContainer : addChild( self.m_duplicateViewContainer )

    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    self.m_backgroundsecond         = self :createSprite( "general_second_underframe.png", "self.m_backgroundsecond")
    self.m_prevChapterButton        = self :createButton( "上一章", "general_button_normal.png", CellCallBack, CDuplicateView.TAG_PREV_CHAPTER, "self.m_prevChapterButton")
    self.m_nextChapterButton        = self :createButton( "下一章", "general_button_normal.png", CellCallBack, CDuplicateView.TAG_NEXT_CHAPTER, "self.m_nextChapterButton")
    self.m_prevPageButton           = self :createButton( "", "copy_sign_arrow.png", CellCallBack, CDuplicateView.TAG_PREV_PAGE, "self.m_prevPageButton")
    self.m_nextPageButton           = self :createButton( "", "copy_sign_arrow.png", CellCallBack, CDuplicateView.TAG_NEXT_PAGE, "self.m_nextPageButton")
    self.m_evaAllSButton            = self :createButton( "全S评价奖励", "general_button_normal.png", CellCallBack, CDuplicateView.TAG_ALLSEVA, "self.m_evaAllSButton")
    self.m_chapterNameSprite        = self :createSprite( "copy_title_frame.png", "self.m_chapterNameSprite")
    self.m_chapterNameLabel         = self :createLabel( "章节名字")
    self.m_pageCountSprite          = self :createSprite( "general_pagination_underframe.png", "self.m_pageCountSprite")
    self.m_pageCountLabel           = self :createLabel( " ")

    self.m_prevPageButton : setVisible( false)
    self.m_nextPageButton : setVisible( false)

    self.m_prevPageButton : setRotation( 90)
    self.m_nextPageButton : setRotation( -90)

    -- self.m_prevChapterButton : setTouchesEnabled( false)
    -- self.m_nextChapterButton : setTouchesEnabled( false)

    self.m_duplicateViewContainer :addChild( self.m_backgroundsecond, -1)
    self.m_duplicateViewContainer :addChild( self.m_prevChapterButton )
    self.m_duplicateViewContainer :addChild( self.m_nextChapterButton )
    self.m_duplicateViewContainer :addChild( self.m_prevPageButton )
    self.m_duplicateViewContainer :addChild( self.m_nextPageButton )
    self.m_duplicateViewContainer :addChild( self.m_evaAllSButton)
    self.m_duplicateViewContainer :addChild( self.m_chapterNameSprite)
    self.m_duplicateViewContainer :addChild( self.m_chapterNameLabel)
    self.m_duplicateViewContainer :addChild( self.m_pageCountSprite)
    self.m_duplicateViewContainer :addChild( self.m_pageCountLabel)

    --英雄魔王label了&button
    self.m_specialContainer = CContainer :create()
    self.m_duplicateViewContainer :addChild( self.m_specialContainer)
    --副本关卡BOSS cell ScrollView 容器
    self.m_checkpointsContainer = CContainer :create()
    self.m_checkpointsContainer : setControlName( "this is CDuplicateView self.m_checkpointsContainer 131")
    self.m_duplicateViewContainer :addChild( self.m_checkpointsContainer )

    local viewSize = CDuplicateView.VIEW_SIZE
    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize )
    self.m_pScrollView :setControlName("this is CBarPanelView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CellCallBack, "this is CDuplicateView self.m_pScrollView CallBack")
    self.m_pScrollView :setTouchesPriority(1)
    self.m_duplicateViewContainer :addChild( self.m_pScrollView )
end

function CDuplicateView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

function CDuplicateView.showCheckPointView( self )
    print("showCheckPointView")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --释放资源
    ----[[
     if self.m_pScrollView ~= nil then
        print( "111zzzzzzzzzzzzzz",self.m_pScrollView :getPageCount())
        local tempnum = self.m_pScrollView :getPageCount()
        if tempnum >0 then
            for i=tempnum-1,0,-1 do
                print("self.m_pScrollView :removePageByIndex( i)",i)
                self.m_pScrollView :removePageByIndex( i)
            end
        end
     end

    if self.m_specialContainer ~= nil then
         self.m_specialContainer : removeAllChildrenWithCleanup(true)
     end

    local duplicatecount     = _G.g_DuplicateDataProxy : getDuplicateCount()          --副本数量
    local duplicatelist      = _G.g_DuplicateDataProxy : getDuplicateList()           --副本信息  copy_id  is_pass
    local chaptercopylist    = _G.g_DuplicateDataProxy : getChapterCopyList()
    local currentchaptername = _G.g_DuplicateDataProxy : getCurrentChapterName()
    local specialnumber      = _G.g_DuplicateDataProxy : getTimes()

    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( chaptercopylist:children():getCount("cid"), CDuplicateView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)

    ------------------------------------------------------------
    local function CellCallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    ------------------------------------------------------------
    if self.m_transferID == 101 then
        print("这是普通副本")
    elseif self.m_transferID == 102 then
            --英雄副本次数标签和购买按钮
            self.m_specialTimesLabel = self :createLabel( "精英副本剩余次数: "..specialnumber, ccc3( 255,255,0))
            local specialButton      = self :createButton( "购买次数", "general_button_normal.png", CellCallBack, CDuplicateView.TAG_HEROBUY, " 购买次数Button")
            self.m_specialTimesLabel :setPosition( ccp( 75, 0))
            self.m_specialTimesLabel :setAnchorPoint( ccp( 0, 0.5))
            self.m_specialContainer :addChild( specialButton, 1)
            self.m_specialContainer :addChild( self.m_specialTimesLabel)
    elseif self.m_transferID == 103 then
            self.m_specialTimesLabel         = self :createLabel( "魔王副本刷新次数: "..specialnumber, ccc3( 255,255,0))
            self.m_specialTimesLabel :setAnchorPoint( ccp( 0, 0.5))
            self.m_specialTimesLabel :setPosition( ccp( 75, 0))
            self.m_specialContainer :addChild( self.m_specialTimesLabel)
    end
    ---------------------------------------------------------------------------
    --关卡button和相关信息显示
    local viewSize             = CDuplicateView.VIEW_SIZE
    local checkpointImgSize    = CCSizeMake( viewSize.width/4, viewSize.height/2 )
    local checkpointCellSize   = CCSizeMake( (viewSize.width-10)/4, viewSize.height/2 )

    self.m_curentPageCount = 1
    self.m_copyContainerList = {}
    local checkpointcount = 0
    for i=1, self.m_pageCount do
        local pageLayer      = CContainer : create()
        pageLayer : setControlName( "this is CDuplicateView pageLayer 250")
        self.m_pScrollView : addPage( pageLayer )

        local horlayout = CHorizontalLayout :create()
        horlayout :setPosition( -viewSize.width/2+5, self.m_nextChapterButton:getPreferredSize().height + 45 )
        horlayout :setVerticalDirection( false )
        --horlayout :setCellHorizontalSpace( winSize.width * 0.07 )
        --horlayout :setCellVerticalSpace( viewSize.height * 0.12+10)
        horlayout :setLineNodeSum( 4 )
        horlayout :setCellSize( checkpointCellSize )
        pageLayer :addChild( horlayout )

        local tempnum = CDuplicateView.PER_PAGE_COUNT
        if i == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for j=1,tempnum do
            local copy_id = chaptercopylist:children():get(checkpointcount,"cid"):getAttribute("id")
            checkpointcount      = checkpointcount + 1
            print("zzzzzzzzzzzzzz",copy_id,j)
            local checkpont      = self :createCheckPoint( copy_id)
            self.m_copyContainerList[copy_id] = checkpont
            if  self.m_flagbool == true then
                self.m_flagbool = false
                print(i,"当前选中副本ID:",self.m_currentClickCopy)
                self.m_curentPageCount = i
            end
            horlayout :addChild( checkpont)
        end
    end
    --普通，英雄，魔王副本底部Label和button处理
    self.m_chapterNameLabel :setString( currentchaptername )
    self.m_pageCountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
    self.m_pScrollView :setPage( self.m_curentPageCount-1, false)
    self : setPageButtonState() --设置翻页按钮
    self : setChapterButtonState() --设置章节按钮
end


function CDuplicateView.getCopyInfoById( self, _copyid)
    local duplicatelist       = _G.g_DuplicateDataProxy : getDuplicateList()   --副本信息  copy_id  is_pass
    for k,v in pairs(duplicatelist) do
        print(k,(v.copy_id),(_copyid))
        if tonumber(_copyid) == v.copy_id then
            print( "XXXX:"..v.copy_id..v.is_pass)
            return v
        end
    end
    return nil
end

function CDuplicateView.getNewCopyId( self)
    local duplicatecount     = _G.g_DuplicateDataProxy : getDuplicateCount()
    local duplicatelist      = _G.g_DuplicateDataProxy : getDuplicateList()
    if duplicatecount > 0 then
        return duplicatelist[1].copy_id
    else
        return nil
    end
end


function CDuplicateView.findTaskCopy( self, _copyid)
    local duplicatelist       = _G.g_DuplicateDataProxy : getDuplicateList()   --副本信息  copy_id  is_pass
    for k,v in pairs(duplicatelist) do
        print(k,(v.copy_id),(_copyid))
        if tonumber(_copyid) == v.copy_id then
            return true
        end
    end
    return false
end

function CDuplicateView.getTaskStringByType( self, _type)
    local temp = nil
    if _type == _G.Constant.CONST_TASK_TRACE_MAIN_TASK then
        temp = "当前任务"
    elseif _type == _G.Constant.CONST_TASK_TRACE_DAILY_TASK then
        temp = "日常任务"
    elseif _type == _G.Constant.CONST_TASK_TRACE_MATERIAL then
        temp = "材料任务"
    else
        temp = "追踪任务类型出错"
    end
    return temp
end

--{创建关卡}
function CDuplicateView.createCheckPoint( self, _copyid)
    --local _copyid = tonumber(_copyid)
    local _checkpoint         = _G.g_DuplicateDataProxy : getDuplicateNameByCopyId( _copyid)
    local copyinfo            = self :getCopyInfoById( _copyid)

    local function CellCallBack( eventType, obj, x, y)
        return self :clickCheckPointCallBack( eventType, obj, x, y)
    end
    local checkpointcontainer = self :createContainer( " createCheckPoint checkpointcontainer:".._copyid)
    local _itempointbutotn    = self :createButton( "", "transparent.png", CellCallBack, _copyid, "_itempointbutotn".._copyid)
    local _itemnormalsprite   = self :createSprite( "copy_frame_normal"..tostring(self.m_transferID-100).."1.png", "_itemnormalsprite".._copyid) --添加常态背景
    local _itemtasksprite     = self :createSprite( "copy_frame_normal"..tostring(self.m_transferID-100).."2.png", "_itemtasksprite".._copyid)   --添加任务背景
    local _itemclickicon      = self :createSprite( "copy_frame_normal"..tostring(self.m_transferID-100).."3.png", "_itemclickicon".._copyid)     --添加选中效果框
    local _itembossBGicon     = nil
    if tonumber(_checkpoint:getAttribute("img")) ~= 0 then
        local temp = "DuplicateResources/fb_".._checkpoint:getAttribute("img")..".png"
        _itembossBGicon     = self :createSprite( temp, "_itembossBGicon".._copyid, true)        --添加Boss背景
    else
        local temp   = "copy_picture.png"
        _itembossBGicon     = self :createSprite( temp, "_itembossBGicon".._copyid)        --添加Boss背景
    end
    local _itembossheadicon   = nil
    if tonumber(_checkpoint:getAttribute("desc")) ~= 0 then
        local temp = "DuplicateResources/fb_".._checkpoint:getAttribute("desc")..".png"
        _itembossheadicon     = self :createSprite( temp, "_itembossheadicon".._copyid, true)        --添加Boss头像
    else
        local temp   = "transparent.png"
        _itembossheadicon     = self :createSprite( temp, "_itembossheadicon".._copyid)        --添加Boss头像
    end
    local _itemlockicon       = self :createSprite( "copy_close.png", " _itemlockicon".._copyid)           --添加未开启图片
    local _itemtaskbackground = self :createSprite( "copy_word_frame.png", " _itemtaskbackground".._copyid)  --副本类型标志背景
    local _itembossname       = self :createLabel( _checkpoint:getAttribute("copy_name")) --_checkpoint.copy_id            --添加BossName

    _itembossheadicon :setTag( CDuplicateView.BOSS_ICON_BG)
    _itembossBGicon :setTag( CDuplicateView.BOSS_ICON)
    _itemclickicon :setTag( CDuplicateView.CLICK_ICON)
    _itemnormalsprite :setTag( CDuplicateView.NORMAL_ICON)
    _itemlockicon :setTag( CDuplicateView.LOCK_ICON)

    _itemclickicon :setVisible( false)
    _itemlockicon :setVisible( false)
    _itemtasksprite :setVisible( false)
    _itemtaskbackground :setVisible( false)

    local _cellbuttonSize     = _itemnormalsprite :getPreferredSize()
    local _bossiconSize       = _itembossBGicon :getPreferredSize()
    local _taskbackgroundSize = _itemtaskbackground :getPreferredSize()
    _itempointbutotn :setPreferredSize( _cellbuttonSize)
    _itempointbutotn : setTouchesPriority( -1 )
    --------------------------------------------
    --SAB
    if copyinfo ~= nil then
        if copyinfo.eva ~= nil and copyinfo.eva ~= 0 then -- 0 未通关，没有评价
        local _itemevaSAB         = self :createSprite( "copy_word_sab_0"..copyinfo.eva..".png", "_itemevaSAB".._copyid)
        local _SABSize            = _itemevaSAB :getPreferredSize()
        _itemevaSAB :setPosition(ccp( _cellbuttonSize.width/2-_SABSize.width/2+10, -_cellbuttonSize.height/2+_SABSize.height/2))
        checkpointcontainer :addChild( _itemevaSAB, 1)
        end
    end
------------------------------------------
--设置为开启副本灰色
    if copyinfo == nil then --未开启副本不能点
        _itempointbutotn :setTouchesEnabled( false)
        _itemlockicon :setVisible( true)
        _itemnormalsprite :setGray( true)
        _itembossheadicon :setGray( true)
        _itembossBGicon :setGray( true)
    end
-------------------------------------------
--设置副本选中效果
    print("要去的副本 :", self.m_chapterId, self.m_taskCopyId, " 副本任务类型 type==", self.m_taskType)
    print( type(self.m_taskCopyId),type( _copyid))
    if self.m_taskCopyId ~= nil then --有任务副本时
        if self :findTaskCopy( self.m_taskCopyId) == true then
            print("有任务副本:",self.m_taskCopyId,"/",_copyid)
            if tonumber(_copyid) ==  tonumber(self.m_taskCopyId) then
                self.m_flagbool = true
                local _itemtaskTypeSprite = self :createSprite("copy_word_0"..self.m_taskType..".png", "_itemtaskTypeSprite".._copyid)
                self.m_itemtaskname       = self :createLabel( " ") --, ccc3( 255,0,0)             
                _itemtaskTypeSprite :setPosition( ccp( -_taskbackgroundSize.width/4,0))
                self.m_itemtaskname :setPosition( ccp(_taskbackgroundSize.width/4,0))
                _itemtaskbackground :addChild( _itemtaskTypeSprite)
                _itemtaskbackground :addChild( self.m_itemtaskname)
                self.m_itemtaskname :setString( self.m_haveCount.."/"..self.m_allCount)
                _itemtaskbackground :setVisible( true)
                print( "当前任务副本:"..self.m_taskCopyId)
                _itemtasksprite :setVisible( true)
                _itemclickicon :setVisible( true)
                _itemnormalsprite :setVisible( false)
                _itembossname :setColor(ccc3( 255, 255, 0))
                self.m_currentClickCopy = _copyid
            end
        else
            local tempcopyid = self :getNewCopyId()
            if tempcopyid ~= nil and tostring(tempcopyid) == _copyid then
                print( "最新副本ID:"..tempcopyid)
                --self.m_flagbool = true
                _itemclickicon :setVisible( true)
                self.m_currentClickCopy = _copyid
            end
        end
    else  --没有任务
        local tempcopyid = self :getNewCopyId()
        if tempcopyid ~= nil and tostring(tempcopyid) == _copyid then
            print( "最新副本ID:"..tempcopyid)
            --self.m_flagbool = true
            _itemclickicon :setVisible( true)
            self.m_currentClickCopy = _copyid
        end
    end
--------------------------------------------
    --_itemtaskbackground :setPreferredSize( CCSizeMake( _bossiconSize.width*0.6, _bossiconSize.height/2))
    --_itemtaskbackground :setPosition( ccp( 0, _cellbuttonSize.height/2 -_taskbackgroundSize.height/2-5))
    --_itemtaskname :setPosition( ccp( _cellbuttonSize.width/2-_bossiconSize.width*0.3-5, _cellbuttonSize.height/2 -_bossiconSize.height/2/2-5))
    if self.m_transferID == 101 then
        _itemtaskbackground :setPosition( ccp( 0, _cellbuttonSize.height/2 -_taskbackgroundSize.height/2-5))
        _itembossBGicon :setPosition( ccp(0, _cellbuttonSize.height/2-_bossiconSize.height/2-6))
        _itembossheadicon :setPosition( ccp(0, _cellbuttonSize.height/2-_bossiconSize.height/2-6))
    else
        _itemtaskbackground :setPosition( ccp( 5, _cellbuttonSize.height/2 -_taskbackgroundSize.height/2-25))
        _itembossBGicon :setPosition( ccp(5, _cellbuttonSize.height/2-_bossiconSize.height/2-26))
        _itembossheadicon :setPosition( ccp(5, _cellbuttonSize.height/2-_bossiconSize.height/2-26))
    end
    _itembossname :setPosition( ccp( 0, -_cellbuttonSize.height/2+CDuplicateView.FONT_SIZE/2+6))

---------------------------------------------------------------
--Tips Button显示判断条件 ，奖励SAB显示
    local buttonstate = {}
    --组队条件
    buttonstate.team  = tonumber(_checkpoint:getAttribute( "is_team")) --1可组队 0不可组队
    --挂机条件
    if copyinfo ~= nil then
        if self.m_roleLv >= tonumber(_checkpoint:getAttribute( "fast_lv")) and copyinfo.is_pass == 1 then
            buttonstate.hangup = tonumber(copyinfo.is_pass) --1可挂机 0不可挂机
        else
            buttonstate.hangup = 0
        end
        buttonstate.eva = copyinfo.eva
    else
        buttonstate.hangup = 0
        buttonstate.eva = 0
    end
    --SAB
    --刷新条件
    if self.m_transferID == 103 then --可进入次数为0
        if copyinfo ~= nil then
            print(  tonumber(copyinfo.times))
            if  tonumber(copyinfo.times) <= 0 then
                buttonstate.refresh = 1
            else
                buttonstate.refresh = 0
            end
        else
            buttonstate.refresh = 0
        end
    else
        buttonstate.refresh = 0
    end
    self.m_buttonstate[_copyid] = buttonstate
---------------------------------------------------------------
    print("XXXSSSSS: ".._copyid.."组队条件 ",buttonstate.team.." 挂机条件 "..buttonstate.hangup.." 刷新条件 "..buttonstate.refresh)
--设置该刷新副本灰色
    if buttonstate.refresh == 1 then
        _itemnormalsprite :setGray( true)
        _itembossheadicon :setGray( true)
        _itembossBGicon :setGray( true)
    end
---------------------------------------
    checkpointcontainer :addChild( _itempointbutotn)
    checkpointcontainer :addChild( _itemnormalsprite)
    checkpointcontainer :addChild( _itemtasksprite)
    checkpointcontainer :addChild( _itembossBGicon)
    checkpointcontainer :addChild( _itembossheadicon)
    checkpointcontainer :addChild( _itembossname)
    checkpointcontainer :addChild( _itemclickicon)
    checkpointcontainer :addChild( _itemlockicon)
    checkpointcontainer :addChild( _itemtaskbackground)
    --checkpointcontainer :addChild( _itemtaskname)
    return checkpointcontainer
end

--创建按钮Button
function CDuplicateView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CDuplicateView.createButton buttonname:",_string ,_controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string or " ", _image)
    _itembutton :setControlName( "this CDuplicateView ".._controlname)
    _itembutton :setFontSize( CDuplicateView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func ~= nil then
        _itembutton :registerControlScriptHandler( _func, "this CDuplicateView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建CSprite
function CDuplicateView.createSprite( self, _image, _controlname, _flag)
    print( "CDuplicateView.createSprite:".._image)
    local _itemsprite = nil
    if _flag == true then
        _itemsprite = CSprite :create( _image)
    else
        _itemsprite = CSprite :createWithSpriteFrameName( _image)
    end
    _itemsprite :setControlName( "this is CDuplicateView createSprite:".._controlname)
    return _itemsprite
end

--创建Label ，可带颜色
function CDuplicateView.createLabel( self, _string, _color)
    print("CDuplicateView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CDuplicateView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--创建CContainer
function CDuplicateView.createContainer( self, _controlname)
    print( "CDuplicateView.createContainer:".._controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( _controlname)
    return _itemcontainer
end

-- {更新界面}
function CDuplicateView.setLocalList( self )
    self : showCheckPointView()
    print("show showshow showshow showshow show")
end

--挂机改变任务次数信息
function CDuplicateView.setTaskNumber(self, _havecount, _allcount)
    if self.m_taskCopyId ~= nil then
        if self :findTaskCopy( self.m_taskCopyId) == true then
            self.m_haveCount = _havecount
            self.m_allCount  = _allcount
            self.m_itemtaskname :setString( self.m_haveCount.."/"..self.m_allCount)
        end
    end
end

function CDuplicateView.setBuyHeroTimes( self, _times)
    self.m_specialTimesLabel :setString( "精英副本剩余次数: ".._times, ccc3( 255,255,0)) --"魔王副本刷新次数: "..specialnumber, ccc3( 255,255,0)
end

 function CDuplicateView.setFiendTimes( self, _copyid, _times)
    self.m_buttonstate[tostring(_copyid)].refresh = 0 --Tips 取消刷新
    self.m_specialTimesLabel :setString( "魔王副本刷新次数: ".._times, ccc3( 255,255,0)) --"魔王副本刷新次数: "..specialnumber, ccc3( 255,255,0)
    self.m_copyContainerList[tostring(_copyid)] :getChildByTag( CDuplicateView.NORMAL_ICON) :setGray( false)
    self.m_copyContainerList[tostring(_copyid)] :getChildByTag( CDuplicateView.BOSS_ICON) :setGray( false)
    self.m_copyContainerList[tostring(_copyid)] :getChildByTag( CDuplicateView.BOSS_ICON_BG) :setGray( false) 
    
 end

--{进入关卡回调}
function CDuplicateView.clickCheckPointCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pDuplicatePromptView :reset()
        _G.pDuplicateAllSView  :reset()
        return obj :containsPoint( obj :convertToNodeSpaceAR( ccp( x, y)))
    elseif eventType == "TouchEnded" then
        self.m_copyContainerList[self.m_currentClickCopy] :getChildByTag( CDuplicateView.CLICK_ICON) :setVisible( false)
        local _copyid = tostring(obj :getTag())
        self.m_currentClickCopy = _copyid
        self.m_copyContainerList[self.m_currentClickCopy] :getChildByTag( CDuplicateView.CLICK_ICON) :setVisible( true)
        if _G.g_isOnline == true then
            local _position = {}
            _position.x = x
            _position.y = y
            self.m_duplicateViewContainer :addChild( _G.pDuplicatePromptView :layer( self.m_transferID, _copyid, self.m_buttonstate[_copyid], _position))
        else
            local scene_id = _G.StageXMLManager : getScenesIDByCopyID( _copyid )
            if scene_id ~= nil then
                _G.pStageMediator : gotoScene( scene_id, 100,200 )
            end
        end
    end
end

function CDuplicateView.setChapterButtonState( self)
    print("!!!!!11111 next:",_G.g_DuplicateDataProxy :getNextChapterIsGoing(),"prev:",_G.g_DuplicateDataProxy :getPrevChapter())
    -- if tonumber(_G.g_DuplicateDataProxy :getNextChapterIsGoing()) == 1 then
    --     self.m_nextChapterButton :setTouchesEnabled( true)
    -- else
    --     self.m_nextChapterButton :setTouchesEnabled( false)
    -- end
    if tonumber(_G.g_DuplicateDataProxy :getPrevChapter()) == 0 then  --上一章为0时上一章不可去
        self.m_prevChapterButton :setTouchesEnabled( false)
    else
        self.m_prevChapterButton :setTouchesEnabled( true)
    end
end
function CDuplicateView.setPageButtonState( self)
    print("cur:",self.m_curentPageCount,"all:",self.m_pageCount )
    if tonumber(self.m_curentPageCount) == 1 then
        self.m_prevPageButton :setVisible( false)
    else
        self.m_prevPageButton :setVisible( true)
    end
    if tonumber(self.m_curentPageCount) == tonumber(self.m_pageCount) then
        self.m_nextPageButton :setVisible( false)
    else
        self.m_nextPageButton :setVisible( true)
    end
end
-- {点击回调函数}
function CDuplicateView.clickCellCallBack( self, eventType, obj, _x, _y)
    print("clickCellCallBack->Id->",obj:getTag())
    if eventType == "TouchBegan" then
        --删除Tips
        _G.pDuplicatePromptView :reset()
        _G.pDuplicateAllSView  :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( _x, _y ) ) )
    elseif eventType == "PageScrolled" then
        local currentPage = _x+1
        print( "eventType",eventType, "当前页：",currentPage, "过去页：",self.m_curentPageCount)
        self.m_curentPageCount = currentPage
        self.m_pageCountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
        self :setPageButtonState()
    elseif eventType == "TouchEnded" then
        if obj :getTag() == CDuplicateView.TAG_CLOSED then
        elseif obj :getTag() == CDuplicateView.TAG_HEROBUY then
        --特殊按钮
            print( "英买雄购")
            local buytimes, freetimes = _G.g_DuplicateDataProxy :getBuyAndFreeTimes()
            --_G.Config :load("config/copy_times_pay.xml")
            local buycopy = _G.Config.copy_times_pays : selectSingleNode("copy_times_pay[@times="..tostring( buytimes+1).."]")
            local gold = nil
            if buycopy : isEmpty() then
                gold = 40
            else
                gold = buycopy : getAttribute("rmb") 
            end
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
                _G.g_DuplicateDataProxy :REQ_HERO_BUY_TIMES( 1 )
                if freetimes-1 < 0 then
                    freetimes = freetimes +1
                    buytimes = buytimes -1
                end
                _G.g_DuplicateDataProxy :setBuyAndFreeTimes( buytimes+1, freetimes-1)
            end
            local function func2()
                print("取消")
            end
            local BoxLayer = ErrorBox : create("精英副本可购买次数 "..buytimes.."/"..(freetimes+buytimes).." \n购买需要花费"..gold.."钻石，是否需要购买？",func1, func2)
            self.m_sceneContainer: addChild(BoxLayer,1000)
        elseif obj :getTag() == CDuplicateView.TAG_PREV_CHAPTER then
            --上一章
            print("上一章", _G.g_DuplicateDataProxy :getPrevChapter())
            self :requestChapterByChapId( _G.g_DuplicateDataProxy :getPrevChapter())
        elseif obj :getTag() == CDuplicateView.TAG_NEXT_CHAPTER then
            --下一章
            if _G.g_DuplicateDataProxy :getNextChapterIsGoing() == 1 then
                print("下一章",_G.g_DuplicateDataProxy :getNextChapter())
                self :requestChapterByChapId( _G.g_DuplicateDataProxy :getNextChapter())
            else
                print("下一章",_G.g_DuplicateDataProxy :getNextChapter(),"不可去")
               --CCMessageBox("下一章",_G.g_DuplicateDataProxy :getNextChapter().."不可去")
                local msg = "下一章开启需要当前章节所有副本全部开启且人物 ".._G.g_DuplicateDataProxy :getNextChapterOpenLv().." 级！"
                if self.m_transferID == 101 then
                    msg = "下一章开启需要当前章节所有副本全部开启！"
                end
                self : createMessageBox(msg)
            end
        elseif obj :getTag() == CDuplicateView.TAG_PREV_PAGE then  --上一页
            print("上一页")
            self.m_curentPageCount = self.m_curentPageCount - 1
            self.m_pageCountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
            self.m_pScrollView :setPage( self.m_curentPageCount-1, false)
            self :setPageButtonState()
        elseif obj :getTag() == CDuplicateView.TAG_NEXT_PAGE then  --下一页
            print("下一页")
            self.m_curentPageCount = self.m_curentPageCount + 1
            self.m_pageCountLabel :setString( self.m_curentPageCount.."/"..self.m_pageCount)
            self.m_pScrollView :setPage( self.m_curentPageCount-1, false)
            self :setPageButtonState()
        elseif obj :getTag() == CDuplicateView.TAG_ALLSEVA then
            --全S评价奖励
            local _position = {}
            _position.x = x
            _position.y = y
            self.m_duplicateViewContainer :addChild( _G.pDuplicateAllSView :layer( self.m_transferID))
        end
    end
end


--{请求当前章节}  _chapID  为 0
function CDuplicateView.requestChapterByChapId( self, _chapID )

    if self.m_transferID == 101     then
        _G.g_DuplicateDataProxy :REQ_COPY_REQUEST( _chapID )
    elseif self.m_transferID == 102 then
        _G.g_DuplicateDataProxy :REQ_HERO_REQUEST( _chapID )
    elseif self.m_transferID == 103 then
        _G.g_DuplicateDataProxy :REQ_FIEND_REQUEST( _chapID )
    end
    print(self.m_transferID, _chapID)
end



function CDuplicateView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_duplicateViewContainer : addChild(BoxLayer,1000)
end