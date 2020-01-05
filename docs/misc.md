# Miscs

### SendPlayerNotification

- Context: `Server & Client`
- Description : `Use to send player a notification toast`

#### Syntax

- Client : `SendPlayerNotification(text, type)`
- Server : `SendPlayerNotification(player, text, type)`

#### Parameters

- Player (Interger) : `Player id to which you want to send the notication`
- Text (String) : `Text to show in the notification`
- Type (String)(Optional) : `Which type of notification you want to send ("success" or "error")`

### PlayPlayerSound

- Context: `Server & Client`
- Description : `Use to player player a sound`

#### Syntax

- Client : `PlayPlayerSound(file, volume)`
- Server : `PlayPlayerSound(player, file, volume)`

#### Parameters

- Player (Interger) : `Player id to which you want to send the notication`
- File (String) : `Sound file to play in "client/files" folder`
- Volume (Number) : `Volume of the sound (between 0 - 2)`

### GetColorByHex

### GetHexByColor

### CreateVehicleOnLocation

### NumberInInterger

### NumberInPositive
