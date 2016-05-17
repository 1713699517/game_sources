require "controller/command"
require "view/view"

require "mediator/KofCareerLayerMediator"

CKofCareerLayer = class(view,function (self)

                            end)

CKofCareerLayer.closeBtnTag      = 1 --关闭按钮
CKofCareerLayer.HookBtnTag       = 2 --挂机按钮
CKofCareerLayer.ReSetBtnTag      = 3 --重置按钮
CKofCareerLayer.ChallengeBtnTag  = 4 --挑战按钮
CKofCareerLayer.BuyBtnTag        = 5 --购买按钮
CKofCareerLayer.StopHookBtnTag   = 6 --停止挂机按钮


CKofCareerLayer.CdTime           = 1 --Cd时间

--CKofCareerLayer.NowChapPassCount = 0 --统计pass的副本数量
--购买挑战次数所需的钻石基数 CONST_FIGHTERS_TIMES_BUY_BASE

function CKofCareerLayer.scene(self)

    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.scene    = CCScene :create()
    self.m_layer  = CContainer :create()
    self.scene    : addChild(self.m_layer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层
    return self.scene
end

function CKofCareerLayer.layer(self,_winSize)
    self.Scenelayer    = CContainer :create()
    self : init (_winSize,self.Scenelayer)

    return self.Scenelayer
end

function CKofCareerLayer.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("KofCareerResource/KofCareer.plist")

    _G.Config:load("config/scene.xml")
    _G.Config:load("config/goods.xml")
    _G.Config:load("config/copy_chap.xml")
    _G.Config:load("config/copy_reward.xml")
    _G.Config:load("config/scene_copy.xml")
end

function CKofCareerLayer.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("KofCareerResource/KofCareer.plist")
    CCTextureCache :sharedTextureCache()        :removeTextureForKey("KofCareerResource/KofCareer.pvr.ccz")
    
    _G.Config:unload("config/copy_chap.xml")
    _G.Config:unload("config/copy_reward.xml")
   -- CCTextureCache:sharedTextureCache():removeUnusedTextures()
   print("CKofCareerLayer 跑啊跑")
end

function CKofCareerLayer.layout(self, winSize)  --适配布局
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   

    self.m_allBackGroundSprite         : setPreferredSize(CCSizeMake(winSize.width,winSize.height))
    self.m_allSecondBackGroundSprite   : setPreferredSize(CCSizeMake(854,640)) 
    self.m_leftBackGround              : setPreferredSize(CCSizeMake(495,610)) 
    self.m_rightBackGround             : setPreferredSize(CCSizeMake(320,610)) 
    self.m_SecondrightBackGround       : setPreferredSize(CCSizeMake(290,410)) 
    local closeSize                    = self.CloseBtn: getContentSize()

    self.m_allBackGroundSprite       : setPosition(winSize.width/2,winSize.height/2)  --总底图
    self.m_allSecondBackGroundSprite : setPosition(IpadSizeWidth/2,IpadSizeheight/2)  --总底图
    self.m_leftBackGround            : setPosition(260,320)                           --左底图
    self.m_mapBackGroundSprite       : setPosition(265,380)                           --左地图底图
    self.m_rightBackGround           : setPosition(680,320)                           --右底图
    self.m_SecondrightBackGround     : setPosition(680,360)                           --右底图2
    self.CloseBtn                    : setPosition(IpadSizeWidth-closeSize.width/2, IpadSizeheight-closeSize.height/2)  --关闭按钮
    self.HookBtn                     : setPosition(740-50,60)
    self.StopHookBtn                 : setPosition(610,60)
    self.ChallengeBtn                : setPosition(280,60)

   --self.DuplicateNameLabel          : setPosition(45,350)
end

function CKofCareerLayer.initParameter(self)
    ----mediator注册
    print("CKofCareerLayer.mediatorRegister 75")
    _G.g_KofCareerLayerMediator = CKofCareerLayerMediator (self)
    controller :registerMediator(  _G.g_KofCareerLayerMediator )

    self : REQ_FIGHTERS_REQUEST (0) --请求拳皇信息 章节ID 0：默认章节
    self.isupOnlyOneTime = 1
    self.isHookingCount  = 0  --挂机时候显示面板的计数值
end

function CKofCareerLayer.init(self,_winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)              --界面初始化
    self : initParameter()                        --参数初始化
    self : layout(_winSize)                       --适配布局初始化
end

function CKofCareerLayer.initView(self,_winSize,_layer)

    local IpadSize =854

    self.BackContainer = CContainer : create()
    self.BackContainer : setPosition(_winSize.width/2-IpadSize/2,0)
    _layer             : addChild(self.BackContainer)
    --底图
    self.m_allBackGroundSprite        = CSprite :createWithSpriteFrameName("peneral_background.jpg")        --总底图
    self.m_allSecondBackGroundSprite  = CSprite :createWithSpriteFrameName("general_first_underframe.png")  --第1底图
    self.m_leftBackGround             = CSprite :createWithSpriteFrameName("general_second_underframe.png") --左底图
    self.m_mapBackGroundSprite        = CSprite :createWithSpriteFrameName("career_underframe.png")         --左地图底图 
    self.m_rightBackGround            = CSprite :createWithSpriteFrameName("general_second_underframe.png") --右底图 
    self.m_SecondrightBackGround      = CSprite :createWithSpriteFrameName("general_second_underframe.png") --右底图2 

    _layer             : addChild(self.m_allBackGroundSprite,-10)
    self.BackContainer : addChild(self.m_allSecondBackGroundSprite,-9)
    self.BackContainer : addChild(self.m_leftBackGround,-8)
    self.BackContainer : addChild(self.m_mapBackGroundSprite,-6) 
    self.BackContainer : addChild(self.m_rightBackGround,-8)
    self.BackContainer : addChild(self.m_SecondrightBackGround,-7)   
    
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    --关闭按钮
    self.CloseBtn        = CButton : createWithSpriteFrameName("","general_close_normal.png")
    self.CloseBtn        : setTag(CKofCareerLayer.closeBtnTag)
    self.CloseBtn        : registerControlScriptHandler(CallBack,"this CKofCareerLayer CloseBtnCallBack 83")
    self.BackContainer   : addChild (self.CloseBtn)
    --挂机按钮
    self.HookBtn         = CButton : createWithSpriteFrameName("","general_button_normal.png")
    self.HookBtn         : setFontSize(24)
    self.HookBtn         : setTag(CKofCareerLayer.HookBtnTag)
    self.HookBtn         : registerControlScriptHandler(CallBack,"this CKofCareerLayer HookBtn 83")
    self.BackContainer   : addChild (self.HookBtn)   
    --停止挂机按钮
    self.StopHookBtn     = CButton : createWithSpriteFrameName("","general_button_normal.png")
    self.StopHookBtn     : setVisible(false)
    self.StopHookBtn     : setTouchesEnabled(false)
    self.StopHookBtn     : setFontSize(24)
    self.StopHookBtn     : setTag(CKofCareerLayer.StopHookBtnTag)
    self.StopHookBtn     : registerControlScriptHandler(CallBack,"this CKofCareerLayer HookBtn 83")
    self.BackContainer   : addChild (self.StopHookBtn) 

    --挑战按钮
    self.ChallengeBtn    = CButton : createWithSpriteFrameName("挑战","general_button_normal.png")
    self.ChallengeBtn    : setFontSize(24)
    self.ChallengeBtn    : setTag(CKofCareerLayer.ChallengeBtnTag)
    self.ChallengeBtn    : registerControlScriptHandler(CallBack,"this CKofCareerLayer ChallengeBtn 83")
    self.BackContainer   : addChild (self.ChallengeBtn)     

    --self.DuplicateNameLabel = CCLabelTTF :create("","Arial",24,CCSizeMake (24, 24*15), kCCTextAlignmentLeft) 
    self.HookBtnLabel       = CCLabelTTF :create("","Arial",18) 
    self.FreeHookBtnLabel   = CCLabelTTF :create("","Arial",18) 
    self.ChallengeBtnLabel  = CCLabelTTF :create("","Arial",18) 
    self.LocationLabel      = CCLabelTTF :create("","Arial",18) 
    self.LocationSprite     = CSprite : createWithSpriteFrameName("copy_title_frame.png")
    self.LocationSprite     : setPreferredSize(CCSizeMake(200,39))
    --self.BackContainer               : addChild (self.DuplicateNameLabel)   
    self.HookBtn                     : addChild (self.HookBtnLabel)   
    self.HookBtn                     : addChild (self.FreeHookBtnLabel)  
    self.ChallengeBtn                : addChild (self.ChallengeBtnLabel) 
    self.m_SecondrightBackGround     : addChild (self.LocationLabel,4) 
    self.m_SecondrightBackGround     : addChild (self.LocationSprite,2) 

    -- self.HookBtnLabel       : setPosition(-75,75)
    self.HookBtnLabel       : setPosition(0,75-10)
    self.FreeHookBtnLabel   : setPosition(-75,50)
    self.ChallengeBtnLabel  : setPosition(-170,0)  
    self.LocationLabel      : setPosition(0,205)  
    self.LocationSprite     : setPosition(0,205)
    self.ChallengeBtnLabel  : setColor(ccc3(255,255,0))

    --奖励显示-----------------------------------------------------------------------
    self.LimitLvLabel = CCLabelTTF : create("","Arial",18)
    self.LimitLvLabel : setColor(ccc3(223,140,8)) 
    self.LimitLvLabel : setPosition(510+115,525)
    self.BackContainer: addChild(self.LimitLvLabel)

    self.RewardLayout = CHorizontalLayout : create()
    self.RewardLayout : setControlName("CShopLayer  GoodsLayout ")
    self.RewardLayout : setLineNodeSum(1)
    self.RewardLayout : setVerticalDirection(false)
    self.RewardLayout : setCellHorizontalSpace( 120 )
    self.RewardLayout : setCellVerticalSpace( 25 )
    self.RewardLayout : setPosition(510,495+10 )
    self.BackContainer: addChild(self.RewardLayout)
    self.rewardLabel  = {}
    self.rewardLabel2 = {}
    self.rewardLabel3 = {}
    for j=1,3 do
        self.rewardLabel[j]   = CCLabelTTF : create("","Arial",18)
        self.rewardLabel2[j]  = CCLabelTTF : create("","Arial",18)
        self.rewardLabel3[j]  = CCLabelTTF : create("","Arial",18)    
            
        self.rewardLabel[j]   : setAnchorPoint( ccp( 0, 0.5 ) )
        self.rewardLabel2[j]  : setAnchorPoint( ccp( 0, 0.5 ) )
        self.rewardLabel3[j]  : setAnchorPoint( ccp( 0, 0.5 ) )   

        self.rewardLabel[j]   : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐 
        self.rewardLabel2[j]  : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐
        self.rewardLabel3[j]  : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐

        self.RewardLayout     : addChild(self.rewardLabel[j])
        self.rewardLabel[j]   : addChild(self.rewardLabel2[j])
        self.rewardLabel[j]   : addChild(self.rewardLabel3[j])

        self.rewardLabel[j]   : setColor(ccc3(223,140,8)) 
        self.rewardLabel2[j]  : setPosition(0,-25)
        self.rewardLabel3[j]  : setPosition(0,-60)    
    end
    --章节显示------------------------------------------------------------------------
    self.boxSprite          = {}   --副本框框
    self.DuplicateSprite    = {}   --副本图标
    self.DuplicateSpriteName= {}   --副本图标名字
    self.DuplicateLineSprite= {}   --路线条子
end

function CKofCareerLayer.CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  TAG_value  = obj : getTag()

        if     TAG_value == CKofCareerLayer.closeBtnTag then
            print("关闭按钮回调",self.up_is) 
            if self.up_is ~= nil and self.up_is == _G.Constant.CONST_FIGHTERS_UPING then
                self : setTheTimes(nil)
                local msg = "正在挂机中,是否关闭界面"
                local function fun1()
                    print("挂机中关闭")
                    self : removeAllCCBI()      --删除回调
                    self.isHooking = 2          --停止挂机了
                    self : unregisterMediator() --反注册
                    CCDirector : sharedDirector () : popScene()
                    self : unloadResources()
                    return
                end
                local function fun2()
                    print("挂机中不关闭")
                    self.isHooking = 1
                    self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
                end
                self : createMessageBox(msg,fun1,fun2)
            else
                self : removeAllCCBI()      --删除回调
                self : unregisterMediator() --反注册
                CCDirector : sharedDirector () : popScene()
                self : unloadResources()
                return
            end
        elseif TAG_value == CKofCareerLayer.HookBtnTag then
            print("挂机按钮回调")
            self.isHooking = 1
            if self.isupOnlyOneTime ~= nil and  self.isupOnlyOneTime == 1 then
                --self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,0),0) --程序下拉
                --self : cleanrewardLabel ()     --清除信息面板
                self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
                self.isupOnlyOneTime = 0
                print("只输出出一次")
            else
                -- if  self.nowHookingCopyNo ~= nil then   --在火柴人哪里记录一下现在的挂机位置 给挂机按钮使用
                --     local no  = self.nowHookingCopyNo + 1 
                --     if self.DuplicateSprite[no] ~= nil then

                --         self : createHookingHCRCCBI( self.DuplicateSprite[no],no)
                --     end
                -- end
                self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
            end
            -- self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,-35-110*3),6) --程序下拉
        elseif TAG_value == CKofCareerLayer.StopHookBtnTag then
            print("停止挂机按钮")
            self.isHooking = 2 --停止挂机了
            self : removeAllCCBI()      --删除回调
            --self : setTheTimes(nil)
            self.HookBtn     : setTouchesEnabled(true)    
            -- self.StopHookBtn : setTouchesEnabled(false)     

            local actarr = CCArray:create()
            local function t_callback1()
                self.StopHookBtn : setTouchesEnabled(false)  
            end
            actarr:addObject( CCCallFunc:create(t_callback1) )
            obj:runAction( CCSequence:create(actarr) )

        elseif TAG_value == CKofCareerLayer.ChallengeBtnTag then
            print("挑战按钮回调")      
            --self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,-35-110*3),6) --程序下拉 测试用的
            self : enterSceneById()

        elseif TAG_value == CKofCareerLayer.BuyBtnTag then
            print("购买按钮回调")  
            local msg = ""
            local function fun1()
                print("购买按钮确认回调")
                self.isupOnlyOneTime = 1
                self : REQ_FIGHTERS_BUY_TIMES(1) --请求拳皇生涯购买挑战次数协议发送
            end
            local function fun2()
                print("不要消耗了")
            end
            if self.buy_times ~= nil and self.buy_times > 0 then
                local rmb = _G.Constant.CONST_FIGHTERS_TIMES_BUY_BASE + self.buy_times*2
                msg       = "购买一次需要消耗"..rmb.."钻石"
            else
                local rmb = _G.Constant.CONST_FIGHTERS_TIMES_BUY_BASE 
                msg       = "购买一次需要消耗"..rmb.."钻石"                
            end

            self : createMessageBox(msg,fun1,fun2)
        elseif TAG_value == CKofCareerLayer.ReSetBtnTag then
            print("重置按钮回调") 
            if self.reis_mo ~= nil and self.reis_mo == 1 then
                --self : cleanrewardLabel ()     --清除信息面板 
                self : REQ_FIGHTERS_UP_RESET() --请求拳皇生涯重置挂机协议发送
                self.reis_mo = 0
            elseif self.reis_mo ~= nil and self.reis_mo == 0 then

                local msg = ""           
                local function fun1()
                    print("重置按钮确认回调")
                    --self : cleanrewardLabel ()     --清除信息面板 
                    self : REQ_FIGHTERS_UP_RESET() --请求拳皇生涯重置挂机协议发送
                    self : setAlre_times(self :getAlre_times() + 1)
                end
                local function fun2()
                    print("重置按钮取消")
                end
                if self.nowReset_rmb ~= nil and self.nowReset_rmb > 0  then
                    --local rmb = self.nowReset_rmb
                    local rmb = (self :getAlre_times() + 1)*50
                    msg = "重置一次需要消耗"..rmb.."钻石"
                end
                self : createMessageBox(msg,fun1,fun2) 
            end
        end
        if self.count ~= nil and self.count > 0 then
            for i=1,self.count do
                if TAG_value == 100 + i then
                    print("副本按钮回调",TAG_value)
                    self : chagneBoxSprite (TAG_value) --切换图标框框
                    self : setRewardLabel(TAG_value)   --label数据填充
                end
            end
        end
    end
