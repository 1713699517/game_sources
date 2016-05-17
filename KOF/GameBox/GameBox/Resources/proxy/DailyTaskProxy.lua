--日常任务proxy
require "view/view"

require "controller/DailyTaskCommand"

CDailyTaskProxy = class( view, function( self )
    self.isInited = false

    self.m_dailyTaskData = {}

    self.m_bStart = false
    --设置任务追踪的副本id及 类型
    self.m_copyData      = {}
    --self.m_copyData.copy_id     = nil
    --self.m_copyData.copy_type   = nil
    self.m_nTurn    = 1
                        
    CCLOG("日常任务proxy注册")
end)

function CDailyTaskProxy.setTurn( self, _value )
    self.m_nTurn = _value
end

function CDailyTaskProxy.getTurn( self )
    return self.m_nTurn
end

function CDailyTaskProxy.setStartData( self, bValue )
    self.m_bStart = bValue
end

function CDailyTaskProxy.getStartData( self )
    return self.m_bStart
end

function CDailyTaskProxy.setInited( self, bValue )
    self.isInited = bValue
end

function CDailyTaskProxy.getInited( self )
    return self.isInited
end

function CDailyTaskProxy.setDailyTaskData( self, value )
    if self.m_dailyTaskData ==nil then
        self.m_dailyTaskData = {}
    end
    self.m_dailyTaskData = value

    if self :getStartData() == true then
        self :setDailyTaskInfo( value )
    end
end

function CDailyTaskProxy.getDailyTaskData( self )
    return self.m_dailyTaskData
end

function CDailyTaskProxy.setTrackCopyData( self, value)
    if self.m_copyData==nil then
        self.m_copyData = {}
    end
    self.m_copyData = value
end

--获取追踪副本的信息
function CDailyTaskProxy.getTrackCopyData( self)
    return self.m_copyData
end

function CDailyTaskProxy.getSceneCopys( self, _copyid)
    local copy_id = tostring( _copyid)

    _G.Config:load( "config/scene_copy.xml")

    local sceneCopys = _G.Config.scene_copys :selectSingleNode( "scene_copy[@copy_id="..copy_id.."]")
    return sceneCopys
end

function CDailyTaskProxy.setDailyTaskInfo( self, _dailyData )
    if _dailyData ~= nil then
        _G.Config :load( "config/task_daily.xml")

        local dailyNode = _G.Config.task_dailys :selectSingleNode( "task_daily[@node="..tostring( _dailyData.node ).."]" )

        local _copyId = nil
        if dailyNode :isEmpty() == false  then
            _copyId = dailyNode:getAttribute("copys_id")
        end

        local roleProperty = _G.g_characterProperty : getMainPlay()
        if roleProperty ~= nil and _copyId ~= nil then
            --得到副本所在章节id
            local sceneCopysNode = _G.pCDailyTaskProxy :getSceneCopys( _copyId )
            --print( "sceneCopysNode :isEmpty()", sceneCopysNode :isEmpty() )
            if sceneCopysNode :isEmpty() == true then
                return
            end
            roleProperty :setTaskInfo( _G.Constant.CONST_TASK_TRACE_DAILY_TASK, tonumber( _copyId ),
                tonumber( sceneCopysNode :getAttribute("belong_id") ), _dailyData.value or "", dailyNode:getAttribute("value") or "")
        end
    end
end
 
--读取 xml 新方法0
function CDailyTaskProxy.getDailyTaskInfo( self, _node )
    if _node ~= nil then
        _G.Config : load( "config/task_daily.xml" )
        print( "\n日常xml", _G.Config.task_dailys, _node )

        local str = "task_daily[@node=" .. tostring( _node ).. "]"
        local _dailyInfo = _G.Config.task_dailys : selectSingleNode( str )
        print("_dailyInfo  ", _dailyInfo )
        return _dailyInfo
    end
end

--注册mediator
_G.pCDailyTaskProxy = CDailyTaskProxy()
--[[
if _G.pCDailyProxyMediator~=nil then
    controller :unregisterMediator( _G.pCDailyProxyMediator)
    _G.pCDailyProxyMediator = nil
end

_G.pCDailyProxyMediator = CDailyProxyMediator( _G.pCDailyTaskProxy)
controller :registerMediator( _G.pCDailyProxyMediator)
--]]