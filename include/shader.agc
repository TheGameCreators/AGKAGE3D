// *************************** SHADERS ****************************//


Function OpenWindowShader()
	
	FoldStart // Create the Window
	w = 500
	h = 600
	Lag_OpenWindow(C_WINShader,G_width/2-w/2,g_height/2-h/2,w,h,"Shader Editor", 0)


	// then, Add the gadget for the shader editor



	Foldend
	
	
	repeat
		
		eventwindow = LAG_EventWindow()
		
		if eventwindow = LAG_C_CloseWindow or GetRawKeyPressed(Key_escape)
			Quit = 1
		elseif eventwindow = LAG_C_EVENTGADGET
			
		endif
		
		
		
		
		
			
		sync()
	until quit>= 1
		
	FoldStart 
		
	LAG_CloseWindow(C_WINShader)
	
	FoldEnd
	
EndFunction



Function GetShaderInfo(id)
	
	// to open the file for shader description & informations
	if id <= -1
		
		txt$ = "AGK Basic shader"
	
	else
		
		file0$ = "shaders/shaderdescription.txt"
		
		if GetFileExists(file0$)
			
			f = OpenToRead(file0$)
			
			if f > 0
				
				While FileEOF(f) = 0
					
					line$ = ReadLine(f)
					index$ = GetStringToken(line$,"|",1)
					
					// message(index$+" | "+GetFilePart(ShaderBank[id].Filename$))
					
					if index$ = GetFilePart(ShaderBank[id].Filename$)
						txt$ = line$
						exit
					endif
					
				endwhile
				
				
				CloseFile(f)
				
			endif
			
		endif
		
		
	endif
	
endfunction txt$













