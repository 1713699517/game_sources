require "mediator/mediator"
require "controller/NetworkAsyncCommand"

CWaitMediator = class(mediator, function(self, _view)
    self.name = "WaitMediator"
    self.view = _view
    self.now_delayTime = nil --延迟时间 绝对时间
    self.addHandle = nil --回调函数句柄
    self.dispHandle = nil
    self.waitSprite = nil --等待图片
end)

CWaitMediator.WAIT_SPRITE_TAG = 25000

function CWaitMediator.getView(self)
    return CCDirector : sharedDirector() : getRunningScene()
end

function CWaitMediator.getName(self)
    return self.name
end

function CWaitMediator.processCommand(self, _command)
    --接收自己客户端
    if _command:getType() == CNetworkAsyncCommand.TYPE then
        print("CWaitMediator1")
        local nowScene = self : getView()
        if nowScene == nil then
            return
        end
        print("CWaitMediator2")
        local act = _command :getAction()
        local data = _command : getData()
        if act == CNetworkAsyncCommand.ACT_WAIT then
        print("CWaitMediator3")
            self : wait( nowScene, data )
        print("CWaitMediator4")
        elseif act == CNetworkAsyncCommand.ACT_CONTINUE then
        print("CWaitMediator5")
            self : continue( nowScene )
        print("CWaitMediator6")
        end
    end
    return false
end


function CWaitMediator.wait( self, _nowScene, _data )
    -- if self.waitScene ~= nil then
    --     local waiter = self.waitScene:getChildByTag( self.WAIT_SPRITE_TAG )
    --     if waiter ~= nil then
    --         return
    --     end
    -- end
    -- if self.dispHandle ~= nil then
    --     _G.Scheduler : unschedule( self.dispHandle )
    --     self.dispHandle = nil
    -- end
    if self.addHandle ~= nil then
        _G.Scheduler : unschedule( self.addHandle )
        self.addHandle = nil
    end
    if self.dispHandle ~= nil then
        _G.Scheduler : unschedule( self.dispHandle )
        self.dispHandle = nil
    end
    local function disapper()
        self:continue( )
        if _G.CNetwork:isConnected() then
            _G.CNetwork:disconnect()
        else
            CCNotificationCenter:sharedNotificationCenter():postNotification("DISCONNECT_MESSAGE")
        end
    end
    local function add(  )
        local nowScene = CCDirector : sharedDirector() : getRunningScene()
        local waitSprite = nowScene :getChildByTag( self.WAIT_SPRITE_TAG )
        if waitSprite ~= nil then
            waitSprite : removeFromParentAndCleanup( true )
        end
        waitSprite = nil
        -- self.waitScene = nowScene
        local waitSprite = CSprite : create( "loading.png" )

        waitSprite : setTag( self.WAIT_SPRITE_TAG )
        local action = CCRotateBy:create(2/4, 90)

        local director = CCDirector :sharedDirector()
        local winSize = director : getWinSize()
        waitSprite : setPosition(winSize.width/2,winSize.height/2)
        local foreverAction = CCRepeatForever : create( action )
        CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents(false)
        waitSprite : runAction( foreverAction )
        nowScene : addChild( waitSprite, self.WAIT_SPRITE_TAG )

        if self.addHandle ~= nil then
             _G.Scheduler : unschedule( self.addHandle )
             self.addHandle = nil
        end

        --self.handle = _G.Scheduler : performWithDelay( _data:getDelayTime(), disapper )
        self.dispHandle = _G.Scheduler : performWithDelay( 20, disapper )
        disapper = nil
    end
    self.addHandle = _G.Scheduler : performWithDelay( 0.1, add )
    add = nil
    -- local delayTime = _data : getDelayTime()
    -- self.handle = _G.Scheduler : performWithDelay( delayTime, add )
end

function CWaitMediator.continue( self, _nowScene )
    CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents( true )
    if self.addHandle ~= nil then
        _G.Scheduler : unschedule( self.addHandle )
        self.addHandle = nil
    end
    if self.dispHandle ~= nil then
        _G.Scheduler : unschedule( self.dispHandle )
        self.dispHandle = nil
    end
    local nowScene = CCDirector : sharedDirector() : getRunningScene()
    local waitSprite = nil
    if nowScene ~= nil then
        waitSprite =  nowScene :getChildByTag( self.WAIT_SPRITE_TAG )
    end

    if waitSprite ~= nil then
        waitSprite : removeFromParentAndCleanup( true )
    end
end