--[[
 --CVindictiveRoleEquipView
 --斗气面板主界面
 --]]
require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/VindictiveMediator"
require "view/VindictivePanelLayer/VindictivePopupView"

require "view/ErrorBox/ErrorBox"

CVindictiveRoleEquipView = class(view, function( self)
    print("CVindictiveRoleEquipView:斗气面板主界面")
    self.m_arrangeVindictiveButton   = nil   -- 整理
    self.m_oneKeySwallowButton       = nil   -- 一键吞噬
    self.m_closedButton              = nil   -- 关闭

    self.m_tagLayout                 = nil   --4种Tag按钮的水平布局
    self.m_vindictivePanelContainer  = nil   -- 斗气面板的容器层
    self.m_opencount                 = 0
    self.m_partnerid                 = 0     --主角属性
    self.m_vindictivecount           = 0
    self.m_vindictivelist            = {}
    --self.m_roleequip                 = {}
    self.m_clickVindictive           = nil   --存放当前选中斗气
    self.m_vindictiveContainer       = {}
    self.m_vindictiveButton          = {}
    self.m_detectIndex               = -1
    self.m_detectFlag                = false
end)
--Constant:
CVindictiveRoleEquipView.TAG_ARRANGEVINDICTIVE  = 201   -- 整理
CVindictiveRoleEquipView.TAG_ONEKEYSWALLOW      = 202   -- 一键吞噬
CVindictiveRoleEquipView.TAG_CLOSED             = 203   -- 关闭
CVindictiveRoleEquipView.TAG_FARME_ICON         = 204

CVindictiveRoleEquipView.PER_PAGE_COUNT         = 20

--字体大小
CVindictiveRoleEquipView.FONT_SIZE        = 21

--加载资源
function CVindictiveRoleEquipView.loadResource( self)

end
--释放资源
function CVindictiveRoleEquipView.unLoadResource( self)
end
--初始化数据成员
function CVindictiveRoleEquipView.initParams( self, layer)
    print("CVindictiveRoleEquipView.initParams")
    self.m_mediator  = CVindictiveRoleEquipMediator( self)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错

    self :REQ_SYS_DOUQI_ASK_USR_GRASP()

    self.m_uid       = _G.g_LoginInfoProxy :getUid()
    self.m_partnerid = 0
    self :getPro()
    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
end
--释放成员
function CVindictiveRoleEquipView.realeaseParams( self)
    if self.m_vindictivePanelContainer ~= nil then
        self.m_vindictivePanelContainer :removeAllChildrenWithCleanup( true)
    end
end

--布局成员
function CVindictiveRoleEquipView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--斗气面板主界面5")
        --背景
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst                  = self.m_vindictivePanelContainer :getChildByTag( 99)
        local vindictivebackgroundfirst        = self.m_vindictivePanelContainer :getChildByTag( 101)
        local vindictivebackgroundleftup       = self.m_vindictivePanelContainer :getChildByTag( 102)
        local vindictivebackgroundrightup      = self.m_vindictivePanelContainer :getChildByTag( 103)
        local vindictivebackgroundleftdown     = self.m_vindictivePanelContainer :getChildByTag( 104)
        local closeButtonSize                  = self.m_closedButton: getPreferredSize()
        local buttonSize                       = self.m_oneKeySwallowButton :getPreferredSize()
        local equipupSize                      = CCSizeMake( backgroundSize.width*0.48, backgroundSize.height*0.655)
        local equipdownSize                    = CCSizeMake( backgroundSize.width*0.48, backgroundSize.height*0.21)
        local backpackSize                     = CCSizeMake( backgroundSize.width*0.48, backgroundSize.height*0.75)

        vindictivebackgroundfirst :setPreferredSize( backgroundSize)
        vindictivebackgroundleftup :setPreferredSize( equipupSize)
        vindictivebackgroundrightup :setPreferredSize( backpackSize)
        vindictivebackgroundleftdown :setPreferredSize( equipdownSize)
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        vindictivebackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        vindictivebackgroundleftup :setPosition( ccp( winSize.width/2-backgroundSize.width/2+equipupSize.width/2+15, equipdownSize.height+equipupSize.height/2+20))
        vindictivebackgroundleftdown :setPosition( ccp( winSize.width/2-backgroundSize.width/2+equipdownSize.width/2+15, equipdownSize.height/2+15))
        vindictivebackgroundrightup :setPosition( ccp( winSize.width/2+backgroundSize.width/2-backpackSize.width/2-15, backgroundSize.height-closeButtonSize.height-backpackSize.height/2))
        --按钮Button
        self.m_arrangeVindictiveButton :setPosition( ccp( winSize.width/2+backpackSize.width*(0.5-0.2), buttonSize.height/2+25))
        self.m_oneKeySwallowButton :setPosition( ccp( winSize.width/2+backpackSize.width*(0.5+0.2), buttonSize.height/2+25))
        self.m_closedButton: setPosition( ccp(winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))

        self.m_vindictiveBackpackContainer :setPosition( ccp( winSize.width*0.5+10, backgroundSize.height-closeButtonSize.height-50))
        self.m_vindictiveRoleIconContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+25, equipdownSize.height/2+15))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--斗气面板主界面")
    end
end

--布局成员
function CVindictiveRoleEquipView.roleEquipLayout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--斗气面板主界面5")
        local backgroundSize   = CCSizeMake( winSize.height/3*4, winSize.height)
        local equipupSize      = CCSizeMake( backgroundSize.width*0.48, backgroundSize.height*0.66)
        local equipdownSize    = CCSizeMake( backgroundSize.width*0.48, backgroundSize.height*0.2)
        local rolePoint = ccp( winSize.width/2-backgroundSize.width/2+equipupSize.width/2+15, equipdownSize.height+equipupSize.height/2+20)
        local tempr     = equipupSize.width/2-45
        local tempa     = 23
        local templist  = {90+tempa,180-tempa,180+tempa,270-tempa,270+tempa,0-tempa,0+tempa,90-tempa}
        for i=1,8 do
            print("斗气位置:",i)
            local x = rolePoint.x+tempr*math.cos(templist[i]/180*3.14)*(-1)
            local y = rolePoint.y+tempr*math.sin(templist[i]/180*3.14)
            self.m_vindictiveButton[ i] :setPosition( ccp( x, y))
        end
        self.m_roleimage :setPosition( ccp(rolePoint.x, rolePoint.y-100))
        self.m_roleLvLabel :setPosition( ccp(rolePoint.x-150, rolePoint.y+180))
        --self.m_roleequip[i]
    --768
    elseif winSize.height == 768 then
        CCLOG("768--斗气面板主界面")
    end
end

--主界面初始化
function CVindictiveRoleEquipView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer, winSize)
    --成员布局移到initView中调用

