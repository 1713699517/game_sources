require "view/view"
require "mediator/mediator"

template_view = class(view, function(self)
    
end)

function template_view.setViewMethodXXX( self, data )
    --
    CCLOG("data="..tostring(data))
end