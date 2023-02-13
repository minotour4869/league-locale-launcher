Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles();

function Deploy-Game()
{
    $file = $file_textdir.Text
    # Write-Host $Global:LeagueFile
    $arg = "--locale=" + $locale_dropdown.SelectedItem
    & $file $arg
}

function Submit-File($file) 
{
    $LEAGUE_HASH = "B3AE988654AF2AE7E5D538FF45417D38849F9A03A99D94043AC38574B0FB03E3"
    return (Get-FileHash $file).Hash -eq $LEAGUE_HASH
}


function Get-Path() 
{
    $Explorer = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [System.Environment]::GetFolderPath('Desktop') }
    $Explorer.Title = "Browsing game directory"
    $Explorer.Filter = "League Client|LeagueClient.exe"

    $result = $Explorer.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        if (Submit-File($Explorer.OpenFile()))
        {
            $Global:LeagueFile = $Explorer.FileName
            $file_textdir.Text = $Global:LeagueFile
            Out-File -FilePath $env:USERPROFILE\.leaguedir -InputObject $Global:LeagueFile
            Write-Host $file
        }
        else 
        {
            [System.Windows.Forms.MessageBox]::Show('Invalid directory, please try again.', 'Error', 'Ok', 'Error')
        }
    }
}

$LeagueFile = Get-Content $env:USERPROFILE\.leaguedir -ErrorAction Ignore

$form = New-Object System.Windows.Forms.Form
$form.Text = 'League of Legends Locale Launcher'
$form.Size = New-Object System.Drawing.Size(420,180)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.StartPosition = 'CenterScreen'

# Load icon (kill me)
$icon_b64 = "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"
$icon_bytes = [System.Convert]::FromBase64String($icon_b64)
$icon_stream = [System.IO.MemoryStream]::new($icon_bytes, 0, $icon_bytes.Length)
$form.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($icon_stream).GetHicon()))

# Game directory
$file_label = New-Object System.Windows.Forms.Label
$file_label.Location = New-Object System.Drawing.Point(10,20)
$file_label.Size = New-Object System.Drawing.Size(100,30)
$file_label.Text = "Game directory: "
$form.Controls.Add($file_label)

$file_textdir = New-Object System.Windows.Forms.TextBox
$file_textdir.Location = New-Object System.Drawing.Point(110,20)
$file_textdir.Size = New-Object System.Drawing.Size(205,30)
$file_textdir.Text = Get-Content $env:USERPROFILE\.leaguedir -ErrorAction Ignore
$form.Controls.Add($file_textdir)

$file_button = New-Object System.Windows.Forms.Button
$file_button.Location = New-Object System.Drawing.Point(325,20)
$file_button.Size = New-Object System.Drawing.Size(66,25)
$file_button.Text = "Browse..."
$file_button.Add_Click({Get-Path})
$form.Controls.Add($file_button)

# Locale 
$locale_label = New-Object System.Windows.Forms.Label
$locale_label.Location = New-Object System.Drawing.Point(10,55)
$locale_label.Size = New-Object System.Drawing.Size(100,30)
$locale_label.Text = "Locale: "
$form.Controls.Add($locale_label)

$locale = "en_US", "vi_VN", "ja_JP", "ko_KR", "zh_CN"

$locale_dropdown = New-Object System.Windows.Forms.ComboBox
$locale_dropdown.Items.AddRange($locale)
$locale_dropdown.Location = New-Object System.Drawing.Point(110,55)
$locale_dropdown.Size = New-Object System.Drawing.Size(280,30)
$locale_dropdown.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$locale_dropdown.TabIndex = 0
$locale_dropdown.SelectedIndex = 0
$form.Controls.Add($locale_dropdown)

$submit = New-Object System.Windows.Forms.Button
$submit.Location = New-Object System.Drawing.Point(172,90)
$submit.Size = New-Object System.Drawing.Size(76,40)
$submit.Text = "Launch"
$submit.Add_Click({
    Deploy-Game
    $form.Close()
})
$form.AcceptButton = $submit
$form.Controls.Add($submit)

$form.ShowDialog() | Out-Null
$form.Dispose()