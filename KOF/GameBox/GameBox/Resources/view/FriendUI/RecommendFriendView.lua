--推荐好友列表

require "view/view"
require "controller/RecommendFriendCommand"
require "model/VO_RecommendModel"

CRecommendFriendView = class( view, function( self, _vo_data)
     CCLOG("CRecommendFriendView构造")
     if _vo_data~=nil then
        self.m_data = _vo_data
     else
        error( "_vo_data==nil", _vo_data)
     end
         
end)

CRecommendFriendView.SCROLL_TAG = 111

--初始化界面
function CRecommendFriendView.init( self, _winSize, _layer )
    print("CRecommendFriendView.init begin")            
    
    self :initParams()                              --初始化参数
    
    self :initBgAndCloseBtn( _layer )               --初始化背景及关闭按钮
    
    self :initView( _winSize, _layer)               --初始化界面
    self :registerMyMediator()
    self :layout()                        --布局
end

function CRecommendFriendView.registerMyMediator( self)
    self :unregisterMyMediator()
    
    require "mediator/RecommendFriendMediator"
    _G.pRecommendFriendMediator = RecommendFriendMediator( self)
    controller :registerMediator( _G.pRecommendFriendMediator)
end

function CRecommendFriendView.unregisterMyMediator( self)
    if _G.pRecommendFriendMediator ~= nil then
        controller :unregisterMediator( _G.pRecommendFriendMediator)
        _G.pRecommendFriendMediator = nil
    end
end


function CRecommendFriendView.loadResources( self )
end

function CRecommendFriendView.unloadResources( self )
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function CRecommendFriendView.initParams( self )
    self.m_pContainer  = CContainer :create()

end


function CRecommendFriendView.initBgAndCloseBtn( self, _layer )
    local IpadWidthSize  = 854
    local IpadSizeheight = 640
    local function closeCallBack( eventType, obj, x, y )
        return self :onCloseCallBack(eventType, obj, x, y)
    end
    self.m_ViewContainer = CContainer :create()
    self.m_ViewContainer : setPosition(854/4,0)
    self.m_ViewContainer : setControlName( "this is CBuildTeamView self.m_buildTeamViewContainer 127")
    _layer :addChild( self.m_ViewContainer, -100)

    --背景
    self.m_pBackground  = CSprite :createWithSpriteFrameName("general_thirdly_underframe.png")
    self.m_pBackground  : setControlName("this CRecommendFriendView. self.m_pBackground 228")
    self.m_nTouches     = -100
    self.m_pBackground  : setTouchesPriority( self.m_nTouches )
    self.m_ViewContainer: addChild( self.m_pBackground, -100 )
    self.m_pBackground  : setTouchesEnabled (true )
    self.m_pBackground  : setFullScreenTouchEnabled(true)

    self.m_allFirstBackGroundSprite   = CSprite :createWithSpriteFrameName("general_second_underframe.png") --第一底图
    self.m_ViewContainer : addChild(self.m_allFirstBackGroundSprite,-99)   
    
    
    --关闭按钮--
    self.m_pCloseBtn    = CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CRecommendFriendView. self.m_pCloseBtn 236")
    self.m_pCloseBtn    :registerControlScriptHandler( closeCallBack, "this CRecommendFriendView. self.m_pCloseBtn 237" )
    self.m_ViewContainer:addChild( self.m_pCloseBtn, -99)
    self.m_pCloseBtn    :setTouchesPriority( self.m_nTouches -2)
    self.m_pCloseBtn    :setTag( 102)
    
end

function CRecommendFriendView.layout( self )
    local _winSize  = CCDirector:sharedDirector():getVisibleSize()
    -- body
    local winX           = _winSize.width
    local winY           = _winSize.height
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640   
    
    self.m_pBackground              : setPreferredSize(CCSizeMake( IpadSizeWidth/2, IpadSizeheight))
    self.m_allFirstBackGroundSprite : setPreferredSize(CCSizeMake(IpadSizeWidth/2-30,480)) 
    self.m_pBackground              : setPosition( ccp( IpadSizeWidth/4, IpadSizeheight/2))
    self.m_allFirstBackGroundSprite : setPosition( ccp( IpadSizeWidth/4, IpadSizeheight/2))

    local sizeBg            = self.m_pBackground :getPreferredSize()
    local sizeCloseBtn      = self.m_pCloseBtn :getPreferredSize()
    self.m_pCloseBtn        :setPosition( ccp( IpadSizeWidth/2-sizeCloseBtn.width/2 - 10, IpadSizeheight-sizeCloseBtn.height/2 - 10))
    
    local allBtnSize        = self.pAddAllBtn :getPreferredSize()

    ----------
    if winY == 640 then
        local labelY               = IpadSizeheight/2+sizeBg.height/2-sizeCloseBtn.height*0.72
        self.pRecommendFriendLabel :setPosition( IpadSizeWidth/4, IpadSizeheight-40)
        self.pAddAllBtn            :setPosition( IpadSizeWidth/4, 40)
        -- self.pLineSpr              :setPreferredSize( CCSizeMake( sizeBg.width, 1 ))
        -- self.pLineSpr              :setPosition( IpadSizeWidth/2, labelY-20)
        self.hNameLayout           :setPosition( IpadSizeWidth/2-sizeBg.width/2+20, labelY-50)
    elseif winY == 768 then
        print("winY == 768 ")
    end 
    ----------
