#pragma rtGlobals = 1				// Use modern global access method.
#pragma version = 1.0.0			//by Yuichi Takeuchi 140122
#pragma IgorVersion = 6.3.7.2		// Igor Pro 6.0 or later

// A procedure for CMAP recordings on LabChart7.
// Reference: Byrne PJ et al. (2005) Arch Facial Plast Surg 7:114-118. 

Macro CMAP_Preparation()
	CMAP_GlobalVariables()
	CMAP_Waves("Latency1;Latency2;Duration;Amplitude;RectifiedArea;ConductionVelocity;")
	CMAP_ControlPanel()
endMacro

Macro CMAP_Help()
	CMAP_HelpNote()
endMacro

Macro CMAP_Procedure()
	DisplayProcedure/W='CMAPAnalysis.ipf'
endMacro

Function CMAP_GlobalVariables()
	CMAP_FolderCheck()
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:Packages:CMAP

	String/G tWin = "Select tWin!"
	String/G tWave = "Select tWave!"
	String/G tWL = "Select tWinL!;"

	Variable/G tWinCategory
	Variable/G CMAPArtifactOnset = 1 			// in millisecond
	Variable/G CMAPLengthOfNerve = 0.01		// in meter
	Variable/G CMAPLatency1 = 0				// in millisecond
	Variable/G CMAPLatency2 = 0				// in millisecond
	Variable/G CMAPDuration = 0				// in millisecond
	Variable/G CMAPAmplitude = 0				// in microV
	Variable/G CMAPArea = 0					// in microV*millisecond
	Variable/G CMAPConductionVelocity = 0		// in meter/millisecond
	
	SetDataFolder fldrSav0
end

Function CMAP_Waves(CMAPWaveList)
	String CMAPWaveList
	
	CMAP_FolderCheck()
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:Packages:CMAP
	
	If(WinType("TableCMAPResults") == 2)
		DoWindow/F $"TableCMAPResults"
	else
		Edit/N=TableCMAPResults
	endIf
	
	Variable i = 0
	String SFL = ""
	do
		SFL = StringFromList(i, CMAPWaveList)
		If(strlen(SFL) == 0)
			break
		endIf
		If(Exists(SFL) != 1)
			Make/N=0 $SFL
		endIf
		AppendToTable $SFL
		i += 1
	while(1)
	
	SetDataFolder fldrSav0
end

Function CMAP_FolderCheck()
	If(DataFolderExists("root:Packages:CMAP"))
		else
			If(DataFolderExists("root:Packages"))
					NewDataFolder root:Packages:CMAP
				else
					NewDataFolder root:Packages
					NewDataFolder root:Packages:CMAP
			endif
	endif
end

