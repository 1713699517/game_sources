--Tips 主界面
--物品信息封装
require "common/Constant"
require "view/TipsLayer/GoodsInfoView"

require "view/UniversalBox/OverlappingUseBox"

require "controller/GuideCommand"

CPopupView = class(view, function( self)
    self.m_good     = nil
    self.m_showtype = 0
    self.m_inity    = 0
    self.m_viewType = 0 --0:正常类型 1:神器界面的tips
end)

_G.g_PopupView = CPopupView()

CPopupView.TAG_BUTTON_USE    = 101
CPopupView.TAG_BUTTON_SELL   = 102
CPopupView.TAG_BUTTON_SHOW   = 103
CPopupView.TAG_BUTTON_BUY    = 104
CPopupView.TAG_BUTTON_XIANGQIAN = 105

CPopupView.PRE_LINE_HEIGHT   = 25
CPopupView.PRE_WIDTH         = 350

CPopupView.FONT_SIZE         = 23

CPopupView.GOODS_EQUIPMENTMANUFACTURE1 = 33 --珍宝阁物品制作
CPopupView.GOODS_EQUIPMENTMANUFACTURE2 = 34 --珍宝阁物品制作

--加载资源
function CPopupView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")

    _G.Config:load("config/equip_enchant.xml")
    _G.Config:load("config/goods.xml") 
    _G.Config:load("config/hidden_make.xml")
    _G.Config:load("config/pearl_com.xml")
end

--释放资源
function CPopupView.onLoadResource( self)
end

function CPopupView.initParams( self)
end

function CPopupView.reset( self)
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
       self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
       self.m_scenelayer = nil
    end   
end

--释放成员
function CPopupView.realeaseParams( self)
    --self.m_scenelayer :setFullScreenTouchEnabled( false)
    --self.m_scenelayer :setTouchesEnabled( false)    
    self :onLoadResource()
end

--布局成员
function CPopupView.layout( self, winSize)
    --640    
    if winSize.height == 640 then     
    --768
    elseif winSize.height == 768 then
    end
    self :setPopupViewPosition()
end

