--BackpackLayer 主界面
require "view/view"
require "mediator/mediator"
require "controller/command"
require "mediator/BackpackMediator"
require "controller/BackpackCommand"
require "model/VO_BackpackModle"

require "model/GameDataProxy"

require "view/BackpackLayer/promptbox"
require "view/BackpackLayer/sellbatchview"
require "view/BackpackLayer/remotestoreview"
require "view/EquipInfoView/EquipTipsView"
require "view/TipsLayer/PopupView"


CBackpackView = class(view, function( self)
    self.m_goodsContainer = nil
end)
--Constant:
CBackpackView.TAG_PROPS            = 1000  --道具
CBackpackView.TAG_EQUIPMENT        = 1001  --装备
CBackpackView.TAG_GEMSTONE         = 1002  --宝石
CBackpackView.TAG_MATERIAL         = 1003  --材料
CBackpackView.TAG_REMOTESTORE      = 1004  --远程商店
CBackpackView.TAG_SELLBATCH        = 1005  --批量出售
CBackpackView.TAG_ARTIFACT         = 1006  --神器
CBackpackView.TAG_CLOSED           = 1007  --关闭
CBackpackView.TAG_SMALLPOINT_START = 1100
CBackpackView.TAG_GOODS_START      = 1500

CBackpackView.PER_PAGE_COUNT   = 20    --每页物品的个数
CBackpackView.MAX_GOODS_COUNT  = 80   --背包最大格数

CBackpackView.FONT_SIZE       = 30


--加载资源
function CBackpackView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Icon")
end

--释放资源
function CBackpackView.onLoadResource( self)
    
end


--初始化数据成员
function CBackpackView.initParams( self, layer)
    print("CBackpackView.initParams")
    --mediator中更新    
    --更新本地数据
    self.m_curgoodsnum       = _G.g_GameDataProxy :getGoodsCount()
    self.m_maxgoodsnum       = _G.g_GameDataProxy :getMaxCapacity()
    self.m_backpackgoodslist = _G.g_GameDataProxy :getBackpackList()
    self.m_equipmentlist     = _G.g_GameDataProxy :getEquipmentList()
    self.m_gemstonelist      = _G.g_GameDataProxy :getGemstoneList()
    self.m_materiallist      = _G.g_GameDataProxy :getMaterialList()
    self.m_propslist         = _G.g_GameDataProxy :getPropsList()
    self.m_artiFactlist      = _G.g_GameDataProxy :getArtifactList()
    
    --连接服务器
    --MVC初始化
    self.mediator = CBackpackMediator(self)
    controller :registerMediator(self.mediator)--先注册后发送 否则会报错    
    
    --local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_REQUEST)
    --local data = {}
    --data.sid  = CSelectSeverHandle.connectSeverId
    --data.uid  = CSelectSeverHandle.selectedUid
    --data.type = 1 --请求背包物品
    --command :setOtherData( data)
    --controller :sendCommand(command)    
end

--释放成员
function CBackpackView.realeaseParams( self)
    
end

--布局成员
function CBackpackView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--背包界面")
        local bgImg = self.m_backpackViewContainer :getChildByTag(100)        
        bgImg: setPreferredSize(CCSizeMake(winSize.width, winSize.height))
        bgImg: setPosition( ccp(winSize.width/2,winSize.height/2))
        
        local bgImgtwo = self.m_backpackViewContainer :getChildByTag(105)
        bgImgtwo: setPreferredSize( CCSizeMake(winSize.width-20, winSize.height-20))
        bgImgtwo: setPosition( ccp(winSize.width/2,winSize.height/2))
                        
        local closedButton = self.m_backpackViewContainer :getChildByTag(CBackpackView.TAG_CLOSED)
        local closeSize = closedButton: getContentSize()
        closedButton: setPosition( ccp(winSize.width-closeSize.width*2/3, winSize.height-closeSize.height*2/3))
        
        local lableCount = self.m_backpackViewContainer :getChildByTag(102)
        lableCount: setPosition( ccp(winSize.width/2-100,40))
        
        self.m_goodsContainer: setPosition( ccp(180,50))
        
        --local bagimg = self.m_goodsContainer :getChildByTag(104)
        --bagimgsize = bagimg :getContentSize()
        --bagimg :setPosition( ccp( 195, 260))
        
        local buttonLayout = self.m_backpackViewContainer :getChildByTag(200)
        local btnsize = buttonLayout: getChildByTag(CBackpackView.TAG_GEMSTONE): getContentSize()
        buttonLayout: setPosition(ccp(btnsize.width*1.1,btnsize.height/2))

    --768
    elseif winSize.height == 768 then
        CCLOG("768--背包界面")
        
    end

