--*********************************
--2013-8-12 by 陈元杰
--翻翻乐主界面-CFurinkazanView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/FurinkazanMediator"
require "view/LuckyLayer/PopBox"

CFurinkazanView = class(view, function(self)
	CFurinkazanView.readgiftxml = nil
end)

----------------------------
--常量
----------------------------
--tag 值
CFurinkazanView.TAG_START     = 201
CFurinkazanView.TAG_GETREWARD = 202
CFurinkazanView.TAG_EXCHANGE  = 203
CFurinkazanView.TAG_CLOSE     = 204

--颜色
CFurinkazanView.RED   = ccc3(255,0,0,255)
CFurinkazanView.GOLD  = ccc3(255,255,0,255)
CFurinkazanView.GREEN = ccc3(120,222,66,255)

--动画常量
CFurinkazanView.TIME_CD   = 0.1
CFurinkazanView.TIMES     = 12

CFurinkazanView.ACTION_YES  = 1
CFurinkazanView.ACTION_NO   = 2

function CFurinkazanView.initView( self, _mainSize )
	----------------------------
	--活动背景  关闭按钮
	----------------------------

	self.m_mainBG = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBG : setControlName( "this CFurinkazanView self.m_mainBG 36 ")
	self.m_mainBG : setPreferredSize( CCDirector:sharedDirector():getVisibleSize() )
	self.m_scenelayer : addChild( self.m_mainBG )

	self.m_allContainer = CContainer :create()
    self.m_allContainer : setControlName( "this is CFurinkazanView self.m_allContainer 41" )
    self.m_scenelayer     : addChild( self.m_allContainer)

	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CFurinkazanView self.m_background 45 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_allContainer : addChild( self.m_background )

	local function local_btnTouchCallback(eventType,obj,x,y)
		--按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	self.m_topImg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_topImg : setControlName( "this CFurinkazanView self.m_topImg 55 ")
    self.m_topImg : setPreferredSize( CCSizeMake( 823, 238 ) )
	self.m_allContainer : addChild( self.m_topImg )

	self.m_downImg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_downImg : setControlName( "this CFurinkazanView self.m_downImg 60 ")
    self.m_downImg : setPreferredSize( CCSizeMake( 823, 360 ) )
	self.m_allContainer : addChild( self.m_downImg )

	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this CFurinkazanView self.m_closeBtn 65 ")
	self.m_closeBtn   :setTag( CFurinkazanView.TAG_CLOSE )
	self.m_closeBtn   :registerControlScriptHandler( local_btnTouchCallback, "this CFurinkazanView self.m_closeBtn 67 ")
	self.m_allContainer :addChild( self.m_closeBtn )

	----------------------------
	--主ConTianer 
	----------------------------
	self : initMainContainer()

    ----------------------------
	--活动介绍
	----------------------------
	self.m_nocitContainer = CContainer :create()
    self.m_nocitContainer : setControlName( "this is CFurinkazanView self.m_nocitContainer 79" )
    self.m_allContainer     : addChild( self.m_nocitContainer)

	self.m_titleImg = CSprite :createWithSpriteFrameName("ffl_word_ffljlgz.png")
    self.m_titleImg : setControlName( "this CFurinkazanView self.m_titleImg 83 ")
	self.m_nocitContainer : addChild( self.m_titleImg )

	local cellSize = CCSizeMake( 300, 28 )
	self.m_noticLayout = CVerticalLayout:create()
	self.m_noticLayout : setCellSize( cellSize )
	self.m_noticLayout : setCellHorizontalSpace(40)
	self.m_noticLayout : setCellVerticalSpace(5)
	self.m_noticLayout : setLineNodeSum(2)
	self.m_noticLayout : setColumnNodeSum(5)
	self.m_noticLayout : setHorizontalDirection(false)
	self.m_noticLayout : setVerticalDirection(false)
	self.m_nocitContainer : addChild( self.m_noticLayout )
	
	local nodeList  = _G.Config.flsh_reward :selectSingleNode("flsh_rewards[0]"):children()
	local nodeCount = nodeList:getCount("flsh_reward")
	local iCount = 1
	for i=1, nodeCount-1, 1 do
		local node = nodeList : get(i,"flsh_reward")
		local name = node : getAttribute("reward_name") or "表有问题"
		if name == "三张相同带一对" then
			name = "三带一对"
		elseif name == "风林火山" then
			name = "一二四五"
		end
    	local typeLabel   = CCLabelTTF :create( iCount.."、"..name, "Arial", 20)
		--多少美刀奖励
		local goldLabel   = CCLabelTTF :create( "奖励 : "..node:getAttribute("renown").." 声望", "Arial", 20)

		typeLabel : setHorizontalAlignment( kCCTextAlignmentLeft )
		typeLabel : setDimensions( cellSize )
		goldLabel : setAnchorPoint( ccp( 0,0.5 ) )
		goldLabel : setPosition( ccp( 145, 14) )
		typeLabel : addChild( goldLabel )
		self.m_noticLayout : addChild( typeLabel)

		iCount = iCount + 1
	end

	--当天剩余次数
	self.m_surplusTitle   = CCLabelTTF :create( "今天剩余次数 ".. self.m_surplusTimes .." 次", "Arial", 20)
	self.m_surplusTitle   : setColor( CFurinkazanView.GOLD )
	self.m_nocitContainer : addChild( self.m_surplusTitle )

