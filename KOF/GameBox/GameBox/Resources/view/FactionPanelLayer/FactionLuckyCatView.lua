--[[
 --CFactionLuckyCatView
 --社团招财猫主界面
 --]]
require "view/view"
require "mediator/mediator"
require "controller/command"

require "controller/FactionCommand"

require "common/protocol/auto/REQ_CLAN_ASK_WATER"
require "common/protocol/auto/REQ_CLAN_START_WATER"

CFactionLuckyCatView = class(view, function( self)
    print("CFactionLuckyCatView:社团招财猫主界面")
    self.m_exp                   = 10
    self.m_expn                  = 100
    self.m_stamina               = 0
    self.m_playtimes             = 0
    self.m_YQtimes               = 0
    self.m_logsdata              = nil
    self.m_closedButton          = nil   --关闭按钮
    self.m_factionLuckyCatViewContainer  = nil  --人物面板的容器层
end)
--Constant:
CFactionLuckyCatView.TAG_PLAY        = 200  --玩耍
CFactionLuckyCatView.TAG_FEEDING     = 201  --喂食
CFactionLuckyCatView.TAG_BATHE       = 202  --洗澡
CFactionLuckyCatView.TAG_LUCKY       = 203  --招财
CFactionLuckyCatView.TAG_CLOSED      = 204  --关闭

CFactionLuckyCatView.FONT_SIZE        = 20

--加载资源
function CFactionLuckyCatView.loadResource( self)

end
--释放资源
function CFactionLuckyCatView.unLoadResource( self)
end
--初始化数据成员
function CFactionLuckyCatView.initParams( self, layer)
    print("CFactionLuckyCatView.initParams")
    require "mediator/FactionMediator"
    self.m_mediator = CFactionLuckyCatMediator( self)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionLuckyCatView.realeaseParams( self)
end
--布局成员
function CFactionLuckyCatView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团招财猫主界面")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst         = self.m_factionLuckyCatViewContainer :getChildByTag( 99)
        local panelbackgroundfirst    = self.m_factionLuckyCatViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_factionLuckyCatViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton :getPreferredSize()
        --local createButtonSize        = self.m_playButton :getPreferredSize()       
        panelbackgroundfirst :setPreferredSize( backgroundSize)
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87))   
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))     
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2, winSize.height*0.87/2+15))
        --界面名称
        self.m_viewnameLabel :setPosition( winSize.width/2, winSize.height/2+backgroundSize.height/2-closeButtonSize.height/2)
        self.m_logsContainer :setPosition( ccp( winSize.width/2+backgroundSize.width*0.1+30, winSize.height*0.8+30))
        self.m_staminaLabel :setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height*0.8+30))
        self.m_palytimesLabel :setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height*0.8))

        self.m_playButton :setPosition( ccp(  winSize.width/2-200, winSize.height*0.25))
        self.m_feedingButton :setPosition( ccp(  winSize.width/2, winSize.height*0.25))
        self.m_batheButton :setPosition( ccp(  winSize.width/2+200, winSize.height*0.25))
        self.m_luckyButton :setPosition( ccp( winSize.width/2, winSize.height*0.45))
        self.m_catSprite :setPosition( ccp( winSize.width/2, winSize.height*0.65))
        self.m_expContainer :setPosition( ccp( winSize.width/2, winSize.height*0.35))
        --self.m_playButton :setPosition( ccp( winSize.width/2+createButtonSize.width/2+20, winSize.height/2-createButtonSize.height-40))
        --self.m_feedingButton :setPosition( ccp( winSize.width/2-createButtonSize.width/2-20, winSize.height/2-createButtonSize.height-40))
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height/2+backgroundSize.height/2-closeButtonSize.height/2))
        if tonumber(self.m_YQtimes) == 0 then
            self.m_luckyButton :setVisible( false)
        else
            self.m_luckyButton :setVisible( true)
        end

    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团招财猫主界面")        
    end
end

--主界面初始化
function CFactionLuckyCatView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self)
    --布局成员
    self.layout(self, winSize)  
end

function CFactionLuckyCatView.scene(self, _activeid)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self.m_activeid = _activeid
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionLuckyCatView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionLuckyCatView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionLuckyCatView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionLuckyCatView.requestService ( self)
    print("-- (手动) -- [33320]请求浇水 -- 社团 ")
    local msg = REQ_CLAN_ASK_WATER()
    _G.CNetwork :send( msg)
end

