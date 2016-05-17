--remotestoreview 主界面
require "view/view"
require "mediator/mediator"
require "controller/command"

CRemoteStoreView = class(view, function( self)
end)

--远程商店最大数量
CRemoteStoreView.MAX_GOODS_NUM = 9

--加载资源
function CRemoteStoreView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist") 
end

--释放资源
function CRemoteStoreView.onLoadResource( self)
    
end

--释放成员
function CRemoteStoreView.realeaseParams( self)
    self.m_goods = {}
    if self.m_layer ~= nil then
        self.m_layer: removeFromParentAndCleanup()
        self.m_layer = nil
    end
    --self.m_sellnumber = 0
end

--布局成员
function CRemoteStoreView.layout( self, winSize)
    local sellbatchview = self.m_layer: getChildByTag(903)
    sellbatchview: setPosition(ccp(winSize.width-300,winSize.height/2-230))
    
    local bgImg = sellbatchview: getChildByTag(900)
    bgImg: setPosition( ccp( 140,220))
    
    local sellButton = sellbatchview: getChildByTag(902)
    sellButton: setPosition(ccp( 140, -10))

end


--初始化成员
function CRemoteStoreView.initview( self, layer)
    

        
end

--初始化批量容器
function CRemoteStoreView.initScrollView(self, layer)
    
    local sellbatchview = CContainer :create()
    sellbatchview : setControlName( "this is CRemoteStoreView sellbatchview 57" )
    
    local bgImg = CSprite :createWithSpriteFrameName("iconinfo.png")
    bgImg : setControlName( "this CRemoteStoreView bgImg 60 ")
    bgImg: setPreferredSize(ccp(350,560))
    sellbatchview: addChild(bgImg,0,900)
    
    local function sellButtonCallBack(eventType, obj, x, y)
        if eventType == "TouchBegan" then
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        elseif eventType == "TouchEnded" then
            
            CCLOG("Clicked SellButton!")
            print(obj: getTag())
            --print("++",self.m_sellnumber, self.m_goods)
            --print("11",i)
            if self:getSellNumber() > 0 then
                --弹出提示框，是否出售总价XXX的物品
                --add:
                print("AllPrice:",self: getSellAllPrice())
                self:sellAllGoods()
            end
        end
    end
    local sellButton = CButton: createWithSpriteFrameName("出售","iconfourlable.png")
    sellButton : setControlName( "this CRemoteStoreView sellButton 81 ")
    sellButton: setFontSize(30)
    sellButton: registerControlScriptHandler( sellButtonCallBack, "this CRemoteStoreView sellButton 84")
    --sellButton.view = self
    sellbatchview: addChild(sellButton,1,902)
    
    
    
    local m_bgCell  = CCSizeMake(96,96)
    local equipCell = CCSizeMake(88,88)
    local viewSize  = CCSizeMake(290,450)
    
    local ScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)    
    sellbatchview: addChild(ScrollView)
    
    self.m_goodBtn = {}
    for k =1 ,1 do
        local pagecontainer = CContainer :create()
        pagecontainer : setControlName( "this is CRemoteStoreView pagecontainer 98")
        ScrollView :addPage( pagecontainer)

        local layout = CHorizontalLayout :create()
        layout :setPosition(-142+(k-1)*280,175)
        layout :setVerticalDirection(false)
        layout: setCellHorizontalSpace(10)
        layout: setCellVerticalSpace(60)
        pagecontainer :addChild(layout)
        layout :setLineNodeSum(3)
        layout :setCellSize(equipCell)
        layout :setHorizontalDirection(true)
        
        local smallPoint = CButton :createWithSpriteFrameName("","iconstateblack.png")
        smallPoint : setControlName( "this CRemoteStoreView smallPoint 113 ")
        smallPoint.view = self
        smallPoint :registerControlScriptHandler(self.clickedSmollpointCallBack, "this CRemoteStoreView smallPoint 116")
        smallPoint :setPosition(85+(k-1)*35,470)
        sellbatchview: addChild(smallPoint,1,k)
        
        self.m_goodBtn[k] = {}
        for i =1 ,9 do
            self.m_goodBtn[k][i] = CButton :createWithSpriteFrameName("","iconframe.png")
            self.m_goodBtn[k][i] : setControlName( "this CRemoteStoreView self.m_goodBtn[k][i] 122 "..tostring(k).."  "..tostring(i))
            local goldIcon = CCScale9Sprite :createWithSpriteFrameName("iconmoney.png")
            goldIcon :setAnchorPoint(ccp(0,0))            
            goldIcon :setPosition(self.m_goodBtn[k][i]: getContentSize().width/2+goldIcon: getContentSize().width/2-100,self.m_goodBtn[k][i]: getContentSize().height/2+goldIcon: getContentSize().height/2-140)
            self.m_goodBtn[k][i]: addChild(goldIcon,1)
            
            local price = CCLabelTTF: create("","Arial",15)
            price: setPosition(self.m_goodBtn[k][i]: getContentSize().width/2+price: getContentSize().width/2-50,self.m_goodBtn[k][i]: getContentSize().height/2+price: getContentSize().height/2-115)
            self.m_goodBtn[k][i]: addChild(price, 1)
            self.m_goodBtn[k][i].price = price
                                                                                                    
            --装备背景图片
            local m_bg = CCScale9Sprite :createWithSpriteFrameName("iconrim.png")
            m_bg :setPreferredSize(m_bgCell)
            m_bg :setAnchorPoint(ccp(0,0))
           --m_bg :setPosition(ccp(0,0))
            m_bg :setPosition( 0-m_bg: getContentSize().width/2,0-m_bg: getContentSize().height/2)
            self.m_goodBtn[k][i] :addChild(m_bg, 0)

            self.m_goodBtn[k][i] :setPreferredSize(equipCell)
            local function clickedCellCallBack(eventType, obj, x, y)
                if eventType == "TouchBegan" then
                    return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
                elseif eventType == "TouchEnded" then
                    print("Clicked CellImg!")
                    print(obj: getTag(),obj.good)
                    print("self.m_sellnumber",self :getSellNumber())
                    if obj.good == nil then
                        print("NO_GOOG")
                        return
                    end
                    self.subGoodToSell(self, obj.good)
                end
            end
            self.m_goodBtn[k][i] :registerControlScriptHandler(clickedCellCallBack, "this CRemoteStoreView self.m_goodBtn[k][i] 157")
            layout :addChild(self.m_goodBtn[k][i],1,i)
        end
    end
    ScrollView :setPage( 0,false)
    
    layer :addChild( sellbatchview,1,903)
    
