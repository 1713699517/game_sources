require "view/view"
require "model/VO_SkillModel"
require "controller/SkillCommand"

require "common/protocol/auto/REQ_SKILL_LEARN"
require "common/protocol/auto/REQ_SKILL_EQUIP"
require "mediator/SkillMediator"
require "common/protocol/REQ_SKILL_PARTNER"
require "common/protocol/REQ_SKILL_UPPARENTLV"
require "controller/GuideCommand"

CSkillNewUI = class( view, function(self )
	-- body
	CCLOG("技能新界面 08.19")
	self.m_winSize = CCSizeMake( 854.0, 640.0)
    self.m_currentViewId = CSkillNewUI.TAG_MAIN_ROLE          -- 初始界面 表示主角
end)

CSkillNewUI.SCALE_SKILL_ICON    = 1.0
CSkillNewUI.TAG_EQUIP_SPR       = 101
CSkillNewUI.TAG_EQUIP_BTN1      = 5
CSkillNewUI.TAG_EQUIP_BTN2      = 6
CSkillNewUI.TAG_EQUIP_BTN3      = 7

CSkillNewUI.TAG_MAIN_ROLE       = 10

function CSkillNewUI.scene( self )
    local retScene	= CCScene :create()

    self :init( retScene, nil)
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup(false)
    end

    retScene :addChild( self.m_pContainer)
    return retScene
end

function CSkillNewUI.setCurrentViewId( self, _viewId)
    self.m_currentViewId = tonumber( _viewId)
end

function CSkillNewUI.getCurrentViewId( self)
    return self.m_currentViewId
end

function CSkillNewUI.layer( self, _uid )
    self.m_retContainer		= CContainer :create()
    self.m_uid = _uid

    self :init( self.m_retContainer, self.m_uid)
    if self.m_pContainer :getParent() ~= nil then
        self.m_pContainer :removeFromParentAndCleanup(false)
    end

    self.m_retContainer :addChild( self.m_pContainer, 100)
    return self.m_retContainer
end

function CSkillNewUI.init( self, _layer, _uid)
	if self.m_pContainer ~= nil then
		self.m_pContainer : removeFromParentAndCleanup( true)
		self.m_pContainer = nil
	end
	self.m_pContainer = CContainer :create()
	_layer :addChild( self.m_pContainer)

	-- body
	self : loadResources()
	self : initData()
	self : initBgAndCloseBtn( _layer, _uid)
	self : initView()
	self : addMediator()
	self : layout()
    self : setCurrentViewId( CSkillNewUI.TAG_MAIN_ROLE)
    self : initEquipBtnIcon()
end

function CSkillNewUI.getRoleUid( self)
    return self.m_uid
end

function CSkillNewUI.loadResources( self )
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("skillsResources/skillResources.plist")
end

function CSkillNewUI.initData( self )
    --local mainProperty          = _G.g_characterProperty:getMainPlay()
    local uid                   = self :getRoleUid()
    local mainProperty          = _G.g_characterProperty :getOneByUid( tonumber( uid), _G.Constant.CONST_PLAYER)

    if self :judgementIsSelf() == true then
        local skillData             = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
        self.m_tableMoneyList       = skillData : getSkillList()             --技能界面得钱币  (rmb_bind, rmb, power, gold)
    end
    --当前职业的技能表  skill_count    skill..
    self.m_tableProSkillIdList  = _G.g_SkillDataProxy : getSkillIdByPro( mainProperty :getPro())


    --self.m_tableStudySkillList  = _G.g_SkillDataProxy : getSkillDataInfoList()       --已学习的技能列表(默认＋学习的)
    --self.m_tableEquipList       = _G.g_SkillDataProxy : getEquipDataInfoList()
    self.m_pro                  = mainProperty : getPro()
    --new
    local mainSkillData            = mainProperty :getSkillData()
    if mainSkillData ~= nil then
        self.m_tableStudySkillList     = mainSkillData :getSkillStudyList()
        self.m_tableEquipList          = mainSkillData :getSkillEquipList()

        if self :getCurrentViewId() ~= CSkillNewUI.TAG_MAIN_ROLE then   --如果不在主角界面
            local partner_id = self :getCurrentViewId()
            --print("伙伴id--->", self :getCurrentViewId(), uid, self :getRoleUid())
            local index = tostring( uid ) .. tostring( partner_id)
            local property = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
            self.m_partnerList  = property :getSkillData() :getSkillStudyList()
        end
    end
    --new


    --skillData : getSkillEquipInfo()                   --已装备的技能信息(skill_lv, equip_pos, skill_id)

    --local mainplay = _G.g_characterProperty :getMainPlay()
    self.m_role_lv           = mainProperty :getLv()                   --玩家级别
    self.m_partnerconut      = mainProperty :getCount()     --伙伴数量
    self.m_partneridlist     = mainProperty :getPartner()   --伙伴ID列表

    self :setLinesAndPages( tonumber(self.m_tableProSkillIdList:getAttribute("skill_count")) )

    self.m_tableXmlInfo = {}
    for i=1, self.m_nLines do
        local nSkill = "skill"..tostring( i)

        self.m_tableXmlInfo[i]     = {}
        self.m_tableXmlInfo[i].skill_id     = tonumber( self.m_tableProSkillIdList:getAttribute(nSkill))

        --print("技能id", self.m_tableXmlInfo[i].skill_id, nSkill)
        local skillNode = _G.g_SkillDataProxy :getSkillById( tostring( self.m_tableXmlInfo[i].skill_id))
        if skillNode :isEmpty() then
            return
        end

        --显示的所有技能id 与已经学习的技能列表比较  获取技能当前等级， 如果没学 默认为0
        for key, value in pairs( self.m_tableStudySkillList) do
            if tonumber( key) == self.m_tableXmlInfo[i].skill_id then
                --print("学习了该技能", key, self.m_tableXmlInfo[i].skill_id, value.m_lv)
                self.m_tableXmlInfo[i].m_lv     = tonumber(value.m_lv)
                break
            else
                self.m_tableXmlInfo[i].m_lv     = 0
            end
        end
        --print("技能等级-->>", self.m_tableXmlInfo[i].skill_id, self.m_tableXmlInfo[i].m_lv)

        --技能id 与已经装备的技能列表比较，获取技能的 equip_pos,如果没有装备 equip_pos默认为 -1
        for key, value in pairs( self.m_tableEquipList) do
            if tonumber( value.skill_id) == self.m_tableXmlInfo[i].skill_id then
                --print("装备的技能xml", value.skill_id, self.m_tableXmlInfo[i].skill_id, value.equip_pos)
                self.m_tableXmlInfo[i].equip_pos = tonumber( value.equip_pos)
                break
            else
                self.m_tableXmlInfo[i].equip_pos = -1
            end
        end
        --print("技能装备位置->>", self.m_tableXmlInfo[i].skill_id, self.m_tableXmlInfo[i].equip_pos)

        self.m_tableXmlInfo[i].pro              = skillNode:getAttribute("pro")                     --职业
        self.m_tableXmlInfo[i].battle_remark    = skillNode:getAttribute("battle_remark")           --技能所需等级
        self.m_tableXmlInfo[i].lv_max           = skillNode:getAttribute("lv_max")                  --技能最大等级
        local nMaxLv = tonumber( self.m_tableXmlInfo[i].lv_max)

        local nLv = 1
        --print("self.m_tableXmlInfo[i].m_lv",self.m_tableXmlInfo[i].m_lv, i )
        if self.m_tableXmlInfo[i].m_lv ~= nil and self.m_tableXmlInfo[i].m_lv ~= 0 and self.m_tableXmlInfo[i].m_lv < nMaxLv then
            nLv = self.m_tableXmlInfo[i].m_lv + 1
        end
        if self.m_tableXmlInfo[i].m_lv == nil then
            self.m_tableXmlInfo[i].m_lv = 1
        end
        local lvsChild = skillNode : children()
        local lvsNode = lvsChild:get(0,"lvs")
        local lvNode = lvsNode:selectSingleNode("lv[@lv="..tostring(nLv).."]")
        local upNode = lvNode:children():get(0,"up")
        local mustNode = lvNode:children():get(0,"must")
        self.m_tableXmlInfo[i].remark           = lvNode:getAttribute("remark")     --技能描述
        self.m_tableXmlInfo[i].name             = skillNode:getAttribute("name")                    --技能名字
        self.m_tableXmlInfo[i].icon             = skillNode:getAttribute("icon")                    --技能图标

        self.m_tableXmlInfo[i].doller           = upNode:getAttribute("gold")   --所需美刀
        self.m_tableXmlInfo[i].power            = upNode:getAttribute("power")  --所需潜能
        self.m_tableXmlInfo[i].must_lv          = mustNode:getAttribute("lv")   --所需等级
    end
    --打印信息
    self : printf( self.m_tableStudySkillList, "已经学习的技能列表")
    self : printf( self.m_tableEquipList, "已装备的技能信息")
    self : printf( self.m_tableMoneyList, "金钱信息")
    self : printf( self.m_tableProSkillIdList, "当前职业的技能表(包括已学及未学的技能)")
    self : printf( self.m_tableXmlInfo, "xml信息")

