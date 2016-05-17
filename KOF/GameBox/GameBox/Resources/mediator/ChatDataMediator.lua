require "mediator/mediator"
require "common/MessageProtocol"
require "model/VO_ChatDataModel"
require "controller/ChatCommand"

require "controller/LogsCommand"

CChatDataMediator = class(mediator,function(self,_view)
	self.name = "CChatDataMediator"
	self.view = _view
end)

function CChatDataMediator.processCommand( self, _command )
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol.ACK_CHAT_RECE then
			self:ACK_CHAT_RECE( ackMsg )
			return true
		elseif msgID == _G.Protocol.ACK_SYSTEM_BROADCAST then -- [810]游戏广播 -- 系统
			self :ACK_SYSTEM_BROADCAST( ackMsg)
			--reterun true
		elseif msgID == _G.Protocol.ACK_SYSTEM_NOTICE then -- (手动) -- [800]系统通知 -- 系统 跑马灯
			self :ACK_SYSTEM_NOTICE( ackMsg)
			--return true
		end

	end
	return false
end

function CChatDataMediator.ACK_SYSTEM_BROADCAST(self, ackMsg)
	print( "-- [810]游戏广播 -- 系统 CChatDataMediator ~~~~~~~~~~~~~~~~~")
	--格式化数据
	_G.pDateTime : reset()
    local nowTime = _G.pDateTime : getTotalMilliseconds()
	--当前时间
	local broadcast_id = ackMsg :getBroadcastId()
	local msgCount     = ackMsg :getMsgCount()
	local msgData      = ackMsg :getData()


    _G.Config :load( "config/broadcast.xml")
	local tmpNode  = _G.Config.broadcasts :selectSingleNode( "broadcast[@id="..tostring( broadcast_id).."]")
	local tmpStr   = nil
	if tmpNode :isEmpty() then
		tmpStr = "该系统广播节点没有找到"
	else
		local child = tmpNode : children()
		local node = child : get(0,"a")
		tmpStr = node:getAttribute("msg")
	end

    print("msg===>", tmpStr )
    local _msgTable = nil        --封装数据table
    local goodsList = nil
    for i=1, msgCount do
    	local msgStr   = "Error"
    	local tempData = msgData[i]   --ACK_SYSTEM_DATA_XXX 数据
	    local msgtype = tempData :getType() --见常量：CONST_BROAD_*
        
        local msgColor = nil
        local msgUid   = nil
        local msgLv    = nil
        local msgColor_name = nil
        
        if _msgTable == nil then
            _msgTable = {}
        end
        _msgTable[i] = {}
        
        _msgTable[i].type   = msgtype
        _msgTable[i].tmpStr = tmpStr            --表中的信息
        local id = nil        
	    print("+++++>>>> ", msgtype)
	    if msgtype == _G.Constant.CONST_BROAD_PLAYER_NAME then      --1     角色名字
	        msgStr      = "【" .. tempData :getUname() .. "】"
            msgColor    = tempData :getColorName()
            msgUid      = tempData :getUid()
            msgLv       = tempData :getLv()
            msgPro      = tempData :getPro()
            print("角色信息~~~!>", msgStr, msgColor, msgUid, msgLv )

	    elseif msgtype == _G.Constant.CONST_BROAD_CLAN_NAME then    --2     家族名字
	        msgStr  = tempData :getClanName()
	    elseif msgtype == _G.Constant.CONST_BROAD_GROUP_NAME then   --3     团队名字
	        msgStr  = tempData :getGroupName()
	    elseif msgtype == _G.Constant.CONST_BROAD_COPY_ID then      --4     副本Id
	        local copy_id   = tempData :getCopyId()
	        local _checkpoint   = _G.g_DuplicateDataProxy : getDuplicateNameByCopyId( copy_id)
	        local copy_name = "Copy XML Error ID:"..copy_id
	        if _checkpoint ~= nil then
	        	copy_name   = _checkpoint:getAttribute("copy_name")
	        end
	        msgStr = copy_name
	    elseif msgtype == _G.Constant.CONST_BROAD_STRING then       --50    普通字符串
	        msgStr = tempData :getString()
	    elseif msgtype == _G.Constant.CONST_BROAD_NUMBER then       --51    普通数字
			msgStr = tempData :getNumber()
	    elseif msgtype == _G.Constant.CONST_BROAD_MAPID then        --52    地图ID
	        msgStr = tempData :getMapId()
	    elseif msgtype == _G.Constant.CONST_BROAD_COUNTRYID then    --53    阵营ID
	        msgStr = "阵营ID:"..tempData :getCountryId()
	    elseif msgtype == _G.Constant.CONST_BROAD_GOODSID then      --54    物品
	        --self.goods       = reader : readXXXGroup()       -- {物品信息块}
	        local goods    = tempData :getGoods()
		    local goodnode  = _G.g_GameDataProxy :getGoodById( goods.goods_id)
		    --local goodcolor = self :getColorByIndex( goodnode.name_color)
		    local goodname = "Goods XML Error ID:"..goods.goods_id
		    if goodnode ~= nil then
		        goodname = goodnode : getAttribute("goods_name") 
		    end
	        msgStr = goodname
	        print()
	    elseif msgtype == _G.Constant.CONST_BROAD_MONSTERID then    --55    怪物ID
	        _G.Config:load("config/scene_monster.xml")
		    local _index = tempData :getMonsterId()
		    local _node  = _G.Config.scene_monsters:selectSingleNode("scene_monster[@id="..tostring( _index).."]") --节点
		    local monster_name = "scene_monster XML Error "..tempData :getMonsterId()
		    if not _node :isEmpty() then
		    	monster_name = _node:getAttribute("monster_name")
		    end
	        msgStr = " "..monster_name
	    elseif msgtype == _G.Constant.CONST_BROAD_CIRCLE_CHAP then  --56    三界杀卷名ID
	        msgStr = "chap_id:"..tempData :getChapId()
	    elseif msgtype == _G.Constant.CONST_BROAD_REWARD then       --57    奖励内容
	        local _gold          = tempData :getGold()  -- {银元}
	        local _rmb           = tempData :getRmb()  -- {金元}
	        local _star          = tempData :getStar()  -- {星魂}
	        local _renown        = tempData :getRenown()  -- {声望}
	        local _clan_value    = tempData :getClanValue()  -- {帮贡}
	        local _count         = tempData :getCount()  -- {物品数量}
	        if _gold ~= 0 then
	        	msgStr = _gold
	        elseif _rmb ~= 0 then
	        	msgStr = _rmb
	        elseif _star ~= 0 then
	        	msgStr = _star
	        elseif _renown ~= 0 then
	        	msgStr = _renown
	        elseif _clan_value ~= 0 then
	        	msgStr = _clan_value
	        elseif _count ~= 0 then
	        	msgStr = "goods :".._count
	        end
	        --local _goods_msg_no  = reader : readXXXGroup() -- {斗气信息块【48203】}
	        local _goods_msg_no = tempData :getGoodsMsgNo()  --用下标取物品
	        for i=1, _count do
	            print("第 "..i.." 物品:--->")
	            local goods = _goods_msg_no[i]
	            ----加入vo
		        if goodsList == nil then
		        	goodsList = {}
		        end
		        goodsList[i] = {}
		        goodsList[i] = goods
	        end

	        


	    elseif msgtype == _G.Constant.CONST_BROAD_PILROAD_ID then   --58    取经之路名字
	        msgStr = tempData :getPilroadId()
	    elseif msgtype == _G.Constant.CONST_BROAD_NAME_COLOR then   --59    名字颜色
	        msgStr = "color: "..tempData :getColor()
	    elseif msgtype == _G.Constant.CONST_BROAD_STARID then       --60    星阵图ID
	        msgStr = "star_id:"..tempData :getStarId()
	    elseif msgtype == _G.Constant.CONST_BROAD_PARTNER_ID then   --61    伙伴名字
	        msgStr = "partner_id: "..tempData :getPartnerId().."partner_color:"..tempData :getPartnerColor()
	    --elseif msgtype == _G.Constant.CONST_BROAD_GOLD then         --62    获得钱数
	    	--msgStr = msgStr.._G.Constant.CONST_BROAD_GOLD
	        --print("Error ----------- 获得金钱广播常量:",self.type)
        elseif msgtype == _G.Constant.CONST_BROAD_DOUQI_ID then     --62    获得斗气

	        _G.Config:load("config/fight_gas_total.xml")

		    local _index = tempData :getDouqiId().."1"
		    local _node  = _G.Config.fight_gas_totals:selectSingleNode("fight_gas_total[@gas_id2="..tostring( _index).."]") --节点
		    local gas_name = "Douqi XML Error "..tempData :getDouqiId()
		    if not _node :isEmpty() then
		    	gas_name = _node:getAttribute("gas_name")
		    	msgColor = tonumber( _node:getAttribute("color") or "0")
		    end
		    --print("%%%%%:",_node.gas_name, _node.gas_id2, _node.color)
		    id     = tempData :getDouqiId()
            msgStr = gas_name
        elseif msgtype == _G.Constant.CONST_BROAD_VIP_LV then       --63    VIP等级
            msgStr = " "..tempData :getVipLv().." 级"
	    else
	    	msgStr = "未定义:"..msgtype	                                                       -- 未定义
	        print("Error ----------- 未定义的广播常量:")
	    end
        
        --生成一个_msgData 
        _msgTable[i].color      = msgColor
        _msgTable[i].uid        = msgUid
        _msgTable[i].lv         = msgLv
        _msgTable[i].msgStr     = msgStr
        _msgTable[i].pro        = msgPro
        _msgTable[i].id         = id 
        --生成一个_msgData
        
        --self :gsubSymbol( tmpStr, "#" )
        tmpStr =  self : gsub( tmpStr, "#", msgStr )
        print( "tmpStrtmpStr", tmpStr, msgStr)
    end
    print("{{{{{{{[[[[[[:",tmpStr, ackMsg :getPosition(), _G.Constant.CONST_CHAT_MARQUEE_ALL, _G.Constant.CONST_CHAT_ALL )
	if ackMsg :getPosition() == _G.Constant.CONST_CHAT_MARQUEE_ALL or ackMsg :getPosition() == _G.Constant.CONST_CHAT_ALL then
		local vo_data = VO_ChatDataModel( nowTime, _G.Constant.CONST_CHAT_SYSTEM, _msgTable )
		vo_data :setChannelId( _G.Constant.CONST_CHAT_SYSTEM)--ackMsg :getPosition()
		vo_data :setMsg( tmpStr)
		vo_data :setGoodsMsgNo( )
		--更新数据
		self:getView():pushData(vo_data)
		--通知界面,下发最新数据
		local _msgCommand = CChatReceivedCommand(vo_data)
		controller:sendCommand(_msgCommand)
		if ackMsg :getPosition() == _G.Constant.CONST_CHAT_MARQUEE_ALL then
			--跑马灯
			local command = CMarqueeCommand( tmpStr)
        	controller :sendCommand( command )
		end
	elseif ackMsg :getPosition() == _G.Constant.CONST_CHAT_MARQUEE then
		--跑马灯
		local command = CMarqueeCommand( tmpStr)
    	controller :sendCommand( command )
	end
