
//**************************  editorgadget

Function LAG_EditorGadget(id,x,y,w,h,txt$,wordwrap,readonly,alignment,alpha)
	
	/*

    option$ = "img|alpha|wordwrap|alignment|"

    - img = the image for the gadget
    - alpha : the transparency of the gadget
    - wordwrap : is the gadget wordwrap or not
    - alignment : the alignment of the text
    - readonly

    */

    i = LAG_CheckIdGadget(id)

    // define the param for the gadget
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_C_TYPEDITOR // the typ

    depth = LAG_D_Gadget[i].depth
	name$ = ""

    // Create the sprite
    if Readonly = 0
		img = LAG_i_Gadget[LAG_c_iString]
    else
		img =0
	endif
    iw# = getImageWidth(img)
    ih# = getImageHeight(img)
	
	LAG_D_Gadget[i].TextSize = 18
	
    // create the sprite background
    LAG_D_Gadget[i].id = LAG_AddSprite(img,x,y,w,h,1,depth)
    Spr = LAG_D_Gadget[i].id
    LAG_D_Gadget[i].X = x
    LAG_D_Gadget[i].Y = y

    
    // create a textbox
    LAG_D_Gadget[i].Text$ = txt$ 
    LAG_D_Gadget[i].TextX = x
	LAG_D_Gadget[i].TextY = y+2
	
	LAG_d_Gadget[i].option1 = Readonly
		
		
    if Readonly = 1
		LAG_d_Gadget[i].textId = LAG_CreateText(txt$,x+4,y+2,depth,1,18) 
		//Lag_AddText(0,x,y,w,h-2,1,depth,0,name$) txt$,
		sp = LAG_d_Gadget[i].textId
		
		SetTextColor(sp,255,255,255,255) // LAG_TextColorR,LAG_TextColorG,LAG_TextColorB) 
		if wordwrap
			SetTextMaxWidth(sp,w-40)
		endif
		//SetEditBoxMultiLine(sp,1)
		//SetTextSize(sp,18)
		SetspriteColor(spr,0,0,0,alpha)
		u=90
		//SetSpriteColor(spr,u,u,u,150)
		SetTextScissor(sp,x,y+2,x+w,y+h-2)
		
	else  
		LAG_d_Gadget[i].EditBoxId = Lag_AddEditBox(0,x,y,w,h-2,1,depth,0,name$)
		sp = LAG_d_Gadget[i].EditBoxId
				
		SetEditBoxText(sp,txt$)
		SetEditBoxTextColor(sp,	255,255,255) // LAG_TextColorR,LAG_TextColorG,LAG_TextColorB) 
		SetEditBoxWrapMode(sp,wordwrap)
		SetEditBoxMultiLine(sp,1)
		SetEditBoxTextSize(sp,18)
		SetEditBoxBackgroundColor(sp,55,55,55,100)
		u=90
		SetEditBoxBorderColor(sp,u,u,u,150)
	endif
	
	LAG_SetGadgetScissor(sp,i,-1,Spr)
	
	LAG_CreateSlider(i,LAG_i_Gadget[LAG_C_ISLIDER],depth,w,h) // dans LAG_listicongadget.agc

	LAG_SetGadgetGroup(i,0,-1)

EndFunction i


