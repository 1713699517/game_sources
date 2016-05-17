require "view/view"
require "proxy/ChatDataProxy"
require "common/Constant"
require "common/protocol/REQ_CHAT_NAME"
require "common/protocol/REQ_CHAT_SEND"
require "common/protocol/REQ_CHAT_GOODS_LIST"
require "common/WordFilter"

require "view/VindictivePanelLayer/VindictivePopupView"
require "view/Stage/TouchPlayView"	

CChatView = class(view, function(self)
	self.m_ShowChannelID = _G.Constant.CONST_CHAT_ALL	--全部
	self.m_ChannelID = _G.Constant.CONST_CHAT_WORLD	--世界频道
	self.m_goodcount = 0
	self.m_goodinfo = {}--REQ_CHAT_GOODS_LIST()
	self.m_isShow   = false
end)

CChatView.ACTION_TEAM_POSTED  = "BuildTeamAction"
CChatView.ACTION_CLICK_ROLE   = "ClickRoleAction"
CChatView.ACTION_CLICK_SYS_ROLE   = "ClickSysRoleAction"
CChatView.ACTION_CLICK_GOOD   = "ClickGoodAction"
CChatView.ACTION_CLICK_DOUQI  = "ClickDouQiAction"

CChatView.World_Time_JianGe = 5

function CChatView.initView( self, _container, _mainSize )
	self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CChatView self.m_background 14 ")
	self.m_background:setPreferredSize( self.m_winSize )
	_container:addChild( self.m_background )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CChatView self.m_mainContainer 53" )
    _container    : addChild( self.m_mainContainer)

	self.m_lpTouchPlayContainer     = CContainer :create() --查看信息层
    self.m_lpTouchPlayContainer : setControlName( "this is CChatView self.m_lpTouchPlayContainer 53" )
    _container    : addChild( self.m_lpTouchPlayContainer)

	self.m_mainground = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_mainground : setControlName( "this CChatView self.m_mainground 14 ")
	self.m_mainground:setPreferredSize( _mainSize )
	self.m_mainContainer:addChild( self.m_mainground )

	self.m_channelLayout = CHorizontalLayout:create()
	self.m_channelLayout:setCellSize(CCSizeMake(127,10))
	self.m_channelLayout:setCellHorizontalSpace(2)
	self.m_channelLayout:setCellVerticalSpace(1)
	self.m_channelLayout:setLineNodeSum(100)
	self.m_channelLayout:setColumnNodeSum(100)
	self.m_mainContainer:addChild( self.m_channelLayout )

	local function local_onSwitchChannelTouched(eventType,obj,x,y)
		return self:onSwitchChannelTouched(eventType,obj,x,y)
	end

	local color_white = ccc4( 255,255,255,255 )
	local fontSize    = 24

	self.m_channel_All = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_All"),"general_label_normal.png")
    self.m_channel_All : setControlName( "this CChatView self.m_channel_All 30 " )
    self.m_channel_All : setColor(color_white)
    self.m_channel_All : setFontSize(fontSize)
	self.m_channel_All:setTag(_G.Constant.CONST_CHAT_ALL)
	self.m_channel_All:registerControlScriptHandler(local_onSwitchChannelTouched, "this CChatView self.m_channel_All 33")
	self.m_channelLayout:addChild( self.m_channel_All )

	self.m_channel_World = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_World"),"general_label_normal.png")
    self.m_channel_World : setControlName( "this CChatView self.m_channel_World 36 " )
    self.m_channel_World : setColor(color_white)
    self.m_channel_World : setFontSize(fontSize)
	self.m_channel_World:setTag(_G.Constant.CONST_CHAT_WORLD)
	self.m_channel_World:registerControlScriptHandler(local_onSwitchChannelTouched, "this CChatView self.m_channel_World 39")
	self.m_channelLayout:addChild( self.m_channel_World )

	self.m_channel_Guild = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_Clan"),"general_label_normal.png")
    self.m_channel_Guild : setControlName( "this CChatView self.m_channel_Guild 42 " )
    self.m_channel_Guild : setColor(color_white)
    self.m_channel_Guild : setFontSize(fontSize)
	self.m_channel_Guild:setTag(_G.Constant.CONST_CHAT_CLAN)
	self.m_channel_Guild:registerControlScriptHandler(local_onSwitchChannelTouched, "this CChatView self.m_channel_Guild 45")
	self.m_channelLayout:addChild( self.m_channel_Guild )

	self.m_channel_Team = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_Team"),"general_label_normal.png")
    self.m_channel_Team : setControlName( "this CChatView self.m_channel_Team 48 " )
    self.m_channel_Team : setColor(color_white)
    self.m_channel_Team : setFontSize(fontSize)
	self.m_channel_Team:setTag(_G.Constant.CONST_CHAT_TEAM)
	self.m_channel_Team:registerControlScriptHandler(local_onSwitchChannelTouched, "this CChatView self.m_channel_Team 51")
	-- self.m_channelLayout:addChild( self.m_channel_Team ) -- 去掉组队聊天

	self.m_channel_Private = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_PM"),"general_label_normal.png")
    self.m_channel_Private : setControlName( "this CChatView self.m_channel_Private 54 " )
    self.m_channel_Private : setColor(color_white)
    self.m_channel_Private : setFontSize(fontSize)
	self.m_channel_Private:setTag(_G.Constant.CONST_CHAT_PM)
	self.m_channel_Private:registerControlScriptHandler(local_onSwitchChannelTouched, "this CChatView self.m_channel_Private 57")
	self.m_channelLayout:addChild( self.m_channel_Private )

	self :setChannelIdHighLight( _G.Constant.CONST_CHAT_ALL )

	--关闭按钮
	local function local_onCloseBtnTouched(eventType, obj, x, y)
		return self:onCloseBtnTouched(eventType, obj, x, y)
	end
	self.m_closeBtn = CButton:createWithSpriteFrameName("","general_close_normal.png")
    self.m_closeBtn : setControlName( "this CChatView self.m_closeBtn 65 " )
	self.m_closeBtn:registerControlScriptHandler(local_onCloseBtnTouched, "this CChatView self.m_closeBtn 67")
	self.m_mainContainer:addChild(self.m_closeBtn)

	--背景

	self.m_ChatBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_ChatBackground : setControlName( "this CChatView self.m_ChatBackground 73 ")
	self.m_mainContainer:addChild( self.m_ChatBackground )
	self.m_NameBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_NameBackground : setControlName( "this CChatView self.m_NameBackground 76 ")
	self.m_mainContainer:addChild( self.m_NameBackground )
	self.m_SentenceBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_SentenceBackground : setControlName( "this CChatView self.m_SentenceBackground 79 ")
	self.m_mainContainer:addChild( self.m_SentenceBackground )

	--显示RichText
	local function m_RichTextBoxCallBack(eventType, action, arg1, arg2)
		return self:RichTextBoxCallBack(eventType, action, arg1, arg2)
	end
	self.m_RichTextBox = CRichTextBox:create(CCSizeMake( 800, 450), ccc4(0,0,0,0))
	self.m_RichTextBox:setAutoScrollDown(true)
	self.m_RichTextBox:retain()
	self.m_RichTextBox:setTouchesPriority(-25)
	self.m_RichTextBox:setTouchesEnabled(true)
	self.m_mainContainer:addChild( self.m_RichTextBox )


	--输入人名
	local _edit1Bg = CCScale9Sprite:create("transparent.png")
	self.m_NameEditBox = CEditBox:create( CCSizeMake(160,58), _edit1Bg, 12, "/"..CLanguageManager:sharedLanguageManager():getString("Chat_EditBox_Normal"), kEditBoxInputFlagSensitive)
	self.m_NameEditBox : setFont( "Arial",23)
	self.m_NameEditBox : setFontColor( color_white )
	self.m_RichTextBox : setTouchesEnabled(true)
	self.m_RichTextBox:registerControlScriptHandler(m_RichTextBoxCallBack,"this CChatView m_RichTextBox m_RichTextBoxCallBack") --jun 2013.10.09
	self.m_mainContainer:addChild( self.m_NameEditBox )
	self.m_NameEditBox : setTextString("/"..CLanguageManager:sharedLanguageManager():getString("Chat_Button_World"))
	self.m_NameEditBox : setEditBoxMaxLength( 20 )
	--输入字符 kEditBoxInputFlagInitialCapsWord
	local _edit2Bg = CCScale9Sprite:create("transparent.png")
	self.m_SentenceEditBox = CEditBox:create( CCSizeMake(510,58), _edit2Bg, 50, "", kEditBoxInputFlagSensitive)
	self.m_SentenceEditBox : setFont( "Arial",23)
	self.m_SentenceEditBox : setFontColor( color_white )
	self.m_mainContainer:addChild( self.m_SentenceEditBox )
	self.m_SentenceEditBox : setEditBoxMaxLength( 50 )
	--发送按钮
	local function local_onSendBtnTouched(eventType, obj, x, y)
		return self:onSendBtnTouched(eventType, obj, x, y)
	end
	self.m_sendBtn = CButton:createWithSpriteFrameName(CLanguageManager:sharedLanguageManager():getString("Chat_Button_Send"),"general_button_normal.png")
    self.m_sendBtn : setControlName( "this CChatView self.m_sendBtn 110 " )
    self.m_sendBtn : setColor(color_white)
    self.m_sendBtn : setFontSize(fontSize)
	self.m_sendBtn:registerControlScriptHandler(local_onSendBtnTouched, "this CChatView self.m_sendBtn 115")
	self.m_mainContainer:addChild(self.m_sendBtn)

