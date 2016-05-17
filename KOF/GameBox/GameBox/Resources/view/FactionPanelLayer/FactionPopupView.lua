--社团功能Tips 主界面
require "common/Constant"

CFactionPopupView = class(view, function( self)
    self.m_role     = nil
    self.m_posttype = 0
    self.m_counts   = 0
end)

_G.g_FactionPopupView = CFactionPopupView()

CFactionPopupView.TAG_TRANSFER      = 101   --转让社长
CFactionPopupView.TAG_APPOINTMENT   = 102   --任命副社长
CFactionPopupView.TAG_REVOCATION    = 103   --撤销副社长
CFactionPopupView.TAG_EXCLUDING     = 104   --剔除社员
CFactionPopupView.TAG_EXAMINE       = 105   --查看信息
CFactionPopupView.TAG_ADDFRIEND     = 106   --添加好友

CFactionPopupView.FONT_SIZE         = 23

--加载资源
function CFactionPopupView.loadResource( self)

end
--释放资源
function CFactionPopupView.onLoadResource( self)    
end
function CFactionPopupView.initParams( self)
end
function CFactionPopupView.reset( self)
    -- body
    if self.m_scenelayer ~= nil then
        print("XXXXXX删除Tips")
        self.m_scenelayer : removeFromParentAndCleanup( true)--removeFromParentAndCleanup( true )
        self.m_scenelayer = nil
        self.m_role     = nil
        self.m_posttype = 0
        self.m_counts   = 0
    end   
end
--释放成员
function CFactionPopupView.realeaseParams( self) 
    self :onLoadResource()
end
--布局成员
function CFactionPopupView.layout( self, winSize)
    --640
    local cellButtonSize = nil
    if winSize.height == 640 then
        cellButtonSize = self.m_examineButton :getPreferredSize()
        self.m_tagLayout :setCellSize( CCSizeMake( cellButtonSize.width, cellButtonSize.height+10))
        self.m_backgroundsize = CCSizeMake( cellButtonSize.width+50, (self.m_counts+0.8)*(cellButtonSize.height+10)+20)
        self.m_bgSprite :setPreferredSize( self.m_backgroundsize)
        self.m_bgSprite :setPosition( ccp( cellButtonSize.width/2, -(self.m_counts/2-0.8)*(cellButtonSize.height+10)))
        self.m_nameLaber :setPosition( ccp( cellButtonSize.width/2, 0.8*(cellButtonSize.height+10)))
    --768
    elseif winSize.height == 768 then
    end
    self :setPopupViewPosition( 1.3*(cellButtonSize.height))
end

--设置Tip的位置 --使其在屏幕内显示
function CFactionPopupView.setPopupViewPosition( self, _y)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_position.x+self.m_backgroundsize.width > winSize.width then
        self.m_position.x = winSize.width - self.m_backgroundsize.width
    end
    if self.m_position.y-self.m_backgroundsize.height < 0 then
        self.m_position.y = self.m_backgroundsize.height
    end
    self.m_scenelayer :setPosition( ccp( self.m_position.x+25, self.m_position.y-_y))
end

--主界面初始化
function CFactionPopupView.init(self, winSize, layer)
    
    -- self :loadResource()

    self :initParams()
    
    self :initview( layer)

    self :layout( winSize)
    
end

