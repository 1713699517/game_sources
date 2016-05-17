--[[
 --CBackpackView
 --角色道具道具神器主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "view/UniversalBox/OverlappingUseBox"


CBackpackView = class(view, function( self)
    print("CBackpackView:角色信息主界面")
    self.m_curpagecount   = 0
    self.m_backpacktype   = 1
    self.m_sellgoodslist  = {}
    self.m_sellgoodscount = 0
    self.m_sellIndex = {}

    self.CreateEffectsList = {} --存放创建ccbi的数据
end)
--Constant:
CBackpackView.TAG_GOODS_LOCK       = 1111
CBackpackView.TAG_SMALLPOINT_START = 1100
CBackpackView.TAG_GOODS_START      = 1500

CBackpackView.GOODS_ICON           = 1000

CBackpackView.PER_PAGE_COUNT       = 20    --每页物品的个数
CBackpackView.MAX_GOODS_COUNT      = 100   --背包最大格数

CBackpackView.FONT_SIZE            = 25  --字体大小

CBackpackView.BACKPACK_OPEN_VIP_LV = 2   --初始开启背包的VIP等级

--加载资源
function CBackpackView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    
end
--释放资源
function CBackpackView.unLoadResource( self)
end

--初始化数据成员
function CBackpackView.initParams( self)
    print("CBackpackView.initParams")
    --更新本地数据
    self.m_curgoodsnum       = _G.g_GameDataProxy :getGoodsCount()
    self.m_maxgoodsnum       = _G.g_GameDataProxy :getMaxCapacity()
    self.m_backpackgoodslist = _G.g_GameDataProxy :getBackpackList()
    self.m_equipmentlist     = _G.g_GameDataProxy :getEquipmentList()
    self.m_artifactlist      = _G.g_GameDataProxy :getArtifactList()
    self.m_gemstonelist      = _G.g_GameDataProxy :getGemstoneList()
    self.m_materiallist      = _G.g_GameDataProxy :getMaterialList()
    self.m_propslist         = _G.g_GameDataProxy :getPropsList()

    local roleProperty = _G.g_characterProperty : getMainPlay()
    self.m_gold        = roleProperty :getGold()
    self.m_rmb         = roleProperty :getRmb() + roleProperty :getBindRmb()
    self.m_vipLv       = roleProperty :getVipLv() or 0

    for i,v in ipairs(self.m_equipmentlist) do
        print("æææææææææææææææææææææææææææ"..i)
    end

    self.m_goodBtn = {}

end
--释放成员
function CBackpackView.realeaseParams( self)
    --controller :unregisterMediator( self.mediator)--ByName( "CCharacterMediator")
    if self.m_scenelayer ~= nil then
        self.m_scenelayer :removeAllChildrenWithCleanup( true)  --removeFromParentAndCleanup
    end

    -- self.m_goodBtn = {}
end

--布局成员
function CBackpackView.layout( self)
    --640
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if winSize.height == 640 then
        print("640--角色信息主界面")
        --人物属性
        local backgroundSize               = CCSizeMake( winSize.height/3*4, winSize.height)
        local backpackbackgroundSize       = CCSizeMake( backgroundSize.width*0.6, winSize.height*0.7)

        self.m_characterpropsbackground :setPreferredSize( backpackbackgroundSize)      
        self.m_characterpropsbackground :setPosition( ccp( winSize.width/2, winSize.height*0.52+15)) -- +260 -32
        self.m_lableCount :setPosition(ccp( winSize.width/2-backpackbackgroundSize.width/2+30, winSize.height*0.1))
        self.m_goldSprite :setPosition(ccp( winSize.width/2-backpackbackgroundSize.width/2+200, winSize.height*0.1))
        self.m_rmbSprite :setPosition(ccp( winSize.width/2-backpackbackgroundSize.width/2+350, winSize.height*0.1))
        self.m_goodsContainer :setPosition( ccp( winSize.width/2-backpackbackgroundSize.width/2+10, winSize.height*0.52-backpackbackgroundSize.height/2+25))
        
        self.m_characterPropsViewContainer :setPosition( ccp( -backgroundSize.width/2+backpackbackgroundSize.width/2+15, 0))  -- -backgroundSize.width/2+equipupSize.width/2+15, 0
        --768
        elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")
        
    end
end

--主界面初始化
function CBackpackView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    
    --require "mediator/CharacterMediator"
    --self.mediator = CCharacterMediator(self)
    --controller :registerMediator(self.mediator)--先注册后发送 否则会报错
    
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CBackpackView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBackpackView.layer( self, _type, _partnerid, _uid)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local function touchesCallback(eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    self.m_backpacktype = _type
    self.m_uid          = _uid
    self.m_partnerid    = _partnerid
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackView self.m_scenelayer 107 ")
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( touchesCallback, "this is CBackpackView self.m_scenelayer touchesCallBack 110")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化界面
function CBackpackView.initView(self, layer)
    print("CBackpackView.initView")
    --角色道具主界面
    self.m_characterPropsViewContainer = CContainer :create()
    layer :addChild( self.m_characterPropsViewContainer)

    --背景图片
    self.m_characterpropsbackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    self.m_characterpropsbackground :setControlName("this is CBackpackView self.m_characterpropsbackground 124 ")
    self.m_characterPropsViewContainer :addChild( self.m_characterpropsbackground, -1)

    --背包中物品数量和最大数量
    local gold = nil
    if tonumber(self.m_gold) >= 100000 then
        gold = math.floor(self.m_gold/10000).."万"
    else
        gold = self.m_gold
    end
    local rmb = nil
    if tonumber(self.m_rmb) >= 100000 then
        rmb = math.floor(self.m_rmb/10000).."万"
    else
        rmb = self.m_rmb
    end
    self.m_lableCount                      = self :createLabel( "容量: "..self.m_curgoodsnum.."/"..self.m_maxgoodsnum)
    self.m_goldSprite, self.m_goldCount    = self :createPrice( 2, gold)
    self.m_rmbSprite, self.m_rmbCount      = self :createPrice( 1, rmb)
    self.m_lableCount :setAnchorPoint( ccp(0, 0.5))
    self.m_characterPropsViewContainer :addChild( self.m_lableCount, 2)
    self.m_characterPropsViewContainer :addChild( self.m_goldSprite, 2)
    self.m_characterPropsViewContainer :addChild( self.m_rmbSprite, 2)
    --背包容器总层
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer :setControlName("this is CBackpackView self.m_goodsContainer 160 ")
    self.m_characterPropsViewContainer :addChild( self.m_goodsContainer, 1)
    --显示所有道具
    self :showAllGoods( self :getShowList())
end

function CBackpackView.getShowList( self)
    local templist = nil
    if self.m_backpacktype == 1 then
        templist = self.m_backpackgoodslist
    elseif self.m_backpacktype == 2 then
        templist = self.m_propslist
    elseif self.m_backpacktype == 3 then 
        templist = self.m_gemstonelist
    elseif self.m_backpacktype == 4 then 
        templist = self.m_materiallist
    end
    -- templist = self.m_backpackgoodslist
    return templist
end

function CBackpackView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

--创建所有物品
function CBackpackView.showAllGoods(self, _goods)
    local goods = _goods or {}
    print("CBackpackView.showAllGoods"..#goods)
    
    --清除容器中原有对象
    if self.m_goodsContainer ~= nil then
        self : removeAllCCBI()
        self.m_goodsContainer :removeAllChildrenWithCleanup( true)
    end
    local function btnCallBack( eventType, obj, x, y )
        return self : clickCellCallBack(eventType, obj, x, y)
    end
    --更新背包中物品数量和最大值Lable
    local gold = nil
    if tonumber(self.m_gold) >= 100000 then
        gold = math.floor(self.m_gold/10000).."万"
    else
        gold = self.m_gold
    end
    local rmb = nil
    if tonumber(self.m_rmb) >= 100000 then
        rmb = math.floor(self.m_rmb/10000).."万"
    else
        rmb = self.m_rmb
    end
    self.m_lableCount: setString("容量: "..self.m_curgoodsnum.."/"..self.m_maxgoodsnum)
    self.m_goldCount : setString( gold) 
    self.m_rmbCount : setString( rmb)
    
    local curtaggoods         = #goods
    local curTagallgoodscount = CBackpackView.MAX_GOODS_COUNT-self.m_curgoodsnum + curtaggoods
    local lockgoods           = CBackpackView.MAX_GOODS_COUNT-self.m_maxgoodsnum     --未开锁背包
    local curtagunlockgoods   = curTagallgoodscount-lockgoods
    print("aaaaaaaaaaaaaaa", curtaggoods,curtagunlockgoods,lockgoods,curTagallgoodscount)
        
    local m_bgCell  = CCSizeMake(98,98)
    --local equipCell = CCSizeMake(88,88)
    local viewSize  = CCSizeMake( 98*5, 99*4)
    local goodscount = 0
    
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( curTagallgoodscount, CBackpackView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :setControlName("this is CBackpackView self.m_pScrollView 179 ")
    self.m_pScrollView : setTouchesPriority(1)
    self.m_pScrollView :registerControlScriptHandler( btnCallBack, "this is CBackpackView.showAllGoods  self.m_pScrollView  CallBack")
    self.m_goodsContainer :addChild( self.m_pScrollView )
    
    self.m_smallPoint = {}
    self.m_goodBtn = {}
    self.m_pageState = {}
    for k=1,self.m_pageCount do
        local pageContainer = CContainer :create()
        pageContainer :setControlName("this is CBackpackView pageContainer 186 ")
        self.m_pScrollView :addPage( pageContainer, true)
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-55)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setLineNodeSum( 5)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)
        --状态翻页按钮
        self.m_smallPoint[k] = {}
        self.m_smallPoint[k].redbutton   = self :createButton( "", "general_pages_pressing.png", btnCallBack, CBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]") 
        self.m_smallPoint[k].blackbutton = self :createButton( "", "general_pages_normal.png", btnCallBack, CBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]")      
        if k == 1 then
            print( "AAAAAAA")
            self.m_smallPoint[1].redbutton :setVisible( true)
            self.m_smallPoint[1].blackbutton :setVisible( false)  
        elseif k ~= 1 then
            print( "BBBBBBBB")
            self.m_smallPoint[k].redbutton :setVisible( false)
            self.m_smallPoint[k].blackbutton :setVisible( true)   
        end
        self.m_smallPoint[k].redbutton :setPosition(150+(k-1)*45,410)
        self.m_smallPoint[k].blackbutton :setPosition(150+(k-1)*45,410)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].redbutton,1)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].blackbutton,1)

        self.m_pageState[k] = self :createPageState()
        self.m_pageState[k] :setPosition(150+(k-1)*45,410)
        self.m_goodsContainer :addChild( self.m_pageState[k])
        
        local tempnum = CBackpackView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        
        for i =1 , tempnum do
            goodscount = goodscount + 1 
            local goodItem = nil       
            if goodscount <= curtagunlockgoods then
                --装备图片
                if goodscount <= curtaggoods then
                    --print( "createGoodItem1有物品的Button")
                    goodItem = self :createGoodItem( true, goods[goodscount])
                    local btnIdx                     = goods[goodscount].index
                    self.m_goodBtn[btnIdx]           = {}
                    self.m_goodBtn[btnIdx].goodsId   = goods[goodscount].goods_id
                    self.m_goodBtn[btnIdx].goodsIcon = goodItem :getChildByTag( CBackpackView.GOODS_ICON)
                    self.m_goodBtn[btnIdx].goodsBtn  = goodItem :getChildByTag( goods[goodscount].index)
                    print("XXXXEEEEDDDDD:",goods[goodscount].index)
                else
                    --print( "createGoodItem没有物品已解锁")
                    goodItem = self :createGoodItem( true)
                end                  
            else
                --print( "createGoodItem没有物品未解锁")
                goodItem = self :createGoodItem()
            end          
            layout :addChild( goodItem,1)                                            
        end
    end
    self.m_pScrollView :setPage( 0, false)
        
