Add-Type -AssemblyName PresentationFramework, System.Windows.Forms

# Function to create BSOD window on a screen
function Show-BSOD {
    param($screen)

    $window = New-Object System.Windows.Window
    $window.WindowStyle = 'None'
    $window.ResizeMode = 'NoResize'
    $window.WindowStartupLocation = 'Manual'
    $window.Left = $screen.Bounds.Left
    $window.Top = $screen.Bounds.Top
    $window.Width = $screen.Bounds.Width
    $window.Height = $screen.Bounds.Height
    $window.Background = 'Blue'
    $window.Topmost = $true
    $window.ShowInTaskbar = $false

    $grid = New-Object System.Windows.Controls.Grid

    # Sad face
    $sadFace = New-Object System.Windows.Controls.TextBlock
    $sadFace.Text = ":("
    $sadFace.Foreground = 'White'
    $sadFace.FontSize = $screen.Bounds.Width / 10
    $sadFace.Margin = '50,50,0,0'
    $sadFace.HorizontalAlignment = 'Left'
    $sadFace.VerticalAlignment = 'Top'

    # Message text
    $message = New-Object System.Windows.Controls.TextBlock
    $message.Text = @"
Your PC ran into a problem and needs to restart.
We're just collecting some error info, and then we'll restart for you.

For more information about this issue and possible fixes, visit
https://www.windows.com/stopcode

If you call a support person, give them this info:
Stop code: FAKE_CRASH_SIMULATION
"@
    $message.Foreground = 'White'
    $message.FontSize = $screen.Bounds.Width / 40
    $message.Margin = '50,' + ($screen.Bounds.Height / 4) + ',50,50'
    $message.TextWrapping = 'Wrap'

    $grid.Children.Add($sadFace)
    $grid.Children.Add($message)

    $window.Content = $grid

    return $window
}

# Create a window for each screen
$windows = @()
[System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
    $windows += Show-BSOD $_
}

# Show all windows
foreach ($win in $windows) {
    $null = $win.Show()
}

# Run a dispatcher to keep them alive
[System.Windows.Threading.Dispatcher]::Run()
