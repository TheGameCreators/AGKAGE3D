

//******************* Gadget List

/*

The gadget list is an array which stock the id of the opened gadget.
It is used to add some gadget in other gadget.
For example, we want to add buttons, checkbox on a panel.
1) create the panel gadget
2) open the gadgetlist which store the id of the panel gadget
3) create a gadget item (for the panel)
4) add some gadgets on this item : button, string chekcbox...
5) add anew item for the panel
6) add some gadget on this new item
7) if needed repear 5) and 6)
8) Close the gadget list
9) the next gadgets will be added to the window and not in a gadget, because, the gadgetlist is closed.

We can off course add panel in another panel, so we have 2 gadgetlist opened at the same time, and we add the gadget (button..) on the second list, close it, and so....


There will be 3 gadgets which could open a gadgetlist :
    ok - panel
    - area
    - container
*/


Function LAG_OpenGadgetList(id,item)

	// we open the gadget list : to add new gadget witht the gadget parent X and Y

    inc LAG_V_NbGadgetList // = LAG_NbGadgetlist +1
    i = LAG_V_NbGadgetList

    dim LAG_GadgetList[i] as integer // if a gadgetlist is opened, we have one element in the array at least
    LAG_GadgetList[i] = id // it's the current opened gadget list
    LAG_CurrGadgetId = id

	//Message("Open gadget list. IdCur = "+str(LAG_CurrGadgetId))

    if Item <> -1
        LAG_CurrGadgetItemId = item
    endif

EndFunction





Function LAG_CloseGadgetList()

	
    // update, hide/show, the gadget if they're on the current item
	if LAG_CurrGadgetId >-1 and LAG_CurrGadgetId <= LAG_D_Gadget.length
		 
		 // update le dernier gadget panel de la liste ouverte
		if LAG_D_Gadget[LAG_CurrGadgetId].Typ = LAG_C_TYPPANEL
			LAG_UpdatePanelGadget(LAG_CurrGadgetId,1)
		endif
		
	endif
	
	/*
	For i= 0 to LAG_GadgetList.length
		txt$ = txt$ + "id : "+str(LAG_GadgetList[i])+chr(13)
	next
	*/
	//message("on ferme le gadgetlist. Nb de gadgetlist : "+str(LAG_GadgetList.length)+chr(13)+txt$)
	
	
	
    // we close a gadgetlist, so decrement the number of gadgetlist opened
    // on ferme une list de gadget, donc on décrémente le nombre de list ouverte.
    // old = LAG_GadgetList[LAG_V_NbGadgetList] // temporaire pour voir	
    dec LAG_V_NbGadgetList   
   
    if LAG_V_NbGadgetList <0 // no more gadget list open
        LAG_V_NbGadgetList =-1
        dim LAG_GadgetList[] as integer
        LAG_CurrGadgetId = -2
    else
		LAG_CurrGadgetId = LAG_GadgetList[LAG_V_NbGadgetList]	
    endif
		
	//Message("close gadget list. Le courant est maintenant le : "+str(LAG_CurrGadgetId)+" | le fermé :" +str(old))
	
	/*
    if LAG_NbGadgetlist > 0
        dim LAG_GadgetList[i+1] as integer // redim the gadgetlist array, we keep the current gadgetlist (i) intact
        // LAG_CurrGadgetId = LAG_GadgetList[i] // it's the current opened gadget list
    else
        dim LAG_GadgetList[0] as integer // redim the gadgetlist array
        LAG_CurrGadgetId = -2 // no more gadgetlist open
    endif
	*/

    // ATTENTION !!!
    // I need to stock the currentGadgetItem, and set the old currentGadgetItem here ?

	


EndFunction

