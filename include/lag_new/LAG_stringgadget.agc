
//**************************  stringgadget

Function LAG_StringGadget(id,x,y,w,h,name$,txt$)


    i = LAG_CheckIdGadget(id)

    // define the param for the gadget
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_C_TYPSTRING // the typ

    depth = LAG_D_Gadget[i].depth
	

    // Create the sprite
    img = LAG_i_Gadget[LAG_c_iString]
    iw# = getImageWidth(img)
    ih# = getImageHeight(img)
	
	//x1 = len(name$)*7.5
	
	
    LAG_D_Gadget[i].name$ = name$
    LAG_D_Gadget[i].nameId = LAG_CreateText(name$,x,y+2,depth,1,18) // h-4)
    LAG_D_Gadget[i].NameX = x
    LAG_D_Gadget[i].NameY = y+2
    LAG_D_Gadget[i].TextSize = 16 // h-4
    
	x1 =  len(name$)*7.5 
	if x1 < 20
		x1 = x1 + 5
	endif 
	//GetTextTotalWidth(LAG_D_Gadget[i].nameId) + 2 // len(name$)*7.5 // + 5 // GetTextTotalWidth(LAG_D_Gadget[i].nameId) + 5 
	/*
	x1 = x1 / 10
	x1 = (x1 * 10) + 5
	*/
	
    // create the sprite
    LAG_D_Gadget[i].id = LAG_AddSprite(img,x+x1,y,w,h,1,depth)
    Spr = LAG_D_Gadget[i].id
    LAG_D_Gadget[i].X = x+x1
    LAG_D_Gadget[i].Y = y

    
    // create a textbox
    LAG_D_Gadget[i].Text$ = txt$   
    LAG_d_Gadget[i].EditBoxId = Lag_AddEditBox(0,x+x1+2,y+2,w,h-2,1,depth,0,name$)
    sp = LAG_d_Gadget[i].EditBoxId
    LAG_D_Gadget[i].TextX = x+x1+2
    LAG_D_Gadget[i].TextY = y+2
	
    SetEditBoxText(sp,txt$)
    SetEditBoxTextColor(sp,	LAG_TextColorR,LAG_TextColorG,LAG_TextColorB) 
	SetEditBoxScissor(sp,x+x1+2,y+2,x+x1+2+w,y+h)
	
	LAG_SetGadgetScissor(1,i,1,1)
	
	

EndFunction i

Function LAG_ActiveStringGadget(id,active)
	
	SetEditBoxActive(LAG_d_Gadget[id].EditBoxId,active)
	
EndFunction