end


function CKofCareerLayer.enterSceneById(self)
    print("进入挑战回调")
    self : removeAllCCBI()      --删除回调
    self : unregisterMediator() --反注册
    self : unloadResources()    --释放资源

    if self.enterSceneId ~= nil and self.enterSceneId > 0 then
        require "common/protocol/auto/REQ_COPY_CREAT"
        local msg = REQ_COPY_CREAT()
        msg : setCopyId( self.enterSceneId )
        _G.CNetwork : send(msg)
        _G.g_IsKofCareer = true
    end
end

function CKofCareerLayer.setRewardLabel(self,TAG_value)
    print("????TAG_value",TAG_value)
    if TAG_value ~= nil and self.XMLChapData  ~= nil and tonumber(TAG_value)  > 0  then
        local data        = self.AllChapListData
        local no          = TAG_value-100
        local sceneCount  = nil 
        if  data[no] ~= nil then
            sceneCount  = data[no].sceneCount
            self.enterSceneId = tonumber(data[no].scene_id) 

            --self.LimitLvLabel  : setString("(等级限制"..data[no].lv.."级)")
        end
        if sceneCount ~= nil and sceneCount > 0 then 
            for i=1,sceneCount do

                local text1       = "通过第"..i.."轮奖励"
                local text2       = ""
                local text3       = ""
                local rewardCount = data[no][i].rewradCount
                if rewardCount ~= nil and rewardCount > 0 then
                    for j = 1,rewardCount do
                        if j == 1 then
                            if tonumber(data[no][i][j].odds) < 10000 then
                                text2 ="奖励(概率获得) : "..data[no][i][j].name.." x "..data[no][i][j].count
                            else
                                text2 ="奖励 : "..data[no][i][j].name.." x "..data[no][i][j].count
                            end

                            if data[no][i].a_money > 0 then
                                text3 ="奖励 : 美刀".." x "..data[no][i].a_money
                            end
                        elseif j == 2 then
                            if tonumber(data[no][i][j].odds) < 10000 then
                                text3 ="奖励(概率获得) : "..data[no][i][j].name.." x "..data[no][i][j].count
                            else
                                text3 ="奖励 : "..data[no][i][j].name.." x "..data[no][i][j].count
                            end
                        end
                    end
                end

                self.rewardLabel[i]  : setString(text1)
                self.rewardLabel2[i] : setString(text2)
                self.rewardLabel3[i] : setString(text3)
                if i == sceneCount then
                    self.LocationLabel : setString(data[no][i].scene_name)
                end
            end
        end
    end
