





Foldstart // ------ DECOR

//nom$ = "mur1,dalle1,poto1,poto2,marche1,muret1"
nom$ = "ground1,decor1,poto3,rock1"

Type sImage
	name$
	image as integer
EndType
nbi = 3
Global dim Image[nbi] as sImage
For i=0 to nbi
	Image[i].name$ = GetStringToken(nom$,",",i+1)
	if Image[i].name$  ="ground1"
		SetGenerateMipmaps( 1 ) 
		Image[i].image = loadimage("obj/"+Image[i].name$+".jpg")
		SetGenerateMipmaps( 0 ) 
	else
		Image[i].image = loadimage("obj/"+Image[i].name$+".jpg")
	endif
next


nb_i=Loading(nb_i)
// les objets
//nom$ = "mur1,dalle1,poto1,poto2,marche1,muret1"

Type sObjet
	Id as integer
	nom$
EndType
// d'abord, je charge les objets
Global Dim Objet[10] as sObjet

// on charge les objets ici
for i = 0 to nbi
	n$ = GetStringToken(nom$,",",i+1)
	ext$ =".obj"
	if n$ ="ground1"
		ext$ = ".dae"
	endif	
	Objet[i].Id = LoadObject("obj/"+n$+ext$)
	Objet[i].nom$ = n$
	SetObjectPosition(objet[i].id,-100000,-100000,-100000)
next

Objet[10].id = LoadObject("obj/mob.dae")




nb_i=Loading(nb_i)
foldend

Foldstart // ------ PLAYER
Type sPlayer	
	x as float
	y as float
	z as float
	Speed as float
	AngleY as float	
	life as integer
	lifemax as integer
	MobId as integer
EndType
Global Player as sPlayer
image1 = loadImage("obj/jim1.png")

nb_i=Loading(nb_i)

Global Jim
global x,y,z as float
Jim = loadObject ("obj/jim.dae")
SetObjectImage(Jim,image1,0)
nb_i=Loading(nb_i)
h = 0 // 2.6
Player.x = 0
Player.y = h
Player.z = 0
Player.life = 70
Player.lifeMax = 70
x = player.x
z = player.z
Player.Speed = 0.1
SetObjectPosition(Jim,Player.x,h,Player.y)

// ------  CIBLE
Global Cible as integer
Cible = CreateObjectBox(1,1,1)
SetObjectColor(Cible,255,0,0,120)
SetObjectVisible(Cible, 0)

nb_i=Loading(nb_i)
Foldend

Foldstart // ------ MOBS
iMob1 = loadImage("obj/mob.png")
Type sMob	
	x as float
	Z as float
	CibleX as float
	CibleZ as float
	Sprite as integer
	CibleOk as integer
	isattacked as integer
	life as integer
	lifemax as integer
	WalkOk as integer
	timeFight as integer
EndType
nbMob = 0
Global dim Mob[nbMob] as sMob

For i=0 to nbMob		
	Mob[i].sprite = InstanceObject(Objet[10].id)	
	//Mob[i].sprite = CloneObject(Objet[10])	
	SetObjectImage(Mob[i].sprite,iMob1,0)
	//SetObjectShader(Mob[i].sprite,shFog)
	// SetObjectScale(Mob[i].sprite,0.1,0.1,0.1)
	mob[i].x = random(-2,5)
	mob[i].z = random(-2,5)
	mob[i].life = 60
	mob[i].lifeMax = 60
	SetObjectPosition(Mob[i].sprite,mob[i].x,0,mob[i].z)
next
Foldend


