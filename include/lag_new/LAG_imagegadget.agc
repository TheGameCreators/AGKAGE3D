

//****************** ImageGadget ******************************//


Function LAG_ImageGadget(id,x,y,w,h,image,option$)

    /*
    option$ = "resize|checker|center,imgforcenter|"

    - resize = 1 we resize the image
    - resize = 0 the image is "scissored" // don't work if the gadget is on a panel, container, scrollaera, because it is scissored by the gadget parent

    - checker = 1 : add a checker
	- center = 1 : add a cross for the center
	- imgforcenter : add a cross for the center
    */

    local i,lag_depth,LAg_resize,Lag_checker,LAg_center,lag_w1,lag_h1,lag_sp1,lag_sp,lag_imgcenter as integer
    local lag_cent$
    
    
    
    i = LAG_CheckIdGadget(id)

    // define the param for the gadget
    LAG_SetGadgetDefault(i,x,y,w,h)
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h

    LAG_D_Gadget[i].Typ = LAG_c_typImage // the typ
    lag_depth = LAG_D_Gadget[i].depth

    // options
    lag_resize = val(GetStringToken(option$,"|",1))
    lag_checker = val(GetStringToken(option$,"|",2))
    lag_cent$ = GetStringToken(option$,"|",3)
    lag_center = val(GetStringToken(lag_cent$,",",1))
    //imgcenter = val(GetStringToken(cent$,",",2))

    lag_w1 = w
    lag_h1 = h


    // add the sprite for the gadget (the button)
    if lag_resize = 0
        w = GetImageWidth(image)
        h = GetImageHeight(image)
    endif

    // the checker
    // add the sprite and image
    lag_sp1 = -1
    if lag_checker = 1
        LAG_D_Gadget[i].spr1 = LAG_AddSprite(LAG_i_Gadget[LAG_c_iChecker],x,y,w,h,1,lag_depth)
        lag_sp1 = LAG_D_Gadget[i].spr1
        LAG_D_Gadget[i].spr1x = x
        LAG_D_Gadget[i].spr1y = y
    endif


    // add the sprite and image
    LAG_D_Gadget[i].id = LAG_AddSprite(image,x,y,w,h,1,lag_depth)
    lag_Sp = LAG_D_Gadget[i].id

	if lag_center =1
		lag_imgcenter = LAG_i_Gadget[LAG_C_ICENTER]
		LAG_D_Gadget[i].spr.length = 0
		LAG_D_Gadget[i].spr[0].id = LAG_AddSprite(lag_imgcenter,x,y,-1,-1,1,lag_depth)
		spr = LAG_D_Gadget[i].spr[0].id
		SetSpriteScissor(Spr,x,y,x+lag_w1,y+lag_h1)
		LAG_D_Gadget[i].spr[0].x = x
		LAG_D_Gadget[i].spr[0].y = y
	endif


    if lag_resize = 0// the image is "scissored"
        SetSpriteScissor(lag_Sp,x,y,x+lag_w1,y+lag_h1)
    endif

	LAG_SetGadgetScissor(1,i,-1,1)



Endfunction i

