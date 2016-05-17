require "view/view"
require "common/Constant"
require "view/Guide/GuideView"
require "view/Guide/GuideNoticPicView"
require "controller/GuideCommand"
-- require "controller/PlotCommand"
-- _G.pCGuideManager

CGuideManager = class(view,function ( self )
    self:loadXml()
    self.m_guideList = {}



    self.m_nowState  = CGuideManager.STATE_STOP
    self.m_preStepId = 0

    local function isEmpty()
    	return true
    end

    self.m_nowGuide  = {}
    self.m_nowGuide.isEmpty = isEmpty
    self.m_nowGuideIdx = 0
    self.m_nowStepState = 1
    self.m_nowGuideView = {}

    self:loadFirstLoginGuide() --读取首次进入游戏的指引

    self.m_guideOpen = true  --新手指引的总开关,  false时不会指引

    self.m_canStartGuide = true   --新手指引暂停,   false时不接受注册指引,暂用于GM命令中
end)

CGuideManager.STATE_STOP  = 10 --停止状态  可以运行新的指引
CGuideManager.STATE_WAIT_INITVIEW = 20 --等待初始化界面
CGuideManager.STATE_WAIT_Touch    = 21 --等待下一次点击
CGuideManager.STATE_WAIT_CScene   = 22 --等待场景转换
CGuideManager.STATE_WAIT_FINISH   = 23 --等待指引结束
CGuideManager.STATE_WAIT_GOBACK   = 24 --等待界面返回继续指引
CGuideManager.STATE_WAIT_COPY_FINISH = 25 --等待任务成
CGuideManager.STATE_GUIDE = 30 --指引状态
CGuideManager.STATE_WAIT_START = 40 --等待开始指引  用于不在此场景的指引  当转移场景时 启动指引



------------------------------------
--界面改变时 触发
------------------------------------
--按钮真的点击中了时 触发
function CGuideManager.stepFinish( self, _step, _isExitView )
	print("stepFinish----1111")--,debug.traceback())
	if self.m_guideView ~= nil then
		print("stepFinish----2222",self.m_nowState,self.m_nowGuideIdx,self.m_preStepId)

		local realGuideIdx = self.m_guideView:getNowGuideIdx()
		local isManLe      = false
		if realGuideIdx ~= self.m_nowGuideIdx and self.m_nowGuideIdx > 0 then
			print("realGuideIdx > self.m_nowGuideIdx --------  stepFinish",realGuideIdx,self.m_nowGuideIdx)
			-- self:setGuideLayerNil()
			-- self:guideFinish()
			-- return
			isManLe = true
			self:thisGuideStepTouch(realGuideIdx)
			-- return
		end

		if self.m_isThisStepFinish then
			return
		end

		self:lockScene()
		print("stepFinish----2222",self.m_nowState,self.m_nowGuideIdx,self.m_preStepId)

		if self.m_nowState == CGuideManager.STATE_WAIT_FINISH then
			--指引结束
			print("stepFinish----6666")

			-- if isManLe and _isExitView then
			-- 	print("asdfeggdsfsfsfsa 1212221221")
			-- 	-- if _step == _G.Constant.CONST_FUNC_OPEN_BAG then
			-- 		self:setGuideLayerNil()
			-- 	-- end
			-- end

			self:guideFinish()
			self.m_isThisStepFinish = true

			self:unlockScene()
		elseif self.m_nowState == CGuideManager.STATE_WAIT_Touch then
			if self.m_nowGuideIdx > 0 and self.m_nowStepState == _G.Constant.CONST_NEW_GUIDE_SPECIAL_GOON then
				--进入下一步指引
				print("stepFinish----3333")
				self.m_guideView : removeNowGuide()--removeGuideLayer()
				self : goNextGuide( self.m_preStepId )
				self.m_isThisStepFinish = true

			end
			self:unlockScene()

		elseif self.m_nowGuideIdx > 0 and self.m_nowState == CGuideManager.STATE_WAIT_INITVIEW then
			--点击完成  下一步是打开界面后  去除指引 但是不能点击
			-- self.m_guideView : removeNowGuide()
			print("stepFinish----4444  111")
			local in_type = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("in_type"))
			local in_id   = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("in_id"))
			if in_type == _G.Constant.CONST_NEW_GUIDE_PUSH_BUTTON and in_id == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then
				--任务指引按钮
				print("stepFinish----4444  222")
				-- self.m_guideView:createPingBiContainer(  )
				self.m_guideView :removeGuideLayer()

				self.m_isThisStepFinish = true

				self:lockScene()
				return

			end

			local realViewId = self:getPreViewId()

			print("stepFinish----4444 333",_step,realViewId)
			if _step == realViewId then
				print("stepFinish----4444  444")
				-- local _parent = _G.g_Stage:getScene() --CCDirector : sharedDirector() : getRunningScene()
				-- self.m_guideView:createPingBiContainer(  )
				self.m_guideView :removeGuideLayer()
				self.m_isThisStepFinish = true

				local nextView = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("next"))
				if nextView == _G.Constant.CONST_FUNC_OPEN_SENCE or nextView == 10106 then
					self:lockScene()
					return
				else
					self:unlockScene()
				end
			elseif realViewId == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then
				print("stepFinish----4444  555")

				-- if _G.g_dialogView ~= nil then
				-- 	if _G.g_dialogView.m_scene ~= nil then
				-- 		--出错
				-- 		self:guideFinish()
				-- 		self:unlockScene()
				-- 		return
				-- 	end
				-- end

				self.m_guideView :removeGuideLayer()

				self.m_isThisStepFinish = true

				self:lockScene()
				return
			-- else
			-- 	self:unlockScene()
			end
		elseif self.m_nowState == CGuideManager.STATE_WAIT_COPY_FINISH then
			--点击完成  下一步是转换场景后  完全去除指引 且可以点击
			print("stepFinish----5555")
			self.m_guideView : removeGuideLayer()
			self.m_isThisStepFinish = true

			self:unlockScene()
		elseif self.m_nowState == CGuideManager.STATE_WAIT_GOBACK then
			print("stepFinish----7777")
			local _parent   = nil
			local preViewId = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("next"))
			for i,v in ipairs(self.m_nowGuideView) do
				if preViewId == v.viewId then
					_parent = v.layer
				end
			end
			if _parent == nil then
				--CCMessageBox( "找不到上个界面!","出错了" )
                CCLOG("codeError!!!! 找不到上个界面!")
				self:guideFinish()

				self:unlockScene()
			else
				--进入下一个指引
				self.m_guideView : goNextGuide( _parent )
				--状态变成 指引中
				self.m_nowState  = CGuideManager.STATE_GUIDE

				self.m_isThisStepFinish = true

				self:unlockScene()
			end
		else
			self:unlockScene()
		end

	end
