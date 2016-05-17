--功能菜单 黄龙程
require "view/MainUILayer/SystemMenu"
require "controller/ChatCommand"
require "controller/ActivityIconCommand"
require "mediator/FunctionMenuMediator"
require "controller/GuideCommand"

CFunctionMenu = class(function(self)
    self.m_Container = CContainer :create()
    self.m_Container : setControlName( "this is CFunctionMenu self.m_Container 7  " )

    self.m_bOpenOrClose = false     --0为关闭， 1为打开
--CMenu

    _G.pCSMenuView = CSystemMenu()
end)

function CFunctionMenu.addMediator( self)
    self :removeMediator()
    
    _G.g_CFunctionMenuMediator = CFunctionMenuMediator( self)
    controller :registerMediator( _G.g_CFunctionMenuMediator)
end

function CFunctionMenu.removeMediator( self)
    if _G.g_CFunctionMenuMediator ~= nil then
        controller :unregisterMediator( _G.g_CFunctionMenuMediator)
        _G.g_CFunctionMenuMediator = nil
    end
end

--布局
function CFunctionMenu.layout(self, winSize)
    --640
    if winSize.height == 640 then
        
        --CCLOG("640--资源")
        local nMenuSize = self.m_menu : getContentSize();
        self.m_menu :setPosition( winSize.width-nMenuSize.width/2, nMenuSize.height/2)


        self.m_guideComtrol :setPosition( 50, 180)
    --768
    elseif winSize.height == 768 then
        
        CCLOG("768--资源")
        
    end
        
end


function CFunctionMenu.init(self, winSize, layer)
    
    
    CFunctionMenu.initView(self, layer)
    
    --布局
    self.layout(self, winSize)
    --self :addMediator()
    
    if _G.pCFunctionOpenProxy :getInited() then             --只要功能开放为true 就打开功能按钮
        if _G.pCFunctionOpenProxy :getIsVisible() == 2 then
            --self :setMenuStatus( true)
            _G.pCFunctionOpenProxy :setIsVisible( -1)
        end
        --_G.pCFunctionOpenProxy :setInited( false)
            
    end
end

function CFunctionMenu.realeaseParams( self )
    -- body
end

--初始化View
function CFunctionMenu.initView(self, layer)

    layer :addChild(self.m_Container)
    --moveto效果
    local function callback( eventType, obj, x, y )
        --CCLOG("\n----callback\n")
        if eventType == "TouchBegan" then
            
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
            
        elseif eventType == "TouchEnded" then
            self :setChatStatus()
            
            local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
            controller :sendCommand( closeCommand )
        end
    end

    self.m_menu = CButton :createWithSpriteFrameName("", "menu_function_button_close.png")
    self.m_menu : setControlName( "this CFunctionMenu self.m_menu 71 ")
    layer :addChild( self.m_menu, 20)
    self.m_menu : setTouchesPriority( -27 )
    self.m_menu : setTouchesEnabled(true)
    self.m_menu :registerControlScriptHandler( callback, "this CFunctionMenu self.m_menu 76") --self.menuCallback)


    local function local_guideCallBack( eventType, obj, x, y )
        if eventType == "TouchBegan" then
            print("------------,local_guideCallBack 111")
            return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
            
        elseif eventType == "TouchEnded" then
            if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
                print("------------,local_guideCallBack 2222")
                self:closeGuide()
                
                local closeCommand = CVipViewCommand( CVipViewCommand.CLOSETIPS )
                controller :sendCommand( closeCommand )
            end
        end
    end

    self.m_guideComtrol = CButton :createWithSpriteFrameName("屏蔽指引", "transparent.png")
    self.m_guideComtrol : setControlName( "this CFunctionMenu self.m_guideComtrol 71 ")
    --layer :addChild( self.m_guideComtrol, 20)
    self.m_guideComtrol : setTouchesPriority( -25 )
    self.m_guideComtrol : setTouchesEnabled(true)
    self.m_guideComtrol : registerControlScriptHandler( local_guideCallBack, "this CFunctionMenu self.m_guideComtrol 76") --self.menuCallback)


    self.m_guideButton = CButton :createWithSpriteFrameName( "", "transparent.png")
    self.m_guideButton : setControlName( "this CFunctionMenu self.m_guideButton 134 " )
    layer :addChild( self.m_guideButton, 20)

