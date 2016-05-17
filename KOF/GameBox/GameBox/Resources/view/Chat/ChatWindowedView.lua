require "view/view"
require "mediator/mediator"
require "mediator/ChatMediator"
require "controller/ChatCommand"
require "view/Chat/ChatView"
require "proxy/ChatDataProxy"

CChatWindowedView = class(view, function(self)

end)

function CChatWindowedView.loadResources(self)

end

function CChatWindowedView.init(self, _container, _winSize)
	-- self:loadResources()
	self:initView( _container, _winSize )
	self:layout(_winSize)
end

function CChatWindowedView.initView( self, _container, _winSize )
	local function onRichTextBoxClicked(eventType, obj, x, y)
		return self:onRichTextBoxTouchCallback(eventType, obj, x, y)
	end

	self.m_container = _container
	self.m_richTextBox = CRichTextBox:create(CCSizeMake(400,60),ccc4(0,0,0,40)) --半透明灰
	self.m_richTextBox:setAutoScrollDown(true)
	self.m_richTextBox:retain()
	self.m_richTextBox:setTouchesPriority(-25)
	self.m_richTextBox:setTouchesEnabled(true)
	self.m_richTextBox:registerControlScriptHandler(onRichTextBoxClicked, "this CChatWindowedView self.m_richTextBox 34")
	self.m_container:addChild( self.m_richTextBox )
    
    --聊天按钮  12.03 新增
    local function chatCallback( eventType, obj, x, y )
        return self :onChatCallback( eventType, obj, x, y )
    end
    
    self.m_lpChatBtn = CButton :createWithSpriteFrameName( "", "menu_chat.png" )
    self.m_lpChatBtn :retain()
    self.m_lpChatBtn :registerControlScriptHandler( chatCallback, "CChatWindowedView.initView self.m_lpChatBtn 42" )
    self.m_container :addChild( self.m_lpChatBtn )
end

function CChatWindowedView.layout(self, _winSize)
    local _nPosX = _winSize.width / 2         --5
    local _lSize = self.m_richTextBox :getScrollSize()
	self.m_container :setPosition( ccp( _nPosX - _lSize.width / 2, 67 ) )
    print( "屏幕size", _winSize.width, _lSize.width )
    local _btnSize = self.m_lpChatBtn :getPreferredSize()
    local nDistance = (_winSize.width - 960) / 2
    self.m_lpChatBtn :setPosition( ccp( _nPosX - _lSize.width - 1.5 * _btnSize.width - nDistance, -_btnSize.height / 2 + 12) )
end

function CChatWindowedView.container(self)
	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	local _container = CContainer:create()
    _container : setControlName("this is CChatWindowedView _container 52 ")
	self:init( _container, _winSize )
	return _container
end






function CChatWindowedView.onRichTextBoxTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		local _wayCommand = CChatWindowedCommand(CChatWindowedCommand.OPEN)
		controller:sendCommand(_wayCommand)
        
        local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
        controller :sendCommand( closeCommand )
	end
end





function CChatWindowedView.close(self)
	self.m_richTextBox:removeFromParentAndCleanup(true)
	self.m_richTextBox:release()
    
    self.m_lpChatBtn :removeFromParentAndCleanup(true)
	self.m_lpChatBtn :release()
end

function CChatWindowedView.hide(self)
	self.m_richTextBox :removeFromParentAndCleanup(false)
    self.m_lpChatBtn :removeFromParentAndCleanup(false)
end

function CChatWindowedView.show(self)
	if self.m_richTextBox :getParent() == nil then
		self.m_container :addChild( self.m_richTextBox )
	end
    if self.m_lpChatBtn ~= nil and self.m_lpChatBtn :getParent() == nil then
        self.m_container :addChild( self.m_lpChatBtn )
    end
end

function CChatWindowedView.open(self)
	_G.pChatView = CChatView()
	_G.pChatMediator = CChatMediator(_G.pChatView)
	controller:registerMediator( _G.pChatMediator )

	--open
	local scene = _G.pChatView:scene()
	CCDirector:sharedDirector():pushScene(scene)
end




function CChatWindowedView.autoArchiveMessage(self, _vo_data)
	self.m_richTextBox:clearAll()
	local tabList = _G.g_ChatDataProxy:getListReverse( 2 )
	for i=1,#tabList do
        if tabList[i] :getMsgType() == 0 then
            if #tabList[i]:getItemList() == 0 then
                --self:onReceivedMessage( tabList[i]:getChannelId(), tabList[i]:getUserName(), tabList[i]:getUid(), tabList[i]:getReceiverUserName(), tabList[i]:getMsg())
                self :XXXXXonReceivedMessage( tabList[i])
            else
                self :XXXXXonReceivedMessage( tabList[i])
            end
        elseif tabList[i] :getMsgType() == _G.Constant.CONST_CHAT_SYSTEM then
        	print( "xOnSystemMessage-->", i )
            self :XXXXXonSystemMessage( tabList[i] ) 
        end
        --
	end
