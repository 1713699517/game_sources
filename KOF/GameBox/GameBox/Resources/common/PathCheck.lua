_G.PathCheck = class()

function PathCheck.check( self, _szPath )
    return CFileStream : existsFromResourcePath( _szPath ) or CFileStream : existsFromResourcePath( "060/Image@640/" .. _szPath )
end

function PathCheck.pathExists( self, _szPath )
    local isExists = CFileStream : existsFromResourcePath( _szPath )
    local isExists2 = CFileStream : existsFromResourcePath( "060/Image@640/" .. _szPath )
    if isExists == true or isExists2 == true then
        return true
    end
    self : WarningMessage( _szPath )
    return false
end

function PathCheck.WarningMessage( self, _szPath )
    local warningTitle = "Error Path"
    --CCMessageBox( _szPath, warningTitle )
    CCLOG(_szPath.."&"..warningTitle)
    error(_szPath..warningTitle)
end