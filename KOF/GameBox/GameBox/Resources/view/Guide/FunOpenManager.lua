require "view/view"
require "common/Constant"

require "controller/GuideCommand"
require "view/Guide/FunOpenView"
require "view/Guide/FunNoticView"
-- require "controller/PlotCommand"
-- _G.pCGuideManager

CFunOpenManager = class(view,function ( self )

	self.m_isStart = true

	self.m_funOpenView  = nil
	self.m_funNoticView = nil

	self.m_funNoticNodeList = {}
	self.m_nowNoticNode = nil

	self:loadXml()

	self:initColor()
end)



CFunOpenManager.FunOpen_ZOrder  = 999
CFunOpenManager.FunNotic_ZOrder = 350

-- CFunOpenManager.FunNotic_ADD_TYPE_NETWORK = 1
-- CFunOpenManager.FunNotic_ADD_TYPE_LOCAL   = 2

CFunOpenManager.FunNotic_TYPE_NOW   = 1
CFunOpenManager.FunNotic_TYPE_NEXT  = 2
CFunOpenManager.FunNotic_TYPE_NODE  = 3
CFunOpenManager.FunNotic_TYPE_SCENE = 4


function CFunOpenManager.setManagerState( self, _bool )
	self.m_isStart = _bool
end


--æææææææææææææææææææææææææææææææææææææææææææææ
--      XML资源管理
--æææææææææææææææææææææææææææææææææææææææææææææ
function CFunOpenManager.loadXml( self )
	print("加载CFunOpenManager-XML")  --sys_remind.xml
    _G.Config:load("config/sys_remind.xml")

    _G.Config:load("config/logs.xml")
end

function CFunOpenManager.unloadXml( self )
	print("释放CFunOpenManager-XML")
end

function CFunOpenManager.getFunNodeById( self, _funId )
	CCLOG("CFunOpenManager.getFunNodeById---->   _funId=".._funId)

	if _funId == nil then
		return nil
	end

	return _G.Config.sys_reminds :selectSingleNode( "sys_remind[@sys_id="..tostring(_funId).."]" )

end

function CFunOpenManager.getNoticNodeById( self, _noticId )
	CCLOG("CFunOpenManager.getNoticNodeById---->   _noticId=".._noticId)

	if _noticId == nil then
		return nil
	end

	return _G.Config.logss :selectSingleNode( "logs[@id="..tostring(_noticId).."]" )

end