end

function CChatView.loadResources(self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("General.plist");
end

function CChatView.layout(self, _mainSize)
	--布局
	self.m_channelLayout:setPosition(28,595)
	local closeBtnSize = self.m_closeBtn:getPreferredSize()
	self.m_closeBtn:setPosition( ccp(_mainSize.width - closeBtnSize.width / 2, _mainSize.height - closeBtnSize.height / 2 ))
	self.m_background:setPosition( ccp(self.m_winSize.width/2, self.m_winSize.height/2) )
	self.m_mainContainer:setPosition( ccp( self.m_winSize.width/2-_mainSize.width/2, 0) )
	self.m_mainground   :setPosition( ccp(_mainSize.width/2, _mainSize.height/2) )
	--聊天背景
	self.m_ChatBackground:setPreferredSize( CCSizeMake( 825, 475 ))
	self.m_ChatBackground:setPosition( _mainSize.width/2 , (_mainSize.height - 475/2-75) )

	--名字背景	
	self.m_NameBackground:setPreferredSize( CCSizeMake( 160 , 58))
	self.m_NameBackground:setPosition( 95 , 50)
	--输入框背景
	self.m_SentenceBackground:setPreferredSize( CCSizeMake( 510, 58))
	self.m_SentenceBackground:setPosition( 442  , 50)

	--发送按钮
	self.m_sendBtn:setPosition( ccp(_mainSize.width - self.m_sendBtn:getPreferredSize().width / 2 - 22 ,50) )

	--名字输入框
	self.m_NameEditBox:setPosition( ccp(97, 50))
	--输入框
	self.m_SentenceEditBox:setPosition( ccp(444, 50))
	--聊天内容框
	self.m_RichTextBox:setPosition( ccp( (854-800)/2, _mainSize.height - 88))
end

function CChatView.init(self, _container, _mainSize)
	-- self:loadResources()
    _G.g_WordFilter :initialize()       --过滤聊天内容初始化
	self:initView(_container, _mainSize)
	self:layout(_mainSize)
	self:setChannelId(self.m_ShowChannelID)
	self:initParams()
end

function CChatView.scene(self)
	self.m_winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, self.m_winSize.height )
	local _scene = CCScene:create()
	self:init(_scene, _mainSize)
	return _scene
