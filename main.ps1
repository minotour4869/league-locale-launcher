Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles();

function Deploy-Game()
{
    $arg = "--locale=" + $locale_dropdown.SelectedItem
    & $Global:LeagueFile $arg
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

$form = New-Object System.Windows.Forms.Form
$form.Text = 'League of Legends Locale Launcher'
$form.Size = New-Object System.Drawing.Size(420,180)
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.StartPosition = 'CenterScreen'

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

$form.Add_

$result = $form.ShowDialog()
$form.Dispose()
# Write-Host $result