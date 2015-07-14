

-- config.lua
local platform = system.getInfo("platformName")
local device = system.getInfo( "model" ); 


if platform == "Android" then
	application =
	{
	        content =
	        {
	                width = 320,
	                height = 480,
	                scale = "zoomStretch",
					
					imageSuffix =
					{
						["@2x"] = 1.5,
						["@4x"] = 4,
					},
	        },
	}
elseif device == "iPad" then
	application =
	{
	        content =
	        {
	                width = 320,
	                height = 480,
	                scale = "letterBox",
					
					imageSuffix =
					{
						["@2x"] = 1.5,
						["@4x"] = 4,
					},
	        },
	}
else
	application =
	{
	        content =
	        {
	                width = 320,
	                height = 480,
	                scale = "zoomStretch",
					
					imageSuffix =
					{
						["@2x"] = 1.5,
						["@4x"] = 4,
					},
	        },
	}
end


