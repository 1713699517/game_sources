--*********************************
--2013-8-16 by 陈元杰
--神器强化界面-CArtifactStrengthenView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/Artifact/ArtifactStrengthenMediator"
require "view/LuckyLayer/PopBox"

CArtifactStrengthenView = class(view, function(self)
	self.isTouchGoodsInfo = false
end)

----------------------------
--常量
----------------------------
--按钮tag值
CArtifactStrengthenView.TAG_CLOSE      = 201
CArtifactStrengthenView.TAG_Strengthen = 202
CArtifactStrengthenView.TAG_OneKeySt   = 203

--神器物品 祝福石 护符 勋章 Tag值
CArtifactStrengthenView.TAG_ShenQI   = 301
CArtifactStrengthenView.TAG_Wish     = 302
CArtifactStrengthenView.TAG_HuFu     = 303
CArtifactStrengthenView.TAG_XunZhang = 304

--颜色
CArtifactStrengthenView.RED   = ccc3(255,0,0,255)
CArtifactStrengthenView.GOLD  = ccc3(255,255,0,255)
CArtifactStrengthenView.GREEN = ccc3(120,222,66,255)

--字体大小
CArtifactStrengthenView.FONT_SIZE_LABEL  = 20
CArtifactStrengthenView.FONT_SIZE_BUTTON = 24
function CArtifactStrengthenView.initView( self, _mainSize )
	----------------------------
	--活动背景  关闭按钮
	----------------------------
	local function local_btnTouchCallback(eventType,obj,x,y)
		--按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	local function local_goodsTouchCallback(eventType, obj, touches)
		--物品格子 单击回调
		return self:goodsTouchCallback(eventType, obj, touches)
	end
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CArtifactStrengthenView self.m_mainContainer 53" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

	self.m_mainLeftBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainLeftBg : setControlName( "this CArtifactStrengthenView self.m_mainLeftBg 57 ")
	self.m_mainLeftBg : setPreferredSize( CCSizeMake( 510 , 553 ) )
	self.m_mainContainer : addChild( self.m_mainLeftBg)

	self.m_mainRightBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainRightBg : setControlName( "this CArtifactStrengthenView self.m_mainRightBg 62 ")
	self.m_mainRightBg : setPreferredSize( CCSizeMake( 311 , 553 ) )
	self.m_mainContainer : addChild( self.m_mainRightBg)

	-- 强化按钮
	self.m_strengthenBtn = CButton :createWithSpriteFrameName( "强化", "general_button_normal.png")
	self.m_strengthenBtn :setControlName( "this CArtifactStrengthenView self.m_strengthenBtn 68 ")
    self.m_strengthenBtn :setFontSize( CArtifactStrengthenView.FONT_SIZE_BUTTON)
    self.m_strengthenBtn :setTouchesEnabled( false )
    self.m_strengthenBtn :setTag( CArtifactStrengthenView.TAG_Strengthen )
    self.m_strengthenBtn :registerControlScriptHandler( local_btnTouchCallback, "this CArtifactStrengthenView self.m_strengthenBtn 72 ")
    self.m_mainContainer :addChild( self.m_strengthenBtn )

    -- 一键强化按钮
	self.m_oneKeyBtn = CButton :createWithSpriteFrameName( "一键强化", "general_button_normal.png")
	self.m_oneKeyBtn :setControlName( "this CArtifactStrengthenView self.m_oneKeyBtn 77 ")
    self.m_oneKeyBtn :setFontSize( CArtifactStrengthenView.FONT_SIZE_BUTTON)
    self.m_oneKeyBtn :setTouchesEnabled( false )
    self.m_oneKeyBtn :setTag( CArtifactStrengthenView.TAG_OneKeySt )
    self.m_oneKeyBtn :registerControlScriptHandler( local_btnTouchCallback, "this CArtifactStrengthenView self.m_oneKeyBtn 81 ")
    self.m_mainContainer :addChild( self.m_oneKeyBtn )

    if tonumber(_G.g_characterProperty : getMainPlay() :getVipLv()) < 6 then 
    	self.m_oneKeyBtn : setVisible( false )
    end

    -- 消耗美刀 成功率 Label
    self.m_useGoldLb = CCLabelTTF :create( "", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_useGoldLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_mainContainer : addChild( self.m_useGoldLb )

	self.m_successLb = CCLabelTTF :create( "", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_successLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_mainContainer : addChild( self.m_successLb )

	-- 物品Button
	--神器物品
	self.m_goodsBtn = CButton : createWithSpriteFrameName("","general_equip_frame.png")
	self.m_goodsBtn : setControlName("this CArtifactStrengthenView self.m_goodsBtn 101 ")
	self.m_goodsBtn : setTag( CArtifactStrengthenView.TAG_ShenQI )
	self.m_goodsBtn : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_goodsBtn : setTouchesEnabled( true)
    self.m_goodsBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactStrengthenView self.m_goodsBtn 105 ")
	self.m_mainContainer : addChild( self.m_goodsBtn )
	--祝福石
	self.m_wishBtn = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
	self.m_wishBtn : setControlName("this CArtifactStrengthenView self.m_wishBtn 109 ")
	self.m_wishBtn : setTag( CArtifactStrengthenView.TAG_Wish )
	self.m_wishBtn : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_wishBtn : setTouchesEnabled( false)
    self.m_wishBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactStrengthenView self.m_wishBtn 113 ")
	self.m_mainContainer : addChild( self.m_wishBtn )
	--护符
	self.m_hufuBtn = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
	self.m_hufuBtn : setControlName("this CArtifactStrengthenView self.m_hufuBtn 117 ")
	self.m_hufuBtn : setTag( CArtifactStrengthenView.TAG_HuFu )
	self.m_hufuBtn : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_hufuBtn : setTouchesEnabled( false)
    self.m_hufuBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactStrengthenView self.m_hufuBtn 121 ")
	self.m_mainContainer : addChild( self.m_hufuBtn )
	--勋章
	self.m_xunZhangBtn   = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
	self.m_xunZhangBtn   : setControlName("this CArtifactStrengthenView self.m_xunZhangBtn 125 ")
	self.m_xunZhangBtn   : setTag( CArtifactStrengthenView.TAG_XunZhang )
	self.m_xunZhangBtn   : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_xunZhangBtn   : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactStrengthenView self.m_xunZhangBtn 128 ")
    self.m_xunZhangBtn   : setTouchesEnabled( false )
	self.m_mainContainer : addChild( self.m_xunZhangBtn )

	--神器Label
	self.m_artifactLb = CCLabelTTF :create( "", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL+2)
	self.m_artifactLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_goodsBtn   : addChild( self.m_artifactLb )

	--祝福石Label
	self.m_wishLb = CCLabelTTF :create( "祝福石", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_wishLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_wishBtn   : addChild( self.m_wishLb )

	--护符Label 1
	self.m_hufuLb = CCLabelTTF :create( "护符", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_hufuLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_hufuBtn   : addChild( self.m_hufuLb )
	--护符Label 2
	self.m_hufuNoticLb = CCLabelTTF :create( "强化7以上可以使用", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_hufuNoticLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_hufuBtn   : addChild( self.m_hufuNoticLb )

	--勋章使用数Label
	self.m_useXunZhangLb = CCLabelTTF :create( "", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
	self.m_useXunZhangLb : setColor( CArtifactStrengthenView.GOLD )
	self.m_xunZhangBtn   : addChild( self.m_useXunZhangLb )

	local goodsBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_sq.png")
	goodsBtnBg : setControlName("this CArtifactStrengthenView goodsBtnBg 147 ")
	self.m_goodsBtn : addChild(goodsBtnBg, -1)

	local wishBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_sp.png")
	wishBtnBg : setControlName("this CArtifactStrengthenView wishBtnBg 106 ")
	self.m_wishBtn : addChild(wishBtnBg, -1)

	local hfBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_hf.png")
	hfBtnBg : setControlName("this CArtifactStrengthenView hfBtnBg 106 ")
	self.m_hufuBtn : addChild(hfBtnBg, -1)

	local xzBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_xz.png")
	xzBtnBg : setControlName("this CArtifactStrengthenView xzBtnBg 106 ")
	self.m_xunZhangBtn : addChild(xzBtnBg, -1)

end

function CArtifactStrengthenView.layout(self, _mainSize)

	-- local winSize = CCDirector:sharedDirector():getVisibleSize()
	-- self.m_mainContainer :setPosition( ccp( winSize.width/2 - _mainSize.width/2 ) )

	----------------------------
	--背景
	----------------------------
	self.m_mainLeftBg    : setPosition( ccp( 265, 293) ) -- 左背景
	self.m_mainRightBg	 : setPosition( ccp( 682, 293) ) -- 右背景

	if tonumber(_G.g_characterProperty : getMainPlay() :getVipLv()) < 6 then 
    	self.m_strengthenBtn : setPosition( ccp( 268, 62) ) -- 强化
    else
    	self.m_strengthenBtn : setPosition( ccp( 142, 62) ) -- 强化
    	self.m_oneKeyBtn     : setPosition( ccp( 395, 62) ) -- 一键强化
    end

	--消耗金额 成功率Label
	self.m_useGoldLb : setAnchorPoint(ccp(0,0.5))
	self.m_successLb : setAnchorPoint(ccp(0,0.5))
	self.m_useGoldLb : setPosition( ccp( 65, 123) ) 
	self.m_successLb : setPosition( ccp( 330, 123) ) 
	--物品按钮
	self.m_goodsBtn : setPosition( ccp( 268, 472) )--神器物品
	self.m_wishBtn  : setPosition( ccp( 105,  340) )--祝福石
	self.m_hufuBtn  : setPosition( ccp( 268*2-105, 340) )--护符
	self.m_xunZhangBtn : setPosition( ccp( 268, 210) )--勋章
	local btnSize = self.m_xunZhangBtn :getContentSize()
	self.m_artifactLb : setPosition( ccp( 0, btnSize.height/2 + 26 ) )--神器Label
	self.m_wishLb  : setPosition( ccp( 0, btnSize.height/2 + 10 ) )--祝福石Label
	self.m_hufuLb  : setPosition( ccp( 0, btnSize.height/2 + 10 ) )--护符Label 1
	self.m_hufuNoticLb : setPosition( ccp( 0, -btnSize.height/2 - 13 ) )--护符Label 2
	self.m_useXunZhangLb  : setPosition( ccp( 0, -btnSize.height/2 - 10 ) )--勋章使用数Label

end

--初始化数据成员
function CArtifactStrengthenView.initParams( self )
	--选中的物品位置 表
	self.m_selectGoods_partnerId = 1 --1代表背包  主将0  武将为他的id    对应协议
	self.m_selectGoods_shenQi = 0 --神器 的位置
	self.m_selectGoods_wish   = 0 --祝福石 的位置
	self.m_selectGoods_hufu   = 0 --护符 的位置

	self.m_thisUseMoney = 0
	--初始化确认框
	self.PopBox = CPopBox() 
    --加载xml 
    self :loadXmlData()
    --加载背包物品数据
    self :refreshPackageData()
end

function CArtifactStrengthenView.refreshPackageData( self )
	--更新本地数据
	print("\n\n\n\n----------------更新本地数据--------------------")
	self.m_mainProperty    = _G.g_characterProperty :getMainPlay()
	self.m_allArtifactList = self :getAllArtifactList()
	self.m_wishGoodsList, self.m_xunZhangList = self:getCaiLiaoGoodsList()
	self.m_huFuGoodsList   = {}

	print("-----CArtifactStrengthenView.initParams--------->>>>>",#self.m_wishGoodsList, #self.m_huFuGoodsList, #self.m_xunZhangList)
end

--注册Mediator
function CArtifactStrengthenView.registerStrengthenMediator( self )
	
    _G.pCArtifactStrengthenMediator = CArtifactStrengthenMediator(self)
    controller :registerMediator(_G.pCArtifactStrengthenMediator)--先注册后发送 否则会报错  

end

--反注册Mediator
function CArtifactStrengthenView.unregisterStrengthenMediator( self )
	if _G.pCArtifactStrengthenMediator ~= nil then 
		controller :unregisterMediator(_G.pCArtifactStrengthenMediator)
		_G.pCArtifactStrengthenMediator = nil
	end
end

function CArtifactStrengthenView.init(self, _mainSize )
	--初始化数据
    self:initParams( )
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
	--显示玩法介绍
	self:showNoticView()
	-- self:showGoodsViewByType(CArtifactStrengthenView.TAG_ShenQI)
end

function CArtifactStrengthenView.layer(self)

    local winSize  = CCDirector:sharedDirector():getVisibleSize()
    local mainSize = CCSizeMake( 854, winSize.height )
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CArtifactStrengthenView self.Scenelayer 249" )
    self:init(mainSize)
    return self.m_scenelayer
end


--*****************
--读取数据
--*****************
function CArtifactStrengthenView.loadXmlData( self )
    _G.Config :load( "config/goods.xml")
end

--获取goods xml的节点
function CArtifactStrengthenView.getGoodsNodeForXml( self, _goodsId )
	return _G.Config.goodss :selectSingleNode( "goods[@id="..tostring( _goodsId ).."]" )
end

--获得所有神器的物品 
function CArtifactStrengthenView.getAllArtifactList( self )

	local list = {}
	local count = 1
	--背包的神器 
	for i,v in ipairs( _G.g_GameDataProxy :getArtifactList() ) do
		list[count] 		= {}
		list[count].idxType = 1  --1:背包  武将:他的Id
		list[count].listIdx = count
		list[count].info    = v
		list[count].realIdx = v.index --所在容器的位置
		count = count + 1
	end

	local uid 			= _G.g_LoginInfoProxy :getUid()
	local mainProperty  = _G.g_characterProperty :getOneByUid( tonumber( uid ), _G.Constant.CONST_PLAYER)
	local partneridlist = mainProperty :getPartner()   --伙伴ID列表

	local myEquiplist = mainProperty :getArtifactEquipList()
	if myEquiplist ~= nil then
		for i,v in ipairs(myEquiplist) do
			list[count] 		= {}
			list[count].idxType = 0  --1:背包  武将:他的Id
			list[count].listIdx = count
			list[count].info    = v
			list[count].realIdx = v.index --所在容器的位置
			count = count + 1
		end
	end

	if partneridlist ~= nil then
		for i,v in ipairs(partneridlist) do
			local index = tostring( uid )..tostring( v )
    		local roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
    		local equiplist    = roleProperty :getArtifactEquipList()
    		if equiplist ~= nil then
    			for j,vv in ipairs(equiplist) do
    				list[count] 		= {}
					list[count].idxType = v  --1:背包  武将:他的Id
					list[count].listIdx = count
					list[count].info    = vv
					list[count].realIdx = vv.index --所在容器的位置
					count = count + 1
    			end
    		end
		end
	end
	return list
end


--得到材料物品列表中的 祝福石物品列表 护符物品列表 以及勋章物品列表
function CArtifactStrengthenView.getCaiLiaoGoodsList( self )
	local list = _G.g_GameDataProxy :getMaterialList()
	local wishList = {}
	local xunZhangList = {}
	if #list > 0 then 
		for i,v in ipairs(list) do
			local goodsId  = v.goods_id
			local type_sub = tonumber(self:getGoodsNodeForXml( goodsId ):getAttribute("type_sub"))
			if type_sub == 75 then 
				table.insert(wishList,v)
			elseif type_sub == 77 then 
				table.insert(xunZhangList,v)
			end
		end
	end
	return wishList,xunZhangList
end

--根据神器Id 获取对应的护符列表 参数:神器Id
function CArtifactStrengthenView.getHuFuGoodsList( self, _goodsId )
	local list = _G.g_GameDataProxy :getMaterialList()
	local xunZhangList = {}
	local goodsNode  = self:getGoodsNodeForXml( _goodsId )
	local goodsColor = tonumber(goodsNode:getAttribute("name_color"))
	if #list > 0 then 
		for i,v in ipairs(list) do
			print(i,v.goods_id)
			local node  = self:getGoodsNodeForXml( v.goods_id )
			if tonumber(node:getAttribute("type_sub")) == _G.Constant.CONST_GOODS_PROTECT_OPERATOR then 
				local color = tonumber(node:children():get(0,"d"):getAttribute("as1"))
				print("护符列表 ----  找到子类型 color=",color.."  goodsColor="..goodsColor)
				if goodsColor == color then 
					table.insert(xunZhangList,v)
				end
			end
		end
	end
	return xunZhangList
end


--根据位置获取祝福石物品信息
function CArtifactStrengthenView.getWishGoodsInfoByIndex( self , _index )
	for i,v in ipairs(self.m_wishGoodsList) do
		if v.index == tonumber(_index) then 
			return v 
		end
	end
	return nil
end

--根据id获取祝福石物品信息
function CArtifactStrengthenView.getWishGoodsInfoByGoodsId( self , _goodsId )
	for i,v in ipairs(self.m_wishGoodsList) do
		if v.goods_id == tonumber(_goodsId) then 
			return v 
		end
	end
	return nil
end

--根据位置获取护符物品信息
function CArtifactStrengthenView.getHuFuGoodsInfoByIndex( self , _index )
	for i,v in ipairs(self.m_huFuGoodsList) do
		if v.index == tonumber(_index) then 
			return v 
		end
	end
	return nil
end

--根据Id获取祝福石增加的概率值 
function CArtifactStrengthenView.getWishProbabilityByGoodsId( self , _goodsId )

	local goodsId     = tonumber( _goodsId )
	local probability = 0

	if goodsId == 37001 then 
		probability = _G.Constant.CONST_MAGIC_EQUIP_PRIMARY_STONE-- 初级
	elseif goodsId == 37006 then 
		probability = _G.Constant.CONST_MAGIC_EQUIP_MIDDLE_STONE--中级
	elseif goodsId == 37011 then 
		probability = _G.Constant.CONST_MAGIC_EQUIP_SENIOR_STONE--高级
	elseif goodsId == 37016 then 
		probability = _G.Constant.CONST_MAGIC_EQUIP_EPIC_STONE--史诗级
	elseif goodsId == 37021 then 
		probability = _G.Constant.CONST_MAGIC_EQUIP_STORY_STONE--传说级
	end

	return probability

end

--根据神器Id  属性类型  读取强化加成数据
function CArtifactStrengthenView.getAttrValue( self, _id, _base_type ) 
    local equStrNode     = self:getEquipStrenForXml( _id )
    local equStrNodeAttr = equStrNode.attr[1]
    local value          = nil

	if(_base_type == _G.Constant.CONST_ATTR_SP)then
	     value = equStrNodeAttr.sp
	elseif(_base_type == _G.Constant.CONST_ATTR_SP_UP)then
	     value =equStrNodeAttr.sp_up        
	elseif(_base_type== _G.Constant.CONST_ATTR_ANIMA)then
	     value = equStrNodeAttr.anima  
	elseif(_base_type == _G.Constant.CONST_ATTR_HP)then
	     value = equStrNodeAttr.hp  
	elseif(_base_type == _G.Constant.CONST_ATTR_HP_GRO)then
	     value = equStrNodeAttr.hp_gro  
	elseif(_base_type == _G.Constant.CONST_ATTR_STRONG)then
	     value = equStrNodeAttr.strong 
	elseif(_base_type == _G.Constant.CONST_ATTR_STRONG_GRO)then
	     value = equStrNodeAttr.strong_gro 
	elseif(_base_type == _G.Constant.CONST_ATTR_MAGIC)then
	     value = equStrNodeAttr.magic 
	elseif(_base_type == _G.Constant.CONST_ATTR_MAGIC_GRO)then
	     value = equStrNodeAttr.magic_gro 
	elseif(_base_type == _G.Constant.CONST_ATTR_STRONG_ATT)then
	     value = equStrNodeAttr.strong_att          
	elseif(_base_type == _G.Constant.CONST_ATTR_STRONG_DEF)then
	     value = equStrNodeAttr.strong_def 
	elseif(_base_type == _G.Constant.CONST_ATTR_SKILL_ATT)then 
	     value = equStrNodeAttr.skill_att 
	elseif(_base_type == _G.Constant.CONST_ATTR_SKILL_DEF)then
	     value = equStrNodeAttr.skill_def 
	elseif(_base_type == _G.Constant.CONST_ATTR_HIT)then
	     value = equStrNodeAttr.crit 
	elseif(_base_type == _G.Constant.CONST_ATTR_DOD)then
	     value = equStrNodeAttr.crit_res 
	elseif(_base_type == _G.Constant.CONST_ATTR_CRIT)then
	     value = equStrNodeAttr.crit_harm 
	elseif(_base_type == _G.Constant.CONST_ATTR_RES_CRIT)then
	     value = equStrNodeAttr.defend_down 
	elseif(_base_type == _G.Constant.CONST_ATTR_CRIT_HARM)then
	     value = equStrNodeAttr.light 
	elseif(_base_type == _G.Constant.CONST_ATTR_DEFEND_DOWN)then
	     value = equStrNodeAttr.light_def 
	elseif(_base_type == _G.Constant.CONST_ATTR_LIGHT)then
	     value = equStrNodeAttr.dark 
	elseif(_base_type == _G.Constant.CONST_ATTR_LIGHT_DEF)then
	     value = equStrNodeAttr.dark_def 
	elseif(_base_type == _G.Constant.CONST_ATTR_DARK)then
	     value = equStrNodeAttr.god 
	elseif(_base_type == _G.Constant.CONST_ATTR_DARK_DEF)then
	     value = equStrNodeAttr.god_def 
	elseif(_base_type == _G.Constant.CONST_ATTR_GOD)then
	     value = equStrNodeAttr.bonus 
	elseif(_base_type == _G.Constant.CONST_ATTR_GOD_DEF)then
	     value = equStrNodeAttr.reduction 
	elseif(_base_type == _G.Constant.CONST_ATTR_BONUS)then
	     value = equStrNodeAttr.imm_dizz 
	end     
    return value 
end

function CArtifactStrengthenView.lockScene( self )
	print("CArtifactStrengthenView.lockScene")
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
    	CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end

end

function CArtifactStrengthenView.unlockScene( self )
	print("CArtifactStrengthenView.unlockScene")
	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end

end

--************************
--按钮回调
--************************
--强化 一键强化 单击回调
function CArtifactStrengthenView.btnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()

			if tag == CArtifactStrengthenView.TAG_Strengthen then 
				-- 强化
				print("强化啦")
				if self.m_xunZhangInfo.count <= self.m_xunZhangInfo.have then 

					local mainProperty = _G.g_characterProperty : getMainPlay()
					local myGolds	   = mainProperty :getGold()
					if myGolds < self.m_thisUseMoney then
						_G.g_CArtifactView:showSureBox( "美刀不足,招财可获得美刀!" )
						return
					end

					self :sendStrengthenMessage(1)

					local actarr = CCArray:create()
					local function t_callback1()
					    self.m_strengthenBtn :setTouchesEnabled( false )
						self.m_oneKeyBtn     :setTouchesEnabled( false )
					end
					actarr:addObject( CCCallFunc:create(t_callback1) )
					obj:runAction( CCSequence:create(actarr) )

				else
					_G.g_CArtifactView:showSureBox( "材料不足" )
				end
			elseif tag == CArtifactStrengthenView.TAG_OneKeySt then 
				-- 一键强化
				print("一键强化啦")

				
				
				self :requestOneKeyMenoryMessage()

				self.m_oneKeyBtn :setTouchesEnabled( false )

			end
		end
		
	end
end

--强化格子 祝福石格子 护符格子 勋章格子 按钮 单击回调
function CArtifactStrengthenView.goodsTouchCallback(self ,eventType, obj, touches)

	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID1    = touch :getID()
                self.touchTag    = obj   :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID1 == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID1 and self.touchTag == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    --弹出物品Tips
                    local tag = obj:getTag()
					if  tag == CArtifactStrengthenView.TAG_ShenQI then 
						-- 强化格子
						print("强化格子")
						if self.m_goodsViewContainer ~= nil and self.isTouchGoodsInfo then 
							self.m_goodsViewContainer : removeFromParentAndCleanup( true )
							self.m_goodsViewContainer = nil
							if self.m_addInfoContainer ~= nil then 
								self.m_addInfoContainer : setVisible( true )
							end
						else
							self :showGoodsViewByType( CArtifactStrengthenView.TAG_ShenQI )
						end
					elseif tag == CArtifactStrengthenView.TAG_Wish then 
						-- 祝福石格子
						print("祝福石格子")
						if self.m_goodsViewContainer ~= nil and self.isTouchGoodsInfo then 
							self.m_goodsViewContainer : removeFromParentAndCleanup( true )
							self.m_goodsViewContainer = nil
							if self.m_addInfoContainer ~= nil then 
								self.m_addInfoContainer : setVisible( true )
							end
						else
							self :showGoodsViewByType( CArtifactStrengthenView.TAG_Wish )
						end
					elseif tag == CArtifactStrengthenView.TAG_HuFu then 
						-- 护符格子
						print("护符格子")
						if self.m_goodsViewContainer ~= nil and self.isTouchGoodsInfo then 
							self.m_goodsViewContainer : removeFromParentAndCleanup( true )
							self.m_goodsViewContainer = nil
							if self.m_addInfoContainer ~= nil then 
								self.m_addInfoContainer : setVisible( true )
							end
						else
							local goodsId = self.m_allArtifactList[ self.m_selectGoods_shenQi ].info.goods_id 
							self.m_huFuGoodsList = self :getHuFuGoodsList( goodsId )
							self :showGoodsViewByType( CArtifactStrengthenView.TAG_HuFu )
						end
					elseif tag == CArtifactStrengthenView.TAG_XunZhang then 
						-- 勋章格子
						print("勋章格子")
						local winSize = CCDirector:sharedDirector():getVisibleSize()
	                    local _position = {}
	                    _position.x = touch2Point.x
	                    _position.y = touch2Point.y
	                    local goodsId = self.m_xunZhangInfo.goodsId

	                    if _G.g_CArtifactView ~= nil then
							_G.g_CArtifactView:showGoodsByGoodsIdTips( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE,_position )
						end

					end

                    self.touchID1    = nil
                    self.touchTag    = nil
                end
            end
        end
        print( eventType,"END")
    end

end

--背包祝福石 单击回调
function CArtifactStrengthenView.packageWishCallback(self, _index)

	if self.m_selectGoods_wish == _index then 
		self.m_selectGoods_wish = 0
		self:removeIconForButton(self.m_wishBtn,CArtifactStrengthenView.TAG_Wish)
	else
		self.m_selectGoods_wish = _index
		
	end

	-- self.probabilityInfo.goodsPro --神器本身强化的概率
	-- self.probabilityInfo.nowPro   --神器现在强化的概率
	-- self.probabilityInfo.wishPro  --祝福石添加的概率
	-- 重算概率
	if self.m_selectGoods_wish == 0 then 
		--取消存放的祝福石 重设概率
		self.probabilityInfo.nowPro = self.probabilityInfo.goodsPro
	else
		local goodsInfo = self :getWishGoodsInfoByIndex( _index )
		if goodsInfo ~= nil then 
			self :addIconForButton( self.m_wishBtn, goodsInfo.goods_id, CArtifactStrengthenView.TAG_Wish )
			local wishGoodsId = goodsInfo.goods_id
			self.probabilityInfo.wishPro = self:getWishProbabilityByGoodsId( wishGoodsId )/100.0
			print("------------------   祝福石成功率:",self.probabilityInfo.wishPro)
			self.probabilityInfo.nowPro  = self.probabilityInfo.goodsPro + self.probabilityInfo.wishPro
			if self.probabilityInfo.nowPro > 100 then 
				self.probabilityInfo.nowPro = 100
			end
		end
	end
	self.m_successLb : setString( "成功率:"..tostring(self.probabilityInfo.nowPro).."%" )

	-- 清除背包
	self.m_goodsViewContainer : removeFromParentAndCleanup( true )
	self.m_goodsViewContainer = nil

	-- 显示强化信息
	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : setVisible( true )
	end
end

--背包护符 单击回调
function CArtifactStrengthenView.packageHuFuCallback(self, _index)

	if self.m_selectGoods_hufu == _index then 
		self.m_selectGoods_hufu = 0
		self:removeIconForButton(self.m_hufuBtn,CArtifactStrengthenView.TAG_HuFu)
	else
		self.m_selectGoods_hufu = _index

		local goodsInfo = self :getHuFuGoodsInfoByIndex( _index )
		if goodsInfo ~= nil then 
			self :addIconForButton( self.m_hufuBtn, goodsInfo.goods_id, CArtifactStrengthenView.TAG_HuFu )
		end
	end

	-- 清除背包
	self.m_goodsViewContainer : removeFromParentAndCleanup( true )
	self.m_goodsViewContainer = nil

	-- 显示强化信息
	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : setVisible( true )
	end

end

--背包神器 单击回调
function CArtifactStrengthenView.packageArtifactCallback(self, _index)

	if self.m_selectGoods_shenQi == _index then 
		self :disboardAritifact()
	else

		local goodsInfo = self.m_allArtifactList[ _index ].info
		self.m_selectGoods_partnerId = self.m_allArtifactList[ _index ].idxType
		self.m_selectGoods_shenQi    = _index

		if goodsInfo ~= nil then 
			--添加强化信息
			-- self :showStrengthenInfo( goodsInfo )
			self :requestStrenInfo( goodsInfo )
		else 
			print("出错啦 应该是tag值不对")
		end
	end

end

--卸下神器
function CArtifactStrengthenView.disboardAritifact( self )
	--取消放入神器 清除信息
	self.m_selectGoods_shenQi = 0
	self.m_selectGoods_partnerId = 1
	self:removeIconForButton(self.m_goodsBtn,CArtifactStrengthenView.TAG_ShenQI)
	self:removeIconForButton(self.m_xunZhangBtn,CArtifactStrengthenView.TAG_XunZhang)
	self:removeIconForButton(self.m_hufuBtn,CArtifactStrengthenView.TAG_HuFu)
	self:removeIconForButton(self.m_wishBtn,CArtifactStrengthenView.TAG_Wish)

	self.m_useGoldLb : setString( "" )
	self.m_successLb : setString( "" )
	self.m_useXunZhangLb : setString( "" )

	self.m_strengthenBtn :setTouchesEnabled( false )
	self.m_oneKeyBtn     :setTouchesEnabled( false )
	self.m_xunZhangBtn   :setTouchesEnabled( false )
	self.m_wishBtn       :setTouchesEnabled( false )
	self.m_hufuBtn		 :setTouchesEnabled( false )

	-- 清除背包
	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	--清楚神器名称
	self.m_artifactLb:setString("")

	-- 清楚强化信息
	self:showNoticView()
	-- if self.m_addInfoContainer ~= nil then 
	-- 	self.m_addInfoContainer : removeFromParentAndCleanup( true )
	-- 	self.m_addInfoContainer = nil
	-- end

	self.probabilityInfo = nil

	-- self:showGoodsViewByType(CArtifactStrengthenView.TAG_ShenQI)
end

--添加Icon到button中
function CArtifactStrengthenView.addIconForButton( self, _btn, _goodsId, _tag )

	self : removeIconForButton( _btn, _tag)

	local iconId = self:getGoodsNodeForXml(_goodsId):getAttribute("icon")

	local icon = CIcon : create("Icon/i"..tostring( iconId )..".jpg")
	_btn : addChild( icon  , 0 , _tag ) 

	_G.g_CArtifactView:setCreateResStr( "Icon/i"..tostring( iconId )..".jpg" )

end

function CArtifactStrengthenView.removeIconForButton( self, _btn, _tag )
	if _btn :getChildByTag( _tag ) ~= nil then 
		_btn :removeChildByTag( _tag, true )
	end
end


function CArtifactStrengthenView.showGoodsViewByType( self, _type )

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	local touchIndex= 0
	local winSize   = CCDirector:sharedDirector():getVisibleSize()
	local mainSize  = CCSizeMake( 854, winSize.width )
	local m_bgCell  = CCSizeMake(98,110)
    local viewSize  = CCSizeMake( 98*3, 110*5)

    self.m_goodsViewContainer = CContainer :create()
    self.m_goodsViewContainer : setControlName( "this is CArtifactStrengthenView self.m_goodsViewContainer 104" )
    self.m_goodsViewContainer : setPosition( ccp( 682-311/2, 0 ) )
    self.m_mainContainer : addChild( self.m_goodsViewContainer)
    
    if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : setVisible( false )
	end
    --获取物品列表 以及选中的物品位置
    local goodsList 
    local goodsIdxSelect
    local titleStr
    if _type == CArtifactStrengthenView.TAG_ShenQI then 
    	goodsList = {}
    	for i,v in ipairs(self.m_allArtifactList) do
    		if v.info.strengthen < 15 then 
				table.insert(goodsList,v)
			end
		end
    	goodsIdxSelect = self.m_selectGoods_shenQi
    	titleStr       = "神器列表"
	elseif _type == CArtifactStrengthenView.TAG_Wish then 
		goodsList      = self.m_wishGoodsList
		goodsIdxSelect = self.m_selectGoods_wish
		titleStr 	   = "祝福石列表"
	elseif _type == CArtifactStrengthenView.TAG_HuFu then 
		goodsList      = self.m_huFuGoodsList
		goodsIdxSelect = self.m_selectGoods_hufu
		titleStr       = "护符列表"
	end
	local curtaggoods = #goodsList

	local function local_buttonCallback( )
		print("local_buttonCallback ComeIn !!!!")
		if _type == CArtifactStrengthenView.TAG_ShenQI then 
			print("TAG_ShenQI")
	    	return self:packageArtifactCallback(touchIndex)
		elseif _type == CArtifactStrengthenView.TAG_Wish then 
			print("TAG_Wish")
			return self:packageWishCallback(touchIndex)
		elseif _type == CArtifactStrengthenView.TAG_HuFu then 
			print("TAG_HuFu")
			return self:packageHuFuCallback(touchIndex)
		end
	end

	local function local_packageGoodsCallback(eventType, obj, touches)
		--物品格子 多点触控回调  弹出tips
		if eventType == "TouchesBegan" then
	        --删除Tips
	        _G.g_PopupView :reset()
	        local touchesCount = touches:count()
	        for i=1, touchesCount do
	            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID2     = touch :getID()
                    self.goodsIndex  = obj :getTag()
                    break
                end
	        end
	    elseif eventType == "TouchesEnded" then
	        if self.touchID2 == nil then
	           return
	        end
	        local touchesCount2 = touches:count()
	        for i=1, touchesCount2 do
	            local touch2 = touches :at(i - 1)
	            if touch2:getID() == self.touchID2 and self.goodsIndex == obj :getTag() then
	                local touch2Point = touch2 :getLocation()
	                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
	                    --弹出物品Tips             
	                    local winSize = CCDirector:sharedDirector():getVisibleSize()
	                    local _position = {}
	                    _position.x = touch2Point.x -- - (winSize.width-854)/2 - 20
	                    _position.y = touch2Point.y -- + 20
	                    local str
						if tonumber(goodsIdxSelect) == tonumber(obj:getTag()) then 
							str = "卸下"
						else
							str = "放入"
						end

						touchIndex = obj:getTag()
						local good 
						if _type == CArtifactStrengthenView.TAG_ShenQI then 
					    	good = self.m_allArtifactList[ obj:getTag() ].info
						elseif _type == CArtifactStrengthenView.TAG_Wish then 
							good = self :getWishGoodsInfoByIndex( obj:getTag() )
						elseif _type == CArtifactStrengthenView.TAG_HuFu then 
							good = self :getHuFuGoodsInfoByIndex( obj:getTag() )
						end

						if _G.g_CArtifactView ~= nil then
							_G.g_CArtifactView:showArtifactGoodsTips( good, _G.Constant.CONST_GOODS_SITE_ARTIFACT,str, local_buttonCallback, _position )
						end
						-- local  temp     = _G.g_PopupView :createByArtifact( good, _G.Constant.CONST_GOODS_SITE_ARTIFACT,str, local_buttonCallback, _position)
		    -- 			self.m_scenelayer :addChild( temp)   --_good, _str, _fun, _position)
	
	                    self.touchID2    = nil
	                    self.goodsIndex  = nil
	                end
	            end
	        end
	        print( eventType,"END")
	    end

	end

    local layout = CHorizontalLayout :create()
    layout :setPosition( 311/2 - viewSize.width/2, viewSize.height-40)
    self.m_goodsViewContainer :addChild(layout,100)
    layout :setVerticalDirection(false)
    layout :setLineNodeSum( 3)
    layout :setCellSize(m_bgCell)

    self.m_goodsBtnList   = {}
	for i=1,15 do

		if curtaggoods >= i then
			local index 
			local goodsId
			local goodNum
			if _type == CArtifactStrengthenView.TAG_ShenQI then 
				index   = goodsList[curtaggoods-i+1].listIdx
				goodsId = goodsList[curtaggoods-i+1].info.goods_id
				goodNum = goodsList[curtaggoods-i+1].info.goods_num
			else 
				index   = goodsList[curtaggoods-i+1].index
				goodsId = goodsList[curtaggoods-i+1].goods_id
				goodNum = goodsList[curtaggoods-i+1].goods_num
			end

			--是否选中
			if index == goodsIdxSelect then 
    			self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_click.png")
    		else
    			self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
    		end

			self.m_goodsBtnList[i] : setTag( index )
			self.m_goodsBtnList[i] : setTouchesMode( kCCTouchesAllAtOnce )
        	self.m_goodsBtnList[i] : setTouchesEnabled( true)
			self.m_goodsBtnList[i] : registerControlScriptHandler( local_packageGoodsCallback, "this CArtifactStrengthenView self.m_goodsBtnList[i] 117 ")

			if _type ~= CArtifactStrengthenView.TAG_ShenQI then 
				local btnSize = self.m_goodsBtnList[i] :getContentSize()
				local countLabel = CCLabelTTF :create( "*"..tostring(goodNum), "Arial", 21)
				countLabel : setColor( CArtifactStrengthenView.GOLD )
				countLabel : setAnchorPoint( ccp(0,1) )
				countLabel : setPosition( ccp( -btnSize.width/2+7, btnSize.height/2-5 ) )
				self.m_goodsBtnList[i] : addChild( countLabel,200 )
			else
				local btnSize = self.m_goodsBtnList[i] :getContentSize()

				if goodsList[curtaggoods-i+1].idxType ~= 1 then
					-- local goodsNode = self:getGoodsNodeForXml( goodsId )
					local nameLabel = CCLabelTTF :create( "装备中", "Arial", 18)
					-- nameLabel : setColor( CArtifactStrengthenView.GOLD )
					nameLabel : setAnchorPoint( ccp(1,0) )
					nameLabel : setPosition( ccp( btnSize.width/2-7, -btnSize.height/2+5 ) )
					self.m_goodsBtnList[i] : addChild( nameLabel,200 )
				end

				local LVLabel = CCLabelTTF :create( "+"..goodsList[curtaggoods-i+1].info.strengthen, "Arial", 21)
				LVLabel : setColor( CArtifactStrengthenView.GOLD )
				LVLabel : setAnchorPoint( ccp(0,1) )
				LVLabel : setPosition( ccp( -btnSize.width/2+7, btnSize.height/2-5 ) )
				self.m_goodsBtnList[i] : addChild( LVLabel,200 )
			end

			self :addIconForButton( self.m_goodsBtnList[i], goodsId, index )
		else
			self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
		end

		self.m_goodsBtnList[i] : setControlName("this CArtifactStrengthenView self.m_goodsBtnList[i] 179 ")
		layout : addChild( self.m_goodsBtnList[i] )
    end
	
end


function CArtifactStrengthenView.showNoticView( self )
	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : removeFromParentAndCleanup( true )
		self.m_addInfoContainer = nil
	end

	self.m_addInfoContainer = CContainer :create()
    self.m_addInfoContainer : setControlName( "this is CArtifactStrengthenView self.m_addInfoContainer 104" )
    self.m_mainContainer    : addChild( self.m_addInfoContainer)

    self.isTouchGoodsInfo = false

	local WFSM_Label = CCLabelTTF :create( "玩法说明 : ","Arial",24 )
	local SM_Label1  = CCLabelTTF :create( "1.点击左侧栏和材料栏可以打开对应背包,点击神器或材料可放入.","Arial",20 )
	local SM_Label2  = CCLabelTTF :create( "2.强化神器需要勋章,不同等级的神器强化需要不同品质的勋章.","Arial",20 )
	local SM_Label3  = CCLabelTTF :create( "3.神器强化有机率成功放入祝福石头可以提升成功率.","Arial",20 )
	local SM_Label4  = CCLabelTTF :create( "4.强化7级或以上神器失败后神器会掉级,使用相应品质的护符可保证神器不掉级.","Arial",20 )

	WFSM_Label : setAnchorPoint( ccp( 0, 1 ) )
	SM_Label1  : setAnchorPoint( ccp( 0, 1 ) )
	SM_Label2  : setAnchorPoint( ccp( 0, 1 ) )
	SM_Label3  : setAnchorPoint( ccp( 0, 1 ) )
	SM_Label4  : setAnchorPoint( ccp( 0, 1 ) )

	WFSM_Label : setHorizontalAlignment( kCCTextAlignmentLeft )
	SM_Label1  : setHorizontalAlignment( kCCTextAlignmentLeft )
	SM_Label2  : setHorizontalAlignment( kCCTextAlignmentLeft )
	SM_Label3  : setHorizontalAlignment( kCCTextAlignmentLeft )
	SM_Label4  : setHorizontalAlignment( kCCTextAlignmentLeft )

	local labelSize = CCSizeMake( 300, 0 )
	SM_Label1 : setDimensions( labelSize )
	SM_Label2 : setDimensions( labelSize )
	SM_Label3 : setDimensions( labelSize )
	SM_Label4 : setDimensions( labelSize )

	local _width = 682 - 150
	WFSM_Label : setPosition( _width,555 )
	SM_Label1  : setPosition( _width,520 )
	SM_Label2  : setPosition( _width,450 )	
	SM_Label3  : setPosition( _width,380 )
	SM_Label4  : setPosition( _width,310 )

	self.m_addInfoContainer : addChild( WFSM_Label )
	self.m_addInfoContainer : addChild( SM_Label1 )
	self.m_addInfoContainer : addChild( SM_Label2 )
	self.m_addInfoContainer : addChild( SM_Label3 )
	self.m_addInfoContainer : addChild( SM_Label4 )
end

function CArtifactStrengthenView.resetStrenInfo( self )

	if self.m_selectGoods_shenQi == 0 then
		return
	end

	local goodsInfo = self.m_allArtifactList[ self.m_selectGoods_shenQi ].info
	self:requestStrenInfo(goodsInfo)

	-- if self.m_artifactRealIdx == nil then
	-- 	return
	-- end

	-- local goodsInfo = nil
	-- for i,v in ipairs(self.m_allArtifactList) do
	-- 	if v.realIdx == self.m_artifactRealIdx then
	-- 		goodsInfo = v.info
	-- 	end
	-- end

	-- if goodsInfo ~= nil then
	-- 	self:requestStrenInfo(goodsInfo)
	-- else
	-- 	self:disboardAritifact()
	-- end
	
end

function CArtifactStrengthenView.requestStrenInfo( self, _goodsInfo )
	require "common/protocol/auto/REQ_MAGIC_EQUIP_ASK_NEXT_ATTR"

	local goodsNode = self :getGoodsNodeForXml( _goodsInfo.goods_id )

	local msg = REQ_MAGIC_EQUIP_ASK_NEXT_ATTR()
	msg : setTypeSub( tonumber( goodsNode:getAttribute("type_sub")) )
	msg : setLv( _goodsInfo.strengthen )
	msg : setColor( tonumber( goodsNode:getAttribute("name_color") ) )
	msg : setClass( tonumber( goodsNode:getAttribute("class") ) )
	CNetwork :send(msg)

	-- self.m_isPutArtifact = true
	self.m_nowGoodsInfo  = _goodsInfo

	print(" requestStrenInfo-->     setTypeSub->"..goodsNode:getAttribute("type_sub").."     setLv->".._goodsInfo.strengthen)
	print(" requestStrenInfo-->     setColor->"..goodsNode:getAttribute("name_color").."     setClass->"..goodsNode:getAttribute("class"))

end


--显示物品强化信息 消耗的美刀 成功率 强化前后的加成 
function CArtifactStrengthenView.showStrengthenInfo( self, _ackMsg )
	
	-- self.m_isPutArtifact = false
	local _goodsInfo = self.m_nowGoodsInfo

	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : removeFromParentAndCleanup( true )
		self.m_addInfoContainer = nil
	end

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	self.isTouchGoodsInfo = true

	local winSize  = CCDirector:sharedDirector():getVisibleSize()
	local mainSize = CCSizeMake( 854, winSize.height )

	self.m_addInfoContainer = CContainer :create()
    self.m_addInfoContainer : setControlName( "this is CArtifactStrengthenView self.m_addInfoContainer 104" )
    self.m_mainContainer    : addChild( self.m_addInfoContainer)

    local goodsNode 	  = self :getGoodsNodeForXml( _goodsInfo.goods_id )
    local colorName,color = self :getNameAndColorByColorId( tonumber(goodsNode:getAttribute("name_color")) )
    local lineBg1         = CSprite :createWithSpriteFrameName( "artifact_strengthen_underframe.png"  )--CCRectMake( 140,0,2,53)
    local lineBg2         = CSprite :createWithSpriteFrameName( "artifact_strengthen_underframe.png" )
    local goNowTitleImg   = CSprite :createWithSpriteFrameName( "artifact_word_qhq.png" )
    local goAfterTitleImg = CSprite :createWithSpriteFrameName( "artifact_word_qhh.png" )
    local goNowNameLb     = CCLabelTTF:create( goodsNode:getAttribute("name"), "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL )
    local goAfterNameLb   = CCLabelTTF:create( goodsNode:getAttribute("name"), "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL )
    local goNowColorLb    = CCLabelTTF:create( colorName.."装 "..tostring(_goodsInfo.strengthen).." 级", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL )
    local goAfterColorLb  = CCLabelTTF:create( colorName.."装 "..tostring(_goodsInfo.strengthen+1).." 级", "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL )

    local myColor = ccc4( 255,215,0,255 )
    goNowNameLb    : setColor( color )
    goAfterNameLb  : setColor( color )
    goNowColorLb   : setColor( color )
    goAfterColorLb : setColor( color )
    goNowNameLb    : setAnchorPoint( ccp( 1, 0.5 ) )
	goAfterNameLb  : setAnchorPoint( ccp( 1, 0.5 ) )
	goNowColorLb   : setAnchorPoint( ccp( 0, 0.5 ) )
	goAfterColorLb : setAnchorPoint( ccp( 0, 0.5 ) )

    lineBg1			: setScale( 1.2 )
    lineBg2			: setScale( 1.2 )
    lineBg1         : setPosition( ccp( 682,538+12) )
	lineBg2         : setPosition( ccp( 682,260+12) )
	goNowTitleImg   : setPosition( ccp( 682,538) )
	goAfterTitleImg : setPosition( ccp( 682,260) )

	goNowNameLb    : setPosition( ccp( 675, mainSize.height*0.76 ) )
	goNowColorLb   : setPosition( ccp( 695, mainSize.height*0.76 ) )
	goAfterNameLb  : setPosition( ccp( 675, mainSize.height*0.323 ) )
	goAfterColorLb : setPosition( ccp( 695, mainSize.height*0.323 ) )

	self.m_addInfoContainer : addChild( lineBg1 )
	self.m_addInfoContainer : addChild( lineBg2 )
	self.m_addInfoContainer : addChild( goNowTitleImg )
	self.m_addInfoContainer : addChild( goAfterTitleImg )
	self.m_addInfoContainer : addChild( goNowNameLb )
	self.m_addInfoContainer : addChild( goAfterNameLb )
	self.m_addInfoContainer : addChild( goNowColorLb )
	self.m_addInfoContainer : addChild( goAfterColorLb )

	self.m_artifactLb : setString( "+"..tostring(_goodsInfo.strengthen).." "..goodsNode:getAttribute("name") )
	self.m_artifactLb : setColor( color )

	local attrInfo = {}
	--强化前属性

	if _goodsInfo.attr_count > 0 then 
		local iCount = 1
		print(_goodsInfo.attr_count,#_goodsInfo.attr_data)
		for i,v in ipairs(_goodsInfo.attr_data) do
			local name  = CLanguageManager:sharedLanguageManager():getString(tostring("goodss_goods_base_types_base_type_type"..v.attr_base_type))
			local value = v.attr_base_value
			local addNameLabel = CCLabelTTF :create( name, "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
			local addValueLabel= CCLabelTTF :create( "+"..tostring(value), "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)

			addNameLabel  : setAnchorPoint( ccp( 1, 0.5 ) )
			addValueLabel : setAnchorPoint( ccp( 0, 0.5 ) )
			
			addNameLabel  : setPosition( ccp( 675, mainSize.height*0.717 - mainSize.height*0.05*(iCount-1) ) )
			addValueLabel : setPosition( ccp( 695, mainSize.height*0.717 - mainSize.height*0.05*(iCount-1) ) )
			self.m_addInfoContainer : addChild( addNameLabel )
			self.m_addInfoContainer : addChild( addValueLabel )
			attrInfo[iCount] 	   = {}
			attrInfo[iCount].type  = v.attr_base_type
			attrInfo[iCount].value = value
			attrInfo[iCount].name  = name
			print("-----=========------",attrInfo[iCount].type,attrInfo[iCount].name,attrInfo[iCount].value)
			iCount = iCount + 1
		end
	else 
		print("物品没有属性")
	end

	--强化后属性
	
	local nodeAttrL = {}
	local jCount    = 1
	local base_types_Child = goodsNode:children():get(0,"base_types"):children()
	local base_types_Count = base_types_Child:getCount("base_type")
	for i=0,base_types_Count-1 do
		nodeAttrL[jCount] 	    = {}
		nodeAttrL[jCount].type  = tonumber(base_types_Child:get(i,"base_type"):getAttribute("type"))
		nodeAttrL[jCount].value = tonumber(base_types_Child:get(i,"base_type"):getAttribute("v"))
		jCount   				= jCount + 1
	end
	-- for i,v in ipairs(getAttribute("base_type")) do
	-- 	nodeAttrL[jCount] 	    = {}
	-- 	nodeAttrL[jCount].type  = tonumber(v.type)
	-- 	nodeAttrL[jCount].value = tonumber(v.v)
	-- 	jCount   				= jCount + 1
	-- end

	for i,v in ipairs(attrInfo) do
		local attrValue = 0--self :getAttrValue( strenId,v.type )
		local initValue = 0 --0级初始值

		for i,k in ipairs(_ackMsg:getMsgXxx1()) do
			if tonumber(v.type) == tonumber(k.type) then
				attrValue = k.type_value
				break
			end
		end

		for i,k in ipairs(nodeAttrL) do
			if k.type == v.type then 
				initValue = k.value
			end
		end
		print("-----=========------",attrValue,v.value,(v.value+attrValue))
		local addNameLabel  = CCLabelTTF :create( v.name , "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
		local addValueLabel = CCLabelTTF :create( "+"..tostring(initValue+attrValue), "Arial", CArtifactStrengthenView.FONT_SIZE_LABEL)
		local addImg  		= CSprite    :createWithSpriteFrameName( "artifact_equip_up.png" )

		local valueLbSize   = addValueLabel :getContentSize()

		addNameLabel  : setAnchorPoint( ccp( 1, 0.5 ) )
		addValueLabel : setAnchorPoint( ccp( 0, 0.5 ) )
		addValueLabel : setColor( CArtifactStrengthenView.GREEN )
		addNameLabel  : setPosition( ccp( 675, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		addValueLabel : setPosition( ccp( 695, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		addImg 		  : setPosition( ccp( 695 + valueLbSize.width + 18, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		self.m_addInfoContainer : addChild( addNameLabel )
		self.m_addInfoContainer : addChild( addValueLabel )
		self.m_addInfoContainer : addChild( addImg )
	end

	--勋章信息
	self.m_xunZhangInfo  = {}
	self.m_xunZhangInfo.goodsId = tonumber(_ackMsg:getMsgXxx2()[1].item_id)
	self.m_xunZhangInfo.count   = tonumber(_ackMsg:getMsgXxx2()[1].count)
	-- self.m_xunZhangInfo.price   = tonumber(equStrNode.m1[1].rep_t2)
	-- self.m_xunZhangInfo.priceName = "美刀"
	self.m_xunZhangInfo.have    = 0

	-- self.probabilityInfo.goodsPro --神器本身强化的概率
	-- self.probabilityInfo.nowPro   --神器现在强化的概率
	-- self.probabilityInfo.wishPro  --祝福石添加的概率
	self.m_thisUseMoney = _ackMsg:getMoney()
	if self.probabilityInfo == nil then 
		self.probabilityInfo = {}
	end
	--神器本身的强化概率
	self.probabilityInfo.goodsPro = tonumber(_ackMsg:getOdds())/100
	if self.probabilityInfo.wishPro == nil then 
		--神器现在的强化概率 等于本身的概率
		self.probabilityInfo.nowPro   = tonumber(_ackMsg:getOdds())/100
	else
		--神器现在的强化概率 等于本身的概率加上祝福石的概率
		self.probabilityInfo.nowPro   = tonumber(_ackMsg:getOdds())/100 + self.probabilityInfo.wishPro
		if self.probabilityInfo.nowPro > 100 then 
			self.probabilityInfo.nowPro = 100
		end
	end

	-- 重设消耗美刀 成功率 Label
	self.m_successLb : setString( "成功率 : "..tostring(self.probabilityInfo.nowPro).."%" )
    self.m_useGoldLb : setString( "需要美刀 : "..self.m_thisUseMoney )

    --添加勋章图标
	self :addIconForButton( self.m_xunZhangBtn, self.m_xunZhangInfo.goodsId, CArtifactStrengthenView.TAG_XunZhang )
	
	--计算现有的勋章个数
    for i,v in ipairs(self.m_xunZhangList) do
    	print(i,v)
    	if v.goods_id == tonumber( self.m_xunZhangInfo.goodsId ) then
    		self.m_xunZhangInfo.have = self.m_xunZhangInfo.have + v.goods_num
    	end
    end

	-- 重设勋章消耗数
	self.m_useXunZhangLb : setString( self.m_xunZhangInfo.have.."/"..self.m_xunZhangInfo.count )

	--更新背包里的对应护符列表
	if _goodsInfo.strengthen >= 7 then 
		self.m_huFuGoodsList = self :getHuFuGoodsList( _goodsInfo.goods_id )
		self.m_hufuBtn		 : setTouchesEnabled( true )
	else
		self.m_hufuBtn		 : setTouchesEnabled( false )
	end

	-- if self.m_xunZhangInfo.count <= self.m_xunZhangInfo.have then 
	-- 	self.m_strengthenBtn :setTouchesEnabled( true ) --强化可点
	-- else
	-- 	self.m_strengthenBtn :setTouchesEnabled( false ) --强化不可点
	-- end
	self.m_strengthenBtn :setTouchesEnabled( true ) --强化可点
	self.m_oneKeyBtn     :setTouchesEnabled( true ) --一键强化可点
	self.m_xunZhangBtn   :setTouchesEnabled( true ) --勋章可点
	self.m_wishBtn       :setTouchesEnabled( true ) --

	--添加神器图标
	self :addIconForButton( self.m_goodsBtn, _goodsInfo.goods_id, CArtifactStrengthenView.TAG_ShenQI )

	self.m_artifactRealIdx = self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx

	if self.m_hasCCBI then
		self.m_strengthenBtn :setTouchesEnabled( false )
		self.m_oneKeyBtn     :setTouchesEnabled( false )
	end

end

function CArtifactStrengthenView.getNameAndColorByColorId( self, _color )

	local colorName , color

	if(_color == 1)then
        colorName ="白"
        color = ccc3(255,255,255)
    elseif(_color == 2)then
        colorName ="绿"
        color = ccc3(91,200,19)
    elseif(_color == 3)then
        colorName ="蓝"
        color = ccc3(0,155,255)
    elseif(_color == 4)then
        colorName ="紫"
        color = ccc3(155,0,188)
    elseif(_color == 5)then
        colorName ="金"
        color = ccc3(255,255,0)
    elseif(_color == 6)then
        colorName ="橙"
        color = ccc3(255,155,0)
    elseif(_color == 7)then
        colorName ="红"
        color = ccc3(255,0,0)
    else
        colorName ="无"
        color = ccc3(255,255,255)
    end

    return colorName,color

end
   



--************************
--发送协议
--************************
--强化
function CArtifactStrengthenView.sendStrengthenMessage( self, _type )
	
	-- self.m_selectGoods_shenQi = 0 --神器 的位置
	-- self.m_selectGoods_wish   = 0 --祝福石 的位置
	-- self.m_selectGoods_hufu   = 0 --护符 的位置
	local type_c 
	local blessId = 0
	local protectionId = 0

	if self.m_selectGoods_partnerId == 1 then 
		type_c = 1
	else
		type_c = 2
	end

	if self.m_selectGoods_wish ~= 0 then 
		blessId = self :getWishGoodsInfoByIndex( self.m_selectGoods_wish ).goods_id
	end

	if self.m_selectGoods_hufu ~= 0 then 
		protectionId = self :getHuFuGoodsInfoByIndex( self.m_selectGoods_hufu ).goods_id
	end

	require "common/protocol/auto/REQ_MAGIC_EQUIP_ENHANCED"
	local msg = REQ_MAGIC_EQUIP_ENHANCED()
	msg :setType(tonumber(_type))
	msg :setTypeC( type_c )
	msg :setId( self.m_selectGoods_partnerId )
	msg :setMagicIdx( self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx )
	msg :setBlessId( blessId )
	msg :setProtectionId( protectionId )
	CNetwork : send( msg )

	-- print("REQ_MAGIC_EQUIP_ENHANCED",self.m_selectGoods_partnerId,self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx)
end

--请求一键强化消耗的金额
function CArtifactStrengthenView.requestOneKeyMenoryMessage( self )
	--   
	local type_c 
	if self.m_selectGoods_partnerId == 1 then 
		type_c = 1
	else
		type_c = 2
	end
	require "common/protocol/auto/REQ_MAGIC_EQUIP_NEED_MONEY"
	local msg = REQ_MAGIC_EQUIP_NEED_MONEY()
	msg :setType( 2 )
	msg :setTypeC( type_c )
	msg :setId( self.m_selectGoods_partnerId )
	msg :setIdx( self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx )
	CNetwork : send( msg )

end




--************************
--mediator控制的方法
--************************
--强化 返回
function CArtifactStrengthenView.strengthenCallBackForMadiator( self, _isSuccess, _index )
	print("\n\n\n\n----------------强化 返回--------------------\n".._index)
	--初始化数据 
	if _isSuccess == 1 then 
		for i,v in ipairs(self.m_allArtifactList) do
			if v.idxType == self.m_selectGoods_partnerId then 
				if v.realIdx == _index then 
					--特效添加
					self : addEffactCCBI()
					if v.info.strengthen == 15 then 
						_G.g_CArtifactView:showSureBox( "强化成功,已达到最高级" )
						self :disboardAritifact()
						return
					else
						--_G.g_CArtifactView:showSureBox( "强化成功" )
						self.m_selectGoods_shenQi = v.listIdx
						break
					end
				end
			end
		end
	else 
		print("神器强化失败播放音效")
    	self : playEffectSound(2) --失败特效

		_G.g_CArtifactView:showSureBox( "强化失败" )

		self.m_hasCCBI = false
		self.m_strengthenBtn :setTouchesEnabled( true )
		self.m_oneKeyBtn     :setTouchesEnabled( true )
	end

	self.m_selectGoods_wish   = 0 --祝福石 的位置
	self.m_selectGoods_hufu   = 0 --护符 的位置

	self.probabilityInfo.wishPro = nil --祝福石概率为空

	--初始化界面
	self:removeIconForButton(self.m_hufuBtn,CArtifactStrengthenView.TAG_HuFu)
	self:removeIconForButton(self.m_wishBtn,CArtifactStrengthenView.TAG_Wish)
	local goodsInfo = self.m_allArtifactList[ self.m_selectGoods_shenQi ].info

	--添加强化信息
	-- self :showStrengthenInfo( goodsInfo )
	self :requestStrenInfo( goodsInfo )
end

function CArtifactStrengthenView.oneKeyMenoryCallBackForMadiator( self, _bless_rmb, _protect_rmb, _total_rmb )

	local useDiamond = _total_rmb

	local function local_strengthenCallBack(  )
		local mainProperty = _G.g_characterProperty : getMainPlay()
        local nDiamond     = mainProperty :getRmb() + mainProperty :getBindRmb()
		local myGolds	   = mainProperty :getGold()

        if nDiamond < useDiamond then 
        	_G.g_CArtifactView:showSureBox( "钻石不足" )
        elseif myGolds < self.m_thisUseMoney then
        	_G.g_CArtifactView:showSureBox( "美刀不足,招财可获得美刀!" )
        else
			self :sendStrengthenMessage(2)

			self.m_strengthenBtn :setTouchesEnabled( false )
			self.m_oneKeyBtn     :setTouchesEnabled( false )
		end
	end 

	local function local_strengthenCancel()
		self.m_oneKeyBtn     :setTouchesEnabled( true )
	end

	print("---------------self.PopBox.iswindowscheckBoxChecked--->"..self.PopBox.iswindowscheckBoxChecked,_bless_rmb,_protect_rmb,_total_rmb,self.m_allArtifactList[ self.m_selectGoods_shenQi ].info.goods_id)
	if useDiamond == 0 or self.PopBox.iswindowscheckBoxChecked == 1 then 
		self.m_oneKeyBtn     :setTouchesEnabled( true ) -- 一键强化可点
		local_strengthenCallBack()
		return
	end

	local str = ""
	if _bless_rmb > 0 then 
		str = str.."花费 ".._bless_rmb.." 钻石购买传说祝福石\n"
	end
	if _protect_rmb > 0 then 
		local goodsId  = self.m_allArtifactList[ self.m_selectGoods_shenQi ].info.goods_id
		-- local hufuNode = self:getHuFuNodeByGoodsId( goodsId )
		local goodNode = self:getGoodsNodeForXml( goodsId )
		local hufuName = self:getHuFuNameByColor( tonumber(goodNode:getAttribute("name_color")) )
		str = str.."花费 ".._protect_rmb.." 钻石购买"..hufuName.."\n"
	end

	str = str.."总共花费 "..useDiamond.." 钻石一键强化"
	
    self.m_strenPopBoxLayer = self.PopBox : create(local_strengthenCallBack,str,1,local_strengthenCancel)
    self.m_strenPopBoxLayer : setPosition(-20,0)
    self.m_scenelayer : addChild(self.m_strenPopBoxLayer,999)

    self.m_oneKeyBtn     :setTouchesEnabled( true ) --一键强化可点
end

function CArtifactStrengthenView.getHuFuNameByColor( self, _color )
	-- body
	local name = ""
	
	if tonumber("_color") == 2 then
		name = "初级保护符"
	elseif tonumber("_color") == 3 then
		name = "中级保护符"
	elseif tonumber("_color") == 4 then
		name = "高级保护符"
	elseif tonumber("_color") == 5 then
		name = "史诗保护符"
	elseif tonumber("_color") == 6 then
		name = "传说保护符"
	end

	return name

end

function CArtifactStrengthenView.getHuFuNodeByGoodsId( self, _goodsId )
	local node  = self:getGoodsNodeForXml( _goodsId )
	local goodsColor = tonumber( node.name_color )
	for i,v in ipairs(_G.Config.goodss.goods) do
		if tonumber(v.type_sub) == _G.Constant.CONST_GOODS_PROTECT_OPERATOR then 
			local color = tonumber(v.d[1].as1)
			if goodsColor == color then 
				return v
			end
		end
	end
	
end

function CArtifactStrengthenView.addEffactCCBI(self)
    print("神器强化成功播放音效")
    self : playEffectSound(1) --成功特效

    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.m_goodsBtn   : removeChild(self.THEccbi,false)
            self.THEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")

            self.m_hasCCBI = true
        end
        if eventType == "AnimationComplete" then
            if self.THEccbi ~= nil then
                if self.THEccbi  : retainCount() >= 1 then
                    self.m_goodsBtn   : removeChild(self.THEccbi,false)
                    self.THEccbi = nil 
                end
            end

            self.m_strengthenBtn :setTouchesEnabled( true )
			self.m_oneKeyBtn     :setTouchesEnabled( true )

			self.m_hasCCBI = false
        end
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    self.m_goodsBtn  : addChild(self.THEccbi,1000)
end

function CArtifactStrengthenView.playEffectSound(self,_type) --成功特效
	if _type == 1 then      --成功音效
		if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
	        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
	    end
	elseif _type == 2 then  --失败音效
		if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
	        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_fail.mp3", false)
	    end
	end
end



