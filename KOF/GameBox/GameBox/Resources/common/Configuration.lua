_G.ConfigNode = class(function(self,root)
    rawset(getmetatable(self), "root", root)
end)
getmetatable(_G.ConfigNode).__index = function(self, key)
    local cn = _G.ConfigNode(rawget(self,"root").."/"..key)
    return cn
end
function _G.ConfigNode.selectSingleNode(self, xpath)
    local r = CConfigurationCache:sharedConfigurationCache():getRootElement(self.root)
    if r ~= nil then
        return r:selectSingleNode(xpath)
    else
        return nil
    end
end

_G.Config = class(function(self)
end)
function Config.load(self, url)
    if url == nil then
        CCLOG("路径错误,为空")
    end
    --优先读C，再读源
    if _G.PathCheck:check(url) then
        return CConfigurationCache:sharedConfigurationCache():load(url)
    end
    local c = string.gsub(url,"(%a+)/(%a+)","%1/configc/%2")
    if _G.PathCheck:check(c) then
        return CConfigurationCache:sharedConfigurationCache():load(c)
    else
        return CConfigurationCache:sharedConfigurationCache():load(url)
    end
end
function Config.unload(self, url)
    if url == nil then
        CCLOG("路径错误,为空")
    end
    if _G.PathCheck:check(url) then
        return CConfigurationCache:sharedConfigurationCache():unload(url)
    end
    local c = string.gsub(url,"(%a+)/(%a+)","%1/configc/%2")
    if _G.PathCheck:check(c) then
        return CConfigurationCache:sharedConfigurationCache():unload(c)
    else
        return CConfigurationCache:sharedConfigurationCache():unload(url)
    end
end
getmetatable(_G.Config).__index = function(self, key)
    local cn = _G.ConfigNode(key)
    return cn
end


--[[

_G.Config:load("config/scene_monster.xml")
    print("gagagagagagaga")
    local v = _G.Config.scene_monsters:selectSingleNode("scene_monster[@id=101]")
    print("asdfasdfasdfadf")
    print("--->", v:children():get(1,"skills"):getAttribute("skill_att") )
    v:getCount("skills")
    v:getCount()
    v:selectSingleNode("skills[@k=2]")


    "scene_monster[0]"
    local v = _G.Config.scene_monsters:selectSingleNode("scene_monster[@id=101]/skills[@k=2]")

]]

--[[
--读取xml
_G.Config:load("config/scene_monster.xml")

--这个变量不能用 ~= 和 == 判断 如果在不确定他是否存在..请再load一次
_G.Config.scene_monsters


--以下取出的值都可以用 ~= 和 == 判断 是否为nil
-- 以scene_monster.xml为例,第一个节点scene_monsters   取出 scene_monster id为 10000的子节点
--每个节点下都有selectSingleNode函数
    local node = _G.Config.scene_monsters : selectSingleNode("scene_monster[@id=10000]")

--取出 当前节点的 属性用 getAttribute
    local value = node : getAttribute("lv")

--每一个 node 都有一个children函数 他返回所有他的子节点.我们再用get函数取出这个子节点
    local child = node : children()

    --返回父节点下有多少个attr子节点,拥有一个就返回1 循环的时候从0开始到1,别越界,注意
    local count = child : getCount("attr")

    --get的用法 第一个是index 从0开始,  意思取出 假如父节点下有很多个attr这个node 我们取出第一个,
    local nextnode = child : get(0,"attr")



--还可以使用一下方法取出.不过...感觉没什么大用处
_G.Config.scene_monsters : selectSingleNode( "scene_monster[@id=101]/skills[@k=2]" )
]]
