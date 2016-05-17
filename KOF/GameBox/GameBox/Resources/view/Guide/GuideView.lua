require "view/view"
require "common/Constant"
-- require "controller/PlotCommand"


CGuideView = class(view,function ( self )

end)

CGuideView.LAYER_ZOrder = 200000
CGuideView.LAYER_PRI    = -200000

CGuideView.FONT_SIZE   = 20
CGuideView.FONT_FAMILY = "Arial"
CGuideView.FONT_COLOR  = ccc4( 0,0,0,255 )

CGuideView.TAG_ARROW = 101
CGuideView.TAG_RECT  = 102
CGuideView.TAG_JUMP  = 103

-- 任务触发
-- 剧情触发
-- 第一次进入游戏触发
-- 升级触发
-- 打开面板触发
--



---------------------------
--界面管理
---------------------------
function CGuideView.initView( self )

	if _G.g_CFunOpenManager ~= nil then
		_G.g_CFunOpenManager:closeNoticView()
		_G.g_CFunOpenManager:resetNoticView()
	end

	self:loadResources()

	local entranceType = tonumber(self.guideNode:getAttribute("in_type") )
	local entranceId   = tonumber(self.guideNode:getAttribute("in_id")  )
	local arrowDir = tonumber(self.guideNode:getAttribute("dir")) --箭头方向
	local arrowStr = self.guideNode:getAttribute("description")   --箭头的内容提示

	self:createNextGuideInScene(entranceType,entranceId,arrowDir,arrowStr)

end

--进入下一个指引
function CGuideView.goNextGuide( self, _parent )

	if _G.g_CFunOpenManager ~= nil then
		_G.g_CFunOpenManager:closeNoticView()
		_G.g_CFunOpenManager:resetNoticView()
	end

	print("CGuideView.goNextGuide  idx="..self.guideIdx,_parent)
	local parent = _parent --or self.preParent
	if parent ~= nil then
		self:createGuideLayer( parent, true )
		-- parent = _G.g_Stage:getScene() --CCDirector : sharedDirector() : getRunningScene()
	else
		self:removeNowGuide()
	end


	self.guideIdx = self.guideIdx + 1

	if self.guideIdx > self.guideNode:children():get(0,"guidss"):children():getCount("guids") then
		--指引结束
		_G.pCGuideManager:guideFinish()
		return
	end

	local nextStepNode = self.guideNode:children():get(0,"guidss"):children():get(self.guideIdx-1,"guids")--:getAttribute("")  guids[self.guideIdx]

	self:loadResources()

	local entranceType = tonumber(nextStepNode:getAttribute("in_type"))
	if entranceType == 0 then
		-- self:createGuideLayer( parent, true )
		self:createNextGuideByRect( nextStepNode )
	else
		-- if entranceType == _G.Constant.CONST_NEW_GUIDE_COPY_TIPS_ENTER then
		-- 	self:createGuideLayer( parent, false )
		-- else
			-- self:createGuideLayer( parent, true )
		-- end
		local entranceId = tonumber(nextStepNode:getAttribute("in_id"))
		local arrowDir   = tonumber(nextStepNode:getAttribute("dir"))   --箭头方向
		local arrowStr   = nextStepNode:getAttribute("content")         --箭头的内容提示
		self:createNextGuideInScene( entranceType,entranceId,arrowDir,arrowStr,_parent  )
	end
end

