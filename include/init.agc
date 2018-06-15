
//******************* INIT *********************//


Function InitFirstOpening()
	
	// just use for the first opening of the program.
	If GetFileExists("options.ini") = 0
		
		InitOptions()
		
		RunApp(C_PROGRAM_NAME + ".exe","")
		
		// sleep(1000)
		
		End
		
	endif	
	
EndFunction


Function InitGeneral()
	
	
	// init variables & constantes
    SetVariables()
    SetConstant()
    
    //message(str(GetVirtualWidth())+"/"+str(GetVirtualHeight()))
    
	InitAtmospheric() // in atmospheric.agc
	InitOptions() // in options.agc
	
	
	#Constant C_VERSION  "0.63"
	#Constant C_DATE 	 "23 March 2018"

	
	
	
	FoldStart // ** RESOLUTION
	
	Global G_width, G_height as integer
	
	
	forvideo = 1 
	
	if forvideo = 1
		G_width = 1024
		G_height = 768
	else
			
		If Options.AutoReso = 1
			//message("on prend la reso ecran")
			G_width = GetDeviceWidth()
			G_height = GetDeviceHeight()
		else
			//message("reso definie par nous")
			G_width = options.ScreenWidth
			G_height = options.ScreenHeight
		endif

		if G_width < 800
			G_width = GetDeviceWidth()
		endif
		if G_height < 600
			G_height = GetDeviceHeight()
		endif
	endif

	SetWindowSize(G_width,G_height,0)
	SetVirtualResolution(G_width, G_height)
	SetWindowTitle(C_PROGRAM_NAME+" "+C_VERSION)
	// SetResolutionMode(1)
	SetWindowAllowResize(1)
	
	UseNewDefaultFonts(1)
	
	
	
	

	FoldEnd
	
    //message(str(GetVirtualWidth())+"/"+str(GetVirtualHeight()))


	FoldStart //set a Background to wait

	
	LoadImage(2,"ui/age.png")
	LoadImage(1,"ui/bg.jpg")
	CreateSprite(1,1)
	
	if forvideo = 0
		If Options.AutoReso = 1
			GetW = GetDeviceWidth()
			if GetScreenBoundsRight() < GetW  or GetScreenBoundsRight()<1024
				if GetW < 1024
					if GetDeviceWidth() >= 1024
						G_width = GetDeviceWidth()
					else
						G_width = 1024
					endif
				else
					if GetW >= 1024 
						G_width = GetW
					else
						G_width = 1024
					endif			
				endif
			endif
		

			if GetScreenBoundsTop() < GetDeviceHeight()
				G_height = GetDeviceHeight()
			endif
			SetWindowSize(G_width,G_height,0)
			SetVirtualResolution(G_width, G_height)
			
		endif
	endif
	
	
	
	SetSpriteSize(1,G_width,G_height)
	CreateSprite(2,2)
	SetSpritePosition(2,G_width/2-GetImageWidth(2)/2,G_height/2-GetImageHeight(2)/2-50)
	Sync()
	
	DeleteSprite(1) : DeleteImage(1)
	DeleteSprite(2) : DeleteImage(2)
	
	
	// define other parameters
	SetPrintSize(20)
	SetGlobal3DDepth(10000)
	SetScissor(0,0,0,0)
	

	
	
	
	
	Foldend




	FoldStart // UI (menu, gadgets)


	// ** THE UI

	// * include the LAG lib (lib made by blendman, oh it's me :))
	// please read : LAG_infos.agc
	
	#Constant USE_LAG = 1

	If use_Lag = 1
		
	Init_LAG(Options.theme$) // other theme : grey, light, dark, fx, white, classic, darkgrey - you can add/change the theme in LAG_init.agc

	Foldstart //*************************** INTERFACE ************************************//

	LAG_InitMenuBox()

	//***** variables
	Global idMenu, PaneLW, PanelH, PanelL_Id, PanelR_Id as integer
	Global MenuH, StatusBarH as integer
	idMenu = -1

	// PanelL_Id = to know the panel Left currently opened
	// PanelR_Id = to know the panel Right currently opened
	
	

	FoldStart //************************ LAG - GADGETS & Menu TEST ***************************//


	FoldStart //*************** The Menu Id


	FOLDSTART //*** Menu constant
	
	// File 0 - 9
	#constant C_MENU_NEW = 0
	#constant C_MENU_OPEN = 1
	#constant C_MENU_MERGE = 2
	#constant C_MENU_SAVE = 3
	#constant C_MENU_SAVEAS = 4
	#constant C_MENU_EXPORT = 5
	#constant C_MENU_IMPORT = 6
	#constant C_MENU_PROP = 7
	#constant C_MENU_PREF = 8
	#constant C_MENU_QUIT = 9


	// EDIT 10 - 25
	#constant C_MENU_UNDO = 10
	#constant C_MENU_REDO = 11

	#constant C_MENU_COPY = 12
	#constant C_MENU_PASTE = 13
	#constant C_MENU_DUPLIQ = 14
	#constant C_MENU_CLONE = 15
	
	#constant C_MENU_HIDE = 16
	#constant C_MENU_FREEZE = 17
	
	#constant C_MENU_TRANSFORMALL = 18
	#constant C_MENU_SETOBJPARAM = 19

	// view 26 - 39
	#constant C_MENU_ZOOMPLUS = 26
	#constant C_MENU_ZOOMLESS = 27

	#constant C_MENU_SHOWPANEL = 28
	#constant C_MENU_SHOWCENTER = 36

	#constant C_MENU_GRID = 29
	#constant C_MENU_DEBUG = 30

	#constant C_MENU_VIEWRESET = 31
	#constant C_MENU_VIEWCENTER = 32
	#constant C_MENU_VIEWSELECTED = 33

	#constant C_MENU_USEWATER = 34
	#constant C_MENU_USERTLM = 39 // real time light map
	//#constant C_MENU_SUN = 35
	//#constant C_MENU_FOG = 36
	//#constant C_MENU_SKYBOX = 39
	
	// object 40 - 59
	#constant C_MENU_ADDOBJ = 40
	#constant C_MENU_ADDLIGHT = 41
	#constant C_MENU_ADDCAMERA = 42
	#constant C_MENU_ADDFX = 43
	#constant C_MENU_ADDSTART = 44
	#constant C_MENU_ADDUI = 45
	#constant C_MENU_ADDWATER = 46
	#constant C_MENU_ADDTERRAIN = 47
	#constant C_MENU_CREATELIGHTMAP = 48


	#constant C_MENU_CHANGETYP = 50
	#constant C_MENU_CHANGEIMG = 51

	//help 60 - 69
	#constant C_MENU_ABOUT = 60
	#constant C_MENU_HELP = 61
	#constant C_MENU_INFO = 62
	#constant C_MENU_RELEASE = 63
	#constant C_MENU_UPDATE = 69
	
	// Selection 70 - 80
	#constant C_MENU_ADDSEL = 70
	#constant C_MENU_SELECTALL = 71
	#constant C_MENU_DESELECTALL = 72
	#constant C_MENU_SELECTBYNAME = 73
	#constant C_MENU_SELECTBYGROUP = 74
	
	// project 81 - 90
	#constant C_MENU_SceneAdd 		= 81
	#constant C_MENU_SceneSelect 	= 82
	#constant C_MENU_SceneDelete 	= 83
	#constant C_MENU_SceneClone 	= 84
	#constant C_MENU_ScenePropertie = 85
	#constant C_MENU_GamePropertie 	= 86





	Global LAG_LASTMENUID as integer // = 100

	

	FOLDEND



	MenuH = 20
	LAG_CreateMenu(0,-1,MenuH,0)
	u=0
	
	// LAG_SetMenuPosition(0,100,0) // to change the menu position if needed

	// MENU FILE
	LAG_MenuTitle(0,"File") // the id of the menutitle is = 0
	LAG_MenuItem(0,C_MENU_NEW,"New  (Ctrl+N)") // you can use a constant for the menuItem Id : #constant CMENU_OPENAS = 20 : LAG_MenuItem(0,CMENU_OPENAS,"Open as...")
	LAG_MenuBar(0) 
	LAG_MenuItem(0,C_MENU_OPEN,"Open  (Ctrl+O)") // you can use a constant for the menuItem Id : #constant CMENU_OPENAS = 20 : LAG_MenuItem(0,CMENU_OPENAS,"Open as...")
	LAG_MenuItem(0,C_MENU_MERGE,"Merge") // you can use a constant for the menuItem Id : #constant CMENU_OPENAS = 20 : LAG_MenuItem(0,CMENU_OPENAS,"Open as...")
	LAG_MenuBar(0) 
	LAG_MenuItem(0,C_MENU_SAVE,"Save  (Ctrl+S)")
	LAG_MenuItem(0,C_MENU_SAVEAS,"SaveAs")
	LAG_MenuItem(0,C_MENU_EXPORT,"Export the level (Ctrl+E)")
	//LAG_MenuItem(0,15,"Import")
	LAG_MenuBar(0) // not working for the moment
	LAG_MenuItem(0,C_MENU_QUIT,"Quit  (Esc)")


	// MENU EDIT
	LAG_MenuTitle(0,"Edit") : inc  u // its id = 1
	//LAG_MenuItem(1,C_MENU_UNDO,"Undo") // the first number = id of the menutitle, the 2nd = id of the menuitem
	//LAG_MenuItem(1,C_MENU_REDo,"Redo")
	LAG_MenuItem(u,C_MENU_COPY,"Copy the selected objects  (Ctrl+C)")
	LAG_MenuItem(u,C_MENU_PASTE,"Paste  (Ctrl+V)")
	// LAG_MenuItem(u,C_MENU_DUPLIQ,"Duplicate Asset  (Shift+D)")
	LAG_MenuItem(u,C_MENU_CLONE,"Clone the selected objects  (Ctrl+D)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_HIDE,"Hide the selected Objects  (H)")
	LAG_MenuItem(u,C_MENU_FREEZE,"Lock the selected Objects  (F)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_SETOBJPARAM,"Change Objects parameters")
	
	

	// MENU VIEW
	LAG_MenuTitle(0,"View") : inc u // its id = 2, and so....
	
	//LAG_MenuItem(u,C_MENU_ZOOMPLUS,"Zoom +")
	//LAG_MenuItem(u,C_MENU_ZOOMLESS,"Zoom -")
	
	LAG_MenuItem(u,C_MENU_VIEWRESET,	"Reset view   (9)")
	LAG_MenuItem(u,C_MENU_VIEWCENTER,	"Center view  (*)")
	LAG_MenuItem(u,C_MENU_VIEWSELECTED,	"View to selected  (/)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_GRID,			"Show grid  (Ctrl+G)")
	LAG_MenuItem(u,C_MENU_SHOWPANEL,	"Show panel  (Tab)")
	LAG_MenuItem(u,C_MENU_SHOWCENTER,	"Show Center")
	LAG_MenuItem(u,C_MENU_Debug,		"Show Debug (D)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_USERTLM,		"LightMap (Real Time)")
	LAG_MenuItem(u,C_MENU_USEWATER,		"Show Water")
	/*
	LAG_MenuItem(2,C_MENU_SUN,"Use Sun   (U)")
	LAG_MenuItem(2,C_MENU_FOG,"Use Fog   (F)")
	LAG_MenuItem(2,C_MENU_SKYBOX,"Use SkyBox   (B)")
	*/

	// MENU Selection
	LAG_MenuTitle(0,"Selection ") : inc u // its id = 3
	LAG_MenuItem(u,C_MENU_SELECTALL,"Select All (Ctr+A)")
	LAG_MenuItem(u,C_MENU_DESELECTALL,"Deselect All (Ctr+D)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_ADDSEL,"Create a new selection")
	LAG_MenuItem(u,C_MENU_SELECTBYNAME,"Select by name")
	LAG_MenuItem(u,C_MENU_SELECTBYGROUP,"Select by group")
	
	
	
	// MENU PROJECT
	LAG_MenuTitle(0,"Object ") : inc u // its id = 3	
	//LAG_MenuItem(u,C_MENU_CHANGETYP,"Change Type of Object   (T)")
	//LAG_MenuItem(u,C_MENU_CHANGEIMG,"Change image of Object   (I)")
	//LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_ADDOBJ,"Add Object   (A)")
	LAG_MenuItem(u,C_MENU_ADDLIGHT,"Add Light   (L)")
	LAG_MenuItem(u,C_MENU_ADDCAMERA,"Add camera   (C)")
	LAG_MenuItem(u,C_MENU_ADDWATER,"Add Water")
	LAG_MenuItem(u,C_MENU_ADDTERRAIN,"Add Terrain")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_CREATELIGHTMAP,"CreateLightMap (Ctrl+L)")


	// MENU HELP	
	LAG_MenuTitle(0,"Help") : inc u // its id = 5
	LAG_MenuItem(u,C_MENU_HELP,"Help (F1)")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_RELEASE,"Release Log")
	LAG_MenuItem(u,C_MENU_INFO,"Informations")
	LAG_MenuBar(u) 
	LAG_MenuItem(u,C_MENU_ABOUT,"About")


	FoldEnd



	FoldStart //*************** Window Id
		
		// the "window id". Each gadget is linked at a window Id
		// if id = 0 or -1 , it's the main window program
		
		#constant C_WINMAIN  	 = 0
		#constant C_WINShader  	 = 1
		#constant C_WINBehavior  = 2
		#constant C_WINWater  	 = 3
		#constant C_WINTerrain   = 4
		#constant C_WINPref   	 = 5
		#constant C_WINPhysic    = 6
		
	
	FoldEnd
	
	
	
	FoldStart //*************** Gadgets 








		FOLDSTART //*** gadget constants


			FoldStart //** gadgets for main window
			
			FoldStart //* Toolbar
			#constant C_Gad_TB  	     = 1
			
			#constant C_GAD_TBNEW  	     = 2
			#constant C_GAD_TBSAVE       = 3
			#constant C_Gad_TBOPEN       = 4
				
			#constant C_Gad_TBOBJ  	 = 5
			#constant C_Gad_TBLIGHT	 = 6
			#constant C_Gad_TBCAM  	 = 7
			#constant C_Gad_TBFX  	 = 8
			
			#constant C_Gad_TBViewPan  = 9
			#constant C_Gad_TBViewRot  = 10
			#constant C_Gad_TBViewZoom  = 11
			
			
			// Play,create,select,move,scale,rotate,delete
			#constant C_Gad_TBPLAY  	= 12
			#constant C_Gad_TBADD		= 13
			#constant C_Gad_TBSELECT   	= 14
			#constant C_Gad_TBMOVE		= 15
			#constant C_Gad_TBSCALE  	= 16
			#constant C_Gad_TBROT  		= 17
			#constant C_Gad_TBCLONE  	= 18
			#constant C_Gad_TBDEL  		= 19
			
			foldend
			
		
		// Panel 
			#constant C_Gad_PanelL      = 20
			#constant C_Gad_PanelR      = 21



		FoldStart // Panel left
		
				Foldstart // Properties 
				
				
				
				Foldstart // gadget for window prop 
				
				#constant C_Gad_WinObjBehavior = 22
				#constant C_Gad_WinObjAnim = 23
				#constant C_Gad_WinObjProp = 24
				#constant C_Gad_WinObjShader = 25
				#constant C_Gad_WinObjPhysic = 26
				#constant C_Gad_WinObjPhysic2 = 27
				#constant C_Gad_WinObjEditor = 28
				#constant C_Gad_WinObjColor = 29
				
				#constant C_GAD_LoadPartsys = 30
				#constant C_GAD_SavePartsys = 31
				
				foldend
				
				
				#constant C_Gad_NameObj   = 32
				#constant C_Gad_Lock      = 33
				#constant C_Gad_Hide      = 34
				#constant C_Gad_ObjFog    = 35
				#constant C_Gad_ObjLight  = 36
				#constant C_Gad_ObjVisible  = 37
				#constant C_Gad_Shado     = 38
				#constant C_Gad_ShadoCAst = 39
				#constant C_Gad_ShadoREC  = 40
				
				#constant C_Gad_Size    = 41
				#constant C_Gad_Tra     = 42
				#constant C_Gad_Alpha   = 43
				#constant C_Gad_Rot     = 44
				#constant C_Gad_X       = 45
				#constant C_Gad_Y       = 46
				#constant C_Gad_Z       = 47
				#constant C_Gad_lock_X   = 48
				#constant C_Gad_lock_Y   = 49
				#constant C_Gad_lock_Z   = 50
				#constant C_Gad_lock_RX   = 51
				#constant C_Gad_lock_RY   = 52
				#constant C_Gad_lock_RZ   = 53
				#constant C_Gad_lock_SX   = 54
				#constant C_Gad_lock_SY   = 55
				#constant C_Gad_lock_SZ   = 56
				
				#constant C_Gad_Sx      = 57
				#constant C_Gad_Sy      = 58
				#constant C_Gad_Sz      = 59
				#constant C_Gad_Rx      = 60
				#constant C_Gad_Ry      = 61
				#constant C_Gad_Rz      = 62
				
				#constant C_Gad_R       = 63
				#constant C_Gad_G       = 64
				#constant C_Gad_B       = 65
				#constant C_Gad_BM  	= 66
				
				#constant C_Gad_Group  = 67
				#constant C_Gad_Layer  = 68
				
				#constant C_Gad_Type    = 69
				#constant C_Gad_SubType = 70
				#constant C_Gad_Param1  = 71
				#constant C_Gad_Param2  = 72
				
				
				


				// Shader, uv...
				#constant C_Gad_uvx = 73
				#constant C_Gad_uvy = 74
				#constant C_Gad_uvw = 75
				#constant C_Gad_uvh = 76
				#constant C_Gad_SetStage = 77
				#constant C_Gad_ImgName = 78
				#constant C_Gad_SetShader = 79
				
				// physics : use a physics window ?
				#constant C_Gad_Physic  = 80
				
				// animation (if object is animated)		
				#constant C_Gad_PlayAnim = 81
				#constant C_Gad_AnimStart = 82
				#constant C_Gad_AnimEnd = 83
				#constant C_Gad_AnimSpeed = 84
				
				
				
				
				// behavior
				
				
				
				
				
				Foldend
				
				FoldStart // images & Shaders
				
				#constant C_Gad_BankImg  	= 85
				#constant C_Gad_SetImg   	= 86
				#constant C_Gad_BankImgPrev = 87
				#constant C_Gad_BankImgNext = 88
				#constant C_Gad_ImgFolder  	= 89
				
				#constant C_Gad_ImgUsed 	= 90
				#constant C_Gad_ImgReload 	= 91
				#constant C_Gad_ImgAdd 		= 92
				#constant C_Gad_ImgDel 		= 93
				#constant C_Gad_ImgList 	= 94
				#constant C_Gad_ImgDelete 	= 95
				
				#constant C_Gad_ImgNormal 	= 96
				#constant C_Gad_ImgLightmap = 97
				#constant C_Gad_ImgSpec     = 98
				
				#constant C_Gad_SetStageName = 99
				#constant C_Gad_AddImgStage = 100
				#constant C_Gad_DelImgStage = 101
				#constant C_Gad_StageList = 102
				
				
				Foldend
				
				FoldStart // creation Assets (objets, light...)
				
				// Les textes 
				#constant C_Gad_TxtAsset  = 103
				#constant C_Gad_TxtCreate   = 104
				#constant C_Gad_TxtBank   = 105
				#constant C_Gad_TxtFolderimg   = 106
				#constant C_Gad_txtPreviewImg  = 107
				#constant C_Gad_TxtObjimg   = 108
				#constant C_Gad_ListStage   = 109

				
				
				
				#constant C_Gad_PreviewModel   = 110
				
				#constant C_Gad_AssetSize   = 111
				#constant C_Gad_AssetW   = 112
				#constant C_Gad_AssetH   = 113
				#constant C_Gad_AssetL   = 114
				#constant C_Gad_AssetProp   = 115
				
				
				
				#constant C_Gad_BankNew      = 116
				#constant C_Gad_BankOpen     = 117
				#constant C_Gad_BankSave     = 118
				#constant C_Gad_BankSub      = 119
				#constant C_Gad_BankOpenFolder = 120
				#constant C_Gad_BankImport   = 121
				#constant C_Gad_BankExport   = 122
				
				#constant C_Gad_BankPrevM  = 123
				#constant C_Gad_BankNextM   = 124
				#constant C_Gad_BankMeshSet = 125
				#constant C_Gad_BankInfo  	 = 126
				#constant C_Gad_BankAdd  	 = 127
				#constant C_Gad_BankList  	 = 128
				
				foldend
				
				#constant C_Gad_ShaderList   = 129
				#constant C_Gad_ShaderPreset = 130
				#constant C_Gad_ShaderReload = 131
				#constant C_Gad_ShaderFolder = 132
		
			Foldend
		
		Foldstart // Panel right				
			
			FoldStart // Atmospheric :  skybox, sun, fog, ambient
			
			#constant C_Gad_SkyOk    = 133
			
			#Constant C_GAD_AtmLoad  = 134
			#Constant C_GAD_AtmSave  = 135
			
			#constant C_Gad_SkyR     = 136
			#constant C_Gad_SkyG     = 137
			#constant C_Gad_SkyB     = 138
			
			#constant C_Gad_SkyHTxt   = 139
			#constant C_Gad_SkyHR     = 140
			#constant C_Gad_SkyHG     = 141
			#constant C_Gad_SkyHB     = 142
			#constant C_Gad_SkyLoad   = 143
			#constant C_Gad_SkySave   = 144
			
			#constant C_Gad_SunOk    = 145
			#constant C_Gad_SunR     = 146
			#constant C_Gad_SunG     = 147
			#constant C_Gad_SunB     = 148
			#constant C_Gad_SunX     = 149
			#constant C_Gad_SunY     = 150
			#constant C_Gad_SunZ     = 151
			#constant C_Gad_SunSave  = 152
			#constant C_Gad_SunLoad  = 153
			#constant C_Gad_SunInt   = 154
			
			#constant C_Gad_FogR     = 155
			#constant C_Gad_FogG     = 156
			#constant C_Gad_FogB     = 157
			#constant C_Gad_FogMin    = 158
			#constant C_Gad_FogMax    = 159
			#constant C_Gad_FogOk     = 160
			#constant C_Gad_FogSave   = 161
			#constant C_Gad_FogLoad   = 162
			
			#constant C_Gad_AmbR     = 163
			#constant C_Gad_AmbG     = 164
			#constant C_Gad_AmbB     = 165
			#constant C_Gad_AmbOk   = 166
			#constant C_Gad_AmbInt   = 167
			
			
			#constant C_Gad_Shado_RT   = 168
			#constant C_Gad_SHADO_Type   = 169
			#constant C_Gad_SHADO_Smooth   = 170
			#constant C_Gad_SHADO_Bias   = 171
			#constant C_Gad_SHADO_SizeW   = 172
			#constant C_Gad_SHADO_SizeH   = 173
			
			
			
			
			Foldend

			FoldStart // options 	
			
			#constant C_Gad_SnapX 	     = 174
			#constant C_Gad_SnapY  	     = 175
			#constant C_Gad_SnapZ  	     = 176
			#constant C_Gad_Snap  	     = 177

			
			#constant C_Gad_LockX      = 178
			#constant C_Gad_LockY      = 179
			#constant C_Gad_LockZ      = 180
			
			#constant C_Gad_LockSx     = 181
			#constant C_Gad_LockSy     = 182
			#constant C_Gad_LockSz     = 183
			
			#constant C_Gad_LockRx     = 184
			#constant C_Gad_LockRy     = 185
			#constant C_Gad_LockRz     = 186
			
			// camera
			#constant C_Gad_CamPresetList  = 187
			#constant C_Gad_CamPresetAdd   = 188
			#constant C_Gad_CamPresetUse   = 189
			#constant C_Gad_CamX      = 190
			#constant C_Gad_CamY      = 191
			#constant C_Gad_CamZ      = 192
			#constant C_Gad_CamRX     = 193
			#constant C_Gad_CamRY     = 194
			#constant C_Gad_CamRZ     = 195
			#constant C_Gad_CamFov    = 196
			#constant C_Gad_CamNear   = 197
			#constant C_Gad_CamFar    = 198
			#constant C_Gad_CamOrtW   = 199
			// #constant C_Gad_CamSpeed   = 200
			
			// Selection
			#constant C_Gad_BtnSelectTyp = 201
			#constant C_Gad_SelectList = 202

			
			Foldend
				
			FoldStart // tools
			
			#constant C_Gad_Tool1 = 203
			#constant C_Gad_Tool2 = 204
			#constant C_Gad_Tool3 = 205
			#constant C_Gad_Tool4 = 206
			
			// Lightmap container
			#constant C_Gad_ContLightMap = 207
			
			#constant C_Gad_LM_SoftShSample = 208
			#constant C_Gad_LM_SoftShSize = 209
			#constant C_Gad_LM_SizeRange = 210
			
			#constant C_Gad_LM_ShadoR = 211
			#constant C_Gad_LM_ShadoG = 212
			#constant C_Gad_LM_ShadoB = 213
			#constant C_Gad_LM_ShadoAlpha = 214
			#constant C_Gad_LM_Width = 215
			#constant C_Gad_LM_Height = 216
			#constant C_Gad_LM_UseLight = 217
			#constant C_Gad_LM_UseShado = 218
			#constant C_Gad_LM_Radiosity = 219
			#constant C_Gad_LM_UseAO = 220
			#constant C_Gad_LM_Rx = 221
			#constant C_Gad_LM_Ry = 222
			#constant C_Gad_LM_RZ = 223
			
			
			// Level container
			#constant C_Gad_ContLvl = 224
			
			#constant C_Gad_LvlDayNight = 225
			#constant C_Gad_LvlWeather = 226
			
			
			
			
			
			
			
			Foldend
		
		Foldend 
			
			
			
		Foldstart // toolbar 2 : global/local, center for rot/scale...
		
			#constant C_Gad_TB2 	     = 227
			#constant C_Gad_Orientation  = 228
			#constant C_Gad_PivotCenter  = 229
			#constant C_Gad_UsePhysics  = 230
			#constant C_Gad_GameMode = 231
			
			
			#constant C_Gad_Layer1  = 232
			#constant C_Gad_Layer2  = 233
			#constant C_Gad_Layer3  = 234
			#constant C_Gad_Layer4  = 235
			#constant C_Gad_Layer5  = 236
			#constant C_Gad_Layer6  = 237
			
			
			FoldEnd
			
			
			FoldEnd
			
			
			#constant C_Gad_Last      = 238


			FoldStart //** gadgets for behavior window
			
			#constant C_Gad_ListBehavior 	= 239
			#constant C_Gad_BehaviorTyp 	= 240
			#constant C_Gad_BehaviorSpeed 	= 241
			#constant C_Gad_BehaviorName 	= 242
			#constant C_Gad_BehaviorOk 		= 243
			#constant C_Gad_BehaviorCancel 	= 244
			#constant C_Gad_BehaviorObj 	= 245
			#constant C_Gad_BehaviorObj1 	= 246
			#constant C_Gad_BehaviorObj2 	= 247
			#constant C_Gad_BehaviorObj3 	= 248
			
			// Gadget for windows 250 to 300  //  start at 250
			#Constant c_GadForWindow = 250
			
			FoldEnd

					
			FoldStart //** gadgets for Shader window
			
			
		
		
			FoldEnd
			// always 300
			#constant C_Gad_VeryLastGadget      = 300


	
		
		FoldEnd










	
	
	PanelH = 1200
	PaneLW = 200

	//*************** add some gadgets  to test

	FoldStart // Toolbar
	
	
	
	FoldStart // Images


	#Constant C_Icon_New 	= 0
	#Constant C_Icon_Open 	= 1
	#Constant C_Icon_Save 	= 2
	#Constant C_Icon_Sub 	= 3
	#Constant C_Icon_Add	= 4
	#Constant C_Icon_Paint 	= 5
	#Constant C_Icon_Prop 	= 6
	#Constant C_Icon_Shader = 7
	#Constant C_Icon_Del 	= 8
	#Constant C_Icon_Light 	= 9
	#Constant C_Icon_Orient = 10
	#Constant C_Icon_Snap 	= 11
	#Constant C_Icon_Physic = 12
	#Constant C_Icon_Lock 	= 13
	#Constant C_Icon_Eye 	= 14
	

	Dim Icon[14] as integer
	Icon[C_Icon_New] 	= loadimage("ui\themes\new.png")
	Icon[C_Icon_Open] 	= loadimage("ui\themes\open.png")
	Icon[C_Icon_Save]	= loadimage("ui\themes\save.png")
	Icon[C_Icon_Sub] 	= loadimage("ui\themes\sub.png")
	Icon[C_Icon_Add] 	= loadimage("ui\themes\add.png")
	Icon[C_Icon_Paint] 	= loadimage("ui\themes\create.png")
	Icon[C_Icon_Prop] 	= loadimage("ui\themes\prop.png")
	Icon[C_Icon_Shader] = loadimage("ui\themes\shader.png")
	Icon[C_Icon_Del] 	= loadimage("ui\themes\del.png")
	Icon[C_Icon_Light] 	= loadimage("ui\themes\light.png")
	Icon[C_Icon_Orient] = loadimage("ui\themes\orientation.png")
	Icon[C_Icon_Snap] 	= loadimage("ui\themes\snap.png")
	Icon[C_Icon_Lock] 	= loadimage("ui\themes\lock.png")
	Icon[C_Icon_Eye] 	= loadimage("ui\themes\view.png")
	
	Foldend
	
	
	yy = 31 : x=0 : w2 = 25 : w3 = 120 :  w4 = 60
	htb2 = 30 : a = 2 : b= 3
	
	Global ToolBarH = 30
	Global ToolBarY 
	ToolBarY = yy
	
	LAG_ContainerGadget(C_Gad_TB, -100, yy, G_width +200, ToolBarH,0, "") 
	
	
	FoldStart  // the tools buttons, checkbox,combo,spin... for toolbar
	yy = -2 // 33
	x = 100
	u=24
	
	// files
	LAG_ButtonImageGadget(C_GAD_TBNEW,5+x,yy,u,u,icon[0],1) : x=x+27 
	LAg_SetGadgetTooltip(C_GAD_TBNEW,"Erase the current level and create an empty level.")  
	LAG_ButtonImageGadget(C_GAD_TBOPEN,5+x,yy,u,u,icon[1],1) : x=x+27  
	LAg_SetGadgetTooltip(C_GAD_TBOPEN,"Open a level.")  
	LAG_ButtonImageGadget(C_GAD_TBSAVE,5+x,yy,u,u,icon[2],1) : x=x+32 
	LAg_SetGadgetTooltip(C_GAD_TBSAVE,"Save the level.")
	  
	 // asset creation
	LAG_ButtonImageGadget(C_Gad_TBOBJ,5+x,yy,u,u,loadimage("ui\themes\assets.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBOBJ,"Set Asset type to object (geometry, model, water or terrain), to add an object in the level.")  
	LAG_ButtonImageGadget(C_Gad_TBLIGHT,5+x,yy,u,u,icon[C_Icon_Light],1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBLIGHT,"Set Asset type to light (to add a light in the level)")  
	LAG_ButtonImageGadget(C_Gad_TBCAM,5+x,yy,u,u,loadimage("ui\themes\camera.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBCAM,"Set Asset type to camera (to add a camera in the level)")  
	LAG_ButtonImageGadget(C_Gad_TBFX,5+x,yy,u,u,loadimage("ui\themes\fx.png"),1) : x=x+32 
	LAg_SetGadgetTooltip(C_Gad_TBFX,"Set Asset type to particles or FX (to add particles in the level)")  

	// playgame
	LAG_ButtonImageGadget(C_Gad_TBPLAY,5+x,yy,u,u,loadimage("ui\themes\play.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBPLAY,"Play the level") 
	
	// actions  
	LAG_ButtonImageGadget(C_Gad_TBADD,5+x,yy,u,u,icon[5],1) : x=x+27 
	LAg_SetGadgetTooltip(C_Gad_TBADD,"Create an object/Light when you clic in the 3D view")  
	LAG_ButtonImageGadget(C_Gad_TBSELECT,5+x,yy,u,u,loadimage("ui\themes\select.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBSELECT,"Select the object in the 3D view.")  

	LAG_ButtonImageGadget(C_Gad_TBMOVE,5+x,yy,u,u,loadimage("ui\themes\move.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBMOVE,"Move the selected object (G)")  
	iRotate = loadimage("ui\themes\rotate.png")
	LAG_ButtonImageGadget(C_Gad_TBROT,5+x,yy,u,u,iRotate,1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBROT,"Rotate the selected object (R)")  

	LAG_ButtonImageGadget(C_Gad_TBSCALE,5+x,yy,u,u,loadimage("ui\themes\scale.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBSCALE,"Scale the selected object (S)")  

	LAG_ButtonImageGadget(C_Gad_TBCLONE,5+x,yy,u,u,loadimage("ui\themes\clone.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBCLONE,"Clone the selected object (Ctrl+D)")  
	LAG_ButtonImageGadget(C_Gad_TBDEL,5+x,yy,u,u,icon[8],1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBDEL,"Delete the selected object (Del)")  
	
	// View pan, rot, zoom
	x=x+15
	LAG_ButtonImageGadget(C_Gad_TBViewPan,5+x,yy,u,u,loadimage("ui\themes\pan.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBViewPan,"Move the view (or Ctrl+leftmouse)")  
	LAG_ButtonImageGadget(C_Gad_TBViewRot,5+x,yy,u,u,iRotate,1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBViewRot,"Rotate the view (or Alt+leftmouse or middlemouse)")  
	LAG_ButtonImageGadget(C_Gad_TBViewZoom,5+x,yy,u,u,loadimage("ui\themes\zoom.png"),1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_TBViewZoom,"Zoom the view (or wheel mouse)")  


	// other gadgets
	x=x+15
	LAG_ButtonGadget(C_Gad_Orientation,x,yy,w4,u,"Global",0) : x=x+w4+b
	LAg_SetGadgetTooltip(C_Gad_Orientation,"Transformation orientation.")  
	LAG_ButtonGadget(C_Gad_PivotCenter,x,yy,w4,u,"Origin",0) : x=x+w4+b 
	LAg_SetGadgetTooltip(C_Gad_PivotCenter,"Set The pivot center for rotation and scale.")  
	LAG_ButtonImageGadget(C_Gad_UsePhysics,x,yy,u,u,icon[C_Icon_Snap],1) : x=x+27 
	LAg_SetGadgetTooltip(C_Gad_UsePhysics,"Enable/disable the physics for object.")  
	LAG_setGadgetState(C_Gad_UsePhysics, options.PhysicOn)
	
	
	LAG_ButtonGadget(C_Gad_GameMode,x,yy,w4,u,"Platform",0) : x=x+w4+b
	LAg_SetGadgetTooltip(C_Gad_GameMode,"Change the view for the game (plateform/isometric/3rd person/RTS/FPS...). For the moment, just a few modes works.")  

	
	
	Foldend

	LAG_CloseGadgetList() 
	
	Foldend

	
	FoldStart // not used : toolbar 2 : orientation, pivotcenter, snap, layer
	YY = yy+30 
	
	
	//LAG_ContainerGadget(C_Gad_TB2,PaneLW+a,yy,G_width -2*PaneLW-a*2,htb2,0) // not finished !!
	x = 5
	yy = -2
	

	//LAG_CloseGadgetList()
	
	Foldend


	yy = 82 // yy = 80 // YY = yy+22 
	u1 = u : u = 40 
	w1 = 15  :  w = 15 : w2 = 33 
	h2 = 14 : h3 = 20 : h4 =17
	h1 = 40
	u2 = (u-h1)/2
	a = 4 : b= 3
	waa = 190


	Global PanelY 
	PanelY = yy

	FoldStart // panel Left

	LAG_PanelGadget(C_Gad_PanelL,0,yy,PaneLW,PanelH,0)

	Foldstart // Create
	LAG_AddGadgetItem(C_Gad_PanelL,0,"Create",0)

	// the gadgetlist is opened, the LAG_CurrGadgetId = the panelId (1)
	// We add the gadget on the panel, so their position is relative to the panel
	// for gadget id, you can use number (1,2,3...) or #constant

	yy = 0
	

	//*** Asset selection
	x = 0
	LAG_FrameGadget(C_Gad_TxtAsset,x,yy,waa,h3*2+h1,"Asset", "0|50|") : yy = yy+h3+a : x=x+w3 
	x = 5
	LAG_ButtonGadget(C_Gad_BankPrevM,x,yy+u2,w1,h1,"<",0)
	LAG_ImageGadget(C_Gad_PreviewModel,	x+a+w1,			yy,u,u,0,"1|") 
	LAG_ButtonGadget(C_Gad_BankNextM,  	x+a*2+w1+u,		yy+u2,w1,h1,">",0)  //: yy=yy+h1+a
	LAG_ButtonGadget(C_Gad_BankMeshSet,	x+a*3+w1*2+u,	yy+u2,h1,h1,"Set",0)  :  yy=yy+h1+a+10
	LAg_SetGadgetTooltip(C_Gad_BankMeshSet,"Change the mesh for selected object (only work with primitive).")
	yy = yy + 10
	
	
	//*** Asset Creations
	x = 0
	LAG_FrameGadget(C_Gad_TxtCreate,x,yy,waa,h3*2+h1,"Default parameter", "0|50|") 
	
	x = PaneLW - 45
	LAG_ButtonImageGadget(C_Gad_AssetProp,x,yy+2,u1,u1,Icon[C_Icon_Prop],0) : yy = yy+h3+a
	LAg_SetGadgetTooltip(C_Gad_AssetProp,"Set default parameters (at creation).")
	x = 5 	
	LAG_StringGadget(C_Gad_AssetSize,x,yy,50,h3,"Size ", str(Options.Asset.Size,0)) : yy=yy+h3+b
	LAg_SetGadgetTooltip(C_Gad_AssetSize,"General size for asset (creation only).")
	x = 5 
	LAG_StringGadget(C_Gad_AssetW,x,yy,30,h3,"W ", str(Options.Asset.W)) : x= x + 60
	LAg_SetGadgetTooltip(C_Gad_AssetW,"Width for asset (creation only).")  
	LAG_StringGadget(C_Gad_AssetH,x,yy,30,h3,"H ", str(Options.Asset.H)) : x= x + 60
	LAg_SetGadgetTooltip(C_Gad_AssetH,"Height for asset (creation only).")  
	LAG_StringGadget(C_Gad_AssetL,x,yy,30,h3,"L ", str(Options.Asset.L)) : x= x + 60
	LAg_SetGadgetTooltip(C_Gad_AssetL,"Lenght for asset (creation only).")  
	yy=yy+h3+b+10 
	

	//*** Model Bank
	yy=yy+10 //h3+b+10
	x = 0
	LAG_FrameGadget(C_Gad_TxtBank,x,yy,waa,h3*2+h1,"Model Bank", "0|50|") : yy = yy+h3+a 

	x = 5 : u1=20
	LAG_ButtonImageGadget(C_Gad_BankNew,x,yy,u1,u1,Icon[C_Icon_New],0) : x=x+u1+b
	LAg_SetGadgetTooltip(C_Gad_BankNew,"Reset the bank : Erase all the models from the bank.")  
	LAG_ButtonImageGadget(C_Gad_BankOpen,x,yy,u1,u1,Icon[C_Icon_Open],0) : x=x+u1+b 
	LAg_SetGadgetTooltip(C_Gad_BankOpen,"Open a bank preset (presets of models).")  
	LAG_ButtonImageGadget(C_Gad_Banksave,x,yy,u1,u1,Icon[C_Icon_Save],0) : x=x+u1+b 
	LAg_SetGadgetTooltip(C_Gad_BankSave,"Save as a bank preset (save all the models 3D presents in that bank).")  
	x = x + 10
	LAG_ButtonImageGadget(C_Gad_BankImport,x,yy,u1,u1,Icon[C_Icon_Add],0) : x=x+u1+b  
	LAg_SetGadgetTooltip(C_Gad_BankImport,"Import a model in the bank (format : .fpe or any AGK 3D model format.")  
	LAG_ButtonImageGadget(C_Gad_BankSub,x,yy,u1,u1,Icon[C_Icon_sub],0) : x=x+u1+b  
	LAg_SetGadgetTooltip(C_Gad_BankSub,"Remove the model from the bank. Be carefull, it erase all the object using this model.")  
	LAG_ButtonImageGadget(C_Gad_BankExport,x,yy,u1,u1,Icon[C_Icon_Save],0) : x=x+u1+b  
	LAg_SetGadgetTooltip(C_Gad_BankExport,"Export the model from the bank (as .fpe)")  
	
	
	yy = yy+u1+10
	
	
	
/*
	LAG_ButtonImageGadget(C_Gad_BankModel1,x,yy,w1+w3+2,u,0,0)   : yy=yy+u+5
	LAG_ButtonImageGadget(C_Gad_BankModel2,x,yy,w1+w3+2,u,0,0)   : yy=yy+u+5 
	LAG_ButtonImageGadget(C_Gad_BankModel3,x,yy,w1+w3+2,u,0,0)   : yy=yy+u+5 
*/
	//yy = yy+10
	//LAG_TextGadget(C_Gad_BankInfo,x,yy,w3,w2,"Information", "-1|255|") 
	//LAG_ButtonGadget(C_Gad_BankAdd,x+w3+2,yy,w2,w2,"+",0)  : yy=yy+w2+5

	// LAG_ButtonImageGadget(,x,yy,w1+w3+2,w1+w3+2,0,0)   : yy=yy+u+5
	
	LAG_ListIconGadget(C_Gad_BankList,5,yy,180,300)
	


	Foldend

	Foldstart // images
	u = 64 

	LAG_AddGadgetItem(C_Gad_PanelL,1,"Images",0)
	yy = 0 
	
	
	//*** Folder image
	x = 0
	LAG_FrameGadget(C_Gad_TxtFolderimg,x,yy,waa,55,"Folder Image", "0|50") : yy = yy+h3+a 
	x = 5

	LAG_ButtonGadget(C_Gad_BankImgPrev,x,yy+u2,h3,h3,"<",0) : x = x + h3  
	LAG_StringGadget(C_Gad_ImgFolder,x-2,yy,160-w1*2,h3,"","default") : x = x+160-h3-4 
	LAg_SetGadgetTooltip(C_Gad_ImgFolder,"The name of the current folder for image. Use < and > to change the folder of images.")
	LAG_ButtonGadget(C_Gad_BankImgNext,x,yy+u2,h3,h3,">",0)  : yy=yy+h3+a+5
	
	
	//*** image preview & butons
	x = 0 : yy =yy+10
	LAG_FrameGadget(C_Gad_TxtPreviewimg,x,yy,waa,275,"Image Selection", "0|50") : yy = yy+h3+a 
	x = 5
	
	LAG_ImageGadget(C_Gad_BankImg,		x,yy,u,u,0,"1|1|") : x = x+a+u
	
	// btn for image
	xa = x
	yy = yy+u2
	LAG_ButtonGadget(C_Gad_SetImg,		x,yy,h1,20,"Set",0)  	: x = x+h1+a
	LAG_ButtonGadget(C_Gad_ImgReload,	x,yy,h1,20,"Reload",0) 	
	
	yy= yy+20+2
	x = xa
	LAG_ButtonImageGadget(C_Gad_ImgAdd, x,yy,u1,u1,Icon[C_Icon_Add],0) : x=x+u1+b 
	LAg_SetGadgetTooltip(C_Gad_ImgAdd,"Add a new image to list of image used")
	LAG_ButtonImageGadget(C_Gad_ImgDel, x,yy,u1,u1,Icon[C_Icon_Sub],0) : x=x+u1+b 
	LAg_SetGadgetTooltip(C_Gad_ImgDel,"Remove the image to list of image used. Be carefull, all object using this image will be blank.") 
	LAG_ButtonGadget(C_Gad_ImgUsed,		x,yy,h1,20,"Bank",0) 	: x = x+a+h1
	LAg_SetGadgetTooltip(C_Gad_ImgUsed,"Change the list of image (bank( from folders) / used in the level).")  

	yy=yy+h1+10
	
	
	// Image list
	x = 0 // : yy =yy+10
	LAG_StringGadget(C_Gad_ImgName, x, yy, 180, h3, "", "")  : yy=yy+h3+a
	x = 5
	LAG_ListIconGadget(C_Gad_ImgList, x, yy, 180, 150)
	yy=yy+160
	
	 
	//*** Object textures stage, uv, shader
	x = 0 : yy =yy+5
	hls = 60
	LAG_FrameGadget(C_Gad_TxtObjimg, x, yy, waa, h3*5+h1+hls+10, "Object Textures", "0|50") : yy = yy+h3+a 
	x = 5


	// object stage
	
	LAG_ListIconGadget(C_Gad_ListStage, x, yy, 180, hls)
	yy = yy + hls+5
	
	LAG_StringGadget(C_Gad_SetStage,x,yy,50,h3,"Stage","") 
	// LAG_StringGadget(C_Gad_SetStageName,x+95,yy,50,h3,"Name ","") 	: yy=yy+h3+b+10
	
	//yy=yy+h3+b+10
	LAG_ButtonGadget(C_Gad_ImgDelete,x+95,yy,60,h3,"Delete",0): yy=yy+h3+b+10 
	
	LAG_CheckBoxGadget(C_Gad_ImgNormal,x,yy,60,h2,"Normal") 
	LAg_SetGadgetTooltip(C_Gad_ImgNormal,"Use normalmap image for object (stage2).")  
	LAG_CheckBoxGadget(C_Gad_ImgLightmap,x+95,yy,80,h2,"lightmap") 
	LAg_SetGadgetTooltip(C_Gad_ImgLightmap,"Use lightmap image for object (stage1).")  
	yy=yy+h2+b+10 
	
	LAG_StringGadget(C_Gad_uvx,x,yy,60,h3,"UvX ","") 
	LAG_StringGadget(C_Gad_uvy,x+95,yy,60,h3,"UvY ","") : yy=yy+h3+b
	LAG_StringGadget(C_Gad_uvw,x,yy,60,h3,"UvW ","") 
	LAG_StringGadget(C_Gad_uvh,x+95,yy,60,h3,"UvH ","") : yy=yy+h3+b+10

	LAG_StringGadget(C_Gad_SetShader,x,yy,45,h3,"Shader","") : x=x+95 // yy=yy+h3+b+10
	LAG_ButtonGadget(C_Gad_ShaderList,x,yy,90,h3,"List ",0) : yy=yy+h3+b+10
	x = 5
	
	// LAG_ButtonGadget(C_Gad_ShaderReload,x,yy,90,h3,"Reload ",0) : yy=yy+h3+b+10
	// LAg_SetGadgetTooltip(C_Gad_ShaderReload,"Reload all the shaders.")  

	

	Foldend

	FoldStart // properties

	LAG_AddGadgetItem(C_Gad_PanelL,2,"Properties",0)

	yy = 0 : x = 5
	
	LAG_ButtonImageGadget(C_Gad_WinObjProp,x,yy,u1,u1,icon[C_Icon_Orient],0) : x=x+u1+b
	LAg_SetGadgetTooltip(C_Gad_WinObjProp,"Change the properties of the object.")
	LAG_ButtonImageGadget(C_Gad_WinObjShader,x,yy,u1,u1,icon[C_Icon_Shader],0) : x=x+u1+b
	LAg_SetGadgetTooltip(C_Gad_WinObjShader, "Open the Shader Editor to modify the shader of the object (not finished).")
	LAG_ButtonImageGadget(C_Gad_WinObjBehavior,x,yy,u1,u1,icon[C_Icon_Prop],0) : x=x+u1+b //  : x=5
	LAg_SetGadgetTooltip(C_Gad_WinObjBehavior, "Add behavior to the selected object (not finished).")
	LAG_ButtonImageGadget(C_Gad_WinObjPhysic,x,yy,u1,u1,icon[C_Icon_Orient],0) : x=x+u1+b
	LAg_SetGadgetTooltip(C_Gad_WinObjPhysic,"Set the physic attributes to object.")
	LAG_ButtonImageGadget(C_Gad_WinObjAnim,x,yy,u1,u1,icon[C_Icon_Orient],0) : x=x+u1+b
	LAg_SetGadgetTooltip(C_Gad_WinObjAnim,"Set the animation attributes.")
		
		
	x=x+10		
	LAG_ButtonImageGadget(C_GAD_LoadPartsys,x,yy,u1,u1,Icon[1],0) : x=x+25
	LAg_SetGadgetTooltip(C_GAD_LoadPartsys,"Load a preset for particle object.")
	LAG_ButtonImageGadget(C_GAD_SavePartsys,x,yy,u1,u1,Icon[2],0) 
	LAg_SetGadgetTooltip(C_GAD_SavePartsys,"Save the particle system preset.")

	
	yy=yy+h3+b+10 : x=5
	LAG_StringGadget(C_Gad_NameObj,x,yy,95,h3,"Name ","") : x = x +135

	// LAG_CheckBoxGadget(C_Gad_Lock,x,yy,60,h2,"Locked")
	LAG_ButtonImageGadget(C_Gad_lock,x,yy,u1,u1,icon[C_Icon_Lock],1)
	LAg_SetGadgetTooltip(C_Gad_Lock, "Lock/Unlock the object in the editor.")
	LAG_ButtonImageGadget(C_Gad_Hide,x+u1+5,yy,u1,u1,icon[C_Icon_Eye],1)
	LAg_SetGadgetTooltip(C_Gad_Hide, "Show/hide the object in the editor.")
	
	// x =x +u1*2+10+b
	
	x = 5 : yy=yy+h3+b
	LAG_CheckBoxGadget(C_Gad_Objlight,x,yy,70,h2,"Light") 	
	LAg_SetGadgetTooltip(C_Gad_Objlight, "Set the lightmode for object.")
	x = x + 70
	LAG_CheckBoxGadget(C_Gad_ObjFog,x,yy,50,h2,"Fog") 	
	LAg_SetGadgetTooltip(C_Gad_ObjFog, "Set the fog mode for this object.")
	x = x + 50
	LAG_CheckBoxGadget(C_Gad_Objvisible,x,yy,60,h2,"Visible") 
	LAg_SetGadgetTooltip(C_Gad_Objvisible, "Is the object visible in game ?")

	// shadow
	x = 5 : yy=yy+h2+10	
	LAG_CheckBoxGadget(C_Gad_Shado,x,yy,55,h2,"Shadow") 
	LAg_SetGadgetTooltip(C_Gad_Shado, "Use the shadow in lightmapper (calculated on texture, not real time).")
	LAG_CheckBoxGadget(C_Gad_ShadoCast,x+70,yy,40,h2,"Cast ") 	// : yy=yy+h2+10
	LAG_CheckBoxGadget(C_Gad_ShadoREC,x+120,yy,70,h2,"Receive ") 	: yy=yy+h2+10
	LAg_SetGadgetTooltip(C_Gad_Shadocast, "Cast shadow in realtime.")
	LAg_SetGadgetTooltip(C_Gad_ShadoRec, "Receive shadow in realtime.")

	//LAG_ButtonGadget(6,5,yy,80,30,"Toggle",1) 		: yy=yy+40
	//LAG_SetGadgetFont(6,-1,12,rgb(100,0,0),255)

	// Position
	LAG_StringGadget(C_Gad_X,x,yy,100,h3,"X   ","")
	LAG_ButtonImageGadget(C_Gad_lock_X,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b //: x=x+u1+b //  : x=5

	//LAG_CheckBoxGadget(C_Gad_lock_X,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	
	LAG_StringGadget(C_Gad_Y,x,yy,100,h3,"Y   ","") 
	//LAG_CheckBoxGadget(C_Gad_lock_Y,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	LAG_ButtonImageGadget(C_Gad_lock_Y,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b 

	LAG_StringGadget(C_Gad_Z,x,yy,100,h3,"Z   ","")
	//LAG_CheckBoxGadget(C_Gad_lock_Z,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b+10
	LAG_ButtonImageGadget(C_Gad_lock_Z,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b +5

	// size
	LAG_StringGadget(C_Gad_Size,x,yy,100,h3,"Siz ","") 
	// LAG_CheckBoxGadget(C_Gad_lock_S,x+140,yy+3,45,h2,"Lock") 
	yy=yy+h3+b

	LAG_StringGadget(C_Gad_SX,x,yy,100,h3,"SX  ","")
	LAG_ButtonImageGadget(C_Gad_lock_SX,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b 
	//LAG_CheckBoxGadget(C_Gad_lock_SX,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	LAG_StringGadget(C_Gad_SY,x,yy,100,h3,"SY  ","") 
	//LAG_CheckBoxGadget(C_Gad_lock_SY,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	LAG_ButtonImageGadget(C_Gad_lock_SY,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b 
	LAG_StringGadget(C_Gad_SZ,x,yy,100,h3,"SZ  ","") 
	//LAG_CheckBoxGadget(C_Gad_lock_SZ,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b+10
	LAG_ButtonImageGadget(C_Gad_lock_SZ,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b+5 

	// rotation
	LAG_StringGadget(C_Gad_RX,x,yy,100,h3,"RX  ","")
	//LAG_CheckBoxGadget(C_Gad_lock_RX,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	LAG_ButtonImageGadget(C_Gad_lock_RX,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b 
	
	LAG_StringGadget(C_Gad_RY,x,yy,100,h3,"RY  ","") 	
	//LAG_CheckBoxGadget(C_Gad_lock_RY,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b
	LAG_ButtonImageGadget(C_Gad_lock_RY,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b 
	
	LAG_StringGadget(C_Gad_RZ,x,yy,100,h3,		"RZ  ","")
	LAG_ButtonImageGadget(C_Gad_lock_RZ,x+140,yy,u1,u1,icon[C_Icon_Lock],1) : yy=yy+h3+b +10	
	//LAG_CheckBoxGadget(C_Gad_lock_RZ,x+140,yy+3,45,h2,"Lock") : yy=yy+h3+b+10


	// Color 
	LAG_StringGadget(C_Gad_Alpha,x,yy,30,h3,	"A   ","") 
	LAg_SetGadgetTooltip(C_Gad_Alpha, "Set The alpha for the object.")
	LAG_ButtonGadget(C_Gad_Tra,x+62,yy,50,h3,"Opaque",0) 
	LAg_SetGadgetTooltip(C_Gad_Tra, "Set The transparency for the object.")
	LAG_ButtonGadget(C_Gad_BM,x+62+53,yy,65,h3,"Normal", 0) : yy=yy+h3+b+2
	LAg_SetGadgetTooltip(C_Gad_BM, "Set The Blendmode for the object.")

	
	LAG_TrackbarGadget(C_Gad_R,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+20
	LAG_TrackbarGadget(C_Gad_G,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+20
	LAG_TrackbarGadget(C_Gad_B,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+20

	//animation
	x=5 : yy=yy+10
	typ$ = GetStringToken(GetObjTypFromFile(""), ",", 1)
	wx = 184/2-5
	LAG_ButtonGadget(C_Gad_Type,x,yy,wx,h3, typ$,0) : x = x +wx+5 
	LAg_SetGadgetTooltip(C_Gad_Type,"Set the Type for object.")
	
	subtyp$ = GetObjTypFromFile(typ$)
	LAG_ButtonGadget(C_Gad_SubType,x,yy,wx,h3,GetStringToken(subtyp$, ",", 1),0) 
	LAg_SetGadgetTooltip(C_Gad_SubType,"Set the SubType for object.")
	yy=yy+h3+b
	
	x = 5
	LAG_StringGadget(C_Gad_Param1,x,yy,55,h3,"Param 1","0") : x = x + 112
	LAg_SetGadgetTooltip(C_Gad_Param1,"Set Type/Sub-Type parameter 1")
	LAG_StringGadget(C_Gad_Param2,x,yy,55,h3,"2","0")
	LAg_SetGadgetTooltip(C_Gad_Param2,"Set Type/Sub-Type parameter 2")

	
	yy=yy+h3+b
	
	
	// LAG_StringGadget(C_Gad_Physic,x,yy,100,h3,"Physic","0") : yy=yy+h3+b
	
	//LAG_ButtonGadget(C_Gad_Physic,x,yy,80,h3,"No Physic",0)	: yy=yy+h3+b
	// LAG_ButtonGadget(C_Gad_Shader,x,yy,90,h3,"List ",0) : yy=yy+h3+b+10
	//

	
	//animation
	x=5 : yy=yy+10
	
	LAG_CheckBoxGadget(C_Gad_PlayAnim,x,yy,60,h2,"Play") 
	LAg_SetGadgetTooltip(C_Gad_PlayAnim,"Play object animation")
	LAG_StringGadget(C_Gad_AnimSpeed,x+80,yy,50,h3,"Speed ","30") : yy=yy+h3+b
	LAg_SetGadgetTooltip(C_Gad_AnimSpeed,"Set animation speed")
	LAG_StringGadget(C_Gad_AnimStart,x,yy,50,h3,"Start","0") 
	LAg_SetGadgetTooltip(C_Gad_AnimStart,"Set animation start ")
	LAG_StringGadget(C_Gad_AnimEnd,x+95,yy,50,h3,"End ","100") : yy=yy+h3+b
	LAg_SetGadgetTooltip(C_Gad_AnimEnd,"Set animation end")
	
	

	LAG_CloseGadgetList()
	Foldend

	Foldend


	Foldstart // panel right
	YY = 80
	// note that panel in panel in another panel is bugged
	LAG_PanelGadget(C_Gad_PanelR,G_width-PaneLW,yy,PaneLW+50,PanelH,1)

	FoldStart // SKY
	YY = 0 : u=16
	spr = LAG_AddGadgetItem(C_Gad_PanelR,0,"Sky",0) // spr = temporaire, voir un peu plus bas, bug avec panel

	
	
	LAG_ButtonGadget(C_GAD_AtmLoad,x,yy,w4,h3,"Load",0) : x=x+w4 +5
	LAg_SetGadgetTooltip(C_GAD_AtmLoad,"Load a preset for full atmosphere changes (skybox, sun, fog, ambient..).")
	LAG_ButtonGadget(C_GAD_AtmSave,x,yy,w4,h3,"Save",0) : yy=yy+h3+a : x=5
	LAg_SetGadgetTooltip(C_GAD_AtmSave,"Save the atmosphere parameters (skybox, sun, fog, ambient..).")


	// Skybox
	LAG_CheckBoxGadget(C_Gad_SkyOk,x,yy,w3,h2,"Sky") : x=x+w3  
	LAG_ButtonImageGadget(C_Gad_SkyLoad,5+x,yy,u,u,Icon[C_Icon_Open],0) : x=x+27 
	LAG_ButtonImageGadget(C_Gad_Skysave,5+x,yy,u,u,Icon[C_Icon_Save],0) : x=x+27 
	yy=yy+h2+10 : x=5

	LAG_TrackbarGadget(C_Gad_SkyR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SkyG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SkyB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4+5

	LAG_TextGadget(C_Gad_SkyHTxt,x,yy,w3,w2,"Horizon Color", "-1|") : yy=yy+w2+5
	LAG_TrackbarGadget(C_Gad_SkyHR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SkyHG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SkyHB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4+5


	// Sun
	LAG_CheckBoxGadget(C_Gad_SunOk,x,yy,w3,h2,"Sun") : x=x+50  
	LAG_StringGadget(C_Gad_SunInt,x,yy-4,h1,h3, "Int","1") :x=x+h1+5
	LAg_SetGadgetTooltip(C_Gad_SunInt,"Set the intensity of the sun.")

	x=5 : : x=x+w3 
	
	LAG_ButtonImageGadget(C_Gad_SunLoad,5+x,yy,u,u,Icon[1],0) : x=x+27 
	LAG_ButtonImageGadget(C_Gad_Sunsave,5+x,yy,u,u,Icon[2],0) : x=x+27 
	yy=yy+h2+10 : x=5

	LAG_TrackbarGadget(C_Gad_SunR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SunG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_SunB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4+5

	LAG_StringGadget(C_Gad_SunX,x,yy,h1,h3, "X","") 
	LAG_StringGadget(C_Gad_SunY,x+h1+15,yy,h1,h3, "Y","") 
	LAG_StringGadget(C_Gad_SunZ,x+(h1+15)*2,yy,h1,h3, "Z","") : yy=yy+h4+15

	// fog
	LAG_CheckBoxGadget(C_Gad_FogOk,x,yy,w3,h2,"Fog ") : x=x+w3 
	LAG_ButtonImageGadget(C_Gad_FogLoad,5+x,yy,u,u,Icon[1],0) : x=x+27 
	LAG_ButtonImageGadget(C_Gad_FogSave,5+x,yy,u,u,Icon[2],0) : x=x+27 
	yy=yy+h2+10 : x=5

	LAG_TrackbarGadget(C_Gad_FogR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_FogG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_FogB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4+5
	LAG_StringGadget(C_Gad_FogMin,x,yy,60,h3,"Min","") 
	LAG_StringGadget(C_Gad_FogMax,x+95,yy,60,h3,"Max ","") : yy=yy+h3+15

	// ambient color
	LAG_CheckBoxGadget(C_Gad_AmbOk,x,yy+4,w3,h2,"Ambient") : x=x+75   
	LAG_StringGadget(C_Gad_AmbInt,x,yy,h1,h3, "Int","1") //:x=x+h1+5
	LAg_SetGadgetTooltip(C_Gad_AmbInt,"Change the factor of the ambient color.")

	x = 5 
	yy=yy+h3+5
	LAG_TrackbarGadget(C_Gad_AmbR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_AmbG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4
	LAG_TrackbarGadget(C_Gad_AmbB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4


	// shadow 
	x=5 
	yy=yy+w2+5
	LAG_CheckBoxGadget(C_Gad_SHADO_RT,x,yy+4,60,h2,"Shadow") : x=x+h1+50 
	LAG_StringGadget(C_Gad_SHADO_Bias,x,yy,h1+7,h3, "Bias ","0") : yy=yy+h3+b //:x=x+h1+5
	x = 5
	LAG_StringGadget(C_Gad_SHADO_SizeW,x,yy,h1,h3, "Width","256") : x=x+h1+50
	LAG_StringGadget(C_Gad_SHADO_SizeH,x,yy,h1,h3, "Height","256")  : yy=yy+h3+b //: x=x+h1+5
	x = 5
	LAG_StringGadget(C_Gad_SHADO_Smooth,x,yy,27,h3, "Smooth ","0") : x=x+h1+50
	LAG_StringGadget(C_Gad_SHADO_Type,x,yy,h1+7,h3, "Type ","0") 




	FoldEnd


	FoldStart // options 
	LAG_AddGadgetItem(C_Gad_PanelR,1,"Options",0)
	YY = 10 : x=5
	LAG_CheckBoxGadget(C_Gad_LockX,x,yy,50,h2,"Lock X") 
	LAG_CheckBoxGadget(C_Gad_LockY,x+60,yy,50,h2,"Lock Y") 	
	LAG_CheckBoxGadget(C_Gad_LockZ,x+120,yy,50,h2,"Lock Z") 	: yy=yy+h2+10


	LAG_CheckBoxGadget(C_Gad_Snap,x,yy,100,h2,"Snap (S)") 	: yy=yy+h2+4
	LAG_SetGadgetState(C_Gad_Snap, Options.Snap) 
	// LAG_CheckBoxGadget(4,5,yy,100,20,"Grid (G)")  	: yy=yy+40
	LAG_StringGadget(C_Gad_SnapX,x,yy,80,h3,"SnapX ",Str(Options.SnapX)) : yy=yy+h3+b
	LAG_StringGadget(C_Gad_SnapY,x,yy,80,h3,"SnapY ",Str(Options.SnapY)) : yy=yy+h3+b
	LAG_StringGadget(C_Gad_SnapZ,x,yy,80,h3,"SnapZ ",Str(Options.SnapZ)) : yy=yy+h3+b+5

	//	Camera
	//LAG_TextGadget(C_Gad_ca,x,yy,36,h3,"Cam Fov ",str(Options.CameraFov)) 
	LAG_StringGadget(C_Gad_CamFov,x,yy,36,h3,"Cam Fov ",str(Options.Camera.Fov)) 
	LAG_StringGadget(C_Gad_CamOrtW,x+100,yy,35,h3,"Ortho ",str(Options.Camera.Ortho,0)) : yy=yy+h3+b
	LAG_StringGadget(C_Gad_CamNear,x,yy,58,h3,"Near ",str(Options.Camera.Near,3)) 
	LAG_StringGadget(C_Gad_CamFar,x+100,yy,50,h3,"Far ",str(Options.Camera.Far,0)) : yy=yy+h3+b
	
	LAG_StringGadget(C_Gad_CamX,x,yy,w2+2,h3,"X ",str(Options.Camera.X)) 
	LAG_StringGadget(C_Gad_CamY,x+60,yy,w2+2,h3,"Y ",str(Options.Camera.Y)) 
	LAG_StringGadget(C_Gad_CamZ,x+120,yy,w2+2,h3,"Z ",str(Options.Camera.Z)) : yy=yy+h3+b
	LAG_StringGadget(C_Gad_CamRX,x,yy,w2,h3,"RX ",str(Options.Camera.RX)) 
	LAG_StringGadget(C_Gad_CamRY,x+60,yy,w2,h3,"RY ",str(Options.Camera.RY)) 
	LAG_StringGadget(C_Gad_CamRZ,x+120,yy,w2,h3,"RZ ",str(Options.Camera.RZ)) : yy=yy+h3+b


	// panel select
	yy = yy + h3
	LAG_ButtonGadget(C_Gad_BtnSelectTyp,x,yy,w4,h3,"Object",0) //: x=x+w4 +5

	yy = yy + h3+a
	LAG_ListIconGadget(C_Gad_SelectList,x,yy,180,300)

	Foldend

	
	FoldStart // Tools
	
	LAG_AddGadgetItem(C_Gad_PanelR,2,"Tool",0)
	YY = 10 : x = 0

	FoldStart  
	u=24
	
	LAG_ButtonImageGadget(C_Gad_Tool1,5+x,yy,u,u,icon[C_Icon_Light],1) : x=x+27   
	LAg_SetGadgetTooltip(C_Gad_Tool1,"Lightmapper Tool : change properties for lightmap")  
	
	//LAG_ButtonImageGadget(C_Gad_Tool2,5+x,yy,u,u,icon[C_Icon_Prop],1) : x=x+27   
	//LAg_SetGadgetTooltip(C_Gad_Tool2,"Level Properties (some options for the level)")  

	y1 = yy
	yy = y1 + u+ 5
	//LAG_ContainerGadget(C_Gad_ContLightMap, 0, yy, 200, 250, 0, "Lightmap") 
	
		//yy = 30 //-2// 33
		//x = 0// 
		x = 5
		
		LAG_CheckBoxGadget(C_Gad_LM_UseLight,x,yy,50,h2,"Use light") : yy=yy+h4+b  
		LAg_SetGadgetTooltip(C_Gad_LM_UseLight,"Use the light, sun, shadow and ambient light.")  

		
		LAG_TrackbarGadget(C_Gad_LM_SoftShSample,x,yy,100,8,1,100, "Sample "," |0|1") : yy=yy+h4  
		LAg_SetGadgetTooltip(C_Gad_LM_SoftShSample,"Set the sample for the soft shadow. Please note a big sample (>15) take a lot of time to calculate.")  
		
		LAG_TrackbarGadget(C_Gad_LM_ShadoAlpha,x,yy,100,8,0,255, 	"Trans  "," |0|1") : yy=yy+h4  
		LAg_SetGadgetTooltip(C_Gad_LM_ShadoAlpha,"Set the transparency of the shadow.") 
		
		// parameters size, range, height
		LAG_StringGadget(C_Gad_LM_SoftShSize,x,yy,60,h3,"Size","0") : x=x +95
		LAg_SetGadgetTooltip(C_Gad_LM_SoftShSize,"The size of the shadow. Bigger size means bigger shadow.")  
		
		LAG_StringGadget(C_Gad_LM_Height,x,yy,60,h3,"H ","0") : x=x +65
		LAg_SetGadgetTooltip(C_Gad_LM_Height,"Change the height of object shadow. Increase the height = shadow smaller for object.y > 0")  
		x = 0 : yy=yy+h3+5 
		LAG_StringGadget(C_Gad_LM_SizeRange,x,yy,60,h3,"Soft","0") 
		LAg_SetGadgetTooltip(C_Gad_LM_SizeRange,"The softness of the shadow.")  
		
		
		
		// Shado color intensity
		x = 0 : yy=yy+h3+5 
		LAG_TrackbarGadget(C_Gad_LM_ShadoR,x,yy,128,8,0,255, "R  "," |0|1") : yy=yy+h4  
		LAG_TrackbarGadget(C_Gad_LM_ShadoG,x,yy,128,8,0,255, "G  "," |0|1") : yy=yy+h4  
		LAG_TrackbarGadget(C_Gad_LM_ShadoB,x,yy,128,8,0,255, "B  "," |0|1") : yy=yy+h4  
		
		// camera rotation X, Y,Z
		w7 = 45
		LAG_StringGadget(C_Gad_LM_Rx,x,yy,w7,h3,"RX","0") : x=x +w7+25
		LAG_StringGadget(C_Gad_LM_Ry,x,yy,w7,h3,"RY","0") : x=x +w7+25
		LAG_StringGadget(C_Gad_LM_Rz,x,yy,w7,h3,"RZ","0") : x=x +w7+25
		x = 0 : yy=yy+h3+5 
	
	
	//LAG_CloseGadgetList()
	
	
	// for the other tool2 (test)
	//yy = y1 + u+ 5
	//LAG_ContainerGadget(C_Gad_ContLvl, 0, yy, 200, 250, 0, "Misc") 
	
		//yy = 30 //-2 // 33
		//x = 0//x = 5
	
		//LAG_TrackbarGadget(C_Gad_LvlDayNight,x,yy,128,8,0,500, "D/N  "," |0|1") : yy=yy+h4  
		//LAg_SetGadgetTooltip(C_Gad_LvlDayNight,"Set The speed of the day/night cycle. 0 means no Day/night cycle.")  
		
	//LAG_CloseGadgetList()
		
	SetToolContainer(C_Gad_Tool1)
	
	
	foldend
	




	Foldend




	LAG_CloseGadgetList()


	Foldend

	

	// Temporaire : bug dans LAG à trouver avec le 2nd panel : les gadgets ne sont pas cachés sur les onglets suivants ??
	LAG_Event_Type = LAG_C_EVENTTYPEMOUSEPRESSED
	LAG_NumSpId = spr
	LAG_EventGadget()



	//************************ LAG - END OF THE TEST ***************************//
	Foldend


	FoldStart //****** StatusBar
	
	#constant StatusBarMain = 0
	
	LAG_AddStatusBar(0)
	LAG_AddStatusBarField(0,150)
	LAG_AddStatusBarField(0,400)	
	LAG_AddStatusBarField(0,800)	
	
	LAG_StatusBarText(0,0,"Document")
	StatusBarH = LAG_GetStatusBarHeight(0)

	FoldEnd


	// LAG_message("Info","Welcome to AGK 3D editor! This Editor isn't finished, but most of the features should works. I hope you like it and find it usefull :).","") // see LAG_Message.agc and LAG_Menubox.agc

	FoldEnd


	FOldEnd

	Endif

	LAg_SetFontColorUI(Options.ColorFont)

	FOldEnd
	
	
	
	
	// ** The Editor, initialisation

	InitEditor() // editor.agc 
	


	// ** The Document
	InitDoc() // document.agc

	IF use_Lag = 1
		LAG_SetGadgetState(C_Gad_BankImg, ImgList[textureId].img)
		// LAG_SetGadgetAttribute(C_Gad_ImgList, LAg_ListIcon_DisplayMode, LAg_ListIcon_LargeIcon)
	endif
	// LAG_SetGadgetState(C_Gad_BankModel1,0)

	
	
	UpdateSun()
	



Endfunction	
	
	

	
	
	

// *************************************** OLD : not used for the moment !!!!!!!!!!!!!!!!!!!!

Function InitGeneral_Old()

    /*
    Ici, c'est pour initialiser l'application, les paramètres globaux, comme :
    - la taille de l'acran (resolution)
    - l'orientation
    - la version, la date
    - les profils
    etc..
    */

    // d'abord il faut initiliaser les variables et constantes
    // SetVariables()
    SetConstant()


    // Resolution, taille de l'écran
    G_width = 1024
    G_height = 614
    SetVirtualResolution(G_width, G_height)

    SetOrientationAllowed(0, 0, 1, 1)
    //SetResolutionMode(0)

	// setclearcolor(255*0.21,0.41*255,0.67*255)
	SetWindowTitle("AGE 3D")
	SetScissor(0,0,0,0)
	Create3DPhysicsWorld()
	Set3DPhysicsGravity(0,-1,0)

    SetPrintSize(18) // temporaire, pour le debug
    SetViewZoomMode(1)
    
    titre= loadimage("agksplash.png")
    createsprite(1,titre)
    SetSpritePosition(1,g_width/2-GetSpriteWidth(1)/2,g_height/2-GetSpriteHeight(1)/2)
    sync()
    deletesprite(1)
    
	//InitMusic()

	
    // init the properties of the game (gameprop)
    /*
    gameProp.VersionNum = 8
    gameProp.Version$ ="V0.08 (alpha)"
    gameProp.Date$ ="20 Nov 2015"
	*/
	// InitLang()
	//GetLanguage(0) 
	
	/*
    // on crée les profils des joueurs : 4 de base
    Global dim Profil[3] as sProfil

    // puis on les charge
    OuvreProfil()
    While Profil[0].nom$ = ""
        OuvreProfil()
    EndWhile
	*/

    //puis, on initialise les images
    InitImage()


    // puis, le jeu
    //  Initgame()

	
EndFunction


Function InitGame()

    /*
    fonction pour initialiser le jeu, les paramèttres généraux :
    - le nombre de map
    - le nombre max d'ennemi
    - les classe de personnage de base
    - les profils (info) des mobs
    - les infos des objets/equipement
    - les infos des pnj
    - les infos des quêtes
    - les infos des maps
    etc...
    */
    
    
    
    
	/*
    // on on initialise certains paramètres (sons, music, langue...)
    ResetGame()

    gameProp.mapMax = 9*3
    gameProp.NightOk = 0


    //************* INIT
	InitEvent()
	
    // puis, on initialise ce qui est nécessaire
    InitBlock()
    InitMap() // pour initialiser les paramètres de la map et les nombres d'objets présents (on ne charge pas la map ici !)
	*/
	//InitFx()
	/*
	InitAssetText()
		
	InitCompagnon() 
	InitInvoc()
	*/
    //InitPlayer() // ça initialise aussi son inventaire, ses sorts (sort[]), etc...
	
	//InitPNJ()
	
    //InitSpells()

    //InitMob() // pour initialiser les "profil des mobs"
	/*
    InitTower() // pour initialiser les profils des tours (fx) et le tableau des tours
	
	InitAction()
	*/
    /*
    idem pour :      
        - les quetes ?
        - les dialogues
        - etc...
    */

EndFunction

