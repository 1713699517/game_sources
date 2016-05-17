--[[
 --CSelectLevelView
 --选择关卡主界面

 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

--require "mediator/InviteTeammatesMediator"


CSelectLevelView = class(view, function( self)
                         print("CSelectLevelView:选择关卡！")
end)
--Constant:

CSelectLevelView.PER_PAGE_COUNT      = 6

CSelectLevelView.TAG_FRIENDROLE      = 201
CSelectLevelView.TAG_CURRENTROLE     = 202
CSelectLevelView.TAG_CLOSED          = 203

CSelectLevelView.TAG_TEAMINFOCELL    = 300


--加载资源
function CSelectLevelView.loadResource( self)
    if _G.Config.scene_copys == nil then
        CConfigurationManager    : sharedConfigurationManager():load("config/scene_copy.xml")
    end
end

--释放资源
function CSelectLevelView.onLoadResource( self)
    
end

--初始化数据成员
function CSelectLevelView.initParams( self, layer)
    print("CSelectLevelView.initParams")
    --mediator注册
    -- _G.g_CInviteTeammatesMediator = CInviteTeammatesMediator (self)
    -- controller :registerMediator(  _G.g_CInviteTeammatesMediator )

     
    local count = self.copyListCount
    if count > 0 then
        self : initScrollView(count)
        self : pushData(count,self.copyListData) 
    end

    self.m_touchBg = false
end

--释放成员
function CSelectLevelView.realeaseParams( self)
    
end

--布局成员
function CSelectLevelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--挂机界面")
        local teammateslistbackground  = self.m_SelectLevelViewContainer :getChildByTag( 101)
        teammateslistbackground        : setPreferredSize( CCSizeMake( 300, 390))
        teammateslistbackground        : setPosition( ccp( 480, 335))
        
    --768
    elseif winSize.height == 768 then
        CCLOG("768--挂机界面")
        
    end
end

--主界面初始化
function CSelectLevelView.init(self, winSize, layer)
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

function CSelectLevelView.scene(self)
    print("create scene")
    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self._scene       = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CSelectLevelView self.m_scenelayer 95" )
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)

    return self._scene
end

function CSelectLevelView.layer( self,_copyListData,_copyListCount)
     local function BackGroundCellCallBack(eventType, obj, x, y)
        return self : BackGroundCellCallBack(eventType,  obj, x, y)
    end 
    print("create m_scenelayer")
    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CSelectLevelView self.m_scenelayer 106" )
    --self.m_scenelayer : setFullScreenTouchEnabled(true)
    self.m_scenelayer : setTouchesPriority( -101 )
    self.m_scenelayer : setTouchesEnabled(true)
    -- self.m_scenelayer : setTouchesPriority(-500)
    --self.m_scenelayer : registerControlScriptHandler( BackGroundCellCallBack, "this CBuildTeamView self.m_allBackGroundSprite 193")

    self.copyListData  = {}
    self.copyListCount = 0
    self.copyListData  = _copyListData
    self.copyListCount = _copyListCount

    self :init(winSize, self.m_scenelayer)

    return self.m_scenelayer
end

--初始化背包界面
function CSelectLevelView.initView(self, layer,winSize)
    print("CSelectLevelView.initHangupView")
    --副本界面容器
    self.m_SelectLevelViewContainer = CContainer :create()
    self.m_SelectLevelViewContainer : setControlName( "this is CSelectLevelView self.m_SelectLevelViewContainer 116" )
    layer :addChild( self.m_SelectLevelViewContainer)
    
    local function CellCallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    -- local function BackGroundCellCallBack(eventType, obj, x, y)
    --     return self : BackGroundCellCallBack(eventType,  obj, x, y)
    -- end 

    self.teammateslistbackground         = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    self.teammateslistbackground         : setControlName( "this CSelectLevelView teammateslistbackground 126 ")
    self.teammateslistbackground         : setTouchesEnabled( true)

    self.m_SelectLevelViewContainer : addChild( self.teammateslistbackground, -1, 101)


    --TeamList界面
    self.m_teamContainer = CContainer :create()
    self.m_teamContainer : setControlName( "this is CSelectLevelView self.m_teamContainer 153" )
    self.m_SelectLevelViewContainer : addChild( self.m_teamContainer)

    local teamListContainer = CContainer :create()
    teamListContainer : setControlName( "this is CSelectLevelView teamListContainer 164" )
    teamListContainer : setTag( 105)
    self.m_teamContainer : addChild( teamListContainer)

    local viewSize            = CCSizeMake( 310, 65*6)
    local pageLayer           = CCLayer :create()
    

    self.m_pScrollView = CPageScrollView :create(2,viewSize)
    self.m_pScrollView : setTouchesPriority( -500)
    self.m_pScrollView : setTouchesEnabled(true)
    self.m_pScrollView : setPosition( ccp(330, 145))
    teamListContainer  : addChild( self.m_pScrollView)
end

function CSelectLevelView.showCheckPointView( self, _checkpoints)
    
end


function CSelectLevelView.BackGroundCellCallBack(self,eventType, obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("点到这块区域3011")
        local teammateslistbackground  = self.m_SelectLevelViewContainer : getChildByTag( 101)
        if teammateslistbackground:containsPoint( teammateslistbackground:convertToNodeSpaceAR(ccp(x,y)) ) then
            print("232")
            return false
        else
            if self.m_scenelayer ~= nil then
                self.m_scenelayer : removeFromParentAndCleanup (true)
                self.m_scenelayer = nil
            end
        end
    end

end
--更新本地list数据
function CSelectLevelView.setLocalList( self)
    print("CSelectLevelView.setLocalList")

end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CSelectLevelView.clickCellCallBack(self,eventType, obj,x,y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then

        print("Clicked CellImg!")
        print("obj: getTag()", obj: getTag())
        local temptag = math.mod( math.mod( obj :getTag(), CSelectLevelView.TAG_TEAMINFOCELL), 10)
        if obj :getTag() == CSelectLevelView.TAG_CLOSED then
            --关闭
            print("关闭")
            if self ~= nil then
                -- if _G.g_CInviteTeammatesMediator ~= nil then
                --     controller :unregisterMediator(_G.g_CInviteTeammatesMediator)
                --     _G.g_CInviteTeammatesMediator = nil
                -- end
                --self.m_scenelayer :removeFromParentAndCleanup (true)
                --controller :unregisterMediator( self.mediator)
                --CCDirector :sharedDirector() :popScene( self._scene)
                else
                print("objSelf = nil", self)
            end
        else
            if temptag == 0 then
                print( "弹出该玩家信息", obj :getTag())
            elseif temptag == 1 then
                print( "邀请该玩家为队友", obj :getTag())
            end
        end
    end
end


function CSelectLevelView.pushData(self,_Count,_CopyListData) 
    print("CSelectLevelView.pushData 刷一刷",_Count,_CopyListData)
    local Count                = _Count           --副本数量
    local CopyListData         = _CopyListData    --副本数据

    if Count > 0 then

        for i,v in pairs(CopyListData) do
            local node = _G.Config.scene_copys : selectNode( "scene_copy", "copy_id" , tostring(v.copy_id) )  --副本信息节点
            local text = node.copy_name
            self.m_teamInfoBtn[i] : setText(text)
            -- self.m_teamInfoBtn[i] : setTag( CBuildTeamView.TAG_TEAMINFOCELL + i)
            self.m_teamInfoBtn[i] : setTag( v.copy_id)
        end   
    end          
end

function CSelectLevelView.initScrollView(self,_Count) --初始化ScrollView界面
    local function CellCallBack(eventType, obj, touches)
        -- return self : clickCellCallBack(self,eventType, obj,x,y)
        return self : m_teamInfoBtnCallBack(eventType, obj, touches)
    end 

    self.m_teamInfoBtn  = {}
    local pageContiner  = {}
    self.m_lastPageCount = 0 
    self.m_pageCount     = 1
    local num            = 0
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local teaminfoCellSize = CCSizeMake( 300, 64)
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( _Count, CSelectLevelView.PER_PAGE_COUNT)
    print("滑动页面进来了", self.m_pageCount, self.m_lastPageCount)
    for i=tonumber(self.m_pageCount),1,-1  do
    --for i=1, tonumber(self.m_pageCount) do

        pageContiner[i] = CContainer : create()
        pageContiner[i] : setControlName( "this is CEquipEnchantView pageContainer[i] 74" )

        local layout = CHorizontalLayout :create()     
        pageContiner[i] : addChild( layout)
        layout       : setPosition( -155, 150)
        layout       : setVerticalDirection( false)
        layout       : setCellVerticalSpace( 0)
        layout       : setLineNodeSum( 1)
        layout       : setCellSize( teaminfoCellSize)
       
        if i == self.m_pageCount  then
            local tempnum = self.m_lastPageCount
            -- for j=tempnum,1,-1 do  
             for j=1,tempnum do           
                num = (i-1)*6+j
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."精英XJ对战佛林", "general_second_underframe.png")
                self.m_teamInfoBtn[num] : setControlName( "this CSelectLevelView self.m_teamInfoBtn[num] 383 "..tostring(i).."  "..tostring(j) )
                self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setTouchesPriority( -505)
                self.m_teamInfoBtn[num] : setTouchesEnabled(true)        
                self.m_teamInfoBtn[num] : setFontSize( 25)
                self.m_teamInfoBtn[num] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CSelectLevelView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])
            end   
        else
            local tempnum = CSelectLevelView.PER_PAGE_COUNT
            -- for j=1,tempnum do    
             for j=1,tempnum do           
                num = (i-1)*6 + j
                self.m_teamInfoBtn[num] = CButton :createWithSpriteFrameName( num.."精英XJ对战佛林", "general_second_underframe.png")
                self.m_teamInfoBtn[num] : setControlName( "this CSelectLevelView self.m_teamInfoBtn[num] 396 "..tostring(i).."  "..tostring(j) )
                self.m_teamInfoBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.m_teamInfoBtn[num] : setTouchesPriority( -505)
                self.m_teamInfoBtn[num] : setTouchesEnabled(true)     
                self.m_teamInfoBtn[num] : setFontSize( 25)
                self.m_teamInfoBtn[num] : setTag( CBuildTeamView.TAG_TEAMINFOCELL+(i-1)*6+j)
                self.m_teamInfoBtn[num] : setPreferredSize( teaminfoCellSize)
                self.m_teamInfoBtn[num] : registerControlScriptHandler( CellCallBack, "this CSelectLevelView self.m_teamInfoBtn[i][k] 241")
                layout                  : addChild( self.m_teamInfoBtn[num])
            end            
        end
    end
    --for k=1 , tonumber(self.m_pageCount) do
    for k=tonumber(self.m_pageCount),1,-1  do
        self.m_pScrollView : addPage(pageContiner[k])  
    end
    print("你看看我射了第几页",self.m_pageCount)
    if self.m_pageCount ~= nil and tonumber(self.m_pageCount) > 0 then
        self.m_pScrollView : setPage(self.m_pageCount-1, false)--设置起始页[0,1,2,3...] 
    end