end

--玩法的Container 开始前游戏界面
function CFurinkazanView.initMainContainer( self )

	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	local function local_btnTouchCallback(eventType,obj,x,y)
		--按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	if self.m_mainContainer ~= nil then 
		self.m_mainContainer : removeFromParentAndCleanup( true )
		self.m_mainContainer = nil
	end

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CFurinkazanView self.m_mainContainer 135" )
    self.m_allContainer    : addChild( self.m_mainContainer)


	--开始游戏按钮
	self.m_startBtn = CButton :createWithSpriteFrameName( "开始游戏", "general_button_normal.png")
	self.m_startBtn :setControlName( "this CFurinkazanView self.m_startBtn 141 ")
    self.m_startBtn :setFontSize( 24)
    self.m_startBtn :setTag( CFurinkazanView.TAG_START )
    self.m_startBtn :registerControlScriptHandler( local_btnTouchCallback, "this CFurinkazanView self.m_startBtn 144 ")
    self.m_mainContainer :addChild( self.m_startBtn )

    --卡牌的背面图片
    self :createCardLayout()

    self.m_cardBgList = {}
    for i=1,5 do
    	self.m_cardBgList[i] = CSprite :createWithSpriteFrameName("ffl_cards_back.png")
	    self.m_cardBgList[i] : setControlName( "this CFurinkazanView self.m_cardBgList[i] 152 ")
		self.m_cardLayout : addChild( self.m_cardBgList[i] )
    end
	
end

function CFurinkazanView.createCardLayout(self)

	local cellSize = CCSizeMake( 139, 198 )
	self.m_cardLayout = CHorizontalLayout:create()
	self.m_cardLayout : setCellSize( cellSize )
	self.m_cardLayout : setCellHorizontalSpace(20)
	self.m_cardLayout : setCellVerticalSpace(1)
	self.m_cardLayout : setLineNodeSum(5)
	self.m_cardLayout : setColumnNodeSum(1)
	self.m_mainContainer : addChild( self.m_cardLayout )
	self.m_cardLayout   :setPosition(      35, 250 )

end

--加载资源
function CFurinkazanView.loadResources(self)
	--加载图片资源
	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("FurinkazanResources/FurinkazanResources.plist")

	--加载xml 
    self :loadXmlData()
end

