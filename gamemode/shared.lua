print( "Loaded shared.lua successfully!" )

GM.Name 	= "Crossbow Game"
GM.Author 	= "Droplit"
GM.Email 	= "droplitofficial@gmail.com"
GM.Website 	= "N/A"

CreateConVar( "mlg_sounds", "1", FCVAR_REPLICATED, "If the crossbow game has mlg sounds" )

function GM:Initialize()
	
	self.BaseClass.Initialize( self )
	
end