--根据场景的npc 按钮 显示指引
function CGuideView.createNextGuideInScene( self, _entranceType, _entranceId, _arrowDir, _arrowStr, _parent )

	local entranceType = tonumber( _entranceType )
	local entranceId   = tonumber( _entranceId )
	local arrowDir     = tonumber( _arrowDir )
	local arrowStr     = _arrowStr

	if entranceType == nil or entranceId == nil or arrowDir == nil or arrowStr == nil then
		_G.pCGuideManager:guideFinish()
		--CCMessageBox( "CGuideView createNextGuideInScene", "参数为空" )
        CCLOG("codeError!!!! CGuideView createNextGuideInScene 参数为空")
		return
	end

	if entranceType == _G.Constant.CONST_NEW_GUIDE_NPC then
		--点击NPC   获取npc obj
		local npc    = _G.pCGuideManager:getNowSceneNpcById( entranceId )

		if npc == nil then
			print( "createNextGuideInScene ---> 找不到npc" )
			_G.pCGuideManager:guideFinish()
			return
		elseif npc:getCollider() == nil then
			print( "createNextGuideInScene ---> npc:getCollider() 为空" )
			_G.pCGuideManager:guideFinish()
			return
		end

		local npcPos = _G.pCGuideManager:getNpcPosById( entranceId )
		-- node     = npc:getMovieClip()
		-- nodeSize = CCSizeMake( tonumber(npc:getCollider().vWidth) + 30, tonumber(npc:getCollider().vHeight) + 50 )

		node     = _G.g_Stage.m_lpMapContainer
		nodeSize = CCSizeMake( tonumber(npc:getCollider().vWidth) + 30, tonumber(npc:getCollider().vHeight) + 50 )

		local ContainerX, ContainerY = _G.g_Stage.m_lpContainer : getPosition()
		local player  = _G.g_Stage :getPlay()
		local playPosX,playPosY = player : getLocationXY()
		local nX = ContainerX + npcPos.x
		if nX > self.m_winSize.width then
			player :setMovePos( ccp( npcPos.x,playPosY ) )
		elseif nX < 0 then
			player :setMovePos( ccp( npcPos.x,playPosY ) )
		end

		print( "-----ContainerX="..ContainerX,"   ContainerY="..ContainerY,"   playPosX="..playPosX,"   playPosY="..playPosY )

		self:createGuideLayer( node, false )
		-- nodePos = ccp(  0, npc:getCollider().vHeight/2+8 )

		nodePos = ccp(  npcPos.x, npcPos.y + npc:getCollider().vHeight/2+8 )

		self:createJumpGuideBtn( _G.pCGuideManager:getSysOpenBtn(), 2 )

	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_PUSH_BUTTON then
		--点击主场景其他按钮 获取按钮 obj

		if entranceId == _G.Constant.CONST_FUNC_OPEN_FUNTION then
			--功能键
			-- _G.pCGuideManager:setSysMeneStatus( false )

			node = _G.pCGuideManager:getSysOpenBtn()
			if node == nil then
				_G.pCGuideManager:guideFinish()
				return
			end
			-- local parent    = node:getParent()
			-- local posX,posY = node:getPosition()
			-- nodePos = parent:convertToWorldSpace( ccp( posX,posY ) )

			self : createGuideLayer( node, false )
			nodePos = ccp( 0, 0 )

		elseif entranceId == _G.Constant.CONST_FUNC_OPEN_TASK_GUIDE then
			--任务指引按钮
			node = _G.pCGuideManager:getTaskGuideBtn()
			if node == nil then
				_G.pCGuideManager:guideFinish()
				return
			end

			if node:isVisible() == false then
				--打开任务指引按钮
				_G.pCGuideManager:guideFinish()
				return
			end

			self:createGuideLayer( node, false )
			nodePos = ccp( 0, 0 )
		else
			--其他按钮
			node = _G.pCGuideManager:getMainSceneOpenIcon( entranceId )
			if node == nil then
				_G.pCGuideManager:guideFinish()
				return
			end
			node : setZOrder( 10 )
			self : createGuideLayer( node, false )
			nodePos = ccp( 0, 0 )
		end

		nodeSize = node:getPreferredSize()

		self:createJumpGuideBtn( _G.pCGuideManager:getSysOpenBtn(), 2 )
		-- nodeSize   = CCSizeMake( size.width+5,size.height+5 )
		print( "点击其他按钮  ",nodePos.x,nodePos.y )
	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_COPY_TIPS_ENTER then
		--副本tips进入按钮
		local btn = _G.pDuplicatePromptView:getBtnByTag( 201 )

		if btn == nil then
			--CCMessageBox( "副本tips进入按钮为空 或者隐藏了","提示" )
            CCLOG("codeError!!!! 副本tips进入按钮为空 或者隐藏了")
			_G.pCGuideManager:guideFinish()
			return
		end

		self : createGuideLayer( btn, false )

		nodeSize = btn:getPreferredSize()
		nodePos    = ccp( 0,0 )

		self:createJumpGuideBtn( btn )

	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_COPY_TIPS_HANGUP then
		--副本tips挂机按钮
		print("_G.Constant.CONST_NEW_GUIDE_COPY_TIPS_HANGUP   ")
		local btn = _G.pDuplicatePromptView:getBtnByTag( 204 )

		if btn == nil then
			CCMessageBox( "副本tips挂机按钮为空 或者隐藏了","提示" )
            CCLOG("codeError!!!! 副本tips挂机按钮为空 或者隐藏了")
			_G.pCGuideManager:guideFinish()
			return
		end

		self : createGuideLayer( btn, false )

		nodeSize = btn:getPreferredSize()
		nodePos    = ccp( 0,0 )

		self:createJumpGuideBtn( btn )

	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_GOOD_TIPS_USE then
		local btn = _G.g_PopupView :getButtonBtTag( 101 )
		if btn == nil then
			--CCMessageBox( "找不到tips使用按钮","提示" )
            CCLOG("codeError!!!! 找不到tips使用按钮")
			_G.pCGuideManager:guideFinish()
			return
		end
		btn  : setZOrder( 20 )
		self : createGuideLayer( btn, false )
		nodeSize = btn:getPreferredSize()
		nodePos  = ccp( 0,0 )

		self:createJumpGuideBtn( btn )

	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_BAG_GOOD_BUTTON then
		if _G.g_CBackpackPanelView ~= nil then
			local goodsBtn = _G.g_CBackpackPanelView:getGoodsBtnById( entranceId )
			if goodsBtn == nil then
				--CCMessageBox("找不到此物品!","新手指引")
                CCLOG("codeError!!!! 找不到此物品 新手指引")
				_G.pCGuideManager:guideFinish()
				return
			end

			local goodsBtnPosition = goodsBtn:convertToWorldSpace(ccp(0,0))
			nodeSize = goodsBtn:getPreferredSize()
			nodePos  = goodsBtnPosition
		else
			--CCMessageBox("_G.g_CBackpackPanelView == nil   背包没打开","新手指引")
            CCLOG("codeError!!!! _G.g_CBackpackPanelView == nil   背包没打开 新手指引")
			_G.pCGuideManager:guideFinish()
			return
		end

		self:createJumpGuideBtn( btn )
	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_HANGUP_BUTTON then
		--挂机按钮
		-- if _parent == nil then
		-- 	_G.pCGuideManager :guideFinish()
		-- 	--CCMessageBox( "挂机按钮为空","提示" )
  --           CCLOG("codeError!!!! 挂机按钮为空")
		-- 	return
		-- end

		-- _parent  : setZOrder( 20 )
		-- nodePos  = ccp( 0, 0 )
		-- nodeSize = _parent:getPreferredSize()

		-- self:createJumpGuideBtn( _parent )

		if _G.g_CHangupView ~= nil then
			local btn = _G.g_CHangupView:getHangupBtn()
			if btn == nil then
				--CCMessageBox( "副本tips进入按钮为空 或者隐藏了","提示" )
	            CCLOG("codeError!!!! 挂机按钮为空 或者隐藏了")
				_G.pCGuideManager:guideFinish()
				return
			end

			self : createGuideLayer( btn, false )

			nodeSize = btn:getPreferredSize()
			nodePos    = ccp( 0,0 )

			self:createJumpGuideBtn( btn )
		else
			_G.pCGuideManager :guideFinish()
			--CCMessageBox( "挂机按钮为空","提示" )
            CCLOG("codeError!!!! 挂机按钮为空")
			return
		end
	elseif entranceType == _G.Constant.CONST_NEW_GUIDE_SPEED_BUTTON then
		--加速按钮
		if _G.g_CHangupView ~= nil then
			local btn = _G.g_CHangupView:getSpeedBtn()
			if btn == nil then
				--CCMessageBox( "副本tips进入按钮为空 或者隐藏了","提示" )
	            CCLOG("codeError!!!! 加速按钮为空 或者隐藏了")
				_G.pCGuideManager:guideFinish()
				return
			end

			self : createGuideLayer( btn, false )

			nodeSize = btn:getPreferredSize()
			nodePos    = ccp( 0,0 )

			self:createJumpGuideBtn( btn )
		else
			_G.pCGuideManager :guideFinish()
			--CCMessageBox( "挂机按钮为空","提示" )
            CCLOG("codeError!!!! 加速按钮为空")
			return
		end

	end

    self.m_touchRectSpr= self :createGuideSpr( nodeSize )
	local guideArrow   = self :createArrow( arrowDir, arrowStr )
	local arrowSize    = guideArrow:getPreferredSize()

	self.m_mainContainer : addChild( self.m_touchRectSpr, 1, CGuideView.TAG_RECT )
	self.m_mainContainer : addChild( guideArrow, 1, CGuideView.TAG_ARROW )

	local arrowPos = self:getArrowPos( nodePos, nodeSize, arrowDir, arrowSize )--{}

	self.m_touchRectSpr : setPosition( ccp( nodePos.x, nodePos.y ) )
	guideArrow   : setPosition( ccp( arrowPos.x, arrowPos.y ) )

	self.m_entranceType = entranceType
	self.m_entranceId   = entranceId


