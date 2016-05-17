
require "controller/command"

require "view/view"

require "mediator/IllusionLayerMediator"

CIllusionLayer = class(view,function (self)
                          end)



function CIllusionLayer.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.IpadSize = 854
    self.scene    = CCScene :create()
    self.Scenelayer  = CContainer :create()
    self.scene    : addChild(self.Scenelayer)
    self.scene    : addChild(self : layer(winSize)) --scene的layer层    
    return self.scene
end

function CIllusionLayer.layer(self)
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()
    self : init (winSize,self.Scenelayer)   
    return self.Scenelayer
end

function CIllusionLayer.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist") --拿世界boss的框框 
end

function CIllusionLayer.layout(self, winSize)  --适配布局
    local IpadSize = 854
    if winSize.height == 640 then

        self.m_BackGround    : setPosition(IpadSize/2+30,290)    --右底图
    elseif winSize.height == 768 then
        print("768 768")
    end
end

function CIllusionLayer.init(self, _winSize, _layer)
    self : loadResources()                       --资源初始化
    self : initView(_winSize,_layer)             --界面初始化
    self : layout(_winSize)                      --适配布局初始化
    self : initParameter()                       --参数初始化
end

function CIllusionLayer.initParameter(self)
    self : registerMediator()         --mediator注册
    --self : REQ_PET_HUANHUA_REQUEST () --幻化界面
end

function CIllusionLayer.initView(self,_winSize,_layer)
    self.m_BackGround    = CSprite :createWithSpriteFrameName("general_second_underframe.png") --底图
    self.m_BackGround    : setPreferredSize(CCSizeMake(815,550)) 
    _layer               : addChild(self.m_BackGround)
end

