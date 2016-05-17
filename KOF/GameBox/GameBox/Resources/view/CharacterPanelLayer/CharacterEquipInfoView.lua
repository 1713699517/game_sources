--[[
 --CCharacterEquipInfoView
 --角色信息主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
--require "view/FightGas/FightGasView"

require "controller/CharacterUpadteCommand"
require "controller/GuideCommand"

CCharacterEquipInfoView = class(view, function( self, _type, _tipstype)
print("CCharacterEquipInfoView:角色信息主界面,_type=".._type)
    self.m_characterInfoViewContainer  = nil  --人物面板的容器层
    self.m_characterequiplist = {}
    self.m_tagLayout          = nil
    self.m_showType           = _type
    self.m_tipsType           = _tipstype

    self.CreateEffectsList = {} --存放创建ccbi的数据
end)
--Constant:
CCharacterEquipInfoView.TAG_EQUIP      = 500 --装备tag

CCharacterEquipInfoView.FONT_SIZE      = 25  --字体大小

CCharacterEquipInfoView.TYPE_NORMAL    = _G.Constant.CONST_GOODS_EQUIP
CCharacterEquipInfoView.TYPE_ARTIFACT  = _G.Constant.CONST_GOODS_MAGIC


--加载资源
function CCharacterEquipInfoView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")

end
--释放资源
function CCharacterEquipInfoView.unLoadResource( self)
end
--初始化数据成员
function CCharacterEquipInfoView.initParams( self)
    print("CCharacterEquipInfoView.initParams")
    if self.m_uid == nil then
        self.m_uid        = _G.g_LoginInfoProxy:getUid()
    end
    _G.Config:load("config/partner_init.xml")
    self.m_partnerId = 0
    print("DDDDDDD:",  self.m_partnerId, self.m_uid)
    if tostring(self.m_partnerId) == "0" then
        print("DDDDDDD1:")
        self.m_roleProperty = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
        self.m_mainProperty = self.m_roleProperty
    else
        print("DDDDDDD2:")
        local index = tostring( self.m_uid)..tostring( self.m_partnerId)
        print("index:",index)
        self.m_roleProperty = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    end
    ----[[
    self.m_pro               = self.m_roleProperty :getPro()       --玩家职业
    self.m_partnerconut      = self.m_roleProperty :getCount()     --伙伴数量
    self.m_partneridlist     = self.m_roleProperty :getPartner()   --伙伴ID列表
    self.m_stata             = self.m_roleProperty :getStata()     --伙伴状态
    self.m_curentPageCount   = self.m_partnerconut
    self.m_pageCount         = self.m_partnerconut+1

    self.m_partnerId = self.m_selectPartnerId

    self: getPartnerParams(self.m_partnerId)

    print("XXXXXXXXX@@@:",self.m_partnerconut, #self.m_partneridlist )
    for k,v in pairs(self.m_partneridlist) do
        print(k,v)
    end
    --]]
end
-- 获取伙伴相关属性
function CCharacterEquipInfoView.getPartnerParams( self, _partnerid)
    self.m_roleProperty = nil
    if _partnerid == 0 then
        --玩家自己
        self.m_partnerId = 0
        self.m_roleProperty = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    else
        --伙伴 索引为uid..id
        local index = tostring( self.m_uid)..tostring( _partnerid)
        self.m_roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if self.m_roleProperty == nil then
            print( "没有对应伙伴")
            return
        end
        self.m_stata  = self.m_roleProperty :getStata()
    end
    self.m_pro        = self.m_roleProperty :getPro()       --玩家职业

    if self.m_showType == CCharacterEquipInfoView.TYPE_ARTIFACT then
        self.m_equipcount = self.m_roleProperty :getArtifactEquipCount() or 0
        self.m_equiplist  = self.m_roleProperty :getArtifactEquipList()
    else
        self.m_equipcount = self.m_roleProperty :getEquipCount() or 0
        self.m_equiplist  = self.m_roleProperty :getEquipList()
    end
    if self.m_equiplist == nil then
        self.m_equiplist = {}
    end
    print("XXXXXXXXX@@@11:",self.m_equipcount, #self.m_equiplist )

end
--释放成员
function CCharacterEquipInfoView.realeaseParams( self)
end

--布局成员
function CCharacterEquipInfoView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面3")
        --人物装备信息
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local equipupSize                      = CCSizeMake( backgroundSize.width*0.48, winSize.height*0.66)
        local equipdownSize                    = CCSizeMake( backgroundSize.width*0.48, winSize.height*0.2)

        self.m_equipbackgroundup  :setPreferredSize( equipupSize)
        self.m_equipbackgrounddown :setPreferredSize( equipdownSize)

        self.m_roleImage :setPosition( ccp( winSize.width/2, winSize.height*0.4))

        if self.m_showType == CCharacterEquipInfoView.TYPE_ARTIFACT then --神器和普通装备位置不同
            self.m_characterequiplist[16] :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20+equipupSize.height*0.31))
            self.m_characterequiplist[11] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20+equipupSize.height*0.31))
            self.m_characterequiplist[12] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20))
            self.m_characterequiplist[14] :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20))
            self.m_characterequiplist[15] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20-equipupSize.height*0.31))
            self.m_characterequiplist[13]  :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20-equipupSize.height*0.31))
        else
            self.m_characterequiplist[16] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20+equipupSize.height*0.31))
            self.m_characterequiplist[11] :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20+equipupSize.height*0.31))
            self.m_characterequiplist[12] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20))
            self.m_characterequiplist[14] :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20))
            self.m_characterequiplist[15] :setPosition( ccp( winSize.width/2-equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20-equipupSize.height*0.31))
            self.m_characterequiplist[13]  :setPosition( ccp( winSize.width/2+equipupSize.width*0.32, equipdownSize.height+equipupSize.height/2+20-equipupSize.height*0.31))
        end

        self.m_tagLayout :setPosition( winSize.width/2-equipdownSize.width/2+8, equipdownSize.height/2+15)
        self.m_equipbackgroundup  :setPosition( ccp( winSize.width/2, equipdownSize.height+equipupSize.height/2+20)) -- -195 -32
        self.m_equipbackgrounddown :setPosition( ccp( winSize.width/2, equipdownSize.height/2+15))
        --self.m_characterInfoViewContainer :setPosition( ccp( -winSize.width*0.2-5, -30))
        self.m_characterInfoViewContainer :setPosition( ccp( -backgroundSize.width/2+equipupSize.width/2+15, 0))
        --768
        elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

