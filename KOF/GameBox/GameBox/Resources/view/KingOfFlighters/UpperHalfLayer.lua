
require "controller/command"

require "view/view"

require "mediator/UpperHalfLayerMediator"

CUpperHalfLayer = class(view,function (self)
                          end)

CUpperHalfLayer.TAG_HappyBtn = 500

function CUpperHalfLayer.scene(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize    = 854
    self.scene       = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene       : addChild(self.Scenelayer)
    self.scene       : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CUpperHalfLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer    = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CUpperHalfLayer.loadResources(self)
    _G.Config:load("config/goods.xml")
end

function CUpperHalfLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_BackGround       : setPosition(455,295)    --底图
        self.m_combatBackGround : setPosition(455,295)    --底图
        self.m_LeftDividingSprite  : setPosition(635,298) --左边分组底图      
        self.m_RightDividingSprite : setPosition(275,298) --右边分组底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CUpperHalfLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CUpperHalfLayer.initParameter(self)
    self : registerMediator()   --mediator注册
    -- self : REQ_WRESTLE_FINAL_REQUEST () --决赛入口
end

function CUpperHalfLayer.initView(self,_winSize,_layer)
    local function CallBack(eventType, obj, x, y)
        return self : CallBack(eventType,obj,x,y)
    end
    self.m_BackGround        = CSprite : createWithSpriteFrameName("general_second_underframe.png")    --底图
    self.m_combatBackGround  = CSprite : createWithSpriteFrameName("combat_background_underframe.png") --底图

    self.m_BackGround  : setPreferredSize(CCSizeMake(820,550))
    _layer             : addChild(self.m_BackGround,-2)
    _layer             : addChild(self.m_combatBackGround,-1)
    --分组底图
    self.m_LeftDividingSprite  = CSprite : createWithSpriteFrameName("combat_dividing.png")  --左边分组底图  
    self.m_LeftDividingSprite  : setScaleX(-1)
    self.m_RightDividingSprite = CSprite : createWithSpriteFrameName("combat_dividing.png")  --右边分组底图
    _layer             : addChild(self.m_LeftDividingSprite)
    _layer             : addChild(self.m_RightDividingSprite)

    --左分组成员
    self.LeftLayout = CHorizontalLayout : create()
    self.LeftLayout : setControlName("CShopLayer  GoodsLayout ")
    self.LeftLayout : setPosition(25,535)
    self.LeftLayout : setLineNodeSum(1)
    self.LeftLayout : setVerticalDirection(false)
    self.LeftLayout : setCellSize(CCSizeMake(200,69))
    _layer          : addChild( self.LeftLayout)

    self.LeftDividingSprite  = {}
    self.LeftDividingLabel   = {}
    self.Left1LineSprite     = {} -- 一层线条
    self.Left2LineSprite     = {} -- 二层线条   
    self.Left3LineSprite     = {} -- 三层线条 
    for i=1,8 do
        self.LeftDividingSprite[i] = CSprite : createWithSpriteFrameName("combat_frame_normal.png")
        self.LeftDividingSprite[i] : setTouchesEnabled(true)
        self.LeftDividingSprite[i] : setTag(i)     
        self.LeftDividingSprite[i] : registerControlScriptHandler(CallBack,"this CUpperHalfLayer RightDividingSprite 110")
        self.LeftLayout            : addChild(self.LeftDividingSprite[i])

        self.LeftDividingLabel[i]  = CCLabelTTF : create("","Arial",18)
        self.LeftDividingSprite[i] : addChild(self.LeftDividingLabel[i])
        --------------------------------------------------------------------------------------------------------------
        self.Left1LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_a01.png")  -- 一层线条
        self.Left1LineSprite[i]    : setVisible( false ) 
        self.Left1LineSprite[i]    : setPosition(77,-11)
        self.LeftDividingSprite[i] : addChild(self.Left1LineSprite[i])
        if i%2 == 0  then
            self.Left1LineSprite[i]    : setScaleY(-1)
            self.Left1LineSprite[i]    : setPosition(77,20)
            --------------------------------------------------------------------------------------------------------------
            self.Left2LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_a02.png")  -- 二层线条 
            self.Left2LineSprite[i]    : setVisible( false ) 
            self.Left2LineSprite[i]    : setPosition(77+35,-11+15)
            self.LeftDividingSprite[i] : addChild(self.Left2LineSprite[i])
            if i%4 == 0 then
                self.Left2LineSprite[i]    : setScaleY(-1)
                self.Left2LineSprite[i]    : setPosition(77+35,20+50)
                --------------------------------------------------------------------------------------------------------------
                self.Left3LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_a03.png")  -- 三层线条 
                self.Left3LineSprite[i]    : setVisible( false ) 
                self.Left3LineSprite[i]    : setPosition(77+35+45,20+20)
                self.LeftDividingSprite[i] : addChild(self.Left3LineSprite[i])
                if i%8 == 0 then
                    self.Left3LineSprite[i]    : setScaleY(-1)
                    self.Left3LineSprite[i]    : setPosition(77+35+45,20+50+50+55)
                    --------------------------------------------------------------------------------------------------------------
                    self.Left4LineSprite       = CSprite : createWithSpriteFrameName("combat_dividing_a04.png")  -- 三层线条
                    self.Left4LineSprite       : setVisible( false )  
                    self.Left4LineSprite       : setPosition(77+35+45+52,20+20+205)
                    self.LeftDividingSprite[i] : addChild(self.Left4LineSprite)
                end
            end
        end
    end
    --左边连线图拼接


    --右分组成员
    self.RightLayout = CHorizontalLayout : create()
    self.RightLayout : setControlName("CShopLayer  GoodsLayout ")
    self.RightLayout : setPosition(685,535)
    self.RightLayout : setLineNodeSum(1)
    self.RightLayout : setVerticalDirection(false)
    self.RightLayout : setCellSize(CCSizeMake(200,69))
    _layer          : addChild( self.RightLayout)

    self.RightDividingSprite  = {}
    self.RightDividingLabel   = {}
    self.Right1LineSprite     = {} -- 一层线条
    self.Right2LineSprite     = {} -- 二层线条   
    self.Right3LineSprite     = {} -- 三层线条 
    for i=1,8 do
        self.RightDividingSprite[i] = CSprite : createWithSpriteFrameName("combat_frame_normal.png")
        self.RightDividingSprite[i] : setTouchesEnabled(true)
        self.RightDividingSprite[i] : setTag(i*10)     
        self.RightDividingSprite[i] : registerControlScriptHandler(CallBack,"this CUpperHalfLayer RightDividingSprite 110")
        self.RightLayout            : addChild(self.RightDividingSprite[i])

        self.RightDividingLabel[i]  = CCLabelTTF : create("","Arial",18)
        self.RightDividingSprite[i] : addChild(self.RightDividingLabel[i])
        --------------------------------------------------------------------------------------------------------------
        self.Right1LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_b01.png")  -- 一层线条 
        self.Right1LineSprite[i]    : setVisible( false )
        self.Right1LineSprite[i]    : setPosition(-77,-11)
        self.RightDividingSprite[i] : addChild(self.Right1LineSprite[i])
        if i%2 == 0 then
            self.Right1LineSprite[i]    : setScaleY(-1)
            self.Right1LineSprite[i]    : setPosition(-77,20)
            --------------------------------------------------------------------------------------------------------------
            self.Right2LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_b02.png")  -- 二层线条 
            self.Right2LineSprite[i]    : setVisible( false )
            self.Right2LineSprite[i]    : setPosition(-77-35,-11+15)
            self.RightDividingSprite[i] : addChild(self.Right2LineSprite[i])
            if i%4 == 0 then
                self.Right2LineSprite[i] : setScaleY(-1)
                self.Right2LineSprite[i] : setPosition(-77-35,20+50)
                --------------------------------------------------------------------------------------------------------------
                self.Right3LineSprite[i]    = CSprite : createWithSpriteFrameName("combat_dividing_b03.png")  -- 三层线条 
                self.Right3LineSprite[i]    : setVisible( false )
                self.Right3LineSprite[i]    : setPosition(-77-35-45,20+20)
                self.RightDividingSprite[i] : addChild(self.Right3LineSprite[i])
                if i%8 == 0 then
                    self.Right3LineSprite[i] : setScaleY(-1)
                    self.Right3LineSprite[i] : setPosition(-77-35-45,20+50+50+55)
                    --------------------------------------------------------------------------------------------------------------
                    self.Right4LineSprite       = CSprite : createWithSpriteFrameName("combat_dividing_b04.png")  -- 三层线条 
                    self.Right4LineSprite       : setVisible( false )
                    self.Right4LineSprite       : setPosition(-77-35-45-52,20+20+205)
                    self.RightDividingSprite[i] : addChild(self.Right4LineSprite)
                end
            end
        end
    end

    --公告信息
    self.InfoLabel = CCLabelTTF : create("半区比赛暂没开始","Arial",24)
    self.InfoLabel : setColor(ccc3(255,255,0))
    self.InfoLabel : setPosition(450,500)
    _layer         : addChild( self.InfoLabel,10)

    --格斗之王logo
    self.KingOfFlightersSprite = CSprite : createWithSpriteFrameName("combat_logo_02.png")
    self.UpperHalfSprite       = CSprite : createWithSpriteFrameName("combat_word_sbq.png")
    self.KingOfFlightersSprite : setPosition(450,350)
    self.UpperHalfSprite       : setPosition(0,-80)
    _layer                     : addChild( self.KingOfFlightersSprite)
    self.KingOfFlightersSprite : addChild( self.UpperHalfSprite,2)

    --冠军之名
    self.WinnerNameBtn = CButton : createWithSpriteFrameName("","login_name_underframe.png")
    self.WinnerNameBtn : setFontSize(24)
    self.WinnerNameBtn : setColor(ccc3(255,255,0))
    self.WinnerNameBtn : setPreferredSize(CCSizeMake(220,40))
    self.WinnerNameBtn : setPosition(450,210)
    _layer             : addChild( self.WinnerNameBtn)

    --下场对决倒计时
    self.NextTimeLeftLabel = CCLabelTTF : create("","Arial",18)
    self.NextTimeLeftLabel : setColor(ccc3(255,255,0))
    self.NextTimeLeftLabel : setPosition(450,140)
    _layer                 : addChild( self.NextTimeLeftLabel)

    --欢乐竞猜
    self.HappyBtn = CButton : createWithSpriteFrameName("欢乐竞猜","general_button_normal.png")
    self.HappyBtn : registerControlScriptHandler(CallBack,"this CUpperHalfLayer HappyBtn 132")
    self.HappyBtn : setTag(CUpperHalfLayer.TAG_HappyBtn)
    self.HappyBtn : setFontSize(24)
    self.HappyBtn : setPosition(450,70)
    _layer        : addChild( self.HappyBtn)

end

function CUpperHalfLayer.CallBack(self,eventType,obj,x,y)  --关闭页面按钮回调
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  TAG_value  = obj : getTag()
        if     TAG_value == CUpperHalfLayer.TAG_HappyBtn then
            print("欢乐小竞猜")
            local FunQuizLayer = CFunQuizLayer ()
            CCDirector : sharedDirector () : pushScene(FunQuizLayer : scene())
            if self.Msg ~= nil then
                FunQuizLayer : pushData(self.Msg)
            end
        end
        for i=1,8 do
            if TAG_value == i then
                print("左边队伍回调")
                self : changeLeftBoxSprite(i)
            end

            if TAG_value == i*10 then
                print("右边队伍回调")
                self : changeRightBoxSprite(i)
            end
        end
    end
end

function CUpperHalfLayer.changeLeftBoxSprite(self,TAG_value)
    self : changeSprite() --消除之前痕迹
    if self.LeftDividingSprite[TAG_value] ~= nil then
        self.LeftDividingSprite[TAG_value] : setImageWithSpriteFrameName( "combat_frame_click.png" )
        self.oldLeftTAG_value              = TAG_value
    end
end
function CUpperHalfLayer.changeRightBoxSprite(self,TAG_value)
    self : changeSprite() --消除之前痕迹
    if self.RightDividingSprite[TAG_value] ~= nil then
        self.RightDividingSprite[TAG_value] : setImageWithSpriteFrameName( "combat_frame_click.png" )
        self.oldRightTAG_value              = TAG_value
    end
end
function CUpperHalfLayer.changeSprite(self)
    if self.oldLeftTAG_value ~= nil then
       self.LeftDividingSprite[self.oldLeftTAG_value] : setImageWithSpriteFrameName("combat_frame_normal.png" )
    end
    if self.oldRightTAG_value ~= nil then
       self.RightDividingSprite[self.oldRightTAG_value] : setImageWithSpriteFrameName("combat_frame_normal.png" )
    end
end


function CUpperHalfLayer.pushData(self,Count,Msg,lunci) --sever methond
    print("CUpperHalfLayer.pushData",Count,lunci)
    self.translunci = lunci
    self.Msg              = Msg
    self.FirstPlayerList  = self : MsgDataGrouping(Msg,1) --数据抽取
    self.SecondPlayerList = self : MsgDataGrouping(Msg,2) --数据抽取
    self.ThirdPlayerList  = self : MsgDataGrouping(Msg,3) --数据抽取
    self.FourPlayerList   = self : MsgDataGrouping(Msg,4) --数据抽取


    self : initDividingLabelData(self.FirstPlayerList.count,self.FirstPlayerList) --初始化第一轮数据 显示第一轮结果


    self : initSecondPlayerView(self.FirstPlayerList,self.SecondPlayerList)       --显示第二轮结果

    self : initThirdPlayerView(self.FirstPlayerList,self.ThirdPlayerList)         --显示第三轮结果

    self : initFourPlayerView(self.FirstPlayerList,self.FourPlayerList)           --显示第四轮结果 

   -- self : initFirstLineSprite()
    -- self.LeftPlayerList  = {}
    -- self.RightPlayerList = {}
    -- if Msg ~= nil and Count ~= nil and Count > 0 then
    --     local count = 0
    --     for k,v in pairs(Msg) do
    --         print("-831--------->",k,v,v.name1,v.name2)
    --         if k <= 4 then
    --             if count <= 8 then
    --                 count = count +１
    --                 self.LeftPlayerList[count]      = {}
    --                 self.LeftPlayerList[count].no   = count
    --                 self.LeftPlayerList[count].name = v.uid1                 
    --                 self.LeftPlayerList[count].name = v.name1  
    --                 self.LeftPlayerList[count].uid  = v.uid   
    --                 self.LeftPlayerList[count].lunci= v.lunci           
    --             end
    --         else

    --         end
    --     end
    -- end
end
function CUpperHalfLayer.initFourPlayerView( self ,firstdata,nowdata) --显示第四轮结果
    if  firstdata ~= nil then
        local Count    = firstdata.count 
        if Count > 0 then
            for i = 1,Count do
                if i <= 4 then
                    if nowdata ~= nil then
                        -- for k,v in pairs(nowdata) do
                        --     if  tonumber(firstdata[i].uid1)  ==  tonumber(v.uid) then
                        --         self.Left4LineSprite  : setVisible( true )  
                        --         self.WinnerNameBtn : setText(firstdata[i].name1)                          
                        --     end
                        --     if  tonumber(firstdata[i].uid2)  ==  tonumber(v.uid) then
                        --         self.Left4LineSprite  : setVisible( true )  
                        --         self.WinnerNameBtn : setText(firstdata[i].name2)                          
                        --     end
                        -- end
                        local icount = nowdata.count 
                        if icount > 0 then
                            for k=1,icount do
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) then 
                                    self.Left4LineSprite  : setVisible( true )  
                                    self.WinnerNameBtn : setText(firstdata[i].name1) 
                                end
                                if tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                    self.Left4LineSprite  : setVisible( true )  
                                    self.WinnerNameBtn : setText(firstdata[i].name2)  
                                end
                            end
                        end
                    end
                elseif i > 4 then
                    if nowdata ~= nil then
                        -- for k,v in pairs(nowdata) do
                        --     if  tonumber(firstdata[i].uid1)  ==  tonumber(v.uid) then
                        --         self.Right4LineSprite : setVisible( true )
                        --         self.WinnerNameBtn : setText(firstdata[i].name1) 
                        --     end
                        --     if  tonumber(firstdata[i].uid2)  ==  tonumber(v.uid) then
                        --         self.Right4LineSprite : setVisible( true )
                        --         self.WinnerNameBtn : setText(firstdata[i].name2) 
                        --     end
                        -- end
                        local icount = nowdata.count 
                        if icount > 0 then
                            for k=1,icount do
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) then 
                                    self.Right4LineSprite : setVisible( true )
                                    self.WinnerNameBtn : setText(firstdata[i].name1)
                                end
                                if tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                    self.Right4LineSprite : setVisible( true )
                                    self.WinnerNameBtn : setText(firstdata[i].name2)  
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function CUpperHalfLayer.initThirdPlayerView( self ,firstdata,nowdata) --显示第三轮结果
    if  firstdata ~= nil then
        local Count    = firstdata.count 
        if Count > 0 then
            for i = 1,Count do
                print("第三轮的I==",i,firstdata,nowdata,nowdata.count)
                if i <= 4 then
                    if nowdata ~= nil then
                        local icount = nowdata.count 
                        if icount > 0 then
                            for k=1,icount do
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) or tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                   if i <=2 then
                                        self.Left3LineSprite[4]    : setVisible( true ) 
                                    else 
                                        self.Left3LineSprite[8]    : setVisible( true ) 
                                    end 
                                end
                            end
                        end
                        -- for k,v in pairs(nowdata) do
                        --     if  tonumber(firstdata[i].uid1)  ==  tonumber(v.uid) or tonumber(firstdata[i].uid2)  ==  tonumber(v.uid) then
                        --        if i <=2 then
                        --             self.Left3LineSprite[4]    : setVisible( true ) 
                        --         else 
                        --             self.Left3LineSprite[8]    : setVisible( true ) 
                        --         end                            
                        --     end
                        -- end
                    end
                elseif i > 4 then
                    print("tttttttttt1")
                    if nowdata ~= nil then
                        -- for k,v in pairs(nowdata) do
                        --     if  tonumber(firstdata[i].uid1)  ==  tonumber(v.uid) or tonumber(firstdata[i].uid2)  ==  tonumber(v.uid) then
                        --        if i <=6 then
                        --             self.Right3LineSprite[4]    : setVisible( true ) 
                        --         else 
                        --             self.Right3LineSprite[8]    : setVisible( true ) 
                        --         end  
                        --     end
                        -- end
                        print("tttttttttt12")
                        local icount = nowdata.count 
                        if icount > 0 then
                            print("tttttttttt3")
                            for k=1,icount do
                                print("tttttttttt4")
                                print("显示第三33轮结果 ++++++++++++++++++++++ ",i,firstdata[i].uid1,firstdata[i].uid2,k,nowdata[k].uid)
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) or tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                    if i <=6 then
                                        self.Right3LineSprite[4]    : setVisible( true ) 
                                    else 
                                        self.Right3LineSprite[8]    : setVisible( true ) 
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


