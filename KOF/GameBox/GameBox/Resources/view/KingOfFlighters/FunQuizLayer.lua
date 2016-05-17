
require "controller/command"

require "view/view"

require "mediator/FunQuizLayerMediator"

CFunQuizLayer = class(view,function (self)
                          end)

CFunQuizLayer.TAG_BetBtn   = 500
CFunQuizLayer.TAG_CloseBtn = 600

function CFunQuizLayer.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene    : addChild(self.Scenelayer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CFunQuizLayer.layer(self,_winSize)
    
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CFunQuizLayer.loadResources(self)
    
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KingOfFlightersResource/KingOfFlighters.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist")
end

function CFunQuizLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

          self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)      --总底图
          self.m_allSecondBackGroundSprite : setPosition(IpadSize/2,640/2) 
          self.m_upBackGroundSprite        : setPosition(IpadSize/2,520-25)
          self.m_downBackGroundSprite      : setPosition(IpadSize/2,220-30)
          self.BackContainer               : setPosition(winSize.width/2-IpadSize/2,0)  
          local closeSize                  = self.CloseBtn: getContentSize()
          self.CloseBtn                    : setPosition(IpadSize-closeSize.width/2, winSize.height-closeSize.height/2)  --关闭按钮
        
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CFunQuizLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CFunQuizLayer.initParameter(self)
    self : registerMediator()    --mediator注册
    self : REQ_WRESTLE_CONNET () --断线重连
end

function CFunQuizLayer.initView(self,_winSize,_layer)
    self.BackContainer = CContainer : create()
    _layer             : addChild(self.BackContainer)

    --底图
    local IpadSize =854
    self.m_allBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("peneral_background.jpg") --总底图
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(_winSize.width,_winSize.height))  
    _layer : addChild(self.m_allBackGroundSprite,-1)    

    self.m_allSecondBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_first_underframe.png") --第二底图
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,_winSize.height)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite,-2)  
 
    self.m_upBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --第二底图
    self.m_upBackGroundSprite   : setPreferredSize(CCSizeMake(820,250))
    self.BackContainer          : addChild(self.m_upBackGroundSprite,-1)
    
    self.m_downBackGroundSprite   = CCScale9Sprite :createWithSpriteFrameName("general_second_underframe.png") --第二底图
    self.m_downBackGroundSprite   : setPreferredSize(CCSizeMake(820,345))
    self.BackContainer          : addChild(self.m_downBackGroundSprite,-1)

    --关闭按钮
    local function BtnCallBack(eventType, obj, x, y)
       return self : BtnCallBack(eventType,obj,x,y)
    end
    self.CloseBtn               = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn               : setTag(CFunQuizLayer.TAG_CloseBtn)
    self.CloseBtn               : registerControlScriptHandler(BtnCallBack)
    self.BackContainer          : addChild (self.CloseBtn)

    --上部分
    self.PrizePoolSprite      = CSprite : createWithSpriteFrameName("combat_word_hljcbqjc.png")
    self.PrizePoolSprite      : setPosition(130,220)
    self.m_upBackGroundSprite : addChild(self.PrizePoolSprite)

    self.PrizePoolLabel      = CCLabelTTF : create("","Arial",24)
    self.PrizePoolLabel      : setPosition(340,220)
    self.m_upBackGroundSprite : addChild(self.PrizePoolLabel)

    self.NowPetNumLabel      = CCLabelTTF : create("","Arial",18)
    self.NowPetNumLabel      : setColor(ccc3(255,255,0))
    self.NowPetNumLabel      : setPosition(620,220)
    self.m_upBackGroundSprite : addChild(self.NowPetNumLabel)

    self.ChampionSprite       = CSprite : createWithSpriteFrameName("combat_word_gj.png")
    self.ChampionSprite       : setPosition(220,130)
    self.m_upBackGroundSprite : addChild(self.ChampionSprite)

    self.ChampionLabel        = CCLabelTTF : create("","Arial",24)
    self.ChampionLabel        : setPosition(0,0)
    self.ChampionSprite       : addChild(self.ChampionLabel)   

    self.RunnerUpSprite       = CSprite : createWithSpriteFrameName("combat_word_yj.png")
    self.RunnerUpSprite       : setPosition(600,130)
    self.m_upBackGroundSprite : addChild(self.RunnerUpSprite)

    self.RunnerUpLabel        = CCLabelTTF : create("","Arial",24)
    self.RunnerUpLabel        : setPosition(0,0)
    self.RunnerUpSprite       : addChild(self.RunnerUpLabel) 

    self.ExplanationLabel      = CCLabelTTF : create("说明 : 竞猜成功最多可获得20倍奖励,投注后无法取消和更好选手名单","Arial",18)
    self.ExplanationLabel      : setPosition(400,30)
    self.m_upBackGroundSprite  : addChild(self.ExplanationLabel)

    --下部分

    self.BetBtn                  = CButton : createWithSpriteFrameName("下注","general_button_normal.png")
    self.BetBtn                  : setTouchesEnabled( false )
    self.BetBtn                  : setTag(CFunQuizLayer.TAG_BetBtn)
    self.BetBtn                  : registerControlScriptHandler(BtnCallBack,"this is CFunQuizLayer BetBtnCallBack ")
    self.BetBtn                  : setPosition(730,40)
    self.m_downBackGroundSprite  : addChild(self.BetBtn)