end

--根据xml定义的区域 位置 显示指引
function CGuideView.createNextGuideByRect( self, _guidsNode )

    local sprSize    = CCSizeMake( tonumber(_guidsNode:getAttribute("rule_w")), tonumber(_guidsNode:getAttribute("rule_l")) )
    self.m_touchRectSpr = self :createGuideSpr( sprSize )
	local guideArrow = self :createArrow( _guidsNode:getAttribute("dir"), _guidsNode:getAttribute("content") )
	local arrowSize  = guideArrow :getPreferredSize()
	local _winSize   = CCDirector:sharedDirector():getVisibleSize()
	local mainSize   = CCSizeMake( 854, 640 )
	local nWidth     = _winSize.width/2-854/2
	local arrowDir   = tonumber( _guidsNode:getAttribute("dir") )
	local nodeSize   = self.m_touchRectSpr:getPreferredSize()

	self.m_mainContainer : addChild( self.m_touchRectSpr, 1, CGuideView.TAG_RECT )
	self.m_mainContainer : addChild( guideArrow, 1, CGuideView.TAG_ARROW )

	-- local nodePos  = ccp( _guidsNode:getAttribute("rule_w")rule_x + sprSize.width/2+nWidth, _guidsNode:getAttribute("rule_w")rule_y+sprSize.height/2 )
	local nodePos  = ccp( _guidsNode:getAttribute("rule_x") + _winSize.width/2 + nodeSize.width/2 , _guidsNode:getAttribute("rule_y") + _winSize.height/2 + nodeSize.height/2 )
	local arrowPos = self:getArrowPos( nodePos, nodeSize, arrowDir, arrowSize )

	print("--------------createNextGuideByRect--?>",nodePos.x,nodePos.y,arrowPos.x,arrowPos.y)

	self.m_touchRectSpr : setPosition( nodePos )
	guideArrow : setPosition( ccp(arrowPos.x,arrowPos.y) )
	-- guideArrow   : setPosition( ccp( _guidsNode:getAttribute("rule_w")x+arrowSize.width/2+nWidth, _guidsNode:getAttribute("rule_w")y+arrowSize.height/2 ) )

	self.m_entranceType = tonumber( _guidsNode:getAttribute("in_type") )
	self.m_entranceId   = tonumber( _guidsNode:getAttribute("in_id") )

	self:createJumpGuideBtn()

