--*********************************
--2013-8-16 by 陈元杰
--神器进阶界面-CArtifactAdvanceView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/Artifact/ArtifactAdvanceMediator"
require "view/LuckyLayer/PopBox"

CArtifactAdvanceView = class(view, function(self)
	CArtifactAdvanceView.readgiftxml = nil
end)

----------------------------
--常量
----------------------------
--按钮tag值
CArtifactAdvanceView.TAG_ADVANCE     = 201

--tab 页面Tag值
CArtifactAdvanceView.TAG_AdvanceNow = 301 --进阶前
CArtifactAdvanceView.TAG_AdvanceAft = 302 --进阶后
CArtifactAdvanceView.TAG_ShengShui  = 303 --圣水

CArtifactAdvanceView.PER_PAGE_COUNT       = 12    --每页物品的个数
CArtifactAdvanceView.MAX_GOODS_COUNT      = 80   --背包最大格数

--颜色
CArtifactAdvanceView.RED   = ccc3(255,0,0)
CArtifactAdvanceView.GOLD  = ccc3(255,215,0)
CArtifactAdvanceView.GREEN = ccc3(120,222,66)

CArtifactAdvanceView.FONT_SIZE_LABEL = 20

function CArtifactAdvanceView.initView( self, _mainSize )
	----------------------------
	--背景
	----------------------------
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CArtifactAdvanceView self.m_mainContainer 104" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

	self.m_mainLeftBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainLeftBg : setControlName( "this CArtifactAdvanceView self.m_mainLeftBg 43 ")
	self.m_mainLeftBg : setPreferredSize( CCSizeMake( 510 , 553 ) )
	self.m_mainContainer : addChild( self.m_mainLeftBg)

	self.m_mainRightBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainRightBg : setControlName( "this CArtifactAdvanceView self.m_mainRightBg 43 ")
	self.m_mainRightBg : setPreferredSize( CCSizeMake( 311 , 553 ) )
	self.m_mainContainer : addChild( self.m_mainRightBg)

	local function local_btnTouchCallback(eventType,obj,x,y)
		--按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	local function local_goodsTouchCallback(eventType, obj, touches)
		--物品格子 单击回调
		return self:goodsTouchCallback(eventType, obj, touches)
	end

	--提示
	self.m_noticLb = CCLabelTTF :create( "神器强化9以上可以进行升阶", "Arial", 20)
	self.m_noticLb : setAnchorPoint( ccp(0,0.5) )
	self.m_noticLb : setColor( CArtifactAdvanceView.GOLD )
	self.m_mainContainer : addChild( self.m_noticLb )

	-- 进阶按钮
	self.m_advanceBtn = CButton :createWithSpriteFrameName( "进阶", "general_button_normal.png")
	self.m_advanceBtn :setControlName( "this CArtifactAdvanceView self.m_advanceBtn 114 ")
    self.m_advanceBtn :setFontSize( 24)
    self.m_advanceBtn :setTouchesEnabled( false )
    self.m_advanceBtn :setTag( CArtifactAdvanceView.TAG_ADVANCE )
    self.m_advanceBtn :registerControlScriptHandler( local_btnTouchCallback, "this CArtifactAdvanceView self.m_advanceBtn 117 ")
    self.m_mainContainer :addChild( self.m_advanceBtn )

    self.m_advanceWord = CSprite :createWithSpriteFrameName( "artifact_arrow_jjh.png" ) 
    self.m_mainContainer :addChild( self.m_advanceWord )

    -- 物品格子
    --当前神器物品
	self.m_goodsNowBtn = CButton : createWithSpriteFrameName("","general_equip_frame.png")
	self.m_goodsNowBtn : setControlName("this CArtifactAdvanceView self.m_goodsNowBtn 179 ")
	self.m_goodsNowBtn : setTag( CArtifactAdvanceView.TAG_AdvanceNow )
	self.m_goodsNowBtn : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_goodsNowBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactAdvanceView self.m_goodsNowBtn 117 ")
	self.m_mainContainer : addChild( self.m_goodsNowBtn )

	--进阶后神器物品
	self.m_goodsAdvanceBtn = CButton : createWithSpriteFrameName("","general_equip_frame.png")
	self.m_goodsAdvanceBtn : setControlName("this CArtifactAdvanceView self.m_goodsAdvanceBtn 179 ")
	self.m_goodsAdvanceBtn : setTag( CArtifactAdvanceView.TAG_AdvanceAft )
	self.m_goodsAdvanceBtn : setTouchesMode( kCCTouchesAllAtOnce )
	-- self.m_goodsAdvanceBtn : setTouchesEnabled( false )
    -- self.m_goodsAdvanceBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactAdvanceView self.m_goodsAdvanceBtn 117 ")
	self.m_mainContainer : addChild( self.m_goodsAdvanceBtn )

	--圣水物品
	self.m_shengShuiBtn = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
	self.m_shengShuiBtn : setControlName("this CArtifactAdvanceView self.m_shengShuiBtn 179 ")
	self.m_shengShuiBtn : setTag( CArtifactAdvanceView.TAG_ShengShui )
	self.m_shengShuiBtn : setTouchesMode( kCCTouchesAllAtOnce )
	self.m_shengShuiBtn : setTouchesEnabled( false )
    self.m_shengShuiBtn : registerControlScriptHandler( local_goodsTouchCallback, "this CArtifactAdvanceView self.m_shengShuiBtn 117 ")
	self.m_mainContainer : addChild( self.m_shengShuiBtn )

	--进阶前神器名称Label
	self.m_nowArtifactLb = CCLabelTTF :create( "", "Arial", 22)
	self.m_goodsNowBtn   : addChild( self.m_nowArtifactLb )

	--进阶后神器名称Label
	self.m_advanceArtiLb = CCLabelTTF :create( "", "Arial", 22)
	self.m_goodsAdvanceBtn   : addChild( self.m_advanceArtiLb )

	--圣水使用数
	self.m_useShengShuiLb = CCLabelTTF :create( "", "Arial", 20)
	self.m_useShengShuiLb : setColor( CArtifactAdvanceView.GOLD )
	self.m_shengShuiBtn   : addChild( self.m_useShengShuiLb )

	--消耗金额
	self.m_useGoldLb = CCLabelTTF :create( "", "Arial", 20)
	self.m_useGoldLb : setColor( CArtifactAdvanceView.GOLD )
	self.m_mainContainer   : addChild( self.m_useGoldLb )

	local goodsNowBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_sq.png")
	goodsNowBtnBg : setControlName("this CArtifactStrengthenView goodsNowBtnBg 147 ")
	self.m_goodsNowBtn : addChild(goodsNowBtnBg, -1)

	local goodsAdvanceBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_sq.png")
	goodsAdvanceBtnBg : setControlName("this CArtifactStrengthenView goodsAdvanceBtnBg 147 ")
	self.m_goodsAdvanceBtn : addChild(goodsAdvanceBtnBg, -1)

	local shengShuiBtnBg = CSprite:createWithSpriteFrameName("artifact_underframe_ss.png")
	shengShuiBtnBg : setControlName("this CArtifactStrengthenView shengShuiBtnBg 147 ")
	self.m_shengShuiBtn : addChild(shengShuiBtnBg, -1)