end



--主界面初始化
function CBackpackView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initBackpackView(self, layer)
    --布局成员
    self.layout(self, winSize)  

end


function CBackpackView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    
    local function touchesCallback(eventType, obj, touches)
        return self :TouchesCallback( eventType, obj, touches)
    end
    
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( " this is CBackpackView self.m_scenelayer 149" )
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( touchesCallback ,"this CBackpackView self.m_scenelayer 152")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end


function CBackpackView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( " this is CBackpackView self.m_scenelayer 164" )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CBackpackView.initBackpackView(self, layer)
    print("CBackpackView.initBackpackView")
    self.m_backpackViewContainer = CContainer :create()
    self.m_backpackViewContainer : setControlName( " this is CBackpackView self.m_backpackViewContainer 173" )
    layer :addChild(self.m_backpackViewContainer)

    --TAG对应的回调
    local function btnCallBack(eventType, obj, x, y)
        print(obj: getTag())
        return self : clickedButtonCallBack( eventType, obj, x, y)
    end
    --backgroundImg
    local bgImg = CSprite: createWithSpriteFrameName("backpackUIrim.png")
    bgImg : setControlName( "this CBackpackView bgImg 178 ")
    self.m_backpackViewContainer :addChild( bgImg,-1,100)
    --二级背景
    local bgImgtwo = CSprite :createWithSpriteFrameName("iconinfo.png")
    bgImgtwo : setControlName( "this CBackpackView bgImgtwo 182 ")
    self.m_backpackViewContainer :addChild( bgImgtwo,-1,105)  
    
    --页数Lable
    ----------------------------------------------------------
    self.m_lableCount = CCLabelTTF :create( string.format("%d/%d",tonumber(self.m_curgoodsnum),tonumber(self.m_maxgoodsnum)),"Arial",25)
    self.m_backpackViewContainer :addChild( self.m_lableCount,2,102)
    
    --标签菜单部分
    ----------------------------------------------------------
    --标签布局
    local buttonLayout = CLayout : create(eLD_Vertical)
    self.m_backpackViewContainer :addChild(buttonLayout,1,200)   
    
    local sellbatchbutton   = self :createButton( "批量出售", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_SELLBATCH, "sellbatchbutton")
    local remotestorebutton = self :createButton( "远程商店", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_REMOTESTORE, "remotestorebutton")
    local materialbutton    = self :createButton( "材料", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_MATERIAL, "materialbutton")
    local gemstonebutton    = self :createButton( "宝石", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_GEMSTONE, "gemstonebutton")   
    local artifactbutton    = self :createButton( "神器", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_ARTIFACT, "artifactbutton")   
    local equipmentbutton   = self :createButton( "装备", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_EQUIPMENT, "equipmentbutton")
    local propsbutton       = self :createButton( "道具", "general_four_button_normal.png", btnCallBack, CBackpackView.TAG_PROPS, "propsbutton")  
    local closedbutton      = self :createButton( "", "general_close_normal.png", btnCallBack, CBackpackView.TAG_CLOSED, "closedbutton")    
    --sellButton :setTouchesPriority((sellButton :getTouchesPriority())-1)
    
    buttonLayout: setColumnNodeSum(7)
    buttonLayout: setCellVerticalSpace(10)
    buttonLayout: setCellSize( ccp( propsbutton: getContentSize().width, propsbutton: getContentSize().height))
    
    buttonLayout: addChild( sellbatchbutton,1)
    buttonLayout: addChild( remotestorebutton,1)
    buttonLayout: addChild( materialbutton,1)
    buttonLayout: addChild( gemstonebutton,1)
    buttonLayout: addChild( artifactbutton,1)
    buttonLayout: addChild( equipmentbutton,1)
    buttonLayout: addChild( propsbutton,1)
    self.m_backpackViewContainer :addChild( closedbutton,2)  
      
        --背包容器总层
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer : setControlName( "this is CBackpackView self.m_goodsContainer 275")
    self.m_goodsContainer: setPosition( ccp(180,50))
    self.m_backpackViewContainer :addChild( self.m_goodsContainer, 1)

    --默认主界面上显示又远程商店
    -----------------------------------------------------------------
    --self.m_sellshop = CRemoteStoreView()
    --self.m_container = CRemoteStoreView :layer()
    --self.m_container :setPosition(-40,0)
    --self.m_backpackViewContainer :addChild(self.m_container,1,701)
            
    --背包界面默认显示道具
    self: setLocalList()  
    self.m_containertag = CBackpackView.TAG_PROPS

    self.m_touchedBtn = nil
    self.m_touchedID  = nil      
    
    self : showViewGoods( self.m_propslist )
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


