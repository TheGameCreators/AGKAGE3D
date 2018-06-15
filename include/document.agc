
//************ document & file : save, open, load, new...

Type tDocument
	
	Name$
	FileName$ // the name when saving
	ExportName$
	Path$
	Date$
	
EndType

Type tLibImage
	
	id as integer
	Newid as integer // if image/shader or model isn't add to the lib
	//Used as integer
	Filename$ 
	wrap as integer
	
endtype

type tGame 
	
	Name$
	Version$
	
endtype







// init 
Function InitDoc()


	Global Doc as tDocument
	Global Game as tGame
	
	Global ObjId,ObjTyp,AssetTyp,TextureId,Action,ShaderId  as integer
	
	Global LoadDoc // to know if we load a doc
	
	
	NewDoc(1)

	

EndFunction





// New, reset
Function NewDoc(auto)
	
	//to create a new Document
	if auto = 0
		If Use_Lag =1
			answer = LAG_message("NEW","Erase all the objects, light, cameras... ?"+chr(10)+"This can't be undo.","1") 
		endif
			
			if answer = LAG_ANSWER_NO 
					
				exitfunction 
					
			endif
		
	endif
	
		
	FoldStart // delete all
			
				
			// ------ Objects 3D
			For i=0 to Object.length
				DeletetheObject(i)				
			next
			Global Dim Object[] as sObject
			
			NbWater = -1 // on reset le nombre de water
			
			
			// ------ Lights
			For i=0 to light.length
				DeleteObject(light[i].Obj)
				DeletePointLight(i+1)
			next
			Global Dim Light[] as tLight
			
			// ------ Camera
			
			// ------ Fx- particles
			DeleteAllPartSystem()
			
			// ------ GamePlay assets
			DeleteAllbehavior()
			
			// ------ Turn off fog, sun, skybox
			If Options.AtmosphereOK = 0
			
				SetFogMode(0)			
				SetSkyBoxVisible(0)			
				SetSunActive(1)
				SetSunDirection(sun.x,sun.y,sun.z)
				//SetSunDirection(112,21,245)
				SetSunColor(sun.r,sun.g,sun.b)
				
				SetSkyBoxSkyColor(SkyBox.Col.r,SkyBox.Col.g,SkyBox.Col.b)
				SetSkyBoxHorizonColor(SkyBox.HCol.r,SkyBox.HCol.g,SkyBox.HCol.b)
				SetAmbientColor(Ambient.r,Ambient.g,Ambient.b)
			endif
			
			if Use_Lag
				SetSkyEditor()
			else
				
			endif
			/*
			SetSunDirection(5,0,-1)
			SetSunColor(250,202,146)
			*/		
			
			
			
			// ------ CAMERA 
			// MoveCameraLocalZ(1,-9)
			// RotateCameraGlobalY(1,180)
			// SetCameraLookAt(1,0,2,0,0)
		
			// ------ LIGHTS
			//AddLight(10,5,5,50,255,155,0,-1,1)
			//AddLight(-100,5,-100,95,120,180,250,-1,1) 
			
			// ------ 	Reset variables
			AssetTyp = 0 // assetType 0 = model3D, 1 = light, 2 =camera, 3 = fx(particle), 4 = start....
			
			ObjId = -1 // The Id of the object. it depends of the type. Ex : objId = 1 & AssetTyp = 1 it's the light N°1 // l'id de l'objet (en fonction du type)
			
			ObjTyp = 0 // The type of object : box, sphere,capsule, cone, cylinder, terrain, water, object from the bank (background, action, NPC, MOnster, FX, player... // le type d'objet : decor, action, pnj, mob, fx...
			
			// TextureId = 0
			
			ShaderId =2
			
			TheObjectLightMAp = -1	
			
			// ------ Reset the document informations
			ResetDoc()
			
			NewBankPreset()
			
			
			
			Foldend
	
	//LAG_ResetPanel(C_Gad_PanelL) // in lag_panelgadget.agc
	//LAG_ResetPanel(C_Gad_PanelR) 
	
EndFunction

Function ResetDoc()
	
	// reset the doc
	Doc.Name$ ="Untitled"
	Doc.Path$ =""
	Doc.FileName$ =""
	
	SetWindowTitle(C_PROGRAM_NAME + " v"+C_VERSION + " - "+Doc.Name$)
	
	// reset the game information
	Game.Name$ = ""
	Game.Version$ = ""
	
	
	// ResetTextureBank()
	
	// reset the list of object
	Lag_FreeallGadgetItemByGadget(C_Gad_SelectList)
	
EndFunction





// save, export
Function SaveTheBank(all)
	
	// save the bank : image & models
	
	// if all = 0 : on prend uniquement les models utilisés, si = 1 on prend tout (c'est pour savebankpreset)
	
	
	//** d'abord, je vérifie les images qu'on utilise dans le jeu
	Dim LibImage[] as tLibImage
	
	
	
	
	// d'abord, on vérifie les textures utilisées
	For j= 0 to object.length
		
		for b=0 to Object[j].stage.length
			
			k = Object[j].stage[b].TextureId
			Object[j].stage[b].LibImg = -1
			
			
			if k>=0 and k <= texture.length					
				Texture[k].Used = 1
				Object[j].stage[b].ImgName$ = Texture[k].Filename$
				
				// new technic 
				// check if we have this image in our libImage
				found = 0
				For n = 0 to LibImage.length
					if LibImage[n].Filename$ = Texture[k].Filename$	
						found = 1
						Object[j].stage[b].LibImg = LibImage[n].id
						exit
					endif
				next
				
				// not found
				if found = 0
					n = LibImage.length+1
					Dim LibImage[n] as tLIbImage
					LibImage[n].id = k
					LibImage[n].Filename$ = Texture[k].Filename$
					LibImage[n].wrap = Texture[k].wrap
					Object[j].stage[b].LibImg = LibImage[n].id
				endif
			
				
			endif
		next
	
	next
	
	// puis, on sauvegarde la libimage, en fonction de ces textures
	/* // old technic
	For k=0 to Texture.length
		if Texture[k].Used = 1				
			n = libImage.length +1
			Dim LibImage[n] as tLIbImage
			LibImage[n].id = k
			LibImage[n].Filename$ = Texture[k].Filename$							
		endif
	next
	*/	
		
		
		
		
	foldstart //** Model 3D
	
	
	
	Dim LibModel[] as tLibImage
	
	For i=0 to BankModel.length
		BankModel[i].Used = 0
	next
	
	// on vérifie les models utilisés
	For j= 0 to object.length
		if Object[j].Typ = C_OBJBANK
			k = Object[j].IdObj3D
			if k>=0 and k <= BankModel.length					
				BankModel[k].used = 1
			endif
		endif
	next
	
	
		
	// puis, on sauvegarde la bankmodel, en fonction de ces modeles utilisés
	For k=0 to BankModel.length
		if BankModel[k].Used = 1 or all = 1				
			n = LibModel.length +1
			Dim LibModel[n] as tLIbImage
			LibModel[n].id = k
			LibModel[n].Filename$ = BankModel[k].name$							
		endif
	next
	
	
	foldend
	
	
	FoldStart //** Shaders
	
	Dim LibShader[] as tLibImage
	
	// check the shader used
	For j= 0 to object.length
			
		k = Object[j].Shader
		
		if k>=0 and k <= ShaderBank.length					
			
			ShaderBank[k].Used = 1
			
			// check if we have this image in our libImage
			found = 0
			For n = 0 to LibShader.length
				if LibShader[n].Filename$ = ShaderBank[k].Filename$	
					found = 1
					exit
				endif
			next
			
			// not found, add the shader to the save array for shaders
			if found = 0
				n = LibShader.length+1
				Dim LibShader[n] as tLIbImage
				LibShader[n].id = k
				LibShader[n].Filename$ = ShaderBank[k].Filename$
			endif
			
		endif
		
	next
	
	Foldend
	
	
	
	
	
EndFunction


