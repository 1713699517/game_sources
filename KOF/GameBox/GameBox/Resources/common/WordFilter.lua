
CWordFilter = class(function(self)
end)

function CWordFilter.initialize(self)
	_G.Config :load("config/w.xml")
end

function CWordFilter.destory(self)
	_G.Config :unload("config/w.xml")
end

function CWordFilter.hasBanWord(self, sentence)
	local node = _G.Config.words : selectSingleNode("filters[0]")
	local child = node : children()
	for i=0, child : getCount("word")-1 do
		local nextnode = child : get(i,"word")
		local value = nextnode : getAttribute("sh")
		--print(i,"word----->", value)
		local res = string.find(sentence, value) 
		if res ~= nil and res > 0 then
			return true
		end
	end
	return false
end

function CWordFilter.replaceBanWord(self, sentence)
	local node = _G.Config.words : selectSingleNode("filters[0]")
	local child = node : children()
	for i=0, child : getCount("word")-1 do
		local nextnode = child : get(i, "word")
		local value = nextnode : getAttribute("sh")
		--print(i,"word----->", value)
		if value ~= nil and type(value) == "string" then
			local res = string.find(sentence, value)
			if res ~= nil and res > 0 then
				sentence = string.gsub(sentence, value, string.rep("*", string.len(value)))
			end
		end
	end
	return sentence
end

_G.g_WordFilter = CWordFilter()

   
    