function CUpperHalfLayer.initSecondPlayerView( self ,firstdata,nowdata) --显示第二轮结果
    if  firstdata ~= nil then
        local Count    = firstdata.count 
        if Count > 0 then
            for i = 1,Count do
                if i <= 4 then
                    no = i * 2
                    if nowdata ~= nil then
                        local icount = nowdata.count 
                        if icount > 0 then
                            for k=1,icount do
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) or tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                    self.Left2LineSprite[no] : setVisible( true ) 
                                end
                            end
                        end
                    end
                elseif i > 4 then
                    no = (i-4) * 2
                    print("显示第二轮结果 no ----------------",no)
                    if nowdata ~= nil then
                        local icount = nowdata.count 
                        if icount > 0 then
                            for k=1,icount do
                                    --print("显示第二轮结果 ++++++++++++++++++++++ ",i,firstdata[i].uid1,firstdata[i].uid2,k,nowdata[k].uid)
                                if  tonumber(firstdata[i].uid1)  ==  tonumber(nowdata[k].uid) or tonumber(firstdata[i].uid2)  ==  tonumber(nowdata[k].uid) then
                                    self.Right2LineSprite[no] : setVisible( true ) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function CUpperHalfLayer.MsgDataGrouping( self, Msg,RoundNo)
    local data = {}
    local count = 0 
    if Msg ~= nil and RoundNo > 0 then
        for k,v in pairs(Msg) do
            print("第"..RoundNo.."轮---------->",k,v,v.name1,v.name2,v.lunci,v.uid)
            if tonumber(v.lunci) == RoundNo then
                count = count + 1 

                data[count] = {}
                data[count] = v 
            end 
        end
        data.count = count
        print("--------------------------------------------------------------------------------------------->")
    end
    return data