Function SaveFileRequester(title$, file$)
	
	
	FoldStart // create the sprite and text 
		
		width = 400
		height = 200
		i = LAG_CreateMenuBox(G_width/2-width/2, G_height/2-height/2, width, height, LAG_C_ICORNER, 255)
		Menu = LAG_GetMenuboxSprite(i)
		
		// Boutons - buttons
		local MessageBtn1,w1,h1,h2,btnok,btnNo,btnCancel,txt2,txt3,txt4 as integer

		FontId = LAG_FontId2
		MessageBtn1 =  LAG_i_Gadget[LAG_C_IBUTTON] 
		w1 = GetImageWidth(MessageBtn1)+20
		h1 = 40
		h2 = GetImageHeight(MessageBtn1)
		
		btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-w1-2,GetSpriteY(Menu)+height-40,1,0)
		SetSpriteSize(btnok,w1,h2)
		btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2+2, GetSpriteY(Menu)+height-40,1,0)
		SetSpriteDepth(btnNo,0)
		SetSpriteSize(btnNo,w1,h2)
		
		// texts					
		txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"OK",FontId,20,0)
		SetTextAlignment(txt2, 1)
		txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"CANCEL",FontId,20,0)
		SetTextAlignment(txt3, 1)
		
		
		// title
		// title$ = "Save the document"
		txttitle = LAg_AddTextFix(GetSpriteX(Menu)+width/2,GetSpriteY(Menu)+5,title$,FontId,30,0)
		SetTextAlignment(txttitle,1)


		img = LAG_i_Gadget[LAG_c_iString]
		w = 200
		h = 25
		y = GetSpriteY(Menu)+50
		x = GetSpriteX(Menu)+width/2-w/2
		Editbox = LAG_AddEditBox(img,x,y,w,h,1,0,1,"")
		
		SetEditBoxText(EditBox, File$)
		SetEditBoxTextColor(EditBox,255,255,255)
		
		
	Foldend
						
	repeat
		
		If GetRawKeyPressed(KEY_ESCAPE)
			quit = 1
		endif
	
		mx = ScreenToWorldX(GetPointerX())
		my = ScreenToWorldY(GetPointerY())

		if GetPointerReleased() = 1
			
			butonTest = GetSpriteHit(mx,my)
			
			if butonTest = btnok
				quit = 2
									
			elseif butonTest = btnNo 
				quit = 1
									
			endif
				
		endif
		
		sync()
		
	until quit >= 1
			
	foldstart  // free ressources
	
		txt$ = GetEditBoxText(editbox)
		txt$ = replacestring(txt$,"scenes\","",1)
		
		DeleteSprite(btnok)
		DeleteText(txt3)
		DeleteText(txt2)
		DeleteText(txttitle)	
		DeleteText(txt3)
        DeleteSprite(btnNo)
		DeleteEditBox(editbox)
		LAG_FreeMenuBox(i)
		sync()
	foldend
	
	
	
endfunction txt$

Function SaveDoc(saveas)
	
	
	
	// to save the document
	
	
	// needed to not keep the ctrl key presed
	if Ctrl = 1
		While quit =0
			If GetRawKeyReleased(key_control)=1
				quit = 1
				ctrl = 0
			endif
			//sync()
		EndWhile
	endif
	
	quit = 0
	
	
	
	
	// check to knwo the name for saving
	if doc.FileName$ ="" or saveas = 1
		
		FoldStart // savefilerequester : create the interface & repeat & free ressources
			
			FileName$ = SaveFileRequester("Save the document", doc.FileName$)
			
			if fileName$ = ""
				exitfunction
			else
				doc.FileName$ = filename$
				quit = 2
			endif
			
		FoldEnd		
	
	else
		quit = 2
	endif



	// then save the document
	Foldstart 
	
	if doc.FileName$ <> "" and quit = 2
		
		// extension of the file
		If Lower(GetExtensionFile(doc.FileName$)) <> "age"
			ext$=".age"
		endif
		
		
		if saveas = 1
			// verify if the file exists
			if GetFileExists(doc.FileName$) =1 or GetFileExists("scenes\"+doc.FileName$) = 1
				Answer = LAG_message("Info","The file "+doc.FileName$+" exists. Do you want to replace it ?","1|")
				if answer = LAG_ANSWER_NO 				
					exitfunction 
				endif
			endif
		endif
			
		
		// erase the folder, in the name : not finished !!!		 
		doc.FileName$ = replacestring(doc.FileName$,"scenes\","",1)
		
		//if FindString(doc.FileName$, "autosave") = 0
			
		//endif
		
		d$ = ","
		e$ = ";"
		f$ = "/"
		
		// message("we save the level ")
		
		FoldStart // save the lib : image, model, shader
		
		SaveTheBank(0)
		
		Foldend
		
		
		
		// then save the document
		fil = OpenToWrite("scenes\"+doc.FileName$+ext$)
		
		//message(doc.FileName$)
		
		
		if fil <> 0
			
			SetWindowTitle(C_PROGRAM_NAME + " v"+C_VERSION + " - "+doc.FileName$)
			
			
			// general info
			writeline(fil,"; General informations")
			txt$ = "General"+d$+C_version+d$+GetCurrentDate()+d$
			writeline(fil,txt$)
			
			// Game info
			writeline(fil,"; Game informations")
			txt$ = "Game"+d$+Game.Name$+d$+Game.Version$+d$
			writeline(fil,txt$)
			
			
			//** save the image for the level
			writeline(fil,"; Images used in the level")
			For i=0 to libImage.length
				// old : txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
				txt$ = "Img"+d$ + str(LibImage[i].id)+ d$+libImage[i].Filename$ +d$ 
				writeline(fil,txt$)
			next
			
			
			//** save the Shader for the level
			writeline(fil,"; Shader used in the level")
			For i=0 to LibShader.length
				// old : txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
				txt$ = "shader"+d$ +str(i)+ d$+str(LibShader[i].id)+d$+LibShader[i].Filename$ +d$ 
				writeline(fil,txt$)
			next
			
			
			//** save the models
			writeline(fil,"; Models used in the level")
			For i=0 to libModel.length
				txt$ = "Model"+ d$ + str(LibModel[i].id) + d$ + libModel[i].Filename$ + d$
				writeline(fil,txt$)
			next
			
			
			//** save atmosphere (sun, skybox,fog, ambient) level : sun,skybox,fog,ambient
			writeline(fil,"; Atmospheric effects")
			txt$ = "Atmos"+d$+ WriteAtmosphereDoc(d$,e$,0) // Fog$+d$+Sun$+d$+Skybox$+d$+Ambient$+d$		
			writeline(fil,txt$)	
			
			
			
			//** lights
			writeline(fil,"; Lights")
			For i=0 to light.length
				
				txt$ = "Light"+d$+light[i].name$+d$+str(light[i].x,2)+d$+str(light[i].y,2)+d$+str(light[i].z,2)+d$			
				txt$ = txt$ +str(light[i].R)+d$+str(light[i].G)+d$+str(light[i].B)+d$+str(light[i].Radius)+d$+str(light[i].Intensity,2)+d$			
				txt$ = txt$ +str(light[i].Hide)+d$+str(light[i].Locked)+d$+str(light[i].Shadow)+d$
				
				writeline(fil,txt$)			
			next
			
			
			
			
			//** objects
			writeline(fil,"; Objects")	
			For i=0 to Object.length
				
				Select Object[i].Typ
					
					case C_OBJPARTSYS
						
						txt$ = SaveParticleSystem(i,d$,e$)
						
					endcase
					
					case default
						
						// name
						txt$ = "object"+d$+object[i].name$+d$
						
						FoldStart // position
						txt$ = txt$ +str(object[i].x,2)+d$+str(object[i].y,2)+d$+str(object[i].z,2)+d$
						
						// rot
						txt$ = txt$ +str(object[i].Rx,2)+d$+str(object[i].ry,2)+d$+str(object[i].rz,2)+d$
						
						// size
						txt$ = txt$ +str(object[i].Sx,2)+d$+str(object[i].Sy,2)+d$+str(object[i].Sz,2)+d$+str(object[i].Size,2)+d$
						
						Foldend
						
						FoldStart // shader, img, color
						// shader
						txt$ = txt$ +str(object[i].Shader)+d$
						
						// image & stage
						NbImgForObj$ = ""
						for qq = 0 to object[i].Stage.length							
							id = object[i].Stage[qq].LibImg
							txt1$ = str(id)+e$+str(object[i].Stage[qq].UVx,2)+e$+str(object[i].Stage[qq].UVy,2)+e$+str(object[i].Stage[qq].UVw,2)+e$+str(object[i].Stage[qq].UVh,2)+e$
							NbImgForObj$ = NbImgForObj$ +txt1$+f$
						next			
						txt$ = txt$ + NbImgForObj$ + d$
						
						// color alpha
						txt$ = txt$ +str(object[i].R)+d$+str(object[i].G)+d$+str(object[i].B)+d$+str(object[i].Alpha)+d$
						
						foldend
						
						FoldStart // editor, shado, typ/w,h,l
						
						// editor
						txt$ = txt$ +str(object[i].Hide)+d$+str(object[i].Locked)+d$
						
						// ombre lightmap, ao, Realtime
						txt$ = txt$+str(object[i].Shadow)+e$+str(object[i].ShadowCast)+e$+str(object[i].ShadowRec)+e$+str(object[i].AO)+e$+str(object[i].normalmap)+e$+str(object[i].lightmap)+e$+str(object[i].FogMode)+e$+str(object[i].Lightmode)+e$+str(object[i].visibleInGame)+e$+d$
						
						//typ, w,h,l
						txt$ = txt$ +str(object[i].Typ)+d$+str(object[i].W)+d$+str(object[i].H)+d$+str(object[i].L)+d$
						
						foldend
						
						Foldstart // L'id model 3D, physic, behavior
						// L'id du model 3D
						txt$ = txt$ +str(object[i].IdObj3D)+d$
						
						// La physic
						txt$ = txt$ +str(object[i].Physic)+e$+str(object[i].Shape)+e$+str(object[i].Mass)+e$+str(object[i].Physics.Colision)+e$+str(object[i].Physics.Restitution)+e$+str(object[i].Physics.Damping)+e$+d$
						
						
						// behavior
						txt$ = txt$+str(object[i].IsPlayer)+d$
						
						Foldend
						
						FoldStart // type, sub-type, param1, param2 / anim
						
						// type, sub-type, param1, param2
						txt$ = txt$+str(object[i].ObjTyp)+e$+str(object[i].SubTyp)+e$+object[i].Param[0]+e$+object[i].Param[1]+e$+d$
						
						
						// Anim
						txt$ = txt$+str(object[i].Animated)+e$+str(object[i].Anim.speed,2)+e$+str(object[i].Anim.FrameSt,2)+e$+str(object[i].Anim.FrameEnd,2)+e$+d$
						
						Foldend
												
					endcase
				
				endselect
				
				
				txt$ = replacestring(txt$, ".00;", ";",-1)
				txt$ = replacestring(txt$, ".00,", ",",-1)
				writeline(fil,txt$)			
			next
			
			
			
			//** camera
			FoldStart 
			writeline(fil,"; Cameras")
			txt$ = "camera"+d$+str(GetCameraX(1))+d$+str(GetCameraY(1))+d$+str(GetCameraZ(1))+d$+str(GetCameraAngleX(1))+d$+str(GetCameraAngleY(1))+d$+str(GetCameraAngleZ(1))+d$+str(GetCameraFOV(1))+d$+str(options.Camera.near)+d$+str(options.Camera.far)+d$+str(options.Camera.ortho)+d$+str(options.Camera.orthow)+d$+str(options.Camera.speed)+d$
			
			txt$ = ReplaceAllString(txt$)
			
			writeline(fil,txt$)
			
			Foldend
			
			
			
			CloseFile(fil)
			if countStringTokens(doc.FileName$, "Autosave") = 0
				message("Document saved with succes : "+doc.FileName$+ext$)
			endif
			
		else
			message("Unable to save the document : "+"scenes\"+doc.FileName$+ext$)
		endif
			
	endif
	
	Foldend
		
	undim LibImage[]
	undim LibShader[]	
	undim LibModel[]
		
	
EndFunction


Function ReplaceAllString(txt$)
	
	//to replace all string not good	
	txt1$ = replacestring(txt$,  ".000000;", ";",-1)
	txt1$ = replacestring(txt1$, ".00000;", ";",-1)
	txt1$ = replacestring(txt1$, ".0000;", ";",-1)
	txt1$ = replacestring(txt1$, ".000;", ";",-1)
	txt1$ = replacestring(txt1$, ".00;", ";",-1)			
	txt1$ = replacestring(txt1$, ".0;", ";",-1)	
	
	txt1$ = replacestring(txt1$, ".000000,", ",",-1)	
	txt1$ = replacestring(txt1$, ".00000,", ",",-1)	
	txt1$ = replacestring(txt1$, ".0000,", ",",-1)	
	txt1$ = replacestring(txt1$, ".000,", ",",-1)	
	txt1$ = replacestring(txt1$, ".00,", ",",-1)	
	txt1$ = replacestring(txt1$, ".0,", ",",-1)	
	
Endfunction txt1$




Function ExportForAGK(mode, auto)
	
	// export in level format, for game
	/*
	mode = 0 level
	
	mode 1 = project agk full 
	
	*/
	
	// needed to not keep the ctrl key presed
	if Ctrl = 1
		While quit =0
			If GetRawKeyReleased(key_control)=1
				quit = 1
				ctrl = 0
			endif
			//sync()
		EndWhile
	endif
	
	quit = 0
	
	
	// verify if we export only (auto=0) or save+export (auto = 1)
	if auto = 0
		
		FoldStart // savefilerequester : create the interface & repeat & free ressources
			
			FileName$ = SaveFileRequester("Export the level","")
			
			if fileName$ = ""
				exitfunction
			endif
			
			Doc.exportName$ = Filename$
			quit = 2
		FoldEnd	
	
	else
		quit = 2 	
	endif
	
	
	select mode
		
		case 0 // level only
			
			foldstart 
			
			Foldstart // save
			
			if Doc.exportName$ <> "" and quit = 2
				
				// extension of the file
				If Lower(GetExtensionFile(doc.exportName$)) <> "agm"
					ext$=".agm"
				endif
				
				
				if auto = 0
					// verify if the file exists
					if GetFileExists(doc.exportName$) =1 or GetFileExists("scenes\"+doc.exportName$) = 1
						Answer = LAG_message("Info","The file "+doc.exportName$+" exists. Do you want to replace it ?","1|")
						if answer = LAG_ANSWER_NO 				
							exitfunction 
						endif
					endif
				endif
					
				
				// erase the folder, in the name : not finished !!!		 
				doc.exportName$ = replacestring(doc.exportName$,"scenes\","",1)
				
				d$ = ","
				e$ = ";"
				f$ = "/"
				
				// message("we save the level ")
				
				FoldStart // save the lib : image, model, shader
				
				SaveTheBank(0)
				
				Foldend
				
				
				
				// then save the document
				fil = OpenToWrite("scenes\export\"+doc.exportName$+ext$)
				
				if fil <> 0
					
					// SetWindowTitle(C_PROGRAM_NAME + " v"+C_VERSION + " - "+doc.FileName$)
					
					
					// general info
					writeline(fil,"; General informations")
					txt$ = "General"+d$+C_version+d$+GetCurrentDate()+d$
					writeline(fil,txt$)
					
					// Game info
					writeline(fil,"; Game informations")
					if Game.Name$ = ""
						Game.Name$ = doc.exportName$
					endif
					if Game.Version$ = ""
						Game.Version$ = "1"
					endif
					txt$ = "Game"+d$+Game.Name$+d$+Game.Version$+d$
					writeline(fil,txt$)
					
					
					//** save the image for the level
					writeline(fil,"; Images used in the level")
					For i=0 to libImage.length
						// old : txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
						wrap$ =""
						if libImage[i].wrap =1
							wrap$ = "1"+d$
						endif
						txt$ = "Img"+d$ + str(LibImage[i].id)+ d$+libImage[i].Filename$+d$+wrap$
						writeline(fil,txt$)
					next
					
					//** save the Shader for the level
					writeline(fil,"; Shader used in the level")
					For i=0 to LibShader.length
						// old : txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
						txt$ = "shader"+d$ +str(i)+ d$+str(LibShader[i].id)+d$+LibShader[i].Filename$ +d$ 
						writeline(fil,txt$)
					next
					
					
					//** save the models
					writeline(fil,"; Models used in the level")
					For i=0 to libModel.length
						txt$ = "Model"+ d$ + str(LibModel[i].id) + d$ + libModel[i].Filename$ + d$
						writeline(fil,txt$)
					next
					
					
					//** save atmosphere (sun, skybox,fog, ambient) level : sun,skybox,fog,ambient
					writeline(fil,"; Atmospheric effects")
					txt$ = "Atmos"+d$+ WriteAtmosphereDoc(d$,e$,0) // Fog$+d$+Sun$+d$+Skybox$+d$+Ambient$+d$		
					writeline(fil,txt$)	
					
					
					
					//** lights
					writeline(fil,"; Lights")
					For i=0 to light.length
						
						txt$ = "Light"+d$+light[i].name$+d$+str(light[i].x,2)+d$+str(light[i].y,2)+d$+str(light[i].z,2)+d$			
						txt$ = txt$ +str(light[i].R)+d$+str(light[i].G)+d$+str(light[i].B)+d$+str(light[i].Radius)+d$+str(light[i].Intensity,2)+d$			
						txt$ = txt$ +str(light[i].Shadow)+d$
						
						txt$ = ReplaceAllString(txt$)
						
						writeline(fil,txt$)			
					next
					
					
					
					
					//** objects
					writeline(fil,"; Objects")	
					For i=0 to Object.length
						
						Select Object[i].Typ
							
							case C_OBJPARTSYS
								
								txt$ = SaveParticleSystem(i,d$,e$)
								
							endcase
							
							case default
								
								// A revoir !!! // to be changed
								
								if Options.export.UseAgeType=1 // or (object[i].ObjTyp = 1 and object[i].SubTyp)
									theindex$ = "object"
								else
									Theindex$ = str(object[i].ObjTyp)+"_"+str(object[i].SubTyp)
								endif
									
										
								FoldStart // name, transform
								txt$ = theindex$+d$+object[i].name$+d$
								
								// position
								txt$ = txt$ +str(object[i].x,2)+d$+str(object[i].y,2)+d$+str(object[i].z,2)+d$
								
								// rot
								txt$ = txt$ +str(object[i].Rx,2)+d$+str(object[i].ry,2)+d$+str(object[i].rz,2)+d$
								
								// size
								txt$ = txt$ +str(object[i].Sx,2)+d$+str(object[i].Sy,2)+d$+str(object[i].Sz,2)+d$+str(object[i].Size,2)+d$
								
								Foldend
	
								
								FoldStart // shader, img, color
	
								// shader
								txt$ = txt$ +str(object[i].Shader)+d$
								
								// Images
								NbImgForObj$ = ""
								for qq = 0 to object[i].Stage.length							
									id = object[i].Stage[qq].LibImg
									txt1$ = str(id)+e$+str(object[i].Stage[qq].UVx,2)+e$+str(object[i].Stage[qq].UVy,2)+e$+str(object[i].Stage[qq].UVw,2)+e$+str(object[i].Stage[qq].UVh,2)+e$
									NbImgForObj$ = NbImgForObj$ +txt1$+f$
								next			
								txt$ = txt$ + NbImgForObj$+d$
								
								// color alpha
								txt$ = txt$ + str(object[i].R)+d$+str(object[i].G)+d$+str(object[i].B)+d$+str(object[i].Alpha)+d$
								Foldend
								
								
								FoldStart // shadow, typ, dimension, id model3D
								// ombre lightmap, ao, Realtime
								txt$ = txt$+str(object[i].Shadow)+e$+str(object[i].ShadowCast)+e$+str(object[i].ShadowRec)+e$+str(object[i].Normalmap)+e$+str(object[i].LightMap)+e$+str(object[i].FogMode)+e$+str(object[i].Lightmode)+e$+str(object[i].visibleInGame)+e$+d$
								
								//typ, w,h,l
								txt$ = txt$ +str(object[i].Typ)+d$+str(object[i].W)+d$+str(object[i].H)+d$+str(object[i].L)+d$
								
								
								// L'id du model 3D
								txt$ = txt$ +str(object[i].IdObj3D)+d$
								Foldend
								
								
								FoldStart // physic, behav, typ-subtyp, anim
									// La physic
									txt$ = txt$ +str(object[i].Physic)+e$+str(object[i].Shape)+e$+str(object[i].Mass)+e$+str(object[i].Physics.Colision)+e$+str(object[i].Physics.Restitution)+e$+str(object[i].Physics.Damping)+e$+d$
									
									
									// behaviors
									txt$ = txt$+str(object[i].IsPlayer)+d$
									
									// type, sub-type, param1 et 2
									txt$ = txt$+str(object[i].ObjTyp)+e$+str(object[i].SubTyp)+e$+object[i].Param[0]+e$+object[i].Param[1]+e$+d$
							
									// Anim
									txt$ = txt$+str(object[i].Animated)+e$+str(object[i].Anim.speed,2)+e$+str(object[i].Anim.FrameSt,2)+e$+str(object[i].Anim.FrameEnd,2)+e$+d$
									Foldend
					
								
								
							endcase
						
						endselect
						
						txt$ = ReplaceAllString(txt$)
						
						writeline(fil,txt$)			
					next
					
					
					
					
					CloseFile(fil)
					//if countStringTokens(doc.exportName$, "Autosave") = 0
						message("Level Exported with succes : "+doc.exportName$+ext$)
					//endif
					
				else
					message("Unable to save the level : "+"scenes\"+doc.exportName$+ext$)
				endif
					
			endif
			
			Foldend
				
			undim LibImage[]
			undim LibShader[]	
			undim LibModel[]
				
			
			foldend
			
		endcase
		
		case 1 // full agk project
			// not for the moment
		endcase
		
	endselect
	
	
	
EndFunction








// open
Function OpenDoc(merge)
	
	
	// to open an AGE document

	
	LoadDoc = 1
	
	// needed to free the release mouse
	if Ctrl = 1
		While quit =0
			If GetRawKeyReleased(key_control)=1
				quit = 1
				ctrl = 0
			endif
			//sync()
		EndWhile
	endif
	quit = 0
	
	
	// check the doc name
	Doc$ = LAG_OpenFile("Open a file","scenes\","*.age",0,-1,-1,0)
	
	/*
	Doc$ = ChooseRawFile("*.age", 1) 
	
	doc$ = GetFilePart(doc$)
	doc$ = "scenes\"+doc$+".age"
	*/
	
	
	// message(doc$)
	
	FoldStart // open the file
		
		if Doc$ <> "" and GetFileExists(doc$)
			
			// MEssage(doc$)
			
			// LAG_Message("Info","The OpenDoc function isn't finished. Some functions aren't available.","")

			
			
			LoadId$ = CreateLoadingWindow("File loading, please wait...")

			doc.FileName$ = doc$
			
			// if doc.FileName$ <> "" and GetFileExists("scenes\"+doc.FileName$)
				
				filename$ = doc.FileName$

				if merge=0
					NewDoc(1)
				endif
				
				doc.FileName$ = filename$
				
				SetWindowTitle(C_PROGRAM_NAME + " v"+C_VERSION + " - "+doc.FileName$)
				
				F = OpenToRead(doc.FileName$)
					
				if F <> 0	
					
					d$ = ","
					e$ = ";"
					f$ = "/"
					
					dim tempostage[7] as tStageTexture
					dim LibImage[] as tLibImage
					dim LibShader[] as tLibImage
					dim LibModel[] as tLibImage
					
					While FileEOF(f) = 0
						
						Line$ = ReadLine(f)
						Index$ = lower(GetStringToken(line$,d$,1))
						Index2$ = GetStringToken(line$,d$,2)
						u = 2
						
						Select index$
								
								case "general"									
									
									EditorVersion = ValFloat(GetStringToken(line$,d$,2))*1000 : inc u
									Date$ = GetStringToken(line$,d$,3)   : inc u
									
									// message("editor version in doc : "+str(EditorVersion))
									
								endcase
								
								case "game"
									
									Game.Name$ = GetStringToken(line$,d$,u)   : inc u
									Game.Version$ = GetStringToken(line$,d$,u)   : inc u
									
								endcase
								
								case "atmos","level"
									Index$ = GetStringToken(line$,d$,1)
									Index2$ = ReplaceString(line$,index$+d$,"",1)																
									Options.AtmosphereOK = ReadAtmospherDoc(Index2$,d$,e$,0)
									SetSkyEditor()
									UpdateSky()
								Endcase 
								
								case "img"
									// txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
									
									u = 2
									// old : txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
									
									if EditorVersion >= 440
										
										//j = val(GetStringToken(line$,d$,u))   : inc u
										id = val(GetStringToken(line$,d$,u))   : inc u
										filename$ = GetStringToken(line$,d$,u)   : inc u
										// Message("ligne libmodel : "+filename$ + " / OldId : "+str(id))
										
										j = LibImage.length + 1
										dim LibImage[j] as tLibImage
										LibImage[j].Filename$ = filename$
										LibImage[j].id = id
										LibImage[j].NewId = -1
										
										ok=0
										For i = 0 to Texture.length
											If Texture[i].Filename$ = filename$ 
												LibImage[j].Newid = i
												ok = 1
												exit
											endif
										Next
										
										// OK ??
										if ok = 0
											newid = AddTextureToBank(filename$,1,1)	
											LibImage[j].Newid = newId
										endif
										
										
									else
										
										// message("on charge l'ancienne fonction image")
										
										//txt$ = "Img"+d$ +str(i)+ d$+libImage[i].Filename$ +d$ 
										id = val(GetStringToken(line$,d$,u))   : inc u
										filename$ = GetStringToken(line$,d$,u)   : inc u
										
										ok=0
										For i = 0 to Texture.length
											If Texture[i].Filename$ = filename$ 
												Texture[i].OldId = id
												ok = 1
												exit
											endif
										Next
										
										// if not found
										if ok = 0
											i = AddTextureToBank(filename$, 1, 1)
											Texture[i].OldId = id	
										endif
									
										
									endif
										
										
										
									
									
								endcase
								
								case "shader"
								
									// open the shader to the temporary libshader
									u = 2
									j = val(GetStringToken(line$,d$,u))   : inc u
									id = val(GetStringToken(line$,d$,u))   : inc u
									filename$ = GetStringToken(line$,d$,u)   : inc u
									
									
									j = LibShader.length + 1
									dim LibShader[j] as tLibImage
									LibShader[j].Filename$ = filename$
									LibShader[j].id = id
										
									// then, load the shader if needed
									ok = 0
									For i = 0 to ShaderBank.length
										If ShaderBank[i].Filename$ = filename$ 
											ShaderBank[i].OldId = id
											LibShader[j].Newid = i
											ok = 1
											exit
										endif
									Next
									
									
									if ok = 0
										newId = AddShaderToBank(filename$,1, GetFilePart(filename$))
										LibShader[j].Newid = newId									
									endif
									
								endcase
								
								case "model"
								
								// les modeles 3D utilisés, je dois vérifier si ce modèle est déjà dans notre banque, sinon, je dois le charger.
								
									u = 2
									id = val(GetStringToken(line$,d$,u))   : inc u
									filename$ = GetStringToken(line$,d$,u)   : inc u

									
									//Message("ligne libmodel : "+filename$ + " / OldId : "+str(id))
									if EditorVersion < 440 or options.UseFpe
										
										ext$ = GetExtensionFile(Filename$)
										Filename$ = ReplaceString(filename$, "."+ext$, "", 1)+".fpe"
										
										// on  vérifie si un model 3D est dans la banque, sinon, on l'ajoute
										ok=0
										For i = 0 to bankModel.length
											If BankModel[i].name$ = filename$ 
												BankModel[i].OldId = id	
												ok=1
												exit
											endif
										Next
										
										
										// on n'a pas trouvé ce model dans notre banque actuelle 
										// on l'ajoute 
										if ok=0
											
											FreeLoadIngWindow(LoadId$)
											ImportModel(filename$,1)
												
											n = BankModel.length
											
											if n>-1	
													
												BankModel[n].OldId = id												
											else
												If LAG_Message("Error","The File "+filename$+" doesn't exists. Do you wish to load it ?","1|") = LAG_ANSWER_YES
													ImportModel("",0)
													n = BankModel.length
													if n>-1	
														BankModel[n].OldId = id	
													else
														exit
													endif
												endif
											endif
											
										endif
									Else
										// on  vérifie si un model 3D est dans la banque, sinon, on l'ajoute
										ok=0
										For i = 0 to bankModel.length
											If BankModel[i].name$ = filename$ 
												BankModel[i].OldId = id	
												ok=1
												exit
											endif
										Next
										
										// on n'a pas trouvé ce model dans notre banque actuelle (si on fait un merge par exemple)
										// on l'ajoute donc à notre banque
										if ok=0
											
											FreeLoadIngWindow(LoadId$)
											ImportModel(filename$,1)
												
											n = BankModel.length
											if n>-1								
												BankModel[n].OldId = id												
											else
												If LAG_Message("Error","The File doesn't exists. Do you wish to load it ?","1|") = LAG_ANSWER_YES
													ImportModel("",0)
													n = BankModel.length
													if n>-1	
														BankModel[n].OldId = id	
													else
														exit
													endif
												endif
											endif
											
										endif
									endif
								
								endcase 
								
								case "level"
								
									old = 0
									
									FoldStart // OLD 
									if old = 1
									u=2
									Fog$ = GetStringToken(line$,d$,u)   : inc u
									v = 1
									Fog.Active = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.r = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.g = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.b = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.Min = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.Max = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.SunCol.r = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.SunCol.g = val(GetStringToken(Fog$,e$,v))   : inc v
									Fog.SunCol.b = val(GetStringToken(Fog$,e$,v))   : inc v
			
									Sun$ = GetStringToken(line$,d$,u)   : inc u 
									v=1
									Sun.Active = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.r = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.g = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.b = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.x = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.y = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.z = val(GetStringToken(Sun$,e$,v))   : inc v
									Sun.intensity = val(GetStringToken(Sun$,e$,v))   : inc v
									
									v=1
									Sky$ = GetStringToken(line$,d$,u)   : inc u
									SkyBox.Active = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.Col.r = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.Col.g = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.Col.b = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.HCol.r = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.HCol.g = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.HCol.b = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.HorHeight = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.Horsize = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.SunCol.r = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.SunCol.g = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.SunCol.b = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.SunVisible = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.SunSize = val(GetStringToken(Sky$,e$,v))   : inc v
									SkyBox.HaloSize = val(GetStringToken(Sky$,e$,v))   : inc v

									v=1
									Amb$ = GetStringToken(line$,d$,u)   : inc u
									Ambient.r = val(GetStringToken(Amb$,e$,v))   : inc v
									Ambient.g = val(GetStringToken(Amb$,e$,v))   : inc v
									Ambient.b = val(GetStringToken(Amb$,e$,v))   : inc v
									
									SetSkyEditor()
									UpdateAtmosphere()
									endif
									Foldend
								
								endcase
								
								case "light","l"
									
								/*	
								txt$ = "Light"+d$+light[i].name$+d$+str(light[i].x,2)+d$+str(light[i].y,2)+d$+str(light[i].z,2)+d$			
								txt$ = txt$ +str(light[i].R)+d$+str(light[i].G)+d$+str(light[i].B)+d$+str(light[i].Radius)+d$+str(light[i].Intensity,2)+d$			
								txt$ = txt$ +str(light[i].Hide)+d$+str(light[i].Locked)+d$+str(light[i].Shadow)+d$
								*/
									u = 2
									name$ = GetStringToken(line$,d$,u)   : inc u
									x# = val(GetStringToken(line$,d$,u)) : inc u
									y# = val(GetStringToken(line$,d$,u))  : inc u
									z# = val(GetStringToken(line$,d$,u)) : inc u
									
									R = val(GetStringToken(line$,d$,u)) : inc u
									g = val(GetStringToken(line$,d$,u)) : inc u
									b = val(GetStringToken(line$,d$,u)) : inc u
									
									radius = val(GetStringToken(line$,d$,u)) : inc u
									int# = val(GetStringToken(line$,d$,u)) : inc u
									
									
									AddLight(x#,y#,z#,radius,r,g,b,-1,1)
									n = Light.length
									Light[n].Name$ = name$
									light[n].Hide = val(GetStringToken(line$,d$,u)) : inc u
									light[n].Locked = val(GetStringToken(line$,d$,u)) : inc u
									light[n].Shadow = val(GetStringToken(line$,d$,u)) : inc u
									light[n].Intensity = int#
									
									SetPointLightColor(n+1,r*int#,g*int#,b*int#)
									
								endcase
								
								case "object","o"
									
									if EditorVersion < 440
									 
										foldstart 
										
										
										// message("on charge l'ancienne fonction")
										
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
										Size# = valfloat(GetStringToken(line$,d$,u)) : inc u
																				
										if sx# =0 then sx# = 1
										if sy# =0 then sy# = 1
										if sz# =0 then sz# = 1
										if size# =0 then size# = 1
										
										ShaderId = val(GetStringToken(line$,d$,u)) : inc u
										
										img$ = GetStringToken(line$,d$,u) : inc u
										v=1
										t_ID = val(GetStringToken(img$,d$,v)) : inc v
										
										textureID = 0
										
										For i = 0 to Texture.length
											if Texture[i].OldId = t_ID
												TextureID = i												
												exit
											endif
										Next
										
										// message("texture id : "+str(textureid))
										
										FoldStart // color, alpha
										
										r = val(GetStringToken(line$,d$,u)) : inc u
										g = val(GetStringToken(line$,d$,u)) : inc u
										b = val(GetStringToken(line$,d$,u)) : inc u
										alpha = val(GetStringToken(line$,d$,u)) : inc u
										if alpha = 0 then alpha = 255
										
										Foldend
										
										FoldStart // editor
										
										hide = val(GetStringToken(line$,d$,u)) : inc u
										lock = val(GetStringToken(line$,d$,u)) : inc u
										
										Foldend
										
										FoldStart // shadow, shadoRt, Ao
										
										shadotot$ = GetStringToken(line$,d$,u) : inc u
										shadoLM = val(GetStringToken(shadotot$,e$,1)) 
										shadoCAst = val(GetStringToken(shadotot$,e$,2)) 
										shadoRec = val(GetStringToken(shadotot$,e$,3)) 
										AO = val(GetStringToken(shadotot$,e$,4)) 
										
										Foldend
										
										FoldStart // typ, w,h,l
										
										OBjTyp = val(GetStringToken(line$,d$,u)) : inc u
											
										w = val(GetStringToken(line$,d$,u)) : inc u
										h = val(GetStringToken(line$,d$,u)) : inc u
										l = val(GetStringToken(line$,d$,u)) : inc u
										
										Foldend
										
										FoldStart // uv scale, offset
										
										uvx = val(GetStringToken(line$,d$,u)) : inc u
										uvy = val(GetStringToken(line$,d$,u)) : inc u
										uvw = val(GetStringToken(line$,d$,u)) : inc u
										uvh = val(GetStringToken(line$,d$,u)) : inc u
										
										Foldend
										
										Obj3dId = val(GetStringToken(line$,d$,u)) : inc u
										
										FoldStart //physic
										
										phys$ = GetStringToken(line$,d$,u) : inc u
										physic = val(GetStringToken(phys$,e$,1)) 
										Shape = val(GetStringToken(phys$,e$,2)) 
										mass = val(GetStringToken(phys$,e$,3)) 
										
										Foldend
										
										option$ = Name$
										
										
										FoldStart // set W, H, L
										If ObjTyp = C_OBJBANK
											
											//Message("on a un objet model 3D. La bank fait : "+str(bankModel.length))
											//Message("We have a model3D, Obj3Did = "+str(Obj3dId))
											Options.Asset.W = 10
											Options.Asset.H = 10
											Options.Asset.L = 10
											
											For i=0 to bankModel.length
												if Obj3dId = BankModel[i].OldId
													Options.BankModelId = i
													//Message("On a trouvé dans la bank notre objet")
													exit
												endif
											next
											
											
											
											
										elseif ObjTyp = C_OBJTERRAIN
											
										elseif ObjTyp = C_OBJWATER
											
											// option$ = 
										else
											
											a = Options.Asset.W
											b = Options.Asset.H
											c = Options.Asset.L 
											
											Options.Asset.W = 10
											Options.Asset.H = 10
											Options.Asset.L = 10
											
											select ObjTyp
												
												case C_OBJSPHERE
													Options.Asset.H = 20
													options.Asset.L = 20
												endcase
												
												case C_OBJCAPSULE
													Options.Asset.H = 20
												endcase
												
											endselect
												
												
										Endif
										
										
										Foldend
										
										AddObjet(x#,y#,z#,option$)
										i = object.length
										ObjId = i
										//if uvw >1 or uvh >1
											//message("Scale uv : "+str(uvw)+"/"+str(uvh))
										//endif
										
										
										FoldStart // Set the properties for new object 
										
										if i>-1
										
											Object[i].R = r 
											Object[i].G = g 
											Object[i].B = b 
											Object[i].Alpha = alpha 
											
											
											Object[i].Size = size#
											Object[i].Sx = sx#
											Object[i].Sy = sy#								
											Object[i].Sz = sz#
											
											Object[i].rx = rx
											Object[i].ry = ry								
											Object[i].rz = rz
											
											Object[i].name$ = name$
											Object[i].Hide = hide
											Object[i].locked = lock
											
											
											Object[i].shadow = shadoLM
											Object[i].ShadowCast = shadoCast
											Object[i].ShadowRec = shadoRec
											Object[i].AO = ao
											
											Object[i].w = w
											Object[i].h = h
											Object[i].l = l
											
											// attention 1 uv chanel saved and load ! 
											Object[i].Stage[0].uvx = uvx
											Object[i].Stage[0].uvy = uvy
											Object[i].Stage[0].uvw = uvw
											Object[i].Stage[0].uvh = uvh
											
											Object[i].physic = physic
											Object[i].shape = shape
											Object[i].mass = mass
											
											UpdateObject(i)
											
											if Object[i].physic> 0
												SetPhysicToObject(i,0)
											endif
										
										endif
										
										foldend
										
									foldend
									
									else
									
										FoldStart // new version, >= 0.44
										
										/*
									pos:  
									Rot : 0,326,0,
									Size : 1,1,1,24,
									shader : 15,									
									Image : 55;0;0;1;1;/22;0;0;1;1;/
									color/alpha : 	0,0,0,255,
									Editor : 0,0,
									Shadow: 0;1;1;0;,
									Typ, dimension : 6,10,10,10,
									Obj3dId : 0,									
									Physic : 0;0;0;,										
									*/	
										u = 2
										name$ = GetStringToken(line$,d$,u)   : inc u
										
										FoldStart // pos, rot, scale
										
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
										
										if sx# <=0 then sx# =1
										if sy# <=0 then sy# =1
										if sz# <=0 then sz# =1
										if size# <=0 then size# =1
										
										Foldend
										
										ShaderId = val(GetStringToken(line$,d$,u)) : inc u
										
										FoldStart // images
											
											img$ = GetStringToken(line$,d$,u) : inc u
											
											// nb of texture stage for models
											nb = max(CountStringTokens(img$,f$),7)-1
											 
											for kk = 0 to 7
												tempostage[kk].LibImg = -1
												tempostage[kk].ImageId = -1
											next  
											 
											For kk = 0 to nb
												
												img1$ = GetStringToken(img$,f$,kk+1) 
												
												v=1
												tempostage[kk].LibImg = val(GetStringToken(img1$,e$,v)) : inc v
												
												if tempostage[kk].LibImg > -1
													// check the id for libimage
													for pp =0 to LibImage.length
														
														if LibImage[pp].id = tempostage[kk].LibImg
															filename$ =  LibImage[pp].Filename$
															
															exit
														endif
													next 
													
													//now, check the name in texture array
													For i = 0 to Texture.length
														If Texture[i].Filename$ = filename$ 
															tempostage[kk].TextureId = i
															tempostage[kk].ImageId = Texture[i].img
															// message(" image  : "+filename$)
															exit
														endif
													next
													
													tempostage[kk].UVx = val(GetStringToken(img1$,e$,v)) : inc v 
													tempostage[kk].UVy = val(GetStringToken(img1$,e$,v)) : inc v 
													tempostage[kk].UVw = val(GetStringToken(img1$,e$,v)) : inc v 
													tempostage[kk].UVh = val(GetStringToken(img1$,e$,v)) : inc v 
												endif
												
											next
										
										Foldend
																			
										FoldStart // color, alpha
										r = val(GetStringToken(line$,d$,u)) : inc u
										g = val(GetStringToken(line$,d$,u)) : inc u
										b = val(GetStringToken(line$,d$,u)) : inc u
										alpha = val(GetStringToken(line$,d$,u)) : inc u
										if alpha = 0 then alpha = 255
										
										Foldend
										
										FoldStart // editor
										hide = val(GetStringToken(line$,d$,u)) : inc u
										lock = val(GetStringToken(line$,d$,u)) : inc u
										Foldend
										
										FoldStart // shadow, shadoRt, Ao...
										shadotot$ = GetStringToken(line$,d$,u) : inc u
										v=1
										shadoLM = val(GetStringToken(shadotot$,e$,v)) : inc v  
										shadoCast = val(GetStringToken(shadotot$,e$,v)) : inc v   
										shadoRec = val(GetStringToken(shadotot$,e$,v)) : inc v  
										AO = val(GetStringToken(shadotot$,e$,v)) : inc v  
										useNormalmap = val(GetStringToken(shadotot$,e$,v)) : inc v  
										uselightmap = val(GetStringToken(shadotot$,e$,v)) : inc v   
										FogMode = val(GetStringToken(shadotot$,e$,v)) : inc v   
										LightMode = val(GetStringToken(shadotot$,e$,v)) : inc v 
										visibleInGame = val(GetStringToken(shadotot$,e$,v)) : inc v 
										Foldend
										
										FoldStart // typ, w,h,l
										ObjTyp = val(GetStringToken(line$,d$,u)) : inc u
											
										w = val(GetStringToken(line$,d$,u)) : inc u
										h = val(GetStringToken(line$,d$,u)) : inc u
										l = val(GetStringToken(line$,d$,u)) : inc u
										
										Foldend
										
										//Obj3dId							
										Obj3dId = val(GetStringToken(line$,d$,u)) : inc u
										
										FoldStart //physic
										phys$ = GetStringToken(line$,d$,u) : inc u
										v=1
										Physic = val(GetStringToken(phys$,e$,v)) : inc v  // physics body 
										Shape = val(GetStringToken(phys$,e$,v)) : inc v  
										Mass = val(GetStringToken(phys$,e$,v))  : inc v 
										Colision = val(GetStringToken(phys$,e$,v)) : inc v  
										Restitution = val(GetStringToken(phys$,e$,v)) : inc v 
										Damping = val(GetStringToken(phys$,e$,v))  : inc v 
										Foldend
										
										// others
										IsPlayer = val(GetStringToken(line$,d$,u)) : inc u
										
										FoldStart // type, subtype, param1, 2
										oTyp$  = GetStringToken(line$,d$,u) : inc u
										v = 1
										Typ = val(GetStringToken(oTyp$,e$,v)) : inc v
										SubTyp = val(GetStringToken(oTyp$,e$,v)) : inc v
										Param0$ = GetStringToken(oTyp$,e$,v) : inc v
										Param1$ = GetStringToken(oTyp$,e$,v) : inc v
										Foldend
										
										FoldStart // Anim
										Anim$  = GetStringToken(line$,d$,u) : inc u
										v = 1
										Anim = val(GetStringToken(Anim$,e$,v)) : inc v
										Speed# = valfloat(GetStringToken(Anim$,e$,v)) : inc v
										FrStart# = valFloat(GetStringToken(Anim$,e$,v)) : inc v
										FrEnd# = valFloat(GetStringToken(Anim$,e$,v)) : inc v
										Foldend
										
										option$ =""
										
										
										
										If ObjTyp = C_OBJBANK
										
											//Message("on a un objet model 3D. La bank fait : "+str(bankModel.length))
											//Message("We have a model3D, Obj3Did = "+str(Obj3dId))
											Options.BankModelId  = -1
											For i=0 to bankModel.length
												if Obj3dId = BankModel[i].OldId
													Options.BankModelId = i
													// Message("On a trouvé dans la bank notre objet")
													exit
												endif
											next
											
											if Options.BankModelId =-1
												// Message("On n'a pas trouvé notre objet dans la bank, on l'ajoutera.")
											endif
											
											
										elseif ObjTyp = C_OBJTERRAIN
											
										elseif ObjTyp = C_OBJWATER
											
											// option$ = 
										else
											//message(str(sx#,2)+"/"+str(sy#,2)+"/"+str(sz#,2)+"/"+str(size#,2))
											
										Endif
									
										
										AddObjet(x#, y#, z#, name$ +",")
										i = object.length
										ObjId = i
										
										FoldStart // Then, update the object with the new parameters
										
										if i>-1
										
											Object[i].R = r 
											Object[i].G = g 
											Object[i].B = b 
											Object[i].Alpha = alpha 
											
											
											Object[i].Size = size#
											Object[i].Sx = sx#
											Object[i].Sy = sy#								
											Object[i].Sz = sz#
											
											Object[i].rx = rx
											Object[i].ry = ry								
											Object[i].rz = rz
											
											Object[i].name$ = name$
											Object[i].Hide  = hide
											Object[i].locked = lock
										
											// Object[i].Groupe$ = groupe$
											// Object[i].Layer$ = layer$
											
											
											
											Object[i].shadow = shadoLM
											Object[i].ShadowCast = shadoCast
											Object[i].ShadowRec = shadoRec
											Object[i].AO = ao
											Object[i].LightMap = uselightmap
											Object[i].Normalmap = usenormalmap
											Object[i].FogMode = fogmode
											Object[i].Lightmode = Lightmode
											Object[i].visibleInGame = visibleInGame
											
											
											
											Object[i].w = w
											Object[i].h = h
											Object[i].l = l
											
											
											// shader
											ok = 0
											for k =0 to LibShader.length
												if LibShader[k].id = ShaderID
													Object[i].Shader = LibShader[k].Newid
													exit
												endif
											next 
											
											if ok = 0											
												For k=0 to ShaderBank.length
													if SHaderBank[k].OldId = ShaderID
														Object[i].Shader = k
														exit
													endif
												next 
											endif
											
											// image, stage & uv
											For k =0  to Object[i].Stage.length
												Object[i].Stage[k].textureId  = -1
												Object[i].Stage[k].ImageId = -1
											next 
											
											For k = 0 to tempostage.length
												
												if tempostage[k].ImageId > 0
													
													Object[i].Stage[k].textureId = tempostage[k].TextureId
													Object[i].Stage[k].ImageId = tempostage[k].ImageId
													
													// uv 
													Object[i].Stage[k].uvx = tempostage[k].uvx
													Object[i].Stage[k].uvy = tempostage[k].uvy
													Object[i].Stage[k].uvw = tempostage[k].uvw
													Object[i].Stage[k].uvh = tempostage[k].uvh
													
												endif
											next 
												
											
												
											// physic
											Object[i].physic = physic
											Object[i].shape = shape
											Object[i].mass = mass
											Object[i].Physics.Colision = Colision
											Object[i].Physics.Restitution = Restitution
											Object[i].Physics.Damping = Damping
											
											
											//
											Object[i].IsPlayer = Isplayer
											
											// type, subtype, param0 ,1
											Object[i].ObjTyp = typ
											Object[i].SubTyp = subtyp
											Object[i].Param[0] = param0$
											Object[i].Param[1] = param1$
											
											
											
											UpdateObject(i)											
											// message("shaderid : "+str(Object[i].Shader))
											
											
											//If ObjTyp = C_OBJBANK											
												UpdateObjetMaterial(i)
											//endif
										
											if Object[i].physic > 0
												SetPhysicToObject(i,0)
											endif
											
										endif
										
										
										Foldend
									
										
										Foldend
									
									
									endif
									
								endcase
								
								case "psys" // system de particles
									/*
									txt$ = "psys"+d$+object[i].name$+d$+str(object[i].x,2)+d$+str(object[i].y,2)+d$+str(object[i].z,2)+d$
									txt$ = txt$ +str(object[i].rx,2)+d$+str(object[i].ry,2)+d$+str(object[i].rz,2)+d$
									
									//speed# = Object[ObjId].Rx
									//speedmin# = Object[ObjId].Ry
									//life = Object[ObjId].Rz
									
									// sx,sy,sz = taille en x,y,z
									txt$ = txt$ +str(object[i].Sx,2)+d$+str(object[i].Sy,2)+d$+str(object[i].Sz,2)+d$+str(object[i].Size,2)+d$
									
									
									// le blendmode
									txt$ = txt$ +str(object[i].Shader)+d$
									
									// l'image utilisée
									txt$ = txt$ +Particle[Object[j].Image[1]].Filename$ +e$+d$
														
									// color alpha
									txt$ = txt$ +str(object[i].R)+d$+str(object[i].G)+d$+str(object[i].B)+d$+str(object[i].Alpha)+d$
									
									// editor
									txt$ = txt$ +str(object[i].Hide)+d$+str(object[i].Locked)+d$
									
									// ombre lightmap, ao, Realtime, Utile ?
									txt$ = txt$+str(object[i].Shadow)+e$+str(object[i].ShadowRT)+e$+str(object[i].AO)+e$+d$
									
									//typ, w,h,l
									txt$ = txt$ +str(object[i].Typ)+d$+str(object[i].W)+d$+str(object[i].H)+d$+str(object[i].L)+d$
									
									// La physic
									txt$ = txt$ +str(object[i].Physic)+e$+str(object[i].Shape)+e$+str(object[i].Mass)+e$+d$
									*/
									u = 2
									name$ = GetStringToken(line$,d$,u)   : inc u
									
									// position
									x# = val(GetStringToken(line$,d$,u)) : inc u
									y# = val(GetStringToken(line$,d$,u)) : inc u
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
									shadoRec = val(GetStringToken(shadotot$,e$,3)) 
									AO = val(GetStringToken(shadotot$,e$,4)) 
									
									// typ, w,h,l
									OBjTyp = C_OBJPARTSYS : inc u // val(GetStringToken(line$,d$,u)) : inc u
																			
									w = val(GetStringToken(line$,d$,u)) : inc u
									h = val(GetStringToken(line$,d$,u)) : inc u
									l = val(GetStringToken(line$,d$,u)) : inc u
									
									
									id = AddObjectPartSyst(x#,y#,z#)
									
									Object[ObjId].Stage.length = 1
									Object[ObjId].Stage[1].TextureId = TextureId
									Object[ObjId].Typ = C_OBJPARTSYS
									
									Object[ObjId].IdObj3D=id 
									
									// position
									Object[ObjId].x = x#
									Object[ObjId].y = y#
									Object[ObjId].z = z#
									
									// size
									Object[ObjId].sx = sx#									
									Object[ObjId].sy = sy#
									Object[ObjId].sz = sz#									
									Object[ObjId].size = size#
									
									// rot 
									Object[ObjId].rx = rx
									Object[ObjId].ry = ry
									Object[ObjId].rz = rz
									
									// color 
									Object[ObjId].r = r
									Object[ObjId].g = g
									Object[ObjId].b = b
									
									// editor
									Object[ObjId].Hide = Hide
									Object[ObjId].Locked = lock
									
									// light, shadow
									Object[ObjId].Shader = bm
									Object[ObjId].Shadow = shadoLM
									Object[ObjId].ShadowCast = shadoCast
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
									SetPartSystemImg(object[Objid].IdObj3D, Particle[TextureId].img, bm)
								
								endcase
								
								case "camera","c"
									
									CamX = val(GetStringToken(line$,d$,u))   : inc u
									CamY = val(GetStringToken(line$,d$,u))   : inc u
									CamZ = val(GetStringToken(line$,d$,u))   : inc u
									CamRx = val(GetStringToken(line$,d$,u))   : inc u
									CamRy = val(GetStringToken(line$,d$,u))   : inc u
									CamRz = val(GetStringToken(line$,d$,u))   : inc u
									Options.camera.fov = val(GetStringToken(line$,d$,u))   : inc u
									options.Camera.near = val(GetStringToken(line$,d$,u))   : inc u
									options.Camera.far = val(GetStringToken(line$,d$,u))   : inc u
									options.Camera.ortho = val(GetStringToken(line$,d$,u))   : inc u
									options.Camera.orthoW = val(GetStringToken(line$,d$,u))   : inc u
									options.Camera.speed = val(GetStringToken(line$,d$,u))   : inc u
									
									SetCamera()
								
								endcase
								
								case "action"
									// not used for the moment 
								endcase
								
								case "start"
									// not used for the moment 
								endcase
							
							endselect
						
					endwhile
						
					CloseFile(f)
					
					
					undim LibImage[]	
					undim LibShader[]
					undim LibModel[]
					undim tempostage[]
					
					FreeLoadIngWindow(LoadId$)
					
				else
					
					LAG_Message("Info","Unable to load the file : "+doc$+".","")
					
				endif
				
		endif
		
	FoldEnd	
	
	ObjID = -1
	LoadDoc = 0
	
EndFunction







// Shader
Function OpenShader()

	Doc$ = LAG_OpenFile("Open a Shader","Scenes/","",0,-1,-1,0)

EndFunction

Function Save_Shader()
	
	// To save a shader
	
	inc ShaderId
	
	Shader$ = "Shader"+str(ShaderId)+".ps"
	
	old = 0
	
	
	if objId > -1 and objId <= object.length
		
		// GetObjectMeshVSSource(objid, "saved_shader.vs")
		// GetObjectMeshPSSource(objid, "saved_shader.ps")
		shadervs$ = GetObjectMeshVSSource(objid, 1)
		shaderps$ = GetObjectMeshPSSource(objid, 1)

		
		OpenToWrite(1, "saved_shader.vs")
		WriteLine(1,shadervs$ )
		CloseFile(1)

		OpenToWrite(1, "saved_shader.ps")
		WriteLine(1,shaderps$ )
		CloseFile(1)

	else
		
	if old = 1
		OpenToWrite(1,shader$)
			
			txt$ = "uniform vec4 agk_MeshDiffuse;"+chr(13)
			txt$ = txt$ + "uniform sampler2D texture0; // diffuse"+chr(13)
			txt$ = txt$ + chr(13)
			txt$ = txt$ + "varying vec2 uv0Varying;" + chr(13)
			txt$ = txt$ + "varying vec3 normalVarying;"+chr(13)
			txt$ = txt$ + "varying vec3 posVarying;"+chr(13)
			txt$ = txt$ + "varying highp vec4 worldPosition;"+chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "uniform vec3 ambient;"+chr(13)
			txt$ = txt$ + "uniform vec3 specint;" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "varying mediump vec3 lightVarying;" + chr(13)
			txt$ = txt$ + "varying mediump vec3 colorVarying;" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "// these must appear exactly as they are to work, spaces and all." + chr(13)
			txt$ = txt$ + "// they will be filled in by AGK" + chr(13)
			txt$ = txt$ + "mediump vec3 GetPSLighting( mediump vec3 normal, highp vec3 pos );" + chr(13)
			txt$ = txt$ + "mediump vec3 ApplyFog( mediump vec3 color, highp vec3 pointPos );" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "void main()" + chr(13)
			txt$ = txt$ + "{" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "	// specular light" + chr(13)
			txt$ = txt$ + "	// mediump vec3 spec = texture2D(texture2, uv0Varying).rgb;" + chr(13)
			txt$ = txt$ + "	vec4 SpecColor = texture2D(texture2, uv0Varying);" + chr(13)
			txt$ = txt$ + "	vec3 spec = vec3(SpecColor.r * 2.0 - 1.0, SpecColor.b, SpecColor.g * 2.0 -1.0);" + chr(13)
			txt$ = txt$ + "	spec = normalize(spec);" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "	// lights" + chr(13)
			txt$ = txt$ + "	mediump vec3 norm = normalize(normalVarying);" + chr(13)
			txt$ = txt$ + "	mediump vec3 light = lightVarying + GetPSLighting( norm, posVarying )*(1+spec*specint); " + chr(13)	
			txt$ = txt$ + "	mediump vec3 color = (texture2D(texture0, uv0Varying).rgb) * light ;" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "	// Apply Fog" + chr(13)
			txt$ = txt$ + "	color = ApplyFog(color, posVarying );" + chr(13)
			txt$ = txt$ + "" + chr(13)
			txt$ = txt$ + "	gl_FragColor = vec4(color*"+str(.01*random(1,10),1)+",1.0);" + chr(13) 
			txt$ = txt$ + "" + chr(13) 
			txt$ = txt$ + "}" + chr(13)
			
		WriteLine(1,txt$)
		CloseFile(1)
		endif
	endif
	
	LoadShader(ShaderId, "shader_ns.vs", Shader$)
	
	
EndFunction






// utilities for open/save : loading message
Function CreateLoadIngWindow(title$)
	
	//create a loading Message 
	
	// the background sprite
	width = 500
	height = 50 
	i1 = LAG_CreateMenuBox(G_width/2-width/2-5, G_height/2-height/2-45, width+10, height+50, LAG_C_ICORNER, 255)
	Fond1 = LAG_GetMenuboxSprite(i1)			
	LAG_SetMenuBoxColor(i1,180,180,180)
	LAG_setMenuBoxDepth(i1,5)
	
	// title
	FontId = LAG_FontId2		
	txttitl1 = LAg_AddTextFix(GetSpriteX(Fond1)+width/2,GetSpriteY(Fond1)+15,Title$,FontId,30,5)
	SetTextAlignment(txttitl1,1)
	
	Sync()
	
	txt$ = str(i1)+"/"+str(txttitl1)
	
Endfunction  txt$

Function FreeLoadIngWindow(LoadId$)

	//Free the loading window
	DeleteText(val(GetStringToken(LoadId$,"/",2)))	
	LAG_FreeMenuBox(val(GetStringToken(LoadId$,"/",1)))	
	
endfunction






// Bank & Model 3D
Function ImportModel(doc$, loaddoc)
	
	// To import a model : dae, x, or fpe
	if loaddoc= 0
		
		/*
		patern$ = "*.fpe;*.dae;*.x;*.obj;*.b3d;*.blend;*.3ds;*.md3;*.smd;*.low;*.ac;*.3d;*.ms3d;*.m3;*.ago;"
		Doc$ = ChooseRawFile(patern$, 1) 
		ext$ = GetExtensionFile(doc$)
		doc$ = GetFilePart(doc$)
		doc$ = "scenes\"+doc$+ext$
		*/
		
	
		Doc$ = LAG_OpenFile("Import a model","models/","Model FPE|*.fpe|3D Files|*.dae;*.x;*.obj;*.b3d;*.blend;*.3ds;*.md3;*.smd;*.low;*.ac;*.3d;*.ms3d;*.m3;*.ago|Dae|*.dae|X|*.x|Obj|*.obj|B3D|*.b3d|3DS|*.3ds|",0,800,600,1) // in LAG_Util.agc
		
		// .X .3ds .md3 .smd .md5 .lwo. .ac .b3d .dae .3d .lws .ms3d .blend .m3 .obj and .ago

	endif
	
	FoldStart // open the file
		
		
		LoadId$ = CreateLoadingWindow("Model loading, please wait...")
		
		if loaddoc = 0
			
			// check multi-opening
			if File_ToLoad$.length > 0
				nbFiletoload = File_ToLoad$.length
			endif
			
			// then load one by one
			For ftl=0 to File_ToLoad$.length
				
				Doc$ = File_ToLoad$[ftl]
				
				if Doc$ <> "" and GetFileExists(doc$)
				
					ImportZemodel(Doc$)
				
				endif
				
			Next ftl
			
					
			undim File_ToLoad$[] 
		
		else
			
			ImportZemodel(Doc$)
			
		endif
			
		FreeLoadingWindow(LoadId$)
			
	foldend
	
	
Endfunction

Function ImportZemodel(Doc$)
		
			FoldStart 
			
			
			ShaderN = -1
			ext$ = "."+GetExtensionFile(doc$)
			
			TheFPE_File$ = GetFilePart(doc$)
			Path$ = GetPathPart(doc$)
			
			// preview image	
			Preview$ = path$+TheFPE_File$+".jpg"
				
			If GetFileExists(preview$) = 0	
				Preview$ = path$+TheFPE_File$+".png"
			endif	
			If GetFileExists(preview$) = 0	
				Preview$ = path$+TheFPE_File$+".bmp"
			endif
			
			
			// by default 
			w = 10
			h = 10
			l = 10
			textur$ = ""
			desc$ = ""
			uvscaleu =1
			uvscaleV =1
				
				
			if ext$ <> ".fpe"
				
				// import model (.x, .b3d, .dae, .obj....				
				// doc$ = Left(doc$,len(doc$)-len(ext$))+".fpe"
				
				foldstart 
				
				// verify if this model is in our bank
				For i=0 to BankModel.length 
					if BankModel[i].filename$ = doc$
						// id = BankModel[i].Id
						find = 1
						exit
					endif
				next
					
				FoldStart // pas trouvé, je l'ajoute	
				
				if find=0
										
					ext$ = lower(getextensionfile(doc$))
					ext$ = ReplaceString(ext$, ".", "", 1)
					Animated = 0
					
					/*
					select ext$
						
						case "x", "dae", "blend"
							// Animated = 1
						endcase
						
					endselect
					*/
					
					// .X .3ds .md3 .smd .md5 .lwo. .ac .b3d .dae .3d .lws .ms3d .blend .m3 .obj and .ago
					
					// load object						
					if Animated =0
						id = LoadObject(doc$)
					else					
						id = LoadObjectWithChildren(doc$)					
					endif
					
					
					if id > 0
					
						// check textures if same name :
						
						textur$ = path$+TheFPE_File$+"_D.jpg"
						//message(textur$)
						
						If GetFileExists(textur$) = 1
							imgExists = 1	
						else
							textur$ = path$+TheFPE_File$+"_D.png"
							If GetFileExists(textur$) = 1
								imgExists = 1	
							endif
						endif	
					
						// add image
						if imgExists = 1
							
							n = 0						
							local dim imgN[n]
							local dim textured$[n] 
							textured$[n] = textur$

							// on ajoute la texture à la banque texture
							// n = imgN.length									
							local dim Img_[n]					
							
							//For j= 0 to imgN.length	
							j= n
							find = 0
							name$ = path$+textured$[j]											  
								
							if name$ <> "" and GetFileExists(name$)
									
								FoldStart // si l'image est dans le dossier		
									
									For i=0 to Texture.length 
										if Texture[i].Filename$ = name$ // path$+textured$[j]
											find = 1
											//message("on a cette texture : "+path$+textured$[j])
											img_[j] = Texture[i].img
											ImgN[j] = i
											exit
										endif
									next
									
									// image not found, add it to the texture bank
									if find=0
										//message("on n'a pas cette texture,on l'ajoute : "+path$+textured$[j])							
										AddTextureToBank(path$+textured$[j],1,1)
										n = Texture.length
										img_[j] = Texture[n].img
										ImgN[j] = n
									endif
									
								foldend
								
							else
								
								FoldStart // image not in the folder, but perahp's exist
								
								name$ = textured$[j]
								
								if name$ <> "" and GetFileExists(name$) 
									
									For i=0 to Texture.length 
										if Texture[i].Filename$ = name$
											find = 1
											//message("on a cette texture : "+name$)
											img_[j] = Texture[i].img
											ImgN[j] = i
											exit
										endif
									next
									
									if find=0
										//message("on n'a pas cette texture,on l'ajoute : "+path$+textured$[j])							
										AddTextureToBank(name$,1,1)
										n = Texture.length
										img_[j] = Texture[n].img
										ImgN[j] = n
									endif
									
								else
									
									// Message("The image doesn't exists : "+name$)
								
								endif
								
								Foldend
							
							endif
							
							//NExt
							
						endif
					
					endif
					
					
				endif
				
				
				foldend 
				
				filename$ = doc$
				Desc$ = TheFPE_File$+"."+ext$
				
				foldend 
				
			else 
				// *.FPE model // message("j'importe un model : "+doc$)
				FoldStart 
				info$ = ""

				
				// on ouvre le fichier
				filim = OpenToRead(doc$)
				
				if filim
					
					
					local dim imgN[]					
					local dim textured$[] 
					
					
					While FileEOF(filim)=0
						
						Line$ = ReplaceString(ReadLine(filim)," ","",-1)
						Line$ = ReplaceString(Line$,chr(9),"",-1)
						index1$ = GetStringToken(line$,"=",1)
						index2$ = GetStringToken(line$,"=",2)
						info$ = info$ + line$
						
						if index1$ <> ""
							
							select index1$
								
								case "desc"
									desc$ = index2$
								endcase
								
								case "textured", "textured2", "textured3", "textured4", "textured5", "textured6","textured7","textured8"
									
									textur$ = index2$
									ext$ = GetExtensionFile(textur$)
									
									if ext$ = "dds"
										LAG_message("Error","Error in the fpe file, the image should be in jpg or png, not in dds. A jpg image would be tested, by default.","")
										textur$ = ReplaceString(textur$,ext$,"jpg",1)
									endif	
																
									n = val(ReplaceString(index1$,"textured","",1)) -1
									if n < 0
										n = 0
									endif
									/*
									if index1$ ="textured"
										dim imgN[0]
										dim textured$[0]
										textured$[0] = textur$
									elseif index1$ ="textured2"
										dim imgN[1]
										dim textured$[1] 
										textured$[1] = textur$
									elseif index1$ ="textured3"
										n =
									elseif index1$ ="textured4"
										n = 3									
									elseif index1$ ="textured5"
										n =4
									endif
									*/
									local dim imgN[n]
									local dim textured$[n] 
									textured$[n] = textur$ // filename$
									
								endcase
								
								case "shader"
									Shader$ = index2$
								endcase
								
								case "wrap"
									wrap = val(index2$)
								endcase
								
								case "uvscaleu"
									uvscaleu = val(index2$)
								endcase
								case "uvscalev"
									uvscalev = val(index2$)
								endcase
								
								case "uvoffsetx"
									uvoffsetx = val(index2$)
								endcase
								case "uvoffsety"
									uvoffsety = val(index2$)
								endcase
								
								case "w"
									w =  val(index2$)
								endcase
								case "h"
									h =  val(index2$)
								endcase
								case "l"
									l =  val(index2$)
								endcase
								
								Case "normal"
									Normalmap = val(index2$)
									message("bank mode has normalmap")
								endcase
								Case "lightmap"
									Uselightmap = val(index2$)
								endcase
								
								case "model"
									model$ = index2$
								endcase
								
								case "animated","playanimineditor"								
									Animated = val(index2$)
								endcase
								
								case "anim0"   
									Anim0$ = index2$
								endcase
								
								case "animspeed"								
									AnimSpeed = val(index2$)
								endcase
								
							endselect
						
						endif
						
					endwhile
					
					Closefile(filim)
				endif
			
				//Message("lecture terminée du fichier fpe")			
				// count = FindStringCount(Doc$, "/" ) 
				// enfin, On ajoute le model à la bank
				
				/*
				Message("le chemin du model : "+path$)
				Message("le fichier fpe : "+TheFPE_File$)
				Message("l'extension : "+ext$)
				*/
				
				// d'abord, je vérifie qu'on n'a pas déjà ce model dans notre bank
				if getextensionfile(model$) <> ""
					Find = 0
					For i=0 to BankModel.length 
						if BankModel[i].name$ = Path$+model$ //path$+model$
							if BankModel[i].filename$ <> doc$ //path$+model$
								// id = BankModel[i].Id
								// ModelId = i
								find = 0
								exit
							else
								id = BankModel[i].Id
								find = 1
								exit
							endif
						endif
					next
				endif
					
				// pas trouvé, je l'ajoute	
				if find=0
					
					if GetExtensionFile(model$) <> ""
						// je load l'object	
						ObjTyp = C_OBJBANK				
						if Animated =0
							id = LoadObject(Path$+model$)
						else					
							id = LoadObjectWithChildren(Path$+model$)					
						endif
					else
						
						select model$
						
							case "box"
								ObjTyp = C_OBJBOX
								id = CreateObjectBox(w,h,l)
							endcase
							case "sphere"
								ObjTyp = C_OBJSPHERE
								id = CreateObjectSphere(w,h,l)
							endcase
							case "capsule"
								ObjTyp = C_OBJCAPSULE
								id = CreateObjectCapsule(w,h,l)
							endcase
							case "plane"
								ObjTyp = C_OBJPLANE
								id = CreateObjectPlane(w,h)
							endcase
							case "cone"
								ObjTyp = C_OBJCONE
								id = CreateObjectCone(w,h,l)
							endcase
							case "cylinder"
								ObjTyp = C_OBJCYLINDER
								id = CreateObjectCylinder(w,h,l)
							endcase
							
						endselect
						
					endif
				
				endif
				
				
				if id > 0
					
					FoldStart // On ajoute les textures et son shader aux banques.
					
					// pour les bank, voir images.agc
					
					FOLDSTART // TEXTURE : on ajoute la texture à la banque texture
					n = imgN.length									
					local dim Img_[n]
					
					// by default I should set to -1
					For j= 0 to imgN.length
						Img_[j] = -1
					next
					For j= 0 to imgN.length
						imgN[j] = -1
					next
						
						
						
					// Message ("nbre de texture pour ce model : "+str(n))
					
					For j= 0 to imgN.length
							
						find = 0
						name$ = path$+textured$[j]											  
						
						if name$ <> "" and GetFileExists(name$)
							
							VerifyTexture(j, name$)
							
						else
							
							FoldStart // on doit utiliser le nom en absolute, le nom = le chamin complet + nom de l'image
							name$ = textured$[j]
							if name$ <> "" and GetFileExists(name$) 
								
								VerifyTexture(j, name$)
								/*
								For i=0 to Texture.length 
									if Texture[i].Filename$ = name$
										find = 1
										//message("on a cette texture : "+name$)
										img_[j] = Texture[i].img
										ImgN[j] = i
										exit
									endif
								next
								
								if find=0
									//message("on n'a pas cette texture,on l'ajoute : "+path$+textured$[j])							
									AddTextureToBank(name$,1,1)
									n = Texture.length
									img_[j] = Texture[n].img
									ImgN[j] = n
								endif
								*/
							else
								//Message("The image doesn't exists : "+name$)
							endif
							Foldend
						endif
					NExt
					
					Foldend

						
					FoldStart // SHADER : on ajoute le shader à la banque shader
					
					Find =0	
					if path$ + Shader$ <> "" and GetFileExists(path$+Shader$+".vs")
						FoldStart //si le shader est dans le dossier
						For i=0 to ShaderBank.length 
							if ShaderBank[i].Filename$ = path$+Shader$
								find = 1
								ShaderId = ShaderBank[i].Shader
								ShaderN = i
								exit
							endif
						next
						if find=0							
							AddShaderToBank(path$+Shader$,1,Shader$)
							n = ShaderBank.length
							if n>-1
								ShaderId = ShaderBank[n].Shader
								ShaderN = n
							else
								ShaderN =-1
							endif
						endif
						Foldend
					else
						// sinon, on utilise peut-être un shader du dossier shaders
						// message("Shader dans un autre dossier que le dossier de l'objet : "+Shader$+".vs")
						if GetFileExists(Shader$+".vs")
							For i=0 to ShaderBank.length 
								if ShaderBank[i].Filename$ = Shader$
									find = 1
									ShaderId = ShaderBank[i].Shader
									ShaderN = i
									exit
								endif
							next
							if find=0							
								AddShaderToBank(Shader$,1,Shader$)
								n = ShaderBank.length
								if n>-1
									ShaderId = ShaderBank[n].Shader
									ShaderN = n
								else
									ShaderN =-1
								endif								
							endif
						else
							ShaderN = -1
						endif
					endif
					
					foldend
					
					foldend
					
				endif
			
				filename$ = Path$+Model$
			
				Foldend
			
			endif
			
			
			
			
			
			FoldStart // enfin on ajoute le model à la banque model
	
			if id >0
					
					
				Find =0
					
				// on a vérifier plus haut si on ne l'avait pas
				n = BankModel.length+1
				Dim bankModel[n] as tBankModel			
				bankModel[n].Id = id
				bankModel[n].name$ = Filename$
				bankModel[n].filename$ = doc$ //Filename$
				BankModel[n].Info$ = info$
				
				// images, shader					
				BankModel[n].Img.length = imgN.length
				For j= 0 to imgN.length		
					BankModel[n].Img[j].TextureId = imgN[j]		
					BankModel[n].Img[j].img = img_[j]							
				next		
				BankModel[n].Shader = ShaderN
				BankModel[n].Normalmap = normalmap
				BankModel[n].Lightmap = Uselightmap
					
				// animation
				BankModel[n].Animated = Animated
				BankModel[n].AnimSpeed = AnimSpeed
				BankModel[n].Anim[0] = Anim0$
				
				
				For j=0 to imgN.length
					BankModel[n].Img[j].img = -1
					if img_[j] > 0						
						if BankModel[n].Normalmap = 1 and j = 2
							SetObjectNormalMap(id, ImgN[j])
						else
							SetObjectImage(id, img_[j], j)								
						endif
						BankModel[n].Img[j].TextureId = ImgN[j]
						BankModel[n].Img[j].img = img_[j] 
						BankModel[n].Img[j].scaleW  = 1
						BankModel[n].Img[j].scaleH  = 1
						// because : 
						//img_[j] = Texture[n].img
						//ImgN[j] = n
					endif
				next
					
				
				
				
					
				// scale et offset uniquement stage 0 pour le moment
				if ImgN.length >= 0
					BankModel[n].Img[0].scaleW  = 1
					BankModel[n].Img[0].scaleH  = 1	
					if uvscaleU > 0 and uvscaleV > 0 
						BankModel[n].Img[0].scaleW  = uvscaleU
						BankModel[n].Img[0].scaleH  = uvscaleV							
						SetObjectUVScale(id,0,uvscaleU,uvscaleV)
					endif
					BankModel[n].Img[0].OffsetX  = uvoffsetx
					BankModel[n].Img[0].Offsety  = uvoffsety
					SetObjectUVOffset(id, 0, uvoffsetx, uvoffsety)
				endif
				
				// shader
				if Shader$ <> "" or ShaderId <> -1 //and shaderID						
					SetObjectShader(id, ShaderId)
				endif
			
				// on cache l'objet en -100000
				SetObjectPosition(id, -100000, -100000, -100000)
				// SetObjectPosition(id, 0, 0, 0)
				SetObjectVisible(id, 0)
				
				// on remet tout à zéro
				img_.length = -1
				imgN.length = -1
				Textured$.length = -1
				undim img_[]
				undim imgN[]
				undim Textured$[]
				
				
				if desc$ = ""
					desc$ = GetFilePart(Model$)
				endif
				
				// Pour terminer, je crée le gadget image pour sélectionner le model par la suite et l'ajouter à mon level si je clic sur "+"				
				LAG_AddGadgetItem(C_Gad_BankList, n, Desc$, loadimage(Preview$))
				
			endif
			
			Foldend
			
			
				
			Foldend
			
endfunction


Function VerifyTexture(j, name$)
	
	FoldStart // si l'image est dans le dossier		
							
	For i=0 to Texture.length 
		if Texture[i].Filename$ = name$
			find = 1
			//message("on a cette texture : "+path$+textured$[j])
			img_[j] = Texture[i].img
			ImgN[j] = i
			exit
		endif
	next
	
	if find=0
		//message("on n'a pas cette texture,on l'ajoute : "+path$+textured$[j])							
		AddTextureToBank(name$, 1, 1)
		//AddTextureToBank(path$+textured$[j],1,1)
		n = Texture.length
		img_[j] = Texture[n].img
		ImgN[j] = n
	endif
	
	foldend
	
	
EndFunction








Function ExportModel()
	
	// Export a FPE file
	
	if objID >-1 and objID <= object.length
	
		doc$ = LAG_SaveFile("Export the model as .FPE", "Default", "")
		
		if doc$ <> ""
	
			Doc$ =  ReplaceExtension(doc$, "fpe")
	
			i = ObjId
	
	
			fil = OpenToWrite(doc$)
			
			if fil > 0
			
				WriteLine(fil, ";header")
				WriteLine(fil, "")
				WriteLine(fil, "desc          = "+Object[i].name$)
				WriteLine(fil, "")
				WriteLine(fil, ";visualinfo")
				
				id = object[i].Stage[0].TextureId
				Textur$ = Texture[id].Filename$				
				WriteLine(fil, "textured      = "+Textur$)
				
				For k =1 to object[i].Stage.length
					id = object[i].Stage[k].TextureId
					if id > -1
						Textur$ = Texture[id].Filename$	
						WriteLine(fil, "textured"+str(k+1)+"     = "+Textur$)
					endif
				next 
				
				// shader, shadows...
				id = Object[i].Shader 
				if id >-1 and id <=  ShaderBank.length   
					Shader$ = ShaderBank[id].Filename$				        
					WriteLine(fil, "shader        = "+Shader$)
				endif
				WriteLine(fil, "castshadow    = "+str(Object[i].ShadowCast))
				WriteLine(fil, "receiveshadow = "+str(Object[i].ShadowRec))
				
				// animation
				WriteLine(fil, "animated      = "+str(Object[i].Animated))
				WriteLine(fil, "animspeed     = "+str(Object[i].Anim.Speed))
				WriteLine(fil, "")
				
				
				WriteLine(fil, ";orientation")
				if object[i].Typ = C_OBJBANK
					id = object[i].IdObj3D					
					model$ = GetFilePart(BankModel[id].name$)+"."+GetExtensionFile(BankModel[id].name$)					
				else
					select object[i].Typ
						
						case C_OBJBOX
							model$ ="box"
						endcase
						case C_OBJSPHERE
							model$ ="sphere"
						endcase
						case C_OBJCAPSULE
							model$ ="capsule"
						endcase
						case C_OBJPLANE
							model$ ="plane"
						endcase
						case C_OBJCONE
							model$ ="cone"
						endcase
						case C_OBJCYLINDER
							model$ ="cylinder"
						endcase
						
					endselect
					
				endif
				WriteLine(fil, "model         = "+model$)
				
				WriteLine(fil, "offx          = 0")
				WriteLine(fil, "offy          = 0")
				WriteLine(fil, "offz          = 0")
				WriteLine(fil, "w          	  = "+str(Object[i].w,1))
				WriteLine(fil, "h             = "+str(Object[i].h,1))
				WriteLine(fil, "l             = "+str(Object[i].l,1))	
				WriteLine(fil, "rotx          = 0")
				WriteLine(fil, "roty          = 0")
				WriteLine(fil, "rotz          = 0")
				WriteLine(fil, "sizx	      = "+str(Object[i].sx,1))
				WriteLine(fil, "sizy	      = "+str(Object[i].Sy,1))
				WriteLine(fil, "sizz	      = "+str(Object[i].Sz,1))
				
				WriteLine(fil, "defaultstatic = 1")
				WriteLine(fil, "materialindex = 1")
				WriteLine(fil, "collisionmode = "+Str(Object[i].Physic))

				CloseFile(fil)
			endif
			
		endif
		
	endif
	
	
	
	
	
	
Endfunction

Function RemoveModelFromBank()
	
	// to remove a model from the bank
	i = Options.BankModelId 
	
	if i >-1 and i<= BankModel.length
		
		DeleteObject(BankModel[i].Id)		
		BankModel.remove(i)
		LAG_FreeGadgetItem(C_Gad_BankList,i)	
		Options.BankModelId = -1
		
	endif
	
EndFunction






// bank preset
Function NewBankPreset()
	
	// d'abord, je réset la banque
	
	n = bankModel.length
	For i = 0 to n
		Options.BankModelId = 0		
		RemoveModelFromBank()
	Next
	
	BankModel.length = -1
	
	// puis je reset les textures
	ResetTextureBank(1)
	
	 
	// puis je reset les Shaders
	ResetShaderBank()
	
	
EndFunction

Function SaveBankPreset(file$,auto)

	d$ =","
	e$ =";"
	
	// to save the model 3D of the current bank
	if File$="" or auto=0
		File$ = "presets/bank/"+LAG_SaveFile("Save bank preset","","")
		ext$ = GetExtensionFile(File$)
		File$ = ReplaceString(file$,ext$,"",1)+".txt"
	endif
	
	if file$ <> ""
		
		
		if GetFileExists(file$) and Options.Ok = 1 and auto =0
			answer = Lag_Message("File exists","Do you want to erase the file ? " + file$,"1|")
		endif
			
		if answer = LAG_ANSWER_YES
			fil = OpenToWrite(file$)
				
			writeline(fil," ; bank preset for AGE")
			
			
			SaveTheBank(1)
			
			
			// general info
			txt$ = "General"+d$+C_version+d$
			writeline(fil,txt$)
			
			writeline(fil," ; Images for the bank preset")
			//** save the image for the level
			For i=0 to libImage.length
				txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
				writeline(fil,txt$)
			next
			
			//** save the models
			writeline(fil," ; Models 3D for the bank preset")
			For i=0 to libModel.length
				txt$ = "Model"+d$ +str(LibModel[i].id)+d$+ libModel[i].Filename$ +d$
				writeline(fil,txt$)
			next
			
			
			

			CloseFile(fil)
		endif
		
	endif
	
EndFunction

Function OpenBankPreset(file$,auto)
	
	
	// to load a bank prest file (img,model 3D)
	
	d$ =","
	e$ =";"
	
	if auto=0 or File$=""
		File$ = LAG_OpenFile("Load Bank preset","presets/bank/","TXT|*.txt",0,-1,-1,0)
		ext$ = GetExtensionFile(File$)
		File$ = ReplaceString(file$,ext$,"",1)
		File$ = ReplaceString(file$,".","",1)
	endif
	
	
	if file$ <> ""
		
		file$ = file$ +".txt"
		
		//message("ouverture fichier atmosphere " + file$)
		if GetFileExists(file$)
			
			fil = OpenToRead(file$)
			
			if fil <> 0
				
				While FileEOF(fil)=0
				
					line$ = ReadLine(fil)
					Index1$ = Lower(GetStringToken(line$,",",1))
					
					select Index1$ 
						
						case  "general"
							
						endcase	
							
						case "img"
							
							// txt$ = "Img"+d$ +str(LibImage[i].id)+d$+ libImage[i].Filename$ +d$
							
							u = 2
							id = val(GetStringToken(line$,d$,u))   : inc u
							filename$ = GetStringToken(line$,d$,u)   : inc u
							// Message("ligne libmodel : "+filename$ + " / OldId : "+str(id))
							
							ok=0
							For i = 0 to Texture.length
								If Texture[i].Filename$ = filename$ 
									Texture[i].OldId = id	
									ok=1
									exit
								endif
							Next
								
							if ok = 0
								AddTextureToBank(filename$,1,1)									
							endif
							
							
						endcase
						
						case "model"
						
						// les modeles 3D utilisés, je dois vérifier si ce modèle est déjà dans notre banque, sinon, je dois le charger.
						// "Model"+d$ +str(LibModel[i].id)+d$+ libModel[i].Filename$ +d$
							u = 2
							id = val(GetStringToken(line$,d$,u))   : inc u
							filename$ = GetStringToken(line$,d$,u)   : inc u
							
							ok=0
							For i = 0 to bankModel.length
								If BankModel[i].name$ = filename$ 
									BankModel[i].OldId = id	
									ok=1
									exit
								endif
							Next
							// on n'a pas trouvé ce model dans notre banque actuelle (si on fait un merge par exemple)
							// on l'ajoute donc à notre banque
							if ok=0
								ImportModel(filename$,1)									
								n = BankModel.length
								if n>-1								
									BankModel[n].OldId = id	
									
								else
									If LAG_Message("Error","The File doesn't exists. Do you wish to load it ?","1|") = LAG_ANSWER_YES
										ImportModel("",0)
										n = BankModel.length
										if n>-1	
											BankModel[n].OldId = id	
										else
											exit
										endif
									endif
								endif								
							endif
						
						endcase 				
						
						
					endselect
					
				endwhile
						
				CloseFile(fil)
				
				
				
				
			else
				message("Unable to load the file : "+file$)	
			endif
		else
			if file$ <> ".txt"
				message("The file ' "+file$+" ' doesn't exist.")	
			endif
		endif
	// else
		// message("Unable to load the file : "+file$)	
	endif
	
	
EndFunction

