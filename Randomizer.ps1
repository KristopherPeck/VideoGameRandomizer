# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$installPath = "$env:USERPROFILE\Appdata\Roaming\Randomizer"

if (!(Test-Path $installPath)){
    New-Item -ItemType Directory -Force -Path $installPath
}
function Randomize {
    #selects the list based on what is in the checkbox then randomly picks one
    #it shows the output in the label

    switch ($gameList.SelectedItem) {
      
    }

    $resultBox.text = $randomResult.ToString()
}

function NewList {
    #$mainBox.Visible = $false
    getcontent
    $newListBox = New-Object System.Windows.Forms.Form
    $newListBox.ClientSize         = '200,200'
    $newListBox.text               = "Create a New List"
    $newListBox.BackColor          = "#ffffff"

    $newListName = New-Object System.Windows.Forms.TextBox
    $newListName.Location = New-Object System.Drawing.Point(50,40)

    $newListButton = New-Object System.Windows.Forms.Button
    $newListButton.Location = New-Object System.Drawing.Point(60,100)
    $newListButton.Text = "Create List"
    $newListButton.Add_Click({CreateList})

    $closeNewListButton = New-Object System.Windows.Forms.Button
    $closeNewListButton.Location = New-Object System.Drawing.Point (60,150)
    $closeNewListButton.Text = "Exit"
    $closeNewListButton.Add_Click({$newListBox.Close()})

    $newListBox.controls.AddRange(@($newListName, $newListButton, $closeNewListButton))
    [void]$newListBox.ShowDialog()
}

function LoadMainForm {
    $mainBox.controls.AddRange(@($gameList,$describeBox,$randomizeButton,$resultBox,$newListButton,$modifyListButton))
    [void]$mainBox.ShowDialog()
}

function CreateList {
    Write-Host $newListName.Text.Trim()
    if ($newListName.Text.Trim() -ne '') {
        $fileName = $newListName.Text.Trim()
        $newListPath = "$installPath\$fileName"
        if (!(Test-Path "$newListPath.txt")){
            New-Item -ItemType File -Force -Path "$newListPath.txt"
        }
        buildDropDownList
        $newListBox.Close()
    } else {
        $wshell = New-Object -ComObject Wscript.Shell
        $Alert = $wshell.Popup("Please Fill Out the Form")
        $Alert
    }
}

function buildDropDownList {
    $Lists = $null
    $gameList.Items.Clear()
    $Lists = @(Get-ChildItem -Path $installPath) | ForEach-Object {$_.BaseName}
    $Lists | ForEach-Object {[void] $gameList.Items.Add($_)}
}

function ModifyList {
    $modifyListBox = New-Object System.Windows.Forms.Form
    $modifyListBox.clientSize = "500,500"
    $modifyListBox.Text = "Update Game List"
    $modifyListBox.BackColor = "#ffffff"

    $modifyListItems = New-Object System.Windows.Forms.ListBox
    $modifyListItems.Location = New-Object System.Drawing.Point(250,250)

    $currentItem = $gameList.SelectedItem
    $fullPath = "$installPath\$currentItem.txt"
    Get-Content -Path $fullPath

    $modifyListBox.controls.AddRange(@($modifyListItems))
    $modifyListBox.ShowDialog()

    
}
# Create a new form
$mainBox                    = New-Object system.Windows.Forms.Form

# Define the size, title and background color
$mainBox.ClientSize         = '500,300'
$mainBox.text               = "Game Randomizer"
$mainBox.BackColor          = "#ffffff"

$describeBox                  = New-Object System.Windows.Forms.Label
$describeBox.text             = "Select the List you want to Randomized:"
$describeBox.Location         = New-Object System.Drawing.Point (20,25)
$describeBox.AutoSize         = $true

$gameList                     = New-Object system.Windows.Forms.ComboBox
$gameList.text                = ""
$gameList.width               = 170
$gameList.autosize            = $true

# Add the items in the dropdown list
#$Lists = @(Get-ChildItem -Path $installPath) | ForEach-Object {$_.BaseName}
#$Lists | ForEach-Object {[void] $gameList.Items.Add($_)}
#@('Personal','Dylan','Ryan','CMU Friends','KZOO Friends') | ForEach-Object {[void] $gameList.Items.Add($_)}
buildDropDownList

# Select the default value
$gameList.SelectedIndex       = 0
$gameList.location            = New-Object System.Drawing.Point(280,20)
$gameList.Font                = 'Microsoft Sans Serif,10'

$randomizeButton              = New-Object System.Windows.Forms.Button
$randomizeButton.Text         = "Randomize"
$randomizeButton.Location     = New-Object System.Drawing.Point (300,70)
$randomizeButton.Add_Click({Randomize})

$newListButton                 = New-Object System.Windows.Forms.Button
$newListButton.Text = "New List"
$newListButton.Location = New-Object System.Drawing.Point (100,70)
$newListButton.Add_Click({NewList})

$modifyListButton                 = New-Object System.Windows.Forms.Button
$modifyListButton.Text = "Modify List"
$modifyListButton.Location = New-Object System.Drawing.Point (200,70)
$modifyListButton.Add_Click({ModifyList})

#We are going to show the results here later
$resultBox                  = New-Object System.Windows.Forms.Label
$resultBox.text             = "Your Result Will Show Up Here"
$resultBox.Location         = New-Object System.Drawing.Point (160,150)
$resultBox.AutoSize         = $true

# Display the form
LoadMainForm
