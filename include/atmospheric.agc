

//************** Sun, Fog, SkyBox ********************//
/*
Type tColor	
	r as integer
	g as integer
	b as integer
	a as integer
Endtype
*/

Type tFog
	
	r as integer
	g as integer
	b as integer
	Factor as integer
	SunCol as tColor	
	Min as integer
	Max as integer
	Active as integer
		
Endtype

Type tSun
	
	// color
	r as integer
	g as integer
	b as integer
	intensity as float
	//dir
	x as integer
	y as integer
	z as integer
	// other
	active as integer
	
Endtype

Type tSkyBox
	
	// skybox
	Active as integer
	Col as tColor
	
	// horizon 	
	HCol as tColor
	Horsize as integer
	HorHeight as integer
	
	// sun
	SunCol as tcolor	
	SunSize as integer
	HaloSize as integer
	SunVisible as integer
	
Endtype

Type tAmbient
	
	Active as integer
	r as integer
	g as integer
	b as integer
	factor as float // intensity of color
	
EndType

Type tShadow
	
	bias as float
	Active as integer
	Width as integer
	Height as integer
	Smooth as integer
	Typ as integer
	
	
endtype







// init
Function InitAtmospheric()
	
	Global Fog as tFog
	Global Sun as tSun
	Global SkyBox as tSkyBox
	Global Ambient as tAmbient
	Global Shado as tShadow
	
	ResetSky()
	
EndFunction


// Changes
Function ResetSky()
	
	Ambient.r = 60 
	Ambient.g = 120 
	Ambient.b = 255
	Ambient.factor = 1 
	Ambient.active = 1 
	
	/*
	Ambient.r = 112 
	Ambient.g = 118 
	Ambient.b = 125 
	*/
	SkyBox.Col.r = 40
	SkyBox.Col.g = 140
	SkyBox.Col.b = 255
	SkyBox.HCol.r = 70
	SkyBox.HCol.g = 170
	SkyBox.HCol.b = 255
	
	Sun.r = 255
	Sun.g = 120
	Sun.b = 0
	Sun.intensity = 1
	Sun.x = -5
	Sun.y = -2
	Sun.z = -5
	Sun.active = 1
	
	Fog.r = 255
	Fog.g = 255
	Fog.b = 255
	Fog.Max = 500
	Fog.Min = 150
	Fog.SunCol.r = 70
	Fog.SunCol.g = 70
	Fog.SunCol.b = 70
	
	Shado.Active = 0
	Shado.bias = 0
	Shado.Width = 1024
	Shado.Height = 1024
	Shado.Smooth = 0
	Shado.Typ = 3
	
	
EndFunction

