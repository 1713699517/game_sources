require "view/view"
require "model/VO_SelectRoleModel"
require "controller/SelectRoleCommand"
require "proxy/LoginInfoProxy"

--setLuaCallback
CSelectRoleView = class(view,function(self)

	self.m_pContainer = CContainer:create()
    self.m_pContainer : setControlName( "this is CSelectRoleView self.m_pContainer 10")

	self.m_pHistoryServers = {}
	self.m_pRecommendServers = {}
	self.m_pRoleList = {}

    self.m_pSeverList = {}
    self.m_bIsInit = false
    self.m_httpSeverString = ""
end)

CSelectRoleView.FONTFAMILY = "Arial"
CSelectRoleView.FONTSIZE = 20

--

function parseJSonObjects(_str)
	CCLOG("parseJsonStart")
	local ret = {}
	local a1 = string.find(_str, "%[")
	local a2 = string.find(_str, "%]")
	local i = 0
	if a1 ~= nil and a2 ~= nil then
		i = 1
	end
	local pos = 1--string.find(_str, "{", a1)
	local endpos = 1--string.find(_str, "}",pos)
	while pos ~= nil do
		pos = string.find(_str,"{", pos)
		endpos = string.find(_str,"}", pos)
		if pos == nil then
			break
		end
		if pos ~= nil and endpos ~= nil then
			ret[i] = {}
			local sstr = string.sub( _str, pos+1, endpos-1 )
			
			--循环读取各种字段加至table
			for k,v in string.gmatch(sstr, '"([%a_]+)"%s*:%s*"?([^,%s"]+)"?') do
				ret[i][k] = v
			end
			i = i + 1
		end
		pos = endpos + 1
	end
	CCLOG("parseJsonEnd")
	--CCLOG("a1"..tostring(a1).." a2"..tostring(a2))
	return ret
end


function CSelectRoleView.init(self, _winSize)
	self:loadResources()
	--背景
	self.m_pBackground = CSprite :create("CreateRoleResources/login_loading_background.jpg")
    self.m_pBackground : setControlName( "this CSelectRoleView self.m_pBackground 63 ")
	self.m_pContainer:addChild( self.m_pBackground , -100 )
	self:initView(_winSize)
    self.m_pContainer :setVisible(false)
    
	self:layout(_winSize)
end

function CSelectRoleView.loadResources(self)
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CreateRoleResources/CreateRoleResource.plist") 
end

function CSelectRoleView.initView(self, _winSize)
	if _winSize.height == 640 then
		self.m_pRoleListBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
        self.m_pRoleListBackground : setControlName( "this CSelectRoleView self.m_pRoleListBackground 79 ")

		self.m_pRoleListBackground :setPreferredSize(CCSizeMake(265,465))
		self.m_pContainer :addChild(self.m_pRoleListBackground, -99)

		self.m_pRolePanelBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
        self.m_pRolePanelBackground : setControlName( "this CSelectRoleView self.m_pRolePanelBackground 85 ")
		self.m_pRolePanelBackground :setPreferredSize(CCSizeMake(330,520))
		self.m_pContainer :addChild(self.m_pRolePanelBackground, -99)

		self.m_pServerListBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
        self.m_pServerListBackground : setControlName( "this CSelectRoleView self.m_pServerListBackground 90 ")
		self.m_pServerListBackground :setPreferredSize(CCSizeMake(265,465))
		self.m_pContainer :addChild(self.m_pServerListBackground, -99)

		self.m_pRoleBackground = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
        self.m_pRoleBackground : setControlName( "this CSelectRoleView self.m_pRoleBackground 95 ")
		self.m_pRoleBackground :setPreferredSize(CCSizeMake(250,250))
		self.m_pContainer :addChild(self.m_pRoleBackground, -98)

		self.m_pRoleListLayout = CVerticalLayout :create()
		self.m_pRoleListLayout:setCellSize(CCSizeMake(250,40))
		self.m_pRoleListLayout:setVerticalDirection(true)
		self.m_pRoleListLayout:setHorizontalDirection(false)
		self.m_pRoleListLayout:setLineNodeSum(1)
		self.m_pRoleListLayout:setColumnNodeSum(10)
		self.m_pRoleListLayout:setCellVerticalSpace(30)
		self.m_pRoleListLayout:setCellHorizontalSpace(0)
		self.m_pContainer:addChild(self.m_pRoleListLayout, -97)

		self.m_pServerListLayout = CVerticalLayout :create()
		self.m_pServerListLayout :setCellSize(CCSizeMake(250,40))
		self.m_pServerListLayout :setVerticalDirection(true)
		self.m_pServerListLayout :setHorizontalDirection(false)
		self.m_pServerListLayout :setLineNodeSum(1)
		self.m_pServerListLayout :setColumnNodeSum(10)
		self.m_pServerListLayout :setCellVerticalSpace(140)
		self.m_pServerListLayout :setCellHorizontalSpace(0)
		self.m_pContainer:addChild(self.m_pServerListLayout, -97)

