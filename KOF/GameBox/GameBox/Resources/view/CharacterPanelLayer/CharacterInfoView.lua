--[[
 --CCharacterInfoView
 --角色信息主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"


CCharacterInfoView = class(view, function( self)
print("CCharacterInfoView:角色信息主界面")
end)
--Constant:
CCharacterInfoView.TAG_PLAYED         = 201 --出战
CCharacterInfoView.TAG_REST           = 202 --休息
CCharacterInfoView.TAG_LEAVE          = 203 --离队
CCharacterInfoView.TAG_RECRUIT        = 204 --招募
CCharacterInfoView.TAG_STRENGTH       = 205 --强化
CCharacterInfoView.TAG_POWERFUL       = 205
CCharacterInfoView.TAG_VIP            = 206

CCharacterInfoView.FONT_SIZE          = 20  --字体大小

--加载资源
function CCharacterInfoView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    
end
--释放资源
function CCharacterInfoView.unLoadResource( self)
end
--初始化数据成员
function CCharacterInfoView.initParams( self)
    print("CCharacterInfoView.initParams")
    local mainplay = nil
    print("DDDDDDD:",  self.m_partnerId, self.m_uid)
    if tostring(self.m_partnerId) == "0" then
        print("DDDDDDD1:")
        mainplay = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    else
        print("DDDDDDD2:")
        local index = tostring( self.m_uid)..tostring( self.m_partnerId)
        print("index:",index)
        mainplay = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    end
    --无背景属性
    self.m_name              = mainplay :getName()      --玩家姓名
    self.m_name_color        = mainplay :getNameColor() --名字颜色
    self.m_pro               = mainplay :getPro()       --玩家职业
    self.m_clan              = mainplay :getClan()
    self.m_clanname          = "无社团"
    if self.m_clan ~= nil then
        self.m_clanname      = mainplay :getClanName()  --帮派名字
    end
    self.m_lv                = mainplay :getLv() or 1        --玩家等级
    self.m_powerful          = mainplay :getPowerful() or 0  --战斗力
    self.m_vip_lv            = mainplay :getVipLv() or 0     --玩家VIP等级
    self.m_rank              = mainplay :getRank() or 0      --竞技排名
    self.m_exp               = mainplay :getExp() or 0       --经验值
    self.m_expn              = mainplay :getExpn() or 1      --下一级需要的经验
    self.m_stata             = mainplay :getStata()     --伙伴状态
    --有背景属性 PVP
    local mainplaypvp = mainplay :getAttr()
    self.m_hp                 = mainplaypvp :getHp()         --气血值
    self.m_strong             = mainplaypvp :getStrong()     --力量值
    self.m_magic              = mainplaypvp :getMagic()      --内力值
    self.m_strong_att         = mainplaypvp :getStrongAtt()  --力量物理攻击
    self.m_strong_def         = mainplaypvp :getStrongDef()  --力量物理防御值
    self.m_skill_att          = mainplaypvp :getSkillAtt()   --技能攻击
    self.m_skill_def          = mainplaypvp :getSkillDef()   --技能防御
    self.m_crit               = mainplaypvp :getCrit()       --暴击值(万分比)
    self.m_crit_res           = mainplaypvp :getCritRes()    --抗暴值(万分比)
    self.m_crit_harm          = mainplaypvp :getCritHarm()   --暴击伤害值(万分比)
    self.m_wreck              = mainplaypvp :getWreck()      --破甲值(万分比)
    self.m_bonus              = mainplaypvp :getBonus()      --伤害系数(万分比)
    self.m_reduction          = mainplaypvp :getReduction()  --免伤系数(万分比)
end

function CCharacterInfoView.getPlayPartnerCount(self)
    local result = 0
    local mainplay      = _G.g_characterProperty :getOneByUid( tonumber(self.m_uid), _G.Constant.CONST_PLAYER)
    local mainlv        = mainplay :getLv()
    local partnercount  = mainplay :getCount()     --伙伴数量
    local partnerlist   = mainplay :getPartner()   --伙伴ID列表
    for i=1,3 do
        local _partnerid = partnerlist[i]
        print("XDC==============:",_partnerid,#partnerlist)
        if _partnerid ~= nil then
            local index = tostring( self.m_uid)..tostring( _partnerid)
            print("index:",index)
            local partner = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
            local stata   = partner :getStata()     --伙伴状态
            print("______________:", stata)
            if tonumber(stata) == 3 then
                result = result + 1
            end
        end
    end
    print("{出战伙伴数量:}", result, mainlv)
    return result, mainlv
end
--释放成员
function CCharacterInfoView.realeaseParams( self)
    controller :unregisterMediator( self.mediator)--ByName( "CCharacterMediator")
    if self.m_scenelayer ~= nil then
        self.m_scenelayer :removeAllChildrenWithCleanup( true)  --removeFromParentAndCleanup
    end
end

--布局成员
function CCharacterInfoView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--角色信息主界面4")
        --人物属性
        local backgroundSize                   = CCSizeMake( winSize.height/3*4, winSize.height)
        local buttonsize                       = self.m_playedButton :getPreferredSize()
        local attributebackgroundSize          = CCSizeMake( backgroundSize.width*0.48, winSize.height*0.87)
        local attributebackground              = self.m_characterInfoViewContainer :getChildByTag( 100)
        local namebackground                   = self.m_characterInfoViewContainer :getChildByTag( 101)
        local linesprite                       = self.m_characterInfoViewContainer :getChildByTag( 102)

        local namebackgroundSize               = namebackground :getPreferredSize()

        attributebackground :setPreferredSize( attributebackgroundSize)

        attributebackground :setPosition( ccp( winSize.width/2, winSize.height/2)) -- +260 -32
        namebackground :setPosition( ccp( winSize.width/2, winSize.height/2+attributebackgroundSize.height/2-namebackgroundSize.height/2))
        linesprite :setPosition( ccp( winSize.width/2, winSize.height/2+20))
        self.m_characterattributeLayout :setPosition( winSize.width/2-attributebackgroundSize.width/2-30, winSize.height*0.75-15)
        self.m_vipContainer :setPosition( ccp( winSize.width/2+attributebackgroundSize.width*0.25, winSize.height/2+attributebackgroundSize.height/2-namebackgroundSize.height/2))
        self.m_powerContainer :setPosition( ccp( winSize.width/2, winSize.height/2+attributebackgroundSize.height*0.35))
        self.m_expContainer :setPosition( ccp( winSize.width/2+30, winSize.height/2+attributebackgroundSize.height*0.2+3))
        self.m_nameContainer :setPosition( ccp( winSize.width/2-attributebackgroundSize.width*0.5+20, winSize.height/2+attributebackgroundSize.height/2-namebackgroundSize.height/2))
        --self.m_characterAttributeViewContainer :setPosition( winSize.width*0.25+20, -32)

        self.m_playedButton :setPosition( ccp( winSize.width/2-attributebackgroundSize.width/2+buttonsize.width, winSize.height/2-attributebackgroundSize.height/2+buttonsize.height))
        self.m_restButton :setPosition( ccp( winSize.width/2-attributebackgroundSize.width/2+buttonsize.width, winSize.height/2-attributebackgroundSize.height/2+buttonsize.height))
        self.m_leaveButton :setPosition( ccp( winSize.width/2+attributebackgroundSize.width/2-buttonsize.width, winSize.height/2-attributebackgroundSize.height/2+buttonsize.height))
        self.m_recruitButton :setPosition( ccp( winSize.width/2-attributebackgroundSize.width/2+buttonsize.width, winSize.height/2-attributebackgroundSize.height/2+buttonsize.height))
        self.m_strengthButton :setPosition( ccp( winSize.width/2+attributebackgroundSize.width/2-buttonsize.width, winSize.height/2-attributebackgroundSize.height/2+buttonsize.height))

        self.m_scenelayer :setPosition( ccp( backgroundSize.width/2-attributebackgroundSize.width/2-15, -backgroundSize.height/2+attributebackgroundSize.height/2+15))
        
        if self.m_showType == true then
            self.m_playedButton :setVisible( false)
            self.m_restButton :setVisible( false)
            self.m_leaveButton :setVisible( false)
            self.m_recruitButton :setVisible( false)
            self.m_strengthButton :setVisible( false)
        end
        --768
        elseif winSize.height == 768 then
        CCLOG("768--角色信息主界面")

    end
end

--主界面初始化
function CCharacterInfoView.init(self, winSize, layer)
    print("viewID:",self._viewID)
--[[
    require "mediator/CharacterMediator"
    self.mediator = CCharacterMediator(self)
    controller :registerMediator(self.mediator)--先注册后发送 否则会报错
 ]]
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self)
    --初始化界面
    self.initView(self, layer)
    --布局成员
    self.layout(self, winSize)
end

function CCharacterInfoView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterInfoView self.m_scenelayer 101 ")
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CCharacterInfoView.layer( self , _uid, _partnerid, _showtype)
    print("create m_scenelayer")
    self.m_uid       = _uid
    self.m_partnerId = _partnerid
    self.m_showType  = _showtype  -- 区分查看自己还是查看其他玩家，屏蔽按钮使用
    if self.m_showType ~= true then
        self.m_showType  = false  -- 区分查看自己还是查看其他玩家，屏蔽按钮使用
    end
    print("DDDDDDD:",  self.m_partnerId, self.m_uid)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CCharacterInfoView self.m_scenelayer 111 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--初始化界面
function CCharacterInfoView.initView(self, layer)
    print("CCharacterInfoView.initView")
    --角色信息主界面
    self.m_characterInfoViewContainer = CContainer :create()
    self.m_characterInfoViewContainer : setControlName("this is CCharacterInfoView self.m_characterInfoViewContainer 121 ")
    layer :addChild( self.m_characterInfoViewContainer)
    --背景图片
    local attributebackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    attributebackground : setControlName( "this CCharacterInfoView attributebackground 203 ")
    self.m_characterInfoViewContainer :addChild( attributebackground, -1, 100)
    --角色名字，背景图片，VIP部分
    local  namebackground       = CSprite :createWithSpriteFrameName( "role_line1.png")
    namebackground :setControlName( "this is CCharacterInfoView namebackground 164")
    self.m_characterInfoViewContainer :addChild( namebackground, -1, 101)

    self.m_nameContainer          = self :createAttribute( self.m_name, nil, ccc3( 255,0,0))
    self.m_vipContainer           = self :createVipView()
    self.m_expContainer           = self :createExpView()
    self.m_powerContainer, self.m_powerfulLabel         = self :createPowerView()

    self.m_characterInfoViewContainer :addChild( self.m_nameContainer)
    self.m_characterInfoViewContainer :addChild( self.m_vipContainer)
    self.m_characterInfoViewContainer :addChild( self.m_powerContainer)
    self.m_characterInfoViewContainer :addChild( self.m_expContainer)



    local  linesprite           = CSprite :createWithSpriteFrameName( "general_dividing_line.png")
    linesprite :setControlName( "this is CCharacterInfoView linesprite 164")
    self.m_characterInfoViewContainer :addChild( linesprite, -1, 102)
    --角色属性部分（右）
    self :initAttributeView()
    --按纽相关
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end    
    self.m_playedButton       = self :createButton( "出战", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_PLAYED, "self.m_playedButton")    --出战按钮 伙伴
    self.m_restButton         = self :createButton( "休息", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_REST, "self.m_restButton")        --休息按钮 伙伴
    self.m_recruitButton      = self :createButton( "招募", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_RECRUIT, "self.m_recruitButton")  --招募按钮 猪脚
    self.m_strengthButton     = self :createButton( "强化", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_STRENGTH, "self.m_playedButton")  --强化按钮 猪脚
    self.m_leaveButton        = self :createButton( "离队", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_LEAVE, "self.m_leaveButton")      --离队按钮 伙伴

    self.m_characterInfoViewContainer :addChild( self.m_playedButton)
    self.m_characterInfoViewContainer :addChild( self.m_restButton)
    self.m_characterInfoViewContainer :addChild( self.m_recruitButton)
    self.m_characterInfoViewContainer :addChild( self.m_strengthButton)
    self.m_characterInfoViewContainer :addChild( self.m_leaveButton)

    self :showButton()

end

--创建按钮Button
function CCharacterInfoView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CCharacterInfoView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CCharacterInfoView ".._controlname)
    m_button :setFontSize( 24)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CCharacterInfoView ".._controlname.."CallBack")
    return m_button
end

--创建经验进度条
function CCharacterInfoView.createExpView( self)
    local expcontainer       = CContainer :create()
    expcontainer :setControlName( "this is CCharacterInfoView createExpView CContainer")
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
    local _explabel          = self :createAttribute( nil, self.m_exp.."/"..self.m_expn)
    _explabel :setPosition( -_expbackgroundSize.width/2+10, 0)
    expcontainer :addChild( _explabel)
    return expcontainer
end

--创建VIP
function CCharacterInfoView.createVipView( self)

    local vipcontainer  = CContainer :create()
    vipcontainer :setControlName( "this is CCharacterInfoView createVipView CContainer")
    if self.m_vip_lv ~= nil then
        local function CallBack( eventType, obj, x, y)
            return self :clickCellCallBack( eventType, obj, x, y)
        end 
        local _vipbutton    = self :createButton( "", "general_button_normal.png", CallBack, CCharacterInfoView.TAG_VIP, "_vipbutton")
        local _vipname      = CSprite :createWithSpriteFrameName( "role_vip.png")

        _vipbutton :setScaleY( 0.7)
        _vipbutton :setPosition( ccp( 10,0))
        if self.m_showType == true then
            _vipbutton :setVisible( false)
        end
        
        local viplv  = tostring( self.m_vip_lv)
        local length = string.len( viplv)

        --角色头像部分
        local _vipLayout     = CHorizontalLayout :create()
        local cellButtonSize = CCSizeMake( 15,30)
        _vipLayout :setVerticalDirection(false)
        --_vipLayout :setCellHorizontalSpace()
        _vipLayout :setLineNodeSum( length)
        _vipLayout :setCellSize( cellButtonSize)
        local vipnameSize  = _vipname :getPreferredSize()
        _vipLayout :setPosition( vipnameSize.width/2+5,0)

        print("WWWWWWW:",viplv)
        for i=1, length do
            print("WWWWWWW:","role_vip_0"..string.sub(viplv,i,i)..".png")
            local _tempvip = CSprite :createWithSpriteFrameName( "role_vip_0"..string.sub(viplv,i,i)..".png")
            _vipLayout :addChild( _tempvip)        
        end
        vipcontainer :addChild( _vipbutton)
        vipcontainer :addChild( _vipname)
        vipcontainer :addChild( _vipLayout)
    end
    return vipcontainer
end

function CCharacterInfoView.createPowerView( self)
    local powercontainer = CContainer :create()
    powercontainer :setControlName( "this is CCharacterInfoView createPowerView CContainer")
    local powerbackground = CSprite :createWithSpriteFrameName( "role_power.png")
    powercontainer :addChild( powerbackground)
    local powervalue, powerlabel  = self :createAttribute( nil , self.m_powerful, ccc3( 0,255,0))
    powervalue :setPosition( -50, 0)
    powervalue :setTag( CCharacterInfoView.TAG_POWERFUL)
    powercontainer :addChild( powervalue)
    return powercontainer,powerlabel
end

--创建单条人物属性
-- _name   属性名
-- _value  属性字符串值
-- _color  字符串颜色
function CCharacterInfoView.createAttribute( self, _name, _value, _color)

    local attributecontainer  = CContainer :create()
    attributecontainer : setControlName("this is CCharacterInfoView attributecontainer 147 ")
    if _name == nil then
        _name = ""
    end
    local attributename      = CCLabelTTF :create( _name, "Arial", CCharacterInfoView.FONT_SIZE)
    attributename :setColor( ccc3( 226,215,118))
    attributename :setAnchorPoint( ccp( 0, 0.5))
    attributecontainer :addChild( attributename)
    if _value == nil then
        _value = ""
    end
    local attributelabel      = CCLabelTTF :create( _value, "Arial", CCharacterInfoView.FONT_SIZE)
    if _color ~= nil then
        attributelabel :setColor( _color)
    end
    attributelabel :setAnchorPoint( ccp( 0, 0.5))
    attributelabel :setPosition( 50, 0)
    attributelabel :setTag( CCharacterInfoView.TAG_POWERFUL)
    attributecontainer :addChild( attributelabel)
    return attributecontainer, attributelabel
end

function  CCharacterInfoView.getProString( self, _pro)
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
function CCharacterInfoView.addAllAtribute( self)
    -- body
    self.m_characterattributeLayout :addChild( self :createAttribute( "职业 ",self :getProString( self.m_pro)))
    self.m_characterattributeLayout :addChild( self :createAttribute( "等级 ",self.m_lv))
    print( "EXP:",self.m_exp.."/"..self.m_expn)
    self.m_characterattributeLayout :addChild( self :createAttribute( "经验 "))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))
    self.m_characterattributeLayout :addChild( self :createAttribute( "社团 ", self.m_clanname))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))--( "称号 ", "独孤求败"))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))
    self.m_characterattributeLayout :addChild( self :createAttribute( ""))
    self.m_characterattributeLayout :addChild( self :createAttribute( "气血 ",self.m_hp))
    self.m_characterattributeLayout :addChild( self :createAttribute( "智力 ",self.m_magic))
    self.m_characterattributeLayout :addChild( self :createAttribute( "力量 ",self.m_strong))    
    self.m_characterattributeLayout :addChild( self :createAttribute( "物防 ",self.m_strong_def))
    self.m_characterattributeLayout :addChild( self :createAttribute( "物攻 ",self.m_strong_att))
    self.m_characterattributeLayout :addChild( self :createAttribute( "技防 ",self.m_skill_def))
    self.m_characterattributeLayout :addChild( self :createAttribute( "技攻 ",self.m_skill_att))
    self.m_characterattributeLayout :addChild( self :createAttribute( "抗暴 ",self.m_crit_res))  --,self.m_crit_res
    self.m_characterattributeLayout :addChild( self :createAttribute( "暴击 ",self.m_crit))    
    self.m_characterattributeLayout :addChild( self :createAttribute( "暴伤 ",self.m_crit_harm))
    self.m_characterattributeLayout :addChild( self :createAttribute( "破甲 ",self.m_wreck))  --,self.m_wreck
    self.m_characterattributeLayout :addChild( self :createAttribute( "减伤 ",self.m_reduction))

    self.m_powerfulLabel :setString( self.m_powerful)