end

--主界面初始化
function CRemoteStoreView.init(self, winSize, layer)
       
    CRemoteStoreView.loadResource(self)
    
    self.m_goods = {}
    --self.m_sellnumber = 0
    
    self.initview(self, layer)
    
    self.initScrollView(self, layer)

    self.layout(self, winSize)
        
end
function CRemoteStoreView.getSellAllPrice( self)
    local i = 1
    local allprice = 0
    while i <= table.maxn(self.m_goods) do
        if self.m_goods[i] ~= nil then
            print("-----",i,"price:",self.m_goods[i].price)
            allprice = allprice + self.m_goods[i].price
        end
        i = i + 1
    end
    print("allprice:",allprice)
    return allprice
end
    
function CRemoteStoreView.getSellNumber( self)
    local i = 0
    local sellnumber = 0
    while i < table.maxn(self.m_goods) do
        sellnumber = sellnumber + 1
        i = i + 1
    end
    print("sellnumber:",sellnumber)
    return sellnumber
end

--增加待售物品
function CRemoteStoreView.addGoodToSell(self, good)
    print("CRemoteStoreView.addGoodToSell")
    if self.getSellNumber( self) == CRemoteStoreView.MAX_GOODS_NUM then
        --提示达到最大出售数量
        --add:
        print("达到最大出售数量",CRemoteStoreView.MAX_GOODS_NUM)
        return
    end
    if self.isContain(self, good) == ture then
        --add:
        print("已存在出售列表中")
        return
    end
    
    --self.m_sellnumber = self.m_sellnumber + 1
    --print("self.m_sellnumber:",self.m_sellnumber)    
    table.insert(self.m_goods,good)
    print("sellnumber:",self:getSellNumber())
    self.showSellGood(self, self.m_goods)
end


--减少待售物品
function CRemoteStoreView.subGoodToSell(self, good)
    print("CRemoteStoreView.subGoodToSell")
    if good == nil then
        --没有选中物品
        print("NO GOOD")
        return
    end
    local i = 1
    print( table.maxn(self.m_goods))
    while i <= table.maxn(self.m_goods) do
        print(i)
        if self.m_goods[i] ~= nil then            
            if self.compareTwoGood(self, self.m_goods[i],good) then
                table.remove(self.m_goods, i)
                --self.m_sellnumber = self.m_sellnumber - 1
                --print("self.m_sellnumber:",self.m_sellnumber)
                else
                i = i + 1
                end
            end
        end
    self.showSellGood(self, self.m_goods)
end

--批量出售中是否有good
function CRemoteStoreView.isContain(self, good)
    print("CRemoteStoreView.isContain")
    if good == nil then
        return
    end
    local i = 1
    while table.maxn(self.m_goods) do
        if self.m_goods[i] == nil then
            return false
        end
        if self.compareTwoGood(self, self.m_goods[i],good) then
            return ture
            else
            i = i + 1
        end
    end
    return false
end