--角色列表
		local function onRoleButtonTouchCallback(eventType, obj, x, y)
			return self:onRoleBtnTouchCallback(eventType, obj, x, y)
		end
		self.m_pRoleBtn = {}
		for i = 6, 1, -1 do
			local roleBtnBackground = CSpriteRGBA :createWithSpriteFrameName("login_big_frame.png", CCRectMake(14,14,16,9))
			local roleName = CCLabelTTF :create("Role_"..tostring(i), CSelectRoleView.FONTFAMILY, CSelectRoleView.FONTSIZE)
			self.m_pRoleBtn[i] = CButton :create(roleName, roleBtnBackground)
            self.m_pRoleBtn[i] : setControlName( "this CSelectRoleView self.m_pRoleBtn[i] 122 "..tostring(i) )
			self.m_pRoleBtn[i] :registerControlScriptHandler(onRoleButtonTouchCallback, "this CSelectRoleView self.self.m_pRoleBtn[i] 129")
			self.m_pRoleBtn[i] :setPreferredSize(CCSizeMake(220,60))
			self.m_pRoleListLayout :addChild( self.m_pRoleBtn[i] )
		end

--服务器列表
		local function onServerButtonTouchCallback(eventType, obj, x, y)
			return self:onServerBtnTouchCallback(eventType, obj, x, y)
		end
		self.m_pServerBtn = {}
		for i = 3, 1, -1 do
			local serverBtnBackground = CSpriteRGBA :createWithSpriteFrameName("login_big_frame.png", CCRectMake(14,14,16,9))
			local serverName = CCLabelTTF :create("More", CSelectRoleView.FONTFAMILY, CSelectRoleView.FONTSIZE)
			self.m_pServerBtn[i] = CButton :create(serverName,serverBtnBackground)
            self.m_pServerBtn[i] : setControlName( "this CSelectRoleView self.m_pServerBtn[i] 137 "..tostring(i) )
			self.m_pServerBtn[i] :setPreferredSize(CCSizeMake(220,60))
			self.m_pServerBtn[i] :registerControlScriptHandler(onServerButtonTouchCallback, "this CSelectRoleView self.m_pServerBtn[i] 146")
			self.m_pServerListLayout :addChild( self.m_pServerBtn[i] )
		end


--已选角色头像
		self.m_pSelectedRoleImage = CSprite :create("transparent.png")
        self.m_pSelectedRoleImage : setControlName( "this CSelectRoleView self.m_pSelectedRoleImage 153 ")
		self.m_pContainer :addChild(self.m_pSelectedRoleImage, -97)

--角色资料
		self.m_pLabLevel = CCLabelTTF :create(CLanguageManager:sharedLanguageManager():getString("SelectRoleView_Label_Level"), CSelectRoleView.FONTFAMILY, CSelectRoleView.FONTSIZE, CCSizeMake(0,0), kCCTextAlignmentLeft)
		self.m_pContainer :addChild(self.m_pLabLevel, -97)

		self.m_pLabTitle = CCLabelTTF :create(CLanguageManager:sharedLanguageManager():getString("SelectRoleView_Label_Title") .. "超级互撸娃", CSelectRoleView.FONTFAMILY, CSelectRoleView.FONTSIZE, CCSizeMake(0,0), kCCTextAlignmentLeft)
		self.m_pContainer:addChild(self.m_pLabTitle, -97)

