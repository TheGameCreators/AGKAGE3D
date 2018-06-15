

//****************** TextGadget ******************************//



Function LAG_TextGadget(id,x,y,w,h,txt$,option$)

    /*

    option$ = "img|alpha|wordwrap|alignment|"

    - img = the image for the gadget
    - alpha : the transparency of the gadget
    - wordwrap : is the gadget wordwrap or not
    - alignment : the alignment of the text

    */

    i = LAG_CheckIdGadget(id)

    // define the param for the gadget
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_c_typText // the typ

    size = 18 // h*0.6
    depth = LAG_D_Gadget[i].depth

    // option$
    img = val(GetStringToken(option$, "|",1))
    alpha = val(GetStringToken(option$, "|",2))
    wordwrap = val(GetStringToken(option$, "|",3))
    alignment = val(GetStringToken(option$, "|",4))

    // add the sprite for the gadget (the button)
    if img = -1
        img = LAG_i_Gadget[LAG_c_iString]
    endif
    LAG_D_Gadget[i].id = LAG_AddSprite(img,x,y,w,h,1,depth)
    Sp = LAG_D_Gadget[i].id
    SetSpriteColor(SP,255,255,255,alpha)

    // text
    LAG_D_Gadget[i].Text$ = txt$
    if wordwrap = 0
		yy = y+h/2-size/2
    else
		yy= y
	endif
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+4,yy,depth,1,size)
    
    txtId = LAG_D_Gadget[i].TextId
    LAG_D_Gadget[i].TextSize = size

    // alignment
    SetTextAlignment(txtId,alignment)
    select alignment
        case 1 // center
            SettextPosition(txtId,x+w/2,yy)
        endcase
        case 2 // right
            SettextPosition(txtId, x+w-4,yy)
        endcase
    endselect

	SetTextColor(txtId,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)


    LAG_D_Gadget[i].TextX = x+4
    LAG_D_Gadget[i].TextY = y
    SetTextScissor(LAG_D_Gadget[i].TextId,x,y,x+w,y+h)
    if wordwrap = 1
        SetTextMaxWidth(LAG_D_Gadget[i].TextId,w)
    endif

	LAG_SetGadgetScissor(sp,i,txtId,-1)


EndFunction i