end

function CSelectLevelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end


function CSelectLevelView.cleanViewData(self) --数据请除
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
function CSelectLevelView.m_teamInfoBtnCallBack(self, eventType, obj, touches)
    print("m_teamInfoBtnCallBack eventType",eventType, obj :getTag(), touches,self.touchID,"obj==",obj)
    --print("alsdkfjalsdkfj", eventType)
    if eventType == "TouchesBegan" then
        self.m_isMove  = false
        self.m_touchBg = false
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()

                if self.teammateslistbackground:containsPoint( self.teammateslistbackground:convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y)) ) then
                    print("232")
                    self.m_touchBg = true
                   
                end

                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)
                    self.transfTag = obj:getTag()

                    break
                end
            end
        end

    elseif eventType == "TouchesMoved" then
        print("come in ")
        self.m_isMove = true

    elseif eventType == "TouchesEnded" then
        -- if self.m_touchBg == false and self.m_isMove == false then
        --     print("removeddddd")
        --      if self.m_scenelayer ~= nil then
        --         self.m_scenelayer : removeFromParentAndCleanup (true)
        --         self.m_scenelayer = nil
        --     end
        -- end
        if self.touchID == nil then

           return
        end

        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 and self.transfTag == obj:getTag() then
                    print ("多点触控～～",self.transfTag)
                    if self.transfTag ~= nil and self.transfTag > 0 then
                        require "controller/BuildTeamCommand"
                        local BuildTeamCommand = CBuildTeamCommand(self.transfTag)
                        controller:sendCommand(BuildTeamCommand)
                    end
                    if self.m_scenelayer ~= nil then
                        self.m_scenelayer : removeFromParentAndCleanup (true)
                        self.m_scenelayer = nil
                    end
                    self.transfTag = nil
                    self.touchID   = nil

                end
            end
        end
    end
end

function CSelectLevelView.requestClanNetWorkSend( self) -- (手动) -- [33010]请求社团面板 -- 社团 
    require "common/protocol/auto/REQ_CLAN_ASK_MEMBER_MSG"
    local msg = REQ_CLAN_ASK_MEMBER_MSG()
    CNetwork  : send( msg)

    -- CLAN_ASK_MEMBER_MSG 33130
end


function CSelectLevelView.requestFriendNetWorkSend( self, _nType)
    _nType = tonumber( _nType)
    print("请求好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）, _nType==", _nType)
    
    if _nType ~= nil then
        require "common/protocol/auto/REQ_FRIEND_REQUES"
        local msg = REQ_FRIEND_REQUES()
        msg :setType( _nType)
        CNetwork : send( msg)
    end
end


function CSelectLevelView.removeMySelf( self )
    if  self.m_scenelayer ~= nil then
        self.m_scenelayer : removeFromParentAndCleanup(true)
        self.m_scenelayer = nil 
    end
end