--主界面初始化
function CCharacterEquipInfoView.init(self, winSize, layer)
    print("viewID:",self._viewID)

    require "mediator/CharacterMediator"
    self.mediator = CCharacterEquipInfoMediator(self)
    controller :registerMediator(self.mediator)--先注册后发送 否则会报错
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CCharacterEquipInfoView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterEquipInfoView self.m_scenelayer 112 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CCharacterEquipInfoView.layer( self, _uid, _partnerid)
    print("create m_scenelayer")
    self.m_uid       = _uid
    self.m_selectPartnerId = _partnerid
    print("DDDDDDD112121:",  self.m_partnerId, self.m_uid)
    -----------------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local function viewTouchesCallback(eventType, obj, touches)
        print("CCharacterEquipInfoView viewTouchesCallback eventType",eventType)
        if eventType == "TouchesBegan" then
            --删除Tips
            _G.g_PopupView :reset()
            if obj :isVisibility() == false then
                return
            end
            print("viewTouchesCallback101010101010101")
        end
    end
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterEquipInfoView self.m_scenelayer 141 ")
    self.m_scenelayer :setTouchesMode( kCCTouchesAllAtOnce )
    self.m_scenelayer :setTouchesEnabled( true)
    self.m_scenelayer :registerControlScriptHandler( viewTouchesCallback, "this CCharacterEquipInfoView self.m_scenelayer 144")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CCharacterEquipInfoView.createEquipButton( self, _good)
        print("CGoodsInfoView.createEquipButton")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickEquipCallBack( eventType, obj, x, y)
    end
    local goodcontainer      = CContainer :create()
    goodcontainer : setControlName("this is CCharacterEquipInfoView goodcontainer 158 ")
    local background     = CSprite :createWithSpriteFrameName( "general_props_underframe.png")
    background : setControlName( "this CCharacterEquipInfoView background 160 ")
    goodcontainer :addChild( background)

    local backgroundsize = background :getPreferredSize()
    if _good ~= nil then
        local goodbutton = nil
        local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        print("createEquipButton -- _good",_good.goods_id)
        if goodnode  == nil then
            goodbutton = CButton: createWithSpriteFrameName("","iconsprite.png")
            goodbutton : setControlName( "this CCharacterEquipInfoView goodbutton 168 " )
        else
            goodbutton = CButton: create(" ","Icon/i"..goodnode :getAttribute("icon")..".jpg")
            goodbutton : setControlName( "this CCharacterEquipInfoView goodbutton 171 " )
            --goodbutton :setScale( 1.3)
            --goodbutton.good = _good
            goodbutton :setTag( _good.goods_id)
            goodbutton :registerControlScriptHandler( CallBack, "this CCharacterEquipInfoView goodbutton 176")
            goodcontainer :addChild( goodbutton)

            if _G.g_CharacterPanelView ~= nil then
                _G.g_CharacterPanelView:insertCreateResStr( "Icon/i"..goodnode :getAttribute("icon")..".jpg" )
            end
            if _G.g_CCharacterCheckPanelView ~= nil then
                _G.g_CCharacterCheckPanelView:insertCreateResStr( "Icon/i"..goodnode :getAttribute("icon")..".jpg" )
            end
        end
    else
        print("createEquipButton  -- _good == nil")
        -- if self.m_showType == CCharacterEquipInfoView.TYPE_ARTIFACT then
        --     local lockBg = CSprite :createWithSpriteFrameName( "general_the_props_close.png")
        --     -- lockBg :setScale( 1.3)
        --     goodcontainer :addChild( lockBg )
        -- end
    end
    local backgroundframe    = CSprite :createWithSpriteFrameName( "general_props_frame_normal.png")
    backgroundframe : setControlName( "this CCharacterEquipInfoView backgroundframe 162 ")
    goodcontainer :addChild( backgroundframe)

    --特效特效·
    if _good ~= nil then
        local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
        local theType  = tonumber(goodnode : getAttribute("type") )
        if theType == 1 or theType == 2 then
            self : Create_effects_equip(backgroundframe,goodnode : getAttribute("name_color") ,_good.goods_id,_good.index)
        end
    end

    return goodcontainer
