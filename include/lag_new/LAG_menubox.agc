

//******************* MENUBOX FOR LAG **********************//

// Menubox by Baxlash, thanks ;)
type Lag_menuboxType

    // editor
    Nom$
    actif as integer // si =1 il existe, sinon, on l'a supprimé
    NumSp as integer // le numéro du sprite (pour l'identifier en cliquant dessus)
    Selected as integer // est-il selectionné ?
    Image as integer // l'image que le menu utilise
    Depth as integer // son depth
    visible as integer

    // parametres
    x as float
    y as float
    width as float
    height as float
    // les sprite pour l'afficahge
    spr1 as integer
    spr2 as integer
    spr3 as integer
    spr4 as integer
    alpha as integer

endtype


Function LAG_InitMenuBox()
	
	// variables for the menu box, and arrays
	global LAG_mbNum = -1
	global dim LAG_menubox[LAG_mbNum] as Lag_menuboxType


	// image for the menu box
	/*
	global LAG_NbImgMenu as integer
	LAG_NbImgMenu = 2
	Global dim LAG_iMenuBox[LAG_NbImgMenu] as integer
	for i = 0 to LAG_NbImgMenu
		LAG_iMenuBox[i] = loadImage("ui\corner\corner"+str(i+1)+".png")
	next
	*/
	
EndFunction


