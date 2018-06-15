


// add panel gadget
Function LAG_PanelGadget(id,x,y,w,h)

    LAG_CheckIdGadget(id)

    i = LAG_V_NbGadget
    // define the param for the gadget
    LAG_D_Gadget[i].Typ = LAG_c_typPanel // the typ

    If LAG_CurrGadgetItemId > -1
        LAG_D_Gadget[i].ItemId = LAG_CurrGadgetItemId // -1 : panel isn't in another gadget like panel, container or scrollarea
    else
        LAG_D_Gadget[i].ItemId = -1
    endif

    LAG_SetGadgetDefault(i,x,y,w,h)

    // Create the sprite
    img = LAG_i_Gadget[LAG_c_iPanel]
    iw# = getImageWidth(img)
    ih# = getImageHeight(img)

    // create the sprite
    LAG_D_Gadget[i].id = LAG_AddSprite(img,x,y,w,h,1,5)
    Spr = LAG_D_Gadget[i].id
    SetSpriteUVscale(spr, iw# / getSpriteWidth(spr), ih# / getSpriteHeight(spr))
    SetSpriteFlip(spr,1,0)



EndFunction Spr



// update a panel item

Function LAG_UpdatePanelGadget(itemId)

    // hide all the gadgets if they have the curritemId
    For i = 0 to LAG_v_NbGadget
        if LAG_D_Gadget[i].actif = 1
            if LAG_D_Gadget[i].typ = LAG_c_typPanel
                if LAG_D_Gadget[i].ItemId = ItemId
                    // to be continued
                endif
            endif
        endif
    next i

    //reveal the gadget with the currItemId


EndFunction
