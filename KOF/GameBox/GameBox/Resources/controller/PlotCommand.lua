require "controller/command"

CPlotCammand = class(command, function(self, VO_data, plotId)
	self.type = "TYPE_CPlotCammand"
	self.data = VO_data
	self.plotId = plotId
end)

CPlotCammand.TYPE   = "TYPE_CPlotCammand"
CPlotCammand.START  = "plot_start"
CPlotCammand.FINISH = "plot_finish"


function CPlotCammand.getData(self)
    return self.data
end

function CPlotCammand.getPlotId(self)
    return self.plotId
end

function CPlotCammand.setType(self,CommandType)
    self.type = CommandType
end

function CPlotCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CPlotCammand.getOtheData(self)
	return self.otherData
end


