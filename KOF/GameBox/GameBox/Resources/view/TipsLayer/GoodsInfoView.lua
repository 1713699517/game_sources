--Tips 主界面
--物品信息封装
require "common/Constant"

CGoodsInfoView = class(view, function( self)
    self.m_good      = nil
    self.m_showtype  = 0
    self.m_inity     = 0
end)

_G.g_GoodsInfoView = CGoodsInfoView()

--常量:
CGoodsInfoView.PRE_LINE_HEIGHT   = 25
CGoodsInfoView.PRE_WIDTH         = 350
CGoodsInfoView.LINE_SPACING      = 35
CGoodsInfoView.FONT_SIZE         = 20

--加载资源
function CGoodsInfoView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 

    _G.Config:load("config/equip_enchant.xml")
    _G.Config:load("config/goods.xml") 
    _G.Config:load("config/pearl_com.xml")
    _G.Config:load("config/hidden_make.xml")
end

--释放资源
function CGoodsInfoView.onLoadResource( self)
end
function CGoodsInfoView.initParams( self)
end
--释放成员
function CGoodsInfoView.realeaseParams( self)
end
--布局成员
function CGoodsInfoView.layout( self, winSize)
    --640    
    if winSize.height == 640 then
    --768
    elseif winSize.height == 768 then
    end
end

function CGoodsInfoView.scene( self, _good, _showtype, _inity)
    self.m_good     = _good
    self.m_showtype = _showtype
    self.m_inity     = _inity
    ---------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CGoodsInfoView self.m_scenelayer 332  " )
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end


function CGoodsInfoView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CGoodsInfoView self.m_scenelayer 342  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CGoodsInfoView.create( self, _good, _showtype, _inity)
    self.m_good     = _good
    self.m_showtype = _showtype
    self.m_inity     = _inity
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CGoodsInfoView self.m_scenelayer 354  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--主界面初始化
function CGoodsInfoView.init(self, winSize, layer)    
    self :loadResource(self)
    self :initParams()    
    self :initview( layer)
    self :layout( winSize)    
end

function CGoodsInfoView.initview( self, layer)
    print( "CGoodsInfoView.initview")
    --显示相应的info
    local good_type = self.m_good.goods_type
    local goods_id  = self.m_good.goods_id
    local node      = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(goods_id).."]") --节点
    local type_sub  = tonumber( node:getAttribute("type_sub") )
    print( "type_sub: "..node:getAttribute("type_sub") )
    if good_type == _G.Constant.CONST_GOODS_EQUIP or good_type == _G.Constant.CONST_GOODS_WEAPON or good_type == _G.Constant.CONST_GOODS_MAGIC then
        print("--装备，武器，神器 1 2 5: ",good_type)
        self.theStep = self : getAdditionalFumoPercentage( self.m_good)
        self :equipBaseInfo()
    elseif good_type == _G.Constant.CONST_GOODS_STERS then
        print("--宝石 3")
        self :gemstoneBaseInfo()
    elseif good_type == _G.Constant.CONST_GOODS_MATERIAL then
        print("--材料 4")
        if type_sub == _G.Constant.CONST_GOODS_MATERIAL_MATERIAL or type_sub == _G.Constant.CONST_GOODS_PROTECTION then  --70  72
            print("--材料-宝石卷轴 --材料-珍宝卷轴 :",type_sub)
        elseif type_sub == _G.Constant.CONST_GOODS_BLESS then  --71
            print("--材料-普通材料:",type_sub)
        else
            print("--材料-待定:",type_sub)
        end
        self :materialTreasureReelBaseInfo()
    else
        print("--道具 非 12345")
        if type_sub == _G.Constant.CONST_GOODS_COMMON_BOX then --132
            print("--宝箱类")
            --self :materialTreasureReelBaseInfo()
        elseif type_sub == _G.Constant.CONST_GOODS_COMMON_PARTNER_CARD then --138
            print("--伙伴卡片类")
            --self :propsBaseInfo()
        else 
            print("--其他道具")
            --self :propsBaseInfo()
        end
        self :materialTreasureReelBaseInfo()        
    end          
end