end

function CGuideView.getArrowPos( self, _nodePos, _nodeSize, _dir, _arrowSize )
	local arrowDir = tonumber( _dir )
	local arrowPos = {}
	if arrowDir == _G.Constant.CONST_NEW_GUIDE_LEFT then
		arrowPos.x = _nodePos.x + _nodeSize.width/2 + _arrowSize.width/2 + 10
		arrowPos.y = _nodePos.y
	elseif arrowDir == _G.Constant.CONST_NEW_GUIDE_RIGHT then
		arrowPos.x = _nodePos.x - _nodeSize.width/2 - _arrowSize.width/2 - 10
		arrowPos.y = _nodePos.y
	elseif arrowDir == _G.Constant.CONST_NEW_GUIDE_UP then
		arrowPos.x = _nodePos.x
		arrowPos.y = _nodePos.y - _nodeSize.height/2 - _arrowSize.height/2 - 10
	elseif arrowDir == _G.Constant.CONST_NEW_GUIDE_DOWN then
		arrowPos.x = _nodePos.x
		arrowPos.y = _nodePos.y + _nodeSize.height/2 + _arrowSize.height/2 + 10
	else
		--CCMessageBox( "表的方向错了",arrowStr )
        CCLOG("codeError!!!! 表的方向错了"..arrowStr)
		arrowPos.x = _nodePos.x
		arrowPos.y = _nodePos.y + _nodeSize.height/2 + _arrowSize.height/2 + 10
	end
	return arrowPos
end