end

--获取上一个指引界面ID
function CGuideManager.getPreViewId( self )

	if self.m_nowGuideIdx <= 0 then
		return tonumber(self.m_nowGuide:getAttribute("in_id"))
	else
		for i=self.m_nowGuideIdx-1,1,-1 do
			local special = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(i-1,"guids"):getAttribute("special"))
			if special == 2 then
				return tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(i-1,"guids"):getAttribute("next"))
			end
		end
		return tonumber(self.m_nowGuide:getAttribute("in_id"))
	end

	return 0
end

--界面加载到场景时 触发
function CGuideManager.initGuide( self, _parent, _viewId )
	print("CGuideManager.initGuide 111")
	if self.m_guideView ~= nil then
		print("CGuideManager.initGuide 222",self.m_nowGuideIdx,_viewId,self.m_nowState)
		local realViewId
		local isOpenNpc = false
		if self.m_nowGuideIdx == 0 then
			realViewId = self.m_nowGuide:getAttribute("in_id")
			if tonumber(realViewId) == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then
				isOpenNpc = true
			end
		else
			realViewId = self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("next") --or 0
		end
		print("CGuideManager.initGuide 234",realViewId)
		if self.m_nowState == CGuideManager.STATE_WAIT_INITVIEW and tonumber( _viewId ) == tonumber( realViewId ) then --and self.m_preStepId == _viewId
			print("CGuideManager.initGuide 333",_parent)

			if _parent ~= nil then
				if _parent.getControlName ~= nil then
					print("CGuideManager.initGuide-----> ControlName = ".._parent:getControlName())
				else
					print("CGuideManager.initGuide-----> ControlName = RunningScene")
				end
			end

			--解锁
			self:unlockScene()

			--进入下一个指引
			self.m_guideView : goNextGuide( _parent )
			--状态变成 指引中
			-- print("initGuide------>",self.m_nowGuideIdx,debug.traceback())
			self.m_nowState  = CGuideManager.STATE_GUIDE

			for i,v in ipairs(self.m_nowGuideView) do
				if v.viewId == tonumber( _viewId ) then
					return
				end
			end
			local list = {}
			list.viewId = tonumber( _viewId )
			list.layer  = _parent
			table.insert(self.m_nowGuideView,list)

		-- elseif self.m_nowState == CGuideManager.STATE_WAIT_INITVIEW and tonumber( _viewId ) ~= tonumber( realViewId ) then
		-- 	--点击事件失效..
		-- 	-- CCMessageBox("点击事件失效,所以你才进入这里把?","新手指引")
		-- 	self.m_guideView : removeGuideLayer()
		elseif isOpenNpc then

			if _parent ~= nil then
				if _parent.getControlName ~= nil then
					print("CGuideManager.initGuide-----> ControlName = ".._parent:getControlName())
				else
					print("CGuideManager.initGuide-----> ControlName = RunningScene")
				end
			end

			--解锁
			self:unlockScene()

			--进入下一个指引
			self.m_guideView : goNextGuide( _parent )
			--状态变成 指引中
			-- print("initGuide------>",self.m_nowGuideIdx,debug.traceback())
			self.m_nowState  = CGuideManager.STATE_GUIDE

			for i,v in ipairs(self.m_nowGuideView) do
				if v.viewId == tonumber( _viewId ) then
					return
				end
			end
			local list = {}
			list.viewId = tonumber( _viewId )
			list.layer  = _parent
			table.insert(self.m_nowGuideView,list)
		else
			self:unlockScene()
		end
	else
		self:unlockScene()
	end