--设置Tip的位置 --使其在屏幕内显示
function CPopupView.setPopupViewPosition( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_position.x+self.m_backgroundsize.width > winSize.width then
        self.m_position.x = winSize.width - self.m_backgroundsize.width
    end
    if self.m_position.y-self.m_backgroundsize.height < 0 then
        self.m_position.y = self.m_backgroundsize.height
    end
    print(" CPopupView.setPopupViewPosition: ",self.m_position.x, self.m_position.y,self.m_backgroundsize.height)
    self.m_scenelayer :setPosition( ccp( self.m_position.x, self.m_position.y))
end

--主界面初始化
function CPopupView.init(self, winSize, layer)    
    self :loadResource()
    self :initParams()
    self :initview( layer)
    self :layout( winSize)

    _G.pCGuideManager:initGuide( layer , self.m_good.goods_id )
end

function CPopupView.scene( self, _good, _showtype, _position)
    self.m_good         = _good
    self.m_showtype     = _showtype
    self.m_position     = _position
    ---------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPopupView self.m_scenelayer 127  " )
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CPopupView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPopupView self.m_scenelayer 127  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

 --[[
    Tips位置-在其他位置 只能查看信息 无按钮     0   CONST_GOODS_SITE_OTHERROLE 
    Tips位置-在背包中                        1   CONST_GOODS_SITE_BACKPACK   
    Tips位置-在角色身上                      2   CONST_GOODS_SITE_ROLEBODY   
    Tips位置-在角色身上背包中                 3   CONST_GOODS_SITE_ROLEBACKPACK   
    Tips位置-在神器界面中                    4   CONST_GOODS_SITE_ARTIFACT  
    Tips位置-在珍宝阁中                      5   CONST_GOODS_SITE_TREASURE
--]]

-- _good      物品             2001协议数据
-- _showtype  Tips所在位置常量  0 1 2 3 4
-- _position  鼠标点击位置      Tips左上角所在位置自动调节
-- _partnerid 角色，伙伴ID      角色 0  伙伴 id
-- _func      按钮回调 ？？？
function CPopupView.create( self, _good, _showtype, _position, _partnerid,_func)
    self.m_good        = _good       --物品信息 协议2001
    self.m_showtype    = _showtype   --物品所在位置， 背包， 角色身上， 其他玩家身上
    self.m_position    = _position   --点击位置
    self.m_partnerid   = _partnerid  --0主角  非0伙伴ID
    if self.m_partnerid == nil then
        self.m_partnerid = 0
    end
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CPopupView.createByArtifact( self, _good, _showtype, _str, _fun, _position)
    self.m_good        = _good       --物品信息 协议2001
    self.m_showtype    = _showtype
    self.m_buttonStr   = _str        --物品按钮的文字
    self.m_position    = _position   --点击位置
    self.m_buttonFun   = _fun        --按钮调用的方法
    if self.m_partnerid == nil then
        self.m_partnerid = 0
    end
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CPopupView.createByGoodsId( self, _goodId, _showtype, _position, _partnerid,_func)
    self.m_good        = self :resetGoodsInfo( _goodId )    --物品信息 协议2001
    self.m_showtype    = _showtype   --物品所在位置， 背包， 角色身上， 其他玩家身上
    self.m_position    = _position   --点击位置
    self.m_partnerid   = _partnerid  --0主角  非0伙伴ID
    self.func          = _func       --暂时是给珍宝阁的物品制作中的自动寻路按钮用
    print("self.func",self.func)
    if self.m_partnerid == nil then
        self.m_partnerid = 0
    end
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CPopupView.initview( self, layer)
    print("CPopupView.initview")
    --显示相应的
    local good_type = self.m_good.goods_type
    print( good_type, self.m_good)
    
    if good_type == _G.Constant.CONST_GOODS_EQUIP or good_type == _G.Constant.CONST_GOODS_WEAPON or good_type == _G.Constant.CONST_GOODS_MAGIC then
        print("self :equipBaseInfo()")
        --装备，武器，神器  1 2 5
        self :showEquip()
        elseif good_type == _G.Constant.CONST_GOODS_STERS then
        --宝石 3
        print(" self :gemstoneBaseInfo()")
        self :showGemstone()
        elseif good_type == _G.Constant.CONST_GOODS_MATERIAL then
        --材料 4
        print(" self :materialBaseInfo()")
        self :showMaterial()
        else
        --道具 非 12345
        print(" self :propsBaseInfo()")
        --self :showProps()
        self :showMaterial()
    end
end

--装备基本信息
--_equipment  :装备， 
--_showtype   :显示类型，所在位置，背包，身上，其他玩家身上
--_inity       :位置
function CPopupView.showEquip( self)
    print("CPopupView.showEquip")
    --装备Tips   --统计长度
    self.m_inity = 20
    self.m_inity = self.m_inity + 130 --装备图标，名字，穿戴需求
    self.m_inity = self.m_inity + 27  --分割线
    for i=1,self.m_good.attr_count do
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT
    end
    --附加属性
    for i=1,self.m_good.plus_count do  
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT
    end
    --宝石属性
    local slot_flag = false
    for i=1,self.m_good.slots_count do 
        if self.m_good.slot_group[i].slot_flag == true then
            slot_flag = true
            self.m_inity = self.m_inity + 2*CPopupView.PRE_LINE_HEIGHT
        end
    end
    if slot_flag == true then
        self.m_inity = self.m_inity + 20
    end
    --武器技能
    if self.m_good.wskillId ~= nil then  
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT
    end
    --附魔等阶
    if self.m_good.fumo ~= nil and self.m_good.fumo > 0 then      
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT*2+27
    end
    --宝石评分
    if self.m_good.pearlScore ~= nil then  
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT
    end
    --套装信息
    if self.m_good.suitId ~= nil then   
        self.m_inity = self.m_inity + 6*CPopupView.PRE_LINE_HEIGHT
    end
    --出售价格
    self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT 
    --显示位置，决定是否有按钮
    ----if self.m_showtype ~= _G.Constant.CONST_GOODS_SITE_OTHERROLE then 
    self.m_inity = self.m_inity + 70
    --end
    self.m_inity = self.m_inity + 3    
    
    --装备信息容器
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer : setControlName( "this is CPopupView self.m_tipscontainer 301  " )
    self.m_scenelayer :addChild( self.m_tipscontainer)
    --加载Tips背景图
    local tipsbackground    = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")
    tipsbackground : setControlName( "this CPopupView tipsbackground 310 ")
    tipsbackground :setPreferredSize( CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity))
    self.m_backgroundsize = CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity)
    tipsbackground :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity/2))
    self.m_tipscontainer :addChild( tipsbackground)

    local goodinfoview = CGoodsInfoView()
    self.m_tipscontainer :addChild( goodinfoview :create( self.m_good, 1, self.m_inity))

    --根据showTpye添加button
    print("0000000000000000000--",self.m_showtype)
    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_BACKPACK then           --在背包
        self.m_tipscontainer :addChild( self: createUseButton( -2))
        self.m_tipscontainer :addChild( self: createSellButton( 2))
        self.m_tipscontainer :addChild( self: createShowButton( 0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBACKPACK then    --在角色身上背包
        self.m_tipscontainer :addChild( self: createUseButton( -1))
        self.m_tipscontainer :addChild( self: createShowButton( 1))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBODY then       --在角色身上
        self.m_tipscontainer :addChild( self: createUseButton( -1))
        self.m_tipscontainer :addChild( self: createShowButton( 1))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_OTHERROLE then      --只查看
        --self.m_tipscontainer :addChild( self: createBuyButton( ))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_ARTIFACT  then      --神器界面
        self.m_tipscontainer :addChild( self: createArtifactButton( 0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASURE  then      --在珍宝阁中
        self.m_tipscontainer :addChild( self: createTreasureButton( 0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASUREUNLOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayCopyButton( 0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASURELOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayBuyButton( 0))
    end
 
end

function CPopupView.showGemstone( self)
    print("CPopupView.showGemstone")
    --宝石Tips
    --统计长度
    self.m_inity = 20
    self.m_inity = self.m_inity + 140 --装备图标，名字，穿戴需求
    self.m_inity = self.m_inity + 27  --line
    --self.m_inity = self.m_inity + 2*CPopupView.PRE_LINE_HEIGHT  --宝石属性
    self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT --出售价格
    
    --if self.m_showtype ~= _G.Constant.CONST_GOODS_SITE_OTHERROLE then --显示位置，决定是否有按钮
        print("self.m_showtype",self.m_showtype)
        self.m_inity = self.m_inity + 70
    --end
    self.m_inity = self.m_inity + 3
    --宝石描述
    local goodNode  = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(self.m_good.goods_id).."]") 
    local remark = goodNode :children() :get(0,"f"):getAttribute("strengthen")
    --描述所占长度
    if remark ~= nil then      --描述
        local Remarklabel = CCLabelTTF :create( remark, "Arial", CGoodsInfoView.FONT_SIZE)
        Remarklabel       : setColor( ccc3( 0, 180, 0))
        Remarklabel       : setAnchorPoint( ccp( 0,1))
        Remarklabel       : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐 
        Remarklabel : setDimensions( CCSizeMake(CPopupView.PRE_WIDTH-50,0))  --设置文字区域
        local RemarklabelSize = Remarklabel : getContentSize()
        print("55RemarklabelSize",RemarklabelSize.height)
        self.m_inity = self.m_inity + RemarklabelSize.height
        Remarklabel = nil
    end
    
    --装备信息容器
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer : setControlName( "this is CPopupView self.m_tipscontainer 346  " )
    self.m_scenelayer :addChild( self.m_tipscontainer)
    --加载Tips背景图
    local tipsbackground    = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")
    tipsbackground : setControlName( "this CPopupView tipsbackground 356 ")
    tipsbackground :setPreferredSize( CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity))
    self.m_backgroundsize = CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity)
    tipsbackground :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity/2))
    self.m_tipscontainer :addChild( tipsbackground)
    
    local goodinfoview = CGoodsInfoView()
    self.m_tipscontainer :addChild( goodinfoview :create( self.m_good, 1, self.m_inity))
    
    --根据showTpye添加button
    if self.m_showtype == 1 then        --在背包
        self.m_tipscontainer :addChild( self: createXIANGQIANButton( -2))
        self.m_tipscontainer :addChild( self: createSellButton( 2))
        self.m_tipscontainer :addChild( self: createShowButton( 0))
        elseif self.m_showtype == 2 then
        
    end

end

function CPopupView.showMaterial( self)
    print("CPopupView.showMaterial   self.m_showtype="..self.m_showtype..self.m_good.goods_id)
    -- body
    --装备Tips
    --统计长度
    self.m_inity = 20
    self.m_inity = self.m_inity + 140 --装备图标，名字，穿戴需求
    self.m_inity = self.m_inity + 27*2  --基础属性
    --if self.m_showtype ~= _G.Constant.CONST_GOODS_SITE_OTHERROLE then --显示位置，决定是否有按钮
        self.m_inity = self.m_inity + 70
    --end
    self.m_inity = self.m_inity + 3

    local  node  = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(self.m_good.goods_id).."]") --节点
    print("remark value444 =",node:getAttribute("remark"),CGoodsInfoView.FONT_SIZE)
    --描述所占长度
    if node:getAttribute("remark") ~= nil then      --描述
        local Remarklabel = CCLabelTTF :create( node:getAttribute("remark"), "Arial", CGoodsInfoView.FONT_SIZE)
        Remarklabel       : setColor( ccc3( 0, 180, 0))
        Remarklabel       : setAnchorPoint( ccp( 0,1))
        Remarklabel       : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐 
        Remarklabel : setDimensions( CCSizeMake(CPopupView.PRE_WIDTH-50,0))  --设置文字区域
        local RemarklabelSize = Remarklabel : getContentSize()
        print("55RemarklabelSize",RemarklabelSize.height)
        self.m_inity = self.m_inity + RemarklabelSize.height
        Remarklabel = nil
    end
    --如果是卷轴类 需要加合成信息长度
    if tonumber(node:getAttribute("type_sub")) == _G.Constant.CONST_GOODS_MATERIAL_MATERIAL then
        local makesNode = _G.Config.pearl_coms : selectSingleNode( "pearl_com[@scroll_id="..tostring(self.m_good.goods_id).."]")  --商店合成卷轴信息节点
        if makesNode:isEmpty() == false and makesNode:children():get(0,"items"):children():get(0,"item"):isEmpty() == false then
            local NeedMaterialCount = tonumber( makesNode:children():get(0,"items"):children():getCount("item") ) + 2
            self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT*NeedMaterialCount --合成信息长度
        else
            print( "XML无数据")
        end        
    elseif tonumber(node:getAttribute("type_sub"))  == _G.Constant.CONST_GOODS_PROTECTION then     
        local makesNode = _G.Config.hidden_makes : selectSingleNode( "hidden_make[@goods_id="..tostring( self.m_good.goods_id).."]")  --商店合成卷轴信息节点
        if makesNode:isEmpty() == false and makesNode:children():get(0,"makes"):children():get(0,"make"):isEmpty() == false then
            local NeedMaterialCount = tonumber( makesNode:children():get(0,"makes"):children():getCount("make") ) + 2
            self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT*NeedMaterialCount --合成信息长度
        else
            print( "XML无数据")
        end
    else 
        self.m_inity = self.m_inity + CPopupView.PRE_LINE_HEIGHT*0
    end

    --装备信息容器
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer : setControlName( "this is CPopupView self.m_tipscontainer 381  " )
    self.m_scenelayer :addChild( self.m_tipscontainer)

    --加载Tips背景图
    self.m_backgroundsize = CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity)

    local tipsbackground    = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")
    tipsbackground :setControlName( "this CPopupView tipsbackground 392 ")
    tipsbackground :setPreferredSize( self.m_backgroundsize)    
    tipsbackground :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity/2))
    self.m_tipscontainer :addChild( tipsbackground)
    
    local goodinfoview = CGoodsInfoView()
    self.m_tipscontainer :addChild( goodinfoview :create( self.m_good, 1,self.m_inity))

    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_BACKPACK then        --在背包
        if self.m_good.goods_type == _G.Constant.CONST_GOODS_MATERIAL then --材料
            self.m_tipscontainer :addChild( self: createSellButton(1))
            self.m_tipscontainer :addChild( self: createShowButton(-1))
        else                                                              --道具及其他                      
            self.m_tipscontainer :addChild( self: createUseButton(-2))
            self.m_tipscontainer :addChild( self: createSellButton(2))
            self.m_tipscontainer :addChild( self: createShowButton(0))
        end
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBACKPACK then    --在角色身上背包
        self.m_tipscontainer :addChild( self: createUseButton( -1))
        self.m_tipscontainer :addChild( self: createShowButton( 1))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_ARTIFACT  then      --神器界面
        self.m_tipscontainer :addChild( self: createArtifactButton( 0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_SHOP then        --在商店
        self.m_tipscontainer :addChild( self: createBuyButton(0))   
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASUREUNLOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayCopyButton(0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASURELOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayBuyButton(0))
    end
end

function CPopupView.makesNodeError( self, node)
    print( "CPopupView.makesNodeError",node)
    if node == nil then
        require "view/ErrorBox/ErrorBox"
        local ErrorBox = CErrorBox()
        local function func1()
            print("确定")
            self :reset()
        end
        local function func2()
            print("bad2")
        end
        local BoxLayer = ErrorBox : create("hidden_makes.xml暂无数据:",func1,func2)
        self.m_scenelayer : addChild(BoxLayer,10)
        print( "+++++++++++++")
        return
    end
end

function CPopupView.showProps( self)
    print("CPopupView.showProps")
    --装备Tips    --统计长度
    self.m_inity = 20
    self.m_inity = self.m_inity + 100 --装备图标，名字，穿戴需求
    self.m_inity = self.m_inity + 27  --基础属性
    self.m_inity = self.m_inity + 27 --出售价格
    --if self.m_showtype ~= _G.Constant.CONST_GOODS_SITE_OTHERROLE then --显示位置，决定是否有按钮
        self.m_inity = self.m_inity + 70
    --end
    self.m_inity = self.m_inity + 3

    --装备信息容器
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer : setControlName( "this is CPopupView self.m_tipscontainer 411  " )
    self.m_scenelayer :addChild( self.m_tipscontainer)
    --加载Tips背景图
    local tipsbackground    = CSprite :createWithSpriteFrameName( "general_tips_underframe.png")
    tipsbackground : setControlName( "this CPopupView tipsbackground 423 ")
    tipsbackground :setPreferredSize( CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity))
    self.m_backgroundsize = CCSizeMake( CPopupView.PRE_WIDTH, self.m_inity)
    tipsbackground :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity/2))
    self.m_tipscontainer :addChild( tipsbackground)
    
    local goodinfoview = CGoodsInfoView()
    self.m_tipscontainer :addChild( goodinfoview :create( self.m_good, 1, self.m_inity))
    
    --根据showTpye添加button
    print("0000000000000000000--",self.m_showtype)
    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_BACKPACK then        --在背包
        self.m_tipscontainer :addChild( self: createUseButton(-2))
        self.m_tipscontainer :addChild( self: createSellButton(2))
        self.m_tipscontainer :addChild( self: createShowButton(0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_SHOP then        --在商店
        self.m_tipscontainer :addChild( self: createBuyButton(0))   
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASUREUNLOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayCopyButton(0))
    elseif self.m_showtype == _G.Constant.CONST_GOODS_SITE_TREASURELOAD then    --在珍宝阁的装备制作
        self.m_tipscontainer :addChild( self: createFindWayBuyButton(0))
    end

end

-- -2 -1 0 1 2
function CPopupView.setButtonPosition( self, _button, _position)
    _button :setTouchesPriority( -10000)
    local itembuttonsize = _button :getPreferredSize()
    if _position == -2 then
        _button :setPosition( ccp( itembuttonsize.width/2+25, -self.m_inity+itembuttonsize.height/2+25 ))
    elseif _position == -1 then
        _button :setPosition( ccp( CPopupView.PRE_WIDTH/2-itembuttonsize.width, -self.m_inity+itembuttonsize.height/2 +25))
    elseif _position == 0 then
        _button :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity+itembuttonsize.height/2 +25))
    elseif _position == 1 then
        _button :setPosition( ccp( CPopupView.PRE_WIDTH/2+itembuttonsize.width, -self.m_inity+itembuttonsize.height/2 +25))
    elseif _position == 2 then
        _button :setPosition( ccp( CPopupView.PRE_WIDTH-itembuttonsize.width/2-25, -self.m_inity+itembuttonsize.height/2+25))
    else -- 0
        _button :setPosition( ccp( CPopupView.PRE_WIDTH/2, -self.m_inity+itembuttonsize.height/2 +25))
    end
