print( "Loaded cl_scoreboard.lua has successfully!" )

// Overrides the normal shitty scoreboard with our mlg one

local showScoreBoard = false
local boardWidth = 800
local boardStartY = math.floor( ScrH()/5 )
local hgt = 0

local boardColors = {}
boardColors.back 	= Color( 84, 84, 84, 175 )
boardColors.title 	= Color( 220, 220, 220, 50 )
boardColors.ply 	= Color( 0, 0, 0, 10 )
boardColors.backText 	= Color( 255, 255, 255 )
boardColors.titleText 	= Color( 0, 0, 0 )
boardColors.plyText 	= Color( 0, 0, 0 )

surface.CreateFont( "ServerName",	// Create font
{
	size = 30,
	weight = 1000,
	font = "Arial"
} )

function GM:ScoreboardShow()
	showScoreBoard = true
end

function GM:ScoreboardHide()
	showScoreBoard = false
end

function GM:HUDDrawScoreBoard()
	
	if !showScoreBoard then return end
	
	local refx = math.floor( ScrW()/2 ) - boardWidth/2
	local refy = boardStartY
	
	draw.RoundedBox( 6, refx - 3, refy - 3, boardWidth + 6, hgt + 6, boardColors.back )
	draw.RoundedBox( 4, refx, refy, boardWidth, 31, boardColors.title )
	draw.SimpleText( GetHostName(), "ServerName", ScrW()/2, refy, boardColors.titleText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	refy = refy + 35
	
	draw.SimpleText( "Frags", "PlayerNames", refx + boardWidth - 240, refy, boardColors.backText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "Deaths", "PlayerNames", refx + boardWidth - 180, refy, boardColors.backText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "Ping", "PlayerNames", refx + boardWidth - 120, refy, boardColors.backText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( "Kill Streak", "PlayerNames", refx + boardWidth - 60, refy, boardColors.backText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	refy = refy + 20
	
	local players = player.GetAll()
	
	for i=1, #players, 1  do
		
		local ply = players[i]
		draw.RoundedBox( 4, refx, refy+2, boardWidth, 26, boardColors.ply )
		draw.SimpleText( ply:Nick(), "ServerName", refx + 2, refy, boardColors.plyText, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( ply:Frags(), "ServerName", refx + boardWidth - 240, refy, boardColors.plyText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( ply:Deaths(), "ServerName", refx + boardWidth - 180, refy, boardColors.plyText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		local pingText = "" if ply:IsBot() then pingText = "Bot" else pingText = ply:Ping() end
		draw.SimpleText( pingText, "ServerName", refx + boardWidth - 120, refy, boardColors.plyText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		draw.SimpleText( ply:GetNWInt( "killstreak" ), "ServerName", refx + boardWidth - 60, refy, boardColors.plyText, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		refy = refy + 30
		
	end
	
	hgt = refy - boardStartY - 2
	
end