function CBackpackView.createGoodItem( self, _islock, _good) 
    local goodContainer = CContainer :create()
    local m_bgCell  = CCSizeMake(96,96)
    local equipCell = CCSizeMake(88,88)
    local _itemButton   = nil
    if _islock == nil then
        print( "createGoodItem@@@@@@@1")
        _itemButton = CButton :createWithSpriteFrameName("","iconframelock.png")
    else
        print( "createGoodItem@@@@@@@2")
        _itemButton = CButton :createWithSpriteFrameName("","iconframe.png")        
    end
    _itemButton :setControlName( "this CBackpackView _itemButton 271 ")
    _itemButton :setPreferredSize(equipCell)
    goodContainer :addChild( _itemButton)
    if _good ~= nil then
        print( "createGoodItem@@@@@@@3-----")
        local goodnode        = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        local _itemGoodSprite = nil
        if goodnode == nil then
            _itemGoodSprite = CSprite: createWithSpriteFrameName("iconsprite.png")
        else
            _itemGoodSprite = CSprite: create( "Icon/i"..goodnode.icon..".jpg")            
            --_itemGoodSprite :setScale( 1.2)
        end
        _itemGoodSprite : setControlName( "this CBackpackView _itemGoodSprite 281 ")
        goodContainer :addChild( _itemGoodSprite)
        local function touchesCallback(eventType, obj, touches)
            return self :TouchesCallback( eventType, obj, touches)
        end

        _itemButton :setFontSize(20)
        _itemButton :setTouchesMode( kCCTouchesAllAtOnce )
        _itemButton :setTouchesEnabled( true)
        _itemButton :setTag( _good.index)
        _itemButton :registerControlScriptHandler( touchesCallback, "this CBackpackView _itemButton CallBack 290")
        _itemButton :setText( tostring( _good.goods_id.."*".._good.index))
        --数量标签
        local _itemprice = CCLabelTTF :create( _good.goods_num,"Arial",15)
        _itemprice :setPosition( _itemButton: getContentSize().width/2-10, -_itemButton :getContentSize().height/2+10)
        goodContainer :addChild( _itemprice)
    end
    --装备背景图片            
    local _itemFarmeOutSprite = CSprite :createWithSpriteFrameName("iconrim.png")
    _itemFarmeOutSprite :setPreferredSize(m_bgCell)
    _itemFarmeOutSprite :setPosition( -_itemFarmeOutSprite: getContentSize().width/2, -_itemFarmeOutSprite: getContentSize().height/2)
    goodContainer :addChild( _itemFarmeOutSprite) 
    return goodContainer
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