end

--界面退出场景时 触发
function CGuideManager.exitView( self, _viewId )

	if self.m_nowState == CGuideManager.STATE_GUIDE and self.m_nowGuideIdx > 0 then
		local nextView = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("next"))
		if nextView == _G.Constant.CONST_FUNC_OPEN_PARTNER then
			--招募关闭  不处理
			return
		end
	end

	self:stepFinish( _viewId, true )

end

--转换场景时 触发
function CGuideManager.goOnGuideBySceneChuange( self )
	print("goOnGuideBySceneChuange----1111",self.m_nowState)
	if self.m_nowState == CGuideManager.STATE_WAIT_COPY_FINISH then
		--正在指引 继续指引
		print("goOnGuideBySceneChuange----1212")
		if _G.g_Stage:getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
			--主城
			print("正在指引 继续指引  当前:主城")

			local _state = 1
			if tonumber( self.m_nowGuideIdx ) > 0 then
				_state  = tonumber(self.m_nowGuide:children():get(0,"guidss"):children():get(self.m_nowGuideIdx-1,"guids"):getAttribute("special")) or 1
			end

			print("goOnGuideBySceneChuange----2222",self.m_nowGuideIdx, _state)

			if _state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_MAINSCENE_COPY then
				--
				if _G.g_CTaskNewDataProxy :getInitialized() == true then
					local mainTask = _G.g_CTaskNewDataProxy:getMainTask()
					print("goOnGuideBySceneChuange----3333")
					if mainTask ~= nil then
						local state = mainTask.state
						print("goOnGuideBySceneChuange----4444", state)
						if state == _G.Constant.CONST_TASK_STATE_FINISHED then
							--完成副本跳转到主场景继续指引
							print("任务完成为提交  指引继续!!")
							--取消角色移动
							_G.g_Stage :getPlay():cancelMove()
							--关闭任务界面框
							self:closeOtherWindow()

							-- local scene = CCDirector : sharedDirector() : getRunningScene()
							self.m_guideView : goNextGuide()
							self.m_nowState = CGuideManager.STATE_GUIDE
						end
					end
				end
			end
		end
	elseif self.m_nowState == CGuideManager.STATE_WAIT_INITVIEW then
		print("goOnGuideBySceneChuange----6666")
		-- self.m_guideView : setGuideLayerNil()
		-- self.m_guideView : createPingBiContainer()
	elseif self.m_nowState == CGuideManager.STATE_WAIT_START then
		--当前不在指引中 开始其他的指引
		print("goOnGuideBySceneChuange----5555")
		self:guideStart()
	end
end

function CGuideManager.closeOtherWindow( self )
	--npc对话框
	if _G.g_dialogView ~= nil then
        _G.g_dialogView :closeWindow()
        _G.g_dialogView = nil
    end
    --招财
    if _G.pLuckyLayer ~= nil then
    	_G.pLuckyLayer : removeLayer()
    	_G.pLuckyLayer = nil
    end
