
CTransportXMLManager = class(function ( self )
    self : load()
end)





function CTransportXMLManager.load( self )
    _G.Config:load("config/scene_door.xml")
end

function CTransportXMLManager.getXMLTransport( self, _doorID )
    local str = "scene_door[@door_id="..tostring(_doorID).."]"
    return _G.Config.scene_doors:selectSingleNode(str)
end








_G.TransportXMLManager = CTransportXMLManager()


