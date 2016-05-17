require "view/view"
require "mediator/mediator"
require "controller/NpcCommand"

CTaskNewDataProxy = class( view, function( self )
	self.m_bInitialized 		= false		--默认未初始化
    self : load()
	print("CTaskNewDataProxy")
	self.m_taskDataList			= {}		--任务数据

	self.m_taskMonsterDetailList= {}		--怪物信息块

	self.m_taskDramaList		= {}		--剧情id

	self.m_mainTask				= nil		--主线id

    self.m_copyList             = {}        --当target_type = 7时 副本数据

    --0911 add
    --切换寻路的数据
    self.m_autoList         = nil       --为nil时不寻路，
end)



--当target_type = 7时 副本数据
function CTaskNewDataProxy.setCopyList( self, _value)
    print("setCopyList().current", _value.current)
   self.m_copyList = _value
end

function CTaskNewDataProxy.getCopyList( self)
   return self.m_copyList
end


function CTaskNewDataProxy.setInitialized( self, _value )
	self.m_bInitialized = _value
	print("CTask set b==", self.m_bInitialized)
end

function CTaskNewDataProxy.getInitialized( self )
	print("CTask get b==", self.m_bInitialized)
	return self.m_bInitialized
end

function CTaskNewDataProxy.removeTaskByData( self, _removeData)
    if _removeData == nil or self.m_taskDataList == nil then
        return
    end

    for lKey, lValue in pairs( _removeData ) do
        for rKey, rValue in pairs( self.m_taskDataList) do
            if tonumber( rKey) == lValue then
                --table.remove( self.m_taskDataList, rKey )
                self.m_taskDataList[rKey] = nil
            end
        end

        if self.m_mainTask ~= nil then
            if self.m_mainTask.id == lValue then
                self : cleanMainTask()
            end
        end
    end

    if self :getInitialized() then
        local guiderTask = self :getMainTask()
        
        if guiderTask == nil then
            local testData = self :getTaskDataList()
            
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
            self :setMainTask( testData[1] )
            
            guiderTask = self :getMainTask()
        end
        
    end
    

end

end

function CTaskNewDataProxy.cleanAllTask( self )
    if self.m_taskDataList ~= nil then
        table.remove( self.m_taskDataList )
        self.m_taskDataList = nil
    end
end

--任务数据
function CTaskNewDataProxy.setTaskDataList( self, _value )
	--self.m_taskDataList = _value
    if _value == nil then
        return
    end

    --更新npc图标
    local command = CNpcUpdateCommand( _value )
    _G.controller :sendCommand( command )

    if self.m_taskDataList == nil then
        self.m_taskDataList = {}
    end
    local vo = self.m_taskDataList[ _value.id]
    print("CTaskNewDataProxy.setTaskDataList", _value.id, _value.state, _value.current)
    if vo == nil or vo.state ~= _value.state or vo.target_type ~= _value.target_type or vo.current ~= _value.current then
        print("CTaskNewDataProxy.setTaskDataList", _value.id, _value.state, _value.current)
        self.m_taskDataList[ _value.id] = _value
    end

end