end

--角色属性部分（右）
function CCharacterInfoView.initAttributeView( self)
    -- body
    --角色属性层
    self.m_characterAttributeViewContainer = CContainer :create()
    self.m_characterAttributeViewContainer : setControlName("this is CCharacterInfoView self.m_characterAttributeViewContainer 198 ")
    self.m_characterInfoViewContainer :addChild( self.m_characterAttributeViewContainer)
    --背景图片
    --local attributebackground   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    --attributebackground : setControlName( "this CCharacterInfoView attributebackground 203 ")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local attributebackgroundSize = CCSizeMake( winSize.height*4/3*0.4, winSize.height*0.87)
    --attributebackground :setPreferredSize( attributebackgroundSize)
    --self.m_characterAttributeViewContainer :addChild( attributebackground, -1, 100)
    --属性布局
    self.m_characterattributeLayout = CHorizontalLayout :create()
    self.m_characterattributeLayout :setVerticalDirection( false)
    self.m_characterattributeLayout :setCellHorizontalSpace( 30)
    self.m_characterattributeLayout :setCellVerticalSpace( 12)
    self.m_characterattributeLayout :setLineNodeSum( 2)
    local cellButtonSize = CCSizeMake( attributebackgroundSize.width/2-20, 20)
    self.m_characterattributeLayout :setCellSize( cellButtonSize)
    --添加属性部分
    self :addAllAtribute()
    self.m_characterAttributeViewContainer :addChild( self.m_characterattributeLayout)
    --return self.m_characterAttributeViewContainer