end



function CPopupView.createUseButton( self, _position)
    print( "XXXXXXX", self.m_showtype,_G.Constant.CONST_GOODS_SITE_ROLEBODY)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = nil
    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBODY then
        itembutton = self :createButton( "卸载", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_USE, " createUseButton itembutton")
    else
        itembutton = self :createButton( "使用", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_USE, " createUseButton itembutton")
    end
    self :setButtonPosition( itembutton, _position)
    return itembutton
end
function CPopupView.createSellButton( self, _position)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = self :createButton( "出售", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_SELL, " createSellButton itembutton")
    self :setButtonPosition( itembutton, _position)
    return itembutton
end
function CPopupView.createShowButton( self, _position)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = self :createButton( "炫耀", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_SHOW, " createShowButton itembutton")
    itembutton :setTouchesEnabled( false)
    self :setButtonPosition( itembutton, _position)
    return itembutton
end
function CPopupView.createBuyButton( self, _position)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = self :createButton( "购买", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_BUY, " createBuyButton itembutton")
    itembutton : setTouchesPriority(-10000)
    self :setButtonPosition( itembutton, _position)
    return itembutton
end

function CPopupView.createXIANGQIANButton( self, _position)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = self :createButton( "镶嵌", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_XIANGQIAN, " createXIANGQIANButton itembutton")
    self :setButtonPosition( itembutton, _position)
    return itembutton
