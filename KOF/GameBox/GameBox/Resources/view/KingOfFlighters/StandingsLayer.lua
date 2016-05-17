
require "controller/command"

require "view/view"

require "mediator/StandingsLayerMediator"

CStandingsLayer = class(view,function (self)
                          end)

CStandingsLayer.TAG_CallBtn         = 1
CStandingsLayer.TAG_PracticeBtn     = 2
CStandingsLayer.TAG_HighPracticeBtn = 3

CStandingsLayer.CdTime              = 1

function CStandingsLayer.scene(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize    = 854
    self.scene       = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene       : addChild(self.Scenelayer)
    self.scene       : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CStandingsLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CStandingsLayer.loadResources(self)
    _G.Config:load("config/goods.xml")
end

function CStandingsLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_BackGround : setPosition(455,295)    --底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CStandingsLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CStandingsLayer.initParameter(self)
    self : registerMediator()   --mediator注册
   -- self : REQ_WRESTLE_SCORE () --积分榜数据
end

function CStandingsLayer.initView(self,_winSize,_layer)

    self.m_BackGround  = CSprite : createWithSpriteFrameName("general_second_underframe.png") --底图
    self.m_BackGround  : setPreferredSize(CCSizeMake(820,550))
    _layer             : addChild(self.m_BackGround)

    self.HeadLabel    = CCLabelTTF : create("     名次                 参赛者                 胜场数                 负场数                 积分","Arial",24)
    self.HeadLabel    : setColor(ccc4(90,152,225,255))
    self.HeadLabel    : setPosition(435,539)
    _layer            : addChild(self.HeadLabel,100)

    self.HeadSprite   = CSprite : createWithSpriteFrameName("team_titlebar_underframe.png")
    -- self.HeadSprite   : setPosition(420,10)
    self.HeadSprite   : setPosition(435+20,539-4)
    self.HeadSprite   : setPreferredSize(CCSizeMake(818,66))
    _layer            : addChild(self.HeadSprite,10)

    self.Layout = CHorizontalLayout : create()
    self.Layout : setControlName("CShopLayer  GoodsLayout ")
    self.Layout : setPosition(55,500)
    self.Layout : setLineNodeSum(1)
    self.Layout : setVerticalDirection(false)
    self.Layout : setCellSize(CCSizeMake(800,60))
    _layer      : addChild( self.Layout)

    self.NoLabel       = {}
    self.NameLabel     = {}
    self.WinCountLabel = {}
    self.LoseLabel     = {}
    self.FractionLabel = {}
    local lineSprite   = {}
    for i=1,8 do
        lineSprite[i] = CButton : createWithSpriteFrameName("","team_dividing_line.png")
        lineSprite[i] : setPreferredSize(CCSizeMake(820,1))
        self.Layout   : addChild(lineSprite[i])

        self.NoLabel[i]       = CCLabelTTF : create("","Arial",24)
        self.NameLabel[i]     = CCLabelTTF : create("","Arial",24)
        self.WinCountLabel[i] = CCLabelTTF : create("","Arial",24)
        self.LoseLabel[i]     = CCLabelTTF : create("","Arial",24)
        self.FractionLabel[i] = CCLabelTTF : create("","Arial",24)

        self.NoLabel[i]       : setPosition(-360,-30)
        self.NameLabel[i]     : setPosition(-190,-30)
        self.WinCountLabel[i] : setPosition(0,-30)
        self.LoseLabel[i]     : setPosition(185,-30)
        self.FractionLabel[i] : setPosition(355,-30)

        lineSprite[i] : addChild(self.NoLabel[i])
        lineSprite[i] : addChild(self.NameLabel[i])
        lineSprite[i] : addChild(self.WinCountLabel[i])
        lineSprite[i] : addChild(self.LoseLabel[i])
        lineSprite[i] : addChild(self.FractionLabel[i])
    end
end


function CStandingsLayer.pushData(self,Count,Msg) --sever methond
    if Count ~= nil and Count > 0 and Msg~= nil   then
        --for i=1,Count do
        for i=Count,1,-1 do
            local no = tonumber (Msg[i].pos)
            print("54818--->",no)
            if no ~= nil and no > 0  then
                self.NoLabel[no]       : setString(Msg[i].pos)
                self.NameLabel[no]     : setString(Msg[i].name)
                self.WinCountLabel[no] : setString(Msg[i].success)
                self.LoseLabel[no]     : setString(Msg[i].fail)
                self.FractionLabel[no] : setString(Msg[i].score)
            end
        end
    end
end

--mediator 注册
function CStandingsLayer.registerMediator(self)
    print("CStandingsLayer.mediatorRegister 75")
    _G.g_StandingsLayerMediator = CStandingsLayerMediator (self)
    controller :registerMediator(  _G.g_StandingsLayerMediator )
end
--协议发送
-- function CStandingsLayer.REQ_WRESTLE_SCORE(self) -- [54815]请求积分榜数据 -- 格斗之王  积分榜页面接收 
--     require "common/protocol/auto/REQ_WRESTLE_SCORE" 
--     local msg = REQ_WRESTLE_SCORE()
--     CNetwork  : send(msg)
--     print("REQ_WRESTLE_SCORE 54815 请求积分榜数据 -- 格斗之王  积分榜页面接收 发送完毕 ")
-- end

--协议返回









