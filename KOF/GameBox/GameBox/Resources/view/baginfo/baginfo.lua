
require "view/baginfo/pointView"
CBagInfoScene = class()


function CBagInfoScene.loadResource(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("bagResurece/bag.plist")
end

function CBagInfoScene.onLoadedResource(self)
    
end

function CBagInfoScene.menuCallbackTouchBegan(obj,x, y)
    CCLOG("began 1111")
    
    local size = CCSizeMake(300,300)
  --  local bg = CCScale9Sprite :create("bagclose.png")
 --  obj.view.tips = CMenu :create(size,2,bg)
    
    local btn = CButton :create("","bagclose.png")
    btn : setControlName( "this CBagInfoScene btn 22 " )
   -- local ttf = CCLabelTTF :create()
   -- ttf :setString("这是装备的信息")
   -- obj.view.tips :addChild(btn)
   -- obj.view.tips :addChild(ttf)

    
    
    
    return true
end


function CBagInfoScene.menuCallbackTouchMoved(obj,x, y)
    CCLOG("moved 2222")
    
end

function CBagInfoScene.menuCallbackTouchEnded(obj,x, y)
    CCLOG("ended 3333")
    

    
  
end

function CBagInfoScene.menuCallbackOpenPopup(eventType,obj,x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
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
end


--适配布局
function CBagInfoScene.layout(self, winSize)
    --640
    if winSize.height == 640 then
        
        CCLOG("640--资源")
        local nPosX = 55
        
        self.m_layout :setPosition(100,500)
       -- self.spriteBg :setPosition(130,250)
        self.baglayout :setPosition(130,450)
        
        self.point :setPosition(300,520)
        self.closeBtn :setPosition(600,600)
        self.labelvolume :setPosition(300,40)
        
        elseif winSize.height == 768 then
        CCLOG("768--资源")
    end
end


function CBagInfoScene.initParameter(self,layer)
    self.m_layout = nil
    self.baglayout = nil
   -- self.spriteBg = nil
    self.point = nil
    self.closeBtn = nil
    self.labelvolume = nil
    self.tips = nil
    self.selectBtn = nil
    
end

function CBagInfoScene.ReleaseParameter(self)
    self.m_layout = nil
    self.baglayout = nil
   -- self.spriteBg = nil
    self.point = nil
    self.closeBtn = nil
    self.labelvolume = nil
    self.tips = nil
    self.selectBtn = nil
end

--初始化
function CBagInfoScene.init(self, winSize, layer)
 

    --加载资源
    self:loadResource()
    
    self:initParameter(layer)
    
    self:addTag(layer)
    
    self :addBagInfo(layer)
    
    self :addPoint(layer)
    
    self.closeBtn = CButton :createWithSpriteFrameName("","bagclose.png")
    self.closeBtn : setControlName( "this CBagInfoScene self.closeBtn 127 " )
    self.closeBtn :registerControlScriptHandler(self.closeScene, "this CBagInfoScene self.closeBtn 129")
    layer :addChild(self.closeBtn)
    
    self.labelvolume = CCLabelTTF :create()
    self.labelvolume :setString("容量" .. "99" .. "/" .. "999" )
    layer :addChild(self.labelvolume)
    
 
    -- 布局
    self.layout(self, winSize)
end

function CBagInfoScene.closeScene(eventType,obj,x,y)
    CCLOG("close")
end



function CBagInfoScene.addBagInfo(self,layer)
   -- self.spriteBg = CSprite :createWithSpriteFrameName("bagbg.png")
   
    --self.spriteBg :setPreferredSize(CCSizeMake(600,500))
    --layer :addChild(self.spriteBg,0,-1)

    
    self.baglayout = CHorizontalLayout :create()
    layer :addChild(self.baglayout)
    
    self.baglayout :setLineNodeSum(4)
    self.baglayout :setCellSize(CCSizeMake(98,98))
    self.baglayout :setVerticalDirection(false)
    
    
     self.selectBtn = {}
    for i=1,20,1 do
        self.selectBtn[i] = CButton :createWithSpriteFrameName("","equipcell.png")
        self.selectBtn[i] : setControlName( "this CBagInfoScene self.selectBtn[i] 165 "..tostring(i) )
        self.selectBtn[i] : registerControlScriptHandler(self.menuCallbackOpenPopup, "this CBagInfoScene self.selectBtn[i] 167")
        self.baglayout :addChild(self.selectBtn[i],0,i)
        
     end

end
--[[
function CBagInfoScene.checkinfo(eventType, obj,x, y)
    print(obj:getTag())
     
    
end
 --]]

function CBagInfoScene.addPoint(self,layer)
    self.point = CHorizontalLayout :create()
    layer : addChild(self.point)
    
    self.point :setCellSize(CCSizeMake(13,13))
    self.point :setCellHorizontalSpace(20)
    local selectPoint = {}
    for i=4,1,-1 do
        selectPoint[i] = CSprite :createWithSpriteFrameName("smollpoint.png")
        selectPoint[i] : setControlName( "this CBagInfoScene selectPoint[i] 190 ")
        self.point :addChild(selectPoint[i])
     end
end

function CBagInfoScene.addTag(self,layer)
    self.m_layout = CVerticalLayout : create()
    layer :addChild(self.m_layout)
    --self.m_layout :setPosition(100,100)
    self.m_layout :setColumnNodeSum(6)
    
    self.m_layout :setCellSize(CCSizeMake(50,60))
    self.m_layout :setVerticalDirection(false)
    --self.m_layout :setCellHorizontalSpace(10)

    local selectTagBtn = {}
    local label = {[1] = "道具",[2]= "装备",[3]="宝石",[4]="材料",[5]= "远程商店",[6]=""}
    
  
    for i =1,6,1 do
        selectTagBtn[i] = CButton :createWithSpriteFrameName(label[i],"forBth.png")
        selectTagBtn[i] : setControlName( "this CBagInfoScene selectTagBtn[i] 210 "..tostring(i) )
        selectTagBtn[i] :setColor(ccc4(255,0,255,255))
        selectTagBtn[i] :registerControlScriptHandler(self.selectTag, "this CBagInfoScene selectTagBtn[i] 213")
        
        self.m_layout :addChild( selectTagBtn[i],0,i)
    end

end

function CBagInfoScene.selectTag(eventType, obj,x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print(obj:getTag())
    end
end


function CBagInfoScene.scene(self)
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    local scene = CCScene :create()
    
    layer = CCLayer :create()
    self :init(winSize, layer)
    scene :addChild(layer)
    
    return scene
end
