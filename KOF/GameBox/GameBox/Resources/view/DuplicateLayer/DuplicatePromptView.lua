--[[
 --CDuplicatePromptView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
--require "view/DuplicateLayer/DuplicateView"
require "view/DuplicateLayer/HangupView"
require "controller/GuideCommand"

CDuplicatePromptView = class(view, function( self)
    print("CDuplicatePromptView:角色信息主界面")
    CDuplicatePromptView.readscenecopyxml = nil
    self.m_enterButton            = nil   --确认进入副本按钮
    self.m_closedButton           = nil   --关闭按钮
    self.m_tagLayout              = nil   --3种Tag按钮的水平布局
    self.m_duplicatePromptContainer  = nil  --人物面板的容器层
end)

_G.pDuplicatePromptView = CDuplicatePromptView()
--Constant:
CDuplicatePromptView.TAG_ENTER      = 201
CDuplicatePromptView.TAG_REFRESH    = 202
CDuplicatePromptView.TAG_TEAM       = 203
CDuplicatePromptView.TAG_HANGUP     = 204

CDuplicatePromptView.FONT_SIZE      = 20

--加载资源
function CDuplicatePromptView.loadResource( self)
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
end
--释放资源
function CDuplicatePromptView.unLoadResource( self)
end
--初始化数据成员
function CDuplicatePromptView.initParams( self, layer)
    print("CDuplicatePromptView.initParams")
end
--释放成员
function CDuplicatePromptView.realeaseParams( self)
end

function CDuplicatePromptView.reset( self)
    -- body
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
        self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
        self.m_scenelayer = nil
    end
end

--布局成员
function CDuplicatePromptView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--副本Tips界面5")
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local duplicatebackground    = self.m_duplicatePromptContainer :getChildByTag( 100)
        local promptviewSize         = CCSizeMake( backgroundSize.width*0.7, winSize.height*0.6)
        local buttonSize             = self.m_enterButton :getPreferredSize()
        self.m_backgroundsize        = promptviewSize
        duplicatebackground :setPreferredSize( promptviewSize)
        duplicatebackground :setPosition( ccp( winSize.width/2, winSize.height/2))

        self.m_tagLayout :setPosition( winSize.width/2-promptviewSize.width/2-40, winSize.height/2+promptviewSize.height/2-150)
        local cellLabelSize  = CCSizeMake( (promptviewSize.width-70)/3, (promptviewSize.height-buttonSize.height*1.5-220)/4)
        self.m_tagLayout :setCellHorizontalSpace( 10)
        self.m_tagLayout :setCellVerticalSpace( 5)
        self.m_tagLayout :setCellSize( cellLabelSize)
        self.m_spliteLineone :setPosition( ccp( winSize.width/2, winSize.height/2+promptviewSize.height/2-30))
        self.m_spliteLinetwo :setPosition( ccp( winSize.width/2, winSize.height/2-promptviewSize.height/2+30))

        self.m_copyName  :setPosition( ccp( winSize.width/2, winSize.height/2+promptviewSize.height/2-50))
        self.m_useEnergy :setPosition( ccp( winSize.width/2, winSize.height/2+promptviewSize.height/2-80))
        self.m_allEnergy :setPosition( ccp( winSize.width/2, winSize.height/2+promptviewSize.height/2-110))

        if self.m_buttonstate.eva ~= nil and self.m_buttonstate.eva ~= 0 then
            local evaSABSize = self.m_evaSAB :getPreferredSize()
            self.m_evaSAB :setPosition( ccp( winSize.width/2+promptviewSize.width/2-evaSABSize.width/2-50, winSize.height/2+promptviewSize.height/2-evaSABSize.height/2-50))
        end

        self.m_refreshButton :setPosition( ccp( winSize.width/2, winSize.height/2-promptviewSize.height/2+buttonSize.height/2+45))
        self.m_teamButton :setPosition( ccp( winSize.width/2, winSize.height/2-promptviewSize.height/2+buttonSize.height/2+45))
        self.m_hangupButton :setPosition( ccp( winSize.width/2-promptviewSize.width/2+100, winSize.height/2-promptviewSize.height/2+buttonSize.height/2+45))
        self.m_enterButton :setPosition( ccp( winSize.width/2+promptviewSize.width/2-100, winSize.height/2-promptviewSize.height/2+buttonSize.height/2+45))

        if self.m_buttonstate.refresh == 1 then
            print("刷新")
            self.m_refreshButton :setVisible( true)
            self.m_teamButton :setVisible( false)
            self.m_enterButton :setVisible( false)
            self.m_hangupButton :setVisible( false)
        else
            self.m_refreshButton :setVisible( false)
            print("进入")
            self.m_enterButton :setVisible( true)
            if self.m_buttonstate.team == 1 then
                print("组队")
                self.m_teamButton :setVisible( true)
            else
                self.m_teamButton :setVisible( false)--false)
            end
            if self.m_buttonstate.hangup == 1 then
                print("挂机")
                self.m_hangupButton :setVisible( true)
            else
                self.m_hangupButton :setVisible( false)
            end
        end
        print("XXXSSSSS: "..self.m_copyid.."组队条件 ",self.m_buttonstate.team.." 挂机条件 "..self.m_buttonstate.hangup.." 刷新条件 "..self.m_buttonstate.refresh)
        --self.m_duplicatePromptContainer :setPosition( ccp( -winSize.width/2+promptviewSize.width/2, -promptviewSize.height))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
    --self :setPopupViewPosition()
end

--设置Tip的位置 --使其在屏幕内显示
function CDuplicatePromptView.setPopupViewPosition( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    ---[[
    if self.m_position.x+self.m_backgroundsize.width > winSize.width then
        self.m_position.x = winSize.width - self.m_backgroundsize.width
    end
    if self.m_position.y-self.m_backgroundsize.height < 0 then
        self.m_position.y = self.m_backgroundsize.height
    end
    self.m_scenelayer :setPosition( ccp( self.m_position.x, self.m_position.y))
    --]]
end

function CDuplicatePromptView.getBtnByTag( self, _tag )
    if self.m_scenelayer ~= nil then
        if self.m_duplicatePromptContainer :getChildByTag( _tag ) ~= nil then
            local btn = self.m_duplicatePromptContainer :getChildByTag( _tag )
            if btn :isVisible() == true then
                return btn
            end
        end
    end
    return nil
end

--主界面初始化
function CDuplicatePromptView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
    --初始化指引

    local function runInitGuide()
        _G.pCGuideManager:initGuide( nil ,self.m_copyid)
    end
    _G.pCGuideManager:lockScene() --initGuide( self.m_scene,self.m_npcId)
    layer:performSelector(0.08,runInitGuide)

end

function CDuplicatePromptView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CDuplicatePromptView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CDuplicatePromptView.layer( self, _transferid, _copyid, _buttonstate, _position)
    print("create m_scenelayer",_copyid)
    self.m_transferID  = _transferid
    self.m_copyid      = tonumber(_copyid)
    self.m_buttonstate = _buttonstate
    self.m_position    = _position

    self.m_copyrewards = self :getCopyRewards( self.m_copyid)
    print("self.m_copyrewards",self.m_copyrewards,self)
    self.m_useenergy   = self :getUseEnergy( self.m_copyid)
    self.m_allenergy   = _G.g_characterProperty:getMainPlay():getSum() or 0
    ---------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    --self.m_scenelayer :setFullScreenTouchEnabled( true)
    --self.m_scenelayer :setTouchesEnabled(true)
    self.m_scenelayer : setControlName("this is CDuplicatePromptView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CDuplicatePromptView.createTiShiBox( self, _msg )
    if self.m_scenelayer ~= nil then
        local parent = self.m_scenelayer : getParent()

        require "view/ErrorBox/ErrorBox"
        local ErrorBox  = CErrorBox()
        local BoxLayer  = ErrorBox : create( _msg, _askFunc, _cancelFunc )
        parent : addChild( BoxLayer, 1000)
    end
end

function CDuplicatePromptView.getCopyRewards( self, _copyid)
    local copy_id = tostring( _copyid)
    _G.Config :load( "config/copy_reward.xml")
    return _G.Config.copy_rewards :selectSingleNode( "copy_reward[@copy_id="..copy_id.."]")
end

function CDuplicatePromptView.getUseEnergy( self, _copyid)
    local sceneCopyNode = _G.g_DuplicateDataProxy:getDuplicateNameByCopyId( _copyid )
    if sceneCopyNode == nil then
        print( " 没有找到副本对应场景")
        return 1
    end
    return sceneCopyNode:getAttribute("use_energy")
end

function CDuplicatePromptView.getHangupTimesByCopyId( self, _copyid )
    local buff      = _G.g_characterProperty:getMainPlay():getBuffValue() or 0
    local energyHas = _G.g_characterProperty:getMainPlay():getSum() + buff
    local times = math.floor( energyHas/self.m_useenergy)
    return times
end

--_string   字段名   默认 ""
--_value    字段值   默认 ""
--_color    颜色值   默认 白色
--_fontsize 字体大小 默认 CDuplicatePromptView.FONT_SZIE
function CDuplicatePromptView.createRewardsInfo( self, _string, _value, _color, _fontsize)
    --print( _string.." ".._value)
    if _string == nil then
        _string = ""
    end
    if _value == nil then
        _value = ""
    end
    if _fontsize == nil then
        _fontsize = CDuplicatePromptView.FONT_SIZE
    end
    local rewardLabel = CCLabelTTF :create( _string.." ".._value, "Arial", _fontsize)
    if _color ~= nil then
        rewardLabel :setColor( _color)
    end
    rewardLabel :setAnchorPoint( ccp(0,0.5))
    return rewardLabel
end

function CDuplicatePromptView.createSplitLine( self, _up, _down)
    print( "无耻的分割线\n----------------------------------------")
    local splitline = CSprite :createWithSpriteFrameName( "general_tips_line.png")
    if _up == true then
        local splitline2 = CSprite :createWithSpriteFrameName( "general_tips_line_4.png")
        splitline2 : setControlName( "this CGoodsInfoView splitline2 118 ")
        splitline2 :setScale( -1)
        splitline2Szie = splitline2 :getPreferredSize()
        splitline2 :setPosition( ccp( 0, splitline2Szie.height/2-9))
        splitline :addChild( splitline2)
    end
    if _down == true then
        local splitline3 = CSprite :createWithSpriteFrameName( "general_tips_line_4.png")
        splitline3 : setControlName( "this CGoodsInfoView splitline3 118 ")
        splitline3Szie = splitline3 :getPreferredSize()
        splitline3 :setPosition( ccp( 0, -splitline3Szie.height/2+9))
        splitline :addChild( splitline3)
    end
    splitline : setControlName( "this CGoodsInfoView splitline 118 ")
    splitline :setAnchorPoint( ccp( 0,1))
    return splitline
end

function CDuplicatePromptView.getGoodNameXMLById( self, _id)
    local goodnode = _G.g_GameDataProxy :getGoodById( _id)
    if goodnode == nil then
        print( "3333XML 中没有找到相应节点",_id)
        return nil, nil
    else
        local color = nil
        color = self :getColorByIndex( goodnode : getAttribute("name_color") )
        return goodnode : getAttribute("name") , color
    end
end

function CDuplicatePromptView.getColorByIndex( self, _color)
    print( "COLOR: ",_color)
    local rgb, rgb4 = nil, nil
    if _color ~= nil then
        _color = tonumber( _color)
        rgb4   = _G.g_ColorManager :getRGBA( _color)
        rgb    = _G.g_ColorManager :getRGB( _color)
    else
        print("_color error")
        rgb  = ccc3( 255,255,255)         --颜色-白  -->
        rgb4 = ccc4( 255,255,255,255)
    end
    return rgb, rgb4
end

--初始化背包界面
function CDuplicatePromptView.initView(self, layer)
    print("CDuplicatePromptView.initView")
    --副本界面容器
    self.m_duplicatePromptContainer = CContainer :create()
    self.m_duplicatePromptContainer : setControlName("this is CDuplicatePromptView self.m_duplicatePromptContainer 94 ")
    layer :addChild( self.m_duplicatePromptContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end

    local duplicatebackground   = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")     --背景Img
    duplicatebackground : setControlName( "this CDuplicatePromptView duplicatebackground 124 ")

    self.m_enterButton          = self :createButton( "进入", "general_smallbutton_click.png", CallBack, CDuplicatePromptView.TAG_ENTER, "self.m_enterButton")
    self.m_refreshButton        = self :createButton( "刷新", "general_smallbutton_click.png", CallBack, CDuplicatePromptView.TAG_REFRESH, "self.m_refreshButton")
    self.m_teamButton           = self :createButton( "组队", "general_smallbutton_click.png", CallBack, CDuplicatePromptView.TAG_TEAM, "self.m_teamButton")
    self.m_hangupButton         = self :createButton( "挂机", "general_smallbutton_click.png", CallBack, CDuplicatePromptView.TAG_HANGUP, "self.m_hangupButton")

    --SAB
    if self.m_buttonstate.eva ~= nil and self.m_buttonstate.eva ~= 0 then -- 0 未通关，没有评价
        self.m_evaSAB    = CSprite :createWithSpriteFrameName( "copy_word_sab_0"..self.m_buttonstate.eva..".png")
        self.m_evaSAB : setControlName( "this CDuplicatePromptView self.m_evaSAB 305 ")
        self.m_duplicatePromptContainer :addChild( self.m_evaSAB)
    end
    print("fffffff",self.m_copyrewards,self)
    self.m_copyName  = self :createRewardsInfo( self.m_copyrewards:getAttribute("copy_name"), nil, nil, CDuplicatePromptView.FONT_SIZE+5)
    self.m_useEnergy = self :createRewardsInfo( "消耗体力:", self.m_useenergy, ccc3(255,255,0))
    self.m_allEnergy = self :createRewardsInfo( "剩余体力:", self.m_allenergy, ccc3(255,255,0))

    self.m_copyName :setAnchorPoint( ccp(0.5,0.5))
    self.m_useEnergy :setAnchorPoint( ccp(0.5,0.5))
    self.m_allEnergy :setAnchorPoint( ccp(0.5,0.5))

    self.m_tagLayout     = CHorizontalLayout :create()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setLineNodeSum(3)

    self.m_tagLayout :addChild( self :createRewardsInfo( "S 评价可得:", nil, ccc3(255,155,0), CDuplicatePromptView.FONT_SIZE+3))
    self.m_tagLayout :addChild( self :createRewardsInfo( "A 评价可得:", nil, ccc3(255,155,0), CDuplicatePromptView.FONT_SIZE+3))
    self.m_tagLayout :addChild( self :createRewardsInfo( "B 评价可得:", nil, ccc3(255,155,0), CDuplicatePromptView.FONT_SIZE+3))
    self.m_tagLayout :addChild( self :createRewardsInfo( "经验:", self.m_copyrewards:getAttribute("a_exp")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "经验:", self.m_copyrewards:getAttribute("b_exp")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "经验:", self.m_copyrewards:getAttribute("c_exp")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "潜能:", self.m_copyrewards:getAttribute("a_power")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "潜能:", self.m_copyrewards:getAttribute("b_power")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "潜能:", self.m_copyrewards:getAttribute("c_power")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "美刀:", self.m_copyrewards:getAttribute("a_money")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "美刀:", self.m_copyrewards:getAttribute("b_money")))  
    self.m_tagLayout :addChild( self :createRewardsInfo( "美刀:", self.m_copyrewards:getAttribute("c_money"))) 

    local goodname , name_color = nil, nil
    goodname, name_color = self :getGoodNameXMLById( self.m_copyrewards : children():get(0,"a_goods"):children():get(0,goods):getAttribute("goods_id") )
    if goodname ~= nil then
        self.m_tagLayout :addChild( self :createRewardsInfo( "", goodname, name_color))
        goodname = nil
    else
        self.m_tagLayout :addChild( self :createRewardsInfo())
    end
    goodname, name_color = self :getGoodNameXMLById( self.m_copyrewards : children():get(0,"b_goods"):children():get(0,goods):getAttribute("goods_id"))
    if goodname ~= nil then
        self.m_tagLayout :addChild( self :createRewardsInfo( "", goodname, name_color))
        goodname = nil
    else
        self.m_tagLayout :addChild( self :createRewardsInfo())
    end
    goodname, name_color = self :getGoodNameXMLById( self.m_copyrewards : children():get(0,"c_goods"):children():get(0,goods):getAttribute("goods_id"))
    if goodname ~= nil then
        self.m_tagLayout :addChild( self :createRewardsInfo( "", goodname, name_color))
        goodname = nil
    else
        self.m_tagLayout :addChild( self :createRewardsInfo())
    end
    self.m_spliteLineone = self :createSplitLine(false, true)
    self.m_spliteLinetwo = self :createSplitLine(true, false)

    self.m_duplicatePromptContainer :addChild( self.m_tagLayout)
    self.m_duplicatePromptContainer :addChild( duplicatebackground, -1, 100)
    self.m_duplicatePromptContainer :addChild( self.m_spliteLineone)
    self.m_duplicatePromptContainer :addChild( self.m_spliteLinetwo)
    self.m_duplicatePromptContainer :addChild( self.m_copyName)
    self.m_duplicatePromptContainer :addChild( self.m_useEnergy)
    self.m_duplicatePromptContainer :addChild( self.m_allEnergy)
    self.m_duplicatePromptContainer :addChild( self.m_enterButton)
    self.m_duplicatePromptContainer :addChild( self.m_refreshButton)
    self.m_duplicatePromptContainer :addChild( self.m_teamButton)
    self.m_duplicatePromptContainer :addChild( self.m_hangupButton)
end

--创建按钮Button
function CDuplicatePromptView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CDuplicatePromptView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CDuplicatePromptView ".._controlname)
    _itembutton :setFontSize( CDuplicatePromptView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :setTouchesPriority( -111)
    if _func ~= nil then
        _itembutton :registerControlScriptHandler( _func, "this CDuplicatePromptView ".._controlname.."CallBack")
    end
    return _itembutton
end


--更新本地list数据
function CDuplicatePromptView.setLocalList( self)
    print("CDuplicatePromptView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CDuplicatePromptView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("obj: getTag()", obj: getTag())

            _G.pCGuideManager:removeThisStep()

            if obj :getTag() == CDuplicatePromptView.TAG_HANGUP then
                print(" --挂机 -- 副本Id->",self.m_copyid)
                local specialnumber = 0
                local maxTimesNum   = nil
                local times = self :getHangupTimesByCopyId( self.m_copyid ) or 0
                if times == 0 then
                    --CCMessageBox("体力不足","提示")
                    local msg = "体力不足,是否购买"
                    self : createMessageBox( msg )
                    return
                end
                if self.m_transferID == 101 then
                    print("self.m_transferID == 101")
                    specialnumber = times

                    -- 是否非副本任务   true->不是副本任务
                    local isDefault    = true
                    local roleProperty = _G.g_characterProperty : getMainPlay()--玩家自己
                    local taskType ,taskCopyId, chapterId = roleProperty :getTaskInfo()
                    if taskCopyId ~= nil then
                        --有当前任务
                        if tonumber( taskCopyId ) == tonumber( self.m_copyid ) then
                            --当前任务为选中的任务
                            local haveCount, allCount = roleProperty:getTaskCount()
                            if haveCount ~= nil and allCount ~= nil then
                                local needCount = allCount - haveCount
                                if needCount > 0 and specialnumber > needCount then
                                    --该任务 需要挂机的次数
                                    specialnumber = needCount
                                    --副本任务
                                    isDefault     = false
                                end
                            end
                        end
                    end

                    if isDefault then
                        -- 不是副本任务,默认挂机次数3次
                        if specialnumber > 3 then
                            specialnumber = 3
                        end
                    end

                elseif self.m_transferID == 102 then
                    print("self.m_transferID == 102")
                    --剩余精英挂机次数
                    specialnumber = _G.g_DuplicateDataProxy : getTimes()
                    maxTimesNum   = specialnumber
                    if specialnumber == 0 then
                        --CCMessageBox("没有剩余次数","提示")
                        print("-----------    ",specialnumber)
                        local msg = "没有剩余次数"
                        self : createTiShiBox(msg)
                        _G.pDuplicatePromptView :reset()
                        return
                    elseif specialnumber > times then
                        --剩余次数大于可挂机次数
                        specialnumber = times
                        maxTimesNum   = times
                    end
                elseif self.m_transferID == 103 then
                    print("self.m_transferID == 103")
                    maxTimesNum   = 1
                    specialnumber = 1
                end
                print("   CDuplicatePromptView   剩余次数"..specialnumber)

                CCDirector:sharedDirector():popScene()

                _G.g_CHangupView = CHangupView()
                CCDirector : sharedDirector () : pushScene( _G.g_CHangupView :scene( self.m_copyid,0,-1,specialnumber,0,maxTimesNum) )

            elseif obj :getTag() == CDuplicatePromptView.TAG_TEAM then
                local roleProperty         = _G.g_characterProperty : getMainPlay()--玩家自己
                local taskType, taskCopyId, chapterId = roleProperty :getTaskInfo()
                local specialnumber        = _G.g_DuplicateDataProxy : getTimes()
                print("--关卡组队回调1011",self.m_copyid,taskType,self.m_transferID)
                if self.m_transferID == 101 then     --普通副本
                    CCDirector : sharedDirector () : pushScene ( CBuildTeamView : scene(self.m_copyid,_G.Constant.CONST_COPY_TYPE_NORMAL) ) --将要组队的场景self.m_copyid传进去
                elseif self.m_transferID == 102 then --英雄副本
                    if specialnumber > 0  then
                        CCDirector : sharedDirector () : pushScene ( CBuildTeamView : scene(self.m_copyid,_G.Constant.CONST_COPY_TYPE_HERO) ) --将要组队的场景self.m_copyid传进去
                    else
                        print("精英提示框")
                        --CCMessageBox("已无次数,请刷新次数再来","CDuplicateView.clickTeamCallBack")
                        local msg = "已无次数,请购买"
                        self : createTiShiBox(msg)
                    end
                elseif self.m_transferID == 103 then --魔王副本
                    --if specialnumber > 0  then
                    CCDirector : sharedDirector () : pushScene ( CBuildTeamView : scene(self.m_copyid,_G.Constant.CONST_COPY_TYPE_FIEND) ) --将要组队的场景self.m_copyid传进去
                    -- else
                    --     --CCMessageBox("已无次数,请明日再来","CDuplicateView.clickTeamCallBack")
                    --     local msg = "已无次数,请明日再来"
                    --     self : createTiShiBox(msg)
                    -- end
                end
            elseif obj :getTag() == CDuplicatePromptView.TAG_REFRESH then
                print( "刷新魔王副本:",self.m_copyid)
                _G.g_DuplicateDataProxy :REQ_FIEND_FRESH_COPY( self.m_copyid)
            elseif obj :getTag() == CDuplicatePromptView.TAG_ENTER then
                print(" 进入副本",self.m_copyid)
                _G.pCGuideManager :sendStepFinish()

                local mainProperty  = _G.g_characterProperty : getMainPlay()
                local currentStrength = nil
                if mainProperty ~= nil then
                    currentStrength = mainProperty : getSum() or 0      --当前体力值
                end

                if currentStrength ~= nil and currentStrength <= 0 then
                    self :createMessageBox( "体力不足,是否购买" )
                    return
                else

                    require "common/protocol/auto/REQ_COPY_CREAT"
                    local msg = REQ_COPY_CREAT()
                    msg : setCopyId( self.m_copyid )
                    _G.CNetwork : send(msg)
                end
            end
            --删除Tips
            _G.pDuplicatePromptView :reset()
        end
    end
end


function CDuplicatePromptView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()

    local function _askFunc()
        require "common/protocol/auto/REQ_ROLE_ASK_BUY_ENERGY"
        local msg = REQ_ROLE_ASK_BUY_ENERGY()
        CNetwork :send( msg)
    end

    local function _cancelFunc()
        CCLOG("删除自己")
    end


    local BoxLayer  = ErrorBox : create( _msg, _askFunc, _cancelFunc )
    ErrorBox :getBoxEnsureBtn() :setText("购买")
    self.m_duplicatePromptContainer : addChild( BoxLayer, 1000)

end


--[[
                print("关闭")
                if _G.pDuplicatePromptView ~= nil then
                    self.m_scenelayer :removeFromParentAndCleanup( true)
                    _G.pDuplicatePromptView = nil
                else
                    print("objSelf = nil", self)
                end
--]]















