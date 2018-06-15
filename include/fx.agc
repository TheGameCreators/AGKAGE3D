
//************** FX *********************//

// fx : partcile, bullets, explosion (plane with image animated)




//************** FX *********************//
Type sVec3D
	x as float
	y as float
	z as float
EndType

Type sBullet
	
	Obj as integer // le billboard pour l'image
	Box as integer // objet pour la collision
	
	Size as integer	
	a as integer // alpha
	Speed as float
	Degat as integer 
	Typ as integer // Typ = 0 -> vient du joueur, 100 = vient des mobs
	Life as integer
	Pos as sVec3D
	Cible as sVec3D
	Angle as float
	
	CibleID as integer // le numéro de la cible .  
	// 0 = player, 1,2,3 : compagnon, 10 à 50 invocation (donc invoc-10 pour connaitre l'id de l'invoc), 100+ : mob
	// Ex pour un mob : 114 : c'est le mob[14], 52 :  c'est l'invoc[42], 0 c'est le player
EndType

Type sParticle
	
	Obj as integer
	// position of particle system
	x as float
	y as float
	z as float
	a as float // alpha
	
	decAlpha as float // decrease alpha by life

	SpeedX as float
	SpeedZ as float
	SpeedY as float
	Life as integer
	LifeMax as integer
	Size as integer
		
EndType

Type sPartSystem
	
	
	x as float
	y as float
	z as float
	
	// color
	Color as integer
	R as integer
	G as integer
	B as integer
	
	Rc as integer
	Gc as integer
	Bc as integer
	
	Alpha as integer
	Bm as integer
	
	// others
	Particle as sParticle[]
	Typ as integer // typ of particle system 0 = movement (up/down) : fire, rain, snow, magic.., Typ = 1 : explosion, typ = 2 : sinus, typ = 3 : circle
	Img as integer 
	Looping as integer // is number of loop (-1 = infinite, 0 = no loop, >0 number of loop) (for typ > 0)
	Life as integer
	
	// Transparency as integer
	// for particles
	Speed as float
	SpeedMin as float
	
	Size as float
	Rand as integer // random position for x & z 
	 
	// if needed
	RandX as integer // random position for x 
	RandY as integer // random position for Y
	RandZ as integer // random position for Z
	
EndType



// Bullet 
Function InitBullet()
	Global Dim Bullet[] as sBullet
EndFunction

Function AddBullet(typ)
	
	
	
	Select Typ
		
		case 0 // player
			
			i=bullet.length+1
			global dim Bullet[i] as sBullet
			/*  **************************************** attente player
			//Bullet[i].CibleID = Player.CibleID
			
			
			//Bullet[i].Pos.x = GetObjectWorldX(Player.KebouzID)
			//Bullet[i].Pos.y = GetObjectWorldY(Player.KebouzID)
			// Bullet[i].Pos.z = GetObjectWorldZ(Player.KebouzID)
			*/
			
			Bullet[i].Typ = Typ
			n = CreateObjectBox(15,15,15)
			Bullet[i].Box = n
			/*  **************************************** attente player
			Bullet[i].Life = ProfilFlingue[0].life
			Bullet[i].degat = ProfilFlingue[0].degat
			Bullet[i].Speed = ProfilFlingue[0].speed
			
			SetObjectPosition(n,Bullet[i].Pos.x,Bullet[i].Pos.y,Bullet[i].Pos.z)
			SetObjectRotation(n,GetObjectAngleX(Player.Obj),GetObjectAngleY(Player.Obj),GetObjectAngleZ(Player.Obj))
			*/
			
			// SetObjectLookAt(n,Bullet[i].Pos.x,Bullet[i].Pos.y,Bullet[i].Pos.z,0) 
			SetObjectVisible(n, 0)
			
			
			n = CreateObjectplane(50,50)
			Bullet[i].Obj=n
			/*  **************************************** attente player
			SetObjectImage(n,iFx+ProfilFlingue[0].Img,0)
			SetObjectColorEmissive(n,ProfilFlingue[0].r,ProfilFlingue[0].g,ProfilFlingue[0].b)
			*/
			SetObjectTransparency(n,2)
			SetObjectShader(n,3)
			SetObjectPosition(n,Bullet[i].Pos.x,Bullet[i].Pos.y,Bullet[i].Pos.z)
			//FixObjectToObject(n,Bullet[i].Box)
			
		endcase		
		case 1 // mob
			
		endcase 
		
	endselect
	