end

function CCharacterEquipInfoView.createRoleButton( self, _roleid)
    print("CGoodsInfoView.createRoleButton")
    --加载装备图片，背景图，边框
    local function CallBack( eventType, obj, x, y)
        return self :clickRoleCallBack( eventType, obj, x, y)
    end
    local rolecontainer = CContainer :create()
    rolecontainer : setControlName("this is CCharacterEquipInfoView rolecontainer 158 ")
    --角色头像背景
    local background    = CSprite :createWithSpriteFrameName( "general_role_head_underframe.png")
    background : setControlName( "this CCharacterEquipInfoView background 160 ")
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
    if self.m_partnerId == _roleid then --选中
        roleframe    = CSprite :createWithSpriteFrameName( "general_role_head_frame_click.png")
    else
        roleframe    = CSprite :createWithSpriteFrameName( "general_role_head_frame_normal.png")
    end
    roleframe : setControlName( "this CCharacterEquipInfoView roleframe 160 ")
    rolecontainer :addChild( roleframe)
    return rolecontainer
end

function CCharacterEquipInfoView.getHeadIconById( self, _partnerid)
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
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring( _partnerid).."]")
        if node : isEmpty() == false and tonumber(node : getAttribute("head"))~=10001 then
            temp = node : getAttribute("head")
        else
            temp = 10404
        end
        temp = "HeadIconResources/role_head_"..temp..".jpg"
    end
    return temp