end

function CChatWindowedView.getChannelName( self, _channelid)
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

function CChatWindowedView.getColorByIndex( self, _color)
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

function CChatWindowedView.XXXXXonSystemMessage( self, _vo_data )
 	print("-->XXXXXonSystemMessage]]]]]]]]]]]]]]]]]")
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
	local oldScrollPoint = self.m_richTextBox:getScrollPoint()
	local defaultFontSize = 20.0
	local defaultFontFamily = "Arial"
	local channelColor = nil
	local channelName = nil
	local channelStr  = ""
	
	channelName, channelColor = self :getChannelName( nChannelId )

	self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_richTextBox:appendRichText(channelName .. ": ")

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

						self.m_richTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, _color )
						self.m_richTextBox :appendRichText( szRoleName )

						strFirst, strSecond = _G.g_ChatDataProxy :gsub( value.tmpStr or "", "#")

						self.m_richTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4( 255, 255, 255, 255 ) )
						self.m_richTextBox :appendRichText( strFirst )
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
                        print("__coloor111", _color )
						self.m_richTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, _color )
						self.m_richTextBox :appendRichText( value.msgStr )

						self.m_richTextBox :setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4( 255, 255, 255, 255 ) )
						self.m_richTextBox :appendRichText( strSecond )
					end
				end
			end
		end

		
	else
		--channelStr = channelStr
	end
	print("sdsddddd", tostring(szPlayerName), "  -->", channelName)
	--self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	--self.m_richTextBox:appendRichText(": ")

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
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, name_color)
		self.m_richTextBox:appendRichText("【"..goodname.."】", CChatView.ACTION_CLICK_GOOD, _vo_data :getId())
	end
	
	channelStr = ""
	--jun 2013.10.09----------------------------------------------------------------------------------------------------------------
	print("Arg_type111",Arg_type,Team_id,Copy_id)
	if 	tonumber(Arg_type) == 2 then
		print("soga22")		
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc3(255,255,255))
		self.m_richTextBox:appendRichText(channelStr.."\n")
	else
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
		self.m_richTextBox:appendRichText(channelStr.."\n")
	end
	--------------------------------------------------------------------------------------------------------------------------------

	local scrollSize = self.m_richTextBox:getScrollSize()
	--万万不能重写getContentSize,除非你知道弄了什么
	local rHeight = CCDirector:sharedDirector():getVisibleSize().height - 195
	if oldScrollPoint.y == 0 or (oldScrollPoint.y ~= 0 and scrollSize.height > rHeight) then
		self.m_richTextBox:scrollToBottomNextFrame()
	end
    
end

function CChatWindowedView.XXXXXonReceivedMessage( self, _vo_data)--(self, nChannelId, szPlayerName, nPlayerId, szReceiverName, szMessage,Arg_type,Team_id,Copy_id)
	print("CChatWindowedViewonReceivedMessage]]]]]]]]]]]]]]]]]")
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
	local oldScrollPoint = self.m_richTextBox:getScrollPoint()
	local defaultFontSize = 20.0
	local defaultFontFamily = "Arial"
	local channelColor = nil
	local channelName = nil
	local channelStr  = ""
	
	channelName, channelColor = self :getChannelName( nChannelId)

	self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_richTextBox:appendRichText(channelName)

	local playerColor = ccc4(255,160,0,255)
	if nChannelId == _G.Constant.CONST_CHAT_PM and string.len(szPlayerName) > 0 then
		if nPlayerId == _G.g_characterProperty:getMainPlay():getUid() then
			self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_YouSay") )
			self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			self.m_richTextBox:appendRichText( "【"..szReceiverName.."】") --接收者名字
			self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Say") )
		else
			self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			self.m_richTextBox:appendRichText( "【"..szPlayerName.."】")
			self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_ToYou") )
		end
	elseif (nChannelId ~= _G.Constant.CONST_CHAT_SYSTEM and nChannelId ~= _G.Constant.CONST_CHAT_MARQUEE_ALL) or string.len(szPlayerName) > 0 then
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
		self.m_richTextBox:appendRichText("【"..szPlayerName.."】")
	else
		--channelStr = channelStr
	end

	self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_richTextBox:appendRichText(": ")

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
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, name_color)
		self.m_richTextBox:appendRichText("【"..goodname.."】", CChatView.ACTION_CLICK_GOOD, _vo_data :getId())
	end
	
	channelStr = szMessage

	--jun 2013.10.09----------------------------------------------------------------------------------------------------------------
	print("Arg_type111",Arg_type,Team_id,Copy_id)
	if 	tonumber(Arg_type) == 2 then
		print("soga22")		
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
		self.m_richTextBox:appendRichText(channelStr.."\n")
	else
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
		self.m_richTextBox:appendRichText(channelStr.."\n")
	end
	--------------------------------------------------------------------------------------------------------------------------------

	local scrollSize = self.m_richTextBox:getScrollSize()
	--万万不能重写getContentSize,除非你知道弄了什么
	local rHeight = CCDirector:sharedDirector():getVisibleSize().height - 195
	if oldScrollPoint.y == 0 or (oldScrollPoint.y ~= 0 and scrollSize.height > rHeight) then
		self.m_richTextBox:scrollToBottomNextFrame()
	end