end



------------------------------------
--新手指引的管理
------------------------------------
--进行下一步指引
function CGuideManager.goNextGuide( self, _stepId )

	if self.m_guideView ~= nil then

		self.m_guideView : removeNowGuide()

		if self.m_nowState == CGuideManager.STATE_WAIT_Touch then --and self.m_preStepId == _stepId then
			--进入下一个指引
			self.m_guideView : goNextGuide()
			--状态变成 指引中
			-- print("goNextGuide------>",self.m_nowGuideIdx,debug.traceback())
			self.m_nowState  = CGuideManager.STATE_GUIDE
		end

	end

end

--点击了指引框
function CGuideManager.thisGuideStepTouch( self, _guideIdx )
	--状态变成 等待
	self.m_nowState  = CGuideManager.STATE_WAIT_Touch

	local _stepId
	local _state = 1
	local now_nodeChild = self.m_nowGuide:children():get(0,"guidss"):children()
	if tonumber( _guideIdx ) > 0 then
		_stepId = tonumber(now_nodeChild:get(_guideIdx-1,"guids"):getAttribute("in_id"))
		_state  = tonumber(now_nodeChild:get(_guideIdx-1,"guids"):getAttribute("special")) or 1
	else
		_stepId = tonumber(self.m_nowGuide:getAttribute("in_id"))
	end

	self.m_preStepId   = _stepId
	self.m_nowGuideIdx = _guideIdx
	self.m_nowStepState = _state

	print("thisGuideStepTouch---  000")
	if self.m_preStepId == _G.Constant.CONST_FUNC_OPEN_FUNTION then
		print("thisGuideStepTouch---  111")
		self:goNextGuide( self.m_preStepId )
		return
	elseif _guideIdx > 0 and _state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_MAINSCENE_COPY then
		print("thisGuideStepTouch---  222")
		-- self.m_guideView:removeGuideLayer()
		self.m_nowState  = CGuideManager.STATE_WAIT_COPY_FINISH
	elseif _guideIdx > 0 and _state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_INITVIEW then
		print("thisGuideStepTouch---  333")
		self.m_nowState  = CGuideManager.STATE_WAIT_INITVIEW
	elseif _guideIdx > 0 and _state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_FINISH then
		print("thisGuideStepTouch---  444")
		self.m_nowState  = CGuideManager.STATE_WAIT_FINISH
	elseif _guideIdx > 0 and _state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_GOBACK then
		print("thisGuideStepTouch---  555")
		print("thisGuideStepTouch---  111")
		local _parent   = nil
		local _guideChild = self.m_nowGuide:children():get(0,"guidss"):children()
		local preViewId = tonumber(_guideChild:get(self.m_nowGuideIdx-1,"guids"):getAttribute("next"))
		for i,v in ipairs(self.m_nowGuideView) do
			if preViewId == v.viewId then
				_parent = v.layer
			end
		end
		if _parent == nil then
			--CCMessageBox( "找不到上个界面!","出错了" )
            CCLOG("codeError!!!! 找不到上个界面!")
			self:guideFinish()

			self:unlockScene()
		else
			--进入下一个指引
			self.m_guideView : goNextGuide( _parent )
			--状态变成 指引中
			self.m_nowState  = CGuideManager.STATE_GUIDE

			-- self.m_isThisStepFinish = true

			self:unlockScene()
		end
		return
		-- self.m_nowState  = CGuideManager.STATE_WAIT_GOBACK
	elseif _guideIdx == 0 then
		print("thisGuideStepTouch---  666")
		self.m_nowState  = CGuideManager.STATE_WAIT_INITVIEW
	end

	self.m_isThisStepFinish = false

	print("thisGuideStepTouch---   _stepId=".._stepId.."   _guideIdx=".._guideIdx.."   _state=".._state)

end