end

function CFunQuizLayer.initm_pScrollView(self,_allcount)
    -- local function ChooseSpriteBtnCallBack(eventType, obj, touches)
    --     return self:ChooseSpriteBtnCallBack(eventType, obj, touches)
    -- end  
    local function BtnCallBack(eventType, obj, x, y)
       return self : BtnCallBack(eventType,obj,x,y)
    end
    self.m_pageCount, self.m_lastPageCount = self : getPageAndLastCount(_allcount,4)

    local m_ViewSize      = CCSizeMake(820,260)
    self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    self.m_pScrollView    : setTouchesPriority(1)
    self.m_pScrollView    : setPosition(70,95)
    self.Scenelayer       : addChild(self.m_pScrollView)

    --self.teamerlayout     = {}
    self.TeamerBox        = {} --小伙伴按钮
    self.TeamNameBox      = {}
    self.TeamerImageBox   = {}
    self.TeamerImageHead  = {}
    self.TeamerPowerBox   = {}
    self.TeamerWinBtn     = {}
    self.TeamerRunBtn     = {}    

    self.TeamerLvLabel     = {}  
    self.TeamerNameLabel   = {}  
    self.TeamerPowerLabel  = {}  

    local pageContiner    = {}
    for i = tonumber(self.m_pageCount),1,-1 do
        pageContiner[i]    = CContainer : create()
        pageContiner[i]    : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        --self.m_pScrollView : addPage(pageContiner[i])
       
        self.teamerlayout = CHorizontalLayout : create()
        self.teamerlayout : setPosition(-400,0)
        self.teamerlayout : setLineNodeSum(4)
        self.teamerlayout : setCellSize(CCSizeMake(200,250))
        self.teamerlayout : setVerticalDirection(false)
        pageContiner[i]   : addChild(self.teamerlayout,10)
        local tempnum = 1
        if i == tonumber(self.m_pageCount) then
            tempnum = tonumber(self.m_lastPageCount)
        else
            tempnum = 4
        end
        for j=1,tempnum do
            num = (i-1)*4 +j 
            self.TeamerBox[num] = CSprite : createWithSpriteFrameName("general_underframe_normal.png")
            self.TeamerBox[num] : setPreferredSize(CCSizeMake(190,250))        
            self.teamerlayout   : addChild( self.TeamerBox[num] ) 

            ---------------------------------------------------------------------------------------
            self.TeamNameBox[num]    = CSprite : createWithSpriteFrameName("arena_name_frame.png")
            self.TeamerImageBox[num] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
            self.TeamerPowerBox[num] = CSprite : createWithSpriteFrameName("combat_word_zl.png")
            self.TeamerWinBtn[num]   = CSprite : createWithSpriteFrameName("general_choose_02.png")
            self.TeamerRunBtn[num]   = CSprite : createWithSpriteFrameName("general_choose_02.png")

            self.TeamerWinBtn[num]   : setTag(num)
            self.TeamerRunBtn[num]   : setTag(num+50)    
            self.TeamerWinBtn[num]   : setTouchesEnabled( true)
            self.TeamerRunBtn[num]   : setTouchesEnabled( true) 
            -- self.TeamerWinBtn[num]   : setTouchesMode( kCCTouchesAllAtOnce )
            -- self.TeamerRunBtn[num]   : setTouchesMode( kCCTouchesAllAtOnce )
            self.TeamerWinBtn[num]   : registerControlScriptHandler (BtnCallBack,"GoodsBtnSpriteBtn CallBack")
            self.TeamerRunBtn[num]   : registerControlScriptHandler (BtnCallBack,"GoodsBtnSpriteBtn CallBack")     

            self.TeamerLvLabel[num]     = CCLabelTTF : create(num,"Arial",18)
            self.TeamerNameLabel[num]   = CCLabelTTF : create("有钱土豪大人","Arial",18)
            self.TeamerPowerLabel[num]  = CCLabelTTF : create("9999999","Arial",18)
            local WinBtnLabel           = CCLabelTTF : create("冠军","Arial",18)
            local RunBtnLabel           = CCLabelTTF : create("亚军","Arial",18)
            self.TeamerPowerLabel[num]  : setColor(ccc3(255,255,0))
            self.TeamerNameLabel[num]   : setAnchorPoint( ccp( 0,0.5 ) )


            self.TeamNameBox[num]    : setPosition(0,110) 
            self.TeamerImageBox[num] : setPosition(0,35) 
            self.TeamerPowerBox[num] : setPosition(0,-40) 
            self.TeamerWinBtn[num]   : setPosition(-65,-90) 
            self.TeamerRunBtn[num]   : setPosition(20,-90) 
            self.TeamerLvLabel[num]     : setPosition(-60,0) 
            self.TeamerNameLabel[num]   : setPosition(-35,0) 
            self.TeamerPowerLabel[num]  : setPosition(25,0) 
            WinBtnLabel                 : setPosition(40,0) 
            RunBtnLabel                 : setPosition(40,0) 

            self.TeamerBox[num]      : addChild( self.TeamNameBox[num] )                 
            self.TeamerBox[num]      : addChild( self.TeamerImageBox[num] ) 
            self.TeamerBox[num]      : addChild( self.TeamerPowerBox[num] ) 
            self.TeamerBox[num]      : addChild( self.TeamerWinBtn[num] ) 
            self.TeamerBox[num]      : addChild( self.TeamerRunBtn[num] ) 
            self.TeamNameBox[num]      : addChild( self.TeamerLvLabel[num] ) 
            self.TeamNameBox[num]      : addChild( self.TeamerNameLabel[num] ) 
            self.TeamerPowerBox[num]   : addChild( self.TeamerPowerLabel[num] ) 
            self.TeamerWinBtn[num]     : addChild( WinBtnLabel ) 
            self.TeamerRunBtn[num]     : addChild( RunBtnLabel ) 
        end

    end
    for k = 1,tonumber(self.m_pageCount) do
        self.m_pScrollView : addPage(pageContiner[k])  
    end
