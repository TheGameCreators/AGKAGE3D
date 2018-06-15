// ********************* gadget tooltips ************************* //

Type tToolTips
	
	Txt$
	SpriteBG as integer
	Sprite as integer
	Textid as integer
	TimeCurrent as float
	Width as integer
	ok as integer
	PreviousGadget as integer
	
EndType


// inits
Function InitToolTips()
	
	Global ToolTips as tToolTips
	Tooltips.TimeCurrent = -40

EndFunction



// Create
Function CreateToolTips(x,y,gadget)
	
	
	// first, I erase the precedent tooltips if needed
	// FreeToolTips()
	//If Tooltips.TimeCurrent >= 0
		if gadget>-1 and gadget <= LAG_D_Gadget.length
			
		If ToolTips.PreviousGadget <> Gadget
		
			ToolTips.PreviousGadget = Gadget
			If ToolTips.ok = 1
				FreeToolTips()
			Endif
				
			if LAG_D_Gadget[gadget].ToolTip$ <> ""
				
				txt$ = LAG_D_Gadget[gadget].ToolTip$
				
				
				FoldStart 
		
				
				
					// to create a tooltips for a gadgets
					
					w = Len(txt$) * 10
					h = 50
					
					// position x of the tooltips
					if x <= G_width/2 
						tx = x +10
					else
						tx = x -w -10
					endif
					
					// position y of the tooltips
					if y <= G_height/2 
						ty = y + 10
					else
						ty = y -h -10
					endif
					
					a = 1
					
					// Create the tooltips
					n = CreateSprite(0)
					ToolTips.SpriteBG = n
					SetSpriteColor(n,20,20,20,255)			
					SetSpriteDepth(n,0)
					FixSpriteToScreen(n,1)
					
					n = CreateSprite(0)
					ToolTips.Sprite = n
					SetSpriteColor(n,110,110,110,255)				
					SetSpriteDepth(n,0)
					FixSpriteToScreen(n,1)
					
					// the text
					n= CreateText(txt$)
					ToolTips.Textid = n
					SetTextSize(n,15)
					SetTextMaxWidth(n,380)
					SetTextDepth(n,0)
					FixTextToScreen(n,1)
					
					W = GetTextTotalWidth(n) +15
					H = GetTextTotalHeight(n) + 12
					
					SetSpriteSize(ToolTips.SpriteBG,w+a*2,h+2*a)
					SetSpriteSize(ToolTips.Sprite,w,h)
					
					// for the timer of the tooltips
					Tooltips.TimeCurrent  = 120
					
					ToolTips.ok = 1
					ToolTipsEvent(x,y)
					
				
				
			Foldend
			
			endif
			
		Endif
		
	endif
	
EndFunction



// update, event
Function ToolTipsEvent(mx,my)
	
	// the event fotr the tooltips
	a = 1
	
	//If Tooltips.TimeCurrent < 0
		//Tooltips.TimeCurrent = Tooltips.TimeCurrent + 1
	//else
	
		If ToolTips.ok =1
			
			If Tooltips.TimeCurrent > 0
				
				Tooltips.TimeCurrent = Tooltips.TimeCurrent - 60/screenfps()
				// position x of the tooltips
					if mx <= G_width/2 
						tx = mx +10
					else
						tx = mx -GetSpriteWidth(ToolTips.SpriteBG) -10
					endif
					
					// position y of the tooltips
					if my <= G_height/2 
						ty = my + 10
					else
						ty = my -GetSpriteHeight(ToolTips.SpriteBG) -10
					endif
					
				SetSpritePosition(ToolTips.SpriteBG,tx+10,ty+10)
				SetSpriteDepth(ToolTips.SpriteBG,0)
				
				SetSpritePosition(ToolTips.Sprite,tx+10+a,ty+10+a)
				SetSpriteDepth(ToolTips.Sprite,0)
				
				SetTextPosition(ToolTips.Textid,tx+20,ty+18)
				SetTextDepth(ToolTips.Textid,0)
				
			else
				FreeToolTips()
			Endif
		Endif
	//Endif
	
EndFunction




// free
Function FreeToolTips()
	
	// to delete the tooltip sprite & text
	If ToolTips.ok =1
		If GetSpriteExists(ToolTips.SpriteBG)
			DeleteSprite(ToolTips.SpriteBG)
		endif
		If GetSpriteExists(ToolTips.Sprite)
			DeleteSprite(ToolTips.Sprite)
		endif
		If GetTextExists(ToolTips.Textid)
			DeleteText(ToolTips.Textid)
		endif
		Tooltips.TimeCurrent = 0
		ToolTips.ok =0
	endif	
	
EndFunction
