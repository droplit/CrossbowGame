print( "Loaded cl_init.lua successfully!" )

include( "shared.lua" )

// Clientside only stuff goes here

CreateConVar( "mlg_hud_kills", "1", FCVAR_NONE, "If the killstreak is rendered")
CreateConVar( "mlg_hud_players", "1", FCVAR_NONE, "If the #dank player names are rendered")
CreateConVar( "hax_mlgplayers", "0", FCVAR_CHEAT, "420 wallhack m8" )
CreateConVar( "mlg_hud_timer", "1", FCVAR_NONE, "If you can see the timer" )
local kills = 0
local HudTime = CurTime()
	
surface.CreateFont( "HUDFont",	// Create font
{
	size = 50,
	weight = 1000,
	font = "Arial"
} )

surface.CreateFont( "PlayerNames",
{
	size = 18,
	weight = 1000,
	antialias = true,
	shadow = false,
	font = "Arial"
} )

function GM:SpawnMenuEnabled()
	
	return false 							// Hides spawn menu
	
end

function HUDHide( hud )						// Hides the HUD's Health, Suit, and Ammo displays

	for k,v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo" } do
		if hud == v then return false end
	end
	
end
hook.Add( "HUDShouldDraw", "HUDHide", HUDHide )

function GetKillStreak( len, ply )
	
	kills = net.ReadInt( 8 )
	print( "MESSAGE RECIEVED: Killstreak set to "..kills )
	
end
net.Receive( "KillStreak", GetKillStreak )

function ShadowText( x, y, text, color, shadow )
	
	shadow = shadow or 0	// Shadow is option paramater
	local alpha = color.a or 255
	
	if shadow > 0 then
		surface.SetTextPos( x+shadow, y+shadow )
		surface.SetTextColor( ColorAlpha( Color( 0, 0, 0, 255 ) , alpha ) )
		surface.DrawText( text )
	end
	
	surface.SetTextPos( x, y )
	surface.SetTextColor( color )
	surface.DrawText( text )
	
end

function OurHUD()			// Actually paints the HUD
	
	local ply = LocalPlayer()
	
	local sw, sh = ScrW(), ScrH()
	
	if ( GetConVar( "mlg_hud_players" ):GetBool() ) then
	
		surface.SetFont( "PlayerNames" )	// Sets fonts to render opponent player overlays
		local maxdist = 2048
		for i, v in pairs( ents.FindByClass( "player" ) ) do
		
			local td = {}
			td.start = ply:GetShootPos()
			td.endpos = v:GetShootPos()
			local trace = util.TraceLine( td )
			
			local vpos = v:GetShootPos()
			local dist = ply:GetShootPos():Distance( vpos )
			if ( v:Alive() and dist > 10 ) and ( ( dist < maxdist and !trace.HitWorld ) or ( GetConVar( "hax_mlgplayers" ):GetBool() ) ) then		// Only if alive, close enough, and not through a wall
				local col, a = team.GetColor( v:Team() ), math.Clamp( maxdist-dist, 0, 255 )	// Alpha fades out as gets farther away
				if GetConVar( "hax_mlgplayers" ):GetBool() then a = 255 end
				local x, y = vpos:ToScreen().x, vpos:ToScreen().y
				local text = v:Nick()
				
				local w = surface.GetTextSize( text )
				local x = x - w / 2
				local y = y - 20
				
				surface.SetTextColor( col.r, col.g, col.b, a )
				surface.SetTextPos( x, y )
				surface.DrawText( text )
				ShadowText( x, y, text, Color( col.r, col.g, col.b, a ), 1 )
			end
			
		end
	end
	
	if GetConVar( "mlg_hud_timer" ):GetBool() and GetConVar( "mlg_sounds" ):GetBool() then
		local blz_cnt = FormatTime( math.ceil( CurTime() - HudTime ) )
		surface.SetFont( "HUDFont" )
		ShadowText( 15, 15, blz_cnt, Color( 255, 255, 255 ), 2 )
	end
	
	if ( not ply:Alive() ) then return end	//############ WONT RENDER PAST HERE IF PLAYER IS DEAD ############
	
	if ( GetConVar( "mlg_hud_kills" ):GetBool() ) then
		local x, y = 20, sh - 60
		
		// Killstreak acquired by messages
		
		local text = "Kill Streak: " .. kills	// TO DO: replace with 'kills' variable when done
		
		surface.SetFont( "HUDFont" )
		ShadowText( x, y, text, Color( 255, 255, 255 ), 2 )
	end
	
end
hook.Add( "HUDPaint", "OurHUD", OurHUD )

function ReceiveGlobalSound( len, ply )
	
	local sound = net.ReadString()
	surface.PlaySound( sound )
	print( "MESSAGE RECIEVED: Sound \"" .. sound .. "\" played" )
	
end
net.Receive( "GlobalSound", ReceiveGlobalSound )

function ReceiveGlobalChat( len, ply )
	
	print( "Global Chat received" )
	local args = net.ReadTable()
	chat.AddText( unpack( args ) )
	
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