function CFurinkazanView.unloadResources(self)
	--删除图片资源缓存

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("FurinkazanResources/FurinkazanResources.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("FurinkazanResources/FurinkazanResources.pvr.ccz")

    _G.g_unLoadIconSources:unLoadCreateResByName( "FurinkazanResources/Furinkazan_checkBox1.png" )
    _G.g_unLoadIconSources:unLoadCreateResByName( "FurinkazanResources/Furinkazan_checkBox2.png" )

    --删除xml缓存
    self :unloadXmlData()
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CFurinkazanView.layout(self, _mainSize)
	local _winSize    = CCDirector:sharedDirector():getVisibleSize()

	self.m_mainBG 		: setPosition(ccp( _winSize.width/2, _winSize.height/2 ))
	self.m_allContainer :setPosition(ccp( _winSize.width/2 - _mainSize.width/2,0 ))
	
	----------------------------
	--活动背景
	----------------------------
	self.m_background  : setPosition(ccp(_mainSize.width*0.5,_mainSize.height*0.5))
	local closeBtnSize = self.m_closeBtn :getContentSize()
	self.m_closeBtn	   : setPosition(ccp(_mainSize.width-closeBtnSize.width/2,_mainSize.height-closeBtnSize.height/2)) 

	self.m_topImg  : setPosition(ccp(_mainSize.width*0.5, 506))
	self.m_downImg : setPosition(ccp(_mainSize.width*0.5, 197))
	----------------------------
	--主ConTianer 
	----------------------------
	self : mainContainerLayout()

	----------------------------
	--活动介绍
	----------------------------
	self.m_surplusTitle : setAnchorPoint( ccp( 0,0.5) ) --当天剩余次数Label
	self.m_surplusTitle : setPosition(ccp( 645 , 52)) 
	self.m_titleImg   	: setPosition(ccp( 122 , 597 )) -- "评分规则" Label

	self.m_noticLayout   :setPosition(      37, 567 )

end

--玩法的Container(游戏开始前)  布局 Layout
function CFurinkazanView.mainContainerLayout( self )
	local _winSize    = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize   = CCSizeMake( 854, _winSize.height )
	self.m_startBtn   : setPosition(ccp( 425 , 80))  --开始游戏按钮
end

--初始化数据成员
function CFurinkazanView.initParams( self, _times, _is_get)
	--剩余次数
	self.m_surplusTimes = _times

	--注册Mediator
    _G.pCFurinkazanMediator = CFurinkazanMediator(self)
    controller :registerMediator(_G.pCFurinkazanMediator)--先注册后发送 否则会报错    

    if _is_get == 0 then 
    	--有未领取的奖励时,还原成之前的信息 重新请求开始游戏
    	self :sendStartMessage()
    end

    self.m_actionType = CFurinkazanView.ACTION_NO
end

--释放成员
function CFurinkazanView.realeaseParams( self)
	--反注册Mediator
    if _G.pCFurinkazanMediator ~= nil then
		controller :unregisterMediator(_G.pCFurinkazanMediator)
		_G.pCFurinkazanMediator = nil
	end

end

function CFurinkazanView.init(self, _mainSize, _times, _is_get)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams( _times, _is_get)
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function CFurinkazanView.scene(self, _times, _is_get)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenelayer = CCScene:create()
	self:init( _mainSize, _times, _is_get )
	return self.m_scenelayer
end


--*****************
--读取xml数据
--*****************
function CFurinkazanView.loadXmlData( self )

    _G.Config :load( "config/flsh_reward.xml")

end

function CFurinkazanView.unloadXmlData( self )

    _G.Config :unload( "config/flsh_reward.xml")

end

function CFurinkazanView.showSureBox( self, _msg )

	local surebox  = CErrorBox()
    local BoxLayer = surebox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)

end



