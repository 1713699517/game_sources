require "controller/command"
require "view/view"


require "mediator/TreasureQuestViewMediator"




CTreasureQuestView = class(view,function (self)
                            self.Count = 0

                            end)

CTreasureQuestView.BtnTag_CLOSE    = 1 --关闭按钮
CTreasureQuestView.BtnTag_PROP     = 2 --道具抽奖按钮
CTreasureQuestView.BtnTag_DIAMONDS = 3 --钻石抽奖按钮

CTreasureQuestView.PropBtnValue    = 10
CTreasureQuestView.DiamondBtnValue = 100

function CTreasureQuestView.scene(self)

    self.scene    = CCScene :create()
    self.scene    : addChild(self : layer()) --scene的layer层

    return self.scene
end

function CTreasureQuestView.layer(self)

    self.Scenelayer    = CContainer :create()
    self               : init (self.Scenelayer)

    return self.Scenelayer
end

function CTreasureQuestView.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TreasureQuestResource/TreasureQuestResource.plist")



    _G.Config:load("config/goods.xml")
    _G.Config:load("config/discove_store.xml")
end

function CTreasureQuestView.unloadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TreasureQuestResource/TreasureQuestResource.plist")
    CCTextureCache     :sharedTextureCache()    :removeTextureForKey("TreasureQuestResource/TreasureQuestResource.pvr.ccz")

end

function CTreasureQuestView.layout(self)  --适配布局
    local winSize        = CCDirector:sharedDirector():getVisibleSize()
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   


    self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)              --大背景图
    self.m_allSecondBackGroundSprite : setPosition(IpadSizeWidth/2,IpadSizeheight/2)              --背景框架图

    self.BackGroundSprite_Info       : setPosition(IpadSizeWidth/2-270,400)  --说明底图
    self.BackGroundSprite_Wins       : setPosition(IpadSizeWidth/2+140,400)  --抽奖底图
    self.BackGroundSprite_Good       : setPosition(IpadSizeWidth/2,90)  --可获得奖品底图


    local closeSize                  = self.CloseBtn: getContentSize()
    self.CloseBtn                    : setPosition(IpadSizeWidth-closeSize.width/2, IpadSizeheight-closeSize.height/2)  --关闭按钮


end

function CTreasureQuestView.initParameter(self)
    --mediator注册
    _G.g_TreasureQuestViewMediator = CTreasureQuestViewMediator (self)
    controller : registerMediator(  _G.g_TreasureQuestViewMediator )
    print("CTreasureQuestView.mediatorRegister ")

    self : NetWorkSend() --钥匙数量请求

    self.iconurlList = {} --大奖励图片路径保存
    self.KeyCount    = 0  --钥匙数量初始化 
    self.BtnType     = nil--按钮类型

    --初始化奖品数据
    self : initGoodsData(1)
end

function CTreasureQuestView.init(self, _layer)
    self : loadResources()               --资源初始化
    self : initView(_layer)              --界面初始化
    self : initParameter()               --参数初始化
    self : layout()                      --适配布局初始化
end

