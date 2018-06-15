
//********************* infos *****************************//

/* ******  Descriptions

Lib AGK GUI (LAG)


Code MenuBox creation by Baxlash : thank you a lot ;)

Lib By Blendman to create interface, UI, menu... for applications and games
(Freely inspired by PB).


Version AGK (For tier 1) : 
- 108.21 (should work with just a few changes (setwindowsize() and array.remove())
- V2


Tested on :
- windows8
- android

*/


/* ****** Infos :

The lib use LAG_ prefixe
- constante : LAG_C_  (ex : constant LAG_C_CHECKBOX)
- variable global LAG_v_ (ex: Global LAG_v_Options)
- dim : LAG_d_ (ex dim LAG_D_gadgets)
- type : LAG_t_
....


Include :
- I have create a lot of little files, for each gadget used. Like that, you can add only the gadget and his file you want in your project ;).
- I need to separate the EventGadget() function in several functions for each gadget. It will be done in a future version ^^.


NOTE :
- This lib use dynamic sprite and text, so be careful if you use DeleteAllSprites() and DeleteAllText(), you need to re-create all your gagdets.
- The creation of the menu item need to be change, because, I have to change the system to a dynamic system.
- For the moment, the creation of the gadgets on a panel isn't add in a sort of "container" or listview. The gadgets in a panel is only created relative to the position of the panel


- The lib use LAG_NumSpId as spritenumber, to know the id of the sprite which is clicked/touched.



Be careful, This lib isn't finished !
WIP means that the function is incomplete or doesn't work.
*/


/* ****** BUGS

BUGS known for actual gadget/menu :

Panel
	- the panel need some works : for example, if it has a lot of gadgetitem, I need to add a little button with a cross to move the item visible
	- if you create a panel inside another panel : the panel is bugged, some gadgets doesn't appear in the good panelItem.



BUGS which seems fixed :
Menu
	ok - in some case, when we clic on a menuItem, than move to another title menu and release the mouse, it open the precedent menuItem.
	ok - bug in menu  : in some menuItem, we have to clic on the left to have the event_menu. If we clic on the right, it doesn't work.
	
*/