--************************
--按钮回调
--************************
--关闭 开始游戏 换牌 领取奖励 按钮 单击回调
function CFurinkazanView.btnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			if tag == CFurinkazanView.TAG_CLOSE then
				self :realeaseParams()
				CCDirector:sharedDirector():popScene()

				self:unloadResources()

				self:unlockScene()


			elseif tag == CFurinkazanView.TAG_START then
				--开始游戏
				print("开始游戏啦")
				if self.m_surplusTimes > 0 then 
					self.m_actionType = CFurinkazanView.ACTION_YES
					self :sendStartMessage()
				else
					self:showSureBox( "今天没有剩余次数了")
				end



            elseif tag == CFurinkazanView.TAG_EXCHANGE then
				--换牌
				if self.m_surplusChangeTimes >= tonumber(_G.Constant.CONST_FLSH_FREE_SWITCH_TIMES) then 
					local function buyChangeCallBack( )
						local mainProperty = _G.g_characterProperty : getMainPlay()
			            local nDiamond     = mainProperty :getRmb() + mainProperty :getBindRmb()
			            if nDiamond >= _G.Constant.CONST_FLSH_CHANGE_RMB_USE then 
			            	self.m_actionType = CFurinkazanView.ACTION_YES
			            	-- self.m_surplusChangeTimes = self.m_surplusChangeTimes + 1
		            		self :sendExchuangeMessage()
			            else 
			            	self:showSureBox( "钻石不足，充值可获得钻石！")
			            end
			        end
			        --确认框
			        local useMoney = (self.m_surplusChangeTimes-_G.Constant.CONST_FLSH_FREE_SWITCH_TIMES+1)*_G.Constant.CONST_FLSH_CHANGE_RMB_USE
			        self.PopBox = CPopBox() --初始化
	                self.m_buyChangeBoxLayer = self.PopBox : create(buyChangeCallBack,"花费"..useMoney.."钻石换一次牌",0)
	                self.m_buyChangeBoxLayer : setPosition(-20,0)
	                self.m_scenelayer        : addChild(self.m_buyChangeBoxLayer)
				else 
					self.m_surplusChangeTimes = self.m_surplusChangeTimes + 1
					self :sendExchuangeMessage()
				end


	
			elseif tag == CFurinkazanView.TAG_GETREWARD then 
				--领取奖励啦
				self.m_actionType = CFurinkazanView.ACTION_NO
				self :sendGetReWardMessage()
			end
		end
		
	end
end

--选择卡牌
function CFurinkazanView.selectCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			print("选择卡牌->",tag)
			if obj :getChecked() then 
				--选中
				self.m_chuangeDiceInfo[tonumber(tag)].select = 1
				self.m_selectNum = self.m_selectNum + 1 
				self.m_exchangeBtn   :setTouchesEnabled( true )
			else 
				--没选中
				self.m_chuangeDiceInfo[tonumber(tag)].select = 0
				self.m_selectNum = self.m_selectNum - 1
				if self.m_selectNum == 0 then 
					self.m_exchangeBtn   :setTouchesEnabled( false )
				end
			end
		end
	end
end

--选择卡牌 (矩形区域单击)
function CFurinkazanView.selectBgCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			print("选择卡牌->",tag)
			if self.m_checkBox[tag] :getChecked() then 
				--之前选中  现在为不选中
				self.m_checkBox[tag] :setChecked(false)
				self.m_chuangeDiceInfo[tonumber(tag)].select = 0
				self.m_selectNum = self.m_selectNum - 1
				if self.m_selectNum == 0 then 
					self.m_exchangeBtn   :setTouchesEnabled( false )
				end
			else 
				--之前为没选中  现在为选中
				self.m_checkBox[tag] :setChecked(true)
				self.m_chuangeDiceInfo[tonumber(tag)].select = 1
				self.m_selectNum = self.m_selectNum + 1 
				self.m_exchangeBtn   :setTouchesEnabled( true )
			end
		end
	end
end





--************************
--发送协议
--************************
--请求游戏开始
function CFurinkazanView.sendStartMessage( self )
	require "common/protocol/auto/REQ_FLSH_GAME_START"
	local msg = REQ_FLSH_GAME_START()
	CNetwork : send( msg )
end

--领取奖励
function CFurinkazanView.sendGetReWardMessage( self )
	require "common/protocol/auto/REQ_FLSH_GET_REWARD"
	local msg = REQ_FLSH_GET_REWARD()
	CNetwork : send( msg )
end

