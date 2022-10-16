#NoTrayIcon

;- This script is used to extract the original balance and import it into remastered scripts.
;- I don't see why anyone would get some use out of this but here you go.


#Include <File.au3>
#Include <Array.au3>

HotKeySet("{F5}","_END")
Func _END()
	Exit
EndFunc

Global $LegacyPath = "C:/Users/RX1500x-METEOR/Desktop/original" ;- Path to original lua weapon folder
Global $RemasteredPath = "C:/Users/RX1500x-METEOR/Desktop/remastered" ;- Path to remastered lua weapon folder
Global $OutputDir = "C:/Users/RX1500x-METEOR/Desktop/output" ;- Where to put the result

Global $LegacyRead = _FileListToArrayRec($LegacyPath,"*.lua",$FLTAR_FILES,$FLTAR_RECUR,$FLTAR_SORT,$FLTAR_FULLPATH)
_ArrayDelete($LegacyRead,0)

Global $RemasteredRead = _FileListToArrayRec($RemasteredPath,"*.lua",$FLTAR_FILES,$FLTAR_RECUR,$FLTAR_SORT,$FLTAR_FULLPATH)
_ArrayDelete($RemasteredRead,0)


Local $ArrayTagInfoText[9] = ["SWEP.Primary.RPM","SWEP.Primary.ClipSize","SWEP.Primary.KickUp","SWEP.Primary.KickDown","SWEP.Primary.KickHorizontal","SWEP.Primary.Automatic","SWEP.Primary.NumShots","SWEP.Primary.Damage","SWEP.Primary.Spread"]
Local $Blacklist[22] = [ _
	"-- This is in Rounds Per Minute", _
	"-- Size of a clip", _
	"-- Maximum up recoil (rise)", _
	"-- Maximum down recoil (skeet)", _
	"-- Maximum up recoil (stock)", _
	"-- Automatic/Semi Auto", _
	"-- How many bullets to shoot per trigger pull, AKA pellets", _
	"-- Base damage per bullet", _
	"-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)", _
	"-- Automatic = true; Semi Auto = false", _
	"-- How many bullets to shoot per trigger pull", _
	"--how many bullets to shoot per trigger pull", _
	"--define from-the-hip accuracy 1 is terrible, .0001 is exact)", _
	"--base damage per bullet", _
	"-- Define from-the-hip accuracy (1 is terrible, .0001 is exact)", _
	"//how many bullets to shoot, use with shotguns", _
	"//base damage, scaled by game", _
	"//define from-the-hip accuracy 1 is terrible, .0001 is exact)", _
	"--how many bullets to shoot, use with shotguns", _
	"--base damage, scaled by game", _
	"//define from-the-hip accuracy (1 is terrible, .0001 is exact)", _
	"-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun" _
]

For $AZ = 0 To uBound($LegacyRead) - 1 Step 1
	Local $ArrayTagInfo[9] = ["RPM = ","ClipSize = ","KickUp = ","KickDown = ","KickHorizontal = ","Automatic = ","NumShots = ","Damage = ","Spread = "]

	Local $ReadLeg = FileReadToArray($LegacyRead[$AZ])
	Local $Lines = @extended

	For $I = 0 To $Lines - 1 Step 1
		For $B = 0 To 8 Step 1
			If StringLeft($ReadLeg[$I],StringLen($ArrayTagInfoText[$B])) == $ArrayTagInfoText[$B] Then

				Local $FindEqual = 0
				For $A = 0 To StringLen($ReadLeg[$I]) Step 1
					If StringMid($ReadLeg[$I],$A,1) == "=" Then
						$FindEqual = $A

						ExitLoop
					EndIf
				Next

				$ArrayTagInfo[$B] = $ArrayTagInfo[$B] & StringMid($ReadLeg[$I],$FindEqual+1)

				$ArrayTagInfo[$B] = StringReplace($ArrayTagInfo[$B],"  "," ") ;- Byebye double spaces
				$ArrayTagInfo[$B] = StringReplace($ArrayTagInfo[$B],"  "," ")
				$ArrayTagInfo[$B] = StringReplace($ArrayTagInfo[$B],"  "," ")

				$ArrayTagInfo[$B] = StringReplace($ArrayTagInfo[$B],@Tab,"") ;- Remove tabs

				For $Z = 0 To uBound($Blacklist) - 1 Step 1 ;- Filter text
					$ArrayTagInfo[$B] = StringReplace($ArrayTagInfo[$B],$Blacklist[$Z],"")
				Next

				If $B <> 8 Then
					$ArrayTagInfo[$B] = $ArrayTagInfo[$B] & ","
				EndIf
			EndIf
		Next
	Next


	Local $Str = "SWEP.LegacyBalance = {" & @CRLF & @TAB & "Primary = {" & @CRLF

	For $I = 0 To uBound($ArrayTagInfo) - 1 Step 1
		$Str = $Str & @Tab & @Tab & $ArrayTagInfo[$I] & @CRLF
	Next

	$Str = $Str & @TAB & "}" & @CRLF & "}"


	;- Retrieve file name

	Local $FName = ""
	For $I = StringLen($LegacyRead[$AZ]) To 1 Step -1
		If StringMid($LegacyRead[$AZ],$I,1) == "\" Then
			$FName = StringMid($LegacyRead[$AZ],$I+1)

			$FName = StringReplace($FName,"\shared.lua","")
		EndIf
	Next


	$FName = $FName & ".lua"


	;- Does it exist in remastered? If so, add the balance table!

	Local $iLen = StringLen($FName)

	For $I = 0 To uBound($RemasteredRead) - 1 Step 1
		If StringRight($RemasteredRead[$I],$iLen) == $FName Then

			;- Find the last line that starts with SWEP.

			Local $FileRead = FileReadToArray($RemasteredRead[$I])
			Local $Lines = @extended
			Local $iLast = 1

			For $A = 1 To $Lines - 1 Step 1
				If StringLeft($FileRead[$A],5) == "SWEP." Then
					$iLast = $A
				EndIf
			Next

			If $iLast+1 == $Lines or $iLast == $Lines Then
				_ArrayAdd($FileRead,@CRLF & $Str)
			Else
				_ArrayInsert($FileRead,$iLast + 1,@CRLF & $Str)
			EndIf

			$FileRead = _ArrayToString($FileRead,@CRLF)

			FileWrite($OutputDir & "\" & $FName,$FileRead)
			ExitLoop

		EndIf
	Next
Next