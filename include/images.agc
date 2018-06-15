

// *********** IMAGES, SHADERS, OBJETS **************//

Type sImage
	
	name$
	image as integer
	alpha as integer // will we use the alpha for the image ? 1 = yes, 0 = no
	
EndType


Type TImgBank
	
	TextureId as integer
	img as integer
	scaleW as integer
	scaleH as integer
	OffsetX as integer
	OffsetY as integer
	
EndType

Type tBankModel
	
	Id as integer
	OldId as integer // uniquement pour charger le model depuis un fichier de sauvegarde, 
	/*
	cet id fait reference à l'id sur le fichier sauvegardé (c'était l'id lors de la session précédente,),  
	je m'en sers uniquement pour ouvrir les models lorsque j'ouvre un document
	Une fois tous les modèles chargés, je ne me sers plus de cet oldid.
	*/
	name$
	Filename$
	Img as TImgBank[0]
	Shader as integer
	Normalmap as integer
	lightmap as integer
	
	Info$
	Used as integer 
	
	Animated as integer
	AnimSpeed as integer
	Anim as string[0]
	
EndType

/*
Type tBankTexture
	
	id as integer
	name$	
	
EndType
*/

Type tTexture
	
	img as integer
	Filename$
	Used as integer // is the texture used ?
	OldId as integer 
	wrap as integer
	
EndType

Type tShader
	
	Name$		
	Used as integer
	ID as integer
	Shader as integer 
	Filename$ 
	OldId as integer 
	
EndType
	
Type tFolder
	
	id 
	name$
	
endtype	
	
	

// list of image, texture
Function ResetTextureBank(ResetTextureBank)

	// d'abord, je supprime toutes les anciennes textures
	
	//if delete all texture from bank-doc
	if ResetTextureBank = 1
		For i=0 to Texture.length
			DeleteImage(Texture[i].img)
		next
		Global dim Texture[] as tTexture
	endif
	
	
	// only update the list of image (change the folder for example)
	For i=0 to ImgList.length
		DeleteImage(ImgList[i].img)
	next
	Global dim ImgList[] as tTexture
	
	
	
	// free item from list
	Lag_FreeallGadgetItemByGadget(C_Gad_ImgList)
	
	
	// the default texture, to start with at least some texture for object 3D
	if options.TextureFolder$ = ""
		options.TextureFolder$ = "default/"		
	endif
	n = CountFilesInFolder("textures/"+options.TextureFolder$,"png/jpg/")
	
	// message("nb texture : "+str(n))
	
	For i = 0 to n
		TheFil$ = "textures/"+options.TextureFolder$+FilImg$[i]
		// AddTextureToBank(TheFil$,0,1)
		AddTextureToList(TheFil$, 0, 1)
	Next
	
	
	// FilImg$[] is in the function CountFilesInFolder()
	FilImg$.length = -1	
	undim FilImg$[]
	
	
	// UpdateTextureList() 
	
	
Endfunction
	
Function AddTextureToBank(file$, used, wrap)
	
	if file$ <> ""
		
		If GetFileExists(file$)
						
			j = texture.length+1
			Dim Texture[j] as tTexture
			Texture[j].Filename$ = File$
			Texture[j].img = LoadImage(File$)
			Texture[j].used= used
			Texture[j].wrap = wrap
			SetImageWrapU(Texture[j].img,wrap)
			SetImageWrapV(Texture[j].img,wrap)
			Textur = Texture[j].img
			
			Desc$ = GetFilePart(Texture[j].Filename$)+"."+GetExtensionFile(Texture[j].Filename$)
			
			img =  Texture[j].img
			// LAG_AddGadgetItem(C_Gad_ImgList, j, Desc$, img)
			
		else
			if file$ <> ""
				message("Unable to load the image file : "+File$+" .This file doesn't exists or can't be opened.")
			endif
		endif
	endif
	
EndFunction j

Function AddTextureToList(file$, used, wrap)
	
	if file$ <> ""
		
		If GetFileExists(file$)
						
			j = ImgList.length+1
			Dim ImgList[j] as tTexture
			ImgList[j].Filename$ = File$
			ImgList[j].img = LoadImage(File$)
			ImgList[j].used= used
			ImgList[j].wrap = wrap
			SetImageWrapU(ImgList[j].img,wrap)
			SetImageWrapV(ImgList[j].img,wrap)
			Textur = ImgList[j].img
			
			Desc$ = GetFilePart(ImgList[j].Filename$)+"."+GetExtensionFile(ImgList[j].Filename$)
			
			img =  ImgList[j].img
			LAG_AddGadgetItem(C_Gad_ImgList, j, Desc$, img)
			
		else
			if file$ <> ""
				message("Unable to load the image file : "+File$+" .This file doesn't exists or can't be opened.")
			endif
		endif
	endif
	
EndFunction j

Function UpdateTextureList()
	
	
	// to update the listicon for texture
	
	
	//delete all items	
	Lag_FreeallGadgetItemByGadget(C_Gad_ImgList)
	

	// add all items
	For kk = 0 to Texture.length
		
		f$ = Texture[kk].Filename$
		Desc$ = GetFilePart(f$)+"."+GetExtensionFile(f$)
		img =  Texture[kk].img
		LAG_AddGadgetItem(C_Gad_ImgList, kk, Desc$, img)
	
	next
	
