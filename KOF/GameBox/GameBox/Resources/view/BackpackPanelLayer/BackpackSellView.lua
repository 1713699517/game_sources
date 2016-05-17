--[[
 --CBackpackSellView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "mediator/CharacterMediator"
require "controller/CharacterUpadteCommand"

require "view/CharacterPanelLayer/CharacterBackpackView"

CBackpackSellView = class(view, function( self)
    print("CBackpackSellView:角色信息主界面")
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_characterPageContainer= nil   --4个标签容器公用
    self.m_characterSellViewContainer  = nil  --人物面板的容器层
    self.m_partnerId             = 0     --主角属性

    self.CreateEffectsList = {} -- 存放创建ccbi的数据
end)
--Constant:
CBackpackSellView.TAG_SELL         = 201
CBackpackSellView.TAG_CLOSED       = 202

CBackpackSellView.FONT_SIZE        = 25
CBackpackSellView.SELL_GOOGS_MAX   = 12
CBackpackSellView.TAB_BUTTON_SIZE  = CCSizeMake( 130, 60)

--加载资源
function CBackpackSellView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    
end
--释放资源
function CBackpackSellView.unloadResource( self)
    
end
--初始化数据成员
function CBackpackSellView.initParams( self, layer)
    print("CBackpackSellView.initParams")
    self.m_uid       = _G.g_LoginInfoProxy :getUid()
    self.m_partnerId = 0

    self.m_mymediator  = CCharacterSellMediator( self)
    controller :registerMediator( self.m_mymediator)--先注册后发送 否则会报错

end
--释放成员
function CBackpackSellView.realeaseParams( self)
    if self.m_characterPageContainer ~= nil then
        self.m_characterPageContainer :removeAllChildrenWithCleanup( true)
    end
end

--布局成员
function CBackpackSellView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面5")
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

function CBackpackSellView.sellGoodsLayout( self)
    --640
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        print("640--角色信息主界面5")
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local buttonSize                       = self.m_sellButton :getPreferredSize()
        local sellbackgroundSize               = CCSizeMake( backgroundSize.width*0.36, winSize.height*0.87)
        local sellbackground                   = self.m_sellViewContainer :getChildByTag( 100)

        sellbackground :setPreferredSize( sellbackgroundSize)

        self.m_sellButton :setTouchesPriority( -1000)

        sellbackground :setPosition( ccp( winSize.width/2, winSize.height*0.87/2+15))
        self.m_layout :setPosition( winSize.width/2-sellbackgroundSize.width/2+5, winSize.height*0.7+25)
        self.m_priceContainer :setPosition( ccp( winSize.width/2-sellbackgroundSize.width/2+ buttonSize.width+60, winSize.height*0.09+15))
        self.m_sellButton :setPosition( ccp( winSize.width/2+ buttonSize.width+60, winSize.height*0.09+15))
        self.m_sellViewContainer :setPosition( ccp( backgroundSize.width/2-sellbackgroundSize.width/2-15, 0))    
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

--主界面初始化
function CBackpackSellView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CBackpackSellView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackSellView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBackpackSellView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackSellView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CBackpackSellView.initView(self, layer)
    print("CBackpackSellView.initView")
    --副本界面容器
    self.m_characterSellViewContainer = CContainer :create()
    self.m_characterSellViewContainer : setControlName("this is CBackpackSellView self.m_characterSellViewContainer 94 ")
    layer :addChild( self.m_characterSellViewContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    self.m_sellButton       = self :createButton( "出售", "general_button_normal.png", CallBack, CBackpackSellView.TAG_SELL, "self.m_sellButton")    --出售按钮 伙伴
    self.m_characterSellViewContainer :addChild( self.m_sellButton,2)    
    --出售界面出售容器部分
    self.m_sellViewContainer = CContainer :create()
    self.m_sellViewContainer :setControlName( "this is CBackpackSellView self.m_sellViewContainer 134")
    self.m_characterSellViewContainer :addChild( self.m_sellViewContainer)
    self :addSellGoods()

end

function CBackpackSellView.addSellGoods( self)
    if self.m_sellViewContainer ~= nil then
        self : removeAllCCBI()
        self.m_sellViewContainer :removeAllChildrenWithCleanup( true)
    end
    --背景图片
    local sellbackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")     --背景Img
    sellbackground : setControlName( "this CBackpackSellView sellbackground 124 ")
    self.m_sellViewContainer :addChild( sellbackground, -1, 100)
    --出售按钮
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --self.m_sellButton       = self :createButton( "出售", "general_button_normal.png", CallBack, CBackpackSellView.TAG_SELL, "self.m_sellButton")    --出售按钮 伙伴
    --self.m_sellViewContainer :addChild( self.m_sellButton)
    --出售总价格
    local price = _G.g_CBackpackPanelView :getAllPrice()
    self.m_priceContainer   = self :createPrice( 2, price)
    self.m_sellViewContainer :addChild( self.m_priceContainer)
    --添加物品
    self.m_layout = CHorizontalLayout :create()
    self.m_sellViewContainer :addChild(self.m_layout)
    self.m_layout :setVerticalDirection(false)
    self.m_layout :setCellVerticalSpace( -2)
    self.m_layout :setLineNodeSum( 3)
    --self.m_layout :setCellSize(m_bgCell)

    for i=1,CBackpackSellView.SELL_GOOGS_MAX do
        local temp = _G.g_CBackpackPanelView :getSellList()
        local num = #temp
        local goodcontainer = nil
        if i <= num then
            goodcontainer = self :createGoodsItem( temp[i].good, temp[i].count)
        else
            goodcontainer = self :createGoodsItem()
        end        
        self.m_layout :addChild( goodcontainer)        
    end

    self :sellGoodsLayout()
end

--创建金钱图标和数量
function CBackpackSellView.createPrice( self, _type, _string)
    --根据_type创建图标
    local _imagename = nil
    if _type == 1 then    --钻石
        _imagename = "menu_icon_dollar.png"
    elseif _type == 2 then--美刀
        _imagename = "menu_icon_dollar.png"
    elseif _type == 3 then--斗魂
        _imagename = "menu_icon_dollar.png"
    end
    local _container       = self :createContainer( "createPrice _container")
    local _itempricesprite = self :createSprite( _imagename, "createSprite _itempricesprite")
    _container :addChild( _itempricesprite)
    local _itempriceslabel = CCLabelTTF :create( _string, "Arial", CCharacterInfoView.FONT_SIZE)
    _itempriceslabel :setColor( ccc3( 226,215,118))
    _itempriceslabel :setAnchorPoint( ccp( 0, 0.5))
    _itempriceslabel :setPosition( ccp( 30, 0))
    _container :addChild( _itempriceslabel)
    return _container
end

function CBackpackSellView.createGoodsItem( self, _good, _count)
    print("CGoodsInfoView.createGoodsItem")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickGoodsCallBack( eventType, obj, x, y)
    end
    if _good == nil then
        _goodname = "没有物品"
    end
    local goodcontainer      = self :createContainer( "createGoodsItem goodcontainer:".._goodname)
    local background         = self :createSprite( "general_props_underframe.png", "createGoodsItem background 160")
    local backgroundframe    = self :createSprite( "general_props_frame_normal.png", "createGoodsItem backgroundframe 160")    
    goodcontainer :addChild( background)
    if _good ~= nil then
        local goodbutton = nil
        local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        print( "CCCCC:", _good.index,_good.goods_id,goodnode : getAttribute("icon"))
        goodbutton = self :createGoodsButton( "", "Icon/i"..goodnode : getAttribute("icon")..".jpg", CallBack, _good.index, "createGoodsItem goodbutton :".._good.index)

        --特效添加
        local theType = tonumber(goodnode : getAttribute("type"))
        if theType == 1 or theType == 2 then
            self : Create_effects_equip(backgroundframe,goodnode : getAttribute("name_color"),goodnode : getAttribute("id"),_good.index)
        end

        --goodbutton :setScale( 1.3)    
            --数量标签
        local _itemprice = CCLabelTTF :create( _count,"Arial",15)
        _itemprice :setPosition( goodbutton: getContentSize().width/2-20, -goodbutton :getContentSize().height/2+15)        
        goodcontainer :addChild( goodbutton)
        goodbutton :addChild( _itemprice, 1)  
    end    
    goodcontainer :addChild( backgroundframe)
    return goodcontainer
end



--创建TabPage
function CBackpackSellView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CBackpackSellView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CBackpackSellView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end

--创建按钮GoodsButton  散图
function CBackpackSellView.createGoodsButton( self, _string, _image, _func, _tag, _controlname)
    print( "CBackpackSellView.createGoodsButton buttonname:".._string.._controlname)
    local m_button = CButton :create( _string, _image)
    m_button :setControlName( "this CBackpackSellView createGoodsButton:".._controlname)
    m_button :setFontSize( CBackpackSellView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CBackpackSellView ".._controlname.."CallBack")
    return m_button
end

--创建按钮Button   plist 合图
function CBackpackSellView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CBackpackSellView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CBackpackSellView createButton:".._controlname)
    m_button :setFontSize( CBackpackSellView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :setTouchesPriority( -100)
    m_button :registerControlScriptHandler( _func, "this CBackpackSellView ".._controlname.."CallBack")
    return m_button
end

--创建CSprite
function CBackpackSellView.createSprite( self, _image, _controlname)
    print( "CBackpackSellView.createSprite:".._image)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this is CBackpackSellView createSprite:".._controlname)
    return _itemsprite
end

--创建CContainer
function CBackpackSellView.createContainer( self, _controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( "this is CBackpackSellView createContainer:".._controlname)
    return _itemcontainer
end

function CBackpackSellView.removeGoodsByIndex( self, _index)
    print("移除需要出售的物品index:",_index)
    _G.g_CBackpackPanelView :deleteOne( _index)
    --放回背包中
    local command = CCharacterSellCancleCommand( _index)
    controller :sendCommand( command)
    self :addSellGoods()
end

--卖掉所有goods
function CBackpackSellView.sellAllGoods(self)
    local temp = _G.g_CBackpackPanelView :getSellList()
    if #temp <= 0 then
        --提示没有东西出售
        --add:
        print("没有东西出售")
        require "view/ErrorBox/ErrorBox"
        local ErrorBox = CErrorBox()
        local function func1()
            print("确定")
        end
        local BoxLayer = ErrorBox : create("没有东西出售",func1)
        _G.g_CBackpackPanelView :getSceneContainer(): addChild(BoxLayer,1000)
    else    --self.m_sellnumber = 1       
        -- local i = 1
        -- while i <= #temp do
        --     local idx = temp[i].good.index 
        --     local num = temp[i].count
        --     i = i + 1
            
        --     --请求卖掉good
        --     print("idx:",idx,"num:",num)      
        --     require "common/protocol/auto/REQ_GOODS_SELL"
        --     local msg = REQ_GOODS_SELL()
        --     msg :setArguments( idx, num)
        --     CNetwork :send( msg)
        -- end
        require "common/protocol/auto/REQ_GOODS_P_SELL"
        local cmsg = REQ_GOODS_P_SELL()
        cmsg : setCount(#temp)
        local tab = {}
        for i=1,#temp do
            tab[i] = {}
            tab[i].index = temp[i].good.index
            tab[i].count = temp[i].count
        end
        cmsg : setData( tab )
        CNetwork :send( cmsg)

        --REQ_GOODS_P_SELL
        _G.g_CBackpackPanelView :deleteAll()
        self :addSellGoods()       
    end
end

-----------------------------------------------------
--更新本地list数据
----------------------------------------------------
--更新本地list数据
function CBackpackSellView.setLocalList( self, _good, _count)
    print("CBackpackSellView.setLocalList:",_good.goods_id.."/".._good.index)
    self :addSellGoods()

end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CBackpackSellView.clickGoodsCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        self :removeGoodsByIndex( obj :getTag())
    end
end

function CBackpackSellView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CBackpackSellView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                --self :resetPageContainer()
                controller :unregisterMediator( self.m_mymediator)
                controller :unregisterMediator( self.m_backpackmediator)
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CBackpackSellView.TAG_SELL then
            print(" 出售")
            self :sellAllGoods()
        end
    end
end

function CBackpackSellView.Create_effects_equip ( self,obj,name_color,id,index) --特效 
    name_color = tonumber(name_color)
    if name_color > 0 and name_color < 8 then 
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end

        -- if  self["effect_ccbi"..index] ~= nil then
        --     self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
        --     self["effect_ccbi"..index] = nil 
        -- end

        if obj ~= nil and index ~= nil  then
            self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..index],1000)

            self : setSaveCreateEffectCCBIList(index,id)
        end
    end
end

function CBackpackSellView.setSaveCreateEffectCCBIList ( self,index,id) 
    local data = {}
    data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
end
function CBackpackSellView.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end


function CBackpackSellView.removeAllCCBI ( self) 
    print("CBackpackSellView 开始调用删除CCBI")
    --local data = _G.g_CBackpackPanelView :getSellList()
    local data = self :getSaveCreateEffectCCBIList() 
    if  data ~= nil then
        for k,goods in pairs(data) do
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                local index = goods.index
                if  self["effect_ccbi"..index] ~= nil then
                    self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..index] = nil 
                    print("删除了CCBI,其名为=========",index)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
end


















