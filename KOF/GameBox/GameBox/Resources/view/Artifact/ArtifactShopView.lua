--*********************************
--2013-8-16 by 陈元杰
--神器商店界面-CArtifactShopView
--*********************************
require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/Artifact/ArtifactShopMediator"
-- require "view/Artifact/ArtifactTipsBuyView"
require "view/Shop/AdditionAndsubtractionPopBox"
--require "common/Constant"

CArtifactShopView = class(view, function(self,_PageType)
	self.PageType = nil 
	self.PageType = tonumber(_PageType) 
	print("self.PageType==",self.PageType)
	if self.PageType == 1 then --神器兑换
		self.SHOP_ChildId = _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_MAT
	elseif self.PageType == 2 then --钻石兑换
		self.SHOP_ChildId = _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_DIAMOND
	end
end)

----------------------------
--常量
----------------------------
--按钮tag值
CArtifactShopView.TAG_CLOSE     = 201

--
CArtifactShopView.PrePageSize    = 8

--商店常量
CArtifactShopView.SHOP_MainId    = 10
-- CArtifactShopView.SHOP_ChildId   = _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_MAT
-- CArtifactShopView.SHOP_ChildId2  = _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_DIAMOND

--颜色
CArtifactShopView.RED   = ccc3(255,0,0)
CArtifactShopView.GOLD  = ccc3(255,215,0)
CArtifactShopView.GREEN = ccc3(120,222,66)
CArtifactShopView.WHITE = ccc3(255,255,255)

function CArtifactShopView.initView( self, _mainSize )
	----------------------------
	--
	----------------------------
	local function local_scrollViewCallBack( eventType,obj,intPage )
		-- body
		return self :ScrollViewCallBack(eventType,obj,intPage)
	end

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CArtifactShopView self.m_mainContainer 104" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

	self.m_mainLeftBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainLeftBg : setControlName( "this CArtifactShopView self.m_mainLeftBg 44 ")
	self.m_mainLeftBg : setPreferredSize( CCSizeMake(_mainSize.width*0.96,_mainSize.height*0.85) )
	self.m_mainContainer : addChild( self.m_mainLeftBg)

	self.m_scrollViewContainer = CContainer :create()
    self.m_scrollViewContainer : setControlName( "this is CArtifactShopView self.m_scrollViewContainer 49" )
    self.m_mainContainer       : addChild( self.m_scrollViewContainer,100)

	self.m_ScrollViewSize = CCSizeMake(_mainSize.width*0.95,_mainSize.height*0.79)
    self.m_pScrollView    = CPageScrollView :create(1,self.m_ScrollViewSize)
    self.m_pScrollView    : registerControlScriptHandler(local_scrollViewCallBack,"this is CShopLayer ScrollViewCallBack 295")
    self.m_pScrollView    : setTouchesPriority(-1)
    self.m_scrollViewContainer : addChild( self.m_pScrollView,100 )

    self.m_nowPageImg = CSprite :createWithSpriteFrameName( "general_pagination_underframe.png" )
    self.m_nowPageLb  = CCLabelTTF :create("0/0","Arial",20) 

    self.m_mainContainer : addChild( self.m_nowPageImg)
    self.m_mainContainer : addChild( self.m_nowPageLb)



    local goldName = "menu_icon_artifact.png"
    if self.SHOP_ChildId == _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_DIAMOND then
    	goldName = "menu_icon_diamond.png"
    end
    self.m_goldIcon = CSprite :createWithSpriteFrameName(goldName)
    self.m_goldIcon : setControlName( "this CArtifactShopView self.m_goldIcon 44 ")
	self.m_mainContainer : addChild( self.m_goldIcon)

	self.m_goldNumLb  = CCLabelTTF :create("","Arial",20) 
    self.m_mainContainer : addChild( self.m_goldNumLb)

    self:resetGoldNum()

end

function CArtifactShopView.layout(self, _mainSize)
	----------------------------
	--背景
	----------------------------
	self.m_mainLeftBg  : setPosition( ccp(_mainSize.width*0.5,_mainSize.height*0.484) ) -- 背景
	self.m_pScrollView : setPosition(_mainSize.width*0.0263,_mainSize.height*0.1)

	self.m_nowPageImg : setPosition( ccp(_mainSize.width*0.5, 64) ) -- 当前页数背景
	self.m_nowPageLb  : setPosition( ccp(_mainSize.width*0.5, 64) ) -- 当前页数Label
	
	self.m_goldIcon   : setPosition( ccp(_mainSize.width*0.06, 65) )

	local goldIconSize = self.m_goldIcon : getPreferredSize()
	self.m_goldNumLb  : setAnchorPoint( ccp(0,0.5) )
	self.m_goldNumLb  : setPosition( ccp(_mainSize.width*0.06 + goldIconSize.width/2 + 5, 65) )