end

function CSkillNewUI.setLinesAndPages( self, _nCount)
    --print("skill_count", _nCount)
    local l_pageCount = _nCount % 3
    if l_pageCount < 0 then
        l_pageCount = 0
    end
    if l_pageCount > 0 then
        l_pageCount = math.modf( _nCount / 3) + 1
        elseif l_pageCount == 0 then
        l_pageCount = _nCount / 3
    end

    -----------------
    self.m_nLines = _nCount         --行数( 6  )
    self.m_nPages = l_pageCount                                   --页数( /3 )
    -----------------
end

function CSkillNewUI.printf( self, _table, _szName)
    --[[
    print("\n-------------------------------------")
    for k, v in pairs( _table) do
        print( _szName, k, v, type(v))
        if type(v) == "table" then
            for kk, vv in pairs( v) do
                print("表内", kk, "   ", vv )
            end
        end
    end
    --]]
end

function CSkillNewUI.initBgAndCloseBtn( self, _layer, _uid )
    if _uid == nil then
        --最底图
        self.m_pWindowBg = CSprite :createWithSpriteFrameName( "peneral_background.jpg" )
        self.m_pWindowBg  :setControlName("this CSkillNewUI. self.m_pWindowBg 174")
        _layer   :addChild( self.m_pWindowBg, -100 )
        --背景
        self.m_pBackground  = CSprite :createWithSpriteFrameName("general_first_underframe.jpg")    --"general_main_underframe.png")
        self.m_pBackground  :setControlName("this CSkillNewUI. self.m_pBackground 63")
        _layer   :addChild( self.m_pBackground, -100 )

        local function closeCallBack( eventType, obj, x, y )
            return self :onCloseCallBack( eventType, obj, x, y)
        end
        --关闭按钮
        self.m_pCloseBtn    = CButton :createWithSpriteFrameName("", "general_close_normal.png")
        self.m_pCloseBtn    :setControlName("this CSkillNewUI. self.m_pCloseBtn 71")
        self.m_pCloseBtn    :registerControlScriptHandler( closeCallBack, "this CSkillNewUI. self.m_pCloseBtn 45" )
        _layer   :addChild( self.m_pCloseBtn, -96)
    end
    ------------------------------------
    local szBgSprName = "general_second_underframe.png"
    --左边的技能滑动bg
    self.m_lpLeftBgSpr      = CSprite :createWithSpriteFrameName( tostring( szBgSprName))
    --左下bg
    self.m_lpLeftBottemSpr  = CSprite :createWithSpriteFrameName( tostring( szBgSprName))
    --右边背景
    self.m_lpRightBgSpr     = CSprite :createWithSpriteFrameName( tostring( szBgSprName))
    --右下背景
    self.m_lpRightBottemSpr = CSprite :createWithSpriteFrameName( tostring( szBgSprName))

    self.m_lpLeftBgSprSize      = CCSizeMake( self.m_winSize.width * 0.48291, self.m_winSize.height * 0.64119+10)
    self.m_lpLeftBottemSprSize  = CCSizeMake( self.m_winSize.width * 0.48291, self.m_winSize.height * 0.20156)
    self.m_lpRightBgSprSize     = CCSizeMake( self.m_winSize.width * 0.4908-15, self.m_winSize.height * 0.5406)  --404
    self.m_lpRightBottemSprSize     = CCSizeMake( self.m_winSize.width * 0.4908-15, self.m_winSize.height * 0.30156)

    self.m_lpLeftBgSpr      :setPreferredSize( self.m_lpLeftBgSprSize)
    self.m_lpLeftBottemSpr  :setPreferredSize( self.m_lpLeftBottemSprSize)
    self.m_lpRightBgSpr     :setPreferredSize( self.m_lpRightBgSprSize)
    self.m_lpRightBottemSpr :setPreferredSize( self.m_lpRightBottemSprSize)

    self.m_pContainer  :addChild( self.m_lpLeftBgSpr)
    self.m_pContainer  :addChild( self.m_lpLeftBottemSpr)
    self.m_pContainer  :addChild( self.m_lpRightBgSpr)
    self.m_pContainer  :addChild( self.m_lpRightBottemSpr)

end

--如果传入的uid与自己相等，即打开自己的界面
function CSkillNewUI.judgementIsSelf( self )
    local uid = _G.g_LoginInfoProxy : getUid()
    --测试
    if self :getRoleUid() == uid then
        return true
    else
        return false
    end
end

function CSkillNewUI.initView( self )
    self :removeLayer()

    if self :judgementIsSelf() == true then

        self :addRoleHeadBtn( )
        if self.m_tableXmlInfo == nil then
            return
        end
        self :addSkillBtn( self.m_tableXmlInfo)
        self :addSkillInfoView()
        self :addEquipSkillBtn()

        --初始化第一个界面  默认第一个技能按钮
        if self.m_lpSkillSprList ~= nil then

            self :setCurrentClickBtn( self.m_lpSkillSprList[1] )
            self :setRightInfoView( self.m_tableXmlInfo)
            self.m_lpSkillSprList[1] :setImageWithSpriteFrameName("general_underframe_click.png")
            self.m_lpSkillSprList[1] :setPreferredSize( self.m_loSkillBtnListSize)
        end
    else
        self :addRoleHeadBtn( )
        self :addSkillBtn( self.m_tableXmlInfo)
    end
end

--{角色头像按钮}
function CSkillNewUI.addRoleHeadBtn( self)
    self.m_roleLayer  = CContainer :create()
    self.m_pContainer :addChild( self.m_roleLayer)

    local function roleBtnCallback( eventType, obj, x, y)
        return self :onRoleBtnCallback( eventType, obj, x, y)
    end

    local _szUnderFrameSprName = "general_role_head_underframe.png"
    local _szTopFramSprName    = "general_role_head_frame_normal.png"

    local l_role_fir_btn = CButton :createWithSpriteFrameName( "", _szUnderFrameSprName)
    local l_role_fir_spr = CSprite :create("HeadIconResources/role_head_0".. self.m_pro ..".jpg")
    local l_role_fir_frame = CSprite :createWithSpriteFrameName( _szTopFramSprName )

    l_role_fir_frame : setControlName( "this CSkillNewUI roleframe 342 ")
    l_role_fir_btn :setControlName("this CSkillNewUI. l_role_fir_btn 96")

    self : addHightLightRoleBtn( l_role_fir_btn)

    self.m_roleLayer :addChild( l_role_fir_btn, 50)
    l_role_fir_btn :addChild( l_role_fir_spr, 88)
    l_role_fir_spr :addChild( l_role_fir_frame, 88)

    l_role_fir_btn :setTag( CSkillNewUI.TAG_MAIN_ROLE)
    l_role_fir_btn :registerControlScriptHandler( roleBtnCallback, "this CSkillNewUI. l_role_fir_btn 45" )

    local firSize = l_role_fir_btn :getPreferredSize()
    local roleX   = firSize.width * 0.75
    local roleY   = firSize.height * 0.66
    l_role_fir_btn :setPosition( roleX, roleY )

    --另三个框框
    for num=1, 3 do
        local l_spr_frame = CSprite :createWithSpriteFrameName( _szUnderFrameSprName )
        self.m_roleLayer  : addChild( l_spr_frame )
        l_spr_frame       : setPosition( ccp( roleX + firSize.width * ( num * 1 ), roleY ) )

        --外框
        local roleframe = CSprite :createWithSpriteFrameName( _szTopFramSprName )
        roleframe : setControlName( "this CSkillNewUI roleframe 160 ")
        roleframe : setPosition( ccp( roleX + firSize.width * ( num * 1 ), roleY ) )
        self.m_roleLayer :addChild( roleframe, 10)
    end

    if self.m_partnerconut > 0 then
        for w=1, self.m_partnerconut do
            local _btnPartner = CButton :createWithSpriteFrameName("", _szTopFramSprName )

            _btnPartner :registerControlScriptHandler( roleBtnCallback, "this CSkillNewUI. _btnPartner 295"..w)
            _btnPartner :setTag( self.m_partneridlist[w])

            local _szPartnerSprName = "HeadIconResources/role_head_10412.jpg"

            local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
            local partnerinfo = partner_inits_temp :selectSingleNode( "partner_init[@id="..tostring( self.m_partneridlist[w] ).."]")
            if not partnerinfo :isEmpty() then
                print("partnerinfo,",partnerinfo:getAttribute("head"))
                _szPartnerSprName = "HeadIconResources/role_head_" .. partnerinfo:getAttribute("head") .. ".jpg"
            end


            local _sprPartner = CSprite : create( _szPartnerSprName )
            self.m_roleLayer  : addChild( _sprPartner, 10)

            _btnPartner :setPosition( roleX + firSize.width * ( 1.00 * w ), roleY )
            _sprPartner :setPosition( roleX + firSize.width * ( 1.00 * w ), roleY )
            self.m_roleLayer  : addChild( _btnPartner, 10 )
        end
    end