Function CMAP_ControlPanel()
	SVAR tWin = 	root:Packages:CMAP:tWin
	PauseUpdate; Silent 1		// building window...
	NewPanel/N=CMAPControlPanel/W=(600,5,1000,485)

	GroupBox GBtwin,pos={13,10},size={370,65},title="Target Window "
	Button BttWin,pos={16,25},size={50,20},proc=CMAP_GettWin,title="Get"
	Button BtCleartWin,pos={66,25},size={50,20},proc=CMAPCleartWin,title="Clear"
	Button BtCleartWin,fColor=(0,15872,65280)
	SetVariable settwin,pos={125,27},size={125,16},title=" "
	SetVariable settwin,value= root:Packages:CMAP:tWin
	PopupMenu Poptwin,pos={260,27},size={105,20},bodyWidth=105,proc=CMAP_PopstrtWin
	PopupMenu Poptwin,mode=1,popvalue="Select tWin",value= #"winlist(\"*\", \";\", \"\")"
	PopupMenu PopUptWinCategory,pos={219,50},size={149,20},bodyWidth=100,proc=CMAP_tWinCategory,title="Category"
	PopupMenu PopUptWinCategory,mode=2,popvalue="Category",value= "All;Graphs;Tables;Layouts;Notebooks;Panels;Procedure Windows;XOP target windows;"

	GroupBox gbtWave,pos={13,78},size={370,40},title="Target Wave"
	Button BtGettWave,pos={16,93},size={50,20},proc=CMAP_GettWave,title="Get"
	Button BtCleartWave,pos={66,93},size={50,20},proc=CMAP_CleartWave,title="Clear"
	Button BtCleartWave,fColor=(0,15872,65280)
	SetVariable settWave,pos={125,95},size={100,16},bodyWidth=100,title=" "
	SetVariable settWave,value= root:Packages:CMAP:tWave
	PopupMenu PoptWave,pos={230,93},size={75,20},bodyWidth=75,proc=CMAP_PoptWave
	PopupMenu PoptWave,mode=253,popvalue="",value= #"wavelist(\"*\", \";\", \"\")"
	Button BTDisplay,pos={312,93},size={50,20},proc=CMAP_DisplaytWave,title="Display"

	GroupBox GBtWL,pos={13,120},size={370,60},title="Target Wavelist"
	Button BtGettWaveList,pos={16,135},size={50,20},proc=CMAP_GettWL,title="Get"
	Button BtCleartWL,pos={66,135},size={50,20},proc=CMAP_CleartWL,title="Clear"
	Button BtCleartWL,fColor=(0,15872,65280)
	SetVariable settWaveList,pos={125,136},size={200,16},bodyWidth=200,title=" "
	SetVariable settWaveList,value= root:Packages:CMAP:tWL
	Button BtDispWaveList_tab10,pos={16,155},size={50,20},proc=CMAP_DisptWL,title="Display"
	Button BtDuplicateWL,pos={66,155},size={55,20},proc=CMAP_DuplicatetWL,title="Duplicate"
	Button BtSubtractionWL,pos={121,155},size={50,20},proc=CMAP_BaseSubtraction,title="BaseSub"
	Button BtAutoStatsWL,pos={171,155},size={50,20},proc=CMAP_AveragetWL,title="Average"

	GroupBox GBCsr,pos={13,183},size={370,40},title="Cursor"
	Button BtPutCsr,pos={15,198},size={50,20},proc=CMAP_PutCsr,title="Put"
	Button BtMIntCs,pos={65,198},size={50,20},proc=CMAP_IntervalCursors,title="Interval"
	Button BtMHorCs,pos={115,198},size={50,20},proc=CMAP_HeightCursors,title="Height"
	Button BtKillCsr,pos={165,198},size={50,20},proc=CMAP_KillCursors,title="Kill"

	GroupBox GBSetting,pos={13,229},size={370,45},title="Setting"
	SetVariable SetvarCMAPAritifact,pos={29,248},size={150,16},title="Artifact onset (ms)"
	SetVariable SetvarCMAPAritifact,limits={0,inf,0.0001},value= root:Packages:CMAP:CMAPArtifactOnset,noedit= 1
	SetVariable SetvarNerveLength,pos={187,248},size={150,16},title="Nerve length (m)"
	SetVariable SetvarNerveLength,limits={0,inf,0.001},value= root:Packages:CMAP:CMAPLengthOfNerve
	
	Button BtRun,pos={34,279},size={50,20},proc=CMAP_RunAnalysis,title="Run"
	Button BtPrintResults,pos={98,279},size={50,20},proc=CMAP_PrintResults,title="Print"
	Button BtEditResults,pos={162,279},size={50,20},proc=CMAP_EditResults,title="Edit"
	Button BtSaveResults,pos={226,279},size={50,20},proc=CMAP_SaveResults,title="Save"

	GroupBox GBResults,pos={13,305},size={226,145},title="Results"
	SetVariable SetvarLatency1,pos={30,325},size={200,16},title="Latency1 (ms)"
	SetVariable SetvarLatency1,limits={-inf,inf,0},value= root:Packages:CMAP:CMAPLatency1
	SetVariable SetvarLatency2,pos={30,345},size={200,16},title="Latency2 (ms) "
	SetVariable SetvarLatency2,limits={-inf,inf,0},value= root:Packages:CMAP:CMAPLatency2
	SetVariable SetvarDuration,pos={30,365},size={200,16},title="Duration (ms)"
	SetVariable SetvarDuration,limits={-inf,inf,0},value= root:Packages:CMAP:CMAPDuration
	SetVariable SetvarAmplitude,pos={30,385},size={200,16},title="Amplitude (uV)"
	SetVariable SetvarAmplitude,limits={-inf,inf,0},value= root:Packages:CMAP:CMAPAmplitude
	SetVariable SetvarArea,pos={30,405},size={200,16},title="Area (uV*ms)"
	SetVariable SetvarArea,limits={-inf,inf,0},value= root:Packages:CMAP:CMAPArea
	SetVariable SetvarConductionVelocity,pos={30,425},size={200,16},title="Conduction Velocity (m/s)"
	SetVariable SetvarConductionVelocity,value= root:Packages:CMAP:CMAPConductionVelocity

	Button BtAxisOn,pos={274,328},size={50,20},proc=CMAP_AxisOn,title="AxisOn"
	Button BtAxisOff,pos={274,348},size={50,20},proc=CMAP_AxisOff,title="AxisOff"
	Button BtInvert,pos={274,368},size={50,20},proc=CMAP_Invert,title="Invert"
	Button BtModGraph1,pos={274,368},size={55,20},proc=CMAP_MakeGraph,title="MGraph1"
	Button BtModGraph2,pos={274,388},size={55,20},proc=CMAP_MakeGraph,title="MGraph2"
	Button BtModGraph3,pos={274,408},size={55,20},proc=CMAP_MakeGraph,title="MGraph3"
	Button BtModGraph4,pos={274,428},size={55,20},proc=CMAP_MakeGraph,title="MGraph4"
	Button BtModGraph5,pos={274,448},size={55,20},proc=CMAP_MakeGraph,title="MGraph5"	
