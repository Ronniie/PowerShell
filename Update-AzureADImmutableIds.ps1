# Import Azure AD module
Import-Module AzureAD

# Authenticate to Azure AD
Connect-AzureAD

# For each user in Azure AD
Get-AzureADUser -All $true | foreach {
    # Get current ImmutableId from Azure AD
    $azureAdImmutableId = $_.ImmutableId
    $onPremisesSamAccountName = $_.UserPrincipalName

    # Check if the ImmutableId exists in Azure AD and is not null or empty
    if ($azureAdImmutableId -ne $null -and $azureAdImmutableId -ne '') {
        # Get the corresponding user in on-premises AD
        $onPremisesUser = Get-ADUser -Filter {UserPrincipalName -eq $onPremisesSamAccountName} -Properties objectGUID

        # Check if the on-premises user and Azure AD user have matching ImmutableId and objectGUID
        if ($onPremisesUser -and $azureAdImmutableId -eq [System.Convert]::ToBase64String($onPremisesUser.objectGUID.ToByteArray())) {
            # If ImmutableId matches, display the current ImmutableId
            Write-Output ("User {0}: ImmutableId matches between Azure AD and on-premises AD | ImmutableId: {1}" -f $onPremisesSamAccountName, $azureAdImmutableId)
        } else {
            # Update the ImmutableId in Azure AD based on the on-premises objectGUID
            $newImmutableId = [System.Convert]::ToBase64String($onPremisesUser.objectGUID.ToByteArray())
            Set-AzureADUser -ObjectId $_.ObjectId -ImmutableId $newImmutableId

            # Display a message indicating that the ImmutableId has been updated
            Write-Output ("User {0}: ImmutableId has been updated in Azure AD | New ImmutableId: {1}" -f $onPremisesSamAccountName, $newImmutableId)
        }
    } else {
        # If ImmutableId is missing or mismatched, skip the user
        Write-Output ("User {0}: Skipped due to missing or mismatched ImmutableId" -f $onPremisesSamAccountName)
    }
}
