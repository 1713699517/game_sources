require "view/Character/BaseCharacter"
require "view/view"
require "view/TaskUI/TaskDialogView"
require "common/ColorManager"

CNpc = class(CBaseCharacter, function( self, _nType )
    if( _nType == nil ) then
        error( "CNpc _nType == nil" )
        return
    end
    self.m_nType = _nType --人物／npc
    self.m_isIcon = false  --默认false， 无icon
end)

function CNpc.npcInit( self, npcId , npcName, npcPx , npcPy , npcSkin )
    self.m_bRoleEnter = false     --玩家是否进入
    self.m_nRoleEnterRadius = 50 --玩家进入半径范围
    self : init( npcId,
            npcName,
            nil,
            nil,
            nil,
            nil,
            npcPx,
            npcPy,
            npcSkin)

    local color = _G.g_ColorManager : getRGB(_G.Constant.CONST_COLOR_GREEN)
    self : setColor( color )
    --增加icon 容器
    self.m_iconContainer = CContainer : create()
    self.m_iconContainer : setControlName( "this is CNpc self.m_iconContainer 27")
    self.m_iconContainer : setPositionY ( npcPy - 40 )
    self.m_lpContainer : addChild ( self.m_iconContainer )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile("taskInfo/taskResources.plist")

    local function clickNpcFun ( eventType, arg0, arg1, arg2, arg3 )
        --eventType, obj, x, y
        self : animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        return self : onClickNpcFun (eventType, arg0, arg1, arg2 )
    end

    --增加点击npc事件
    --self.m_lpMovieClip : setFullScreenTouchEnabled ( false )
    if self.m_lpMovieClip then
        self.m_lpMovieClip : setTouchesPriority( -26 )
        self.m_lpMovieClip : setTouchesEnabled (true)
        self.m_lpMovieClip : registerControlScriptHandler ( clickNpcFun, "this CNpc self.m_lpMovieClip 38"..self:getName())
    end

    self :setNpcStateIconByNpcId( tonumber( npcId ) )
end

function CNpc.setNpcStateIconByNpcId( self, _npcId )
    print( "_npcId_npcId", _npcId )
    if _npcId == nil then
        --CCMessageBox( "_npcId为nil", _npcId )
        CCLOG("codeError!!!!  _npcId为nil ".._npcId )
        return
    end

    if type( _npcId ) ~= "number" then
        _npcId = tonumber( _npcId )
    end

    --初始化npc头上的图标
    if _G.g_CTaskNewDataProxy :getInitialized() == true then
        local taskData  = _G.g_CTaskNewDataProxy : getTaskDataList()

        if taskData ~= nil then
            for key, data in pairs( taskData ) do
                local taskNode = _G.g_CTaskNewDataProxy :getTaskDataById( data.id )

                if taskNode ~= nil then
                    taskBeginNpc = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "s", "npc" ) )
                    taskEndNpc   = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "e", "npc" ) )

                    --如果开始npc和结束npc相同
                    if taskBeginNpc == taskEndNpc and taskBeginNpc == _npcId then
                        self :setIcon( tonumber( data.state ) )
                        break
                    end

                    --如果开始npc和结束npc不相同
                    if taskBeginNpc ~= taskEndNpc then
                        if data.state > 0 and data.state <= 3 then
                            if taskBeginNpc == _npcId then
                                self :setIcon( tonumber( data.state ) )
                                break
                            end

                        elseif data.state > 3 then
                            if taskEndNpc == _npcId then
                                self :setIcon( tonumber( data.state ) )
                                break
                            end
                        end
                    end
                end
                --print("getTaskDataList", key, data.id, data.state, data.target_type, taskNode )
            end
        end
    end
end

_G.g_ClickNpc = false

--点击 npc 函数
function CNpc.onClickNpcFun (self , eventType, obj, x, y )
    if eventType == "TouchBegan" then
        --return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        local collider = self : getCollider()
        local npcAR = obj:convertToWorldSpaceAR( ccp(0, 0) )
        if collider == nil then
            return
        end
        local npcAR_X = npcAR.x +collider.offsetX
        local npcAR_Y = npcAR.y +collider.offsetZ
        local tmpRect = CCRectMake( npcAR_X, npcAR_Y,
           collider.vWidth,
           collider.vHeight )
        local bTouched = tmpRect:containsPoint( ccp(x,y) )
        if( bTouched ) then --点击了,记录当前操作的npcID
            CNpc.s_id         = self.m_nID
            self.m_bRoleEnter = false
            _G.g_ClickNpc     = true
        end

    elseif eventType == "Enter" then
        local status = self : getStatus()
        self.m_nStatus = -100
        self : setStatus( status )
        --return true
    elseif eventType == "TouchEnded" then

    end