/* ****** Changes

[09/06/2016] (v0.50) (19)
// New
	- Lag_SaveFile()
// fixes
	- fix minor error in statusbar position

[08/06/2016] (v0.49) (18)
// New
	- Lag_InputRequester()


[07/06/2016] (v0.48) (17)
// New
	- LAG_ListIconGadget()
// Changes
	- Now, I hide all the sprites and text on gadgetitem, not just the 0
	- Some changes in Lag_OpenFile() : check extension, pattern and show only the file with pattern extension
	
	
[05/06/2016] (v0.47) (16)
// New
	- add 2 new images (for starways) :column 
	- LAG_OpenFile() (OpenFileRequester()
// Fixes	
	- some minor bugs fixes

[04/06/2016] (v0.46) (15)
// Changes
	- add a new image if needed (BG for gadget). For example for panel gadget
	- panelgadget has now a background, to hide the screen (like a real panel ^^)
	- change font color by theme


[03/06/2016] (v0.45) (14)
// Changes
	- add a flag LAG_MenuOpen to know if a menu is open or not
	- theme darkgrey changed, for better image
// fixes
	- fix minor bugs in LAG_Message()
	- fixe a bug in answer with LAg_message()
	- fix a bug with panel gadget : the gadgetItem position is update when clic on it
	- fix a bug with panel gadget : the gadgetItem are hiden if Position is > width of the panel


[02/06/2016] (v0.44) (13)
// New
	- Addstatusbar, statusbarfield, statusbartext
	- ContainterGadget() not finished	
// Changes
	- Now, the message use the proper height for the text, to draw it.
	- changes in button image (centered, not resized)



[23/10/2014] (v0.43) (12)
Message
	- add a LAG_Message() to replace the Message() feature, with more options (title, type of message (ok/yes-no/yes-no-cancel))
Misc
	- add LAG_menubox (thanks to Baxlash)
	- Some minor corrections
Panel
	- add a miror option for panel to change left or right panel (panel should be create with menubox, it's on todo list ^^)
Stringgadget
	- hide/set it inactive them if they are inside a panelgadget item and if the gadgetitem hasn't the focus


[22/10/2014] (v0.42) (11)
Some minor corrections


[09/10/2014] (v0.41) (10)
	- Just test the lib in AGK V2.71 alpha : there are some bug in menu (seems ok, in v2 alpha 8 +), and panel
	- some minor corrections
Gadget
	- add the scissor for panel in gadgets : button, buttonimage, buttoncustom, checkbox, image, panel, string, text,trackbar


[05/07/2014] (v0.40) (9)
EventGadget
    - remove SetGadgetState for all gadget and set only for the gadgets that need


[04/07/2014] (v0.36) (8)
EventGadget
    - some minors corrections
SetGadgetState
    - add the state for Trackbar
EventType
    - add LAg_X and Lag_Y (=GetPointerX() and GetPointerY()) to save the pointer X and Y



[02/07/2014] (v0.35) (7)
Gadget
    - LAG_ButtonCustomGadget() : a simple button with custom image (normal, over and imagebutton if needed) and text
Changes
    - some minor corrections and change on buttons
    - now, all the gadget take care of the depth of the parent gadget, if they are créeted on a panel for example, the depth of each gadget is relative at the depth of the panel
Panel
    - Some corrections and change on panel : we can now add a panel inside another panel
    - the pael item are now dynamically hide or reveeal, it depends if its gadgetId is hiden or revealed
    - correction of the depth of the gadgetItem
Menu
    - corrections with eventType




[01/07/2014] (v0.30) (6)
Menu
    - add a box on the selected MenuItem
    - now the menu are "dynamic" : we can navigate inside a menu,...
Correction
    - GetMenuItemText()
    - other corrections
Changes
    - some change in EventType and EventMenu



[30/06/2014] (v0.25) (5)
Panel
    - a gadget inside a panel is now relative (for its position) to this gadget (panel). If we move the panel gadget, the gadgets inside are moved too.
    - now, the gadget are relative to their gadget item (the item of the panel), so when a panel is selected, only the gadgets on this item is shown
Gadget
    - LAG_TextGadget()
    - LAG_ImageGadget()
Event
    - LAG_FreeGadget(Id) // to free a gadget
    - LAG_ResetGadget(ID, mode) // only reset a gadget, but keep the sprite and text info
    - LAG_HideGadget()
    - LAG_SetVisibleGadget()




[29/06/2014] (v0.22) (4)
Gadget
    - LAG_StringGadget()
GadgetItem :
    - for the moment, it's only for panel. I will add the creation of gadget item when I will add a gadget which need gadgetItems (combobox, listview...)
Panel
    - Now, for a panel, I open a gadgetList (LAG_OpenGadgetList(GadgetId,ItemId)), and add all the gadgets on the panel, until the list is closed (LAG_CloseGadgetList())
Correction
    - some minor corrections (found with compiler v2)

[28/06/2014] (v0.20) (3)
Constant :
    - add constant for other gadget (not used)
Gadget
    - LAG_ButtonImageGadget()
    - correction on trackbar (getgadgetstate/Setgadgetstate didn't work properly)
General
    - add name to gadget
    - LAG_SetGadgetName()
    - LAG_GetGadgetName()
    - add name and text to trackbar
Menu
    - change menuTitle sprite to menu sprite
    - change menutitle Y position to 0
    - change menutitle height to imageheight(menu image)
    - add two parameter to the menu : height (height of the menu) and space (space between menu tile)
    - LAG_SetMenuItemText()
    - Change menuItem creation : it's now dynamic, and we can add an menuitem when and where we want :)
    - LAG_GetCurrentMenu() : to get the current menu id used
    - LAG_SetCurrentMenu() : to Set the current menu id to use
    - all sprite of menuitem are now resized if a text of an item of the menutitle is bigger


Very WIP (not finished at all):
Toolbar
    WIP - LAG_AddToolbar(i,x,y,w,h) not finished at all !
Menu
    WIP - LAG_MenuBar() : to add bar between two menu (not finish)


[27/06/2014] (v0.15) (2)
UI
    - add new basic font (arial16.png)
Gadgets
    - LAG_Trackbargadget()
Function
    - LAG_SetGadgetFont()
    - LAG_SetGadgetSize(id,x,y,w,h)
Menu
    - add the eventmenu() of the menuitem
    - LAG_GetMenuItemText()
Modification :
    - Panel item are now their depth which change depending to their position
    - text are now extended


[24/06/2014] (v0.10) (1)
(First test)
Include:
    - add file include infos
    - add file include constant
    - add file include type
    - add file include gadgets
    - add file include menu
    - add file include init
    - add file include include
    - add file include util
Gadgets
    - LAG_Butongadget()
    - LAG_CheckBoxgadget()
    - LAG_Panelgadget()
Function
    - LAG_SetGadgetState()
    - LAG_GetGadgetState()
    - LAG_SetGadgetText()
    - LAG_GetGadgetText()
    wip - LAG_FreeGadget(id) not finished ! -> ok in v0.25
Menu
    - LAG_CreateMEnu()
    - LAG_MenuTitle()
    - LAG_MenuItem()
Event
    - LAG_EventGadget() (need all the gadget)
    WIP - LAG_EventMenu()
    wip - LAG_EventType()  // need all the eventType (keyboard, mouse (mobile, pc, mac..))

*/


