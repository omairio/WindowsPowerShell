$env:Path += ";$Env:HOMEPATH\Documents\WindowsPowerShell;C:\Python34"
$env:Path += ";C:\Program Files (x86)\mingw-w64\i686-4.9.2-posix-dwarf-rt_v4-rev2\mingw32\bin"

$env:Path += ";Z:\Program Files (x86)\Git\bin"
$env:Path += ";Z:\Program Files (x86)\Git\share\vim\vim74"

# Transparent windows
WinStyler.exe -p PowerShell -a 225

# My Aliases
Set-Alias e explorer
Set-Alias l color-ls
Set-Alias ls color-ls -Option AllScope
Set-Alias subl "C:\Program Files\Sublime Text 3\sublime_text"

function profile {
    subl $profile
}

function Prompt {
    $promptUser = "Omair@$env:computername "
    $promptString = "" + $(Get-Location) + ">"
 
    # Custom color for Windows console
    if ( $Host.Name -eq "ConsoleHost" )
    {
        Write-Host $promptUser -NoNewline -ForegroundColor Cyan
        Write-Host $promptString -NoNewline -ForegroundColor Green
    }
    # Default color for the rest
    else
    {   
        $noConsole = $promptUser + $promptString
        Write-Host $noConsole -NoNewline
    }
 
    return " "
}

function color-ls
{
    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
          -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $fore = $Host.UI.RawUI.ForegroundColor
    $compressed = New-Object System.Text.RegularExpressions.Regex(
          '\.(zip|tar|gz|rar|jar|war)$', $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
          '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
          '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|cs)$', $regex_opts)

    Invoke-Expression ("Get-ChildItem $args") | ForEach-Object {
        if ($_.GetType().Name -eq 'DirectoryInfo') 
        {
            $Host.UI.RawUI.ForegroundColor = 'DarkCyan'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        }
        elseif ($compressed.IsMatch($_.Name)) 
        {
            $Host.UI.RawUI.ForegroundColor = 'DarkGreen'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        }
        elseif ($executable.IsMatch($_.Name))
        {
            $Host.UI.RawUI.ForegroundColor = 'DarkRed'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        }
        elseif ($text_files.IsMatch($_.Name))
        {
            $Host.UI.RawUI.ForegroundColor = 'Yellow'
            echo $_
            $Host.UI.RawUI.ForegroundColor = $fore
        }
        else
        {
            echo $_
        }
    }
}


function Show-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}
