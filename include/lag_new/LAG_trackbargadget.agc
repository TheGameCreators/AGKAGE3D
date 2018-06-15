

Function LAG_TrackbarGadget(id,x,y,w,h,mini,maxi,name$,option$)

    /*
    For option$ :

    option$ = "txt$|snap|drawtext"

    txt$ = the text to draw, at the right of the gadget
    snap : the value of snap step of the gadget
    drawtext = 1 : we draw the text, if =0 we don't draw the text

    */

    i = LAG_CheckIdGadget(id)

    // define parameters
    LAG_SetGadgetDefault(i,x,y,w,8)

    LAG_D_Gadget[i].Typ = LAG_C_TYPTRACKBAR // the typ
    x = LAG_D_Gadget[i].x
    y = LAG_D_Gadget[i].y
    w = LAG_D_Gadget[i].w
    h = LAG_D_Gadget[i].h
	LAg_depth = LAG_D_Gadget[i].depth
 
    size = 16
    h = GetImageHeight(LAG_i_Gadget[LAG_c_iTrackbar])

    // the name for the gadget (the first text, at left)
    LAG_D_Gadget[i].Name$ = name$
    LAG_D_Gadget[i].NameId = LAG_CreateText(name$,x,y+h/2-size/2,LAg_depth,1,size)
    LAG_D_Gadget[i].NameX = x
    LAG_D_Gadget[i].NameY = y+h/2-size/2



	// la barre 
    // add the sprite for the gadget (the bar)
    x = x + len(name$)*7 //GetTextTotalWidth(LAG_D_Gadget[i].NameId)+5
    LAG_D_Gadget[i].id = LAG_AddSprite(LAG_i_Gadget[LAG_c_iTrackbar],x,y,w,h,1,LAg_depth)
    Sp = LAG_D_Gadget[i].id
    
	LAG_D_Gadget[i].OriginX = len(name$)*7


    // slider of the trackbar
    h1 = GetImageHeight(LAG_i_Gadget[LAG_c_iTrackbar2])
    w1 = GetImageWidth(LAG_i_Gadget[LAG_c_iTrackbar2])
	LAG_D_Gadget[i].h2 = h1

    LAG_D_Gadget[i].spr1 = LAG_AddSprite(LAG_i_Gadget[LAG_c_iTrackbar2],x,y-h1/2+h/2,w1,h1,1,LAg_depth)
    LAG_D_Gadget[i].spr1X = x
    LAG_D_Gadget[i].spr1Y = y-h1/2+h/2
	

    // add the text of the gadget
    txt$ = getStringToken(option$, "|",1)
    LAG_D_Gadget[i].Text$ = txt$
    LAG_D_Gadget[i].TextId = LAG_CreateText(txt$,x+w+10,y+h/2-size/2,LAg_depth,1,size-3)
    SetTextColor(LAG_D_Gadget[i].textId,LAG_TextColorR,LAG_TextColorG,LAG_TextColorB,255)

    
    //SetTextAlignment(LAG_D_Gadget[i].TextId,1)
    LAG_D_Gadget[i].TextX = x+w+4
    LAG_D_Gadget[i].TextY = y+h/2-size/2

    // option$ = "txt$|snap|drawtext"
    LAG_D_Gadget[i].mini = mini
    LAG_D_Gadget[i].maxi = maxi

    LAG_D_Gadget[i].option1 = val(getStringToken(option$, "|",3))
    LAG_D_Gadget[i].snap = val(getStringToken(option$, "|",2))


	LAG_SetGadgetScissor(sp,i,-1,LAG_D_Gadget[i].spr1)



EndFunction i

