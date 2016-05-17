require "view/view"
require "controller/EmailCommand"

require "model/VO_EmailModel"

CEmailView = class( view, function(self)
    CCLOG("CEmailView构造")
    self.m_winSize = CCSizeMake( 854.0, 640.0)
    self.m_visibleSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_xDistance = (self.m_visibleSize.width - self.m_winSize.width) / 2
end)

CEmailView.SCROLLTAG    = 100
CEmailView.SELECTALLTAG = 5000000

function CEmailView.scene( self)
    local cleanIconCommand = CEmailUpdataCommand( CEmailUpdataCommand.CLEAN )
    controller :sendCommand( cleanIconCommand )
    
    local winSize	= CCDirector :sharedDirector() :getVisibleSize()
    local scene		= CCScene :create()

    self :init( winSize, scene)
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup(false)
    end

    scene :addChild( self.m_pContainer)
    return scene
end

function CEmailView.init( self, _winSize, _layer)
    -- self :loadResources()
    self :initParams()
    self :initBgAndCloseBtn( _layer)
    self :initView( _layer )
    
    self :registerMyMediator()
    self :layout( _winSize)
end

function CEmailView.initBgAndCloseBtn( self, _layer )
    --底图
    self.m_sprBottem  = CSprite :createWithSpriteFrameName( "peneral_background.jpg")
    self.m_sprBottem  :setControlName("this CEmailView. sprBottem 40")
    self.m_pContainer :addChild( self.m_sprBottem, -100)
    
        
	--背景
    self.m_pBackground  = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_pBackground  :setControlName("this CEmailView. self.m_pBackground 39")
    self.m_pContainer   :addChild( self.m_pBackground, -100 )
    
    self.m_pEmailLabel = CCLabelTTF :create( "邮件", "Arial", 24 )
    self.m_pBackground  :addChild( self.m_pEmailLabel, 10 )
    
    --邮件的第二背景图
    self.m_emailBg  = CSprite :createWithSpriteFrameName("general_second_underframe.png", CCRectMake(13,13,9,9))
    self.m_emailBg  :setControlName("this CEmailView. self.m_emailBg 44")
    self.m_pContainer      :addChild( self.m_emailBg, -99)

    
    local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack( eventType, obj, x, y)
    end
    --关闭按钮
    self.m_pCloseBtn    = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CEmailView. self.m_pCloseBtn 53")
    self.m_pCloseBtn    :registerControlScriptHandler( closeCallBack, "this CEmailView. self.m_pCloseBtn 43" )
    self.m_pBackground  :addChild( self.m_pCloseBtn, 10)
end

function CEmailView.initParams( self )
	self.m_pContainer = CContainer :create()
	self.m_pContainer :setControlName("this CEmailView. self.m_pContainer 60")

end

function CEmailView.registerMyMediator( self )
    require "mediator/EmailMediator"
    _G.pCEmailMediator = CEmailMediator( self)
    controller :registerMediator( _G.pCEmailMediator)
    
	-- body
    require "common/protocol/auto/REQ_MAIL_REQUEST"
    local msg    = REQ_MAIL_REQUEST()
    msg :setType( _G.Constant.CONST_MAIL_TYPE_GET )
    CNetwork :send( msg)
    print("请求邮件类型为", msg :getType())
    
end

function CEmailView.unregisterMyMediator( self)
    if _G.pCEmailMediator then
        controller :unregisterMediator( _G.pCEmailMediator)
        _G.pCEmailMediator = nil
    end
end

function CEmailView.pushData(self, vo_data)     --mediator传过来的数据
    print("CEmailMediator传过来的数据, 83", vo_data, vo_data :getBoxtype(), vo_data :getCount())
    
    self.nBoxType   = vo_data :getBoxtype()     --邮箱类型
    self.nBoxCount  = vo_data :getCount()       --邮件数量
    self.models     = vo_data :getModels()      --邮件模块信息8513
    
    self.nCheckCount        =  {}                --已选的邮件 邮件id 和 邮件数量 nIdCount
    
    --创建上下滑动界面
    self :pageScrollView()
    
end

function CEmailView.updateView( self, _nClickId)
    print("更新打开界面", _nClickId)
    if self.models == nil or _nClickId == nil then
        return
    end
    
    for key, value in pairs( self.models) do
        if tonumber( _nClickId) == tonumber( value.mail_id) then
            value.state = _G.Constant.CONST_MAIL_STATE_READ
        end
    end
    --创建上下滑动界面
    self :pageScrollView()
    self :clickEmailSpr( _nClickId)
end

function CEmailView.setCheckCount( self, _nValue)
    self.nCheckCount = tonumber(_nValue)
    
end

