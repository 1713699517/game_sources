require "mediator/mediator"
require "controller/command"

CunLoadIconSources = class(function(self)
    self.data  = {}
    self.count = 0
end)
--icon名字添加 每创建一个icon后就添加进去 
--单个界面调用 unLoadAllIcons            传进来是一个icon名字 删除在关闭界面的时候删除就行  方法放在删除页面后调用
--多个界面调用 unLoadAllIconsByNameList  传进来是一个列表     即需要自己页面去存储         方法放在删除页面后调用

-----------------单界面方法调用---------------------------------------------------------------------
function CunLoadIconSources.addIconData(self,icon)
    self.count      = self.count + 1
    self.data.count = self.count
    
    local no        = self.count
    self.data[no]   = icon
end

function CunLoadIconSources.unLoadAllIcons(self)
	print("++++++++++++++++++++++++++++++++++++#")
    if self.data ~= nil then
    	local data  = self.data
        local loops = self.data.count
        if loops ~= nil and  loops > 0 then
        	for i=1,loops do
        		local icon_url = "Icon/i"..data[i]..".jpg"
                --local icon_url = "HeadIconResources/role_head_0"..data[i]..".jpg"
        		print("CunLoadIconSources.unLoadAllIcons=========",i,"------",data[i])
        		local r        = CCTextureCache :sharedTextureCache():textureForKey(icon_url)
	            if r ~= nil then
	                CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
	                CCTextureCache :sharedTextureCache():removeTexture(r)
	                r = nil
	            end
        	end

        end
    end
    self.data  = {}
    self.count = 0
end

-----------------多界面方法调用---------------------------------------------------------------------
function CunLoadIconSources.unLoadAllIconsByNameList(self,List)
    if List ~= nil then
        for i,v in ipairs(List) do
            local r        = CCTextureCache :sharedTextureCache():textureForKey(v)
            if r ~= nil then
                CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
                CCTextureCache :sharedTextureCache():removeTexture(r)
                r = nil
            end
        end
    end
end

function CunLoadIconSources.unLoadCreateResByName( self, _name )
    
    if _name ~= nil then
        
        local r        = CCTextureCache :sharedTextureCache():textureForKey(_name)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
        
    end
    
end


_G.g_unLoadIconSources = CunLoadIconSources()