--进入游戏
		local function onEnterGameTouchCallback(eventType, obj, x, y)
            print("eventType",eventType)
			return self:onEnterGameBtnTouchCallback(eventType, obj, x, y)
		end
		self.m_pEnterGameBtn = CButton :createWithSpriteFrameName(CLanguageManager :sharedLanguageManager():getString("SelectRoleView_Button_EnterGame"), "general_four_button_normal.png")
        self.m_pEnterGameBtn : setControlName( "this CSelectRoleView self.m_pEnterGameBtn 161 " )
		self.m_pEnterGameBtn:setFontFamily(CSelectRoleView.FONTFAMILY)
		self.m_pEnterGameBtn:setFontSize(CSelectRoleView.FONTSIZE)
		self.m_pEnterGameBtn:registerControlScriptHandler(onEnterGameTouchCallback, "this CSelectRoleView self.m_pEnterGameBtn 171")
		self.m_pContainer:addChild(self.m_pEnterGameBtn, -96)
	elseif _winSize.height == 768 then
		--self.m_pRoleListBackground = CSprite:createWithSpriteFrameName("general_second_underframe.png")
		
	end
end

function CSelectRoleView.layout(self, _winSize)
	--背景定位
	self.m_pBackground :setPosition(ccp(_winSize.width/2, _winSize.height/2))

	local roleListBackgroundSize = self.m_pRoleListBackground :getPreferredSize()
	local rolePanelBackgroundSize = self.m_pRolePanelBackground :getPreferredSize()
	local serverListBackgroundSize = self.m_pServerListBackground :getPreferredSize()
	local roleBackgroundSize = self.m_pRoleBackground :getPreferredSize()

	self.m_pRoleListBackground :setPosition(ccp(_winSize.width/2 - (rolePanelBackgroundSize.width + roleListBackgroundSize.width)/2 - 20, _winSize.height/2))
	self.m_pRolePanelBackground :setPosition(ccp(_winSize.width/2, _winSize.height/2))
	self.m_pServerListBackground :setPosition(ccp(_winSize.width/2 + (rolePanelBackgroundSize.width + serverListBackgroundSize.width)/2 + 20, _winSize.height/2))
	self.m_pRoleBackground :setPosition(ccp(_winSize.width/2, _winSize.height/2 + rolePanelBackgroundSize.height/2 - roleBackgroundSize.height / 2 - 35))
	--角色列表定位
	self.m_pRoleListLayout :setPosition(_winSize.width/2 - (rolePanelBackgroundSize.width/2 + roleListBackgroundSize.width ) - 15, self.m_pRoleListBackground:getPositionY() - roleListBackgroundSize.height / 2 + 35 )
	self.m_pServerListLayout :setPosition(_winSize.width/2 + (rolePanelBackgroundSize.width/2) + 28, self.m_pRoleListBackground:getPositionY() - roleListBackgroundSize.height / 2 + 35 )

	--
	self.m_pSelectedRoleImage :setPosition(ccp(self.m_pRoleBackground:getPosition()))
	self.m_pLabLevel :setPosition(ccp(_winSize.width/2, _winSize.height/2 - 60))
	self.m_pLabTitle :setPosition(ccp(_winSize.width/2, _winSize.height/2 - 100))
	self.m_pEnterGameBtn :setPosition(ccp(_winSize.width/2, _winSize.height/2 - 180))
end


function CSelectRoleView.scene(self)
	local winSize	= CCDirector:sharedDirector():getVisibleSize()
	local scene		= CCScene :create()
	self:init(winSize)
	if self.m_pContainer:getParent() ~= nil then
		self.m_pContainer :removeFromParentAndCleanup(false)
	end
	scene:addChild(self.m_pContainer)
	return scene
