--Localise the module.
local M = {}




--Creates the map html file when you pass in all the parameters.
M.createMapHtml = function( params )
	--Set our main vars based off the params.
	local language = params.language or ""
	local zoomLevel = params.zoomLevel or 11
	local disableDefaultUI = params.disableDefaultUI or "true"
	local draggable = params.draggable or "true"
	local zoomAllowed = params.zoomAllowed or "true"
	local bouncingPins = params.bouncingPins or "false"
	local mapTypeId = params.mapTypeId or "ROADMAP"
	local showStyling = params.showStyling or "false"
	local lat = params.lat or 37.450876
	local lon = params.lon or -122.156689
	local htmlFile = params.htmlFile or "map.html"
	local path = system.pathForFile( htmlFile, system.DocumentsDirectory )
	
	--Marker data
	local markerTable = params.markers

	--Marker images
	local markerImage = params.markerInfo.markerImage or ""
	local markerShadow = params.markerInfo.markerShadow or ""
	local markerImageSize = params.markerInfo.markerImageSize or {55, 28}
	local markerShadowSize = params.markerInfo.markerShadowSize or { 55, 28 }
	local markerShadowOffset = params.markerInfo.markerShadowOffset or { 20, 28 }

	
	--MARKER JAVASCRIPT
	--This creates each custom marker, its click function and the infoBox/Button that appears. You can edit the css to whatever you want to change the style of the box!
	local markerCode = {}
	for i=1, #markerTable do
	    markerCode[i] = [[
	     	var boxText = document.createElement("div");
	        boxText.style.cssText = "border: 1px solid black; font-family: \"Arial\"; font-size: 14px; color: white; margin-top: 8px; background: #1c5daf; padding: 6px;";
	        boxText.innerHTML = "<strong>]]..markerTable[i].name..[[</strong><br>]]..markerTable[i].notes..[[<br>   <form action=\"corona:]]..markerTable[i].url..[[\"><input type=\"submit\"/ value=\"View Info\" ></form>";

		    var infowindow]]..i..[[ = new InfoBox({
		   		content: boxText
	            ,disableAutoPan: false
	            ,maxWidth: 200
	            ,pixelOffset: new google.maps.Size(-140, 0)
	            ,zIndex: null
	            ,boxStyle: { 
	              background: "url('http://google-maps-utility-library-v3.googlecode.com/svn/trunk/infobox/examples/tipbox.gif') no-repeat"
	              ,opacity: 0.9
	              ,width: "230px"
	             }
	            ,closeBoxMargin: "10px 2px 2px 2px"
	            ,closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif"
	            ,infoBoxClearance: new google.maps.Size(1, 1)
	            ,isHidden: false
		    });
		  
		    marker[]]..i..[[] = new google.maps.Marker({
			    position: new google.maps.LatLng(]]..markerTable[i].lat..', '..markerTable[i].lon..[[),
			    map: map,
			    draggable: false,
			    animation: google.maps.Animation.DROP,
			    icon:  new google.maps.MarkerImage(
		            ']]..markerImage..[[',
		            null,
		            null,
		            null,
		            new google.maps.Size(]]..markerImageSize[1]..[[, ]]..markerImageSize[2]..[[)
		        ),
				shadow: new google.maps.MarkerImage(
		            ']]..markerShadow..[[',
		            null,
		            null,
		            new google.maps.Point(]]..markerShadowOffset[1]..[[, ]]..markerShadowOffset[2]..[[),
		            new google.maps.Size(]]..markerShadowSize[1]..[[, ]]..markerShadowSize[2]..[[)
		        ),
		    });
		    
		    google.maps.event.addListener(marker[]]..i..[[], 'click', function() {
		   		if( prev_infowindow )
		        {
		        	prev_infowindow.close();
		        }
		   		infowindow]]..i..[[.open(map, this);
		   		prev_infowindow = infowindow]]..i..[[;


		   		//Bouncing pins!!
		   		if (bouncingPins)
				{
					if (this.getAnimation() != null) {
				    	this.setAnimation(null);
				 	} else {
				   		this.setAnimation(google.maps.Animation.BOUNCE);
				   		setTimeout(function(){ this.setAnimation(null); }, 1000);
				   		
				  	}
				}
		    });
	    ]]
	end
	local markerString = table.concat(markerCode)
	       	       

	--HTML & JAVASCRIPT CODE
	local mapString = [[
		<html>
<head>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <script type="text/javascript">
    google.load('visualization', '1.1', {packages: ['line']});
    google.setOnLoadCallback(drawChart);

    function drawChart() {

      var data = new google.visualization.DataTable();
      data.addColumn('number', 'Day');
      data.addColumn('number', 'Guardians of the Galaxy');
      data.addColumn('number', 'The Avengers');
      data.addColumn('number', 'Transformers: Age of Extinction');

      data.addRows([
        [1,  37.8, 80.8, 41.8],
        [2,  30.9, 69.5, 32.4],
        [3,  25.4,   57, 25.7],
        [4,  11.7, 18.8, 10.5],
        [5,  11.9, 17.6, 10.4],
        [6,   8.8, 13.6,  7.7],
        [7,   7.6, 12.3,  9.6],
        [8,  12.3, 29.2, 10.6],
        [9,  16.9, 42.9, 14.8],
        [10, 12.8, 30.9, 11.6],
        [11,  5.3,  7.9,  4.7],
        [12,  6.6,  8.4,  5.2],
        [13,  4.8,  6.3,  3.6],
        [14,  4.2,  6.2,  3.4]
      ]);

      var options = {
        chart: {
          title: 'Box Office Earnings in First Two Weeks of Opening',
          subtitle: 'in millions of dollars (USD)'
        },
        width: 900,
        height: 500
      };

      var chart = new google.charts.Line(document.getElementById('linechart_material'));

      chart.draw(data, options);
    }
  </script>
</head>
<body>
  <div id="linechart_material"></div>
</body>
</html>

	]]


	--HTML FILE CREATION
	local file = io.open( path, "w" )
	file:write( mapString )
	io.close( file )
end





--Return M.
return M