--初始化排行榜界面
function CFactionLuckyCatView.initView(self, layer)
    print("CFactionLuckyCatView.initView")
    --副本界面容器
    self.m_factionLuckyCatViewContainer = CContainer :create()
    self.m_factionLuckyCatViewContainer : setControlName("this is CFactionLuckyCatView self.m_factionLuckyCatViewContainer 94 ")
    layer :addChild( self.m_factionLuckyCatViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local backgroundfirst        = self :createSprite( "peneral_background.jpg", "backgroundfirst")
    local panelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "panelbackgroundfirst")     --背景Img
    local panelbackgroundsecond  = self :createSprite( "general_second_underframe.png", "panelbackgroundsecond")   --背景二级Img

    --创建各种Button
    self.m_playButton         = self :createOperatingContainer( "玩耍", CFactionLuckyCatView.TAG_PLAY, 1, 20000, 50, 10)  
    self.m_feedingButton      = self :createOperatingContainer( "喂食", CFactionLuckyCatView.TAG_FEEDING, 2, 20, 500, 200)
    self.m_batheButton        = self :createOperatingContainer( "洗澡", CFactionLuckyCatView.TAG_BATHE, 2, 100, 5000, 1000)
    self.m_luckyButton       = self :createButton( "招财", "general_button_normal.png", CallBack, CFactionLuckyCatView.TAG_LUCKY, "self.m_luckyButton")
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionLuckyCatView.TAG_CLOSED, "self.m_closedButton")    

    --创建Cat
    self.m_catSprite         = self :createSprite( "clan_picture_cat.png", "self.m_catSprite")   
    --创建经验条
    self.m_expContainer      = self :createExpView( self.m_exp, self.m_expn)    
    --创建日志部分
    self.m_logsContainer     = self :createLogsView()  

    self.m_staminaLabel      = self :createLabel( "个人贡献: "..self.m_stamina)
    self.m_palytimesLabel    = self :createLabel( "互动次数: "..self.m_playtimes)

    self.m_staminaLabel :setAnchorPoint( ccp(0,0.5))
    self.m_palytimesLabel :setAnchorPoint( ccp(0,0.5))
    --社团列表 界面标题
    self.m_viewnameLabel  = self :createLabel( "招财猫")
    self.m_viewnameLabel :setFontSize( CFactionLuckyCatView.FONT_SIZE+15)

    self.m_factionLuckyCatViewContainer :addChild( backgroundfirst, -1, 99)
    self.m_factionLuckyCatViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_factionLuckyCatViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_factionLuckyCatViewContainer :addChild( self.m_viewnameLabel)    
    self.m_factionLuckyCatViewContainer :addChild( self.m_staminaLabel)
    self.m_factionLuckyCatViewContainer :addChild( self.m_palytimesLabel)
    self.m_factionLuckyCatViewContainer :addChild( self.m_playButton)
    self.m_factionLuckyCatViewContainer :addChild( self.m_feedingButton)
    self.m_factionLuckyCatViewContainer :addChild( self.m_batheButton)
    self.m_factionLuckyCatViewContainer :addChild( self.m_catSprite)
    self.m_factionLuckyCatViewContainer :addChild( self.m_expContainer)  
    self.m_factionLuckyCatViewContainer :addChild( self.m_luckyButton)
    self.m_factionLuckyCatViewContainer :addChild( self.m_logsContainer)
    self.m_factionLuckyCatViewContainer :addChild( self.m_closedButton, 2)      
end

function CFactionLuckyCatView.createLogsView( self)
    local logscontainer       = CContainer :create()
    logscontainer :setControlName( "this is CFactionLuckyCatView createExpView CContainer")
    if self.m_logsdata == nil then
        return logscontainer
    end
    local layout = CHorizontalLayout :create()
    layout :setVerticalDirection( false)
    --layout :setCellHorizontalSpace( 30)
    layout :setCellVerticalSpace( 1)
    layout :setLineNodeSum( 1)
    local cellButtonSize = CCSizeMake( 10, 30)
    layout :setCellSize( cellButtonSize)
    logscontainer :addChild( layout)

    for k,v in pairs(self.m_logsdata) do
        print( "第 "..k.." 条日志")
        local logsitem = self :createLogsItem( v)
        layout :addChild( logsitem)
    end
    return logscontainer    
end

function CFactionLuckyCatView.createLogsItem( self, _log)
    local itemContainer = CContainer :create()
    itemContainer :setControlName( "this is CFactionLuckyCatView createLogsItem :".._log.name)
    _itemrolename = self :createLabel( _log.name, ccc3( 255,0,0)) --名字颜色使用 _log.name_color
    local temp = nil
    if _log.type == 1 then
        temp = "与招财猫进行了玩耍"
    elseif _log.type == 2 then
        temp = "给招财猫进行了喂食"
    elseif _log.type == 3 then
        temp = "帮招财猫进行了洗澡"
    end
    local _itemstring = self :createLabel( temp)
    _itemrolename :setAnchorPoint( ccp( 0, 0.5))
    _itemstring :setAnchorPoint( ccp( 0, 0.5))

    local namelength = string.len( _log.name)*CFactionLuckyCatView.FONT_SIZE/3+10 ---??????
    print( string.len( _log.name).."LEN:"..namelength)
    _itemstring :setPosition( ccp( namelength, 0))

    itemContainer :addChild( _itemrolename)
    itemContainer :addChild( _itemstring)
    return itemContainer
end