end

-- function CUpperHalfLayer.initDividingLabelData(self,Count,data) --初始化第一轮数据
--     if Count ~= nil and Count > 0 then
--         for i = 1,Count do
--             if i <= 4 then
--                 no = i * 2
--                 if data[i].name1 ~= nil then
--                     self.LeftDividingLabel[no-1] : setString(data[i].name1)
--                 end
--                 if data[i].name2 ~= nil then
--                     self.LeftDividingLabel[no]   : setString(data[i].name2)
--                 end
--                 --显示第一轮结果
--                 if tonumber(data[i].uid1)  ==  tonumber(data[i].uid) then
--                     self.Left1LineSprite[no-1]    : setVisible( true ) 
--                 end
--                 if  tonumber(data[i].uid2) ==  tonumber(data[i].uid) then
--                     self.Left1LineSprite[no]    : setVisible( true ) 
--                 end
--             elseif i > 4 then
--                 no = (i-4) * 2
--                 if data[i].name1 ~= nil then
--                     self.RightDividingLabel[no-1] : setString(data[i].name1)
--                 end
--                 if data[i].name2 ~= nil then
--                     self.RightDividingLabel[no]   : setString(data[i].name2)
--                 end
--                 --显示第一轮结果
--                 if tonumber(data[i].uid1)  ==  tonumber(data[i].uid) then
--                     self.Right1LineSprite[no-1]    : setVisible( true ) 
--                 end
--                 if  tonumber(data[i].uid2) ==  tonumber(data[i].uid) then
--                     self.Right1LineSprite[no]    : setVisible( true ) 
--                 end
--             end
--         end
--     end
-- end
--mediator 注册
function CUpperHalfLayer.registerMediator(self)
    print("CUpperHalfLayer.mediatorRegister 75")
    _G.g_UpperHalfLayerMediator = CUpperHalfLayerMediator (self)
    controller :registerMediator(  _G.g_UpperHalfLayerMediator )
