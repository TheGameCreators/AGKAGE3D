
//****************** PanelGadget ******************************//

// add panel gadget
Function LAG_ListIconGadget(id,x,y,w,h)

    i = LAG_CheckIdGadget(id)

    // define some parameters
    LAG_SetGadgetDefault(i,x,y,w,h)

    // define the param for the gadget
    LAG_D_Gadget[i].Typ = LAG_C_TYPLISTICON // the typ
    depth = LAG_D_Gadget[i].depth
	
    // open the gagdet list
	/*
    LAG_OpenGadgetList(i, -1)

    If LAG_CurrGadgetItemId > -1
        LAG_D_Gadget[i].ItemId = LAG_CurrGadgetItemId // -1 : panel is in another gadget like panel, container or scrollarea
    else
        LAG_D_Gadget[i].ItemId = -1
    endif
	*/

	w = LAG_D_Gadget[i].w
	h = LAG_D_Gadget[i].h 
	
	// the image for the panel
    img = LAG_i_Gadget[LAG_c_iBg]
    iw# = getImageWidth(img)
    ih# = getImageHeight(img)

    // the Background of  the panel
    //img1 = LAG_i_Menu[LAG_c_iMenu]
    img1 = LAG_i_Gadget[LAG_c_iBg] //LAG_i_Menu[LAG_c_iMenuItem]
    a = 1
    LAG_D_Gadget[i].spr1 = LAG_AddSprite(img1,LAG_D_Gadget[i].x-a,LAG_D_Gadget[i].y-a,w+a*2,h+a*2,1,depth)
	LAG_D_Gadget[i].spr1x = LAG_D_Gadget[i].x-a
	LAG_D_Gadget[i].spr1y = LAG_D_Gadget[i].y-a
	Sp = LAG_D_Gadget[i].spr1
	SetSpriteColor(sp,50,50,50,150)
	
    //SetSpriteUVscale(sp, iw# / getSpriteWidth(sp), ih# / getSpriteHeight(sp))
    //SetSpriteFlip(sp,1-miror,0)
    
    
   

    // create the main sprite
    LAG_D_Gadget[i].id = LAG_AddSprite(img,LAG_D_Gadget[i].x,LAG_D_Gadget[i].y ,w,h,1,depth)
    Sp = LAG_D_Gadget[i].id
    SetSpriteUVscale(sp, iw# / getSpriteWidth(sp), ih# / getSpriteHeight(sp))
    //SetSpriteFlip(sp,1-miror,0)

	// set the scissor for the panel
	LAG_SetGadgetScissor(sp,i,-1,-1)
	
	
	LAG_CreateSlider(i,LAG_i_Gadget[LAG_C_ISLIDER],depth,w,h)
	
	
EndFunction Sp

Function LAG_CreateSlider(GadgetId,Image,depth,w,h)

	// to create the slider for some gadgets: list icon, area, editor..
	
	i = GadgetId
	img = image 
	img1 = LAG_i_Gadget[LAG_c_iBg]
	 
	//**** the sliders
	w1 = 15
	h1 = 15
	c = 200
	
	j = LAG_D_Gadget[i].spr.length 
	LAG_D_Gadget[i].spr.length = 4 +j// slider top, center, bottom + the middleslider (not used for the moment)
	inc j 
	
	// ascenceur // slider
	n = LAG_AddSprite(img1,LAG_D_Gadget[i].x+w-w1,LAG_D_Gadget[i].y,w1,h,1,depth)
	LAG_D_Gadget[i].spr[j].id = n
	LAG_D_Gadget[i].spr[j].x = LAG_D_Gadget[i].x+w-w1
	LAG_D_Gadget[i].spr[j].y = LAG_D_Gadget[i].y
	SetSpriteColor(n,c,c,c,255)
	
	LAG_D_Gadget[i].sliderId = j // to know the first element of the slider, to know what element to check  with eventgadget
	
	// haut, top
	c = 150
	n = LAG_AddSprite(img,LAG_D_Gadget[i].x+w-w1,LAG_D_Gadget[i].y,w1,h1,1,depth)
	LAG_D_Gadget[i].spr[j+1].id =n
	LAG_D_Gadget[i].spr[j+1].x =LAG_D_Gadget[i].x+w-w1
	LAG_D_Gadget[i].spr[j+1].y =LAG_D_Gadget[i].y
	SetSpriteColor(n,c,c,c,255)
	
	// bas, bottom  
	n = LAG_AddSprite(img,LAG_D_Gadget[i].x+w-w1,LAG_D_Gadget[i].y+h-h1,w1,h1,1,depth)
	LAG_D_Gadget[i].spr[j+2].id =n
	LAG_D_Gadget[i].spr[j+2].x = LAG_D_Gadget[i].x+w-w1
	LAG_D_Gadget[i].spr[j+2].y = LAG_D_Gadget[i].y+h-h1
	SetSpriteColor(n,c,c,c,255)
	SetSpriteFlip(n,0,1)
	
	// center 
	c=100
	n = LAG_AddSprite(img1,LAG_D_Gadget[i].x+w-w1,LAG_D_Gadget[i].y+h1,w1,h1,1,depth)
	LAG_D_Gadget[i].spr[j+3].id =n
	LAG_D_Gadget[i].spr[j+3].x = LAG_D_Gadget[i].x+w-w1
	LAG_D_Gadget[i].spr[j+3].y = LAG_D_Gadget[i].y+h1
	SetSpriteColor(n,c,c,c,255)
	
	
	
EndFunction