--整个指引结束
function CGuideManager.guideFinish( self )

	print("CGuideManager.guideFinish", debug.traceback())

	--锁住屏幕
	self:lockScene()

	local guideId = 0
	if self.m_nowGuide :isEmpty() == false then
		guideId = tonumber( self.m_nowGuide:getAttribute("id") )
	end

	self:releseParment()

	if #self.m_guideList > 0 then
		self.m_nowState = CGuideManager.STATE_WAIT_START
	end

	self:registGuide( _G.Constant.CONST_NEW_GUIDE_COMPLETE_GUIDE, guideId )
	self:guideStart( guideId )

	-- local _guideCommand = CGuideStepCammand( CGuideTouchCammand.GUIDE_FINISH, guideId )
	-- controller:sendCommand(_guideCommand)
	--

	-- print("guideFinish------>   ",debug.traceback())
end


--开始指引
function CGuideManager.guideStart( self, _touchId )
	--在 m_guideList 中查找是否存在 指引
	--把第一个赋给 nowGuide
	--删除 m_guideList 中的第一个指引
	print("CGuideManager  guideStart ------------",self.m_nowState,_touchId)

	if self.m_guideOpen == false then
		print("guideStart     111")
		self:unlockScene()
		return false
	end

	local function start()
		local guideNode = self.m_guideList[1]

		local myLv   = _G.g_characterProperty:getMainPlay():getLv()
		local nodeLv = tonumber(guideNode:getAttribute("drive_lv"))

		-- if nodeLv > myLv then
		-- 	--等级不足 延迟问题 不出现指引
		-- 	print("guideStart---->等级不足  ",nodeLv,myLv)
		-- 	local function isEmpty()
		--     	return true
		--     end

		--     self.m_nowGuide  = {}
		--     self.m_nowGuide.isEmpty = isEmpty

		-- 	table.remove( self.m_guideList, 1 )
			
		-- 	--解锁屏幕
		-- 	self:unlockScene()
		-- 	return
		-- end

		local entranceType = tonumber(guideNode:getAttribute("in_type"))
		local entranceId   = tonumber(guideNode:getAttribute("in_id"))
		if entranceType == _G.Constant.CONST_NEW_GUIDE_NPC then
			--NPC  查看是否在此场景
			local npc = self:getNowSceneNpcById( entranceId )
			if npc == nil then
				print("CGuideManager--->  npc 不存在或不在当前场景中.")
				--解锁屏幕
				self:unlockScene()
				self.m_nowState = CGuideManager.STATE_WAIT_START
				return
			end
		end

		print("CGuideManager--->  开始指引")
		self.m_nowGuide = guideNode
		table.remove( self.m_guideList, 1 )

		local runScene = CCDirector : sharedDirector() : getRunningScene()

		-- print("guideStart------>   ",debug.traceback())
		self.m_nowState   = CGuideManager.STATE_GUIDE
		self.m_guideView  = CGuideView()
		self.m_guideLayer = self.m_guideView:layer( self.m_nowGuide, runScene )

		--解锁屏幕
		self:unlockScene()

		self:closeOtherWindow()
	end


	if self.m_nowState == CGuideManager.STATE_WAIT_START then

		if self.m_canStartGuide == false then
			--解锁屏幕
			self:unlockScene()
			return
		end

		if #self.m_guideList < 1 then
			--解锁屏幕
			self:unlockScene()
			print("CGuideManager--->  当前没有指引")
			return
		end

		if _touchId == nil then
			start()
		else
			local TouchType = tonumber(self.m_guideList[1]:getAttribute("type"))
			local TouchId   = tonumber(self.m_guideList[1]:getAttribute("drive_id"))
			if TouchType == _G.Constant.CONST_NEW_GUIDE_ACCEPT_TASK or TouchType == _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK then
				TouchId = TouchId * 10
			end
			if TouchId == tonumber(_touchId) then
				start()
			else
				--解锁屏幕
				self:unlockScene()
			end
		end
	else
		--解锁屏幕
		self:unlockScene()
	end
end