end

function CPopupView.createTreasureButton( self, _position)
    print( "XXXXXXX", self.m_showtype)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    local itembutton = nil
    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBODY then
        itembutton = self :createButton( "卸载", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_USE, " createUseButton itembutton")
    else
        itembutton = self :createButton( "使用", "general_smallbutton_click.png", CallBack, CPopupView.TAG_BUTTON_USE, " createUseButton itembutton")
    end
    self :setButtonPosition( itembutton, _position)
    return itembutton    
end
function CPopupView.createFindWayCopyButton( self, _position)
    -- body
    local itembutton     = CButton :createWithSpriteFrameName( "自动寻路","general_button_normal.png")
    itembutton           : setTouchesPriority(-10000)
    itembutton           : setTouchesEnabled(true)
    itembutton           : setControlName( "this CPopupView itembutton 224 ")
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    itembutton :setTag( CPopupView.GOODS_EQUIPMENTMANUFACTURE1)
    itembutton :registerControlScriptHandler( CallBack, "this CPopupView showbutton 247" )
    itembutton :setFontSize( 24)
    self :setButtonPosition( itembutton, _position)
    return itembutton
end
function CPopupView.createFindWayBuyButton( self, _position)
    -- body
    local itembutton     = CButton :createWithSpriteFrameName( "购买","general_smallbutton_click.png")
    itembutton           : setTouchesEnabled(true)
    itembutton           : setTouchesPriority(-10000)
    itembutton           : setControlName( "this CPopupView itembutton 224 ")
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    itembutton :setTag( CPopupView.GOODS_EQUIPMENTMANUFACTURE2)
    itembutton :registerControlScriptHandler( CallBack, "this CPopupView showbutton 247" )
    itembutton :setFontSize( 24)
    self :setButtonPosition( itembutton, _position)
    return itembutton
