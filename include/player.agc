

// ********************** PLAYER ****************************** //
Type sPlayer
	
	obj as integer	
	x as float
	y as float
	z as float
		
	Speed as float
	AngleY as float	
	
	Life as integer
	Lifemax as integer
	Degat as integer
	
	MobId as integer
	MapId as integer
	Fight as integer
	FightTime as integer
	
EndType



// Init
Function InitPlayer()

	Global Player as sPlayer

	// Global Jim, h, hl, h2, dist

	Player.life = Options.Player.lifeMax
	Player.lifeMax = Options.Player.lifeMax
	Player.Speed = Options.Player.Speed
	Player.MobId = -1
	Player.MapId = Options.Player.MapId
	Player.Degat = Options.Player.Degat



EndFunction

Function CreatePlayer()
	
	/*
	m =200
	
	// ------ pour créer l'objet player dans le jeu
	Jim = loadObject ("obj/jim.dae")
	Player.obj = Jim
	SetObjectImage(Jim,iPlayer,0)
	// SetObjectShader(Jim,shFog)
	SetObjectPosition(Jim,Player.x,1,Player.y)
	// SetObjectVisible(jim, 0)
	// SetObjectCollisionMode(Jim,1)
	// Create3DPhysicsDynamicBody(jim)
	// SetObjectShapeBox(jim)
	n = Jim
	
	
	// camera et light collé au player
	Global PlayerCam,PlayerLight
	PlayerCam = CreateObjectBox(1,1,1)
	PlayerLight = CreateObjectBox(1,1,1)
	SetObjectPosition(PlayerCam, 0,10,15)
	FixObjectToObject(PlayerCam,Jim)
	SetObjectVisible(PlayerCam,0)

	SetObjectPosition(PlayerLight, 0,2,-5)	
	FixObjectToObject(PlayerLight,Jim)	
	SetObjectVisible(PlayerLight,0)
	
	// ------  la cible pour le clic and go 
	Global Cible as integer
	Cible = CreateObjectBox(1,1,1)
	SetObjectColor(Cible,255,0,0,120)
	SetObjectVisible(Cible, 0)
	
	
	// ------  la cible pour le mob (ou l'objet, action..) ciblé
	
	
	Global CibleMob as integer
	CibleMob = CreateObjectPlane(2,2)
	n = CibleMob
	SetObjectColor(n,255,0,0,120)
	SetObjectRotation(n,90,0,0)
	SetObjectPosition(n,-10000,-10000,-10000)
	*/
	
	
EndFunction


//event



// update
Function MovePlayer()
	
	/*	
	//print(str(GetObjectX(PlayerCam))+","+str(GetObjectY(PlayerCam))+","+str(GetObjectZ(PlayerCam)))	
	
	SetObjectPosition(Jim,Player.x,GetObjectY(Jim),Player.z)
	//SetCameraPosition(1,Player.x,h2+5,Player.z-15)
	SetCameraPosition(1,Player.x,h2+15,Player.z-25)
	// SetCameraPosition(1,GetObjectWorldX(PlayerCam),GetObjectWorldY(PlayerCam),GetObjectWorldZ(PlayerCam))

	// SetCameraRotation(1,0,GetObjectAngleY(jim),0)
	SetCameraLookAt(1,Player.x,Player.Y+2,Player.z,1)
		
	// SetPointLightPosition(1,Player.x,10,Player.z-2)
	//SetObjectPosition(Sphere,Player.x,10,Player.z-2)
	n = PlayerLight
	SetPointLightPosition(1,GetObjectWorldX(n),GetObjectWorldY(n),GetObjectWorldZ(n))
	SetObjectPosition(Sphere,GetObjectWorldX(n),GetObjectWorldY(n),GetObjectWorldZ(n))
	*/
	
EndFunction



