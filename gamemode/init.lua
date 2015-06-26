print( "Loaded init.lua successfully!" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "shared.lua" )


include( 'shared.lua' )
include( 'player.lua' )

// Serverside only stuff goes here

CreateConVar( "mlg_sounds", "1", FCVAR_NONE, "If the crossbow game has mlg sounds" )
//CreateConVar( "set_killstreaks", "0", FCVAR_CHEAT, "Set the Players killstreak" )

// Forces players to download models / workshop con

resource.AddWorkshop( "325884882" )		// sanic
resource.AddWorkshop( "351508041" )		// snipars
resource.AddWorkshop( "344162661" )		// dank mlg
resource.AddWorkshop( "391383735" ) 	// left shark
resource.AddWorkshop( "314261589" )		// shrek 	

resource.AddWorkshop( "381636466" )		// text to speech
//resource.AddFile( "materials/gui/hitmark.vmt" )	// hitmarker image
resource.AddFile( "materials/gui/hitmarker_crop.png" )
resource.AddFile( "gamemodes/crossbowgame/content/models" )

spawnpoints = {}

spawnModels =
{
	"models/player/dank.mdl",
	"models/player/sanic.mdl",
	"models/player/snipars.mdl",
	"models/freeman/player/left_shark.mdl",
	"models/player/pyroteknik/shrek.mdl"
}

/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
   Desc: Give the player the default spawning weapons/ammo
---------------------------------------------------------*/

function GM:PlayerInitialSpawn( ply )
	

	//PrintMessage( HUD_PRINTTALK, ply:Nick().." has joined the game." )
	GlobalChat( Color( 255, 100, 100, 255 ), ply:Nick(), Color( 255, 255, 255, 255 ), " has joined the game." )
	RandomPlayerModel( ply )
	SendTime( ply )
	
	ply:SetNWBool( "haxor", false )
	
	// Set initial spawnpoint
	ply:SetNWVector( "spawnpoint" )
	ply:SetNWAngle( "spawnangle" )
	ply:SetNWInt( "spawnset" )
	
end
	
function GamemodeInit()
	
	HudTime = CurTime()
	timer.Create( "Timer", 260, 0, Time )
	timer.Simple( math.random( 300, 600 ), dankstorm )
	
end
hook.Add( "Initialize", "OurInit", GamemodeInit )

function GM:PlayerConnect( name, ip )
	
	PrintMessage( HUD_PRINTTALK, name .. " has connected to the server." )
	
end

function PlayerLeave( ply )
	
	PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has disconnected." )
	
end
hook.Add( "PlayerDisconnected", "PlayerLeaveChat", PlayerLeave )

