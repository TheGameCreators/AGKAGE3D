


Function InitLevel(Newgame)
	
	
	if newgame = 1
		CreatePlayer()
		nb_i=Loading(nb_i)
	endif
	
	// ------ CAMERA 
	// MoveCameraLocalZ(1,-9)
	RotateCameraGlobalY(1,180)
	// SetCameraLookAt(1,0,2,0,0)

	// ------ LIGHTS 
	//CreatePointLight(2,10,5,5,250,120,180,250)
	CreatePointLight(2,-100,5,-100,120,120,180,250)
	SetPointlightmode(2,1)
	Global light as integer
	Light = 2
	
	// light player
	CreatePointLight(1,0,10,0,20,1200,400,0)
	// SetPointlightmode(1,1)
	
	nb_i=Loading(nb_i)
	
	Global Sphere
	Sphere = CreateObjectSphere(1,6,6)
	SetObjectLightMode(Sphere,0)
	SetObjectColor(Sphere,600,200,0,255)
	//SetObjectColorEmissive(Sphere,600,200,0)
	
	SetSunActive(1)
	SetSunDirection(-5,-1,-5)
	//SetSunDirection(112,21,245)
	//SetSunColor(50,50,255)
	u=2
	// SetSunColor(u*50,u*50,u*255)
	SetSunColor(255*0.273,255*0.603,255*0.853)
	/*
	SetSunActive(0)
	SetSunDirection(5,0,-1)
	SetSunColor(250,202,146)
	*/
	//SetAmbientColor(12,18,25)
	a as float
	a = 1.5
	SetAmbientColor(20*a,20*a,100*a)
	
	nb_i=Loading(nb_i)

	
	
	LoadLevel()
	nb_i=Loading(nb_i)
	
	CreateDecor() // si besoin, on crée le décor
	nb_i=Loading(nb_i)
	
	CreateTheMob()	
	nb_i=Loading(nb_i)
	
	
Endfunction


Function LoadLevel()
	
	fil$="map/"+str(player.MapId)+".map"
	
	if GetFileExists(fil$) = 1

		OpenToRead(5, fil$)
		
		While FileEOF(5) = 0

			Line$ = ReadLine(5)
			Index$ = GetStringToken(Line$ ,"|",1)
			select index$
				case "L" // light
					typ = ValFloat(GetStringToken(line$,"|",2))	 // 0 = sun, 1 = light				
					x2# = ValFloat(GetStringToken(line$,"|",3)) 
					Y2# = ValFloat(GetStringToken(line$,"|",4))
					Z2# = ValFloat(GetStringToken(line$,"|",5))
					
					r = ValFloat(GetStringToken(line$,"|",9))
					g = ValFloat(GetStringToken(line$,"|",10))
					b = ValFloat(GetStringToken(line$,"|",11))
					select typ 
						case 0
							// SetSunActive(0)
							// SetSunColor(r,g,b)
							// SetAmbientColor(150,102,46)
							// SetAmbientColor(0,0,0)
						endcase
						case 1							
							inc light
							CreatePointLight(light,x2#,z2#,y2#,15,r*2,g*2,b*2)
							SetPointLightMode(light,1)
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
					MovePlayer()
					//Message("Start : "+str(x)+"/"+str(y))
				endcase
				case "F" // fx, particles
					typ = Val(GetStringToken(line$,"|",2)) 
					x# = ValFloat(GetStringToken(line$,"|",3)) 
					Y# = ValFloat(GetStringToken(line$,"|",4))
					Z# = ValFloat(GetStringToken(line$,"|",5))
					AddPartSystem(x#,y#,z#)
				/*
					nbfx = Particle.length+1
					Global dim particle[nbfx] as integer
					i = nbfx 
					particle[i] = CreateObjectPlane(2,2)
					n = particle[i]
					typ = Val(GetStringToken(line$,"|",2)) 
					x# = ValFloat(GetStringToken(line$,"|",3)) 
					Y# = ValFloat(GetStringToken(line$,"|",4))
					Z# = ValFloat(GetStringToken(line$,"|",5))
					//SetObjectPosition(n,15*i,5,0)
					SetObjectPosition(n,x#,y#,z#)
					SetObjectImage(n,iFx,0)
					SetObjectTransparency(n,2)
					SetObjectLightMode(n,0)	
					//SetObjectColorEmissive(n,255,255,255)
					*/	
				endcase
				case "O" // normal object
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


