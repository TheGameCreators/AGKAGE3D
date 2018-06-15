
//******************* CONSTANT FOR LAG **********************//


/*

<<********************************************** CONSTANTS **********************************************>>



NOTE :
- please leave this constants, they are needed by the lib

If needed, you can change the constant for the image (LAG_c_iCheckbox)
But, don't forget, they're an element of an array. So i f you set it : LAG_c_iCheckbox = 50000, your array for image will have 50 000 elements !


*/


Foldstart //********** LAG MISC CONSTANTS

#constant LAG_C_VERSION = "v0.78"
#constant LAG_C_DATE = "8/03/2018"
#Constant LAG_C_IGNORE = -65535
#Constant LAG_C_AUTHOR = "Blendman"
#Constant LAG_C_AGKVERSION = "v2"

#Constant LAG_C_SPEEDLISTICONY = 20

Foldend



Foldstart //********** THE TYPE FOR THE GADGETS
// you can change the type if you want, but it's better to let it like that ;)

#constant LAG_C_TYPBUTTON       = 0
#constant LAG_C_TYPBUTTONIMAGE  = 1
#constant LAG_C_TYPCHECKBOX     = 2
#constant LAG_C_TYPCOMBOBOX     = 3 // not used for the moment
#constant LAG_C_TYPPANEL        = 4
#constant LAG_C_TYPTRACKBAR     = 5
#constant LAG_C_TYPCONTAINER    = 6 
#constant LAG_C_TYPSTRING       = 7
#constant LAG_C_TYPTEXT         = 8
#constant LAG_C_TYPSPIN         = 9 // not used for the moment
#constant LAG_C_TYPTREE         = 10 // not used for the moment
#constant LAG_C_TYPLISTICON     = 11 
#constant LAG_C_TYPLISTVIEW     = 12 // not used for the moment
#constant LAG_C_TYPEDITOR       = 13 
#constant LAG_C_TYPIMAGE        = 14 // for ImageGadget, not an image ;)
#constant LAG_C_TYPBUTTONCUSTOM = 15
#constant LAG_C_TYPSCROLLAREA 	= 16 // not used for the moement

foldend



Foldstart //********** THE IMAGE FOR THE GADGET (it is not the id, it's the element of the image array for gadget)
// -1 : no image for the moment,

#constant LAG_C_ICHECKBOX       = 0
#constant LAG_C_ICHECKBOX_C     = 1 // must be LAG_c_iCheckbox + 1
#constant LAG_C_ISTRING         = 2
#constant LAG_C_IPANEL          = 3
#constant LAG_C_IBUTTON         = 4
#constant LAG_C_IBUTTON_C       = 5 // must be LAG_c_iButton + 1
#constant LAG_C_IBUTTONIMAGE    = 6 
#constant LAG_C_ICOMBOBOX       = 7
#constant LAG_C_ITRACKBAR       = 8
#constant LAG_C_ITRACKBAR2      = 9
#constant LAG_C_ICHECKER        = 10
#constant LAG_C_ICORNER        	= 11
#constant LAG_C_IBG        		= 12
#constant LAG_C_ICORNER2        = 13 // Image for corner 
#constant LAG_C_IASCENSOR       = 14 
#constant LAG_C_IFILEPREV       = 15 
#constant LAG_C_ICENTER       	= 16 
#constant LAG_C_ISLIDER       	= 17 

foldend



Foldstart //********** CONSTANT IMAGE FOR THE MENU

#constant LAG_C_IMENU        = 0
#constant LAG_C_IMENUTITLE   = 1
#constant LAG_C_IMENUITEM    = 2
#constant LAG_C_IMENUBAR     = 3

Foldend



FoldStart //********** Constant for eventwindow
	
	#Constant LAG_C_CloseWindow = 10
	#Constant LAG_C_MoveWindow = 11
	#Constant LAG_C_MinimiseWindow = 12
	#Constant LAG_C_EventGadget = 13
	#Constant LAG_C_EventMenu = 14
	
Foldend



FoldStart //********** Attributes (& value) constants for the gadgets, by gadget

// list icon

#Constant LAg_ListIcon_DisplayMode  = 0 

#Constant LAg_ListIcon_List = 0 
#Constant LAg_ListIcon_ListMedium = 1 
#Constant LAg_ListIcon_ListLarge = 2 
#Constant LAg_ListIcon_SmallIcon = 3 // grid smal icon
#Constant LAg_ListIcon_LargeIcon = 4 // grid Large icon

// TreeGadget

// Combobox




Foldend



