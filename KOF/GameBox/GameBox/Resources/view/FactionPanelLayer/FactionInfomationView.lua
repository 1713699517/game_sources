--[[
 --CFactionInfomationView
 --社团信息界面  毛泽东
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "common/WordFilter"

require "mediator/FactionMediator"
require "view/FactionPanelLayer/FactionVerifyListView"

CFactionInfomationView = class(view, function( self)
print("CFactionInfomationView：挂机啦")
    self.m_verifyButton            = nil
    self.m_exp                     = 0
    self.m_expn                    = 0
    self.m_bulletinstring          = "社团公告区"
end)
--Constant:

CFactionInfomationView.TAG_CHANGEBULLETIN     = 201
CFactionInfomationView.TAG_QUITFACTION        = 202
CFactionInfomationView.TAG_VERIFY             = 203  --社团审核

CFactionInfomationView.BULLETIN_LENGTH        = 120   --公告最大长度 --40中文字符
CFactionInfomationView.FONT_SIZE              = 20
CFactionInfomationView.PER_PAGE_COUNT         = 4

--加载资源
function CFactionInfomationView.loadResource( self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("FactionResources/FactionResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")

    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")
end
--释放资源
function CFactionInfomationView.onLoadResource( self)    
end
--初始化数据成员
function CFactionInfomationView.initParams( self, layer)
    print("CFactionInfomationView.initParams")  
    --require "mediator/FactionMediator"
    --self.m_mediator = CFactionInfomationMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --初始化屏蔽字库
    _G.g_WordFilter :initialize()
end
--释放成员
function CFactionInfomationView.realeaseParams( self) 
    --释放屏蔽字库
    _G.g_WordFilter :destory()   
end
--布局成员
function CFactionInfomationView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团信息界面")
        local backgroundSize       = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundleftup     = self.m_infomationViewContainer :getChildByTag( 100)
        local backgroundleftdown   = self.m_infomationViewContainer :getChildByTag( 101)
        local backgroundrightup    = self.m_infomationViewContainer :getChildByTag( 102)    
        local splitlineleft        = self.m_infomationViewContainer :getChildByTag( 110)
        local splitlinerightup     = self.m_infomationViewContainer :getChildByTag( 111)
        local splitlinerightdown   = self.m_infomationViewContainer :getChildByTag( 112) 

        local templeftwidth  = winSize.width/2-backgroundSize.width/2
        local temprightwidth = winSize.width/2+backgroundSize.width/2

        backgroundleftup :setPreferredSize( CCSizeMake( backgroundSize.width*0.55, backgroundSize.height*0.42))
        backgroundleftdown :setPreferredSize( CCSizeMake( backgroundSize.width*0.55, backgroundSize.height*0.44))
        backgroundrightup :setPreferredSize( CCSizeMake( backgroundSize.width*0.41, backgroundSize.height*0.65))

        backgroundleftup :setPosition( ccp( templeftwidth+backgroundSize.width*0.55/2+15, winSize.height*(0.44+0.42/2)+22))
        backgroundleftdown :setPosition( ccp( templeftwidth+backgroundSize.width*0.55/2+15, winSize.height*0.44/2+15))
        backgroundrightup :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.55+11))

        splitlineleft :setPosition( ccp(  templeftwidth+backgroundSize.width*0.55/2+15, winSize.height*0.35+20))
        splitlinerightup :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.75+30))
        splitlinerightdown :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.4))

        self.m_factionInfomationLayout :setPosition( templeftwidth-60, winSize.height*0.8)
        self.m_factionInfomationLayout :setCellHorizontalSpace( 20)
        self.m_factionInfomationLayout :setCellVerticalSpace( 14)
        local cellButtonSize = CCSizeMake( (backgroundSize.width*0.55-50)/2, CFactionInfomationView.FONT_SIZE)
        self.m_factionInfomationLayout :setCellSize( cellButtonSize)

        self.m_bulletinNameSprite :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.8+30))
        self.m_bulletinEditBox :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.4+20))
        self.m_bulletinLabel :setPosition( ccp( temprightwidth-backgroundSize.width*0.41+15, winSize.height*0.8-30))

        self.m_logsNameSprite :setPosition( ccp( templeftwidth+backgroundSize.width*0.55/2+15, winSize.height*0.35+45))
        self.m_factionJournalContainer :setPosition( templeftwidth, 30)

        self.m_expContainer :setPosition( ccp( winSize.width/2-130, backgroundSize.height*0.6-5))

        self.m_verifyButton :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15-80, winSize.height*0.1))
        self.m_quitButton :setPosition( ccp( temprightwidth-backgroundSize.width*0.41/2-15+80, winSize.height*0.1))
        self.m_changeButton :setPosition( ccp(temprightwidth-backgroundSize.width*0.41/2-15, winSize.height*0.35-10))       
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团信息界面")
        
    end
