selectServer_model = class(function(self)
    self.myData1 = 100
    self.myData2 = "test"
    self.myData3 = 3.33
    self.scrollView = {}
end)

function selectServer_model.setData1( self, data1 )
self.myData1 = data1
end

function selectServer_model.getData1( self )
return self.myData1
end

function selectServer_model.setData2( self, data2 )
self.myData2 = data2
end

function selectServer_model.getData2( self )
return self.myData2
end


--[[
local tdata = test_model()
tdata:setData1(200)
]]

