-- 赛场入口小道(6张)
function _G.getMapData10161()
	return CBaseMapData(
			{ "Scene/m10117/m1001034.jpg","Scene/m10117/m1001035.jpg","Scene/m10117/m1001036.jpg" }, -- 路径
			1, -- 地图类型
			10161, -- 地图id
			10, -- 格子宽度
			10, -- 格子高度
			3070, -- 格子宽数
			640, -- 格子高数
			{

			}, -- 可走
			{ "Scene/m10117/m1001034.jpg","Scene/m10117/m1001035.jpg","Scene/m10117/m1001036.jpg","Scene/m10117/m1001034.jpg","Scene/m10117/m1001035.jpg","Scene/m10117/m1001034.jpg" } , --地图块 
			3070, -- 地图宽度
			640, -- 地图高度
			512, -- 地图块宽度
			285 -- 可行高度
		) 
end