End

Function  CMAP_HelpNote()
	
	NewNotebook/F=0
	String strhelp =""
	strhelp += "0. Preparation									(Menu -> Macros -> CMAP_Preparation)"+"\r"
	strhelp += "1. Display source waves on a graph"+"\r"
	strhelp += "2. Specify the Target Window						(Control Panel -> Target Window -> Get button)"+"\r"
	strhelp += "3. Get the list of source waves						(Control Panel -> Target Wavelist -> Get button)"+"\r"
	strhelp += "4. Duplicate the source waves						(Control Panel -> Target Wavelist -> Duplicate)"+"\r"
	strhelp += "5. BaseSubtraction 								(Control Panel -> Target Wavelist -> BaseSub button)"+"\r"
	strhelp += "6. Average duplicated waves						(Control Panel -> Target Wavelist -> Average button)"+"\r"
	strhelp += "7. Put Cursor A and B, at the begining and ending of the averaged CMAP, respectively."+"\r"
	strhelp += "8. Set Artifact onset and Nerve length				(Control Panel -> Setting)"+"\r"
	strhelp += "9. Measure: Run, Print, Edit, and Save button."+"\r"
	strhelp += ""+"\r"
	Notebook $WinName(0, 16) selection={endOfFile, endOfFile}
	Notebook $WinName(0, 16) text = strhelp + "\r"
end