Endfunction

Function updateListImage()
	
	// to update the list of image in the list icon gadget (panel image)
	LAG_SetGadgetText(C_Gad_ImgFolder, ImgFolder[FolderId].name$)
	options.TextureFolder$ = ImgFolder[FolderId].name$+"/"
	
	if options.listImageTyp = 0 // open the image from current image folder
		ResetTextureBank(0)
	else
		// open the images used currently in the level
		/*
		if ObjTyp = C_OBJPARTSYS
			FoldStart 
			if TextureID<0 
				TextureID = Particle.length
			endif
			if textureId > Particle.length
				TextureID = 0 
			endif														
			imgID=Particle[textureId].img
			Foldend
		else
		
			if TextureID < 0 
				TextureID = Texture.length
			endif
			if textureId > Texture.length
				TextureID = 0 
			endif
			imgID=Texture[textureId].img
		//endif
		*/
		UpdateTextureList()
		if texture.length > -1	
			imgID = Texture[0].img
			LAG_SetGadgetState(C_Gad_BankImg,imgID)
		endif
	endif
	
Endfunction


Function GetCurrentTexture(AddTextureToBank)
	
	if options.listImageTyp = 0
		if TextureId <= ImgList.length
			img = ImgList[TextureId].img
			if AddTextureToBank = 1
				file_0$ =  ImgList[TextureId].Filename$
				
				// verify if we have this texture
				ok = 0
				For i= 0 to texture.length
					if file_0$  = texture[i].Filename$
						ok = 1
						n = i
						exit
					endif
				next 
				
				// not found, add to texture bank
				if ok = 0
					wrap =  ImgList[TextureId].wrap
					n = AddTextureToBank(file_0$, 1, wrap)
				endif
				
				// then we have our image
				img =  Texture[n].img
				
			endif
		endif
	else
		if TextureId <= texture.length
			img = Texture[TextureId].img
		endif
	endif
	
Endfunction img 

Function CheckTextureId()
	
	
	//to verify if we have this texture in our bank or not and use it
	
	if options.listImageTyp = 0
		
		if TextureId <= ImgList.length
			
			file_0$ =  ImgList[TextureId].Filename$
			
			// verify if we have this texture
			ok = 0
			For i= 0 to texture.length
				if file_0$  = texture[i].Filename$
					ok = 1
					n = i
					exit
				endif
			next 
			
			// not found, add to texture bank
			if ok = 0
				wrap =  ImgList[TextureId].wrap
				n = AddTextureToBank(file_0$, 1, wrap)
			endif
			
		endif
	else
		n = TextureId
	endif
	
Endfunction n







// shader
Function ResetShaderBank()
	
	
	
	// if still shader, delete all
	if ShaderBank.length > -1
		for j=0 to ShaderBank.length
			DeleteShader(j+GameProp.shader)
		next
	endif
	
	//message ("shader deleted")
	
	// je charge les shaders
	//Global Dim ShaderBank[] as tShader // je mets 3 shaders de base


	// the default Shaders, to start with at least some shaders for object 3D
	SetFolder("")
	SetFolder("media")
	SetFolder("shaders")
	SetFolder("default")
	
	Dim TheShaderFile$[]	
	n = -1
		
	fn$ = GetFirstFile()
	while fn$ <> ""					
		if GetExtensionFile(fn$) = "vs" and fn$ <> ""
			inc n	
			Dim TheShaderFile$[n]	
			TheShaderFile$[n] = replacestring("shaders/default/"+fn$,".vs","",1)				
		endif
		fn$ = GetNextFile()			
	endwhile	
	SetFolder("")
	SetFolder("media")
	
	//message ("shader found in folder")
	
	For i =0 to TheShaderFile$.length
		ShaderName$ = "" 
		
		shader = AddShaderToBank(TheShaderFile$[i], 0, ShaderName$)
		if TheShaderFile$[i] = "shaders/default/additif"			
			shFx = shader
		endif
	next
	
	TheShaderFile$.length = -1
	Undim TheShaderFile$[]
	
	
	// note: for the moment, there isn't a good shader by default, it's to be improved :)

	
EndFunction

Function AddShaderToBank(file$, used, name$)
	
	// message("Shader : "+File$)
	if file$ <> ""
		If GetFileExists(file$+".vs") and GetFileExists(file$+".ps")
			
			FindShader = 0
			For k=0 to ShaderBank.length
				if ShaderBank[k].Filename$ = File$	
					FindShader = 1
					j = k
					exit
				endif
			next 	
			
			// not find the shader
			if FindShader = 0		
				j = ShaderBank.length+1
				Dim ShaderBank[j] as tShader
				ShaderBank[j].Filename$ = File$	
				ShaderBank[j].Name$ = name$	
				ShaderBank[j].Id = j
				ShaderBank[j].used= used
			endif
			
			
			LoadShader(j+GameProp.shader,File$+".vs",File$+".ps")
			ShaderBank[j].Shader = j + gameProp.shader // LoadShader(File$+".vs",File$+".ps") // j
			Shader = ShaderBank[j].Shader
			//message(File$)
			if GetFilePart(File$) = "refmap01"
				//message("ok")
				//SetShaderConstantByName(Shader,"Scale",0.5,0.5,0,0)
			endif
			
			//message ("shader added to bank " + file$)
			
			
		else
			Ext$ = GetExtensionFile	(File$)
			if ext$ <> ""		
				message("Unable to load the shader file : "+File$+" .This file doesn't exists or can't be opened.")
			endif
		endif
	endif
	
