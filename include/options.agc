
// ************ OPTIONS


FoldStart // types 


Type tPosition
	
	x as integer
	y as integer
	
EndType

type tAssetBase
	
	Size as float
	W as integer
	L as integer
	H as integer
	Material as integer
	
	Colision
	PhysicsBody
	
endtype
	
type tShow


	Grid as integer
	Center as integer
	
	// Assets
	Light as integer
	Object as integer	
	Camera as integer
	
	FX as integer
	Water as integer
	Terrain as integer
	UI as integer
	LMRT as integer 


endtype

Type tExport
	
	Index$
	UseAgeType
	
Endtype



Type tOptions
	
	ok as integer // to know if the options.ini is saved in media (write folder), needed for the first time we open the visual editor
	Y as integer // the position of the menu
	
	GameMode as integer // 0 = plateforme, 1 = isometric, 2 = 3rd person, 3=rts (vue de dessus, petit, 4 = fps, 5 = camera fixe
	

	// general
	Debug as integer
	AutoReso as integer
	AllowResize as integer
	ScreenHeight as integer
	ScreenWidth as integer
	FullScreen as integer // when playing the game
		
	//camera
	Camera as tCamera
		
		
	PhysicsGravity as tVector
	PhysicsScale 
		
	// util
	Show as tShow
	
	ShowGrid as integer
	ShowCenter as integer
	
	// Assets
	ShowLight as integer
	ShowObject as integer	
	ShowCamera as integer
	
	Asset as tAssetBase
	
	// performances
	ShadowOn as integer
	AntiAlias as integer
	ShowFX as integer
	ShowWater as integer
	ShowTerrain as integer
	ShowUI as integer
	ShowLMRT as integer 
	
	// size of images
	WaterImageSize as integer
	LightmapImageSize as integer


	// UI
	UpdateStagelist
	
	Snap as integer
	SnapX as integer
	SnapY as integer
	SnapZ as integer
	
	LockX as integer
	LockY as integer
	LockZ as integer
	LockRX as integer
	LockRY as integer
	LockRZ as integer
	LockSX as integer
	LockSY as integer
	LockSZ as integer
	
	// Automatic operation
	AutoCreate
	
	// view Edition
	Orientation as integer // global, local ?
	Pivotcenter as integer // origine,bbox,cursor
	
	Profil$ // the profil for the user
	
	MinX as float
	MaxX as float
	MinY as float
	MaxY as float
	MinZ as float
	MaxZ as float
	
	// position of the center view
	GeneralX as float
	GeneralY as float
	GeneralZ as float
	
	// Window position
	WindowBehavior 	as tPosition
	WindowShader 	as tPosition
	WindowObjParam 	as tPosition
	WindowPhysic 	as tPosition
	
	
	// Physic
	PhysicOn as integer 
	
	
	// Bank model 
	BankModelId as integer
	BankModeName$ 
	
	
	
	// directories
	TerrainFile$
	TextureFolder$
	
	// list image (image du folder ou texture bank)
	listImageTyp as integer
	
	//atmospheric
	ShowFog as integer
	ShowSun as integer
	ShowSkyBox as integer
	AtmosphereOK as integer 
	
	
	
	
	
	// Editor only, not saved // pour bouger/scaler/rotationner les objets
	Startx#
	Starty#
	Startz#
	MenuOpen as integer
	HideLag as integer
	


	//theme
	ClearColor as integer
	Theme$
	ColorFont as integer
	
	// export - import
	Export as tExport
	DistancePartTocam as integer
	DistanceCulling as integer
	DistanceLod as integer
	UseFpe as integer
	
	// Player
	Player as sPlayer
	
EndType


foldend




// init 
Function InitOptions()
	
	Global Options as tOptions
	ResetOption()	
	LoadOptions()
	
EndFunction