function CFactionPopupView.scene( self, _good, _showtype, _position)
    self.m_role         = _good
    self.m_posttype     = _showtype
    self.m_position     = _position
    ---------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CFactionPopupView self.m_scenelayer 117  " )
    self :init(winSize, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end


function CFactionPopupView.layer( self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CFactionPopupView self.m_scenelayer 127  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CFactionPopupView.create( self, _role, _myrole, _position)
    self.m_role        = _role
    self.m_posttype    = _myrole.post
    self.m_position    = _position
    print("AAAAAAA",self.m_role.uid)
    --------------------------------------------
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    if self.m_scenelayer ~= nil then
       --self.m_scenelayer : removeAllChildrenWithCleanup( true)--removeFromParentAndCleanup( true )
       --self.m_scenelayer = nil
    end    
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( "this is CFactionPopupView self.m_scenelayer 139  " )
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end
--创建按钮Button
function CFactionPopupView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionPopupView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionPopupView ".._controlname)
    _itembutton :setFontSize( CFactionPopupView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CFactionPopupView ".._controlname.."CallBack")
    self.m_counts = self.m_counts + 1
    return _itembutton
end

--创建二级背景Sprite
function CFactionPopupView.createSprite( self, _image, _controlname)
    local _itemsprite = CSprite :createWithSpriteFrameName( _image)
    _itemsprite :setControlName( "this CFactionPopupView background 121:".._controlname)
    return _itemsprite
end

--创建Label ，可带颜色
function CFactionPopupView.createLabel( self, _string, _color)
    print("CFactionPopupView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionPopupView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end

function CFactionPopupView.initview( self, layer)
    print("CFactionPopupView.initview")
    self.m_tipscontainer = CContainer :create()
    self.m_tipscontainer :setControlName( "this CFactionPopupView self.m_tipscontainer 129")
    layer :addChild( self.m_tipscontainer)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --背景图片
    self.m_bgSprite      = self :createSprite( "general_tips_underframe.png", "self.m_bgSprite 150")
    self.m_tipscontainer :addChild(self.m_bgSprite)
    --角色名字
    self.m_nameLaber     = self :createLabel( self.m_role.name)
    self.m_tipscontainer :addChild( self.m_nameLaber)
    --标签Button布局
    self.m_tagLayout     = CHorizontalLayout :create()    
    self.m_tagLayout :setVerticalDirection(false)
    --self.m_tagLayout :setCellHorizontalSpace( 1)
    self.m_tagLayout :setLineNodeSum(1)
    self.m_tipscontainer :addChild( self.m_tagLayout)
    --根据postTpye添加button
    print("0000000000000000000--",self.m_posttype)
    self.m_examineButton = self: createButton( "查看信息", "general_label_click.png", CallBack, CFactionPopupView.TAG_EXAMINE, "查看信息")
    local mainplay = _G.g_characterProperty :getMainPlay()
    local myuid    = mainplay :getUid()      --玩家Uid
    print("FFFFFFFFF",myuid, self.m_role.uid)
    if self.m_role.uid ~= myuid then
        if self.m_posttype == _G.Constant.CONST_CLAN_POST_MASTER then        --在社长
            --添加社长相应功能
            self.m_tagLayout :addChild( self :createButton( "转让社长", "general_label_click.png", CallBack, CFactionPopupView.TAG_TRANSFER, "转让社长"))
            if self.m_role.post == _G.Constant.CONST_CLAN_POST_SECOND then
                self.m_tagLayout :addChild( self: createButton( "撤销副社", "general_label_click.png", CallBack, CFactionPopupView.TAG_REVOCATION, "撤销副社")) 
            elseif self.m_role.post == _G.Constant.CONST_CLAN_POST_COMMON then
                self.m_tagLayout :addChild( self: createButton( "任命副社", "general_label_click.png", CallBack, CFactionPopupView.TAG_APPOINTMENT, "任命副社")) 
            end
            self.m_tagLayout :addChild( self :createButton( "请出社团", "general_label_click.png", CallBack, CFactionPopupView.TAG_EXCLUDING, "请出社团"))                   
        elseif self.m_posttype == _G.Constant.CONST_CLAN_POST_SECOND then    --在副社长
            --添加副社长相应功能
            self.m_tagLayout :addChild( self :createButton( "请出社团", "general_label_click.png", CallBack, CFactionPopupView.TAG_EXCLUDING, "请出社团")) 
        elseif self.m_posttype == _G.Constant.CONST_CLAN_POST_COMMON then        --在帮众  
           
        end
        if false == false then --如果不是好友就显示加好友
            self.m_tagLayout :addChild( self: createButton( "加为好友", "general_label_click.png", CallBack, CFactionPopupView.TAG_ADDFRIEND, "加为好友")) 
        end
    end   
    self.m_tagLayout :addChild( self.m_examineButton)      
end

function CFactionPopupView.clickCellCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("nTag:",obj :getTag())
        if obj :getTag() == CFactionPopupView.TAG_TRANSFER then
            print( "转让社长")
            require "common/protocol/auto/REQ_CLAN_ASK_SET_POST"
            local msg = REQ_CLAN_ASK_SET_POST()
            msg :setUid( self.m_role.uid)
            msg :setPost( _G.Constant.CONST_CLAN_POST_MASTER)
            _G.CNetwork :send( msg)
        elseif obj :getTag() == CFactionPopupView.TAG_APPOINTMENT then
            print( "任命副社长")
            -- (手动) -- [33135]请求设置成员职位 -- 社团
            require "common/protocol/auto/REQ_CLAN_ASK_SET_POST"
            local msg = REQ_CLAN_ASK_SET_POST()
            msg :setUid( self.m_role.uid)
            msg :setPost( _G.Constant.CONST_CLAN_POST_SECOND)
            _G.CNetwork :send( msg)
        elseif obj :getTag() == CFactionPopupView.TAG_REVOCATION then
            print( "撤销副社长")
            -- (手动) -- [33135]请求设置成员职位 -- 社团
            require "common/protocol/auto/REQ_CLAN_ASK_SET_POST"
            local msg = REQ_CLAN_ASK_SET_POST()
            msg :setUid( self.m_role.uid)
            msg :setPost( _G.Constant.CONST_CLAN_POST_COMMON)
            _G.CNetwork :send( msg)
        elseif obj :getTag() == CFactionPopupView.TAG_EXCLUDING then
            print( "剔除社员")
            -- (手动) -- [33135]请求设置成员职位 -- 社团
            require "common/protocol/auto/REQ_CLAN_ASK_SET_POST"
            local msg = REQ_CLAN_ASK_SET_POST()
            msg :setUid( self.m_role.uid)
            msg :setPost( _G.Constant.CONST_CLAN_POST_OUT)
            _G.CNetwork :send( msg)
        elseif obj :getTag() == CFactionPopupView.TAG_EXAMINE then
            print( "查看信息:")
            --请求玩家身上装备 --本玩家
            print("请求玩家身上装备开始")
            local msg = REQ_GOODS_EQUIP_ASK()
            msg :setUid( self.m_role.uid)
            msg :setPartner( 0)
            _G.CNetwork :send( msg)
            print("请求玩家身上装备结束")
            print("请求玩家属性开始:"..(self.m_role.uid))
            local msg_role = REQ_ROLE_PROPERTY()
            msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
            msg_role: setUid( self.m_role.uid )
            msg_role: setType( 0 )
            _G.CNetwork : send( msg_role )
            print("请求玩家属性结束")
            --人物接口
        elseif obj :getTag() == CFactionPopupView.TAG_ADDFRIEND then
            print( "添加好友")
            require "common/protocol/auto/REQ_FRIEND_ADD"
            local sendList = {}
            sendList[1]  = self.m_role.uid
            local msg = REQ_FRIEND_ADD()
            msg :setType( 1)
            msg :setCount( #sendList)
            msg :setDetail( sendList)
            CNetwork :send( msg)
        end
        --删除Tips
        _G.g_FactionPopupView :reset()
    end
end