end

--
function CRecommendFriendView.initView( self, _winSize, _layer )
    local szLabelName = "Arial"
    local nFontSize   = 25
    
    local l_container = CContainer :create()
    self.m_pContainer :addChild( l_container)
    
    local function btnCallback( eventType, obj, x, y)
        return self :onBtnCallback( eventType, obj, x, y)
    end
    --全部添加按钮
    self.pAddAllBtn     = CButton :createWithSpriteFrameName("全部添加", "general_button_normal.png")
    self.pAddAllBtn     :setControlName("this CRecommendFriendView self.pAddAllBtn 96")
    self.pAddAllBtn     :registerControlScriptHandler( btnCallback, "this CRecommendFriendView self.pAddAllBtn 97")
    self.pAddAllBtn     :setTouchesPriority( self.m_nTouches -1)
    self.pAddAllBtn     :setFontSize( nFontSize-1)
    self.m_ViewContainer:addChild( self.pAddAllBtn)
    
    
    --推荐好友label
    self.pRecommendFriendLabel  = CCLabelTTF :create("推荐好友", szLabelName, nFontSize)
    self.m_ViewContainer        : addChild( self.pRecommendFriendLabel)
    
    --角色名 职业 等级
    self.hNameLayout     = CHorizontalLayout :create()
    self.m_ViewContainer : addChild( self.hNameLayout, -98)
    
    self.hNameLayout  :setControlName("this CRecommendFriendView. self.hNameLayout 246")
    self.hNameLayout  :setHorizontalDirection( true)
    --hNameLayout  :setVerticalDirection( false)
    self.hNameLayout  :setCellHorizontalSpace( 20)
    self.hNameLayout  :setLineNodeSum( 3)
    
    self :createLabelLayout( self.m_data)
end

