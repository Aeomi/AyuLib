

-- Globals --
Adb 	= Adb 	  or { }	
Adb.Sql = Adb.Sql or { } 
-------------



-- Dynamic Printing --
function Adb.Sql.SVPrint( Str )
	MsgC( Color( 175, 175, 255 ), "[ Ayu/ARpg/Adb/Sql ]: ".. Str .."\n" )
end


-- Validate Database --
function Adb.Sql.ValDB( )
	if ( sql.TableExists( "Adb_Info" ) ) then
		Adb.Sql.SVPrint( "SQL Database Validated" )
	else
		local Qry  = "CREATE TABLE Adb_Info ( id int, name string, hp int, speed int, power int );"
		local RQry = sql.Query( Qry )
		if ( sql.TableExists( "Adb_Info" ) ) then
			Adb.Sql.SVPrint( "SQL Database Created" )
		else
			Adb.Sql.SVPrint( "SQL Database was not created - Retrying" )
			Adb.Sql.SVPrint( tostring( sql.LastError( RQry ) ) )
			Adb.Sql.ValDB( )
		end
	end
end


function Adb.Sql.ValRow( Pl )
	local ID   = Adb.GetID( Pl )
	local Qry  = "SELECT id, name, hp, speed, power FROM Adb_Info WHERE id = '".. ID .."';" 
	local RQry = sql.Query( Qry )
	return RQry 
end


function Adb.Sql.ValPl( Pl )
	local ID   = Adb.GetID( Pl ) 
	local RQry = Adb.Sql.ValRow( Pl )
	if ( RQry ) then
		Adb.Sql.GetInfo( Pl )
	else
		Adb.Sql.CreatePl( Pl )
	end
end


function Adb.Sql.PlGen( Pl )
	local ID   = Adb.GetID( Pl )
	local Qry  = "INSERT INTO Adb_Info ( 'id', 'name', 'hp', 'speed', 'power' ) VALUES ( '".. ID .."', 'DEFAULT', '100', '1', '1' )" 
	local RQry = sql.Query( Adb.Sql.ValRow( Pl ) )
	Adb.Sql.SVPrint( "SQL Row under generation..." )
	if ( RQry ) then
		-- Set Adb Tbl --
		Adb.PlGenTbl( Pl, "DEFAULT", 100, 1, 1 )
	else
		Adb.Sql.SVPrint( "SQL Row was not created - Retrying" )
		Adb.Sql.SVPrint( tostring( sql.LastError( RQry ) ) )
		Adb.Sql.PlGen( Pl )
	end
end


function Adb.Sql.SetNWInfo( Pl )
	local ID 	= Adb.GetID( Pl )
	local Name 	= sql.QueryValue( "SELECT name FROM Adb_Info WHERE id = '".. ID .."';" ) 
	local Hp 	= sql.QueryValue( "SELECT hp FROM Adb_Info WHERE id = '".. ID .."';" ) 
	local Speed = sql.QueryValue( "SELECT speed FROM Adb_Info WHERE id = '".. ID .."';" ) 
	local Power = sql.QueryValue( "SELECT power FROM Adb_Info WHERE id = '".. ID .."';" ) 
	Pl:SetNWInt( "Ayu/Adb/Info/Name",  Name  )
	Pl:SetNWInt( "Ayu/Adb/Info/Hp",    Hp    )
	Pl:SetNWInt( "Ayu/Adb/Info/Speed", Speed )
	Pl:SetNWInt( "Ayu/Adb/Info/Power", Power )
end


function Adb.Sql.SaveInfo( Pl )
	local ID    = Adb.GetID( Pl )
	local Name  = Pl:GetNWInt( "Ayu/Adb/Info/Name"  )
	local Hp    = Pl:GetNWInt( "Ayu/Adb/Info/Hp" 	)
	local Speed = Pl:GetNWInt( "Ayu/Adb/Info/Speed" )
	local Power = Pl:GetNWInt( "Ayu/Adb/Info/Power" )
	sql.Query( "UPDATE Adb_Info SET name = "..Name..", hp = "..Hp..", speed "..Speed..", power "..Power.." WHERE id = '".. ID .."';" )
	Adb.Sql.SVPrint( "SQL Row ( ".. ID .." ) Saved" )
end