end

function CVindictiveRoleEquipView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CVindictiveRoleEquipView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CVindictiveRoleEquipView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CVindictiveRoleEquipView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化背包界面
function CVindictiveRoleEquipView.initView(self, layer, winSize)
    print("CVindictiveRoleEquipView.initView")
    --副本界面容器
    self.m_vindictivePanelContainer = CContainer :create()
    self.m_vindictivePanelContainer : setControlName("this is CVindictiveRoleEquipView self.m_vindictivePanelContainer 94 ")
    layer :addChild( self.m_vindictivePanelContainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCallBack( eventType, obj, x, y)
    end
    --添加背景， 二级背景
    local backgroundfirst               = self :addSprite( self.m_vindictivePanelContainer, "peneral_background.jpg", 99, "backgroundfirst")
    local vindictivebackgroundfirst     = self :addSprite( self.m_vindictivePanelContainer, "general_first_underframe.png", 101, "vindictivebackgroundfirst")
    local vindictivebackgroundleftup    = self :addSprite( self.m_vindictivePanelContainer, "general_second_underframe.png", 102, "vindictivebackgroundleftup")
    local vindictivebackgroundrightup   = self :addSprite( self.m_vindictivePanelContainer, "general_second_underframe.png", 103, "vindictivebackgroundrightup")
    local vindictivebackgroundleftdown  = self :addSprite( self.m_vindictivePanelContainer, "general_second_underframe.png", 104, "vindictivebackgroundleftdown")
    --添加单击Button
    self.m_oneKeySwallowButton          = self :addButton( self.m_vindictivePanelContainer, "一键吞噬", "general_button_normal.png", CallBack, CVindictiveRoleEquipView.TAG_ONEKEYSWALLOW, "self.m_oneKeySavvyButton")
    self.m_arrangeVindictiveButton      = self :addButton( self.m_vindictivePanelContainer, "整理", "general_button_normal.png", CallBack, CVindictiveRoleEquipView.TAG_ARRANGEVINDICTIVE, "self.m_arrangeVindictiveButton")
    self.m_closedButton                 = self :addButton( self.m_vindictivePanelContainer, "", "general_close_normal.png", CallBack, CVindictiveRoleEquipView.TAG_CLOSED, "self.m_closedButton")


    --默认属性界面
    --add:
    --背包部分
    self.m_vindictiveBackpackContainer = CContainer :create()
    self.m_vindictiveBackpackContainer :setControlName("this is CVindictiveRoleEquipView self.m_vindictiveBackpackContainer ")
    layer :addChild( self.m_vindictiveBackpackContainer)
    --self :createBackpackVindictiveView( self.m_vindictiveBackpackContainer)

    --角色装备部分
    self.m_vindictiveEquipContainer = CContainer :create()
    self.m_vindictiveEquipContainer :setControlName("this is CVindictiveRoleEquipView self.m_vindictiveEquipContainer ")
    layer :addChild( self.m_vindictiveEquipContainer)
    --self :createRoleEquipView( self.m_vindictiveEquipContainer)

    --角色头像部分
    self.m_vindictiveRoleIconContainer = CContainer :create()
    self.m_vindictiveRoleIconContainer :setControlName( "this is CVindictiveRoleEquipView self.m_vindictiveRoleIconContainer")
    layer :addChild( self.m_vindictiveRoleIconContainer)

    --布局成员
    self :layout( winSize)
end

--创建人物皮肤
function CVindictiveRoleEquipView.addCharaterView( self, _container)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end
    local pro = nil
    if self.m_partnerid ~= nil and  tonumber(self.m_partnerid) == 0 then
        pro = "1000"..self.m_pro
    else
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(self.m_partnerid).."]")
        if  node : isEmpty() == false then
            pro = node : getAttribute("skin")
        else
            pro = tostring("10404")
        end
    end
    print("HPRO:"..self.m_pro)
    local rolelv   = CCLabelTTF :create( "LV: "..self.m_rolelv, "Arial", CVindictiveRoleEquipView.FONT_SIZE)
    local roleCCBI = CMovieClip:create( "CharacterMovieClip/"..(pro).."_normal.ccbi" )
    roleCCBI :setControlName( "this CVindictiveRoleEquipView roleCCBI 84")
    roleCCBI :registerControlScriptHandler( animationCallFunc, "this is CVindictiveRoleEquipView roleCCBI CallBack"..self.m_pro)
    _container :addChild( rolelv)
    _container :addChild( roleCCBI)
    return roleCCBI, rolelv
end

--根据位置获取相应斗气，没有为nil
function CVindictiveRoleEquipView.getVindictiveByLanid( self, _lanid)
    for k,v in pairs( self.m_roleequiplist) do
        if v.lan_id == _lanid then
            print("人物身上的斗气:",_lanid)
            self.m_popTipsType = _G.Constant.CONST_DOUQI_STORAGE_TYPE_ROLE
            return v
        end
    end
    for k,v in pairs( self.m_vindictivelist) do
        if v.lan_id == _lanid then
            print("背包里斗气:",_lanid)
            self.m_popTipsType = _G.Constant.CONST_DOUQI_STORAGE_TYPE_EQUIP
            return v
        end
    end
    print("没有找到斗气:",_lanid)
    return nil
end