end

function CKofCareerLayer.setHookingRewardLabel(self,TAG_value,_Num,_Data,_Gold)
    print("????TAG_value",TAG_value)
    if TAG_value ~= nil and self.XMLChapData  ~= nil and tonumber(TAG_value)  > 0  then
        local data        = self.AllChapListData
        local no          = TAG_value-100
        local sceneCount  = nil 
        if  data[no] ~= nil then
            sceneCount  = data[no].sceneCount
            self.enterSceneId = tonumber(data[no].scene_id) 
        end
        if sceneCount ~= nil and sceneCount > 0 then 
            for i=1,sceneCount do
                if i == sceneCount then
                    self.isHookingCount = self.isHookingCount + 1
                    local Hookingno = nil 
                    if self.isHookingCount <= 3 then
                        Hookingno     = self.isHookingCount
                    elseif self.isHookingCount > 3 then
                        self : cleanrewardLabel () --清除信息面板
                        self.isHookingCount = self.isHookingCount % 3
                        Hookingno    = self.isHookingCount 
                    end

                    local text1       = "章节名字名字\n" 
                    local text2       = ""
                    local text3       = ""
                    local Num = tonumber(_Num)
                    if Num > 0 and _Data ~= nil  then
                        for j=1,Num do
                            if j == 1 then
                                local id   = _Data[j].goold_id
                                --local node = _G.Config.goodss : selectNode("goods","id",tostring(id))  
                                local node      = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(id).."]")
                                local node_name = node :  getAttribute("name")
                                text2 ="奖励 : "..node_name.." x ".._Data[j].count
                                text3 ="奖励 : 美刀 x ".._Gold
                            elseif j == 2 then
                                local id   = _Data[j].goold_id
                                local node = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(id).."]")
                                text3 ="奖励 : "..data[no][i][j].name.." x ".._Data[j].count
                            end
                        end
                    end
                    -- local rewardCount = data[no][i].rewradCount
                    -- if rewardCount ~= nil and rewardCount > 0 then
                    --     for j = 1,rewardCount do
                    --         if j == 1 then
                    --             if tonumber(data[no][i][j].odds) < 10000 then
                    --                 text2 ="奖励 : (概率获得)"..data[no][i][j].name.."  "..data[no][i][j].count.."个"
                    --             else
                    --                 text2 ="奖励 : "..data[no][i][j].name.."  "..data[no][i][j].count.."个"
                    --             end
                    --         elseif j == 2 then
                    --             if tonumber(data[no][i][j].odds) < 10000 then
                    --                 text3 ="奖励 : (概率获得)"..data[no][i][j].name.."  "..data[no][i][j].count.."个"
                    --             else
                    --                 text3 ="奖励 : "..data[no][i][j].name.."  "..data[no][i][j].count.."个"
                    --             end
                    --         end
                    --     end
                    -- end

                    if Hookingno ~= nil then
                        self.rewardLabel[Hookingno]  : setString(data[no][i].scene_name)
                        self.rewardLabel2[Hookingno] : setString(text2)
                        self.rewardLabel3[Hookingno] : setString(text3)
                    end
                end
            end
        end
    end
end

-- function CKofCareerLayer.setHookingRewardLabel(self,TAG_value)
--     print("????TAG_value",TAG_value)
--     if TAG_value ~= nil and self.XMLChapData  ~= nil and tonumber(TAG_value)  > 0  then
--         local data        = self.AllChapListData
--         local no          = TAG_value-100
--         local sceneCount  = nil 
--         if  data[no] ~= nil then
--             sceneCount  = data[no].sceneCount
--             self.enterSceneId = tonumber(data[no].scene_id) 
--         end
--         if sceneCount ~= nil and sceneCount > 0 then 
--             for i=1,sceneCount do
--                 if i == sceneCount then
--                     self.isHookingCount = self.isHookingCount + 1
--                     local Hookingno = nil 
--                     if self.isHookingCount <= 3 then
--                         Hookingno     = self.isHookingCount
--                     elseif self.isHookingCount > 3 then
--                         self : cleanrewardLabel () --清除信息面板
--                         self.isHookingCount = self.isHookingCount % 3
--                         Hookingno    = self.isHookingCount 
--                     end

--                     local text1       = "章节名字名字\n" 
--                     local text2       = ""
--                     local text3       = ""
--                     local rewardCount = data[no][i].rewradCount
--                     if rewardCount ~= nil and rewardCount > 0 then
--                         for j = 1,rewardCount do
--                             if j == 1 then
--                                 if tonumber(data[no][i][j].odds) < 10000 then
--                                     text2 ="奖励 : (概率获得)"..data[no][i][j].name.."  "..data[no][i][j].count.."个"
--                                 else
--                                     text2 ="奖励 : "..data[no][i][j].name.."  "..data[no][i][j].count.."个"
--                                 end
--                             elseif j == 2 then
--                                 if tonumber(data[no][i][j].odds) < 10000 then
--                                     text3 ="奖励 : (概率获得)"..data[no][i][j].name.."  "..data[no][i][j].count.."个"
--                                 else
--                                     text3 ="奖励 : "..data[no][i][j].name.."  "..data[no][i][j].count.."个"
--                                 end
--                             end
--                         end
--                     end
--                     if Hookingno ~= nil then
--                         self.rewardLabel[Hookingno]  : setString(data[no][i].scene_name)
--                         self.rewardLabel2[Hookingno] : setString(text2)
--                         self.rewardLabel3[Hookingno] : setString(text3)
--                     end
--                 end
--             end
--         end
--     end
-- end

function CKofCareerLayer.cleanrewardLabel( self )
    for j=1,3 do
        self.rewardLabel[j]   : setString("")
        self.rewardLabel2[j]  : setString("")
        self.rewardLabel3[j]  : setString("")
    end
    self.LocationLabel : setString("")
    self.LimitLvLabel  : setString("")
end

function CKofCareerLayer.chagneBoxSprite(self,TAG_value)  --改变框框
    if self.oldTAG_value ~= nil then
       self.boxSprite[self.oldTAG_value] : setImageWithSpriteFrameName("login_player_underframe_normal.png" )
       if self.isPassListData ~= nil then
           self : chagneisPassBoxSprite (self.isPassListData)
        end
        local no = self.oldTAG_value -100
        if no ~= nil and no > 0 then
             --self.DuplicateSprite[no]         : setTouchesEnabled(false)  
             self.DuplicateSprite[no]         : setGray(true)     
        end
    end
    if self.boxSprite[TAG_value] ~= nil then
        self.boxSprite[TAG_value] : setImageWithSpriteFrameName( "career_frame_click.png" )
        self.oldTAG_value         = TAG_value
        local no = TAG_value -100
        if no ~= nil and no > 0 then
            if  self.oldDuplicateSpriteNo ~= nil then
                local no = self.oldDuplicateSpriteNo 
                self.DuplicateSprite[no] : setImageWithSpriteFrameName( "career_copy_icon.png" ) --替换为有人像的底座图
            end


             --self.DuplicateSprite[no]         : setTouchesEnabled(true) 
             self.DuplicateSprite[no]         : setGray(false)  
             ---添加一个ccbi
             self.DuplicateSprite[no] : setImageWithSpriteFrameName( "career_copy_icon2.png" ) --替换为无人像的底座图
             self.oldDuplicateSpriteNo = no 
             self : createHCRCCBI( self.DuplicateSprite[no],2)    --1打拳 2蓄力 3正面奔跑 4侧面奔跑 

        end
    end
end

