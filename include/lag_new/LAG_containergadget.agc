

//****************** Container Gadget ******************************//


// create the gadget

Function LAG_ContainerGadget(id, x, y, w, h,img, name$)

    i = LAG_CheckIdGadget(id)

    // add the caracteristics of the gadgets
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h


    LAG_D_Gadget[i].Typ = LAG_C_TYPCONTAINER // the typ

    size = h*0.6
    depth = LAG_D_Gadget[i].depth


	// open the gagdet list
    LAG_OpenGadgetList(i, -1)

    // add the sprite for the gadget
    if img = -1
		img = LAG_i_Menu[LAG_c_iMenu]
	endif
    LAG_D_Gadget[i].id = LAG_AddSprite(img,x,y,w,h,1,depth)
    Sp = LAG_D_Gadget[i].id
	
	if img <= -1 // no image	
		SetSpriteColorAlpha(sp,0)
	else
		c = LAG_ClearColor - 20
		SetSpriteColor(sp, c, c, c, 255)
	endif
	
	// name of the container if needed, to draw a text
	if name$ <> ""
		
		Size = 18
		LAG_D_Gadget[i].Text$ = Name$
		LAG_D_Gadget[i].TextId = LAG_CreateText(Name$, x+5, y+5, depth, 1, size)
		LAG_D_Gadget[i].TextX = x + 5
		LAG_D_Gadget[i].TextY = y + 5
		LAG_D_Gadget[i].TextSize = size

		SetTextColor(LAG_D_Gadget[i].textId, LAG_TextColorR, LAG_TextColorG, LAG_TextColorB, 255)

		LAG_SetGadgetScissor(sp, i, LAG_D_Gadget[i].TextId, -1)

	endif
	
	/*
	if LAG_CurrGadgetId > -1
		MEssage("JE crée le container : "+str(id)+" | Son parent est : "+str(LAG_CurrGadgetId))		
	endif
	*/
	// LAG_SetGadgetScissor(sp,i,LAG_D_Gadget[i].TextId,-1)
	
	//set the group for this container, for all child gadget
	LAG_SetGadgetGroup(i,0,-1)
	
	
	
EndFunction i