// create
Function LAG_CreateMenuBox(x as float, y as float, width as float, height as float, img1, alpha)

    // by Baxslash : thanks ! // modifie by blendman for LAG
    
    
    // first, check if there is a menubox free 
	id = -1
	if LAG_menubox.length > -1
		for i=0 to LAG_menubox.length
			if LAG_menubox[i].actif = 0
				id =i
				exit
			endif
		next
	endif
	
	// no menubox free, we add one new
	if id = -1
		inc LAG_mbNum
		global dim LAG_menubox[LAG_mbNum] as LAG_menuboxType
		id = LAG_mbNum
	endif
	
	LAG_menubox[id].actif = 1
	
	// then create the menubox
	depth = 4
	
	if img1 > LAG_i_gadget.length
		img1 = LAG_C_ICORNER
	endif
    LAG_menubox[id].image =  LAG_i_Gadget[img1] // img



    img =  LAG_i_Gadget[img1] // LAG_iMenuBox[img]
    LAG_menubox[id].alpha = alpha
    
	

    iw# = getImageWidth(img)
    ih# = getImageHeight(img)

    if width<iw#*2 then width = iw#*2
    if height<ih#*2 then height = ih#*2

	

    spr = createSprite(img)
    SpNew = spr
    setSpriteSize(spr, width - iw#, height - ih#)
    setSpritePosition(spr, x, y)
    setSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
    LAG_menubox[id].spr1 = spr
    SetSpriteDepth(spr,depth)
    FixSpriteToScreen(spr,1)

    spr = createSprite(img)
    setSpriteSize(spr, width - iw#, ih#)
    setSpritePosition(spr, x, y + height - ih#)
    setSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
    setSpriteFlip(spr, 0, 1)
    LAG_menubox[id].spr2 = spr
    SetSpriteDepth(spr,depth)
    FixSpriteToScreen(spr,1)

    spr = createSprite(img)
    setSpriteSize(spr, iw#, height - ih#)
    setSpritePosition(spr, x + width - iw#, y)
    setSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
    setSpriteFlip(spr, 1, 0)
    LAG_menubox[id].spr3 = spr
    SetSpriteDepth(spr,depth)
    FixSpriteToScreen(spr,1)

    spr = createSprite(img)
    setSpriteSize(spr, iw#, ih#)
    setSpritePosition(spr, x + width - iw#, y + height - ih#)
    setSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
    setSpriteFlip(spr, 1, 1)
    SetSpriteDepth(spr,depth)
    LAG_menubox[id].spr4 = spr
    FixSpriteToScreen(spr,1)

    LAG_menubox[id].x = x
    LAG_menubox[id].y = y
    LAG_menubox[id].width = width
    LAG_menubox[id].height = height

endfunction id // spnew


// Set (change)
Function LAG_SetMenuBoxColor(id,r,g,b)
	
	SetSpriteColor(LAG_menubox[id].spr1,r,g,b,LAG_menubox[id].alpha) 
	SetSpriteColor(LAG_menubox[id].spr2,r,g,b,LAG_menubox[id].alpha) 
	SetSpriteColor(LAG_menubox[id].spr3,r,g,b,LAG_menubox[id].alpha) 
	SetSpriteColor(LAG_menubox[id].spr4,r,g,b,LAG_menubox[id].alpha) 
	
	
EndFunction

Function LAG_setMenuBoxDepth(id,depth)

	SetSpriteDepth(LAG_menubox[id].spr1,depth) 
	SetSpriteDepth(LAG_menubox[id].spr2,depth) 
	SetSpriteDepth(LAG_menubox[id].spr3,depth) 
	SetSpriteDepth(LAG_menubox[id].spr4,depth) 
	
Endfunction

Function LAG_SetMenuBoxPosition(id,x,y)
	
	img = LAG_menubox[id].image
	iw# = getImageWidth(img)
    ih# = getImageHeight(img)
	width = LAG_menubox[id].width
	height = LAG_menubox[id].height
	LAG_menubox[id].x = x
	LAG_menubox[id].y = y
	
	SetSpritePosition(LAG_menubox[id].spr1, x, y) 
	SetSpritePosition(LAG_menubox[id].spr2, x, y + height - ih#) 
	SetSpritePosition(LAG_menubox[id].spr3, x + width - iw#, y) 
	SetSpritePosition(LAG_menubox[id].spr4, x + width - iw#, y + height - ih#)
	 
EndFunction

Function LAg_setMenuBoxSize(id,width,height)
	
	img = LAG_menubox[id].image
	iw# = getImageWidth(img)
    ih# = getImageHeight(img)
	LAG_menubox[id].width = width
	LAG_menubox[id].height = height
	
	setSpriteSize(LAG_menubox[id].spr1, width - iw#, height - ih#)
	setSpriteSize(LAG_menubox[id].spr2, width - iw#, ih#)
	setSpriteSize(LAG_menubox[id].spr3, iw#, height - ih#)
	setSpriteSize(LAG_menubox[id].spr4, iw#, ih#)
	
	x = LAG_menubox[id].x
	y = LAG_menubox[id].y
	
	LAG_SetMenuBoxPosition(id,x,y)
	
EndFunction


// GET
Function LAG_GetMenuboxSprite(id)
	
	sp = LAG_menubox[id].spr1
	
EndFunction sp



// free
Function LAG_FreeMenuBox(i)
	
	if i=-1
		i = LAG_menubox.length
	endif
	
	// To free a menubox
	LAG_DeleteSprite(LAG_menubox[i].spr1)
    LAG_DeleteSprite(LAG_menubox[i].spr2)
    LAG_DeleteSprite(LAG_menubox[i].spr3)
    LAG_DeleteSprite(LAG_menubox[i].spr4)
    
    // LAG_menubox.Remove(i) // agk v2 only
    
    LAG_menubox[i].actif = 0 
    
EndFunction

Function LAG_FreeAllMenuBox()

    For i = 0 to LAG_mbNum
        LAG_DeleteSprite(LAG_menubox[i].spr1)
        LAG_DeleteSprite(LAG_menubox[i].spr2)
        LAG_DeleteSprite(LAG_menubox[i].spr3)
        LAG_DeleteSprite(LAG_menubox[i].spr4)
    next i

    LAG_mbNum = -1
    global dim LAG_menubox[] as Lag_menuboxType

EndFunction


// others utils
Function LAG_AddMenu(del,NumSp)

    if del = 0 // add the menu
        LAG_menubox[LAG_mbNum].actif = 1
        LAG_menubox[LAG_mbNum].nom$ = "Menu_"+str(LAG_mbNum)
        LAG_menubox[LAG_mbNum].visible = 1
        LAG_menubox[LAG_mbNum].depth = 10
        LAG_menubox[LAG_mbNum].NumSp = NumSp
        idMenu = LAG_mbNum
    else // delete the menu
        For i = 0 to LAG_mbNum
            if LAG_menubox[i].actif = 1
                if LAG_menubox[i].NumSp = NumSp
                    LAG_DeleteSprite(LAG_menubox[i].spr1)
                    LAG_DeleteSprite(LAG_menubox[i].spr2)
                    LAG_DeleteSprite(LAG_menubox[i].spr3)
                    LAG_DeleteSprite(LAG_menubox[i].spr4)
                    LAG_menubox[i].actif = 0
                    idMenu = -1
                    exit
                endif
            endif
        next i
    endif

EndFunction

Function LAG_DeleteSprite(sp)
	
    if GetSpriteExists(sp) and sp > 10000
        DeleteSprite(sp)
    endif
    
EndFunction




