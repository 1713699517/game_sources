--[[
 --CFactionSkillPanelView
 --社团技能主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

CFactionSkillPanelView = class(view, function( self)
    print("CFactionSkillPanelView:社团技能主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_activePanelViewContainer = nil  --酒吧面板的容器层
end)
--Constant:
CFactionSkillPanelView.TAG_CLOSED       = 205  --关闭

CFactionSkillPanelView.TAG_LABEL_ITEM    = 250  --_itembackgroundSize.height/20~255

CFactionSkillPanelView.FONT_SIZE        = 23

CFactionSkillPanelView.ITEM_HEIGHT      = 800
CFactionSkillPanelView.PER_PAGE_COUNT   = 4

--加载资源
function CFactionSkillPanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist") 
end
--释放资源
function CFactionSkillPanelView.unLoadResource( self)
end
--初始化数据成员
function CFactionSkillPanelView.initParams( self, layer)
    print("CFactionSkillPanelView.initParams")
    local mainplay          = _G.g_characterProperty :getMainPlay()
    self.m_rolelv           = mainplay :getLv()        --玩家等级
    self.m_rolepartnercount = mainplay :getCount()  -- 伙伴数量
    self.m_rolerenown       = mainplay :getRenown() -- 玩家声望

    --require "mediator/WorldBossMediator"
    --self.m_mediator = CWorldBossMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionSkillPanelView.realeaseParams( self)
end

--布局成员
function CFactionSkillPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团技能主界面")
        --背景部分
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local barbackgroundupSize    = CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87)  

        self.m_roleinfoLabel :setPosition( ccp( winSize.width/2-backgroundSize.width/2+27,  winSize.height-110))
        self.m_skillListContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+27, 30))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团技能主界面")
        
    end
end

--主界面初始化
function CFactionSkillPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource( self)
    --初始化数据
    self.initParams( self,layer)
    --初始化界面
    self.initView( self, layer)
    --请求服务端消息
    self.requestService( self)
    --布局成员
    self.layout( self, winSize)  
end

function CFactionSkillPanelView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionSkillPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionSkillPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionSkillPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionSkillPanelView.requestService ( self)
    print(" -- (手动) -- [33200]请求社团技能面板 -- 社团") 
    require "common/protocol/auto/REQ_CLAN_ASK_CLAN_SKILL"
    local msg = REQ_CLAN_ASK_CLAN_SKILL()
    _G.CNetwork :send( msg)
end

--read XML 
function CFactionSkillPanelView.getActiveXmlById( self, _id)
    print( "CFactionSkillPanelView.getActiveXmlById:")
    local active_id = tostring( _id)
    _G.Config:load("config/active.xml")
    local partner_node = _G.Config.actives : selectSingleNode("active[@active_id="..active_id.."]")
    if partner_node : isEmpty() == false then
        return partner_node
    end
    return nil
end

--初始化排行榜界面
function CFactionSkillPanelView.initView(self, layer)
    print("CFactionSkillPanelView.initView")
    --副本界面容器
    self.m_activePanelViewContainer = CContainer :create()
    self.m_activePanelViewContainer : setControlName("this is CFactionSkillPanelView self.m_activePanelViewContainer 94 ")
    layer :addChild( self.m_activePanelViewContainer)    
    --创建个人贡献Label
    self.m_roleinfoLabel        = self :createLabel( "个人贡献: 99999", ccc3( 255, 255, 0))
    self.m_roleinfoLabel :setAnchorPoint( ccp( 0, 0.5))
    --创建角色相关信息Label
    self.m_skillListContainer = CContainer :create()
    self.m_activePanelViewContainer :addChild( self.m_roleinfoLabel)
    self.m_activePanelViewContainer :addChild( self.m_skillListContainer, 1)
    --self :setLocalList()         
end

function CFactionSkillPanelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)
    
    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--显示排行榜玩家