function CTreasureQuestView.initView(self,_layer)
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   
    local winSize        = CCDirector:sharedDirector():getVisibleSize()

    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    local function GoodBtnBtnCallBack(eventType, obj, touches)
     return   self:onGoodBtnBtnCallBack(eventType, obj, touches)
    end

    self.BackContainer = CContainer : create()
    self.BackContainer : setPosition(winSize.width/2-IpadSizeWidth/2,0)
    _layer             : addChild(self.BackContainer)

    --大背景图
    self.m_allBackGroundSprite   = CSprite :createWithSpriteFrameName("peneral_background.jpg") 
    self.m_allBackGroundSprite   : setPreferredSize(CCSizeMake(winSize.width,winSize.height))
    _layer :addChild(self.m_allBackGroundSprite,-2)
    --背景框架图
    self.m_allSecondBackGroundSprite   = CSprite :createWithSpriteFrameName("general_first_underframe.png") 
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,640)) 
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite,-1)

    self.BackGroundSprite_Info   = CSprite :createWithSpriteFrameName("general_second_underframe.png")  --说明底图
    self.BackGroundSprite_Wins   = CSprite :createWithSpriteFrameName("general_second_underframe.png")  --抽奖底图
    self.BackGroundSprite_Good   = CSprite :createWithSpriteFrameName("general_second_underframe.png")  --可获得奖品底图

    self.BackGroundSprite_Info   : setPreferredSize(CCSizeMake(280,460)) 
    self.BackGroundSprite_Wins   : setPreferredSize(CCSizeMake(530,460)) 
    self.BackGroundSprite_Good   : setPreferredSize(CCSizeMake(820,150)) 

    self.BackContainer : addChild(self.BackGroundSprite_Info)   
    self.BackContainer : addChild(self.BackGroundSprite_Wins)
    self.BackContainer : addChild(self.BackGroundSprite_Good)

    --关闭按钮
    self.CloseBtn         = CButton : createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn         : setTag(CTreasureQuestView.BtnTag_CLOSE)
    self.CloseBtn         : registerControlScriptHandler(CallBack,"this CTreasureQuestView CloseBtnCallBack 83")
    self.BackContainer    : addChild (self.CloseBtn)

    --说明模块
    self.InfoSprite  = CSprite : createWithSpriteFrameName("draw_word_yxsm.png") 
    self.InfoSprite  : setPosition(0,200)
    self.BackGroundSprite_Info : addChild(self.InfoSprite)

    self.ExplanationLayout     = CHorizontalLayout : create()
    self.ExplanationLayout     : setLineNodeSum(1)
    self.ExplanationLayout     : setVerticalDirection(false)
    self.ExplanationLayout     : setCellSize(CCSizeMake(280,140))
    self.ExplanationLayout     : setPosition(-260,50)
    self.BackGroundSprite_Info : addChild(self.ExplanationLayout)



    self.ExplanationLabel = {} --1条条游戏说明
    for i=1,3 do
        self.ExplanationLabel[i] = CCLabelTTF :create("","Arial",20) 
        self.ExplanationLabel[i] : setAnchorPoint( ccp(0.0, 0.5)) 
        self.ExplanationLabel[i] : setDimensions( CCSizeMake(250,150))          --设置文字区
        self.ExplanationLabel[i] : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐
        self.ExplanationLayout   : addChild(self.ExplanationLabel[i])
    end

    --抽奖模块
    self.WinsBackSprite_draw       = CSprite : createWithSpriteFrameName("draw_background.png")      --蓝底
    --self.WinsBackSprite_draw_shade = CSprite : create("TreasureQuestResource/draw_shade.png")           --圆形底
    self.WinsBackSprite_draw_shade = CSprite : createWithSpriteFrameName("draw_shade.png")           --圆形底
    self.WinsBackSprite_peole      = CSprite : createWithSpriteFrameName("draw_peole.png")           --人物
    self.WinsBackSprite_getprize   = CSprite : createWithSpriteFrameName("draw_word_hdjp.png")       --获得奖品
    self.WinsBackSprite_prizeback  = CSprite : createWithSpriteFrameName("general_equip_frame.png")  --奖品底图

    self.WinsBackSprite_draw        : setPosition(-1,0)
    self.WinsBackSprite_draw_shade  : setPosition(30+100,30)
    self.WinsBackSprite_peole       : setPosition(90 ,0)
    self.WinsBackSprite_getprize    : setPosition(-160 ,150)
    self.WinsBackSprite_prizeback   : setPosition(-130 ,35)

    self.BackGroundSprite_Wins      : addChild(self.WinsBackSprite_draw,2)
    self.BackGroundSprite_Wins      : addChild(self.WinsBackSprite_draw_shade,3)
    self.BackGroundSprite_Wins      : addChild(self.WinsBackSprite_peole,4)
    self.BackGroundSprite_Wins      : addChild(self.WinsBackSprite_getprize,5)
    self.BackGroundSprite_Wins      : addChild(self.WinsBackSprite_prizeback,6)

    --获奖物品
    self.PrizeBtn    = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
    self.PrizeBtn    : setTouchesEnabled( true)
    self.PrizeBtn    : setTouchesMode( kCCTouchesAllAtOnce )
    self.PrizeBtn    : registerControlScriptHandler(GoodBtnBtnCallBack,"this CTreasureQuestView self.GoodBtn[i] ")
    self.PrizeBtn    : setPosition(0,0)
    self.WinsBackSprite_prizeback : addChild(self.PrizeBtn,6)

    self.PrizeCountLabel = CCLabelTTF : create("","Arial",18)
    self.PrizeCountLabel : setPosition(25,-30)
    self.PrizeBtn        : addChild(self.PrizeCountLabel,10)

    --道具抽奖按钮
    self.PropBtn               = CButton : createWithSpriteFrameName("","general_button_click.png")
    self.PropBtn               : setTag(CTreasureQuestView.BtnTag_PROP)
    self.PropBtn               : registerControlScriptHandler(CallBack,"this CTreasureQuestView PropBtn ")
    self.PropBtn               : setPosition(-130,-65)
    self.BackGroundSprite_Wins : addChild (self.PropBtn,6)

    local PropBtnSprite = CSprite : createWithSpriteFrameName("draw_key.png")
    local PropBtnLabel  = CCLabelTTF : create("x10 兑换","Arial",18)
    PropBtnSprite       : setPosition(-40,0)
    PropBtnLabel        : setPosition(15,0)
    self.PropBtn        : addChild(PropBtnSprite,5)
    self.PropBtn        : addChild(PropBtnLabel,5)

    --钻石抽奖按钮
    self.DiamondBtn               = CButton : createWithSpriteFrameName("","general_button_click.png")
    self.DiamondBtn               : setTag(CTreasureQuestView.BtnTag_DIAMONDS)
    self.DiamondBtn               : registerControlScriptHandler(CallBack,"this CTreasureQuestView DiamondBtn ")
    self.DiamondBtn               : setPosition(-130,-135)
    self.BackGroundSprite_Wins : addChild (self.DiamondBtn,6)

    local DiamondBtnSprite = CSprite : createWithSpriteFrameName("draw_key.png")
    local DiamondBtnLabel  = CCLabelTTF : create("x100 兑换","Arial",18)
    DiamondBtnSprite       : setPosition(-40,0)
    DiamondBtnLabel        : setPosition(15,0)
    self.DiamondBtn        : addChild(DiamondBtnSprite,5)
    self.DiamondBtn        : addChild(DiamondBtnLabel,5)

    --剩余钥匙数量 道具数量
    self.KeyCountLabel      = CCLabelTTF : create("88888 ","Arial",18)
    self.KeyCountSprite     = CSprite : createWithSpriteFrameName("draw_key.png")
    self.DiamondCountLabel  = CCLabelTTF : create("9999 ","Arial",18)  
    self.DiamondCountSprite = CSprite : createWithSpriteFrameName("menu_icon_diamond.png")

    self.KeyCountSprite     : setPosition(-160,-200)
    self.KeyCountLabel      : setPosition(20,0)
    self.DiamondCountSprite : setPosition(-50,-200)
    self.DiamondCountLabel  : setPosition(20,0)

    self.KeyCountLabel     : setAnchorPoint( ccp(0.0, 0.5)) 
    self.DiamondCountLabel : setAnchorPoint( ccp(0.0, 0.5)) 

    self.BackGroundSprite_Wins : addChild (self.KeyCountSprite,6)
    self.KeyCountSprite        : addChild(self.KeyCountLabel)
    self.BackGroundSprite_Wins : addChild (self.DiamondCountSprite,6) 
    self.DiamondCountSprite    : addChild(self.DiamondCountLabel)


    --可获得奖品模块
    self.GoodLabel = CCLabelTTF : create("大奖展示 : ","Arial",18)
    self.GoodLabel : setPosition(-330 ,50)
    self.BackGroundSprite_Good : addChild(self.GoodLabel)

    self.GoodBtnLayout     = CHorizontalLayout : create()
    self.GoodBtnLayout     : setLineNodeSum(7)
    self.GoodBtnLayout     : setVerticalDirection(false)
    self.GoodBtnLayout     : setCellSize(CCSizeMake(110+2,95))
    self.GoodBtnLayout     : setPosition(-400+10,-10)
    self.BackGroundSprite_Good : addChild(self.GoodBtnLayout)

    self.GoodBtn = {} --奖品按钮
    for i=1,7 do
        self.GoodBtn[i]    =  CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
        self.GoodBtn[i]    : setTouchesEnabled( true)
        self.GoodBtn[i]    : setTouchesMode( kCCTouchesAllAtOnce )
        self.GoodBtn[i]    : registerControlScriptHandler(GoodBtnBtnCallBack,"this CTreasureQuestView self.GoodBtn[i] ")
        self.GoodBtnLayout : addChild(self.GoodBtn[i])
    end