end

function CCharacterEquipInfoView.getNormalEquipBySubType( self, _subtype)
    _subtype = tostring( _subtype)
    print( "_subtype ------ ", _subtype,self.m_equipcount)
    if self.m_equipcount ~= nil and self.m_equipcount > 0 then
        if _subtype == "0" then
            print("jjjjjjjjjjjjjjjjjjjjjjj")
            for k,v in pairs( self.m_equiplist) do
                print(k,v.goods_type)
                local goodnode = _G.g_GameDataProxy :getGoodById( v.goods_id)
                local type_sub = goodnode : getAttribute("type_sub")
                print( "type_sub",type_sub)
                if type_sub ~= "11" and type_sub ~= "12" and type_sub ~= "13" and type_sub ~= "14" and type_sub ~= "15" and self.m_showType == CCharacterEquipInfoView.TYPE_NORMAL then
                    print( "type_sub",type_sub)
                    return v
                elseif type_sub ~= "51" and type_sub ~= "52" and type_sub ~= "53" and type_sub ~= "54" and type_sub ~= "55" and self.m_showType == CCharacterEquipInfoView.TYPE_ARTIFACT then
                    print( "type_sub",type_sub)
                    return v
                end
                if k == self.m_equipcount then
                    return nil
                end
            end
        else
            print("KKKKKKKKKKKKKKKKKKKKKKK")
            for k,v in pairs( self.m_equiplist) do
                --print(k,v)
                local goodnode = _G.g_GameDataProxy :getGoodById( v.goods_id)
                if goodnode : getAttribute("type_sub") == _subtype then
                    return v
                end
                if k == self.m_equipcount then
                    return nil
                end
            end
        end
    end
end

function CCharacterEquipInfoView.getEquipById( self, _id)
    if self.m_equipcount > 0 then
        for k,v in pairs( self.m_equiplist) do
            if v.goods_id == _id then
                return v
            end
        end
        print("没有找到装备，错误！")
        return false
    end
end