function CTaskNewDataProxy.getTaskDataList( self )
    local tempList = nil
    if self.m_taskDataList ~= nil then
        tempList        = {}
        local nCount    = 1

        if tempList ~= nil then
            print( "还有几个任务1－－》", #tempList )
        end
        
        for k, v in pairs( self.m_taskDataList) do
            tempList[nCount] = {}
            tempList[nCount].id             = v.id
            tempList[nCount].state          = v.state
            tempList[nCount].target_type    = v.target_type

            tempList[nCount].copy           = v.copy
            tempList[nCount].current        = v.current
            tempList[nCount].max            = v.max

            tempList[nCount].monster_count  = v.monster_count
            tempList[nCount].monster_detail = v.monster_detail
            tempList[nCount].type           = 0

            local taskNode = self :getTaskDataById( tempList[nCount].id )

            if taskNode ~= nil and not taskNode :isEmpty() then
                tempList[nCount].type       = tonumber( taskNode :getAttribute( "type") )
            else --说明找不到该任务，所以移除掉该任务 2013.12.16日添加
                table.remove( tempList, nCount )
                print( "移除任务了1－->", nCount )
                nCount = nCount - 1
                print( "移除任务了2－->", nCount )
            end
            --print("tempList[nCount].type", tempList[nCount].type )
            nCount = nCount + 1
        end
        
        if tempList ~= nil then
            print( "还有几个任务2－－》", #tempList )
        end
    end

    self : sortTaskData( tempList )

	return tempList
end

--{对数据进行排序    主线 > 支线 > id}
function CTaskNewDataProxy.sortTaskData( self, _data )
    if _data ~= nil then
        local func = function( lValue, rValue )
            if lValue.type < rValue.type then
                return true

            elseif lValue.type == rValue.type then
                if lValue.id < rValue.id then
                    return true
                else
                    return false
                end

            elseif lValue.type > rValue.type then
                return false
            end
        end
        table.sort( _data, func )
    end

end

--怪物信息块
function CTaskNewDataProxy.setTaskMonsterDetailList( self, _value )
	self.m_taskMonsterDetailList = _value
end

function CTaskNewDataProxy.getTaskMonsterDetailList( self )
	return self.m_taskMonsterDetailList
end

--剧情id
function CTaskNewDataProxy.setTaskDramaList( self, _value )
	self.m_taskDramaList = _value
end

function CTaskNewDataProxy.getTaskDramaList( self )
	return self.m_taskDramaList
end

function CTaskNewDataProxy.load( self)
    _G.Config:load("config/tasks.xml")

    _G.Config:load("config/scene.xml")

    _G.Config:load("config/scene_npc.xml")

    _G.Config:load("config/scene_copy.xml")

end
--------------------------淫荡的分割线-----------------------
--------------------------scene_npc.xml--------------------
function CTaskNewDataProxy.getNpcNodeById( self, _npcId)
    --print("_npcId==", _npcId)
    if _npcId == nil then
        return
    end
    _G.Config:load("config/scene_npc.xml")

    local str = "scene_npc[@id=" .. tostring( _npcId ) .. "]"
    CCLOG( "scene_npcXml 拼接 -- %s", str )
    local npcNode = _G.Config.scene_npcs :selectSingleNode( str )
    if not npcNode :isEmpty() then
        return npcNode
    end
    
    return nil
end

--npcNode.funs[1].fun[1].id
function CTaskNewDataProxy.getFunAttribute( self, _node, _selectName )
    if not _node :isEmpty() then
        local _funsNode = _node :children() :get( 0, "funs" )
        if _funsNode :isEmpty() == false and _funsNode :children() :getCount() > 0 then
            local _count = _funsNode :children() :getCount()
            local _funNode = _funsNode :children() :get( 0, "fun" )
            if not _funNode :isEmpty() and _count > 0 then
                local retData = _funNode :getAttribute( tostring( _selectName ) )
                print("返回@@" .. _selectName .." ＝＝", retData )
                return retData
            end
        end
    end
    
    return nil
end

--------------------------淫荡的分割线-----------------------
--------------------------scene_copy.xml-------------------
function CTaskNewDataProxy.getScenesCopysNodeByCopyId( self, _copyId )
    if _copyId == nil then
        return nil
    end
    CCLOG("副本idid" .. _copyId )
    
    _G.Config : load( "config/scene_copy.xml" )
    
    local str = "scene_copy[@copy_id=" .. _copyId .. "]"
    CCLOG("scene_copyXml 拼接 --%s ", str )
    local node = _G.Config.scene_copys :selectSingleNode( str )
    if not node :isEmpty() then
        return node
    end
    return nil
end

--通过id读取 task.xml数据  返回读取的节点
function CTaskNewDataProxy.getTaskDataById( self, _value )
    CCLOG("_value==".._value)
    if _value == nil then
        return nil
    end

    _G.Config : load( "config/tasks.xml" )
    
    local str = "task[@id="..tostring(_value).."]"
    local node = _G.Config.tasks :selectSingleNode( str )
    CCLOG("拼接字段[任务]－－>%s", str)
    print( node :isEmpty() )
    if node :isEmpty() == true then
       --CCMessageBox("该任务id无法在xml表中查到", _value)
        CCLOG("codeError!!!! 该任务id无法在xml表中查到")
        return nil
    end
    return node
end

--返回 <task> 的数据
function CTaskNewDataProxy.getTaskAttribute( self, _node, _szName )
    local retData = nil
    if _node ~= nil then
        retData = _node :getAttribute( _szName )
    end
    return retData
end

--返回 <target_num> 的数据
function CTaskNewDataProxy.getTargetAttribute( self, _node, _szName, _target_type )
    local retData = nil
    if _node ~= nil then
        local _targetNode = _node :children() :get( 0, "target_" .. tostring( _target_type ) )
        if not _targetNode : isEmpty() then
            retData = tonumber( _targetNode :getAttribute( _szName )  )
        end
    end
    return retData
end

--返回 <target_6> 的数据
function CTaskNewDataProxy.getTarget6Attribute( self, _node, _szName )
    local retData = nil
    if _node ~= nil then
        local _targetNode = _node :children() :get( 0, "target_6" )
        if not _targetNode : isEmpty() then
            retData = tonumber( _targetNode :getAttribute( _szName )  )
        end
    end
    return retData
end


--返回 <npc> 的数据
function CTaskNewDataProxy.getNpcAttribute( self, _node, _S_or_E, _szName )
    local retData = nil
    if _node ~= nil then
        local _npcNode = _node :children() :get( 0, "npc" )
        if not _npcNode :isEmpty() then
            local _tempNode = _npcNode :children() :get( 0, _S_or_E )
            if not _tempNode :isEmpty() then
                retData = _tempNode :getAttribute( _szName )
            end
        end
    end
    self :printf("npc-->", retData)
    return retData
end

--返回 <dialog> 的数据
function CTaskNewDataProxy.getDialogAttribute( self, _node, _szName )
    local retData = nil
    if _node ~= nil then
        if not _node :isEmpty() and _node :children() :getCount() > 0 then
            local _dialogNode = _node :children() :get( 0, "dialog" )
            if not _dialogNode :isEmpty() then
                retData = _dialogNode :getAttribute( _szName )
            end
        end
    end
    self :printf("dialog-->", retData )
    return retData
end

--返回 <dialog-er> 的数据
function CTaskNewDataProxy.getDialogErAttribute( self, _node, _szName )
    local retData = nil
    if _node ~= nil then
        if not _node :isEmpty() and _node :children() :getCount() > 0 then
            local _dialogNode = _node :children() :get( 0, "dialog" )
            --print("sdfsdfs", _dialogNode :isEmpty() )
            if not _dialogNode :isEmpty() and _dialogNode :children() :getCount() > 0 then
                local _ersNode = _dialogNode :children() :get( 0, "ers" )
                --print("ddddd", _ersNode :isEmpty() )
                if not _ersNode :isEmpty() and _ersNode :children() :getCount() > 0 then
                    local _erNode = _ersNode :children() :get( 0, "er" )
                    if not _erNode :isEmpty() then
                        return _erNode :getAttribute( _szName )
                    end
                end
            end
        end
    end
    self :printf("dialog-er-->", retData)
    return retData
end

--返回 <tip> 的数据
function CTaskNewDataProxy.getTipAttribute( self, _node, _szName )
    local retData = nil
    if _node ~= nil then
        if not _node :isEmpty() and _node :children() :getCount() > 0 then
            local _tipNode = _node :children() :get( 0, "tip" )
            if not _tipNode :isEmpty() then
                retData = _tipNode :getAttribute( _szName )
            end
        end
    end
    self :printf( "tip --> ", retData )
    return retData
end

--返回 <goods> 的数据
function CTaskNewDataProxy.getGoodsAttribute( self, _node, _pos, _szName)
    local retData = nil
    if _node ~= nil then
        if not _node :isEmpty() and _node :children() :getCount() > 0 then
            local _dialogNode = _node :children() :get( 0, "goods" )
            if not _dialogNode :isEmpty() and _dialogNode :children() :getCount() >0 then
                local _goodNode = _dialogNode :children() :get( _pos, "good" )
                if not _goodNode :isEmpty() then
                    retData = _goodNode :getAttribute( _szName )
                end
            end
        end
    end
    self :printf("taskGoods-->", retData )
    return retData
end

-- goods.xml 表数据,返回物品图标
function CTaskNewDataProxy.getGoodsXmlIcon( self, _szGoodsId )
    local retData = nil 
    if _szGoodsId ~= nil then
        _G.Config :load( "config/goods.xml" )
        
        local str = "goods[@id=" .. tostring( _szGoodsId ) .. "]"
        local goodsNode = _G.Config.goodss :selectSingleNode( str )
        
        if not goodsNode :isEmpty() then
            retData = goodsNode :getAttribute( "icon" )
        end
    else
        
        CCLOG("CTaskNewDataProxy.getGoodsXmlIcon 怎么回事,弄个空表")
    end
    self :printf( "goodss拿iconid", retData )
    return retData
end

function CTaskNewDataProxy.printf( self, _szType, _szContent )
    print( "\n [", _szType, "] ==== [", _szContent or"空的", "]" )
end

function CTaskNewDataProxy.cleanMainTask( self )
    if self.m_mainTask ~= nil then
        table.remove( self.m_mainTask )
        self.m_mainTask = nil
    end
end

--保存接任务的那个id跟状态
function CTaskNewDataProxy.setNowTaskEffectsData( self,_TaskId,_TaskState)
    print("保存一下发送过了的任务数据",_TaskId,_TaskState)
    self.NowTaskEffects_TaskId    = tonumber(_TaskId) 
    self.NowTaskEffects_TaskState = tonumber(_TaskState)    
end
function CTaskNewDataProxy.getNowTaskEffects_TaskId( self)
    return self.NowTaskEffects_TaskId    
end
function CTaskNewDataProxy.getNowTaskEffects_TaskState( self)
    return self.NowTaskEffects_TaskState    
end


function CTaskNewDataProxy.TaskEffectsCommandSend(self,value)
    require "controller/TaskEffectsCommand"
    local TaskEffectsCommand = CTaskEffectsCommand(value) -- 1是接受任务 2是完成任务
    controller:sendCommand(TaskEffectsCommand)
end

function CTaskNewDataProxy.isTaskEffectsOkToCreate(self,_Task)
    print("任务特效判断===",_Task.id,self : getNowTaskEffects_TaskId())
    local nowTaskId    = self : getNowTaskEffects_TaskId()
    local nowTaskState = self : getNowTaskEffects_TaskState()
    if nowTaskId ~= nil and nowTaskState ~= nil and  nowTaskId  == tonumber(_Task.id) and nowTaskState == _G.Constant.CONST_TASK_STATE_ACCEPTABLE  then
        if tonumber(_Task.state) == _G.Constant.CONST_TASK_STATE_UNFINISHED then --接受未完成
            self : TaskEffectsCommandSend (1)
            self : setNowTaskEffectsData(0,0)
        end
    end
end

--设置主线追踪任务
function CTaskNewDataProxy.setMainTask( self, _value )
    if _value == nil then
        return
    end

    self :cleanMainTask()

    self : isTaskEffectsOkToCreate(_value) --任务特效判断

     print( "当前追踪任务id==", _value.id, _value.state )
     local ccc = self :getTaskDataById( _value.id )
     if ccc == nil then
         print("tasks 表里没找到这个数据-->", _value.id)
         return
     end

     if self.m_mainTask == nil then
         self.m_mainTask = {}
     end

     self.m_mainTask.id             = _value.id
     self.m_mainTask.target_type    = _value.target_type
     self.m_mainTask.state          = _value.state
    
    local test = ccc :children()
    local ncount = test :getCount()
    local data = test :get( 0, "npc")
    local dataChildren = data :children()
    local ss = dataChildren :get( 0, "s" )
    --local sScene = ss :getAttribute("scene")
    local sScene = self :getNpcAttribute( ccc, "s", "scene" )
    -------------
    local dChildren = data :children()
    print( "typeee3" , type( test ), ncount, type( ncount ), data, sScene )
    -------------
    
    self.m_mainTask.beginNpc       = tonumber( self :getNpcAttribute( ccc, "s", "npc" ) )
    self.m_mainTask.endNpc         = tonumber( self :getNpcAttribute( ccc, "e", "npc" ) )
    self.m_mainTask.beginNpcScene  = tonumber( self :getNpcAttribute( ccc, "s", "scene" ) )   --开始npc的场景
    self.m_mainTask.endNpcScene    = tonumber( self :getNpcAttribute( ccc, "e", "scene" ) )   --结束npc的场景
    self.m_mainTask.type           = tonumber( ccc :getAttribute( "npc" ) )
    self.m_mainTask.target_id      = nil

    if self.m_mainTask.target_type == 7 then
        self.m_mainTask.copy_id    = tonumber( self :getTargetAttribute( ccc, "copy_id", 7 ) )
        --print("self.m_mainTask.copy_id", self.m_mainTask.copy_id)
        self.m_mainTask.current    = _value.current
        self.m_mainTask.max        = _value.max
        --设置要去的副本类型
        if self.m_mainTask.copy_id then
            local roleProperty = _G.g_characterProperty : getMainPlay()
            local sceneCopys = nil
            --_G.Config.scene_copys :( "scene_copy", "copy_id", tostring( self.m_mainTask.copy_id))
            local sceneCopyNode = self :getScenesCopysNodeByCopyId( tostring( self.m_mainTask.copy_id ) )
            if not sceneCopyNode :isEmpty() then
                sceneCopys = sceneCopyNode :getAttribute( "belong_id" )
            end
            
            if sceneCopys == nil then
                CCLOG("codeError!!!! 查询scene_copys.xml表配置")
            end
            
            local _chapId = sceneCopys or 0
            roleProperty :setTaskInfo( 1, self.m_mainTask.copy_id, tonumber(_chapId), self.m_mainTask.current or "", self.m_mainTask.max or "")
            print(" _value.current", _value.current, _value.max, self.m_mainTask.copy_id, sceneCopys )
        else
            --CCMessageBox("主线任务id为nil", self.m_mainTask.copy_id)
            CCLOG("codeError!!!! 主线任务id为nil")
        end
    elseif self.m_mainTask.target_type == 6 then
        local _target_id = self :getTargetAttribute( ccc, "id", 6 )
        if _target_id ~= nil then
            self.m_mainTask.target_id    = tonumber( _target_id )
        end
        self.m_mainTask.copy_id    = nil
    else
        self.m_mainTask.copy_id    = nil
    end

    
    local updateBtnCommand = CTaskDataUpdataCommand( CTaskDataUpdataCommand.UPDATEGUIDER )
    controller :sendCommand( updateBtnCommand )
    --print("主线id==", self.m_mainTask.id, self.m_mainTask.beginNpc)
end

function CTaskNewDataProxy.getMainTask( self )
	return self.m_mainTask
end

function CTaskNewDataProxy.getSceneNode( self, _scene_id )
    local str = "scene[@scene_id=" .. tostring( _scene_id ) .."]"
    local sceneNode = _G.Config.scenes : selectSingleNode( str )
    return sceneNode
end

function CTaskNewDataProxy.getSceneNpcCount( self, _node )
    local retData = nil
    
    if not _node :isEmpty() then
        local _npcsNode = _node :children() :get( 0, "npcs" )
        retData = _npcsNode :children() :getCount()
    end
    return retData
end

function CTaskNewDataProxy.playMusicByName( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end

--得到scenes表 npcs-npc 的数据 
function CTaskNewDataProxy.getSceneNpcsData( self, _node, _pos, _valueName )
    local retData = nil 
    
    if not _node :isEmpty() then
        local _npcsNode = _node :children() :get( 0, "npcs" )
        if not _npcsNode :isEmpty() and _npcsNode :children() :getCount() > 0 then
            local _npcNode = _npcsNode :children() :get( _pos, "npc" )
            if not _npcNode :isEmpty() then
                retData = _npcNode :getAttribute( tostring( _valueName or "" ) )
            end
        end
    end
    return retData
end

--通过 npcId 和场景id 得到npc的位置nPos
function CTaskNewDataProxy.getNpcPos( self, _npcId, _sceneId)
    if _sceneId == nil or _npcId == nil then
        return
    end

    --setNpcEnterId
    --设置id  可以自动打开
    local npcArr = _G.CharacterManager : getNpc()       --获取场景中的npc
    for key, value in pairs( npcArr ) do
        if tonumber( value.m_nID ) == tonumber( _npcId ) then
            value :setNpcEnterId( tonumber( _npcId ) )
        end
    end

    local nNowSceneId = _G.g_Stage :getScenesID()

    if nNowSceneId == _sceneId then
        local sceneNode =  self :getSceneNode( _sceneId )
        print( "sceneNode :isEmpty", sceneNode :isEmpty(), _sceneId )
        if sceneNode :isEmpty() == true then
            CCLOG("codeError!!!! task's question, please notice programmer!")
            return
        end

        local x, y = _G.g_Stage :getRole() :getLocationXY()
        local nPos = CCPointMake( x * 1.0, y * 1.0)

        local _npcCount = self :getSceneNpcCount( sceneNode )
        print( "_npcCount", _npcCount )
        for i=1, _npcCount do          --npc id相等时，取相应的x y值
            local idx = i - 1
            print("npc_id == ", self :getSceneNpcsData( sceneNode, ( idx ), "npc_id"))
            if self :getSceneNpcsData( sceneNode, ( idx ), "npc_id") == tostring( _npcId ) then
                local nX = tonumber( self :getSceneNpcsData( sceneNode, ( idx ), "x") or 0 )
                local nY = tonumber( self :getSceneNpcsData( sceneNode, ( idx ), "y") or 0 )
                print("ssssss", nX, nY)
                local nSecPos = CCPointMake( nX * 1.0, nY * 1.0)

                return nSecPos
            end
        end
        print("怎么跑到自己那里去，速度看代码", nPos.x, nPos.y, sceneNode :isEmpty())
        return nPos                                 --如果没有符合的就在原点
    elseif nNowSceneId ~= _sceneId then
        --如果不相等，先跑到当前场景的传送门
        self :gotoDoorsPos( nNowSceneId, 2 )
        self :setAutoList( _npcId, _sceneId )
    end
end

function CTaskNewDataProxy.setAutoList( self, _npcId, _sceneId )
    if self.m_autoList == nil then
        self.m_autoList = {}
    end

    self.m_autoList.npcId   = _npcId
    self.m_autoList.sceneId = _sceneId
end

function CTaskNewDataProxy.getAutoList( self )
    return self.m_autoList
end

function CTaskNewDataProxy.getScenesDoorId( self, _node, _pos, _selectName )
    if not _node :isEmpty() then
        local doorsNode = _node :children() :get( 0, "doors" )
        if not doorsNode :isEmpty() then
            local _doorNode = doorsNode :children() :get( _pos, "door" )
            if not _doorNode :isEmpty() then
                return _doorNode :getAttribute( _selectName )
            end
        end
    end
    
    return nil
end

--通过场景id跑到副本传送门  直接跑  1: 传送副本，  2: 传送场景
function CTaskNewDataProxy.gotoDoorsPos( self, _sceneId, _type)
    if _sceneId == nil or _type == nil then
        return
    end
    local str = "scene[@scene_id=" .. _sceneId .. "]"
    local sceneNode = _G.Config.scenes : selectSingleNode( str )
    if sceneNode :isEmpty() == true then
        return
    end

    if _type < 1 and _type > 2 then
        _type = 1
    end

    
    
    local x     = tonumber( self :getScenesDoorId( sceneNode, _type - 1, "x" ) )    --sceneNode.doors[1].door[_type].x)
    local y     = tonumber( self :getScenesDoorId( sceneNode, _type - 1, "y" ) )    --sceneNode.doors[1].door[_type].y)
    print("CTaskNewDataProxy.gotoDoorsPos", _type, x, y )
    local nDoorsPos = CCPointMake( x * 1.0, y * 1.0)

    if _type == 1 then
        local distance = ccpDistance( ccp( _G.g_Stage :getRole() :getLocationXY() ), ccp( nDoorsPos.x, nDoorsPos.y ) )
        local nRadius = 80
        print( "CTaskNewDataProxy-->", nDoorsPos.x, nDoorsPos.y, distance)
        if distance < nRadius then
            require "view/DuplicateLayer/DuplicateSelectPanelView"
            local tempview = CDuplicateSelectPanelView()
            CCDirector :sharedDirector() :pushScene( tempview :scene())
            return
        end

    end

    print("跑的位置", x, y)
    if _G.g_Stage == nil then
        --CCMessageBox("_G.g_Stage==nil, CTaskNewDataProxy.gotoDoorsPos 150 line")
        CCLOG("codeError!!!! _G.g_Stage==nil, CTaskNewDataProxy.gotoDoorsPos 150 line")
    end
    _G.g_Stage :getRole() :setMovePos( nDoorsPos)

end


if _G.g_CTaskNewDataProxy == nil then

    _G.g_CTaskNewDataProxy  = CTaskNewDataProxy()
    --[[
    require "mediator/TaskNewDataMediator"
    _G.pTaskNewDataMediator = CTaskNewDataMediator( _G.g_CTaskNewDataProxy )
    controller :registerMediator( _G.pTaskNewDataMediator )

    print("_G.g_CTaskNewDataProxy, CTaskNewDataMediator注册", _G.pTaskNewDataMediator)
     --]]
end