end

function CChatView.setChannelIdHighLight(self, _nChannelID )
	if self.m_hightlightSpr ~= nil then
		self.m_hightlightSpr :removeFromParentAndCleanup( true)
		self.m_hightlightSpr = nil
	end

	local btn = self.m_channelLayout:getChildByTag( _nChannelID )
	if btn ~= nil then
		self.m_hightlightSpr = CSprite :createWithSpriteFrameName( "general_label_click.png")
		btn :addChild( self.m_hightlightSpr , 1)	
	end
end


function CChatView.onSwitchChannelTouched(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		self : removeTouchPlayContainerChild()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			local nChannelId = obj:getTag()
			if nChannelId ~= _G.Constant.CONST_CHAT_PM then
				self.m_NameEditBox:setTextString("")
			end

			self :setChannelIdHighLight( nChannelId )

			if nChannelId == self.m_ShowChannelID then
				return
			end

			if nChannelId == _G.Constant.CONST_CHAT_ALL or
				nChannelId == _G.Constant.CONST_CHAT_SYSTEM then
				self.m_ChannelID = _G.Constant.CONST_CHAT_WORLD
			else
				self.m_ChannelID = nChannelId
			end
			self.m_ShowChannelID = nChannelId
			--切换面板
			self:setChannelId( nChannelId )

			--切换按钮效果
			--[[
			if nChannelId == _G.Constant.CONST_CHAT_ALL then
				self.m_channel_All:setDark()
			elseif nChannelId == _G.Constant.CONST_CHAT_WORLD then
				self.m_channel_World:setDark()
			elseif nChannelId == _G.Constant.CONST_CHAT_CLAN then
				self.m_channel_Guild:setDark()
			elseif nChannelId == _G.Constant.CONST_CHAT_TEAM then
				self.m_channel_Team:setDark()
			elseif nChannelId == _G.Constant.CONST_CHAT_PM then
				self.m_channel_Private:setDark()
			end]]
		end
	end
end

function CChatView.onSendBtnTouched(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
	    _G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		local strString = self.m_SentenceEditBox:getTextString()
		if strString == nil or string.len(strString) == 0 then
			return
		end
		local strName = self.m_NameEditBox:getTextString()
        print("strName", strName, self.m_SentenceEditBox:getTextString())
		if strName ~= nil and string.len(strName) > 0 and self.m_ChannelID == _G.Constant.CONST_CHAT_PM then
			self:sendMessage( strName, self :filterWordByString( self.m_SentenceEditBox:getTextString() ) )
		else
			print("_G.g_ServerTime:getChatJTime()  ==".._G.g_ServerTime:getChatJTime())
			if self.m_ChannelID == _G.Constant.CONST_CHAT_WORLD or self.m_ChannelID == _G.Constant.CONST_CHAT_ALL then
				if _G.g_ServerTime:getChatJTime() > CChatView.World_Time_JianGe then
					self:sendMessage( self.m_ChannelID, self :filterWordByString( self.m_SentenceEditBox:getTextString() ) )
					_G.g_ServerTime:resetChatJTime()
				else
					--时间 间隔没到  不能发送
					self :onReceiverOffline("世界发言间隔为 "..CChatView.World_Time_JianGe.." 秒!  ["..(CChatView.World_Time_JianGe - _G.g_ServerTime:getChatJTime() + 1).."秒后可以继续发言]")
					return
				end
			else
				self:sendMessage( self.m_ChannelID, self :filterWordByString( self.m_SentenceEditBox:getTextString() ) )
			end

		end
		self.m_SentenceEditBox:setTextString("")
	end
end

function CChatView.filterWordByString( self, _strWord )   
    _strWord = _G.g_WordFilter :replaceBanWord( tostring( _strWord ) )
    return _strWord
end

function CChatView.onCloseBtnTouched(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
	    _G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if _G.pChatMediator ~= nil then
			controller:unregisterMediator( _G.pChatMediator )
			_G.pChatMediator = nil
		end
        _G.g_WordFilter :destory()
		_G.pChatView = nil
		CCDirector:sharedDirector():popScene()
	end
end


function CChatView.initParams( self )
	self.m_uid 			= _G.g_LoginInfoProxy :getUid()
	self.m_mainProperty = _G.g_characterProperty :getOneByUid( tonumber( self.m_uid ), _G.Constant.CONST_PLAYER)
end


--发送普通消息
function CChatView.sendMessage(self, _varChannel, _szMessage)

	if self.m_ChannelID == _G.Constant.CONST_CHAT_CLAN then
		if self.m_mainProperty:getClan() == nil or self.m_mainProperty:getClan() == 0 then
			self :onReceiverOffline("你未加入社团")
			return
		end
		print("getClan="..self.m_mainProperty:getClan())
	elseif self.m_ChannelID == _G.Constant.CONST_CHAT_TEAM then
		if self.m_mainProperty:getTeamID() == self.m_mainProperty:getUid() then
			self :onReceiverOffline("你未加入队伍")
			return
		end
	end

	if self.m_ChannelID == _G.Constant.CONST_CHAT_PM and type(_varChannel) == "string" then
		--私聊
		local _pMsg = REQ_CHAT_NAME()
		_pMsg:setName( _varChannel )
		_pMsg:setMsg( _szMessage )
		_pMsg:setGoodsCount(0)
		CNetwork:send( _pMsg )
	else
		--频道发送
		print("我输出一下下给你看看",_varChannel,_szMessage)
		local _pMsg2 = REQ_CHAT_SEND()
		_pMsg2:setChannelId(tonumber(_varChannel))
		_pMsg2:setArg_type(_G.Constant.CONST_CHAT_GOODS)
		_pMsg2:setUid(0)
		_pMsg2:setGoodsCount( self.m_goodcount)
		_pMsg2:setGoodsList( self.m_goodinfo)
		_pMsg2:setTeamId(0)
		_pMsg2:setCopyId(0)
		_pMsg2:setMsg( _szMessage )
		CNetwork:send( _pMsg2 )
		-- self.m_CurrentName = nil
	end
	--炫耀处理
	if self.m_isShow == true then 
		self.m_isShow   = false
		self.m_goodcount = 0
		self.m_goodinfo = {}
	end
end


function CChatView.sendItem(self)
	-- body
end


function CChatView.setChannelId( self, _nChannelId )
	print("切换面板", _nChannelId)
	self.m_nChannelId = _nChannelId
	self.m_RichTextBox:clearAll()
	local tabList = _G.g_ChatDataProxy:getList(_nChannelId)
	for i,v in ipairs(tabList) do
		self:autoArchiveMessage( v )
	end

	if _nChannelId == _G.Constant.CONST_CHAT_PM then
		print("currentname", self.m_CurrentName)
		if self.m_CurrentName == nil or self.m_CurrentName == "" then
			self.m_NameEditBox:setTextString("")
		else
			self.m_NameEditBox:setTextString(self.m_CurrentName)
		end
	elseif _nChannelId == _G.Constant.CONST_CHAT_WORLD or _nChannelId == _G.Constant.CONST_CHAT_ALL then
		self.m_NameEditBox:setTextString("/"..CLanguageManager:sharedLanguageManager():getString("Chat_Button_World"))
	elseif _nChannelId == _G.Constant.CONST_CHAT_CLAN then
		self.m_NameEditBox:setTextString("/"..CLanguageManager:sharedLanguageManager():getString("Chat_Button_Clan"))
	elseif _nChannelId == _G.Constant.CONST_CHAT_TEAM then
		self.m_NameEditBox:setTextString("/"..CLanguageManager:sharedLanguageManager():getString("Chat_Button_Team"))
	end
end

function CChatView.autoArchiveMessage(self, _vo_data)
	print("autoArchiveMessage[[[[[[[[[[[[[[[[[[---", debug.traceback() )
	if self.m_ShowChannelID ~= _G.Constant.CONST_CHAT_ALL and _vo_data:getChannelId() ~= self.m_ShowChannelID then
		return
	end
    if _vo_data :getMsgType() == 0 then
        if #_vo_data:getItemList() == 0 then
            self:onReceivedMessage( _vo_data) --( _vo_data:getChannelId(), _vo_data:getUserName(), _vo_data:getUid(), _vo_data:getReceiverUserName(), _vo_data:getMsg(),_vo_data:getArg_type(),_vo_data:getTeam_id(),_vo_data:getCopy_id())
        else
            self:onReceivedMessage( _vo_data)
        end
    elseif _vo_data :getMsgType() == _G.Constant.CONST_CHAT_SYSTEM then
        self :onSystemMessage( _vo_data )
    end
end

function CChatView.getChannelName( self, _channelid)
	local channelColor = nil
	local channelName = nil
	if _channelid == _G.Constant.CONST_CHAT_WORLD then
		channelName = "【世界】"
		channelColor = ccc4(146,185,70,255)
	elseif _channelid == _G.Constant.CONST_CHAT_TEAM then
		channelName = "【组队】"
		channelColor = ccc4(226,226,58,255)
	elseif _channelid == _G.Constant.CONST_CHAT_CLAN then
		channelName = "【社团】"
		channelColor = ccc4(234,109,54,255)
	elseif _channelid == _G.Constant.CONST_CHAT_PM then
		channelName = "【私聊】"
		channelColor = ccc4(203,88,217,255)
	elseif _channelid == _G.Constant.CONST_CHAT_SYSTEM or _channelid == _G.Constant.CONST_CHAT_MARQUEE_ALL then
		channelName = "【系统】"
		channelColor = ccc4(255,255,255,255)
	end
	if channelName == nil or channelColor == nil then
		return
	end
	return channelName, channelColor
end

    
function CChatView.getColorByIndex( self, _color)
    print( "COLOR: ".._color)
    local temp = nil
    _color = tonumber( _color)
    if _color ~= nil then
        temp = _G.g_ColorManager :getRGBA( _color)
    else
        temp = ccc3( 255,255,255,255)         --颜色-白  -->        
    end
    return temp
end

    
function CChatView.onReceivedMessage( self, _vo_data)--(self, nChannelId, szPlayerName, nPlayerId, szReceiverName, szMessage,Arg_type,Team_id,Copy_id)
	print("onReceivedMessage]]]]]]]]]]]]]]]]]", debug.traceback() )
	local nChannelId     = _vo_data:getChannelId() 
	local szPlayerName   = _vo_data:getUserName()
	local nPlayerId      = _vo_data:getUid()
	local szReceiverName = _vo_data:getReceiverUserName()
	local szMessage      = _vo_data:getMsg()
	local Arg_type       = _vo_data:getArg_type()
	local Team_id        = _vo_data:getTeam_id()
	local Copy_id        = _vo_data:getCopy_id()
	local receiver_id    = _vo_data:getReceiverId()
	print("ddddd:", nChannelId, szPlayerName, nPlayerId, szReceiverName, szMessage,Arg_type,Team_id,Copy_id)
	if szMessage == nil then
		return
	end
	local oldScrollPoint = self.m_RichTextBox:getScrollPoint()
	local defaultFontSize = 24.0
	local defaultFontFamily = "Arial"
	local channelColor = nil
	local channelName = nil
	local channelStr  = ""
	
	channelName, channelColor = self :getChannelName( nChannelId)

	self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_RichTextBox:appendRichText(channelName)

	local playerColor = ccc4(255,160,0,255)
	if nChannelId == _G.Constant.CONST_CHAT_PM and string.len(szPlayerName) > 0 then
		if nPlayerId == _G.g_characterProperty:getMainPlay():getUid() then
			--channelStr = CLanguageManager:sharedLanguageManager():getString("Chat_Literal_YouSay")..szReceiverName..CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Say")
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_RichTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_YouSay") )
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			self.m_RichTextBox:appendRichText( "【"..szReceiverName.."】", CChatView.ACTION_CLICK_ROLE, _vo_data :getId(), 1) --接收者名字
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_RichTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Say") )
		else
			--channelStr = szPlayerName..CLanguageManager:sharedLanguageManager():getString("Chat_Literal_ToYou")
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			self.m_RichTextBox:appendRichText( "【"..szPlayerName.."】", CChatView.ACTION_CLICK_ROLE, _vo_data :getId(), 2)
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_RichTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_ToYou") )
		end
	elseif (nChannelId ~= _G.Constant.CONST_CHAT_SYSTEM and nChannelId ~= _G.Constant.CONST_CHAT_MARQUEE_ALL) or string.len(szPlayerName) > 0 then
		--channelStr = szPlayerName
		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
		self.m_RichTextBox:appendRichText("【"..szPlayerName.."】", CChatView.ACTION_CLICK_ROLE, _vo_data :getId(), 2)
	else
		--channelStr = channelStr
	end

	--channelStr = channelStr.." : "..szMessage
	self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_RichTextBox:appendRichText(": ")
    ----[[
	if #_vo_data:getItemList() ~= 0 then
		local goods = _vo_data:getItemList()[1]
		local goodname = "Data Error "
		local name_color = nil
		if goods ~= nil then
            local goodnode  = _G.g_GameDataProxy :getGoodById( goods.goods_id)
            goodname = goodname..goods.goods_id
            if goodnode ~= nil then     
                goodname  = goodnode : getAttribute("name") 
                name_color = self :getColorByIndex(goodnode : getAttribute("name_color") )
            end
		end
		--name_color = channelColor
		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, name_color)
		self.m_RichTextBox:appendRichText("【"..goodname.."】", CChatView.ACTION_CLICK_GOOD, _vo_data :getId())
	end
	--]]

	channelStr = szMessage
	--jun 2013.10.09----------------------------------------------------------------------------------------------------------------
	print("Arg_type111",Arg_type,Team_id,Copy_id)
	if 	tonumber(Arg_type) == 2 then
		print("soga22")		
		-- self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc3(255,255,255))
		-- self.m_RichTextBox:appendRichText(channelStr.."\n",CChatView.ACTION_TEAM_POSTED,Team_id,Copy_id)
		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
		self.m_RichTextBox:appendRichText(channelStr)
		local addmsg = "点击进入"
		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,0,0,255))
		self.m_RichTextBox:appendRichText(addmsg.."\n",CChatView.ACTION_TEAM_POSTED,Team_id,Copy_id)
	else
		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
		self.m_RichTextBox:appendRichText(channelStr.."\n")
	end
	--------------------------------------------------------------------------------------------------------------------------------

	local scrollSize = self.m_RichTextBox:getScrollSize()
	--万万不能重写getContentSize,除非你知道弄了什么
	local rHeight = CCDirector:sharedDirector():getVisibleSize().height - 195
	if oldScrollPoint.y == 0 or (oldScrollPoint.y ~= 0 and scrollSize.height > rHeight) then
		self.m_RichTextBox:scrollToBottomNextFrame()
	end
