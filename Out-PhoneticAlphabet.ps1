<#PSScriptInfo
.VERSION 0.1.0
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
        $PSBoundParameters.GetEnumerator() | ForEach-Object { Write-Verbose -Message "$($PSItem)" }

        $nato = @{
            '0'='(ZERO)'
            '1'='(ONE)'
            '2'='(TWO)'
            '3'='(THREE)'
            '4'='(FOUR)'
            '5'='(FIVE)'
            '6'='(SIX)'
            '7'='(SEVEN)'
            '8'='(EIGHT)'
            '9'='(NINE)'
            'a'='alfa'
            'b'='bravo'
            'c'='charlie'
            'd'='delta'
            'e'='echo'
            'f'='foxtrot'
            'g'='golf'
            'h'='hotel'
            'i'='india'
            'j'='juliett'
            'k'='kilo'
            'l'='lima'
            'm'='mike'
            'n'='november'
            'o'='oscar'
            'p'='papa'
            'q'='quebec'
            'r'='romeo'
            's'='sierra'
            't'='tango'
            'u'='uniform'
            'v'='victor'
            'w'='whiskey'
            'x'='xray'
            'y'='yankee'
            'z'='zulu'
            '.'='(POINT)'
            '-'='(DASH)'
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
                            $sb.Append($nato.Get_Item("$character")) | Out-Null
                            break
                        }
                        '[a-z]'
                        {
                            $sb.Append($nato.Get_Item("$character").ToLower()) | Out-Null
                            break
                        }
                        '[A-Z]'
                        {
                            
                            $sb.Append($nato.Get_Item("$character").ToUpper()) | Out-Null
                            break
                        }
                        '\.'
                        {
                            $sb.Append($nato.Get_Item("$character")) | Out-Null
                            break
                        }
                        '\-'
                        {
                            $sb.Append($nato.Get_Item("$character")) | Out-Null
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