function CRecommendFriendView.createLabelLayout( self, _data)
    if self.m_pScrollView ~= nil then
        self.m_pScrollView : removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
    
    print("_data=", _data)
    if _data == nil or self.m_count == 0 then
        return
    end
    --print( debug.traceback())
    local nPageLine   = 10
    local nLineCount = #_data
    self.m_count     = tonumber(nLineCount) 
    local nPage ,lastPageCount = self :getPages( nLineCount, nPageLine)
    
    self.m_pageCount = nPage
    self.m_currentPage  = self.m_pageCount-1
    
    if nPage <= 0 or nLineCount <=0 then
        print("没有信息", nPage, nLineCount)
        return
    end
    
    print("页数：", nPage, "行数：", nLineCount,"最后一页个数",lastPageCount)
    
    local function pageCallback( eventType, obj, x, y)
        print("XXXXXXXpageCallback:",eventType, obj, x, y)
        return self :onPageCallback( eventType, obj, x, y)
    end
    
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local sizeBg  = self.m_pBackground :getPreferredSize()
    print("sizeBg", sizeBg.width, sizeBg.height)
    local viewSize = CCSizeMake( 854/2, 480)      --385 323   winX/2, winY-60))
    local lineHeight = 480 / nPageLine        --行高
    print("viewSize:", viewSize.width, viewSize.height, lineHeight)
                                
    self.m_pScrollView  = CPageScrollView :create( eLD_Vertical, viewSize)
    self.m_pScrollView  : setControlName("this CRecommendFriendView. self.m_pScrollView 220")
    self.m_pScrollView  : registerControlScriptHandler( pageCallback, "this CRecommendFriendView. self.m_pScrollView 221")
  self.m_pScrollView  : setTouchesPriority( self.m_nTouches - 1 )
    self.m_ViewContainer: addChild( self.m_pScrollView, -97)

    
    local function touchCallback( eventType, obj, x, y)
        --print( "addbtn1111 ", obj :getTouchesPriority(), eventType, obj :getTag() )
        return self :onTouchCallback( eventType, obj, x, y)
    end
    
    local szLabelName = "Arial"
    local nFontSize   = 18
    
    --页内容  --nLineCount包括行数
    local _pageContainer   = {}
    local nLine            = nLineCount        --显示行数
    local teaminfoCellSize = CCSizeMake( 854/2-25, lineHeight) --height=96 +10    
    local layout = {}
    for iPage=1,nPage do
        print("-------------------------------iPage=",iPage)
        _pageContainer[iPage] = CContainer :create()
        self.m_pScrollView :addPage( _pageContainer[iPage])
        _pageContainer[iPage] : setControlName("this CRecommendFriendView. _pageContainer[iPage] 166")

        layout[iPage] = CHorizontalLayout :create()     
        _pageContainer[iPage] : addChild( layout[iPage])
        layout[iPage]: setPosition( -70, 215) --200 -160 370
        layout[iPage]: setVerticalDirection( false)
        --layout[iPage]: setCellVerticalSpace( 0)
        layout[iPage]: setLineNodeSum( 1)
        layout[iPage]: setCellSize( teaminfoCellSize)

            for i=1,nPageLine do
                num = nLine --(iPage-1)*nPageLine + i
                ----单个添加按钮
                local addBtn = CButton :createWithSpriteFrameName("添加", "general_smallbutton_click.png")
                addBtn       : setScale(0.8)
                addBtn       : setControlName("this CRecommendFriendView self.pAddAllBtn 96")
                addBtn       : setTouchesPriority( self.m_nTouches-2)
                if _data[num].fid then
                    addBtn   : setTag( _data[num].fid)
                end
                addBtn       : registerControlScriptHandler( touchCallback, "this CRecommendFriendView self.pAddAllBtn 97")
                addBtn       : setFontSize( nFontSize)
                layout[iPage]: addChild( addBtn)

                local szRoleName = "角色名"
                if _data[num].fname then
                    szRoleName = tostring(_data[num].fname)
                end
                
                local szPro      = "职业"
                if _data[num].pro then
                    szPro = self : getJobName(_data[num].pro)  
                end
                
                local szLv      = "级别"
                if _data[num].flv then
                    szLv = tostring(_data[num].flv.."级")
                end

                local partingLineSprite  = CSprite :createWithSpriteFrameName( "team_dividing_line.png") --我是无耻的分割线 
                partingLineSprite        : setPreferredSize(CCSizeMake(854/2+60,2))
                partingLineSprite        : setControlName( "this CGenerateTeamView partingLineSprite 565 ")
                partingLineSprite        : setPosition(-165,-30)
                addBtn                   : addChild(partingLineSprite,10)            

                local pRoleLabel  = CCLabelTTF :create( szRoleName, szLabelName, nFontSize+3)
                pRoleLabel : setAnchorPoint( ccp(0.0, 0.5))
                pRoleLabel : setPosition(-360,0)
                addBtn     : addChild( pRoleLabel)
                
                local pProLabel  = CCLabelTTF :create( szPro, szLabelName, nFontSize+3)
                pProLabel : setAnchorPoint( ccp(0.0, 0.5))
                pProLabel : setPosition(-140,0)
                addBtn    : addChild( pProLabel)
                
                local pLvLabel  = CCLabelTTF :create( szLv, szLabelName, nFontSize+3)
                pLvLabel : setAnchorPoint( ccp(0.0, 0.5))
                pLvLabel : setPosition(-230,0)
                addBtn   : addChild( pLvLabel)
    
                if nLine <= 1 then
                    break
                else
                    nLine = nLine - 1
                end
            end
          
    end

    
    local IpadSizeWidth  = 854
    local IpadSizeheight = 640 
    self.m_pScrollView :setPage( 0, false)
    ---position
    if winSize.height==640 then
        self.m_pScrollView :setPosition( 0, 80)
    elseif winSize.height==768 then
        print("winY == 768 ")
    end
    print("更新成功-----------------------------")
end


function  CRecommendFriendView.getJobName( self, _pro)
    local prostring = nil
    if _pro == _G.Constant.CONST_PRO_NULL then
        prostring = "所有"
    elseif _pro == _G.Constant.CONST_PRO_SUNMAN then
        prostring = "烈焰之拳"
    elseif _pro == _G.Constant.CONST_PRO_ZHENGTAI then
        prostring = "焰之旋风"
    elseif _pro == _G.Constant.CONST_PRO_ICEGIRL then
        prostring = "苍蓝之冰"
    elseif _pro == _G.Constant.CONST_PRO_BIGSISTER then
        prostring = "飞天之舞"
    elseif _pro == _G.Constant.CONST_PRO_LOLI then
        prostring = "梦幻之星"
    elseif _pro == _G.Constant.CONST_PRO_MONSTER then
        prostring = "钢铁之躯"
    else
        prostring = "没有找到相应职业"
    end
    return prostring
