CPointView = class()


function CPointView.loadResource(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("bagResurece/bag.plist")
end

function CPointView.onLoadedResource(self)
    
end

function CPointView.menuCallbackTouchBegan(obj,x, y)
    CCLOG("began 1111")
    return true
end


function CPointView.menuCallbackTouchMoved(obj,x, y)
    CCLOG("moved 2222")
    
end

function CPointView.menuCallbackTouchEnded(obj,x, y)
    CCLOG("ended 3333")
    
    
    
    
end

function CPointView.menuCallbackOpenPopup(eventType,obj,x, y)
    print(obj:getTag())
    -- loop test sound effect
    CCLOG("menuCall="..eventType.." x="..tostring(x).." y="..tostring(y) )
    if eventType == "TouchBegan" then
        return CBagInfoScene.menuCallbackTouchBegan(obj,x, y)
    elseif eventType == "TouchMoved" then
        CBagInfoScene.menuCallbackTouchMoved(obj,x, y)
    elseif eventType == "TouchEnded" then
        CBagInfoScene.menuCallbackTouchEnded(obj,x, y)
    end
end


--适配布局
function CPointView.layout(self, winSize)
    --640
    if winSize.height == 640 then
        
        CCLOG("640--资源")
        local nPosX = 55

        
        self.point :setPosition(300,520)

        
        elseif winSize.height == 768 then
        CCLOG("768--资源")
    end
end


function CPointView.initParameter(self,layer)
    self.point = nil
end

function CPointView.ReleaseParameter(self)

    self.point = nil

end

--初始化
function CPointView.init(self, winSize, layer)
    
    
    --加载资源
    self:loadResource()
    
    self:initParameter(layer)
    

    self :addPoint(layer)
    

    -- 布局
    self.layout(self, winSize)
end




function CPointView.addPoint(self,layer)
    self.point = CHorizontalLayout :create()
    layer : addChild(self.point)
    
    self.point :setCellSize(CCSizeMake(13,13))
    self.point :setCellHorizontalSpace(20)
    self.point :setHorizontalDirection(true)
    local selectPoint = {}
    for i=1,4,1 do
        selectPoint[i] = CButton :createWithSpriteFrameName("","smollpoint.png")
        selectPoint[i] : setControlName( "this CPointView selectPoint[i] 103 "..tostring(i) )

        selectPoint[i] :registerControlScriptHandler(self.menuCallbackOpenPopup, "this CPointView selectPoint[i] 105")
        self.point :addChild(selectPoint[i],0,i)
    end
end




function CPointView.scene(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CCScene :create()
    
    layer = CCLayer :create()
    self :init(winSize, layer)
    scene :addChild(layer)
    
    return scene
end