end

function CChatView.onSystemMessage( self, _vo_data )
    if _vo_data ~= nil then
        print( "CChatView.onSystemMessage" , _vo_data)
        local nChannelId     = _vo_data:getChannelId() 
		local szPlayerName   = _vo_data:getUserName()
		local nPlayerId      = _vo_data:getUid()
		local szReceiverName = _vo_data:getReceiverUserName()
		local szMessage      = _vo_data:getMsg()
		local Arg_type       = _vo_data:getArg_type()
		local Team_id        = _vo_data:getTeam_id()
		local Copy_id        = _vo_data:getCopy_id()
		local receiver_id    = _vo_data:getReceiverId()
	    
	    local msgTable       = _vo_data :getMsgTable()
        --[[
	    if msgTable ~= nil then
	        for key, v in pairs( msgTable ) do
	            if v ~= nil then
	                for kk, value in pairs( v ) do
	                    print( "_table_-->", key, kk, value )
	                end
	            end
	        end
	    end
        --]]
		print("ddddd:", nChannelId, szPlayerName, nPlayerId, szReceiverName, szMessage,Arg_type,Team_id,Copy_id)
		if szMessage == nil then
			return
		end
		local oldScrollPoint = self.m_RichTextBox:getScrollPoint()
		local defaultFontSize = 24.0
		local defaultFontFamily = "Arial"
		local channelColor = nil
		local channelName = nil
		local channelStr  = ""
		
		channelName, channelColor = self :getChannelName( nChannelId )

		self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
		self.m_RichTextBox:appendRichText(channelName .. ": ")

		local playerColor = ccc4(255,160,0,255)
		if (nChannelId == _G.Constant.CONST_CHAT_SYSTEM and nChannelId ~= _G.Constant.CONST_CHAT_MARQUEE_ALL) or string.len(szPlayerName) > 0 then
			local szRoleName = ""
			if msgTable ~= nil then
				local strFirst  = ""
				local strSecond = ""
				for key, value in pairs( msgTable ) do
					local remainder = key % 2 		--取余
					if remainder == 1 then 			--奇数时
						if value.msgStr ~= nil and value.color ~= nil then
							szRoleName = tostring( value.msgStr )
							local _color = _G.g_ChatDataProxy :getColorByType( tonumber( value.color or _G.Constant.CONST_COLOR_WHITE ))

                            --玩家姓名 并包含点击事件
							self.m_RichTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, _color )
							self.m_RichTextBox :appendRichText( szRoleName, CChatView.ACTION_CLICK_SYS_ROLE, _vo_data :getId())--tonumber( value.uid or "0"), szRoleName )

							strFirst, strSecond = _G.g_ChatDataProxy :gsub( value.tmpStr or "", "#")

                            --拼接内容
							self.m_RichTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4( 255, 255, 255, 255 ) )
							self.m_RichTextBox :appendRichText( strFirst )
						end
					elseif remainder == 0 then 		--偶数时
						if value.msgStr ~= nil  then
                            --精英颜色
                            local colorType = nil
                            if value.type == _G.Constant.CONST_BROAD_COPY_ID then
                                colorType = _G.Constant.CONST_COLOR_RED
                            else
                                colorType = value.color or _G.Constant.CONST_COLOR_WHITE
                            end
							local _color = _G.g_ChatDataProxy :getColorByType( colorType )
                            print("__coloor222", _color )
							self.m_RichTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, _color )
                            local _strTemp = tostring( value.msgStr or "" )
                            local _action_click = nil
                            local _tagId = nil
               
                            if value.type ~= nil and value.type == _G.Constant.CONST_BROAD_DOUQI_ID then        --为物品时
                                _strTemp = "【" .. _strTemp .. "】"
                                _action_click = CChatView.ACTION_CLICK_DOUQI
                                _tagId  = value.id--_vo_data :getId()
                                print(" ,,, ssss", _action_click, _tagId )
                            end
                            --第二个物品或  数字信息
                            if _action_click ~= nil and _tagId ~= nil then
                                self.m_RichTextBox :appendRichText( _strTemp, _action_click, _tagId )
                            else
                                self.m_RichTextBox :appendRichText( _strTemp )
                            end

							self.m_RichTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4( 255, 255, 255, 255 ) )
							self.m_RichTextBox :appendRichText( strSecond )
						end
					end
				end
			end

			
		else
			--channelStr = channelStr
		end
		print("sdsddddd", tostring(szPlayerName), "  -->", channelName)
		--self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
		--self.m_RichTextBox:appendRichText(": ")

		if #_vo_data:getItemList() ~= 0 then
			local goods = _vo_data:getItemList()[1]
			local goodname = "Data Error "
			local name_color = nil
			if goods ~= nil then
	            local goodnode  = _G.g_GameDataProxy :getGoodById( goods.goods_id)
	            goodname = goodname..goods.goods_id
	            if goodnode ~= nil then     
	                goodname  = goodnode : getAttribute("name") 
	                name_color = self :getColorByIndex(goodnode : getAttribute("name_color"))
	            end
			end
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, name_color)
			self.m_RichTextBox:appendRichText("【"..goodname.."】", CChatView.ACTION_CLICK_GOOD, _vo_data :getId())
		end
		
		channelStr = ""
		--jun 2013.10.09----------------------------------------------------------------------------------------------------------------
		print("Arg_type111",Arg_type,Team_id,Copy_id)
		if 	tonumber(Arg_type) == 2 then
			print("soga22")		
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc3(255,255,255))
			self.m_RichTextBox:appendRichText(channelStr.."\n",CChatView.ACTION_TEAM_POSTED,Team_id,Copy_id)
		else
			self.m_RichTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
			self.m_RichTextBox:appendRichText(channelStr.."\n")
		end
		--------------------------------------------------------------------------------------------------------------------------------

		local scrollSize = self.m_RichTextBox:getScrollSize()
		--万万不能重写getContentSize,除非你知道弄了什么
		local rHeight = CCDirector:sharedDirector():getVisibleSize().height - 195
		if oldScrollPoint.y == 0 or (oldScrollPoint.y ~= 0 and scrollSize.height > rHeight) then
			self.m_RichTextBox:scrollToBottomNextFrame()
		end
	end