function RandomPlayerModel( ply )
	
	local t_model = spawnModels[ math.random( #spawnModels ) ]
	if t_model == ply:GetModel() then
		RandomPlayerModel( ply )
	else
		ply:SetModel( t_model )
		if ply:GetModel() == "models/freeman/player/left_shark.mdl" then
			ply:SetSkin( 1 )
		else
			ply:SetSkin( 0 )
		end
	end
	
end

function GM:PlayerSpawn( ply )

	ply:UnSpectate()

	RandomPlayerModel( ply )
    ply:AllowFlashlight( true )

	MsgN( ply:Nick() .. " has spawned!" )
	ply:RemoveAllAmmo()
	
	if ( ply:GetNWBool( "spawnset" ) ) then
		ply:SetPos( ply:GetNWVector( "spawnpoint" ) )
		ply:SetEyeAngles( ply:GetNWAngle( "spawnangle" ) )
	end
	
	ply:Give( "weapon_crossbow" )
	ply:GiveAmmo( 256, "XBowBolt", true )
	ply:SetupHands()
	
	if GetConVar( "mlg_sounds" ):GetBool() then
		ply:Give( "noise_maker" )
	end
	
	ply:SetNWInt( "killstreak", 0 )
	
	GiveGod( ply )
	timer.Simple( 2, function() RemoveGod( ply ) end )
	
	net.Start( "spawned" )
	net.Send( ply )
	
end
util.AddNetworkString( "spawned" )

function GM:DoPlayerDeath( ply, attacker, dmg )
	
	ply:CreateRagdoll()

	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() and attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			ply:AddFrags( -1 )
			if ( GetConVar( "mlg_sounds" ):GetBool() ) then
				ply:EmitSound( "sadairhorn.mp3", 75 )
			end
		else
			attacker:AddFrags( 1 )
			attacker:SetNWInt( "killstreak", attacker:GetNWInt( "killstreak" ) + 1 )
			
			ply:Spectate( OBS_MODE_DEATHCAM )
			ply:SpectateEntity( attacker )
			ply:StripWeapons()
			
			timer.Simple( 1, function()
				ply:Spectate( OBS_MODE_FREEZECAM )
				SendAttacker( ply, attacker )
			end )
			
			timer.Simple( 5, function()
				ply:UnSpectate()
			end )
			
			if ( ply:SteamID() == "STEAM_0:1:6132152" ) then
				ply:EmitSound( "zvc.mp3", 75, 100, 1, CHAN_AUTO )
			elseif ( attacker:SteamID() == "STEAM_0:1:6132152" ) then
				attacker:EmitSound( "zl.mp3", 75, 100, 1, CHAN_AUTO )
			else
				attacker:EmitSound( "Airporn.mp3", 75, 100, 1, CHAN_AUTO )
				ply:EmitSound( "ws.wav", 48, 100, 1, CHAN_AUTO )
			end
			
			local kills = attacker:GetNWInt( "killstreak" )
			
			if ( GetConVar( "mlg_sounds" ):GetBool() ) then
				if ( kills/3 == 1 ) then
					SendGlobalSound( "ohbat.mp3" )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick() .. " got a triple kill!!1!!one!" )
				elseif ( kills/5 ==  1 ) then
					SendGlobalSound( "mgtc.mp3" )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick() .. " is on a 5 kill streak!!11!one!!" )
				elseif ( kills/10 == 1 ) then
					SendGlobalSound( "ss.mp3" )
					util.ScreenShake( attacker:GetPos() , 70, 35, 30, 1000000 )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick() .. " is on a 10 kill streak!one!!1!!1" )
				elseif ( kills/50 == 1 ) then
					attacker:SetMoveType( MOVETYPE_NOCLIP )
					GiveGod( attacker )
					attacker:SetNWBool( "haxor", true )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick() .. " is a 1337 h4x0r!!!!!111one" )
					SendGlobalSound( "ge4ce.wav" )
					timer.Simple( 30, function()
						//GlobalChat( Color( 255, 255, 255 ), attacker:Nick() .. " disconnected: Kicked: Too much of a 1337 h4x0r" )
						attacker:Kick( "Kicked: Too much of a 1337 h4x0r" )
					end )
				end
			end
		end
		
	else
		ply:AddFrags( -1 )
		if ( GetConVar( "mlg_sounds" ):GetBool() ) then
			ply:EmitSound( "sadairhorn.mp3", 75 )
		end
	end
	
end

function GM:GetFallDamage( ply, speed )
	return 0
end

function SendGlobalSound( sound )
	
	net.Start( "GlobalSound" )
	net.WriteString( sound )
	net.Send( player.GetAll() )
	print( "MESSAGE SENT TO ALL PLAYERS: Sound \"" .. sound .. "\" played" )
	
end
util.AddNetworkString( "GlobalSound" )

function Time()
	
	if ( GetConVar( "mlg_sounds" ):GetBool() ) then 
		PrintMessage( HUD_PRINTCENTER, "SAMPLE TEXT" )
		SendGlobalSound( "swe.mp3" )
		HudTime = CurTime()
		SendTime( player.GetAll() )
	end
	
end

function SendTime( ply )
	
	net.Start( "HudTime" )
	net.WriteDouble( HudTime )
	net.Send( ply )
	