end




function CSelectRoleView.onEnterGameBtnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		obj:setTouchesEnabled(false)
	    self :socketConnectSever()
		CCLOG("进入游戏 角色ID="..tostring(_G.g_LoginInfoProxy:getUid()).." 服务器="..tostring(_G.g_LoginInfoProxy:getServerId()))
	end
end


function CSelectRoleView.socketConnectSever(self)
    CCLOG("aaaa".. tostring(_G.g_LoginInfoProxy:getServerId()) )
    for k=1,#self.m_pSeverList do
        CCLOG(self.m_pSeverList[k]["ip"],self.m_pSeverList[k]["port"])
        if(tonumber(self.m_pSeverList[k]["sid"])==tonumber(_G.g_LoginInfoProxy:getServerId()))then
            CCLOG(self.m_pSeverList[k]["ip"],self.m_pSeverList[k]["port"])
            CCLOG(self.m_pSeverList[k]["port"])
            local ret = CNetwork :connect(self.m_pSeverList[k]["ip"],self.m_pSeverList[k]["port"])
            if(ret ~=0 )then
                CCLOG("正在连接服务器。。。。。。。")
                --CCMessageBox("正在连接服务器。。。。。。。","asdf")
                self :askSocketRoleLogin()
            else
                CCLOG("服务器没有打开")
                --CCMessageBox("服务器没有打开 ","Error")
                local msg = "无法连接服务器"
                self : createMessageBox(msg)
            end
            break
        end
    end
end

function CSelectRoleView.askSocketRoleLogin(self)
    require "common/protocol/auto/REQ_ROLE_LOGIN"
    local msg = REQ_ROLE_LOGIN()
    msg: setUid(_G.g_LoginInfoProxy:getUid())
    msg: setUuid(_G.LoginInfo.uuid)
    msg: setSid(_G.g_LoginInfoProxy:getServerId())
    msg: setCid(217)
    msg: setOs("ios")
    msg: setPwd(getStringByKey(self.m_pRoleList,"uid","pwd",_G.g_LoginInfoProxy:getUid()))
    msg: setVersions(1.34)
    msg: setFmc(0)
    msg: setRelink(false)
    msg: setDebug(false)
    msg: setLoginTime(getStringByKey(self.m_pRoleList,"uid","login_time",_G.g_LoginInfoProxy:getUid()))
    CNetwork :send(msg)


    CRechargeScene:setRechargeData("username", tostring( CUserCache:sharedUserCache():getObject("userName")))
    CRechargeScene:setRechargeData("roleid", tostring(_G.g_LoginInfoProxy:getUid()))
    CRechargeScene:setRechargeData("serverid", tostring(_G.g_LoginInfoProxy:getServerId()))
end

function getStringByKey(findTable,m_key,m_needStr,m_findStr)
    for k=1, #findTable do
        if( tostring(findTable[k][m_key]) == tostring(m_findStr)) then
            return findTable[k][m_needStr]
        end
    end
end

function CSelectRoleView.onServerBtnTouchCallback( self, eventType, obj, x, y )
	CCLOG("onServerBtn "..eventType)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		local selectedServerId = obj:getTag()
	    self.m_pContainer :setVisible(false)
		if selectedServerId == 0 then
			return self:onMoreServerTouchCallback(eventType, obj, x, y)
		else
			self:setServerId(selectedServerId)
		end
	end
end