Function CMAP_GettWin(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin
	DoWindow/B CMAPControlPanel
	tWin = WinName(0,87)
	If(StringMatch(tWin, "CMAPControlPanel") || StringMatch(tWin, "Select tWin!"))
		tWin = "Select tWin!"
		Abort
	endIf
	DoWindow/F CMAPControlPanel
	If(Strlen(tWin) == 0)
		Abort
	endIf
	DoWindow/F $tWin
End

Function CMAPCleartWin(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin
	tWin = ""
End

Function CMAP_PopstrtWin(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	SVAR tWin = root:Packages:CMAP:tWin

	If(stringmatch(popStr, "*.ipf"))
		DisplayProcedure/W = $popStr
	else
		DoWindow/F $popStr
	endif

	tWin = popStr

	ControlUpdate/A
	If(stringmatch(popStr, "*.ipf"))
		DisplayProcedure/W = $popStr
	else
		If(stringmatch(popStr, "Procedure"))
			DisplayProcedure/W = $"Procedure"
		else
			DoWindow/F $popStr
		endif
	endif
End

Function CMAP_tWinCategory(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	NVAR tWinCategory = root:Packages:CMAP:tWinCategory

	Switch (popNum)
		case 1 :
			tWinCategory = 0
			PopupMenu Poptwin value=winlist("*", ";", "")
			break;
		case 2 :
			tWinCategory = 1
			PopupMenu Poptwin value=winlist("*", ";", "Win:1")
			break;
		case 3 :
			tWinCategory = 2
			PopupMenu Poptwin value=winlist("*", ";", "Win:2")
			break;
		case 4 :
			tWinCategory = 4
			PopupMenu Poptwin value=winlist("*", ";", "Win:4")
			break;
		case 5 :
			tWinCategory = 16
			PopupMenu Poptwin value=winlist("*", ";", "Win:16")
			break;
		case 6 :
			tWinCategory = 64
			PopupMenu Poptwin value=winlist("*", ";", "Win:64")
			break;
		case 7 :
			tWinCategory = 128
			PopupMenu Poptwin value=winlist("*", ";", "Win:128")
			break;
		case 8 :
			tWinCategory = 4096
			PopupMenu Poptwin value=winlist("*", ";", "Win:4096")
		default :
			break;
	endswitch
End

Function CMAP_GettWave(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWave = root:Packages:CMAP:tWave
	tWave = StringByKey("TNAME", CsrInfo(A))
End

Function CMAP_CleartWave(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWave = root:Packages:CMAP:tWave
	tWave = ""
End

Function CMAP_PoptWave(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr

	SVAR tWave = root:Packages:CMAP:tWave
	tWave = popStr
End

Function CMAP_DisplaytWave(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave = root:Packages:CMAP:tWave
	Display $tWave
	GetAxis/Q left
	SetAxis left, V_max, V_min
	Showinfo
	
	CMAP_GettWin("")
End

Function CMAP_GettWL(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWL = root:Packages:CMAP:tWL
	SVAR tWin = root:Packages:CMAP:tWin
	tWL = wavelist("*", ";", "WIN:")
End

Function CMAP_CleartWL(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWL = root:Packages:CMAP:tWL
	tWL = ""
End

Function CMAP_DisptWL(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWL = root:Packages:CMAP:tWL
	String SFL
	Variable i = 0

	do
		SFL = StringFromList(i, tWL)
		if(strlen(SFL) == 00)
			break
		endif
		if(i == 0)
			Display $SFL
		else
			appendtograph $SFL
		endif
		i += 1
	while(1)
	
	GetAxis/Q left
	SetAxis left, V_max, V_min
	showinfo
End

Function CMAP_DuplicatetWL(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin
	SVAR tWL = root:Packages:CMAP:tWL
	String Keyword
	String SwitchStr
	String OW
	String SwitchDisplay
	Prompt Keyword, "Enter Keyword"
	Prompt OW "Overwrite?", popup "Yes;No;"
	Prompt SwitchDisplay "Display?", popup "Yes;No;"
	DoPrompt "Duplicate Wave", Keyword, OW, SwitchDisplay
	If(V_flag)
		Abort
	endif
	Variable i = 0
	String SFL
	If(StringMatch(SwitchDisplay, "Yes"))
		Display
		ShowInfo
	endif
	do
		SFL = StringFromList(i, tWL)
		If(Strlen(SFL) == 0)
			break
		endif
		Wave srcWave = $SFL
		String destWave = Keyword + "_" + Num2str(i)
		If(StringMatch(OW, "Yes"))
			Duplicate/O srcWave $destWave
		else
			Duplicate srcWave $destWave
		endif
		If(StringMatch(SwitchDisplay, "Yes"))
			AppendToGraph $destWave
		endif
		i += 1
	while(1)

	If(StringMatch(SwitchDisplay, "Yes"))
		CMAP_GettWin("")
		CMAP_GettWL("")
		DoWindow/K $tWin
		CMAP_DisptWL("")
	endif			
End

Function CMAP_BaseSubtraction(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWL = root:Packages:CMAP:tWL
	Variable i, s = 0
	String SFL
	do
		SFL = StringFromList(i, tWL)
		If(strlen(SFL) == 0)
			break
		endif
		Wave srcW = $SFL
		If(strlen(CsrInfo(A)) == 0)
			Cursor A, $SFL, leftx($SFL)
		endIf
		s= srcW(xcsr(a))
		srcW = srcW - s		
		i += 1
	while(1)
End

Function CMAP_AveragetWL(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin
	SVAR tWL = root:Packages:CMAP:tWL
	SVAR tWave = root:Packages:CMAP:tWave

	if(strlen(StringFromList(0, tWL)) == 0)
		Abort
	endif
	
	Wave srcWave = $StringFromList(0, tWL)
	
	String destName, target, appendtg, strdisplay, wn
	Prompt destName, "Enter the name of destination wave"
	Prompt target "target wave?", popup "Yes;No;"
	Prompt appendtg "AppendToGraph?", popup "Yes;No;"
	Prompt strdisplay "Display?", popup "Yes;No;"
	DoPrompt "Igor wants to know", destName, target, appendtg, strdisplay
	If(V_flag)
		Abort
	endif

	Variable index=0

	wn = StringFromList(0, tWL)
	Duplicate/O $wn, $destName

	WAVE dest = $destName
	dest = 0
	
	do
		wn = StringFromList(index, tWL)
		if (strlen(wn) == 0)
			break
		endif
		WAVE source = $wn
		dest += source
		index += 1
	while (1)

	dest /= index	
	
	If(StringMatch(target, "Yes"))
		tWave = destName
	endIf
		
	If(StringMatch(appendtg, "Yes"))
		AppendToGraph/W=$tWin $destName
		ModifyGraph/W=$tWin rgb($destName)=(8704,8704,8704)
		ShowInfo
	endIf
	
	If(StringMatch(strdisplay, "Yes"))
		Display $tWave
		GetAxis/Q left
		SetAxis left, V_max, V_min
		Showinfo
		CMAP_GettWin("")
	endif
End

Function CMAP_PutCsr(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWave = root:Packages:CMAP:tWave
	Cursor A, $tWave, leftx($tWave)
	Cursor B, $tWave, leftx($tWave)
End

Function CMAP_IntervalCursors(ctrlName) : ButtonControl
	String ctrlName

	print (xcsr(B)-xcsr(A))
End

Function CMAP_HeightCursors(ctrlName) : ButtonControl
	String ctrlName

	print(vcsr(B)-vcsr(A))
End

Function CMAP_KillCursors(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin

	Cursor/K/W=$tWin A
	Cursor/K/W=$tWin B	
End

Function CMAP_RunAnalysis(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWave = root:Packages:CMAP:tWave

	NVAR Latency1 = root:Packages:CMAP:CMAPLatency1
	NVAR Latency2 = root:Packages:CMAP:CMAPLatency2
	NVAR Duration = root:Packages:CMAP:CMAPDuration
	NVAR Amplitude = root:Packages:CMAP:CMAPAmplitude
	NVAR CMAPArea = root:Packages:CMAP:CMAPArea
	NVAR ConductionVelocity = root:Packages:CMAP:CMAPConductionVelocity

	NVAR ArtifactOnset = root:Packages:CMAP:CMAPArtifactOnset
	NVAR LengthOfNerve = root:Packages:CMAP:CMAPLengthOfNerve
	
	WaveStats/Q/R=(xcsr(A), xcsr(B)) $tWave
	
	Duplicate/O $tWave, $"WaveTempCMAP"
	WAVE temp = $"WaveTempCMAP"
	temp[p, ] = abs(temp[p])
	
	Latency1 = xcsr(A) - ArtifactOnset
	Latency2 = xcsr(B) - ArtifactOnset
	Duration = xcsr(B) - xcsr(A)
	Amplitude = V_max - V_min
	CMAPArea = area(temp, xcsr(A), xcsr(B))
	ConductionVelocity = LengthOfNerve*1000/Latency1

	Make/n=6 array
	array[0] = Latency1
	array[1] = Latency2
	array[2] = Duration
	array[3] = Amplitude
	array[4] = CMAPArea
	array[5] = ConductionVelocity
	CMAP_WaveUpDate(array, "Latency1;Latency2;Duration;Amplitude;RectifiedArea;ConductionVelocity;")
	
	Killwaves temp, array
End

Function CMAP_WaveUpDate(array, SrcWaveList)
	WAVE array
	String SrcWaveList
	
	CMAP_FolderCheck()
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:Packages:CMAP

	Variable i = 0
	
	do
		String SFL = StringFromList(i, SrcWaveList)
		If(strlen(SFL) < 1)
			break
		endIf
		WAVE temp = $SFL
		Redimension/n=(numpnts(temp)+1) temp
		temp[(numpnts(temp) - 1)] = array[i]
		i += 1
	while(1)
	
	SetDataFolder fldrSav0
End

Function CMAP_PrintResults(ctrlName) : ButtonControl
	String ctrlName

	NVAR Latency1 = root:Packages:CMAP:CMAPLatency1
	NVAR Latency2 = root:Packages:CMAP:CMAPLatency2
	NVAR Duration = root:Packages:CMAP:CMAPDuration
	NVAR Amplitude = root:Packages:CMAP:CMAPAmplitude
	NVAR CMAPArea = root:Packages:CMAP:CMAPArea
	NVAR ConductionVelocity = root:Packages:CMAP:CMAPConductionVelocity
	
	Printf "%s %s\r", Date(), Time()
	Printf "Latency1 = %f\r", Latency1
	Printf "Latency2 = %f\r", Latency2
	Printf "Duration = %f\r", Duration
	Printf "Amplitude = %f\r", Amplitude
	Printf "Area = %f\r", CMAPArea
	Printf "Conduction Velocity = %f\r", ConductionVelocity 
	
//	NewNotebook/F=0
//	String strout =""
//	strout += Num2str(Latency1)+"\r"
//	strout += Num2str(Latency2)+"\r"
//	strout += Num2str(Duration)+"\r"
//	strout += Num2str(Amplitude)+"\r"
//	strout += Num2str(CMAPArea)+"\r"
//	strout += Num2str(ConductionVelocity)
//	Notebook $WinName(0, 16) selection={endOfFile, endOfFile}
//	Notebook $WinName(0, 16) text = strout + "\r"
End

Function CMAP_EditResults(ctrlName) : ButtonControl
	String ctrlName
	
	CMAP_Waves("Latency1;Latency2;Duration;Amplitude;RectifiedArea;ConductionVelocity;")
End

Function CMAP_SaveResults(ctrlName) : ButtonControl
	String ctrlName
	
	CMAP_Waves("Latency1;Latency2;Duration;Amplitude;RectifiedArea;ConductionVelocity;")
	
	DoWindow/F TableCMAPResults
	SaveTableCopy/T=2
End

Function CMAP_AxisOn(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:CMAP:tWin
	String SFL
	Variable i = 0
	do
		If(Strlen(StringFromList(i, AxisList(tWin))) == 0)
			break
		endif
		SFL = StringFromList(i, AxisList(tWin))
		ModifyGraph/W = $tWin noLabel($SFL) = 0, axThick = 1
		i += 1
	while(1)
End

Function CMAP_AxisOff(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWin = root:Packages:CMAP:tWin
	String SFL
	Variable i = 0
	do
		If(Strlen(StringFromList(i, AxisList(tWin))) == 0)
			break
		endif
		SFL = StringFromList(i, AxisList(tWin))
		ModifyGraph/W = $tWin noLabel($SFL) = 2, axThick = 0
		i += 1
	while(1)
End

Function CMAP_Invert(ctrlName) : ButtonControl
	String ctrlName

	SVAR tWin = root:Packages:CMAP:tWin
	If(WinType(tWin) == 1)
		GetAxis/Q/W=$tWin left
		SetAxis/W=$tWin left, V_max, V_min
	endIf
End

Function CMAP_MakeGraph(ctrlName) : ButtonControl
	String ctrlName
	
	SVAR tWave = root:Packages:CMAP:tWave
	
	PauseUpdate; Silent 1		// building window...
	Display/W=(111,261.5,428.25,518) $tWave
	ModifyGraph expand=-2,width=85.0394,height=85.0394
	ModifyGraph rgb=(0,0,0)
	ModifyGraph noLabel=2
	ModifyGraph axThick=0
	ModifyGraph lsize=0.75
	
	Variable VSwitch
	sscanf ctrlName, "BtModGraph%d", VSwitch
	
	switch(VSwitch)
		case 1:
			SetAxis left 1000,-2000
			SetAxis bottom 0,10
			TextBox/C/N=text0/F=0/A=MC/X=51.10/Y=-57.71 "1 mV"
			break
		case 2:
			SetAxis left 2000,-4000
			SetAxis bottom 0,10
			TextBox/C/N=text0/F=0/A=MC/X=51.10/Y=-57.71 "2 mV"
			break
		case 3:
			SetAxis left 3000,-6000
			SetAxis bottom 0,10
			TextBox/C/N=text0/F=0/A=MC/X=51.10/Y=-57.71 "3 mV"
			break
		case 4:
			SetAxis left 4000,-8000
			SetAxis bottom 0,10
			TextBox/C/N=text0/F=0/A=MC/X=51.10/Y=-57.71 "4 mV"
			break
		case 5:
			SetAxis left 5000,-10000
			SetAxis bottom 0,10
			TextBox/C/N=text0/F=0/A=MC/X=51.10/Y=-57.71 "5 mV"
			break
		default:
			break
	endswitch
	TextBox/C/N=text1/F=0/A=MC/X=25.11/Y=-81.94 "2 ms"
	SetDrawLayer UserFront
	DrawLine 0.845814977973568,0.903083700440529,0.845814977973568,1.23788546255507
	DrawLine 0.643171806167401,1.23348017621146,0.845814977973568,1.23348017621146
End