/* ****** TODO list

[ TODO LIST ]

Gadgets :
    OK : 
    ok - LAG_ButtonGadget()
    ok - LAG_ButtonImageGadget() // a classic button, with an image inside
    ok - LAG_CheckBoxGadget()
    ok - LAG_StringGadget()
    ok - LAG_TrackbarGadget()
    ok - LAG_TextGadget()
    ok - LAG_ImageGadget()
    ok - LAG_ButtonCustomGadget() : a button with your own image as background and text
    
    Seems ok, to be tested : 
    - LAG_ListIconGadget() 
	
    
    Not Finished / WIP :
    - LAG_ContainerGadget()
    - LAG_panelgadget() (some bugs in complexe panel inside other panel)
	
	NOT ok : 
	- LAG_TabBarGadget()
    - LAG_SpinGadget()
    - LAG_FrameGadget()
    - LAG_ComboBoxGadget()
    - LAG_ScrollArea()
    - LAG_RebarGadget()
    - LAG_TreeGadget()

    in reflexion :
    - LAG_ListViewGadget() (?)   
    - LAG_CanvasGadget() (= imagegadget ?)

Gadget Set
    ok - LAG_SetGadgetState
    ok - LAG_SetGadgetText
    ok - LAG_SetGadgetFont
    ok - LAG_SetGadgetName
    ok - LAG_SetGadgetSize

Gadget Get
    ok - LAG_GetGadgetState
    ok - LAG_GetGadgetText

Gadget List (to add gadget inside other gadget (panel, container..))
    ok - LAG_OpenGadgetList(id,item)
    ok - LAG_CloseGadgetList()

Menu
    ok - LAG_createmenu()
    ok - LAG_menuitem()
    ok - LAG_menuTitle()

Statusbar
    ok - LAG_addstatusbar()
    ok - LAG_statusbarfield()
    - LAG_statusbarHeight()

Event
    - LAG_EventGadget() (not really finished, because it need all the gadget)
    WIP - LAG_EventMenu()
    Wip - LAG_EventType() // need all the eventType (keyboard, mouse (windows, mac..))

Window
    - LAG_OpenWindow()
    - LAG_SizeWindow()
    - LAG_CloseWindow()

File
	ok - LAG_OpenFileRequester() : to be improved
	- LAG_SaveFileRequester()
	- LAG_Input()

Misc
    - LAG_RulerGadget()
    ok - add text to trackbar
    ok - add Name to gadget

Toolbar : 
ok with custom gadget (container + buttons + other gadgets)
    - LAG_AddToolbar()
    - LAG_ToolbarHeight()
    - LAG_ToolbarSeparator()

*/