--换牌
function CFurinkazanView.sendExchuangeMessage( self )

	local data   = {}
	local iCount = 1
	--得到所有被选中的卡牌的位置
	for i,v in ipairs(self.m_chuangeDiceInfo) do
		if v.select == 1 then 
			data[iCount] = v.pos
			iCount 	     = iCount + 1
		end
	end
	--发送协议
	if #data > 0 then 
		require "common/protocol/REQ_FLSH_PAI_SWITCH"
		local msg = REQ_FLSH_PAI_SWITCH()
		msg : setCount( tonumber(self.m_selectNum) )
		msg : setData( data )
		CNetwork : send( msg )
	end

end

--请求剩余次数
function CFurinkazanView.sendSurplusTimesMessage( self )
	require "common/protocol/auto/REQ_FLSH_TIMES_REQUEST" --[50210]    请求剩余次数 - 翻翻乐
    local msg3 = REQ_FLSH_TIMES_REQUEST()
    CNetwork : send( msg3 )
end

--锁屏
function CFurinkazanView.lockScene( self )
	--锁住屏幕
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
    	CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end
end
--解锁屏幕
function CFurinkazanView.unlockScene( self )
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end
end


--************************
--mediator控制的方法
--************************
function CFurinkazanView.createStartAction( self, _isStart )

	------------------------------------------
	--  _isStart : true   <开始游戏,背面翻到正面>
	--  _isStart : false  <结束游戏,正面翻到背面>
	------------------------------------------

	--锁屏
	self:lockScene()

	local function local_actionEnd()

		--解锁屏幕
		self:unlockScene()

		if _isStart then
			self :removeMainContainerChild() -- 清除主Container的所有孩子
			self :addCardView( self.m_diceData )       -- 加载界面
		else
			self :sendSurplusTimesMessage() --请求剩余次数 ,ActivityMediator接受 更新数据(状态:已领取) 以及更改剩余次数
			self.m_surplusTimes = self.m_surplusTimes - 1 -- 剩余次数减一
			self :initMainContainer()   -- 初始化主Container
			self :mainContainerLayout() -- 布局主Container的孩子
			self :resetSurplusLabel()   -- 刷新当天可玩的剩余次数

			self.m_chuangeDiceInfo = nil --清除骰子的信息(是否选中)
		end
	end

	local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
        	if _isStart then
        		--背面翻到正面
            	arg0 : play( "run" )
            else
            	--正面翻到背面
            	local tag = self.m_cardBgList[self.m_ccbiIdx] : getTag()
            	local num = self.m_chuangeDiceInfo[tag].num
            	arg0 : play( "run"..tostring(num) )

            	self.m_ccbiIdx = self.m_ccbiIdx + 1
            	if self.m_ccbiIdx == 5 then
            		self.m_ccbiIdx = 1
            	end
            end
        elseif eventType == "AnimationComplete" then

        	--删除CCBI
        	local tag = self.m_ccbiList[self.m_ccbiIdx]:getTag()
        	self.m_ccbiList[self.m_ccbiIdx] : removeFromParentAndCleanup( true )

        	if self.m_ccbiIdx == 5 then
        		self.m_ccbiIdx = 1
        		local_actionEnd()
        	else
        		self.m_ccbiIdx = self.m_ccbiIdx + 1
        	end
        end
    end

    local ccbiName
    if _isStart then
    	ccbiName = "CharacterMovieClip/effects_ffl1.ccbi"
    else
    	ccbiName = "CharacterMovieClip/effects_ffl2.ccbi"
    end

    self.m_ccbiList = {}
    self.m_ccbiIdx  = 1
	if self.m_cardBgList ~= nil then
		for i,v in ipairs(self.m_cardBgList) do
			
			if _isStart then
				v:setImageWithSpriteFrameName( "transparent.png" )
			else
				v:removeAllChildrenWithCleanup( true )
			end

			self.m_ccbiList[i] = CMovieClip:create( ccbiName )
		    self.m_ccbiList[i] : setControlName( "this CFurinkazanView self.m_ccbiList[i] 84")
		    self.m_ccbiList[i] : setTag( i )
		    self.m_ccbiList[i] : registerControlScriptHandler( animationCallFunc )
		    v : addChild( self.m_ccbiList[i], 10 )
		end
	end