function CKofCareerLayer.chagneisPassBoxSprite(self,_data)  --通过副本框框
    local data  = _data
    local count = #self.AllChapListData
    if data ~= nil then
        for k,v in pairs(data) do
            print("---->>>///",k,v.copy_id,v.is_pass,count)
            for i = 1,count do
                if self.AllChapListData~= nil and self.AllChapListData[i] ~= nil then
                    if tonumber(self.AllChapListData[i].scene_id) == v.copy_id and v.is_pass == 1 then
                        print("the i  = ",i)
                        self.boxSprite[100+i]           : setImageWithSpriteFrameName( "login_player_underframe_click.png" )
                        self.DuplicateSprite[i]         : setTouchesEnabled(false)     
                        for x,y in pairs(data) do
                            print("66666--->",self.AllChapListData[i].next_scene_id,y.copy_id)
                            if tonumber(self.AllChapListData[i].next_scene_id) > 0 then
                                if tonumber(self.AllChapListData[i].next_scene_id) == y.copy_id and y.is_pass == 1 then
                                    print("高举那条亮线")
                                    self.DuplicateLineSprite[100+i] : setImageWithSpriteFrameName( "career_dividing_lit.png" )
                                end  
                            elseif tonumber(self.AllChapListData[i].next_scene_id) == 0   then
                                print("此时就是最后一章了",y.is_pass,k)
                                if self.AllChapListData[i+1] ~= nil and self.DuplicateLineSprite[100+i+1] ~= nil   then
                                    print("夸章高举那条亮线")
                                    self.DuplicateLineSprite[100+i] : setImageWithSpriteFrameName( "career_dividing_lit.png" )

                                end
                            end
                        end
                    elseif  tonumber(self.AllChapListData[i].scene_id) == v.copy_id and v.is_pass == 0 then
                        self.DuplicateSprite[i]         : setTouchesEnabled(true) 
                    end
                end
            end
        end
    end 
end

function CKofCareerLayer.createMessageBox(self,_msg,_fun1,_fun2)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg,_fun1,_fun2)
    self.Scenelayer : addChild(BoxLayer)
end


function CKofCareerLayer.pushData(self,chap_id,next_chap,times,reset_times,buy_times,Alre_times,Reis_mo,up_is,up_chap,up_copy,count,data)
    print("999999999999999444444444444444444",Alre_times)
    self : setAlre_times(Alre_times)
    print("如果没有挂机，那么挂机副本跟id是====",up_chap,up_copy)
    self : setButton(times,reset_times,up_is,Reis_mo)                     --设置显示按钮

   -- self : NextChapNetWorkSend(chap_id,next_chap)                         --下一章协议发送

    self.XMLChapData     = self : getChapDataFromXml(chap_id,Alre_times)  --获取当前章节XML表数据以及奖励
    self.isPassListData  = data                                           --给蓝色框框传递判断

    print("看看重置是否有挂机判断",up_is,buy_times,Reis_mo,chap_id)
    self.up_is           = tonumber(up_is)                                --给关闭按钮传递传递判断  -- {是否挂机(1:是|0:不是)}   
    self.buy_times       = tonumber(buy_times)                            --已购买挑战次数    
    self.reis_mo         = tonumber(Reis_mo)                              --重置是否免费       

    self : initScrollViewAndchagneisPassBoxSprite(data,chap_id,Alre_times)            --初始化scrollView和设置副本框框
    --self : setCopyPosition(data,chap_id )

    self : setDuplicateScrollViewPosition(data,up_copy)                           --ScrollView位置变动

    self : defaultunSelectedFirst(data,up_copy,reset_times)               --默认选中当前第一个未挑战的

    self : isSetChallengeBtnTouch(up_is)
end

function CKofCareerLayer.setAlre_times( self,_times )
    self.Alre_times = tonumber(_times) 
end
function CKofCareerLayer.getAlre_times( self )
    return self.Alre_times 
end

function CKofCareerLayer.isSetChallengeBtnTouch( self,_up_is )
    if _up_is == _G.Constant.CONST_FIGHTERS_UPING then
        self.ChallengeBtn : setTouchesEnabled(false)
    else
        self.ChallengeBtn : setTouchesEnabled(true)
    end
end


function CKofCareerLayer.setTheTimes(self,_time)
    self.AllTime = _time
end

function CKofCareerLayer.NextChapNetWorkSend(self,_chap_id,_next_chap)
    if _next_chap == 1 then 
        local data = self : getChapDataFromXml(_chap_id)
        if data ~= nil  then 
            local nextid = tonumber(data.next_chap_id) 
            if nextid ~= nil and nextid > 0 then
                print("下一章节请求")
                self : REQ_FIGHTERS_REQUEST(nextid)
                print("下一章节请求成功")
            end
        end
    end
end
function CKofCareerLayer.setCopyPosition( self,data,chap_id )
    if _G.g_KOFCopyID ~= nil then
        if _G.g_KOFisWin ~= nil and _G.g_KOFisWin == true then
            self : initScrollViewAndchagneisPassBoxSprite(data,chap_id)  --初始化scrollView和设置副本框框
        elseif _G.g_KOFisWin ~= nil and _G.g_KOFisWin == false then
           -- local id  = tonumber(_G.g_KOFCopyID)
            self : initScrollViewAndchagneisPassBoxSprite(data,chap_id)       --初始化scrollView和设置副本框框
        end
    else
        self : initScrollViewAndchagneisPassBoxSprite(data,chap_id)      --初始化scrollView和设置副本框框
    end
end

function CKofCareerLayer.setDuplicateScrollViewPosition(self,_severdata,_up_copy)  --ScrollView位置变动 isZerotimes 1是无时间间隔 0 是有
    if _severdata ~= nil and #_severdata > 0 then
        local count = 0
        for k,v in pairs(_severdata) do
            if v.is_pass == 1 then
                count = count + 1
            end
        end
        if count > 1 then
            count = count - 1
        end
        print("猪你又调皮了",count)
        --此为挂机中途停止挂机返回设置的ScrollView位置
        if _G.g_KOFCopyID ~= nil and _G.g_KOFisWin ~= nil then
            local id = tonumber(_G.g_KOFCopyID)
            if _G.g_KOFisWin == true then
                for k,v in pairs(_severdata) do
                    if v.is_pass == 1 then
                        if tonumber(v.copy_id) == id and tonumber(v.is_pass)  == 1  then
                            if k < #_severdata then
                                count = k 
                                print("赢了，算出就是你拉",count,k)
                            end
                        end
                    end
                end
            elseif _G.g_KOFisWin == false then
                for k,v in pairs(_severdata) do
                    if v.is_pass == 1 then
                        if tonumber(v.copy_id) == id and tonumber(v.is_pass)  == 1  then
                            if  k > 0 then
                                count = k -1
                            end
                            print("输了，算出就是你拉",count,k)
                        end
                    end
                end
            end
        end
        --揽腰截胡
        if  tonumber(_up_copy) ~= 0 and tonumber(_up_copy) > 0 then
            for k,v in pairs(_severdata) do
                if v.is_pass == 1 and tonumber(v.copy_id) == tonumber(_up_copy) then
                    count = k - 1
                    break
                end
            end
        end
        if self.m_DuplicateScrollView ~= nil and count > 1  then 
            local xx = self.m_DuplicateScrollView  : getContentOffset()
            self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,-25-120*count),0) --程序下拉 无时间间隔
        end
    end
end