function CIllusionLayer.initm_pScrollView(self,_allcount)
    local function BoxCallBack(eventType, obj, touches)
       return self : BoxCallBack(eventType, obj, touches)
    end
    local function BtnCallBack(eventType, obj, x , y)
       return self : BtnCallBack(eventType, obj, x , y)
    end

    self.m_pageCount, self.m_lastPageCount = self : getPageAndLastCount(_allcount,4)

    local m_ViewSize      = CCSizeMake(800,520)
    self.m_pScrollView    = CPageScrollView :create(1,m_ViewSize)
    self.m_pScrollView    : setTouchesPriority(1)
    self.m_pScrollView    : setPosition(60,30)
    self.Scenelayer       : addChild(self.m_pScrollView)

    self.IllusionLayout     = {}
    self.IllusionBtn        = {}
    self.IllusionNameLabel  = {}
    self.IllusionBox        = {}
    local pageContiner      = {}

    for i = tonumber(self.m_pageCount),1,-1 do
        pageContiner[i]    = CContainer : create()
        pageContiner[i]    : setControlName( "this is CEquipComposeLayer pageContiner 183" )
        --self.m_pScrollView : addPage(pageContiner[i])
       
        self.IllusionLayout = CHorizontalLayout : create()
        self.IllusionLayout : setControlName("CShopLayer  GoodsLayout ")
        self.IllusionLayout : setPosition(-400,40)
        self.IllusionLayout : setLineNodeSum(4)
        self.IllusionLayout : setVerticalDirection(false)
        self.IllusionLayout : setCellSize(CCSizeMake(200,500))
        pageContiner[i]     : addChild(self.IllusionLayout)

        if i == tonumber(self.m_pageCount) then
            local  tempnum = tonumber(self.m_lastPageCount)
            for j=1,tempnum do
                num = (i-1)*4 +j 

                self.IllusionBtn[num] = CButton : createWithSpriteFrameName("幻化","general_button_normal.png")
                --self.IllusionBtn[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.IllusionBtn[num] : setTag(num)
                self.IllusionBtn[num] : registerControlScriptHandler(BtnCallBack,"this CIllusionLayer self.IllusionBtn[i] callback")
                self.IllusionBtn[num] : setFontSize(24)

                self.IllusionBox[num] = CSprite : createWithSpriteFrameName("worldBoss_boss_frame.png")
                self.IllusionBox[num] : setTouchesMode( kCCTouchesAllAtOnce )
                self.IllusionBox[num] : setTouchesEnabled(true)
                self.IllusionBox[num] : setTag(num)
                self.IllusionBox[num] : registerControlScriptHandler(BoxCallBack,"this CIllusionLayer self.IllusionBtn[i] callback")

                self.IllusionNameLabel[num]  = CCLabelTTF : create("天地会陈进南","Arial",24)

                self.IllusionBtn[num]        : setPosition(0,-260)
                self.IllusionNameLabel[num]  : setPosition(0,-140)       

                self.IllusionLayout   : addChild(self.IllusionBox[num])
                self.IllusionBox[num] : addChild(self.IllusionBtn[num],-2)
                self.IllusionBox[num] : addChild(self.IllusionNameLabel[num],2)  
            end
        else
            local  tempnum = 4
            num = (i-1)*4 +j

            self.IllusionBtn[num] = CButton : createWithSpriteFrameName("幻化","general_button_normal.png")
            self.IllusionBtn[num] : registerControlScriptHandler(BtnCallBack,"this CIllusionLayer self.IllusionBtn[i] callback")
            self.IllusionBtn[num] : setFontSize(24)
            self.IllusionLayout   : addChild(self.IllusionBtn[num])

            self.IllusionBox[num]        = CSprite : createWithSpriteFrameName("worldBoss_boss_frame.png")
            self.IllusionNameLabel[num]  = CCLabelTTF : create("天地会陈进南","Arial",18)

            self.IllusionBox[num]        : setPosition(0,260)
            self.IllusionNameLabel[num]  : setPosition(0,140)       

            self.IllusionBtn[num] : addChild(self.IllusionBox[num],-2)
            self.IllusionBtn[num] : addChild(self.IllusionNameLabel[num] )            
        end
    end
    for k = tonumber(self.m_pageCount),1,-1 do
        self.m_pScrollView : addPage(pageContiner[k])  
    end
end

function CIllusionLayer.initm_pScrollViewData(self,Count,SkinId,MsgSkin)
    local defaultId = tonumber(SkinId)
    for i=1,Count do
        if self.IllusionBtn[i] ~= nil then
            local icon_url      = "HeadIconResources/worldBoss_boss_picture_0"..i..".png"
            local PeopleImage   = CSprite : create(icon_url)  
            PeopleImage         : setPosition(0,60)
            self.IllusionBox[i] : addChild(PeopleImage,-3) 
        end
        if MsgSkin[i] ~= nil and tonumber(MsgSkin[i]) > 0 then
            local skin_id = tonumber(MsgSkin[i])
            --local Node    = _G.Config.pet_skills : selectNode("pet_skill","unreal_skin",tostring(skin_id)) --宠物技能表 通过皮肤ID拿技能id
            local Node    = _G.Config.pet_skills : selectSingleNode("pet_skill[@unreal_skin="..tostring(skin_id).."]")
            if Node : isEmpty() == false then
                local name = Node : getAttribute("pet_name") 
                if self.IllusionNameLabel[i] ~= nil then
                    self.IllusionNameLabel[i] : setString(name)
                end
            end

            if defaultId~= nil and defaultId > 0 then
                if defaultId == skin_id then
                    print("使用中的id序号是===",i,defaultId)
                    self : changeBoxSprite(i)  --默认上次选中的幻化人物 框框效果
                    self : setButtonVisible(i) --默认上次选中的幻化人物 幻化效果消失
                end
            end
        end
    end
end
function CIllusionLayer.pushData(self,Count,SkinId,MsgSkin)
   local Count  = tonumber (Count)
   self.MsgSkin = MsgSkin

   if Count ~= nil and Count > 0 then
        self : initm_pScrollView( Count )                    --初始化ScrollView
        self : initm_pScrollViewData(Count,SkinId,MsgSkin)  --初始化ScrollView填充数据 
   end
end

--多点触控
function CIllusionLayer.BoxCallBack(self, eventType, obj, touches)
    print("多点触控一下",eventType,obj)
    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            if obj:getTag() > 0 then
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID = touch :getID()
                    self.transTagValue = obj:getTag()
                    print( "XXXXXXXXSs"..self.touchID,obj:getTag(),obj)
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
            print("obj: tag",obj:getTag())
            if touch2:getID() == self.touchID and self.transTagValue == obj:getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    -- print("幻化回调")
                    -- local no = self.transTagValue
                    -- if self.MsgSkin ~= nil then
                    --     local MsgSkin = self.MsgSkin
                    --     if MsgSkin[no] ~= nil and tonumber(MsgSkin[no]) > 0 then
                    --         self : REQ_PET_HUANHUA( MsgSkin[no] )
                    --     end
                    -- end
                    local no = self.transTagValue
                    self : changeBoxSprite (no)

                    self.touchID       = nil
                    self.transTagValue = nil
                end
            end
        end
    end
end

function CIllusionLayer.changeBoxSprite(self,TAG_value)
    if self.oldTAG_value ~= nil then
       self.IllusionBox[self.oldTAG_value] : setImageWithSpriteFrameName("worldBoss_boss_frame.png" )
    end
    if self.IllusionBox[TAG_value] ~= nil then
        self.IllusionBox[TAG_value] : setImageWithSpriteFrameName( "worldBoss_boss_click.png" )
        self.oldTAG_value         = TAG_value
    end
end

function CIllusionLayer.setButtonVisible(self,no)
    if self.theoldNo ~= nil then
        print("self.theoldNo",self.theoldNo)
       self.IllusionBtn[self.theoldNo] : setTouchesEnabled( true )
       --self.IllusionBtn[self.theoldNo] : setVisible( true )
       
    end
    if self.IllusionBtn[no] ~= nil then
        print("nononononono",no,self)
        self.IllusionBtn[no] : setTouchesEnabled( false )
        --self.IllusionBtn[no] : setVisible( false )
        self.theoldNo         = no
    end
end


function CIllusionLayer.BtnCallBack(self,eventType,obj,x,y)   
   if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("幻化回调")
        local no =  obj : getTag()
        if self.MsgSkin ~= nil then
            local MsgSkin = self.MsgSkin
            if MsgSkin[no] ~= nil and tonumber(MsgSkin[no]) > 0 then
                self : REQ_PET_HUANHUA( MsgSkin[no] )
                self : changeBoxSprite(no)
                self.theHUANHUAbtnNo = no --传递到幻化成功返回判断
            end
        end
    end
end

--mediator 注册
function CIllusionLayer.registerMediator(self)
    print("CKofCareerLayer.mediatorRegister 75")
    _G.g_IllusionLayerMediator = CIllusionLayerMediator (self)
    controller :registerMediator(  _G.g_IllusionLayerMediator )
end

--协议发送
function CIllusionLayer.REQ_PET_HUANHUA_REQUEST(self)   -- [23000]请求幻化界面 -- 宠物
    require "common/protocol/auto/REQ_PET_HUANHUA_REQUEST" 
    local msg = REQ_PET_HUANHUA_REQUEST()
    CNetwork  : send(msg)
    print("REQ_PET_HUANHUA_REQUEST 23000 发送完毕 ")
end

function CIllusionLayer.REQ_PET_HUANHUA(self,SkinId)   -- [23000]请求幻化界面 -- 宠物
    require "common/protocol/auto/REQ_PET_HUANHUA" 
    local msg = REQ_PET_HUANHUA()
    msg       : setId(SkinId) -- {皮肤id}
    CNetwork  : send(msg)
    print("REQ_PET_HUANHUA 23000 发送完毕 ")
end
--协议返回

function CIllusionLayer.NetWorkReturn_HUANHUA_REPLY(self,_type)   --式神召唤成功返回
    if _type == 1 then
        local msg = "式神幻化成功"
        self : createMessageBox(msg)
        
        if self.theHUANHUAbtnNo ~= nil and self.theHUANHUAbtnNo > 0  then
            local no = self.theHUANHUAbtnNo
            print("self.theHUANHUAbtnNo==",self.theHUANHUAbtnNo)
            self : setButtonVisible(no) --默认上次选中的幻化人物 幻化效果消失
        end
    else
        local msg = "式神幻化失败"
        self : createMessageBox(msg)
    end
end


function CIllusionLayer.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
         pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("5555555555555555", pageCount, lastPageCount)
    return pageCount,lastPageCount
end

function CIllusionLayer.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.Scenelayer : addChild(BoxLayer,1000)
end







