

//*************** Type Lib Agk Gui **********************//
Type Lag_t_Sprite
	id as integer
	x as integer
	y as integer
Endtype




Type LAG_t_GadgetItem
	
	x as float	
	y as float
	// extra position
    x1 as float
    y1 as float
    
    // origin du sprite principal
    originx as integer
    originY as integer
    
    //******** sprite
    id as integer // the id of the gadget = the sprite number create for the gadget
    spr1 as integer // another sprite, if needed (trackbar for example)
	spr as Lag_t_Sprite[] //other gadgets if needed, for example : sliders for list icon
	
	sliderId as integer // si on utiliser un slider (ascenceur), je dois savoir quel est l'id du premeir gadget (en gros, le premier element de spr[] qui est un element du slider, car les 4 se suivent. (ascenceur, slider haut, bas, milieu)
	
	// au cas où, pour certains gadgets je peux avoir besoin de la position du slider (pour listicon, pour 

    //******** text
    TextId as integer // the number if of the text of the gadget (create with createText()), use in CheckboxGadget(), ComboboxGadget(), buttonGadget()...
    Text$ // the text of the gadgets
    TextSize  as integer
    Name$ // the name of the gadget : usefull for the text for exemple
    NameId as integer // the number id for createtext() : pour le nom du gadget (le texte)
   
    EditBoxId as integer // editboxid : pour l'editbox si besoin
    TextBox$
	
	// size
	
	w as float
    h as float
    h2 as integer // taille des gadgetitems du gadget
    w2 as integer // taille des gadgetitems du gadget
	totalW as float // for gadget parent only (ex : panel) to know the position W of the current item
	totalH as float // for gadget parent only (ex : panel) to know the position H of the current item

	IsPressed as integer // to know if a gadget is pressed or not (to move the sdebar for exemple of a gadget

EndType

	
Type LAG_t_Gadget


	// windowid parent
	WindowId as integer

    //******** position
    x as float
    y as float
    // extra position
    x1 as float
    y1 as float
    
    // origin (position without the parent, for gadget inside another gadget)
    originx as integer
    originY as integer
    
    // position fo the parent Gadget Id
    parentX as float 
    parentY as float 
   
    
    //because window can be moved
    WinX as float // the parent window X if is inside a window
    WinY as float // the parent window y if is inside a window
    
    CurY as float // for gadget with sidebar, to move the gadget item if the curY move
    CurX as float // for gadget with trackbar or other gadget, if needed to know the position of the slider
    StartY as float // idem
    CurSpeedY as float
    
    
    // position of the other element than the principal (sprite & text)
    spr1x as integer
    spr1y as integer
    TextX as integer
    TextY as integer
    NameX as integer
    NameY as integer
    


    w as float
    h as float
    h2 as integer // taille des gadgetitems du gadget
    w2 as integer // taille des gadgetitems du gadget
	totalW as float // for gadget parent only (ex : panel) to know the position W of the current item
	totalH as float // for gadget parent only (ex : panel) to know the position H of the current item

	IsPressed as integer // to know if a gadget is pressed or not (to move the sdebar for exemple of a gadget


	// dim GadgetItem[]

    //******** color, alpha, alpha
    alpha as integer
    ColorBG as integer // color of the gadget
    ColorTxt as integer // color of the text
    depth as integer // the current depth
    depthMax as integer // the maxdepth
    visible as integer

	// l'image si besoin, pour la stocker
	Image as integer[0]


    // Image (for custom gadget)
    Image1 as integer // for the custom button image1 (normal image)
    Image2 as integer // for the custom button image2 (over/clic image if getpointerpressed)
    Image3 as integer // for the custom image

    //******** others
    State as integer // the state of the gadget (for example, a checkbox)
    Actif as integer // is the gadget actif or not (not = we have free the gadget, we erase and delete the sprite and text...)

    Typ as integer // the type of the gadget : butongadget, panel...
    // to see the type, see the LAG_constant.agc


    //******** sprite
    id as integer // the id of the gadget = the sprite number create for the gadget
    spr1 as integer // another sprite, if needed (trackbar for example)
	spr as Lag_t_Sprite[] //other gadgets if needed, for example : sliders for list icon
	sliderId as integer // si on utiliser un slider, je dois savoir quel est l'id du premeir gadget (en gros, le premier element de spr[] qui est un element du slider, car les 4 se suivent. (ascenceur, slider haut, bas, milieu)
	
	

    //******** text
    TextId as integer // the number if of the text of the gadget (create with createText()), use in CheckboxGadget(), ComboboxGadget(), buttonGadget()...
    Text$ // the text of the gadgets
    TextSize  as integer
    Name$ // the name of the gadget : usefull for the text for exemple
    NameId as integer // the number id for createtext()
    EditBoxId as integer
    TextBox$

    //******** items
    ParentID as integer // the parent of the gadget or the id of thegadgets for gadgetitem
    ItemId as integer // the ItemId, for example if we create a gadget on a panel, we need to know the id of the item on which we add this gadgets.
    NbGadgetItem as integer // the number of gadgetitem for the gadget
    Position as integer // position, for the gadget item

	// nécessaire pour les gadget item
	TempFile$ as string[] 
	TempImg as integer[] 


	// Item as LAG_t_GadgetItem[] // not use for the moment 
	attribute as integer
	attributeVAlue as integer

    //******** Tooltips
    Tooltip$ // tooltip of the gadget (=help text)
    
    
    //******** options if needed
    option1 as integer // first options for some gadget. Example : button : option1 = toggle on /off, for editor : readonly
    snap as integer // for trackbar, is the cursor snap to a grid ?

    mini as integer // minimum value (for trackbar for example or spinegadget)
    maxi as integer // maximum value (for trackbar for example)
    // current value = state


EndType