end

function CSkillNewUI.addHightLightRoleBtn( self, _btn )
    if _btn ~= nil then
        if self.m_clickRoleSpr ~= nil then
            self.m_clickRoleSpr :removeFromParentAndCleanup( true)
            self.m_clickRoleSpr = nil
        end
        self.m_clickRoleSpr = CSprite :createWithSpriteFrameName( "general_role_head_frame_click.png")
        _btn :addChild( self.m_clickRoleSpr, 1100)
    end
end

--{技能滑动按钮}
function CSkillNewUI.addSkillBtn( self, _dataList)
    --print("总页数", self.m_nPages, "  行数", self.m_nLines)
    if self.m_nLines <= 0 or self.m_nPages <= 0 or _dataList == nil then
        return
    end

    local viewSize = self.m_lpLeftBgSprSize

    local _pageContainer = {}
    local nPage       = self.m_nPages
    local nAllLine    = self.m_nLines

    local l_nLine     = 1
    local l_nIconLine = 1
    local l_nSprLine  = 1
    local l_nNameLine = 1
    local l_nLvLine   = 1

    self.m_lpSkillSprList = {}                  --左边的技能背景条
    self.m_lpSkillLvInfoList = {}               --等级 0阶0级
    self.m_loSkillBtnListSize = CCSizeMake( viewSize.width-20, viewSize.height / 3.5 )

    local pageSize = CCSizeMake( viewSize.width, viewSize.height - 30 )
    self.m_pScrollView = CPageScrollView :create( eLD_Vertical, pageSize)
    --self.m_pScrollView :setTouchesPriority( -10 )
    self.m_pContainer :addChild( self.m_pScrollView)

    local function clickSkillBtnCallback( eventType, obj, touches )
        return self :onClickSkillBtnCallback( eventType, obj, touches )
    end
    ------添加技能按钮背景条
    for iPage=1, nPage do
        _pageContainer[iPage] = CContainer :create()
        _pageContainer[iPage] : setControlName("this is CSkillNewUI _pageContainer[i] 155  "..tostring( iPage))

        ---------------------------------------------
        local vLayout = CVerticalLayout :create()
        _pageContainer[iPage] : addChild( vLayout, -99)

        vLayout :setCellSize( CCSizeMake( viewSize.width - 10, viewSize.height / 3.5))
        vLayout :setCellVerticalSpace( 10)
        vLayout :setLineNodeSum( 1)
        vLayout :setVerticalDirection( false)
        vLayout :setPosition( (viewSize.width-20) / 2, viewSize.height * 0.45)

        local lineCount = 3
        for iLine=1, lineCount do
            local _skillBgSpr = CSprite :createWithSpriteFrameName( "general_underframe_normal.png")
            _skillBgSpr   :setControlName("this is CSkillNewUI _skillBgSpr[i] 164  "..tostring( l_nLine))
            _skillBgSpr   :setPreferredSize( self.m_loSkillBtnListSize)---CCSizeMake( viewSize.width-20, viewSize.height / 4.5))

            _skillBgSpr   :setTouchesMode( kCCTouchesAllAtOnce )     --
            _skillBgSpr   :setTouchesEnabled( true)
            _skillBgSpr   :setTouchesPriority( _skillBgSpr :getTouchesPriority() - 50)

            local _nBgTag = l_nLine
            _skillBgSpr   :setTag( _nBgTag )
            _skillBgSpr   :registerControlScriptHandler( clickSkillBtnCallback, "this CSkillNewUI. _skillBgSpr 168"..tostring( _nBgTag) )
            vLayout       :addChild( _skillBgSpr, -99)

            self.m_lpSkillSprList[l_nLine] = _skillBgSpr
            --数量
            if l_nLine >= nAllLine then
                break
            else
                l_nLine = l_nLine + 1
            end
        end
        ---------------------------------------------
        -->>>>技能背景icon
        local vSkillIconLayout = CVerticalLayout :create()
        _pageContainer[iPage] : addChild( vSkillIconLayout, -98)

        vSkillIconLayout :setCellVerticalSpace( 30)
        vSkillIconLayout :setLineNodeSum( 1)
        vSkillIconLayout :setVerticalDirection( false)
        vSkillIconLayout :setPosition( -viewSize.width / 5, viewSize.height * 0.43)

        for iLine=1, lineCount do
            local _skillBgSpr = CSprite :createWithSpriteFrameName( "skill_second_underframe.png")
            _skillBgSpr   :setControlName("this is CSkillNewUI _skillBgSpr[i] 221  "..tostring( l_nIconLine))
            vSkillIconLayout :addChild( _skillBgSpr, -98)

            if l_nIconLine >= nAllLine then
                break
            else
                l_nIconLine = l_nIconLine + 1
            end
        end
        ---------------------------------------------
        -->>>技能里面的图标
        local vSprLayout = CVerticalLayout :create()
        _pageContainer[iPage] : addChild( vSprLayout, -97)

        vSprLayout :setCellVerticalSpace( 30)
        vSprLayout :setLineNodeSum( 1)
        vSprLayout :setVerticalDirection( false)
        vSprLayout :setPosition( -viewSize.width / 5, viewSize.height * 0.43)

        for iLine=1, lineCount do
            --拿.icon确定图片
            local szIconSprName = "IconSkill/is101.png"

            if _dataList[l_nSprLine] ~= nil and _dataList[l_nSprLine].icon ~= nil then
                szIconSprName = "IconSkill/is".._dataList[l_nSprLine].icon..".png"
            end

            local _skillBgSpr = CSprite :create( tostring( szIconSprName ) )
            _skillBgSpr   :setControlName("this is CSkillNewUI _skillBgSpr[i] 253  "..tostring( l_nSprLine))
            --_skillBgSpr   :setScale( self.SCALE_SKILL_ICON)
            vSprLayout :addChild( _skillBgSpr, -97)

            if _dataList[l_nSprLine] ~= nil and tonumber( _dataList[l_nSprLine].m_lv ) == 0 then
                _skillBgSpr :setGray( true )
            end
            if l_nSprLine >= nAllLine then
                break
            else
                l_nSprLine = l_nSprLine + 1
            end
        end
        ---------------------------------------------
        -->>>技能名称  l_nNameLine
        local vNameLayout = CVerticalLayout :create()
        _pageContainer[iPage] : addChild( vNameLayout, -97)

        vNameLayout :setCellVerticalSpace( 32)
        vNameLayout :setLineNodeSum( 1)
        vNameLayout :setVerticalDirection( false)
        vNameLayout :setPosition( 0, viewSize.height * 0.5)

        for iLine=1, lineCount do
            local szLabelName = "技能名称"
            if _dataList[l_nNameLine] ~= nil and _dataList[l_nNameLine].name ~= nil then
                szLabelName = _dataList[l_nNameLine].name       -- .._dataList[l_nNameLine].skill_id
            end
            local _nameLabel = CCLabelTTF :create( tostring( szLabelName), "Arial", 20)
            _nameLabel    :setAnchorPoint( ccp( 0.0, 0.5))
            --print("this is CSkillNewUI _nameLabel[i] 253  "..tostring( l_nNameLine))
            vNameLayout   :addChild( _nameLabel, -97)

            if l_nNameLine >= nAllLine then
                break
            else
                l_nNameLine = l_nNameLine + 1
            end
        end

        ---<<<<---------------------------------------------
        --技能等级
        local vLvLayout = CVerticalLayout :create()
        _pageContainer[iPage] : addChild( vLvLayout, -97)

        vLvLayout :setCellVerticalSpace( 32)
        vLvLayout :setLineNodeSum( 1)
        vLvLayout :setVerticalDirection( false)
        vLvLayout :setPosition( 0, viewSize.height * 0.42)

        for iLine=1, lineCount do
            local szLabelLv = "等级 0阶0级"
            if  _dataList[l_nLvLine] then
                szLabelLv = self :getLvLabel( l_nLvLine, _dataList)
            end

            local _lvLabel = CCLabelTTF :create( tostring( szLabelLv), "Arial", 20)
            _lvLabel    :setAnchorPoint( ccp( 0.0, 0.5))
            --print("this is CSkillNewUI _lvLabel 296  "..tostring( l_nLvLine))
            vLvLayout   :addChild( _lvLabel, -97)

            self.m_lpSkillLvInfoList[l_nLvLine] = _lvLabel

            if l_nLvLine >= nAllLine then
                break
            else
                l_nLvLine = l_nLvLine + 1
            end
        end

    end

    ---添加页面
    for iPage=nPage, 1, -1 do
        self.m_pScrollView :addPage( _pageContainer[iPage])
    end

    self.m_pScrollView :setPage( nPage - 1, false)

    local nMic = 8
    local leftBgX =  self.m_lpLeftBgSprSize.width * 0.0296 + nMic
    local leftBgY =  self.m_lpLeftBottemSprSize.height +  3.0 * nMic
    self.m_pScrollView :setPosition( leftBgX, leftBgY)

    if self :getCurrentViewId() == CSkillNewUI.TAG_MAIN_ROLE then
        self :initEquipSpr( _dataList)
    end
