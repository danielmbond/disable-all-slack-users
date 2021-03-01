Clear-Host
<#
https://api.slack.com/scim#delete-users-id
DELETE /Users/{id}

Sets a Slack user to deactivated. The value of the {id} should be the user's corresponding Slack ID, beginning with either U or W.

 DELETE /scim/v1/Users/42 HTTP/1.1
 Host: api.slack.com
 Accept: application/json
 Authorization: Bearer xoxp-4956040672-4956040692-6476208902-xxxxxx
#>

# Token scopes needed are admin and user:read
$TOKEN = ''
$APIuserList = "https://slack.com/api/users.list"
$APIuserDisable = "https://api.slack.com/scim/v1/Users"

$users = Invoke-RestMethod -Method Post -Uri $userListAPI -Body @{token="$TOKEN"}
$cursor = ($users.response_metadata).next_cursor
$members = $users.members

while($cursor) {
    Write-Host $cursorURL
    $cursor
    $users = Invoke-RestMethod -Method Post -Uri $userListAPI -Body @{token="$TOKEN"
        cursor="$cursor"
    }
    $members += ($users).members
    $cursor = ($users.response_metadata).next_cursor
    Start-Sleep 5
}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $TOKEN)

foreach ($i in $members) {
    if(!$i.deleted -and ($i.name -ne "daniel.bond" -and $i.name -ne "slackbot")){
        write-host $i.id $i.name
        $id = $i.id
        $URI = "$APIuserDisable/$id"
        Invoke-RestMethod -Method Delete -Uri $URI -Headers $headers
    }
}
