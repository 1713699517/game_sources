
require "controller/command"

require "view/view"
require "view/Shikigami/FamiliarLayer"
require "view/Shikigami/IllusionLayer"


CShikigamiInfoView = class(view,function (self)
                          end)

CShikigamiInfoView.TAG_FamiliarPage   = 1
CShikigamiInfoView.TAG_IllusionPage   = 2

function CShikigamiInfoView.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CShikigamiInfoView.layer(self,_winSize)
    
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CShikigamiInfoView.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist") --拿世界boss的框框 
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ShikigamiResources/Shikigami.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() : addSpriteFramesWithFile("EquipmentResources/equipSystemResource.plist")  --进度条

    _G.Config:load("config/goods.xml")
    _G.Config:load("config/pet.xml")
    _G.Config:load("config/pet_skill.xml")
    _G.Config:load("config/skill.xml")
end

--释放资源
function CShikigamiInfoView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("WorldBossResources/WorldBossResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ShikigamiResources/Shikigami.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("EquipmentResources/equipSystemResource.plist")

    _G.Config:unload("config/pet.xml")
    _G.Config:unload("config/pet_skill.xml")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CShikigamiInfoView.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

          self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)      --总底图
          local closeSize                  = self.CloseBtn: getContentSize()
          self.CloseBtn                    : setPosition(IpadSize-closeSize.width/2, winSize.height-closeSize.height/2)  --关闭按钮
          self.tab                         : setPosition(20,winSize.height-50)
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CShikigamiInfoView.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
end

function CShikigamiInfoView.initView(self,_winSize,_layer)
    self.BackContainer = CContainer : create()
    _layer             : addChild(self.BackContainer)

    --底图
    local IpadSize =854
    self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    _layer : addChild(self.m_allBackGroundSprite,-1)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,_winSize.height)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite)  

    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)       
    self.m_allSecondBackGroundSprite   : setPosition(IpadSize/2,_winSize.height/2) 
    --关闭按钮
    local function closeBtnCallBack(eventType, obj, x, y)
       return self : closeLayer_CallBack(eventType,obj,x,y)
    end
    self.CloseBtn               = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn               : registerControlScriptHandler(closeBtnCallBack)
    self.BackContainer          : addChild (self.CloseBtn)

    local function PageCallBack(eventType, obj, x, y)
       return self : Page_CallBack(eventType,obj,x,y)
    end
    ---------Tab-------
    --魔宠页面
    self.FamiliarPage       = CTabPage : createWithSpriteFrameName("魔宠","general_label_normal.png","魔宠","general_label_click.png")
    self.FamiliarPage       : setFontSize(24)
    self.FamiliarPage       : setTag (CShikigamiInfoView.TAG_FamiliarPage)
    self.FamiliarPage       : registerControlScriptHandler(PageCallBack)
    local m_FamiliarPageContainer = CContainer : create()
    m_FamiliarPageContainer       : setControlName( "this is CShikigamiInfoView m_FamiliarPageContainer 90" )

    self.Familiar = CFamiliarLayer() --初始化
    FamiliarLayer = self.Familiar : layer()
    FamiliarLayer : setPosition(-50,-590)
    m_FamiliarPageContainer : addChild(FamiliarLayer) 

    --幻化页面
    self.IllusionPage       = CTabPage : createWithSpriteFrameName("幻化","general_label_normal.png","幻化","general_label_click.png")
    self.IllusionPage       : setFontSize(24)
    self.IllusionPage       : setTag (CShikigamiInfoView.TAG_IllusionPage)
    self.IllusionPage       : registerControlScriptHandler(PageCallBack)
    local m_IllusionPageContainer = CContainer : create()
    m_IllusionPageContainer       : setControlName( "this is CShikigamiInfoView m_IllusionPageContainer 103" )
 
    self.CIllusion = CIllusionLayer() --初始化
    IllusionLayer = self.CIllusion :layer()
    IllusionLayer : setPosition(-50,-590)
    m_IllusionPageContainer : addChild(IllusionLayer)


    --Tab
    self.tab = CTab : create (eLD_Horizontal, CCSizeMake(self.IpadSize/2*0.3044,_winSize.height/2*0.1875))--按钮间距
    self.tab : setPosition(self.IpadSize/2*0.0472,_winSize.height/2*1.828125)
    self.BackContainer : addChild (self.tab)

    self.tab : addTab(self.FamiliarPage,m_FamiliarPageContainer)
    self.tab : addTab(self.IllusionPage,m_IllusionPageContainer)


    self.tab : onTabChange(self.FamiliarPage) --默认页面
    -- self.Strengthen : mediatorRegister()        --默认页面的mediator注册
    -- print("默认强化系统页面的mediator注册 143")
end

function CShikigamiInfoView.closeLayer_CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then

        self : allunregisterMediator()
        CCDirector : sharedDirector () : popScene()
        self:unloadResource()
    end
end

function CShikigamiInfoView.Page_CallBack(self,eventType,obj,x,y)   --Page页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        if pageTag == CShikigamiInfoView.TAG_FamiliarPage then
            print("魔宠页面回调")
        elseif pageTag == CShikigamiInfoView.TAG_IllusionPage then
            print("幻化页面回调")
            self.CIllusion : REQ_PET_HUANHUA_REQUEST()
        end

    end
end

function CShikigamiInfoView.allunregisterMediator(self)

        if _G.g_IllusionLayerMediator ~= nil then
            controller :unregisterMediator(_G.g_IllusionLayerMediator)
            _G.g_IllusionLayerMediator = nil
            print("unregisterMediator.g_IllusionLayerMediator")
        end

        if _G.g_FamiliarLayerMediator ~= nil then
            controller :unregisterMediator(_G.g_FamiliarLayerMediator)
            _G.g_FamiliarLayerMediator = nil
            print("unregisterMediator.g_FamiliarLayerMediator")
        end
end


