--创建人物角色身上装备
function CVindictiveRoleEquipView.addRoleIcon( self)
    print("CVindictiveRoleEquipView.addRoleIcon")
    if self.m_vindictiveRoleIconContainer ~= nil then
        self.m_vindictiveRoleIconContainer :removeAllChildrenWithCleanup( true)
    end
    --角色头像部分
    self.m_tagLayout     = CHorizontalLayout :create()
    self.m_tagLayout :setVerticalDirection(false)
    self.m_tagLayout :setCellHorizontalSpace( -2)
    self.m_tagLayout :setLineNodeSum( 4)
    self.m_rolecontainer = {}
    for i=1,4 do
        local _partnerid = nil
        if i == 1 then
            _partnerid = 0
        else
            _partnerid = nil
            if self.m_roledata[i] ~= nil then
                _partnerid =  self.m_roledata[i-1].role_id
            end
        end
        print("XDC:",_partnerid,#self.m_roledata)
        self.m_rolecontainer[i]     = self :createRoleButton( _partnerid)
        self.m_tagLayout :addChild( self.m_rolecontainer[i])
    end
    self.m_vindictiveRoleIconContainer :addChild( self.m_tagLayout)
    --self :roleEquipLayout( winSize)
end

function CVindictiveRoleEquipView.createRoleButton( self, _roleid)
    print("CGoodsInfoView.createRoleButton")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickRoleCallBack( eventType, obj, x, y)
    end
    local rolecontainer = CContainer :create()
    rolecontainer : setControlName("this is CVindictiveRoleEquipView rolecontainer 158 ")
    --角色头像背景
    local background    = CSprite :createWithSpriteFrameName( "general_role_head_underframe.png")
    background : setControlName( "this CVindictiveRoleEquipView background 160 ")
    rolecontainer :addChild( background)
    --角色头像
    local backgroundsize = background :getPreferredSize()
    if _roleid ~= nil then
        local imgname            = self :getHeadIconById( _roleid)
        print("imgnamea:",imgname)
        local roleIconButton = self :createButton( "", imgname, CallBack,_roleid, "roleIconButton ".._roleid, true)
        rolecontainer :addChild( roleIconButton)
    end
    --角色头像外框
    local roleframe = nil
    if self.m_partnerid == _roleid then --选中
        roleframe    = CSprite :createWithSpriteFrameName( "general_role_head_frame_click.png")
    else
        roleframe    = CSprite :createWithSpriteFrameName( "general_role_head_frame_normal.png")
    end
    roleframe : setControlName( "this CVindictiveRoleEquipView roleframe 160 ")
    rolecontainer :addChild( roleframe)
    return rolecontainer
end

function CVindictiveRoleEquipView.getHeadIconById( self, _partnerid)
    local roleProperty = nil
    local temp         = nil
    if _partnerid ~= nil and tonumber(_partnerid) == 0 then
        --玩家自己
        roleProperty = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
        temp = "HeadIconResources/role_head_0"..tostring( roleProperty :getPro())..".jpg"
    else
        --伙伴 索引为uid..id
        --local index = tostring( _G.g_LoginInfoProxy :getUid())..tostring( _partnerid)
        --roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        _G.Config :load("config/partner_init.xml") 
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring(_partnerid).."]")
        if node : isEmpty() == false and tonumber(node :getAttribute("head"))~=10001 then
            temp = node :getAttribute("head")
        else
            temp = tostring("10404")
        end
        temp = "HeadIconResources/role_head_"..temp..".jpg"
    end
    return temp
end