--注册指引
function CGuideManager.registGuide( self, _touchType, _touchId )

	if self.m_guideOpen == false then
		return false
	end

	print( "---------registGuide----------" )



	--锁住屏幕
	self:lockScene()

	if self.m_canStartGuide == false then
		--解锁屏幕
		self:unlockScene()
		return false
	end

	local touchId = tonumber( _touchId )
	if tonumber( _touchType ) == _G.Constant.CONST_NEW_GUIDE_ACCEPT_TASK or
	   tonumber( _touchType ) == _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK then
	   --任务的话需要先处理ID   少一个0
	   touchId = touchId/10
	end
	local guideNode = self:queryNodeByTypeAndId( _touchType, touchId )

	if guideNode:isEmpty() then
		print("registGuide 没有指引!")
		--解锁屏幕
		self:unlockScene()
		return false
	end

	if #self.m_guideList > 0 then
		if tonumber(guideNode:getAttribute("id")) == tonumber(self.m_guideList[1]:getAttribute("id")) then
			--已经注册了相同的
			self:unlockScene()
			return false
		end
		table.remove( self.m_guideList,1 )
	end
	table.insert(self.m_guideList,guideNode)

	if tonumber(_touchType) == _G.Constant.CONST_NEW_GUIDE_NEW then
		--第一次进入游戏
		--因为场景还没有转换 所以状态为等待开始
		self.m_nowState = CGuideManager.STATE_WAIT_START

		--解锁屏幕
		self:unlockScene()
	else
		--尝试开始指引
		print("12121123   ",self.m_nowState)
		if self.m_nowState == CGuideManager.STATE_STOP then
			--当前不在指引中 开始其他的指引

			self.m_nowState = CGuideManager.STATE_WAIT_START
			if tonumber( guideNode:getAttribute("type") ) == _G.Constant.CONST_NEW_GUIDE_FUN_NOTIC then
				self:guideStart()
			end
			-- self:guideStart()
		else
			--解锁屏幕
			self:unlockScene()
		end
	end

	print( "---------registGuide----------" )

	return true



end

function CGuideManager.removeThisStep( self )
	if self.m_nowState ~= CGuideManager.STATE_STOP then
		if self.m_guideView ~= nil then
			self.m_guideView :removeGuideLayer()
		end
	end
end

--获取当前指引状态
function CGuideManager.getNowGuideState( self )
	return self.m_nowState
end

--初始化变量
function CGuideManager.releseParment( self )

	--指引结束 改变状态
	self.m_nowState  = CGuideManager.STATE_STOP
	self.m_preStepId = 0

	--清除view
	if self.m_guideView ~= nil then
		self.m_guideView : removeGuideLayer()
		self.m_guideView = nil
	end

	--清楚当前指引
	local function isEmpty()
    	return true
    end

    self.m_nowGuide  = {}
    self.m_nowGuide.isEmpty = isEmpty


	self.m_nowGuideIdx  = 0
	self.m_nowStepState = 1
	self.m_nowGuideView = {}
end

function CGuideManager.setGuideLayerNil( self )
	if self.m_guideView ~= nil then
		self.m_guideView:setGuideLayerNil()
	end
end

--是否可以开始指引
function CGuideManager.setIsCanStartGuide( self, _boolean )
	self.m_canStartGuide = _boolean
end

function CGuideManager.getIsCanStartGuide( self )
	return self.m_canStartGuide
end

--断线重连 时
function CGuideManager.disConnectServer( self )
	
	--清楚新手指引
	self:releseParment()

	--解锁
	self:unlockScene()

end



----------------------------------
--首次登陆提示是否需要新手指引
----------------------------------
function CGuideManager.guideNotic( self )

	print("121212121   guideNotic")

	self:goOnGuideBySceneChuange()

	-- local function local_ensureGuide()
	-- 	print("local_ensureGuide   guideNotic")
	-- 	self:goOnGuideBySceneChuange()
	-- end

	-- local function local_cancelGuide()
	-- 	self:cancelGuide()
	-- end



	-- require "view/ErrorBox/ErrorBox"
	-- local guideBox = CErrorBox()
 --    local BoxLayer = guideBox : create("你是需要引导的新手还是大神呢？",local_ensureGuide,local_cancelGuide)

 --    local btn = guideBox : getBoxCancelBtn()
 --    if btn ~= nil then
 --        btn : setText("大神")
 --    end
 --    local btn2 = guideBox : getBoxEnsureBtn()
 --    if btn2 ~= nil then
 --        btn2 : setText("新手")
 --    end

 --    _G.g_Stage:getScene() :addChild( BoxLayer, 10000 )

end

--取消
function CGuideManager.cancelGuide( self )

	print("CGuideManager.cancelGuide")

	if _G.pCGuideMediator ~= nil then
        controller :unregisterMediator(_G.pCGuideMediator)
        _G.pCGuideMediator = nil
    end

    self.m_guideOpen = false

    _G.pCGuideManager:removeAllGuide()
    _G.pCGuideManager:guideFinish()

    self:sendGuideSetting()
end