end

function CSkillNewUI.getLvLabel( self, _nCount, _dataList)
    _nCount = tonumber( _nCount)
    local szLabelLv = nil
    if _dataList[_nCount].m_lv == nil then
        return
    end
    local nLv = _dataList[_nCount].m_lv
    --print("", _dataList[_nCount].m_lv, nLv, _G.Constant.CONST_SKILL_LV_MAX)
    if nLv ~= nil and nLv < 0 or nLv > _G.Constant.CONST_SKILL_LV_MAX then
        --print("errorlv", nLv, _dataList[_nCount].m_lv)
        --szLabelLv = "等级 0阶0级"
    end
    if nLv >= 0 and nLv <= _G.Constant.CONST_SKILL_LV_MAX then
        local nTen = math.modf( nLv / 10)
        local nSin = nLv % 10
        szLabelLv = "等级 "..tostring( nTen).."阶"..tostring( nSin).."级"
    end
    return szLabelLv
end

--{技能信息}
function CSkillNewUI.addSkillInfoView( self)
    if self.m_skillInfoLayer ~= nil then
        self.m_skillInfoLayer :removeFromParentAndCleanup( true)
        self.m_skillInfoLayer = nil
    end
    if self :judgementIsSelf() == false then
        return
    end
    self.m_skillInfoLayer  = CContainer :create()
    self.m_pContainer :addChild( self.m_skillInfoLayer )

    local szFontName = "Arial"
    local nFontSize = 20

    self.m_lpEffectLabel = CCLabelTTF :create( "技能效果:", szFontName, nFontSize)    --技能效果
    self.m_lpNeedLvLabel = CCLabelTTF :create( "所需等级:", szFontName, nFontSize)    --所需等级
    self.m_lpNeedDollerLabel = CCLabelTTF :create( "所需美刀:", szFontName, nFontSize)    --所需美刀
    self.m_lpNeedPowerLabel = CCLabelTTF :create( "所需潜能:", szFontName, nFontSize)    --所需潜能
    self.m_lpPowerLabel = CCLabelTTF :create( "当前潜能:", szFontName, nFontSize)    --当前潜能

    self.m_lpEffectLabel :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_lpEffectLabel :setDimensions( CCSizeMake( self.m_lpRightBgSprSize.width - 30, 100 ))
    self.m_lpNeedLvLabel :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_lpNeedDollerLabel :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_lpNeedPowerLabel :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_lpPowerLabel :setAnchorPoint( ccp( 0.0, 0.5))

    self.m_lpEffectLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.m_lpNeedLvLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.m_lpNeedDollerLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.m_lpNeedPowerLabel :setHorizontalAlignment( kCCTextAlignmentLeft)
    self.m_lpPowerLabel :setHorizontalAlignment( kCCTextAlignmentLeft)

    self.m_lpNeedLvLabel :setColor( ccc3( 255, 255, 0))
    self.m_lpNeedDollerLabel :setColor( ccc3( 255, 255, 0))
    self.m_lpNeedPowerLabel :setColor( ccc3( 255, 255, 0))

    self.m_lpLineSpr = CSprite :createWithSpriteFrameName( "general_dividing_line.png") --分割线
    self.m_lpLineSpr :setControlName("this CSkillNewUI. self.m_lpLineSpr 205")
    self.m_lpLineSpr :setPreferredSize( CCSizeMake( self.m_lpRightBgSprSize.width - 20, 1) )


    local function updateCallback( eventType, obj, x, y)
        return self :onUpdateCallback( eventType, obj, x, y)
    end
    self.m_lpUpdateBtn = CButton :createWithSpriteFrameName( "升级", "general_button_normal.png")
    self.m_lpUpdateBtn :setFontSize( 30)
    --self.m_lpUpdateBtn :setHightLight()
    self.m_skillInfoLayer :addChild( self.m_lpUpdateBtn)

    self.m_lpUpdateBtn :registerControlScriptHandler( updateCallback, "this CSkillNewUI. self.m_lpUpdateBtn 225")
    local updateBtnSize = self.m_lpUpdateBtn : getPreferredSize()
    local updateX = self.m_lpLeftBgSprSize.width + self.m_lpRightBgSprSize.width / 2 + 15
    local updateY = self.m_lpRightBottemSprSize.height + updateBtnSize.height
    self.m_lpUpdateBtn :setControlName("this CSkillNewUI. self.m_lpUpdateBtn 230")
    self.m_lpUpdateBtn :setPosition( updateX, updateY )

    for k, v in pairs( self.m_tableStudySkillList) do
        --print( "", k, self.m_tableXmlInfo[1].skill_id)
        if tonumber(k) == self.m_tableXmlInfo[1].skill_id then
            self.m_lpUpdateBtn :setVisible( true)
            break
        end
    end

    self.m_skillInfoLayer :addChild( self.m_lpEffectLabel)
    self.m_skillInfoLayer :addChild( self.m_lpNeedLvLabel)
    self.m_skillInfoLayer :addChild( self.m_lpNeedDollerLabel)
    self.m_skillInfoLayer :addChild( self.m_lpNeedPowerLabel)
    self.m_skillInfoLayer :addChild( self.m_lpPowerLabel)
    self.m_skillInfoLayer :addChild( self.m_lpLineSpr)

end
 