end

--请求游戏开始 返回
function CFurinkazanView.statdCallBackForMediator( self, _times, _data )

	--保存当前骰子信息(服务器发过来的)
	self.m_diceData = _data

	self.m_surplusChangeTimes = _times
	self :sendSurplusTimesMessage() --请求剩余次数 ,ActivityMediator接收 更新数据(状态:未领取)

	self.m_actionDiceData = self :getChangeDiceList( _data ) -- 获取需要播放动画的骰子信息
	self :cleanCheckInfo() -- 清除选中信息

	if self.m_chuangeDiceInfo == nil then
		--重新开始游戏 或者 加载上次玩的信息
		self:createStartAction(true)
		return
	else
		--换牌返回
		self.m_getRewardBtn : setTouchesEnabled( false )
		self :setTime( 0 )
	end

	
end

--领取奖励 返回
function CFurinkazanView.getRewardCallBackForMediator( self, _id )
	----领取成功 
	print("-----------getRewardCallBackForMediator-------------")

	local function local_finishEnd()
		self:createStartAction( false )
	end

	local function local_finish()
		--延迟显示ccbi
		if self.m_allContainer ~= nil then
			--锁屏
			self:lockScene()
			self.m_allContainer : performSelector( 0.3, local_finishEnd )
		else
			local_finishEnd()
		end
	end

	if _id ~= nil then 
		print("id=".._id)
		local rewardNode = _G.Config.flsh_reward :selectSingleNode("flsh_rewards[0]/flsh_reward[@id="..tostring(_id).."]")
		if rewardNode :isEmpty() == false then 
			local reward = rewardNode:getAttribute("renown")
			local name   = rewardNode:getAttribute("reward_name")
			if name == "三张相同带一对" then
				name = "三带一对"
			elseif name == "风林火山" then
				name = "一二四五"
			end

			local surebox  = CErrorBox()
		    local BoxLayer = surebox : create( name.."! 获得声望 "..reward ,local_finish )
		    self.m_scenelayer : addChild(BoxLayer,1000)

			-- self:showSureBox( )
		else
			self:showSureBox( "出错!找不到节点")
		end
	else
		self:showSureBox( "出错!领取ID为空")
	end

end





--刷新剩余次数
function CFurinkazanView.resetSurplusLabel( self )

	if self.m_surplusTimes == 0 then 
		if self.m_mainContainer :getChildByTag(CFurinkazanView.TAG_START) then 
			self.m_startBtn :setTouchesEnabled( false )
		end
	end

	self.m_surplusTitle :setString( "今天剩余次数 ".. self.m_surplusTimes .." 次" )
end

--清楚主Container 的所有控件
function CFurinkazanView.removeMainContainerChild( self )
	if self.m_mainContainer ~= nil then 
		self.m_mainContainer :removeAllChildrenWithCleanup( true )
	end
end



