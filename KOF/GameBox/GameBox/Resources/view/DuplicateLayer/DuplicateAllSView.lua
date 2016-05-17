--[[
 --CDuplicateAllSView
 --角色面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
--require "view/DuplicateLayer/DuplicateView"
require "view/DuplicateLayer/HangupView"
require "controller/GuideCommand"

CDuplicateAllSView = class(view, function( self)
    print("CDuplicateAllSView:角色信息主界面")
    CDuplicateAllSView.readscenecopyxml = nil
    self.m_rewardButton              = nil   --确认领取副本按钮
    self.m_tagLayout                 = nil   --3种Tag按钮的水平布局
    self.m_duplicateAllSContainer  = nil   --人物面板的容器层
end)

_G.pDuplicateAllSView = CDuplicateAllSView()
--Constant:
CDuplicateAllSView.TAG_ENTER      = 201
CDuplicateAllSView.TAG_REFRESH    = 202
CDuplicateAllSView.TAG_TEAM       = 203
CDuplicateAllSView.TAG_HANGUP     = 204

CDuplicateAllSView.FONT_SIZE      = 20

--加载资源
function CDuplicateAllSView.loadResource( self)
end
--释放资源
function CDuplicateAllSView.unLoadResource( self)
end
--初始化数据成员
function CDuplicateAllSView.initParams( self, layer)
    print("CDuplicateAllSView.initParams")
end
--释放成员
function CDuplicateAllSView.realeaseParams( self)
end

function CDuplicateAllSView.reset( self)
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
        self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
        self.m_scenelayer = nil
    end
end

--布局成员
function CDuplicateAllSView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--副本Tips界面5")
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local duplicatebackground    = self.m_duplicateAllSContainer :getChildByTag( 100)
        local promptviewSize         = CCSizeMake( backgroundSize.width*0.3, winSize.height*0.45)
        local buttonSize             = self.m_rewardButton :getPreferredSize()
        self.m_backgroundsize        = promptviewSize
        duplicatebackground :setPreferredSize( promptviewSize)
        duplicatebackground :setPosition( ccp( winSize.width/2, winSize.height/2))

        self.m_tagLayout :setPosition( winSize.width/2-promptviewSize.width/2, winSize.height/2+promptviewSize.height/2-50)
        local cellLabelSize  = CCSizeMake( (promptviewSize.width-70)/3, (promptviewSize.height-buttonSize.height*1.5-80)/4)
        self.m_tagLayout :setCellHorizontalSpace( 10)
        --self.m_tagLayout :setCellVerticalSpace( 10)
        self.m_tagLayout :setCellSize( cellLabelSize)

        self.m_spliteLineone :setScaleX( 0.5)
        self.m_spliteLinetwo :setScaleX( 0.5)
        self.m_spliteLineone :setPosition( ccp( winSize.width/2, winSize.height/2+promptviewSize.height/2-30))
        self.m_spliteLinetwo :setPosition( ccp( winSize.width/2, winSize.height/2-promptviewSize.height/2+30))

        self.m_rewardButton :setPosition( ccp( winSize.width/2, winSize.height/2-promptviewSize.height/2+buttonSize.height/2+45))
        self.m_duplicateAllSContainer :setPosition( ccp( winSize.width/2 - promptviewSize.width-20, 50))

        if _G.g_DuplicateDataProxy : getChapterReward() == 1 then
            self.m_rewardButton : setTouchesEnabled( false)
        elseif _G.g_DuplicateDataProxy : getChapterReward() == 0 then
            if self : getIsReward() == false then
                self.m_rewardButton : setTouchesEnabled( false)
            end            
        end
    --768
    elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
    --self :setPopupViewPosition()
end

--设置Tip的位置 --使其在屏幕内显示
function CDuplicateAllSView.setPopupViewPosition( self)
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

function CDuplicateAllSView.getBtnByTag( self, _tag )
    if self.m_scenelayer ~= nil then
        if self.m_duplicateAllSContainer :getChildByTag( _tag ) ~= nil then
            local btn = self.m_duplicateAllSContainer :getChildByTag( _tag )
            if btn :isVisible() == true then
                return btn
            end
        end
    end
    return nil
end

--主界面初始化
function CDuplicateAllSView.init(self, winSize, layer)
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
end

function CDuplicateAllSView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CDuplicateAllSView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CDuplicateAllSView.layer( self, _transferID)

    self.m_transferID  = _transferID
    self.m_copyrewards = _G.g_DuplicateDataProxy : getChapterRewardList()

    --self :getCopyRewards( self.m_copyid)
    ---------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    --self.m_scenelayer :setFullScreenTouchEnabled( true)
    --self.m_scenelayer :setTouchesEnabled(true)
    self.m_scenelayer : setControlName("this is CDuplicateAllSView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CDuplicateAllSView.getIsReward( self)
    local duplicatelist    = _G.g_DuplicateDataProxy : getDuplicateList()   --副本信息  copy_id  is_pass
    for k,v in pairs(duplicatelist) do
        print(k,(v.copy_id))
        if 3 ~= v.eva then  --有不为S false
            return false
        end
    end
    return true
end

function CDuplicateAllSView.getGoodNameXMLById( self, _id)
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

function CDuplicateAllSView.getColorByIndex( self, _color)
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
function CDuplicateAllSView.initView(self, layer)
    print("CDuplicateAllSView.initView")
    --副本界面容器
    self.m_duplicateAllSContainer = CContainer :create()
    self.m_duplicateAllSContainer : setControlName("this is CDuplicateAllSView self.m_duplicateAllSContainer 94 ")
    layer :addChild( self.m_duplicateAllSContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end

    local duplicatebackground   = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")     --背景Img
    duplicatebackground : setControlName( "this CDuplicateAllSView duplicatebackground 124 ")

    local temp = "error"
    if _G.g_DuplicateDataProxy : getChapterReward() == 1 then
        temp = "已领取"
    elseif _G.g_DuplicateDataProxy : getChapterReward() == 0 then
        temp = "领取"
    end

    self.m_rewardButton          = self :createButton( temp, "general_button_normal.png", CallBack, CDuplicateAllSView.TAG_ENTER, "self.m_rewardButton")

    self.m_rewardName            = self :createRewardsInfo( "全S评价可得", nil, ccc3(255,155,0), CDuplicateAllSView.FONT_SIZE+5)
    self.m_rewardName : setAnchorPoint( ccp( -0.15, 0.5))

    self.m_tagLayout     = CHorizontalLayout :create()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setLineNodeSum(1)

    self.m_tagLayout :addChild( self.m_rewardName )
    --self.m_tagLayout :addChild( self :createRewardsInfo( "全S评价可得:", nil, ccc3(255,155,0), CDuplicateAllSView.FONT_SIZE+3))
    --self.m_tagLayout :addChild( self :createRewardsInfo())
    local goodname , name_color = nil, nil
    for i=1, self.m_copyrewards : children() : getCount("reward") do
        print(i)
        goodname, name_color = self :getGoodNameXMLById( self.m_copyrewards :children():get(i-1,"reward"):getAttribute("goods_id") )
        if goodname ~= nil then
            self.m_tagLayout :addChild( self :createRewardsInfo( "", goodname.." *"..(self.m_copyrewards :children():get(i-1,"reward"):getAttribute("goods_count")) or 0, name_color, CDuplicateAllSView.FONT_SIZE+3))
            goodname = nil
        else
            self.m_tagLayout :addChild( self :createRewardsInfo())
        end
    end
    self.m_spliteLineone = self :createSplitLine(false, true)
    self.m_spliteLinetwo = self :createSplitLine(true, false)

    self.m_duplicateAllSContainer :addChild( self.m_tagLayout)
    self.m_duplicateAllSContainer :addChild( duplicatebackground, -1, 100)
    --self.m_duplicateAllSContainer :addChild( self.m_rewardName)
    self.m_duplicateAllSContainer :addChild( self.m_spliteLineone)
    self.m_duplicateAllSContainer :addChild( self.m_spliteLinetwo)
    self.m_duplicateAllSContainer :addChild( self.m_rewardButton)
end

--创建按钮Button
function CDuplicateAllSView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CDuplicateAllSView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CDuplicateAllSView ".._controlname)
    _itembutton :setFontSize( CDuplicateAllSView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :setTouchesPriority( -111)
    if _func ~= nil then
        _itembutton :registerControlScriptHandler( _func, "this CDuplicateAllSView ".._controlname.."CallBack")
    end
    return _itembutton
end


--_string   字段名   默认 ""
--_value    字段值   默认 ""
--_color    颜色值   默认 白色
--_fontsize 字体大小 默认 CDuplicateAllSView.FONT_SZIE
function CDuplicateAllSView.createRewardsInfo( self, _string, _value, _color, _fontsize)
    --print( _string.." ".._value)
    if _string == nil then
        _string = ""
    end
    if _value == nil then
        _value = ""
    end
    if _fontsize == nil then
        _fontsize = CDuplicateAllSView.FONT_SIZE
    end
    local rewardLabel = CCLabelTTF :create( _string.." ".._value, "Arial", _fontsize)
    if _color ~= nil then
        rewardLabel :setColor( _color)
    end
    rewardLabel :setAnchorPoint( ccp(0,0.5))
    return rewardLabel
end

function CDuplicateAllSView.createSplitLine( self, _up, _down)
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

--更新本地list数据
function CDuplicateAllSView.setLocalList( self)
    print("CDuplicateAllSView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CDuplicateAllSView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            print("obj: getTag()", obj: getTag())
            if obj :getTag() == CDuplicateAllSView.TAG_ENTER then
                require "common/protocol/auto/REQ_COPY_CHAP_REWARD"
                local msg = REQ_COPY_CHAP_REWARD()
                print("领取章节评价奖励 -- 副本\nREQ_COPY_CHAP_REWARD:".._G.Protocol.REQ_COPY_CHAP_REWARD,"type:",tonumber(self.m_transferID)-100)
                msg :setType( tonumber(self.m_transferID)-100) --1,2,3  普通，精英，魔王
                msg :setChapId( _G.g_DuplicateDataProxy :getCurrentChapter())
                CNetwork :send( msg)
            end
            --删除Tips
            _G.pDuplicateAllSView :reset()
        end
    end
end


function CDuplicateAllSView.createMessageBox(self,_msg)
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
    self.m_duplicateAllSContainer : addChild( BoxLayer, 1000)

end