--背包物品显示
function CBackpackView.showViewGoods(self, goods)
    print("CBackpackView.showViewGoods")

    --清除容器中原有对象
    if self.m_goodsContainer ~= nil then
        self.m_goodsContainer :removeAllChildrenWithCleanup( true)
    end
    local function btnCallBack( eventType, obj, x, y )
        return self : clickedButtonCallBack(eventType, obj, x, y)
    end
    --更新背包中物品数量和最大值Lable
    self.m_lableCount: setString( string.format("%d/%d",self.m_curgoodsnum,self.m_maxgoodsnum))

    local curtaggoods         = #goods
    local curTagallgoodscount = CBackpackView.MAX_GOODS_COUNT-self.m_curgoodsnum + curtaggoods 
    local lockgoods           = CBackpackView.MAX_GOODS_COUNT-self.m_maxgoodsnum     --未开锁背包
    local curtagunlockgoods   = curTagallgoodscount-lockgoods
    print("aaaaaaaaaaaaaaa", curtaggoods,curtagunlockgoods,lockgoods,curTagallgoodscount)
    
    local bagImg = CSprite :createWithSpriteFrameName("iconinfo.png")
    bagImg : setControlName( "this CBackpackView bagImg 296 ")
    bagImg :setPreferredSize( ccp(400,560))
    bagImg :setPosition( ccp( 195, 260))
    self.m_goodsContainer :addChild( bagImg,-1,104)

    local viewSize  = CCSizeMake(97*4,97*5)
    local m_bgCell  = CCSizeMake(96,96)
    local equipCell = CCSizeMake(88,88)
    local goodscount = 0
    
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( curTagallgoodscount, CBackpackView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)

    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :registerControlScriptHandler( btnCallBack, "this is CBackpackView self.m_pScrollView CallBack")
    self.m_pScrollView : setTouchesPriority(1)
    self.m_goodsContainer :addChild( self.m_pScrollView )

    self.m_smallPoint = {}
    self.m_goodBtn = {}
    for k=1,self.m_pageCount do
        local pageContainer = CContainer :create()
        pageContainer : setControlName( "this is CBackpackView pageContainer 308")
        self.m_pScrollView :addPage( pageContainer, true)

        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-55)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setLineNodeSum(4)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)
        --状态翻页按钮
        self.m_smallPoint[k] = {}
        self.m_smallPoint[k].redbutton   = self :createButton( "", "iconstatered.png", btnCallBack, CBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]") 
        self.m_smallPoint[k].blackbutton = self :createButton( "", "iconstateblack.png", btnCallBack, CBackpackView.TAG_SMALLPOINT_START+k, "self.m_smallPoint[k]")      
        if k == 1 then
            print( "AAAAAAA")
            self.m_smallPoint[1].redbutton :setVisible( true)
            self.m_smallPoint[1].blackbutton :setVisible( false)  
        elseif k ~= 1 then
            print( "BBBBBBBB")
            self.m_smallPoint[k].redbutton :setVisible( false)
            self.m_smallPoint[k].blackbutton :setVisible( true)   
        end
        self.m_smallPoint[k].redbutton :setPosition(140+(k-1)*35,510)
        self.m_smallPoint[k].blackbutton :setPosition(140+(k-1)*35,510)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].redbutton,1)
        self.m_goodsContainer :addChild( self.m_smallPoint[k].blackbutton,1)

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
                    print( "createGoodItem1有物品的Button")
                    goodItem = self :createGoodItem( true, goods[goodscount])
                else
                    print( "createGoodItem没有物品已解锁")
                    goodItem = self :createGoodItem( true)
                end                  
            else
                print( "createGoodItem没有物品未解锁")
                goodItem = self :createGoodItem()
            end          
            layout :addChild( goodItem,1)                                            
        end
    end
    self.m_pScrollView :setPage( 0, false)
    self.m_curentPageCount = 0  
end

