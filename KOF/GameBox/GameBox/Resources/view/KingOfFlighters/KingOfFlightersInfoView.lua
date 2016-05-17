
require "controller/command"

require "view/view"
require "view/KingOfFlighters/MyGameLayer"
require "view/KingOfFlighters/StandingsLayer"
require "view/KingOfFlighters/UpperHalfLayer"
require "view/KingOfFlighters/BottomHalfLayer"
require "view/KingOfFlighters/KingHegemonyLayer"

require "view/KingOfFlighters/FunQuizLayer"

CKingOfFlightersInfoView = class(view,function (self)
                          end)

CKingOfFlightersInfoView.TAG_MyGamePage       = 1
CKingOfFlightersInfoView.TAG_StandingsPage    = 2
CKingOfFlightersInfoView.TAG_UpperHalfPage    = 3
CKingOfFlightersInfoView.TAG_BottomHalfPage   = 4
CKingOfFlightersInfoView.TAG_KingHegemonyPage = 5


function CKingOfFlightersInfoView.getScene(self)
    --self : ServerTimeNetWorkSend()
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层
    return self.scene
end

function CKingOfFlightersInfoView.layer(self,_winSize)

    self.Scenelayer = CContainer :create()
    self : init (_winSize,self.Scenelayer)
    return self.Scenelayer
end

function CKingOfFlightersInfoView.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KingOfFlightersResource/KingOfFlighters.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CKingOfFlightersInfoView.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("KingOfFlightersResource/KingOfFlighters.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CKingOfFlightersInfoView.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

          self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)      --总底图
          local closeSize                  = self.CloseBtn: getContentSize()
          self.CloseBtn                    : setPosition(IpadSize-closeSize.width/2, winSize.height-closeSize.height/2)  --关闭按钮
          self.tab                         : setPosition(25+50,winSize.height-42)
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CKingOfFlightersInfoView.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
end