end

function CFunQuizLayer.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("ccccccccccc", pageCount, lastPageCount)
    return pageCount,lastPageCount
end


function CFunQuizLayer.BtnCallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local value = tonumber(obj :getTag()) 
        print("button回调",value)
        if value == CFunQuizLayer.TAG_BetBtn then
            print("下注回调")

            if self.theuid1 ~= nil and self.theuid2 ~= nil then
               if tonumber(self.theuid2) == tonumber(self.theuid1) then
                    return
                else
                    print("没有这个冠军人物",self.theuid1,self.theuid2)
                    require "view/KingOfFlighters/AddAndReduceBox"
                    self.ARBox = CAddAndReduceBox() --初始化
                    TheARBox = self.ARBox : create(nil,nil,self.theuid1,self.theuid2)
                    TheARBox : setPosition(-20,0)
                    self.Scenelayer : addChild(TheARBox) 
                    --self : REQ_WRESTLE_GUESS(self.theuid1,self.theuid2)
                end
            end

        elseif value == CFunQuizLayer.TAG_CloseBtn then
            print("关闭按钮回调")
            return  CCDirector : sharedDirector () : popScene()
        end

        if self.icount ~= nil then
            for i=1,self.icount do
                if i == value then
                    print("左边冠军按钮")
                    if self.Player ~= nil then
                        self.theuid1 = self.Player[i].uid 
                    end
                    if  self.theuid1 ~= nil and self.theuid2 ~= nil then 
                        if tonumber(self.theuid1) == tonumber(self.theuid2) then
                            return
                        end
                    end

                    self : changeBoxSprite(value)
                    self.isBetBtnValue = self.isBetBtnValue + 1
                    self : setBetBtnOK() --判断有勾选了两个才给按
                end
                if i+50 == value then
                    print("右边亚军按钮")
                    if self.Player ~= nil then
                        self.theuid2 = self.Player[i].uid 
                    end
                    if  self.theuid1 ~= nil and self.theuid2 ~= nil then 
                        if tonumber(self.theuid2) == tonumber(self.theuid1) then
                            return
                        end
                    end
                    self : changeBoxSprite(value)
                    self.isBetBtnValue = self.isBetBtnValue + 1
                    self : setBetBtnOK() --判断有勾选了两个才给按
                end
            end
        end
    end