function CFactionSkillPanelView.showAllSkill( self)
    if self.m_skillListContainer ~= nil then
        self.m_skillListContainer :removeAllChildrenWithCleanup( true)
    end

    --self.m_roleinfoLabel :setString( "个人贡献:"..self.m_stamina)
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end   
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_skillcount, CFactionSkillPanelView.PER_PAGE_COUNT)
    self.m_curentPageCount = self.m_pageCount -1
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize   = CCSizeMake( winSize.height/3*4, winSize.height)
    
    local m_bgCell  = CCSizeMake( (backgroundSize.width-100)/4,winSize.height*0.87-50)
    local viewSize  = CCSizeMake( backgroundSize.width-50, winSize.height*0.87-20)

    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :setControlName("this is CFactionSkillPanelView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_skillListContainer :addChild( self.m_pScrollView )

    local skillcount       = 0
    self.m_skillList       = {}
    for k=1,self.m_pageCount do
        local pageContainer = nil
        pageContainer = CContainer :create()
        pageContainer :setControlName("this is CFactionSkillPanelView pageContainer 186 "..tostring(k))       
        
        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-m_bgCell.height/2)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellHorizontalSpace( 15)
        layout :setLineNodeSum( 4)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)        
        local tempnum = CFactionSkillPanelView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            skillcount = skillcount + 1
            local _skilltype = tostring(self.m_skilllist[skillcount].type)
            self.m_skillList[ _skilltype] = self :createSkillItem( self.m_skilllist[skillcount], m_bgCell)
            layout :addChild( self.m_skillList[_skilltype])
        end
        self.m_pScrollView :addPage( pageContainer, false)
    end
    self.m_pScrollView :setPage( 0, false)
end

function CFactionSkillPanelView.getStringByType( self, _type)
    local tmpStr = CLanguageManager:sharedLanguageManager():getString("goodss_goods_base_types_base_type_type"..tostring( _type))
    if tmpStr == nil then
        return _type
    end
    return tmpStr
end

--创建社团列表单项
function CFactionSkillPanelView.createSkillItem( self, _skillinfo , _cellsize)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CFactionSkillPanelView.createSkillItem itemContainer ")
    local _activeattr        = self :getStringByType( _skillinfo.type).." +".._skillinfo.value.."\n".."提升 +".._skillinfo.add_value       
    local _itembackground    = self :createSprite( "worldBoss_boss_frame.png", "_itembackground")
    local _itembackgroundS   = self :createSprite( "general_underframe_normal.png", "_itembackgroundS")
    local _itemskillSprite   = self :createSprite( "clan_skill_".._skillinfo.type..".png", "_itemskillSprite")
    local _itemskilllvSprite = self :createSprite( "clan_skill_frame.png", "_itemskilllvSprite")
    local _itemuseLabel      = self :createLabel( "消耗贡献: ".._skillinfo.cast, ccc3( 255, 255, 0))
    local _itemattrLabel     = self :createLabel( _activeattr)
    local _itemlvLabel       = self :createLabel( _skillinfo.skill_lv.." 级", ccc3( 255, 155, 0))

    _itemuseLabel :setTag( CFactionSkillPanelView.TAG_LABEL_ITEM)
    _itemattrLabel :setTag( CFactionSkillPanelView.TAG_LABEL_ITEM+1) 
    _itemlvLabel :setTag( CFactionSkillPanelView.TAG_LABEL_ITEM+2)

    _itembackground :setVisible( false)
    --创建相应的Button
    local function CallBack( eventType, obj, x, y)
        return self :clickIntobattleCallBack( eventType, obj, x, y)
    end
    local _itemstateButton       = self :createButton( "提升", "general_button_normal.png", CallBack, _skillinfo.type, "_itemstateButton")  
    local _itembackgroundSize    = _itembackground :getPreferredSize()
    local _itemskillSpriteSize   = _itemskillSprite :getPreferredSize()
    local _itemskilllvSpriteSize = _itemskilllvSprite :getPreferredSize()

    _itembackgroundS :setPreferredSize( CCSizeMake(_itembackgroundSize.width, _itembackgroundSize.height-90))
    _itemskilllvSprite :setPreferredSize( CCSizeMake( _itemskillSpriteSize.width, _itemskilllvSpriteSize.height))

    _itembackgroundS :setPosition( ccp( 0, 20))
    _itembackground :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-10))
    _itemskilllvSprite :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-100))
    _itemskillSprite :setPosition( ccp( 0, _cellsize.height/2-_itemskillSpriteSize.height/2-75))
    _itemstateButton :setPosition( ccp( 0, -_cellsize.height/2+10))  
    _itemuseLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+30))
    _itemattrLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+105))
    _itemlvLabel :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-100))
    
    
    itemContainer :addChild( _itembackground) 
    itemContainer :addChild( _itembackgroundS) 
    itemContainer :addChild( _itemskillSprite)  
    itemContainer :addChild( _itemskilllvSprite)
    itemContainer :addChild( _itemattrLabel)
    itemContainer :addChild( _itemuseLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemstateButton)
    return itemContainer