--{装备技能按钮}
function CSkillNewUI.addEquipSkillBtn( self)
    if self.m_equipLayer ~= nil then
        self.m_equipLayer :removeFromParentAndCleanup( true)
        self.m_equipLayer = nil
    end

    if self :judgementIsSelf() == false then
        return
    end
    self.m_equipLayer  = CContainer :create()
    self.m_pContainer :addChild( self.m_equipLayer)

    self.m_lpEquipLabel = CCLabelTTF :create( "点击下面技能栏可装备此技能", "Arial", 25)
    --print("this CSkillNewUI . self.m_lpEquipLabel 202")
    self.m_lpEquipLabel :setColor( ccc3( 255, 255, 0))

    self.m_lpEquipBtn1 = CButton :createWithSpriteFrameName( "", "skill_number_1.png")
    self.m_lpEquipBtn2 = CButton :createWithSpriteFrameName( "", "skill_number_2.png")
    self.m_lpEquipBtn3 = CButton :createWithSpriteFrameName( "", "skill_number_3.png")

    self.m_lpEquipBtn1 :setControlName("this CSkillNewUI. self.m_lpEquipBtn1 205")
    self.m_lpEquipBtn2 :setControlName("this CSkillNewUI. self.m_lpEquipBtn2 206")
    self.m_lpEquipBtn3 :setControlName("this CSkillNewUI. self.m_lpEquipBtn3 207")

    self.m_equipLayer :addChild( self.m_lpEquipBtn1, -99)
    self.m_equipLayer :addChild( self.m_lpEquipBtn2, -99)
    self.m_equipLayer :addChild( self.m_lpEquipBtn3, -99)
    self.m_equipLayer :addChild( self.m_lpEquipLabel, -99)

    local function equipCallback( eventType, obj, x, y)
        return self :onEquipCallback( eventType, obj, x, y)
    end


    self.m_lpEquipBtn1  :setTag( self.TAG_EQUIP_BTN1)
    self.m_lpEquipBtn2  :setTag( self.TAG_EQUIP_BTN2)
    self.m_lpEquipBtn3  :setTag( self.TAG_EQUIP_BTN3)

    self.m_lpEquipBtn1  :registerControlScriptHandler( equipCallback, "this CSkillNewUI. self.m_lpEquipBtn1 268")
    self.m_lpEquipBtn2  :registerControlScriptHandler( equipCallback, "this CSkillNewUI. self.m_lpEquipBtn2 269")
    self.m_lpEquipBtn3  :registerControlScriptHandler( equipCallback, "this CSkillNewUI. self.m_lpEquipBtn3 270")

end

function CSkillNewUI.createRoleView( self, _nRoleTag)
    --print("角色   ".._nRoleTag, self :getCurrentViewId(), " 伙伴数量 ", self.m_partnerconut)
    if self :getCurrentViewId() == _nRoleTag or self.m_partnerconut <= 0 then
        print("相同界面 不切换")
        return
    end

    self :setCurrentViewId( _nRoleTag)
    --请求新得界面得同时需要清空partner数据
    --_G.g_SkillDataProxy :cleanPartnerSkillData()
    print("当前界面", self :getCurrentViewId())
    if _nRoleTag == CSkillNewUI.TAG_MAIN_ROLE then
        self :cleanSmallIcon()
        self :removeThreeLayer()
        local function func()
            self :initData()
            if self.m_tableXmlInfo==nil then
                return
            end
            self :addSkillBtn( self.m_tableXmlInfo)

            if self :judgementIsSelf() == true then
                self :addSkillInfoView()
                --self :addEquipSkillBtn()
                if self.m_equipLayer ~= nil then
                    self.m_equipLayer :setVisible( true )
                end
                self :layout()
                --初始化第一个界面  默认第一个技能按钮
                if self.m_lpSkillSprList ~= nil then
                    self :setCurrentClickBtn( self.m_lpSkillSprList[1] )
                    self :setRightInfoView( self.m_tableXmlInfo)
                    self.m_lpSkillSprList[1] :setImageWithSpriteFrameName("general_underframe_click.png")
                    self.m_lpSkillSprList[1] :setPreferredSize( self.m_loSkillBtnListSize)
                end
            end
        end
        local actarr = CCArray :create()
        local dela = CCDelayTime :create( 0.01 )
        local temp = CCCallFunc : create( func )
        actarr :addObject( dela)
        actarr :addObject( temp)
        local seq = CCSequence:create(actarr)
        self.m_retContainer :runAction( seq )

        return true
    end
    print("点击了伙伴，现在开始请求伙伴技能", _nRoleTag, self :getRoleUid())
    --self.m_partneridlist
    self :requestPartnerId( self :getRoleUid(), tonumber( _nRoleTag))
end

function CSkillNewUI.requestPartnerId( self, _uid, _nId)
    local msg = REQ_SKILL_PARTNER()
    if self :judgementIsSelf() == true then
        _uid = 0    --若是本人，则请求0
    end
    --print("CSkillNewUI.requestPartnerId", _uid, _nId)
    if _uid == nil then
        print("空空空，怎么回事,通知前端1", _uid)
        _uid =0
    end
    if _nId == nil then
        print("空空空，怎么回事,通知前端2", _nId)
        _nId =0
    end

    msg :setUid( _uid )
    msg :setParentid( _nId)
    CNetwork :send( msg)
end

function CSkillNewUI.removeLayer( self)
    self :removeThreeLayer()
    if self.m_roleLayer ~= nil then
        self.m_roleLayer : removeFromParentAndCleanup( true)
        self.m_roleLayer = nil
    end
end

function CSkillNewUI.removeThreeLayer( self)
    if self.m_equipLayer ~= nil then
        --[[self.m_equipLayer : removeFromParentAndCleanup( true)
        self.m_equipLayer = nil
         --]]
        CCLOG("CSkillNewUI.removeThreeLayer", self.m_equipLayer)
        self.m_equipLayer :setVisible( false )
    end
    if self.m_skillInfoLayer ~= nil then
        self.m_skillInfoLayer : removeFromParentAndCleanup( true)
        self.m_skillInfoLayer = nil
    end
    if self.m_pScrollView ~= nil then
        self.m_pScrollView : removeFromParentAndCleanup( true)
        self.m_pScrollView = nil
    end
end

function CSkillNewUI.addMediator( self )
	self : removeMediator()

    _G.g_CSkillMediator = CSkillMediator( self)
    controller :registerMediator( _G.g_CSkillMediator)
end

function CSkillNewUI.removeMediator( self )
    if _G.g_CSkillMediator ~= nil then
        controller :unregisterMediator( _G.g_CSkillMediator)
        _G.g_CSkillMediator = nil
    end
end

function CSkillNewUI.layout( self )
	-- body
	--local winX = self.m_winSize.width
	--local winY = self.m_winSize.height

    local _windowSize = CCDirector :sharedDirector() :getVisibleSize()
    local winX = _windowSize.width
    local winY = _windowSize.height

	if winY == 640 then
        if self.m_pWindowBg ~= nil then
            self.m_pWindowBg   :setPreferredSize( CCSizeMake( winX, winY))
            self.m_pWindowBg   :setPosition( ccp( winX / 2, winY / 2) )

            self.m_pBackground :setPreferredSize( CCSizeMake( self.m_winSize.width, self.m_winSize.height))
            self.m_pBackground :setPosition( ccp( winX / 2, winY / 2) )

            local closeBtnSize = self.m_pCloseBtn  :getPreferredSize()
            self.m_pCloseBtn  :setPosition( ccp( (_windowSize.width-self.m_winSize.width) / 2 + self.m_winSize.width - closeBtnSize.width / 2 - 5 , winY - closeBtnSize.height / 2 - 5))
        end

        if self.m_pContainer then
            self.m_pContainer :setPosition( (_windowSize.width - self.m_winSize.width)/2, (_windowSize.height-self.m_winSize.height) / 2 + 15)
        end
        local nMic = 15--8
        --左边
        local leftBgX = self.m_lpLeftBgSprSize.width / 2 + nMic
        local leftBgY = self.m_lpLeftBgSprSize.height / 2 + self.m_lpLeftBottemSprSize.height + 5--2 * nMic
        self.m_lpLeftBgSpr      :setPosition( leftBgX, leftBgY)
        --左下
        local leftBottemX = self.m_lpLeftBottemSprSize.width / 2 + nMic
        local leftBottemY = self.m_lpLeftBottemSprSize.height / 2 --+ nMic
        self.m_lpLeftBottemSpr  :setPosition( leftBottemX, leftBottemY)
        --右边
        local rightX = self.m_lpRightBgSprSize.width / 2 + self.m_lpLeftBgSprSize.width + nMic + 5--2 * nMic
        local rightY = self.m_lpRightBottemSprSize.height + self.m_lpRightBgSprSize.height / 2 + nMic-- 2 * nMic
        self.m_lpRightBgSpr     :setPosition( rightX, rightY)
        --右下
        local rightBottemX = self.m_lpRightBottemSprSize.width + self.m_lpLeftBottemSprSize.width / 2 + nMic + 10-- 2 * nMic
        local rightBottemY = self.m_lpRightBottemSprSize.height / 2 --+ nMic
        self.m_lpRightBottemSpr :setPosition( rightBottemX,  rightBottemY)

        if self.m_equipLayer ~= nil then
            local equipBtnSize = self.m_lpEquipBtn1 :getPreferredSize()
            local equipX = self.m_lpLeftBottemSprSize.width + equipBtnSize.width
            local equipY = equipBtnSize.height * 0.81
            self.m_lpEquipBtn1 :setPosition( equipX, equipY)
            self.m_lpEquipBtn2 :setPosition( equipX + equipBtnSize.width * 1.3, equipY)
            self.m_lpEquipBtn3 :setPosition( equipX + equipBtnSize.width * 2.6, equipY)
            self.m_lpEquipLabel :setPosition( equipX + equipBtnSize.width, equipY * 2.0)
        end

        if self.m_skillInfoLayer ~= nil then
            local labelX = self.m_lpLeftBottemSprSize.width + 40
            local labelY = self.m_lpRightBgSprSize.height + self.m_lpRightBottemSprSize.height
            self.m_lpEffectLabel    :setPosition( labelX, labelY * 0.90)   --技能效果
            self.m_lpNeedLvLabel    :setPosition( labelX, labelY * 0.77)   --所需等级
            self.m_lpNeedDollerLabel :setPosition( labelX, labelY * 0.71)       --所需美刀
            self.m_lpNeedPowerLabel :setPosition( labelX, labelY * 0.65)     --所需潜能
            self.m_lpPowerLabel     :setPosition( labelX + 200, labelY * 0.65)     --当前潜能

            local lineSize = self.m_lpLineSpr :getPreferredSize()
            local lineX = self.m_lpRightBgSprSize.width / 2 + self.m_lpLeftBgSprSize.width + 2 * nMic
            local lineY = self.m_lpRightBottemSprSize.height * 1.6
            self.m_lpLineSpr        :setPosition( lineX, lineY)    --分割线
        end

        if self :judgementIsSelf() == false then
            self.m_lpRightBgSpr     : setVisible( false )
            self.m_lpRightBottemSpr : setVisible( false )
        end
	elseif winY == 768 then

	end
