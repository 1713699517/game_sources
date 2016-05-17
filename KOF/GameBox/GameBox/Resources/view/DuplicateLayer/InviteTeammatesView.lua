--[[
 --CInviteTeammatesView
 --选择关卡主界面

 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/InviteTeammatesMediator"


CInviteTeammatesView = class(view, function( self)
print("CInviteTeammatesView:邀请队友！")
end)
--Constant:

CInviteTeammatesView.PER_PAGE_COUNT      = 6

CInviteTeammatesView.TAG_FRIENDROLE      = 201
CInviteTeammatesView.TAG_CURRENTROLE     = 202
CInviteTeammatesView.TAG_CLOSED          = 203

CInviteTeammatesView.TAG_TEAMINFOCELL    = 300


--加载资源
function CInviteTeammatesView.loadResource( self)
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")

    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("TeamViewResources/TeamViewResources.plist") 

end

--释放资源
function CInviteTeammatesView.unLoadResource( self)
    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("TeamViewResources/TeamViewResources.plist")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

--初始化数据成员
function CInviteTeammatesView.initParams( self, layer)
    print("CInviteTeammatesView.initParams")
    --mediator注册
    _G.g_CInviteTeammatesMediator = CInviteTeammatesMediator (self)
    controller :registerMediator(  _G.g_CInviteTeammatesMediator )

    self.inviteType = 1
  
end

--释放成员
function CInviteTeammatesView.realeaseParams( self)
    
end

--布局成员
function CInviteTeammatesView.layout( self, winSize)
    local IpadSizeWidth  = 450
    local IpadSizeheight = 510 
    if winSize.height == 640 then
        print("640--组队界面")
        local inviteteammatesbackgroundfirst  = self.m_inviteTeammatesViewContainer :getChildByTag( 100)
        local teammateslistbackground         = self.m_inviteTeammatesViewContainer :getChildByTag( 101)
            
        inviteteammatesbackgroundfirst : setPreferredSize( CCSizeMake( 450,510))
        teammateslistbackground        : setPreferredSize( CCSizeMake( 420,420))

        local closedButtonSize                   = self.m_closedButton :getContentSize()
        local tagButtonSize                      = self.m_friendButton :getContentSize()
        local inviteteammatesbackgroundfirstSize = inviteteammatesbackgroundfirst :getContentSize()
        
        inviteteammatesbackgroundfirst : setPosition( ccp( 480, 320))
        teammateslistbackground        : setPosition( ccp( 480, 288))
        self.m_tagLayout               : setPosition( IpadSizeheight-tagButtonSize.width/2-170, IpadSizeheight-tagButtonSize.height/2+50)

        self.m_closedButton            : setPosition( ccp( IpadSizeWidth-closedButtonSize.width/2+255-10, IpadSizeheight-closedButtonSize.height/2+65-10))

    elseif winSize.height == 768 then
        CCLOG("768--组队界面")
    end
end

--主界面初始化
function CInviteTeammatesView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化界面
    self.initView(self, layer,winSize)
    --布局成员
    self.layout(self, winSize)  
    --初始化数据
    self.initParams(self,layer)
end

function CInviteTeammatesView.scene(self)
    print("create scene")
    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self._scene       = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CInviteTeammatesView self.m_scenelayer 95" )
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)

    return self._scene
end

function CInviteTeammatesView.layer( self)
    print("create m_scenelayer")
    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CInviteTeammatesView self.m_scenelayer 106" )
    --self.m_scenelayer : setTouchesPriority( -101 )
    
   -- self.m_scenelayer : setFullScreenTouchEnabled(true)
    self.m_scenelayer : setTouchesEnabled(true)
    self.m_scenelayer : setTouchesPriority(-99)

    self :init(winSize, self.m_scenelayer)

    return self.m_scenelayer
end

--初始化背包界面
function CInviteTeammatesView.initView(self, layer,winSize)
    print("CInviteTeammatesView.initHangupView")
    --副本界面容器
    self.m_inviteTeammatesViewContainer = CContainer :create()
    self.m_inviteTeammatesViewContainer : setControlName( "this is CInviteTeammatesView self.m_inviteTeammatesViewContainer 116" )
    layer :addChild( self.m_inviteTeammatesViewContainer)
    
    local function CellCallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end

    local inviteteammatesbackgroundfirst  = CSprite :createWithSpriteFrameName( "general_thirdly_underframe.png")  --背景Img
    local teammateslistbackground         = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    inviteteammatesbackgroundfirst        : setControlName( "this CInviteTeammatesView inviteteammatesbackgroundfirst 125 ")
    teammateslistbackground               : setControlName( "this CInviteTeammatesView teammateslistbackground 126 ")
    self.m_friendButton                   = CButton :createWithSpriteFrameName( "好友", "general_label_click.png")
    self.m_currentButton                  = CButton :createWithSpriteFrameName( "社团", "general_label_click.png")
    self.m_closedButton                   = CButton :createWithSpriteFrameName( "", "general_close_normal.png")

    self.m_friendButton                   : setTouchesPriority( -100 )
    self.m_currentButton                  : setTouchesPriority( -101 )
    self.m_closedButton                   : setTouchesPriority( -101 )

    self.m_friendButton  : setControlName( "this CInviteTeammatesView self.m_friendButton 129 " )
    self.m_currentButton : setControlName( "this CInviteTeammatesView self.m_currentButton 130 " )
    self.m_closedButton  : setControlName( "this CInviteTeammatesView self.m_closedButton 131 " )
    
    self.m_friendButton  : setFontSize( 30)
    self.m_currentButton : setFontSize( 30)

    self.m_friendButton : setTouchesEnabled(true)
    
    self.m_friendButton  : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_friendButton 138")
    self.m_currentButton : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_currentButton 139")
    self.m_closedButton  : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_closedButton 140")
    
    self.m_tagLayout     = CHorizontalLayout :create()
    local cellButtonSize = self.m_friendButton :getContentSize()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setCellHorizontalSpace( 5)
    self.m_tagLayout :setLineNodeSum(2)
    self.m_tagLayout :setCellSize( cellButtonSize)
    
    self.m_tagLayout : addChild( self.m_friendButton, 1, CInviteTeammatesView.TAG_FRIENDROLE)
    self.m_tagLayout : addChild( self.m_currentButton, 1, CInviteTeammatesView.TAG_CURRENTROLE)
    self.m_inviteTeammatesViewContainer : addChild( inviteteammatesbackgroundfirst, -1, 100)
    self.m_inviteTeammatesViewContainer : addChild( teammateslistbackground, -1, 101)
    self.m_inviteTeammatesViewContainer : addChild( self.m_tagLayout)
    self.m_inviteTeammatesViewContainer : addChild( self.m_closedButton, 2, CInviteTeammatesView.TAG_CLOSED)

    --TeamList界面
    self.m_teamContainer = CContainer :create()
    self.m_teamContainer : setControlName( "this is CInviteTeammatesView self.m_teamContainer 153" )
    self.m_inviteTeammatesViewContainer : addChild( self.m_teamContainer)

    local partingLineSprite  = CSprite :createWithSpriteFrameName( "general_dividing_line.png") --我是无耻的分割线    
    partingLineSprite        : setControlName( "this CInviteTeammatesView partingLineSprite 163 ")

    self.m_teamContainer : addChild( partingLineSprite, 1, 103)

    local teamListContainer = CContainer :create()
    teamListContainer : setControlName( "this is CInviteTeammatesView teamListContainer 164" )
    teamListContainer : setTag( 105)
    self.m_teamContainer : addChild( teamListContainer)
    
    --local roleinfoButtonSize  = CCSizeMake( winSize.width*0.65, winSize.height*0.12)
    local viewSize            = CCSizeMake( 430, 65*6)
    local pageLayer           = CCLayer :create()
    

    self.m_pScrollView = CPageScrollView :create(2,viewSize)
    self.m_pScrollView : setTouchesPriority( -150)
    self.m_pScrollView : setTouchesEnabled(true)
    self.m_pScrollView : setPosition( ccp( 269, 105))
    teamListContainer  : addChild( self.m_pScrollView)
end

function CInviteTeammatesView.showCheckPointView( self, _checkpoints)
    
end

--更新本地list数据
function CInviteTeammatesView.setLocalList( self)
    print("CInviteTeammatesView.setLocalList")

end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CInviteTeammatesView.clickCellCallBack(self,eventType, obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then

        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        local temptag = math.mod( math.mod( obj :getTag(), CInviteTeammatesView.TAG_TEAMINFOCELL), 10)
        if obj :getTag() == CInviteTeammatesView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                if _G.g_CInviteTeammatesMediator ~= nil then
                    controller :unregisterMediator(_G.g_CInviteTeammatesMediator)
                    _G.g_CInviteTeammatesMediator = nil
                end
                self : unLoadResource()
                self.m_scenelayer :removeFromParentAndCleanup (true)
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CInviteTeammatesView.TAG_FRIENDROLE then
            print(" 好友list")
            self.inviteType = 1
            self : requestFriendNetWorkSend(1) --请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）
        elseif obj :getTag() == CInviteTeammatesView.TAG_CURRENTROLE then
            print(" 社团")
            self.inviteType = 2
            self : requestClanNetWorkSend()
        else
            if temptag == 0 then
                print( "弹出该玩家信息", obj :getTag())
            elseif temptag == 1 then
                print( "邀请该玩家为队友", obj :getTag())
            end
        end
    end
end


function CInviteTeammatesView.pushData(self,_Count,_FriendListData,_friendType) --_friendType 1表示好友 2表示社团
    print("CInviteTeammatesView.pushData 刷一刷",_Type,_Count,_FriendListData)
    -- local Type           = _Type               --好友列表类型
    local Count                = _Count           --好友数量
    local FriendListData       = _FriendListData  --好友信息块
    local FriendOnLineListData = {}               --好友在线信息表
    local loops                = 0                --在线好友计数
    self : cleanViewData ()                       --清除旧数据

    if Count > 0 then
        if _friendType == 1 then
            for k,v in pairs(FriendListData) do
                if v.isonline == 1 then
                    loops = loops + 1 
                    FriendOnLineListData[loops] = {}  --好友在线信息表
                    FriendOnLineListData[loops] = v              
                end
            end
            if loops > 0 then
                self : initScrollView(loops)          --初始化ScrollView界面 

                for i,v in pairs(FriendOnLineListData) do
                    --self.m_teamInfoBtn[k] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                    local  text  = v.fname.."    ".."LV"..v.flv.."       "
                    self.m_teamInfoBtn[i] : setText(text)
                    -- self.m_teamInfoBtn[i] : setTag( CBuildTeamView.TAG_TEAMINFOCELL + i)
                    --self.m_teamInfoBtn[i] : setTag( v.fid)
                    self.m_teamInfoInviteBtn[i] : setTag( v.fid)

                end  
            end 

        elseif _friendType == 2 then
            for k,v in pairs(FriendListData) do
                if v.time == 1 then
                    loops = loops + 1 
                    FriendOnLineListData[loops] = {}  --好友在线信息表
                    FriendOnLineListData[loops] = v              
                end
            end
            if loops > 0 then
                self : initScrollView(loops)          --初始化ScrollView界面 

                for i,v in pairs(FriendOnLineListData) do
                    --self.m_teamInfoBtn[k] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                    local  text  = v.name.."    ".."LV"..v.lv.."       "
                    self.m_teamInfoBtn[i] : setText(text)
                    -- self.m_teamInfoBtn[i] : setTag( CBuildTeamView.TAG_TEAMINFOCELL + i)
                    --self.m_teamInfoBtn[i] : setTag( v.uid)
                    self.m_teamInfoInviteBtn[i] : setTag( v.uid)
                end  
            end 
        end          
    end
end

function CInviteTeammatesView.initScrollView(self,_Count) --初始化ScrollView界面
    local function CellCallBack(eventType, obj, touches)
        -- return self : clickCellCallBack(self,eventType, obj,x,y)
        return self : m_teamInfoBtnCallBack(eventType, obj, touches)
    end 

    self.m_teamInfoBtn        = {}
    self.m_teamInfoInviteBtn  = {}    
    local pageContiner   = {}
    self.m_lastPageCount = 0 
    self.m_pageCount     = 1
    local num            = 0
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local teaminfoCellSize = CCSizeMake( 412, 65)
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( _Count, CInviteTeammatesView.PER_PAGE_COUNT)
    print("滑动页面进来了", self.m_pageCount, self.m_lastPageCount)
    for i=tonumber(self.m_pageCount),1,-1  do
    --for i=1, tonumber(self.m_pageCount) do

        pageContiner[i] = CContainer : create()
        pageContiner[i] : setControlName( "this is CEquipEnchantView pageContainer[i] 74" )

        local layout = CHorizontalLayout :create()     
        pageContiner[i] : addChild( layout)
        layout       : setPosition( -210, 160)
        layout       : setVerticalDirection( false)
        layout       : setCellVerticalSpace( 0)
        layout       : setLineNodeSum( 1)
        layout       : setCellSize( teaminfoCellSize)
       
        if i == self.m_pageCount  then
            local tempnum = self.m_lastPageCount
            -- for j=tempnum,1,-1 do  
             for j=1,tempnum do           
                num = (i-1)*6+j
                if self.m_teamInfoBtn[num] ~= nil then
                     self.m_teamInfoBtn[num] : removeFromParentAndCleanup(true)
                end
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."我是大魔王            LV99", "team_list_click.png")
                self.m_teamInfoBtn[num] : setControlName( "this CInviteTeammatesView self.m_teamInfoBtn[num] 383 "..tostring(i).."  "..tostring(j) )
                --self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setTouchesPriority( -205)
                self.m_teamInfoBtn[num] : setTouchesEnabled(true)        
                self.m_teamInfoBtn[num] : setFontSize( 25)
                --self.m_teamInfoBtn[num] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                --self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])

                self.m_teamInfoInviteBtn[num] = CButton :createWithSpriteFrameName( "邀请", "general_smallbutton_click.png")
                self.m_teamInfoInviteBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoInviteBtn[num] : setTouchesEnabled(true) 
                self.m_teamInfoInviteBtn[num] : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_teamInfoBtn[i][k] 241") 
                self.m_teamInfoInviteBtn[num] : setFontSize( 25)
                self.m_teamInfoInviteBtn[num] : setPosition(150,0)             
                self.m_teamInfoBtn[num]       : addChild( self.m_teamInfoInviteBtn[num],10)

            end   
        else
            local tempnum = CInviteTeammatesView.PER_PAGE_COUNT
            -- for j=1,tempnum do    
             for j=1,tempnum do           
                num = (i-1)*6 + j
                if self.m_teamInfoBtn[num] ~= nil then
                     self.m_teamInfoBtn[num] : removeFromParentAndCleanup(true)
                end
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."我是大魔王            LV99", "team_list_click.png")
                self.m_teamInfoBtn[num] : setControlName( "this CInviteTeammatesView self.m_teamInfoBtn[num] 396 "..tostring(i).."  "..tostring(j) )
                --self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setTouchesPriority( -205)
                self.m_teamInfoBtn[num] : setTouchesEnabled(true)     
                self.m_teamInfoBtn[num] : setFontSize( 30)
                --self.m_teamInfoBtn[num] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                --self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])

                self.m_teamInfoInviteBtn[num] = CButton :createWithSpriteFrameName( "邀请", "general_smallbutton_click.png")
                self.m_teamInfoInviteBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoInviteBtn[num] : setTouchesEnabled(true) 
                self.m_teamInfoInviteBtn[num] : registerControlScriptHandler( CellCallBack, "this CInviteTeammatesView self.m_teamInfoBtn[i][k] 241") 
                self.m_teamInfoInviteBtn[num] : setFontSize( 25)
                self.m_teamInfoInviteBtn[num] : setPosition(150,0)             
                self.m_teamInfoBtn[num]       : addChild( self.m_teamInfoInviteBtn[num],10)
            end            
        end
    end
    --for k=1 , tonumber(self.m_pageCount) do
    for k=tonumber(self.m_pageCount),1,-1  do
        self.m_pScrollView : addPage(pageContiner[k])  
    end
    self.m_pScrollView : setPage(self.m_pageCount, true)--设置起始页[0,1,2,3...] 