--创建经验进度条
function CFactionLuckyCatView.createExpView( self, _exp, _expn)
    local expcontainer       = CContainer :create()
    expcontainer :setControlName( "this is CCharacterInfoView createExpView CContainer")
    local _expbackground     = CSprite :createWithSpriteFrameName( "role_exp_frame.png")
    expcontainer :addChild( _expbackground)
    local _expbackgroundSize = _expbackground :getPreferredSize()
    local _expsprite         = CSprite :createWithSpriteFrameName( "role_exp.png", CCRectMake( 12, 1, 1, 21))
    local _expspriteSize     = _expsprite :getPreferredSize()
    local _length            = _exp/_expn*_expbackgroundSize.width-2
    if _expn == 0 then
        _length = 0
        _expsprite :setVisible( false)
    end
    print("exp:",_exp.."/".._expn)
    if _length >= _expspriteSize.width-5 then
        _expsprite :setPreferredSize( ccp( _length, _expbackgroundSize.height-1))
    else 
        local x = _length/_expspriteSize.width
        _expsprite :setScaleX( x)
        _expsprite :setVisible( false)
    end
    _expsprite :setPosition( ccp( -_expbackgroundSize.width/2+_length/2+2, -1))
    expcontainer :addChild( _expsprite)
    local _explabel          = self :createLabel( _exp.."/".._expn)
    --_explabel :setPosition( -_expbackgroundSize.width/2+10, 0)
    expcontainer :addChild( _explabel)
    return expcontainer
end

function CFactionLuckyCatView.createOperatingContainer( self, _string, _tag, _type, _value1, _value2, _value3)
    local itemContainer = CContainer :create()
    itemContainer :setControlName("this is CFactionLuckyCatView createOperatingContainer itemContainer :".._string)
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local _itembutton   = self :createButton( _string, "general_button_normal.png", CallBack, _tag, "_itembutton :".._string)
    local temp = nil
    if _type == 1 then
        temp = "需".._value1.."美刀"
    elseif _type == 2 then
        temp = "需".._value1.."钻石"        
    end
    local _itemmoneyLabel   = self :createLabel( temp, ccc3( 255, 255, 0))
    local _itemexpLabel     = self :createLabel( "招财猫经验 +".._value2)
    local _itemstaminalabel = self :createLabel( "个人贡献 +".._value3)

    _itemmoneyLabel :setPosition( ccp( 0, -50))
    _itemexpLabel :setPosition( ccp( 0, -80))
    _itemstaminalabel :setPosition( ccp( 0, -110))

    itemContainer :addChild( _itemexpLabel)
    itemContainer :addChild( _itemstaminalabel)
    itemContainer :addChild( _itemmoneyLabel)
    itemContainer :addChild( _itembutton)
    return itemContainer
end

--创建按钮Button
function CFactionLuckyCatView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionLuckyCatView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionLuckyCatView ".._controlname)
    _itembutton :setFontSize( CFactionLuckyCatView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this CFactionLuckyCatView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建图片Sprite
function CFactionLuckyCatView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionLuckyCatView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionLuckyCatView.createLabel( self, _string, _color)
    print("CFactionLuckyCatView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionLuckyCatView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

--更新本地list数据
function CFactionLuckyCatView.setLocalList( self, _data)
    print("CFactionLuckyCatView.setLocalList") 
    self.m_stamina   = _data.stamina 
    self.m_playtimes = _data.water_times.."/".._data.all_times
    --更新活动选择界面的次数
    local temp    = {}
    temp.active_id   = self.m_activeid
    temp.water_times = _data.water_times
    temp.all_times   = _data.all_times
    local command = CFactionLuckCatCommand( temp)
    controller :sendCommand( command )

    self.m_exp       = _data.yqs_exp
    self.m_expn      = _data.up_exp
    self.m_YQtimes   = _data.yq_times
    self.m_logsdata  = _data.water_logs
    if self.m_scenelayer ~= nil then
        self.m_scenelayer :removeAllChildrenWithCleanup( true)
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --初始化界面
    self.initView(self, self.m_scenelayer)
    --布局成员
    self.layout(self, winSize) 
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionLuckyCatView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionLuckyCatView.TAG_CLOSED then
            print("关闭/取消")
            if self ~= nil then
                controller :unregisterMediator( self.m_mediator)
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CFactionLuckyCatView.TAG_PLAY then  
            self :REQ_CLAN_START_WATER( 1, 1)
        elseif obj :getTag() == CFactionLuckyCatView.TAG_FEEDING then
            self :REQ_CLAN_START_WATER( 1, 2)
        elseif obj :getTag() == CFactionLuckyCatView.TAG_BATHE then
            self :REQ_CLAN_START_WATER( 1, 3)
        elseif obj :getTag() == CFactionLuckyCatView.TAG_LUCKY then
            self :REQ_CLAN_START_WATER( 2, 0) 
        end    
    end
end

--请求 玩耍，喂食，洗澡 _type 1 _typeact 1 2 3
--    招财 _type 2 _typeact 0
function CFactionLuckyCatView.REQ_CLAN_START_WATER( self, _type, _typeact)
    print("-- (手动) -- [33325]请求开始浇水|摇钱 -- 社团".._type.."/".._typeact)
    local msg = REQ_CLAN_START_WATER()
    msg :setType( _type)
    msg :setTypeAct( _typeact)
    _G.CNetwork :send( msg)
end





















