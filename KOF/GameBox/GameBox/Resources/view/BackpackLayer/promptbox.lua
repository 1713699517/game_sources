--promptbox 主界面

CPromptBoxView = class(view, function( self)
end)

--使用最大数量
CPromptBoxView.MAX_GOODS_NUM = 99

--加载资源
function CPromptBoxView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist") 
end

--释放资源
function CPromptBoxView.onLoadResource( self)
    
end

function CPromptBoxView.initParams( self)
    -- body
    --self.m_scenelayer :setTouchesPriority(0)
    --self.m_scenelayer :setFullScreenTouchEnabled(true)
    --self.m_scenelayer :setTouchesEnabled(true)
    self.m_ngoodsnumber = 99
end

--释放成员
function CPromptBoxView.realeaseParams( self)

    self.m_ngoodsnumber = 0
    self.m_backgroundImg = nil
    self.m_buttonmax = nil
    self.m_buttonadd = nil
    self.m_buttonadd = nil
    self.m_buttonapply = nil
    self.m_buttoncancle = nil
    self.m_editbox = nil
    self.m_lablename = nil
    self.m_lableinfo = nil
    if self.m_data.model == 2 then
        self.m_labelnumber = nil
    end
    self.m_data = nil
    --self.m_scenelayer :setFullScreenTouchEnabled( false)
    --self.m_scenelayer :setTouchesEnabled( false)
    
    self :onLoadResource()
end

--布局成员
function CPromptBoxView.layout( self, winSize)
    --640    
    if winSize.height == 640 then

        if self.m_data.model == 1 then   --1: "确认／取消"     
            self.m_backgroundImg :setPosition( ccp( winSize.width/2, winSize.height/2)) 
            self.m_buttonmax :setScale( 0.8)       
            self.m_buttonmax :setPosition( ccp( winSize.width/2, winSize.height/2+30))
            self.m_buttonadd :setPosition( ccp( winSize.width/2+60, winSize.height/2+100))
            self.m_buttonsub :setPosition( ccp( winSize.width/2-60, winSize.height/2+100))
            self.m_buttonapply :setPosition( ccp( winSize.width/2-100, winSize.height/2-100))
            self.m_buttoncancle :setPosition( ccp( winSize.width/2+100, winSize.height/2-100))
            self.m_editbox :setPosition( ccp( winSize.width/2, winSize.height/2+100))
            self.m_lablename :setPosition( ccp( winSize.width/2-150, winSize.height/2+100))
            self.m_lableinfo :setPosition( ccp( winSize.width/2-100, winSize.height/2-30))
            
        elseif self.m_data.model == 2 then  --2: 使用／关闭X 
            self.m_backgroundImg :setPosition( ccp( winSize.width/2, winSize.height/2)) 
            self.m_buttonmax :setScale( 0.8)       
            self.m_buttonmax :setPosition( ccp( winSize.width/2+130, winSize.height/2))
            self.m_buttonadd :setPosition( ccp( winSize.width/2+40, winSize.height/2))
            self.m_buttonsub :setPosition( ccp( winSize.width/2-80, winSize.height/2))
            self.m_buttonapply :setPosition( ccp( winSize.width/2, winSize.height/2-100))
            self.m_buttoncancle :setPosition( ccp( winSize.width/2+200, winSize.height/2+100))
            self.m_editbox :setPosition( ccp( winSize.width/2-20, winSize.height/2))
            self.m_lablename :setPosition( ccp( winSize.width/2-150, winSize.height/2+100))
            self.m_lableinfo :setPosition( ccp( winSize.width/2-50, winSize.height/2+100))
            self.m_labelnumber :setPosition( ccp( winSize.width/2-150, winSize.height/2))
        end
    --768
    elseif winSize.height == 768 then

    end
end


