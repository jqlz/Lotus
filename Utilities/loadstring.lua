local Source = "%sLoader.lua"
local Branch, NotificationTime, IsLocal = "%s", %s, %s

loadstring(IsLocal and readfile("riot/Loader.lua")
or game:HttpGet(Source), "Loader")(Branch, NotificationTime, IsLocal)
