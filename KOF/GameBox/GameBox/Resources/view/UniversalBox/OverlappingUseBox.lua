--[[
--OverlappingUseBox 重叠道具使用主界面 
--]]

COverlappingUseBoxView = class(view, function( self)
    print("重叠道具使用主界面声明")
end)

_G.g_COverlappingUseBoxView = COverlappingUseBoxView()

--CONST:
COverlappingUseBoxView.TAG_APPLY     = 100
COverlappingUseBoxView.TAG_CANCLE    = 110
COverlappingUseBoxView.TAG_ADD       = 120
COverlappingUseBoxView.TAG_SUB       = 130

COverlappingUseBoxView.FONT_SIZE     = 24
--使用最大数量
COverlappingUseBoxView.MAX_GOODS_NUM = 99

--加载资源
function COverlappingUseBoxView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("Shop/ShopReSources.plist") 
end
--释放资源
function COverlappingUseBoxView.onLoadResource( self)
    
end
function COverlappingUseBoxView.initParams( self)
    -- body
    --self.m_scenelayer :setTouchesPriority(0)
    --self.m_scenelayer :setFullScreenTouchEnabled(true)
    --self.m_scenelayer :setTouchesEnabled(true)
    self.m_ngoodsnumber = 99
end
--释放成员
function COverlappingUseBoxView.realeaseParams( self)

    self.m_ngoodsnumber = 0
    self.m_backgroundImg = nil
    self.m_buttonadd = nil
    self.m_buttonadd = nil
    self.m_buttonapply = nil
    self.m_buttoncancle = nil
    self.m_editbox = nil
    self.m_lableinfo = nil
    self.m_data = nil
    --self.m_scenelayer :setFullScreenTouchEnabled( false)
    --self.m_scenelayer :setTouchesEnabled( false)
    
    self :onLoadResource()
end

--主界面初始化
function COverlappingUseBoxView.init(self, winSize, layer)    
    COverlappingUseBoxView.loadResource(self)
    self :initParams()    
    self :initview( layer)
    self :layout( winSize)
    print("initover")    
end