--根据物品ID取得物品
function CBackpackView.getGoodsByID( self, _index)
    for k,v in pairs( self.m_backpackgoodslist) do
        print(k,v)
        if v.index == _index then
            return v
        end
    end
    return false
end

--更新本地list数据
function CBackpackView.setLocalList( self)
    print("CBackpackView.setLocalList")
    --更新本地数据
    self.m_curgoodsnum       = _G.g_GameDataProxy :getGoodsCount()
    self.m_maxgoodsnum       = _G.g_GameDataProxy :getMaxCapacity()
    self.m_backpackgoodslist = _G.g_GameDataProxy :getBackpackList()
    self.m_equipmentlist     = _G.g_GameDataProxy :getEquipmentList()
    self.m_gemstonelist      = _G.g_GameDataProxy :getGemstoneList()
    self.m_materiallist      = _G.g_GameDataProxy :getMaterialList()
    self.m_propslist         = _G.g_GameDataProxy :getPropsList()
    self.m_artiFactlist      = _G.g_GameDataProxy :getArtifactList()
end
    
--根据背包类型返回相应list
function CBackpackView.getListByType( self, tag_type)
    print( "111111111111111111",tag_type)
    local list
    if CBackpackView.TAG_EQUIPMENT == tag_type then
        list = self.m_equipmentlist
    elseif CBackpackView.TAG_GEMSTONE == tag_type then
        list = self.m_gemstonelist
    elseif CBackpackView.TAG_MATERIAL == tag_type then
        list = self.m_materiallist
    elseif CBackpackView.TAG_PROPS == tag_type then
        list = self.m_propslist
    elseif CBackpackView.TAG_ARTIFACT == tag_type then
        list = self.m_artiFactlist
    else
        print("出错啦！没有相应的标签。")
    end
    return list
end    
    
--数据成员设置
--从mediator更新数据
--更新UI
-----------------------------------------------------
--获取背包信息    
function CBackpackView.setBackpackInfo( self)
    print("CBackpackView.setBackpackInfo")
    --更新本地数据
    self: setLocalList()   
    self :showViewGoods( self :getListByType( self.m_containertag))
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--物品的多点触控
function CBackpackView.TouchesCallback(self, eventType, obj, touches)
    print("viewTouchesCallback eventType",eventType, obj :getTag(),self.touchID)
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID     = touch :getID()
                    self.touchGoodId = obj :getTag()
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
            if touch2:getID() == self.touchID and self.touchGoodId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    --弹出物品Tips
                    print("dianji")                    
                    local _position = {}
                    _position.x = touch2Point.x
                    _position.y = touch2Point.y
                    local  temp =   _G.g_PopupView :create( self :getGoodsByID( obj :getTag()), _G.Constant.CONST_GOODS_SITE_BACKPACK, _position)
                    self.m_scenelayer :addChild( temp)

                    self.touchID     = nil
                    self.touchGoodId = nil
                end
            end
        end
        print( eventType,"END")
    end
end