--装备基本信息   
--_equipment  :装备， 
--_showtype   :显示类型，所在位置，背包，身上，其他玩家身上
--_inity       :位置
function CGoodsInfoView.equipBaseInfo( self)
    print("CGoodsInfoView.equipBaseInfo")
    -- body
    --装备信息容器
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer : setControlName( "this is CGoodsInfoView self.m_goodsContainer 202  " )
    self.m_scenelayer :addChild( self.m_goodsContainer)
    
    self.m_inity = self.m_inity -70
    --出售价格
    self.m_goodsContainer :addChild( self :createGoodPrice( self.m_good))
    --加载无耻的分割线
    self.m_goodsContainer :addChild( self :createSplitLine( true, false))
    --附魔等阶 郭俊志2013.08.09
    if self.m_good.fumo > 0 then
        --添加附魔等级信息
        self.m_goodsContainer :addChild( self :createFumoInfo())
        --加载无耻的分割线
        self.m_goodsContainer :addChild( self :createSplitLine( ))
    end
    ----[[
    --宝石相关
    local lineflag = false
    if self.m_good.slots_count > 0 then
        for i=1,self.m_good.slots_count do --宝石属性
            if self.m_good.slot_group[i].slot_flag == true then
                print( "self.m_good.slot_group[i].slot_flag",self.m_good.slot_group[i].slot_flag,self.m_good.slot_group[i].slot_pearl_id)
                lineflag = true
                self.m_goodsContainer :addChild( self :createGemstoneInfo( self.m_good.slot_group[i].slot_pearl_id))
            end
        end
    end
     --]]
    --加载无耻的分割线
    if lineflag == true then
        self.m_goodsContainer :addChild( self :createSplitLine())
    end
    --基础属性
    if self.m_good.attr_count > 0 then
        for i=1,self.m_good.attr_count do
            print("$$$$$$$$$$$$$$$#",i,self.m_good.attr_data[i].attr_base_type,self.m_good.attr_data[i].attr_base_value)
            self.m_goodsContainer :addChild( self :createBaseAttribute( self.m_good.attr_data[i].attr_base_type,self.m_good.attr_data[i].attr_base_value))
        end
    end
    --加载装备图片，背景图，边框，
    print( "VVVVVVVVVVVV",self.m_inity)
    self.m_goodsContainer :addChild( self :createGoodIcon( self.m_good))
    --装备名字，强化等级
    self.m_goodsContainer :addChild( self :createStrengthenLv( self.m_good))   
    self.m_goodsContainer :addChild( self :createGoodName( self.m_good))
    --加载无耻的分割线
    self.m_inity = 55
    self.m_goodsContainer :addChild( self :createSplitLine( false, true))
end

--道具 
function CGoodsInfoView.propsBaseInfo( self)
    -- body
    --装备信息容器
    self.m_goodsContainer = CContainer :create()
    self.m_goodsContainer : setControlName( "this is CGoodsInfoView self.m_goodsContainer 291  " )
    self.m_scenelayer :addChild( self.m_goodsContainer)
    --加载装备图片，背景图，边框，
    self.m_goodsContainer :addChild( self :createGoodIcon( self.m_good, self.m_inity-57))
    --装备名字，强化等级
    self.m_goodsContainer :addChild( self :createGoodName( self.m_good, self.m_inity))
    --加载无耻的分割线
    self.m_inity = self.m_inity-150
    self.m_goodsContainer :addChild( self :createSplitLine( ))
    --加载无耻的分割线
    self.m_inity = 55
    self.m_goodsContainer :addChild( self :createSplitLine( false, true))
end

--宝石 -->宝石
function CGoodsInfoView.gemstoneBaseInfo( self)
    --装备信息容器
    self.m_goodsContainer = self :createContainer( " gemstoneBaseInfo self.m_goodsContainer")
    self.m_scenelayer :addChild( self.m_goodsContainer)
    self.m_inity = self.m_inity -70
    --出售价格
    self.m_goodsContainer :addChild( self :createGoodPrice( self.m_good))
    --加载无耻的分割线
    self.m_goodsContainer :addChild( self :createSplitLine( true, false))
    --宝石描述
    local goodNode  = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(self.m_good.goods_id).."]") 
    local remark = goodNode :children() :get(0,"f"):getAttribute("strengthen")
    if remark ~= nil then  
    print("XXXDDD:",remark)      
        self.m_goodsContainer :addChild( self :createGemstoneDescription( self.m_good.goods_id))
        --加载无耻的分割线
        self.m_goodsContainer :addChild( self :createSplitLine( ))
    end 
    --宝石属性信息
    self.m_goodsContainer :addChild( self :createGemstoneAttribute( self.m_good.goods_id))   
    --加载宝石图片，背景图，边框，
    self.m_goodsContainer :addChild( self :createGoodIcon( self.m_good))
    --宝石名字
    self.m_goodsContainer :addChild( self :createGoodName( self.m_good))
    --加载无耻的分割线
    self.m_inity = 55
    self.m_goodsContainer :addChild( self :createSplitLine( false, true))