function CSelectRoleView.onRoleBtnTouchCallback( self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		local selectedRoleId = obj:getTag()
		if selectedRoleId == 0 then
	   
	   
	        self :socketForCreateRoleConnectServer()

		else
			self:setRoleId(selectedRoleId)
		end
	end
end

function CSelectRoleView.onMoreServerTouchCallback(self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
	    require "view/CreateRoleScene/SelectServerScene"
	    _G.pSelectServerScene = CSelectServerScene()
	    local _startupScene = _G.pSelectServerScene :scene()
	    CCDirector :sharedDirector():pushScene( _startupScene )
		CCLOG("更多服务器列表")
	end
end

function CSelectRoleView.onServerListCallback( self, response )
    CCLOG("onServerListCallback -->")
    local text = response :getResponseText()
    if string.len(text) == 0 then
        --CCMessageBox("Couldn't connect to Server","Error!")
        CCLOG("codeError!!!! Couldn't connect to Server")
        self :getServerList()
        return
    end
    
    self.m_httpSeverString = response:getResponseText()
    
	local strResult = response:getResponseText()
	CCLOG("SERVERLIST == "..strResult)
	local _,_,ref = string.find(strResult, '{"ref":(%d),')
	if ref ~= "1" then
		local _,_,msg = string.find(strResult, '"msg":"([^%s,]+)"')
		--CCMessageBox(msg,"Server List Error")
        CCLOG("codeError!!!! Server List Error "..msg)
		return
	end


	local a1,a2 = string.find(strResult, '"history":%[')
	local b1,b2 = string.find(strResult, '%],', a1)
	local _history = string.sub(strResult, a2, b1)
	self.m_pHistoryServers = parseJSonObjects(_history)

	--recommend
	a1,a2 = string.find(strResult, '"recommend":%[')
	b1,b2 = string.find(strResult, '%],', a1)
	local _recommend = string.sub(strResult, a1, b1)
	self.m_pRecommendServers = parseJSonObjects(_recommend)
    
    --SeverList
    
	a1,a2 = string.find(strResult, '"all":%[')
	b1,b2 = string.find(strResult, '%],', a1)
	local _severList = string.sub(strResult, a1, b1)
	self.m_pSeverList = parseJSonObjects(_severList)

	--读取角色列表
	if self.m_pHistoryServers[1] ~= nil then
		print("go history")
		self:getRoleList( tonumber(self.m_pHistoryServers[1]["sid"]) )
		if _G.g_LoginInfoProxy:getServerId() == -1 then
			_G.g_LoginInfoProxy:setServerId( tonumber(self.m_pHistoryServers[1]["sid"]) )
		end
	elseif self.m_pRecommendServers[1] ~= nil then
		print("go recommend")
		self:getRoleList( tonumber(self.m_pRecommendServers[1]["sid"]) )
		if _G.g_LoginInfoProxy:getServerId() == -1 then
			_G.g_LoginInfoProxy:setServerId( tonumber(self.m_pRecommendServers[1]["sid"]) )
		end
	elseif self.m_pSeverList[1] ~= nil then
		print("go all")
		self:getRoleList( tonumber(self.m_pSeverList[1]["sid"]) )
		if _G.g_LoginInfoProxy:getServerId() == -1 then
			_G.g_LoginInfoProxy:setServerId( tonumber(self.m_pSeverList[1]["sid"]) )
		end
	end
end


function CSelectRoleView.onRoleListCallback(self, response)
    CCLOG("onRoleListCallback -->")
    
    local text = response :getResponseText()
    if string.len(text) == 0 then
       --CCMessageBox("Couldn't connect to Server","Error!")
        CCLOG("codeError!!!! Couldn't connect to Server")
        self :getServerList()
        return
    end

    
	local strResult = response:getResponseText()
	local _,_,ref = string.find(strResult, '{"ref":(%d),')
	if ref ~= "1" then
		local _,_,msg = string.find(strResult, '"msg":"([^%s,]+)"')
		--CCMessageBox(msg,"Role List Error")
        CCLOG("codeError!!!! Role List Error "..msg)
		return
	end
    

	local a1,a2 = string.find(strResult, '"role_list":%[')
	local b1,b2 = string.find(strResult, '%],',a1)
	local _roleList = string.sub(strResult, a2, b1)
	self.m_pRoleList = parseJSonObjects(_roleList)

    self :setRoleList( self.m_pRoleList )
    self.m_pContainer :setVisible(true)
    if self.m_bIsInit == false then
        local initData = VO_SelectRoleModel( self.m_pHistoryServers, self.m_pRecommendServers, nil, self.m_pRoleList)
        local initCmd = CSelectRoleInitCommand(initData)
        controller:sendCommand(initCmd)
        self.m_bIsInit = true
    end
    --_G.pSelectRoleView :getServerList()
end



function CSelectRoleView.setServerId(self, _serverId)
	for i = 1, table.maxn(self.m_pServerBtn) do
		if self.m_pServerBtn[i]:getTag() == tonumber(_serverId) then
			self.m_pServerBtn[i]:setColor(ccc4(255,255,0,255))
			self:getRoleList(_serverId)
		else
			self.m_pServerBtn[i]:setColor(ccc4(255,255,255,255))
		end
	end
    _G.g_LoginInfoProxy:setServerId(tonumber(_serverId))
end

function CSelectRoleView.setRoleId(self, _roleId)
	local numRoleId = tonumber(_roleId)
	for i = 1, 6 do
		if self.m_pRoleBtn[i]:getTag() == numRoleId then
			self.m_pRoleBtn[i]:setColor(ccc4(255,255,0,255))
		else
			self.m_pRoleBtn[i]:setColor(ccc4(255,255,255,255))
		end 
	end
	for i = 1, table.maxn(self.m_pRoleList) do
		if tonumber(self.m_pRoleList[i].uid) == numRoleId then
			self.m_pLabLevel:setString(CLanguageManager :sharedLanguageManager():getString("SelectRoleView_Label_Level")..tostring(self.m_pRoleList[i].lv))
			self.m_pLabTitle:setString(CLanguageManager :sharedLanguageManager():getString("SelectRoleView_Label_Title")..tostring(self.m_pRoleList[i].pro))
			self.m_pSelectedRoleImage :setImageWithSpriteFrameName("login_big_player"..tostring(self.m_pRoleList[i].pro)..".png")
			break
		end
	end
    _G.g_LoginInfoProxy:setUid( numRoleId )
end

function CSelectRoleView.setRoleList(self, _roleListTable)
	local bAutoSelect = false
	for i = 1,6 do
		local _roleData = _roleListTable[i]
		if _roleData == nil then
			self.m_pRoleBtn[i]:setText(CLanguageManager:sharedLanguageManager():getString("SelectRoleView_Button_NewPlayer"))
			self.m_pRoleBtn[i]:setTag(0)
		else
			self.m_pRoleBtn[i]:setText(_roleData.uname)
			self.m_pRoleBtn[i]:setTag( tonumber(_roleData.uid) )
			if bAutoSelect == false then
				bAutoSelect = true
				self:setRoleId(_roleData.uid)
			end
		end
	end
end

function CSelectRoleView.setServerList(self, _serverListTable)
    
	local len = table.maxn(_serverListTable)

	print(len, "lenlen")
	if len > 1 then	--2
		self.m_pServerBtn[1]:setText(_serverListTable[1].name)
		self.m_pServerBtn[1]:setTag(self.m_pHistoryServers[1]["sid"])
        if _G.g_LoginInfoProxy:getServerId() == tonumber(self.m_pHistoryServers[1]["sid"]) then
			self.m_pServerBtn[1]:setColor(ccc4(255,255,0,255))
		end
		self.m_pServerBtn[2]:setText(_serverListTable[2].name)
		self.m_pServerBtn[2]:setTag(self.m_pRecommendServers[1]["sid"])
	elseif len > 0 then
		self.m_pServerBtn[1]:setText(_serverListTable[1].name)
		self.m_pServerBtn[1]:setTag(_serverListTable[1].sid)
		self.m_pServerBtn[1]:setColor(ccc4(255,255,0,255))

		self.m_pServerBtn[2]:setText(_serverListTable[1].name)
		self.m_pServerBtn[2]:setTag(_serverListTable[1].sid)
	end
	self.m_pServerBtn[3]:setText(CLanguageManager:sharedLanguageManager():getString("SelectRoleView_Button_MoreServer"))
	self.m_pServerBtn[3]:setTag(0)
end
--获取服务器列表
function CSelectRoleView.getServerList(self)
	local function serverListCallback(response)
		self:onServerListCallback(response)
	end
    local getServerListRequest = CCHttpRequest()

    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping 

    local strTemp = "cid=".._G.LoginConstant.CID.."&uuid="..tostring(_G.LoginInfo.uuid).."&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY
    CCLOG("SERVERLIS1 == "..strTempWithKey)
    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )

    local strUrl = _G.netWorkUrl .. "/api/Phone/ServList?"..tostring(strTemp).."&sign="..tostring(strMD5)
    -- CCLOG("SERVERLIS2 == "..strUrl)
    getServerListRequest : setUrl( strUrl )

    getServerListRequest : setRequestType(0)
    getServerListRequest : setLuaCallback( serverListCallback )
    --CCHttpClient:getInstance():setTimeoutForConnect(5.0)
    --CCHttpClient:getInstance():setTimeoutForRead(5.0)
    CCHttpClient :getInstance():send(getServerListRequest)
end

--获取用户列表
function CSelectRoleView.getRoleList(self, _serverId)
	local function roleListCallback(response)
		self :onRoleListCallback(response)
	end

    
	local getRoleListRequest = CCHttpRequest()
    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping 
    local fcm = "0";  -- by:yiping 
    local fcmId = "";  -- by:yiping 

    local strTemp = "cid=".._G.LoginConstant.CID.."&sid="..tostring(_serverId).."&uuid="..tostring(_G.LoginInfo.uuid).."&fcm="..fcm.."&fcm_id="..fcmId.."&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY
    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )
    local strUrl = _G.netWorkUrl .. "/api/Phone/RoleList?"..tostring(strTemp).."&sign="..tostring(strMD5)


    print("get role list", strUrl)

    getRoleListRequest:setUrl(strUrl)
    getRoleListRequest:setRequestType(0)
    getRoleListRequest:setLuaCallback( roleListCallback )
    --CCHttpClient:getInstance():setTimeoutForConnect(5.0)
    --CCHttpClient:getInstance():setTimeoutForRead(5.0)
    CCHttpClient:getInstance():send(getRoleListRequest)