function CKofCareerLayer.initScrollViewAndchagneisPassBoxSprite(self,_severdata,_chap_id,Alre_times) --初始化scrollView和设置副本框框

    self.ChapListData      = {}
    self.AllChapListData   = {}
    local ChapListCount = 0   --所有副本下的章节总个数
    self : getPreChapListDataFromXml(_chap_id,Alre_times)
    self : getNextChapListDataFromXml(_chap_id,Alre_times)
    if self.ChapListData ~= nil then
        for k,chap in pairs(self.ChapListData) do
            print("为了荣耀",k,chap,#chap)
            for i=1,#chap do
                print("为了你---",chap[i],chap[i].scene_id)
                self.AllChapListData[ChapListCount+i] = {}
                self.AllChapListData[ChapListCount+i] = chap[i]
            end
            ChapListCount = ChapListCount + #chap
        end
        self.AllChapListData = self : changeDataLocationById(self.AllChapListData) --重新排序
    end
    print("为了尼玛",#self.AllChapListData)
    local AllChapCount = #self.AllChapListData
    if self.AllChapListData ~= nil and AllChapCount > 0 then

        self : initScrollView (AllChapCount,self.AllChapListData)--初始化ScrollView
        self : setDuplicateSpriteTouchenable (_severdata)  --判断可操作副本按钮
        self : chagneisPassBoxSprite (_severdata)          --变化通关副本框框
    end   
end

function CKofCareerLayer.defaultunSelectedFirst(self,data,up_copy,reset_times)  ---默认选中当前第一个未挑战的 (severdata,当前挂机副本)
    print("默认选中当前第一个未挑战的=",data,#data,up_copy,reset_times)
    --self : Searchdefault(data)
    self.isnowReset_rmbValue = nil
    local no = 0
    if tonumber(up_copy) == 0 then 
        if _G.g_KOFCopyID == nil and _G.g_KOFisWin == nil then
            if data ~= nil then
                local  count = #data 
                if count > 0 then
                    for i = 1,count do
                        if tonumber(data[i].is_pass)  == 0 then
                            no = i 
                            --添加寻找最后一个已通关的副本的 resetRMB-----------------------------------------
                            if no ==  1 then
                                if self.AllChapListData ~= nil and #self.AllChapListData > 0 then
                                    if self.AllChapListData[no] ~= nil then
                                        self.nowReset_rmb = tonumber(self.AllChapListData[no].reset_rmb) 
                                        print("00self.nowReset_rmb= ",self.nowReset_rmb)
                                    end
                                end
                            elseif no >  1 then
                                if data[no-1] ~= nil and tonumber(data[no-1].is_pass)  == 1 then
                                    if self.AllChapListData[no] ~= nil then
                                        self.nowReset_rmb = tonumber(self.AllChapListData[no].reset_rmb) 
                                        print("11self.nowReset_rmb= ",self.nowReset_rmb)
                                    end

                                    if tonumber(data[no-1].copy_id)  == tonumber(up_copy) and tonumber(reset_times) > 0 then
                                        print("终于可以重置了，好高兴")

                                        if self.HookBtn ~= nil then
                                            self.HookBtn      : setText("重置")
                                            self.HookBtn      : setTouchesEnabled(true)
                                            self.HookBtn      : setTag(CKofCareerLayer.ReSetBtnTag)
                                        end
                                    end
                                end

                            end
                            self.isnowReset_rmbValue = 1
                            ------------------------------------------------------------------------------
                            break 
                        end
                    end
                end
            end
        elseif _G.g_KOFCopyID ~= nil and _G.g_KOFisWin ~= nil then --挑战完回来就是是走到这里
            print("挑战完回来就是是走到这里",_G.g_KOFCopyID,_G.g_KOFisWin)
            local copy_id = tonumber(_G.g_KOFCopyID) 
            local isWin   = tostring(_G.g_KOFisWin) 
            if data ~= nil then
                for k,v in pairs(data) do
                    if copy_id == v.copy_id  then
                        if isWin ==tostring(true)   then
                            no = k + 1
                            print("挑战完赢了",no)
                        elseif isWin == tostring(false) then
                            no = k
                            print("挑战完输了",no)
                        end 
                    end
                end
            end
            print("nono = ",no)
             _G.g_KOFCopyID = nil
             _G.g_KOFisWin  = nil
        end
    else
            if data ~= nil then
                local  count = #data 
                if count > 0 then
                    for i = 1,count do
    
                        if tonumber(data[i].is_pass)  == 1 and tonumber(data[i].copy_id) == tonumber(up_copy)  then
                            no = i
                            --添加寻找最后一个已通关的副本的 resetRMB-----------------------------------------
                            if no ==  1 then
                                if self.AllChapListData ~= nil and #self.AllChapListData > 0 then
                                    if self.AllChapListData[no] ~= nil then
                                        self.nowReset_rmb = tonumber(self.AllChapListData[no].reset_rmb) 
                                    end
                                end
                            elseif no >  1 then
                                if data[no-1] ~= nil and tonumber(data[no-1].is_pass)  == 1 then
                                    if self.AllChapListData[no] ~= nil then
                                        self.nowReset_rmb = tonumber(self.AllChapListData[no].reset_rmb) 
                                        
                                    end

                                    if tonumber(data[no-1].copy_id)  == tonumber(up_copy) and tonumber(reset_times) > 0 then

                                        if self.HookBtn ~= nil then
                                            self.HookBtn      : setText("重置")
                                            self.HookBtn      : setTouchesEnabled(true)
                                            self.HookBtn      : setTag(CKofCareerLayer.ReSetBtnTag)
                                        end
                                    end
                                end

                            end
                            self.isnowReset_rmbValue = 1
                            ------------------------------------------------------------------------------
                            -- if _G.g_KOFCopyID ~= nil and _G.g_KOFisWin ~= nil then
                            --     if _G.g_KOFisWin == true then
                            --         no = no +1 
                            --     end
                            --     _G.g_KOFCopyID = nil
                            --     _G.g_KOFisWin  = nil
                            -- end
                            break 
                        end
                    end
                end
            end
    end

    local TAG_value = nil 
    -- if self.theUnPassValue ~= nil then
    --     TAG_value = 100 + self.theUnPassValue 
    -- end
    print("7777777 no=",no)
    if no > 0 then
        TAG_value = 100 + no 
    end
    self : chagneBoxSprite (TAG_value) --切换图标框框
    self : setRewardLabel(TAG_value)   --label数据填充
    print("为什么会这样狗腿")
    if self.isnowReset_rmbValue == nil then --当是最后一个时的值
        print("是这样")
        local  count = #data 
        if self.AllChapListData[count] ~= nil then
            self.nowReset_rmb = tonumber(self.AllChapListData[count].reset_rmb) 
            print("最后一个self.nowReset_rmb= ",self.nowReset_rmb)
        end
    end
end

function CKofCareerLayer.setDuplicateSpriteTouchenable(self,data)  ---判断可操作副本按钮
    if data ~= nil then
        local  count  = #data 
        if count > 0 then
            for i = 1,count do
                self.DuplicateSprite[i]     : setTouchesEnabled(true)
            end
        end
    end
end

function CKofCareerLayer.initScrollView(self,_copyCount,_data)

    if self.m_DuplicateScrollView ~= nil  then
        self.m_DuplicateScrollView : removeFromParentAndCleanup( true )
        self.m_DuplicateScrollView = nil 
    end
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end

    if _copyCount ~= nil and _copyCount > 0 then
        count = _copyCount
    else
        count = 1
    end
    self.count              = count  --传到回调里面去
    self.DuplicateContainer = CContainer : create() 
    print("_sceneCount=",_copyCount)
    for j=1,count do
        
        self.DuplicateSprite[j]     = CSprite : createWithSpriteFrameName("career_copy_icon.png")
        self.DuplicateSprite[j]     : setTouchesEnabled(false)
        self.DuplicateSprite[j]     : setTag(100 + j)
        self.DuplicateSprite[j]     : registerControlScriptHandler(CallBack,"this CKofCareerLayer ChallengeBtn 83")
        self.DuplicateContainer     : addChild(self.DuplicateSprite[j],-j)

        self.DuplicateSpriteName[j] = CButton : createWithSpriteFrameName("我的名字","general_pagination_underframe.png")
        self.DuplicateSpriteName[j] : setFontSize(18)
        self.DuplicateSpriteName[j] : setPosition(1,-50+2)
        self.DuplicateSprite[j]     : addChild(self.DuplicateSpriteName[j],2)

        ----------------
        local scene_id =  _data[j].scene_id
        local node     =  _G.Config.scenes : selectSingleNode("scene[@copy_id="..tostring(scene_id).."]")
        if node : isEmpty() == false then
            self.DuplicateSpriteName[j] : setText(node : getAttribute("scene_name"))
        end

        ----------------
        

        self.DuplicateLineSprite[100+j] = CSprite : createWithSpriteFrameName("career_dividing_normal.png")
        self.DuplicateSprite[j]         : addChild(self.DuplicateLineSprite[100+j])
        if j%2 == 1 then
            self.DuplicateSprite[j]         : setPosition(95,-50+125*j)
            self.DuplicateLineSprite[100+j] : setPosition(175,25)
        elseif j%2 == 0 then
            self.DuplicateSprite[j]         : setPosition(355,-50+125*j)
            self.DuplicateLineSprite[100+j] : setPosition(175,25)
            self.DuplicateSprite[j]         : setScaleX(-1)
            --self.DuplicateLineSprite[100+j] : setScaleX(-1)
            
            self.DuplicateSpriteName[j] : setScaleX(-1)
        end

        self.boxSprite[100+j]  =  CSprite : createWithSpriteFrameName("login_player_underframe_normal.png")
        self.DuplicateSprite[j]: addChild(self.boxSprite[100+j],-5)
        if j == count then
            self.DuplicateLineSprite[100+j] : setVisible(false)
        end
    end
    local m_ViewSize            = CCSizeMake(470,510)
    self.m_DuplicateScrollView  = CCScrollView : create(m_ViewSize,self.DuplicateContainer)
    self.m_DuplicateScrollView  : setDirection(kCCScrollViewDirectionVertical)
    self.m_DuplicateScrollView  : setTouchEnabled(false)
    self.m_DuplicateScrollView  : setPosition(40,100)
    self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,0),0) --程序下拉
    self.BackContainer          : addChild(self.m_DuplicateScrollView,100)
end

function CKofCareerLayer.setButton(self,times,reset_times,up_is,Reis_mo) --设置显示按钮
    print("reset_timesreset_times3301====",times,reset_times,up_is,Reis_mo)
    if times ~= nil and times > 0 then
        self.ChallengeBtnLabel : setString("今日可挑战次数 : "..times)
        self.ChallengeBtn : setText("挑战")
        self.ChallengeBtn : setTag(CKofCareerLayer.ChallengeBtnTag)
    else
        self.ChallengeBtnLabel : setString("")
        self.ChallengeBtn : setText("购买")
        self.ChallengeBtn : setTag(CKofCareerLayer.BuyBtnTag)       
    end
    if reset_times ~= nil and reset_times > 0 then
        if Reis_mo ~= nil and tonumber(Reis_mo) > 0 then
            reset_times = tonumber(reset_times) - tonumber(Reis_mo)
            print("111111",reset_times)
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        elseif Reis_mo ~= nil and tonumber(Reis_mo) == 0 then
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        end
        self.HookBtn      : setText("挂机")
        self.HookBtn      : setTouchesEnabled(true)
        self.HookBtn      : setTag(CKofCareerLayer.HookBtnTag)
    else
        if Reis_mo ~= nil and tonumber(Reis_mo) > 0 then
            --reset_times = tonumber(reset_times) - tonumber(Reis_mo)
            print("2kk2222222",reset_times)
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        elseif Reis_mo ~= nil and tonumber(Reis_mo) == 0 then
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        end
        -- self.HookBtn      : setText("重置")
        -- self.HookBtn      : setTag(CKofCareerLayer.ReSetBtnTag)
        self.HookBtn      : setText("挂机")
        self.HookBtn      : setTag(CKofCareerLayer.HookBtnTag)
        if tonumber(Reis_mo) > 0  then
            self.HookBtn      : setTouchesEnabled(true)

        else
            self.HookBtn      : setTouchesEnabled(false)
            
        end
    end

    if up_is ==  _G.Constant.CONST_FIGHTERS_UPOVER then --挂机完成
        if Reis_mo ~= nil and tonumber(Reis_mo) > 0 then
            --reset_times = tonumber(reset_times) - tonumber(Reis_mo)
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        elseif Reis_mo ~= nil and tonumber(Reis_mo) == 0 then
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        end
        self.HookBtn      : setText("重置")
        self.HookBtn      : setTouchesEnabled(true)
        self.HookBtn      : setTag(CKofCareerLayer.ReSetBtnTag)
    end
    if up_is ==  _G.Constant.CONST_FIGHTERS_UPING then --挂机ing
        if Reis_mo ~= nil and tonumber(Reis_mo) > 0 then
            --reset_times = tonumber(reset_times) - tonumber(Reis_mo)
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        elseif Reis_mo ~= nil and tonumber(Reis_mo) == 0 then
            self.HookBtnLabel     : setString("今日可重置次数 : "..reset_times)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mo.."次") 
        end
        self.HookBtn      : setText("挂机")
        self.HookBtn      : setTouchesEnabled(true)
        self.HookBtn      : setTag(CKofCareerLayer.HookBtnTag)
    end
