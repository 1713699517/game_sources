CViewManager = class(function(self)
	if _G.glViewId == nil then
		_G.glViewId = 100
	end
	self.id = _G.glViewId
end)

function CViewManager.createViewID(self, _view)
	self.id = self.id + 1
	if self._tblViews == nil then
		self._tblViews = {}
	end
	self._tblViews[ self.id ] = _view
	return self.id
end

function CViewManager.getViewByID(self, _viewID)
	return self._tblViews[ _viewID ]
end

_G.ViewManager = CViewManager()


view = class(function(self)
	self._viewID = _G.ViewManager:createViewID(self)
end)


function view.getViewID(self)
	return self._viewID
end

function view.getView(self)
	return _G.ViewManager:getViewByID(self._viewID)
end