end

function CPopupView.createArtifactButton( self, _position)
    --添加神器的 放入 卸下 按钮
    print(self.m_buttonStr,self.m_inity)
    local itembutton = CButton :createWithSpriteFrameName( self.m_buttonStr,"general_smallbutton_click.png")
    itembutton : setControlName( "this CPopupView itembutton 224 ")
    local function CallBack( eventType, obj, x, y)
        if eventType == "TouchBegan" then
            return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
        elseif eventType == "TouchEnded" then
            if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
                self :reset()
                return self :m_buttonFun(  )
            end
        end
    end
    itembutton :setTag( CPopupView.TAG_BUTTON_BUY)
    itembutton :registerControlScriptHandler( CallBack, "this CPopupView showitembutton 247" )
    itembutton :setFontSize( 30)
    self :setButtonPosition( itembutton, _position)
    return itembutton

end

--创建按钮Button
function CPopupView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CPopupView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CPopupView ".._controlname)
    _itembutton :setFontSize( CPopupView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this CPopupView ".._controlname.."CallBack")
    end
    return _itembutton
end

function CPopupView.getButtonBtTag( self, _tag )
    
    if self.m_tipscontainer ~= nil then
        return self.m_tipscontainer:getChildByTag( _tag )
    else
        return nil
    end

end


function CPopupView.getGoodSubType( self, _goodsid)
    local goodnode = _G.g_GameDataProxy :getGoodById( tostring(_goodsid))
    if goodnode ~= nil then
        return tonumber(goodnode : getAttribute("type_sub") )
    end
    return nil    
end


function CPopupView.btnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        -- body
        local nTag = obj :getTag()
        print("nTag:",nTag)
        if obj :getTag() == CPopupView.TAG_BUTTON_USE then
            require "common/protocol/auto/REQ_GOODS_USE"   
            local function popUseBox()
                --弹出重叠道具使用框
                print(" 打开重叠道具使用框")
                local function useFunc(_index, _num)
                    self :playSound( "inventory_items")
                    local msg = REQ_GOODS_USE()
                    msg :setType( 1)
                    msg :setTarget( self.m_partnerid)
                    msg :setFromIndex( _index)
                    msg :setCount( _num)
                    print("使用物品:", self.m_partnerid, _index, _num)
                    --msg :setArguments( 1, 0, _index, _num)
                    CNetwork :send( msg)                    
                end
                local promptbox = _G.g_COverlappingUseBoxView :create( self.m_good, useFunc,1)
                promptbox :setFullScreenTouchEnabled(true)
                promptbox :setTouchesEnabled(true)
                local nowScene = CCDirector : sharedDirector() : getRunningScene()
                nowScene : addChild(promptbox,1000)
            end          
            --在不同的位置使用不同的物品
            print( "使用物品/卸载装备")                
            -----------------------------------------------
            if self.m_showtype == _G.Constant.CONST_GOODS_SITE_ROLEBODY then --卸载
                self :playSound( "inventory_items")
                local msg = REQ_GOODS_USE()
                msg :setType( 2)
                msg :setTarget( self.m_partnerid)
                msg :setFromIndex( self.m_good.index)
                msg :setCount( self.m_good.goods_num)
                print("使用物品:", self.m_partnerid, self.m_good.index, self.m_good.goods_num)
                _G.CNetwork :send( msg)
            else   --使用
                local type_sub = tonumber(self :getGoodSubType(self.m_good.goods_id))
                if self.m_good.goods_num > 1 then
                    
                    print("多个物品的使用:", type_sub)
                    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_BACKPACK and 
                     (type_sub == _G.Constant.CONST_GOODS_COMMON_EXP or type_sub ==_G.Constant.CONST_GOODS_COMMON_PAR_EXP)  --经验丹
                    then  --大背包
                        _G.g_CBackpackPanelView :closeBackpackPanel()
                        require "view/CharacterPanelLayer/CharacterPanelView"
                        CCDirector :sharedDirector() :pushScene( _G.g_CharacterPanelView :scene( nil, _G.Constant.CONST_GOODS_EQUIP, true))
                        --_G.g_CharacterPanelView :createViewByTag(  _G.Constant.CONST_GOODS_EQUIP)
                    else
                        popUseBox()
                    end
                else
                    if self.m_showtype == _G.Constant.CONST_GOODS_SITE_BACKPACK and (tonumber(self.m_good.goods_type) == 1 or tonumber(self.m_good.goods_type) == 2 or tonumber(self.m_good.goods_type) == 5 or (type_sub == _G.Constant.CONST_GOODS_COMMON_EXP or type_sub ==_G.Constant.CONST_GOODS_COMMON_PAR_EXP) ) then  -- 大背包 使用装备打开人物界面
                        _G.g_CBackpackPanelView :closeBackpackPanel()
                        require "view/CharacterPanelLayer/CharacterPanelView"
                        CCDirector :sharedDirector() :pushScene( _G.g_CharacterPanelView :scene(nil, _G.Constant.CONST_GOODS_EQUIP, true))
                        --_G.g_CharacterPanelView :createViewByTag(  _G.Constant.CONST_GOODS_EQUIP)
                    else --正常使用
                        self :playSound( "inventory_items")
                        local msg = REQ_GOODS_USE()
                        msg :setType( 1)
                        msg :setTarget( self.m_partnerid)
                        msg :setFromIndex( self.m_good.index)
                        msg :setCount( self.m_good.goods_num)
                        print("使用物品:", self.m_partnerid, self.m_good.index, self.m_good.goods_num)
                        _G.CNetwork :send( msg)
                    end
                end
            end
        elseif obj :getTag() == CPopupView.TAG_BUTTON_XIANGQIAN then
            print("跳转镶嵌界面") 
            CCLOG("强化")
            _G.g_CEquipInfoView = CEquipInfoView()
            CCDirector : sharedDirector () : pushScene( _G.g_CEquipInfoView :scene())         
        elseif obj :getTag() == CPopupView.TAG_BUTTON_SELL then
            print( "出售物品")
            local function sellFunc( _num)
                print("出售物品更新")
                if _G.g_CBackpackPanelView :getSellIsMax() == true then
                    _G.g_CBackpackPanelView :addOne( self.m_good, _num)
                    local command = CCharacterSellCommand(self.m_good, _num)
                    controller :sendCommand( command)
                else
                    print( "已经达到最大出售数量")
                    require "view/ErrorBox/ErrorBox"
                    local ErrorBox = CErrorBox()
                    local function func1()
                        print("确定")
                    end
                    local BoxLayer = ErrorBox : create("已经达到最大出售数量",func1)
                    _G.g_CBackpackPanelView :getSceneContainer(): addChild(BoxLayer,1000)
                end                  
            end
            if self.m_good.goods_num > 1 then 
                --弹出重叠道具使用框
                print(" 打开重叠道具使用框")
                local promptbox = _G.g_COverlappingUseBoxView :create( self.m_good, sellFunc,2)
                promptbox :setFullScreenTouchEnabled(true)
                promptbox :setTouchesEnabled(true)
                local nowScene = CCDirector : sharedDirector() : getRunningScene()
                nowScene : addChild(promptbox,1000)
            else
                sellFunc( 1)
            end
        elseif obj :getTag() == CPopupView.TAG_BUTTON_SHOW then
            print( "展示物品")
            local goodnode  = _G.g_GameDataProxy :getGoodById( self.m_good.goods_id)
            local goodname = "Goods XML Error :"..self.m_good.goods_id
            if goodnode ~= nil then     
                goodname  = goodnode : getAttribute("name") 
            end
            local data = {}
            data.good_name  = goodname
            data.good_index = self.m_good.index
            data.good_num   = self.m_good.goods_num
            data.pos_type   = self.m_showtype
            print("WWWWWWW1:",data.good_name,data.good_index,data.good_num,data.pos_type)
            local _wayCommand = CShowGoodOpenChatCommand( data )
            _G.controller:sendCommand(_wayCommand)
        elseif obj :getTag() == CPopupView.GOODS_EQUIPMENTMANUFACTURE1 then
            print("珍宝阁的物品制作tips自动寻路按钮弹出回调")
            if self.func ~= nil then
                self.func() 
                print("自动寻路按钮妥妥的")
            end
        elseif obj :getTag() == CPopupView.GOODS_EQUIPMENTMANUFACTURE2 then
            print("珍宝阁的物品制作tips自动寻路按钮弹出回调")
            if self.func ~= nil then
                self.func()
                print("自动寻路按钮妥妥的")
            end
        end
        --删除Tips
        _G.g_PopupView :reset()

        _G.g_PopupView :setGuideStepFinish()
    end
end

--新手引导点击命令
function CPopupView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end

function CPopupView.playSound( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end



--初始化数据，没有2001数据时使用
function CPopupView.resetGoodsInfo( self, _goodsId )
    local good = {}
    print("CPopupView _goodsId==== ".._goodsId)
    local node = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(_goodsId).."]")
    
    good.index        = nil
    good.goods_id     = _goodsId
    good.goods_num    = 0
    good.expiry       = 0
    good.time         = nil
    good.price        = tonumber(node:getAttribute("price"))
    good.goods_type   = tonumber(node:getAttribute("type"))
    print("大类--->"..good.goods_type)
    if good.goods_type == _G.Constant.CONST_GOODS_EQUIP or good.goods_type == _G.Constant.CONST_GOODS_WEAPON or good.goods_type == _G.Constant.CONST_GOODS_MAGIC then 
        print("装备 武器 神器")
        good.is_data      = true
        good.powerful     = nil
        good.pearl_score  = nil
        good.suit_id      = nil
        good.wskill_id    = nil
        good.strengthen   = 0
        good.plus_count   = 0
        good.plus_msg_no  = nil
        good.slots_count  = 0
        good.slot_group   = nil
        good.fumo         = 0
        good.fumoz        = 0
        good.attr1        = 0
        good.attr2        = 0
        good.attr3        = 0
        good.attr4        = 0

        local iCount   = 0
        local attrList = {}
        local base_typeList  = node:children():get(0,"base_types"):children()
        local base_typeCount = base_typeList:getCount("base_type")
        for i=0,base_typeCount-1 do
            local base_type = base_typeList:get(i,"base_type")
            
            if tonumber(base_type:getAttribute("type")) > 0 then
                iCount           = iCount + 1
                attrList[iCount] = {}
                attrList[iCount].attr_base_type  = tonumber(base_type:getAttribute("type"))
                attrList[iCount].attr_base_value = tonumber(base_type:getAttribute("v"))
            end
        end
        -- for i,v in ipairs(node.base_types[1].base_type) do
        --     print("-------v.type---------"..v.type)
        --     if tonumber(v.type) > 0 then 
        --         iCount           = iCount + 1
        --         attrList[iCount] = {}
        --         attrList[iCount].attr_base_type  = tonumber(v.type)
        --         attrList[iCount].attr_base_value = tonumber(v.v)
        --     end
        -- end
        if iCount > 0 then 
            print("有属性")
            good.attr_count   = iCount
            good.attr_data    = attrList
        else 
            good.attr_count   = 0
            good.attr_data    = nil
        end

    else
        print("灵珠 材料 道具")
        good.is_data      = false
        good.powerful     = nil
        good.pearl_score  = nil
        good.suit_id      = nil
        good.wskill_id    = nil
        good.strengthen   = nil
        good.plus_count   = nil
        good.plus_msg_no  = nil
        good.slots_count  = nil
        good.slot_group   = nil
        good.fumo         = nil
        good.fumoz        = nil
        good.attr1        = 0
        good.attr2        = 0
        good.attr3        = 0
        good.attr4        = 0
        good.attr_count   = nil
        good.attr_data    = nil
    end   
    return good
end