end

function CKofCareerLayer.getNextChapListDataFromXml(self,chap_id,Alre_times) --获取此章节之前的所有章节数据
    print("getChapListDataFromXml id = ",chap_id)
    local chap_id = tonumber(chap_id)
    if chap_id ~=nil  and chap_id > 0 then
        local ChapData  = self : getChapDataFromXml(chap_id,Alre_times)
        if ChapData ~= nil then
            self.ChapListData[chap_id] = {}
            self.ChapListData[chap_id] = ChapData

            local neid  =  ChapData.next_chap_id
            self : getNextChapListDataFromXml(neid,Alre_times)
        end
    elseif chap_id == 0 then
        return 
    end
end
function CKofCareerLayer.getPreChapListDataFromXml(self,chap_id,Alre_times) --获取此章节之后的所有章节数据
    print("getChapListDataFromXml id = ",chap_id)
    local chap_id = tonumber(chap_id)
    if chap_id ~=nil  and chap_id > 0 then
        local ChapData  = self : getChapDataFromXml(chap_id,Alre_times)
        if ChapData ~= nil then
            self.ChapListData[chap_id] = {}
            self.ChapListData[chap_id] = ChapData

            local perid  =  ChapData.per_chap_id
            self : getPreChapListDataFromXml(perid,Alre_times)
        end
    elseif chap_id == 0 then
        self.isTheFinalChap = 1
        return 
    end
end

function CKofCareerLayer.getChapDataFromXml(self,chap_id,Alre_times) --设置显示按钮
    if chap_id ~= nil and chap_id > 0 then
        local data        = {}
        --local Node        = _G.Config.copy_chaps : selectNode("copy_chap","chap_id",tostring(chap_id)) --章节节点节点
        local Node        = _G.Config.copy_chaps : selectSingleNode("copy_chap[@chap_id="..tostring(chap_id).."]")
        local Node_cids   = Node : children() : get(0,"cids")
        data.chap_name    = Node: getAttribute("chap_name")    --章节名称
        data.chap_id      = Node: getAttribute("chap_id")      --章节ID
        data.next_chap_id = Node: getAttribute("next_chap_id") --章节的下一章节ID
        data.per_chap_id  = Node: getAttribute("per_chap_id")  --章节的上一个章节ID
        data.reset_rmb    = Alre_times*50 --Node: getAttribute("reset_rmb")    --此章节下的副本重置花费
        print("输出一下重置次数",Alre_times)

        data.copyCount    = Node_cids : children() : getCount("cid") --#Node.cids[1].cid --章节当中的副本个数
        ----------------------------------------------------------------------------------------------------
        for i=0,data.copyCount-1 do
            k = i + 1 --最开始是从1开始
            data[k] = {}
            local Node_cids_copy   = Node_cids : children() : get(i,"cid")
            local Node_cids_copyId = Node_cids_copy : getAttribute("id")
            if  Node_cids_copyId ~= nil and tonumber(Node_cids_copyId) > 0 then

                local scene_copyNode        = _G.Config.scene_copys : selectSingleNode("scene_copy[@copy_id="..tostring(Node_cids_copyId).."]")  --scenecopy下的副本节点
                local scene_copyNode_scenes = scene_copyNode : children() : get(0,"scenes")

                data[k].scene_name    = scene_copyNode : getAttribute("copy_name")
                data[k].scene_id      = scene_copyNode : getAttribute("copy_id")
                data[k].next_scene_id = scene_copyNode : getAttribute("next_copy_id")
                data[k].lv            = scene_copyNode : getAttribute("lv")  
                data[k].reset_rmb     = Alre_times*50--Node : getAttribute("reset_rmb")  --此章节下的副本重置花费  
                data[k].sceneCount    = scene_copyNode_scenes : children() : getCount("scene") --#scene_copyNode.scenes[1].scene
                ----------------------------------------------------------------------------------------------------
                local sceneCount      = tonumber(scene_copyNode_scenes : children() : getCount("scene") ) 
                for j = 0,sceneCount-1 do
                    x = j + 1 
                    data[k][x]      = {}
                    if x ~= sceneCount then
                        local copy_scene_id      = scene_copyNode_scenes : children() : get(j,"scene") : getAttribute("id")
                        local sceneNode          = _G.Config.scenes : selectSingleNode("scene[@scene_id="..tostring(copy_scene_id).."]")   --scene下的副本节点
                        local sceneNode_rewards  = sceneNode : children() : get(0,"rewards")

                        data[k][x].scene_id      =  sceneNode : getAttribute("scene_id")
                        data[k][x].scene_name    =  sceneNode : getAttribute("scene_name")
                        data[k][x].a_money       =  0
                        data[k][x].rewradCount   =  sceneNode_rewards : children() : getCount("reward") --#sceneNode.rewards[1].reward 
                        ---------------------------------------------------------------------------------------------------- 
                        for w=0,tonumber(sceneNode_rewards : children() : getCount("reward")) - 1 do
                            y = w + 1
                            data[k][x][y]       = {}
                            local rewardNode    = sceneNode_rewards : children() : get(w,"reward")

                            local rewardNode_id    = rewardNode : getAttribute("id") 
                            data[k][x][y].rewardid = rewardNode : getAttribute("id") 
                            data[k][x][y].count    = rewardNode : getAttribute("count")
                            data[k][x][y].odds     = rewardNode : getAttribute("odds")

                            local goodNode         = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(rewardNode_id).."]")  --scene下的副本节点
                            data[k][x][y].name     = goodNode: getAttribute("name") 
                        end
                    elseif  x == sceneCount and x ~= nil then
                        local copy_rewardNode_Copy_id = scene_copyNode : getAttribute("copy_id")
                        local copy_rewardNode         = _G.Config.copy_rewards : selectSingleNode("copy_reward[@copy_id="..tostring(copy_rewardNode_Copy_id).."]")  --奖励XML节点 

                        local copy_rewardNode_a_goods = copy_rewardNode : children() : get(0,"a_goods")

                        data[k][x].scene_id      =  copy_rewardNode: getAttribute("copy_id")
                        data[k][x].scene_name    =  copy_rewardNode: getAttribute("copy_name")
                        data[k][x].a_money       =  tonumber(copy_rewardNode: getAttribute("a_money")) 
                        print("amoney====",copy_rewardNode: getAttribute("a_money"))
                        data[k][x].rewradCount   =  copy_rewardNode_a_goods : children() : getCount("goods") --#copy_rewardNode.a_goods[1].goods  
                        ---------------------------------------------------------------------------------------------------- 
                        for p =0,tonumber(copy_rewardNode_a_goods : children() : getCount("goods")) - 1  do
                            y = p + 1
                            data[k][x][y]          = {}
                            local rewardNode       = copy_rewardNode_a_goods : children() : get(p,"goods")

                            local rewardNode_Goods_id = rewardNode : getAttribute("goods_id")
                            data[k][x][y].rewardid = rewardNode : getAttribute("goods_id") 
                            data[k][x][y].count    = rewardNode : getAttribute("goods_count") 
                            data[k][x][y].odds     = rewardNode : getAttribute("goods_odds") 

                            local goodNode         = _G.Config.goodss : selectSingleNode("goods[@id="..tostring(rewardNode_Goods_id).."]")  --scene下的副本节点
                            data[k][x][y].name     = goodNode: getAttribute("name") 
                         end 
                    end
                end
            end
        end

        return data 
    else
        return nil 
    end