end

--初始化数据成员
function CArtifactShopView.initParams( self )

	self.m_isInit    = 0
	self.m_pageCount = 0
end

--注册Mediator
function CArtifactShopView.registerShopMediator( self )
	
    _G.pCArtifactShopMediator = CArtifactShopMediator(self)
    controller :registerMediator(_G.pCArtifactShopMediator)--先注册后发送 否则会报错  

end

--反注册Mediator
function CArtifactShopView.unregisterShopMediator( self )
	if _G.pCArtifactShopMediator ~= nil then 
		controller :unregisterMediator( _G.pCArtifactShopMediator )
		_G.pCArtifactShopMediator = nil
	end
end

function CArtifactShopView.init(self, _mainSize )
	--初始化数据
    self:initParams( )
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function CArtifactShopView.layer(self)

    local winSize  = CCDirector:sharedDirector():getVisibleSize()
    local mainSize = CCSizeMake( 854, winSize.height )
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CArtifactShopView self.Scenelayer 14" )
    self:init(mainSize)
    return self.m_scenelayer
end

--*****************
--读取xml数据
--*****************
--获取goods xml的节点
function CArtifactShopView.getGoodsNodeForXml( self, _goodsId )
	return _G.Config.goodss :selectSingleNode( "goods[@id="..tostring( _goodsId ).."]" )
end




--*****************
--页面设置
--*****************
function CArtifactShopView.resetGoldNum( self )
	local money = 0
	if self.SHOP_ChildId == _G.Constant.CONST_MAGIC_EQUIP_EXCHANGE_DIAMOND then
		local mainProperty = _G.g_characterProperty : getMainPlay()
		money = mainProperty :getRmb() + mainProperty :getBindRmb()
	else
		local materList = _G.g_GameDataProxy : getBackpackList() or {}
		for i,v in ipairs(materList) do
			if 38501 == v.goods_id then
				money = money + v.goods_num
			end
		end
    end

    if self.m_goldNumLb ~= nil then
    	self.m_goldNumLb : setString(tostring(money))
    end
end