function CPromptBoxView.initview( self, layer)
    print("initview")
    self.m_backgroundImg = CSprite :createWithSpriteFrameName("iconinfo.png")
    self.m_backgroundImg : setControlName( "this CPromptBoxView self.m_backgroundImg 90 ")
    if self.m_data.model == 1 then
        self.m_buttonapply  = CButton :createWithSpriteFrameName("确认","iconfourlable.png")
        self.m_buttoncancle = CButton :createWithSpriteFrameName("取消","iconfourlable.png")
        self.m_buttonapply : setControlName( "this CPromptBoxView self.m_buttonapply 93 ")
        self.m_buttoncancle : setControlName( "this CPromptBoxView self.m_buttoncancle 94 ")

        self.m_lableinfo = CCLabelTTF: create( self.m_data.info,"Arial",30)  --
    elseif self.m_data.model == 2 then
        self.m_buttonapply  = CButton :createWithSpriteFrameName("使用","iconfourlable.png")
        self.m_buttoncancle = CButton :createWithSpriteFrameName("","iconclosed.png")
        self.m_buttonapply : setControlName( "this CPromptBoxView self.m_buttonapply 100 ")
        self.m_buttoncancle : setControlName( "this CPromptBoxView self.m_buttoncancle 101 ")

        self.m_lableinfo = CCLabelTTF: create( "*"..self.m_data.maxnum,"Arial",30)  --
        self.m_labelnumber = CCLabelTTF: create( "数量","Arial",30)
    end
    self.m_buttonmax = CButton :createWithSpriteFrameName("MAX","iconfourlable.png")
    self.m_buttonadd = CButton :createWithSpriteFrameName("+","iconstateblack.png")
    self.m_buttonsub = CButton :createWithSpriteFrameName("-","iconstatered.png")
    self.m_buttonmax : setControlName( "this CPromptBoxView self.m_buttonmax 109 ")
    self.m_buttonadd : setControlName( "this CPromptBoxView self.m_buttonadd 110 ")
    self.m_buttonsub : setControlName( "this CPromptBoxView self.m_buttonsub 111 ")
    local editdefaultnum = 99
    if tonumber( self.m_data.maxnum) < 99 then
        self.m_ngoodsnumber = self.m_data.maxnum
        editdefaultnum = self.m_data.maxnum
    end        
    self.m_editbox = CEditBox :create( CCSizeMake( 100, 50), CCScale9Sprite :createWithSpriteFrameName( "iconfourlable.png"), 4, tostring( editdefaultnum), kEditBoxInputFlagSensitive)
    --self.m_editbox :setInputMode( kEditBoxInputModePhoneNumber)
    self.m_lablename = CCLabelTTF: create( self.m_data.name,"Arial",30)    

    if self.m_data.model == 1 then
        self.m_backgroundImg :setPreferredSize( ccp( 480, 320))
    elseif self.m_data.model == 2 then
        self.m_backgroundImg :setPreferredSize( ccp( 480, 280))
    end

    self.m_buttonapply :setTouchesPriority( self.m_buttonapply : getTouchesPriority()-1)
    self.m_buttoncancle :setTouchesPriority( self.m_buttoncancle :getTouchesPriority()-1)
    self.m_buttonmax :setTouchesPriority( self.m_buttonmax :getTouchesPriority()-1)
    self.m_buttonadd :setTouchesPriority( self.m_buttonadd :getTouchesPriority()-1)
    self.m_buttonsub :setTouchesPriority( self.m_buttonsub :getTouchesPriority()-1)
    self.m_editbox :setTouchesPriority( self.m_editbox :getTouchesPriority()-1)

    self.m_buttonapply :setFontSize( 30)
    self.m_buttoncancle :setFontSize( 30)
    self.m_buttonmax :setFontSize( 30)
    self.m_buttonadd :setFontSize( 30)
    self.m_buttonsub :setFontSize( 30)    
    
    layer :addChild( self.m_backgroundImg)
    layer :addChild( self.m_buttonapply)
    layer :addChild( self.m_buttoncancle)
    layer :addChild( self.m_buttonmax)
    layer :addChild( self.m_buttonadd)
    layer :addChild( self.m_buttonsub)
    layer :addChild( self.m_editbox) 
    layer :addChild( self.m_lablename)
    layer :addChild( self.m_lableinfo)
    if self.m_data.model == 2 then
        layer :addChild( self.m_labelnumber)
    end

    local nTag = 100
    self.m_buttonsub :setTag( nTag)
    nTag = nTag + 10
    self.m_buttonadd :setTag( nTag)
    nTag = nTag + 10
    self.m_buttonmax :setTag( nTag)
    nTag = nTag + 10
    self.m_buttonapply :setTag( nTag)
    nTag = nTag + 10
    self.m_buttoncancle :setTag( nTag)

    local function callBack( eventType, obj, x, y)
        -- body
        return self :btnCallBack( eventType, obj, x, y)
    end
    self.m_buttonsub :registerControlScriptHandler( callBack, "this CPromptBoxView self.m_buttonsub 169")
    self.m_buttonadd :registerControlScriptHandler( callBack, "this CPromptBoxView self.m_buttonadd 170")
    self.m_buttonmax :registerControlScriptHandler( callBack, "this CPromptBoxView self.m_buttonmax 171")
    self.m_buttonapply :registerControlScriptHandler( callBack, "this CPromptBoxView self.m_buttonapply 172")
    self.m_buttoncancle :registerControlScriptHandler( callBack, "this CPromptBoxView self.m_buttoncancle 173")
        