end

function CKofCareerLayer.changeDataLocationById(self,_data)
    data  = _data
    count = #_data
    temp  = {}
    if  data ~= nil and count > 0  then
        for i = 1,count do
            for j=1,count-i do
                print("---->>mmmm",data[j].scene_id)
                if tonumber(data[j].scene_id) > tonumber(data[j+1].scene_id) then
                    temp      = data[j]
                    data[j]   = data[j+1] 
                    data[j+1] = temp
                end
            end
        end
    end
    print("重新排序后的结果")
    for k,v in pairs(data) do
        print("yy=====",k,v.scene_id)
    end
    return data
end

---协议发送 向服务器发送页面数据请求
function CKofCareerLayer.REQ_FIGHTERS_REQUEST(self,_chap)      --请求拳皇生涯协议发送
    require "common/protocol/auto/REQ_FIGHTERS_REQUEST" 
    local msg = REQ_FIGHTERS_REQUEST()
    msg       : setChap(_chap) --默认章节
    CNetwork  : send(msg)
    print("REQ_FIGHTERS_REQUEST 55810发送完毕 ")
end
function CKofCareerLayer.REQ_FIGHTERS_BUY_TIMES(self,_buytimes) --请求拳皇生涯购买挑战次数协议发送
    require "common/protocol/auto/REQ_FIGHTERS_BUY_TIMES" 
    local msg = REQ_FIGHTERS_BUY_TIMES()
    msg       : setTimes(_buytimes) 
    CNetwork  : send(msg)
    print("REQ_FIGHTERS_BUY_TIMES 55840发送完毕 ")
end
function CKofCareerLayer.REQ_FIGHTERS_UP_START(self)  --请求拳皇生涯开始挂机协议发送
    print("应该请求四次才对是不是------》")
    require "common/protocol/auto/REQ_FIGHTERS_UP_START" 
    local msg = REQ_FIGHTERS_UP_START()
    CNetwork  : send(msg)
    print("REQ_FIGHTERS_UP_START 55860发送完毕 ")
end
function CKofCareerLayer.REQ_FIGHTERS_UP_STOP(self)  --请求拳皇生涯停止挂机协议发送
    require "common/protocol/auto/REQ_FIGHTERS_UP_STOP" 
    local msg = REQ_FIGHTERS_UP_STOP()
    CNetwork  : send(msg)
    print("REQ_FIGHTERS_UP_STOP 55890发送完毕 ")
end
function CKofCareerLayer.REQ_FIGHTERS_UP_RESET(self)  --请求拳皇生涯重置挂机协议发送
    require "common/protocol/auto/REQ_FIGHTERS_UP_RESET" 
    local msg = REQ_FIGHTERS_UP_RESET()
    CNetwork  : send(msg)
    print("REQ_FIGHTERS_UP_RESET 55960发送完毕 ")