end

--材料 
function CGoodsInfoView.materialTreasureReelBaseInfo( self)
    --装备信息容器
    self.m_goodsContainer = self :createContainer( " materialTreasureReelBaseInfo self.m_goodsContainer")
    self.m_scenelayer :addChild( self.m_goodsContainer)
    self.m_inity = self.m_inity -70
    --出售价格
    self.m_goodsContainer :addChild( self :createGoodPrice( self.m_good))
    --加载无耻的分割线
    self.m_goodsContainer :addChild( self :createSplitLine( true, false))
    --珍宝卷轴合成信息
    local makesNode = nil
    local goodNode  = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(self.m_good.goods_id).."]")                 --商店合成卷轴信息节点
    if tonumber(goodNode:getAttribute("type_sub") ) == _G.Constant.CONST_GOODS_PROTECTION then
        makesNode = _G.Config.hidden_makes : selectSingleNode( "hidden_make[@goods_id="..tostring(self.m_good.goods_id).."]" )  --商店合成卷轴信息节点
        if makesNode:isEmpty() == false and makesNode:children():get(0,"makes"):children():get(0,"make"):isEmpty() == false then            
            self.m_goodsContainer :addChild( self :createProtectionComposite( self.m_good.goods_id)) 
            --加载无耻的分割线
            self.m_goodsContainer :addChild( self :createSplitLine( ))
        end
    elseif tonumber(goodNode:getAttribute("type_sub") ) == _G.Constant.CONST_GOODS_MATERIAL_MATERIAL then
        makesNode = _G.Config.pearl_coms : selectSingleNode( "pearl_com[@scroll_id="..tostring(self.m_good.goods_id).."]" )  --商店合成卷轴信息节点
        if makesNode:isEmpty() and makesNode:children():get(0,"items"):children():get(0,"item"):isEmpty() == false then            
            self.m_goodsContainer :addChild( self :createProtectionComposite( self.m_good.goods_id)) 
            --加载无耻的分割线
            self.m_goodsContainer :addChild( self :createSplitLine( ))
        end
    else
        makesNode = nil
    end
    --卷轴描述
    if goodNode:getAttribute("remark") ~= nil then        
        self.m_goodsContainer :addChild( self :createProtectionDescription( self.m_good.goods_id))
        --加载无耻的分割线
        self.m_goodsContainer :addChild( self :createSplitLine( ))
    end
    --加载宝石图片，背景图，边框，
    self.m_goodsContainer :addChild( self :createGoodIcon( self.m_good))
    --宝石名字 
    self.m_goodsContainer :addChild( self :createGoodName( self.m_good))
    --加载无耻的分割线
    self.m_inity = 55
    self.m_goodsContainer :addChild( self :createSplitLine( false, true))
end

