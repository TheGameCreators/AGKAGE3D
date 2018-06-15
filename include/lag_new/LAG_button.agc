



// create the button gadgets


Function LAG_ButtonImageGadget(id,x,y,w,h,image,toggle)

    LAG_CheckIdGadget(id)
    i = LAG_V_NbGadget
    // define the param for the gadget
    LAG_D_Gadget[i].Typ = LAG_c_typButtonImage // the typ
    LAG_SetGadgetDefault(i,x,y,w,h)

    LAG_D_Gadget[i].Option1 = toggle

    size = h*0.6

    // add the sprite for the gadget (the button)
    LAG_D_Gadget[i].id = LAG_AddSprite(LAG_i_Gadget[LAG_c_iButton],x,y,w,h,1,5)
    // Sp = LAG_D_Gadget[i].id

    // the image on the button
    LAG_D_Gadget[i].spr1 = LAG_AddSprite(image,x+2,y+2,w-4,h-4,1,5)
    Sp = LAG_D_Gadget[i].spr1

	LAG_SetGadgetScissor(LAG_D_Gadget[i].id,i,-1)
	// need scissor for Sp

Endfunction Sp


Function LAG_ButtonGadget(id, x, y, w, h, txt$, toggle)

    LAG_CheckIdGadget(id)
    i = LAG_V_NbGadget

    // add the caracteristics of the gadgets
    LAG_SetGadgetDefault(i,x,y,w,h)
    LAG_D_Gadget[i].Typ = LAG_c_typButton // the typ
    LAG_D_Gadget[i].Option1 = toggle

    size = h*0.6

    // add the sprite for the gadget
    LAG_D_Gadget[i].id = LAG_AddSprite(LAG_i_Gadget[LAG_c_iButton],x,y,w,h,1,5)
    Sp = LAG_D_Gadget[i].id

    // add the text of the gadget
    LAG_D_Gadget[i].Text$ = txt$
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+w/2,y+h/2-size/2,5,1,size)
    SetTextAlignment(LAG_D_Gadget[i].TextId,1)

	LAG_SetGadgetScissor(sp,i,LAG_D_Gadget[i].TextId)


EndFunction sp