Function UpdateSky()

	// Skybox
	SkyBox.Col.r = LAG_GetGadgetState(C_Gad_SkyR)
	SkyBox.Col.g = LAG_GetGadgetState(C_Gad_SkyG)
	SkyBox.Col.b = LAG_GetGadgetState(C_Gad_SkyB)
	SkyBox.Active = LAG_GetGadgetState(C_Gad_SkyOk)
	SkyBox.HCol.r = LAG_GetGadgetState(C_Gad_SkyHR)
	SkyBox.HCol.g = LAG_GetGadgetState(C_Gad_SkyHG)
	SkyBox.HCol.b = LAG_GetGadgetState(C_Gad_SkyHB)
	SetSkyBoxHorizonColor(SkyBox.HCol.r,SkyBox.HCol.g,SkyBox.HCol.b)
	SetSkyBoxSkyColor(SkyBox.Col.r,SkyBox.Col.g,SkyBox.Col.b)
	SetSkyBoxVisible(SkyBox.Active)	
	Options.showSkybox = SkyBox.Active
	
	// Sun
	Sun.r = LAG_GetGadgetState(C_Gad_SunR)
	Sun.g = LAG_GetGadgetState(C_Gad_SunG)
	Sun.b = LAG_GetGadgetState(C_Gad_SunB)
	Sun.x = valFloat(LAG_GetGadgetText(C_Gad_SunX))
	Sun.y = valFloat(LAG_GetGadgetText(C_Gad_SunY))
	Sun.z = valFloat(LAG_GetGadgetText(C_Gad_SunZ))
	Sun.active = LAG_GetGadgetState(C_Gad_SunOk)
	Sun.intensity = valfloat(LAG_GetGadgetText(C_Gad_SunInt))
	//s# = Sun.intensity
	Options.showSun = Sun.Active
	//SetSunColor(Sun.r*s#,Sun.g*s#,Sun.b*s#)
	//SetSunDirection(Sun.x,Sun.y,Sun.z)
	//SetSunActive(Sun.active)	
	//SetObjectSun()
	
	UpdateSun()
	
		
	// Fog 
	Fog.Active = LAG_GetGadgetState(C_Gad_FogOk)
	Options.ShowFog = Fog.Active
	Fog.R = LAG_GetGadgetState(C_Gad_FogR)
	Fog.G = LAG_GetGadgetState(C_Gad_FogG)
	Fog.B = LAG_GetGadgetState(C_Gad_FogB)
	Fog.Min = val(LAG_GetGadgetText(C_Gad_FogMin))
	Fog.Max = val(LAG_GetGadgetText(C_Gad_FogMax))
	SetFogMode(Fog.Active)	
	SetFogColor(Fog.r,Fog.g,Fog.b)
	SetFogRange(Fog.Min,Fog.Max)
	
	// Ambient
	Ambient.active = LAG_GetGadgetState(C_Gad_AmbOk)
	Ambient.r = LAG_GetGadgetState(C_Gad_AmbR)
	Ambient.g = LAG_GetGadgetState(C_Gad_AmbG)
	Ambient.b = LAG_GetGadgetState(C_Gad_AmbB)
	Ambient.factor = valfloat(LAG_GetGadgetText(C_Gad_AmbInt))
	s# = Ambient.factor * Ambient.active
	SetAmbientColor(Ambient.r*s#,Ambient.g*s#,Ambient.b*s#)
	
	// Shadow
	Shado.Active = LAG_GetGadgetState(C_Gad_SHADO_RT)
	Shado.bias = valFloat(LAG_GetGadgetText(C_Gad_SHADO_Bias))
	if Shado.bias<=0.00001
		Shado.bias = 0.001
	endif
	Shado.Width = val(LAG_GetGadgetText(C_Gad_SHADO_SizeW))
	Shado.Height = val(LAG_GetGadgetText(C_Gad_SHADO_SizeH))
	Shado.Smooth = val(LAG_GetGadgetText(C_Gad_SHADO_Smooth))
	Shado.Typ = val(LAG_GetGadgetText(C_Gad_SHADO_Type))
	UpdateShadow()
	
	SaveOptions()
	
	
EndFunction

Function SetSkyEditor()
	
	// ambient
	LAG_SetGadgetText(C_Gad_AmbInt,Str(Ambient.factor,2))
	LAG_SetGadgetState(C_Gad_AmbR,Ambient.r)
	LAG_SetGadgetState(C_Gad_AmbG,Ambient.g)
	LAG_SetGadgetState(C_Gad_AmbB,Ambient.b)
	LAG_SetGadgetState(C_Gad_AmbOk,Ambient.Active)
	
	// sky
	LAG_SetGadgetState(C_Gad_SkyR,SkyBox.Col.r )
	LAG_SetGadgetState(C_Gad_SkyG,SkyBox.Col.g )
	LAG_SetGadgetState(C_Gad_SkyB,SkyBox.Col.b )
	LAG_SetGadgetState(C_Gad_SkyOk,SkyBox.Active)
	
	LAG_SetGadgetState(C_Gad_SkyHR,SkyBox.HCol.r)
	LAG_SetGadgetState(C_Gad_SkyHG,SkyBox.HCol.g)
	LAG_SetGadgetState(C_Gad_SkyHB,SkyBox.HCol.b)
	
	// sun
	LAG_SetGadgetText(C_Gad_SunInt,str(Sun.intensity,2))
	LAG_SetGadgetState(C_Gad_SunR,Sun.r)
	LAG_SetGadgetState(C_Gad_SunG,Sun.g)
	LAG_SetGadgetState(C_Gad_SunB,Sun.b)
	
	LAG_SetGadgetText(C_Gad_Sunx,str(Sun.x))
	LAG_SetGadgetText(C_Gad_Suny,str(Sun.y))
	LAG_SetGadgetText(C_Gad_SunZ,str(Sun.z))
	LAG_SetGadgetState(C_Gad_SunOk,Sun.active)
	
	// fog
	LAG_SetGadgetState(C_Gad_FogR,Fog.r)
	LAG_SetGadgetState(C_Gad_FogG,Fog.g)
	LAG_SetGadgetState(C_Gad_Fogb,Fog.b)
	LAG_SetGadgetText(C_Gad_FogMin,str(Fog.Min))
	LAG_SetGadgetText(C_Gad_FogMax,str(Fog.Max))
	LAG_SetGadgetState(C_Gad_Fogok,Fog.Active)
	
	// shadow
	if shado.bias< 0.00001
		shado.bias = 0.001
	endif
	LAG_SetGadgetText(C_Gad_SHADO_Bias,str(shado.bias))
	LAG_SetGadgetText(C_Gad_SHADO_SizeH,str(shado.Height))
	LAG_SetGadgetText(C_Gad_SHADO_SizeW,str(shado.Width))
	LAG_SetGadgetText(C_Gad_SHADO_Smooth,str(shado.Smooth))
	LAG_SetGadgetText(C_Gad_SHADO_Type,str(shado.Typ))
	LAG_SetGadgetState(C_Gad_SHADO_RT,shado.Active)
	
EndFunction




// update
Function UpdateSkyBox()
	
	// Skybox
	SetSkyBoxVisible(SkyBox.Active)
	SetSkyBoxSkyColor(SkyBox.Col.r,SkyBox.Col.g,SkyBox.Col.b)
	SetSkyBoxHorizonColor(SkyBox.HCol.r,SkyBox.HCol.g,SkyBox.HCol.b)
	
	// SetSkyBoxSunColor()
	// SetSkyBoxSunSize
	// SetSkyBoxSunVisible(Sun.active)
	
EndFunction

Function UpdateSun()
	
	// Sun
	s# = Sun.intensity
	SetSunColor(Sun.r*s#,Sun.g*s#,Sun.b*s#)
	SetSunDirection(Sun.x,Sun.y,Sun.z)
	SetSunActive(Sun.active)
	
	SetObjectSun()
	
	
EndFunction

Function SetObjectSun()
	
	//ax = atan2(sqrt(sun.y^2+sun.z^2),sun.x)
	//ay = atan2(sqrt(sun.z^2+sun.x^2),sun.y)
	//az = atan2(sqrt(sun.x^2+sun.y^2),sun.z)
	//SetObjectLookat(oSun, ay, ax, az,0)	
	SetObjectLookat(oSun, Sun.x, Sun.y, Sun.z,0)	

	
	
endfunction



Function UpdateFog()
	
	// Fog
	SetFogMode(Fog.Active)	
	SetFogColor(Fog.r,Fog.g,Fog.b)
	SetFogRange(Fog.Min,Fog.Max)
	
EndFunction

Function UpdateAmbient()
	
	//Ambient
	s# = Ambient.factor * Ambient.Active	
	SetAmbientColor(Ambient.r*s#,Ambient.g*s#,Ambient.b*s#)
	
EndFunction

Function UpdateShadow()
	
	if Shado.Active = 0
		SetShadowMappingMode(0)
	else
		if Shado.Width > 16 and Shado.Height > 16
			Shado.Typ = Max(Shado.Typ,3)
			Shado.Typ = Min2(Shado.Typ,1)
			SetShadowMappingMode(Shado.Typ)
			SetShadowBias(Shado.bias)
			SetShadowMapSize(Shado.Width, shado.Height)
			SetShadowSmoothing(shado.Smooth)
		endif
	endif
	
	
endfunction


Function UpdateAtmosphere()
	
	UpdateSkyBox()
	UpdateSun()
	UpdateFog()
	UpdateAmbient()
	UpdateShadow()
	
Endfunction 1







// save, load
Function WriteAtmosphereDoc(d$,e$,mode)

	//	 d'abord, je vérifie si tout est ok
	Ambient.Active = Max(Ambient.Active,1)
	Ambient.Active = Min2(Ambient.Active,0)
	Fog.Active = Max(Fog.Active,1)
	Fog.Active = Min2(Fog.Active,0)
	Sun.Active = Max(Sun.Active,1)
	Sun.Active = Min2(Sun.Active,0)
	Skybox.Active = Max(Skybox.Active,1)
	Shado.Active = Max(Shado.Active,2)
	Shado.Active = Min2(Shado.Active,0)
	
	//create txt$ string		
	SkyBox$ = str(SkyBox.Active)+e$+str(SkyBox.Col.r)+e$+str(SkyBox.Col.g)+e$+str(SkyBox.Col.b)+e$
	SkyBox$ = SkyBox$ +str(SkyBox.HCol.r)+e$+str(SkyBox.HCol.g)+e$+str(SkyBox.HCol.b)+e$+str(SkyBox.HorHeight)+e$+str(SkyBox.Horsize)+e$
	SkyBox$ = SkyBox$ +str(SkyBox.SunCol.r)+e$+str(SkyBox.SunCol.g)+e$+str(SkyBox.SunCol.b)+e$+str(SkyBox.SunVisible)+e$+str(SkyBox.SunSize)+e$+str(SkyBox.HaloSize)+e$
	
	Sun$ = str(Sun.Active)+e$+str(Sun.r)+e$+str(Sun.g)+e$+str(Sun.b)+e$+str(Sun.x)+e$+str(Sun.y)+e$+str(Sun.z)+e$+str(Sun.intensity,4)+e$

	Fog$ =str(Fog.Active)+e$+str(Fog.r)+e$+str(Fog.g)+e$+str(Fog.b)+e$+str(Fog.Min)+e$+str(Fog.Max)+e$+str(Fog.SunCol.r)+e$+str(Fog.SunCol.g)+e$+str(Fog.SunCol.b)+e$
	
	Ambient$ = str(Ambient.r)+e$+str(ambient.g)+e$+str(ambient.b)+e$+str(ambient.factor,4)+e$+str(ambient.Active)+e$
		
	
	if Shado.width <=16
		Shado.width = 512
	endif	
	if Shado.height <=16
		Shado.height = 512
	endif	
	if Shado.bias<=0.00001
		Shado.bias = 0.001
	endif	
	Shado$ = str(Shado.Active)+e$+str(Shado.bias)+e$+str(Shado.Width)+e$+str(Shado.Height)+e$+str(Shado.Smooth)+e$+str(Shado.Typ)+e$
		
		
	if mode =0 // on sauve tout : skybox,sun,ambient,fog
		txt$ = Fog$+d$+Sun$+d$+Skybox$+d$+Ambient$+d$+Shado$+d$		
	
	elseif mode = 1 // save the skybox only
		txt$ = Skybox$+d$
	
	Elseif mode = 2 // save the sun only
		txt$ = Sun$+d$
	
	elseif mode = 3 // save the fog only
		txt$ = Fog$+d$
	
	elseif mode = 4 // save the ambient only
		txt$ = Ambient$+d$	
	endif 	


	
	
	txt$ = ReplaceAllString(txt$) // in document.agc	


EndFunction txt$

Function ReadAtmospherDoc(info$,d$,e$,mode)
	
	// pour lire les parametres de l'atmosphere
	
	/*
	SKYBOX$ = STR(SKYBOX.ACTIVE)+E$+STR(SKYBOX.COL.R)+E$+STR(SKYBOX.COL.G)+E$+STR(SKYBOX.COL.B)+E$
	SKYBOX$ = SKYBOX$ +STR(SKYBOX.HCOL.R)+E$+STR(SKYBOX.HCOL.G)+E$+STR(SKYBOX.HCOL.B)+E$+STR(SKYBOX.HORHEIGHT)+E$+STR(SKYBOX.HORSIZE)+E$
	SKYBOX$ = SKYBOX$ +STR(SKYBOX.SUNCOL.R)+E$+STR(SKYBOX.SUNCOL.G)+E$+STR(SKYBOX.SUNCOL.B)+E$+STR(SKYBOX.SUNVISIBLE)+E$+STR(SKYBOX.SUNSIZE)+E$+STR(SKYBOX.HALOSIZE)+E$
	
	SUN$ = STR(SUN.ACTIVE)+E$+STR(SUN.R)+E$+STR(SUN.G)+E$+STR(SUN.B)+E$+STR(SUN.X)+E$+STR(SUN.Y)+E$+STR(SUN.Z)+E$+STR(SUN.INTENSITY)+E$

	FOG$ =STR(FOG.ACTIVE)+E$+STR(FOG.R)+E$+STR(FOG.G)+E$+STR(FOG.B)+E$+STR(FOG.MIN)+E$+STR(FOG.MAX)+E$+STR(FOG.SUNCOL.R)+E$+STR(FOG.SUNCOL.G)+E$+STR(FOG.SUNCOL.B)+E$
	
	AMBIENT$ = STR(AMBIENT.R)+E$+STR(AMBIENT.G)+E$+STR(AMBIENT.B)+E$
		
	IF MODE =0 // ON SAUVE TOUT : SKYBOX,SUN,AMBIENT,FOG
		TXT$ = FOG$+D$+SUN$+D$+SKYBOX$+D$+AMBIENT$+D$		
	*/
	
	// message("je lis les infos du fichier atmosphere " + info$)
	
	Fog$ = GetStringToken(info$,d$,1)
	u = 1
	FOG.ACTIVE = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.r = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.g = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.b = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.min = valFloat(GetStringToken(FOG$,e$,u)) : inc u
	FOG.max = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.SUNCOL.r = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.SUNCOL.g = val(GetStringToken(FOG$,e$,u)) : inc u
	FOG.SUNCOL.b = val(GetStringToken(FOG$,e$,u)) : inc u
	
	u=1
	Sun$ = GetStringToken(info$,d$,2)
	SUN.ACTIVE = val(GetStringToken(Sun$,e$,u)) : inc u
	SUN.R = val(GetStringToken(Sun$,e$,u)) : inc u
	SUN.g = val(GetStringToken(Sun$,e$,u)) : inc u
	SUN.b = val(GetStringToken(Sun$,e$,u)) : inc u
	SUN.x = valFloat(GetStringToken(Sun$,e$,u)) : inc u
	SUN.y = valFloat(GetStringToken(Sun$,e$,u)) : inc u
	SUN.z = valFloat(GetStringToken(Sun$,e$,u)) : inc u
	SUN.INTENSITY = valFloat(GetStringToken(Sun$,e$,u)) : inc u
	//message("sun : "+sun$)
	 
	u=1
	Skybox$ = GetStringToken(info$,d$,3)
	SKYBOX.ACTIVE = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.COL.R = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.COL.g = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.COL.b = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HCOL.R = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HCOL.g = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HCOL.b = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HORHEIGHT = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HORSIZE = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.SUNCOL.R = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.SUNCOL.g = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.SUNCOL.b = val(GetStringToken(Skybox$,e$,u)) : inc u
	
	SKYBOX.SUNVISIBLE = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.SUNSIZE = val(GetStringToken(Skybox$,e$,u)) : inc u
	SKYBOX.HALOSIZE = val(GetStringToken(Skybox$,e$,u)) : inc u
	
	//message("Skybox : "+Skybox$)
	
	u=1
	Ambient$ = GetStringToken(info$,d$,4)
	AMBIENT.R = val(GetStringToken(Ambient$,e$,u)) : inc u
	AMBIENT.g = val(GetStringToken(Ambient$,e$,u)) : inc u
	AMBIENT.b = val(GetStringToken(Ambient$,e$,u)) : inc u
	AMBIENT.factor = valfloat(GetStringToken(Ambient$,e$,u)) : inc u
	AMBIENT.factor = val(GetStringToken(Ambient$,e$,u)) : inc u
	if Ambient.factor = 0
		Ambient.FActor = 1
	endif
	
	//message("Ambient : "+Ambient$)
	
	
	u=1
	Shado$ = GetStringToken(info$,d$,5)
	
	ShadoActive = val(GetStringToken(Shado$,e$,u)) : inc u
	Shadobias = ValFloat(GetStringToken(Shado$,e$,u)) : inc u
	ShadoWidth = val(GetStringToken(Shado$,e$,u)) : inc u
	ShadoHeight = val(GetStringToken(Shado$,e$,u)) : inc u
	ShadoSmooth = val(GetStringToken(Shado$,e$,u)) : inc u
	ShadoTyp = val(GetStringToken(Shado$,e$,u)) : inc u
	if Shado.bias<=0.00001
		Shado.bias = 0.001
	endif
	
	if ShadoWidth >= 16 and ShadoHeight >= 16
		Shado.Active = ShadoActive
		Shado.bias = Shadobias
		Shado.Width = ShadoWidth
		Shado.Height = ShadoHeight
		Shado.Smooth = ShadoSmooth
		Shado.Typ = ShadoTyp
	endif
	
	
	if mode =0 // on update tout : skybox,sun,ambient,fog
		ok = UpdateAtmosphere()
			
	elseif mode = 1 // update the skybox only
		UpdateSkyBox()
	
	Elseif mode = 2 // save the sun only
		UpdateSun()
	
	elseif mode = 3 // save the fog only
		UpdateFog()
	
	elseif mode = 4 // save the ambient only
		UpdateAmbient()
	endif 	
	
Endfunction ok



Function SaveAtmosphere(file$,auto,mode)

	d$ =","
	e$ =";"
	
	// mode = 0 -> save full atmosphere, mode =1 : only skybox, 2 = only sun, 3 =only fog, 4 =only ambient


	// to save fog,skybox,sun,ambient...
	if File$="" or auto=0
		File$ = "atmosphere/"+LAG_SaveFile("Save Atmosphere preset","","")
		ext$ = GetExtensionFile(File$)
		File$ = ReplaceString(file$,ext$,"",1)+".txt"
	endif
	
	if file$ <> ""
		
		
		if GetFileExists(file$) and Options.Ok = 1 and auto =0
			answer = Lag_Message("File exists","Do you want to erase the file ? " + file$,"1|")
		endif
			
		if answer = LAG_ANSWER_YES
			fil = OpenToWrite(file$)
				
			txt$ = "Atmos/"+WriteAtmosphereDoc(d$,e$,mode)
			writeline(fil,txt$)

			CloseFile(fil)
		endif
		
	endif
	
EndFunction

Function LoadAtmosphere(File$,auto,mode)

	// to load an atmospheric file (skybox,sun,fog,ambient)
	
	d$ =","
	e$ =";"
	
	if auto=0 or File$=""
		File$ = LAG_OpenFile("Load Atmosphere","atmosphere/","TXT|*.txt",0,-1,-1,0)
		ext$ = GetExtensionFile(File$)
		File$ = ReplaceString(file$,ext$,"",1)
		File$ = ReplaceString(file$,".","",1)
		
	endif
	
	
	if file$ <> ""
		
		if auto = 0
			file$ = file$ +".txt"
		endif
		
		//message("ouverture fichier atmosphere " + file$)
		if GetFileExists(file$)
			
			fil = OpenToRead(file$)
			
			if fil <> 0
				While FileEOF(fil)=0
				
					line$ = ReadLine(fil)
					Index1$ = GetStringToken(line$,"/",1)
					Index2$ = GetStringToken(line$,"/",2)
					If Index1$ = "Atmos"
											
						Options.AtmosphereOK = ReadAtmospherDoc(index2$,d$,e$,mode)
						
					else
						// au cas où j'ajouterai autre chose (post-fx ??)
						
					endif
					
				endwhile
						
				CloseFile(fil)
				
				if auto = 0
					SetSkyEditor()
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
	
	

Endfunction





// Openwindow atmosphere
Function OpenWindowAtmosphere()
	
	
	FoldStart // Create the Window
	w = 400
	h = 600
	OldAction = action
	Action = C_ACTIONSELECT
	Lag_OpenWindow(C_WINBehavior,G_width/2-w/2,g_height/2-h/2,w,h,"Behavior",0)
	
	// then, Add the gadget for the behavior editor
	w1 = 80 : h1 = 30
	
	//LAG_ButtonGadget(C_Gad_BehaviorOk,w-w1-10,h-h1-5,w1,h1,"OK",0)
	xx = 10 : yy = 10
	LAG_ListIconGadget(C_Gad_ListBehavior,xx,yy,250,300) : yy=yy +310 
	
	LAg_AddItemToListIcon("atmosphere","txt",C_Gad_ListBehavior)
	
	
	yy = h-h1-5
	LAG_ButtonGadget(C_Gad_BehaviorOk,xx,yy,w1,h1,"Ok",0) : xx = xx + w1 +5
	LAG_ButtonGadget(C_Gad_BehaviorCancel,xx,yy,w1,h1,"Cancel",0)
	
	

	Foldend
	
	
	repeat
				
		eventwindow = LAG_EventWindow()
		LAG_EventType()
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
		
		else // if eventwindow = LAG_C_EventGadget
			
			eventgadget = LAg_eventgadget()
					
			If GetPointerReleased() or LAG_Event_Type = LAG_C_EVENTTYPEMOUSERELEASED					
				
				select eventgadget 
					case C_Gad_BehaviorOk
						
					endcase
					case C_Gad_BehaviorCancel
						
					endcase
				endselect
			endif
			
		endif
		
		EventBehavior()
					
		sync()
	until quit>= 1
		
		
	FoldStart 
		
		LAG_CloseWindow(C_WINBehavior)
		//action = OldAction
		//Undim TempFile$[] : undim TempImg[] 
		
	FoldEnd
	
	
EndFunction