end
--协议发送
function CUpperHalfLayer.REQ_WRESTLE_FINAL_REQUEST(self) -- [54850]请求上半区数据 -- 格斗之王  决赛入口
    require "common/protocol/auto/REQ_WRESTLE_FINAL_REQUEST" 
    local msg = REQ_WRESTLE_FINAL_REQUEST()
    msg : setType(0)
    CNetwork  : send(msg)
    print("REQ_WRESTLE_FINAL_REQUEST 54850 决赛入口 -- 格斗之王   发送完毕 ")
end

--协议返回

function CUpperHalfLayer.NetWorkReturn_WRESTLE_STATE(self,State) --sever methond
    print("CUpperHalfLayer.NetWorkReturn_WRESTLE_STATE",State)
    local msg = ""
    if State ~= nil then
        if State == _G.Constant.CONST_WRESTLE_JUESAIJINGXINGZHONG then
            msg = "决赛进行中"
        elseif State == _G.Constant.CONST_WRESTLE_JUESAIJIESHU then
            msg = "决赛结束"
        else
            msg = "决赛暂未开始"
        end
    
        self.InfoLabel : setString(msg)
    end
end

function CUpperHalfLayer.NetWorkReturn_WRESTLE_TIME(self,nowtime,endTime,startTime) --sever methond
    print("CUpperHalfLayer [54805]各种倒计时 -- 格斗之王888 ",nowtime,endTime,startTime)
    local Value      = nil 

    local leftTime   = nil
    local gotime     = nil
    leftTime   = tonumber(endTime) - tonumber(startTime) 
    gotime     = tonumber(nowtime) - tonumber(startTime) 
    print("print the time = ",startTime,nowtime,endTime)
    print("true time ======",leftTime,gotime)
    print("轮次====",self.translunci)
    if self.translunci ~= nil and self.translunci == 1 then
                    print("是第一轮的倒计时")
        if startTime < nowtime and gotime <= _G.Constant.CONST_WRESTLE_BEFORE_TIME then
            Value = _G.Constant.CONST_WRESTLE_BEFORE_TIME - gotime
        end
    else
        if startTime > nowtime then
            Value = startTime - nowtime + _G.Constant.CONST_WRESTLE_BEFORE_TIME
            print("不是第一轮的倒计时")
            if Value > _G.Constant.CONST_WRESTLE_START_NULL then
                Value = _G.Constant.CONST_WRESTLE_START_NULL
            end
        else
            if gotime <= _G.Constant.CONST_WRESTLE_BEFORE_TIME then
                Value = _G.Constant.CONST_WRESTLE_BEFORE_TIME - gotime
            end
        end
    end

    if Value ~= nil and Value > 0 then
        --倒计时
        self : setReceiveAwardsTime(Value)
        self : registerEnterFrameCallBack()
    end