--珍宝卷轴合成信息
function CGoodsInfoView.createProtectionComposite( self, _goodsid)
    print("CGoodsInfoView.createProtectionComposite :",self.m_good.goods_id)
    local makesNode = nil
    local goodNode  = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(self.m_good.goods_id).."]" )                 --商店合成卷轴信息节点

    local goodcontainer = self :createContainer( " createProtectionComposite goodcontainer")
    if tonumber(goodNode:getAttribute("type_sub") ) == _G.Constant.CONST_GOODS_PROTECTION then
        makesNode = _G.Config.hidden_makes : selectSingleNode( "hidden_make[@goods_id="..tostring(self.m_good.goods_id).."]" )  --商店合成卷轴信息节点
        local function sortmakes( make1, make2)
            if tonumber( make1:getAttribute("copy_id") ) > tonumber( make2:getAttribute("copy_id") ) then
                return true
            end
            return false
        end 

        local makesCount = makesNode:children():getCount("makes")
        local makeList  = makesNode:children():get(0,"makes"):children()
        local makeCount = makeList:getCount("make")

        local newMakeList = {}
        for i=0,makeCount-1 do
            local make = makeList:get(i,"make")
            table.insert(newMakeList,make)
        end

        table.sort( newMakeList , sortmakes)

        for i=1,#newMakeList do
            local make = newMakeList[i]
            goodcontainer :addChild( self :createCompositeGoodInfo( make:getAttribute("ietm"), make:getAttribute("count")))
        end
        -- for k,v in pairs( makesNode.makes[1].make ) do   
        --     goodcontainer :addChild( self :createCompositeGoodInfo( v.ietm, v.count))
        -- end
        self.m_inity        = self.m_inity - makesCount*CGoodsInfoView.PRE_LINE_HEIGHT
    elseif tonumber(goodNode:getAttribute("type_sub") ) == _G.Constant.CONST_GOODS_MATERIAL_MATERIAL then
        makesNode = _G.Config.pearl_coms : selectSingleNode( "pearl_com[@scroll_id="..tostring(self.m_good.goods_id).."]" )  --商店合成卷轴信息节点
        local function sortitems( item1, item2)
            if item1:getAttribute("id") > item2:getAttribute("id") then
                return true
            end
            return false
        end 

        local itemsCount = makesNode:children():getCount("items")
        local itemList   = makesNode:children():get(0,"items"):children()
        local itemCount  = itemList:getCount("item")

        local newItemList = {}
        for i=0,itemCount-1 do
            local item = itemList:get(i,"item")
            table.insert(newItemList,item)
        end

        table.sort( newItemList , sortitems)

        for i=1,#newItemList do
            local item = newItemList[i]
            goodcontainer :addChild( self :createCompositeGoodInfo( item:getAttribute("id"), item:getAttribute("count")))
        end

        -- for k,v in pairs( makesNode.items[1].item ) do   
        --     goodcontainer :addChild( self :createCompositeGoodInfo( v.id, v.count))
        -- end
        self.m_inity        = self.m_inity - itemsCount*CGoodsInfoView.PRE_LINE_HEIGHT
    end
    local iteminfo      = self :createLabel( "合成信息:")
    iteminfo :setAnchorPoint( ccp( 0, 0.5))
    
    iteminfo :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))         
    goodcontainer :addChild( iteminfo)
    return goodcontainer
end

function CGoodsInfoView.createCompositeGoodInfo( self, _goodsid, _count)
    local node    = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(_goodsid).."]") --节点
    local color   = self :getColorByIndex( node:getAttribute("name_color") )
    local bgcount = self : getMaterialCountFromBag( _goodsid)

    local itemcontainer  = self :createContainer( " createCompositeGoodInfo itemcontainer")
    local itemnamelabel  = self :createLabel( node:getAttribute("name"), color)
    local itemcountlabel = self :createLabel( bgcount.."/".._count, color)

    itemnamelabel :setAnchorPoint( ccp( 0, 0.5))
    itemcountlabel :setAnchorPoint( ccp( 0, 0.5))

    self.m_inity  = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemnamelabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING+10, -self.m_inity))
    itemcountlabel :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2+10, -self.m_inity))

    itemcontainer :addChild( itemnamelabel)
    itemcontainer :addChild( itemcountlabel)
    return itemcontainer
end

--卷轴描述 策划录入换行
function CGoodsInfoView.createProtectionDescription( self, _goodsid)
    print("CGoodsInfoView.createProtectionDescription")
    local  node  = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(_goodsid).."]") --节点
    print("remark value =",node:getAttribute("remark"))
    local itemlabel = self :createLabel( node:getAttribute("remark") )
    itemlabel : setAnchorPoint( ccp( 0,1))   --微调
    itemlabel : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐
    itemlabel : setDimensions( CCSizeMake(CGoodsInfoView.PRE_WIDTH-50,0))  --设置文字区域
    local itemlabelSize = itemlabel : getContentSize()
    self.m_inity      = self.m_inity - itemlabelSize.height
    print("itemlabelSize",itemlabelSize.height,self.m_inity)
    itemlabel : setPosition(  ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity+CGoodsInfoView.FONT_SIZE/2))
    return itemlabel