--自动换行    关键字-> "&#13;"
function CFunOpenManager.getNewStrOnLineChuange( self, _str )
	if _str == nil then
		return "getNewStr ~~~~~~   传进来的str为空"
	end

	local newString = ""

    local posStart = 1
    -- local posEnd   = 1
    -- local strEnd   = 1

    for i=1,10 do

        local posEnd,strEnd = string.find(_str,"&#13;", posStart)

        if posEnd ~= nil then
            newString = newString..string.sub( _str, posStart, posEnd-1 ).."\n"
            posStart =  strEnd + 1

        elseif posStart == 1 then
            return _str
        else
            return newString..string.sub( _str, posStart, #_str )
        end
    end

    return newString
end



--æææææææææææææææææææææææææææææææææææææææææææææ
--      功能开放
--æææææææææææææææææææææææææææææææææææææææææææææ
--展示功能开放界面
function CFunOpenManager.showFunOpenView( self, _funId )
	print("CFunOpenManager.showFunOpenView   111")
	if self.m_isStart ~= true or _funId == nil then
		return
	end

	print("CFunOpenManager.showFunOpenView   222")

	local funNode = self:getFunNodeById( _funId )
	if funNode:isEmpty() then
		print("功能开放,不需要提示.")
		return
	end

	print("CFunOpenManager.showFunOpenView   333")

	--关闭之前的界面
	self:closeFunOpenView()

	print("CFunOpenManager.showFunOpenView   444")

	--创建新的界面
	self.m_funOpenView = CFunOpenView()
	local funOpenLayer = self.m_funOpenView:create( funNode )
	_G.g_Stage:getScene() : addChild( funOpenLayer, CFunOpenManager.FunOpen_ZOrder )

	print("CFunOpenManager.showFunOpenView   555")

end

--关闭功能开放界面
function CFunOpenManager.closeFunOpenView( self )
	if self.m_funOpenView ~= nil then
		self.m_funOpenView : closeView()
		self.m_funOpenView = nil
	end
end

--功能开放界面已关闭
function CFunOpenManager.resetFunOpenView( self )
	self.m_funOpenView = nil
end














--æææææææææææææææææææææææææææææææææææææææææææææ
--      系统功能提示
--æææææææææææææææææææææææææææææææææææææææææææææ
--添加一个提示
function CFunOpenManager.addOneNotic( self, _msg )

	if _msg == nil or self.m_isStart ~= true then
		return
	end

	for i,v in ipairs(self.m_funNoticNodeList) do
		if tonumber(v.msg.id) == tonumber(_msg.id) then
			--已存在相同的提示了
			return
		end
	end

	if self.m_nowNoticNode ~= nil then
		if tonumber(self.m_nowNoticNode.msg.id) == tonumber(_msg.id) then
			--当前显示的就是改提示
			return
		end
	end

	local _noticId = _msg.id

	local noticNode = self:getNoticNodeById( _noticId )
	if noticNode:isEmpty() then
		CCLOG("CFunOpenManager.addOneNotic--->  [noticNode == nil]")
		return
	end

	-- local openId = tonumber( noticNode:getAttribute("open") )
	-- if openId ~= 0 then
	-- 	if self:isFunOpen( openId ) == false then
	-- 		--此功能没有开放 不显示
	-- 		print("CFunOpenManager.addOneNotic--->  此功能没有开放")
	-- 		return
	-- 	end
	-- end

	local list = {}
	list.node = noticNode
	list.msg  = _msg

	--添加成功
	table.insert( self.m_funNoticNodeList, list )

	print("[功能提醒]   添加一条数据->".._noticId..  "当前总个数->"..#self.m_funNoticNodeList)

	--尝试打开新提示
	self:showOneNotic( CFunOpenManager.FunNotic_TYPE_NODE, list )

                                              

--[[
	if _noticId == nil or self.m_isStart ~= true then
		return
	end


	local noticNode = self:getNoticNodeById( _noticId )
	if noticNode == nil then
		CCLOG("CFunOpenManager.addOneNotic--->  [noticNode == nil]")
		return
	end

	if _G.g_Stage:getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY then
		--不在主城
		table.insert( self.m_funNoticNodeList, noticNode )
		return
	end

	if self.m_funNoticView == nil then
		self:createNoticView()
	end

	local isAdd = self.m_funNoticView:addOneNotic( noticNode )
	if isAdd == false then
		--添加不成功
		CCLOG("CFunOpenManager.addOneNotic--->  [isAdd == false] _noticId=".._noticId)
		return
	end

	--添加成功
	table.insert( self.m_funNoticNodeList, noticNode )

]]

end



function CFunOpenManager.delNowNoticAndGoNext( self )

	self:closeNoticView()

	self:showOneNotic( CFunOpenManager.FunNotic_TYPE_NEXT )

end

function CFunOpenManager.delNodeFromList( self, _node )


	if _node ~= nil then

		--删除List里面的该节点
		local index = nil
		for i,vv in ipairs(self.m_funNoticNodeList) do
			if tonumber( vv.node.id ) == tonumber( _node.node.id ) then
				index = i
			end
		end
		if index ~= nil then
			table.remove( self.m_funNoticNodeList, index )
		end

	end

end

function CFunOpenManager.showOneNotic( self, _type, _noticNode )

	local noticNode = nil

	print("showOneNotic   |   111",_type,#self.m_funNoticNodeList,self.m_nowNoticNode)

	if _G.g_Stage:getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY then
		--不在主城
		print("--不在主城")
		return
	end

	if self.m_funNoticView ~= nil and _type ~= CFunOpenManager.FunNotic_TYPE_SCENE then
		--当前存在 提示界面  (且不是转换场景)
		print("--当前存在 提示界面")
		return
	end

	if _type == CFunOpenManager.FunNotic_TYPE_NOW then
		--打开当前界面
		noticNode = self.m_nowNoticNode
	elseif _type == CFunOpenManager.FunNotic_TYPE_NODE then
		--打开传进来的提示界面
		noticNode = _noticNode
	elseif _type == CFunOpenManager.FunNotic_TYPE_NEXT then
		--打开下一个提示界面
		if #self.m_funNoticNodeList > 0 then
			noticNode = self.m_funNoticNodeList[1]
		else
			self.m_nowNoticNode = nil
			return
		end
	elseif _type == CFunOpenManager.FunNotic_TYPE_SCENE then
		--转换场景时 , 显示上个场景的提示
		noticNode = self.m_nowNoticNode
		if noticNode == nil then
			--显示下一个提示界面
			if #self.m_funNoticNodeList > 0 then
				noticNode = self.m_funNoticNodeList[1]
			else
				self.m_nowNoticNode = nil
				return
			end
		end
	end

	if noticNode == nil then
		self.m_nowNoticNode = nil
		print("showOneNotic   |   222")
		return
	end


	self:createNoticView()

	local isAdd = self.m_funNoticView:addOneNotic( noticNode )
	if isAdd == false then
		--添加不成功
		CCLOG("CFunOpenManager.addOneNotic--->  [isAdd == false] _noticId=".._noticNode.id)
		self.m_nowNoticNode = nil
		self:closeNoticView()
		return
	end

	print("showOneNotic   |   222")

	--当前显示的节点
	self.m_nowNoticNode = noticNode


	if _type ~= CFunOpenManager.FunNotic_TYPE_NOW then
		--删除List里面的该节点
		self:delNodeFromList( noticNode )
	end

	print("[展示新的功能提示界面后]    剩余需要显示的数量为->"..#self.m_funNoticNodeList)

    _G.g_CTaskNewDataProxy :playMusicByName( "point_out" )
end

function CFunOpenManager.showAllNotic( self )

	if #self.m_funNoticNodeList <= 0 then
		return
	end

	if _G.g_Stage:getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY then
		--不在主城
		return
	end

	self:createNoticView()

	for i,noticNode in ipairs(self.m_funNoticNodeList) do
		self.m_funNoticView:addOneNotic( noticNode )
	end

end

--创建提示界面
function CFunOpenManager.createNoticView( self )
	--关闭之前的界面
	self:closeNoticView()

	self.m_funNoticView = CFunNoticView()
	local noticLayer = self.m_funNoticView : create()
	_G.g_Stage:getScene() : addChild( noticLayer, CFunOpenManager.FunNotic_ZOrder )


end

--删除当前提示节点 且 关闭提示界面
-- function CFunOpenManager.delNoticView( self )

-- 	self.m_nowNoticNode = nil

-- 	if self.m_funNoticView ~= nil then
-- 		self.m_funNoticView : closeView()
-- 		self.m_funNoticView = nil
-- 	end
-- end

--关闭提示界面
function CFunOpenManager.closeNoticView( self )
	if self.m_funNoticView ~= nil then
		self.m_funNoticView : closeView()
		self.m_funNoticView = nil
	end
end

--提示界面已关闭
function CFunOpenManager.resetNoticView( self )
	self.m_funNoticView  = nil
	self.m_nowNoticNode  = nil
	-- self.m_funNoticNodeList = {}
end





--æææææææææææææææææææææææææææææææææææææææææææææ
--      跳转界面
--æææææææææææææææææææææææææææææææææææææææææææææ
function CFunOpenManager.getActivityOpenType(self, _id)

    local tag  		   = 0
    local chuangType   = nil
    local activityType = 1
    local id = tonumber( _id )
    print("--- 前往--->"..id)
    if id == _G.Constant.CONST_MAP_HERO_COPY then
        --精英副本
        activityType = 102
        tag = _G.Constant.CONST_FUNC_OPEN_ELITE
    elseif id == _G.Constant.CONST_MAP_FIEND_COPY then
        --魔王副本
        activityType = 103
        tag = _G.Constant.CONST_FUNC_OPEN_DEVIL
    elseif id == _G.Constant.CONST_MAP_OPEN_COM_COPY then
        --打开-普通副本
        activityType = 101
        tag = 100


    elseif id == _G.Constant.CONST_MAP_DAILY then
        --打开日常任务
        tag = _G.Constant.CONST_FUNC_OPEN_STRENGTH
    elseif id == _G.Constant.CONST_MAP_BOSS then
        --打开世界BOSS
        tag = _G.Constant.CONST_FUNC_OPEN_BOSS
    elseif id == _G.Constant.CONST_MAP_ARENA then
        --打开竞技场
        tag = _G.Constant.CONST_FUNC_OPEN_LISTS
    elseif id == _G.Constant.CONST_MAP_MONEY then
        --打开招财
        tag = _G.Constant.CONST_FUNC_OPEN_MONEYTREE

    elseif id == _G.Constant.CONST_MAP_FANFANLE then
        --打开翻翻乐
        tag = _G.Constant.CONST_FUNC_OPEN_GAMBLE
    elseif id == _G.Constant.CONST_MAP_YIJIAN then
        --打开每日一箭
        tag = _G.Constant.CONST_FUNC_OPEN_WEAPON
    elseif id == _G.Constant.CONST_MAP_FIGHTERS then
        --打开拳皇生涯
        tag = _G.Constant.CONST_FUNC_OPEN_OVERCOME
    elseif id == _G.Constant.CONST_MAP_WONDERFUL_ACTIVITIES then
    	--打开精彩活动
    	tag = _G.Constant.CONST_FUNC_OPEN_ELIMINATE
    elseif id == _G.Constant.CONST_MAP_DAILY_SIGN then
    	--打开每日签到
    	tag = _G.Constant.CONST_FUNC_OPEN_INLAY


------------------------------------------------------------------------
------------------------------------------------------------------------
    elseif id == _G.Constant.CONST_MAP_PLAYER then
    	--打开人物界面
    	activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_ROLE
    elseif id == _G.Constant.CONST_MAP_SKILL then
    	--打开人物界面------技能界面
    	activityType = 2
    	chuangType   = 203
        tag = _G.Constant.CONST_FUNC_OPEN_ROLE
    elseif id == _G.Constant.CONST_MAP_STRENGTHEN then
    	--打开强化
    	activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_STRENGTHEN
    elseif id == _G.Constant.CONST_MAP_INSET then
    	--打开强化 -- 镶嵌界面
    	activityType = 2
    	chuangType   = 2
        tag = _G.Constant.CONST_FUNC_OPEN_STRENGTHEN
    elseif id == _G.Constant.CONST_MAP_DOUQI then
        --打开斗气
        activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_STAR
    elseif id == _G.Constant.CONST_MAP_TREASURE then
        --打开珍宝
        activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_JEWELLERY
    elseif id == _G.Constant.CONST_MAP_TREASURE_SHOP then
        --打开珍宝 -- 商店
        activityType = 2
        chuangType   = 3
        tag = _G.Constant.CONST_FUNC_OPEN_JEWELLERY
    elseif id == _G.Constant.CONST_MAP_OPEN_BAG then
        --打开背包
        activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_BAG
    elseif id == _G.Constant.CONST_MAP_TASK then
    	--打开背包
        activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_MAIN_TASK
    elseif id == _G.Constant.CONST_MAP_COMMUNITY then
    	--打开社团界面
        activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_GUILD
    elseif id == _G.Constant.CONST_MAP_GOD then
    	--打开神器
    	activityType = 2
        tag = _G.Constant.CONST_FUNC_OPEN_ARTIFACT
    
------------------------------------------------------------------------
------------------------------------------------------------------------
    elseif id == _G.Constant.CONST_MAP_GIFT then
    	--打开首充礼包
    	activityType = 3
    	tag = _G.Constant.CONST_SALES_ID_PAY_ONCE

    elseif id == _G.Constant.CONST_MAP_BAR then
    	--打开酒吧
    	activityType = 4
    	tag = _G.Constant.CONST_FUNC_OPEN_PARTNER

    elseif id == _G.Constant.CONST_MAP_STRATEGY then
    	--打开我要变强
    	activityType = 5
    	tag = _id
    elseif id == _G.Constant.CONST_MAP_CHAPPER_SHOP then
    	--打开优惠商店
    	activityType = 6
    	tag = _id
    elseif id == _G.Constant.CONST_MAP_WONDERFUL_ADD_PAY then
    	--打开精彩活动-累计充值活动
    	activityType = 11
    	tag = _id


    end

    return tag,activityType,chuangType

end

--根据活动Id找到对应的功能开放Id
function CFunOpenManager.openActivityById( self, _id, _type )

	local tag,activityType,chuangType = self:getActivityOpenType( _id )
	if tag == 0 then
        CCLOG( "CFunOpenManager.openActivityById  111")
        return
    elseif tag == 100 or tag == _G.Constant.CONST_FUNC_OPEN_ELITE or tag == _G.Constant.CONST_FUNC_OPEN_DEVIL then
        --打开-普通副本  精英   魔王
        require "view/DuplicateLayer/DuplicateSelectPanelView"
        --清除任务信息
        local roleProperty = _G.g_characterProperty : getMainPlay()
        roleProperty :setTaskInfo()

        local tempview = CDuplicateSelectPanelView()
        self : pushLuaScene( tempview :scene(activityType))
    else
        if activityType == 2 then
        	--功能按钮
            if _G.pCSMenuView ~= nil then
                _G.pCSMenuView : openFunctionViewByTag( tag, 1 )

                if chuangType ~= nil then 
                	self:chuangeViewByIdAndType(tag,chuangType)
                end
            else
                CCLOG( "CFunOpenManager.openActivityById  222")
            end
        elseif activityType == 3 then
        	--首充礼包
        	require "view/FirstTopupGift/FirstTopupGiftView"
    		self : pushLuaScene(CFirstTopupGiftView () :scene(tag,0))

    	elseif activityType == 4 then
    		--酒吧
    		require "view/BarPanelLayer/BarPanelView"
    		_G.pBarPanelView = CBarPanelView()
            self :pushLuaScene( _G.pBarPanelView :scene())
        elseif activityType == 5 then
        	--我要变强
        	require "view/Strategy/StrategyView"
            self : pushLuaScene(CStrategyView () :scene())
        elseif activityType == 6 then
        	--优惠商店
        	require "view/SuperDealsShop/SuperDealsShopLayer"
        	self : pushLuaScene(CSuperDealsShopLayer () :scene())
        elseif activityType == 11 then
        	--打开精彩活动-累计充值活动
        	require "view/Activities/ActivitiesView"
	        local view = CActivitiesView(501,0)
	        self : pushLuaScene(view :scene())
        else
        	--活动按钮
            if _G.pCActivityIconView ~= nil then
                _G.pCActivityIconView : openActivityViewById( tag, 1 )

                if chuangType ~= nil then 
                	self:chuangeViewByIdAndType(tag,chuangType)
                end
            else
                CCLOG( "CFunOpenManager.openActivityById  333")
            end
        end
    end
end

function CFunOpenManager.pushLuaScene( self, _scene )
    if _scene ~= nil then
    	local pScene = CCTransitionCrossFade :create( 0.5, _scene) 
        _G.pCFunctionOpenProxy :pushEffectScene( pScene, 0.5 )
    else
        CCLOG("肿么了，传个空场景进来啊！！！！")
    end
end

function CFunOpenManager.chuangeViewByIdAndType( self, _openId, _chuangeType )

	if _openId == nil or _chuangeType == nil then
		return
	end

	print("chuangeViewByIdAndType--->",_openId,_chuangeType)

	local openId 	 = tonumber( _openId )
	local chuangType = tonumber( _chuangeType )

	if openId == _G.Constant.CONST_FUNC_OPEN_ROLE then
		--人物界面
		if _G.g_CharacterPanelView ~= nil then
			_G.g_CharacterPanelView:createViewByTag( chuangType )
		end
	elseif openId == _G.Constant.CONST_FUNC_OPEN_JEWELLERY then
		--珍宝界面
		if _G.g_CTreasureHouseInfoView ~= nil then
			_G.g_CTreasureHouseInfoView :chuangePageByType( chuangType )
		end
	elseif openId == _G.Constant.CONST_FUNC_OPEN_STRENGTHEN then
		--强化界面
		if _G.g_CEquipInfoView ~= nil then
			_G.g_CEquipInfoView:chuangePageByTag( chuangType )
		end
	end

end

--判断此功能是否开放   参数->场景的打开某某界面
function CFunOpenManager.isFunOpen( self, _openId )

    print( "isFunOpen--->".._openId )

    if _openId == nil then
    	return
    end

    --获取功能开放Id
    local _funId, _activityType = self:getActivityOpenType( _openId )

    --获取功能开放列表
    local openFunList = {}
    if _G.pCFunctionOpenProxy :getInited() then
        openFunList = _G.pCFunctionOpenProxy :getSysId()
    end

    if _funId == _G.Constant.CONST_FUNC_OPEN_MAIL then
        --普通副本
        return true
    end

    --查找是否开放
    for i,v in ipairs(openFunList) do
        print("isFunOpen 11->",v.id,_funId)
        if tonumber(v.id) == tonumber(_funId) then
            return true
        end
    end

    return false
end


function CFunOpenManager.initColor( self )

	self.m_color = {}
    self.m_color[1] = ccc4( 255, 255, 255, 255 )
    self.m_color[2] = ccc4( 24, 220, 3, 255 )
    self.m_color[3] = ccc4( 0, 0, 255, 255 )
    self.m_color[4] = ccc4( 160, 0, 83, 255 )
    self.m_color[5] = ccc4( 237, 234, 0, 255 )
    self.m_color[6] = ccc4( 255, 126, 0, 255 )
    self.m_color[7] = ccc4( 255, 0, 0, 255 )

end

function CFunOpenManager.getColorByType( self, _type )

	if _type == nil then
		return self.m_color[1]
	end

	local iType = tonumber( _type )

	if self.m_color[iType] ~= nil then
		return self.m_color[iType]
	else
		return self.m_color[1]
	end

end



_G.g_CFunOpenManager = CFunOpenManager()