end

function CRecommendFriendView.scene( self )
    local winSize   = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer = CContainer :create()
    self:init( winSize, self.Scenelayer)
    if self.m_pContainer:getParent() ~= nil then
        self.m_pContainer:removeFromParentAndCleanup(false)
    end
    self.Scenelayer : addChild(self.m_pContainer)
    return self.Scenelayer
end

function CRecommendFriendView.getPages( self, _nCount, _nLine)
    local everCount = _nCount
    _nCount = tonumber( _nCount)
    if _nCount ~= 0 then
        local nnn = _nCount%_nLine
        if nnn > 0 then
            _nCount = math.modf(_nCount/_nLine) + 1
        else
            _nCount = _nCount/_nLine
        end
    else
        _nCount = 1
    end
    local lastPageCount =  everCount%_nLine          --最后一页个数
    print("默认=", _nCount, everCount,lastPageCount,_nCount,_nLine)
    return tonumber(_nCount),lastPageCount
end


----------------callback函数 begin
function CRecommendFriendView.onRewardCallback( self, eventType, obj, x, y )
    -- body
end

function CRecommendFriendView.onCloseCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:getTag() == 102 then

            print("@@@@@@@@@@@@@@@@关闭好友推荐界面@@@@@@@@@@@@@@@@")
            if self.Scenelayer ~= nil then
                self.Scenelayer :removeFromParentAndCleanup( true)
                self.Scenelayer = nil
                self : unloadResources()
            end
            self :unregisterMyMediator()
        end
        
        return true
    end
end


function CRecommendFriendView.onBtnCallback( self, eventType, obj, x, y)
    print("self.m_count111",self.m_count)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if self.m_count ~=nil and self.m_count > 0 then
            if self.m_data == nil then
                print("self.m_data没有数据", self.m_count)
                return 
            end
            
            local sendList = {}
            for i=1, self.m_count do
                sendList[i] = tonumber( self.m_data[i].fid)
            end
 
            require "common/protocol/auto/REQ_FRIEND_ADD"
            local msg = REQ_FRIEND_ADD()
            msg :setType( 1)
            msg :setCount( self.m_count)
            msg :setDetail( sendList)
            CNetwork :send( msg)
            print("推荐 添加好友 数量=", #sendList, obj :getTag())
        end
        
        print("@@@@@@@@@@@@@@@@关闭好友推荐界面@@@@@@@@@@@@@@@@")
        if self.Scenelayer ~= nil then
            self.Scenelayer :removeFromParentAndCleanup( true)
            self.Scenelayer = nil
            self : unloadResources()
        end
        self :unregisterMyMediator()
        return true
    end
end


function CRecommendFriendView.onPageCallback( self, eventType, obj, x, y)
    print("onPageCallback111：", eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        return true
    elseif eventType == "PageScrolled" then
        print("PageScrolled222:", eventType, obj, x, y)
        return true
    end
    
end

function CRecommendFriendView.onTouchCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        
        print( obj:getTag())
        
        if obj:getTag() then
            local sendList = {}
            sendList[1] = obj:getTag()
            
            require "common/protocol/auto/REQ_FRIEND_ADD"
            local msg = REQ_FRIEND_ADD()
            msg :setType( 1)
            msg :setCount( 1)
            msg :setDetail( sendList)
            CNetwork :send( msg)
        end
        return true
    end
    
end




function CRecommendFriendView.pushData( self)
    print("CRecommendFriendView.pushData ")
    print("过滤已经添加的  和已经是自己的好友")
    if _G.pCFriendDataProxy :getInitialized() and _G.pCFriendDataProxy :getFriendCount()>0 then
        self.data = _G.pCFriendDataProxy :getFriendData()
        self.count = _G.pCFriendDataProxy :getFriendCount()
    else
        self.data = nil
        self.count = 0
    end
    
    print(self.data, self.m_data, self.m_count, self.count)
    if self.data and self.m_data and self.m_count~=nil and self.count>0 then
        for k, v in pairs(self.m_data) do
            for kk, vv in pairs(self.data) do
                print("vvvvvv.id", v.fid, vv.fid)
               if tonumber( v.fid) == tonumber( vv.fid) then
                  table.remove( self.m_data, k)
                   
               end
            end
        end
    end
        if self.m_data then
            self.m_count = #self.m_data
            print("sfsfsfsfsfs",self.data, self.m_data, self.m_count, self.count)
        end
    if self.m_count > 0 then
        self :createLabelLayout( self.m_data)
    else
        self :createLabelLayout( nil)
    end
end