end

function CArtifactAdvanceView.layout(self, _mainSize)

	-- local winSize  = CCDirector:sharedDirector():getVisibleSize()
	-- self.m_mainContainer :setPosition( ccp( winSize.width/2-_mainSize.width/2, 0 ) )

	----------------------------
	--背景
	----------------------------
	self.m_mainLeftBg    : setPosition( ccp( 262, 293) ) -- 左背景
	self.m_mainRightBg	 : setPosition( ccp( 682, 293) ) -- 右背景
	self.m_advanceBtn    : setPosition( ccp( 262,_mainSize.height*0.17) )  -- 进阶按钮
	self.m_advanceWord   : setPosition( ccp( 262,_mainSize.height*0.695) )

	self.m_noticLb : setPosition( ccp( 26 , _mainSize.height*0.85) )--提示
	-- 物品格子
	self.m_goodsNowBtn 		: setPosition( ccp( 262 - 145 ,_mainSize.height*0.695) )--当前神器物品
	self.m_goodsAdvanceBtn  : setPosition( ccp( 262 + 145,_mainSize.height*0.695) )--进阶后神器物品
	self.m_shengShuiBtn  	: setPosition( ccp( 262,_mainSize.height*0.45) )--圣水物品

	local shengShuiBtnSize = self.m_shengShuiBtn :getContentSize()
	self.m_nowArtifactLb   : setPosition( ccp( 0, shengShuiBtnSize.height/2 + 26 ) )--进阶前神器名称Label
	self.m_advanceArtiLb   : setPosition( ccp( 0, shengShuiBtnSize.height/2 + 26 ) )--进阶后神器名称Label
	self.m_useShengShuiLb  : setPosition( ccp( 0, -shengShuiBtnSize.height/2 - 10 ) )--圣水使用数Label

	self.m_useGoldLb       : setPosition( ccp( 262, _mainSize.height*0.28 ) )--消耗金额
end

--初始化数据成员
function CArtifactAdvanceView.initParams( self )
	--
	self.m_selectGoods_partnerId = 1
	self.m_selectGoods_shenQi    = 0

	--跟新背包的物品数据
	self:refreshPackageData()

    self :loadXmlData()
end

function CArtifactAdvanceView.refreshPackageData( self )
	--更新本地数据
	self.m_mainProperty    = _G.g_characterProperty :getMainPlay()
	self.m_allArtifactList = self :getAllArtifactList()
	self.m_materiaList     = _G.g_GameDataProxy :getMaterialList()
end

--注册Mediator
function CArtifactAdvanceView.registerAdvanceMediator( self )
	
    _G.pCArtifactAdvanceMediator = CArtifactAdvanceMediator(self)
    controller :registerMediator(_G.pCArtifactAdvanceMediator)--先注册后发送 否则会报错  

end

--反注册Mediator
function CArtifactAdvanceView.unregisterAdvanceMediator( self )
	if _G.pCArtifactAdvanceMediator ~= nil then 
		controller :unregisterMediator( _G.pCArtifactAdvanceMediator )
		_G.pCArtifactAdvanceMediator = nil
	end