// Reset
Function ResetOption()


	Options.Debug = 0
	Options.ShowGrid = 1
	
	//Assets
	Options.ShowLight = 1
	Options.ShowObject = 1
	Options.ShowFX = 1
	Options.ShowCamera = 1
	Options.ShowWater = 1
	Options.ShowCenter = 1
	
	// Performance
	Options.ShadowOn = 0
	Options.AntiAlias= 1
	Options.WaterImageSize= 256

	// UI
	Options.Snap = 0
	Options.SnapX = 5
	Options.SnapY = 5
	Options.SnapZ = 5
	Options.LockX = 0
	Options.LockY = 0
	Options.LockZ = 0
	
	// asset
	Options.Asset.Size = 1
	Options.Asset.W = 10
	Options.Asset.H = 10
	Options.Asset.L = 10
	Options.Asset.Colision = 1
	Options.Asset.PhysicsBody = 0
	
	// physic world
	Options.PhysicsGravity.x = 0
	Options.PhysicsGravity.y = -10
	Options.PhysicsGravity.z = 0
	Options.PhysicsScale = 40
	
	// Resolution
	Options.AllowResize = 0
	Options.AutoReso = 1
	Options.ScreenWidth = 1024
	Options.ScreenHeight = 768
	Options.FullScreen = 0
	
	// effects
	Options.ShowFog = 0
	Options.ShowSun = 0
	Options.ShowSkyBox = 0
	
	// Shadow
	/*
	Options.Shado.Active = 0
	Options.Shado.bias	 = 0
	Options.Shado.Smooth = 0
	Options.Shado.Typ = 0
	Options.Shado.Width = 256
	Options.Shado.Height = 256
	*/
	
	// Reset camera
	Options.Camera.X	= 0
	Options.Camera.Y	= 0
	Options.Camera.Z	= 0
	Options.Camera.RX	= 0
	Options.Camera.RY	= 180
	Options.Camera.RZ	= 0
	Options.Camera.Speed  = 5
	Options.Camera.Near  = 1
	Options.Camera.Far  = 3000
	Options.Camera.Fov  = 70
	Options.Camera.Ortho = 0
	Options.Camera.OrthoW = 1000
	
	RotateCameraGlobalY(1,180)
	SetCameraRange(1,Options.Camera.Near,Options.Camera.Far)
	SetCameraFov(1,Options.Camera.Fov)
	
	Options.theme$ = "darkgrey"
	Options.ClearColor = MakeColor(80,80,80)
	Options.ColorFont = MakeColor(255,255,255)
	Options.TerrainFile$ = "terrain/default/terrain.fpe"
	
	// export
	Options.Export.Index$ = "atmos,img,model,object,light,psys,camera,start,end,mob,npc,"
	Options.Export.UseAgeType = 1

	Options.DistancePartTocam = 500
	Options.DistanceCulling = 1000
	
	// player	
	Options.Player.lifeMax = 50
	Options.Player.life = Options.Player.lifeMax
	Options.Player.Speed = 0.1
	Options.Player.MobId = -1
	Options.Player.MapId = 0
	Options.Player.Degat = 10
	
Endfunction