--单点类型CallBack
function CBackpackView.clickedButtonCallBack(self, eventType, obj, x, y)
    --删除Tips
    _G.g_PopupView :reset()
    print( eventType, obj :getTag())
    if eventType == "TouchBegan" then
        local ret = obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        print( "XXXXXXXXXXXXXXXXXXXX", ret)
        return ret
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
        if (obj: getTag()) == CBackpackView.TAG_CLOSED then
            --背包关闭CallBack
            print("Clicked closed!1")
            if self ~= nil then
                --清除容器中原有对象
                if self.m_goodsContainer ~= nil then
                    print("Clicked closed!2")
                    self.m_goodsContainer :removeAllChildrenWithCleanup( true)
                    self.m_goodsContainer = nil
                    print("Clicked closed!3")
                end
                --self.m_scenelayer :removeAllChildrenWithCleanup(true)
                controller :unregisterMediator( self.mediator)
                CCDirector :sharedDirector() :popScene( )
                print("Clicked closed!4")
                else
                print("objSelf = nil", self)
            end            
        elseif (obj: getTag()) == CBackpackView.TAG_SELLBATCH then
            --
            print("批量出售")
            print(obj: getTag())
            --[[
            if self.m_container == obj then
                print("批量出售")
                return
            end
            if self.m_container ~= nil then
                print("Remove Old")
                self.m_container :removeFromParentAndCleanup(true)
            end
            print("New 批量出售") 
            self.m_sellshop = CSellBatchView()
            self.m_container = self.m_sellshop :layer()
            self.m_container :setPosition(-50,0)
            self.m_backpackViewContainer :addChild(self.m_container,1,700)
            ]]
        elseif (obj: getTag()) == CBackpackView.TAG_REMOTESTORE then
            --
            print("远程商店")  --Remote Store
            --[[
            if(self.m_container == obj) then
                return
            end
            if self.m_container ~= nil then
                self.m_container :removeFromParentAndCleanup(true)
            end
            self.m_sellshop = CRemoteStoreView()
            self.m_container = CRemoteStoreView :layer()
            self.m_container :setPosition(-40, 0)
            self.m_backpackViewContainer :addChild(self.m_container,1,701)
            --]]
        elseif obj :getTag() > CBackpackView.TAG_SMALLPOINT_START and obj :getTag() <= CBackpackView.TAG_SMALLPOINT_START + self.m_pageCount then
            --翻页状态点回调
            print("Clicked smollpoint!")
            print(obj: getTag())
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            k = obj :getTag()-CBackpackView.TAG_SMALLPOINT_START
            self.m_smallPoint[k].redbutton :setVisible( true)
            self.m_smallPoint[k].blackbutton :setVisible( false)
            self.m_pScrollView :setPage( k-1 , false)
        else
            self.m_containertag = obj: getTag()
            if (obj: getTag()) == CBackpackView.TAG_EQUIPMENT then
                --装备回调
                print("Clicked ZhuangBeiButton!")
                print(obj: getTag())
                self.showViewGoods(self, self.m_equipmentlist)
                --CBackpackView.initview(self, self.m_scenelayer)
            elseif obj: getTag() == CBackpackView.TAG_GEMSTONE then
                print("Clicked BaoShiButton!")
                print(obj: getTag())
                self.showViewGoods(self, self.m_gemstonelist)
            elseif obj: getTag() == CBackpackView.TAG_MATERIAL then
                print("Clicked CaiLiaoButton!")
                print(obj: getTag())
                self.showViewGoods(self, self.m_materiallist)
                --
            elseif obj: getTag() == CBackpackView.TAG_PROPS then
                print("Clicked DaoJuButton!")
                print(obj: getTag())
                self.showViewGoods(self, self.m_propslist)
            elseif obj: getTag() == CBackpackView.TAG_ARTIFACT then
                print("Clicked ShengQiButton!")
                print(obj: getTag())
                self.showViewGoods(self, self.m_artiFactlist)
            end
            local k = 1
            while k <= self.m_pageCount do
                self.m_smallPoint[k].blackbutton :setVisible( true)
                k = k + 1
            end
            self.m_smallPoint[1].redbutton :setVisible( true) 
            self.m_smallPoint[1].blackbutton :setVisible( false) 
            self.m_pScrollView :setPage( 0, false)
        end
        
    end
end




--单击回调
function CBackpackView.clickCellCallBack(self,eventType, obj, x, y)
    print("XXXXXXX",obj: getTag(),eventType)
    if eventType == "TouchBegan" then
        print("xiaohong")
        local ret = obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        print("tttt", ret)
        return ret
    elseif eventType == "TouchEnded" then
        
        print("Clicked CellImg!")
        print(obj: getTag())
        print("Good ID:",obj: getText())    

    end
end


