require "view/view"

CMarquee = class(view, function ( self )
    self.m_marqueeMsgList = {}
    self.m_isRun       = false
    self.winSize       = CCDirector : sharedDirector() :getVisibleSize()
    self.m_lastTime    = 0
    self.m_curshowtime = 1
    self :load()    
end)

CMarquee.SHOW_V      = 100

CMarquee.FONT_SIZE   = 24

function CMarquee.load( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/ChallengeResources.plist")    
end


function CMarquee.pushOne( self, _msgData )
    if _G.g_Stage :getScene() == CCDirector : sharedDirector() : getRunningScene() then        
        table.insert( self.m_marqueeMsgList, _msgData )
        print("List加入一条跑马灯消息 num:"..#self.m_marqueeMsgList)
    else
        self.m_marqueeMsgList = {}
        print("不在主城场景跳过跑马灯消息 num:"..#self.m_marqueeMsgList)
    end
end

function CMarquee.show( self, _nowTime )
    --print("MMMMMMMMMMMMMMMMMMM--->1 show")
    if _G.g_Stage == nil or _G.g_Stage : isInit() ~= true then
        --print("MMMMMMMMMMMMMMMMMMM--->A")
        return
    end
    if #self.m_marqueeMsgList <= 0 then
        self.m_lastTime = _nowTime
        --print("MMMMMMMMMMMMMMMMMMM--->B")
        return
    end
    if _nowTime - self.m_lastTime <= self.m_curshowtime*1000 then --间隔1s 1000
        --print("MMMMMMMMMMMMMMMMMMM--->C")
        return
    end
    local nodemsg      = self.m_marqueeMsgList[1]
    local _szString    = "<color:255,255,0,255>"..nodemsg.msgdata
    local _showtime    = nodemsg.showtime
    self.m_marqueeMsgList[1] = nil
    table.remove(self.m_marqueeMsgList,1)
    print("List去掉一条跑马灯消息 num:"..#self.m_marqueeMsgList)
    self : addString( _szString, _showtime )
    self.m_lastTime = _nowTime
end

function CMarquee.addString( self, _string, _showtime)
    ----[[ --ScrollView
    self.m_marqueeContainer = self :createMarquee( _string, _showtime)
    _G.g_Stage : addMarquee( self.m_marqueeContainer)
     --]]
end

function CMarquee.createMarquee( self, _string, _showtime)
    print("XXXXXX Time:".._showtime)
    self :load()
    local marqueeContainer    = self :createContainer( " marqueeContainer")
    local _marqueeBackground  = self :createSprite( "arena_underframe.png", "_marqueeBackground")
    local _backgroundSize     = _marqueeBackground :getPreferredSize()
    local scrollViewContainer = self :createContainer( " scrollViewContainer")   

    local _itemlabel = CCLabelTTF :create( _string, "Arial", CMarquee.FONT_SIZE)
    local size       = _itemlabel :getContentSize()
    _itemlabel :release()
    local length   = size.width-200 --string.len( _string)/4*CMarquee.FONT_SIZE
    print("XXXXXX Length:"..length)
    _showtime = (length+500)/CMarquee.SHOW_V
    self.m_curshowtime = _showtime
    print(" Length: ",length+500, " Time: ",_showtime)
    local lpString = self :createLabelColor( _string)
    scrollViewContainer :addChild( lpString)

    _marqueeBackground :setPreferredSize( ccp( 500, _backgroundSize.height*1.2)) --跑马灯背景大小
    _backgroundSize     = _marqueeBackground :getPreferredSize()

    local scrollView = CCScrollView :create( CCSizeMake(500, _backgroundSize.height), scrollViewContainer)
    scrollView : setDirection(kCCScrollViewDirectionHorizontal) --kCCScrollViewDirectionHorizontal kCCScrollViewDirectionVertical
    scrollView : setContentOffsetInDuration(CCPointMake( -length/2, _backgroundSize.height/2 ), _showtime)
    scrollView : setTouchEnabled(false)
    scrollView : setContentSize( CCSizeMake( length, _backgroundSize.height))

    scrollView : setPosition( ccp( self.winSize.width/2-500/2, self.winSize.height*0.7-_backgroundSize.height/2))
    scrollViewContainer :setPosition( ccp( 500+length/2, _backgroundSize.height/2))
    _marqueeBackground :setPosition( ccp( self.winSize.width/2, self.winSize.height*0.7))

    local function onCallBack()
        -- self.m_marqueeMsgList[1] = nil
        -- table.remove(self.m_marqueeMsgList,1)
        -- print("List去掉一条跑马灯消息 num:"..#self.m_marqueeMsgList)
        print("@@@@@@@@@@@@@@@@@@ reset self.m_curshowtime = 1")
        self.m_curshowtime = 1
        marqueeContainer : removeFromParentAndCleanup(true)
        marqueeContainer = nil
    end
    local _callBacks = CCArray:create()
    _callBacks:addObject(CCMoveTo:create( _showtime, ccp( self.winSize.width/2, self.winSize.height*0.7) ))
    _callBacks:addObject(CCCallFunc:create(onCallBack))
    _marqueeBackground : runAction( CCSequence:create(_callBacks) )

    marqueeContainer :addChild( _marqueeBackground)
    marqueeContainer :addChild( scrollView)
    return marqueeContainer
end

--创建容器CContainer
function CMarquee.createContainer( self, _controlname)
    print("this is CMarquee createContainer ".._controlname)
    local itemcontainer = CContainer :create()
    itemcontainer :setControlName( _controlname)
    return itemcontainer
end

--创建图片Sprite
function CMarquee.createSprite( self, _image, _controlname)
    print("this is CMarquee createSprite ".._controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CMarquee createSprite ".._controlname)
    return _background
end

--创建LabelColor
function CMarquee.createLabelColor( self, _string)
    print( "this is CMarquee createLabelColor :".._string)
    local itemlabel = CLabelColor : create()
    itemlabel : appendText( _string, "Marker Felt", CMarquee.FONT_SIZE)
    return itemlabel
end