--比较good1和good2
function CRemoteStoreView.compareTwoGood(self, good1, good2)
    print("CRemoteStoreView.compareTwoGood")
    print(good1.goods_type,good2.goods_type)
    print(good1.index,good2.index)
    if good1.goods_type == good2.goods_type and good1.index == good2.index then
        return true
    end
    --[[
    if good1.goods_type == 1 then
        if good2.goods_type == 1 then
            if good1.goods_type == good2.goods_type and good1.index == good2.index then
                return true
            end
        end
    else
        if good2.goods_type ~= 1 then
            --非装备比较
            if good1.param2.goodsType == good2.param2.goodsType and good1.param2.index == good2.param2.index then
                return true
            end
        end
    end
     ]]
    return false    
end

--设置容器大小
function CRemoteStoreView.setContainerSize(self, counts)
    
end

--显示批量出售中的物品
function CRemoteStoreView.showSellGood(self, goods)
    print("CRemoteStoreView.showSellGood")
    --批量出售窗口中物品信息初始化
    --add:
        for i=1,1 do
            for j=1,9 do
                self.m_goodBtn[i][j]: setText("")
                self.m_goodBtn[i][j].price :setString("")
                self.m_goodBtn[i][j].good = nil
                if self.m_goodBtn[i][j].icon ~= nil then
                    self.m_goodBtn[i][j].icon :removeAllChildrenWithCleanup()
                end
                
            end
        end
        --更新背包容器中显示的物品
        --根据good显示相应信息
        local _good_num = 0
        for k,v in pairs(goods) do
            _good_num = _good_num + 1
            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
            print("第：",_good_num,"goods")            
            local j = math.mod(_good_num-1,9)+1
            local i = (_good_num-j)/9+1
            local goodnode = _G.g_GameDataProxy :getGoodById( v.goods_id)
            
            --self.m_goodBtn[i][k]: initWithSpriteFrameName(tostring(v.goods_id),"forBth.png")
            --self.m_goodBtn[i][j].icon = CSprite: createWithSpriteFrameName("iconsprite.png")
            self.m_goodBtn[i][j].icon  = CSprite: create( "Icon/i"..goodnode : getAttribute("icon")..".jpg")
            self.m_goodBtn[i][j].icon : setControlName( "this CRemoteStoreView self.m_goodBtn[i][j].icon 337 "..tostring(i).." "..tostring(j))
            --self.m_goodBtn[i][j].icon :setScale( 1.2)
            self.m_goodBtn[i][j]: addChild(self.m_goodBtn[i][j].icon,1)
            self.m_goodBtn[i][j]: setFontSize(20)
            self.m_goodBtn[i][j]: setText( tostring( v.goods_id))
            self.m_goodBtn[i][j].price :setString( tostring( v.price))
            self.m_goodBtn[i][j].good = v

    end    
    return
    --self.setContainerSize(self, self.m_sellnumber)
    
    
end


--出售成功刷新界面
function CRemoteStoreView.removeGoodsByIndex(self, index)
    print("CRemoteStoreView.removeGoodsByIndex")
    local i = 1
    print( table.maxn(self.m_goods), index)
    while i <= table.maxn(self.m_goods) do
        --print(i)
        if self.m_goods[i] ~= nil then
            --判断条件不全
            --add：
            if self.m_goods[i].index == index then
                table.remove(self.m_goods, i)
                --self.m_sellnumber = self.m_sellnumber - 1
                --print("self.m_sellnumber:",self.m_sellnumber)
                else
                i = i + 1
            end
        end
    end
    self.showSellGood(self, self.m_goods)
end

--卖掉所有goods
function CRemoteStoreView.sellAllGoods(self)
    if self:getSellNumber() <= 0 then
        --提示没有东西出售
        --add:
        print("没有东西出售",self:getSellNumber())
    else    --self.m_sellnumber = 1
        
        
        local sellNum = table.maxn(self.m_goods)
        local i = 1
        while i <= sellNum do
            local idx = self.m_goods[i].index 
            local num = self.m_goods[i].goods_num
            --table.remove(self.m_goods, i)
            i = i + 1
            --请求卖掉good
            print("idx:",idx,"num:",num)
            --P_GOODS_SELL_OK 出售成功 无参
            --add:        
            require "common/protocol/auto/REQ_GOODS_SELL"
            local msg = REQ_GOODS_SELL()
            msg :setArguments( idx, num)
            CNetwork :send( msg)
            --end
            --self :removeGoodsByIndex( idx)
        end      
        
        print("++++")
        self.m_goods = {}
        print( "xxxxxxxxxxxxxxself.m_goods",self.m_goods)
        self.showSellGood(self, self.m_goods)        
        
    end

end

--/Users/mac/Desktop/GameBox0704/GameBox/Resources/common/protocol/auto/REQ_GOODS_SELL.lua
function CRemoteStoreView.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.m_layer = CContainer :create()
    self.m_layer : setControlName( "this is CRemoteStoreView self.m_layer 411")
    self.m_layer :setPosition(winSize.width/2,winSize.height/2)
    self: init(winSize, self.m_layer)
    return self.m_layer
end

function CRemoteStoreView.scene(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
  
    local scene = CCScene :create()
    
    scene :addChild( self: layer(self))
    return scene
end