end

function CArtifactAdvanceView.init(self, _mainSize )
	--初始化数据
    self:initParams( )
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
	--显示玩法介绍
	self :showNoticView()
end

function CArtifactAdvanceView.layer(self)

    local winSize  = CCDirector:sharedDirector():getVisibleSize()
    local mainSize = CCSizeMake( 854, winSize.height )
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CArtifactAdvanceView self.Scenelayer 14" )
    self:init(mainSize)
    return self.m_scenelayer
end


--*****************
--读取xml数据
--*****************
function CArtifactAdvanceView.loadXmlData( self )

    _G.Config :load( "config/goods.xml")

	_G.Config :load( "config/equip_make.xml")

end

--读取物品信息 从xml
function CArtifactAdvanceView.getGoodsNodeForXml( self, _goodsId )
	return _G.Config.goodss :selectSingleNode( "goods[@id="..tostring( _goodsId ).."]" )
end

--读取物品打造信息 从xml
function CArtifactAdvanceView.getEupipMakeNodeForXml( self, _goodsId )
	return _G.Config.equip_makes :selectSingleNode( "equip_make[@id="..tostring( _goodsId ).."]" )
end


--获得所有神器的物品 
function CArtifactAdvanceView.getAllArtifactList( self )

	local list = {}
	local count = 1

	--背包的神器 
	for i,v in ipairs( _G.g_GameDataProxy :getArtifactList() ) do
		if v.strengthen >= 9 then 
			local goodsNode = self :getGoodsNodeForXml( v.goods_id )
			if tonumber(goodsNode:children():get(0,"f"):getAttribute("make")) == 1 then 
				list[count] 		= {}
				list[count].idxType = 1  --1:背包  武将:他的Id
				list[count].listIdx = count
				list[count].info    = v
				list[count].realIdx = v.index --所在容器的位置
				count = count + 1
			end
		end
	end

	local uid 			= _G.g_LoginInfoProxy :getUid()
	local mainProperty  = _G.g_characterProperty :getOneByUid( tonumber( uid ), _G.Constant.CONST_PLAYER)
	local partneridlist = mainProperty :getPartner()   --伙伴ID列表

	local myEquiplist = mainProperty :getArtifactEquipList()
	if myEquiplist ~= nil then
		for i,v in ipairs(myEquiplist) do
			if v.strengthen >= 9 then 
				local goodsNode = self :getGoodsNodeForXml( v.goods_id )
				if tonumber(goodsNode:children():get(0,"f"):getAttribute("make")) == 1 then 
					print("---getAllArtifactList ",v.index)
					list[count] 		= {}
					list[count].idxType = 0  --1:背包  武将:他的Id
					list[count].listIdx = count
					list[count].info    = v
					list[count].realIdx = v.index --所在容器的位置
					count = count + 1
				end
			end
		end
	end

	if partneridlist ~= nil then
		for i,v in ipairs(partneridlist) do
			local index = tostring( uid )..tostring( v )
    		local roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
    		local equiplist    = roleProperty :getArtifactEquipList()
    		if equiplist ~= nil then
    			for j,vv in ipairs(equiplist) do
    				if vv.strengthen >= 9 then 
						local goodsNode = self :getGoodsNodeForXml( vv.goods_id )
						if tonumber(goodsNode:children():get(0,"f"):getAttribute("make")) == 1 then 
							print("---getAllArtifactList ",vv.index)
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
		end
	end

	return list
end


--得到进阶材料的背包物品列表
function CArtifactAdvanceView.getArtifactGoodsList( self )
	
	local list = {}
	for i,v in ipairs(_G.g_GameDataProxy :getArtifactList() ) do
		if v.strengthen >= _G.Constant.CONST_MAGIC_EQUIP_STRENGTHEN_LV then 
			table.insert(list,v)
		end
	end

	return list

end

--得到进阶材料的背包物品列表
function CArtifactAdvanceView.getCaiLiaoGoodsList( self, _goodsId )
	
	local list = {}
	for i,v in ipairs(self.m_materiaList) do
		if v.goods_id == tonumber( _goodsId ) then 
			table.insert(list,v)
		end
	end

	return list

end

--得到进阶材料的总数量
function CArtifactAdvanceView.getCaiLiaoGoodsNum( self, _goodsId )
	
	local list  = self :getCaiLiaoGoodsList(_goodsId)
	local count = 0
	for i,v in ipairs(list) do
		count = count + v.goods_num
	end

	return count

end