end

function CChatDataMediator.ACK_SYSTEM_NOTICE(self, ackMsg)
	print( "-- (手动) -- [800]系统通知 -- 系统 CChatDataMediator ~~~~~~~~~~~~~~~~~")
	--格式化数据
	_G.pDateTime : reset()
    local nowTime = _G.pDateTime : getTotalMilliseconds()
	--当前时间
	local vo_data = VO_ChatDataModel(nowTime) --error

end

function CChatDataMediator.ACK_CHAT_RECE(self, ackMsg)
	--格式化数据
	_G.pDateTime : reset()
    local nowTime = _G.pDateTime : getTotalMilliseconds()
	--当前时间
	local vo_data = VO_ChatDataModel(nowTime)

	vo_data:setChannelId( ackMsg:getChannelId() )
	vo_data:setSid( ackMsg:getSid() )
	vo_data:setUid( ackMsg:getUid() )
	vo_data:setUserName( ackMsg:getUname() )
	vo_data:setSex( ackMsg:getSex() )
	vo_data:setPro( ackMsg:getPro() )
	vo_data:setLevel( ackMsg:getLv() )
	vo_data:setCountryId( ackMsg:getCountryId() )
	vo_data:setReceiverId( ackMsg:getRUid() )
	vo_data:setTitleList( ackMsg:getTitleId() )
	vo_data:setItemList( ackMsg:getGoodsMsgNo() )
	vo_data:setReceiverUserName( ackMsg:getRName() )
	vo_data:setReceiverPro( ackMsg:getRPro())
	vo_data:setReceiverLv( ackMsg:getRLv())
	vo_data:setMsg( ackMsg:getMsg() )

	vo_data:setArg_type( ackMsg:getArg_type() )
    vo_data:setTeam_id( ackMsg:getTeam_id() )
    vo_data:setCopy_id( ackMsg:getCopy_id() )

    print("lumaaaaa00",ackMsg:getChannelId(),ackMsg:getMsg(),ackMsg:getArg_type(),ackMsg:getTeam_id(),ackMsg:getCopy_id())
	--更新数据
	self:getView():pushData(vo_data)
	--通知界面,下发最新数据
	local _msgCommand = CChatReceivedCommand(vo_data)
	controller:sendCommand(_msgCommand)