end

--清除当前层并注销mediator
function CSkillNewUI.removeAll( self)
    self :removeMediator()
    if self.m_pContainer ~= nil then
        self.m_pContainer : removeFromParentAndCleanup( true)
        self.m_pContainer = nil
    end
end
---------callback
function CSkillNewUI.onCloseCallBack( self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )

    elseif eventType == "TouchEnded" then
    	self :removeAll()
		CCDirector :sharedDirector() :popScene()
    end
end

function CSkillNewUI.onRoleBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )

    elseif eventType == "TouchEnded" then
        print("角色按钮", obj :getTag())

        self : addHightLightRoleBtn( obj)
        --显示不同角色的技能界面
        self :createRoleView( tonumber( obj :getTag()))

    end
end


function CSkillNewUI.onClickSkillBtnCallback( self, eventType, obj, touches )
    --print( "\n技能按钮显示点击" .. eventType, obj :isVisibility() )
    if eventType == "TouchesBegan" then
        --点击异常判断
        if obj :isVisibility() == false then
            return
        end

        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.touchSkillId = obj :getTag()
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
            if touch2:getID() == self.touchID and self.touchSkillId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                    local nTag = obj :getTag()
                    ---add code here
                    print("nTag", nTag)
                    --技能按钮
                    if self.m_lpSkillSprList ~= nil then
                        for k, v in pairs( self.m_lpSkillSprList) do
                            --print(k , v)
                            if v :getTag() == nTag then
                                v :setImageWithSpriteFrameName("general_underframe_click.png")
                                self :setCurrentClickBtn( v)         --保存当前点击的图片位置
                            else
                                v :setImageWithSpriteFrameName("general_underframe_normal.png")
                            end

                            v :setPreferredSize( self.m_loSkillBtnListSize)
                        end
                    end

                    if self :judgementIsSelf() == false then
                        return
                    end

                    if self :getCurrentViewId() == 10 and self.m_tableXmlInfo then
                        self :setRightInfoView( self.m_tableXmlInfo)   --tonumber(nTag))
                    else
                        if self.m_partnerDataInfo then
                            self :setRightInfoView( self.m_partnerDataInfo)
                        end
                    end

                    self:setGuideStepFinish()

                    self.touchID     = nil
                    self.touchSkillId = nil
                    break
                end
            end
        end
        return true
        --print( eventType,"END")
    end
end


function CSkillNewUI.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end

function CSkillNewUI.onUpdateCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )

    elseif eventType == "TouchEnded" then

        if self :getCurrentClickBtn() then
            local nClickSkill = self :getCurrentClickBtn() :getTag()

            print("self :getCurrentClickBtn()", nClickSkill, self :getCurrentViewId())

            if self.m_tableXmlInfo[nClickSkill] then
                if self.m_tableMoneyList then
                    print("升级是需要钱的", self.m_tableMoneyList.rmb, self.m_tableMoneyList.bind_rmb, self.m_tableMoneyList.power, self.m_tableMoneyList.gold)
                end
                local nViewId = tonumber(self :getCurrentViewId())

                --比较当前等级 美刀 潜能是否足够升级
                local nNeedPower    = 0
                local nNeedDoller   = 0
                local nNeedLv       = 0

                if nViewId == CSkillNewUI.TAG_MAIN_ROLE then

                    if self.m_tableXmlInfo == nil then
                        print( debug.traceback())
                        return
                    end
                    nNeedPower    = tonumber(self.m_tableXmlInfo[nClickSkill].power)
                    nNeedDoller   = tonumber(self.m_tableXmlInfo[nClickSkill].doller)
                    nNeedLv       = tonumber(self.m_tableXmlInfo[nClickSkill].must_lv)
                else
                    if self.m_partnerDataInfo == nil then
                        print( debug.traceback())
                        return
                    end
                    nNeedPower    = tonumber(self.m_partnerDataInfo[nClickSkill].power)
                    nNeedDoller   = tonumber(self.m_partnerDataInfo[nClickSkill].doller)
                    nNeedLv       = tonumber(self.m_partnerDataInfo[nClickSkill].must_lv)
                end
                if nNeedPower > tonumber(self.m_tableMoneyList.power) then
                    --CCMessageBox( "潜能不足，无法升级", self.m_tableMoneyList.power)
                    local msg = "   潜能不足，无法升级"
                    self : createMessageBox(msg)
                    return true
                end
                if nNeedDoller > tonumber(self.m_tableMoneyList.gold) then
                    --CCMessageBox( "   货币不足，无法升级", self.m_tableMoneyList.gold)
                    local msg = "货币不足，无法升级"
                    self : createMessageBox(msg)
                    return true
                end
                if nNeedLv > self.m_role_lv then
                    --CCMessageBox( "   等级不足，无法升级", self.m_tableMoneyList.gold)
                    local msg = "等级不足，无法升级"
                    self : createMessageBox(msg)
                    return true
                end

                local nId = tonumber(self.m_tableXmlInfo[nClickSkill].skill_id)
                local nLv = tonumber(self.m_tableXmlInfo[nClickSkill].m_lv)


                print("升级请求", nClickSkill, nId, nLv, nViewId)

                if nViewId == CSkillNewUI.TAG_MAIN_ROLE then
                    local lMsg = REQ_SKILL_LEARN()
                    lMsg :setSkillId( nId)
                    lMsg :setLv( nLv)
                    CNetwork :send( lMsg)
                else
                    local lMsg = REQ_SKILL_UPPARENTLV()
                    lMsg :setParentid( nViewId)
                    lMsg :setSkillId( self.m_partnerDataInfo[nClickSkill].skill_id)
                    lMsg :setLv( self.m_partnerDataInfo[nClickSkill].m_lv)
                    CNetwork :send( lMsg)

                    print("伙伴－－－－－－", self.m_partnerDataInfo[nClickSkill].skill_id, self.m_partnerDataInfo[nClickSkill].m_lv)
                    self.m_nClickSkill = nClickSkill        --所点的技能区域
                end
            end
        end
    end

end

