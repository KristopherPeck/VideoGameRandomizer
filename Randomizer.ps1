# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#We are storing out files in Appdata to make it work for other users instead of inside the script. 
$installPath = "$env:USERPROFILE\Appdata\Roaming\Randomizer"

if (!(Test-Path $installPath)){
    New-Item -ItemType Directory -Force -Path $installPath
}
function Randomize {
    #selects the list based on what is in the checkbox then randomly picks one. Currently it's empty as we figure out the best way to pull out the entries
    #it shows the output in the label

    switch ($gameList.SelectedItem) {
      
    }

    $resultBox.text = $randomResult.ToString()
}

function NewList {
    #this function loads the form for creating New Lists. It includes a Textbox and two buttons. 
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
    #Adds the controls to the mainbox and displays it. This is a hold over from when I was thinking of closing out the main form
    #and then rebuilding it everytime. 
    $mainBox.controls.AddRange(@($gameList,$describeBox,$randomizeButton,$resultBox,$newListButton,$modifyListButton))
    [void]$mainBox.ShowDialog()
}

function CreateList {
    #This will create the new list file
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
    #This rebuidls the dropdown list when adding new ones so it doesn't just keep adding duplicates. 
    $Lists = $null
    $gameList.Items.Clear()
    $Lists = @(Get-ChildItem -Path $installPath) | ForEach-Object {$_.BaseName}
    $Lists | ForEach-Object {[void] $gameList.Items.Add($_)}
}

function ModifyList {
    #When this works it will allow us to modify existing lists. 
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
#@() | ForEach-Object {[void] $gameList.Items.Add($_)}
buildDropDownList

# Select the default value
$gameList.SelectedIndex       = 0
$gameList.location            = New-Object System.Drawing.Point(280,20)
$gameList.Font                = 'Microsoft Sans Serif,10'

#Builds the Randomizer Button
$randomizeButton              = New-Object System.Windows.Forms.Button
$randomizeButton.Text         = "Randomize"
$randomizeButton.Location     = New-Object System.Drawing.Point (300,70)
$randomizeButton.Add_Click({Randomize})

#Button for creating new game lists
$newListButton                 = New-Object System.Windows.Forms.Button
$newListButton.Text = "New List"
$newListButton.Location = New-Object System.Drawing.Point (100,70)
$newListButton.Add_Click({NewList})

#Button for modifying existing game lists
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