end
--卷轴描述 策划录入换行
function CGoodsInfoView.createGemstoneDescription( self, _goodsid)
    print("CGoodsInfoView.createGemstoneDescription")
    --local  node  = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(_goodsid).."]") --节点
    --print("remark value =",node:getAttribute("remark"))
    --宝石描述
    local goodNode  = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(self.m_good.goods_id).."]") 
    local remark = goodNode :children() :get(0,"f"):getAttribute("strengthen")
    local itemlabel = self :createLabel( remark )
    itemlabel : setAnchorPoint( ccp( 0,1))   --微调
    itemlabel : setHorizontalAlignment(kCCTextAlignmentLeft)        --左对齐
    itemlabel : setDimensions( CCSizeMake(CGoodsInfoView.PRE_WIDTH-50,0))  --设置文字区域
    local itemlabelSize = itemlabel : getContentSize()
    self.m_inity      = self.m_inity - itemlabelSize.height
    print("itemlabelSize",itemlabelSize.height,self.m_inity)
    itemlabel : setPosition(  ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity+CGoodsInfoView.FONT_SIZE/2))
    return itemlabel
end


function CGoodsInfoView.createGemstoneInfo( self, _slot_pearl_id)
    print( "CGoodsInfoView.createGemstoneInfo")
    local itemcontainer   = self :createContainer( " createGemstoneInfo itemcontainer")
    local goodnode        = _G.g_GameDataProxy :getGoodById( _slot_pearl_id)
    local color           = self :getColorByIndex( goodnode:getAttribute("name_color") )
    local itemnamelabel   = nil
    local itemremarklabel = nil
    local itemaddlabel    = nil
    if goodnode == nil then
        print( "2222XML 中没有找到相应节点",_good.goods_id)
        itemnamelabel   = self :createLabel( " node error", color)
        itemremarklabel = self :createLabel( " node error", color)
        itemaddlabel    = self :createLabel( " error", color)
    else
        local addvalue  = " " 
        if self.theStep ~= nil and self.theStep >0 then
            local _value = goodnode:children():get(0,"d"):getAttribute("as5")
            addvalue ="("..math.floor(_value/100 * self.theStep)..")" 
        end
        itemnamelabel   = self :createLabel( goodnode:getAttribute("name"), color)
        itemremarklabel = self :createLabel( goodnode:getAttribute("remark"), color)
        itemaddlabel    = self :createLabel( addvalue, color)
    end

    itemremarklabel :setAnchorPoint( ccp( 0,0.5))
    itemnamelabel :setAnchorPoint( ccp( 0,0.5))
    itemaddlabel :setAnchorPoint( ccp( 0,0.5))

    self.m_inity = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemremarklabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))   
    itemaddlabel :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2+CGoodsInfoView.LINE_SPACING, -self.m_inity))
    self.m_inity = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemnamelabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))

    itemcontainer :addChild( itemremarklabel)
    itemcontainer :addChild( itemaddlabel)
    itemcontainer :addChild( itemnamelabel)    
    return itemcontainer
end


function CGoodsInfoView.createGemstoneAttribute( self, _goodsid)
    local itemcontainer = self :createContainer( " createGemstoneAttribute itemcontainer")
    local goodnode = _G.g_GameDataProxy :getGoodById( _goodsid)
    if goodnode == nil then
        print( "2222XML 中没有找到相应节点",_good.goods_id)
        itemremarklabel = self :createLabel( " XML中没有找到 ".._goodsid)
    else
        itemremarklabel = self :createLabel( goodnode:getAttribute("remark") )
    end
    self.m_inity = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemremarklabel :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2-30, -97))
    itemremarklabel :setAnchorPoint( ccp( 0,0.5))
    itemcontainer :addChild( itemremarklabel)    
    return itemcontainer
end