function CKingOfFlightersInfoView.initView(self,_winSize,_layer)
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
    --我的比赛------------------------------------------------------------------------------------------------------------------------------
    self.MyGamePage       = CTabPage : createWithSpriteFrameName("我的比赛","general_label_normal.png","我的比赛","general_label_click.png")
    self.MyGamePage       : setFontSize(24)
    self.MyGamePage       : setTag (CKingOfFlightersInfoView.TAG_MyGamePage)
    self.MyGamePage       : registerControlScriptHandler(PageCallBack)
    local m_MyGamePageContainer = CContainer : create()
    m_MyGamePageContainer       : setControlName( "this is CKingOfFlightersInfoView m_MyGamePageContainer 90" )

    print("self111111",self)
    self.MyGameLayer = CMyGameLayer() --初始化
    MyGameLayer      = self.MyGameLayer : layer()
    MyGameLayer      : setPosition(-50,-600)
    m_MyGamePageContainer : addChild(MyGameLayer)

    --积分榜 ------------------------------------------------------------------------------------------------------------------------------
    self.StandingsPage       = CTabPage : createWithSpriteFrameName("积分榜","general_label_normal.png","积分榜","general_label_click.png")
    self.StandingsPage       : setFontSize(24)
    self.StandingsPage       : setTag (CKingOfFlightersInfoView.TAG_StandingsPage)
    self.StandingsPage       : registerControlScriptHandler(PageCallBack)
    local m_StandingsPageContainer = CContainer : create()
    m_StandingsPageContainer       : setControlName( "this is CKingOfFlightersInfoView m_StandingsPageContainer 103" )

    self.StandingsLayer = CStandingsLayer() --初始化
    StandingsLayer      = self.StandingsLayer :layer()
    StandingsLayer      : setPosition(-50,-600)
    m_StandingsPageContainer : addChild(StandingsLayer)

    --上半区 ------------------------------------------------------------------------------------------------------------------------------
    self.UpperHalfPage       = CTabPage : createWithSpriteFrameName("上半区","general_label_normal.png","上半区","general_label_click.png")
    self.UpperHalfPage       : setFontSize(24)
    self.UpperHalfPage       : setTag (CKingOfFlightersInfoView.TAG_UpperHalfPage)
    self.UpperHalfPage       : registerControlScriptHandler(PageCallBack)
    local m_UpperHalfPageContainer = CContainer : create()
    m_UpperHalfPageContainer       : setControlName( "this is CKingOfFlightersInfoView m_StandingsPageContainer 103" )

    self.UpperHalfLayer = CUpperHalfLayer() --初始化
    UpperHalfLayer      = self.UpperHalfLayer :layer()
    UpperHalfLayer      : setPosition(-50,-600)
    m_UpperHalfPageContainer : addChild(UpperHalfLayer)

    --下半区 ------------------------------------------------------------------------------------------------------------------------------
    self.BottomHalfPage       = CTabPage : createWithSpriteFrameName("下半区","general_label_normal.png","下半区","general_label_click.png")
    self.BottomHalfPage       : setFontSize(24)
    self.BottomHalfPage       : setTag (CKingOfFlightersInfoView.TAG_BottomHalfPage)
    self.BottomHalfPage       : registerControlScriptHandler(PageCallBack)
    local m_BottomHalfPageContainer = CContainer : create()
    m_BottomHalfPageContainer       : setControlName( "this is CKingOfFlightersInfoView m_StandingsPageContainer 103" )

    self.BottomHalfLayer = CBottomHalfLayer() --初始化
    BottomHalfLayer      = self.BottomHalfLayer :layer()
    BottomHalfLayer      : setPosition(-50,-600)
    m_BottomHalfPageContainer : addChild(BottomHalfLayer)

    --王者争霸------------------------------------------------------------------------------------------------------------------------------
    self.KingHegemonyPage       = CTabPage : createWithSpriteFrameName("王者争霸","general_label_normal.png","王者争霸","general_label_click.png")
    self.KingHegemonyPage       : setFontSize(24)
    self.KingHegemonyPage       : setTag (CKingOfFlightersInfoView.TAG_KingHegemonyPage)
    self.KingHegemonyPage       : registerControlScriptHandler(PageCallBack)
    local m_KingHegemonyPageContainer = CContainer : create()
    m_KingHegemonyPageContainer       : setControlName( "this is CKingOfFlightersInfoView m_StandingsPageContainer 103" )

    self.KingHegemonyLayer = CKingHegemonyLayer() --初始化
    KingHegemonyLayer      = self.KingHegemonyLayer :layer()
    KingHegemonyLayer      : setPosition(-50,-600)
    m_KingHegemonyPageContainer : addChild(KingHegemonyLayer)

    --Tab
    self.tab = CTab : create (eLD_Horizontal, CCSizeMake(self.IpadSize/2*0.3044,_winSize.height/2*0.1875))--按钮间距
    _layer   : addChild (self.tab)

    self.tab : addTab(self.MyGamePage,m_MyGamePageContainer)
    self.tab : addTab(self.StandingsPage,m_StandingsPageContainer)
    self.tab : addTab(self.UpperHalfPage,m_UpperHalfPageContainer)
    self.tab : addTab(self.BottomHalfPage,m_BottomHalfPageContainer)
    self.tab : addTab(self.KingHegemonyPage,m_KingHegemonyPageContainer)

    self.tab : onTabChange(self.MyGamePage) --默认页面
    -- self.Strengthen : mediatorRegister()        --默认页面的mediator注册
    -- print("默认强化系统页面的mediator注册 143")
end

function CKingOfFlightersInfoView.closeLayer_CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        self : REQ_WRESTLE_DROP() ---离开格斗之王面板
        self : allunregisterMediator()
        CCDirector : sharedDirector () : popScene()
        self : unloadResources()

        self : removeScene()
        _G.g_CKingOfFlightersInfoView = nil
    end
end

function CKingOfFlightersInfoView.Page_CallBack(self,eventType,obj,x,y)   --Page页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        if pageTag == CKingOfFlightersInfoView.TAG_MyGamePage then
            print("我的比赛页面回调")
            self : REQ_WRESTLE_BOOK() --我的比赛界面请求
        elseif pageTag == CKingOfFlightersInfoView.TAG_StandingsPage then
            print("积分榜页面回调")
            self : REQ_WRESTLE_SCORE () --积分榜数据
        elseif pageTag == CKingOfFlightersInfoView.TAG_UpperHalfPage then
            print("上分区页面回调")
            self : REQ_WRESTLE_FINAL_REQUEST (0) --决赛入口
        elseif pageTag == CKingOfFlightersInfoView.TAG_BottomHalfPage then
            print("下分区页面回调")
            self : REQ_WRESTLE_FINAL_REQUEST (1) --决赛入口
        elseif pageTag == CKingOfFlightersInfoView.TAG_KingHegemonyPage then
            print("王者争霸页面回调")
             self : REQ_WRESTLE_ZHENGBA () --争霸数据
        end
    end