--双击回调
function CBackpackView.doubleclickCellCallBack(eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("Double Clicked CellImg!")
        print(obj: getTag())    
    end
end


--输出物品信息
--测试数据使用
------------------------------------------------------

--[[
        --请求商店

        if obj.good ~= nil and obj.good.goods_type == 1 then
            local data = {}
            data.npc_id   = 0        
            local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_SHOP_ASK)
            command :setOtherData( data)
            controller :sendCommand( command)
        end
        


        --请求背包扩充

        if obj.good ~= nil and obj.good.goods_type == 1 then
            local data = {}
            data.arg   = false        --询问数量
            local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_ENLARGE_REQUEST)
            command :setOtherData( data)
            controller :sendCommand( command)
        end
        
        --请求角色装备信息

        if obj.good ~= nil and obj.good.goods_type == 1 then   
            local data = {}
            data.uid         = CSelectSeverHandle.selectedUid       --玩家UID
            data.partner     = 0  --CSelectSeverHandle.selectedUid       --主将
            local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_EQUIP_ASK)
            command :setOtherData( data)
            controller :sendCommand( command)
        end
        

        
        --使用物品

        --if obj.good ~= nil and obj.good.goods_type == 1 then   --装备
        
        if obj.good ~= nil then

            local shop = self.m_backpackViewContainer: getChildByTag(700)
            if shop ~= nil then
                self.m_sellshop :addGoodToSell(obj.good)
            else
                local promptbox = CPromptBoxView :create( obj.good,2)
                promptbox :setFullScreenTouchEnabled(true)
                promptbox :setTouchesEnabled(true)
                promptbox :setPosition(100,0)
                self.m_scenelayer :addChild( promptbox)

           -- end
            
            --local window = CWindow :createWithSpriteFrameName( "backpackUIrim.png","iconclosed.png",promptbox)
            --window :show( self.m_scenelayer, ccp( x,y))

            if false then
                --
                local data = {}
                data.type       = 1  --背包
                data.target     = 0  --CSelectSeverHandle.selectedUid  --自己
                data.from_index = obj.good.index
                data.count      = obj.good.goods_num
                print("data.from_index",data.from_index,"data.count",data.count)
                local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_USE)
                command :setOtherData( data)
                controller :sendCommand( command)   

                require "common/protocol/auto/REQ_GOODS_USE"
                local msg = REQ_GOODS_USE()
                local type       = 1
                local target     = 0
                local from_index = obj.good.index
                local count      = obj.good.goods_num
                msg :setArguments( type, target, from_index, count)
                CNetwork :send( msg)         
            end

        --end 
    
        
        --丢弃物品/Users/mac/Desktop/GameBox0704/GameBox/Resources/common/protocol/auto/REQ_GOODS_LOSE.lua

        if obj.good ~= nil then
            require "common/protocol/auto/REQ_GOODS_LOSE"
            local msg = REQ_GOODS_LOSE()
            msg :setArguments( obj.good.index)
            CNetwork :send( msg)
         
        end

        
        --出售物品

        print(self.m_backpackViewContainer: getChildByTag(700))
        print(self.m_backpackViewContainer: getChildByTag(701))
        local shop = self.m_backpackViewContainer: getChildByTag(700)
        if shop ~= nil and obj ~= nil then
            self.m_sellshop :addGoodToSell(obj.good)
        end

        
        --需要设置touches模式

        if eventType == "TouchesBegan" then
            if self.m_touchedID ~= 0 or self.m_touchedBtn ~= nil then --已点击则退出
                return
            end
            for i = 1, touches:count() do
                local touch = touches:at( i - 1 )
                if obj:containsTouch(touch) and obj.icon ~= nil then                    --其中一点击中则退出循环
                    self.m_touchedID = touch:getID()
                    self.m_touchedBtn = obj
                    print("obj:",obj: getText())
                    --Tips
                    local tips = CEquipTipsView:layer(obj)
                    self.m_backpackViewContainer :addChild(tips)
                    --tips : show(self.m_backpackViewContainer)
                    break
                end
            end
        elseif eventType == "TouchesEnded" then
            self.m_touchedBtn = nil
            self.m_touchedID = 0
        end

--]]




