function CEmailView.getCheckCount( self)
    print("self.nCheckCount", #self.nCheckCount)
    if #self.nCheckCount == 0 then
        return 0
    else
        return self.nCheckCount
    end
end

function CEmailView.loadResources( self )
	-- body
end

function CEmailView.getlabel( self, _szLabel )
    local szLabelName = "Arial"
    local nFontSize   = 20
    local pLabel = CCLabelTTF :create( _szLabel, szLabelName, nFontSize )
    pLabel :setAnchorPoint( ccp( 0.0, 0.5 ) )
    pLabel :setHorizontalAlignment( kCCTextAlignmentLeft )
    
    return pLabel
end

--创建上下滑动界面
function CEmailView.pageScrollView( self )
    --test
    print("CEmailMediator传过来的数据, 102")

    if self.m_pScrollView ~= nil then
        self.m_pScrollView :removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
    
    if self.models == nil or #self.models==0 then         --如果全部删除了，则退出
       print("#self.models", self.models)
       return 
    end
    
    if self.models then                 
        local func = function( lValue, rValue)
            --print("--按日期排序", lValue.date, rValue.date)
            if lValue.date > rValue.date then
                return true
            elseif lValue.date < rValue.date then
                return false
            elseif lValue.date == rValue.date then
                if lValue.mail_id > rValue.mail_id then
                    return true
                else
                    return false
                end
            end
        end
        table.sort( self.models, func)
    end

    if self.models ~= nil then
        for k, data in pairs( self.models ) do
            print( "排序后--->", data.mail_id, data.date)
        end
    end

	local _winSize      = CCDirector :sharedDirector() :getVisibleSize()
    local nBgSize       = self.m_emailBg  :getPreferredSize()
    local nCloseBtnSize = self.m_pCloseBtn :getContentSize()
    
    self.m_viewSize      = CCSizeMake( nBgSize.width, nBgSize.height-nCloseBtnSize.height - 30)
    local nLineHeight   = self.m_viewSize.height / 5   --行高
    print("self.m_viewSize", nLineHeight, self.m_viewSize.width, self.m_viewSize.height )
    
    self.is_auto = 0
    
    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, self.m_viewSize)
    self.m_pScrollView :setControlName("this CEmailView. self.m_pScrollView 145") 
    self.m_pContainer  :addChild( self.m_pScrollView)

    local _pageContainer = {}

    local function emailClickCallback( eventType, obj, touches )
        return self :onEmailClickCallback( eventType, obj, touches)
    end
    
    --checkbox 回调
    local function checkBoxCallBack(eventType, obj, x, y)
        return self : onCheckBox_CallBack(eventType,obj,x,y)
    end
    
    local szLabelName   = "Arial"
    local nFontSize     = 20
    -->>
    local nCountPage =  self :emailPages( #self.models)
    local nContent  = tonumber(#self.models)
    print("nContent", nContent)
    local nTimeCount = nContent             --时间的计数
    local nNameCount = nContent             --名字的计数
    local nIconCount = nContent
    local nCheckCount = nContent
    
    print("页数＝＝==", nCountPage, #self.models)
    --[[
    if self.models then
        print("k标记", "邮件ID", "邮件类型01","名字","标题","发送日期","邮件状态01","附件是否提取012" )
        for k, v in pairs( self.models) do
            print(k, v.mail_id, v.mtype, v.name, v.title, v.date, v.state, v.pick)
        end
    end
     --]]
    -------
    --页数
    local nPage = nCountPage
    
    self.checkBox       = {}
    self.m_sprBgLine    = {}

    local nYYY  = 50
    for i=1, nPage do
        _pageContainer[i] = CContainer :create()
        _pageContainer[i] :setControlName("this CEmailView. _pageContainer[i] 124") 
         
        local vLayout = CVerticalLayout :create()
        vLayout :setControlName("this CEmailView. vLayout 189") 
        vLayout :setCellSize( CCSizeMake( _winSize.width-15, nLineHeight-5))
        vLayout :setVerticalDirection( false)
        vLayout :setHorizontalDirection( true)
        vLayout :setLineNodeSum( 1)
        vLayout :setColumnNodeSum( 10)
        vLayout :setCellVerticalSpace( 0)
        vLayout :setCellHorizontalSpace( 0)
        _pageContainer[i] :addChild( vLayout, -97)
        
        vLayout :setPosition( _winSize.width * 0.5, _winSize.height / 5+nYYY)   --( 40, _winSize.height/5+90)

        --local btnEmail = {}
        local nNumber  = 5
        for ii=1, nNumber do
            local szEmailTitle = "邮件标题"
            local szEmailName  = "邮件发件人"
            local szEmailSender= "发件人名字"
            
            local nEmailTime   = "2013/07/26"
            local nEmailTag    = ii
            local nPick        = nil
            local nEmailState = tostring( _G.Constant.CONST_MAIL_STATE_UNREAD)     --默认未读
            
            if self.models[nContent] ~= nil then
                szEmailTitle = tostring( self.models[nContent].title)
                szEmailName  = tostring( self.models[nContent].name)
                szEmailSender= tostring( self.models[nContent].title)
                local tempTime  = tonumber( os.date( "*t", self.models[nContent].date ) )
                if tempTime ~= nil then     --拼接时间
                    nEmailTime  = tempTime.year .. "/" .. tempTime.month .. "/" .. tempTime.day .. "  " .. tempTime.hour .. ":" .. tempTime.min
                end
                
                nEmailTag    = tonumber( self.models[nContent].mail_id)
                --附件是否提取( 无附件:0|未提取:1|已提取:2)
                nPick        = tonumber( self.models[nContent].pick)
                nEmailState = tostring( self.models[nContent].state)
            end
            self.m_sprBgLine[nEmailTag]  = CSprite :createWithSpriteFrameName( "general_underframe_normal.png" )
            self.m_sprBgLine[nEmailTag] :setControlName("this CEmailView. self.m_sprBgLine[nEmailTag] 224"..nEmailTag)
            
            self.m_sprBgLine[nEmailTag] :setTag( nEmailTag)           --可以考虑用邮件id做 tag
            self.m_sprBgLine[nEmailTag] :setPreferredSize( CCSizeMake( self.m_viewSize.width - 20, nLineHeight) )
            self.m_sprBgLine[nEmailTag] :setTouchesMode( kCCTouchesAllAtOnce )     --
            self.m_sprBgLine[nEmailTag] :setTouchesEnabled( true)
            self.m_sprBgLine[nEmailTag] :registerControlScriptHandler( emailClickCallback, "this CEmailView. self.m_sprBgLine[nEmailTag] 232")
            
            self.m_sprBgLine[nEmailTag] :setTouchesPriority( self.m_sprBgLine[nEmailTag]:getTouchesPriority()-1)
            vLayout      :addChild( self.m_sprBgLine[nEmailTag], -98)

            
            
            --主题 
            local pNameLabel = self :getlabel( szEmailTitle )
            self.m_sprBgLine[nEmailTag] :addChild( pNameLabel, 10)
            
            --时间
            local pTimeLabel  = self :getlabel( nEmailTime )
            pTimeLabel :setPosition( ccp( 283, 0 ) )
            self.m_sprBgLine[nEmailTag] :addChild( pTimeLabel, 10)
            
            --发件人名字
            local pSenderName = self :getlabel( szEmailName )
            pSenderName :setPosition( ccp( -205, 0) )
            self.m_sprBgLine[nEmailTag] :addChild( pSenderName, 10)
            
            --是否读取的图标显示
            local sprIcon = CSprite :create( "EmailResources/Email_icon_0" .. (nEmailState or "0") .. ".png")
            local sprIconSize = sprIcon :getPreferredSize()
            sprIcon :setControlName("this CEmailView. sprIcon 356")
            sprIcon :setPosition( ccp( -334 + sprIconSize.width / 2, 0))
            self.m_sprBgLine[nEmailTag] :addChild( sprIcon, 10 )
            
            --checkbox
            local mailTag = self.models[nContent].mail_id
            --self.checkBox[mailTag] = CCheckBox :create("EmailResources/check_off.png", "EmailResources/check_on.png", "") general_choose_02
            self.checkBox[nContent] = CCheckBox :create("EmailResources/check_off.png", "EmailResources/check_on.png", "")
            self.checkBox[nContent] :setControlName("this CEmailView. self.checkBox[nContent] 390")
            self.checkBox[nContent] : registerControlScriptHandler( checkBoxCallBack,"this CEmailView self.checkBox[nContent] 391")
            self.checkBox[nContent] : setTag( self.models[nContent].mail_id )
            self.checkBox[nContent] : setTouchesPriority( self.checkBox[nContent] :getTouchesPriority()-1)
            self.checkBox[nContent] : setPosition (-395 + 28, 0)
            self.m_sprBgLine[nEmailTag] :addChild( self.checkBox[nContent], 10 )
            
            if nPick ~= nil and nPick == _G.Constant.CONST_MAIL_ACCESSORY_NO then
                local _pickSpr = CSprite :create("EmailResources/Email_icon_things.png")
                local _pickSprSize = _pickSpr :getPreferredSize()
                _pickSpr :setPosition( -270 + _pickSprSize.width / 2, 0)
                self.m_sprBgLine[nEmailTag] :addChild( _pickSpr, 10)
            end
            
            --nNumber = nNumber-1
            print("pNameLabelpNameLabel --> " .. ii .."-----", szEmailTitle, nEmailTime)
            if nContent<=1 then
                break
            else
                nContent = nContent-1
            end
            
        end
        
        --[[----->>时间
        local vLayoutTime = CVerticalLayout :create()
        vLayoutTime :setCellSize( CCSizeMake( self.m_viewSize.width-15, nLineHeight-5))
        vLayoutTime :setControlName("this CEmailView. vLayoutTime 250") 
        vLayoutTime :setVerticalDirection( false)
        vLayoutTime :setHorizontalDirection( true)
        vLayoutTime :setLineNodeSum( 1)
        vLayoutTime :setColumnNodeSum( 10)
        vLayoutTime :setCellVerticalSpace( 0)
        vLayoutTime :setCellHorizontalSpace( 0)
        _pageContainer[i] :addChild( vLayoutTime, -97)
        
        vLayoutTime :setPosition( _winSize.width * 7/10, _winSize.height/5+nYYY)   --( 40, _winSize.height/5+90)
        
        local nTNumber  = 5
        for ii=1, nTNumber do
            local nEmailTime   = "2013/07/26"
            local nEmailTag    = ii
            
            if self.models[nTimeCount] then
                local tempTime = os.date( "*t", self.models[nTimeCount].date )
                if tempTime ~= nil then     --拼接时间
                    nEmailTime  = tempTime.year .. "/" .. tempTime.month .. "/" .. tempTime.day .. "  " .. tempTime.hour .. ":" .. tempTime.min
                end
                
            end
            
            local pTimeLabel  = CCLabelTTF :create( nEmailTime, szLabelName, nFontSize)
            vLayoutTime       :addChild( pTimeLabel, -98)
            
            --nTNumber = nTNumber-1
            
            if nTimeCount <=1 then
                break
            else
                nTimeCount = nTimeCount-1
            end
            
        end
        --]]------<<时间

        --[[------>>名字 nNameCount
        local vLayoutName = CVerticalLayout :create()
        vLayoutName :setControlName("this CEmailView. vLayoutName 287") 
        vLayoutName :setCellSize( CCSizeMake( self.m_viewSize.width-15, nLineHeight-5))
        vLayoutName :setVerticalDirection( false)
        vLayoutName :setHorizontalDirection( true)
        vLayoutName :setLineNodeSum( 1)
        vLayoutName :setColumnNodeSum( 10)
        vLayoutName :setCellVerticalSpace( 0)
        vLayoutName :setCellHorizontalSpace( 0)
        _pageContainer[i] :addChild( vLayoutName, -97)
        
        vLayoutName :setPosition( _winSize.width / 5, _winSize.height/5+nYYY)   --( 40, _winSize.height/5+90)
        
        local nNNnumber  = 5
        for ii=1, nNNnumber do
            local szEmailName   = "发件人名字"
            
            if self.models[nNameCount] then
                szEmailName   = tostring( self.models[nNameCount].name)
                
                
                --if self.models[nNameCount].state == _G.Constant.CONST_MAIL_STATE_UNREAD then         --未读
                    --szEmailName = szEmailName.."(未读,"
                --elseif self.models[nNameCount].state == _G.Constant.CONST_MAIL_STATE_READ then --已读
                   -- szEmailName = szEmailName.."(已读,"
                --end
               
                if self.models[nNameCount].pick == _G.Constant.CONST_MAIL_ACCESSORY_NULL then         --无附件
                    szEmailName = szEmailName       --.."(无附件)"
                elseif self.models[nNameCount].pick == _G.Constant.CONST_MAIL_ACCESSORY_NO then     --未提取
                    szEmailName = szEmailName       --.."(未提取)"
                elseif self.models[nNameCount].pick == _G.Constant.CONST_MAIL_ACCESSORY_YES then     --已经提取
                    szEmailName = szEmailName       --.."(已提取)"
                end
                
            end
            
            local pTimeLabel  = CCLabelTTF :create( szEmailName, szLabelName, nFontSize)
            --pTimeLabel        :setHorizontalAlignment( kCCTextAlignmentLeft)
            vLayoutName       :addChild( pTimeLabel, -98)
            
            --nNNnumber = nNNnumber-1
            
            if nNameCount <=1 then
                break
            else
                nNameCount = nNameCount-1
            end
            
        end
        --]]------<<名字
        
        --[[------>>icon nIconCount
        local vLayoutIcon = CVerticalLayout :create()
        vLayoutIcon :setControlName("this CEmailView. vLayoutIcon 340") 
        vLayoutIcon :setCellSize( CCSizeMake( self.m_viewSize.width-15, nLineHeight-5))
        vLayoutIcon :setVerticalDirection( false)
        vLayoutIcon :setHorizontalDirection( true)
        vLayoutIcon :setLineNodeSum( 1)
        vLayoutIcon :setColumnNodeSum( 10)
        vLayoutIcon :setCellVerticalSpace( 0)
        vLayoutIcon :setCellHorizontalSpace( 0)
        _pageContainer[i] :addChild( vLayoutIcon)
        
        vLayoutIcon :setPosition(_winSize.width / 13, _winSize.height/5+nYYY)   --( 40, _winSize.height/5+90)
        
        local nINumber  = 5
        for ii=1, nINumber do
            --获取邮箱是否读取状态  CONST_MAIL_STATE_UNREAD(0)  CONST_MAIL_STATE_READ(1)
            local nEmailState = tostring( _G.Constant.CONST_MAIL_STATE_UNREAD)     --默认未读
            if self.models[nIconCount] then
                nEmailState = tostring( self.models[nIconCount].state)
                print("邮箱读取状态", self.models[nIconCount].state)
            end
            local sprIcon = CSprite :create( "EmailResources/Email_icon_0"..nEmailState..".png")
            sprIcon :setControlName("this CEmailView. sprIcon 356") 
            vLayoutIcon       :addChild( sprIcon, -98)
            --nINumber = nINumber-1
            
            if nIconCount <=1 then
                break
            else
                nIconCount = nIconCount-1
            end
            
        end
        --]]------<<nIconCount
        
        --[[------>>check nCheckCount
        local vLayoutCheck = CVerticalLayout :create()
        vLayoutCheck :setControlName("this CEmailView. vLayoutCheck 371")
        vLayoutCheck :setCellSize( CCSizeMake( self.m_viewSize.width-15, nLineHeight-5))
        vLayoutCheck :setVerticalDirection( false)
        vLayoutCheck :setHorizontalDirection( true)
        vLayoutCheck :setLineNodeSum( 1)
        vLayoutCheck :setColumnNodeSum( 10)
        vLayoutCheck :setCellVerticalSpace( 0)
        vLayoutCheck :setCellHorizontalSpace( 0)
        _pageContainer[i] :addChild( vLayoutCheck)
        
        vLayoutCheck :setPosition( (_winSize.width - self.m_winSize.width) * 0.5 - 20, _winSize.height/5+nYYY)   --( 40, _winSize.height/5+90)
        
       

        local nCNumber  = 5
        for ii=1, nCNumber do
            
            local mailTag = self.models[nCheckCount].mail_id
            --self.checkBox[mailTag] = CCheckBox :create("EmailResources/check_off.png", "EmailResources/check_on.png", "") general_choose_02
            self.checkBox[nCheckCount] = CCheckBox :create("EmailResources/check_off.png", "EmailResources/check_on.png", "")
            self.checkBox[nCheckCount] :setControlName("this CEmailView. self.checkBox[mailTag] 390")
            self.checkBox[nCheckCount] : registerControlScriptHandler( checkBoxCallBack,"this CEmailView self.checkBox[mailTag] 391")
            self.checkBox[nCheckCount] : setTag( self.models[nCheckCount].mail_id)
            self.checkBox[nCheckCount] : setTouchesPriority( self.checkBox[nCheckCount] :getTouchesPriority()-1)
            self.checkBox[nCheckCount] : setPosition (-self.m_winSize.width / 2, 0)
            vLayoutCheck :addChild( self.checkBox[nCheckCount])
            print("self.checkBox[nCheckCount]", nCheckCount)
            --
            --local sprIcon = CSprite :create( "EmailResources/check_on.png")
            --vLayoutCheck       :addChild( sprIcon, -98)
            --
            --nCNumber = nCNumber-1
            
            if nCheckCount <=1 then
                break
            else
                nCheckCount = nCheckCount-1
            end
            
        end
        --]]------<<nIconCount
        
        
    end
    --<<

    for i=nPage, 1, -1 do
        self.m_pScrollView :addPage( _pageContainer[i])
    end

    if nPage <=1 then
        nPage = 1
    end    

    self.m_pScrollView :setPage( nPage-1, false)
    
    if _winSize.height==640 then
            self.m_pScrollView  :setPosition( (_winSize.width - self.m_winSize.width) * 0.5 + 0, _winSize.height / 6)
        --self.m_pScrollView  :setPosition( 0, 0)
    elseif _winSize.height==768 then
        
    end
    
    if self.m_checkAll ~= nil then
        self.m_checkAll :removeFromParentAndCleanup( true)
        self.m_checkAll = nil
    end

    self.m_checkAll = CCheckBox :create("EmailResources/check_off.png", "EmailResources/check_on.png", "全选")
    self.m_checkAll :setControlName("this CEmailView. checkBox 434")
    self.m_checkAll : registerControlScriptHandler( checkBoxCallBack,"this CEmailView checkBox 435")
    self.m_checkAll : setTag( CEmailView.SELECTALLTAG)
    self.m_checkAll : setTouchesPriority( self.m_checkAll :getTouchesPriority()-1)
    self.m_checkAll : setPosition ( (_winSize.width - self.m_winSize.width) * 0.5 + 53.7, 50)
    self.m_pContainer :addChild( self.m_checkAll)
    print("CEmailView.pageScrollView")
end


function CEmailView.emailPages( self, _nCount )
    --默认页数   --  对行数 进行取余，如果有余数，nRetPage+1
    _nCount = tonumber( _nCount)
    
    if _nCount ~= 0 then
        local nnn = _nCount % 5
        
        if nnn > 0 then
            _nCount = math.modf(_nCount / 5) + 1
        else    --  nnn==0
            _nCount = _nCount / 5
        end
    else
        _nCount = 1
    end
    
    return _nCount
end



function CEmailView.initView( self, _layer )
    local l_container = CContainer :create()
    self.m_pContainer :addChild( l_container)
    --container :setControlName()

	-- body
    local winSize	    = CCDirector:sharedDirector():getVisibleSize()
    local szLabelName   = "Arial"
    local nFontSize     = 20
    local nCloseBtnSize = self.m_pCloseBtn :getContentSize()
    local nLabelY       = winSize.height -nCloseBtnSize.height -50
    
    --发件人
    local pSendLabel  = CCLabelTTF :create("发件人", szLabelName, nFontSize)
    --主题  
    local pTitleLabel  = CCLabelTTF :create("主题", szLabelName, nFontSize)
     --失效                                     
    local pFailureLabel  = CCLabelTTF :create("失效时间", szLabelName, nFontSize)

    local color = ccc3(0, 180, 255)
    pSendLabel :setColor( color)
    pTitleLabel :setColor( color)
    pFailureLabel :setColor( color)
    
    l_container :addChild( pSendLabel, 10)
    l_container :addChild( pTitleLabel, 10)
    l_container :addChild( pFailureLabel, 10)

    pTitleLabel :setPosition( 470 + self.m_xDistance, nLabelY )
    pSendLabel  :setPosition( 240 + self.m_xDistance, nLabelY )
    pFailureLabel :setPosition( 743 + self.m_xDistance, nLabelY )

    local pLineSpr = CSprite :createWithSpriteFrameName( "general_dividing_line.png")
    l_container    :addChild( pLineSpr, -98)
    pLineSpr :setPreferredSize( CCSizeMake( self.m_winSize.width-30, 1 ))
    pLineSpr :setPosition( winSize.width/2, nLabelY-18)

    local function btnCallback( eventType, obj, x, y )
        return self :onBtnCallback( eventType, obj, x, y)
    end
    --领取按钮  --删除按钮 --保存按钮
    local szBtnName = "general_button_normal.png"
    self.m_pReceiveBtn = CButton :createWithSpriteFrameName("领取", szBtnName)
    self.m_pDeleteBtn = CButton :createWithSpriteFrameName("删除", szBtnName)
    --self.m_pSaveBtn = CButton :createWithSpriteFrameName("保存", "general_two_button_normal.png")

    self.m_pReceiveBtn  : setControlName( "this CEmailView self.m_pStudyBtn 532 ")
    self.m_pDeleteBtn   : setControlName( "this CEmailView self.m_pStudyBtn 532 ")
    --self.m_pSaveBtn   : setControlName( "this CEmailView self.m_pStudyBtn 532 ")

    l_container  : addChild( self.m_pReceiveBtn, -99, 10 )
    l_container  : addChild( self.m_pDeleteBtn, -99, 20 )
    --l_container   :addChild( self.m_pSaveBtn, -99, 30 )

    self.m_pReceiveBtn : registerControlScriptHandler( btnCallback, "this CEmailView self.m_pStudyBtn 545")
    self.m_pReceiveBtn : setFontSize( nFontSize )

    self.m_pDeleteBtn : registerControlScriptHandler( btnCallback, "this CEmailView self.m_pStudyBtn 545")
    self.m_pDeleteBtn : setFontSize( nFontSize )

    --self.m_pSaveBtn : registerControlScriptHandler( btnCallback, "this CEmailView self.m_pStudyBtn 545")
    --self.m_pSaveBtn : setFontSize( nFontSize )
    
    --设置背景图的大小
    local nReceiveBtnSize = self.m_pReceiveBtn :getPreferredSize() 
    self.m_emailBg  :setPreferredSize( CCSizeMake( self.m_winSize.width - 30,  self.m_winSize.height - 150) )--180
   
    
end




function CEmailView.layout( self, _winSize )
	-- body
    local sizeCloseBtn  = self.m_pCloseBtn :getPreferredSize()
    local winX          = _winSize.width
    local winY          = _winSize.height

    local nReceiveBtnSize = self.m_pReceiveBtn :getPreferredSize()
    
    if winY == 640 then
        self.m_sprBottem        :setPosition( ccp( winX / 2, winY / 2))
        self.m_pBackground      :setPreferredSize( CCSizeMake( self.m_winSize.width, self.m_winSize.height))
        self.m_pCloseBtn        :setPosition( ccp( self.m_winSize.width / 2-sizeCloseBtn.width / 2, self.m_winSize.height / 2-sizeCloseBtn.height/2))
        self.m_pBackground      :setPosition( ccp( winX / 2, winY / 2 ))
        self.m_pEmailLabel      :setPosition( ccp( 0, self.m_winSize.height / 2 - 35) )

        self.m_emailBg  :setPosition( winX / 2, winY / 2 + 5 )

        self.m_pReceiveBtn :setPosition( (_winSize.width + self.m_winSize.width) / 2 - 1.80 * nReceiveBtnSize.width, nReceiveBtnSize.height * 0.8 )
        self.m_pDeleteBtn :setPosition( (_winSize.width + self.m_winSize.width) / 2 - 0.70 * nReceiveBtnSize.width, nReceiveBtnSize.height * 0.8 )
        --self.m_pSaveBtn :setPosition( winX/2+3*nReceiveBtnSize.width, nReceiveBtnSize.height/2+10 )
        
    elseif winY==768 then

	end
end



-------------callback  回调
function CEmailView.onCloseCallBack( self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
	elseif eventType == "TouchEnded" then
        
        self :unregisterMyMediator()
        CCLOG("关闭邮箱界面")
        CCDirector :sharedDirector() :popScene()
		return true
	end
end

function CEmailView.onBtnCallback( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        local nTag = obj:getTag()
        print("领取10 删除20 保存30＝111＝", nTag)
        
        local nCheckInfo = self :getCheckCount()
        if nCheckInfo == 0 then
            if nTag == 10 then
                --CCMessageBox("请选中要领取奖励的邮件！", "提示")
                local msg = "请选中要领取奖励的邮件！"
                self : createMessageBox(msg)
            elseif nTag == 20 then
                --CCMessageBox("请选中要删除的邮件！", "提示")
                local msg = "请选中要删除的邮件！"
                self : createMessageBox(msg)
            elseif nTag == 30 then
                --CCMessageBox("请选中要保存的邮件！", "提示")
                local msg = "请选中要保存的邮件！"
                self : createMessageBox(msg)                
            end
           return 
        end
        
        if nTag == 10 then      --领取选中的邮件物品
            local checkList = nCheckInfo
            
            if self.models then
                for k, v in pairs( self.models) do
                    for kk, vv in pairs( checkList) do
                        if tonumber(vv) == tonumber( v.mail_id) and tonumber(v.pick)==2 or tonumber(v.pick)==0 then
                            table.remove( checkList, kk)
                        end
                    end
                end
            end
            
            print("checkListcheckList", #checkList)
            if #checkList == 0 then
                --CCMessageBox("没有可领取奖励！", "提示" )
                local msg = "没有可领取奖励！"
                self : createMessageBox(msg) 
                return true
            end
            
            require "common/protocol/REQ_MAIL_PICK"
            local msg = REQ_MAIL_PICK()
            msg :setcount( #checkList )
            msg :setmailids( checkList)
             CNetwork :send( msg)

            
            for k, v in pairs( checkList) do
                print( "提取邮件物品==", k, v)
            end
            
                       
        elseif nTag == 20 then  --删除选中的邮件物品
            local checkList = nCheckInfo
            
            for k, v in pairs( checkList) do
                print("试验", k, v)
                if self.models then
                    for key, value in pairs( self.models) do
                        if value.mail_id == v and value.pick == _G.Constant.CONST_MAIL_ACCESSORY_NO then
                            --CCMessageBox("还有附件未提取，无法删除", "提示")
                            local msg = "还有附件未提取，无法删除"
                            self : createMessageBox(msg) 
                            return true
                        end
                    end
                end
            end
            
            if self.models then
                for k, v in pairs( self.models) do
                    for kk, vv in pairs( checkList) do
                        if tonumber(vv) == tonumber( v.mail_id) and tonumber(v.pick)==1 then
                            table.remove( checkList, kk)
                        end
                    end
                end
            end
            
            require "common/protocol/REQ_MAIL_DEL"
            local msg = REQ_MAIL_DEL()
            msg :setcount( #checkList )
            msg :setmailids( checkList)
            CNetwork :send( msg)
            
            for k, v in pairs( checkList) do
                print( "删除由件物品==", k, v)
            end
            
           
        elseif nTag == 30 then
            
        end
        return true
    end
end
--多点触控 滑动界面
function CEmailView.onEmailClickCallback( self, eventType, obj, touches )
    if eventType == "TouchesBegan" then
        
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchEmailId = obj :getTag()
                break
            end
        end
        elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
            return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.touchEmailId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local nRequestId = obj :getTag()
                    
                    local sendData = {}
                    for i=1, #self.models do
                        if nRequestId == self.models[i].mail_id then
                            sendData = self.models[i]
                        end
                    end
                    --选择高亮图片
                    self : clickEmailSpr( tonumber( nRequestId))
                    --同时选择checkbox 
                    if self.checkBox ~= nil then
                        for key, value in pairs( self.checkBox ) do
                            if value :getTag() == nRequestId then
                                value :setChecked( true )
                                break
                            end
                        end
                    end
                    
                    require "view/EmailUI/ReadEmailView"
                    local readEmail = CReadEmailView( nRequestId, sendData)
                    CCDirector :sharedDirector() :pushScene( readEmail :scene())
                    
                    self.touchID     = nil
                    self.touchEmailId = nil
                    break
                end
            end
        end
    end
end

function CEmailView.clickEmailSpr( self, _nMailId)
    if self.m_sprBgLine then
        for key, value in pairs( self.m_sprBgLine) do
            if key == _nMailId then
                value : setImageWithSpriteFrameName("general_underframe_click.png")
            else
                --value : setImage("Loading/transparent.png")--("general_underframe_normal.png")
                value : setImageWithSpriteFrameName("general_underframe_normal.png")
            end
            value :setPreferredSize( CCSizeMake( self.m_viewSize.width - 20, self.m_viewSize.height / 5) )
            
        end
    end
end

function CEmailView.onCheckBox_CallBack( self,eventType,obj,x,y )  --checkBox回调
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        print("onCheckBox_CallBack", obj:getTag(), obj:getChecked())
        local nMailId = tonumber( obj:getTag())
        
        if nMailId ~= CEmailView.SELECTALLTAG then
            local nC      = self :getCheckCount()
            
            self : clickEmailSpr( tonumber( nMailId))
            print("self.nCheckCount==", nC, nMailId)
                        
            --只要有一个未选中，self.m_checkAll 全选就取消掉，否则选择
            local isCheckAll = false
            for i=1, #self.models do
                if self.checkBox[i] == nil then
                    break
                end
                if  false == self.checkBox[i] :getChecked( ) then
                    isCheckAll = false
                    break
                else
                    isCheckAll = true
                end
            end
            
            if obj:getChecked() then
                if nC==0 then
                    self.nCheckCount[1] = nMailId
                else
                    
                    self.nCheckCount[#nC+1] = nMailId
                    
                end
            else
                if nC==0 then
                
                else
                    for k, v in pairs( self.nCheckCount) do
                        if tonumber( v)== nMailId then
                            table.remove( self.nCheckCount, k)
                        end
                    end
                end
            end
            for k, v in pairs( self.nCheckCount) do
                print("nMailIdnMailId", k, v,  #self.models)
            end
            
            
            if self.m_checkAll ~= nil then
                self.m_checkAll :setChecked( isCheckAll)
                return true
            end
        -----------
        else
            --CCMessageBox("选择所有按钮", obj:getChecked())
            if obj:getChecked() then        --true时 所有按钮全显示
                for i=1, #self.models do
                    self.checkBox[i] :setChecked( true)
                    self.nCheckCount[i] = self.models[i].mail_id
                end
            else
                for i=1, #self.models do
                    self.checkBox[i] :setChecked( false)
                    table.remove(self.nCheckCount)
                end
            end
        end
    end
end


-----------------
function CEmailView.setLabel( self, _vo_data)
    if _vo_data == nil then
        return
    end
    --成功提取的邮件id
    print("CEmailView.setLabel", _vo_data.count, _vo_data.id_msg)
    
    for key, value in pairs( self.models) do
        for k, v in pairs( _vo_data.id_msg) do
            if tonumber( v)== tonumber( value.mail_id) and tonumber( value.pick) ==_G.Constant.CONST_MAIL_ACCESSORY_NO then
                --table.remove( self.models, kk)
                value.pick = _G.Constant.CONST_MAIL_ACCESSORY_YES
            end
        end
    end
    
    self :pageScrollView()
end


function CEmailView.setDelView( self, vo_data)
    print("CEmailView.setDelView", self, vo_data: get8562Count())
    local nCount = vo_data: get8562Count()
    local nDataList = vo_data :get8562Data()
    
    if nCount <= 0 then
        --CCMessageBox("没有可删除的邮件!", "提示")
        local msg = "没有可删除的邮件！"
        self : createMessageBox(msg)
    end
    
    local szDelName = nil
    for k, v in pairs( nDataList) do
        for kkk,  vvv in pairs( self.nCheckCount) do
            if tonumber( v) == tonumber( vvv) then
               table.remove(self.nCheckCount, kkk)
            end
        end
        
        for kk, vv in pairs( self.models) do
            if tonumber( v)== tonumber( vv.mail_id) then
                table.remove( self.models, kk)
                print("删除 邮件id", vv.mail_id, vv.name, kk)
                szDelName = vv.name
            end
        end
    end
    
    self :pageScrollView()
end


function CEmailView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end