--创建按钮Button
function CVindictiveRoleEquipView.createButton( self, _string, _image, _func, _tag, _controlname, _flag)
    print( "CVindictiveRoleEquipView.createButton buttonname:".._string.._controlname)
    local _itembutton = nil
    if _flag == true then
        _itembutton = CButton :create( _string, _image)
    else
        _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    end
    _itembutton :setControlName( "this CVindictiveRoleEquipView ".._controlname)
    _itembutton :setFontSize( CVindictiveRoleEquipView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CVindictiveRoleEquipView ".._controlname.."CallBack")
    return _itembutton
end

--创建人物角色身上装备
function CVindictiveRoleEquipView.addRoleGoods( self, goodscontainer)
    print("CVindictiveRoleEquipView.addRoleGoods")
    --角色皮肤部分
    self.m_roleimage, self.m_roleLvLabel = self :addCharaterView( goodscontainer) --self :createRoleImage( 1)
    --goodscontainer :addChild( self.m_roleimage)
    local count = 1
    for i=_G.Constant.CONST_DOUQI_LAN_START, _G.Constant.CONST_DOUQI_LAN_END do
        local goodItem, goodButton = nil, nil
        if count <= self.m_opencount then
            --self.m_roleequip[i] = self :createGoodItem( i, true)
            goodItem, goodButton  = self :createGoodItem( i, true)
        else
            --self.m_roleequip[i] = self :createGoodItem( i, true, true)
            goodItem, goodButton  = self :createGoodItem( i, true, true)
        end
        self.m_vindictiveContainer[ i] = goodItem
        self.m_vindictiveButton[ i] = goodButton
        print( (count).."/"..( self.m_opencount))
        count = count + 1
        goodscontainer :addChild( goodButton)
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self :roleEquipLayout( winSize)
    self.m_clickVindictive = nil
end

--创建所有物品
function CVindictiveRoleEquipView.addAllGoods(self, goodscontainer)
    print("CVindictiveRoleEquipView.addAllGoods")
    --local m_bgCell  = CCSizeMake(99,98)

    local layout = CHorizontalLayout :create()
    goodscontainer :addChild( layout)
    layout :setVerticalDirection(false)
    layout :setCellHorizontalSpace( -1)
    layout :setCellVerticalSpace(-5)
    layout :setLineNodeSum( 4)
    --layout :setCellSize(m_bgCell)

    for i =_G.Constant.CONST_DOUQI_BAG_START , _G.Constant.CONST_DOUQI_BAG_END do
        --local goodItem       = self :createGoodItem( i)
        --layout :addChild( goodItem,1)
        local goodItem, goodButton  = self :createGoodItem( i)
        self.m_vindictiveContainer[ i] = goodItem
        self.m_vindictiveButton[ i] = goodButton
        layout :addChild( goodButton,1)
    end
    self.m_clickVindictive = nil
end

--_lanid  栏 ID
--_islock 人物身上是否开启
--_type   人物身上的背景
function CVindictiveRoleEquipView.createGoodItem( self, _lanid, _type, _islock)
    --print( "斗气LanId: ".._lanid.." _islock: "..( _islock or " 未锁"))
    local function touchesCallback(eventType, obj, touches)
        return self :viewTouchesCallback( eventType, obj, touches)
    end
    local _itemlock     = CSprite :createWithSpriteFrameName( "general_the_props_close.png")
    _itemlock :setControlName( "this is CVindictiveRoleEquipView createGoodItem _itemlock".._lanid)
    local vindictinve   = self :getVindictiveByLanid( _lanid)
    local _itemButton = CButton :createWithSpriteFrameName("","star_underframe.png")
    _itemButton :setControlName( "this CVindictiveRoleEquipView _itemButton 271 ")
    local _itembackground = nil
    if _type == true then
        _itembackground = self :addSprite( _itemButton, "star_texture01.png", 0," _itembackground".._lanid)

    else
        _itembackground = self :addSprite( _itemButton, "star_texture02.png", 0," _itembackground".._lanid)
    end
    _itembackground :setZOrder( 1)
    local _itemframesprite = self :addSprite( _itemButton, "star_underfram_click.png", CVindictiveRoleEquipView.TAG_FARME_ICON , " _itemframesprite".._lanid)
    _itemframesprite :setVisible( false)
    _itemframesprite :setZOrder(2)
    local _itemlocklv   = nil
    if _islock == true then
        _itemlock :setVisible( true)
        _G.Config :load("config/fight_gas_open.xml")
        local _node  = _G.Config.fight_gas_opens : selectSingleNode("fight_gas_open[@seal_id="..tostring( _lanid).."]")
        local temp = _node : getAttribute("open_lv")
        if _node : isEmpty() == true then
            temp = "xml error !"
        end
        _itemlocklv = CCLabelTTF :create( temp.."级", "Arial", CVindictiveRoleEquipView.FONT_SIZE)
    else
        _itemlock :setVisible( false)
        _itemButton :setTouchesMode( kCCTouchesAllAtOnce )
        _itemButton :setTouchesEnabled( true)
        _itemButton :setTag( _lanid)
        _itemButton :registerControlScriptHandler( touchesCallback, "this CVindictiveRoleEquipView _itemButton CallBack 290")
    end
    --goodContainer :addChild( _itemButton)
    _itemButton :addChild( _itemlock,1)
    if _islock == true then
        _itemButton :addChild( _itemlocklv,1)
    end
    --斗气部分
    local goodContainer = CContainer :create()
    _itemButton :addChild( goodContainer, 3)
    if vindictinve ~= nil then
        local _itemGoodCCBI   = self :addCCBI( goodContainer, "FightGas/fightgas_"..vindictinve.dq_type..".ccbi", 0, "_itemGoodCCBI")
        local _itemnamesprite = self :addSprite( goodContainer, "star_name_underframe.png",0," _itemnamesprite".._lanid)
        _itemnamesprite :setZOrder( 0)
        _itemnamesprite :setPreferredSize( CCSizeMake( 90, 25))
        _itemnamesprite :setPosition( ccp( 0, -35))
        --数量标签
        local index  = vindictinve.dq_type..vindictinve.dq_lv
        local dqinfo = self :getVindictiveXML( index)
        local _itemprice = CCLabelTTF :create( tostring( dqinfo :getAttribute("gas_name") ),"Arial",15)
        local rgb  = self :getColorByIndex( dqinfo :getAttribute("color") )
        _itemprice :setColor( rgb)
        _itemprice :setFontSize( CVindictiveRoleEquipView.FONT_SIZE)
        --_itemprice :setPosition( ccp( 0, -35))
        _itemnamesprite :addChild( _itemprice)
    end
    return goodContainer, _itemButton
end
--创建按钮Button
function CVindictiveRoleEquipView.addButton( self, _container, _string, _image, _func, _tag, _controlname)
    if _string == nil then
        _string = " "
    end
    print( "CVindictiveRoleEquipView.addButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CVindictiveRoleEquipView ".._controlname)
    _itembutton :setFontSize( CVindictiveRoleEquipView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CVindictiveRoleEquipView ".._controlname.."CallBack")
    _container :addChild( _itembutton)
    return _itembutton
end

--创建图片Sprite
function CVindictiveRoleEquipView.addSprite( self, _container, _image, _tag, _controlname)
    print("CVindictiveRoleEquipView.addSprite".._controlname)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this CVindictiveRoleEquipView ".._controlname)
    _itemsprite :setTag( _tag)
    _container :addChild( _itemsprite)
    return _itemsprite
end

--创建图片Sprite
function CVindictiveRoleEquipView.addCCBI( self, _container, _ccbi, _tag, _controlname)
    print("CVindictiveRoleEquipView.addSprite".._controlname)
    local _itemccbi = CMovieClip:create( _ccbi)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "AnimationComplete" then
            --self:onAnimationCompleted( eventType, arg0 )
        elseif eventType == "Enter" then
            _itemccbi : play("run")
        end
    end
    
    _itemccbi :setControlName( "this CVindictiveRoleEquipView ".._controlname)
    _itemccbi :registerControlScriptHandler( animationCallFunc)
    _itemccbi :setTag( _tag)
    _container :addChild( _itemccbi)
    return _itemccbi
end


--创建Label
function CVindictiveRoleEquipView.addLabel( self, _container, _string)
    print("CVindictiveRoleEquipView.addLabel")
    local _itemlabel =  CCLabelTTF :create( _string, "Arial", CVindictiveRoleEquipView.FONT_SIZE)
    _itemlabel :setAnchorPoint( ccp( 0, 0.5))
    _container :addChild( _itemlabel,1)
    return _itemlabel
end

function CVindictiveRoleEquipView.getVindictiveXML( self, _index)
    local _node  = _G.Config.fight_gas_totals : selectSingleNode("fight_gas_total[@gas_id2="..tostring( _index).."]")
    print("%%%%%:",_node : getAttribute("gas_name") , _node : getAttribute("gas_id2") , _node : getAttribute("color") )
    if _node : isEmpty() == false then
        return _node
    end
    return nil
end

function CVindictiveRoleEquipView.getColorByIndex( self, _color)
    print( "COLOR: ",_color)
    local temp, rgb4 = nil, nil
    _color = tonumber( _color)
    if _color ~= nil then
        rgb4   = _G.g_ColorManager :getRGBA( _color)
        temp    = _G.g_ColorManager :getRGB( _color)
    else
        temp = ccc3( 255,255,255)         --颜色-白  -->
        rgb4 = ccc4( 255,255,255,255)
    end
    return temp, rgb4
end



function CVindictiveRoleEquipView.removeVindictiveByLanid( self, _list, _count, _lanid)
    if _lanid == nil then
        print(" 该位置没有斗气")
        return _count
    end
    print("=======Remove S ",_lanid)
    for k,v in pairs(_list) do
        if _lanid == v.lan_id then
            print("remove:",_lanid)
            table.remove( _list, k)
            _count = _count - 1
            break
        end
    end
    print("=======Remove E ",_lanid)
    return _count
end



-----------------------------------------------------
--mediator更新本地数据
-----------------------------------------------------
--更新本地list数据
function CVindictiveRoleEquipView.setLocalList( self)
    print("CVindictiveRoleEquipView.setLocalList")

end

function CVindictiveRoleEquipView.setPartnerInfomation( self, _opencount, _rolecount, _roledata)
    print(" FFFFFF setPartnerInfomation ".._opencount)
    self.m_opencount   = tonumber(_opencount)   --已打开斗气栏个数
    self.m_rolecount   = _rolecount   --角色数量
    self.m_roledata    = _roledata    --角色ID  主角为0
    for i=1,self.m_rolecount do
        print("FFFFFF RoleId:",self.m_roledata[i].role_id,"Count:",self.m_roledata[i].count,"Msg:",self.m_roledata[i].douqi_msg)
        if tonumber(self.m_roledata[i].role_id) == 0 then
            self.m_roleequipcount = self.m_roledata[i].count
            self.m_roleequiplist  = self.m_roledata[i].douqi_msg
        end
    end

    self :addRoleIcon()

    if self.m_vindictiveEquipContainer ~= nil then
        self.m_vindictiveEquipContainer :removeAllChildrenWithCleanup( true)
        self :addRoleGoods( self.m_vindictiveEquipContainer)
    end
end

--仓库斗气监听
function CVindictiveRoleEquipView.setVindictiveBackpackChange( self, _count, _dqlist)
    print("仓库斗气监听 FFFFFF setVindictiveBackpackChange ".._count)
    self.m_vindictivecount  = _count
    self.m_vindictivelist   = _dqlist
    print("##########:"..self.m_vindictivecount..#self.m_vindictivelist)

    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :addAllGoods( self.m_vindictiveBackpackContainer)--createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    --self.m_clickVindictive = nil
    if self.m_nodeccbi ~= nil then
        self.m_scenelayer:removeChild( self.m_nodeccbi )
        self.m_nodeccbi = nil
    end
end

--分解成功
function CVindictiveRoleEquipView.setDecomposeVindictiveOK( self, _lanid, _adamwar)
    local updataflag = 0
    for i,t in pairs( self.m_vindictivelist) do
        print(i,t.lan_id)
        if _lanid == t.lan_id then
            print("remove背包斗气:",t.lan_id)
            table.remove( self.m_vindictivelist, i)
            self.m_vindictivecount = self.m_vindictivecount - 1
            updataflag = 1
            break
        end
    end
    for i,t in pairs( self.m_roleequiplist) do
        print(i,t.lan_id)
        if _lanid == t.lan_id then
            print("remove角色斗气:",t.lan_id)
            table.remove( self.m_roleequiplist, i)
            self.m_roleequipcount = self.m_roleequipcount - 1
            updataflag = 2
            break
        end
    end
    if self.m_vindictiveBackpackContainer ~= nil and updataflag == 1 then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :addAllGoods( self.m_vindictiveBackpackContainer)--createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    if self.m_vindictiveEquipContainer ~= nil and updataflag == 2 then
        self.m_vindictiveEquipContainer :removeAllChildrenWithCleanup( true)
        self :addRoleGoods( self.m_vindictiveEquipContainer)
    end
    --更新斗魂数量

end

--移动斗气成功
function CVindictiveRoleEquipView.setMoveVindictiveOK( self, _startid, _endid, _count, _newdata)
print("移动斗气成功 #")
    self.m_vindictivecount = self :removeVindictiveByLanid( self.m_vindictivelist, self.m_vindictivecount, _startid)
    self.m_vindictivecount = self :removeVindictiveByLanid( self.m_vindictivelist, self.m_vindictivecount, _endid)
    self.m_roleequipcount  = self :removeVindictiveByLanid( self.m_roleequiplist, self.m_roleequipcount, _startid)
    self.m_roleequipcount  = self :removeVindictiveByLanid( self.m_roleequiplist, self.m_roleequipcount, _endid)
    if _endid >= _G.Constant.CONST_DOUQI_LAN_START and _endid <= _G.Constant.CONST_DOUQI_LAN_END then
        print("insert角色斗气:",_endid)
        table.insert( self.m_roleequiplist, _newdata[1])
        self.m_roleequipcount = self.m_roleequipcount + 1
    else
        print("insert背包斗气:",_endid)
        table.insert( self.m_vindictivelist, _newdata[1])
        self.m_vindictivecount = self.m_vindictivecount + 1
    end
    if self.m_vindictiveBackpackContainer ~= nil then
        self.m_vindictiveBackpackContainer :removeAllChildrenWithCleanup( true)
        self :addAllGoods( self.m_vindictiveBackpackContainer)--createBackpackVindictiveView( self.m_vindictiveBackpackContainer)
    end
    if self.m_vindictiveEquipContainer ~= nil then
        self.m_vindictiveEquipContainer :removeAllChildrenWithCleanup( true)
        self :addRoleGoods( self.m_vindictiveEquipContainer)
    end
    if self.m_vindictiveButton[ _endid]  ~= nil then
        self.m_clickVindictive = self.m_vindictiveButton[ _endid] 
        self.m_clickVindictive : getChildByTag(  CVindictiveRoleEquipView.TAG_FARME_ICON) : setVisible( true)
    end
    if self.m_nodeccbi ~= nil then
        self.m_scenelayer:removeChild( self.m_nodeccbi )
        self.m_nodeccbi = nil
    end

end

function CVindictiveRoleEquipView.getFormatString( self, _dq1, _dq2)
    local dqinfobegin,dqinfoend   = nil, nil
    local dqbegin, dqend  = nil, nil
    local index1  = _dq1.dq_type.._dq1.dq_lv
    local dqinfo1 = self :getVindictiveXML( index1)
    local index2  = _dq2.dq_type.._dq2.dq_lv
    local dqinfo2 = self :getVindictiveXML( index2)
    if tonumber(dqinfo1 :getAttribute("color")) > tonumber(dqinfo2 : getAttribute("color")) then
        dqinfobegin = dqinfo2
        dqinfoend   = dqinfo1
        dqbegin     = _dq2
        dqend       = _dq1
    elseif tonumber(dqinfo1 :getAttribute("color")) < tonumber(dqinfo2 : getAttribute("color")) then
        dqinfobegin = dqinfo1
        dqinfoend   = dqinfo2
        dqbegin     = _dq1
        dqend       = _dq2
    else
        if tonumber(_dq1.dq_exp) > tonumber(_dq2.dq_exp) then
            dqinfobegin = dqinfo2
            dqinfoend   = dqinfo1
            dqbegin     = _dq2
            dqend       = _dq1
        else
            dqinfobegin = dqinfo1
            dqinfoend   = dqinfo2
            dqbegin     = _dq1
            dqend       = _dq2
        end
    end
    local _xc = nil
    local temp = {}
    temp[1] = {}
    temp[1].string = tostring( dqinfobegin : getAttribute("gas_name") ).."lv"..dqbegin.dq_lv
    _xc,temp[1].color  = self :getColorByIndex( tonumber(dqinfobegin : getAttribute("color") ))
    temp[2] = {}
    temp[2].string = "即将被 "
    temp[3] = {}
    temp[3].string = tostring( dqinfoend :getAttribute("gas_name") ).."lv"..dqend.dq_lv
    _xc,temp[3].color  = self :getColorByIndex( tonumber(dqinfoend :getAttribute("color") ))
    temp[4] = {}
    temp[4].string = " 吞噬!  是否需要吞噬？"
    self.m_dqnew = dqend
    --temp = tostring( dqinfobegin : getAttribute("gas_name") ).." 即将被 "..tostring( dqinfoend :getAttribute("gas_name") ).." 吞噬! \n是否需要吞噬？"
    return temp
end
-- _dq 新斗气
-- _end_lan_id 终点位置ID
-- _end_is_empty 终点有斗气是否，移动 true 或者 吞噬 false、nil
function CVindictiveRoleEquipView.isEquipThisDQ( self, _dq, _end_lan_id, _start_lan_id)
    print("查看是否装备了同种斗气：",_dq.lan_id)
    local index  = _dq.dq_type.._dq.dq_lv
    local dqinfo = self :getVindictiveXML( index)
    local dqtype = dqinfo :getAttribute("type")
    for i,t in pairs( self.m_roleequiplist) do
        local temp = self :getVindictiveXML( t.dq_type..t.dq_lv)
        print(i,">>>>>>>>>",t.lan_id,"Type:", dqtype, temp : getAttribute("type"))
        if tonumber(temp : getAttribute("type")) == tonumber(dqtype)  then
            if _start_lan_id ~= nil and _start_lan_id >= _G.Constant.CONST_DOUQI_LAN_START and _start_lan_id <= _G.Constant.CONST_DOUQI_LAN_END then --移动到角色身上
                print("移动的是人物身上的斗气到身上其他空白位置")
                return false
            end
            if t.lan_id == _end_lan_id then
                print("吞噬后在同一位置")
                return false
            else
                print("吞噬后在人物身上，不在同一位置")
                return true
            end
        end
    end
    return false    
end

function CVindictiveRoleEquipView.getDQPosByLanid( self, _lanid)
    if self.m_vindictiveButton[ _lanid] ~= nil and _lanid ~= nil then
        local tempSize = CCSizeMake( self.m_winSize.height/3*4, self.m_winSize.height)
        local _positionXX,_positionYY = self.m_vindictiveButton[ _lanid] : getPosition()
        local _position2 = nil
        if _lanid >= _G.Constant.CONST_DOUQI_LAN_START and _lanid <= _G.Constant.CONST_DOUQI_LAN_END then
            print("角色斗气:",_lanid)
            _position2 = self.m_scenelayer : convertToNodeSpaceAR( ccp(_positionXX+0, _positionYY+0))
        else
            print("背包斗气:",_lanid)
            _position2 = self.m_scenelayer : convertToNodeSpaceAR( ccp(_positionXX+self.m_winSize.width/2+15, _positionYY+525))
        end        
        return _position2
    end
    return ccp(0,0)
end



function CVindictiveRoleEquipView.getIsFullLv( self, _dq)
    local index  = _dq.dq_type.._dq.dq_lv
    local dqinfo = self :getVindictiveXML( index)
    if tonumber(_dq.dq_lv) == 10 and tonumber(_dq.dq_exp) == tonumber(dqinfo : getAttribute("next_lv_exp")) then
        return true
    end
    return false
end

function CVindictiveRoleEquipView.getDqColor( self, _dq)
    local index  = _dq.dq_type.._dq.dq_lv
    local dqinfo = self :getVindictiveXML( index)
    return tonumber(dqinfo :getAttribute("color"))
end

function CVindictiveRoleEquipView.getIsSwallow( self, _dq1, _dq2)
    if self :getIsFullLv( _dq1) or self :getIsFullLv( _dq2) then
        if  self :getIsFullLv( _dq1) == true then
            if self :getIsFullLv( _dq2) == false and (self :getDqColor( _dq1) < self :getDqColor( _dq2)) then
                return true
            end
            return false
        end
        if self :getIsFullLv( _dq2) == true then
            if self :getIsFullLv( _dq1) == false and (self :getDqColor( _dq2) < self :getDqColor( _dq1)) then
                return true
            end
            return false
        end
    else
        return true
    end    
end

-----------------------------------------------------
--回调函数
-----------------------------------------------------
--
function CVindictiveRoleEquipView.viewTouchesCallback(self, eventType, obj, touches)
    --print("CVindictiveRoleEquipView.viewTouchesCallback eventType",eventType, obj :getTag(), touches,obj.touchID)
    --print("eventType:", eventType, self.m_detectIndex, CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount)
    if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    print("XXXXXXXX",self.touchID,obj :getTag())
                    _G.pDateTime :reset()
                    self.touchID     = touch :getID()
                    self.touchLanId  = obj :getTag()
                    self.touchTime   = _G.pDateTime:getTotalMilliseconds()
                    self.m_startposition = self : getDQPosByLanid(obj:getTag())
                    local vindictinenode = self :getVindictiveByLanid( obj :getTag())
                    if  vindictinenode ~= nil then
                        print("产生移动斗气:",obj :getTag())
                        if self.m_clickVindictive ~= nil then
                            self.m_clickVindictive : getChildByTag(  CVindictiveRoleEquipView.TAG_FARME_ICON) : setVisible( false)
                        end
                        self.m_clickVindictive = self.m_vindictiveButton[ obj :getTag()] 
                        self.m_clickVindictive : getChildByTag(  CVindictiveRoleEquipView.TAG_FARME_ICON) : setVisible( true)
                        local dq_container = self.m_vindictiveButton[ obj:getTag() ]
                        local dq = self.m_vindictiveContainer[ obj:getTag() ]
                        dq:retain()
                        dq:removeFromParentAndCleanup(false)
                        --dq_container:removeChild( dq , false )
                        self.m_scenelayer:addChild( dq )
                        dq:release()
                        dq:setPosition( self : getDQPosByLanid(obj:getTag()) )
                        self.m_nodeccbi = dq
                        self.m_detectIndex = -1
                    end
                    break
                end
        end
    elseif eventType == "TouchesMoved" then
        if self.touchID == nil then
            return
        end
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at(i - 1)
            if touch:getID() == self.touchID and self.touchLanId == obj :getTag() then
                local touchPoint = touch :getLocation()
                --add:原斗气图标扣出，移动斗气图标位于鼠标中心，
                if self.m_nodeccbi ~= nil then
                    self.m_nodeccbi :setPosition( touchPoint)
                end
                print("yidong, "..obj :getTag().."X："..touchPoint.x.."Y："..touchPoint.y)
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
            return
        end
        self.m_detectIndex = self.m_detectIndex + 1
        self.m_detectFlag  = true
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if touch:getID() == self.touchID and self.touchLanId ~= obj :getTag() then
                    if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                        print("END obj:",obj :getTag())
                        print( "当前角色:",self.m_partnerid)
                        local vindictinenode  = self :getVindictiveByLanid( self.touchLanId)
                        local endvindictine   = self :getVindictiveByLanid( obj :getTag())
                        if vindictinenode ~= nil then
                            local function fun1()--确认吞噬
                                self :playSound( "inventory_items")
                                self :REQ_SYS_DOUQI_ASK_USE_DOUQI( self.m_partnerid, vindictinenode.dq_id,self.touchLanId, obj :getTag())
                                if self.m_nodeccbi ~= nil then
                                    self.m_nodeccbi : removeFromParentAndCleanup(true)
                                    self.m_nodeccbi = nil
                                    self.touchID    = nil
                                    self.touchLanId = nil
                                    self.touchTime  = nil
                                end
                            end
                            local function fun2()--取消吞噬
                                --锁住屏幕
                                CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                                local function movedCallBack()
                                    local dq_container = self.m_vindictiveButton[ self.touchLanId ]
                                    self.m_nodeccbi:retain()
                                    self.m_scenelayer:removeChild( self.m_nodeccbi , false )
                                    --self.m_nodeccbi : removeFromParentAndCleanup(true)
                                    dq_container : addChild( self.m_nodeccbi,3)
                                    self.m_nodeccbi : setPosition( ccp(0,0))
                                    self.m_nodeccbi:release()
                                    print("eeeeeee:", self.touchLanId, self.m_startposition.x, self.m_startposition.y)
                                    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                                    if isdis == false then
                                        print("XXXXXXXXXXX")
                                        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                                    end
                                    self.m_nodeccbi = nil
                                    self.touchID    = nil
                                    self.touchLanId = nil
                                    self.touchTime  = nil
                                end
                                local arr2 = CCArray:create()
                                arr2:addObject(CCMoveTo:create( 0.5, self.m_startposition))
                                arr2:addObject(CCCallFunc:create(movedCallBack))
                                self.m_nodeccbi :runAction( CCSequence:create(arr2) )
                            end
                            local function fun3()--取消
                            end
                            local function movefunc()  --成功移动
                                self :playSound( "inventory_items")
                                self :REQ_SYS_DOUQI_ASK_USE_DOUQI( self.m_partnerid, vindictinenode.dq_id,self.touchLanId, obj :getTag())
                                self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                if self.m_nodeccbi ~= nil then
                                    self.m_scenelayer:removeChild( self.m_nodeccbi )
                                    self.m_nodeccbi = nil
                                end
                            end
                            if endvindictine ~= nil then --吞噬 
                                if obj :getTag() >= _G.Constant.CONST_DOUQI_LAN_START and obj :getTag() <= _G.Constant.CONST_DOUQI_LAN_END then --移动到角色身上
                                    self :getFormatString( vindictinenode, endvindictine) -- 不能注释掉，该函数对 吞噬后的斗气种类 self.m_dqnew 进行赋值
                                    if self : isEquipThisDQ( self.m_dqnew, obj :getTag()) then --t吞噬后有相同
                                        --已装备相同斗气
                                        local ErrorBox = CErrorBox()
                                        local BoxLayer = ErrorBox : create( "已经装备了相同类型的斗气！",fun2,nil) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                        local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                        nowScene : addChild(BoxLayer,1000)
                                        self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                        return false
                                    end
                                end
                                if self : getIsSwallow( vindictinenode, endvindictine) == true then
                                    local ErrorBox = CErrorBox()
                                    local BoxLayer = ErrorBox : create( nil,fun1,fun2,true) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                    for k,v in pairs( self :getFormatString( vindictinenode, endvindictine)) do
                                        print(k,v.string,v.color)
                                        ErrorBox :addString( v.string, v.color)
                                    end
                                    local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                    nowScene : addChild(BoxLayer,1000)
                                    self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                else
                                    local ErrorBox = CErrorBox()
                                    local BoxLayer = ErrorBox : create( "斗气已达最高等级，不能吞噬其他斗气！",fun2,nil) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                    local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                    nowScene : addChild(BoxLayer,1000)
                                    self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                end
                            else --移动
                                if obj :getTag() >= _G.Constant.CONST_DOUQI_LAN_START and obj :getTag() <= _G.Constant.CONST_DOUQI_LAN_END then --移动到角色身上
                                    if self :getDqColor( vindictinenode) == 1 then --白色
                                        --白色不能装备
                                        local ErrorBox = CErrorBox()
                                        local BoxLayer = ErrorBox : create( "无法装备白色斗气！",fun2,nil) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                        local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                        nowScene : addChild(BoxLayer,1000)
                                        self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                    else
                                        if self : isEquipThisDQ( vindictinenode, obj :getTag(), vindictinenode.lan_id) then  --有相同
                                            --已装备相同斗气
                                            local ErrorBox = CErrorBox()
                                            local BoxLayer = ErrorBox : create( "已经装备了相同类型的斗气！",fun2,nil) -- (string,fun1,fun2)--[[self :getFormatString( vindictinenode, endvindictine)]]
                                            local nowScene = CCDirector : sharedDirector() : getRunningScene()
                                            nowScene : addChild(BoxLayer,1000)
                                            self.m_detectIndex = CVindictivePanelView.PER_PAGE_COUNT + self.m_opencount
                                        else
                                            movefunc()
                                        end
                                    end
                                else  --移动到背包中
                                    movefunc()
                                end
                            end
                        end
                        break
                    end
                end
        end
        for i=1, touchesCount do
            local touch = touches :at(i - 1)
            if touch:getID() == self.touchID and self.touchLanId == obj :getTag() then
                local touchPoint = touch :getLocation()
                if ccpDistance( touchPoint, touch :getStartLocation()) < 10 then
                    print("dianji"..obj :getTag())
                    local vindictinenode = self :getVindictiveByLanid( obj :getTag())
                    --add:弹出斗气Tips
                    if  vindictinenode ~= nil then
                        print("===================================")
                        if self.m_nodeccbi ~= nil then
                            self.m_detectFlag = false
                            local lan_id = self.touchLanId
                            --锁住屏幕
                            CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                            local function movedCallBack()
                                --self.m_nodeccbi:
                                local dq_container = self.m_vindictiveButton[ lan_id ]
                                self.m_nodeccbi:retain()
                                self.m_nodeccbi : removeFromParentAndCleanup(false)
                                dq_container:addChild(self.m_nodeccbi,3)
                                self.m_nodeccbi : setPosition( ccp(0,0))
                                self.m_nodeccbi:release()
                                self.m_nodeccbi = nil
                                print("eeeeeee", lan_id)
                                local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                                if isdis == false then
                                    CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                                end
                            end
                            local arr = CCArray:create()
                            arr:addObject(CCMoveTo:create( 0, self.m_startposition))
                            arr:addObject(CCCallFunc:create(movedCallBack))
                            self.m_nodeccbi :runAction( CCSequence:create(arr) )
                        end

                        local _position = {}
                        _position.x = touchPoint.x
                        _position.y = touchPoint.y
                        local  temp =   _G.g_VindictivePopupView :create( vindictinenode, self.m_popTipsType, _position, self.m_partnerid)
                        self.m_scenelayer :addChild( temp)
                    end
                    --self.m_scenelayer :addChild( temp)
                    self.touchID    = nil
                    self.touchLanId = nil
                    self.touchTime  = nil
                end
            end
        end
        if self.m_detectIndex == CVindictiveRoleEquipView.PER_PAGE_COUNT + self.m_opencount - 1 and self.m_detectFlag == true then
            print("nonononononononononononononononono",self.m_detectIndex,self.m_detectFlag)
            if self.m_nodeccbi ~= nil then
                --锁住屏幕
                CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
                local function movedCallBack()
                    --self.m_nodeccbi:
                    local dq_container = self.m_vindictiveButton[ self.touchLanId ]
                    self.m_nodeccbi:retain()
                    self.m_nodeccbi : removeFromParentAndCleanup(false)
                    dq_container:addChild(self.m_nodeccbi,3)
                    self.m_nodeccbi : setPosition( ccp(0,0))
                    self.m_nodeccbi:release()
                    self.m_nodeccbi = nil
                    print("eeeeeee", self.touchLanId)
                    local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                    if isdis == false then
                        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                    end
                    self.m_nodeccbi = nil
                    self.touchID    = nil
                    self.touchLanId = nil
                    self.touchTime  = nil
                end
                local arr = CCArray:create()
                arr:addObject(CCMoveTo:create( 0.5, self.m_startposition))
                arr:addObject(CCCallFunc:create(movedCallBack))

                self.m_nodeccbi :runAction( CCSequence:create(arr) )
                -- if self.m_nodeccbi ~= nil then
                --     self.m_nodeccbi :removeAllChildrenWithCleanup( true)
                --     self.m_nodeccbi = nil
                -- end
            end
        end
    end
end

--BUTTON类型切换buttonCallBack
--单击回调
function CVindictiveRoleEquipView.clickCallBack(self,eventType, obj, x, y)
    --删除Tips
    _G.g_VindictivePopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CVindictiveRoleEquipView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                controller :unregisterMediator( self.m_mediator)
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CVindictiveRoleEquipView.TAG_ARRANGEVINDICTIVE then
            print(" 整理背包")
            if self.m_vindictivecount > 0 then
                self :REQ_SYS_DOUQI_ASK_CLEAR_STORAG()
            end
        elseif obj :getTag() == CVindictiveRoleEquipView.TAG_ONEKEYSWALLOW then
            print(" 一键吞噬")
            self :REQ_SYS_DOUQI_ASK_EAT( 1)
        end
    end
end


function CVindictiveRoleEquipView.getPro(self)
    self.m_roleProperty = nil
    if self.m_partnerid == 0 then
        --玩家自己
        self.m_roleProperty = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    else
        --伙伴 索引为uid..id
        local index = tostring( self.m_uid)..tostring( self.m_partnerid)
        self.m_roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if self.m_roleProperty == nil then
            print( "没有对应伙伴")
            return
        end
        self.m_stata  = self.m_roleProperty :getStata()
    end
    self.m_powerful   = self.m_roleProperty :getPowerful()
    self.m_pro        = self.m_roleProperty :getPro()       --玩家职业
    self.m_rolelv      = self.m_roleProperty :getLv()       --玩家职业
    _G.Config :load("config/fight_gas_open.xml")
    for i=1,8 do
        print(i)
        local _node  = _G.Config.fight_gas_opens : selectSingleNode("fight_gas_open[@seal_id="..tostring( i).."]")
        local openlv = _node : getAttribute("open_lv")
        if self.m_rolelv >= tonumber(openlv) then
            self.m_opencount = i
        end
    end
end

function CVindictiveRoleEquipView.createClickRoleIcon( self)
    local function func_create()
        self :getPro()
        print( "当前角色:",self.m_partnerid)
        for i=1,self.m_rolecount do
            print("第",i,"个角色 :",self.m_roledata[i].role_id)
            if self.m_roledata[i].role_id == self.m_partnerid then
                self.m_roleequipcount = self.m_roledata[i].count
                self.m_roleequiplist  = self.m_roledata[i].douqi_msg
                print("斗气数量:",self.m_roleequipcount)
                for k,v in pairs( self.m_roleequiplist) do
                    print(k,"人物身上的斗气:",v.lan_id)
                end
                break
            end
        end
        if self.m_vindictiveEquipContainer ~= nil then
            self.m_vindictiveEquipContainer :removeAllChildrenWithCleanup( true)
            self :addRoleGoods( self.m_vindictiveEquipContainer)
        end
        self :addRoleIcon()
    end 
    local actarr = CCArray :create()
    local dela = CCDelayTime :create( 0.05 )
    local temp = CCCallFunc : create( func_create )
    actarr :addObject( dela)
    actarr :addObject( temp)
    local seq = CCSequence:create(actarr)
    self.m_scenelayer:runAction(seq)
end

--BUTTON类型切换buttonCallBack
--单击回调
function CVindictiveRoleEquipView.clickRoleCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        --删除Tips
        _G.g_VindictivePopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if self.m_partnerid ~= obj :getTag() then
            self.m_partnerid = obj :getTag()
            self :createClickRoleIcon()
        end
    end
end

-----------------------------------------------------
--请求服务器
-----------------------------------------------------
--请求一键吞噬
function CVindictiveRoleEquipView.REQ_SYS_DOUQI_ASK_EAT( self, _type)
    print("-- (手动) -- [48280]请求一键吞噬 -- 斗气系统")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_EAT"
    local msg = REQ_SYS_DOUQI_ASK_EAT()
    msg :setType( _type) -- {仓库类型  0领悟仓库| 1装备仓库}
    _G.CNetwork :send( msg)
end

--请求装备斗气界面
function CVindictiveRoleEquipView.REQ_SYS_DOUQI_ASK_CLEAR_STORAG( self)
    print("-- (手动) -- [48400]请求整理仓库 [48201] Type=1 -- 斗气系统 ")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_CLEAR_STORAG"
    local msg = REQ_SYS_DOUQI_ASK_CLEAR_STORAG()
    _G.CNetwork :send( msg)
end

--请求装备斗气界面
function CVindictiveRoleEquipView.REQ_SYS_DOUQI_ASK_USR_GRASP( self)
    print("-- (手动) -- [48250]请求装备斗气界面 -- 斗气系统")
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_USR_GRASP"
    local msg = REQ_SYS_DOUQI_ASK_USR_GRASP()
    _G.CNetwork :send( msg)
end

--请求移动斗气位置
function CVindictiveRoleEquipView.REQ_SYS_DOUQI_ASK_USE_DOUQI( self, _roleid, _dqid, _startid, _endid)
    print("-- (手动) -- [48280]请求移动斗气位置 -- 斗气系统 ")
    print("当前角色:".._roleid.."移动的斗气ID:".._dqid.."开始位置:".._startid.."结束位置:".._endid)
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_USE_DOUQI"
    local msg = REQ_SYS_DOUQI_ASK_USE_DOUQI()
    msg :setRoleId( _roleid)
    msg :setDqId( _dqid)
    msg :setLanidStart( _startid)
    msg :setLanidEnd( _endid)
    _G.CNetwork :send( msg)
end



function CVindictiveRoleEquipView.playSound( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end



 










