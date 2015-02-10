print( "Loaded init.lua successfully!" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )
include( 'player.lua' )

// Serverside only stuff goes here

CreateConVar( "mlg_sounds", "1", 1, "If the crossbow game has mlg sounds" )

// Forces players to download models / workshop con

resource.AddWorkshop( "325884882" )	// sanic
resource.AddWorkshop( "351508041" )	// snipars
resource.AddWorkshop( "344162661" )	// dank mlg
resource.AddWorkshop( "381636466" )	// text to speech

spawnModels =
{
	"models/player/dank.mdl",
	"models/player/sanic.mdl",
	"models/player/snipars.mdl"
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
	
end

function GamemodeInit()
	
	HudTime = CurTime()
	timer.Create( "Timer", 260, 0, Time )
	
end
hook.Add( "Initialize", "OurInit", GamemodeInit )

function GM:PlayerConnect( name, ip )
	
	PrintMessage( HUD_PRINTTALK, name .. " has connected to the server." )
	
end

function GM:PlayerDisconnected( ply )
	
	PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has disconnected." )
	
end

function RandomPlayerModel( ply )
	
	local t_model = spawnModels[ math.random( #spawnModels ) ]
	if t_model == ply:GetModel() then
		RandomPlayerModel( ply )
	else
		ply:SetModel( t_model )
	end
	
end

function GM:PlayerSpawn( ply )

	RandomPlayerModel( ply )
	
    ply:AllowFlashlight( true )
	
	MsgN( ply:Nick() .. " has spawned!" )
	ply:RemoveAllAmmo()
	
	ply:Give( "weapon_crossbow" )
	ply:GiveAmmo( 256, "XBowBolt", true )
	ply:SetupHands()
	
	if GetConVar( "mlg_sounds" ):GetBool() then
		ply:Give( "noise_maker" )
	end
	
	SetKillStreak( ply, 0 )
	
end

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
			SetKillStreak( attacker, attacker.killstreak + 1 )
			
			attacker:EmitSound( "Airporn.mp3", 75, 100, 1, CHAN_AUTO )
			ply:EmitSound( "ws.wav", 30, 100, 1, CHAN_AUTO )
			
			if ( GetConVar( "mlg_sounds" ):GetBool() ) then
				if ( attacker.killstreak/3 == 1 ) then
					SendGlobalSound( "ohbat.mp3" )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick().." got a triple kill!!1!!one!" )
				elseif ( attacker.killstreak/5 ==  1 ) then
					SendGlobalSound( "mgtc.mp3" )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick().." is on a 5 kill streak!!11!one!!" )
				elseif ( attacker.killstreak/10 == 1 ) then
					SendGlobalSound( "ss.mp3" )
					util.ScreenShake( attacker:GetPos() , 70, 35, 30, 1000000 )
					PrintMessage( HUD_PRINTCENTER, attacker:Nick().." is on a 10 kill streak!one!!1!!1" )
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

function SetKillStreak( ply, kills )	// Sets kills, and sends to client
	
	ply.killstreak = kills
	net.Start( "KillStreak" )
	net.WriteInt( kills, 8 )
	net.Send( ply )
	print( "MESSAGE SENT TO " .. ply:Nick() .. ", killstreak set to " .. kills )
	
end
util.AddNetworkString( "KillStreak" )

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
	
	print( "Global Chat sent" )
	local args = {...}
	net.Start( "GlobalChat" )
	net.WriteTable( args )
	net.Send( player.GetAll() )
	
end
util.AddNetworkString( "GlobalChat" )
