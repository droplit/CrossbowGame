print( "Loaded cl_init.lua successfully!" )

include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_scoreboard.lua" )

// Clientside only stuff goes here

CreateConVar( "mlg_hud_kills", "1", FCVAR_NONE, "If the killstreak is rendered")
CreateConVar( "mlg_hud_players", "1", FCVAR_NONE, "If the player names are rendered")
CreateConVar( "mlg_hud_timer", "1", FCVAR_NONE, "If the 4:20 timer is rendered" )
CreateConVar( "mlg_hud_crosshair", "1", FCVAR_NONE, "If the hitmarker crosshair is rendered" )
CreateConVar( "hax_mlgplayers", "0", FCVAR_CHEAT, "420 wallhack m8" )

HudTime = CurTime()

//hitmarker = surface.GetTextureID( "gui/hitmark" )
hitmarker = Material( "materials/gui/hitmarker_crop.png" )

function GM:SpawnMenuEnabled()
	
	return false 							// Hides spawn menu
	
end

function Spawn( len, ply )
	
	
	
end
net.Receive( "spawned", Spawn )

function ReceiveGlobalSound( len, ply )
	
	local sound = net.ReadString()
	surface.PlaySound( sound )
	print( "MESSAGE RECIEVED: Sound \"" .. sound .. "\" played" )
	
end
net.Receive( "GlobalSound", ReceiveGlobalSound )

function ReceiveGlobalChat( len, ply )
	
	local args = net.ReadTable()
	chat.AddText( unpack( args ) )
	print( "Received chat" )
	
end
net.Receive( "GlobalChat", ReceiveGlobalChat )

function ReceiveHudTime( len, ply )
	
	HudTime = net.ReadDouble()
	
end
net.Receive( "HudTime", ReceiveHudTime )

function FormatTime( seconds )
	
	local str = ""
	local min = seconds/60
	local dec = min - math.floor( min )
	local whole = min - dec
	local sec = math.floor( dec * 60 )
	if sec < 10 then
		str = whole .. ":0" .. sec
	else
		str = whole .. ":" .. sec
	end
	
	return str
	
end

function ReceiveAttacker( len, ply )

	attacker = net.ReadEntity()
	bylate = not net.ReadBool()
	suicide = LocalPlayer() == attacker
	ShowKilledBy = true

	//local frame = vgui.Create("DFrame")
	//local av = vgui.Create("AvatarImage", frame)

end
net.Receive( "attacker", ReceiveAttacker )