end

function CInviteTeammatesView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end


function CInviteTeammatesView.cleanViewData(self) --数据请除
    if self.m_pScrollView ~= nil then
        --self.m_pScrollView : removeAllChildrenWithCleanup( true)
        --local m_pageCount, m_lastPageCount = self :getPageAndLastCount( _Count, CBuildTeamView.PER_PAGE_COUNT)
        local  counts = self.m_pScrollView : getPageCount() 
        if counts > 0 then
            for i=1,counts do
                self.m_pScrollView : removePageByIndex(0)
            end
        end
    end
end

--多点触控
function CInviteTeammatesView.m_teamInfoBtnCallBack(self, eventType, obj, touches)
    print("m_teamInfoBtnCallBack eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        print("aaaaa")
        local touchesCount = touches:count()
        print("bbbbb",touchesCount)
        for i=1, touchesCount do
                    print("ccc")
            local touch = touches :at( i - 1 )
                    print("ddd")
            if obj:getTag() > 300 then
                        print("eeeee")
                local touchPoint = touch :getLocation()
                        print("ffff")
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                            print("hhh")
                    self.touchID = touch :getID()
                    print( "XXXXXXXXSs1111111111"..self.touchID,obj:getTag(),obj)
                    self.transfId = obj:getTag()

                    break
                end
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
 
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID then
                local touch2Point = touch2 :getLocation()
                print("fuckkkkk")
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 and self.transfId == obj:getTag() then
                    print ("多点触控～～")
                    if self.transfId ~= nil and self.transfId > 0 then
                        self : inviteFriendNetWorkSend(self.transfId,self.inviteType)

                        obj : setTouchesEnabled(false)
                    end
                end
            end
        end
        self.touchID = nil
    end
end

function CInviteTeammatesView.requestClanNetWorkSend( self) -- (手动) -- [33010]请求社团面板 -- 社团 
    require "common/protocol/auto/REQ_CLAN_ASK_MEMBER_MSG"
    local msg = REQ_CLAN_ASK_MEMBER_MSG()
    CNetwork  : send( msg)
end


function CInviteTeammatesView.requestFriendNetWorkSend( self, _nType)
    _nType = tonumber( _nType)
    print("请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）, _nType==", _nType)  
    if _nType ~= nil then
        require "common/protocol/auto/REQ_FRIEND_REQUES"
        local msg = REQ_FRIEND_REQUES()
        msg :setType( _nType)
        CNetwork : send( msg)
    end
end

function CInviteTeammatesView.inviteFriendNetWorkSend( self, _uid,_inviteType) -- (手动) -- [3680]邀请好友

    print("邀请类型--好友1,社团人员2 ==", _uid,_inviteType)  
    if _uid ~= nil then
        require "common/protocol/auto/REQ_TEAM_INVITE"
        local msg = REQ_TEAM_INVITE()
        msg :setUid( _uid)
        msg :setType( _inviteType)
        CNetwork : send( msg)
    end
end