end

--主界面初始化
function CFactionInfomationView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务器
    self.requestService(self)
    --布局成员
    self.layout(self, winSize)  
end

function CFactionInfomationView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CFactionInfomationView self.m_scenelayer 98" )
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionInfomationView.layer( self, _uid)
    print("create m_scenelayer")
    self.m_factionuid = _uid
    if self.m_factionuid == nil then
        self.m_factionuid = 0
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CFactionInfomationView self.m_scenelayer 109" )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionInfomationView.requestService ( self)
    require "common/protocol/auto/REQ_CLAN_ASK_CLAN"
    local msg = REQ_CLAN_ASK_CLAN()
    msg :setClanId( self.m_factionuid)
    _G.CNetwork :send( msg)
end

--创建按钮Button
function CFactionInfomationView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionInfomationView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CFactionInfomationView ".._controlname)
    m_button :setFontSize( CFactionInfomationView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CFactionInfomationView ".._controlname.."CallBack")
    return m_button
end

--创建二级背景Sprite
function CFactionInfomationView.createBackground( self, _image, _controlname)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this CFactionInfomationView background 121:".._controlname)
    return _itemsprite
end

--创建无耻的分割线
function CFactionInfomationView.createSplitLine( self)
    local _itemspriteline = CSprite :createWithSpriteFrameName( "general_dividing_line.png")
    _itemspriteline :setControlName( "this CFactionInfomationView _itemspriteline 116")
    return _itemspriteline
end

--创建info
-- _string 字符串
-- _color  字符串颜色
function CFactionInfomationView.createInfomationLabel( self, _string, _color)
    if _string == nil then
        _string = ""
    end
    local _infomationlabel      = CCLabelTTF :create( _string, "Arial", CFactionInfomationView.FONT_SIZE)
    if _color ~= nil then
        _infomationlabel :setColor( _color)
    end
    _infomationlabel :setAnchorPoint( ccp( 0, 0.5))
    return _infomationlabel
end

function CFactionInfomationView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

--显示排行榜玩家
function CFactionInfomationView.showAllLogs( self)
    if self.m_factionJournalContainer ~= nil then
        self.m_factionJournalContainer :removeAllChildrenWithCleanup( true)
    end
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_logscount, CFactionInfomationView.PER_PAGE_COUNT)
    print("bbbbbbbbbbbbbbb", self.m_pageCount, self.m_lastPageCount)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local m_bgCell  = CCSizeMake( winSize.width*0.6-50, (winSize.height*0.3)/CFactionInfomationView.PER_PAGE_COUNT)
    local viewSize  = CCSizeMake( winSize.width*0.6-20, winSize.height*0.3+10)

    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView :setControlName("this is CFactionInfomationView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_factionJournalContainer :addChild( self.m_pScrollView )

    self.m_roleBtn = {}
    local tempfactioncount = 0
    local pageContainerList = {}
    for k=1,self.m_pageCount do
        pageContainerList[k] = nil
        pageContainerList[k] = CContainer :create()
        pageContainerList[k] :setControlName("this is CFactionInfomationView pageContainerList 186 ")       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width+50, 70)
        pageContainerList[k] :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellVerticalSpace( 1)
        layout :setLineNodeSum( 1)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionInfomationView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        self.m_roleBtn[k] = {}
        for i =1 , tempnum do
            tempfactioncount = tempfactioncount + 1
            local temprole = self :createInfomationLabel( self.m_logsdata[tempfactioncount])
            temprole : setAnchorPoint( ccp( 0,0.5))   --微调
            temprole : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐
            temprole : setDimensions( CCSizeMake(viewSize.width-50,0))  --设置文字区域
            layout :addChild( temprole)
        end
    end
    for k=self.m_pageCount,1,-1 do
        self.m_pScrollView :addPage( pageContainerList[k], false)
    end
    self.m_pScrollView :setPage( self.m_pageCount-1, false)