end


function CChatWindowedView.onReceivedMessage(self, nChannelId, szPlayerName, nPlayerId, szReceiverName, szMessage)
	if szMessage == nil then
		return
	end
	local defaultFontSize = 24.0
	local defaultFontFamily = "Arial"
	local channelColor = nil
	local channelName = nil
	local channelStr  = "  "

	if nChannelId == _G.Constant.CONST_CHAT_WORLD then
		channelName = "[世界]"
		channelColor = ccc4(146,185,70,255)
	elseif nChannelId == _G.Constant.CONST_CHAT_TEAM then
		channelName = "[组队]"
		channelColor = ccc4(226,226,58,255)
	elseif nChannelId == _G.Constant.CONST_CHAT_CLAN then
		channelName = "[社团]"
		channelColor = ccc4(234,109,54,255)
	elseif nChannelId == _G.Constant.CONST_CHAT_PM then
		channelName = "[私聊]"
		channelColor = ccc4(203,88,217,255)
	elseif nChannelId == _G.Constant.CONST_CHAT_SYSTEM or nChannelId == _G.Constant.CONST_CHAT_MARQUEE_ALL then --系统 跑马灯 
		channelName = "[系统]"
		channelColor = ccc4(255,255,255,255)
	end
	if channelName == nil or channelColor == nil then
		return
	end

	-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	-- self.m_richTextBox:appendRichText(channelName)

	local playerColor = ccc4(255,160,0,255)
	if nChannelId == _G.Constant.CONST_CHAT_PM and string.len(szPlayerName) > 0 then
		if nPlayerId == _G.g_characterProperty:getMainPlay():getUid() then
			channelStr = channelName.." "..CLanguageManager:sharedLanguageManager():getString("Chat_Literal_YouSay")..szReceiverName..CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Say")
			-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			-- self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_YouSay") )
			-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			-- self.m_richTextBox:appendRichText(szReceiverName)
			-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			-- self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_Say") )
		else
			channelStr = channelName.." "..szPlayerName..CLanguageManager:sharedLanguageManager():getString("Chat_Literal_ToYou")
			-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
			-- self.m_richTextBox:appendRichText(szPlayerName)
			-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
			-- self.m_richTextBox:appendRichText(CLanguageManager:sharedLanguageManager():getString("Chat_Literal_ToYou") )
		end
	elseif (nChannelId ~= _G.Constant.CONST_CHAT_SYSTEM and nChannelId ~= _G.Constant.CONST_CHAT_MARQUEE_ALL) or string.len(szPlayerName) > 0 then
		channelStr = channelName.." "..szPlayerName
		-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
		-- self.m_richTextBox:appendRichText(szPlayerName .. ": ")
	else
		channelStr = channelStr..channelName
	end

	channelStr = channelStr.." : "..szMessage

	self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, channelColor)
	self.m_richTextBox:appendRichText(channelStr.."\n")
	--[[
	if nChannelId ~= _G.Constant.CONST_CHAT_SYSTEM or string.len(szPlayerName) > 0 then
		local playerColor = ccc4(255,160,0,255)
		self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, playerColor)
		self.m_richTextBox:appendRichText(szPlayerName .. ": ")
	end]]

	-- self.m_richTextBox:setCurrentStyle(defaultFontFamily, defaultFontSize, ccc4(255,255,255,255))
	-- self.m_richTextBox:appendRichText(szMessage.."\n")
end

function CChatWindowedView.onChatCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        self :open()
        return true
    end
end
