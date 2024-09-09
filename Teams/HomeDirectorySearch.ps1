# Import the Active Directory module (make sure it is installed)
Import-Module ActiveDirectory

# Specify the Organizational Unit (OU) or domain to search (optional, leave blank for entire domain)
$searchBase = ""  # Example: "OU=Users,DC=example,DC=com"

# Get all users in the specified OU (or domain if searchBase is empty)
$users = Get-ADUser -Filter * -SearchBase $searchBase -Property DisplayName, HomeDirectory, UserPrincipalName

# Create a list to store the results
$usersList = @()

# Loop through each user and extract the relevant properties
foreach ($user in $users) {
    # Create a custom object with the user details
    $userDetails = [PSCustomObject]@{
        DisplayName        = $user.DisplayName
        UserPrincipalName  = $user.UserPrincipalName
        HomeDirectory      = $user.HomeDirectory
    }
    
    # Add the user details to the list
    $usersList += $userDetails
}

# Export the results to a CSV file
$usersList | Export-Csv -Path "C:\Temp\ADUsersInventory.csv" -NoTypeInformation

Write-Host "Export completed. CSV file saved as ADUsersInventory.csv"