// Load, save
Function LoadOptions()
	
	
	//message(GetWritePath())
	
	if GetFileExists("options.ini")
		
		OpenToread(1,"options.ini")
		
		While FileEOF(1) = 0
			
			line$ = readline(1)
			
			index$ = GetStringToken(line$,"=",1)
			i$ = GetStringToken(line$,"=",2)
			
			select index$
				
				// options
				case "AntiAlias"
					Options.AntiAlias = val(i$)
				endcase
				case "GameMode"
					Options.GameMode = val(i$)
					// LAg_SetGadgetTExt()
				endcase
								
				// Player
				case "PlayerLifemax"
					Options.Player.lifeMax = val(i$)	
				endcase
				case "PlayerDamage"
					Options.Player.Degat = val(i$)	
				endcase
				case "PlayerSpeed"				
					Options.Player.Speed = ValFloat(i$)	
				endcase
				
				// Screen resolution
				case "AutoReso"
					Options.AutoReso = val(i$)
				endcase
				case "AllowResize"
					Options.AllowResize = val(i$)
				endcase
				case "ScreenWidth"
					Options.ScreenWidth = val(i$)
				endcase
				case "ScreenHeight"
					Options.ScreenHeight = val(i$)
				endcase	
				case "FullScreen"
					Options.FullScreen = val(i$)
				endcase
				
				// Show , hide options
				case "Debug"
					Options.Debug = val(i$)
				endcase
				case "ShowGrid"
					Options.ShowGrid = val(i$)
				endcase
				case "ShowLight"
					Options.ShowLight = val(i$)
				endcase
				case "ShowObject"
					Options.ShowObject	= val(i$)
				endcase
				case "ShowFX"
					Options.ShowFX = val(i$)
				endcase				
				case "ShowCenter"
					Options.ShowCenter = val(i$)					
				endcase				
				case "ShowLMRT"
					Options.ShowLMRT = val(i$)
				endcase				
				
				// Water
				case "ShowWater"
					Options.ShowWater = val(i$)
				endcase
				case "WaterImageSize"
					Options.WaterImageSize = val(i$)					
					Options.WaterImageSize = min3(Options.WaterImageSize,0,128)				
				endcase
				
				// Terrain
				case "ShowTerrain"
					Options.ShowTerrain = val(i$)
				endcase				
				case "TerrainFile"
					Options.TerrainFile$ = i$					
				endcase
				
				// Shadow, lightmap
				case "LightmapImageSize"
					Options.LightmapImageSize = val(i$)	
					Options.LightmapImageSize = min3(Options.LightmapImageSize,0,512)
				endcase
				case "ShadowOn"
					Options.ShadowOn = val(i$)
				endcase
				
				// Asset
				case "AssetSize"		
					Options.Asset.Size = val(i$)
				endcase
				case "AssetW"		
					Options.Asset.W = val(i$)
				endcase
				case "AssetH"		
					Options.Asset.H = val(i$)
				endcase
				case "AssetL"		
					Options.Asset.L = val(i$)
				endcase
				case "AssetColision"		
					Options.Asset.Colision = val(i$)
				endcase
				case "AssetPhysicBody"		
					Options.Asset.PhysicsBody = val(i$)
				endcase
					
				// physics world
				case "PhysicsScale"		
					Options.PhysicsScale = val(i$)
				endcase
				case "PhysicsGravityX"		
					Options.PhysicsGravity.x = val(i$)
				endcase
				case "PhysicsGravityY"		
					Options.PhysicsGravity.y = val(i$)
				endcase
				case "PhysicsGravityZ"		
					Options.PhysicsGravity.z = val(i$)
				endcase
				
						
				// Snap				
				case "Snap"
					Options.Snap = val(i$)
				endcase				
				case "SnapX"
					Options.SnapX = val(i$)
					SNapX = Options.SnapX
				endcase
				case "SnapY"
					Options.SnapY = val(i$)
					SnapY = Options.SnapY
				endcase
				case "SnapZ"
					Options.SnapZ = val(i$)
					SnapZ = Options.SnapZ
				endcase
				
				// LOCK
				case "LockRX"
					Options.LockRX = val(i$)
				endcase
				case "LockRY"
					Options.LockRY = val(i$)
				endcase
				case "LockRZ"
					Options.LockRZ = val(i$)
				endcase
				case "LockSZ"
					Options.LockSZ = val(i$)
				endcase
				case "LockSY"
					Options.LockSY = val(i$)
				endcase
				case "LockSX"
					Options.LockSX= val(i$)
				endcase
				case "LockX"
					Options.LockX = val(i$)
				endcase
				case "LockY"
					Options.LockY = val(i$)
				endcase
				case "LockZ"
					Options.LockZ = val(i$)
				endcase
				
				// Atmosphere Show, hide  : not used anymore, use the sky panel
				case "ShowFog"
					Options.ShowFog = val(i$)
				endcase
				case "ShowSun"
					Options.ShowSun = val(i$)
				endcase
				case "ShowSkyBox"
					Options.ShowSkyBox = val(i$)
				endcase
				
				// Theme and color UI
				case "Theme"
					Options.Theme$ = i$
				endcase
				
				case "ColorFont"
					ColorFont$ = Lower(i$)
					if ColorFont$ = "c_white"
						Options.ColorFont = MakeColor(255,255,255)
					elseif ColorFont$ = "c_black" 
						Options.ColorFont = 0					
					elseif ColorFont$ = "c_grey" 
						Options.ColorFont = MakeColor(127,127,127)
					elseif ColorFont$ = "c_darkgrey" 
						Options.ColorFont = MakeColor(60,60,60)
					elseif ColorFont$ = "c_lightgrey" 
						Options.ColorFont = MakeColor(200,200,200)
					else
						Options.ColorFont = val(ColorFont$)
					endif
				endcase
				case "Clearcolor"
					Options.Clearcolor = val(i$)
				endcase
				
				// Camera parameters
				case "ShowCamera"
					Options.ShowCamera = val(i$)
				endcase
				case "CameraFov"
					Options.Camera.Fov = val(i$)
				endcase
				case "CameraFar"
					Options.Camera.Far = val(i$)										
				endcase
				case "CameraNear"
					Options.Camera.Near = val(i$)
				endcase
				case "CameraFov"
					Options.Camera.Fov = val(i$)					
				endcase
				case "CameraOrthoW"
					Options.Camera.OrthoW = val(i$)					
				endcase
				case "CameraSpeed"
					Options.Camera.Speed = val(i$)					
				endcase
				case "CamX"
					Options.Camera.X = val(i$)
				endcase				
				case "CamY"
					Options.Camera.Y = val(i$)
				endcase
				case "CamZ"
					Options.Camera.Z = val(i$)
				endcase
				case "CamRX"
					Options.Camera.RX = val(i$)
				endcase
				case "CamRY"
					Options.Camera.RY = val(i$)
				endcase
				case "CamRZ"
					Options.Camera.RZ = val(i$)
				endcase
				
				// SAving parameters
				case "ExportIndex"
					Options.Export.Index$ = i$
				endcase
				case "ExportUseAgeType"
					Options.Export.UseAgeType= val(i$)
				endcase
				case "DistancePartTocam"
					Options.DistancePartTocam = val(i$)
				endcase
				case "DistanceCulling"
					Options.DistanceCulling = val(i$)
				endcase
				case "DistanceLod"
					Options.DistanceLod = val(i$)
				endcase
			
			endselect
			
		EndWhile
		
		Options.Ok = 1
		
		closefile(1)
	else
		LoadAtmosphere("atmos.txt",1,0)	
		ResetOption()
		SaveOptions()		
	endif
	
	
	
	// Options.CameraNear = 1
	// Options.CameraFar  = 10000
	// set some options by default
		
	if Options.WaterImageSize<=0
		Options.WaterImageSize = 128
	endif
	
	if Options.theme$ =""
		Options.theme$ = "darkgrey"
	endif
	if Options.TerrainFile$ = ""
		Options.TerrainFile$ = "terrain/default/terraindefault.fpe"						
	endif
	if Options.Export.Index$ = ""
		Options.Export.Index$ = "atmos,img,model,object,light,psys,camera,start,end,mob,npc,"
	endif
	
	// set camera
	SetCamera()
	
	// puis, je load l'atmosphere
	LoadAtmosphere("atmos.txt",1,0)	
	