function CGoodsInfoView.createBaseAttribute( self, _type, _value)
    -- body
    local base_type_id   = "goodss_goods_base_types_base_type_type".._type          --属性名称ID
    local base_type_name = CLanguageManager :sharedLanguageManager() :getString( tostring( base_type_id)) --属性名称名字
    local color          = ccc3( 0,180,0)
    local addvalue  = " " 
    if self.theStep ~= nil and self.theStep >0 then
        addvalue ="("..math.floor(_value/100 * self.theStep)..")" 
    end
    local itemcontainer  = self :createContainer( " createBaseAttribute itemcontainer")
    local itemattrlabel  = self :createLabel( base_type_name.."  ".._value, color)
    local itemaddlabel   = self :createLabel( addvalue, color)
    itemattrlabel :setAnchorPoint( ccp( 0,0.5))
    itemaddlabel :setAnchorPoint( ccp( 0,0.5))
    self.m_inity = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemattrlabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))
    itemaddlabel :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2+CGoodsInfoView.LINE_SPACING, -self.m_inity))
    itemcontainer :addChild( itemattrlabel)
    itemcontainer :addChild( itemaddlabel)    
    return itemcontainer
end

function CGoodsInfoView.createFumoInfo( self, _good)
    print( "CGoodsInfoView createFumoInfo")
    local step, name     = self :getAdditionalFumoPercentage( self.m_good)
    local color          = ccc3( 0, 255, 0)
    local itemcontainer  = self :createContainer( " createFumoInfo itemcontainer")
    local itemnamelabel  = self :createLabel( "当前附魔"..name, color)
    local itemattrlabel  = self :createLabel( "装备属性加成"..step.."%", color)
    itemnamelabel :setAnchorPoint( ccp( 0,0.5))
    itemattrlabel :setAnchorPoint( ccp( 0,0.5))
    self.m_inity    = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemnamelabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))
    self.m_inity    = self.m_inity - CGoodsInfoView.PRE_LINE_HEIGHT
    itemattrlabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))
    itemcontainer :addChild( itemnamelabel)
    itemcontainer :addChild( itemattrlabel)
    return itemcontainer
end

--取得附魔等阶
function CGoodsInfoView.getAdditionalFumoPercentage( self, _good) --附加附魔百分比 郭俊志2013.08.17
    print("CGoodsInfoView.getAdditionalFumoPercentage")
    local good              = _good
    local node              = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(good.goods_id).."]") --节点
    local enchantId         = node:getAttribute("type_sub") .."_"..good.fumo   --附魔节点ID                 
    local equip_enchantNode = _G.Config.equip_enchants:selectSingleNode("equip_enchant[@id="..tostring(enchantId).."]") --附魔节点
    local step = 0 
    local name = 0
    if equip_enchantNode:isEmpty() == false then
        step                = tonumber(equip_enchantNode:getAttribute("step"))       --附魔等阶
        name                = equip_enchantNode:getAttribute("step_name")
    end    
    return step, name
end


function CGoodsInfoView.getMaterialCountFromBag(self,_materialId)
    print( " CGoodsInfoView.getMaterialCountFromBag:".._materialId)
    local m_MaterialListData =  _G.g_GameDataProxy : getMaterialList() --材料列表
    local bag_material_count = 0
    if m_MaterialListData ~=nil then
        for k,v in pairs(m_MaterialListData) do
            if( tonumber(_materialId) == v.goods_id)then
                bag_material_count = bag_material_count + tonumber(v.goods_num)             --背包材料数量
            end
        end

    end
    print( "bag_material_count :"..bag_material_count)
    return bag_material_count
end

function CGoodsInfoView.getColorByIndex( self, _color)
    print( "COLOR: ".._color)
    local temp = nil
    _color = tonumber( _color)
    if _color ~= nil then
        temp = _G.g_ColorManager :getRGB( _color)
    else
        temp = ccc3( 255,255,255)         --颜色-白  -->        
    end
    return temp
end

function CGoodsInfoView.createStrengthenLv( self, _good)
    print("CGoodsInfoView.createStrengthenLvlabel")
    --装备名字，强化等级
    local color             = ccc3( 0, 180, 0)
    local temp              = " "
    if _good.strengthen > 0 then
        temp = "强化等级".._good.strengthen
    end
    local strengthenLvlabel = self :createLabel( temp, color)
    strengthenLvlabel :setAnchorPoint( ccp( 0,0.5))
    strengthenLvlabel :setPosition(  ccp( CGoodsInfoView.PRE_WIDTH/2-30, -105))
    return strengthenLvlabel
end

