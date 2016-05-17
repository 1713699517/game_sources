--Tips 主界面
--物品信息封装
require "common/Constant"

CVindictivePopupView = class(view, function( self)
    self.m_good     = nil
    self.m_showtype = 0
    self.m_inity    = 0
    self.m_viewType = 0 --0:正常类型 1:神器界面的tips
end)

_G.g_VindictivePopupView = CVindictivePopupView()

CVindictivePopupView.TAG_PICKUP     = 201   --拾取
CVindictivePopupView.TAG_EQUIP      = 202   --装备
CVindictivePopupView.TAG_UNINSTALL  = 203   --卸载
CVindictivePopupView.TAG_DECOMPOSE  = 204   --分解

CVindictivePopupView.PRE_LINE_HEIGHT   = 23
CVindictivePopupView.PRE_WIDTH         = 350
CVindictivePopupView.FONT_SIZE         = 22

--加载资源
function CVindictivePopupView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("VindictiveResources/VindictiveResources.plist")

    if _G.Config.equip_enchants == nil then
        CConfigurationManager    : sharedConfigurationManager():load("config/equip_enchant.xml")
    end
end
--释放资源
function CVindictivePopupView.onLoadResource( self)    
end
function CVindictivePopupView.initParams( self)
end
function CVindictivePopupView.reset( self)
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
       self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
       self.m_scenelayer = nil
    end 
end
--释放成员
function CVindictivePopupView.realeaseParams( self)
    --self.m_scenelayer :setFullScreenTouchEnabled( false)
    --self.m_scenelayer :setTouchesEnabled( false)    
    self :onLoadResource()
end
--布局成员
function CVindictivePopupView.layout( self, winSize)
    --640    
    if winSize.height == 640 then 
        local tipsbackground  = self.m_tipscontainer :getChildByTag( 101)
        tipsbackground :setPreferredSize( self.m_backgroundsize)
        tipsbackground :setPosition( ccp( CVindictivePopupView.PRE_WIDTH/2, -self.m_tipslength/2))  

        --self.m_lineSprite1 :setPosition( ccp( self.m_backgroundsize.width/2, -130))
        --self.m_lineSprite2 :setPosition( ccp( self.m_backgroundsize.width/2, -230))

    --768
    elseif winSize.height == 768 then

    end
    self :setPopupViewPosition()
end