EndFunction

Function EventBullet()
	
	For i=0 to bullet.length
		
		if Bullet[i].Life>0
			dec Bullet[i].Life
			n = Bullet[i].Box
			if Bullet[i].CibleID <> -1
				j = Bullet[i].CibleID
				// attente mob :   SetObjectLookAt(n,Mob[j].x,Mob[j].y,Mob[j].z,0)
			endif
			MoveObjectLocalZ(n,Bullet[i].Speed)
			SetObjectLookAt(Bullet[i].Obj,GetCameraX(1),GetCameraY(1),GetCameraZ(1),0)
			SetObjectPosition(Bullet[i].Obj,GetobjectX(n),GetobjectY(n),GetobjectZ(n))
		else
			DeleteObject(Bullet[i].Box)
			DeleteObject(Bullet[i].Obj)
			Bullet.remove(i)
		endif
		
	NExt
	
EndFunction	




//    particles system functions


/*  EXAMPLES 

// add some particles system
smoke = AddPartSystem(0,6,iFx+4,0,0.8,0,2,35,1,85,MakeColor(100,100,100),1.46) // smoke
SetPartSystemTransparency(smoke,1,0)

AddPartSystem(0,45,iFx,0,0,0,4,30,1,55,MakeColor(150,70,0),1.6) // fire

AddPartSystem(0,35,iFx,-10,1,0,10,35,2,40,MakeColor(255,50,0),0.8) // fire braise
AddPartSystem(0,10,iFx+1,10,-1,0,6,10,2,450,MakeColor(100,100,255),1.5) // stars
AddPartSystem(0,15,iFx,-10,1,-10,2,2,2,240,MakeColor(50,235,25),2.5) // blob
AddPartSystem(0,15,iFx+2,0,1,-10,1,15,2,120,MakeColor(60,60,254),3.8) // magic fil
Explode = AddPartSystem(1,30,iFx,0,20,0,0,30,15,160,MakeColor(220,100,50),2) // explosion move
SetPartSystemAnimation(Explode,1,30)

Blob = AddPartSystem(1,20,iFx,0,30,0,0,15,8,80,MakeColor(20,180,150),2) // Blob 2
SetPartSystemAnimation(Blob,1,30)

Rain = AddPartSystem(0,45,iFx+2,0,40,0,150,-220,-200,80,MakeColor(250,250,250),2) // rain

Snow = AddPartSystem(0,50,iFx,0,40,0,150,-80,-60,200,MakeColor(250,250,250),2.2) // snow
BigRain = AddPartSystem(0,50,iFx+2,0,40,0,150,-460,-420,40,MakeColor(250,250,250),2.8) // BigRain

Luciole = AddPartSystem(1,60,iFx,0,20,0,1000,8,0,350,MakeColor(250,250,250),1.8) 
SetPartSystemAnimation(Luciole,1,70)	


Grele = AddPartSystem(0,40,iFx,0,40,0,150,-300,-200,120,MakeColor(254,254,254),0.6) 

*/


// Init system
Function InitPartSystem()
	global dim PartSystem[-1] as sPartSystem
EndFunction