EndFunction



Function SaveOptions()
	
	// save the options
	OpenToWrite(1,"options.ini")
		
		WriteLine(1,"; Preference file for AGE 3D (AGK Game Editor)")
		
		WriteLine(1,"; Options Editor")
		WriteLine(1,"Debug="+str(Options.Debug))
		WriteLine(1,"AntiAlias="+str(Options.AntiAlias))
		
		WriteLine(1,"; Show/hide assets")
		WriteLine(1,"ShowGrid="+str(Options.ShowGrid))
		WriteLine(1,"ShowLight="+str(Options.ShowLight))
		WriteLine(1,"ShowObject="+str(Options.ShowObject))		
		WriteLine(1,"ShowCamera="+str(Options.ShowCamera))
		WriteLine(1,"ShowWater="+str(Options.ShowWater))
		WriteLine(1,"ShowTerrain="+str(Options.ShowTerrain))
		WriteLine(1,"ShowCenter="+str(Options.ShowCenter))
		WriteLine(1,"; Show/hide LightMapRealTime")
		WriteLine(1,"ShowLMRT="+str(Options.ShowLMRT))
		
		WriteLine(1,"; for Assets creation (by default)")
		WriteLine(1,"AssetSize="+str(Options.Asset.Size))
		WriteLine(1,"AssetW="+str(Options.Asset.W))
		WriteLine(1,"AssetH="+str(Options.Asset.H))
		WriteLine(1,"AssetL="+str(Options.Asset.L))
		WriteLine(1,"AssetColision="+str(Options.Asset.Colision))
		WriteLine(1,"AssetPhysicsBody="+str(Options.Asset.PhysicsBody))

		WriteLine(1,"; Physics world")
		WriteLine(1,"PhysicsScale="+str(Options.PhysicsScale))
		WriteLine(1,"PhysicsGravityX="+str(Options.PhysicsGravity.x))
		WriteLine(1,"PhysicsGravityY="+str(Options.PhysicsGravity.y))
		WriteLine(1,"PhysicsGravityZ="+str(Options.PhysicsGravity.z))

		
		WriteLine(1,"; Directories")
		WriteLine(1,"TerrainFile="+Options.TerrainFile$)
		
		
		WriteLine(1,"; Options Resolution")
		WriteLine(1,"AutoReso="+str(Options.AutoReso))
		WriteLine(1,"AllowResize="+str(Options.AllowResize))
		WriteLine(1,"ScreenWidth="+str(Options.ScreenWidth))
		WriteLine(1,"ScreenHeight="+str(Options.ScreenHeight))
		WriteLine(1,"FullScreen="+str(Options.FullScreen))
		
		WriteLine(1,"; Performance Editor")
		WriteLine(1,"ShadowOn="+str(Options.ShadowOn))
		WriteLine(1,"AntiAlias="+str(Options.AntiAlias))
		WriteLine(1,"ShowFX="+str(Options.ShowFX))
		WriteLine(1,"WaterImageSize="+str(Options.WaterImageSize))
		WriteLine(1,"LightmapImageSize="+str(Options.LightmapImageSize))
		
		/*
		WriteLine(1,"; Atmospheric effects ; not used anymore")
		WriteLine(1,"ShowFog="+str(Options.ShowFog))
		WriteLine(1,"ShowSun="+str(Options.ShowSun))
		WriteLine(1,"ShowSkyBox="+str(Options.ShowSkyBox))
		*/
		
		WriteLine(1,"; UI")
		WriteLine(1,"Snap="+str(Options.Snap))
		WriteLine(1,"SnapX="+str(Options.SnapX))
		WriteLine(1,"SnapY="+str(Options.SnapY))
		WriteLine(1,"SnapZ="+str(Options.SnapZ))
		WriteLine(1,"LockX="+str(Options.LockX))
		WriteLine(1,"LockY="+str(Options.LockY))
		WriteLine(1,"LockZ="+str(Options.LockZ))
		WriteLine(1,"LockRZ="+str(Options.LockRZ))
		WriteLine(1,"LockRX="+str(Options.LockRx))
		WriteLine(1,"LockRY="+str(Options.LockRy))
		WriteLine(1,"LockSX="+str(Options.Locksx))
		WriteLine(1,"LockSY="+str(Options.Locksy))
		WriteLine(1,"LockSZ="+str(Options.Locksz))
		
		WriteLine(1,"; Theme (other theme : basic, light, dark, fx, white, classic, darkgrey)")
		WriteLine(1,"Theme="+Options.Theme$)
		WriteLine(1,"ClearColor="+str(Options.ClearColor))
		WriteLine(1,"; ColorFont : c_black,c_grey,c_white,c_darkgrey,c_lightgrey or the color in rgb(r,g,b), ex : 2525624")
		WriteLine(1,"ColorFont="+str(Options.ColorFont))

		WriteLine(1,"; Camera")
		Options.Camera.RX = GetCameraAngleX(1)
		Options.Camera.RY = GetCameraAngleY(1)
		Options.Camera.RZ = GetCameraAngleZ(1)
		Options.Camera.X = GetCameraX(1)
		Options.Camera.Y = GetCameraY(1)
		Options.Camera.Z = GetCameraZ(1)
		Options.Camera.Fov = GetCameraFOV(1)
				
		WriteLine(1,"CamX="+str(Options.Camera.X))
		WriteLine(1,"CamY="+str(Options.Camera.Y))
		WriteLine(1,"CamZ="+str(Options.Camera.Z))
		WriteLine(1,"CamRX="+str(Options.Camera.RX))
		WriteLine(1,"CamRY="+str(Options.Camera.RY))
		WriteLine(1,"CamRZ="+str(Options.Camera.RZ))
		WriteLine(1,"CameraSpeed="+str(Options.Camera.Speed,2))
		WriteLine(1,"CameraNear="+str(Options.Camera.Near,2))
		WriteLine(1,"CameraFar="+str(Options.Camera.Far,0))
		WriteLine(1,"CameraFov="+str(Options.Camera.Fov))
		WriteLine(1,"CameraOrthoW="+str(Options.Camera.OrthoW))
		
		WriteLine(1,"; Play")	
		WriteLine(1,"GameMode="+str(Options.GameMode))
		
		WriteLine(1,"; Player")	
		WriteLine(1,"PlayerLifemax="+str(Options.Player.lifeMax))
		WriteLine(1,"PlayerDamage="+str(Options.Player.Degat))
		WriteLine(1,"PlayerSpeed="+str(Options.Player.Speed,3))
		
		
		
		WriteLine(1,"; Export")	
		WriteLine(1,"ExportIndex="+Options.Export.Index$)
		WriteLine(1,"ExportUseAgeType="+str(Options.Export.UseAgeType))
		WriteLine(1,"DistancePartTocam="+str(Options.DistancePartTocam))
		WriteLine(1,"DistanceCulling="+str(Options.DistanceCulling))
		WriteLine(1,"DistanceLod="+str(Options.DistanceLod))
		
		
	closefile(1)
	
	// puis, je sauvegarde l'atmosphere
	SaveAtmosphere("atmos.txt",1,0)
	
	
	
EndFunction


// Options for the game : see export.agc ??
