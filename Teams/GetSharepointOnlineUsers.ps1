# Connect to Microsoft 365
Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All"

# Define the group IDs
$group1Id = "GroupID_1"  # Replace with your first group ID
$group2Id = "GroupID_2"  # Replace with your second group ID

# Function to get members from a group
function Get-GroupMembers($groupId) {
    Get-MgGroupMember -GroupId $groupId -All
}

# Get members from both groups
$group1Members = Get-GroupMembers -groupId $group1Id
$group2Members = Get-GroupMembers -groupId $group2Id

# Combine both groups and remove duplicates
$allMembers = $group1Members + $group2Members | Sort-Object UserPrincipalName -Unique

# Initialize the list to store user details
$usersList = @()

# Loop through each member
foreach ($member in $allMembers) {
    $userPrincipalName = $member.UserPrincipalName
    $user = Get-MgUser -UserId $userPrincipalName

    # Get the OneDrive URL for the user
    $oneDriveUrl = Get-SPOSite -Filter "Url -like '*$userPrincipalName-my.sharepoint.com*'" -ErrorAction SilentlyContinue
    
    if ($oneDriveUrl) {
        # Create a custom object with the user details
        $userDetails = [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $userPrincipalName
            OneDriveURL = $oneDriveUrl.Url
        }
        
        # Add the details to the list
        $usersList += $userDetails
    }
}

# Export the results to a CSV
$usersList | Export-Csv -Path "OneDriveUserInventory.csv" -NoTypeInformation

Write-Host "Export completed. CSV file saved as OneDriveUserInventory.csv"