do
	
	
	foldstart // keyboard 
		if GetRawKeyState(27)=1
			end
		endif
		if GetRawKeyPressed(32)=1 // space
			Id = Addobjet(TypId,ObjId,x,z,0,"")
		endif
		if GetRawKeyPressed(9)=1 // tab
			inc action
			if action > C_ACTIONCLONE
				action = C_ACTIONPLAY
			endif
			move = 0
			rotate = 0
			scale = 0
			SetObjectVisible(ground1,1)
			SetObjectVisible(CibleEd,1)
			select action
				case C_ACTIONPLAY
					SetObjectVisible(ground1,0)
					SetObjectVisible(CibleEd,0)
				endcase				
				case C_ACTIONMOVE
					move = 1
				endcase
				case C_ACTIONROTATE
					rotate = 1
				endcase
				case C_ACTIONSCALE
					scale = 1
				endcase
			endselect
			Action$ =GetStringToken(a1$,",",action+1)
		endif
		if GetRawKeyPressed(66)=1 // B
			// Change the Type of Object
			inc ObjId
			if ObjId > 3
				ObjId = 0
			endif			
		endif
		
	foldend
	
	foldstart // ----- Mouse
	
	if GetPointerState()
		
		select action
			case C_ACTIONPLAY // play
				worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * 800
				worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * 800
				worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * 800	 
				worldX# = worldX# + GetCameraX(1)
				worldY# = worldY# + GetCameraY(1)
				worldZ# = worldZ# + GetCameraZ(1)
				ClickOnObj = 0
				obj = 0
				If ClickOnObj = 0 // pour vérifier si on a cliqué sur l'interface , plus tard ^^
					for i=0 to NbMob
						obj=ObjectRayCast(mob[i].sprite,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
						if obj
							Player.MobId = i
							ClickOnObj = 1
							exit
						endif						
					next
				endif
								
				if clickOnObj = 0	// clic and go !			 	 
					obj=ObjectRayCast(ground1,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
					if obj				
						x=GetObjectRayCastX(0)
						y=GetObjectRayCasty(0)
						z=GetObjectRayCastz(0)
						Player.MobId = -1
						SetObjectPosition(cible,x,0.2,z)
					endif
				endif
			endcase
		endselect
	endif
	
	if GetPointerPressed()
		worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * 800
		worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * 800
		worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * 800	 
		worldX# = worldX# + GetCameraX(1)
		worldY# = worldY# + GetCameraY(1)
		worldZ# = worldZ# + GetCameraZ(1)
		
		
		select action		
			case C_ACTIONCREATE // create
				obj=ObjectRayCast(ground1,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
				if obj
					x=GetObjectRayCastX(0)
					y=GetObjectRayCastY(0)										
					z=GetObjectRayCastZ(0)										
					SetObjectPosition(CibleEd,x,y,z)
					SetObjectLookAt(CibleEd,getcameraX(1),getcameray(1),getcameraz(1),0)
				endif				
			endcase
		endselect
	endif
	
	
	select action
		case C_ACTIONSELECT 
				u=100 // 800
				worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * u
				worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * u
				worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * u	 
				worldX# = worldX# + GetCameraX(1)
				worldY# = worldY# + GetCameraY(1)
				worldZ# = worldZ# + GetCameraZ(1)
				if GetPointerPressed()
											
					For i=0 to decor.length
						SetObjectColorEmissive(decor[i].sprite,0,0,0)
					next
					
					For i=0 to decor.length
						n = decor[i].sprite
						obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
						if obj
							id = i								
							moveobj = 1
							SetObjectColorEmissive(decor[i].sprite,50,0,0)
							exit
						endif
					next				
				endif
				
		Endcase	
		case C_ACTIONMOVE // move
			
			worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * 800
			worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * 800
			worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * 800	 
			worldX# = worldX# + GetCameraX(1)
			worldY# = worldY# + GetCameraY(1)
			worldZ# = worldZ# + GetCameraZ(1)
				
				select TypId
					case 0
						if GetPointerPressed()	
								
							For i=0 to decor.length
								SetObjectColorEmissive(decor[i].sprite,0,0,0)
							next
							
							For i=0 to decor.length
								n = decor[i].sprite
								obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
								if obj
									id = i								
									moveobj = 1
									SetObjectColorEmissive(decor[i].sprite,50,0,0)
									exit
								endif
							next
						elseif GetPointerReleased()
							moveobj = 0
						endif
						if GetPointerState()
							if moveobj =1
								obj=ObjectRayCast(ground1,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
								if obj
									x=GetObjectRayCastX(0)
									z=GetObjectRayCastZ(0)						
									SetObjectPosition(decor[id].sprite,x,0,z)
								endif
							endif
						endif							
					endcase
				endselect						
				
			endcase
			case C_ACTIONSCALE // scale
				
			endcase
			case C_ACTIONROTATE // Rotate
				select TypId
					case 0
						if GetPointerPressed()						
							For i=0 to decor.length
								n = decor[i].sprite
								obj=ObjectRayCast(n,getcamerax(1),getcameray(1),getcameraz(1),worldx#,worldy#,worldz#)
								if obj	
									id = i							
									moveobj = 1
									u = GetObjectAngleZ(decor[id].sprite)
									exit
								endif
							next
						elseif GetPointerReleased()
							moveobj = 0
						endif
						if GetPointerState()
							if moveobj =1
								inc u
								n = decor[id].sprite 
								SetObjectRotation(n,GetObjectAngleX(n)+u*RX,GetObjectAngleY(n)+u*RY,GetObjectAngleZ(n)+u*RZ)
							endif
						endif							
					endcase
				endselect						
				
			endcase
			case C_ACTIONDELETE // delete
				
			endcase
		endselect				
	
	foldend
	
	
	if action <> C_ACTIONPLAY
		
	Foldstart // EDITOR MODE : move camera 
	
	
		rem Move camera
		if ( GetRawKeyState(38)) then MoveCameraLocalZ( 1, dc )
		if ( GetRawKeyState(40)) then MoveCameraLocalZ( 1, -dc )
		if ( GetRawKeyState(37) ) then MoveCameraLocalX( 1, -dc*0.2 )
		if ( GetRawKeyState(39) ) then MoveCameraLocalX( 1, dc*0.2)
			
		if move = 0 and rotate = 0 and scale = 0
			oldx#=GetCameraX(1)
			oldy#=GetCameraY(1)-45.0
			oldz#=GetCameraZ(1)			
			
			if ( GetRawMouseRightPressed() )
				startx# = GetPointerX()
				starty# = GetPointerY()
				angx# = GetCameraAngleX(1)
				angy# = GetCameraAngleY(1)
				pressed = 1
			endif

			if ( GetRawMouseRightState() = 1 )
				fDiffX# = (GetPointerX() - startx#)/1.0
				fDiffY# = (GetPointerY() - starty#)/1.0

				newX# = angx# + fDiffY#
				if ( newX# > 89 ) then newX# = 89
				if ( newX# < -89 ) then newX# = -89
				SetCameraRotation( 1, newX#, angy# + fDiffX#, 0 )
			endif
		endif
	foldend
	
	Else 
		
	Foldstart // else play MODE
		
		FoldStart 
		
		// d'abord, on récupère la vie
		if player.life < player.lifemax
			if timelife<=0
				timelife = 60
				player.life = player.life +5
			else
				dec timelife
			endif
		endif
		
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
		FolDEnd
	
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
			MovePlayer(angle#)
		endif
	endif
	foldend
	
		FoldStart // mob
	For i=0 to NbMob
		n = mob[i].sprite
		if mob[i].timeFight>0
			dec mob[i].timeFight
		endif
		if abs(Player.x-Mob[i].x)<=10 and abs(player.z-Mob[i].z)<=10
			Mob[i].IsAttacked = 1						
		endif
		if abs(Player.x-Mob[i].x)<=3 and abs(player.z-Mob[i].z)<=3
			if mob[i].timeFight<= 0
				Player.life = Player.life - 12	
				mob[i].timeFight= 100				
			endif
			mob[i].cibleok = 0
		else
			mob[i].cibleOk = 1
		endif
		if Mob[i].IsAttacked = 1
			if mob[i].cibleOK = 1
				if Mob [i].walkok = 0
					Mob[i].CibleX=Player.X+random(-2,2)
					Mob[i].CibleZ=Player.Z+random(-2,2)
					Mob[i].walkok = 1
				endif
			endif
			if Mob[i].X<Mob[i].CibleX
				Mob[i].x=Mob[i].x+sp							
			elseif  Mob[i].X>Mob[i].CibleX
				Mob[i].x=Mob[i].x-sp			
			endif
			if abs(mob[i].x-Mob[i].Ciblex)<sp
				mob[i].x=Mob[i].Ciblex										
			endif
			if Mob[i].z<Mob[i].CibleZ
				Mob[i].z=Mob[i].z+sp								
			elseif Mob[i].z>Mob[i].CibleZ
				Mob[i].z=Mob[i].z-sp			
			endif	
			if abs(mob[i].z-Mob[i].CibleZ)<sp
				mob[i].z=Mob[i].CibleZ					
			endif		
			if Mob[i].walkok=1
				if Mob[i].x<>Mob[i].Ciblex or Mob[i].z<>Mob[i].Ciblez
					//angle# = -getangle(Mob[i].Ciblex,Mob[i].x,Mob[i].CibleZ,Mob[i].Z)
					//SetObjectRotation(mob[i].sprite,0,angle#,0)
					SetObjectLookAt(mob[i].sprite,PLayer.x,player.y,player.z,0)
				endif
				SetObjectPosition(mob[i].sprite,Mob[i].x,0,mob[i].z)
			endif
			if Mob[i].X=Mob[i].CibleX and Mob[i].z = Mob[i].Ciblez
				Mob[i].WalkOk = 0
			endif
			// print(str(Mob[i].X)+"/"+str(Mob[i].ciblex)+"-"+str(Mob[i].Z)+"/"+str(Mob[i].ciblez))
		endif
	Next 
	
	foldend
	
	foldend
	
	endif
		
	// Step3DPhysicsWorld()
	Sync()
 
loop

Function MovePlayer(angle#)
		
	SetObjectPosition(Jim,Player.x,GetObjectY(Jim),Player.z)
	SetCameraPosition(1,Player.x,h2+5,Player.z+d-25)
	// SetCameraRotation(1,GetCameraAngleX(1),getobjectangleY(Jim),GetCameraAngleZ(1))
	SetCameraRotation(1,0,GetObjectAngleY(jim),0)
	SetCameraLookAt(1,Player.x,Player.Y+2,Player.z,1)	
	SetPointLightPosition(1,Player.x,hl,Player.z-2)
	
EndFunction
 
Function limb(obj1,obj2,xstep#,ystep#,zstep#)
    setobjectposition(obj2,getobjectX(obj1),getobjectY(obj1),getobjectZ(obj1))
    setobjectrotation(obj2,getobjectanglex(obj1),getobjectangleY(obj1),getobjectangleZ(obj1))
    moveobjectlocalx(obj2,xstep#)
    moveobjectlocaly(obj2,ystep#)
    moveobjectlocalz(obj2,zstep#)
endfunction


Function LoadLevel()
	
	fil$="map/test.map"
	
	if GetFileExists(fil$) = 1

		OpenToRead(5, fil$)
		
		While FileEOF(5) = 0

			Line$ = ReadLine(5)
			Index$ = GetStringToken(Line$ ,"|",1)
			select index$
				case "L" // light
					typ = ValFloat(GetStringToken(line$,"|",2))	 // 0 = sun, 1 = light				
					x# = ValFloat(GetStringToken(line$,"|",3)) 
					Y# = ValFloat(GetStringToken(line$,"|",4))
					Z# = ValFloat(GetStringToken(line$,"|",5))
					r = ValFloat(GetStringToken(line$,"|",6))
					g = ValFloat(GetStringToken(line$,"|",7))
					b = ValFloat(GetStringToken(line$,"|",8))
					select typ 
						case 0
							//SetSunActive(0)
							// SetSunColor(r,g,b)
							//SetAmbientColor(150,102,46)
							//SetAmbientColor(0,0,0)
						endcase
						case 1							
							//inc light
							//CreatePointLight(light,x#,z#,y#,250,r,g,b)
							//SetPointlightmode(light,1)
						endcase
					endselect 
					
				endcase
				case "S" // start				
					x = ValFloat(GetStringToken(line$,"|",3)) 
					Y = ValFloat(GetStringToken(line$,"|",4))
					player.x = x
					player.z = y
					x = Player.x					
					z = Player.z					
					SetObjectPosition(Cible,x,0,y)
					SetObjectPosition(Jim,Player.x,h,Player.y)
					MovePlayer(0)
					//Message("Start : "+str(x)+"/"+str(y))
				endcase
				case "O"
					ok = 0
					for i=0 to objet.length
						if objet[i].nom$ <> ""
							nam$ = lower(GetStringToken(line$,"|",2))
							if nam$ = lower(objet[i].nom$)
								//t$ = t$ + " ok ---------------------"+chr(10)
								id = i
								u = 2
								img$ = nam$ : inc u							
								sync()
								x# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								y# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								z# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								sx# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								sy# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								sz# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								rx# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								ry# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								rz# = ValFloat(GetStringToken(line$,"|",u)) : inc u
								ok = 1
								exit
							endif
						endif
					next
				
					if ok = 1
						Addobjet(0,id,x#,y#,z#,img$+","+str(sx#)+","+str(sy#)+","+str(sz#)+","+str(rx#)+","+str(ry#)+","+str(rz#))
						sync()
					endif
					
				endcase
			endselect
		EndWhile
		
		closefile(5)
	
	endif
		
EndFunction




/* // Getmousepick object
rem
rem AGK Application
rem
SetVirtualResolution( 480, 480 )
SetCameraPosition(1,0,0,-300)
SetCameraRotation(1,0,0,0)
rem A Wizard Did It!
box= CreateObjectBox( 50,50,50 )
SetObjectPosition( box, -60, 0,0 )
box= CreateObjectBox( 50,50,50 )
SetObjectPosition( box, 0, 0,0 )
box= CreateObjectBox( 50,50,50 )
SetObjectPosition( box, 60, 0,0 )

do
	RotateObjectGlobalX( box, 1 )
	REM // Check if user selects an 3d object
	rx#=Get3DVectorXFromScreen( GetRawMouseX(), GetRawMousey() ) * 100 // *100000
	ry#=Get3DVectorYFromScreen( GetRawMouseX(), GetRawMousey() ) * 100 // *100000
	rz#=Get3DVectorZFromScreen( GetRawMouseX(), GetRawMousey() ) * 100 // *100000

	if GetRawMouseLeftReleased()
		temp=0
		REM// seams like i nead to check for raycast hits on all the objects?
		for t=10001 to 10003
			temp=ObjectRayCast( t, getcamerax(1), getcameray(1), getcameraz(1), rx#, ry#, rz# )
			if temp>0
				temp=t
				exit
			endif
		next t
		if temp>0 
			//if temp<>box 
				box=temp
			//endif
		endif
	endif
	print(str(rx#)+"/"+str(ry#)+"/"+str(rz#))
	print(str(box))
	Sync()
loop



*/

/* // clic on object ok !!!
global aicount
aicount=3
createobjectplane(1,100,100)
movecameralocalz(1,-50)
movecameralocalY(1,-100)
RotateCameraLocalX(1,-60)
createobjectbox(2,5,5,5)
setobjectcolor(2,255,0,0,255)
do
 
	worldX# = Get3DVectorXFromScreen( GetPointerX(), GetPointerY() ) * 800
    worldY# = Get3DVectorYFromScreen( GetPointerX(), GetPointerY() ) * 800
    worldZ# = Get3DVectorZFromScreen( GetPointerX(), GetPointerY() ) * 800
 
    worldX# = worldX# + GetCameraX( 1 )
    worldY# = worldY# + GetCameraY( 1 )
    worldZ# = worldZ# + GetCameraZ( 1 )
 
	obj=ObjectRayCast(1,getcamerax(1),getcameray(1),getcameraz(1), worldx#,worldy#,worldz#)
	if obj
		x as float
		y as float
		z as float
		x=GetObjectRayCastX(0)
		y=GetObjectRayCasty(0)
		z=GetObjectRayCastz(0)
		setobjectposition (2,x,y,z)
		if getpointerpressed()
			createobjectbox(aicount,5,5,5)
			setobjectposition(aicount,x,y,z)
			setobjectcolor(aicount,0,255,0,255)
			aicount=aicount+1
		endif
		print ("object: "+str(obj))
		print ( "X: "+str(x) )
		print ( "Y: "+str(y))
		print ( "Z: "+str(z))
	endif
    sync()
 
 
loop

*/