----------------------------------
--新手副本  弹出操作 指引
----------------------------------
function CGuideManager.showGuidePic( self )
	local guidePicScene = CGuideNoticPicView():scene()
	CCDirector:sharedDirector():pushScene( guidePicScene )
end

function CGuideManager.GuidePicFinish( self )
	print("CGuideManager.GuidePicFinish")
end


----------------------------------
--屏幕点击控制
----------------------------------
--锁屏
function CGuideManager.lockScene( self )
	--锁住屏幕
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
    	CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end
end
--解锁屏幕点击
function CGuideManager.unlockScene( self )

	print("CGuideManager.lockScene   unlockScene")
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end
end



--删除所有指引  现在只用于GM命令
function CGuideManager.removeAllGuide( self )
	self.m_guideList = {}

	if self.m_nowGuide :isEmpty() == false then
		local touchType = tonumber( self.m_nowGuide:getAttribute("type") )
		if touchType == _G.Constant.CONST_NEW_GUIDE_ACCEPT_TASK or touchType == _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK then
			--当前指引为任务触发的指引
			if _G.g_CTaskNewDataProxy :getInitialized() == true then
				local mainTask = _G.g_CTaskNewDataProxy:getMainTask()
				if mainTask ~= nil then
					local touchId = tonumber( self.m_nowGuide:getAttribute("drive_id") )
					local taskId  = mainTask.id
					if touchId ~= taskId then
						--当前任务与当前的指引触发ID 不相同  清楚当前指引

						--指引结束 改变状态
						self.m_nowState  = CGuideManager.STATE_STOP
						self.m_preStepId = 0

						--清除view
						self.m_guideView = nil

						--清楚当前指引
						local function isEmpty()
					    	return true
					    end

					    self.m_nowGuide  = {}
					    self.m_nowGuide.isEmpty = isEmpty


						self.m_nowGuideIdx  = 0
						self.m_nowStepState = 1
						self.m_nowGuideView = {}
					end
				end
			end
		end
	end

end






------------------------------
--查找数据
------------------------------

--加载xml
function CGuideManager.loadXml( self )
    _G.Config:load("config/guide.xml")
    _G.Config:load("config/scene.xml")
end

