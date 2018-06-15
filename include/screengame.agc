


#Constant C_GAMEMODE_PLATFORMER = 0
#Constant C_GAMEMODE_ISOMETRIC = 1
#Constant C_GAMEMODE_3RD_PERS = 2
#Constant C_GAMEMODE_RTS = 3
#Constant C_GAMEMODE_FPS = 4
#Constant C_GAMEMODE_FIXED = 5
#Constant C_GAMEMODE_SIDESCROLL = 6



Function LoadingScene()
	
	// créer une image pour le chargement, puis un texte pour afficher l'avancée du chargement
	// InitLevel(1)
	
EndFunction


Function ScreenGame()
		
	
	foldstart // init the game and load some element if needed
	
	
	//***** First, I hide all the LAG interface
	FreeToolTips()
	LAG_HideAll(1) // in LAG_Free.agc
	SetTextString(1,"")
	
	
	// SetWindowPosition(GetDeviceWidth()/2-512,(GetDeviceHeight()-768)/2)
	if Options.Fullscreen = 0
		SetWindowSize(1024,768,Options.FullScreen)	
		SetVirtualResolution(1024,768)
	endif
	
	// Hide editor utilities (center, object selected in Red
	showGrid = Options.ShowGrid
	Options.ShowGrid = 0
	SetObjectVisible(Grid,0)
	SetObjectVisible(CibleEd,0)
	
	// Hide the centers of objects
	For i=0 to Object.length
		SetSpriteVisible(Object[i].spr,0)
		if Object[i].Typ <> C_OBJPARTSYS
			SetObjectColorEmissive(Object[i].Obj,Object[i].R,Object[i].G,Object[i].B)
		endif
	next
	
	// hide lights-Object
	For i=0 to Light.length
		SetObjectVisible(Light[i].Obj,0)
	next
	
	// reset some editor variables
	ObjId = 0 
	TypId = 0 

	
	//***** Then, I load the object, behavior, level, UI... if needed
	LoadingScene()
	
		
		
		
	// ------  pour les tests	
	camx = 0
	camy = 0
	camz = 0	
	d 	= 10
	h2 	= 8
	hl 	= 10
	v as float
	v = 1 // Player.Speed
	sp as float = 0.03
		
	
	// ------ EDITOR  : reset to 0  
	NewX as float
	NewZ as float	
	quit = 0
	// MovePlayer()
	
	
	Foldstart // create the player and camera object
		
		Dc = 5 // speed for camera
		
		// Set The player behavior
		Nplayer = -1		
		For i=0 to object.length
			if Object[i].IsPlayer = 1
				Nplayer = Object[i].Obj
				Player.obj = Object[i].Obj
				PLayerId = i		
			else
				For j=0 to Object[i].Behavior.length
					//if Object[i].Behavior[j].Typ = 9 and  // player keyboard
								
					//else					
						if Object[i].Behavior[j].Typ <=8
							ObjId  = i
							AssetTyp =C_ASSETOBJ
							AddBehavior(Object[i].Behavior[j].Typ,"")
						endif					
					//endif
				next	
			endif			
		next
		/*
		For i=0 to Behavior.length
			if Behavior[i].active =1
				if Behavior[i].Typ = 9 or Behavior[i].Typ = 10
					id = Behavior[i].ObjId[0]
					if id>-1 and id <= object.length
						player = Object[id].obj							
						exit
					endif
				endif
			endif
		next
		*/
		
		
		if Nplayer > -1
			
			// create the object Camera, to fix the camera to this object
			id = PLayerId
			
			ObjCam = CreateObjectBox(10,10,10)
			SetObjectFogMode(ObjCam,0)
			SetObjectColorEmissive(ObjCam,255,0,0)
			sx# = Object[id].Size * Object[id].sx
			sy# = Object[id].Size * Object[id].sy
			sz# = Object[id].Size * Object[id].sz
			s# = Object[id].Size
			CamX = 0 // (GetCameraX(1)-GetObjectX(Player))/sx#
			//CamY = (GetCameraY(1) - GetObjectY(NPlayer))/sy#
			//CamZ = -(GetCameraZ(1) - GetObjectZ(NPlayer))/sz#
			
			//CamY = 5*s# //50
			//CamZ = 10*s# 
			
			CamY = s#*GetCameraY(1)/300 // 310
			CamZ = -s#*GetCameraZ(1)/100 // -480
			//message(str(GetCameraY(1))+"/"+str(GetCameraZ(1)))
			
			
			
			Select Options.GameMode
				
				case C_GAMEMODE_PLATFORMER
					//CamY = 0 // 2*s# //- GetObjectY(NPlayer)
					//CamZ = 0 // 4*s# //- GetObjectZ(NPlayer)
					
				endcase
				
				case C_GAMEMODE_ISOMETRIC
					CamY = 15*s# //- GetObjectY(NPlayer)
					CamZ = 20*s# //- GetObjectZ(NPlayer)
					SetCameraFOV(1,0)
				endcase
			endselect
			
			SetObjectPosition(ObjCam, camX, CamY, CamZ)
			
			
			//SetObjectScale(ObjCam, 1/sx#, 1/sy#, 1/sz#)
			FixObjectToObject(ObjCam, NPlayer)
			//SetObjectVisible(ObjCam,0)
			
			
				
			//CamY = (GetCameraY(1) - GetObjectY(NPlayer))
			//CamZ = (GetCameraZ(1) - GetObjectZ(NPlayer))
			
			newX# = GetCameraAngleX(1)
			newY# = GetCameraAngleY(1)
			newZ# = GetCameraAngleZ(1)
			camY2# = newY#
			
			if Options.GameMode = 0 
				// CamZ = 0
			Endif
		else
			message("To add a player for the test, select the object, then hit ctrl+P to set it as player. Press P to start the level")	
		endif
		
		SetCameraRange(1,1,20000) // ?

	
	Foldend
	
	
	rotationInc = 2
	Speed as float
	speed = 100 //  * object[id].Size  // player.speed
	
	Debug3DPhysicsCharacterController(Nplayer, 1)
	
	foldend
	
	
	
	repeat 
		
		if Options.Debug = 1 or FreeCamera = 1
			//Print(Str(ScreenFPS())+" | "+str(PLayer.x)+"/"+str(player.z))
			Print(Str(ScreenFPS())+"|"+str(GetVerticesProcessed())+" | Phys : "+str(Get3DPhysicsTotalObjects())+" | Poly : "+str(GetPolygonsDrawn()))
		endif
		
		Print(str(joystick_y#)+"/"+str(joystick_x#))
		
		FoldStart // ----- Joystick & keyboard
		
		joystick_y# = GetRawJoystickY(1)
		joystick_x# = GetRawJoystickX(1)
		
		FoldStart // joystick
		
		if Object.length >=0
		
			FoldStart // keyboard , physic, if object.length >-1
			
			if id>-1 and id <= Object.length
			
				If Object[id].physic = 4
					
					Debug3DPhysicsCharacterController(Nplayer,1)
					 
					if GetRawKeyPressed(32) or GetRawJoystickButtonPressed(1,1) // Jump
						jumped=1
						Jump3DPhysicsCharacterController(Nplayer)
						//SetObject3DPhysicslinearVelocity( player, 0, 1, 0,30) 
					endif
					
					Move3DPhysicsCharacterController(NPlayer,0,0)
					if joystick_y#<0 or GetRawKeyState(38)
						Move3DPhysicsCharacterController(NPlayer,1,Speed)
					endif
					if joystick_y#>0 or GetRawKeyState(40)
						Move3DPhysicsCharacterController(NPlayer,2,Speed)
					endif
					if joystick_x#<-0.5 or GetRawKeyState(37)
						//Move3DPhysicsCharacterController(Player,3,u)
						finalRotation = finalRotation - rotationInc
						Rotate3DPhysicsCharacterController( NPlayer, finalRotation )
						
					endif
					if joystick_x#>0.5 or GetRawKeyState(39) 
						//Move3DPhysicsCharacterController(Player,4,u)
						finalRotation = finalRotation + rotationInc
						Rotate3DPhysicsCharacterController( NPlayer, finalRotation )
					endif
					
					If Options.PhysicOn
						Step3DPhysicsWorld()
					endif
					
				endif
			endif
			
			Foldend
		
			foldstart // -----  Keyboard 
			
			
			// camera
			if FreeCamera = 1
						
			else
				
				FoldStart // if we have a player in our level
				
				if Nplayer >-1
					
					u = NPlayer
					
					print("ok player !")
					
					if Object[Id].Physic <> 4
						Move3DPhysicsCharacterController(NPlayer,0,0)
						if ( GetRawKeyState(37) or joystick_x#<-0.5) then RotateObjectLocalY( u, -1 )		
						if ( GetRawKeyState(39) or joystick_x#>0.5) then RotateObjectLocalY( u, 1)			
						if ( GetRawKeyState(38) or joystick_y#<0) then MoveObjectLocalZ( u, -4 )				
						if ( GetRawKeyState(40) or joystick_y#>0)  then MoveObjectLocalZ( u, 4 )
					else
						/*
						if ( GetRawKeyState(37)) then RotateObjectLocalY( u, -1 )		
						if ( GetRawKeyState(39)) then RotateObjectLocalY( u, 1)			
						if ( GetRawKeyState(38)) then Move3DPhysicsCharacterController(NPlayer,1,Speed)			
						if ( GetRawKeyState(40))  then Move3DPhysicsCharacterController(NPlayer,2,Speed)
						*/
					endif
					
					if Options.GameMode = 1 // isometric
						SetCameraPosition(1,GetObjectX(u),GetObjectY(u)+camY,GetObjectZ(u)+CamZ)
						SetCameraLookAt(1,getobjectX(u),getobjectY(u),getobjectZ(u),0)
					
					elseif Options.GameMode = 0 // plateforme
						
						
						print("Move camera "+str(GetObjectWorldX(ObjCam)))
						
						
						//SetCameraPosition(1, GetObjectX(ObjCam), GetObjectY(ObjCam), GetObjectZ(ObjCam))
						
						SetCameraPosition(1, GetObjectWorldX(ObjCam), GetObjectWorldY(ObjCam), GetObjectWorldZ(ObjCam))
						//SetCameraLookAt(1,getobjectX(u), getobjectY(u)-10*s#,getobjectZ(u),0)
						// SetCameraLookAt(1,getobjectX(u), getobjectY(ObjCam),getobjectZ(u),0)
					
					elseif Options.GameMode = 5 // camera fixe
						SetCameraLookAt(1,getobjectX(u),getobjectY(u),getobjectZ(u),0) 
					endif
					
					//Print(str(GetObjectWorldX(ObjCam))+"/"+str(GetObjectWorldY(ObjCam))+"/"+str(GetObjectWorldZ(ObjCam)))
				
				endif
				
				Foldend
				
				
				
				
			endif
			
			
		foldend
		
		Endif
		
		
		foldstart // -----  other Keyboard
		
		
		
		if GetRawKeyreleased(27)=1 or GetRawJoystickButtonState(1, 7) // Button Back xbox
			Action = C_ACTIONSELECT
		endif
		
		if GetRawKeyPressed(KEY_F1)
			Freecamera = 1-Freecamera
		endif
		
		if FreeCamera = 1
			// Gosub MoveCamera
			if ( GetRawKeyState(37)) then MoveCameraLocalX( 1, -dc )		
			if ( GetRawKeyState(39)) then MoveCameraLocalX( 1, dc)			
			if ( GetRawKeyState(38)) then MoveCameraLocalZ( 1, dc )				
			if ( GetRawKeyState(40))  then MoveCameraLocalZ( 1, -dc ) 
		else
			
			FoldStart // camera
				if GetRawJoystickRX(1) <> 0 or GetRawJoystickRY(1)<>0

					if GetRawJoystickRY(1) >=0.9 or GetRawJoystickRY(1)<=-0.9
						newX# = newX# + GetRawJoystickRY(1)*0.5
						if newX# > 50
							newX# = 50
						elseif newX# < 20
							newX# = 20
						endif					
						camZ = CamZ - GetRawJoystickRY(1)
						camY = CamY + GetRawJoystickRY(1)*2 
						if CamZ <-260
							CamZ = -260
						elseif CamZ > -160
							CamZ = -160
						endif
						if CamY < 40
							CamY = 40
						elseif CamY > 120
							CamY = 120
						endif
						
						SetCameraRotation(1, newX#, camY, 0 )	
					endif
									
					
					if GetRawJoystickRX(1) <> 0
						camY2# = camY2# + GetRawJoystickRX(1)						
						if camY2# > 360
							camY2# = 0
						elseif camY2#<0
							camY2# = 360
						endif 
						setCameraRotation(1,GetCameraAngleX(1),camY2#,GetCameraAngleZ(1))
						setcameraposition(1,GetObjectWorldX(Nplayer),GetObjectWorldY(Nplayer)+camY2#,GetObjectWorldZ(Nplayer))
						moveCameraLocalZ(1,camZ)
						finalRotation = camY2#
						old = finalRotation
						// Rotate3DPhysicsCharacterController(objId,camY#)
					endif
				
				endif
				FoldEnd
			
			
			
		endif
		
		
		
		// wheel mouse for zoom
			wheel = GetRawMouseWheelDelta() 
			if wheel <> 0
				
				//MoveCameraLocalZ(1,dc*GetRawMouseWheelDelta())
				if Options.GameMode = 0
					//CamY =CamY+dc*GetRawMouseWheelDelta()
					//CamZ =CamZ+dc*GetRawMouseWheelDelta()
					MoveObjectLocalZ(ObjCam,dc*GetRawMouseWheelDelta())
					//MoveObjectLocalY(ObjCam,dc*GetRawMouseWheelDelta())
					MoveObjectLocalY(ObjCam,GetRawMouseWheelDelta())
				else 
					CamY = CamY + dc*GetRawMouseWheelDelta()
				endif
			endif
			
			// middle clic to move the camera	
			if GetRawMouseMiddlePressed()				
				startx1# = GetPointerX()
				starty1# = GetPointerY()
				angx# = GetCameraAngleX(1)
				angy# = GetCameraAngleY(1)
				SetCameraLookAt(1,options.GeneralX,options.GeneralY,options.GeneralZ,0)
				//CAmZ = GetcameraZ(1)
			endif
			
			if GetRawMouseMiddlestate()	
				new_x# = GetPointerX()
				new_y# = GetPointerY()
				MoveCameraLocalX( 1,-new_x#+startx1#)
				startx1#= new_x#
				MoveCameraLocalY( 1, new_y#-starty1# )
				starty1#= new_y#
				SetCameraLookAt(1,options.GeneralX,options.GeneralY,options.GeneralZ,0)
			endif
			
		
		Foldend
		
		
		FoldEnd
		
		
		FoldEnd
		
		foldstart // ----- Mouse
		
		//print(str(player.MobId))
		if GetPointerPressed()
			u=10000
			worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u
			worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u
			worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u	 
			worldX# = worldX# + GetCameraX(1)
			worldY# = worldY# + GetCameraY(1)
			worldZ# = worldZ# + GetCameraZ(1)			
		endif
		
		if GetPointerState()
			u=10000
			worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u
			worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u
			worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u	 
			worldX# = worldX# + GetCameraX(1)
			worldY# = worldY# + GetCameraY(1)
			worldZ# = worldZ# + GetCameraZ(1)
			
			ClickOnObj = 0
			obj = 0
			If ClickOnObj = 0 // pour vérifier si on a cliqué sur l'interface , plus tard ^^
				/*
				for i=0 to Mob.length
					obj=ObjectRayCast(mob[i].sprite,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
					if obj
						Player.MobId = i
						ClickOnObj = 1
						SetObjectPosition(CibleMob,mob[i].x,0,mob[i].z)
						Player.Fight = 1
						exit
					endif						
				next
				*/
			endif
							
			if clickOnObj = 0	// clic and go !			 	 
				obj=ObjectRayCast(Grid,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
				if obj				
					x=GetObjectRayCastX(0)
					y=GetObjectRayCasty(0)
					z=GetObjectRayCastz(0)
					// Player.MobId = -1
					//SetObjectPosition(cible,x,0.2,z)
					// SetObjectPosition(CibleMob,0,-10,0)
					//PLayer.Fight = 0
				endif
			endif
				
		endif
		
		
		
		foldend
		
		Foldstart // ----- player
		
		if GameProp.HasPlayer = 1
		
		
		
		
		
		
		// d'abord, on récupère la vie
		/* // no player for the moment
		if player.life < player.lifemax
			if timelife<=0
				timelife = 60
				player.life = player.life +5
			else
				dec timelife
			endif
		endif
		*/
		HitPlayer =0
		//For i=0 to nb
			//n = decor[i].sprite
			//HitPlayer = ObjectRayCast(0,GetObjectX(jim), GetObjectY(jim),GetObjectZ(jim),GetObjectX(n),GetObjectY(n),GetObjectZ(n) )
			//if HitPlayer <> 0
				//hitX = GetObjectX(n)
				//hitz = GetObjectz(n)		
			//endif		
			//exit
		//next
		
		/*
		if raycastjim
			If (GetObjectRayCastNumHits()=0)
				NewY#=GetObjectY(Jim)-1
			else
				NewY#=GetObjectRayCastY(0)+19
			EndIf		
		EndIf
		*/
		//print(str(Player.x)+"/"+str(hitX)+"-"+str(player.z)+"/"+str(hitz))
		
		Foldstart // move
		if HitPlayer <> 0
			/*
			if move = 0
				if player.x > hitx
					player.x = player.x + 1 //v*2 
				else
					player.x = player.x - 1 //v*2 
				endif
				if player.z > hitz
					player.z = player.z + 1 // v*2 
				else
					player.z = player.z - 1// v*2 
				endif
				MovePlayer()
				move =1
			endif
			*/
		else
			/*
			move = 0
			If player.x < x		
				//Player.x = player.x+v		
				NewX = player.x+v		
				move = 1
				if abs(NewX-x)<v
					NewX = x			
				endif			
			elseif player.x > x
				NewX = player.x-v
				move = 1
				if abs(NewX-x)<v
					NewX = x			
				endif
			Endif
			If player.z < z
				NewZ = player.z+v
				move = 1
				if abs(NewZ-z)<v
					NewZ = z			
				endif
			elseif player.z > z
				NewZ = player.z-v
				move = 1
				if abs(NewZ-z)<v
					NewZ = z			
				endif
			Endif
			
			
			if move=1
				if Player.z <> z or PLayer.x <> x
					angle#=-GetAngle(x,z,player.x,player.z)
					SetObjectRotation(Jim,0,angle#,0)	
				endif
				Player.x = NewX
				Player.z = NewZ
				MovePlayer()
			endif
			*/
		endif
		foldend
		
		else
		
			
		Endif

		
		
		
		foldend
		
		FoldStart // ----- Event 
		if Object.length >-1
			
			inc Cycle
			if Cycle = 5 then Cycle = 0
			px = GetObjectX(Nplayer)
			py = GetObjectY(Nplayer)
			pz = GetObjectZ(Nplayer)
			For i=Cycle to Object.length step 6
				if Object[i].Obj<> Nplayer
					if abs(px-Object[i].x) > 1000
						// GetDistance3D(,getobjectY(Nplayer),getobjectZ(Nplayer),,Object[i].y,object[i].z)<1200
						SetObjectVisible(Object[i].Obj,0)
					else
						if abs(pz-Object[i].y) > 1000
							SetObjectVisible(Object[i].Obj,0)
						else
							SetObjectVisible(Object[i].Obj,1-Object[i].hide)
						endif
					endif
				endif
			next
			
			
			// EventMob()		
			EventBehavior()
			EventFx()
			
		endif
		
		Foldend
		
		//Print("Life: "+str(Player.Life)+"/"+str(player.lifemax))
		//Print("Pos "+str(GetObjectY(jim)))
		
		
		
		// SyncShadow() // only RealTime shadowing
		
		if NbWater >-1 and Options.ShowWater=1
			SyncWater()		
		else		
			Sync()
		endif
	
	until quit = 1 or action <> C_ACTIONPLAY
	
	
	
	
	FoldStart // On sort de l'éditeur
	
	// Delete temporary objects
	DeleteObject(objcam)
	
	// then unhide LaGui
	
	if Action <> C_ACTIONPLAY 
		
		// unhide the utilities
		For i=0 to Object.length
			if Object[i].Hide=0 
				if Object[i].Typ <> C_OBJPARTSYS
					SetObjectVisible(Object[i].Obj, 1)
				endif
				SetSpriteVisible(Object[i].spr, Options.ShowCenter)
			endif
		next
		UpdateAllCenter()
		
		// light
		For i=0 to Light.length
			SetObjectVisible(Light[i].Obj, 1-Light[i].Hide)
		next
		
		// grid
		Options.ShowGrid = showGrid
		SetObjectVisible(Grid,Options.ShowGrid)
		
	
		// unHide ui
		if Options.Fullscreen = 0		
			SetWindowSize(G_width,G_height,0)
			SetVirtualResolution(G_width,G_height)
		endif
		LAG_HideALL(0)
		
		// SetWindowPosition(0,0)
	Endif

	Foldend
	
	
	
EndFunction 