end
                                              
function CChatView.onReceiverOffline(self,_str)
	local defaultFontSize = 24.0
	local defaultFontFamily = "Arial"
	self.m_RichTextBox:setCurrentStyle(defaultFontFamily,defaultFontSize, ccc4(255,0,0,255))
	self.m_RichTextBox:appendRichText( _str .. "\n")
end
    
----------0801.add 
function CChatView.setFriendName( self, _szName)
    self.m_ShowChannelID = _G.Constant.CONST_CHAT_PM
        self.m_ChannelID = _G.Constant.CONST_CHAT_PM
    self :setChannelIdHighLight( self.m_ShowChannelID )

    self:setChannelId( _G.Constant.CONST_CHAT_PM )
        
    _szName = tostring( _szName)
    if _szName == nil  then
        return
    end
    
    self.m_NameEditBox :setTextString( _szName)
    self.m_CurrentName = _szName
end

----------11.07.add 
function CChatView.setShowGoodName( self, _data)
    self.m_ShowChannelID = _G.Constant.CONST_CHAT_WORLD
        self.m_ChannelID = _G.Constant.CONST_CHAT_WORLD
    self :setChannelIdHighLight( self.m_ShowChannelID )
    self:setChannelId( _G.Constant.CONST_CHAT_WORLD )
    self.m_isShow   = true


    --_data.good_name 
    --_data.good_index 
    --_data.good_num  
    --_data.pos_type
    self.m_goodcount = 1
    --self.m_goodinfo = REQ_CHAT_GOODS_LIST()
    self.m_goodinfo.goods_type = _data.pos_type -- :setGoodsType( _data.pos_type)
    self.m_goodinfo.id         = 0              -- :setId( 0)
    self.m_goodinfo.goods_index= _data.good_index-- :setGoodsIndex( _data.good_index)
    --table.insert( self.m_goodinfo, msg )
    self.m_SentenceEditBox:setTextString( " ".._data.good_name.." ")  
    --self.m_goodname = "【".._data.good_name.."】"  