--************************
--按钮回调
--************************
--进阶 按钮 单击回调
function CArtifactAdvanceView.btnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			if  tag == CArtifactAdvanceView.TAG_ADVANCE then 
				-- 进阶
				print("进阶啦")
				
				local function local_advanceCallBack( )
					local mainProperty = _G.g_characterProperty : getMainPlay()
		            local myGolds
		            if self.m_shengShuiInfo.goldType == _G.Constant.CONST_CURRENCY_GOLD then 
						myGolds = mainProperty :getGold()
					else
						myGolds = mainProperty :getRmb() + mainProperty :getBindRmb()
					end
		            	
		            if myGolds >= self.m_shengShuiInfo.price then 
	            		self :sendAdvanceMessage()
		            else 
		            	_G.g_CArtifactView:showSureBox( self.m_shengShuiInfo.goldName.."不足" )
		            end
		        end
		        --确认框
		        self.PopBox = CPopBox() --初始化
                self.m_advanceBoxLayer = self.PopBox : create(local_advanceCallBack,"消耗"..self.m_shengShuiInfo.price..self.m_shengShuiInfo.goldName.."进阶神器",0)
                self.m_advanceBoxLayer : setPosition(0,0)
                self.m_scenelayer        : addChild(self.m_advanceBoxLayer)
				
			end
		end
	end
end


--物品 按钮 单击回调
function CArtifactAdvanceView.goodsTouchCallback(self, eventType, obj, touches)

	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID1     = touch :getID()
                self.goodstag1    = obj :getTag()
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
            if touch2:getID() == self.touchID1 and self.goodstag1 == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                	local tag = obj:getTag()
					if  tag == CArtifactAdvanceView.TAG_AdvanceNow then 
						-- 神器格子
						print("神器格子")
						if self.m_goodsViewContainer ~= nil and self.isTouchGoodsInfo then 
							self :removeGoodsView()
						elseif self.m_goodsViewContainer == nil then
							self :showGoodsView()
						end

					elseif tag == CArtifactAdvanceView.TAG_ShengShui then 
						-- 圣水格子
						print("圣水格子 展示物品")

						local winSize = CCDirector:sharedDirector():getVisibleSize()
	                    local _position = {}
	                    _position.x = touch2Point.x 
	                    _position.y = touch2Point.y 
	                    local goodsId = self.m_shengShuiInfo.goodsId

	                    if _G.g_CArtifactView ~= nil then
							_G.g_CArtifactView:showGoodsByGoodsIdTips( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE,_position )
						end

					end

                    self.touchID1    = nil
                    self.goodstag1   = nil
                end
            end
        end
        print( eventType,"END")
    end

end







--************************
--页面管理
--************************
--神器放入 卸下 
function CArtifactAdvanceView.packageGoodsCallback( self, _index )

	local index = _index
	if self.m_selectGoods_shenQi == index then 
		--卸下  清除信息
		self :disboardAritifact()
	else 
		--放入  加载信息
		local goodsInfo = self.m_allArtifactList[ index ].info
		if goodsInfo ~= nil then 
			self.m_selectGoods_partnerId = self.m_allArtifactList[ index ].idxType
			self.m_selectGoods_shenQi    = index
			self:requestStrenInfo( goodsInfo )
			--self :showAdvanceInfo( goodsInfo )
		else 
			print("出错啦 应该是index值不对")
		end
	end
	
end

--清除进阶信息
function CArtifactAdvanceView.disboardAritifact( self )

	self.m_selectGoods_partnerId = 1
	self.m_selectGoods_shenQi    = 0

	--清除放入的图标
	self:removeIconForButton(self.m_goodsNowBtn,CArtifactAdvanceView.TAG_AdvanceNow)
	self:removeIconForButton(self.m_goodsAdvanceBtn,CArtifactAdvanceView.TAG_AdvanceAft)
	self:removeIconForButton(self.m_shengShuiBtn,CArtifactAdvanceView.TAG_ShengShui)

	self.m_advanceBtn   : setTouchesEnabled( false )
	self.m_shengShuiBtn : setTouchesEnabled( false )

	self.m_useShengShuiLb :setString("")
	self.m_useGoldLb      :setString("")

	self.m_nowArtifactLb :setString("")
	self.m_advanceArtiLb :setString("")

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	-- if self.m_addInfoContainer ~= nil then 
	-- 	self.m_addInfoContainer :removeFromParentAndCleanup( true )
	-- 	self.m_addInfoContainer = nil
	-- end

	self :showNoticView()
end