end

function CSelectRoleView.getSelectedServerID(self)
    return _G.g_LoginInfoProxy:getServerId()
end

function CSelectRoleView.getSelectedUid(self)
    return _G.g_LoginInfoProxy:getUid()
end

function CSelectRoleView.setSelectedUid(self,_uid)
    return _G.g_LoginInfoProxy:setUid(_uid)
end

function CSelectRoleView.getSelectedServer(self)

    
    for i = 1, table.maxn(self.m_pHistoryServers) do
        if self.m_pHistoryServers[i].sid == tonumber(self:getSelectedServerID()) then
            return self.m_pHistoryServers[i]
        end
    end
    for i = 1, table.maxn(self.m_pRecommendServers) do
        if self.m_pRecommendServers[i].sid == tonumber(self:getSelectedServerID()) then
            return self.m_pRecommendServers[i]
        end
    end
    return nil
end



function CSelectRoleView.getServerListForView(self)
   return self.m_pSeverList
end


function CSelectRoleView.socketForCreateRoleConnectServer(self)
    for i = 1, table.maxn(self.m_pSeverList) do
        if(tonumber(_G.g_LoginInfoProxy:getServerId())==tonumber(self.m_pSeverList[i]["sid"])) then

            local ret = CNetwork :connect(self.m_pSeverList[i]["ip"],self.m_pSeverList[i]["port"])

            if(ret ~=0 )then
                require "common/Network"
                require "view/CreateRoleScene/CreateRoleScene"
                _G.pCreateRoleScene = CCreateRoleScene()
                local _startupScene = _G.pCreateRoleScene :scene()
                CCDirector :sharedDirector():replaceScene( _startupScene )
                CCLOG("创建玩家")
            else
                CNetwork :disconnect()
                CCLOG("无法连接服务器")
            end
            break
        end
    end
end

function CSelectRoleView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end