end

function CNpc.getNpcEnterId( self )
    return self.s_id
end

--设置npc进入id
function CNpc.setNpcEnterId( self, _id )
    CNpc.s_id = _id
end

function CNpc.getIconState( self)
    return self.m_isIcon
end

--增加npc任务icon
function CNpc.setIcon(self , iconType)
    if self.m_iconContainer then    --清除容器
        self.m_iconContainer : removeFromParentAndCleanup( true)
        self.m_iconContainer = nil
    end
    self.m_isIcon = false
    if (self == nil) or iconType == nil then
        --print("self 不能为空", iconType)
        return
    end
    local nY = self :getLocationY()
    print("nny", nY)
    --增加icon 容器
    self.m_iconContainer = CContainer : create()
    self.m_iconContainer : setControlName( "this is CNpc self.m_iconContainer 27")
    self.m_iconContainer : setPositionY ( 240 )
    self.m_lpContainer : addChild ( self.m_iconContainer )


    print("图标iconType:",iconType, self.m_nID)
    local icon = nil
    if iconType == _G.Constant.CONST_TASK_STATE_INACTIVE then           -- 任务状态-未激活 (0)   红色问号
        icon = CSprite : createWithSpriteFrameName("task_red_question_mark.png")
    elseif iconType == _G.Constant.CONST_TASK_STATE_ACTIVATE then       -- 任务状态-已激活 (1)
        icon = CSprite : createWithSpriteFrameName("task_red_question_mark.png")

    elseif iconType == _G.Constant.CONST_TASK_STATE_ACCEPTABLE then     -- 任务状态-可接受 (2)   黄色
        icon = CSprite : createWithSpriteFrameName("task_yellow_exclamation_mark.png")--

    elseif iconType == _G.Constant.CONST_TASK_STATE_UNFINISHED then     -- 任务状态-接受未完成 (3)
        icon = CSprite : createWithSpriteFrameName("task_green_question_mark.png")--("task_red_question_mark.png")

    elseif iconType == _G.Constant.CONST_TASK_STATE_FINISHED then       -- 任务状态-完成未提交 (4)
        icon = CSprite : createWithSpriteFrameName("task_green_exclamation_mark.png")

    elseif iconType == _G.Constant.CONST_TASK_STATE_SUBMIT then         -- 任务状态-已提交 (5)
        icon = nil --CSprite : createWithSpriteFrameName("task_red_question_mark.png")

    end

    if icon ~= nil then -- 如果有对应的图标
        self.m_iconContainer :addChild( icon )
        self.m_isIcon = true
    else
        if self.m_iconContainer ~= nil then    --清除容器
            self.m_iconContainer :removeFromParentAndCleanup( true )
            self.m_iconContainer = nil
        end
    end


end

function CNpc.onRoleEnter( self, _fRoleX, _fRoleY )
    --CCLOG("进入npc onRoleEnter..........")
    --玩家进入范围
    if self.m_bRoleEnter == true or CNpc.s_id ~= self.m_nID then
        return
    end

    local distance = ccpDistance( ccp( self:getLocationXY() ), ccp( _fRoleX, _fRoleY ) )

    if distance > self.m_nRoleEnterRadius  then
        return
    end

    self.m_bRoleEnter = true
    CNpc.s_id = nil

    if _G.g_dialogView ~= nil then
        _G.g_dialogView :closeWindow()
        _G.g_dialogView = nil
    end

    --打开界面
    _G.g_dialogView = CTaskDialogView( self.m_nID, 20 )
    _G.tmpMainUi : addChild ( _G.g_dialogView :scene() )

end

function CNpc.onRoleExit( self, _fRoleX, _fRoleY )
    --玩家离开范围
    _G.g_ClickNpc = false
    if self.m_bRoleEnter == false then
        return
    end

    local distance = ccpDistance( ccp( self:getLocationXY() ), ccp( _fRoleX, _fRoleY ) )
    if distance <= self.m_nRoleEnterRadius  then
        return
    end

    self.m_bRoleEnter = false
    --设置选中的npc为空
    if CNpc.s_id == self.m_nID then
        CNpc.s_id = nil
    end

end





