--设置Tip的位置 --使其在屏幕内显示
function CVindictivePopupView.setPopupViewPosition( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_position.x+self.m_backgroundsize.width > winSize.width then
        self.m_position.x = winSize.width - self.m_backgroundsize.width
    end
    if self.m_position.y-self.m_backgroundsize.height < 0 then
        self.m_position.y = self.m_backgroundsize.height
    end
    self.m_scenelayer :setPosition( ccp( self.m_position.x, self.m_position.y))
end

function CVindictivePopupView.scene( self, _vindictive, _showtype, _position)
    self.m_vindictive    = _vindictive
    self.m_showtype     = _showtype
    self.m_position     = _position
    ---------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CVindictivePopupView self.m_scenelayer 117  " )
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end


function CVindictivePopupView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CVindictivePopupView self.m_scenelayer 127  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CVindictivePopupView.create( self, _vindictive, _showtype, _position, _partnerid)
    self.m_vindictive   = _vindictive  --物品信息 斗气 协议48203数据
    self.m_showtype    = _showtype   --物品所在位置， 背包， 角色身上， 其他玩家身上
    self.m_position    = _position   --点击位置
    self.m_partnerid   = _partnerid  --0主角  非0伙伴ID
    if self.m_partnerid == nil then
        self.m_partnerid = 0
    end
    local index = self.m_vindictive.dq_type..self.m_vindictive.dq_lv
    self.m_vindictiveInfomation  = self :getVindictiveXML( index)
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CVindictivePopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end


function CVindictivePopupView.createById( self, _dqid, _showtype, _position)
    if _dqid == nil then
        print( "Ｅｒｒｏｒ　斗气ID为空")
        _dqid = "1001"
    end
    self.m_dqid = _dqid
    self.m_position    = _position   --点击位置
    local index = self.m_dqid.."1"
    self.m_showtype =  99999 --_showtype or 99999 --斗气在聊天框时
    self.m_vindictiveInfomation  = self :getVindictiveXML( index)
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CVindictivePopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end


function CVindictivePopupView.getVindictiveXML( self, _index)
    local _node  = _G.Config.fight_gas_totals : selectSingleNode("fight_gas_total[@gas_id2="..tostring( _index).."]")
    print("%%%%%:",_node : getAttribute("gas_name") , _node : getAttribute("gas_id2") , _node : getAttribute("color") )
    if _node : isEmpty() == false then
        return _node
    end
    return nil
end

--主界面初始化
function CVindictivePopupView.init(self, winSize, layer)
    
    CVindictivePopupView.loadResource(self)
    self :initParams()
    
    self :initview( layer)

    self :layout( winSize)
    
end

function CVindictivePopupView.getTipsHeight( self)
    --统计长度
    self.m_tipslength = 30
    self.m_tipslength = self.m_tipslength + 120 --装备图标，名字，穿戴需求
    self.m_tipslength = self.m_tipslength + 100 --经验部分
    self.m_tipslength = self.m_tipslength + 80  --按钮
    --self.m_tipslength = self.m_tipslength + CVindictivePopupView.PRE_LINE_HEIGHT*3 --属性
    self.m_tipslength = self.m_tipslength + 30*3  --分割线
    return self.m_tipslength
end

function CVindictivePopupView.getTypeStringByType( self, _type)
    local tmpStr = CLanguageManager:sharedLanguageManager():getString("goodss_goods_base_types_base_type_type"..tostring(_type) )
    if tmpStr == nil then
        return _type
    end
    return tmpStr
end

function CVindictivePopupView.getStringFormatByType( self, _type, _value)
    if _value == "0" then
        return nil
    end
    --if tonumber(_type) == _G.Constant.CONST_ATTR_BONUS or tonumber(_type) == _G.Constant.CONST_ATTR_REDUCTION then
        --_value = tostring(_value/100).."%"
    --end
    return self :getTypeStringByType( _type).."   +".._value
end

function CVindictivePopupView.getColorByIndex( self, _color)
    print( "COLOR: ",_color)
    local temp = nil
    if _color ~= nil then
        _color = tonumber( _color)
        temp    = _G.g_ColorManager :getRGB( _color)
    else
        temp = ccc3( 255,255,255)         --颜色-白  -->        
    end
    return temp
end


--装备基本信息   
--_equipment  :装备， 
--_showtype   :显示类型，所在位置，背包，身上，其他玩家身上
--_inity       :位置
function CVindictivePopupView.initview( self, layer)
    print("CVindictivePopupView.initview")
    --装备Tips
    --统计长度
    self.m_tipslength = 30   
    --装备信息容器
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer : setControlName( "this is CVindictivePopupView self.m_tipscontainer 301  " )
    layer :addChild( self.m_tipscontainer)

    --加载Tips背景图
    local tipsbackground    = self :createSprite( "general_tips_underframe.png", "CVindictivePopupView tipsbackground")
    self.m_tipscontainer :addChild( tipsbackground,-1,101)

    --加载图标部分
    self.m_goodsContainer     = self :createGoodItem()
    self.m_lineSprite1        = self :createLineSprite( "general_tips_line.png", "self.m_lineSprite")    
    self.m_expContainer       = self :createExpView()
    self.m_lineSprite2        = self :createLineSprite( "general_tips_line.png", "self.m_lineSprite") 
    self.m_attributeContainer = self :createGoodAttribute() --动态增加Tip长度

    self.m_tipscontainer :addChild( self.m_goodsContainer)
    self.m_tipscontainer :addChild( self.m_lineSprite1)
    self.m_tipscontainer :addChild( self.m_expContainer)  
    self.m_tipscontainer :addChild( self.m_lineSprite2)
    self.m_tipscontainer :addChild( self.m_attributeContainer)

    self.m_tipslength = self.m_tipslength + 70 --button高度
    self.m_backgroundsize = CCSizeMake( CVindictivePopupView.PRE_WIDTH, self.m_tipslength)
    --根据showTpye添加button
    local layout = CHorizontalLayout :create()
    --layout :setPosition(-viewSize.width/2, viewSize.height/2-55)
    self.m_tipscontainer :addChild(layout)
    layout :setVerticalDirection(false)
    layout :setLineNodeSum( 2)
    layout :setCellSize( CCSizeMake(150,70))
    if self.m_showtype ~= 99999 then --在聊天框时无按钮
        local btnCount = 0
        print("0000000000000000000--",self.m_showtype)
        if self.m_showtype == _G.Constant.CONST_DOUQI_STORAGE_TYPE_TEMP then        --在领悟仓库
            btnCount = btnCount + 1
            layout :addChild( self :createButton( "拾取", "general_button_normal.png", CVindictivePopupView.TAG_PICKUP, "_itembutton拾取"))
        elseif self.m_showtype == _G.Constant.CONST_DOUQI_STORAGE_TYPE_ROLE then    --在角色身上
            btnCount = btnCount + 1
            layout :addChild( self :createButton( "卸载", "general_button_normal.png", CVindictivePopupView.TAG_UNINSTALL, "_itembutton卸载"))
        elseif self.m_showtype == _G.Constant.CONST_DOUQI_STORAGE_TYPE_EQUIP then        --在背包仓库          
            if tonumber(self.m_vindictiveInfomation :getAttribute("color") ) > 1 then --白色不能装备
                btnCount = btnCount + 1
                layout :addChild( self :createButton( "装备", "general_button_normal.png", CVindictivePopupView.TAG_EQUIP, "_itembutton装备"))
            end      
        end
        if tonumber(self.m_vindictiveInfomation :getAttribute("color") ) >= 4 then --紫色及以上可以分解
            btnCount = btnCount + 1
            layout :addChild( self :createButton( "分解", "general_button_normal.png", CVindictivePopupView.TAG_DECOMPOSE, "_itembutton分解")) --分解
        end
        if btnCount == 1 then
            layout :setPosition( CVindictivePopupView.PRE_WIDTH/2-75, -self.m_tipslength+50)
        elseif btnCount == 2 then
            layout :setPosition( 25, -self.m_tipslength+50)
        else
            print("按钮个数不为1or2")
        end
    end
end

--创建经验进度条
function CVindictivePopupView.createExpView( self)
    local expcontainer       = CContainer :create()
    expcontainer :setControlName( "this is CVindictivePopupView createExpView CContainer")
    local _expbackground     = CSprite :createWithSpriteFrameName( "role_exp_frame.png")
    expcontainer :addChild( _expbackground)
    local _expbackgroundSize = _expbackground :getPreferredSize()
    local _expsprite         = CSprite :createWithSpriteFrameName( "role_exp.png", CCRectMake( 12, 1, 1, 21))
    local _expspriteSize     = _expsprite :getPreferredSize()
    local dq_exp = self.m_vindictiveInfomation :getAttribute("self_exp")
    if self.m_showtype ~= 99999 then
        dq_exp = self.m_vindictive.dq_exp
    end
    local _length            = dq_exp/self.m_vindictiveInfomation :getAttribute("next_lv_exp") *_expbackgroundSize.width-2
    if self.m_vindictiveInfomation :getAttribute("next_lv_exp")  == 0 then
        _length = 0
        _expsprite :setVisible( false)
    end
    print("exp:",dq_exp.."/"..self.m_vindictiveInfomation :getAttribute("next_lv_exp") )
    if _length >= _expspriteSize.width-5 then
        _expsprite :setPreferredSize( ccp( _length, _expbackgroundSize.height-1))
    else 
        local x = _length/_expspriteSize.width
        _expsprite :setScaleX( x)
        _expsprite :setVisible( false)
    end
    _expsprite :setPosition( ccp( -_expbackgroundSize.width/2+_length/2+2, -1))
    expcontainer :addChild( _expsprite)
    local _explabel          = self :createAttribute(dq_exp.."/"..self.m_vindictiveInfomation :getAttribute("next_lv_exp") )
    _explabel :setAnchorPoint( ccp( 0.5, 0.5))
    --_explabel :setPosition( -_expbackgroundSize.width/2+10, 0)
    expcontainer :addChild( _explabel)
    local _exptaglabel       = self :createAttribute( "下一级所需经验")
    _exptaglabel :setColor( ccc3( 226,215,118))
    _exptaglabel :setPosition( ccp( -_expbackgroundSize.width/2-20, 35))
    expcontainer :addChild( _exptaglabel)
    expcontainer :setPosition( ccp( _expbackgroundSize.width/2+40, -self.m_tipslength-30))
    self.m_tipslength        = self.m_tipslength + 60
    print("CVindictivePopupView.createExpView  end")
    return expcontainer
end

function CVindictivePopupView.createGoodItem( self) 
    local goodContainer     = CContainer :create()
    
    --local vindictinve       = self :getVindictiveByLanid( _lanid) 
    local _itembackground   = CSprite :createWithSpriteFrameName("star_underframe.png")    
    _itembackground :setControlName( "this CVindictivePopupView _itembackground 271 ")
    goodContainer :addChild( _itembackground)

    local _itemsprite = CSprite :createWithSpriteFrameName("star_texture02.png") 
    _itemsprite :setControlName( "this CVindictivePopupView _itemsprite 271 ")
    goodContainer :addChild( _itemsprite)


    local backgroundSize = _itembackground :getPreferredSize()

    local dq_type = self.m_dqid
    if self.m_showtype ~= 99999 then
        dq_type = self.m_vindictive.dq_type
    end
    local _itemGoodCCBI  = self :createCCBI( "FightGas/fightgas_"..dq_type..".ccbi", 0, "_itemGoodCCBI")
    goodContainer :addChild( _itemGoodCCBI)

    local _itemnameLabel     = self :createAttribute( self.m_vindictiveInfomation :getAttribute("gas_name") , self :getColorByIndex( self.m_vindictiveInfomation :getAttribute("color") ))
    _itemnameLabel :setPosition( ccp( backgroundSize.width*0.7, backgroundSize.height*0.3))
    goodContainer :addChild( _itemnameLabel)

    local _itemlvLabel       =  self :createAttribute( "等级  LV "..self.m_vindictiveInfomation :getAttribute("lv") )
    _itemlvLabel :setPosition( ccp( backgroundSize.width*0.7, -backgroundSize.height*0.2))
    goodContainer :addChild( _itemlvLabel)
    goodContainer :setPosition( ccp( backgroundSize.width/2+30, -backgroundSize.height/2-self.m_tipslength))
    self.m_tipslength       = self.m_tipslength + 100
    return goodContainer
end

function CVindictivePopupView.createGoodAttribute( self)

    local attributecontainer = CContainer :create()
    attributecontainer :setControlName( "this is CVindictivePopupView createGoodAttribute attributecontainer")
    local _lineflag = false
    local function addAttri( attri)
        if attri ~= nil then
            _lineflag           = true
            local _itemAttr    = self :createAttribute( attri)
            _itemAttr :setPosition( ccp( 30, -self.m_tipslength))
            self.m_tipslength   = self.m_tipslength + 30
            attributecontainer :addChild( _itemAttr)
        end
    end
    local attributestring1 = self :getStringFormatByType( self.m_vindictiveInfomation :getAttribute("attr_type_one") , self.m_vindictiveInfomation :getAttribute("attr_one") )
    addAttri( attributestring1)
    local attributestring2 = self :getStringFormatByType( self.m_vindictiveInfomation :getAttribute("attr_type_two") , self.m_vindictiveInfomation :getAttribute("attr_two") )
    addAttri( attributestring2)
    local attributestring3 = self :getStringFormatByType( self.m_vindictiveInfomation :getAttribute("attr_type_three") , self.m_vindictiveInfomation :getAttribute("attr_three") )
    addAttri( attributestring3)
    if _lineflag == true then
        _itemline = self :createLineSprite( "general_tips_line.png", "self.m_lineSprite") 
        attributecontainer :addChild( _itemline)
    end

    return attributecontainer    
end

function CVindictivePopupView.createLineSprite( self, _image, _controlname)
    local _itemline      = self :createSprite( _image, _controlname)
    _itemline :setPosition( ccp( CVindictivePopupView.PRE_WIDTH/2, -self.m_tipslength))
    self.m_tipslength    = self.m_tipslength + 30
    return _itemline
end

function CVindictivePopupView.createSprite( self, _image, _controlname)
    local spriteimage = CSprite :createWithSpriteFrameName( _image)
    spriteimage : setControlName( "this CVindictivePopupView createSprite ".._controlname)
    --spriteimage :setAnchorPoint( ccp( 0,1))
    return spriteimage
end

--创建单条人物属性
-- _string 属性字符串
-- _color  字符串颜色
function CVindictivePopupView.createAttribute( self, _string, _color)
    if _string == nil then
        _string = ""
    end
    local attributelabel      = CCLabelTTF :create( _string, "Arial", CVindictivePopupView.FONT_SIZE)
    if _color ~= nil then
        attributelabel :setColor( _color)
    end
    attributelabel :setAnchorPoint( ccp( 0, 0.5))
    return attributelabel
end

--创建图片Sprite
function CVindictivePopupView.createCCBI( self, _ccbi, _tag, _controlname)
    print("CVindictivePopupView.addSprite".._controlname)
    local _itemccbi     = CMovieClip:create( _ccbi)
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "AnimationComplete" then
            --self:onAnimationCompleted( eventType, arg0 )
        elseif eventType == "Enter" then
            _itemccbi : play("run")
        end
    end    
    _itemccbi :setControlName( "this CVindictivePopupView ".._controlname)
    _itemccbi :registerControlScriptHandler( animationCallFunc)
    _itemccbi :setTag( _tag)
    return _itemccbi
end

--创建按钮Button
function CVindictivePopupView.createButton( self, _string, _image, _tag, _controlname)
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    if _string == nil then
        _string = " "
    end
    print( "CVindictivePopupView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CVindictivePopupView ".._controlname)
    _itembutton :setFontSize( CVindictivePopupView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( CallBack, "this CVindictivePopupView ".._controlname.."CallBack")
    return _itembutton
end

-----------------------------------------------------
--回调函数
-----------------------------------------------------
function CVindictivePopupView.btnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj :getTag() == CVindictivePopupView.TAG_PICKUP then
            print( "拾取")
            self :playSound( "inventory_items")
            self :REQ_SYS_DOUQI_ASK_GET_DQ( self.m_vindictive.lan_id)
        elseif obj :getTag() == CVindictivePopupView.TAG_EQUIP then
            print( "装备")
            self :playSound( "inventory_items")
            self :REQ_SYS_DOUQI_ASK_USE_DOUQI( self.m_partnerid, self.m_vindictive.dq_id, self.m_vindictive.lan_id, 0)
        elseif obj :getTag() == CVindictivePopupView.TAG_UNINSTALL then
            print( "卸载")
            self :playSound( "inventory_items")
            self :REQ_SYS_DOUQI_ASK_USE_DOUQI( self.m_partnerid, self.m_vindictive.dq_id, self.m_vindictive.lan_id, 0)
        elseif obj :getTag() == CVindictivePopupView.TAG_DECOMPOSE then
            print( "分解")
            self :playSound( "inventory_items")
            self :REQ_SYS_DOUQI_DQ_SPLIT( self.m_partnerid, self.m_vindictive.lan_id)
        end
        self :reset()
    end
end

--请求拾取
function CVindictivePopupView.REQ_SYS_DOUQI_ASK_GET_DQ( self, _id)
    print("-- (手动) -- [48300]请求拾取斗气 -- 斗气系统 ")    
    require "common/protocol/auto/REQ_SYS_DOUQI_ASK_GET_DQ"
    local msg = REQ_SYS_DOUQI_ASK_GET_DQ()
    msg :setLanId( _id)  -- {0 一键拾取| ID 唯一ID}
    _G.CNetwork :send( msg)
end

--请求移动斗气位置
--请求装备/请求卸载
function CVindictivePopupView.REQ_SYS_DOUQI_ASK_USE_DOUQI( self, _roleid, _dqid, _startid, _endid)
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


--请求分解
function CVindictivePopupView.REQ_SYS_DOUQI_DQ_SPLIT( self, _roleid, _lanid)
    print("-- (手动) -- [48320]请求分解斗气 -- 斗气系统 ")    
    require "common/protocol/auto/REQ_SYS_DOUQI_DQ_SPLIT"
    local msg = REQ_SYS_DOUQI_DQ_SPLIT()
    msg :setRoleId( _roleid)
    msg :setLanId( _lanid)  -- {0 一键拾取| ID 唯一ID}
    _G.CNetwork :send( msg)
end

function CVindictivePopupView.playSound( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end