function CGuideManager.loadFirstLoginGuide( self )
	print("loadFirstLoginGuide----111")
	if _G.g_LoginInfoProxy :getFirstLogin() then
		print("loadFirstLoginGuide----222")
		-- for i,v in ipairs(_G.Config.guides.guide) do
		-- 	if _G.Constant.CONST_NEW_GUIDE_NEW == tonumber(v.type) then

		-- 		return
		-- 	end
		-- end

		local guideNode = self:queryNodeByTypeAndId(1,0)

		if guideNode:isEmpty() then
			return
		end

		table.insert( self.m_guideList, guideNode )
		self.m_nowState = CGuideManager.STATE_WAIT_START


		print("loadFirstLoginGuide----333",#self.m_guideList)
	end
end

-- 查找是否存在指引..   _touchType->触发类型     _touchId->触发Id
function CGuideManager.queryNodeByTypeAndId( self, _touchType, _touchId )

	print( "queryNodeByTypeAndId  111",_touchType,_touchId )
	if _touchType == nil or _touchId == nil then
		return nil
	end

	-- type_drive
	local _type_drive = tostring(_touchType).."_"..tostring(_touchId)

	return _G.Config.guides:selectSingleNode("guide[@type_drive=".._type_drive.."]")

	-- local list = _G.Config.guides.guide
	-- for i,v in ipairs(list) do
	-- 	if tonumber( _touchType ) == tonumber(v.type) and tonumber( _touchId ) == tonumber(v.drive_id) then
	-- 		return v
	-- 	end
	-- end

	-- return nil

end


--获取NPC
function CGuideManager.getNowSceneNpcById( self, _npcId )
	local npcArr = _G.CharacterManager : getNpc()       --获取场景中的npc
    for key, value in pairs( npcArr ) do
        if tonumber( value.m_nID ) == tonumber( _npcId ) then
        	return value
        end
    end
end

--获取NPC位置
function CGuideManager.getNpcPosById( self, _npcId )

	local nNowSceneId = _G.g_Stage :getScenesID()
	local sceneNode = _G.Config.scenes : selectSingleNode( "scene[@scene_id="..tostring( nNowSceneId ).."]" )
    if sceneNode:isEmpty() then
        --CCMessageBox( "task's question, please notice programmer!", nNowSceneId )
        CCLOG("codeError!!!! task's question, please notice programmer!"..nNowSceneId)
        return
    end

    local sceneNPC = sceneNode:children():get(0,"npcs"):children()
    local NPCCount = sceneNPC:getCount("npc")
    for i=0, NPCCount-1 do          --npc id相等时，取相应的x y值
    	local npc = sceneNPC:get(i,"npc")
        if npc:getAttribute("npc_id") == tostring(_npcId) then
            local nX = tonumber( npc:getAttribute("x"))
            local nY = tonumber( npc:getAttribute("y"))
            local nSecPos = CCPointMake( nX * 1.0, nY * 1.0)

            return nSecPos
        end
    end

    -- CCMessageBox( "CGuideManager getNpcPos 没找到Npc的位置","提示" )
    CCLOG("codeError!!!! CGuideManager getNpcPos 没找到Npc的位置")
    return CCPointMake( 500,300 )
end



--获取主界面图标按钮
function CGuideManager.getMainSceneOpenIcon( self, _openId )

	--查找上方按钮
	if _G.pCActivityIconView == nil then
		CCMessageBox( "_G.pCActivityIconView 为空", "提示" )
        CCLOG("codeError!!!! _G.pCActivityIconView 为空")
		return
	end
	if _G.pCActivityIconView:getActivityBtnByIndex( _openId ) then
		return _G.pCActivityIconView:getActivityBtnByIndex( _openId )
	end



	--查找下方按钮
	if _G.pCSMenuView == nil then
		CCMessageBox( "_G.pCSMenuView 为空", "提示" )
        CCLOG("codeError!!!! _G.pCSMenuView 为空")
		return
	end

	if _G.pCFunctionMenuView == nil then
		CCMessageBox( "_G.pCFunctionMenuView 为空", "提示" )
        CCLOG("codeError!!!! _G.pCFunctionMenuView 为空")
		return
	end
	-- _G.pCFunctionMenuView :setMenuStatus( true )

	if _G.pCSMenuView:getFuncBtnByIndex( _openId ) then
		return _G.pCSMenuView:getFuncBtnByIndex( _openId )
	end

	-- _G.pCFunctionMenuView :setMenuStatus( true )

	-- if _G.pCSMenuView:getFuncBtnByIndex( _openId ) then
	-- 	return _G.pCSMenuView:getFuncBtnByIndex( _openId )
	-- end

	--CCMessageBox( "找不到该按钮,功能开放Id=".._openId, "提示" )
    CCLOG("codeError!!!! 找不到该按钮,功能开放Id=".._openId)

	--找不到按钮
	return nil

end

--设置系统按钮的状态
function CGuideManager.setSysMeneStatus( self, _boolean )

	if _G.pCFunctionMenuView == nil then
		CCMessageBox( "_G.pCFunctionMenuView 为空", "提示" )
        CCLOG("codeError!!!! _G.pCFunctionMenuView 为空")
		return
	end
	_G.pCFunctionMenuView :setMenuStatus( _boolean )

end


--获取功能按钮
function CGuideManager.getSysOpenBtn( self )
	if _G.pCFunctionMenuView ~= nil then
		print( " _G.pCFunctionMenuView ~= nil " )
		return _G.pCFunctionMenuView : getMenuButton()
	else
		print("_G.pCFunctionMenuView 为空")
	end
end

--获取任务指引按钮
function CGuideManager.getTaskGuideBtn( self )

	if _G.pCActivityIconView == nil then
		--CCMessageBox( "_G.pCActivityIconView 为空", "提示" )
        CCLOG("codeError!!!! _G.pCActivityIconView 为空")
		return
	end
	if _G.pCActivityIconView:getTaskGuideBtn( ) then
		return _G.pCActivityIconView:getTaskGuideBtn( )
	end

	CCMessageBox( "找不到任务指引按钮", "提示" )
    CCLOG("codeError!!!! 找不到任务指引按钮")

	return nil
end



function CGuideManager.sendGuideSetting( self )
	require "common/protocol/auto/REQ_SYS_SET_CHECK"
	local msg = REQ_SYS_SET_CHECK()
	msg : setType( _G.Constant.CONST_SYS_SET_GUIDE )
	CNetwork : send( msg )
end

--
function CGuideManager.sendStepFinish( self )

	if self.m_nowGuide:isEmpty() == false then
		local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
	    controller:sendCommand(_guideCommand)
	end
end