end

function CFunQuizLayer.setBetBtnOK(self)
    if self.isBetBtnValue ~= nil and  self.isBetBtnValue >= 2 then 
        self.BetBtn : setTouchesEnabled( true )
    end
end

function CFunQuizLayer.changeBoxSprite(self,TAG_value)
    if TAG_value < 50 then
        if self.oldTAG_value ~= nil then
           self.TeamerWinBtn[self.oldTAG_value] : setImageWithSpriteFrameName("general_choose_02.png" )
        end
        if self.TeamerWinBtn[TAG_value] ~= nil then
            self.TeamerWinBtn[TAG_value] : setImageWithSpriteFrameName( "general_choose_01.png" )
            self.oldTAG_value         = TAG_value
        end
    elseif TAG_value > 50 then
        if self.oldTAG_value2 ~= nil then
           self.TeamerRunBtn[self.oldTAG_value2-50] : setImageWithSpriteFrameName("general_choose_02.png" )
        end
        if self.TeamerRunBtn[TAG_value-50] ~= nil then
            self.TeamerRunBtn[TAG_value-50] : setImageWithSpriteFrameName( "general_choose_01.png" )
            self.oldTAG_value2         = TAG_value
        end

    end
end

-- --多点触控
-- function CFunQuizLayer.ChooseSpriteBtnCallBack(self, eventType, obj, touches)
--     print("多点触控一下",eventType,obj)
--     if eventType == "TouchesBegan" then
--         local touchesCount = touches:count()
--         for i=1, touchesCount do
--             local touch = touches :at( i - 1 )
--             if obj:getTag() > 0 then
--                 local touchPoint = touch :getLocation()
--                 if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
--                     self.touchID = touch :getID()
--                     self.ChooseSpriteBtnCallBackTag = obj:getTag()
--                     print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)
--                     _G.pDateTime :reset()
--                     self.touchTime = _G.pDateTime:getTotalMilliseconds()
--                     break
--                 end
--             end
--         end
--     elseif eventType == "TouchesEnded" then
--         if self.touchID == nil then
--            return
--         end
 