--玩法的Container 开始后游戏界面
function CFurinkazanView.addCardView( self, _data )
	-- 
	local function local_btnTouchCallback(eventType,obj,x,y)
		-- 领取奖励 换牌按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	local function local_selectCallback(eventType,obj,x,y)
		-- 选择(checkBox) 回调
		return self:selectCallback(eventType,obj,x,y)
	end

	local function local_selectBgCallback(eventType,obj,x,y)
		-- 选择(矩形区域) 回调
		return self:selectBgCallback(eventType,obj,x,y)
	end

	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	self.m_getRewardBtn	 = CButton :createWithSpriteFrameName( "领取奖励", "general_button_normal.png")
	self.m_getRewardBtn  :setControlName( "this CFurinkazanView self.m_getRewardBtn 514 ")
	self.m_getRewardBtn  :setTag( CFurinkazanView.TAG_GETREWARD )
	self.m_getRewardBtn  :setFontSize(24)
	self.m_getRewardBtn  :registerControlScriptHandler( local_btnTouchCallback, "this CFurinkazanView self.m_getRewardBtn 517 ")
	self.m_mainContainer :addChild( self.m_getRewardBtn )

	self.m_exchangeBtn	 = CButton :createWithSpriteFrameName( "换牌", "general_button_normal.png")
	self.m_exchangeBtn   :setControlName( "this CFurinkazanView self.m_exchangeBtn 521 ")
	self.m_exchangeBtn   :setTag( CFurinkazanView.TAG_EXCHANGE )
	self.m_exchangeBtn   :setFontSize(24)
	self.m_exchangeBtn   :setTouchesEnabled( false )
	self.m_exchangeBtn   :registerControlScriptHandler( local_btnTouchCallback, "this CFurinkazanView self.m_exchangeBtn 525 ")
	self.m_mainContainer :addChild( self.m_exchangeBtn )

	self.m_exchangLabel  = CCLabelTTF :create( "(注 : 需要换牌请点击卡牌)", "Arial", 20)
	self.m_exchangLabel  : setAnchorPoint( ccp( 0,0.5 ) )
	self.m_mainContainer : addChild( self.m_exchangLabel )

	local cellSize = CCSizeMake( 139, 198 )
	self :createCardLayout()

	self.m_chuangeDiceInfo = {} -- 记录卡牌点数信息 点数,位置,是否选中
	self.m_selectNum  = 0  -- 记录被选中的卡牌总数量
	self.m_checkBox   = {} -- 每个卡牌的CheckBox
	self.m_diceNumImg = {}

	self.m_cardBgList = {}
	for i,v in ipairs(_data) do
		print(i,v.num,v.pos)

		self.m_chuangeDiceInfo[i] = {}
		local diceNum = v.num
		if self.m_actionType == CFurinkazanView.ACTION_YES then
			--有动画效果的话  默认初始骰子点数为 1
			diceNum = 1
		end

		--牌的背景
		self.m_cardBgList[i] = CButton :createWithSpriteFrameName( "","transparent.png" )
		self.m_cardBgList[i] : setControlName( "this CFurinkazanView self.m_cardBgList[i] 546 ")
		self.m_cardBgList[i] : registerControlScriptHandler( local_selectBgCallback, "this CFurinkazanView self.m_cardBgList[i] 549")
		self.m_cardBgList[i] : setPreferredSize( cellSize )
		self.m_cardBgList[i] : setTag( v.pos )
		self.m_cardLayout : addChild( self.m_cardBgList[i] , 0)

		self.m_diceNumImg[v.pos] = CSprite :createWithSpriteFrameName("ffl_cards_0"..diceNum..".png")
    	self.m_diceNumImg[v.pos] : setControlName( "this CFurinkazanView self.m_diceNumImg[v.pos] 546 ")
		self.m_diceNumImg[v.pos] : setTag( v.pos )
		self.m_cardBgList[i] : addChild( self.m_diceNumImg[v.pos] , 0)

		self.m_checkBox[v.pos] = CCheckBox :create("FurinkazanResources/Furinkazan_checkBox1.png","FurinkazanResources/Furinkazan_checkBox2.png","")
		self.m_checkBox[v.pos] : setControlName( "this CFurinkazanView self.m_checkBox[i] 553 ")
		self.m_checkBox[v.pos] : setTag( v.pos )
		self.m_checkBox[v.pos] : registerControlScriptHandler( local_selectCallback, "this CFurinkazanView self.m_checkBox[i] 555")
		self.m_checkBox[v.pos] : setPosition( ccp( 0, -cellSize.height/2 - 32 ) )

		self.m_cardBgList[i] : addChild( self.m_checkBox[v.pos] , 3 )

		self.m_chuangeDiceInfo[v.pos].num    = v.num
		self.m_chuangeDiceInfo[v.pos].pos    = v.pos
		self.m_chuangeDiceInfo[v.pos].select = 0
	end

	self.m_getRewardBtn :setPosition( ccp( 355, 52 ) )
	self.m_exchangeBtn  :setPosition( ccp( 495, 52 ) )
	self.m_exchangLabel :setPosition( ccp( 38 , 52 ) )

	local function goDiceAction()
		self :setTime( 0 )
	end

	if self.m_actionType == CFurinkazanView.ACTION_YES then
		--有动画效果 
		self.m_getRewardBtn : setTouchesEnabled( false )
		
		if self.m_allContainer ~= nil then
			self.m_allContainer:performSelector( 0.3, goDiceAction )
		else
			goDiceAction()
		end
	end

