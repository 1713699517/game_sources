

require "view/view"
require "controller/command"

require "mediator/TreasureHouseInfoViewMediator"

require "view/TreasureHouse/TreasureHouseScene"
require "view/TreasureHouse/MysteriousShopLayer"
require "view/TreasureHouse/EquipmentManufactureLayer"



CTreasureHouseInfoView = class(view,function (self)
                          end)

CTreasureHouseInfoView.TAG_TreasureHousePage          = 1  --珍宝
CTreasureHouseInfoView.TAG_EquipmentManufacturePage   = 2  --道具制作
CTreasureHouseInfoView.TAG_MysteriousShopPage         = 3  --神秘商店

function CTreasureHouseInfoView.scene(self)
    print("珍宝阁资源完全建立之前------------")
    --CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene    : create()
    self.m_layer  = CContainer : create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CTreasureHouseInfoView.layer(self,_winSize)
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CTreasureHouseInfoView.loadResources(self)
  
end

function CTreasureHouseInfoView.unloadResources(self)
    _G.Config:unload("config/hidden_describe.xml")
    _G.Config:unload("config/hidden_store.xml")
    _G.Config:unload("config/hidden_make.xml")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TreasureHouseResource/TreasureHouseResource.plist")  
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TreasureHouseResource/TreasureHouseResource.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("EquipmentResources/Equip.plist")

    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("TreasureHouseResource/TreasureHouseResource.pvr.ccz")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("BarResources/BarResources.ccz")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("TreasureHouseResource/TreasureHouseResource.pvr.ccz")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("EquipmentResources/Equip.pvr.ccz")

    self.MysteriousShop             : removeIconResources()
   --self.CEquipmentManufactureLayer : removeIconResources()
    self.TreasureHouse              : removeIconResources()
    self.TreasureHouse              : RemoveAllCCBI() --删除ccbi
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CTreasureHouseInfoView.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

          self.m_allBackGroundSprite      : setPosition(winSize.width/2,winSize.height/2)      --总底图
          local closeSize                 = self.CloseBtn: getContentSize()
          self.CloseBtn                   : setPosition(IpadSize-closeSize.width/2, winSize.height-closeSize.height/2)  --关闭按钮
          self.tab                        : setPosition(20,winSize.height-40)
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CTreasureHouseInfoView.init(self, _winSize, _layer)
    -- self : loadResources()                    --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CTreasureHouseInfoView.initParameter(self)
    --mediator注册
    print("CTreasureHouseInfoView.mediatorRegister 68")
     _G.g_CTreasureHouseInfoViewMediator = CTreasureHouseInfoViewMediator (self)
     controller :registerMediator(  _G.g_CTreasureHouseInfoViewMediator )
end

function CTreasureHouseInfoView.initView(self,_winSize,_layer)
    self.BackContainer = CContainer : create()
    _layer             : addChild(self.BackContainer)

    --底图
    local IpadSize =854
    self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    _layer : addChild(self.m_allBackGroundSprite,-1)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    --self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.height/3*4,_winSize.height))  
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,_winSize.height)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite)  

    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)       
    self.m_allSecondBackGroundSprite   : setPosition(IpadSize/2,_winSize.height/2) 
    --关闭按钮
    local function closeBtnCallBack(eventType, obj, x, y)
       return self : closeLayer_CallBack(eventType,obj,x,y)
    end
    self.CloseBtn               = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn               : setTouchesPriority(-20) 
    self.CloseBtn               : registerControlScriptHandler(closeBtnCallBack)
    self.BackContainer          : addChild (self.CloseBtn,100)

    local function PageCallBack(eventType, obj, x, y)
       return self : Page_CallBack(eventType,obj,x,y)
    end
    ---------Tab-------
    --珍宝页面
    self.TreasureHousePage       = CTabPage : createWithSpriteFrameName("珍宝","general_label_normal.png","珍宝","general_label_click.png")
    self.TreasureHousePage       : setTouchesPriority(-10)
    self.TreasureHousePage       : setFontSize(24)
    self.TreasureHousePage       : setTag (CTreasureHouseInfoView.TAG_TreasureHousePage)
    self.TreasureHousePage       : registerControlScriptHandler(PageCallBack,"MysteriousShopPage Page_CallBack ")
    local TreasureHousePageContainer = CContainer : create()
    TreasureHousePageContainer : setControlName( "this is CTreasureHouseInfoView m_StrengthenPageContainer 77" )

    self.TreasureHouse = CTreasureHouseScene() --初始化
    TreasureHouseLayer = self.TreasureHouse :layer()
    TreasureHouseLayer : setPosition(-45,-590)
    TreasureHousePageContainer : addChild(TreasureHouseLayer) 
    
    -- --道具制作
    -- self.EquipmentManufacturePage       = CTabPage : createWithSpriteFrameName("道具制作","general_label_normal.png","道具制作","general_label_click.png")
    -- self.EquipmentManufacturePage       : setTouchesPriority(-10)
    -- self.EquipmentManufacturePage       : setFontSize(24)
    -- self.EquipmentManufacturePage       : setTag (CTreasureHouseInfoView.TAG_EquipmentManufacturePage)
    -- self.EquipmentManufacturePage       : registerControlScriptHandler(PageCallBack)
    -- local EquipmentManufacturePageContainer = CContainer : create()
    -- EquipmentManufacturePageContainer : setControlName( "this is CTreasureHouseInfoView m_GemInlayPageContainer 95" )

    -- self.CEquipmentManufactureLayer   = CEquipmentManufactureLayer() --初始化
    -- EquipmentManufactureLayer         = self.CEquipmentManufactureLayer : layer()
    -- EquipmentManufactureLayer         : setPosition(-45,-590)
    -- EquipmentManufacturePageContainer : addChild(EquipmentManufactureLayer)

    --神秘商店页面
    self.MysteriousShopPage       = CTabPage : createWithSpriteFrameName("神秘商店","general_label_normal.png","神秘商店","general_label_click.png")
    self.MysteriousShopPage       : setTouchesPriority(-10)   
    self.MysteriousShopPage       : setFontSize(24)
    self.MysteriousShopPage       : setTag (CTreasureHouseInfoView.TAG_MysteriousShopPage)
    self.MysteriousShopPage       : registerControlScriptHandler(PageCallBack,"MysteriousShopPage Page_CallBack ")
    local MysteriousShopPageContainer = CContainer : create()
    MysteriousShopPageContainer       : setControlName( "this is CTreasureHouseInfoView m_EnchantsPageContainer 126" )

    self.MysteriousShop          = CMysteriousShopLayer()
    self.MysteriousShopLayer     = self.MysteriousShop :layer()
    self.MysteriousShopLayer     : setPosition(-45,-590)
    MysteriousShopPageContainer  : addChild(self.MysteriousShopLayer)

    --Tab
    self.tab = CTab : create (eLD_Horizontal, CCSizeMake(self.IpadSize/2*0.3044,640/2*0.1875))--按钮间距
    --self.tab : setPosition(self.IpadSize/2*0.0472,640/2*1.828125+40)
    self.BackContainer : addChild (self.tab)

    self.tab : addTab(self.TreasureHousePage,TreasureHousePageContainer)
    self.tab : addTab(self.MysteriousShopPage,MysteriousShopPageContainer)
    --self.tab : addTab(self.EquipmentManufacturePage,EquipmentManufacturePageContainer)


    self.tab : onTabChange(self.TreasureHousePage) --默认页面
    -- self.Strengthen : mediatorRegister()        --默认页面的mediator注册
    -- print("默认强化系统页面的mediator注册 143")
