This visual editor is not finished. It's an editor to create 3D levels, and in a next version, add gameplay assets. 

This Editor (AGE = Agk Game Editor) use :
- Lib Agk Gui : my lib to create menu/gadgets, interfaces...
- some Shaders made by AGK community (specially Janbo for Water (reflection / refraction)).
- the GameGuru *.fpe import/export for 3Dmodel (the graphic part), just some parameters are loaded for the moment.

How is the code organised :
- in general, I create a file by elements and the functions for this element are in this file.


The principal files : 
- atmospheric.agc : skybox, sun, ambient and fog
- editor.agc : function for the editor (some keyboard functions)
- images.agc : init "bank" : images, shaders & models3D. Function to init bank, load an object, load an image or a shader.
- init.agc : init the programm (setconstants, init the UI (menu, gadgets, statusbar, toolbar...), load options...
- light.agc : light functions
- object.agc functions for objects are in that file.
- options.agc : save/load options
- terrain.agc : for terrain (creation...)
- utile.agc : some functions usefull (min(), max(), GetFileExtension(), ...)
- water.agc : for water (creation, sync()) : (water is made By janbo)
- shader.agc : for shader and shader window
- behavior.agc : for behavior and behavior window


All files with LAG_ prefixe are files for the interface (gadgets, menus, statusbar, toolbar)



KNOWN BUGS :
- the save/open doc system isn't finished
- objects are not created with their shader or texture (it's not finished)


You can find more documentation in media/doc