end

--多点触控
function CTreasureQuestView.onGoodBtnBtnCallBack(self, eventType, obj, touches)
    

    if eventType == "TouchesBegan" then
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.GoodBtnCallBackId = obj:getTag()
                    break
                end
            end
        end

    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        _G.g_PopupView :reset()
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)

            if touch2:getID() == self.touchID and self.GoodBtnCallBackId == obj:getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local id = obj:getTag() 

                    _position   = {}
                    _position.x = touch2Point.x
                    _position.y = touch2Point.y
                    if id ~= nil then
                        local  temp =  _G.g_PopupView :createByGoodsId(id, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
                        self.Scenelayer :addChild(temp,10000)
                    end
                    self.GoodBtnCallBackId = nil 
                    self.touchID           = nil
                end
            end
        end
    end
end


function CTreasureQuestView.CallBack(self,eventType,obj,x,y)  --按钮回调
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )      
    elseif eventType == "TouchEnded" then
        _G.g_PopupView :reset()

        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            tagvalue = obj : getTag()

            if tagvalue == CTreasureQuestView.BtnTag_CLOSE  then
                print("关闭按钮回调")

                self : removeCCBI()

                _G.g_unLoadIconSources : unLoadAllIcons(  ) --释放icon

                CCDirector : sharedDirector () : popScene()

            elseif tagvalue == CTreasureQuestView.BtnTag_PROP  then
                print("道具抽奖回调") --X 10
                local Count = self : getKeyCount()
                local msg   = ""
                if Count >=  _G.Constant.CONST_TREASURE_CHEST_TEN then
                    msg = "是否确认兑换？"
                else
                    local DiamondCount  = (_G.Constant.CONST_TREASURE_CHEST_TEN -Count) * _G.Constant.CONST_TREASURE_CHEST_KEY_RMB
                    msg = "道具不足,是否花费"..DiamondCount.."钻石进行兑换？"
                end

                local function fun1()
                    self : setBtnType(_G.Constant.CONST_TREASURE_CHEST_FALSE)
                    self : Imagereplacement()  
                end
                local function fun2()
                    print("不要你了")  
                end
                self : createMessageBox(msg,fun1,fun2)

            elseif tagvalue == CTreasureQuestView.BtnTag_DIAMONDS  then
                print("钻石抽奖按钮")

                local Count = self : getKeyCount()
                local msg   = ""
                if Count >=  _G.Constant.CONST_TREASURE_CHEST_HUNDRED then
                    msg = "是否确认兑换？"
                else
                    local DiamondCount  = (_G.Constant.CONST_TREASURE_CHEST_HUNDRED - Count) * _G.Constant.CONST_TREASURE_CHEST_KEY_RMB
                    msg = "道具不足,是否花费"..DiamondCount.."钻石进行兑换？"
                end

                local function fun1()
                    self : setBtnType(_G.Constant.CONST_TREASURE_CHEST_TRUE)
                    self : Imagereplacement() 
                end
                local function fun2()
                    print("不要你了")    
                end
                self : createMessageBox(msg,fun1,fun2)
            end
        end
    end