end

function CTreasureHouseInfoView.chuangePageByType( self, _type )
    if _type == CTreasureHouseInfoView.TAG_TreasureHousePage then
        self.tab : onTabChange(self.TreasureHousePage)
    elseif _type == CTreasureHouseInfoView.TAG_MysteriousShopPage then
        self.tab : onTabChange(self.MysteriousShopPage)
    end
end

function CTreasureHouseInfoView.closeLayer_CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        self : allunregisterMediator()
        _G.g_PopupView :reset()
        self : unloadResources()
        _G.g_CTreasureHouseInfoView = nil

        self.TreasureHouse  : RemoveAllCCBI()                --删除显示界面的ccbi
        self.MysteriousShop :  removeGoodsBtnSpriteBtnCCBI() --删除商店ccbi

        return    CCDirector : sharedDirector () : popScene()
    end
end

function CTreasureHouseInfoView.Page_CallBack(self,eventType,obj,x,y)   --Page页面按钮回调
    print("页面按钮回调11")
     _G.g_PopupView :reset()
   if eventType == "TouchBegan" then
       -- local  pageTag = obj : getTag()
        -- if pageTag == CTreasureHouseInfoView.TAG_EquipmentManufacturePage then
        --     print("TAG_EquipmentManufacturePageTAG_EquipmentManufacturePage1")
        --     return false 
        -- end
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        
       -- --self : allunregisterMediator()
        if pageTag == CTreasureHouseInfoView.TAG_TreasureHousePage then
            print("这是珍宝页面")
            --self.CEquipmentManufactureLayer : removeIconResources()

            self.MysteriousShop :  removeGoodsBtnSpriteBtnCCBI() --删除商店ccbi
            self.MysteriousShop :  resetGoodsBtnSpriteBtnCCBI()  --重置背景 商店ccbi
        elseif pageTag == CTreasureHouseInfoView.TAG_MysteriousShopPage then
            print("这是神秘商店页面")
            --self.CEquipmentManufactureLayer : removeIconResources()

        end
    end
end

function CTreasureHouseInfoView.allunregisterMediator(self)

        if _G.g_CTreasureHouseInfoViewMediator ~= nil then
            controller : unregisterMediator(_G.g_CTreasureHouseInfoViewMediator)
            _G.g_CTreasureHouseInfoViewMediator = nil
        end

        if _G.g_MysteriousShopMediator ~= nil then
            controller :unregisterMediator(_G.g_MysteriousShopMediator)
            _G.g_MysteriousShopMediator = nil
            print("unregisterMediator.g_MysteriousShopMediator")
        end

        if _G.g_CTreasureHouseMediator ~= nil then
            controller : unregisterMediator(_G.g_CTreasureHouseMediator)
            _G.g_CTreasureHouseMediator = nil
        end
        
        if _G.g_EquipmentManufactureMediator ~= nil then
            controller : unregisterMediator(_G.g_EquipmentManufactureMediator)
            _G.g_EquipmentManufactureMediator = nil
        end
end

function CTreasureHouseInfoView.OpenEquipmentManufacturePage(self,_data) -- _data 装备信息
    --self.tab : onTabChange(self.EquipmentManufacturePage)
    self.tab : setSelectedTabIndex(2)
    --self.CEquipmentManufactureLayer : pushData(_data)
end

-- function CTreasureHouseInfoView.OpenTreasureHousePage(self)
--     self.tab : onTabChange(self.TreasureHousePage)
-- end

function CTreasureHouseInfoView.OpenMysteriousShopPage(self) 
    self.tab : onTabChange(self.MysteriousShopPage)
end

function CTreasureHouseInfoView.releaseAllResources(self)  --在合成界面发送过来的清理所有资源命令
    self : allunregisterMediator()
    _G.g_PopupView :reset()
    self : unloadResources()

    _G.g_CTreasureHouseInfoView = nil
    return    CCDirector : sharedDirector () : popScene()
end