end

function CPromptBoxView.btnCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        -- body
        local nTag = obj :getTag()
        print("nTag:",nTag)
        if nTag == 100 then  --sub
            if self.m_ngoodsnumber > 1 then
                self.m_ngoodsnumber = self.m_ngoodsnumber - 1
            end
            self.m_editbox :setTextString( tostring( self.m_ngoodsnumber))
        elseif nTag == 110 then
            if self.m_ngoodsnumber < self.m_data.maxnum then
                self.m_ngoodsnumber = self.m_ngoodsnumber + 1
            end
            self.m_editbox :setTextString( tostring( self.m_ngoodsnumber))
        elseif nTag == 120 then
            self.m_ngoodsnumber = self.m_data.maxnum
            self.m_editbox :setTextString( tostring( self.m_ngoodsnumber))
        elseif nTag == 130 then
            --[[
            local data = {}
            data.type       = 1  --背包
            data.target     = 0  --CSelectSeverHandle.selectedUid  --自己
            data.from_index = self.m_data.good.index
            data.count      = self.m_ngoodsnumber
            print("QQQQQQ",self.m_data.good.index,self.m_ngoodsnumber)
            local command = CBackpackREQCommand( _G.Protocol.REQ_GOODS_USE)
            command :setOtherData( data)
            controller :sendCommand( command)
             ]]
             self :playSound( "inventory_items")
            require "common/protocol/auto/REQ_GOODS_USE"
            local msg = REQ_GOODS_USE()
            local type       = 1
            local target     = 0
            local from_index = self.m_data.good.index
            local count      = self.m_ngoodsnumber
            msg :setArguments( type, target, from_index, count)
            CNetwork :send( msg)
            
            self :realeaseParams()
            self.m_scenelayer :removeAllChildrenWithCleanup( true)
        elseif nTag == 140 then
            self :realeaseParams()
            self.m_scenelayer :removeAllChildrenWithCleanup( true)
        end
    end
end

--主界面初始化
function CPromptBoxView.init(self, winSize, layer)
    
    CPromptBoxView.loadResource(self)
    self :initParams()
    
    self :initview( layer)

    self :layout( winSize)
    print("initover")
    
end


function CPromptBoxView.scene( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_data = {}
    self.m_data.name = "goodname"
    self.m_data.info = "goodinfo"
    self.m_data.maxnum = "9999"
    self.m_data.model = 2
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPromptBoxView self.m_scenelayer 240")
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end


function CPromptBoxView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_data = {}
    self.m_data.name = "物品名字"
    self.m_data.info = "物品信息描述"
    self.m_data.maxnum = "1234"
    self.m_data.model = 1  --{1: 确认／取消  2: 使用／关闭X }
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPromptBoxView self.m_scenelayer 255")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CPromptBoxView.create( self, good, model)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_data = {}
    self.m_data.good = good
    self.m_data.name = good.goods_id
    self.m_data.info = "test:XXXXXXXXXXXXX"
    self.m_data.maxnum = good.goods_num
    self.m_data.model = model or 1
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CPromptBoxView self.m_scenelayer 269")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end


function CPromptBoxView.playSound( self, _szMp3Name )
    if _G.pCSystemSettingProxy :getStateByType( _G.Constant.CONST_SYS_SET_MUSIC ) == 1 and _szMp3Name ~= nil then
        SimpleAudioEngine :sharedEngine() :playEffect("Sound@mp3/".. tostring( _szMp3Name ) .. ".mp3", false )
    end
end