end

function CChatView.getTouchPlayContainer( self )
    return self.m_lpTouchPlayContainer
end
function CChatView.removeTouchPlayContainerChild( self )
    self.m_lpTouchPlayContainer : removeAllChildrenWithCleanup( true )
end

---jun 2013.10.09
function CChatView.RichTextBoxCallBack( self, eventType, action, arg1, arg2 )
	print("000aafffffffffffffffffffffff", eventType, action, arg1, arg2 )
	if eventType == "TouchBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
	    _G.g_PopupView :reset()
	    self : removeTouchPlayContainerChild()
		return false--obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then  --RichTextBoxCallBack
		print("你为什么要点我111111111？")
	elseif eventType == "RichTextBoxCallBack" then
		if action == CChatView.ACTION_TEAM_POSTED then
			print("OMG WHAT THE FUCK","------->>", arg1, arg2)
			local teamid = arg1
			local copyid = arg2
			if teamid ~=nil then
	            self : TeamIsLiveNetWorkSend(teamid) --判断队伍是否存在
	            self.Team_id = teamid 
	            self.Copy_id = copyid
        	end
        elseif action == CChatView.ACTION_CLICK_SYS_ROLE then
        	print( "查看人物信息1:")
        	local vo_node = nil
			local tabList = _G.g_ChatDataProxy:getList( self.m_ShowChannelID)
			for i,v in ipairs(tabList) do
				print( i, v: getId(), arg1)
				if tonumber(v :getId()) == tonumber(arg1) then
					print( arg1)
					vo_node = v
                    break
				end
			end
			local msgTable       = vo_node :getMsgTable()
			local uid,name,lv,pro = nil, nil, nil, nil
			for key, value in pairs( msgTable ) do
				local remainder = key % 2 		--取余
				if remainder == 1 then 			--奇数时
					if value.msgStr ~= nil and value.color ~= nil then
						uid,name,lv,pro = value.uid or 0, value.msgStr or "error", value.lv or 1, value.pro or 1
					end
				elseif remainder == 0 then 		--偶数时
					if value.msgStr ~= nil  then
					end
				end
			end
        	if tonumber( uid) ~= tonumber(_G.g_characterProperty:getMainPlay():getUid()) and arg1 ~= nil then  
	            --local viewObject = CChatRolePopupView( arg1, arg2, 1 , 450, 350 )
	            local viewObject = CTouchPlayView( uid,name,lv,pro, 500, 350 ) -- uid  name  lv  pro  x  y
	            local tempView   = viewObject : getShowView( )
	            local scene = CCDirector : sharedDirector() : getRunningScene()
	            if scene ~= nil then
	                self : removeTouchPlayContainerChild()
	                container = self : getTouchPlayContainer()
	                if container ~= nil then
	                    container : addChild( tempView )
	                end
	            end
	            return true
            else
		    	local _msg = "无法查看自己的信息！"
			   	require "view/ErrorBox/ErrorBox"
			    local ErrorBox  = CErrorBox()
			    local BoxLayer  = ErrorBox : create(_msg)
			    self.m_mainContainer : addChild(BoxLayer,1000)
            end
        elseif action == CChatView.ACTION_CLICK_ROLE then
        	print( "查看人物信息2:")
        	local vo_node = nil
			local tabList = _G.g_ChatDataProxy:getList( self.m_ShowChannelID)
			for i,v in ipairs(tabList) do
				print( i, v: getId(), arg1)
				if tonumber(v :getId()) == tonumber(arg1) then
					print( arg1)
					vo_node = v
                    break
				end
			end
			local uid,name,lv,pro = nil, nil, nil, nil
			if tonumber(arg2) == 2 then
				uid  = vo_node : getUid()
				name = vo_node : getUserName()
				lv   = vo_node : getLevel() or 1
				pro  = vo_node : getPro() or 1
			elseif tonumber(arg2) == 1 then
				uid  = vo_node : getReceiverId()
				name = vo_node : getReceiverUserName()
				lv   = vo_node : getReceiverLv() or 1
				pro  = vo_node : getReceiverPro() or 1
			end
			print(arg2,"XXXX", uid, name, lv , pro)
        	if tonumber( uid) ~= tonumber(_G.g_characterProperty:getMainPlay():getUid()) and arg1 ~= nil then  
	            --local viewObject = CChatRolePopupView( arg1, arg2, 1 , 450, 350 )
	            local viewObject = CTouchPlayView( uid, name, lv , pro,  500, 350 ) -- uid  name  lv  pro  x  y
	            local tempView   = viewObject : getShowView( )
	            local scene = CCDirector : sharedDirector() : getRunningScene()
	            if scene ~= nil then
	                self : removeTouchPlayContainerChild()
	                container = self : getTouchPlayContainer()
	                if container ~= nil then
	                    container : addChild( tempView )
	                end
	            end
	            return true
            else
		    	local _msg = "无法查看自己的信息！"
			   	require "view/ErrorBox/ErrorBox"
			    local ErrorBox  = CErrorBox()
			    local BoxLayer  = ErrorBox : create(_msg)
			    self.m_mainContainer : addChild(BoxLayer,1000)
            end
        elseif action == CChatView.ACTION_CLICK_GOOD then
        	print( "查看物品信息:",self.m_nChannelId)  
        	local goods = nil
			local tabList = _G.g_ChatDataProxy:getList( self.m_ShowChannelID)
			for i,v in ipairs(tabList) do
				print( i, v: getId(), arg1)
				if tonumber(v :getId()) == tonumber(arg1) then
					print( arg1)
					goods = v:getItemList()[1]
                    print( goods )
                    break
				end
			end
			if goods == nil then
				print("Error goods :",goods)
				return
			end 
            local _position = {}
            _position.x = 300
            _position.y = 500
            local  temp =   _G.g_PopupView :create( goods, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
            self.m_mainContainer:addChild( temp)
        elseif action == CChatView.ACTION_CLICK_DOUQI then
            local _position = {}
            _position.x = 300
            _position.y = 500
        	local  temp =   _G.g_VindictivePopupView :createById( arg1, 99999, _position)
            self.m_mainContainer :addChild( temp)
		end
	end
end

function CChatView.NetWorkReturn_TEAM_LIVE_REP( self ,rep,inviteType)
	print("队伍是否存在协议返回",rep)
	if inviteType == 0 then
		if rep == 1 then
			if self.Team_id ~=nil and self.Copy_id ~= nil then
				local teamid = self.Team_id 
	            self : TeamJoinNetWorkSend(teamid)  --加入队伍协议发送

	            require "view/DuplicateLayer/GenerateTeamView"
	            local pGenerateTeamView = CGenerateTeamView()
	            local id = self.Copy_id
	            CCDirector : sharedDirector () : pushScene( pGenerateTeamView :scene(0,id)) 
	    	end
	    elseif rep == 0 then
	    	local _msg = "队伍进入副本或队伍已解散"
		   	require "view/ErrorBox/ErrorBox"
		    local ErrorBox  = CErrorBox()
		    local BoxLayer  = ErrorBox : create(_msg)
		    self.m_mainContainer : addChild(BoxLayer,1000)
		end
	end
end

function CChatView.TeamIsLiveNetWorkSend( self,_TeamId)  --队伍是否存在协议发送
    require "common/protocol/auto/REQ_TEAM_LIVE_REQ" 
    local msg = REQ_TEAM_LIVE_REQ()
    msg       : setTeamId(_TeamId)  
    msg       : setInviteType(0)
    CNetwork  : send(msg)
    print("CChatView TeamIsLiveNetWorkSend REQ_TEAM_LIVE_REQ send,完毕")
end

function CChatView.TeamJoinNetWorkSend( self,_TeamId)
    require "common/protocol/auto/REQ_TEAM_JOIN" 
    local msg = REQ_TEAM_JOIN()
    msg       : setTeamId(_TeamId)  
    CNetwork  : send(msg)
    print("CChatView TeamJoinNetWorkSend REQ_TEAM_JOIN send,完毕")
end

function CChatView.TeamPostedRecruited( self,msg,TeamId,CopyId)
	--_G.TeamPostedisveryOk = 1
	--self : sendMessage(_G.Constant.CONST_CHAT_WORLD,msg) --世界频道里面喊话
	--频道发送
	local _pMsg2 = REQ_CHAT_SEND()
	_pMsg2:setChannelId(tonumber(_G.Constant.CONST_CHAT_WORLD)) --世界频道
	_pMsg2:setArg_type(_G.Constant.CONST_CHAT_TEAM_ID)          --参数类型
	_pMsg2:setUid(0)
	_pMsg2:setGoodsCount(0)
	_pMsg2:setGoodsList(0)
	_pMsg2:setTeamId(TeamId)
	_pMsg2:setCopyId(CopyId)
	_pMsg2:setMsg( msg )
	CNetwork:send(_pMsg2) 
	self.m_CurrentName = nil
end


        		-- require "view/Chat/ChatRolePopupView"	            
	         --    local viewObject = CChatRolePopupView( arg1, arg2, 1 , 450, 350 )
	         --    local tempView   = viewObject : getShowView( )
	         --    local scene = CCDirector : sharedDirector() : getRunningScene()
	         --    if scene ~= nil then
	         --        self : removeTouchPlayContainerChild()
	         --        container = self : getTouchPlayContainer()
	         --        if container ~= nil then
	         --            container : addChild( tempView )
	         --        end
	         --    end