end

--去除符号
function CChatDataMediator.gsubSymbol( self, _str, _target )
    local retFirst  = ""
    local retSecond = ""
    
    print( ")____str ", _str )
    
    local isFind = false
    if _str ~= nil then
        local nCount = 1        --计数，去除第二个 _target
        for i=1, string.len( _str ) do
            local tmpStr = string.sub( _str, i, i )
            if tmpStr == _target then
                if nCount == 1 then
                    nCount = nCount + 1
                else
                    isFind = true
                end
                tmpStr = ""
            end
            
            if isFind == false then
                retFirst = retFirst .. tmpStr
            else
                retSecond = retSecond .. tmpStr
            end
                
        end
    end
    
    print( "返回的最终-->", retFirst, " -->   ", retSecond )
    return retFirst, retSecond
end

function CChatDataMediator.gsub( self, _str ,_taget, _source, _color )
    local result=""
    local isfind = false
    local colorStr = CLanguageManager:sharedLanguageManager():getString("CONST_COLOR_"..tostring(_color))
    if colorStr == nil then
        colorStr = "<color:255,255,255,255>"
    else
        colorStr = colorStr.value
    end
    for i=1,string.len(_str) do
        local tmpStr = string.sub(_str,i,i)
        if tmpStr == _taget and isfind == false then
            result = result.._source
            isfind = true
        else
            result = result..tmpStr
        end
    end
    return result
end