end

function CFunctionMenu.getMenuButton( self )
    return self.m_menu
end

function CFunctionMenu.getGuideButton( self )
    return self.m_guideButton
end

--设置聊天栏状态
function CFunctionMenu.setChatStatus( self )
    local _wayCommand = nil
    if self:getMenuStatus() == false then
        _wayCommand = CChatWindowedCommand(CChatWindowedCommand.HIDE)
        self :setMenuStatus( true )
    else
        _wayCommand = CChatWindowedCommand(CChatWindowedCommand.SHOW)
        self :setMenuStatus( false )
        
    end
    
    if _wayCommand ~= nil then
        controller:sendCommand( _wayCommand )
    end
end

function CFunctionMenu.btnCallback( eventType, obj, x, y )
    -- body

end

--关闭 menu   设置false
function CFunctionMenu.setMenuStatus( self, _bValue )
    --
    print("self:getMenuStatus()", _bValue, self:getMenuStatus())
    if self.m_bOpenOrClose == _bValue then
        return;
    elseif self.m_bOpenOrClose ~= _bValue then
        ----
        if self:getMenuStatus() == false then

            -------
            if self.m_leftMenu == nil then
                
                self.m_leftMenu = _G.pCSMenuView :scene()
                self.m_layer :addChild( self.m_leftMenu)
                
            elseif self.m_leftMenu ~= nil then
                _G.pCSMenuView   :removeMediator()
                self.m_leftMenu :removeFromParentAndCleanup( true)
                self.m_leftMenu = nil
                
                self.m_leftMenu = _G.pCSMenuView : scene()
                self.m_layer :addChild( self.m_leftMenu)
            end
            ------
            
        elseif self:getMenuStatus() == true then

            if _G.pCSMenuView ~= nil then 
                _G.pCSMenuView :removeAllIconCCBI()
            end

            -- if _G.pCActivityIconView ~= nil then
            --     print("在setMenuStatus 调用清除")
            --     _G.pCActivityIconView :removeAllIconCCBI()
            -- end
            --
            if  self.m_leftMenu ~= nil then
                _G.pCSMenuView   :removeMediator()
                self.m_leftMenu :removeFromParentAndCleanup( true)
                self.m_leftMenu = nil
            end
            --
            
        end
        ----
        self.m_bOpenOrClose = _bValue
    end
    --
    self :setGuiderState( _bValue)
    
    
    --local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END, _G.Constant.CONST_FUNC_OPEN_FUNTION )
    --controller:sendCommand(_guideCommand)
end

function CFunctionMenu.setGuiderState( self, _bValue)
    local _guiderCommand = nil
    if _bValue==true then
        _guiderCommand = CActivityIconCommand( CActivityIconCommand.HIDE)
    elseif _bValue== false then
        _guiderCommand = CActivityIconCommand( CActivityIconCommand.NOHIDE)
    end
    
    if _guiderCommand ~= nil then
        controller :sendCommand( _guiderCommand)
    end
end

--获取 menu状态
function CFunctionMenu.getMenuStatus(self)
   return self.m_bOpenOrClose
end

function CFunctionMenu.closeGuide( self )

    if _G.pCGuideMediator ~= nil then
        controller :unregisterMediator(_G.pCGuideMediator)
        _G.pCGuideMediator = nil
    end

    _G.pCGuideManager:removeAllGuide()
    _G.pCGuideManager:guideFinish()
end


function CFunctionMenu.scene(self)
    
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CContainer :create()
    scene : setControlName( "this is CFunctionMenu scene 134  " )
    self.m_layer = CCLayer :create()
    self :init( winSize, self.m_layer)
    

    scene :addChild( self.m_layer)
    return scene

    
end





