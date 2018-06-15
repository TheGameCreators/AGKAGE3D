

//******************* Get the gadgets informations

function LAG_GetGadgetState(id)

    state = LAG_D_Gadget[id].state
    	
EndFunction state



function LAG_GetGadgetText(id)

    txt$ = LAG_D_Gadget[id].text$
	if LAG_D_Gadget[id].Typ = LAG_c_typString or LAG_D_Gadget[id].Typ = LAG_c_typEditor
        Txt$ = GetEditBoxText(LAG_D_Gadget[id].EditBoxId)
	endif
	
EndFunction txt$


function LAG_GetGadgetName(id)

    txt$ = LAG_D_Gadget[id].Name$

EndFunction txt$


// get size, width
Function Lag_GetGadgetWidth(id)

	w = GetSpriteWidth(LAG_D_Gadget[id].id)

EndFunction w

Function Lag_GetGadgetHeight(id)

	w = GetSpriteHEight(LAG_D_Gadget[id].id)

EndFunction w


Function Lag_GetGadgetType(id)

	result = LAG_D_Gadget[id].Typ

EndFunction result



// get position

Function Lag_GetGadgetY(id)
	/*
	y1 =0
	j =  LAG_D_Gadget[id].ParentId
	if j>-1
		y1 = LAG_D_Gadget[j].y + 5
	endif
	y = LAG_D_Gadget[id].y - y1
	*/
	y = GetSpriteY(LAG_D_Gadget[id].id)
	
EndFunction y 


Function Lag_GetGadgetX(id)
	
	/*
	x1 =0
	j =  LAG_D_Gadget[id].ParentId
	if j>-1
		x1 = LAG_D_Gadget[j].x + 5
	endif
	x = LAG_D_Gadget[id].x - x1
	*/
	
	x = GetSpriteX(LAG_D_Gadget[id].id)

EndFunction x 
