local lineChart = require("googleCharts.lineChart")
local barChart = require("googleCharts.barChart")
local scatterChart = require("googleCharts.scatterChart")


local M = {}


function M.createChart(options)
	local HTML = ""
	local path = nil
	if options.chartType == "line" then 
		HTML, path = lineChart.construct(options)
	elseif options.chartType == "bar" then 
		HTML, path = barChart.construct(options)
	elseif options.chartType == "scatter" then --At the time of writting this only supported by 1.0
		HTML, path = scatterChart.construct(options)
	end
	print("creatingChart",options.width,options.height,path)
	print("xy",options.x, options.y)
	local webView = native.newWebView(  options.x, options.y, options.width, options.height  )
	webView:request( (options.file or "chart.html"), system.DocumentsDirectory )
	webView.anchorX = options.anchorX or 0
	webView.anchorY = options.anchorY or 0
	return webView
end


return M