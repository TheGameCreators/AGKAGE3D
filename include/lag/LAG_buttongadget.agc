


//****************** Button & ButtonImage Gadget ******************************//


// create the gadgets

Function LAG_ButtonGadget(id, x, y, w, h, txt$, toggle)

    i = LAG_CheckIdGadget(id)

    // add the caracteristics of the gadgets
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h


    LAG_D_Gadget[i].Typ = LAG_c_typButton // the typ
    LAG_D_Gadget[i].Option1 = toggle

    size = 18 // h*0.6
    depth = LAG_D_Gadget[i].depth

    // add the sprite for the gadget
   
   
    if W>=h*3 or h>=w*3
		LAG_D_Gadget[i].id =  SetSpriteSize9Slice( LAG_i_Gadget[LAG_c_iButton], -1, w, h, 4, 4 )
	else
		LAG_D_Gadget[i].id =  LAG_AddSprite(LAG_i_Gadget[LAG_c_iButton], x, y, w, h, 1, depth)
    endif
    
    Sp = LAG_D_Gadget[i].id
    
    LAG_D_Gadget[i].Image[0] = GetSpriteImageID(sp)
       
    LAG_D_Gadget[i].Image.length = 1
    
    if W >= h*2
		SetSpriteSize9Slice( LAG_i_Gadget[LAG_c_iButton+1], LAG_D_Gadget[i].id, w, h, 4, 4 )
    else
		SetSpriteImage(sp, LAG_i_Gadget[LAG_c_iButton+1])
	endif
    LAG_D_Gadget[i].Image[1] = GetSpriteImageID(sp)   
    SetSpriteImage(sp,LAG_D_Gadget[i].Image[0])
    
    
    SetSpritePosition(sp, x, y)
	SetSpriteDepth(sp,depth)
	FixSpriteToScreen(sp,1)


    // add the text of the gadget
    LAG_D_Gadget[i].Text$ = txt$
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+w/2,y+h/2-size/2,depth,1,size)
    LAG_D_Gadget[i].TextX = x+w/2
    LAG_D_Gadget[i].TextY = y+h/2-size/2
    LAG_D_Gadget[i].TextSize = size

    SetTextAlignment(LAG_D_Gadget[i].TextId,1)
	SetTextColor(LAG_D_Gadget[i].textId,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)

	LAG_SetGadgetScissor(sp,i,LAG_D_Gadget[i].TextId,-1)

	
EndFunction i


Function LAG_ButtonImageGadget(id,x,y,w,h,image,toggle)

    i = LAG_CheckIdGadget(id)

    // define the param for the gadget
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_c_typButtonImage // the typ
    LAG_D_Gadget[i].Option1 = toggle

    size = h*0.6
    depth = LAG_D_Gadget[i].depth

    // add the sprite for the gadget (the button)
	if W>=h*3 or h>w*3
		LAG_D_Gadget[i].id =  SetSpriteSize9Slice( LAG_i_Gadget[LAG_c_iButton], -1, w, h, 4, 4 )
	else
		LAG_D_Gadget[i].id =  LAG_AddSprite(LAG_i_Gadget[LAG_c_iButton],x,y,w,h,1,depth)
    endif
    
    Sp = LAG_D_Gadget[i].id    
    LAG_D_Gadget[i].Image[0] = GetSpriteImageID(sp)       
    LAG_D_Gadget[i].Image.length = 1
    
    if W>=h*2
		SetSpriteSize9Slice( LAG_i_Gadget[LAG_c_iButton+1], LAG_D_Gadget[i].id, w, h, 4, 4 )
    else
		SetSpriteImage(sp, LAG_i_Gadget[LAG_c_iButton+1])
	endif
    LAG_D_Gadget[i].Image[1] = GetSpriteImageID(sp)   
    SetSpriteImage(sp,LAG_D_Gadget[i].Image[0])
    
    SetSpritePosition(sp, x, y)
	SetSpriteDepth(sp,depth)
	FixSpriteToScreen(sp,1)

  



    // the image on the button
    LAG_D_Gadget[i].image3 = image
    w1= GetImageWidth(image)
    h1= GetImageHeight(image)
    x1 = x+w/2-w1/2
    y1 = y+h/2-h1/2
    
    //LAG_D_Gadget[i].spr1 = LAG_AddSprite(image,x+2,y+2,w-4,h-4,1,depth)
    LAG_D_Gadget[i].spr1 = LAG_AddSprite(image,x1,y1,w1,h1,1,depth)
    Sp = LAG_D_Gadget[i].spr1
    LAG_D_Gadget[i].spr1X = x1
    LAG_D_Gadget[i].spr1Y = y1

	LAG_SetGadgetScissor(LAG_D_Gadget[i].id,i,-1,sp)


Endfunction i


Function LAG_ButtonCustomGadget(id,x,y,image1,image2, image3,option$)

    /*
    option$ = "w|h|text$|toggle|"

    */
    w = val(GetStringToken(option$,"|",1))
    h = val(GetStringToken(option$,"|",2))
    txt$ = GetStringToken(option$,"|",3)
    toggle = val(GetStringToken(option$,"|",4))

    i = LAG_CheckIdGadget(id)


    // define the param for the gadget
    LAG_D_Gadget[i].Typ = LAG_c_typButtonCustom // the typ
    LAG_D_Gadget[i].Image1 = image1
    LAG_D_Gadget[i].Image2 = image2
    LAG_D_Gadget[i].Option1 = toggle

    if w <= 0
        w = GetImageWidth(image1)
    endif
    if h <=0
        h = GetImageHeight(image1)
    endif

    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h


    size = h*0.6
    depth = LAG_D_Gadget[i].depth



    // add the sprite for the gadget (the button)
    LAG_D_Gadget[i].id =  SetSpriteSize9Slice( LAG_i_Gadget[LAG_c_iButton], -1, w, h, 4, 4 )
    Sp = LAG_D_Gadget[i].id
    SetSpritePosition(sp, x, y)
	SetSpriteDepth(sp,depth)
	FixSpriteToScreen(sp,1)
	LAG_D_Gadget[i].Image[0] = GetSpriteImageID(sp)

    
    //LAG_D_Gadget[i].id = LAG_AddSprite(image1,x,y,w,h,1,depth)
    //Sp = LAG_D_Gadget[i].id

    // the custom image if needed
    if image3 >-1
        LAG_D_Gadget[i].spr1 = LAG_AddSprite(image3,x+w/2-GetImageWidth(image3)/2,y+h/2+GetImageHeight(image3)/2,w,h,1,depth)
    endif

    // add the text of the gadget
    LAG_D_Gadget[i].Text$ = txt$
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+w/2,y+h/2-size/2,depth,1,size)
    LAG_D_Gadget[i].TextX = x+w/2
    LAG_D_Gadget[i].TextY = y+h/2-size/2

    SetTextAlignment(LAG_D_Gadget[i].TextId,1)


	LAG_SetGadgetScissor(sp,i,LAG_D_Gadget[i].TextId,-1)


Endfunction i