FoldStart //********** the eventtype for the gadgets
#constant LAG_C_EVENTTYPELEFTMOUSEPRESSED      = 0
#constant LAG_C_EVENTTYPELEFTMOUSESTATE        = 1
#constant LAG_C_EVENTTYPELEFTMOUSERELEASED     = 2
#constant LAG_C_EVENTTYPERIGHTMOUSEPRESSED     = 3
#constant LAG_C_EVENTTYPERIGHTMOUSESTATE       = 4
#constant LAG_C_EVENTTYPERIGHTMOUSERELEASED    = 5
#constant LAG_C_EVENTTYPEMOUSE                 = 6
#constant LAG_C_EVENTTYPEMOUSEPRESSED          = 7
#constant LAG_C_EVENTTYPEMOUSERELEASED         = 8
#constant LAG_C_EVENTTYPEMOUSEMOVE             = 9
#constant LAG_C_EVENTTYPEKEYPRESSED            = 10
#constant LAG_C_EVENTTYPEKEYRELEASED           = 11

Foldend



Foldstart //********** CONSTANT FOR MESSAGE

	// for the answers
	#constant LAG_ANSWER_YES 	= 0
	#constant LAG_ANSWER_NO 	= 1
	#constant LAG_ANSWER_CANCEL = 2
	
	// for the message type
	#constant LAG_MSG_OK 		= 0
	#constant LAG_MSG_YESNO 	= 1
	#constant LAG_MSG_YESNOCANCEL = 2
	
	#constant LAG_MSG_YES 		= 1
	#constant LAG_MSG_NO 		= 2
	#constant LAG_MSG_CANCEL 	= 3
	
foldend



FoldStart //********** colors

	#constant C_WHITE = MakeColor(255,255,255)
	#constant C_BLACK = 0
	#constant C_GREY = MakeColor(127,127,127)
	#constant C_DARKGREY = MakeColor(60,60,60)
	#constant C_LIGHTGREY = MakeColor(180,180,180)
	
Foldend



foldstart //********** KEYBOARD

	
	#CONSTANT KEY_BACK         8		
	#CONSTANT KEY_TAB          9	   
	#CONSTANT KEY_ENTER        13
		
	#CONSTANT KEY_SHIFT        16		
	#CONSTANT KEY_CONTROL      17
	#CONSTANT KEY_ALT      	   18
		
	#CONSTANT KEY_ESCAPE       27
	
    #CONSTANT KEY_SPACE        32
    #CONSTANT KEY_PAGEUP       33
    #CONSTANT KEY_PAGEDOWN     34
    #CONSTANT KEY_END          35
    #CONSTANT KEY_HOME         36
   
    // fleche - arrow
    #CONSTANT KEY_LEFT         37    
    #CONSTANT KEY_UP           38
    #CONSTANT KEY_RIGHT        39
    #CONSTANT KEY_DOWN         40
    
    #CONSTANT KEY_INSERT       45
    #CONSTANT KEY_DELETE       46
   
   // numpad
    #CONSTANT KEY_0            48
    #CONSTANT KEY_1            49
    #CONSTANT KEY_2            50
    #CONSTANT KEY_3            51
    #CONSTANT KEY_4            52
    #CONSTANT KEY_5            53
    #CONSTANT KEY_6            54
    #CONSTANT KEY_7            55
    #CONSTANT KEY_8            56    
    #CONSTANT KEY_9            57
    
    #CONSTANT KEY_A            65
    #CONSTANT KEY_B            66
    #CONSTANT KEY_C            67
    #CONSTANT KEY_D            68
    #CONSTANT KEY_E            69
    #CONSTANT KEY_F            70
    #CONSTANT KEY_G            71
    #CONSTANT KEY_H            72
    #CONSTANT KEY_I            73
    #CONSTANT KEY_J            74
    #CONSTANT KEY_K            75
    #CONSTANT KEY_L            76
    #CONSTANT KEY_M            77
    #CONSTANT KEY_N            78
    #CONSTANT KEY_O            79    
    #CONSTANT KEY_P            80
    #CONSTANT KEY_Q            81
    #CONSTANT KEY_R            82
    #CONSTANT KEY_S            83
    #CONSTANT KEY_T            84
    #CONSTANT KEY_U            85
    #CONSTANT KEY_V            86
    #CONSTANT KEY_W            87
    #CONSTANT KEY_X            88
    #CONSTANT KEY_Y            89
    #CONSTANT KEY_Z            90
    
    #CONSTANT KEY_F1           112
    #CONSTANT KEY_F2           113
    #CONSTANT KEY_F3           114
    #CONSTANT KEY_F4           115
    #CONSTANT KEY_F5           116
    #CONSTANT KEY_F6           117    
    #CONSTANT KEY_F7           118
    #CONSTANT KEY_F8           119
    
    // ,                188
    // .                190
    // /                191
    // ;                186
    // '                192
    // #                222
    #CONSTANT KEY_ASTERIX      106 // * 
    #CONSTANT KEY_PLUS         107 // * 
    #CONSTANT KEY_COMMA        188 // , 
    #CONSTANT KEY_POINT        190 // .
    #CONSTANT KEY_SLASH        192 // / 
    
   
    #CONSTANT KEY_LESS         189 // -
    #CONSTANT KEY_EGAL         187 // =
    // [                219
    // ]                221
    // `                223
FOLDEND
	
	


