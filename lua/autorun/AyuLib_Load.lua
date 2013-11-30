if ( SERVER ) then 
	-- Clientside Files --
	AddCSLuaFile( )
end

if ( CLIENT ) then 
	-- Clientside Includes --
end

if ( SERVER ) then 
	-- Serverside Includes --
	include( 'arpg/adb/server/adblib.lua' )
end

if ( !SERVER and !CLIENT ) then 
	-- Shared includes --
end

if ( CLIENT ) then 
	-- Clientside Init Calls --
end

if ( SERVER ) then 
	-- Serverside Init Calls --
	-- ServerInit( )
end

