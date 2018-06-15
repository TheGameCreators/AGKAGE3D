

//****************** CheckboxGadget ******************************//


Function LAG_CheckBoxGadget(id, x, y, w, h, txt$)

    i =LAG_CheckIdGadget(id)

    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_c_typCheckbox // the typ
    depth = LAG_D_Gadget[i].depth


    LAG_D_Gadget[i].id = LAG_AddSprite(LAG_i_Gadget[LAG_c_iCheckbox],x,y,h,h,1,depth)
    Sp = LAG_D_Gadget[i].id

    LAG_D_Gadget[i].Text$ = txt$
    if h>20
		h2 = h-4
		y1 = 2
	else
		h2 = h
	endif
	if h2< 14
		h2 = 14
	endif
	
	u = 18
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+u,y-y1,depth,1,h2)
	SetTextColor(LAG_D_Gadget[i].textId,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)
    LAG_D_Gadget[i].TextSize = h2
	LAG_D_Gadget[i].TextX = X+u
	LAG_D_Gadget[i].TextY =Y-y1
  
	LAG_SetGadgetScissor(sp,i,LAG_D_Gadget[i].TextId,-1)

EndFunction i 