end

--清除选中的信息
function CFurinkazanView.cleanCheckInfo( self )

	if self.m_chuangeDiceInfo == nil then
		return
	end

	for i,v in ipairs(self.m_chuangeDiceInfo) do
		v.select = 0
		self.m_checkBox[v.pos] :setChecked( false ) --不选中
	end

	self.m_selectNum   = 0 --记录被选中的卡牌总数量
	self.m_exchangeBtn : setTouchesEnabled( false ) --换牌 按钮不可按
end

--获得需要动画效果的骰子列表
function CFurinkazanView.getChangeDiceList( self, _data )

	local data = {}

	if self.m_chuangeDiceInfo ~= nil then

		local iCount = 1
		for i,v in ipairs(self.m_chuangeDiceInfo) do
			if v.select == 1 then 
				for k,vv in ipairs(_data) do
					print(v.pos,vv.pos)
					if v.pos == vv.pos then
						data[iCount] = vv
						iCount = iCount + 1
						break
					end
				end
			end
		end

		return data

	else
		return _data
	end
end

--显示最终的骰子点数
function CFurinkazanView.setRealDiceBg( self )
	local diceData = self.m_actionDiceData
	for i,v in ipairs(diceData) do
		self.m_diceNumImg[v.pos] : setImageWithSpriteFrameName( "ffl_cards_0"..v.num..".png" )
	end

	self.m_getRewardBtn : setTouchesEnabled( true )

	print("-----------self.m_diceData(正确骰子)-----------")
	for i,v in ipairs(self.m_diceData) do
		print("位置:"..v.pos,"点数:"..v.num)
	end
	print("-----------self.m_diceData(正确骰子)-----------")

end

--显示随机的骰子点数
function CFurinkazanView.resetAllDiceBgByRandow( self )

	local diceData = self.m_actionDiceData
	for i,v in ipairs(diceData) do
		local random = self:getRandNumber()
		self.m_diceNumImg[v.pos] : setImageWithSpriteFrameName( "ffl_cards_0"..random..".png" )
	end
end

--æææææææææææææææææææææææææææææææææææææææ
--时间控制 
--æææææææææææææææææææææææææææææææææææææææ
function CFurinkazanView.registerEnterFrameCallBack(self)
    print( "CFurinkazanView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset(	) 
        self :updataResetTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

--反注册时间回调
function CFurinkazanView.realeaseTimes( self )
	self.m_scenelayer : unscheduleUpdate()

	self :unlockScene()
end

--时间控制 主函数
function CFurinkazanView.updataResetTime( self, _duration)
    if self.m_nowTime == nil or self.m_nowTime < 0 then
        return
    end

    self.m_nowTime   = self.m_nowTime + _duration
    local chuangTime = self.m_nowTime/self.m_currentTimes

    if chuangTime > CFurinkazanView.TIME_CD then
    	if self.m_currentTimes <= CFurinkazanView.TIMES then
    		self :resetAllDiceBgByRandow()
    		self.m_currentTimes = self.m_currentTimes + 1
    	else
    		print("updataResetTime    unlockScene")
    		self :setRealDiceBg()
    		self :realeaseTimes()
    	end
    end
end


--设置时间
function CFurinkazanView.setTime( self, _time)
    self.m_nowTime  	= _time
    self.m_currentTimes = 1

    --注册时间回调
    self :registerEnterFrameCallBack()

    print("updataResetTime    lockScene")
    self :lockScene()
end

--获得 1~6 的随机数
function CFurinkazanView.getRandNumber( self )
	local nState = 1
	local nEnd   = 6
	local tm

    tm={math.random(nState,nEnd),math.random(nState,nEnd)}
    return tm[2];
end