end

--创建按钮Button
function CFactionSkillPanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionSkillPanelView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionSkillPanelView ".._controlname)
    _itembutton :setFontSize( CFactionSkillPanelView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this CFactionSkillPanelView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建图片Sprite
function CFactionSkillPanelView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionSkillPanelView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionSkillPanelView.createLabel( self, _string, _color)
    print("CFactionSkillPanelView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionSkillPanelView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end
-----------------------------------------------------
--mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CFactionSkillPanelView.setLocalList( self, _stamina, _skillcount, _skilllist)
    print("CFactionSkillPanelView.setLocalList")
    local function sortSkill( skill1, skill2)
        if skill1.type < skill2.type then
            return true
        end
        return false
    end
    self.m_stamina    = _stamina
    self.m_skillcount = _skillcount
    self.m_skilllist  = _skilllist
    table.sort( self.m_skilllist, sortSkill)

    self.m_roleinfoLabel :setString( "个人贡献:"..self.m_stamina)
    self :showAllSkill()
end

function CFactionSkillPanelView.setLVChange( self, _skilltype, _skilllv, _skilllvalue, _skillladdvalue, _skillcast)
    print("CFactionSkillPanelView.setLVChange:")
    local _activeattr    = self :getStringByType( _skilltype).." +".._skilllvalue.."\n".."提升 +".._skillladdvalue       
    local _itemuseLabel  = self.m_skillList[ tostring(_skilltype)] :getChildByTag( CFactionSkillPanelView.TAG_LABEL_ITEM)
    local _itemattrLabel = self.m_skillList[ tostring(_skilltype)] :getChildByTag( CFactionSkillPanelView.TAG_LABEL_ITEM+1)
    local _itemlvLabel   = self.m_skillList[ tostring(_skilltype)] :getChildByTag( CFactionSkillPanelView.TAG_LABEL_ITEM+2)

    --local command = CLogsCommand( _activeattr)
    --controller :sendCommand( command )

    _itemuseLabel :setString( "消耗贡献: ".._skillcast)
    _itemattrLabel :setString( _activeattr)
    _itemlvLabel :setString( _skilllv.." 级")

end

function CFactionSkillPanelView.setStamina( self, _stamina)
    print( "FFFFFF更新帮贡:".._stamina)
    self.m_stamina = _stamina
    self.m_roleinfoLabel :setString( "个人贡献:"..self.m_stamina)
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--单击回调
function CFactionSkillPanelView.clickCellCallBack(self,eventType, obj, x, y)  
    print( "eventType",eventType)     
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then        
        local currentPage = x
        print( "eventType",eventType, "当前页：",currentPage, "过去页：",self.m_curentPageCount)
        self.m_curentPageCount = currentPage 
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionSkillPanelView.TAG_CLOSED then
            print("关闭")
        end    
    end
end

--进入战斗
function CFactionSkillPanelView.clickIntobattleCallBack(self,eventType, obj, x, y)  
    print( "eventType",eventType)     
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("提升技能: "..obj: getTag()) 
        require "common/protocol/auto/REQ_CLAN_STUDY_SKILL"
        local msg  = REQ_CLAN_STUDY_SKILL()
        msg :setType( obj: getTag()) 
        CNetwork :send( msg)
    end
end