end
util.AddNetworkString( "HudTime" )

function GlobalChat( ... )
	
	local args = {...}
	net.Start( "GlobalChat" )
	net.WriteTable( args )
	net.Send( player.GetAll() )
	print( "Global Chat sent" )
	
end
util.AddNetworkString( "GlobalChat" )

function PlayerChat( ... )
	
	local args = {...}
	local ply = args[1]
	table.remove( args, 1 )
	net.Start( "GlobalChat" )
	net.WriteTable( args )
	net.Send( ply )
	print( "Player Chat sent to " .. ply:Nick() )
	
end

function ChtCommands( ply, text, teamChat )
	
	local args = string.Explode( " ", text )
	
	if ( string.lower( args[1] ) == "!setkills" ) then
			if ply:IsAdmin() then
				
				local players = player.GetAll()
				for _, pl in ipairs( players ) do
					if string.lower( args[2] ) == string.lower( pl:Nick() ) then
						pl:SetNWInt( "killstreak", tonumber( args[3] ) )
						if pl == ply then
							PlayerChat( ply, Color( 255, 255, 255 ), "You set your kill streak to ", Color( 255, 0, 0 ), tostring( ply:GetNWInt( "killstreak" ) ), Color( 255, 255, 255 ), "." )
						else
							PlayerChat( ply, Color( 255, 255, 255 ), "You set ", Color( 0, 128, 255 ), pl:Nick(), Color( 255, 255, 255 ), "'s kill streak to ", Color( 255, 0, 0 ), tostring( pl:GetNWInt( "killstreak" ) ), Color( 255, 255, 255 ), "." )
							PlayerChat( pl, Color( 0, 128, 255 ), ply:Nick(), Color( 255, 255, 255 ), " set your kill streak to ", Color( 255, 0, 0 ), tostring( pl:GetNWInt( "killstreak" ) ), Color( 255, 255, 255 ), "." )
						end
					end
				end
				
			else
				PlayerChat( ply, Color( 204, 0, 0 ), "You do not have the privilage to do that." )
			end
		return false
	end
	
	if ( string.lower( args[1] ) == "!setspawn" ) then
		
		//args[2] = args[2] or "bl"
		
		if args[2] == "reset" then
			ply:SetNWBool( "spawnset", false )
			GlobalChat( Color( 255, 0, 0 ), ply:Nick(), Color( 255, 255, 255 ), " has reset their spawnpoint." )
		else
			ply:SetNWVector( "spawnpoint", ply:GetPos() )
			ply:SetNWAngle( "spawnangle", ply:EyeAngles() )
			ply:SetNWBool( "spawnset", true )
			
			//PlayerChat( ply, Color( 255, 255, 255 ), "You set your spawnpoint." )
			GlobalChat( Color( 255, 0, 0 ), ply:Nick(), Color( 255, 255, 255 ), " has set their spawnpoint." )
		end
		return false
	end
	
end
hook.Add( "PlayerSay", "ChatCommands", ChtCommands )

function GiveGod( ply )

	ply:GodEnable()
	ply:SetMaterial( "models/props_combine/masterinterface01c" )
	ply:GetHands():SetMaterial( "models/props_combine/masterinterface01c" )
	
end

function RemoveGod( ply )

	ply:GodDisable()
	ply:SetMaterial( "" )
	ply:GetHands():SetMaterial( "" )
	
end

function dankstorm()
	
	SendGlobalSound( "dd.mp3" )
	PrintMessage( HUD_PRINTCENTER, "Tiem 4 dat DANKstorm!!!!!111one" )
	timer.Simple( math.random( 300, 600 ), dankstorm )
	
end

function SendAttacker( ply, attacker )
	
	if ( ply == attacker ) then 
		print( "GG" )
	end
	net.Start( "attacker" )
	net.WriteEntity( attacker )
	net.WriteBool( attacker:Alive() )
	net.Send( ply )
	
end
util.AddNetworkString( "attacker" )