end

function CTreasureQuestView.initGoodsData(self,_type)
    local List = {}
    local Node =  _G.Config.discove_stores : selectSingleNode("discove_store[@type="..tostring(_type).."]")

    if Node : isEmpty() ==  true then
        return false
    end

    local Node_child_ids       = Node : children() : get(0,"goods_ids")
    local Node_child_ids_Count = Node_child_ids : children() : getCount("goods_id")

    if Node_child_ids_Count > 0 and Node_child_ids_Count <= 7 then
        for i=1,Node_child_ids_Count do

            local GoodNode = Node_child_ids : children() : get(i-1,"goods_id")
            local GoodId   = GoodNode : getAttribute("goods_id") 
            print("id ==========>>>>",i,GoodId)

            --获取物品图片路径
            local Node =  _G.Config.goodss : selectSingleNode("goods[@id="..tostring(GoodId).."]")
            if Node : isEmpty() ==  true then
                return false
            end
            local icon       = Node : getAttribute("icon")
            local icon_url   = "Icon/i"..icon..".jpg"
            _G.g_unLoadIconSources : addIconData( icon )
            local GoodSprite = CSprite : create(icon_url)
            self.GoodBtn[i]  : addChild(GoodSprite)
            self.GoodBtn[i]  : setTag(GoodId)

            table.insert(List,icon)

        end
        self : setIconurlList(List)

    end

    self.ExplanationLabel[1] : setString("1.宝箱中藏有各种宝物。玩家需要使用宝箱钥匙开启宝箱。宝箱钥匙可以从每日的活跃度中领取。")    
    self.ExplanationLabel[2] : setString("2.宝箱分为两个等级，分别要使用10个钥匙和100个钥匙打开。而高级宝箱开启后获得的宝物也更加的稀有。")
    self.ExplanationLabel[3] : setString("3.当玩家钥匙不够时可以使用钻石开启宝箱。")

    --获得的奖品
    self.PrizeSprite = CSprite : create("Icon/i40181.jpg") 
    _G.g_unLoadIconSources : addIconData( 40181 )
    self.PrizeBtn    : addChild(self.PrizeSprite,-2)