--创建按钮Button
function CCharacterEquipInfoView.createButton( self, _string, _image, _func, _tag, _controlname, _flag)
    print( "CCharacterEquipInfoView.createButton buttonname:".._string.._controlname)
    local _itembutton = nil
    if _flag == true then
        _itembutton = CButton :create( _string, _image)

        if _G.g_CharacterPanelView ~= nil then
            _G.g_CharacterPanelView:insertCreateResStr( _image )
        end
        if _G.g_CCharacterCheckPanelView ~= nil then
            _G.g_CCharacterCheckPanelView:insertCreateResStr( _image )
        end
    else
        _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    end
    _itembutton :setControlName( "this CCharacterEquipInfoView ".._controlname)
    _itembutton :setFontSize( CCharacterEquipInfoView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CCharacterEquipInfoView ".._controlname.."CallBack")
    return _itembutton
end

--创建人物皮肤
function CCharacterEquipInfoView.addCharaterView( self, _container)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end
    local pro = nil
    if self.m_partnerId ~= nil and  tonumber(self.m_partnerId) == 0 then
        pro = "1000"..self.m_pro
    else
        local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
        local node = partner_inits_temp : selectSingleNode("partner_init[@id="..tostring( self.m_partnerId).."]")
        if  node : isEmpty() == false then
            pro = node : getAttribute("skin")
        else
            pro = tostring(10404)
        end
    end
    print("HPRO:"..self.m_pro)
    local roleCCBI = CMovieClip:create( "CharacterMovieClip/"..(pro).."_normal.ccbi" )
    roleCCBI :setControlName( "this CCharacterEquipInfoView roleCCBI 84")
    roleCCBI :registerControlScriptHandler( animationCallFunc, "this is CCharacterEquipInfoView roleCCBI CallBack"..self.m_pro)
    _container :addChild( roleCCBI)
    return roleCCBI
end


--添加相应装备Button
function CCharacterEquipInfoView.addEquipView( self, _container)
    --装备图标
    --装备图标布局
    print("self.m_showType == "..self.m_showType)
    self.m_characterequiplist = {}
    local goodsType = 11
    if self.m_showType == CCharacterEquipInfoView.TYPE_ARTIFACT then
        goodsType = 51
    end
    for i=11, 16 do
        if i == 16 then
            goodsType = 0
        end
        self.m_characterequiplist[i] = self :createEquipButton( self :getNormalEquipBySubType( goodsType ))
        _container :addChild( self.m_characterequiplist[i])
        goodsType = goodsType + 1
    end
end

--初始化界面
function CCharacterEquipInfoView.initView(self, layer)
    print("CCharacterEquipInfoView.initView")
    --角色信息主界面
    self.m_characterInfoViewContainer = CContainer :create()
    self.m_characterInfoViewContainer : setControlName("this is CCharacterEquipInfoView self.m_characterInfoViewContainer 301 ")
    layer :addChild( self.m_characterInfoViewContainer)
    --背景图片
    self.m_equipbackgroundup    = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    self.m_equipbackgrounddown = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    self.m_equipbackgroundup  : setControlName( "this CCharacterEquipInfoView self.m_equipbackgroundup  359 ")
    self.m_equipbackgrounddown :setControlName( "this CCharacterEquipInfoView self.m_equipbackgrounddown 360")
    self.m_characterInfoViewContainer :addChild( self.m_equipbackgroundup  , -1)
    self.m_characterInfoViewContainer :addChild( self.m_equipbackgrounddown, -1)

    --装备部分
    self.m_equipContainer = CContainer :create()
    self.m_equipContainer : setControlName("this is CCharacterEquipInfoView self.m_equipContainer 301 ")
    self.m_characterInfoViewContainer :addChild( self.m_equipContainer)
    self :addEquipView( self.m_equipContainer)
    --角色皮肤部分（左）
    self.m_roleImage = self :addCharaterView( self.m_characterInfoViewContainer)
    --下方人物头像
    self :addRoleIcon( self.m_characterInfoViewContainer)


end

--创建人物头像列表
function CCharacterEquipInfoView.addRoleIcon( self, goodscontainer)
    print("CCharacterEquipInfoView.addRoleIcon")
    --角色头像部分
    self.m_tagLayout     = CHorizontalLayout :create()
    local cellButtonSize = CCSizeMake( 99, 99)
    self.m_tagLayout :setVerticalDirection(false)
    --self.m_tagLayout :setCellHorizontalSpace()
    self.m_tagLayout :setLineNodeSum( 4)
    self.m_tagLayout :setCellSize( cellButtonSize)

    for i=1,4 do
        local _partnerid = nil
        if i == 1 then
            _partnerid = 0
        else
            _partnerid = self.m_partneridlist[i-1]
        end
        print("XDC:",_partnerid,#self.m_partneridlist)
        local rolebutton     = self :createRoleButton( _partnerid)
        self.m_tagLayout :addChild( rolebutton)
    end
    goodscontainer :addChild( self.m_tagLayout)
    --self :roleEquipLayout( winSize)


end

function CCharacterEquipInfoView.updateRoleIcon( self)
    print("CCharacterEquipInfoView.updateRoleIcon:")
    if self.m_tagLayout ~= nil then
        self.m_tagLayout :removeAllChildrenWithCleanup( true)
    end
    for i=1,4 do
        local _partnerid = nil
        if i == 1 then
            _partnerid = 0
        else
            _partnerid = self.m_partneridlist[i-1]
        end
        print("XDC:",_partnerid,#self.m_partneridlist)
        local rolebutton     = self :createRoleButton( _partnerid)
        self.m_tagLayout :addChild( rolebutton)
    end
end

function CCharacterEquipInfoView.removePartnerById( self, _partnerid)
    print("CCharacterEquipInfoView.removePartnerById:", _partnerid,self.m_partnerconut)
    local icount = 1
    self.m_partnerconut = #self.m_partneridlist
    while icount <= self.m_partnerconut do
        print("OOOO:",icount,self.m_partnerconut,self.m_partneridlist[icount])
        if self.m_partneridlist[icount] == _partnerid then
            print("删除伙伴ID：",_partnerid,#self.m_partneridlist)
            table.remove( self.m_partneridlist, icount)
            self.m_partnerconut = self.m_partnerconut - 1
            break
        end
        icount = icount + 1
    end
    return self.m_partneridlist
end

function CCharacterEquipInfoView.setPartnerStateChange( self, _type, _partnerid)
    print("!@#$%^&*:",_type,_partnerid)
    if _type == 0 then   --离队成功 到酒吧 归队
        --删除缓存中属性，更新界面
        self.m_partnerId = 0
        self.m_pageCount = self.m_pageCount - 1
        local index      = tostring( self.m_uid)..tostring( _partnerid)
        print( "index:",index)
        --_G.g_characterProperty :removeOne( index, _G.Constant.CONST_PARTNER)
        self.m_mainProperty :setPartner( self :removePartnerById( _partnerid))   --伙伴ID列表
        self.m_mainProperty :setCount( self.m_partnerconut)     --伙伴数量
        print("UID:",self.m_uid,"Partner_id:",self.m_partnerId)
        self :updateCharacterInfo( self.m_uid, self.m_partnerId)
    elseif _type == 1 then --归队成功 到身上 已招
        print("111111111111111111:归队成功")
        --table.insert( self.m_partneridlist, _partnerid)
        --self.m_partnerconut = self.m_partnerconut + 1
        --下方人物头像
        --self :updateRoleIcon()
    elseif _type == 2 then --出战成功 身上 已招--出战
        --self.m_playedButton :setVisible( false)
        --self.m_restButton :setVisible( true)
        local command = CCharacterButtonStataCommand( 2)
        controller :sendCommand( command)
        self.m_roleProperty :setStata( 3)
    elseif _type == 3 then --休息成功 身上 出战--已招
        --self.m_playedButton :setVisible( true)
        --self.m_restButton :setVisible(false)
        local command = CCharacterButtonStataCommand( 3)
        controller :sendCommand( command)
        self.m_roleProperty :setStata( 0)
    elseif _type == 4 then --招募成功 身上or酒吧 已招or归队
        print("444444444444444:招募成功")
    end
end

function CCharacterEquipInfoView.setRoleIconList( self)
    print("CCharacterEquipInfoView.setRoleIconList:招募成功")
    self.m_partnerconut = self.m_partnerconut + 1
    self :updateRoleIcon()
end

--更新本地list数据
function CCharacterEquipInfoView.setLocalList( self)  --更换装备，整体刷新 旧
    print("CCharacterEquipInfoView.setLocalList")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self :getPartnerParams( self.m_partnerId)

    if self.m_characterInfoViewContainer ~= nil then
        self : removeAllCCBI() --ccbi清除
        self.m_characterInfoViewContainer :removeFromParentAndCleanup( true)
    end
    self :initView( self.m_scenelayer)
    self.layout(self, winSize)
end

--更新本地list数据
function CCharacterEquipInfoView.setEquipContainerList( self) --更换装备，装备部分刷新 新
    print("CCharacterEquipInfoView.setEquipContainerList")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self :getPartnerParams( self.m_partnerId)

    if self.m_equipContainer ~= nil then
        self : removeAllCCBI() --ccbi清除
        self.m_equipContainer :removeAllChildrenWithCleanup( true)
    end
    self :addEquipView( self.m_equipContainer)
    self.layout(self, winSize)
end
--发送更新属性请求
function CCharacterEquipInfoView.updateCharacterInfo( self, _uid, _partnerid)
    if self.m_characterInfoViewContainer ~= nil then
        self : removeAllCCBI() --ccbi清除
        self.m_characterInfoViewContainer :removeFromParentAndCleanup( true)
    end
    self :getPartnerParams( _partnerid)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self :initView( self.m_scenelayer)
    self.layout(self, winSize)

    local characterID = {}
    characterID.uid        = _uid
    characterID.partner_id = _partnerid
    local command = CCharacterCutoverCommand( characterID)
    controller :sendCommand( command)
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
function CCharacterEquipInfoView.clickEquipCallBack(self,eventType, obj, x, y)
    --删除Tips
     _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        require "view/TipsLayer/PopupView"
        local _position = {}
        _position.x = x
        _position.y = y
        if self.m_tipsType == nil then
            self.m_tipsType = _G.Constant.CONST_GOODS_SITE_ROLEBODY
        end
        local  temp =   _G.g_PopupView :create( self :getEquipById( tonumber(obj :getTag())), self.m_tipsType, _position, self.m_partnerId)
        self.m_scenelayer :addChild( temp)
    end
end
--单击回调
function CCharacterEquipInfoView.clickRoleCallBack(self,eventType, obj, x, y)
    --删除Tips
     _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if self.m_partnerId ~= obj: getTag() then
            self.m_partnerId = obj: getTag()
            print("UPDATE ###@@@START:"..self.m_partnerId)
            self :updateCharacterInfo( self.m_uid, self.m_partnerId)
            print("UPDATE ###@@@END:"..self.m_partnerId)

            self:setGuideStepFinish()
        end
    end
end
--单击回调
function CCharacterEquipInfoView.clickCellCallBack(self,eventType, obj, x, y)
    --删除Tips
     _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
    end
end



--新手引导点击命令
function CCharacterEquipInfoView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end



function CCharacterEquipInfoView.Create_effects_equip ( self,obj,name_color,id,index)
    name_color = tonumber(name_color)
    if name_color > 0 and name_color < 8 then
        if name_color ~= 1 then
            name_color = name_color - 1
        end
        local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
            if eventType == "Enter" then
                print( "Enter««««««««««««««««"..eventType )
                arg0 : play("run")
            end
        end

        if obj ~= nil and index ~= nil  then

            self["effect_ccbi"..index] = CMovieClip:create( "CharacterMovieClip/effects_equip_0"..name_color..".ccbi" )
            self["effect_ccbi"..index] : setControlName( "this CCBI Create_effects_activity CCBI")
            self["effect_ccbi"..index] : registerControlScriptHandler( animationCallFunc)
            obj  : addChild(self["effect_ccbi"..index],1000)

            self : setSaveCreateEffectCCBIList(index,id)
        end
    end
end

function CCharacterEquipInfoView.setSaveCreateEffectCCBIList ( self,index,id)
    print("CCharacterEquipInfoView 存表----",index,id)
    local data = {}
    data.index = index
    data.id    = id
    table.insert(self.CreateEffectsList,data)
    print("CCharacterEquipInfoView 村表后的个数",#self.CreateEffectsList,self.CreateEffectsList)
end
function CCharacterEquipInfoView.getSaveCreateEffectCCBIList ( self)
    print("返回存储的ccbi数据",self.CreateEffectsList,#self.CreateEffectsList)
    return self.CreateEffectsList
end

function CCharacterEquipInfoView.removeAllCCBI ( self)
    print("CCharacterEquipInfoView 开始调用删除CCBI")
    -- local data = self :getShowList()
    local data = self :getSaveCreateEffectCCBIList()
    print("1")
    if  data ~= nil then
        print("2")
        for k,goods in pairs(data) do
            print("3")
            --if tonumber(goods.goods_type) == 1 or tonumber(goods.goods_type)  == 2 then
                --local id = goods.goods_id
                local index = goods.index
                if  self["effect_ccbi"..index] ~= nil then
                    print("4")
                    self["effect_ccbi"..index] : removeFromParentAndCleanup(true)
                    self["effect_ccbi"..index] = nil
                    print("CCharacterEquipInfoView 删除了CCBI,其名为=========",index)
                end
            --end
        end
        self.CreateEffectsList = {} --删除后从新重置 存放创建ccbi的数据
    end
end