--显示物品列表信息
function CArtifactAdvanceView.showGoodsView( self )

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : setVisible( false )
	end


	local winSize   = CCDirector:sharedDirector():getVisibleSize()
	local mainSize  = CCSizeMake( 854, winSize.height )
	local m_bgCell  = CCSizeMake(98,110)
    local viewSize  = CCSizeMake( 98*3, 110*5)
    local goodscount= 0

    self.m_goodsViewContainer = CContainer :create()
    self.m_goodsViewContainer : setControlName( "this is CArtifactAdvanceView self.m_goodsViewContainer 104" )
    self.m_goodsViewContainer : setPosition( ccp( 682-311/2, 0 ) )
    self.m_mainContainer : addChild( self.m_goodsViewContainer)
    
    local goodsList      = self.m_allArtifactList
    local curtaggoods    = #goodsList
    local goodsIdxSelect = self.m_selectGoods_shenQi
    local touchIndex 	 = 0

    local function local_buttonCallback( )
    	print(touchIndex)
		return self:packageGoodsCallback(touchIndex)
	end

    local function local_packageGoodsCallback(eventType, obj, touches)
		--物品格子 多点触控回调
		if eventType == "TouchesBegan" then
	        --删除Tips
	        _G.g_PopupView :reset()
	        local touchesCount = touches:count()
	        for i=1, touchesCount do
	            local touch = touches :at( i - 1 )
	            local touchPoint = touch :getLocation()
	            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
	                self.touchID     = touch :getID()
	                self.goodsIndex  = obj :getTag()
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
	            if touch2:getID() == self.touchID and self.goodsIndex == obj :getTag() then
	                local touch2Point = touch2 :getLocation()
	                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
	                    --弹出物品Tips             
	                    local winSize = CCDirector:sharedDirector():getVisibleSize()
	                    local _position = {}
	                    _position.x = touch2Point.x - (winSize.width-854)/2 - 20
	                    _position.y = touch2Point.y + 20
	                    local str --按钮的名称
						if tonumber(goodsIdxSelect) == tonumber(obj:getTag()) then 
							str = "卸下"
						else
							str = "放入"
						end

						touchIndex = obj:getTag()
						local good = self.m_allArtifactList[ obj:getTag() ].info

						if _G.g_CArtifactView ~= nil then
							_G.g_CArtifactView:showArtifactGoodsTips( good, _G.Constant.CONST_GOODS_SITE_ARTIFACT, str, local_buttonCallback, _position )
						end

						-- local  temp     = _G.g_PopupView :createByArtifact( good, _G.Constant.CONST_GOODS_SITE_ARTIFACT, str, local_buttonCallback, _position)
		    -- 			self.m_scenelayer :addChild( temp)   --_good, _str, _fun, _position)

	                    self.touchID    = nil
	                    self.goodsIndex = nil
	                end
	            end
	        end
	        print( eventType,"END")
	    end
	end

    local layout = CHorizontalLayout :create()
    layout :setPosition( 311/2 - viewSize.width/2, viewSize.height - 40)
    self.m_goodsViewContainer :addChild(layout)
    layout :setVerticalDirection(false)
    layout :setLineNodeSum( 3)
    layout :setCellSize(m_bgCell)

    self.m_goodsBtnList   = {}

    for i=1,15 do
    	if curtaggoods >= i then 
    		if goodsList[curtaggoods-i+1].listIdx == goodsIdxSelect then 
    			--当前物品为之前选中的物品
    			self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_click.png")
    		else
    			self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
    		end
    	else
    		self.m_goodsBtnList[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
    	end

		self.m_goodsBtnList[i] : setControlName("this CArtifactAdvanceView self.m_goodsBtnList[i] 179 ")
		layout : addChild( self.m_goodsBtnList[i] )

		if curtaggoods >= i then
			self.m_goodsBtnList[i] : setTag( goodsList[curtaggoods-i+1].listIdx )
			self.m_goodsBtnList[i] : setTouchesMode( kCCTouchesAllAtOnce )
        	self.m_goodsBtnList[i] : setTouchesEnabled( true)
			self.m_goodsBtnList[i] : registerControlScriptHandler( local_packageGoodsCallback, "this CArtifactAdvanceView self.m_goodsBtnList[i] 117 ")

			self :addIconForButton( self.m_goodsBtnList[i], goodsList[curtaggoods-i+1].info.goods_id, goodsList[curtaggoods-i+1].listIdx )

			local btnSize = self.m_goodsBtnList[i] :getContentSize()

			if goodsList[curtaggoods-i+1].idxType ~= 1 then
				-- local goodsNode = self:getGoodsNodeForXml( goodsId )
				local nameLabel = CCLabelTTF :create( "装备中", "Arial", 18)
				-- nameLabel : setColor( CArtifactAdvanceView.GOLD )
				nameLabel : setAnchorPoint( ccp(1,0) )
				nameLabel : setPosition( ccp( btnSize.width/2-7, -btnSize.height/2+5 ) )
				self.m_goodsBtnList[i] : addChild( nameLabel,200 )
			end

			local LVLabel = CCLabelTTF :create( "+"..goodsList[curtaggoods-i+1].info.strengthen, "Arial", 21)
			LVLabel : setColor( CArtifactAdvanceView.GOLD )
			LVLabel : setAnchorPoint( ccp(0,1) )
			LVLabel : setPosition( ccp( -btnSize.width/2+7, btnSize.height/2-5 ) )
			self.m_goodsBtnList[i] : addChild( LVLabel,200 )
		end
    end

end

function CArtifactAdvanceView.showNoticView( self )
	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : removeFromParentAndCleanup( true )
		self.m_addInfoContainer = nil
	end

	self.m_addInfoContainer = CContainer :create()
    self.m_addInfoContainer : setControlName( "this is CArtifactAdvanceView self.m_addInfoContainer 104" )
    self.m_mainContainer    : addChild( self.m_addInfoContainer)

    self.isTouchGoodsInfo = false

	local WFSM_Label = CCLabelTTF :create( "玩法说明 : ","Arial",24 )
	local SM_Label1  = CCLabelTTF :create( "1.点击左侧栏和材料栏可以打开对应背包,点击神器或材料可放入.","Arial",20 )
	local SM_Label2  = CCLabelTTF :create( "2.神器需要9级或以上才可以进行进阶,进阶后会降3级","Arial",20 )
	local SM_Label3  = CCLabelTTF :create( "3.神器进阶需要使用对应品质的圣水.","Arial",20 )
	local SM_Label4  = CCLabelTTF :create( "4.神器进阶100%成功.","Arial",20 )

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

function CArtifactAdvanceView.resetStrenInfo( self )

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

function CArtifactAdvanceView.requestStrenInfo( self, _goodsInfo )
	require "common/protocol/auto/REQ_MAGIC_EQUIP_ASK_NEXT_ATTR"

	-- local goodsNode 	  = self :getGoodsNodeForXml( _goodsInfo.goods_id )
	local equipMakeNode   = self :getEupipMakeNodeForXml( _goodsInfo.goods_id )
	local advanceNode     = self :getGoodsNodeForXml( equipMakeNode:children():get(0,"make1"):getAttribute("goods") )  --进阶xml节点数据

	local goodsLv = tonumber(_goodsInfo.strengthen) - _G.Constant.CONST_MAGIC_EQUIP_LV_DOWN - 1

	local msg = REQ_MAGIC_EQUIP_ASK_NEXT_ATTR()
	msg : setTypeSub( tonumber( advanceNode:getAttribute("type_sub") ) )
	msg : setLv( goodsLv )
	msg : setColor( tonumber( advanceNode:getAttribute("name_color") ) )
	msg : setClass( tonumber( advanceNode:getAttribute("class") ) )
	CNetwork :send(msg)

	-- self.m_isPutArtifact = true
	self.m_nowGoodsInfo  = _goodsInfo

	print(" requestStrenInfo-->     setTypeSub->"..advanceNode:getAttribute("type_sub").."     setLv->"..goodsLv)
	print(" requestStrenInfo-->     setColor->"..advanceNode:getAttribute("name_color").."     setClass->"..advanceNode:getAttribute("class"))

end


--显示物品强化信息 消耗的美刀 进阶前后的加成 
function CArtifactAdvanceView.showAdvanceInfo( self, _ackMsg )

	local _goodsInfo = self.m_nowGoodsInfo

	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer : removeFromParentAndCleanup( true )
		self.m_addInfoContainer = nil
	end

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	print("  ---showAdvanceInfo---  11")

	local winSize  = CCDirector:sharedDirector():getVisibleSize()
	local mainSize = CCSizeMake( 854,winSize.height )

	self.m_addInfoContainer = CContainer :create()
    self.m_addInfoContainer : setControlName( "this is CArtifactAdvanceView self.m_addInfoContainer 104" )
    self.m_mainContainer    : addChild( self.m_addInfoContainer)

    self.isTouchGoodsInfo = true

    local goodsNode 	  = self :getGoodsNodeForXml( _goodsInfo.goods_id )
    local equipMakeNode   = self :getEupipMakeNodeForXml( _goodsInfo.goods_id )
	local advanceNode     = self :getGoodsNodeForXml( equipMakeNode:children():get(0,"make1"):getAttribute("goods") )  --进阶xml节点数据

    local colorName1,color1 = self :getNameAndColorByColorId( tonumber(goodsNode:getAttribute("name_color")) )
    local colorName2,color2 = self :getNameAndColorByColorId( tonumber(advanceNode:getAttribute("name_color")) )

    local lineBg1         = CSprite :createWithSpriteFrameName( "artifact_strengthen_underframe.png"  )--CCRectMake( 140,0,2,53)
    local lineBg2         = CSprite :createWithSpriteFrameName( "artifact_strengthen_underframe.png" )
    local goNowTitleImg   = CSprite :createWithSpriteFrameName( "artifact_word_jjq.png" )
    local goAfterTitleImg = CSprite :createWithSpriteFrameName( "artifact_word_jjh.png" )
    local goNowNameLb     = CCLabelTTF:create( goodsNode:getAttribute("name"), "Arial", 20 )
    local goAfterNameLb   = CCLabelTTF:create( advanceNode:getAttribute("name"), "Arial", 20 )
    local goNowColorLb    = CCLabelTTF:create( colorName1.."装 "..tostring(_goodsInfo.strengthen).." 级", "Arial", 20 )
    local goAfterColorLb  = CCLabelTTF:create( colorName2.."装 "..tostring(_goodsInfo.strengthen-_G.Constant.CONST_MAGIC_EQUIP_LV_DOWN).." 级", "Arial", 20 )

    goNowNameLb    : setColor( color1 )
    goAfterNameLb  : setColor( color2 )
    goNowColorLb   : setColor( color1 )
    goAfterColorLb : setColor( color2 )
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

	goNowNameLb     : setPosition( ccp( 675, mainSize.height*0.76 ) )
	goNowColorLb    : setPosition( ccp( 695, mainSize.height*0.76 ) )
	goAfterNameLb   : setPosition( ccp( 675, mainSize.height*0.323 ) )
	goAfterColorLb  : setPosition( ccp( 695, mainSize.height*0.323 ) )

	self.m_addInfoContainer : addChild( lineBg1 )
	self.m_addInfoContainer : addChild( lineBg2 )
	self.m_addInfoContainer : addChild( goNowTitleImg )
	self.m_addInfoContainer : addChild( goAfterTitleImg )
	self.m_addInfoContainer : addChild( goNowNameLb )
	self.m_addInfoContainer : addChild( goAfterNameLb )
	self.m_addInfoContainer : addChild( goNowColorLb )
	self.m_addInfoContainer : addChild( goAfterColorLb )

	self.m_nowArtifactLb :setString("+"..tostring(_goodsInfo.strengthen).." "..goodsNode:getAttribute("name"))
	self.m_advanceArtiLb :setString("+"..tostring(_goodsInfo.strengthen-_G.Constant.CONST_MAGIC_EQUIP_LV_DOWN).." "..advanceNode:getAttribute("name"))
	self.m_nowArtifactLb :setColor(color1)
	self.m_advanceArtiLb :setColor(color2)

	local attrInfo = {}
	print("  ---showAdvanceInfo---  22")
	--进阶前属性 根据物品现有的属性
	if _goodsInfo.attr_count > 0 then 
		local iCount = 1
		print(_goodsInfo.attr_count,#_goodsInfo.attr_data)

		local attrList = _goodsInfo.attr_data
		local function sortfunc1( attr1, attr2)

	        if attr1.attr_base_type < attr2.attr_base_type then
	            return true
	        end
	        return false
	    end
	    table.sort( attrList, sortfunc1)

		for i,v in ipairs(attrList) do
			local name  = CLanguageManager:sharedLanguageManager():getString(tostring("goodss_goods_base_types_base_type_type"..v.attr_base_type))
			local value = v.attr_base_value
			local addNameLabel = CCLabelTTF :create( name, "Arial", CArtifactAdvanceView.FONT_SIZE_LABEL)
			local addValueLabel= CCLabelTTF :create( "+"..tostring(value), "Arial", CArtifactAdvanceView.FONT_SIZE_LABEL)
			print("  ---showAdvanceInfo---  33")
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

	--保存圣水的信息
	self.m_shengShuiInfo = {}
	self.m_shengShuiInfo.goodsId  = tonumber(equipMakeNode:children():get(0,"make1"):getAttribute("item1"))   --圣水Id
	self.m_shengShuiInfo.useCount = tonumber(equipMakeNode:children():get(0,"make1"):getAttribute("count1"))  --进阶使用的圣水数量
	self.m_shengShuiInfo.goldType = tonumber(equipMakeNode:children():get(0,"make1"):getAttribute("ct"))      --进阶消耗的金额类型
	self.m_shengShuiInfo.price    = tonumber(equipMakeNode:children():get(0,"make1"):getAttribute("cv"))      --进阶消耗的金额数
	self.m_shengShuiInfo.haveNum  = self :getCaiLiaoGoodsNum( self.m_shengShuiInfo.goodsId ) --现有的圣水数量
	if self.m_shengShuiInfo.goldType == _G.Constant.CONST_CURRENCY_GOLD then 
		self.m_shengShuiInfo.goldName = "美刀"
	else
		self.m_shengShuiInfo.goldName = "钻石"
	end

	local advanceLv   = _goodsInfo.strengthen - _G.Constant.CONST_MAGIC_EQUIP_LV_DOWN --进阶降级后的等级
	-- local strengthenId= tostring( advanceLv ) .. "_" .. tostring(advanceNode.name_color) .. "_" .. tostring(advanceNode.type_sub) .. "_" .. tostring(advanceNode.class) --查找进阶xml节点的Id
	local advanceAttr = {} --进阶后属性列表
	local icount = 1

	local base_typeList  = advanceNode:children():get(0,"base_types"):children()
	local base_typeCount = base_typeList:getCount("base_type")
	for i=0,base_typeCount-1 do
		local addValue  = 0
		local base_type = base_typeList:get(i,"base_type")

		for j,k in ipairs(_ackMsg:getMsgXxx1()) do
			if tonumber(base_type:getAttribute("type")) == tonumber(k.type) then
				addValue = k.type_value
				break
			end
		end

		advanceAttr[icount] 	  = {}
		advanceAttr[icount].type  = tonumber(base_type:getAttribute("type")) --属性类型
		advanceAttr[icount].value = tonumber(base_type:getAttribute("v")) + addValue --初始值加上强化的值
		icount = icount + 1
	end

	local function sortfunc2( attr1, attr2)

        if attr1.type < attr2.type then
            return true
        end
        return false
    end
    table.sort( advanceAttr, sortfunc2)

	--显示进阶后的属性加成
	for i,v in ipairs(advanceAttr) do
		local name  = CLanguageManager:sharedLanguageManager():getString(tostring("goodss_goods_base_types_base_type_type"..v.type))
		local addNameLabel  = CCLabelTTF :create( name , "Arial", CArtifactAdvanceView.FONT_SIZE_LABEL)
		local addValueLabel = CCLabelTTF :create( "+"..tostring(v.value), "Arial", CArtifactAdvanceView.FONT_SIZE_LABEL)
		local addImg  		= CSprite    :createWithSpriteFrameName( "artifact_equip_up.png" )

		local valueLbSize   = addValueLabel :getContentSize()

		addNameLabel  : setAnchorPoint( ccp( 1, 0.5 ) )
		addValueLabel : setAnchorPoint( ccp( 0, 0.5 ) )
		addValueLabel : setColor( CArtifactAdvanceView.GREEN )
		addNameLabel  : setPosition( ccp( 675, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		addValueLabel : setPosition( ccp( 695, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		addImg 		  : setPosition( ccp( 695 + valueLbSize.width + 18, mainSize.height*0.28 - mainSize.height*0.05*(i-1) ) )
		self.m_addInfoContainer : addChild( addNameLabel )
		self.m_addInfoContainer : addChild( addValueLabel )
		self.m_addInfoContainer : addChild( addImg )

	end

	--添加进阶前图标
	self :addIconForButton( self.m_goodsNowBtn, _goodsInfo.goods_id, CArtifactAdvanceView.TAG_AdvanceNow )
	--添加进阶后图标
	self :addIconForButton( self.m_goodsAdvanceBtn, equipMakeNode:children():get(0,"make1"):getAttribute("goods"), CArtifactAdvanceView.TAG_AdvanceAft )
	--添加圣水图标
	self :addIconForButton( self.m_shengShuiBtn, self.m_shengShuiInfo.goodsId, CArtifactAdvanceView.TAG_ShengShui )

	--设置圣水现有数以及消耗数
	self.m_useShengShuiLb : setString( self.m_shengShuiInfo.haveNum.."/"..self.m_shengShuiInfo.useCount )

	--圣水数够的话 进阶按钮可按
	if self.m_shengShuiInfo.useCount <= self.m_shengShuiInfo.haveNum then 
		self.m_advanceBtn   :setTouchesEnabled( true )
	end
	--圣水按钮可按 查看圣水信息
	self.m_shengShuiBtn : setTouchesEnabled( true )
	--设置消耗金额
	self.m_useGoldLb :setString("需要"..self.m_shengShuiInfo.goldName.." : "..self.m_shengShuiInfo.price)

	self.m_artifactRealIdx = self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx

end

function CArtifactAdvanceView.getNameAndColorByColorId( self, _color )

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


--清除物品列表 显示进阶加成信息
function CArtifactAdvanceView.removeGoodsView( self )

	if self.m_goodsViewContainer ~= nil then 
		self.m_goodsViewContainer : removeFromParentAndCleanup( true )
		self.m_goodsViewContainer = nil
	end

	if self.m_addInfoContainer ~= nil then 
		self.m_addInfoContainer :setVisible( true )
	end

end


--添加Icon到button中
function CArtifactAdvanceView.addIconForButton( self, _btn, _goodsId, _tag )

	self : removeIconForButton( _btn, _tag)

	local iconId = self:getGoodsNodeForXml(_goodsId):getAttribute("icon") 

	local icon = CIcon : create("Icon/i"..tostring( iconId )..".jpg")
	_btn : addChild( icon  , 0 , _tag ) 

	_G.g_CArtifactView:setCreateResStr( "Icon/i"..tostring( iconId )..".jpg" )

end

--去除button中的ICon
function CArtifactAdvanceView.removeIconForButton( self, _btn, _tag )
	if _btn :getChildByTag( _tag ) ~= nil then 
		_btn :removeChildByTag( _tag, true )
	end
end


--根据物品ID 属性类型 查找相应的属性值
function CArtifactAdvanceView.getAttrValue( self, _id, _base_type ) 	
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



--************************
--发送协议
--************************
--请求进阶
function CArtifactAdvanceView.sendAdvanceMessage( self )

	local type_c --	1背包 ，2武将
	if self.m_selectGoods_partnerId == 1 then 
		type_c = 1
	else
		type_c = 2
	end

	require "common/protocol/auto/REQ_MAGIC_EQUIP_ADVANCE"
	local msg = REQ_MAGIC_EQUIP_ADVANCE()
	msg :setType( type_c )
	msg :setId( self.m_allArtifactList[ self.m_selectGoods_shenQi ].idxType ) 
	msg :setIdx( self.m_allArtifactList[ self.m_selectGoods_shenQi ].realIdx )
	msg :setHolyWaterId( self.m_shengShuiInfo.goodsId )
	CNetwork : send( msg )

end


--************************
--mediator控制的方法
--************************
--进阶返回 返回
function CArtifactAdvanceView.advanceCallBackForMadiator( self )
	--清除进阶数据
	self : addEffactCCBI()
	-- self :disboardAritifact()
end

function CArtifactAdvanceView.addEffactCCBI(self)
    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.m_goodsAdvanceBtn   : removeChild(self.THEccbi,false)
            self.THEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
            if self.THEccbi ~= nil then
                if self.THEccbi  : retainCount() >= 1 then
                    self.m_goodsAdvanceBtn   : removeChild(self.THEccbi,false)
                    self.THEccbi = nil 
                end
            end
            self :disboardAritifact()
        end
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    self.m_goodsAdvanceBtn  : addChild(self.THEccbi,1000)
end



