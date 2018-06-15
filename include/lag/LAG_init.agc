
//********************* Init the lib *********************************//


Function Reset_LAG()
	
	LAG_InitWindow()
	Lag_InitStatusBar()
	Global dim LAG_D_Gadget[0] as LAG_t_Gadget 	
	Global dim LAG_D_GadgetItem[0] as LAG_t_Gadget
	Global dim LAG_GadgetList[] as integer 
	
	LAG_V_NbGadgetList = -1
	LAG_v_NbGadget = 0
	LAG_V_NbGadgetItem = 0
	LAG_CurrGadgetId = -2
	LAG_CurrGadgetItemId = -2
	
	LAG_Event_Type = -1
	
	Global dim LAG_d_Menu[0] as LAG_t_Menu
    // Global dim LAG_d_MenuItem[0] as LAG_t_MenuItem

	
EndFunction

	
	
Function Init_LAG(theme$)


    //************ For Window creation
    LAG_InitWindow()
    Global LAG_WindowOpen as integer // is a "window" opened/selected ?



    //************ For Utils (openFileRequester()...
    Global LAG_FullPathFile$
    
    
    Global LAG_group = 150 // the group for sprite
    
    //************ gadgets


    // for the gadgets
    Global dim LAG_D_Gadget[0] as LAG_t_Gadget // the arrays for the gadgets created
    Global LAG_v_NbGadget as integer // the number of gadgets created
    Global LAG_CurrGadgetId as integer // the current Gadget used (example : to add gadget on this gadget (panel, container...))
	LAG_CurrGadgetId = -2

    // the gadets items
    Global dim LAG_D_GadgetItem[0] as LAG_t_Gadget
    Global LAG_V_NbGadgetItem as integer // the number of gadgetItem created
    Global LAG_CurrGadgetItemId as integer // the current GadgetItem used
    LAG_CurrGadgetItemId = -2

    // for the gadgetlists
    Global dim LAG_GadgetList[] as integer // the current Gadgetlist used (this stock th id of the gadget opened (for example a panel))
    Global LAG_V_NbGadgetList as integer // the number of gadgetlist which are opened
	LAG_V_NbGadgetList = -1


    //************ Statusbar
    Lag_InitStatusBar()
    
    
    
    //************ menu
    Global LAG_v_NbMenu as integer // the number of menu created
    Global LAG_v_NbMenuItem as integer // the number of menuitem created
    Global dim LAG_d_Menu[0] as LAG_t_Menu
    // Global dim LAG_d_MenuItem[0] as LAG_t_MenuItem
    Global LAG_v_CurrMenuId as integer // the current menu used
    Global LAG_v_MenuItemId as integer // the current MenuItem used
    Global LAG_v_EventMenuId as integer // the current event Menu Id
	Global LAG_MenuOpen as integer // is a menu opened/selected ?
	
	

    // other events
    Global LAG_Event_Type as integer // the eventType (mouse pressed, released...)
    Global LAG_Event_Gadget as integer // the eventgadget (id of the gadget)
    Global LAG_Event_Menu as integer // the EventMenu (id of the menu)
    Global LAG_NumSpId as integer // the ID number of the current sprite touched/clicked
	Global Lag_MousePressed as integer

    // mouse    
    // Global LAG_MouseClic as integer
    Global LAG_X, LAG_Y, LAG_OldX, LAG_OldY as integer

    //******* FONT
    Global LAG_FontId1, LAG_FontId2 as integer
    LAG_FontId1 = 1 // LoadImage("ui\fonts\arial16.png") // font for interface change here to load your font
    LAG_FontId2 = 1 // LoadImage("ui\fonts\arial22.png") // font for the message
    
    //SetImageMinFilter(LAG_FontId1,0)
    //SetImageMagFilter(LAG_FontId1,0)
    //SetImageMinFilter(LAG_FontId2,0)
    //SetImageMagFilter(LAG_FontId2,0)




    //******* the images used by the gadgets


    // image for the futur menu (file, edit...)

    Global LAG_TextColorR as integer
    Global LAG_TextColorG as integer
    Global LAG_TextColorB as integer


    // change here the UI
    // Several UI example, you can add easly your own ui
    // LAG_ThemeUi$ = "dark" // other theme : "light", "classic","fx" you can create theme if you want you own theme/image ;)
	LAG_TextColorR = 0            
	LAG_TextColorG = 0            
	LAG_TextColorB = 0  
	
	Global LAG_ClearColor as integer
	Global LAG_IMAGEColor as integer
	
    select Theme$

        case "classic"
			LAG_ClearColor = 140
            setClearColor(140,140,140) 
        endcase

        case "white"
			LAG_ClearColor = 220
            setClearColor(220,220,220)           
        endcase

        case "fx"
			LAG_ClearColor = 100
            setClearColor(100,100,100)
        endcase

        case "darkgrey"
			LAG_ClearColor =50
            setClearColor(50,50,50)           
        endcase

        case "dark", "grey"
			LAG_ClearColor = 80
            setClearColor(80,80,80)
            LAG_TextColorR = 255           
            LAG_TextColorG = 255            
            LAG_TextColorB = 255
            LAG_IMAGEColor = 65
        endcase

        case "light"
			LAG_ClearColor = 190
            setClearColor(190,190,190)           
        endcase

        case default
			LAG_ClearColor = 160
            setClearColor(160,160,160)
        endcase

    endselect
    
    LAG_UiDir$ ="ui\themes\" + Theme$


    Global dim LAG_i_Menu[3] as integer
    LAG_i_Menu[LAG_C_IMENU]     = LoadImage(LAG_UiDir$+"/LAG_menu.png")
    LAG_i_Menu[LAG_C_IMENUTITLE]= LoadImage(LAG_UiDir$+"/LAG_menuTitle.png")
    LAG_i_Menu[LAG_C_IMENUITEM] = LoadImage(LAG_UiDir$+"/LAG_menuTitle.png")
    LAG_i_Menu[LAG_C_IMENUBAR]  = LoadImage(LAG_UiDir$+"/LAG_menuBar.png")


    // The image used by the gadgets
    Global dim LAG_i_Gadget[20] as integer
    LAG_i_Gadget[LAG_C_ICHECKBOX]   =Loadimage(LAG_UiDir$+"/LAG_checkbox.png")
    LAG_i_Gadget[LAG_C_ICHECKBOX_C] =Loadimage(LAG_UiDir$+"/LAG_checkbox_c.png")
    LAG_i_Gadget[LAG_C_ISTRING]     =Loadimage(LAG_UiDir$+"/LAG_string.png")
    LAG_i_Gadget[LAG_C_IPANEL]      =loadimage(LAG_UiDir$+"/LAG_panel.png")
    LAG_i_Gadget[LAG_C_IBUTTON]     =loadimage(LAG_UiDir$+"/LAG_button.png")
    LAG_i_Gadget[LAG_C_IBUTTON_C]   =loadimage(LAG_UiDir$+"/LAG_button_c.png")
    LAG_i_Gadget[LAG_C_IBUTTONIMAGE]=loadimage(LAG_UiDir$+"/LAG_button.png")
    LAG_i_Gadget[LAG_C_ICOMBOBOX]   =loadimage(LAG_UiDir$+"/LAG_button.png")
    LAG_i_Gadget[LAG_C_ITRACKBAR]   =loadimage(LAG_UiDir$+"/LAG_trackbar.png")
    lag_i_gadget[LAG_C_ITRACKBAR2]  =loadimage(LAG_UiDir$+"/LAG_trackbar2.png")
    LAG_i_Gadget[LAG_C_ICHECKER]    =loadimage("ui/checker.png")
    LAG_i_Gadget[LAG_C_ICORNER]    	=loadimage(LAG_UiDir$+"/LAG_panel.png")
    LAG_i_Gadget[LAG_C_IBG]    		=loadimage(LAG_UiDir$+"/LAG_bg.png")
    LAG_i_Gadget[LAG_C_ICORNER2]    =loadimage("ui/corner0.png")
    LAG_i_Gadget[LAG_C_IASCENSOR]   =loadimage("ui/ascensor.png")
    LAG_i_Gadget[LAG_C_IFILEPREV]   =loadimage("ui/themes/previewfile.png")
    LAG_i_Gadget[LAG_C_ICENTER]     =loadimage("ui/themes/center.png")
    LAG_i_Gadget[LAG_C_ISLIDER]     =loadimage(LAG_UiDir$+"/LAG_slider1.png")

    // NOTE :  for constant, see LAG_constant.agc



EndFunction


Function LAg_SetFontColorUI(color)
	
	LAG_TextColorR = GetColorRed(color)           
	LAG_TextColorG = GetColorGreen(color)                 
	LAG_TextColorB = GetColorBlue(color)      
	 
EndFunction