end


function CTreasureQuestView.NetWorkSend(self)
    --向服务器发送页面数据请求
    require "common/protocol/auto/REQ_DISCOVE_STORE_ASK"
    local msg = REQ_DISCOVE_STORE_ASK()  
    CNetwork : send(msg)

    print("CTreasureQuestView NetWorkSend 页面发送数据请求")
end

function CTreasureQuestView.REQ_DISCOVE_STORE_TYPE(self,_type)
    require "common/protocol/auto/REQ_DISCOVE_STORE_TYPE"
    local msg = REQ_DISCOVE_STORE_TYPE()
    msg :setType(_type)    -- [57820]请求类型 -- 宝箱探秘
    CNetwork :send(msg)
    print("物品兑换请求完毕",_type)
end

--mediator传送过来的数据（同时也是初始化）
function CTreasureQuestView.pushData(self,_Count)

    --获取钥匙
    if _Count ~= nil then
        self.KeyCountLabel : setString(_Count)
        self : setKeyCount(_Count)
    end

    --获取钻石
    local mainProperty = _G.g_characterProperty : getMainPlay()
    local money        = tonumber(mainProperty :getBindRmb()) 
    self.DiamondCountLabel : setString(money)
end

--钥匙数量存取
function CTreasureQuestView.setKeyCount( self,_Count )
    self.KeyCount = _Count
end
function CTreasureQuestView.getKeyCount( self )
    return  self.KeyCount 
end
--大奖图路径存取
function CTreasureQuestView.setIconurlList( self,_List )
    self.iconurlList = _List
end
function CTreasureQuestView.getIconurlList( self )
    return  self.iconurlList 
end
--大奖图路径存取
function CTreasureQuestView.setBtnType( self,_type )
    self.BtnType = _type
end
function CTreasureQuestView.getBtnType( self )
    return  self.BtnType 
end

function CTreasureQuestView.NetWorkReturn_DISCOVE_STORE_GOODS(self,_id,_count) --初始化每个页面
    print("成功获得物品====",_id,_count)
    self : exchangePrizeSpriteAndNumber(_id,_count)
    self : createCCBI(_id)
end

function CTreasureQuestView.createCCBI(self,_id)

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end

        if eventType == "AnimationComplete" then
            self : removeCCBI()
        end
    end

    self : removeCCBI()

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_draw.ccbi" )
    self.THEccbi : setControlName( "this CCBI self.PrizeBtn CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    self.PrizeBtn: addChild(self.THEccbi,10)
end

function CTreasureQuestView.removeCCBI(self)
    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.THEccbi : removeFromParentAndCleanup(true)
            self.THEccbi = nil 
        end
    end
end

function CTreasureQuestView.exchangePrizeSpriteAndNumber(self ,_id,_count)
    --获取物品图片路径
    local Node =  _G.Config.goodss : selectSingleNode("goods[@id="..tostring(_id).."]")
    if Node : isEmpty() ==  true then
        return false
    end
    local icon       = Node : getAttribute("icon")
    local icon_url   = "Icon/i"..icon..".jpg"

    self.PrizeSprite : setImage(icon_url)
    self.PrizeBtn    : setTag(_id)

    if _count ~= nil then
        print("奖品的数量是=",_count)
        self.PrizeCountLabel : setString(_count) 
    end
end

function CTreasureQuestView.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end

function CTreasureQuestView.Imagereplacement(self)
    print("切换图片")
    local List      = self : getIconurlList() 
    local actarr    = CCArray:create()
    local delayTime = 0.1

    if List ~= nil then
        self.PrizeCountLabel : setString("") --清空一下物品的数量

        for i=1,10 do

            local function t_callback()
                local no = self : getRandNumber()
                local icon_url   = "Icon/i"..List[no]..".jpg"
                self.PrizeSprite : setImage(icon_url)
            end
            actarr:addObject( CCDelayTime:create(delayTime) )
            actarr:addObject( CCCallFunc:create(t_callback) )
        end

        local function t_callback()
            local Type = self : getBtnType()
            self : REQ_DISCOVE_STORE_TYPE(Type)
        end
    
        actarr:addObject( CCCallFunc:create(t_callback) )

        self.Scenelayer:runAction( CCSequence:create(actarr) )
    end
end


--获得 1~7 的随机数
function CTreasureQuestView.getRandNumber( self )
    local nState = 1
    local nEnd   = 7
    local tm

    tm={math.random(nState,nEnd),math.random(nState,nEnd)}
    return tm[2];
end