function CGoodsInfoView.createGoodIcon( self, _good)
    print("CGoodsInfoView.createGoodIcon")
    --加载装备图片，背景图，边框
    local goodcontainer = self :createContainer( " createGoodIcon goodcontainer")
    local background    = self :createSprite( "general_props_underframe.png", " createGoodIcon background")
    local background2   = self :createSprite( "general_props_frame_click.png", " createGoodIcon background2")
    local backgroundsize = background :getPreferredSize()
    local goodicon = nil
    local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
    if goodnode == nil then
        goodicon = self :createSprite( "iconsprite.png", " createGoodIcon goodicon 1")
    else
        goodicon = CSprite: create( "Icon/i"..goodnode:getAttribute("icon")..".jpg")
        goodicon :setControlName( "this is createGoodIcon goodicon ".._good.goods_id)
    end
    background :setPosition( ccp( backgroundsize.width-15, -backgroundsize.height+5))
    background2 :setPosition( ccp( backgroundsize.width-15, -backgroundsize.height+5))
    goodicon :setPosition( ccp( backgroundsize.width-15, -backgroundsize.height+5))        
    goodcontainer :addChild( background)    
    goodcontainer :addChild( goodicon)
    goodcontainer :addChild( background2)
    return goodcontainer
end

function CGoodsInfoView.createGoodName( self, _good)
    print("CGoodsInfoView.createGoodName")
    --装备名字
    local goodnode  = _G.g_GameDataProxy :getGoodById( _good.goods_id)
    local goodcolor = self :getColorByIndex( goodnode:getAttribute("name_color") )
    local goodnamelabel = nil
    if goodnode == nil then
        goodnamelabel   = self :createLabel( "XML中未找到".._good.goods_id)
    else        
        goodnamelabel   = self :createLabel( goodnode:getAttribute("name"), goodcolor)
    end
    goodnamelabel :setFontSize( CGoodsInfoView.FONT_SIZE+5) 
    goodnamelabel :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2-30, -47))
    goodnamelabel :setAnchorPoint( ccp( 0,1))
    return goodnamelabel
end

function CGoodsInfoView.createGoodPrice( self, _good)
    -- body
    local pricelabel = CCLabelTTF :create( "出售价格   ".._good.price, "Arial", CGoodsInfoView.FONT_SIZE)
    pricelabel :setColor( ccc3( 255, 255, 0))
    self.m_inity = self.m_inity-CGoodsInfoView.PRE_LINE_HEIGHT
    pricelabel :setPosition( ccp( CGoodsInfoView.LINE_SPACING, -self.m_inity))
    pricelabel :setAnchorPoint( ccp( 0,0.5))
    return pricelabel
end

function CGoodsInfoView.createSplitLine( self, _up, _down)
    print( "无耻的分割线\n----------------------------------------")
    local splitline  = self :createSprite( "general_tips_line.png", " createSplitLine splitline")
    if _up == true then
        local splitline2 = self :createSprite( "general_tips_line_4.png", " createSplitLine splitline2")
        splitline2 :setScale( -1)
        splitline2Szie = splitline2 :getPreferredSize()
        splitline2 :setPosition( ccp( 0, splitline2Szie.height/2-9))
        splitline :addChild( splitline2)
    end
    if _down == true then
        local splitline3 = self :createSprite( "general_tips_line_4.png", " createSplitLine splitline3")
        splitline3Szie = splitline3 :getPreferredSize()
        splitline3 :setPosition( ccp( 0, -splitline3Szie.height/2+9))
        splitline :addChild( splitline3)
    end
    self.m_inity = self.m_inity-CGoodsInfoView.PRE_LINE_HEIGHT
    local temp = -self.m_inity
    
    splitline :setPosition( ccp( CGoodsInfoView.PRE_WIDTH/2, temp))
    return splitline
end

--创建图片Sprite
function CGoodsInfoView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CGoodsInfoView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CGoodsInfoView.createLabel( self, _string, _color)
    print("CGoodsInfoView.createLabel:".._string)
    if _string == nil then
        _string = " "
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CGoodsInfoView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

function CGoodsInfoView.createContainer( self, _controlname)
    print( "CGoodsInfoView.createContainer")
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( " this is CGoodsInfoView createContainer ".._controlname)
    return _itemcontainer
end

function CGoodsInfoView.btnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local nTag = obj :getTag()
        print("nTag:",nTag)
    end
end