function COverlappingUseBoxView.scene( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_data = {}
    self.m_data.name = "goodname"
    self.m_data.info = "goodinfo"
    self.m_data.maxnum = "9999"
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is COverlappingUseBoxView self.m_scenelayer 240")
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function COverlappingUseBoxView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_data = {}
    self.m_data.name = "物品名字"
    self.m_data.info = "物品信息描述"
    self.m_data.maxnum = "1234"
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is COverlappingUseBoxView self.m_scenelayer 255")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function COverlappingUseBoxView.create( self, good, _func, type)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_type = type
    self.m_func = _func
    self.m_data = {}
    self.m_data.good = good
    self.m_data.name = good.goods_id
    self.m_data.info = "拥有数量: "..good.goods_num
    self.m_data.maxnum = good.goods_num
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is COverlappingUseBoxView self.m_scenelayer 269")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--布局成员
function COverlappingUseBoxView.layout( self, winSize)
    --640    
    if winSize.height == 640 then  
        self.m_backgroundImg :setPreferredSize( ccp( 375, 400))

        self.m_backgroundImg :setPosition( ccp( winSize.width/2, winSize.height/2)) 
        self.m_buttonadd :setPosition( ccp( winSize.width/2+130, winSize.height/2-80))
        self.m_buttonsub :setPosition( ccp( winSize.width/2+80, winSize.height/2-80))
        self.m_buttonapply :setPosition( ccp( winSize.width/2-100, winSize.height/2-150))
        self.m_buttoncancle :setPosition( ccp( winSize.width/2+100, winSize.height/2-150))
        self.m_editbox :setPosition( ccp( winSize.width/2, winSize.height/2-80))
        self.m_labeluse :setPosition( ccp( winSize.width/2-100, winSize.height/2-80))
        self.m_lableinfo :setPosition( ccp( winSize.width/2, winSize.height/2-10))
        self.m_goodIcon :setPosition( ccp( winSize.width/2, winSize.height/2+120))
        self.m_goodName :setPosition( ccp( winSize.width/2, winSize.height/2+40))
    --768
    elseif winSize.height == 768 then

    end
end


function COverlappingUseBoxView.initview( self, layer)
    print("initview")
    local function CallBack( eventType, obj, x, y)
        return self :btnCallBack( eventType, obj, x, y)
    end
    self.m_backgroundImg = self :createSprite( "general_thirdly_underframe.png", " self.m_backgroundImg")
    self.m_buttonapply   = self :createButton( "确认", "general_button_normal.png", CallBack, COverlappingUseBoxView.TAG_APPLY, " self.m_buttonapply")
    self.m_buttoncancle  = self :createButton( "取消", "general_button_normal.png", CallBack, COverlappingUseBoxView.TAG_CANCLE, " self.m_buttoncancle")
    self.m_buttonadd     = self :createButton( "+", "shop_button_add_normal.png", CallBack, COverlappingUseBoxView.TAG_ADD, " self.m_buttonadd")
    self.m_buttonsub     = self :createButton( "-", "shop_button_subtract_normal.png", CallBack, COverlappingUseBoxView.TAG_SUB, " self.m_buttonsub")

    self.m_lableinfo     = self :createLabel( self.m_data.info, ccc3( 255,255,0))
    self.m_labeluse      = self :createLabel( "使用数量: ")

    self.m_goodIcon      = self :createGoodIcon( self.m_data.good)
    self.m_goodName      = self :createGoodName( self.m_data.good)

    local editdefaultnum = 99
    if tonumber( self.m_data.maxnum) < 99 then
        self.m_ngoodsnumber = self.m_data.maxnum
        editdefaultnum = self.m_data.maxnum
    end        
    self.m_editbox = CEditBox :create( CCSizeMake( 100, 50), CCScale9Sprite :createWithSpriteFrameName( "general_second_underframe.png"), 4, tostring( editdefaultnum), kEditBoxInputFlagSensitive)
    self.m_editbox : registerControlScriptHandler( CallBack, "this COverlappingUseBoxView self.m_editbox CallBack")
    self.m_editbox : setEditBoxInputMode( kEditBoxInputModePhoneNumber)
    

    self.m_buttonapply :setTouchesPriority( self.m_buttonapply : getTouchesPriority()-1)
    self.m_buttoncancle :setTouchesPriority( self.m_buttoncancle :getTouchesPriority()-1)
    self.m_buttonadd :setTouchesPriority( self.m_buttonadd :getTouchesPriority()-1)
    self.m_buttonsub :setTouchesPriority( self.m_buttonsub :getTouchesPriority()-1)
    self.m_editbox :setTouchesPriority( self.m_editbox :getTouchesPriority()-1)  
    
    layer :addChild( self.m_backgroundImg)
    layer :addChild( self.m_buttonapply)
    layer :addChild( self.m_buttoncancle)
    layer :addChild( self.m_buttonadd)
    layer :addChild( self.m_buttonsub)
    layer :addChild( self.m_editbox) 
    layer :addChild( self.m_lableinfo)
    layer :addChild( self.m_labeluse)
    layer :addChild( self.m_goodIcon)
    layer :addChild( self.m_goodName)
end


function COverlappingUseBoxView.createGoodIcon( self, _good)
    print("COverlappingUseBoxView.createGoodIcon")
    --加载装备图片，背景图，边框
    local goodcontainer = CContainer :create()
    local background    = self :createSprite( "general_props_underframe.png", " background")
    local background2   = self :createSprite( "general_props_frame_click.png", " background2")
    local backgroundsize = background :getPreferredSize()
    local goodicon = nil
    local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
    if goodnode == nil then
        goodicon = CSprite: createWithSpriteFrameName("iconsprite.png")
        goodicon : setControlName( "this COverlappingUseBoxView goodicon 97 ")
    else
        goodicon = CSprite: create( "Icon/i"..goodnode:getAttribute("icon")..".jpg")
        goodicon : setControlName( "this COverlappingUseBoxView goodicon 100 ")
    end  
    goodcontainer :addChild( background)    
    goodcontainer :addChild( goodicon)
    goodcontainer :addChild( background2)
    return goodcontainer
end

function COverlappingUseBoxView.createGoodName( self, _good)
    print("COverlappingUseBoxView.createGoodName")
    --装备名字，强化等级
    local goodicon = nil
    local goodnode = _G.g_GameDataProxy :getGoodById( _good.goods_id)
    local goodnamelabel = nil
    if goodnode == nil then
        print( "1111XML 中没有找到相应节点",_good.goods_id)
        goodnamelabel   = self :createLabel( "不知道这东西叫什么")
        else        
        goodnamelabel   = self :createLabel( goodnode:getAttribute("name"), ccc3( 244,0,0))
    end 
    return goodnamelabel
end

--创建按钮Button
function COverlappingUseBoxView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "COverlappingUseBoxView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this COverlappingUseBoxView ".._controlname)
    _itembutton :setFontSize( COverlappingUseBoxView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this COverlappingUseBoxView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建图片Sprite
function COverlappingUseBoxView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this COverlappingUseBoxView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function COverlappingUseBoxView.createLabel( self, _string, _color)
    print("COverlappingUseBoxView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", COverlappingUseBoxView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

function COverlappingUseBoxView.btnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "EditBoxReturn" then
        self.isstring = string.match(x , "%d+")
        if self.isstring == nil then
            local msg = "输入数值为非数字，请从新输入"
            self : createMessageBox(msg)

            self.m_editbox :setTextString( self.m_ngoodsnumber)
        else
            local num = tonumber(self.m_editbox : getTextString())
            if num ~= nil and num > 0 and num <= self.m_data.maxnum then
                self.m_ngoodsnumber = num
            end
            self.m_editbox :setTextString( self.m_ngoodsnumber)
        end  
    elseif eventType == "TouchEnded" then
        local nTag = obj :getTag()
        print("nTag:",nTag)
        if nTag == COverlappingUseBoxView.TAG_SUB then  --sub
            if self.m_ngoodsnumber > 1 then
                self.m_ngoodsnumber = self.m_ngoodsnumber - 1
            end
            self.m_editbox :setTextString( tostring( self.m_ngoodsnumber))
        elseif nTag == COverlappingUseBoxView.TAG_ADD then
            if self.m_ngoodsnumber < self.m_data.maxnum then
                self.m_ngoodsnumber = self.m_ngoodsnumber + 1
            end
            self.m_editbox :setTextString( tostring( self.m_ngoodsnumber))
        elseif nTag == COverlappingUseBoxView.TAG_APPLY then
            if self.m_func ~= nil then
                if self.m_type == 1 then --使用
                    self.m_func( self.m_data.good.index, self.m_ngoodsnumber)
                elseif self.m_type == 2 then --出售
                    self.m_func( self.m_ngoodsnumber)
                end
            end            
            self :realeaseParams()
            self.m_scenelayer :removeFromParentAndCleanup( true)
        elseif nTag == COverlappingUseBoxView.TAG_CANCLE then
            self :realeaseParams()
            self.m_scenelayer :removeFromParentAndCleanup( true)
        end
    end
end


function COverlappingUseBoxView.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)
end

--[[
    local promptbox = _G.g_COverlappingUseBoxView :create( obj.good,2)
    promptbox :setFullScreenTouchEnabled(true)
    promptbox :setTouchesEnabled(true)
    promptbox :setPosition(100,0)
    self.m_scenelayer :addChild( promptbox)
--]]