EndFunction shader





// particle
Function AddParticleToBank(File$,used)

	// message("Shader : "+File$)
	if file$ <> ""
		If GetFileExists(file$) 		
			j = Particle.length+1
			Dim Particle[j] as tTexture
			Particle[j].Filename$ = File$	
			Particle[j].used= used
			Particle[j].img = LoadImage(File$)
			Part = Particle[j].img
		else			
			if file$ <> ""	
				message("Unable to load the image file : "+File$+" .This file doesn't exists or can't be opened.")
			endif
		endif
	endif

EndFunction part






// INIT
Function Loading(nb_i)
	Print("Loading : "+str(nb_i)+"%") : nb_i = nb_i+1
	sync()
Endfunction nb_i


Function InitBank()
	
	// pour initialiser les diverses bank : texture, model, shader, fx, AI...
	//Global Dim BankShader[] as tBankTexture
	//Global Dim BankTexture[] as tBankTexture
	Global Dim BankModel[] as tBankModel
	
	Options.BankModelId = -1
	
	

	
	// pas utilisé ??
	//BankTextureId = -1
	//BankShaderId = -1

EndFunction

Function InitImage()
	
	
	//nb_i=Loading(nb_i)
	
	FoldStart //********* IMAGES
	
	// ************* UI
	#Constant iGrid =1
	#Constant iGridx =3
	#Constant iGridy =4
	LoadImage(iGrid,"ui/grid.png")
	LoadImage(iGridx,"ui/gridx.png")
	LoadImage(iGridy,"ui/gridy.png")
	
	
	#Constant iCible =2
	LoadImage(2,"ui/cible_ed.png")


	// 1 à 200 : UI
	#Constant iLight = 50
	LoadImage(iLight,"ui/light.png")
	
	#Constant iCamera = 52
	LoadImage(iCamera,"ui/camera.png")
	
	#Constant iLightmap = 200

	
	// fx particles 
	Dim Particle[] as tTexture
	
	dim FilImg$[]
	n = CountFilesInFolder("textures/part/","png/jpg/")
	
	For i = 0 to n
		// LoadImage(iFx,"textures/part/part"+str(i)+".png")
		TheFil$ = "textures/part/"+FilImg$[i]
		AddParticleToBank(TheFil$,0)
	next
	FilImg$.length = -1	
	

	// the image for UI
	Global dim UiObjImg[C_OBJLAST-1] as integer
	For i= 0 to UiObjImg.length
		UiObjImg[i] = loadImage("ui/objtyp"+str(i)+".jpg")
	next
	
	
	
	
	// ************* textures and list of texture (in folder media\texture\)
	Global FolderId // the id of the folder currently used
	Global dim ImgList[] as tTexture
	
	UpdateImageFolder()
	
	Global dim Texture[] as tTexture
	// ResetTextureBank()
		
	Foldend
	
	
	
	FoldStart //********* SHADERS
	
	// shader for particles
	global shFx as integer
	Global Dim ShaderBank[] as tShader // je mets 3 shaders de base

	Global GridShader
	GridShader = LoadShader("ui/grid.vs","ui/grid.ps")
	
	
	// les shaders
	ResetShaderBank()
		
	
	
	
	
	
	
	Foldend
	
	
	
	FoldStart //********* OBJETS
	
	InitBank()
	
		
	Foldend
	
	
	
		
EndFunction

Function UpdateImageFolder()
	
	Global dim ImgFolder[] as tFolder// the array for folders of image
	
	n = CountFolderInFolder("textures/")
	Global dim ImgFolder[n] as tFolder
	
	for i=0 to TempFolder$.length
		ImgFolder[i].id = n - i
		ImgFolder[i].name$ = TempFolder$[i]
	next
	TempFolder$.length = -1
	
	/*
	for i=0 to ImgFolder.length
		message(str(ImgFolder[i].id)+ " : "+ImgFolder[i].name$)
	next 
	*/
	
	ImgFolder.sort()
	
	/*
	for i=0 to ImgFolder.length
		message(str(ImgFolder[i].id)+ " : "+ImgFolder[i].name$)
	next 
	*/
	
Endfunction







//****************** FUNCTIONS For UI ******************//

function AddSprite(img,x,y,fix,depth)

    if GetSpriteExists(sprite) = 0
        sprite = CreateSprite(img)
    endif
    FixSpriteToScreen(sprite, fix)
    SetSpritePosition(sprite, x, y)
    SetSpriteDepth(sprite, depth)

endfunction sprite




