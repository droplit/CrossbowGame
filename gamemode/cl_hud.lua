print( "Loaded cl_hud.lua successfully!" )

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

attacker = LocalPlayer()
bylate = false
ShowKilledBy = false

function HUDHide( hud )						// Hides the HUDs Health, Suit, and Ammo displays

	for k,v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair" } do
		if hud == v then return false end
	end
	
end
hook.Add( "HUDShouldDraw", "HUDHide", HUDHide )

function ShadowText( x, y, text, color, shadow )
	
	shadow = shadow or 0	// Shadow is optional paramater
	local alpha = color.a or 255
	
	if shadow != 0 then
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

	if(ply:Health() <= 10 and ply:Health() > 0) then

		local x, y = ScrW()/2, ScrH()/4
		
		local text = "Your health is at " .. ply:Health().."!"
	
		surface.SetFont( "HUDFont" )
		x = x - surface.GetTextSize( text )/2
		local width, height = surface.GetTextSize(text)
		//draw.RoundedBox( 8, x-4, y, width+8, height, Color( 84, 84, 84, 175 ) )
		
		ShadowText( x, y, text, Color( 255, 0, 0 ), 2 )
	end
	
	if GetConVar( "mlg_hud_timer" ):GetBool() and GetConVar( "mlg_sounds" ):GetBool() then
		local blz_cnt = FormatTime( math.ceil( CurTime() - HudTime ) )
		surface.SetFont( "PlayerNames" )
		local width, height = surface.GetTextSize("BLAZE TIMER: " .. blz_cnt)
		draw.RoundedBox( 8, 1, 5, width+8, height, Color( 255, 132, 0, 175 ) )
		ShadowText( 5, 5, "BLAZE TIMER: " .. blz_cnt, Color( 255, 255, 255 ), 0 )


	end
	
	if ( not ply:Alive() ) then
		if ShowKilledBy then
			if attacker then
				KilledBy( attacker )
			end
		end
		return //############ WONT RENDER PAST HERE IF PLAYER IS DEAD ############
	end
	
	if ( GetConVar( "mlg_hud_players" ):GetBool() ) then
	
		local maxdist = 2048
		for i, v in pairs( ents.FindByClass( "player" ) ) do
		
			local td = {}
			td.start = ply:GetShootPos()
			td.endpos = v:GetShootPos()
			local trace = util.TraceLine( td )
			haxor = v:GetNWBool( "haxor" )
			
			local vpos = v:GetShootPos()
			local dist = ply:GetShootPos():Distance( vpos )
			if ( v:Alive() and dist > 10 ) and ( ( dist < maxdist and !trace.HitWorld ) or ( GetConVar( "hax_mlgplayers" ):GetBool() or haxor ) ) then		// Only if alive, close enough, and not through a wall
				local col, a = team.GetColor( v:Team() ), math.Clamp( maxdist-dist, 0, 255 )	// Alpha fades out as gets farther away
				if GetConVar( "hax_mlgplayers" ):GetBool() or haxor then a = 255 end
				local x, y = vpos:ToScreen().x, vpos:ToScreen().y
				local text = v:Nick()
				
				if haxor then surface.SetFont( "HUDFont" ) else surface.SetFont( "PlayerNames" ) end		// Sets fonts to render opponent player overlays
				
				local w, h = surface.GetTextSize( text )
				local x = x - w / 2
				local y = y - 20

				surface.SetDrawColor( Color( 225, 225, 225, 255 ) )
				surface.DrawRect( x-5, y-3, w+10, h+6 )
				surface.SetDrawColor( Color( 84, 84, 84, 255 ) )
				surface.DrawRect( x-4, y-2, w+8, h+4 )
				
				surface.SetTextColor( 50 + ( v:GetNWInt( "killstreak" )*2 ), 50, 50, a )
				surface.SetTextPos( x, y )
				surface.DrawText( text )
				ShadowText( x, y, text, Color( math.Clamp( v:GetNWInt( "killstreak" )*25, 0, 255 ), math.Clamp( 255 - v:GetNWInt( "killstreak" )*25, 0, 255 ), 0, a ), 1 )

			end
			
		end
	end
	
	if ( GetConVar( "mlg_hud_kills" ):GetBool() ) then
		local x, y = 20, sh - 60
		
		// Killstreak acquired by messages
		
		local text = "Kill Streak: " .. tostring( LocalPlayer():GetNWInt( "killstreak" ) )	// TO DO: replace with 'kills' variable when done
		
		surface.SetFont( "HUDFont" )
		local width, height = surface.GetTextSize(text)
		draw.RoundedBox( 8, x-4, y, width+8, height, Color( 84, 84, 84, 175 ) )

		ShadowText( x, y, text, Color( 255, 255, 255 ), 2 )
	end
	
	if GetConVar( "mlg_hud_crosshair" ):GetBool() then
		surface.SetMaterial( hitmarker )
		surface.DrawTexturedRect( ScrW()/2 - 16, ScrH()/2 - 16, 32, 32 )
	else
		DrawCrosshair( ScrW()/2-1, ScrH()/2 )
	end

 
end
hook.Add( "HUDPaint", "OurHUD", OurHUD )

function DrawCrosshair( x, y )	// Renders a normal-looking crosshair, because we disabled the real one
	
	surface.SetDrawColor( 255, 224, 100 )
	//surface.SetDrawColor( 255, 0, 0 )
	surface.DrawRect( x, y, 1, 1 )
	surface.DrawRect( x+10, y, 1, 1 )
	surface.DrawRect( x-10, y, 1, 1 )
	surface.DrawRect( x, y+8, 1, 1 )
	surface.DrawRect( x, y-8, 1, 1 )
	
end

function KilledBy( attacker )

	local x, y = ScrW()/2, ScrH()/4
	
	local text = "You were killed by: " .. attacker:Nick()

	if bylate then
		text = "You were killed by the late: " .. attacker:Nick()
	end
	
	surface.SetFont( "HUDFont" )
	x = x - surface.GetTextSize( text )/2
	local width, height = surface.GetTextSize(text)
	draw.RoundedBox( 8, x-4, y, width+8, height, Color( 84, 84, 84, 175 ) )
	
	ShadowText( x, y, text, Color( 255, 255, 255 ), 2 )

end