function CSkillNewUI.onEquipCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )

    elseif eventType == "TouchEnded" then
        local nTag  = obj :getTag()

        self :setGuideStepFinish()

        if self.m_tableXmlInfo == nil or self :getCurrentClickBtn() == nil then
            return
        end
        local nMark = self :getCurrentClickBtn() :getTag()      --当前所选技能按钮
        print("装备按钮", nTag, nMark, self.m_tableXmlInfo[nMark].skill_id, self.m_tableXmlInfo[nMark].icon, self.m_tableXmlInfo[nMark].must_lv)

        local isV = false
        if self.m_tableStudySkillList ~= nil then
            for key, value in pairs( self.m_tableStudySkillList ) do
                if tonumber( key ) == tonumber( self.m_tableXmlInfo[nMark].skill_id ) then
                    isV = true
                    break
                end
                --print("zssss", key, value.skill_id, self.m_tableXmlInfo[nMark].skill_id, self.m_role_lv, self.m_tableXmlInfo[nMark].must_lv, isV)
            end
        end

        if isV == true then
            if self.m_sprEquipFrame ~= nil then
                self.m_sprEquipFrame :removeFromParentAndCleanup( true)
                self.m_sprEquipFrame = nil
            end
            self.m_sprEquipFrame = CSprite :createWithSpriteFrameName("skill_first_underframe.png")
            obj :addChild( self.m_sprEquipFrame, -98)
        else
            --CCMessageBox( "等级不够，尚未学习技能，无法装备1", self.m_role_lv)
            local msg = "等级不够，尚未学习技能，无法装备"
            self : createMessageBox(msg)
            return
        end

        if self.m_role_lv < tonumber( self.m_tableXmlInfo[nMark].must_lv) then
            --CCMessageBox( "等级不够，尚未学习技能，无法装备1", self.m_role_lv)
            local msg = "等级不够，尚未学习技能，无法装备"
            self : createMessageBox(msg)
            return
        end

        --self :addEquipIconById( self.m_tableXmlInfo[nMark].skill_id, obj)
        --[[
        if self.m_tableXmlInfo[nMark].icon then
            --CCMessageBox("self.m_tableXmlInfo[nMark].icon", self.m_tableXmlInfo[nMark].icon)
            if self["m_sprSkillIcon"..nMark] ~= nil then
                self["m_sprSkillIcon"..nMark] :removeFromParentAndCleanup( true)
                self["m_sprSkillIcon"..nMark] = nil
            end
            self["m_sprSkillIcon"..nMark] = CSprite :createWithSpriteFrameName("skill_icon.png")
            obj :addChild( self["m_sprSkillIcon"..nMark], 10)
        end
         --]]

        local msg = REQ_SKILL_EQUIP()
        msg :setEquipPos( tonumber( nTag))
        msg :setSkillId( tonumber( self.m_tableXmlInfo[nMark].skill_id))
        CNetwork :send( msg)
        print("装备技能请求", msg :getEquipPos(), msg :getSkillId())
    end
end

--装备显示效果对应技能id
function CSkillNewUI.addEquipIconById( self, _id, _obj)
    if _id == nil or _obj == nil then
        return
    end

    if self["m_sprSkillIcon".._id] ~= nil then
        self["m_sprSkillIcon".._id] :removeFromParentAndCleanup( true)
        self["m_sprSkillIcon".._id] = nil
    end

    local skillNode = _G.g_SkillDataProxy :getSkillById( tostring( _id))
    --print("打印下哈哈 ", skillNode)
    if skillNode :isEmpty()then
        return
    end

    local szSprName = "IconSkill/is101.png"

    if skillNode:getAttribute("icon") ~= nil then
        szSprName = "IconSkill/is"..skillNode:getAttribute("icon")..".png"
    end

    --print("需要拼接技能图片的地方", szSprName)         --等资源
    self["m_sprSkillIcon".._id] = CSprite :create( tostring( szSprName ) )
    _obj :addChild( self["m_sprSkillIcon".._id], 10)

end

--先清空所有的icon再初始化
function CSkillNewUI.cleanClickEquipIcon( self)
    if self.m_tableStudySkillList ~= nil then
        for k, v in pairs( self.m_tableStudySkillList) do
            --print("", k, v)
            if self["m_sprSkillIcon"..k] ~= nil then
                self["m_sprSkillIcon"..k] :removeFromParentAndCleanup( true)
                self["m_sprSkillIcon"..k] = nil
            end
        end
    end

    print("清空装备icon", self.proxy)
end

--{初始化装备按钮上的icon}
function CSkillNewUI.initEquipBtnIcon( self)
    local l_equip_list = self.m_tableEquipList
    if l_equip_list ~= nil then
        for k, v in pairs( l_equip_list) do

            if self.m_equipLayer ~= nil then
                local _btn = self.m_equipLayer :getChildByTag( k)

                if _btn ~= nil then
                    self :addEquipIconById( v.skill_id, _btn)
                end
            end

        end
    else
        CCLOG("装备技能信息为空-->", l_equip_list)
    end
end

function CSkillNewUI.cleanSmallIcon( self)
    if self.m_lpEquipSprFirst then
        self.m_lpEquipSprFirst :removeFromParentAndCleanup( true)
        self.m_lpEquipSprFirst = nil
    end
    if self.m_lpEquipSprSecond then
        self.m_lpEquipSprSecond :removeFromParentAndCleanup( true)
        self.m_lpEquipSprSecond = nil
    end
    if self.m_lpEquipSprThird then
        self.m_lpEquipSprThird :removeFromParentAndCleanup( true)
        self.m_lpEquipSprThird = nil
    end
    if self :getCurrentViewId() ~= CSkillNewUI.TAG_MAIN_ROLE then
        if self.m_sprEquipFrame ~= nil then
            self.m_sprEquipFrame :removeFromParentAndCleanup( true)
            self.m_sprEquipFrame = nil
        end
        if self.m_sprSkillIcon ~= nil then
            self.m_sprSkillIcon :removeFromParentAndCleanup( true)
            self.m_sprSkillIcon = nil
        end
    end
end

function CSkillNewUI.initEquipSpr( self, _dataList)
    if self == nil or _dataList == nil or self.m_lpSkillSprList == nil then
        print("查看问题")
        return
    end
    print("CSkillNewUI.initEquipSpr", self :judgementIsSelf() )
    if self :judgementIsSelf() == false then
        return
    end
    self :cleanSmallIcon()
    for k, v in pairs( _dataList) do
        print("equipPos", v.equip_pos, v.skill_id)
        if v.equip_pos == CSkillNewUI.TAG_EQUIP_BTN1 then
            self.m_lpEquipSprFirst = CSprite :createWithSpriteFrameName("skill_number_small1.png")
            self.m_lpEquipSprFirst :setControlName("this CSkillNewUI. self.m_lpEquipSprFirst 836")
            if self.m_lpSkillSprList[k] then
                local sprSize = self.m_lpEquipSprFirst :getPreferredSize()
                self.m_lpEquipSprFirst   :setPosition( self.m_lpLeftBgSprSize.width / 2 - sprSize.width, 0)
                self.m_lpSkillSprList[k] :addChild( self.m_lpEquipSprFirst, 10)
            end

        elseif v.equip_pos == CSkillNewUI.TAG_EQUIP_BTN2 then
            self.m_lpEquipSprSecond = CSprite :createWithSpriteFrameName("skill_number_small2.png")
            self.m_lpEquipSprSecond :setControlName("this CSkillNewUI. self.m_lpEquipSprSecond 841")
            if self.m_lpSkillSprList[k] then
                local sprSize = self.m_lpEquipSprSecond :getPreferredSize()
                self.m_lpEquipSprSecond   :setPosition( self.m_lpLeftBgSprSize.width / 2 - sprSize.width, 0)
                self.m_lpSkillSprList[k] :addChild( self.m_lpEquipSprSecond, 10)
            end

        elseif v.equip_pos == CSkillNewUI.TAG_EQUIP_BTN3 then
            self.m_lpEquipSprThird = CSprite :createWithSpriteFrameName("skill_number_small3.png")
            self.m_lpEquipSprThird :setControlName("this CSkillNewUI. self.m_lpEquipSprThird 847")
            if self.m_lpSkillSprList[k] then
                local sprSize = self.m_lpEquipSprThird :getPreferredSize()
                self.m_lpEquipSprThird   :setPosition( self.m_lpLeftBgSprSize.width / 2 - sprSize.width, 0)
                self.m_lpSkillSprList[k] :addChild( self.m_lpEquipSprThird, 10)
            end
        end
    end