--创建箭头以及内容
function CGuideView.createArrow( self, _dir, _str )

	print(" createArrow 111 ",_dir,_str)

	local dir = tonumber(_dir)
	local wordPos   = {}
	local arrowName = ""
	if dir == _G.Constant.CONST_NEW_GUIDE_LEFT then
		arrowName = "guide_arrow_left.png"
		wordPos.x = 20
		wordPos.y = 0
	elseif dir == _G.Constant.CONST_NEW_GUIDE_RIGHT then
		arrowName = "guide_arrow_right.png"
		wordPos.x = -20
		wordPos.y = 0
	elseif dir == _G.Constant.CONST_NEW_GUIDE_UP then
		arrowName = "guide_arrow_up.png"
		wordPos.x = 0
		wordPos.y = -20
	elseif dir == _G.Constant.CONST_NEW_GUIDE_DOWN then
		arrowName = "guide_arrow_down.png"
		wordPos.x = 0
		wordPos.y = 20
	else
		--CCMessageBox( "表的方向错了",_str )
        CCLOG("codeError!!!! 表的方向错了".._str)
		arrowName = "guide_arrow_down.png"
		wordPos.x = 0
		wordPos.y = 20
	end

	local float = 255.0
	local higth = 1.8
	local guideArrow = CSprite:createWithSpriteFrameName(arrowName)
	-- guideArrow : shaderMulColor( higth * float, higth * float, higth * float, 1.0* float )
	local act    = CCMoveBy:create(0.5, ccp( -wordPos.x, -wordPos.y ))
	local _array = CCArray :create()
	_array :addObject( act )
	_array :addObject( act :reverse(), 0.5)
    --guideArrow:runAction( CCRepeat:create(CCSequence :create( _array ), -1) )
    guideArrow:runAction( CCRepeatForever:create(CCSequence :create( _array )) )

    local arrowSize  = guideArrow:getPreferredSize()
    local guideLabel = CCLabelTTF :create( _str,"Arial",22)
    guideLabel : setColor( CGuideView.FONT_COLOR )
    -- guideLabel : setPosition( ccp( wordPos.x+arrowSize.width/2, wordPos.y+arrowSize.height/2 ) )
    guideLabel : setPosition( ccp( wordPos.x, wordPos.y ) )
    guideArrow : addChild( guideLabel,10 )

    return guideArrow
end

--创建点击区域
function CGuideView.createGuideSpr( self, _size )
	local float = 255.0
	local higth = 1.8
	local sprite = CSprite :createWithSpriteFrameName("guide_frame.png")--,CCRectMake(19,19,1,1) )
	-- sprite : shaderMulColor(  higth * float, higth * float, higth * float, 1.0 * float  )
    sprite : setControlName( "this CGuideView sprite 39 ")
	sprite : setPreferredSize( _size )

	-- local _duration = 0.3
	-- local act1   = CCScaleTo:create(_duration, 1.01)
	-- local act2   = CCScaleTo:create(_duration, 0.97)
	-- local _array = CCArray :create()
	-- _array :addObject( act1 )
	-- _array :addObject( act2 )
	-- sprite:runAction( CCRepeatForever:create(CCSequence :create( _array )) )

	return sprite
end

--创建跳过指引按钮
function CGuideView.createJumpGuideBtn( self, _node, _type )

	if self.m_jumpButton ~= nil then
		print("createJumpGuideBtn    !!!!!")
		self.m_jumpButton : removeFromParentAndCleanup( true )
	end

	self.m_jumpButton = CSprite:createWithSpriteFrameName("general_button_click.png")
	self.m_jumpButton : setControlName( "this CGuideView self.m_jumpButton 352 " )

	-- if self.m_aaaaaaaa == nil then
	-- 	self.m_aaaaaaaa = 1
	-- end
	local strLabel = CCLabelTTF:create( "跳过指引","Arial",22 )--..self.m_aaaaaaaa
	self.m_jumpButton : addChild( strLabel )

	-- self.m_aaaaaaaa = self.m_aaaaaaaa + 1

	local jumpBtnSize= self.m_jumpButton:getPreferredSize()
	-- local self.m_jumpButton = self:createJumpGuideBtn()

	if _type == 2 then
		--加到层上
		_node : addChild( self.m_jumpButton, 1, CGuideView.TAG_JUMP )
	else
		self.m_mainContainer : addChild( self.m_jumpButton, 1, CGuideView.TAG_JUMP )
	end

	if _node then
		--加到节点上
		local worldPos = _node:convertToWorldSpace( ccp(0,0) )
		print("createJumpGuideBtn-->  nodePos.x="..nodePos.x.."   nodePos.y="..nodePos.y.."   worldPos.x="..worldPos.x.."   worldPos.y="..worldPos.y)

		local btnPos
		if _type == 1 then
			--加到NPC中
			local ContainerX, ContainerY = _G.g_Stage.m_lpContainer : getPosition()
			btnPos = ccp( ContainerX-worldPos.x+jumpBtnSize.width/2, -worldPos.y + 240 )
		else
			btnPos = ccp( -worldPos.x+jumpBtnSize.width/2, -worldPos.y + 240 )
		end

		self.m_jumpButton : setPosition(btnPos)
	else
		--加到场景中
		self.m_jumpButton : setPosition( ccp( jumpBtnSize.width/2, 240 ) )
	end