end

--初始化背包界面
function CFactionInfomationView.initView(self, layer)
    print("CFactionInfomationView.initHangupView")
    --副本界面容器
    self.m_infomationViewContainer = CContainer :create()
    self.m_infomationViewContainer : setControlName( "this is CFactionInfomationView self.m_infomationViewContainer 119" )
    layer :addChild( self.m_infomationViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --创建二级背景
    local backgroundleftup       = self :createBackground( "general_second_underframe.png", "backgroundleftup")      
    local backgroundleftdown     = self :createBackground( "general_second_underframe.png", "backgroundleftdown")
    local backgroundrightup      = self :createBackground( "general_second_underframe.png", "backgroundrightup")
    --创建分割线
    local splitlineleft          = self :createSplitLine()
    local splitlinerightup       = self :createSplitLine()
    local splitlinerightdown     = self :createSplitLine()
    --创建各种Button
    self.m_verifyButton      = self :createButton( "社团审核", "general_button_normal.png", CallBack, CFactionInfomationView.TAG_VERIFY, "self.m_verifyButton ")
    self.m_changeButton      = self :createButton( "更改公告", "general_button_normal.png", CallBack, CFactionInfomationView.TAG_CHANGEBULLETIN, "self.m_changeButton")   
    self.m_quitButton        = self :createButton( "退出社团", "general_button_normal.png", CallBack, CFactionInfomationView.TAG_QUITFACTION, "self.m_quitButton")
    
    self.m_changeButton :setVisible( false)
    self.m_verifyButton :setVisible( false)
    if self.m_factionuid ~= 0 then
        self.m_quitButton :setVisible( false)
    end
    --添加社团信息 左上
    --布局
    self.m_factionInfomationLayout = CHorizontalLayout :create()
    self.m_factionInfomationLayout :setVerticalDirection( false)
    self.m_factionInfomationLayout :setLineNodeSum( 2)
    --添加属性部分
    self.m_factionNameLabel            = self :createInfomationLabel( "社团名称: ")
    self.m_factionPresidentNameLabel   = self :createInfomationLabel( "社团社长: ")
    self.m_factionPresidentLvLabel     = self :createInfomationLabel( "社长等级: ")
    self.m_factionRankingLabel         = self :createInfomationLabel( "社团排名: ")
    self.m_factionLvLabel              = self :createInfomationLabel( "社团等级: ")
    self.m_factionMembersLabel         = self :createInfomationLabel( "社团成员: ")
    self.m_factionContributionLabel    = self :createInfomationLabel( "社团贡献: ")
    self.m_factionExpLabel             = self :createInfomationLabel( "社团经验: ")
    self.m_expContainer                = CContainer :create()

    self.m_expContainer            :addChild( self :createExpView())   
    --
    self.m_infomationViewContainer :addChild( self.m_expContainer)
    self.m_factionInfomationLayout :addChild( self.m_factionNameLabel)
    self.m_factionInfomationLayout :addChild( self :createInfomationLabel( ""))
    self.m_factionInfomationLayout :addChild( self.m_factionPresidentNameLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionPresidentLvLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionRankingLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionLvLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionMembersLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionContributionLabel)
    self.m_factionInfomationLayout :addChild( self.m_factionExpLabel)
    self.m_infomationViewContainer :addChild( self.m_factionInfomationLayout)
    --添加社团公告
    self.m_factionBulletinContainer = CContainer :create()
    self.m_bulletinNameSprite        = self :createSprite( "clan_word_stgg.png","社团公告")

    local defaultbulletin = "社团公告输入区"
    local winSize         = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize  = CCSizeMake( winSize.height/3*4, winSize.height)

    local editboxSize     = CCSizeMake( backgroundSize.width*0.41-20, 40)
    self.m_bulletinEditBox          = CEditBox :create( editboxSize, CCScale9Sprite :createWithSpriteFrameName( "general_second_underframe.png"), 60, defaultbulletin, kEditBoxInputFlagSensitive)  --
    self.m_bulletinEditBox :registerControlScriptHandler( CallBack, "this is CFactionInfomationView self.m_bulletinEditBox CallBack")
    self.m_bulletinEditBox :setFont( "Arial", 20)

    self.m_bulletinLabel  = self :createInfomationLabel( "")
    self.m_bulletinLabel : setAnchorPoint( ccp( 0,1))   --微调
    self.m_bulletinLabel : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐
    self.m_bulletinLabel : setDimensions( CCSizeMake(backgroundSize.width*0.41-40,0))  --设置文字区域

    self.m_factionBulletinContainer :addChild( self.m_bulletinNameSprite)
    self.m_factionBulletinContainer :addChild( self.m_bulletinEditBox)
    self.m_factionBulletinContainer :addChild( self.m_bulletinLabel)
    self.m_infomationViewContainer :addChild( self.m_factionBulletinContainer)
    --添加社团日志
    self.m_factionJournalContainer = CContainer :create()
    self.m_logsNameSprite          = self :createSprite( "clan_word_strz.png","社团日志")
    self.m_infomationViewContainer :addChild( self.m_logsNameSprite)
    self.m_infomationViewContainer :addChild( self.m_factionJournalContainer)

    self.m_infomationViewContainer :addChild( backgroundleftup, -1, 100)
    self.m_infomationViewContainer :addChild( backgroundleftdown, -1, 101)
    self.m_infomationViewContainer :addChild( backgroundrightup, -1, 102)
    self.m_infomationViewContainer :addChild( splitlineleft, -1, 110)
    self.m_infomationViewContainer :addChild( splitlinerightup, -1, 111)
    self.m_infomationViewContainer :addChild( splitlinerightdown, -1, 112)
    self.m_infomationViewContainer :addChild( self.m_verifyButton)
    self.m_infomationViewContainer :addChild( self.m_changeButton)
    self.m_infomationViewContainer :addChild( self.m_quitButton)  

end

--创建经验进度条
function CFactionInfomationView.createExpView( self)
    local expcontainer       = CContainer :create()
    expcontainer :setControlName( "this is CFactionInfomationView createExpView CContainer")
    local _expbackground     = CSprite :createWithSpriteFrameName( "role_exp_frame.png")
    expcontainer :addChild( _expbackground)
    local _expbackgroundSize = _expbackground :getPreferredSize()
    local _expsprite         = CSprite :createWithSpriteFrameName( "role_exp.png", CCRectMake( 12, 1, 1, 21))
    local _expspriteSize     = _expsprite :getPreferredSize()
    local _length            = self.m_exp/self.m_expn*_expbackgroundSize.width-2
    if self.m_expn == 0 then
        _length = 0
        _expsprite :setVisible( false)
    end
    print("exp:",self.m_exp.."/"..self.m_expn)
    if _length >= _expspriteSize.width-5 then
        _expsprite :setPreferredSize( ccp( _length, _expbackgroundSize.height-1))
    else 
        local x = _length/_expspriteSize.width
        _expsprite :setScaleX( x)
        _expsprite :setVisible( false)
    end
    _expsprite :setPosition( ccp( -_expbackgroundSize.width/2+_length/2+2, -1))
    expcontainer :addChild( _expsprite)
    local _explabel          = self :createInfomationLabel( self.m_exp.."/"..self.m_expn)
    _explabel :setAnchorPoint( ccp( 0.5,0.5))
    --_explabel :setPosition( -_expbackgroundSize.width/2+10, 0)
    expcontainer :addChild( _explabel)
    return expcontainer
end

--创建图片Sprite
function CFactionInfomationView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionInfomationView createSprite _background".._controlname)
    return _background
end

--更新本地list数据
function CFactionInfomationView.setLocalList( self)
    print("CFactionInfomationView.setLocalList")

end

function CFactionInfomationView.setFactionInfo( self, _factiondata)
    self.m_factiondata = _factiondata
    if self.m_factiondata.clan_name == nil then
        self.m_factiondata.clan_name = "clan_name nil"
    end
    self.m_factionNameLabel :setString( "社团名称: "..self.m_factiondata.clan_name)
    self.m_factionRankingLabel :setString( "社团排名: "..self.m_factiondata.clan_rank)
    self.m_factionLvLabel :setString( "社团等级: "..self.m_factiondata.clan_lv)
    self.m_factionMembersLabel :setString( "社团成员: "..self.m_factiondata.clan_members.."/"..self.m_factiondata.clan_all_members)
    _G.g_GameDataProxy:setClanLv( self.m_factiondata.clan_lv) --更新后的背包金币
end

function CFactionInfomationView.setPresidentInfo( self, _presidentdata)
    self.m_presidentdata = _presidentdata
    self.m_factionPresidentNameLabel :setString( "社团社长: "..self.m_presidentdata.master_name)
    self.m_factionPresidentNameLabel :setColor( ccc3( 120,120,0))--setColor( self.m_presidentdata.master_name_color)   --
    self.m_factionContributionLabel :setString( "社团贡献: "..self.m_presidentdata.clan_all_contribute)
    self.m_factionPresidentLvLabel :setString( "社长等级: "..self.m_presidentdata.master_lv)
    self.m_factionExpLabel :setString( "社团经验: ")
    self.m_exp  = self.m_presidentdata.clan_all_contribute
    self.m_expn = self.m_presidentdata.clan_contribute   
    if self.m_expContainer ~= nil then
        self.m_expContainer :removeAllChildrenWithCleanup( true) 
    end
    self.m_expContainer :addChild( self :createExpView())
    local tempstring = self.m_presidentdata.clan_broadcast
    print( tempstring)
    if tempstring == nil then
        tempstring = "社团公告区"
        print( tempstring)
    end
    print( tempstring)      
    self.m_bulletinstring = tempstring  
    self.m_bulletinEditBox :setTextString( "")
    self.m_bulletinEditBox :setVisible( false)
    --self.m_bulletinEditBox :setTouchesEnabled( false)
    self.m_bulletinLabel :setString( tempstring)

    if self.m_presidentdata.member_power == _G.Constant.CONST_CLAN_POST_SECOND or self.m_presidentdata.member_power == _G.Constant.CONST_CLAN_POST_MASTER then
        self.m_changeButton :setVisible( true)
        self.m_verifyButton :setVisible( true)
        self.m_bulletinEditBox :setVisible( true)
        --self.m_bulletinEditBox :setTouchesEnabled( true)
    end
end

function CFactionInfomationView.setLogsIngo( self, _logscount, _logsdata)
    self.m_logscount = _logscount
    self.m_logsdata  = _logsdata
    self :showAllLogs()
end

function CFactionInfomationView.setOutClanOK( self)
    --返回到申请列表界面
    print( "返回到申请列表界面")
    controller :unregisterMediatorByName( "CFactionInfomationMediator")
    CCDirector :sharedDirector() :popScene( )
    require "view/FactionPanelLayer/FactionApplyView"
    _G.pFactionApplyView = CFactionApplyView()
    CCDirector :sharedDirector() :pushScene( _G.pFactionApplyView :scene())
end

function CFactionInfomationView.setChangeBulletinOK( self)
    --修改公告成功
    self.m_bulletinLabel :setString( self.m_bulletinstring)
    self.m_bulletinEditBox :setTextString( "")
    --self.m_bulletinstring = "社团公告区"
    --CCMessageBox("修改公告成功！"," ")
    require "view/ErrorBox/ErrorBox"
    local ErrorBox = CErrorBox()
    local function func1()
        print("确定")
    end
    local BoxLayer = ErrorBox : create("修改公告成功！",func1)  
    self.m_scenelayer: addChild(BoxLayer,1000)    
end

function CFactionInfomationView.outClanClick( self)
    require "view/ErrorBox/ErrorBox"
    local function func1()
        print("确定")
        -- (手动) -- [33150]请求退出|解散社团 -- 社团 
        require "common/protocol/auto/REQ_CLAN_ASK_OUT_CLAN"
        local msg = REQ_CLAN_ASK_OUT_CLAN()
        msg :setType( 1)        -- {1 退出社团| 0 解散社团}
        _G.CNetwork :send( msg)
    end
    local function func2()
        print("取消")
    end
    local ErrorBox = CErrorBox()
    local BoxLayer = ErrorBox : create( "退出社团后要等待一小时才可重新加入社团，确定要退出？",func1,func2) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
    local nowScene = CCDirector : sharedDirector() : getRunningScene()
    nowScene : addChild(BoxLayer,1000)
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack 
--单击回调
function CFactionInfomationView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "EditBoxReturn" then 
        print( "EEEE:", x)
        self.m_bulletinstring = tostring( self.m_bulletinEditBox :getTextString())
        self.m_bulletinstring = _G.g_WordFilter :replaceBanWord( self.m_bulletinstring)
        if string.len( self.m_bulletinstring) > CFactionInfomationView.BULLETIN_LENGTH then
            --CCMessageBox("输入公告长度为 "..string.len( self.m_bulletinstring).."，公告最大长度为 "..CFactionInfomationView.BULLETIN_LENGTH.."！","Editbox输入回调") 
            self.m_bulletinEditBox :setTextString( self.m_bulletinstring)
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
            end
            local BoxLayer = ErrorBox : create("输入公告长度为 "..string.len( self.m_bulletinstring).."，公告最大长度为 "..CFactionInfomationView.BULLETIN_LENGTH.."！",func1)  
            self.m_scenelayer: addChild(BoxLayer,1000)  
        else
            --self.m_bulletinLabel :setString( self.m_bulletinstring)
            self.m_bulletinEditBox :setTextString( self.m_bulletinstring)
        end    
    elseif eventType == "TouchEnded" then    
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionInfomationView.TAG_CHANGEBULLETIN then
            print(" 更改公告:"..self.m_bulletinstring)
            -- (手动) -- [33110]请求修改社团公告 -- 社团 
            --local tempstring = self.m_bulletinEditBox :getTextString()
            require "common/protocol/auto/REQ_CLAN_ASK_RESET_CAST"
            local msg = REQ_CLAN_ASK_RESET_CAST()
            msg :setString( self.m_bulletinstring)
            _G.CNetwork :send( msg)

        elseif obj :getTag() == CFactionInfomationView.TAG_QUITFACTION then
            print( "退出社团")
            self :outClanClick()
        elseif obj :getTag() == CFactionInfomationView.TAG_VERIFY then
            print( "审核社员")
            -- if self.m_infomationViewContainer ~= nil then
            --     self.m_infomationViewContainer :removeAllChildrenWithCleanup( true)
            -- end
            -- local tempinfoview          = CFactionVerifyListView()     
            -- self.m_infomationViewContainer :addChild( tempinfoview :layer())
            require "view/FactionPanelLayer/FactionVerifyListView"
            if _G.pFactionPanelView ~= nil then
                _G.pFactionPanelView : realeaseParams()
            end
            CCDirector :sharedDirector() :popScene()
            local pFactionVerifyListView = CFactionVerifyListView()
            CCDirector :sharedDirector() :pushScene( pFactionVerifyListView :scene())
        end    
    end
end