end
----------setView
function CSkillNewUI.setCurrentClickBtn( self, _btn)
    if self.m_sprEquipFrame ~= nil then
        self.m_sprEquipFrame :removeFromParentAndCleanup( true)
        self.m_sprEquipFrame = nil
    end
    if self.m_sprSkillIcon ~= nil then
        self.m_sprSkillIcon :removeFromParentAndCleanup( true)
        self.m_sprSkillIcon = nil
    end
    if self.m_lpCurrentBtn == nil then
        self.m_lpCurrentBtn = {}
    end
    self.m_lpCurrentBtn = _btn
end

function CSkillNewUI.getCurrentClickBtn( self)
    if self.m_lpCurrentBtn == nil then
        return nil
    end
    return self.m_lpCurrentBtn
end



------------------------
function CSkillNewUI.setRightInfoView( self, _dataList)
    if self :getCurrentViewId() == CSkillNewUI.TAG_MAIN_ROLE and _dataList== nil and self.m_tableXmlInfo then
        _dataList = self.m_tableXmlInfo
    end

    if _dataList == nil then
        return
    end

    --print("右边的技能信息显示", self :getCurrentClickBtn(), _dataList, self :judgementIsSelf(), self :getCurrentViewId())

    if self :judgementIsSelf() == false then
        return
    end
    local _nTag = nil
    if self :getCurrentClickBtn() then
        _nTag = self :getCurrentClickBtn() :getTag()
    end
    if _nTag == nil or _nTag < 0 or _dataList == nil or _dataList[_nTag] == nil then
        return
    end


    self.m_lpEffectLabel     :setString("技能效果:".._dataList[_nTag].remark)    --技能效果
    self.m_lpNeedLvLabel     :setString("所需等级:".._dataList[_nTag].must_lv)    --所需等级
    self.m_lpNeedDollerLabel :setString("所需美刀:".._dataList[_nTag].doller)    --所需美刀
    self.m_lpNeedPowerLabel  :setString("所需潜能:".._dataList[_nTag].power)    --所需潜能
    local szPower = 0
    if self.m_tableMoneyList.power then
        szPower = self.m_tableMoneyList.power
    end
    self.m_lpPowerLabel      :setString("当前潜能:"..szPower)    --当前潜能

    local nMaxLv = tonumber(_dataList[_nTag].lv_max)
    local isUpdateBtn = false
    if _dataList[_nTag].m_lv > 0 and _dataList[_nTag].m_lv < nMaxLv then
        isUpdateBtn = true
        --elseif _dataList[_nTag].m_lv == nMaxLv then
        --CCMessage("恭喜！技能[".._dataList[_nTag].name.."]达到最大等级", "")
    end
    self.m_lpUpdateBtn :setVisible( isUpdateBtn)

    --显示等级
    local szLvLabel = self :getLvLabel( _nTag, _dataList)
    self.m_lpSkillLvInfoList[_nTag] :setString( szLvLabel)
end

function CSkillNewUI.setEquipView( self)
    if self.m_tableEquipList == nil then
        return
    end
    self :initData()

    if self.m_tableXmlInfo and  self :getCurrentViewId() == CSkillNewUI.TAG_MAIN_ROLE then
        self :initEquipSpr( self.m_tableXmlInfo)
    end
end

--临时新增伙伴界面
function CSkillNewUI.setPartnerView( self)
    self :initData()
    --初始化伙伴技能显示  及升级界面
    local partnerList = self.m_partnerList

    if partnerList == nil then
        return
    end

    if self.m_partnerData ~= nil then
        table.remove( self.m_partnerData)
        self.m_partnerData = nil
    end
    local nCount = 1
    self.m_partnerData = {}
    for k, v in pairs( partnerList) do
        self.m_partnerData[nCount] = {}
        self.m_partnerData[nCount].skill_id = v.m_skillID
        self.m_partnerData[nCount].skill_lv = v.m_lv
        nCount = nCount + 1
    end

    if self.m_partnerDataInfo ~= nil then
        table.remove( self.m_partnerDataInfo)
        self.m_partnerDataInfo = nil
    end
    self.m_partnerDataInfo = {}
    for i=1, #self.m_partnerData  do
        --print("伙伴技能id  ", self.m_partnerData[i].skill_id, self.m_partnerData[i].skill_lv)
        local skillNode = _G.g_SkillDataProxy :getSkillById( tostring( self.m_partnerData[i].skill_id))
        if skillNode:isEmpty() then
            return
        end

        self.m_partnerDataInfo[i]       = {}
        self.m_partnerDataInfo[i].skill_id         = self.m_partnerData[i].skill_id

        self.m_partnerDataInfo[i].m_lv             = self.m_partnerData[i].skill_lv
        self.m_partnerDataInfo[i].pro              = skillNode:getAttribute("pro")                     --职业
        self.m_partnerDataInfo[i].battle_remark    = skillNode:getAttribute("battle_remark")           --技能所需等级
        self.m_partnerDataInfo[i].lv_max           = skillNode:getAttribute("lv_max")                  --技能最大等级
        local nMaxLv = tonumber( self.m_partnerDataInfo[i].lv_max)

        local nLv = 1
        if self.m_partnerDataInfo[i].m_lv ~= 0 and self.m_partnerDataInfo[i].m_lv < nMaxLv then
            nLv = self.m_partnerDataInfo[i].m_lv + 1
        end
        local lvsChild = skillNode : children()
        local lvsNode = lvsChild:get(0,"lvs")
        local lvNode = lvsNode:selectSingleNode("lv[@lv="..tostring(nLv).."]")
        local upNode = lvNode:children():get(0,"up")
        local mustNode = lvNode:children():get(0,"must")
        self.m_partnerDataInfo[i].remark           = lvNode:getAttribute("remark")     --技能描述
        self.m_partnerDataInfo[i].name             = skillNode:getAttribute("name")                    --技能名字
        self.m_partnerDataInfo[i].icon             = skillNode:getAttribute("icon")                    --技能图标

        self.m_partnerDataInfo[i].doller           = upNode:getAttribute("gold")   --所需美刀
        self.m_partnerDataInfo[i].power            = upNode:getAttribute("power")  --所需潜能
        self.m_partnerDataInfo[i].must_lv          = mustNode:getAttribute("lv")   --所需等级
    end
    --[[
     --]]
    if self.m_partnerDataInfo then
        self :cleanSmallIcon()
        self :removeThreeLayer()

        local function func()
            self :setLinesAndPages( #self.m_partnerData)
            self :addSkillBtn( self.m_partnerDataInfo)
            self :addSkillInfoView()
            self :layout()
            --初始化第一个界面  默认第一个技能按钮
            if self.m_lpSkillSprList ~= nil then
                local nClickSkill = 1
                if self.m_nClickSkill ~= nil and self.m_lpSkillSprList[self.m_nClickSkill] ~= nil then
                    nClickSkill = self.m_nClickSkill
                end
                --print("nClickSkillnClickSkill", self.m_nClickSkill, nClickSkill, self.m_lpSkillSprList[self.m_nClickSkill])
                self :setCurrentClickBtn( self.m_lpSkillSprList[nClickSkill] )
                self :setRightInfoView( self.m_partnerDataInfo )
                if self.m_lpSkillSprList[self.m_nClickSkill] ~= nil then
                    self.m_lpSkillSprList[nClickSkill] :setImageWithSpriteFrameName("general_underframe_click.png")
                    self.m_lpSkillSprList[nClickSkill] :setPreferredSize( self.m_loSkillBtnListSize)
                end
            end
        end
        local actarr = CCArray :create()
        local dela = CCDelayTime :create( 0.01 )
        local temp = CCCallFunc : create( func )
        actarr :addObject( dela)
        actarr :addObject( temp)
        local seq = CCSequence:create( actarr)
        self.m_retContainer :runAction( seq )
    end
end

function CSkillNewUI.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_retContainer   : addChild(BoxLayer,1000)
end

--添加技能强化音效
function CSkillNewUI.playEffectSound(self) --成功特效
    print("专治吹牛逼11")
    if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
        SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/strengthen_success.mp3", false)
    end
end

--[[




 ]]

