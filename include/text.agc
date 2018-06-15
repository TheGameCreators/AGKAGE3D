


//******************* fonction utiles pour le texte ******************//
Type sText
	
	x as float
	y as float
	textId as integer
	text$
	FontId as integer
	Time as integer
	TimeMax as integer
	Actif as integer
	
EndType


// Asset text
// ce sont des objets textes dont j'ai besoin, comme les fx
// par exemple pour monter le nombre de points en combat, le level up, etc..

Function InitAssetText()
	
	GameProp.NbAssetText = -1
	Global dim AssetText[] as sText
	//GameProp.AssetTextId = 0
		
EndFunction

Function AddAssetText(txt$,x,y)
	
	//if i = -1
		
		inc GameProp.NbAssetText 
		i = GameProp.NbAssetText 
		Global dim AssetText[i]as sText
		//GameProp.AssetTextId = -1
			
	//endif
	
	AssetText[i].x = x+viewX
	AssetText[i].y = y+viewY
	AssetText[i].Time = 120
	AssetText[i].TimeMax = 120	
	AssetText[i].Actif = 1
	AssetText[i].textId = AddText(x,y,txt$,Arial32,30)
	SetTextAlignment(AssetText[i].textId,1)
	
EndFunction

Function CheckAssetText(txt$,x,y)
	
	/*
	if GameProp.NbAssetText > -1
		if GameProp.AssetTextId  <> -1
		
		else
			for i = 0 to GameProp.NbAssetText
				if AssetText[i].actif = 0
					AddAssetText(i,txt$,x,y)
					trouve = 1
					exit
				endif
			next i
			if trouve = 0
				AddAssetText(-1,txt$,x,y)
			endif
		endif
				
	else
		//GameProp.NbAssetText = 0		
		AddAssetText(0,txt$,x,y)
	endif
	*/
	AddAssetText(txt$,x,y)
EndFunction

Function ResetAssetText()
	
	//if GameProp.NbAssetText > -1
		for i = 0 to AssetText.length //GameProp.NbAssetText
			//if g_tower[i].sprite > 10000
			//endif
			DeleteText(AssetText[i].textId)
		Next i
	//endif
	
	GameProp.NbAssetText = -1
	Global dim AssetText[] as sText
	//GameProp.AssetTextId = 0	

EndFunction

Function EventText()
	
	For i = 0 to AssetText.length  // GameProp.NbAssetText
		if AssetText[i].Time >= 0
			dec AssetText[i].Time
			if AssetText[i].Time <= AssetText[i].TimeMax/2
				b# = 255 
				b# = b#/ AssetText[i].TimeMax
				a = (b#*255)/(-AssetText[i].Time*2+AssetText[i].TimeMax+1)
				if a < 0
					a = 0
				endif
				SetTextColorAlpha(AssetText[i].textId,a)
			Endif
			SetTextPosition(AssetText[i].textId,AssetText[i].x, AssetText[i].y+(AssetText[i].Time-AssetText[i].TimeMax)/2)
		elseif AssetText[i].Time < 0
			DeleteText(AssetText[i].textId)
			AssetText.remove(i)
			//AssetText[i].Time = -1
			//AssetText[i].Actif = 0
			//GameProp.AssetTextId = i
			//SetTextPosition(AssetText[i].textId,-500,-500)
		endif			
	Next i
	
EndFunction



 // AddText et addtext2
Function AddTextFix(x,y,txt$,FontId,size,depth)

    id = CreateText(txt$)
    SetTextPosition(id, x, y)
    SetTextFontImage(id, FontId)
    SetTextExtendedFontImage(id, FontId)
    SetTextSize(id, size)
    FixTextToScreen(id, 1)
    SetTextDepth(id, depth)

EndFunction id

Function AddText(x,y,txt$,FontId,size)

    id = CreateText(txt$)
    SetTextPosition(id, x, y)
    SetTextFontImage(id, FontId)
    SetTextExtendedFontImage(id, FontId)
    SetTextSize(id, size)

EndFunction id

Function AddText2(id,x,y,txt$,FontId,size)

    CreateText(id,txt$)
    SetTextPosition(id, x, y)
    SetTextFontImage(id, FontId)
    SetTextExtendedFontImage(id, FontId)
    SetTextSize(id, size)

EndFunction

Function AddTextFix2(id, x, y, txt$, FontId, size)

    CreateText(id, txt$)
    SetTextPosition(id, x, y)
    SetTextFontImage(id, FontId)
    SetTextExtendedFontImage(id, FontId)
    SetTextSize(id, size)
    FixTextToScreen(id, 1)
    SetTextDepth(id, 1)

EndFunction id



Function TextlevelUp(txt$, x, y) 

    id = CreateText(txt$)
    SetTextPosition(id,  x, y)
    SetTextFontImage(id, Arial32)
    SetTextExtendedFontImage(id, Arial32)
    SetTextSize(id, 28)
    FixTextToScreen(id, 1)

EndFunction id

Function Input(textin$,length) 

    SetCursorBlinkTime(0.5)
    SetTextInputMaxChars(length)
    StartTextInput(textin$)

    do
        sync()
        state=GetTextInputState()
        c=GetLastChar()
        if GetTextInputCompleted()
            if GetTextInputCancelled()
                text$=textin$
                exit
            else
                text$=GetTextInput()
                exit
            endif
        endif

    loop

    StopTextInput()
    sync()

endfunction text$

function ReplaceString2(phrase$,string$,stringToreplace$) 

    // pour remplacer une partie d'une phrase, par exemple, des # par des chr(10)
	PhraseNew$ = Phrase$

    lenght=Len(phrase$)

    l=len(string$)
    for i=1 to lenght
        if mid(phrase$,i,l)=string$
            PhraseNew$=LEFT(phrase$,i-1)+stringToreplace$+RIGHT(phrase$,lenght-(i+l)+1)
            Phrase$ = PhraseNew$
        endif
    next i

EndFunction PhraseNew$ 


Function split(phrase$,char$,pos) 

    // pour découper une phrase en plusieurs
    debu=0
    fin=0
    index=0
    lenght=LEN(phrase$)
    inc pos

    for i=1 to lenght
        if mid(phrase$,i,1)=char$
            inc index
            if index=pos
                lenght=i-1
            else
                debu=i
            endif
        endif
    next i
    fin=lenght

    mot$=RIGHT(LEFT(phrase$,fin),fin-debu)

endfunction mot$ 

