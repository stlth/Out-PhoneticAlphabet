<#PSScriptInfo
.VERSION 0.2.0
.GUID 2d10c0a1-6a5a-4cc5-876e-afd3feebc9e9
.AUTHOR Cory Calahan
.COMPANYNAME
.COPYRIGHT (C) Cory Calahan. All rights reserved.
.TAGS NATO,phonetic,alphabet
.LICENSEURI
.PROJECTURI
    https://github.com/stlth/Out-PhoneticAlphabet
.ICONURI
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
.Synopsis
    Converts a string to a phonetic alphabet (NATO) pronunciation.
.DESCRIPTION
    Converts a supplied string to output a phonetic alphabet (NATO) pronunciation as a new string.
.EXAMPLE
    PS> Out-PhoneticAlphabet -InputObject 000OOOo11IIi
#>
function Out-PhoneticAlphabet
{
    [CmdletBinding(SupportsShouldProcess=$true,
                  ConfirmImpact='Low')]
    [Alias('Out-NATOAlphabet')]
    [OutputType([String])]
    Param
    (
        # Input string to convert
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$false,
                   ValueFromRemainingArguments=$false,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[0-9a-zA-Z\.\-]+$")]
        [string[]]
        $InputObject
    )
    Begin
    {
        Write-Verbose -Message 'Listing Parameters utilized:'
        $PSBoundParameters.GetEnumerator() | ForEach-Object -Process { Write-Verbose -Message "$($PSItem)" }

        $nato = @{
            '0'=[PSCustomObject]@{PSOutputString='(ZERO)';Pronunciation='ZEE-RO';}
            '1'=[PSCustomObject]@{PSOutputString='(ONE)';Pronunciation='WUN';}
            '2'=[PSCustomObject]@{PSOutputString='(TWO)';Pronunciation='TOO';}
            '3'=[PSCustomObject]@{PSOutputString='(THREE)';Pronunciation='TREE';}
            '4'=[PSCustomObject]@{PSOutputString='(FOUR)';Pronunciation='FOW-ER';}
            '5'=[PSCustomObject]@{PSOutputString='(FIVE)';Pronunciation='FIFE';}
            '6'=[PSCustomObject]@{PSOutputString='(SIX)';Pronunciation='SIX';}
            '7'=[PSCustomObject]@{PSOutputString='(SEVEN)';Pronunciation='SEV-EN';}
            '8'=[PSCustomObject]@{PSOutputString='(EIGHT)';Pronunciation='AIT';}
            '9'=[PSCustomObject]@{PSOutputString='(NINE)';Pronunciation='NIN-ER';}
            'a'=[PSCustomObject]@{PSOutputString='alfa';Pronunciation='AL-FAH';}
            'b'=[PSCustomObject]@{PSOutputString='bravo';Pronunciation='BRAH-VOH';}
            'c'=[PSCustomObject]@{PSOutputString='charlie';Pronunciation='CHAR-LEE';}
            'd'=[PSCustomObject]@{PSOutputString='delta';Pronunciation='DELL-TAH';}
            'e'=[PSCustomObject]@{PSOutputString='echo';Pronunciation='ECK-OH';}
            'f'=[PSCustomObject]@{PSOutputString='foxtrot';Pronunciation='FOKS-TROT';}
            'g'=[PSCustomObject]@{PSOutputString='golf';Pronunciation='GOLF';}
            'h'=[PSCustomObject]@{PSOutputString='hotel';Pronunciation='HOH-TEL';}
            'i'=[PSCustomObject]@{PSOutputString='india';Pronunciation='IN-DEE-AH';}
            'j'=[PSCustomObject]@{PSOutputString='juliett';Pronunciation='JEW-LEE-ETT';}
            'k'=[PSCustomObject]@{PSOutputString='kilo';Pronunciation='KEY-LOH';}
            'l'=[PSCustomObject]@{PSOutputString='lima';Pronunciation='LEE-MAH';}
            'm'=[PSCustomObject]@{PSOutputString='mike';Pronunciation='MIKE';}
            'n'=[PSCustomObject]@{PSOutputString='november';Pronunciation='NO-VEM-BER';}
            'o'=[PSCustomObject]@{PSOutputString='oscar';Pronunciation='OSS-CAH';}
            'p'=[PSCustomObject]@{PSOutputString='papa';Pronunciation='PAH-PAH';}
            'q'=[PSCustomObject]@{PSOutputString='quebec';Pronunciation='KEH-BECK';}
            'r'=[PSCustomObject]@{PSOutputString='romeo';Pronunciation='ROH-ME-OH';}
            's'=[PSCustomObject]@{PSOutputString='sierra';Pronunciation='SEE-AIR-RAH';}
            't'=[PSCustomObject]@{PSOutputString='tango';Pronunciation='TANG-GO';}
            'u'=[PSCustomObject]@{PSOutputString='uniform';Pronunciation='YOU-NEE-FORM';}
            'v'=[PSCustomObject]@{PSOutputString='victor';Pronunciation='VIK-TAH';}
            'w'=[PSCustomObject]@{PSOutputString='whiskey';Pronunciation='WISS-KEY';}
            'x'=[PSCustomObject]@{PSOutputString='xray';Pronunciation='ECKS-RAY';}
            'y'=[PSCustomObject]@{PSOutputString='yankee';Pronunciation='YANG-KEY';}
            'z'=[PSCustomObject]@{PSOutputString='zulu';Pronunciation='ZOO-LOO';}
            '.'=[PSCustomObject]@{PSOutputString='(POINT)';Pronunciation='POINT';}
            '-'=[PSCustomObject]@{PSOutputString='(DASH)';Pronunciation='DASH';}
        }
    } # END: BEGIN
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            foreach ($string in $InputObject)
            {
                Write-Verbose -Message "InputObject: '$string'"
                $sb = New-Object -TypeName 'System.Text.StringBuilder'
                $characters = $string.ToCharArray()
                $count = $($characters.Count)
                for ($i = 0; $i -lt $count; $i++)
                {
                    $character = $characters[$i]
                    switch -Regex -CaseSensitive ($character)
                    {
                        '\d'
                        {
                            $sb.Append($nato.Get_Item("$character").PSOutputString) | Out-Null
                            break
                        }
                        '[a-z]'
                        {
                            $sb.Append($nato.Get_Item("$character").PSOutputString.ToLower()) | Out-Null
                            break
                        }
                        '[A-Z]'
                        {
                            
                            $sb.Append($nato.Get_Item("$character").PSOutputString.ToUpper()) | Out-Null
                            break
                        }
                        '\.'
                        {
                            $sb.Append($nato.Get_Item("$character").PSOutputString) | Out-Null
                            break
                        }
                        '\-'
                        {
                            $sb.Append($nato.Get_Item("$character").PSOutputString) | Out-Null
                            break
                        }
                        Default {<# Nothing. #>}
                    }
                    # The string contains additional characters, append a whitespace ' ' to make the output text easier to read.
                    if ($i -ne $($count-1))
                    {
                        $sb.Append(' ') | Out-Null
                    }
                }
                Write-Output -InputObject $($sb.ToString())
                Remove-Variable -Name sb,characters,count
            }
        }
    } # END: PROCESS
    End
    {
    } # END: END
}
