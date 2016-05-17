
--[[
    game color manager
--]]

CColorManager = class(function ( self )
	self : init()
end)


function CColorManager.init( self )
    self.m_color = {}
    self.m_color[_G.Constant.CONST_COLOR_GRAY]       = {r=150,  g=150,   b=150,  a=255}  --颜色-灰
    self.m_color[_G.Constant.CONST_COLOR_WHITE]      = {r=255,  g=255,   b=255,  a=255}  --颜色-白
    self.m_color[_G.Constant.CONST_COLOR_GREEN]      = {r=30 ,  g=227,   b=10 ,  a=255}  --颜色-绿
    self.m_color[_G.Constant.CONST_COLOR_BLUE]       = {r=0  ,  g=150,   b=255,  a=255}  --颜色-蓝
    self.m_color[_G.Constant.CONST_COLOR_VIOLET]     = {r=138,  g=0  ,   b=255,  a=255}  --颜色-紫
    self.m_color[_G.Constant.CONST_COLOR_GOLD]       = {r=255,  g=240,   b=0  ,  a=255}  --颜色-黄
    self.m_color[_G.Constant.CONST_COLOR_ORANGE]     = {r=255,  g=96 ,   b=0  ,  a=255}  --颜色-橙
    self.m_color[_G.Constant.CONST_COLOR_RED]        = {r=255,  g=0  ,   b=0  ,  a=255}  --颜色-红
    self.m_color[_G.Constant.CONST_COLOR_CYANBLUE]   = {r=0  ,  g=255,   b=162,  a=255}  --颜色-青
    self.m_color[_G.Constant.CONST_COLOR_MOONLIGHT]  = {r=0  ,  g=234,   b=255,  a=255}  --颜色-月光
    self.m_color[_G.Constant.CONST_COLOR_AMBER]      = {r=252,  g=0  ,   b=255,  a=255}  --颜色-琥珀
end

function CColorManager.getColor( self, _colorID )
    --if self.m_color[_colorID] ~= nil then
    --    return self.m_color[_colorID]
    --else --error 没有找到 显示黑色
    --    return {r=0,  g=0  ,b=0,  a=255}
    --end
    return self.m_color[tonumber(_colorID)]
end

function CColorManager.getRGB( self, _colorID )
    _colorID = tonumber(_colorID)
    if self.m_color[_colorID] ~= nil then
        return ccc3( self.m_color[_colorID].r, self.m_color[_colorID].g, self.m_color[_colorID].b)
    else --error 没有找到 显示黑色
        return ccc3( 0, 0, 0)
    end
end

function CColorManager.getRGBA( self, _colorID )
    _colorID = tonumber(_colorID)
    if self.m_color[_colorID] ~= nil then
        return ccc4( self.m_color[_colorID].r, self.m_color[_colorID].g, self.m_color[_colorID].b, self.m_color[_colorID].a)
    else --error 没有找到 显示黑色
        return ccc4( 0, 0, 0, 255)
    end
end

function CColorManager.getColorString( self, _colorID )
    _colorID = tonumber(_colorID)
    if self.m_color[_colorID] ~= nil then
        return "<color:"..self.m_color[_colorID].r..","..self.m_color[_colorID].g..","..self.m_color[_colorID].b..","..self.m_color[_colorID].a..">"
    else --error 没有找到 显示黑色
        return "<color:0, 0, 0,255>"
    end
end

_G.g_ColorManager = CColorManager()