--scrollView
function CArtifactShopView.resetScrollViewPage( self )

	local function local_btnBuyTouchCallback(eventType,obj,x,y)
		--购买 单击回调
		--print("购买 单击回调")
		return self:btnBuyTouchCallback(eventType,obj,x,y)
	end

	local function local_bgTouchCallBack( eventType, obj, touches )
		print("…………………ææææææææææææææ……………………"..eventType)
		return self:bgTouchCallBack( eventType, obj, touches )
	end

	local function local_goodsTouchCallBack( eventType, obj, x, y )
		print("…………………ææææææææææææææ……………………"..eventType)
		return self:goodsTouchCallBack( eventType, obj, x, y )
	end

	local winSize  = CCDirector:sharedDirector():getVisibleSize()
	local mainSize = CCSizeMake( 854, winSize.height )

	local count    = #self.m_goodsList
	local pageSize = CArtifactShopView.PrePageSize
	local pageCount= math.floor(count/pageSize) + 1

	self.m_pageCount = pageCount
	self.m_nowPageLb :setString( tostring(1).."/"..self.m_pageCount )

	if math.mod( count,pageSize) == 0 and count ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( count-1,pageSize)+1         --最后一页个数


    local cellSize = CCSizeMake(mainSize.width*0.462,mainSize.height*0.175)
    
	local index = count
	for i=1,pageCount do
		
		local pageContainer = CContainer :create()
	    pageContainer : setControlName( "this is CArtifactShopView pageContainer 176" )
	    self.m_pScrollView : addPage( pageContainer , true )

		local goodsLayout = CHorizontalLayout:create()
		goodsLayout : setCellSize( cellSize )
		goodsLayout : setCellHorizontalSpace( 8 )
		goodsLayout : setCellVerticalSpace( 9 )
		goodsLayout : setVerticalDirection( false)
        goodsLayout : setHorizontalDirection( true)
		goodsLayout : setLineNodeSum(2)
		goodsLayout : setColumnNodeSum(4)
		pageContainer : addChild( goodsLayout )
		goodsLayout : setPosition( -mainSize.width*0.47,self.m_ScrollViewSize.height/2-60 )

		local size = pageSize
		if i == pageCount then 
			size = lastPageCount
		end

		for j=1,size do
			print(i,j,index)
			-- print(self.m_goodsList[index].id,count)
			local goodsId   = self.m_goodsList[index].goods_id
			local goodsIdx  = self.m_goodsList[index].idx
			local goodsNode = self :getGoodsNodeForXml( goodsId )
			local goodsIcon = goodsNode:getAttribute("icon")
			local name      = goodsNode:getAttribute("name")
			local priceType = self.m_goodsList[index].type
			local price     = self.m_goodsList[index].s_price
			local priceName = CLanguageManager:sharedLanguageManager():getString(tostring("Currency_Type_"..priceType))
			local btnName   = "购买" 
			if priceType ~= _G.Constant.CONST_CURRENCY_RMB and priceType ~= _G.Constant.CONST_CURRENCY_GOLD and priceType ~= _G.Constant.CONST_CURRENCY_RMB_BIND then 
				btnName   = "兑换" 
				--price     = self.m_goodsList[index].goods_num or -1
			end 

			index = index - 1

			local cellBg = CButton :createWithSpriteFrameName("","general_underframe_normal.png")
		    cellBg : setControlName( "this CArtifactShopView cellBg 217 ")
			cellBg : setPreferredSize( cellSize )
			cellBg : setTouchesPriority(-10)
			cellBg : setTag( goodsIdx )
			cellBg : setTouchesMode( kCCTouchesAllAtOnce )
			cellBg : registerControlScriptHandler( local_bgTouchCallBack, "this CArtifactShopView cellBg 227 ")
			goodsLayout : addChild( cellBg )

			local goodsBg = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
		    goodsBg : setControlName( "this CArtifactShopView goodsBg 222 ")
			cellBg  : addChild( goodsBg, 10 )

			_G.g_CArtifactView:setCreateResStr( "Icon/i"..tostring( goodsIcon )..".jpg" )
			local goodsBtn = CButton :create("","Icon/i"..tostring( goodsIcon )..".jpg")
		    goodsBtn  : setControlName( "this CArtifactShopView goodsBtn 226 ")
		    goodsBtn  : setTag( goodsId )
		    goodsBtn  : registerControlScriptHandler( local_goodsTouchCallBack, "this CArtifactShopView cellBg 227 ")
			goodsBg   : addChild( goodsBtn,-1 )

			local nameLabel = CCLabelTTF :create(name,"Arial",20)
			cellBg :addChild( nameLabel, 10 )

			local priceLabel = CCLabelTTF :create("价格:"..price..priceName,"Arial",20)
			priceLabel :setColor( ccc4(255,255,0,255) )
			cellBg :addChild( priceLabel, 10 )

			local buyButton =  CButton : createWithSpriteFrameName(btnName,"general_smallbutton_click.png")
			buyButton : setControlName("this CArtifactShopView buyButton 237 ")
			buyButton : setTag( goodsIdx )
			buyButton : setFontSize( 24 )
			buyButton : setTouchesPriority(-11)
		    buyButton : registerControlScriptHandler( local_btnBuyTouchCallback, "this CArtifactShopView buyButton 242 ")
			cellBg    : addChild( buyButton, 10 )

			local cellBgSize    = cellBg    :getPreferredSize()
			local goodsBgSize   = goodsBg   :getPreferredSize()
			local buyButtonSize = buyButton :getContentSize()

			goodsBg    : setPosition( ccp(goodsBgSize.width/2-cellBgSize.width/2+5,0) )
			goodsBtn  : setPosition( ccp(0,0) )
			nameLabel  : setPosition( ccp(goodsBgSize.width-cellBgSize.width/2+10,20) )
			priceLabel : setPosition( ccp(goodsBgSize.width-cellBgSize.width/2+10,-20) )
			buyButton  : setPosition( ccp(cellBgSize.width/2-buyButtonSize.width/2-25,0) )
			nameLabel  : setAnchorPoint( ccp(0,0.5) )
			priceLabel : setAnchorPoint( ccp(0,0.5) )

		end
	end

end





function CArtifactShopView.getGoodsInfoByIndex( self, _index )
	
	for i,v in ipairs(self.m_goodsList) do
		if tonumber(_index) == v.idx then 
			return v
		end
	end
	return nil

end






--************************
--按钮回调
--************************
function CArtifactShopView.ScrollViewCallBack(self,eventType,obj,intPage)
	_G.g_PopupView :reset()
	local pageCount = obj :getPageCount() or 99
	local nowPage   = intPage or 0
	self.m_nowPageLb :setString( tostring(nowPage+1).."/"..pageCount )
end


--购买 按钮 单击回调
function CArtifactShopView.btnBuyTouchCallback(self, eventType, obj, x, y)


	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 

	    	local tag = obj:getTag()

			local PopData = self :makePopData( tag )

			self.PopBox = CAdditionAndsubtractionPopBox()
			local ThePopBox = self.PopBox : create( nil, nil , PopData )
			ThePopBox : setPosition(-20,0)
			self.m_scenelayer : addChild(ThePopBox) 

			local parent = obj :getParent()
			self :chuangItemBgForObj( parent )

        end
    end