end

----倒计时
function CUpperHalfLayer.registerEnterFrameCallBack(self,nowtime,endTime,startTime)
    print( "CUpperHalfLayer.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset() 
        self :updataReceiveAwardsTime( _duration)
    end
    self.Scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CUpperHalfLayer.updataReceiveAwardsTime( self, _duration)
    if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
        return
    end
    self.m_receiveawardstime = self.m_receiveawardstime - _duration
    if self.m_receiveawardstime <= 0 then
        print("倒数完了")
    else
        local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.NextTimeLeftLabel :setString("离下场对决还剩 : "..fomarttime)
    end
end

function CUpperHalfLayer.setReceiveAwardsTime(self, _time)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
    local fomarttime = self :turnTime( self.m_receiveawardstime)
    self.NextTimeLeftLabel :setString("离下场对决还剩 : "..fomarttime)
end

function CUpperHalfLayer.turnTime( self, _time)
    _time = _time < 0 and 0 or _time
    local hor  = math.floor( _time/(60*60))
    hor = hor < 0 and 0 or hor
    local min  = math.floor( _time/60-hor*60)
    min = min < 0 and 0 or min
    local sec  = math.floor( _time-hor*60*60-min*60)
    sec = sec < 0 and 0 or sec    
    hor = self :toTimeString( hor)
    min = self :toTimeString( min )
    sec = self :toTimeString( sec )
    return min..":"..sec
end
--{时间转字符串}
function CUpperHalfLayer.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end

function CUpperHalfLayer.clickInfo( self )
    print( "查看信息:")
    --请求玩家身上装备 --本玩家
    print("请求玩家身上装备开始")
    local msg = REQ_GOODS_EQUIP_ASK()
    msg :setUid( self.m_nUid)
    msg :setPartner( 0)
    _G.CNetwork :send( msg)
    print("请求玩家身上装备结束")
    print("请求玩家属性开始:"..(self.m_nUid))
    local msg_role = REQ_ROLE_PROPERTY()
    msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg_role: setUid( self.m_nUid )
    msg_role: setType( 0 )
    _G.CNetwork : send( msg_role )
    print("请求玩家属性结束")
end

function CUpperHalfLayer.NetWorkReturn_WRESTLE_FINAL_REP( self,Turn,Count,Msg)
    print("CUpperHalfLayer收到新协议发过来的数据",Turn,Count,Msg)
    self.Msg = Msg --传递给欢乐竞猜
    if Count > 0 and Msg ~= nil then
        for i,player in pairs(Msg) do
            print("----->>>>>>>>>>>>>>>",player.index,player.uid,"====="..player.name,player.is_fail,player.fail_turn)
            local  index  = tonumber(player.index)
            if index <= 8 then
                self.LeftDividingLabel[index] : setString(player.name) 
            else
                index = index - 8 
                self.RightDividingLabel[index] : setString(player.name) 
            end
        end
        self : initNewDividingLabelData(Turn,Msg)
    end
end


function CUpperHalfLayer.initNewDividingLabelData(self,Turn,data) 
    if data ~= nil then
        for k,player in pairs(data) do
            ----一直赢的-------------------------------------------------------------------------
            local WinTimes = nil
            local index    = tonumber(player.index)
            if player.is_fail == 0 then
                WinTimes = Turn-1 
            elseif player.is_fail == 1 then
                WinTimes = tonumber(player.fail_turn )-1 
            end
               
            if index > 0 then
                if WinTimes > 0 then
                    print("000000009999",index)
                    local Position = nil 
                    if index <= 8  then
                        Position = "Left"
                    else
                        index = index - 8 
                        Position = "Right"
                    end
                    print("index====",index,WinTimes)
                    for i=1,WinTimes do
                        if i == 2 then
                            if index % 2 == 1 then
                                index = index +1
                            end
                            --index = index/2
                        elseif i == 3 then
                            if index <= 4 then
                                index = 4
                            else
                                index = 8
                            end
                        end

                        print("000000009999",i,Position,index)
                        if i ~= 4 then
                            print("1----->",i,Position,index)
                            self[Position..i.."LineSprite"][index]    : setVisible( true ) 
                        else
                            print("2----->",i,Position,index)
                            self[Position..i.."LineSprite"]    : setVisible( true ) 
                            self.WinnerNameBtn : setText(player.name)
                        end
                    end

                end
            end
            -----部分输的------------------------------------------------------------------------


        end
    end
end



--     if Count ~= nil and Count > 0 then
--         for i = 1,Count do
--             if i <= 4 then
--                 no = i * 2
--                 if data[i].name1 ~= nil then
--                     self.LeftDividingLabel[no-1] : setString(data[i].name1)
--                 end
--                 if data[i].name2 ~= nil then
--                     self.LeftDividingLabel[no]   : setString(data[i].name2)
--                 end
--                 --显示第一轮结果
--                 if tonumber(data[i].uid1)  ==  tonumber(data[i].uid) then
--                     self.Left1LineSprite[no-1]    : setVisible( true ) 
--                 end
--                 if  tonumber(data[i].uid2) ==  tonumber(data[i].uid) then
--                     self.Left1LineSprite[no]    : setVisible( true ) 
--                 end
--             elseif i > 4 then
--                 no = (i-4) * 2
--                 if data[i].name1 ~= nil then
--                     self.RightDividingLabel[no-1] : setString(data[i].name1)
--                 end
--                 if data[i].name2 ~= nil then
--                     self.RightDividingLabel[no]   : setString(data[i].name2)
--                 end
--                 --显示第一轮结果
--                 if tonumber(data[i].uid1)  ==  tonumber(data[i].uid) then
--                     self.Right1LineSprite[no-1]    : setVisible( true ) 
--                 end
--                 if  tonumber(data[i].uid2) ==  tonumber(data[i].uid) then
--                     self.Right1LineSprite[no]    : setVisible( true ) 
--                 end
--             end
--         end
--     end
-- end