end

function CGuideView.getNowGuideIdx( self )
	return self.guideIdx
end


--创建屏蔽的Container  CTouchContainer
function CGuideView.createGuideLayer( self, _parent, _isCopyLayer )

	local function local_fullScreenTouchCallBack( eventType, obj, x , y )
		print("local_fullScreenTouchCallBack  touch 1212 ",eventType)
		return self :fullScreenTouchCallBack( eventType, obj, x , y )
	end

	print("CGuideView.createGuideLayer---->")--,debug.traceback())

	if _parent == nil then
		_G.pCGuideManager:guideFinish()
		return
	end

	self:removeGuideLayer()

	-- if _parent.getControlName ~= nil then
	-- 	print("createGuideLayer-----> ControlName = ".._parent:getControlName())
	-- 	if _parent:getParent() ~= nil then
	-- 		print("createGuideLayer----->  _parent:getParent() ~= nil ")
	-- 	end
	-- else
	-- 	print("createGuideLayer-----> ControlName = RunningScene")
	-- end


	self.m_guideLayer = CTouchContainer :create()
    self.m_guideLayer : setControlName( " this is CGuideView self.m_guideLayer 164" )
    self.m_guideLayer : setTouchesEnabled( true )
    self.m_guideLayer : setTouchesPriority( CGuideView.LAYER_PRI )
    self.m_guideLayer : registerControlScriptHandler(local_fullScreenTouchCallBack,"this is CGuideView self.m_guideLayer 462")


    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( " this is CGuideView self.m_mainContainer 164" )
    self.m_guideLayer : addChild( self.m_mainContainer )

    self.m_copyGuideLayer    = self.m_guideLayer
    self.m_copyMainContainer = self.m_mainContainer



	-- if _isCopyLayer then
		-- self.preParent = _parent

		-- if self.preParent:getParent() ~= nil then
		-- 	local node = self.preParent:getParent()
		-- 	self.preParent : removeFromParentAndCleanup( true )
		-- 	node :addChild( self.preParent, 2000 )
		-- end
	-- end

	_parent : addChild( self.m_guideLayer, CGuideView.LAYER_ZOrder )



end

--清楚屏蔽的Container
function CGuideView.removeGuideLayer( self )

	-- print("CGuideView.removeGuideLayer---->",debug.traceback())
	print("CGuideView.removeGuideLayer   111")
	if self.m_guideLayer ~= nil then
		print("CGuideView.removeGuideLayer   222")

		if self.m_jumpButton ~= nil then
			print("CGuideView.removeGuideLayer   333")
			self.m_jumpButton : removeFromParentAndCleanup( true )
			self.m_jumpButton = nil
		end

		self.m_guideLayer : removeFromParentAndCleanup( true )
		self.m_guideLayer = nil
		self.m_mainContainer = nil
	end

end
--无效
function CGuideView.setGuideLayerNil( self )
	self.m_guideLayer = nil
	self.m_mainContainer = nil
end
--清楚箭头以及点击区域
function CGuideView.removeNowGuide( self )
	print("removeNowGuide---- 111")
	if self.m_mainContainer ~= nil then
		print("removeNowGuide---- 222")
		if self.m_mainContainer:getChildByTag( CGuideView.TAG_RECT ) then
			print("removeNowGuide---- 333")
			self.m_mainContainer:removeChildByTag( CGuideView.TAG_RECT )
		end
		if self.m_mainContainer:getChildByTag( CGuideView.TAG_ARROW ) then
			print("removeNowGuide---- 444")
			self.m_mainContainer:removeChildByTag( CGuideView.TAG_ARROW )
		end
		-- self.m_mainContainer : removeAllChildrenWithCleanup( false )
		-- self.m_mainContainer : removeFromParentAndCleanup( true )
		-- self.m_mainContainer = nil
	end
