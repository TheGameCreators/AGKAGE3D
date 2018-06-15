
//******************* MESSAGE FOR LAG **********************//

Function LAG_AddTextFix(x,y,txt$,FontId,size,depth)

    id = CreateText(txt$)
    SetTextPosition(id, x, y)
    SetTextSize(id, size)
    FixTextToScreen(id, 1)
    SetTextDepth(id, depth)
    //SetTextFontImage(id, 1)
    //SetTextExtendedFontImage(id, 1)


EndFunction id

function LAG_AddSprite2(img, x, y, fix,depth)

    sprite = CreateSprite(img)
    FixSpriteToScreen(sprite, fix)
    SetSpritePosition(sprite, x, y)
	SetSpriteDepth(sprite,depth)
	
endfunction sprite


Function LAG_message(title$,text$,option$)
	
	/*
	To create a message like with message(), but with more option, butons...
	
	Option$ = "typ|bg|icon|", for example : "1|1" : a yes-no message with a black background
	
	typ 0 : message with just "ok" buton
	typ 1 : message "yes-no" butons
	typ 2 : message "yes-no-cancel" butons
	
	bg : if bg = 1 : add a black semi transparent Background for the message
	
	icon : not used for the omment, will be the icon for message (like a classic windows MessageRequester())
	*/
	
	FreeToolTips()
	

	FoldStart // create the UI & text
	
	//********* Variables local
		local Typ,Bg,txttitle,txt1,width,height,menu,Fond,FontId as integer
		local mx, my, depth, butonTest, quit as integer
		Local Answer = 0
		
				
		Typ = val(GetStringToken(option$,"|",1))
		Bg = val(GetStringToken(option$,"|",2))
	
		FontId = LAG_FontId1
	
	//********* Black BG if needed
		if BG = 1
			Fond = CreateSprite(0)
			SetSpriteSize(Fond, G_width, G_height)
			SetSpriteColor(Fond,0,0,0,150)
			FixSpriteToScreen(Fond,1)
			SetSpriteDepth(Fond,0)
		endif
	
	
	//********* BG message
		
		width = 400 // size of the message
		ww = (len(text$)*10)/width
		if ww >=  3
			height = 200 +(ww-3)*20
		else
			height = 200 
		endif
		
		countline = FindStringCount(text$,chr(10))
		if height < 200 +(countline-2)*30
			height = 200 +(countline-2)*30
		endif
		
		height = height + 10
						
		if height > 700
			height = 700
		endif
		
		a = 6 : b = 40
		i1 = LAG_CreateMenuBox(G_width/2-width/2-a/2+ GetScreenBoundsLeft(), G_height/2-height/2-b+ GetScreenBoundsTop(), width+a, height+b+a/2, LAG_C_ICORNER, 255)
		Fond = 	LAG_GetMenuboxSprite(i1)		
		LAG_SetMenuBoxColor(i1,180,180,180)
		nmb=0
		
		i2  = LAG_CreateMenuBox(G_width/2-width/2+ GetScreenBoundsLeft(), G_height/2-height/2+ GetScreenBoundsTop(), width, height, LAG_C_ICORNER, 255)
		MEnu = LAG_GetMenuboxSprite(i2)
		
	
	//********* Butons
	local MessageBtn1,w1,h1,h2,btnok,btnNo,btnCancel,txt2,txt3,txt4 as integer
		MessageBtn1 =  LAG_i_Gadget[LAG_C_IBUTTON] 
		MessageBtn  =  LAG_i_Gadget[LAG_C_IBUTTON_C] 
		w1 = GetImageWidth(MessageBtn1)+20
		h1 = 40
		h2 = GetImageHeight(MessageBtn1)
		
		select typ
			
			case LAG_MSG_OK					
				btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-w1/2,GetSpriteY(Menu)+height-40,1,0)
				SetSpriteSize(btnok,w1,h2)
				SetSpriteDepth(btnok,0)
								
				// text
				txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"Ok",FontId,20,0)
				SetTextAlignment(txt2, 1)
			endcase
			 
			case LAG_MSG_YESNO	
				btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-w1-2,GetSpriteY(Menu)+height-40,1,0)
				SetSpriteSize(btnok,w1,h2)
				btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2+2, GetSpriteY(Menu)+height-40,1,0)
				SetSpriteDepth(btnNo,0)
				SetSpriteSize(btnNo,w1,h2)
				
				// texts					
				txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"Yes",FontId,20,0)
				SetTextAlignment(txt2, 1)
				txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"No",FontId,20,0)
				SetTextAlignment(txt3, 1)
			endcase	
					
			case LAG_MSG_YESNOCANCEL
				btnok = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2-3*w1/2-4,GetSpriteY(Menu)+height-40,1,0)
				SetSpriteSize(btnok,w1,h2)
				btnNo = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+width/2+w1/2, GetSpriteY(Menu)+height-40,1,0)
				SetSpriteDepth(btnNo,0)
				SetSpriteSize(btnNo,w1,h2)
				btnCancel = Lag_AddSprite2(MessageBtn1,GetSpriteX(Menu)+2*w1+2, GetSpriteY(Menu)+height-40,1,0)
				SetSpriteDepth(btnCancel,0)
				SetSpriteSize(btnCancel,w1,h2)		
				
				// Text for butons
				txt2 = LAG_AddTextFix(GetSpriteX(btnok)+GetSpriteWidth(btnok)/2,GetSpriteY(btnok)+5,"Yes",FontId,20,0)
				SetTextAlignment(txt2, 1)
				txt3 = LAG_AddTextFix(GetSpriteX(btnNo)+GetSpriteWidth(btnNo)/2,GetSpriteY(btnNo)+5,"No",FontId,20,0)
				SetTextAlignment(txt3, 1)
				txt4 = LAG_AddTextFix(GetSpriteX(btnCancel)+GetSpriteWidth(btnCancel)/2,GetSpriteY(btnCancel)+5,"Cancel",FontId,20,0)
				SetTextAlignment(txt4, 1)
			endcase 
		
		endselect
	
	
	
	//********* the text
	// title		
		txttitle = LAg_AddTextFix(GetSpriteX(Menu)+width/2,GetSpriteY(Fond)+5,title$,FontId,30,0)
		SetTextAlignment(txttitle,1)


	// text
		// zetext$ = ReplaceString(zetext$,"#",chr(10)) 
		x_1 = 20 : b = 35
		txt1 = LAg_AddTextFix(GetSpriteX(Menu)+x_1,GetSpriteY(Menu)+b,text$,FontId,20,0)
		SetTextMaxWidth(txt1, width-50)
		SetTextScissor(txt1,GetSpriteX(Menu)+x_1,GetSpriteY(Menu)+b,GetSpriteX(Menu)+x_1+width+200,GetSpriteY(Menu)+b+height-50)

	FoldEnd
	/*
	For i=0 to 10
		SetSpriteVisible(100475+i,1)
		SetSpritecolor(100475+i,255,0,0,255)
		//SetSpritePosition(100475+i,600,200)
	next
	*/
	
	
	Repeat
		
		//print("LAG message : "+str(ButonTest)+"/"+str(btnok))
		//print(str(mzx)+"/"+str(mzy)+"|"+str(getspriteX(btnOK))+"/"+str(getspriteY(btnOK)))
		
		//inc a
		//SetSpritePosition(100483,getspriteX(100483),400+sin(a)*10)
		
		GetScreenBoundEditor()
		
		If GetRawKeyReleased(KEY_ESCAPE)
			quit = LAG_MSG_CANCEL
			Answer = LAG_ANSWER_CANCEL		
		elseif GetRawKeyReleased(KEY_Enter)
			quit = LAG_MSG_YES
            Answer = LAG_ANSWER_YES  
		endif
		
		
		mzx = ScreenToWorldX(GetPointerX())
        mzy = ScreenToWorldY(GetPointerY())
		
	
		if GetPointerPressed()
			
			butonTest = GetSpriteHit(mzx,mzy)
			
			select butonTest 
				case  btnok, btnNo, btnCancel
					SetSpriteImage(butonTest,MessageBtn)
				endcase
			endselect
			
		elseif GetPointerReleased() = 1
			
			SetSpriteImage(btnok, MessageBtn1)
			if typ >= LAG_MSG_YESNO
				SetSpriteImage(btnNo, MessageBtn1)
			endif
			SetSpriteImage(btnCancel, MessageBtn1)
           
            butonTest = GetSpriteHit(mzx,mzy)
            
            if butonTest = btnok 
                quit = LAG_MSG_YES
                Answer = LAG_ANSWER_YES                
            else
				
				if typ >= LAG_MSG_YESNO	
					if butonTest = btnNo 
						quit = LAG_MSG_NO
						Answer = LAG_ANSWER_NO						
					endif	
					if typ = LAG_MSG_YESNOCANCEL		
						if butonTest = btnCancel
							quit = LAG_MSG_CANCEL
							Answer = LAG_ANSWER_CANCEL							
						endif
					endif
				endif
            endif
		endif
			
		Sync()
		
	until quit >= 1
	
	
	FoldStart // free all
			
	if bg = 1
		DeleteSprite(Fond)
	endif
	DeleteSprite(btnok)
	DeleteText(txt1)
	DeleteText(txt2)
	DeleteText(txttitle)
	if typ >= LAG_MSG_YESNO
		DeleteText(txt3)
        DeleteSprite(btnNo)
	endif
	if typ = LAG_MSG_YESNOCANCEL
		DeleteText(txt4)
        DeleteSprite(btnCancel)
	endif
	LAG_FreeMenuBox(i1)
	LAG_FreeMenuBox(i2)
	
	// sync()
	
	LAG_ResetPanel(C_Gad_PanelL) // in lag_panelgadget.agc
	LAG_ResetPanel(C_Gad_PanelR) 
	
	
	FoldEnd
	
	
	
EndFunction Answer
	
