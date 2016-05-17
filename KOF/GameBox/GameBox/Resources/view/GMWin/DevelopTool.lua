require "common/protocol/auto/REQ_CHAT_GM"
require "common/Network"

CDevelopTool = class(view, function( self )
    print("GM命令初始化")
end)

function CDevelopTool.initView(self, _mainSize)

    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local t_w = _mainSize.width 
    local t_h = _mainSize.height - 20

    self.m_mainBg = CSprite :createWithSpriteFrameName( "peneral_background.jpg" )
    self.m_mainBg : setPreferredSize( winSize )
    self.m_scene  : addChild( self.m_mainBg, -1 )

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CDevelopTool self.m_mainContainer 62 ")
    self.m_scene :addChild( self.m_mainContainer )

    local function local_closeWin( eventType, obj, x, y )
        return self:closeWin( eventType, obj, x, y )
    end

    local function local_sendFun( eventType, obj, x, y )
        return self:sendFun( eventType, obj, x, y )
    end

    --创建主背景
    self.m_winBg = CCScale9Sprite : createWithSpriteFrameName("general_first_underframe.png")
    self.m_winBg : setPreferredSize( _mainSize )
    self.m_mainContainer : addChild ( self.m_winBg)
    --关闭按钮
    self.m_closeBtn = CButton : createWithSpriteFrameName("" , "general_close_normal.png" , "" , "general_close_normal.png" , false)
    self.m_closeBtn : setControlName( "this CDevelopTool self.m_closeBtn 62 ")
    self.m_closeBtn : registerControlScriptHandler (local_closeWin, "this CDevelopTool self.m_closeBtn 66")
    self.m_mainContainer : addChild ( self.m_closeBtn)
    
    
    local inputBg = CCScale9Sprite : createWithSpriteFrameName("general_underframe_normal.png")
    self.m_input  = CEditBox : create ( CCSizeMake(600 , 100) , inputBg ,100 , "" , kEditBoxInputFlagSensitive )
    self.m_input  : setFont( "Arial",48 )
    self.m_mainContainer : addChild(self.m_input)
    
    --发送按钮
    self.m_sendBtn = CButton : createWithSpriteFrameName("发送" , "general_smallbutton_click.png" )
    self.m_sendBtn : setControlName( "this CDevelopTool self.m_sendBtn 80 ")
    self.m_sendBtn : setColor ( ccc4 (255 , 255 ,255 , 255 ))
    self.m_sendBtn : setFontSize( 24 )
    self.m_sendBtn : registerControlScriptHandler( local_sendFun, "this CDevelopTool self.m_sendBtn 84")
    self.m_mainContainer : addChild(self.m_sendBtn)
    
    --显示文本
    self.m_showBg = CCScale9Sprite : createWithSpriteFrameName("general_underframe_normal.png")
    self.m_showBg : setPreferredSize ( CCSizeMake(700 , 450))
    
    self.m_mainContainer : addChild(self.m_showBg)
    self.m_showLab = CCLabelTTF : create ( )
    self.m_showLab : setFontSize(20)
    self.m_showLab : setDimensions(CCSizeMake(700 , 450)) 
    
    self.m_mainContainer : addChild(self.m_showLab)
    self : show("-----显示以下内容------")
    
end

function CDevelopTool.layout( self, _mainSize )
    -- body
    local winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBg        :setPosition( ccp( winSize.width/2, winSize.height/2 ) )
    self.m_mainContainer :setPosition( ccp( winSize.width/2 - _mainSize.width/2 , 0 ) )

    local closeBtnSize = self.m_closeBtn:getPreferredSize()
    local showBgSize   = self.m_showBg  :getPreferredSize()
    local sendBtnSize  = self.m_sendBtn :getPreferredSize()
    self.m_winBg    : setPosition ( _mainSize.width/2 , _mainSize.height/2)
    self.m_closeBtn : setPosition ( _mainSize.width - closeBtnSize.width/2 , _mainSize.height - closeBtnSize.height/2)
    self.m_input    : setPosition ( _mainSize.width/2-80,85)
    self.m_sendBtn  : setPosition ( _mainSize.width/2-80+showBgSize.width/2+5,85);
    self.m_showBg   : setPosition ( _mainSize.width/2-30 , 385)
    self.m_showLab  : setPosition ( _mainSize.width/2-30 , 385)
end

--显示内容
function CDevelopTool.show(self , str)
    self.str = self.str .. str.."\n"
    self.m_showLab : setString(self.str)
end



--加载资源
function CDevelopTool.loadResource( self)
    print("GM命令加载资源")
end

--释放资源
function CDevelopTool.unLoadResource( self)

end

function CDevelopTool.init( self, _mainSize )
    self :loadResource()
    self :initView( _mainSize )
    self :layout( _mainSize )
    _G.pCGuideManager:setIsCanStartGuide( false )
end


function CDevelopTool.scene(self)
    
    print("««««««««««««««««««««««««««««««««««««")
    print("GM命令")
    print("««««««««««««««««««««««««««««««««««««")

    local winSize  = CCDirector :sharedDirector():getVisibleSize() --得到场景的大小
    local mainSize = CCSizeMake( 854, winSize.height )
    self.m_scene = CContainer : create()
    self.m_scene : setControlName( "this is CDevelopTool self.m_scene 119  " )
    self.str = ""
    --创建内容
    self :init( mainSize )
    return self.m_scene
end

--关闭窗口
function CDevelopTool.closeWin( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
    elseif eventType == "TouchEnded" then
        if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            CCDirector : sharedDirector() : popScene()
            _G.pCGuideManager:setIsCanStartGuide( true )
            _G.pCGuideManager:removeAllGuide()
        end
    end
end


--发送函数
function CDevelopTool.sendFun( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
    elseif eventType == "TouchEnded" then
        local str = self.m_input : getTextString()
        CCLOG("发送了内容:" .. str)
        
        local msg = REQ_CHAT_GM()
        msg : setCommand(str)
        CNetwork : send(msg)
        --[[
        if string.find(str , "@lv %d+") then    --升级
            i , j = string.find(str , "@lv %d+");
            local data = tonumber( string.match(str , "%d+") );
            print("跳到升级命令" , i , j , data);
        elseif string.find(str , "@make %d+ %d+") then  --得到物品
            i , j = string.find(str , "@make %d+ %d+");
            print("得到物品命令" , i , j );
        elseif string.find(str , "@gold %d+") then  --增加元宝、铜钱、绑定元宝
            i , j = string.find(str , "@lv %d+");
            print("增加元宝、铜钱、绑定元宝命令" , i , j );
        else
            print("*******没有获得到命令字********");
        end;
        ]]
        
        self:show(str)
    end
end