end
---协议返回
function CKofCareerLayer.HookNetWorkReturn(self,ChapId,CopyId,Num,Data,Gold) --挂机协议返回
    self:lockScene() --锁屏
     self.isNotAllPass = nil 
    print("你猜猜我出现了多少次",ChapId,CopyId)
    self.HookBtn     : setTouchesEnabled(false)
    self.StopHookBtn : setTouchesEnabled(true)
    if self.isHooking == 1 then
        local data = self.isPassListData 
        if data ~= nil and #data > 0 then
            local CopyId = tonumber(CopyId)
            if CopyId ~= nil and CopyId > 0 then
                for k,v in pairs(data) do
                    if v.is_pass == 0 then
                        self.isNotAllPass = 1 
                    end
                    if tonumber(v.copy_id) == CopyId and v.is_pass == 1 then
                        print("应该是返回四次才对",k)
                        --控制协议发送
                        if k < #data   then -- -1
                            -------------------------------------------------------------------------------------------
                            local TAG_value = nil 
                            TAG_value = 100 + k -- + 1
                            self : chagneBoxSprite (TAG_value) --切换图标框框
                            self : setHookingRewardLabel(TAG_value,Num,Data,Gold)   --label数据填充
                            --self : setRewardLabel(TAG_value) --label数据填充
                            self.LocationLabel : setString("当前挂机中 : ")
                            -------------------------------------------------------------------------------------------
                            print("你猜猜00",k)
                            if self.m_DuplicateScrollView ~= nil then
                                if k == 1 then
                                    self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,0),0) --程序下拉
                                    print("你猜猜11",k)
                                elseif k > 2 then 
                                    print("你猜猜22",k)
                                    if k%4 == 0 then
                                        local location        = self.m_DuplicateScrollView  : getContentOffset()
                                        local  FinallocationY =  math.abs(-120*k) -math.abs(location.y)
                                        local  time           = FinallocationY/90
                                        self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,-130-135*(k-2)),0) --程序下拉 无时间间隔
                                        --self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,-130-120*(k-2)),0) --程序下拉 无时间间隔
                                    end
                                end
                                print("还没还没进来了了了了",k,#data -1)
                                if k == #data -1 then
                                    print("进来了了了了55",k)
                                    self.FinalCopyTime = 0 
                                    --self : setTheTimes(0)
                                    self : setFinalCopyScelected()

                                    self : createHookingHCRCCBI( self.DuplicateSprite[k],k)
                                end
                            end
                            ------------------------
                            if k < #data  then
                                if #data ~= 2 then
                                    --print("倒数应该发送三次才对",k)
                                     -- self : setTheTimes(0)
                                     -- self : addTime()
                                    self : createHookingHCRCCBI( self.DuplicateSprite[k],k)
                                end
                            end
                        end
                        if k == tonumber(#data-1) then
                            if self.isTheFinalChap ~= nil and self.isTheFinalChap == 1 then
                                print("我是传说中的第十三次～～～～")
                                self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
                                print("所以我发多一次")
                                local TAG_value = nil 
                                TAG_value = 100 + k -- + 1
                                self : chagneBoxSprite (TAG_value) --切换图标框框
                                self : setHookingRewardLabel(TAG_value,Num,Data,Gold)   --label数据填充
                            end
                        end
                    end
                end
            end
        end
    end
end

function CKofCareerLayer.setFinalCopyScelected(self)
    local function FinalCopySend(_addtime) 
        --_G.pDateTime : reset()
        if self.FinalCopyTime == nil or self.FinalCopyTime < 0 then
            return
        end
        self.FinalCopyTime = self.FinalCopyTime + _addtime        
        if self.FinalCopyTime > CKofCareerLayer.CdTime then
            print("专门调用你一次")
            if self.isPassListData ~= nil then
                print("self.isPassListData",self.isPassListData)
                local data = self.isPassListData
                for k,v in pairs(data) do
                    print("how how how ",k)
                    if tonumber(v.is_pass) == 0 then
                        print("看看我进来了没 ",k)
                        local TAG_value =100 + k
                        self : chagneBoxSprite (TAG_value) --切换图标框框
                        self : setRewardLabel(TAG_value)   --label数据填充

                        self.FinalCopyTime = nil
                        self.Scenelayer : unscheduleUpdate()
                    end
                end
                if self.isNotAllPass == nil then
                    self.FinalCopyTime = nil         
                end
            end
        end
    end
    self.Scenelayer : scheduleUpdateWithPriorityLua( FinalCopySend, 0 )
end

function CKofCareerLayer.addTime(self)
    local function HookSend(_addtime)
        --_G.pDateTime : reset()
        if self.AllTime == nil or self.AllTime < 0 then
            return
        end
        self.AllTime = self.AllTime + _addtime 
        if self.AllTime > CKofCareerLayer.CdTime then
            print("》》》》》》》》》一秒")
            --self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
            self : setTheTimes(nil)        --设置self.AllTime 为空
            self.BackContainer : unscheduleUpdate()

        end
    end
    self.BackContainer : scheduleUpdateWithPriorityLua( HookSend, 0 )
end
function CKofCareerLayer.setTheTimes(self,_time) --设置时间
    self.AllTime = _time
end

function CKofCareerLayer.HookOKNetWorkReturn(self)            --挂机完成协议返回
    print("挂机完成")
    self : unlockScene() -- 锁屏
    self : isSetChallengeBtnTouch(0) --设置挑战按钮可按

    self.isHooking = 0 --是否挂机 1为ing 0 为否
    self.up_is = _G.Constant.CONST_FIGHTERS_UPOVER --挂机完成
    self.LocationLabel : setString("挂机完成")

    if self.HookBtn ~= nil then
        self.HookBtn : setText("重置")
        self.HookBtn : setTouchesEnabled(true)
        self.HookBtn : setTag(CKofCareerLayer.ReSetBtnTag)
    end
    if self.StopHookBtn ~= nil then
        self.StopHookBtn : setTouchesEnabled(false)
    end
end

function CKofCareerLayer.HookResetOKWorkReturn(self,ResetTimes,Reis_mon,UpIs,UpChan,UpCopy) --重置挂机成功协议返回
    self : cleanrewardLabel ()     --清除信息面板
    print("uuuuuuuuuuuuuuuuuuu===",ResetTimes,Reis_mon)
    if self.HookBtnLabel ~= nil and ResetTimes ~= nil then
        if Reis_mon ~= nil   then
            ResetTimes = tonumber(ResetTimes) - tonumber(Reis_mon)
            self.HookBtnLabel : setString("今日可重置次数 : "..ResetTimes)
            --self.FreeHookBtnLabel : setString("今日可免费重置"..Reis_mon.."次") 
        end
    end 
    if self.HookBtn ~= nil then
        self.HookBtn      : setText("挂机")
        self.HookBtn      : setTag(CKofCareerLayer.HookBtnTag)
    end
    if self.m_DuplicateScrollView ~= nil and count > 1  then 
        self.m_DuplicateScrollView  : setContentOffsetInDuration(CCPointMake(0,0),0)  --程序下拉 无时间间隔
    end
end
function CKofCareerLayer.BuyOKNetWorkReturn(self,Times) --购买成功协议返回

    local msg = "购买次数成功"
    self : createMessageBox(msg)

    if self.ChallengeBtnLabel ~= nil and Times ~= nil then
        self.ChallengeBtnLabel : setString("今日可挑战次数 : "..Times)
    end 
    if self.ChallengeBtn ~= nil then
        self.ChallengeBtn      : setText("挑战")
        self.ChallengeBtn      : setTag(CKofCareerLayer.ChallengeBtnTag)
    end
end

function CKofCareerLayer.unregisterMediator(self)
    if _G.g_KofCareerLayerMediator ~= nil then
        controller :unregisterMediator(_G.g_KofCareerLayerMediator)
        _G.g_KofCareerLayerMediator = nil
        print("unregisterMediator.g_KofCareerLayerMediator")
    end
end


function CKofCareerLayer.createHookingHCRCCBI( self,obj,_no) --1打拳 2蓄力 3正面奔跑 4侧面奔跑
    print("火柴人块泡====",_no)
    if obj ~= nil then
        if self.hcrccbi ~= nil then
            self.hcrccbi : removeFromParentAndCleanup(true)
            self.hcrccbi = nil 
        end
        self.hcrccbi = CMovieClip:create( "CharacterMovieClip/effects_hcr.ccbi" )

        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            print("animationCallFunc",eventType, arg0, arg1, arg2, arg3)
            --self.hcrccbi : play( "run2" )
            if eventType == "Enter" then

            elseif eventType == "Exit" then
                print("animationCallFunc  Exit")
            elseif eventType == "AnimationComplete" then
                
                if arg0 == "run1" then --3打完拳
                        --移动一下 侧面跑ccbi 
                        if _no ~= nil and self.DuplicateSprite[_no+1] ~= nil  then
                            self.DuplicateSprite[_no+1] : setImageWithSpriteFrameName( "career_copy_icon2.png" ) --替换为无人像的底座图
                        end
                        
                        self : moveHCRCCBI_run4()   --侧门跑移动
                        self.hcrccbi : play("run4") --4侧面跑
                        return
          
                elseif  arg0 == "run2" then
                     -- if self.ismoveHCRCCBI_run3OK ~= nil and self.ismoveHCRCCBI_run3OK == 1 then
                     --    --self.hcrccbi  : play("run2") --2蓄力 
                    
                     -- else
                         self.hcrccbi  : play("run1") --1打拳
                     --end
                elseif  arg0 == "run4" then
                    if self.ismoveHCRCCBI_run4OK ~= nil and self.ismoveHCRCCBI_run4OK == 0 then
                        self.hcrccbi : play("run4") --4侧面跑
                    elseif self.ismoveHCRCCBI_run4OK ~= nil and self.ismoveHCRCCBI_run4OK == 1 then
                        self : moveHCRCCBI_run3()   --正面跑移动
                        self.hcrccbi : play("run3") --3正面奔跑
                    end
                elseif arg0 ==  "run3" then 
                    if self.ismoveHCRCCBI_run3OK ~= nil and self.ismoveHCRCCBI_run3OK == 0 then
                        self.hcrccbi : play("run3") --3正面奔跑
                    elseif self.ismoveHCRCCBI_run3OK ~= nil and self.ismoveHCRCCBI_run3OK == 1 then
                        self.nowHookingCopyNo = tonumber(_no)   --记录一下现在的挂机位置 给挂机按钮使用

                        self : removeAllCCBI ()  --删除ccbi
                        self : REQ_FIGHTERS_UP_START() --请求拳皇生涯开始挂机协议发送
                        self.BackContainer : unscheduleUpdate()
                        --self.hcrccbi : play("run2") --3蓄力
                    end
                end
                
            end
        end

        self.hcrccbi : registerControlScriptHandler( animationCallFunc )
        self.hcrccbi : setPosition(0,25)
        self.hcrccbi : play( "run2" ) --2蓄力
        obj : addChild( self.hcrccbi,1000)
    end



end

function CKofCareerLayer.moveHCRCCBI_run4( self ) --侧门泡移动
    -- if _no ~= nil and tonumber(_no) ~= 0  then
    --     local no = tonumber(_no)%2

        if self.hcrccbi ~= nil then
            self.ismoveHCRCCBI_run4OK = 0 
            local function local_infoActionCallBack()
               self.ismoveHCRCCBI_run4OK = 1 
            end

            local _actionInfo = CCArray:create()

            -- if  no == 1 then --往右边
            --     print("往右边泡啊泡")
            --     --self.hcrccbi : setScaleX(-1)
            --     _actionInfo:addObject(CCMoveTo:create( 1, ccp( 250+20,0 ) ))
            -- elseif no == 0 then --往左边
               --print("往左边泡啊泡")
                --self.hcrccbi : setScaleX(-1)
                _actionInfo:addObject(CCMoveTo:create( 1, ccp( 250+20,0 ) ))
            --end
            
            _actionInfo:addObject(CCCallFunc:create(local_infoActionCallBack))
            self.hcrccbi : runAction( CCSequence:create(_actionInfo) )
        end
    --end
end
function CKofCareerLayer.moveHCRCCBI_run3( self ) --正面泡移动
    -- if _no ~=nil and tonumber(_no) ~= 0 then
    --     local no = tonumber(_no)%2

        if self.hcrccbi ~= nil then
            self.ismoveHCRCCBI_run3OK = 0 
            local function local_infoActionCallBack()
               self.ismoveHCRCCBI_run3OK = 1 
            end

            local _actionInfo = CCArray:create()

            -- if  no == 1 then --往右边
            --     _actionInfo:addObject(CCMoveTo:create( 0.5, ccp( 250+20,130 ) ))
            -- elseif no == 0 then --往左边
            _actionInfo:addObject(CCMoveTo:create( 0.5, ccp( 250+20,130 ) ))
            --end

            _actionInfo:addObject(CCCallFunc:create(local_infoActionCallBack))
            self.hcrccbi : runAction( CCSequence:create(_actionInfo) )
        end
    --end
end



function CKofCareerLayer.createHCRCCBI( self,obj) --1打拳 2蓄力 3正面奔跑 4侧面奔跑

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
        end

        if eventType == "AnimationComplete" then
            self.hcrccbi : play("run2") --3蓄力
        end
    end

    if self.hcrccbi ~= nil then
        self.hcrccbi : removeFromParentAndCleanup(true)
        self.hcrccbi = nil 
    end

    if obj ~= nil then
        self.hcrccbi = CMovieClip:create( "CharacterMovieClip/effects_hcr.ccbi" )
        self.hcrccbi : setPosition(0,30)
        self.hcrccbi : setControlName( "this hcrccbi CCBI")
        self.hcrccbi : registerControlScriptHandler( animationCallFunc)
        self.hcrccbi : play("run2") --3蓄力
        obj  : addChild(self.hcrccbi,1000)
    end
end

function CKofCareerLayer.removeAllCCBI( self )

    if self.hcrccbi ~= nil then
        self.hcrccbi : removeFromParentAndCleanup(true)
        self.hcrccbi = nil 
    end
end


function CKofCareerLayer.lockScene( self )
    --锁住屏幕

    print("CGuideManager.lockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == true then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    end
end
--解锁屏幕点击
function CKofCareerLayer.unlockScene( self )

    print("CGuideManager.lockScene   unlockScene")
    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    if isdis == false then
        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
    end
end



