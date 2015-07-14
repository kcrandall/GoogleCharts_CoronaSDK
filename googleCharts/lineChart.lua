local M = {}



function M.construct(options)
	print("creating HTML")
	for k, v in pairs(options) do
		print(k,v)
	end
	local HTML = ""

	local chartType = ""
	-- SET UP 
	local version = options.version or "1.1"
	local name = options.name  or "visualization"
	local packages = nil
	if options.design == "material" then 
		packages = options.packages or {'line'}
	else
		packages = options.packages or {'corechart'} -- corechart or line(material design)
	end
	

	local elementByID = nil
	if options.elementByID == "material" then 
		elementByID = "linechart_material"
		chartType = "material"
	elseif options.elementByID == "curve" then 
		elementByID = "curve_chart"
		chartType = "normal"
	elseif options.elementByID == "topX" or options.elementByID == "topx" or options.elementByID == "top_x" then 
		--Note: topx is ONLY supported by MATERIAL CHARTS
		elementByID = "line_top_x"
		chartType = "material"
	else 
		elementByID = "curve_chart"
		chartType = "normal"
	end
	elementByID = options.elementByID


	local packageString = ""
	for i = 1, #packages do 
		if i == 1 then 
			packageString = "'" .. packages[i] .. "'"
		elseif i ~= 1 then 
			packageString = packageString .. "'" .. packages[i] .. "'"
		end
	end

	-- VAR OPTIONS

	-- If width and height arent set set them
	local optionsData = options.options
	if options.options.width == nil then 
		optionsData.width = options.width or 400
	end
	if options.options.height == nil then 
		optionsData.height = options.height or 400
	end

	-- Creates the options String 
	-- works with multidimensioal arrays like the google options require
	--- booleans, strings, arrays, and numbers are supported
	local optionsString = ""
	for k, v in pairs(optionsData) do -- first pairs
		-- add a line if not the first line
		if i ~= 1 then 
			optionsString = optionsString .. "\n"
		end
		--check if it needs its own pairs
		if type(v) == "table" and #v > 0 then 
			optionsString = optionsString .. k .. ": "

			-- This is for trendlines and series where the key is number
			-- which makes no sense because of variable naming convetions, but javascript is weird i guess.
			if type(v[1]) == "table" then 
				optionsString = optionsString .. "{\n"
				for i = 1, #v do 
					if v[i]["skip"] == nil then
						-- Have to subtract one because index starts at 0
						optionsString = optionsString .. tostring(i - 1) .. ": {" -- ex: 0: { 
						for k0,v0 in pairs(v[i]) do 
							optionsString = optionsString .. k0 .. ": "
							if type(v0) == "table" and #v0 > 0 then -- if its an array
								for d = 1, #v0 do 
									if d == 1 then 
										if v0[d] == "null" then
											optionsString = optionsString .. "[" .. "null" .. ""
										elseif type(v0[d]) == "string" then
											optionsString = optionsString .. "['" .. v0[d] .. "'"
										else
											if type(v0[d]) == "boolean" then 
												if v0[d] == true then 
													v0[d] = "true"
												else 
													v0[d] = "false"
												end
											end
											optionsString = optionsString .. "[" .. v0[d] .. ""
										end
									elseif d > 1 and d ~= #v0 then 
										if v0[d] == "null" then 
											optionsString = optionsString .. ", null" 	
										elseif type(v0[d]) == "string" then
											optionsString = optionsString .. ", '" .. v0[d] .. "'"	
										else
											if type(v0[d]) == "boolean" then 
												if v0[d] == true then 
													v0[d] = "true"
												else 
													v0[d] = "false"
												end
											end
											optionsString = optionsString .. ", " .. v0[d]
										end 
									elseif d > 1 and d == #v0 then 
										if v0[d] == "null" then 
											optionsString = optionsString .. ", " .."null" .. "],"
										elseif type(v0[d]) == "string" then
											optionsString = optionsString .. ", '" .. v0[d] .. "'],"			
										else
											if type(v0[d]) == "boolean" then 
												if v0[d] == true then 
													v0[d] = "true"
												else 
													v0[d] = "false"
												end
											end
											optionsString = optionsString .. ", " .. v0[d] .. "]"
										end 
									end
								end
							elseif v0 == "null" then 
								optionsString = optionsString .. " null" 	
							elseif type(v0) == "string" then
								optionsString = optionsString .. " '" .. v0 .. "'"	
							else
								if type(v0) == "boolean" then 
									if v0 == true then 
										v0 = "true"
									else 
										v0 = "false"
									end
								end
								optionsString = optionsString .. " " .. v0
							end 
							optionsString = optionsString .. ","
						end
						optionsString = optionsString .. "},\n"
					end
				end
				optionsString = optionsString .. "},"
			else -- start if its actually an array of values.. not an array of dict/hashes like above
				for d = 1, #v do 
					if d == 1 then 
						if v[d] == "null" then
							optionsString = optionsString .. "[" .. "null" .. ""
						elseif type(v[d]) == "string" then
							optionsString = optionsString .. "['" .. v[d] .. "'"
						else
							if type(v[d]) == "boolean" then 
								if v[d] == true then 
									v[d] = "true"
								else 
									v[d] = "false"
								end
							end
							optionsString = optionsString .. "[" .. v[d] .. ""
						end
					elseif d > 1 and d ~= #v then 
						if v[d] == "null" then 
							optionsString = optionsString .. ", null" 	
						elseif type(v[d]) == "string" then
							optionsString = optionsString .. ", '" .. v[d] .. "'"	
						else
							if type(v[d]) == "boolean" then 
								if v[d] == true then 
									v[d] = "true"
								else 
									v[d] = "false"
								end
							end
							optionsString = optionsString .. ", " .. v[d]
						end 
					elseif d > 1 and d == #v then 
						if v[d] == "null" then 
							optionsString = optionsString .. ", " .."null" .. "],"
						elseif type(v[d]) == "string" then
							optionsString = optionsString .. ", '" .. v[d] .. "'],"			
						else
							if type(v[d]) == "boolean" then 
								if v[d] == true then 
									v[d] = "true"
								else 
									v[d] = "false"
								end
							end
							optionsString = optionsString .. ", " .. v[d] .. "],"
						end 
					end
				end
			end
		elseif type(v) == "table" then 
			optionsString = optionsString .. k .. ": {\n"
			for k1, v1 in pairs(v) do -- second pairs
				print(k1,k[1])
				if type(v1) == "string"  then
					optionsString = optionsString .. k1 .. ": '" .. v1 .. "',"
				elseif type(v1) == "table" and #v1 > 0 then 
					optionsString = optionsString .. k .. ": "
					for d = 1, #v1 do 
						if d == 1 then 
							if v1[d] == "null" then
								optionsString = optionsString .. "[" .. "null" .. ""
							elseif type(v1[d]) == "string" then
								optionsString = optionsString .. "['" .. v1[d] .. "'"
							else
								if type(v1[d]) == "boolean" then 
									if v1[d] == true then 
										v1[d] = "true"
									else 
										v1[d] = "false"
									end
								end
								optionsString = optionsString .. "[" .. v1[d] .. ""
							end
						elseif d > 1 and d ~= #v1 then 
							if v1[d] == "null" then 
								optionsString = optionsString .. ", null" 	
							elseif type(v1[d]) == "string" then
								optionsString = optionsString .. ", '" .. v1[d] .. "'"	
							else
								if type(v1[d]) == "boolean" then 
									if v1[d] == true then 
										v1[d] = "true"
									else 
										v1[d] = "false"
									end
								end
								optionsString = optionsString .. ", " .. v1[d]
							end 
						elseif d > 1 and d == #v1 then 
							if v1[d] == "null" then 
								optionsString = optionsString .. ", " .."null" .. "],"
							elseif type(v1[d]) == "string" then
								optionsString = optionsString .. ", '" .. v1[d] .. "'],"			
							else
								if type(v1[d]) == "boolean" then 
									if v1[d] == true then 
										v1[d] = "true"
									else 
										v1[d] = "false"
									end
								end
								optionsString = optionsString .. ", " .. v1[d] .. "],"
							end 
						end
					end
				elseif type(v1) == "table" then 
					optionsString = optionsString .. k1 .. ": {\n"
					for k2, v2 in pairs(v1) do -- third pairs
						if type(v2) == "string" then
							optionsString = optionsString .. k2 .. ": '" .. v2 .. "',"
						elseif type(v2) == "table" and #v2 > 0 then 
							optionsString = optionsString .. k .. ": "
							for d = 1, #v2 do 
								if d == 1 then 
									if v2[d] == "null" then
										optionsString = optionsString .. "[" .. "null" .. ""
									elseif type(v2[d]) == "string" then
										optionsString = optionsString .. "['" .. v2[d] .. "'"
									else
										if type(v2[d]) == "boolean" then 
											if v2[d] == true then 
												v2[d] = "true"
											else 
												v2[d] = "false"
											end
										end
										optionsString = optionsString .. "[" .. v2[d] .. ""
									end
								elseif d > 1 and d ~= #v2 then 
									if v2[d] == "null" then 
										optionsString = optionsString .. ", null" 	
									elseif type(v2[d]) == "string" then
										optionsString = optionsString .. ", '" .. v2[d] .. "'"	
									else
										if type(v2[d]) == "boolean" then 
											if v2[d] == true then 
												v2[d] = "true"
											else 
												v2[d] = "false"
											end
										end
										optionsString = optionsString .. ", " .. v2[d]
									end 
								elseif d > 1 and d == #v2 then 
									if v2[d] == "null" then 
										optionsString = optionsString .. ", " .."null" .. "],"
									elseif type(v2[d]) == "string" then
										optionsString = optionsString .. ", '" .. v2[d] .. "'],"			
									else
										if type(v2[d]) == "boolean" then 
											if v2[d] == true then 
												v2[d] = "true"
											else 
												v2[d] = "false"
											end
										end
										optionsString = optionsString .. ", " .. v2[d] .. "],"
									end 
								end
							end
						else
							if type(v2) == "boolean" then 
								if v2 == true then 
									v2 = "true"
								else 
									v2 = "false"
								end
							end
							optionsString = optionsString .. k2 .. ": " .. v2 .. ","
						end
					end
					optionsString = optionsString .. "},"
				else
					if type(v1) == "boolean" then 
						if v1 == true then 
							v1 = "true"
						else 
							v1 = "false"
						end
					end
					optionsString = optionsString .. k1 .. ": " .. v1 .. ","
				end
			end
			optionsString = optionsString .. "},"
		else 
			if type(v) == "string" then
				optionsString = optionsString .. k .. ": '" .. v .. "',"
			else
				if type(v) == "boolean" then 
					if v == true then 
						v = "true"
					else 
						v = "false"
					end
				end
				optionsString = optionsString .. k .. ": " .. v .. ","
			end
		end
	end
	print(optionsString)

	-- DATA    used for all charts
	local data = options.data 
	if data == nil then 
		return "error", "no data: please specify the data option(table sorted into rows of data)"
	end
	local dataString = ""
	for i = 1, #data do 
		for d = 1, #data[i] do 
			if d == 1 then 
				if data[i][d] == "null" then
					dataString = dataString .. "[" .. "null" .. ""
				elseif type(data[i][d]) == "string" then
					dataString = dataString .. "['" .. data[i][d] .. "'"
				else
					dataString = dataString .. "[" .. data[i][d] .. ""
				end
			elseif d > 1 and d ~= #data[i] then 
				if data[i][d] == "null" then 
					dataString = dataString .. ", null" 	
				elseif type(data[i][d]) == "string" then
					dataString = dataString .. ", '" .. data[i][d] .. "'"	
				else
					dataString = dataString .. ", " .. data[i][d]
				end 
			elseif d > 1 and d == #data[i] then 
				if data[i][d] == "null" then 
					dataString = dataString .. ", " .."null" .. "],"
				elseif type(data[i][d]) == "string" then
					dataString = dataString .. ", '" .. data[i][d] .. "'],"			
				else
					dataString = dataString .. ", " .. data[i][d] .. "],"
				end 
			end
		end
		if i ~= #data then 
			dataString = dataString .. "\n"
		end
	end
	--This is only used for material design charts
	local columns = nil
	local columnsString = nil 
	if options.columns ~= nil then
		columns = options.columns
		columnsString = ""
		for i = 1, #columns do
			if columns[i].type == nil then 
				columns[i].type = "number"
			end
			columnsString = columnsString .. "data.addColumn('" .. columns[i].type .. "', '" .. columns[i].name .. "');\n"
		end
	end
	print(options.deisgn)
	if options.version == "1.1" then
		print(2)
		HTML = [[<html>
		<head>
		  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		  <script type="text/javascript">
		    google.load(']] .. name .. [[', ']] .. version .. [[', {packages: []] .. packageString .. [[]});
		    google.setOnLoadCallback(drawChart);

		    function drawChart() {
		        ]]

		     if  columnsString ~= nil then
		    	 HTML = HTML .. "var data = new google.visualization.DataTable();\n" .. columnsString .. [[
		    		   
		      data.addRows([
		        ]] .. dataString .. [[
		      ]); ]]
			else

			HTML = HTML .. [[var data = google.visualization.arrayToDataTable([
		          ]] .. dataString .. [[
		        ]);
			
		      var options = {
		        ]] .. optionsString .. [[
		      };]]
		    end
		    HTML = HTML .. [[

		        var options = {
		          ]] .. optionsString .. [[
		        };

		      var chart = new google.charts.Line(document.getElementById(']] .. elementByID .. [['));

		      chart.draw(data, options);
		    }
		  </script>
		</head>
		<body>
		  <div id="]] .. elementByID .. [["></div>
		</body>
		</html>
		]]

	else -- create a non material chart.
		HTML = [[ 
		  <html>
		  <head>
		    <script type="text/javascript"
		          src="https://www.google.com/jsapi?autoload={
		            'modules':[{
		              'name':']] .. name.. [[',
		              'version':']] .. version .. [[',
		              'packages':[]] .. packageString .. [[]
		            }]
		          }"></script>

		    <script type="text/javascript">
		      google.setOnLoadCallback(drawChart);

		       function drawChart() {
		        ]]

		     if  columnsString ~= nil then
		    	 HTML = HTML .. "var data = new google.visualization.DataTable();\n" .. columnsString .. [[
		    		   
		      data.addRows([
		        ]] .. dataString .. [[
		      ]); ]]
			else

			HTML = HTML .. [[var data = google.visualization.arrayToDataTable([
		          ]] .. dataString .. [[
		        ]);
			
		      var options = {
		        ]] .. optionsString .. [[
		      };]]
		    end
		    HTML = HTML .. [[

		        var options = {
		          ]] .. optionsString .. [[
		        };

		        var chart = new google.visualization.LineChart(document.getElementById(']] .. elementByID .. [['));

		        chart.draw(data, options);
		      }
		    </script>
		  </head>
		  <body>
		    <div id="]] .. elementByID .. [[" style="width: ]] .. optionsData.width .. [[px; height: ]] .. optionsData.height .. [[px"></div>
		  </body>
		</html>
		]]
	end
	print(HTML)
	local fileString = options.file or "chart.html"
	local path = system.pathForFile( fileString, system.DocumentsDirectory )

	-- write the file to load
	local file = io.open( path, "w" )
	file:write( HTML )
	io.close( file )
	return HTML, path
end

return M