end

--初始化变量
function CGuideView.initParment( self, _guideNode )
	self.guideNode = _guideNode
	self.guideIdx  = 0

	self.m_entranceType = 0
	self.m_entranceId   = 0

end

function CGuideView.init( self, _guideNode )
	self:initParment( _guideNode )
	self:initView()
end

function CGuideView.layer( self, _guideNode, _parent )

	self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
    self:createGuideLayer( _parent, true )
    self:init( _guideNode )

    return self.m_guideLayer
end

function CGuideView.loadResources( self )
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("GuideResources/GuideResources.plist")
end






---------------------------
--点击事件
---------------------------
--屏蔽点击事件
function CGuideView.fullScreenTouchCallBack(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		if self.m_mainContainer ~= nil then
			if self.m_jumpButton ~= nil then
				local touchRectObj = self.m_mainContainer:getChildByTag( CGuideView.TAG_RECT )
				if self.m_jumpButton:containsPoint(self.m_jumpButton:convertToNodeSpaceAR(ccp(x,y))) then

					self.m_jumpButton:removeFromParentAndCleanup( true )
					self.m_jumpButton = nil
					_G.pCGuideManager:guideFinish()
				elseif touchRectObj ~= nil then
					local node = touchRectObj
					if node.containsPoint == nil then
						node = self.m_touchRectSpr
						print("艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹  111")
						if node.containsPoint == nil then
							-- node = self.m_touchRectSpr
							print("艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹艹  222")
						end
					end
					if node:containsPoint(node:convertToNodeSpaceAR(ccp(x,y))) then
						CCLOG( "Go Next Guide!  < guideId="..self.guideNode:getAttribute("id").."   index="..self.guideIdx.." >" )
						if self.m_entranceType == _G.Constant.CONST_NEW_GUIDE_PUSH_BUTTON and self.m_entranceId == _G.Constant.CONST_FUNC_OPEN_FUNTION then
							--点击功能键 延迟进入下一步
							self:removeNowGuide()
							self:setTimeAndCDTime(0,0.5)
						else
							if self.guideIdx > 0 then
								local state = tonumber(self.guideNode:children():get(0,"guidss"):children():get(self.guideIdx-1,"guids"):getAttribute("special")) or 1
								if state == _G.Constant.CONST_NEW_GUIDE_SPECIAL_GOBACK then
									self:setTimeAndCDTime(0,0.5)
								else
									self:thisStepFinish()
								end
							else
								self:thisStepFinish()
							end
							-- self:removeNowGuide()
							-- self:setTimeAndCDTime(0,0.15)

						end
						return false
					end
				end
			end
		end
		print("新手指引  拦截")
		return true
	elseif eventType == "Enter" then

		if self.m_guideLayer == nil then
			self.m_guideLayer = self.m_copyGuideLayer
		end

		if self.m_mainContainer == nil then
			self.m_mainContainer = self.m_copyMainContainer
		end

	elseif eventType == "Exit" then

		self.m_guideLayer = nil
		self.m_mainContainer = nil

	end
end

--点中了 点击区域
function CGuideView.thisStepFinish( self )
	print("thisStepFinish------------->>>>>>> self.guideIdx",self.guideIdx)
	_G.pCGuideManager:thisGuideStepTouch( self.guideIdx )
end







---------------------------
--时间管理
---------------------------
function CGuideView.registerEnterFrameCallBack(self)
    print( "CGuideView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset()
        self :updataResetTime( _duration)
    end
    self.m_guideLayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CGuideView.updataResetTime( self, _duration)
    if self.m_nowTime == nil or self.m_nowTime < 0 then
        return
    end

    self.m_nowTime = self.m_nowTime + _duration

    if self.m_nowTime > self.m_cdTime then
    	self:thisStepFinish()
    	self.m_guideLayer : unscheduleUpdate()
    end
end

function CGuideView.setTimeAndCDTime( self, _time, _CDTime )
	self.m_nowTime = _time
	self.m_cdTime  = _CDTime

	if self.m_guideLayer ~= nil then
		self:registerEnterFrameCallBack()
	end
end
