print( "Loaded player.lua successfully!" )

DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

// See gamemodes/base/player_class/player_default.lua for all overridable variables

PLAYER.WalkSpeed = 200
PLAYER.RunSpeed	= 800

function PLAYER:Loadout()
	
	self.Player:RemoveAllAmmo()
	
	self.Player:GiveAmmo( 256, "XBowBolt", true )
	self.Player:Give( "weapon_crossbow" )
	
end

player_manager.RegisterClass( "player_crossbow", PLAYER, "player_default" )
