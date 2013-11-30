include( 'SQL.lua' )

-- Globals --
Adb 	= Adb 	 or { }	-- Main Table
Adb.Pl  = Adb.Pl or { } -- Pl Database
-------------



/*************|
|   Generic   |
|*************/
-- Dynamic Printing --
function Adb.SVPrint( Str, Clr )
	MsgC( Clr, "[ Ayu/ARpg/Adb ]: ".. Str .."\n" )
end

-- Get Pl UniqueID --
function Adb.GetID( Pl )
    local ID = tonumber( Pl:SteamID( ):sub( 11 ) )
    if ( ID ) then return ID end
end

-- Create Pl Tbl --
function Adb.PlGenTbl( Pl, name, hp, speed, power )
    local ID = Adb.GetID( Pl )
    Adb.Pl[ID] = { Name = name, Hp = hp, Speed = speed, Power = power }
	Adb.SVPrint( "Generated Player row for ".. Pl:Nick( ) .." ( ".. name .. " ) ", Color( 175, 175, 255 ) )
end

-- Validate Filesystem --
function Adb.ValDir( Str )
	if ( file.Exists( "AyuLib", 'DATA' ) and file.Exists( "AyuLib/ARpg", 'DATA' ) and file.Exists( "AyuLib/ARpg/DB", 'DATA' ) ) then
		if ( file.Exists( "AyuLib/ARpg/DB/".. Str, 'DATA') ) then
			Adb.SVPrint( "Database is valid", Color( 175, 175, 255 ) )
			return true
		else
			Adb.SVPrint( "Database is invalid ( Creating specified path )", Color( 175, 175, 255 ) )
			file.CreateDir( "AyuLib/ARpg/DB/".. Str, 'DATA' )
		end
	else 
		Adb.SVPrint( "No Database found: Creating...", Color( 175, 175, 255 ) )
		file.CreateDir( "AyuLib", 'DATA' )
		file.CreateDir( "AyuLib/ARpg", 'DATA' )
		file.CreateDir( "AyuLib/ARpg/DB", 'DATA' )
		file.CreateDir( "AyuLib/ARpg/DB/".. Str, 'DATA' )
		Adb.SVPrint( "Database created", Color( 175, 175, 255 ) )
	end
end



/*************|
|    Saves    |
|*************/
-- Save Tbl->Txt --
function Adb.SaveTxt( Pl )
    local ID = Adb.GetID( Pl )
	local Value = util.TableToKeyValues( Adb.Pl[ID] )
	Adb.SVPrint( "Preparing to save ".. Pl:Nick( ) .."\'s data", Color( 175, 175, 255 ) )
	Adb.SVPrint( "[ Txt ] Saving Player Data ( ".. Pl:Nick( ) .." )...", Color( 175, 175, 255 ) )
	if ( Adb.ValDir( "Text/IDs" ) ) then 
		file.Write( "AyuLib/ARpg/DB/Text/IDs/".. ID ..".txt", Value )
		if ( file.Read( "AyuLib/ARpg/DB/Text/IDs/".. ID ..".txt" ) != nil ) then
			Adb.SVPrint( "[ Txt ] Save complete", Color( 175, 175, 255 ) )
		else
			Adb.SVPrint( "[ Txt ] Save failed! - Retrying...", Color( 175, 175, 255 ) )
			Adb.SaveTxt( Pl )
		end
	end
end

--[[
-- Save Tbl->Sql --
function Adb.SaveSql( Pl )
	local ID = Adb.GetID( Pl )
	local Str = util.TableToKeyValues( Adb.Pl[ID] )
	Adb.SVPrint( "[ Sql ] Saving Player Data ( ".. Pl:Nick( ) .." )...", Color( 175, 175, 255 ) )
	Pl:SetPData( "Ayu/ARpg/DB/".. ID, Str )
	if ( !Pl:GetPData( "Ayu/ARpg/DB/".. ID, nil ) ) then
		Adb.SVPrint( "[ Sql ] Save complete", Color( 175, 175, 255 ) )
	else
		Adb.SVPrint( "[ Sql ] Save failed! - Retrying...", Color( 175, 175, 255 ) )
		Adb.SaveSql( Pl )
	end
end
--]]


/*************|
|    Loads    |
|*************/
-- Load Txt->Tbl --
function Adb.LoadTxt( Pl )
    local ID = Adb.GetID( Pl )
	local FStr = file.Read( "AyuLib/ARpg/DB/Text/IDs/".. ID ..".txt" )
	if ( Adb.ValDir( "Text/IDs" ) ) then
		local Value = util.KeyValuesToTable( FStr )
		return Value
	end
end

--[[
-- Load Sql->Tbl --
function Adb.LoadSql( Pl )
	local ID = Adb.GetID( Pl )
	local Value = Pl:GetPData( "Ayu/ARpg/DB/".. ID )
	if ( Value ) then
		return util.KeyValuesToTable( Value )
	end
end
]]--