end

function CBackpackView.getGoodsBtnById( self, _goodsId )
    print("CBackpackView.getGoodsBtnById",_goodsId,#self.m_goodBtn)
    if _goodsId == nil then 
        return nil
    end
    for i,v in pairs(self.m_goodBtn) do
        print("getGoodsBtnById-->    _goodsId=".._goodsId.."     v.goodsId="..v.goodsId)
        if tonumber(v.goodsId) == tonumber( _goodsId ) then 
            return v.goodsBtn
        end
    end
    return nil    
end

--创建金钱图标和数量
function CBackpackView.createPrice( self, _type, _string)
    --根据_type创建图标
    local _imagename = nil
    if _type == 1 then    --钻石
        _imagename = "menu_icon_diamond.png"
    elseif _type == 2 then--美刀
        _imagename = "menu_icon_dollar.png"
    elseif _type == 3 then--斗魂
        _imagename = "star_soul_cion.png"
    end
    local _container       = CContainer :create()
    _container : setControlName(" CBackpackView.createPrice".._imagename)
    local _itempricesprite = CSprite :createWithSpriteFrameName( _imagename)
    _itempricesprite :setControlName( "this is createSprite _itempricesprite:".._imagename)
    _container :addChild( _itempricesprite)
    local _itempriceslabel = self :createLabel( _string)
    --CCLabelTTF :create( _string, "Arial", CBackpackView.FONT_SIZE)
    --_itempriceslabel :setColor( ccc3( 226,215,118))
    _itempriceslabel :setAnchorPoint( ccp( 0, 0.5))
    _itempriceslabel :setPosition( ccp( 30, 0))
    _container :addChild( _itempriceslabel)
    return _container, _itempriceslabel
end

--创建Label ，可带颜色
function CBackpackView.createLabel( self, _string, _color)
    print("CBackpackView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CBackpackView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--创建按钮Button
function CBackpackView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CBackpackView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CBackpackView ".._controlname)
    m_button :setFontSize( CBackpackView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CBackpackView ".._controlname.."CallBack")
    return m_button
end

function CBackpackView.createPageState( self)
    local pagestatecontainer = CContainer :create()
    local _itembackground    = CSprite: createWithSpriteFrameName("general_pages_normal.png")
    pagestatecontainer :addChild( _itembackground)
    local _itemclick         = CSprite: createWithSpriteFrameName("general_pages_pressing.png")
    _itemclick :setTag( 1)
    pagestatecontainer :addChild( _itemclick)
    return pagestatecontainer
end

function CBackpackView.createGoodItem( self, _islock, _good) 
    local goodContainer = CContainer :create()
    local m_bgCell  = CCSizeMake(96,96)
    local equipCell = CCSizeMake(88,88)
    --装备外框图片            
    local _itembackground = CSprite :createWithSpriteFrameName("general_props_underframe.png")
    --_itembackground :setPreferredSize(m_bgCell)
    _itembackground :setPosition( -_itembackground: getContentSize().width/2, -_itembackground: getContentSize().height/2)
    goodContainer :addChild( _itembackground) 
    local _itemButton   = nil
    if _islock == nil then
        local function btnCallBack( eventType, obj, x, y )
            return self : clickCellCallBack(eventType, obj, x, y)
        end
        --print( "createGoodItem@@@@@@@1")
        _itemButton = CButton :createWithSpriteFrameName("","general_the_props_close.png")
        _itemButton :setTag( CBackpackView.TAG_GOODS_LOCK)
        _itemButton :registerControlScriptHandler( btnCallBack, "this CBackpackView _itemButton CallBack 368")
    else
        --print( "createGoodItem@@@@@@@2")
        _itemButton = CButton :createWithSpriteFrameName("","general_props_underframe.png")        
    end
    _itemButton :setControlName( "this CBackpackView _itemButton 271 ")
    --_itemButton :setPreferredSize(equipCell)
    goodContainer :addChild( _itemButton)
    if _good ~= nil then
        print( "createGoodItem@@@@@@@3",_good.index)
        local isSell          = _G.g_CBackpackPanelView :getOneByIndex( _good.index)
        local goodnode        = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        local _itemGoodSprite = nil
        if goodnode == nil then
            _itemGoodSprite = CSprite: createWithSpriteFrameName("iconsprite.png")
        else
            _itemGoodSprite = CSprite: create( "Icon/i"..goodnode : getAttribute("icon")..".jpg")      
            _G.g_CBackpackPanelView:setCreateResStr( "Icon/i"..goodnode : getAttribute("icon")..".jpg" )      
            --_itemGoodSprite :setScale( 1.2)
        end
        _itemGoodSprite : setControlName( "this CBackpackView _itemGoodSprite 281 ")
        _itemGoodSprite :setTag(  CBackpackView.GOODS_ICON)
        if isSell == true then
            print("XXXXEEEE self:",#self.m_sellIndex,self.m_sellIndex)
            table.insert(self.m_sellIndex,  _good.index)
            _itemGoodSprite :setGray( true)
        end
        goodContainer :addChild( _itemGoodSprite)
        local function touchesCallback(eventType, obj, touches)
            return self :viewTouchesCallback( eventType, obj, touches)
        end

        _itemButton :setFontSize(20)
        _itemButton :setTouchesMode( kCCTouchesAllAtOnce )
        if isSell == true then
            _itemButton :setTouchesEnabled( false)
        else
            _itemButton :setTouchesEnabled( true)
        end
        _itemButton :setTag( _good.index)
        _itemButton :registerControlScriptHandler( touchesCallback, "this CBackpackView _itemButton CallBack 290")
        --_itemButton :setText( tostring( _good.goods_id.."*".._good.index))
        --数量标签
        local _itemprice = CCLabelTTF :create( _good.goods_num,"Arial",15)
        _itemprice :setPosition( _itemButton: getContentSize().width/2-20, -_itemButton :getContentSize().height/2+15)
        goodContainer :addChild( _itemprice)
    end
    --装备外框图片            
    local _itemFarmeOutSprite = CSprite :createWithSpriteFrameName("general_props_frame_normal.png")
    --特效特效·
    if _good ~= nil then
        local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        local theType  = tonumber(goodnode : getAttribute("type") )
        if theType == 1 or theType == 2 then
            self : Create_effects_equip(_itemFarmeOutSprite,goodnode : getAttribute("name_color") ,_good.goods_id,_good.index)
        end
    end
    --_itemFarmeOutSprite :setPreferredSize(m_bgCell)
    _itemFarmeOutSprite :setPosition( -_itemFarmeOutSprite: getContentSize().width/2, -_itemFarmeOutSprite: getContentSize().height/2)
    goodContainer :addChild( _itemFarmeOutSprite) 
    return goodContainer
end

function CBackpackView.Create_effects_equip ( self,obj,name_color,id,index) 
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

            -- if eventType == "AnimationComplete" then
            --     if self["effect_ccbi"..index] ~= nil then
            --         if self["effect_ccbi"..index]  : retainCount() >= 1 then
            --             self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
            --             self["effect_ccbi"..index] = nil 
            --             print("你自己删除好了，好不啊后====",index)
            --         end
            --     end
            -- end

        end



        if obj ~= nil and index ~= nil  then
            -- if  self["effect_ccbi"..index] ~= nil then
            --     self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
            --     self["effect_ccbi"..index] = nil 
            -- end

            -- if  self["effect_ccbi"..index] ~= nil then

            --     if self["effect_ccbi"..index]  : retainCount() >= 1 then
            --         self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
            --         self["effect_ccbi"..index] = nil 
            --         print("有重复的先自己删除====",index)
            --     end
            -- end

            -- self["effect_ccbi"..id] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            -- self["effect_ccbi"..id] : setControlName( "this CCBI Create_effects_activity CCBI")
            -- self["effect_ccbi"..id] : registerControlScriptHandler( animationCallFunc)
            -- obj  : addChild(self["effect_ccbi"..id],1000)

            self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..index],1000)

            self : setSaveCreateEffectCCBIList(index,id)
        end
    end
end

function CBackpackView.setSaveCreateEffectCCBIList ( self,index,id) 
    print("存表----",index,id)
    local data = {}
    data.index = index 
    data.id    = id 
    table.insert(self.CreateEffectsList,data)
    print("村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CBackpackView.getSaveCreateEffectCCBIList ( self) 
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CBackpackView.removeAllCCBI ( self) 
    print("开始调用删除CCBI")
    -- local data = self :getShowList() 
    local data = self :getSaveCreateEffectCCBIList() 
    print("1")
    if  data ~= nil then
        print("2")
        for k,goods in pairs(data) do
            print("3")
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                --local id = goods.goods_id
                local index = goods.index
                if  self["effect_ccbi"..index] ~= nil then
                    print("4")
                    self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..index] = nil 
                    print("删除了CCBI,其名为=========",index)
                end 
            --end
        end
    end
    self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
end


--根据物品ID取得物品
function CBackpackView.getGoodsByIndex( self, _index)
    for k,v in pairs( self.m_backpackgoodslist) do
        if v.index == _index then
            return v
        end
    end
    return false
end
-----------------------------------------------------
--通过mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CBackpackView.setLocalList( self)
    print("CBackpackView.setLocalList")
    self :initParams()
    --显示所有道具
    self :showAllGoods( self :getShowList())
    self :layout()
    self.m_pScrollView :setPage( self.m_curpagecount , false)
end

function CBackpackView.setVipView( self)
    local roleProperty = _G.g_characterProperty : getMainPlay()
    self.m_gold        = roleProperty :getGold()
    self.m_rmb         = roleProperty :getRmb() + roleProperty :getBindRmb()
    print("Gold:",self.m_gold, "Rmb:",self.m_rmb)
    local gold = nil
    if tonumber(self.m_gold) >= 100000 then
        gold = math.floor(self.m_gold/10000).."万"
    else
        gold = self.m_gold
    end
    local rmb = nil
    if tonumber(self.m_rmb) >= 100000 then
        rmb = math.floor(self.m_rmb/10000).."万"
    else
        rmb = self.m_rmb
    end
    self.m_goldCount : setString( gold) 
    self.m_rmbCount : setString( rmb)    
end

function CBackpackView.setUseGood( self, _data, _showtype)
    print("大背包内使用物品:",_showtype) -- 1 使用  2 出售
    local promptbox = _G.g_COverlappingUseBoxView :create( _data, _showtype)
    promptbox :setFullScreenTouchEnabled(true)
    promptbox :setTouchesEnabled(true)
    --promptbox :setPosition(100,0)
    self.m_scenelayer :addChild( promptbox)
end

function CBackpackView.setCancleSell( self, _index)
    print( "====== setCancleSell:",type(_index),_index,self)
    print("XXXXEEEE self: ",#self.m_sellIndex,self.m_sellIndex)
    for k,v in pairs(self.m_sellIndex) do
        print(k,v)
        if tonumber(v) == tonumber(_index) then
            self.m_goodBtn[_index].goodsIcon :setGray( false)
            self.m_goodBtn[_index].goodsBtn :setTouchesEnabled( true)
            table.remove( self.m_sellIndex, k)
            break
        end
    end
    print("XXXXEEEE self:",#self.m_sellIndex,self.m_sellIndex)

end


function CBackpackView.setSellGood( self, _good, _count)
    print("出售物品背包更新")
    print("XXXXEEEE self:",#self.m_sellIndex,self.m_sellIndex)
    table.insert( self.m_sellIndex, _good.index)
    self.m_goodBtn[_good.index].goodsIcon  :setGray( true)
    self.m_goodBtn[_good.index].goodsBtn :setTouchesEnabled( false)
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--多点触控
function CBackpackView.viewTouchesCallback(self, eventType, obj, touches)
    print("CBackpackView.viewTouchesCallback eventType",eventType, obj :getTag())
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        if obj :isVisibility() == false then
            return
        end
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print("XXXXXXXX",self.touchID,obj :getTag())
                    self.touchID     = touch :getID()
                    self.touchIndex  = obj :getTag()                    
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
            print("touch2:getID():",touch2:getID(),"")
            if touch2:getID() == self.touchID and self.touchIndex == obj :getTag() then
                --check distance
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 and obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touch2Point.x, touch2Point.y))) then
                    print("dianji index:",obj :getTag())
                    --非出售界面弹出Tips
                    local _position = {}
                    _position.x = touch2Point.x
                    _position.y = touch2Point.y
                    local  temp =   _G.g_PopupView :create( self :getGoodsByIndex( obj :getTag()), _G.Constant.CONST_GOODS_SITE_BACKPACK, _position, self.m_partnerid)
                    self.m_scenelayer :addChild( temp, 10)
                    self.touchID   = nil
                    self.touchIndex = nil
                end
            end
        end
    end
end
--BUTTON类型切换buttonCallBack
--单击回调
function CBackpackView.clickCellCallBack(self,eventType, obj, x, y)
    print( "CBackpackView.clickCellCallBack",eventType, obj, x, y)
    --删除Tips
    _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then        
        local currentPage = x
        print( "eventType",eventType, currentPage, self.m_curentPageCount)
        if currentPage ~= self.m_curentPageCount then
            self.m_curentPageCount = currentPage 
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            k = self.m_curentPageCount+1
            self.m_smallPoint[k].redbutton :setVisible( true)
            self.m_smallPoint[k].blackbutton :setVisible( false)
        end
    elseif eventType == "TouchEnded" then
        if obj :getTag() > CBackpackView.TAG_SMALLPOINT_START and obj :getTag() <= CBackpackView.TAG_SMALLPOINT_START + self.m_pageCount then
            --翻页状态点回调
            print("Clicked smollpoint!")
            print(obj: getTag())
            -- self.m_curpagecount = k-1
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            k = obj :getTag()-CBackpackView.TAG_SMALLPOINT_START
            self.m_smallPoint[k].redbutton :setVisible( true)
            self.m_smallPoint[k].blackbutton :setVisible( false)
            self.m_pScrollView :setPage( k-1 , false)
        elseif obj :getTag() == CBackpackView.TAG_GOODS_LOCK then
            print("锁住的背包")
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
                print(" VIP: 跳转到VIP")
                require "view/VipUI/VipUI"
                local vipUI = CVipUI()
                CCDirector :sharedDirector() :pushScene( vipUI:scene())
            end
            local function func2()
                print("取消")
            end
            local tempLv = 0
            if self.m_vipLv >= 0 and self.m_vipLv <_G.Constant.CONST_VIP_BAG_ADD_TWO then
                tempLv = _G.Constant.CONST_VIP_BAG_ADD_TWO
            elseif self.m_vipLv >= _G.Constant.CONST_VIP_BAG_ADD_TWO and self.m_vipLv <_G.Constant.CONST_VIP_BAG_ADD_FIVE then
                tempLv = _G.Constant.CONST_VIP_BAG_ADD_FIVE
            elseif self.m_vipLv >= _G.Constant.CONST_VIP_BAG_ADD_FIVE and self.m_vipLv <_G.Constant.CONST_VIP_BAG_ADD_SEVNE then
                tempLv = _G.Constant.CONST_VIP_BAG_ADD_SEVNE
            else
                tempLv = 14
            end            
            local BoxLayer = ErrorBox : create("开启背包需要VIP "..tempLv..", 当前是VIP "..self.m_vipLv..",是否去提升？",func1,func2)
            _G.g_CBackpackPanelView :getSceneContainer(): addChild(BoxLayer,1000)
        end
    end
end

















