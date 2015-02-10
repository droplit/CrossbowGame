AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Terry Hearst"
SWEP.Contact		= "thearst3rd@gmail.com"
SWEP.Purpose		= "Make MLG Sounds"
SWEP.Instructions	= "Click for hitmark, right click for airhorn"
SWEP.PrintName		= "MLG Noise Maker"

SWEP.ViewModelFOV	= 69
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_pistol.mdl"
SWEP.UseHands		= true
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.DrawAmmo = false

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"

SWEP.Secondary.ClipSize		= 1					// Size of a clip
SWEP.Secondary.DefaultClip	= 1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"

SWEP.Slot 		= 0
SWEP.SlotPos 	= 0

/*---------------------------------------------------------
	Initialize
---------------------------------------------------------*/
function SWEP:Initialize()
	
end


/*---------------------------------------------------------
	Reload
---------------------------------------------------------*/
function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD );
end


/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()
	
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Make sure we can shoot first
	//if ( !self:CanPrimaryAttack() ) then return end

	// Play shoot sound
	self:EmitSound( "hitmark.wav" )
	
	// Shoot 9 bullets, 150 damage, 0.01 aimcone
	//self:ShootBullet( 150, 1, 0.01 )
	self:ShootEffects()
	
	// Remove 1 bullet from our clip
	//self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view
	//self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
	
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Make sure we can shoot first
	//if ( !self:CanSecondaryAttack() ) then return end
	if self:Clip2() > 0 then
		// Play shoot sound
		self:EmitSound( "airhorn.mp3" )
		
		// Shoot 9 bullets, 150 damage, 0.25 aimcone
		//self:ShootBullet( 150, 9, 0.25 )
		self:ShootEffects()
		
		// Remove 1 bullet from our clip
		//self:TakeSecondaryAmmo( 1 )	// ### UNCOMMENT FOR TIME RESTRICTION
		
		// Punch the player's view
		//self.Owner:ViewPunch( Angle( -10, 0, 0 ) )
		
		//timer.Simple( 3, function() self:SetClip2( 1 ) end )	// ### UNCOMMENT THIS TOO
	end
	
end