// add syst and particles
Function AddPartSystem(typ,nb,img,x#,y#,z#,rand,speed#,speedmin#,life,color,size#)
	
	n = PartSystem.length+1
	global dim PartSystem[n] as sPartSystem
	PartSystem[n].Typ = Typ 
	PartSystem[n].x = x# 
	PartSystem[n].y = y#
	PartSystem[n].z = z#
	PartSystem[n].Rand = rand
	PartSystem[n].Randx = rand
	PartSystem[n].Randy = rand
	PartSystem[n].Randz = rand
	PartSystem[n].Size = size#
	PartSystem[n].img = img
	PartSystem[n].speedmin = speedmin#
	PartSystem[n].speed = speed#
	PartSystem[n].Color = color
	PartSystem[n].R = GetColorRed(color)
	PartSystem[n].G = GetColorGreen(color)
	PartSystem[n].B = GetColorBlue(color)
	PartSystem[n].Rc = 255
	PartSystem[n].Gc = 255
	PartSystem[n].Bc = 255
	PartSystem[n].Alpha = 255
	PartSystem[n].life = life
	
	For i=0 to nb
		// s# = 0.25*random(3,6)
		AddParticle(n) // ,x#,y#,z#,color,speed#,life)
	next
	
EndFunction n
		
Function AddParticle(id) // ,x#,y#,z#,color,sp#,life)
	
	// if id <= PartSystem.length
	
	// Ajout d'un objet particule dans le système
	nb = PartSystem[id].Particle.length+1
	PartSystem[id].Particle.length = nb
	PartSystem[id].Particle[nb].Obj = CreateObjectPlane(2,2) // the particle fx in normal mode
	u = PartSystem[id].Particle[nb].Obj

	
	// variables du systeme
	x# = PartSystem[id].x
	y# = PartSystem[id].y
	z# = PartSystem[id].z
	
	color 	= makecolor(PartSystem[id].R,PartSystem[id].g,PartSystem[id].b)
	sp# 	= PartSystem[id].Speed
	size 	= PartSystem[id].size
	life 	= PartSystem[id].life

	
	
	// ------ properties for particles	
	
	// size 
	s# = 0.1*random(8*size,10*size)
	SetObjectScale(u,s#,s#,s#)	
	//SetObjectPosition(u,-1,0,-6)
	
	// shader & image, colors 
	SetObjectImage(u,PartSystem[id].img,0)
	
	SetObjectTransparency(u,2)
	SetObjectShader(u,shFx)

	
	if color <> -1
		SetObjectColorEmissive(u,GetColorRed(color),GetColorGreen(color),GetColorBlue(color))
		SetObjectColor(u,GetColorRed(color),GetColorGreen(color),GetColorBlue(color),255)
	endif	
	//SetObjectLightMode(u,0)
	PartSystem[id].Particle[nb].size = size
	
	// the position & speed of the particles
	rand = PartSystem[id].Rand
	sp1# = abs(PartSystem[id].speedmin)
	sign = 1
	a# = 0.2
	if PartSystem[id].Typ < 1		
		SetParticleSpeed(id,nb)
		PartSystem[id].Particle[nb].x = x# + a#*(random(0,rand) - random(0,rand))
		PartSystem[id].Particle[nb].y = s# + y# // y# + 2*a#*(random(0,3))
		PartSystem[id].Particle[nb].z = z# + a#*(random(0,rand) - random(0,rand))
	else		
		
		SetParticleSpeed(id,nb)
		PartSystem[id].Particle[nb].x = x# + a#*(random(0,rand) - random(0,rand))
		PartSystem[id].Particle[nb].y = y# + a#*(random(0,rand) - random(0,rand))
		PartSystem[id].Particle[nb].z = z# + a#*(random(0,rand) - random(0,rand))
	endif
	
	// position and random position
	SetObjectPosition(u,PartSystem[id].Particle[nb].x,PartSystem[id].Particle[nb].y,PartSystem[id].Particle[nb].z)


	// alpha
	PartSystem[id].Particle[nb].a = PartSystem[id].Alpha // 255
	
	
	// life 
	PartSystem[id].Particle[nb].LifeMax = life
	PartSystem[id].Particle[nb].Life = random(0,life)
	
	/*
	t$ = GetObjectMeshVSSource(PartSystem[id].Particle[nb].Obj,1)
	t1$ = GetObjectMeshPSSource(PartSystem[id].Particle[nb].Obj,1)
	
	OpenToWrite(1,"shadertest_vs.txt")
	WriteLine(1,t$)
	closefile(1)
	OpenToWrite(1,"shadertest_ps.txt")
	WriteLine(1,t1$)
	closefile(1)
	*/

EndFunction



	
// Changes parmaeters
	
Function SetPartSystemAnimation(id,looping,nb)
	if id <= PartSystem.length
		PartSystem[id].looping = looping
		// PartSystem[id].Particle.length = nb
	endif
EndFunction	

Function SetPartSystemColor(id,r,g,b,a)
	if id <= PartSystem.length
		PartSystem[id].Color = MakeColor(r,g,b)	
				
		PartSystem[id].R = r	
		PartSystem[id].G = g	
		PartSystem[id].b = b	
		
		PartSystem[id].Rc = 255	
		PartSystem[id].Gc = 255	
		PartSystem[id].bc = 255	
		
		PartSystem[id].Alpha = a		
		For i= 0 to PartSystem[Id].Particle.length
			u = PartSystem[id].Particle[i].Obj
			SetObjectColorEmissive(u,r,g,b)
			SetObjectColor(u,r,g,b,a)
		next		
	endif
EndFunction
	
Function SetPartSystemParam(id,randx,randy,randz,img,size#,speed#,speedmin#,life)
	if id <= PartSystem.length
		PartSystem[id].Randx = randx
		PartSystem[id].Randy = randy
		PartSystem[id].Randz = randz
		PartSystem[id].Size = size#
		if img >-1
			PartSystem[id].img = img
		endif
		PartSystem[id].speedmin = speedmin#
		PartSystem[id].speed = speed#
		For i= 0 to PartSystem[Id].Particle.length
			u = PartSystem[id].Particle[i].Obj
			s# = 0.1*random(8*size#,10*size#)
			SetObjectScale(u,s#,s#,s#)
			PartSystem[id].Particle[i].LifeMax=life
			SetParticleSpeed(id,i)
			if img >-1
				SetObjectImage(u,img,0)
			endif
		next		
	endif
EndFunction	

Function SetPartSystemImg(id,img,bm)
	
	if id <= PartSystem.length
		PartSystem[id].img = img
		For i= 0 to PartSystem[Id].Particle.length
			u = PartSystem[id].Particle[i].Obj
			if img >-1
				SetObjectImage(u,img,0)
				PartSystem[Id].img = img
			endif			
			PartSystem[Id].bm = bm
			if bm>-1
				SetObjectTransparency(u,bm)
				
				if bm = 2
					SetObjectShader(u,shFx)
				else
					SetObjectShader(u,0)
				endif
			endif
		next	
	endif
	
EndFunction

Function SetPartSystemPosition(id,x#,y#,z#)
	if id <= PartSystem.length
		PartSystem[id].x = x#
		PartSystem[id].y = y#
		PartSystem[id].z = z#
	endif
EndFunction	
	
Function SetPartSystemTransparency(id,mode,shader)
	/*
	if id <= PartSystem.length
		For i= 0 to PartSystem[id].Particle.length
			n = PartSystem[id].Particle[i].Obj
			//SetObjectTransparency(n,mode)
			//SetObjectShader(n,shader)
		next 		
	endif
	*/
Endfunction	
		
Function SetParticleSpeed(id,nb)
	
	sp1# = abs(PartSystem[id].speedmin)
	sp# = PartSystem[id].speed
	
	if PartSystem[id].Typ < 1
		sign = 1
		if sp# < 0  
			sign = -1
		endif
		PartSystem[id].Particle[nb].speedY = sign * random(sp1#,abs(sp#))*0.005*0.5 // 0.005 * random(2,30)*0.5 + sp#*0.001
		PartSystem[id].Particle[nb].speedX = sign * random(sp1#,abs(sp#))*0.005*0.5 // 0.005 * random(2,30)*0.5 + sp#*0.001
		PartSystem[id].Particle[nb].speedZ = sign * random(sp1#,abs(sp#))*0.005*0.5 // 0.005 * random(2,30)*0.5 + sp#*0.001
	else
		signX = (1 -2*random(0,1)) 
		signY = (-1 +2*random(0,1))
		signZ = (1 -2*random(0,1))
		PartSystem[id].Particle[nb].speedX = signX * random(0,abs(sp#))*0.0025 // 0.005 * random(2,30)*0.5 + sp#*0.001
		PartSystem[id].Particle[nb].speedY = signY * random(0,abs(sp#))*0.0025 // 0.005 * random(2,30)*0.5 + sp#*0.001
		PartSystem[id].Particle[nb].speedZ = signZ * random(0,abs(sp#))*0.0025 // 0.005 * random(2,30)*0.5 + sp#*0.001
	endif
	
EndFunction

Function SetParticleNumber(id, nb)

	// pour ajouter ou supprimer des particules dans le system de particules
	if id >-1 and id <=PartSystem[id].Particle.length
		
		if nb <> PartSystem[id].Particle.length
			
			if nb > PartSystem[id].Particle.length
				
				a = PartSystem[id].Particle.length
				For i=a to nb
					AddParticle(id) // ,x#,y#,z#,color,speed#,life)
				next
				
			else
			
				n = PartSystem[id].Particle.length - nb
				for i=0 to n //PartSystem[id].Particle.length
					DeleteObject(PartSystem[id].Particle[i].Obj)		
				next
				// PartSystem[id].Particle.length = -1
			
			endif
		endif
	endif

EndFunction


// Delete
Function DeletePartSystem(id)
	
	if id <= PartSystem.length
		for i=0 to PartSystem[id].Particle.length
			DeleteObject(PartSystem[id].Particle[i].Obj)		
		next
		PartSystem[id].Particle.length = -1
		PartSystem.remove(id)
	
		For i =0 to PartSystem.length
		
		next	
	
	endif
EndFunction

Function DeleteAllPartSystem()
	
	For j=0 to PartSystem.length
		for i=0 to PartSystem[j].Particle.length
			DeleteObject(PartSystem[j].Particle[i].Obj)		
		next
		// PartSystem[id].Particle.length = -1
		//PartSystem.remove(id)
	Next
	global dim PartSystem[-1] as sPartSystem
EndFunction




// save, load preset
Function SaveParticleSystemPreset(File$, auto)
	
	
	d$ =","
	e$ =";"
	
	// to save the particles system preset
	i = objID
	if ObjID >-1 and ObjID<= object.length
	
		if File$="" or auto=0
			File$ = "presets/particles/"+LAG_SaveFile("Save particle system preset","","")
			ext$ = GetExtensionFile(File$)
			File$ = ReplaceString(file$,ext$,"",1)+".txt"
		endif
		
		if file$ <> ""
			
			
			if GetFileExists(file$) and Options.Ok = 1 and auto =0
				answer = Lag_Message("File exists","Do you want to erase the file ? " + file$,"1|")
			endif
				
			if answer = LAG_ANSWER_YES
				fil = OpenToWrite(file$)
				
				txt$ = "; particle system for AGE"			
				writeline(fil,txt$)
				
				desc$ = "Description"
				
				if Object[i].stage[1].TextureId<= particle.length and Object[i].stage[1].TextureId>-1
					desc$ = particle[Object[i].stage[1].TextureId].filename$
				endif
				
				txt$ = "desc"+d$+desc$
				writeline(fil,txt$)
				
				txt$ = SaveParticleSystem(i,d$,e$)
				writeline(fil,txt$)

				CloseFile(fil)
			endif
			
		endif
	endif
	
EndFunction

Function LoadParticleSystemPreset(File$,auto)
	
	// to load particle system file
	
	d$ =","
	e$ =";"
	
	if auto=0 or File$=""
		File$ = LAG_OpenFile("Load PArticle system","presets/particles/","TXT|*.txt",0,-1,-1,0)
		ext$ = GetExtensionFile(File$)
		File$ = ReplaceString(file$,ext$,"",1)+"txt"
	endif
	
	if file$ <> ""
		
		//message("ouverture fichier atmosphere " + file$)
		if GetFileExists(file$)
			
			fil = OpenToRead(file$)
			
			if fil <> 0
				While FileEOF(fil)=0
				
					line$ = ReadLine(fil)
					Index1$ = GetStringToken(line$,",",1)
					//Index2$ = GetStringToken(line$,",",2)
					If Index1$ = "psys"
						
						ReadParticleSystem(line$,d$,e$) // ReadAtmospherDoc(index2$,d$,e$,mode)
						
					else
						// au cas où j'ajouterai autre chose (post-fx ??)
						
					endif
					
				endwhile
						
				CloseFile(fil)
				
				if auto = 0
					// SetSkyEditor()
				endif
			else
				message("Unable to load the file : "+file$)	
			endif
		else
			message("The file ' "+file$+" ' doesn't exist.")	
			
		endif
	else
		// message("Unable to load the file : "+file$)	
	endif
	
	
	
EndFunction




// load, save particle system
Function SaveParticleSystem(i,d$,e$)
	
	txt$ = "psys"+d$+object[i].name$+d$+str(object[i].x,2)+d$+str(object[i].y,2)+d$+str(object[i].z,2)+d$
	txt$ = txt$ +str(object[i].rx,1)+d$+str(object[i].ry,1)+d$+str(object[i].rz,1)+d$
	/*
	speed# = Object[ObjId].Rx
	speedmin# = Object[ObjId].Ry
	life = Object[ObjId].Rz
	*/
	// sx,sy,sz = taille en x,y,z
	txt$ = txt$ +str(object[i].Sx,1)+d$+str(object[i].Sy,1)+d$+str(object[i].Sz,1)+d$+str(object[i].Size,1)+d$
	
	
	// le blendmode
	txt$ = txt$ + str(object[i].Shader)+d$
	
	// l'image utilisée
	txt$ = txt$ + Particle[Object[i].stage[1].TextureId].Filename$ +e$+d$
						
	// color alpha
	txt$ = txt$ +str(object[i].R)+d$+str(object[i].G)+d$+str(object[i].B)+d$+str(object[i].Alpha)+d$
	
	// editor
	txt$ = txt$ +str(object[i].Hide)+d$+str(object[i].Locked)+d$
	
	// ombre lightmap, ao, Realtime, Utile ?
	txt$ = txt$+str(object[i].Shadow)+e$+str(object[i].ShadowCast)+str(object[i].Shadowrec)+e$+str(object[i].AO)+e$+d$
	
	//typ, w,h,l
	txt$ = txt$ +str(object[i].Typ)+d$+str(object[i].W)+d$+str(object[i].H)+d$+str(object[i].L)+d$
	
	
	//txt$ = txt$ +str(object[i].UVx,2)+d$+str(object[i].UVy,2)+d$+str(object[i].UVw)+d$+str(object[i].UVh)+d$
	
	//if object[i].UVw>1 or object[i].UVh >1
		//message("save : "+str(object[i].UVw)+"/"+str(object[i].UVh))
	//endif
	
	// L'id du model 3D
	//txt$ = txt$ +str(object[i].IdObj3D)+d$
	
	// La physic
	txt$ = txt$ +str(object[i].Physic)+e$+str(object[i].Shape)+e$+str(object[i].Mass)+e$+d$
	
EndFunction txt$

Function ReadParticleSystem(line$,d$,e$)

	
	u = 2
	name$ = GetStringToken(line$,d$,u)   : inc u

	// position
	x# = val(GetStringToken(line$,d$,u)) : inc u
	y# = val(GetStringToken(line$,d$,u))  : inc u
	z# = val(GetStringToken(line$,d$,u)) : inc u
	
	//rotation
	Rx = val(GetStringToken(line$,d$,u)) : inc u
	Ry = val(GetStringToken(line$,d$,u)) : inc u
	Rz = val(GetStringToken(line$,d$,u)) : inc u
	
	// scale
	Sx# = valfloat(GetStringToken(line$,d$,u)) : inc u
	Sy# = valfloat(GetStringToken(line$,d$,u)) : inc u
	Sz# = valfloat(GetStringToken(line$,d$,u)) : inc u
	Size#= valfloat(GetStringToken(line$,d$,u)) : inc u
	
	// blendmode, image
	bm = val(GetStringToken(line$,d$,u)) : inc u
	if bm <> 2
	endif
	Fn$ = GetStringToken(line$,d$,u) : inc u
	filename$ = GetStringToken(fn$,e$,1)
	For j=0 to particle.length
		// message(particle[j].Filename$ +"/"+Filename$)
		if particle[j].Filename$ = filename$											
			img = particle[j].img
			particle[j].used = 1
			TextureId = j
			exit
		endif
	next
	
	
	// R,g,b,alpha
	r = val(GetStringToken(line$,d$,u)) : inc u
	g = val(GetStringToken(line$,d$,u)) : inc u
	b = val(GetStringToken(line$,d$,u)) : inc u
	alpha = val(GetStringToken(line$,d$,u)) : inc u
	if alpha = 0 then alpha = 255
	
	// editor
	hide = val(GetStringToken(line$,d$,u)) : inc u
	lock = val(GetStringToken(line$,d$,u)) : inc u
	
	// shadow, shadoRt, Ao
	shadotot$ = GetStringToken(line$,d$,u) : inc u
	shadoLM = val(GetStringToken(shadotot$,e$,1)) 
	shadoCast = val(GetStringToken(shadotot$,e$,2)) 
	shadoREc = val(GetStringToken(shadotot$,e$,3)) 
	AO = val(GetStringToken(shadotot$,e$,4)) 
	
	// typ, w,h,l
	OBjTyp = C_OBJPARTSYS : inc u // val(GetStringToken(line$,d$,u)) : inc u
											
	w = val(GetStringToken(line$,d$,u)) : inc u
	h = val(GetStringToken(line$,d$,u)) : inc u
	l = val(GetStringToken(line$,d$,u)) : inc u

	if objId > -1 and ObjId <=object.length
	
		Object[ObjId].stage.length = 1
		Object[ObjId].stage[1].TextureId = TextureId									
		Object[ObjId].Typ = C_OBJPARTSYS
		
		id= Object[ObjId].IdObj3D
		
		Object[ObjId].sx = sx#
		Object[ObjId].sy = sy#
		Object[ObjId].sz = sz#
		Object[ObjId].size = size#
		Object[ObjId].rx = rx
		Object[ObjId].ry = ry
		Object[ObjId].rz = rz
		
		Object[ObjId].r = r
		Object[ObjId].g = g
		Object[ObjId].b = b
		
		// editor
		Object[ObjId].Hide = Hide
		Object[ObjId].Locked = lock
		
		// light, shadow
		Object[ObjId].Shader = bm
		Object[ObjId].Shadow = shadoLM
		Object[ObjId].ShadowCAst = shadoCAst
		Object[ObjId].ShadowRec = shadoRec
		Object[ObjId].AO = Ao
		
		
		// w,h,l
		Object[ObjId].w = w									
		Object[ObjId].h = h									
		Object[ObjId].l = l
		
		
		// puis, je définis le gadget
		// GetObjProp()
		// SetObjProp(mode)
		
		speed# = Object[ObjId].Rx
		speedmin# = Object[ObjId].Ry
		life = Object[ObjId].Rz
		SetPartSystemColor(id,Object[ObjId].r,Object[ObjId].g,Object[ObjId].b,Object[ObjId].alpha)
		SetPartSystemParam(id,sx#,sy#,sz#,-1,Object[ObjId].Size,speed#,speedmin#,life)
		SetPartSystemImg(object[Objid].IdObj3D,Particle[TextureId].img,bm)
	
	endif	


EndFunction




//Event 
Function EventFX()
	
	dist = 500
	for j=0 to PartSystem.Length
		if PartSystem[j].Particle.length < 0
			PartSystem.remove(j)
		else
		//if PartSystem[j].typ =1 or (abs(player.x-partsystem[j].x)<dist and abs(player.y-partsystem[j].y)<dist and abs(player.z-partsystem[j].z)<dist)
		if action <> C_ACTIONPLAY or (PartSystem[j].typ =1 or (abs(getcameraX(1)-partsystem[j].x)<dist and abs(getcameraY(1)-partsystem[j].y)<dist and abs(getcameraZ(1)-partsystem[j].z)<dist))
			For i=0 to PartSystem[j].Particle.length
				
					n = PartSystem[j].Particle[i].Obj
					SetObjectLookAt(n,getcameraX(1),getcameraY(1),getcameraZ(1),0) // position camera
					dec PartSystem[j].Particle[i].life
					select PartSystem[j].Typ
					
						case 0 // particules qui continuent (feu, fumée, pluie, neige...)
							if PartSystem[j].Particle[i].a >0 and PartSystem[j].Particle[i].life >=0
								SetObjectPosition(n,GetObjectX(n),GetobjectY(n)+PartSystem[j].Particle[i].speedY,GetObjectZ(n))
								PartSystem[j].Particle[i].a = PartSystem[j].Particle[i].a - PartSystem[j].Particle[i].decAlpha
								if PartSystem[j].Particle[i].a < 0
									PartSystem[j].Particle[i].a = 0
								endif
								SetObjectColor(n,PartSystem[j].Rc,PartSystem[j].Gc,PartSystem[j].Bc,PartSystem[j].Particle[i].a) 
								//if PartSystem[j].bm = 2
									//SetObjectColor(n,255,255,255,PartSystem[j].Particle[i].a) 
								//else
									// SetObjectColor(n,255,255,255,255) 
								//endif
							else
								a# = 0.2
								s# = 0.1*random(8*PartSystem[j].size,10*PartSystem[j].size)
								rndx = PartSystem[j].Randx
								rndy = PartSystem[j].Randy
								rndz = PartSystem[j].Randz
								x1# = PartSystem[j].x + a#*(random(0,rndx) - random(0,rndx))
								y1# = PartSystem[j].y 
								z1# = PartSystem[j].z + a#*(random(0,rndz) - random(0,rndz))
								PartSystem[j].Particle[i].a = PartSystem[j].Alpha
								PartSystem[j].Particle[i].Life = random(0,PartSystem[j].Particle[i].LifeMax)
								PartSystem[j].Particle[i].decAlpha = 255
								PartSystem[j].Particle[i].decAlpha = PartSystem[j].Particle[i].decAlpha/PartSystem[j].Particle[i].Life						
								SetObjectScale(n,s#,s#,s#)
								SetObjectPosition(n,x1#,y1#,z1#) 
							endif	
						endcase
						
						case 1 // explosion
							if PartSystem[j].Particle[i].a >0 and PartSystem[j].Particle[i].life >=0
								SetObjectPosition(n,GetObjectX(n)+PartSystem[j].Particle[i].speedx,GetobjectY(n)+PartSystem[j].Particle[i].speedY,GetObjectZ(n)+PartSystem[j].Particle[i].speedz)						
								PartSystem[j].Particle[i].a = PartSystem[j].Particle[i].a - PartSystem[j].Particle[i].decAlpha
								if PartSystem[j].Particle[i].a<0
									PartSystem[j].Particle[i].a =0
								endif
								SetObjectColor(n,255,255,255,PartSystem[j].Particle[i].a) 
							else							
								if PartSystem[j].looping = 0
									DeleteObject(n)
									PartSystem[j].Particle.remove(i)								
								else
									a# = 0.2
									s# = 0.1*random(8*PartSystem[j].size,10*PartSystem[j].size)
									rnd = PartSystem[j].Rand
									x1# = PartSystem[j].x + a#*(random(0,rnd) - random(0,rnd))
									y1# = PartSystem[j].y + a#*(random(0,rnd) - random(0,rnd)) 
									z1# = PartSystem[j].z + a#*(random(0,rnd) - random(0,rnd))
									sp1# = abs(PartSystem[j].SpeedMin)
									sp# = abs(PartSystem[j].Speed)
									PartSystem[j].Particle[i].speedX = random(0,sp#) *(1 -2*random(0,1)) *0.0025
									PartSystem[j].Particle[i].speedY = random(0,sp#) *(1 -2*random(0,1)) *0.0025
									PartSystem[j].Particle[i].speedZ = random(0,sp#) *(1 -2*random(0,1)) *0.0025
									PartSystem[j].Particle[i].a = 255
									PartSystem[j].Particle[i].Life = random(0,PartSystem[j].Particle[i].LifeMax )
									PartSystem[j].Particle[i].decAlpha = 255
									PartSystem[j].Particle[i].decAlpha = PartSystem[j].Particle[i].decAlpha/PartSystem[j].Particle[i].Life			
									SetObjectScale(n,s#,s#,s#)
									SetObjectPosition(n,x1#,y1#,z1#) 
								endif
							endif	
						endcase				
					
					endselect		
				
			next
		endif	
		endif 
	next 
	
	EventBullet()
	
		
EndFunction