--         local touchesCount2 = touches:count()
--         for i=1, touchesCount2 do
--             local touch2 = touches :at(i - 1)
--             print("obj: tag",obj:getTag())
--             if touch2:getID() == self.touchID and self.ChooseSpriteBtnCallBackTag == obj:getTag() then
--                 local touch2Point = touch2 :getLocation()
--                 if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
--                     value  = tonumber(obj:getTag())
--                     if self.icount ~= nil then

--                         for i=1,self.icount do
--                             if i == value then
--                                 print("左边冠军按钮")
--                             end
--                             if i+50 == value then
--                                 print("右边亚军按钮")
--                             end
--                         end
--                     end

--                     self.touchID = nil
--                     self.touchTime = nil
--                     self.ChooseSpriteBtnCallBackTag = nil
--                 end
--             end
--         end
--     end
-- end

function CFunQuizLayer.pushData(self,Msg) --not from sever
    self.Msg    = Msg
    self.Player,self.icount = self : getPlayerData  (Msg) --获取参选选手    
    print("CFunQuizLayer.pushData",self.Player,self.icount)
    if self.icount ~= nil and self.icount > 0 then
        self : initm_pScrollView(self.icount) --初始话ScrollView
    end 

    self : initScrollViewData (self.Player,self.icount )    --初始化选手面板

    self.isBetBtnValue = 0 
end

function CFunQuizLayer.initScrollViewData( self,Player,icount)
    if Player ~= nil and icount ~= nil and icount > 0  then
       for i=1,icount do
            self.TeamerNameLabel[i]  : setString(Player[i].name)
            self.TeamerPowerLabel[i] : setString(Player[i].power)

            -- self.TeamerImageHead[i] = CSprite : createWithSpriteFrameName("general_role_head_frame_normal.png")
            -- pro

       end
    end
end

function CFunQuizLayer.getPlayerData( self,Msg )
    local PlayerMsg = {}
    local icount = 0 
    if Msg ~= nil then
        local count  = #Msg
        if count > 0 then
            for i=1,count do
                icount = icount + 1
                PlayerMsg[icount] = {}
                PlayerMsg[icount].name  = Msg[i].name
                PlayerMsg[icount].uid   = Msg[i].uid
                PlayerMsg[icount].pro   = Msg[i].pro
                PlayerMsg[icount].power = Msg[i].power                
            end
        end
    end
    return PlayerMsg,icount
end

--mediator 注册
function CFunQuizLayer.registerMediator(self)
    print("CBottomHalfLayer.mediatorRegister 75")
    _G.g_CFunQuizLayerMediator = CFunQuizLayerMediator (self)
    controller :registerMediator(  _G.g_CFunQuizLayerMediator )
end
--协议发送
function CFunQuizLayer.REQ_WRESTLE_CONNET(self) -- [54890]欢乐竞猜 -- 格斗之王
    require "common/protocol/auto/REQ_WRESTLE_CONNET" 
    local msg = REQ_WRESTLE_CONNET()
    CNetwork  : send(msg)
    print("REQ_WRESTLE_CONNET -- [54892]断线重连 -- 格斗之王    发送完毕 ")
end
--协议返回
function CFunQuizLayer.NetWorkReturn_WRESTLE_GUESS_STATE(self,State,Name1,Name2,Rmb)
    if State ~= nil and State == 0 then
        print("竞猜失败")
    elseif State ~= nil and State == 1 then
        print("竞猜成功")
    end
    self.NowPetNumLabel : setString("当前下注数量 : "..Rmb.."钻石")
    if Name1 ~= nil then
        self.ChampionLabel  : setString(Name1)
    end
    if Name2 ~= nil then
        self.RunnerUpLabel  : setString(Name2)  
    end
    if self.BetBtn  ~= nil then
        self.BetBtn : setTouchesEnabled(false)
    end
end

function CFunQuizLayer.NetWorkReturn_WRESTLE_PEBBLE(self,Pebble)
    if Pebble ~= nil then
        self.PrizePoolLabel : setString(Pebble.."竞技水晶")
    end

end

