end
--切换人物时更新装备
function CCharacterInfoView.showButton( self)
    print("BUTTON:",self.m_partnerId,"/",self.m_stata)
    if self.m_partnerId == 0 then
        self.m_recruitButton :setVisible( true)
        self.m_strengthButton :setVisible( true)
        self.m_playedButton :setVisible( false)
        self.m_restButton :setVisible( false)
        self.m_leaveButton :setVisible( false)
    else
        if self.m_stata == 3 then
            self.m_playedButton :setVisible( false)
            self.m_restButton :setVisible( true)
        elseif self.m_stata == 0 then
            self.m_playedButton :setVisible( true)
            self.m_restButton :setVisible(false)
        end
        self.m_recruitButton :setVisible( false)
        self.m_strengthButton :setVisible( false)
        self.m_leaveButton :setVisible( true)
    end
end
-----------------------------------------------------
--更新本地list数据
----------------------------------------------------
--更新本地list数据
function CCharacterInfoView.setLocalList( self)
    print("CCharacterInfoView.setLocalList")
    self :initParams()
    if self.m_characterattributeLayout ~= nil then
        self.m_characterattributeLayout :removeAllChildrenWithCleanup(true)
    end
    --更新属性部分
    self :addAllAtribute()

end

function CCharacterInfoView.setStateChange( self, _type)
    --local index = tostring( self.m_uid)..tostring( self.m_partnerId)
    --print("index:",index)
    --local play = _G.g_characterProperty :getOneByUid( index, _G.Constant.CONST_PARTNER)
    if _type == 0 then   --离队成功 到酒吧 归队
    elseif _type == 1 then --归队成功 到身上 已招
    elseif _type == 2 then --出战成功 身上 已招--出战
        self.m_playedButton :setVisible( false)
        self.m_restButton :setVisible( true)
    elseif _type == 3 then --休息成功 身上 出战--已招
        self.m_playedButton :setVisible( true)
        self.m_restButton :setVisible(false)
    elseif _type == 4 then --招募成功 身上or酒吧 已招or归队
    end
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CCharacterInfoView.clickCellCallBack(self,eventType, obj, x, y)
    --删除Tips
     _G.g_PopupView :reset()
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())         
        if obj :getTag() == CCharacterInfoView.TAG_LEAVE then
            print(" 离队:",self.m_partnerId)
            require "common/protocol/auto/REQ_INN_DROP_OUT"
            local msg = REQ_INN_DROP_OUT()
            msg :setPartnerId( self.m_partnerId)
            _G.CNetwork :send( msg)
            require "view/ErrorBox/ErrorBox"
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
            end
            local BoxLayer = ErrorBox : create("离队后伙伴返回酒吧，到酒吧可设置归队!",func1)
            _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,1000)
        elseif obj :getTag() == CCharacterInfoView.TAG_PLAYED then
            local partnercount, mainlv = self :getPlayPartnerCount() 
            if mainlv < _G.Constant.CONST_ATTR_PARTNER_LV_TWO then
                if partnercount == 1 then --只能出战1个
                    require "view/ErrorBox/ErrorBox"
                    local ErrorBox = CErrorBox()
                    local function func1()
                        print("确定")
                    end
                    local BoxLayer = ErrorBox : create("玩家 ".._G.Constant.CONST_ATTR_PARTNER_LV_TWO.."级可以出战 2 个伙伴",func1)
                    _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,1000)
                    return
                end
            elseif mainlv < _G.Constant.CONST_ATTR_PARTNER_LV_THREE then
                if partnercount == 2 then --只能出战2个
                    require "view/ErrorBox/ErrorBox"
                    local ErrorBox = CErrorBox()
                    local function func1()
                        print("确定")
                    end
                    local BoxLayer = ErrorBox : create("玩家 ".._G.Constant.CONST_ATTR_PARTNER_LV_THREE.."级可以出战 3 个伙伴",func1)
                    _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,1000)
                    return
                end
            end
            print(" 出战:",self.m_partnerId)
            require "common/protocol/auto/REQ_INN_WAR"
            local msg = REQ_INN_WAR()
            msg :setPartnerId( self.m_partnerId)
            _G.CNetwork :send( msg)            
            self:setGuideStepFinish()
        elseif obj :getTag() == CCharacterInfoView.TAG_REST then
            print(" 休息:",self.m_partnerId)
            require "common/protocol/auto/REQ_INN_NTE_WAR"
            local msg = REQ_INN_NTE_WAR()
            msg :setPartnerId( self.m_partnerId)
            _G.CNetwork :send( msg)
        elseif obj :getTag() == CCharacterInfoView.TAG_RECRUIT then
            print(" 招募: 跳转到酒吧")
            if self.m_lv >= _G.Constant.CONST_INN_RECRUIT_LV then
                require "view/BarPanelLayer/BarPanelView"
                _G.pBarPanelView = CBarPanelView()
                CCDirector :sharedDirector() :pushScene( CCTransitionShrinkGrow:create(0.5,_G.pBarPanelView :scene()))
            else
                require "view/ErrorBox/ErrorBox"
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("招募开放等级为".._G.Constant.CONST_INN_RECRUIT_LV,func1)
                _G.g_CharacterPanelView :getSceneContainer(): addChild(BoxLayer,1000)
            end
        elseif obj :getTag() == CCharacterInfoView.TAG_STRENGTH then
            print(" 强化: 跳转到强化")
            --CFightGasView()
            _G.g_CharacterPanelView :closeAll()
            require "view/EquipInfoView/EquipInfoView"
            _G.g_CEquipInfoView = CEquipInfoView ()
            _G.g_CEquipInfoView : setOpenCharacterPanelView(1)
            CCDirector : sharedDirector () : pushScene(CCTransitionShrinkGrow:create(0.5,_G.g_CEquipInfoView :scene())) --玩家
        elseif obj :getTag() == CCharacterInfoView.TAG_VIP then
            print(" VIP: 跳转到VIP")
            require "view/VipUI/VipUI"
            local vipUI = CVipUI()
            CCDirector :sharedDirector() :pushScene( vipUI:scene())
        end
    end
end


function CCharacterInfoView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end



