end

--物品 单击回调
function CArtifactShopView.goodsTouchCallBack( self, eventType , obj , x, y )

	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 

	    	local goodsId   = obj:getTag()
	    	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
			local _mainSize = CCSizeMake( 854, _winSize.height )
            local _position = {}
            _position.x = x
            _position.y = y

            if _G.g_CArtifactView ~= nil then
				_G.g_CArtifactView:showGoodsByGoodsIdTips( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE,_position )
			end

			local parent = obj : getParent() : getParent()
			self :chuangItemBgForObj( parent )
        end
    end
end

--背景 单击回调
function CArtifactShopView.bgTouchCallBack( self, eventType , obj , touches )
	if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.goodsIdx    = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.goodsIdx == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                	self :chuangItemBgForObj( obj )

                    self.touchID   = nil
                    self.goodsIdx  = nil
                end
            end
        end
    end
end

function CArtifactShopView.chuangItemBgForObj( self, _obj )

	if _obj == nil then 
		return
	end

	local mainSize = CCSizeMake( 854, 640 )
	local cellSize = CCSizeMake(mainSize.width*0.462,mainSize.height*0.175)
	if self.m_touchBg ~= nil then
		self.m_touchBg : removeChildByTag(999)
		self.m_touchBg = nil 
	end

	self.m_touchBg = CSprite :createWithSpriteFrameName("general_underframe_click.png")
	self.m_touchBg : setPreferredSize( cellSize )
	_obj :addChild( self.m_touchBg,2,999 )

	self.m_touchBg = _obj
end


function CArtifactShopView.makePopData( self , _index )
	
	local goodsInfo = self :getGoodsInfoByIndex( _index )
	local goodsNode = self :getGoodsNodeForXml( goodsInfo.goods_id )
	local data = {}
	data.id   = goodsInfo.goods_id
	data.name = goodsNode:getAttribute("name")
	data.icon = goodsNode:getAttribute("icon")
	data.idx  = _index
	data.price_type = goodsInfo.type
	data.s_price    = goodsInfo.s_price
	data.v_price    = goodsInfo.s_price
	data.goods_num  = goodsInfo.goods_num
	data.total_remaider_Num = goodsInfo.total_remaider_Num
	data.mall_typebb = self.SHOP_ChildId
	data.mall_type   = CArtifactShopView.SHOP_MainId
	return data

end


--************************
--发送协议
--************************
--请求商店数据
function CArtifactShopView.sendRequestViewMessage( self )

	if self.m_isInit == 0 then 
		self.m_isInit = 1
		require "common/protocol/auto/REQ_SHOP_REQUEST"
		local msg = REQ_SHOP_REQUEST()
		print("协议发=====",self.SHOP_ChildId)
		msg :setType( CArtifactShopView.SHOP_MainId )
		msg :setTypeBb( self.SHOP_ChildId )
		CNetwork : send( msg )
	end
end

--请求购买
-- function CArtifactShopView.sendBuyGoodsMessage( self,_index,_goodsId,_count )
-- 	require "common/protocol/auto/REQ_SHOP_BUY"
-- 	local msg = REQ_SHOP_BUY()
-- 	msg :setType( CArtifactShopView.SHOP_MainId )
-- 	msg :setTypeBb( CArtifactShopView.SHOP_ChildId )
-- 	msg :setIdx( _index )
-- 	msg :setGoodsId( _goodsId )
-- 	msg :setCount( _count )
-- 	CNetwork : send( msg )
-- end

--************************
--mediator控制的方法
--************************
--商城数据 返回
function CArtifactShopView.shopDataCallBackForMadiator( self, _data )
	print("返回了多少此？",#_data)
	-- local data = {}
	-- if _data  ~= nil then
	-- 	local PriceType = nil 
	-- 	if self.PageType  == 1  then
	-- 		PriceType = _G.Constant.CONST_CONST_CURRENCY_SYMBOL  --神器碎片
	-- 	elseif self.PageType  == 2  then
	-- 		PriceType = _G.Constant.CONST_CURRENCY_RMB           --钻石碎片
	-- 	end

	-- 	for k,v in pairs(_data) do
	-- 		if tonumber(v.type) == PriceType then --神器碎片
	-- 			table.insert(data,v)
	-- 		end 
	-- 	end
		
	-- end
	-- self.m_goodsList = data
	self.m_goodsList = _data
	self :resetScrollViewPage()

end

function CArtifactShopView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local _winSize  = CCDirector:sharedDirector():getVisibleSize()
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    BoxLayer : setPosition(ccp(-_winSize.width/2+854/2,0))
    self.m_mainContainer : addChild(BoxLayer,1000)
end