end

function CKingOfFlightersInfoView.allunregisterMediator(self)

    if _G.g_MyGameLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_MyGameLayerMediator)
        _G.g_MyGameLayerMediator = nil
        print("unregisterMediator.g_MyGameLayerMediator")
    end

    if _G.g_StandingsLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_StandingsLayerMediator)
        _G.g_StandingsLayerMediator = nil
        print("unregisterMediator.g_GemInlayMediator")
    end

    if _G.g_BottomHalfLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_BottomHalfLayerMediator)
        _G.g_BottomHalfLayerMediator = nil
        print("unregisterMediator.g_BottomHalfLayerMediator")
    end

    if _G.g_UpperHalfLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_UpperHalfLayerMediator)
        _G.g_UpperHalfLayerMediator = nil
        print("unregisterMediator.g_UpperHalfLayerMediator")
    end

    if _G.g_KingHegemonyLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_KingHegemonyLayerMediator)
        _G.g_KingHegemonyLayerMediator = nil
        print("unregisterMediator.g_KingHegemonyLayerMediator")
    end

end


function CKingOfFlightersInfoView.pushData(self,Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail) --sever methond
    print("self2222",self)
    self.MyGameLayer : pushData(Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail)
end


function CKingOfFlightersInfoView.removeScene(self)
    print("4454545",self,self.MyGameLayer)
    self.MyGameLayer       : removeCCBI()
    self.KingHegemonyLayer : removeCCBI()
    --self.KingHegemonyLayer : removeCCBI()
    self.Scenelayer        : removeFromParentAndCleanup(true)
    print("6656565")
end

---协议发送
function CKingOfFlightersInfoView.REQ_WRESTLE_DROP(self)
    require "common/protocol/auto/REQ_WRESTLE_DROP"
    local msg = REQ_WRESTLE_DROP()
    CNetwork  : send(msg)
    print("REQ_WRESTLE_DROP -- [54830]离开格斗之王面板 -- 格斗之王 ")
end

function CKingOfFlightersInfoView.REQ_WRESTLE_BOOK(self)
    require "common/protocol/auto/REQ_WRESTLE_BOOK"
    local msg = REQ_WRESTLE_BOOK()
    CNetwork  : send(msg)
    print("REQ_WRESTLE_BOOK 54801 发送完毕 ")
end

function CKingOfFlightersInfoView.REQ_WRESTLE_SCORE(self) -- [54815]请求积分榜数据 -- 格斗之王  积分榜页面接收
    require "common/protocol/auto/REQ_WRESTLE_SCORE"
    local msg = REQ_WRESTLE_SCORE()
    CNetwork  : send(msg)
    print("REQ_WRESTLE_SCORE 54815 请求积分榜数据 -- 格斗之王  积分榜页面接收 发送完毕 ")
end

function CKingOfFlightersInfoView.REQ_WRESTLE_FINAL_REQUEST(self,value) -- [54850]请求下半区数据 -- 格斗之王  决赛入口
    require "common/protocol/auto/REQ_WRESTLE_FINAL_REQUEST"
    local msg = REQ_WRESTLE_FINAL_REQUEST()
    msg : setType(value)
    CNetwork  : send(msg)
    print("REQ_WRESTLE_FINAL_REQUEST 54850 决赛入口 -- 格斗之王   发送完毕 ")
end

function CKingOfFlightersInfoView.REQ_WRESTLE_ZHENGBA(self) -- [54815]请求积分榜数据 -- 格斗之王  积分榜页面接收
    require "common/protocol/auto/REQ_WRESTLE_ZHENGBA"
    local msg = REQ_WRESTLE_ZHENGBA()
    CNetwork  : send(msg)
    print("REQ_WRESTLE_ZHENGBA -- [54910]王者争霸入口 -- 格斗之王 发送完毕 ")
end

-- function CKingOfFlightersInfoView.ServerTimeNetWorkSend( self )
--     require "common/protocol/auto/REQ_SYSTEM_HEART"
--     local req = REQ_SYSTEM_HEART()
--     CNetwork:send(req)
-- end


