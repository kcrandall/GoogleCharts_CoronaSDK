print("------------------------------------------------------")
--------------------------------------------------------------------
--------------------------------------------------------------------
-- Created by Keston Crandall
--------------------------------------------------------------------
--------------------------------------------------------------------
--Uncomment the variables "random" to create a chart of that type.
-- https://developers.google.com/chart/interactive/docs/reference
-- The code basically creates an HTML document with Javascript and loads it into a webview.
--------------------------------------------------------------------
--------------------------------------------------------------------

local charts = require("googleCharts.createChart")

--------------------------------------------------------------------
--------------------------------------------------------------------
-- MATERIAL CHARTS version 1.1
--------------------------------------------------------------------
--------------------------------------------------------------------

--Line
local options = {
	x = 0,
	y = 0, 
	anchorX = 0,
	anchorY = 0,
	width = 800,--display.contentWidth, 
	height = 888,--display.contentHeight,
	file = "chart.html",
	version = "1.1",
	chartType = "line",
	design = "material",
	elementByID = "linechart_material",
	data = {
		{1,1,1},
		{2,2,3},
		{3,4,3},
		{4,5,3},
		{5,8,3},
	},
	columns = {
		{name = "days"},
		{name = "line 1"},
		{name = "line 2"},
	},
	options = {
		chart = {
			title = 'Random',
			subtitle = "randomrandom",
		},
	},
}
--random = charts.createChart(options)

--Bar chart
local options = {
	x = 0,
	y = 0, 
	anchorX = 0,
	anchorY = 0,
	width = 800,--display.contentWidth, 
	height = 888,--display.contentHeight,
	file = "line.html",
	version = "1.1",
	packages = {'bar'},
	chartType = "bar",
	design = "material",
	elementByID = "barchart_material",
	data = {
		{"asd","asdf","asdf"},
		{"df",2,3},
		{"hhg",4,3},
		{"4hh",5,3},
		{"5234fs",8,3},
	},

	options = {
		chart = {
			title = 'Randoms',
			subtitle = "randomrandom",
		},
		bars = 'horizontal',
	},
}
--random = charts.createChart(options)


--------------------------------------------------------------------
--------------------------------------------------------------------
-- CORE CHARTS (non-material) version 1
--------------------------------------------------------------------
--------------------------------------------------------------------
--Line
local options = {
	x = 0,
	y = 0, 
	anchorX = 0,
	anchorY = 0,
	file = "line.html",
	width = 800,
	height = 800,
	version = "1",
	chartType = "line",
	design = "coreChart",
	elementByID = "curve_chart",
	data = {
		{"X Axis","Line2","Line3"},
		{2,2,3},
		{3,4,3},
		{4,5,3},
		{5,8,3},
	},
	--[[columns = {
		{name = "days"},
		{name = "line 1"},
		{name = "line 2"},
	},]]
	options = {
		title = 'Random',
		subtitle = "randomrandom",
		cureType = "function",
		hAxis = {
			title = "X axis"
		},
		vAxis = {
			title = "Y axis"
		},
		colors =  {'#AB0D06', '#007329'},
		--backgroundColor = '#f1f8e9',
		--lineWidth = 3,
		trendlines = {
			{type = 'exponential', color = '#333', opacity = 1},
		},
		series = {
			{skip = true},
			{lineWidth = 5, lineDashStyle = {5,1,5}},
		},
		crosshair = {
			color = '#000',
			trigger = "selection",
		},
	},
}
--random = charts.createChart(options)

--Bar
local options = {
	x = 0,
	y = 0, 
	anchorX = 0,
	anchorY = 0,
	file = "bar.html",
	width = 500,
	height = 500,
	version = "1",
	chartType = "bar",
	design = "coreChart",
	elementByID = "chart_div",
	data = {
		{"X Axis","Line2","Line3"},
		{2,2,3},
		{3,4,3},
		{4,5,3},
		{5,8,3},
	},

	options = {
		title = 'Random',
		subtitle = "randomrandom",
		cureType = "function",
		hAxis = {
			title = "X axis"
		},
		vAxis = {
			title = "Y axis"
		},
		colors =  {'#AB0D06', '#007329'},
		--backgroundColor = '#f1f8e9',
		--lineWidth = 3,
		trendlines = {
			{type = 'exponential', color = '#333', opacity = 1},
		},
		series = {
			{skip = true},
			{lineWidth = 5, lineDashStyle = {5,1,5}},
		},
	},
}
--random = charts.createChart(options)



--SCATTER
local options = {
	x = 0,
	y = 0, 
	anchorX = 0,
	anchorY = 0,
	file = "scatter.html",
	width = 500,
	height = 500,
	version = "1",
	chartType = "scatter",
	design = "coreChart",
	elementByID = "chart_div",
	data = {
		{"X Axis","Line2"},
		{2,2},
		{3,4},
		{4,5},
		{5,8},
	},
	options = {
		title = 'Random',
		subtitle = "randomrandom",
		cureType = "function",
		hAxis = {
			title = "X axis"
		},
		vAxis = {
			title = "Y axis"
		},
		colors =  {'#AB0D06', '#007329'},
		--backgroundColor = '#f1f8e9',
		--lineWidth = 3,
		trendlines = {
			{type = 'linear', color = '#333', opacity = 1, visibleInLegend = true},
		},
	},
}
--random = charts.createChart(options)

--transition.to(random, {x = -display.contentWidth, time=500})

