extends Network
class_name SteamNetwork

###
# OVERRIDE
###
func _ready() -> void:
	Steam.connect("lobby_created", _on_lobby_created)
	Steam.connect("lobby_match_list", _on_lobby_match_list)
	Steam.connect("lobby_joined", _on_lobby_joined)
	Steam.connect("lobby_chat_update", _on_lobby_chat_update)
	Steam.connect("lobby_message", _on_lobby_message)
	Steam.connect("lobby_data_update", _on_lobby_data_update)
	Steam.connect("lobby_invite", _on_lobby_invite)
	Steam.connect("join_requested", _on_lobby_loin_Requested)
	Steam.connect("persona_state_change", _on_persona_change)
	Steam.connect("p2p_session_request", _on_p2p_session_request)
	Steam.connect("p2p_session_connect_fail", _on_p2p_session_connect_fail)

	# Check for command line arguments
	_check_Command_Line()

func _process(_delta) -> void:
  Steam.run_callbacks()

  # If the player is connected, read packets
  if LOBBY_ID > 0:
    _read_all_p2p_packet()

func create_client(args: Dictionary):
	pass

func create_server(args: Dictionary):
	pass

func send(destination: int, channel: String, data):
  var type: int = Steam.P2P_SEND_RELIABLE if channel != "update_entity_unstable_state" else Steam.P2P_SEND_UNRELIABLE
	send_p2p_packet(destination, {
    "channel": channel,
    "data": data
  }, type)

func send_update(destination: int, state: Dictionary):
	send(destination, "receive_update", state)

func get_sender_id() -> int:
	return 0

func get_id() -> int:
	return STEAM_ID


###
# BUILT-IN
# Global
###
# _global_requests.emit(data)


###
# BUILT-IN
# State
###
# _update_entity_unstable_state.emit(data)

# _update_entity_stable_state.emit(data)

# _update_world_stable_state.emit(data)

###
# BUILT-IN
# Clock synchro
###
# _clock_synchronization.emit(data)



###
# BUILT-IN
# HIGH-LEVEL
###

###
# BUILT-IN
###
const PACKET_READ_LIMIT: int = 32
var STEAM_ID: int = 0
var SERVER_ID: int = 0
var STEAM_USERNAME: String = ""
var LOBBY_ID: int = 0
var LOBBY_MEMBERS: Array = []
var DATA
var LOBBY_VOTE_KICK: bool = false
var LOBBY_MAX_MEMBERS: int = 10
enum LOBBY_AVAILABILITY {PRIVATE, FRIENDS, PUBLIC, INVISIBLE}

func _check_Command_Line() -> void:
	var ARGUMENTS: Array = OS.get_cmdline_args()
  
	# There are arguments to process
	if ARGUMENTS.size() <= 0:
    return
  
  # A Steam connection argument exists
  if ARGUMENT[0] == "+connect_lobby":
  
    # Lobby invite exists so try to connect to it
    if int(ARGUMENTS[1]) <= 0:
      return
    

    # At this point, you'll probably want to change scenes
    # Something like a loading into lobby screen
    print("CMD Line Lobby ID: "+str(ARGUMENTS[1]))
    _join_lobby(int(ARGUMENTS[1]))

###
# BUILT-IN
# Lobby
###

func create_lobby() -> void:
	# Make sure a lobby is not already set
	if LOBBY_ID == 0:
		Steam.createLobby(LOBBY_AVAILABILITY.PUBLIC, LOBBY_MAX_MEMBERS)

func _on_lobby_created(connect: int, lobby_id: int) -> void:
  if connect != 1:
    return

  LOBBY_ID = lobby_id
  print("Created a lobby: "+str(LOBBY_ID))

  Steam.setLobbyJoinable(LOBBY_ID, true)

  # Set some lobby data
  Steam.setLobbyData(lobbyID, "name", "Gramps' Lobby")
  Steam.setLobbyData(lobbyID, "mode", "GodotSteam test")

  # Allow P2P connections to fallback to being relayed through Steam if needed
  var RELAY: bool = Steam.allowP2PPacketRelay(true)
  print("Allowing Steam to be relay backup: "+str(RELAY))

func _on_open_lobby_list_pressed() -> void:
  # Set distance to worldwide
  Steam.addRequestLobbyListDistanceFilter(3)

  print("Requesting a lobby list")
  Steam.requestLobbyList()

func _on_lobby_match_list(lobbies: Array) -> void:
  for LOBBY in lobbies:
    # Pull lobby data from Steam, these are specific to our example
    var LOBBY_NAME: String = Steam.getLobbyData(LOBBY, "name")
    var LOBBY_MODE: String = Steam.getLobbyData(LOBBY, "mode")

    # Get the current number of members
    var LOBBY_NUM_MEMBERS: int = Steam.getNumLobbyMembers(LOBBY)

    # Create a button for the lobby
    var LOBBY_BUTTON: Button = Button.new()
    LOBBY_BUTTON.set_text("Lobby ", LOBBY, ": ", LOBBY_NAME, " [", LOBBY_MODE, "] - ", LOBBY_NUM_MEMBERS, " Player(s)")
    LOBBY_BUTTON.set_size(Vector2(800, 50))
    LOBBY_BUTTON.set_name("lobby_"+str(LOBBY))
    LOBBY_BUTTON.connect("pressed", _join_lobby, [LOBBY])

    # Add the new lobby to the list
    # $"Lobby Panel/Panel/Scroll/VBox".add_child(LOBBY_BUTTON)

func _join_lobby(lobby_id: int) -> void:
  print("Attempting to join lobby "+str(lobby_id)+"...")

  # Clear any previous lobby members lists, if you were in a previous lobby
  LOBBY_MEMBERS.clear()

  # Make the lobby join request to Steam
  Steam.joinLobby(lobby_id)

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
  # If joining was successful
  if response == 1:
    # Set this lobby ID as your lobby ID
    LOBBY_ID = lobby_id

    SERVER_ID = Steam.getLobbyOwner(LOBBY_ID)

    # Get the lobby members
    _get_lobby_members()

    # Make the initial handshake
    _make_p2p_handshake()

    _connection_succeeded.emit()

  # Else it failed for some reason
  else:
    # Get the failure reason
    var FAIL_REASON: String
  
    match response:
      2:	FAIL_REASON = "This lobby no longer exists."
      3:	FAIL_REASON = "You don't have permission to join this lobby."
      4:	FAIL_REASON = "The lobby is now full."
      5:	FAIL_REASON = "Uh... something unexpected happened!"
      6:	FAIL_REASON = "You are banned from this lobby."
      7:	FAIL_REASON = "You cannot join due to having a limited account."
      8:	FAIL_REASON = "This lobby is locked or disabled."
      9:	FAIL_REASON = "This lobby is community locked."
      10:	FAIL_REASON = "A user in the lobby has blocked you from joining."
      11:	FAIL_REASON = "A user you have blocked is in the lobby."
    
    print(FAIL_REASON)

    _connection_failed.emit()

    #Reopen the lobby list
    _on_open_lobby_list_pressed()

func _on_lobby_join_requested(lobby_id: int, owner_id: int) -> void:
  # Get the lobby owner's name
  var OWNER_NAME: String = Steam.getFriendPersonaName(friend_id)

  print("Joining "+str(OWNER_NAME)+"'s lobby...")

  # Attempt to join the lobby
  _join_lobby(lobby_id)

func _get_lobby_members() -> void:
  # Clear your previous lobby list
  LOBBY_MEMBERS.clear()

  # Get the number of members from this lobby from Steam
  var MEMBERS: int = Steam.getNumLobbyMembers(LOBBY_ID)

  # Get the data of these players from Steam
  for MEMBER in range(0, MEMBERS):
    # Get the member's Steam ID
    var MEMBER_STEAM_ID: int = Steam.getLobbyMemberByIndex(LOBBY_ID, MEMBER)

    # Get the member's Steam name
    var MEMBER_STEAM_NAME: String = Steam.getFriendPersonaName(MEMBER_STEAM_ID)

    # Add them to the list
    LOBBY_MEMBERS.append({"steam_id":steam_id, "steam_name":steam_name})

func _on_persona_change(steam_id: int, _flag: int) -> void:
	print("[STEAM] A user ("+str(steam_id)+") had information change, update the lobby list")
	_get_lobby_members()

func _make_p2p_handshake() -> void:
  print("Sending P2P handshake to the lobby")
  _send_p2p_packet(0, {"message":"handshake", "from": STEAM_ID})

func _on_lobby_chat_update(lobbyID: int, changedID: int, makingChangeID: int, chatState: int) -> void:
  # Get the user who has made the lobby change
  var CHANGER: String = Steam.getFriendPersonaName(changedID)

  # If a player has joined the lobby
  if chatState == 1:
    print(str(CHANGER)+" has joined the lobby.")
    _peer_connected.emit(changedID)

  # Else if a player has left the lobby
  elif chatState == 2:
    print(str(CHANGER)+" has left the lobby.")
    _peer_disconnected.emit(changedID)

  # Else if a player has been kicked
  elif chatState == 8:
    print(str(CHANGER)+" has been kicked from the lobby.")

  # Else if a player has been banned
  elif chatState == 16:
    print(str(CHANGER)+" has been banned from the lobby.")

  # Else there was some unknown change
  else:
    print(str(CHANGER)+" did... something.")

  # Update the lobby now that a change has occurred
  _get_lobby_members()

func _leave_lobby() -> void:
  # If in a lobby, leave it
  if LOBBY_ID != 0:
    # Send leave request to Steam
    Steam.leaveLobby(LOBBY_ID)

    # Wipe the Steam lobby ID then display the default lobby ID and player list title
    LOBBY_ID = 0

    # Close session with all users
    for MEMBERS in LOBBY_MEMBERS:
      # Make sure this isn't your Steam ID
      if MEMBERS['steam_id'] != STEAM_ID:

      # Close the P2P session
      Steam.closeP2PSessionWithUser(MEMBERS['steam_id'])

    # Clear the local lobby list
    LOBBY_MEMBERS.clear()

###
# BUILT-IN
# P2P
###

func _on_p2p_session_request(remote_id: int) -> void:
	# Get the requester's name
	var REQUESTER: String = Steam.getFriendPersonaName(remote_id)

	# Accept the P2P session; can apply logic to deny this request if needed
	Steam.acceptP2PSessionWithUser(remote_id)

	# Make the initial handshake
	_make_p2p_handshake()

func _read_all_p2p_packet(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return
	if Steam.getAvailableP2PPacketSize(0) > 0:
		_read_p2p_packet()
		_read_all_p2p_packet(read_count + 1)

func _read_p2p_packet() -> void:
  var PACKET_SIZE: int = Steam.getAvailableP2PPacketSize(0)

  if PACKET_SIZE <= 0:
    return
  
  var PACKET: Dictionary = Steam.readP2PPacket(PACKET_SIZE, 0)

  if PACKET.empty() or PACKET == null:
    print("WARNING: read an empty packet with non-zero size!")
    return

  # Get the remote user's ID
  var PACKET_SENDER: int = PACKET['steam_id_remote']

  # Make the packet data readable
  var PACKET_CODE: PoolByteArray = PACKET['data']
  var CONTENT: Dictionary = bytes2var(PACKET_CODE)

  if not "channel" in CONTENT:
    return
  
  var data = CONTENT["data"]
  var signal = get("_" + CONTENT["channel"]).emit(data)

func _send_p2p_packet(target: int, data: Dictionary, type: int = Steam.P2P_SEND_RELIABLE) -> void:
  var CHANNEL: int = 0

  # Create a data array to send the data through
  var DATA: PoolByteArray
  DATA.append_array(var2bytes(packet_data))

  # If sending a packet to everyone
  if target == Channel.ALL:
    # If there is more than one user, send packets
    if LOBBY_MEMBERS.size() <= 1:
      return
    
    # Loop through all members that aren't you
    for MEMBER in LOBBY_MEMBERS:
      if MEMBER['steam_id'] == STEAM_ID:
        continue
      
      Steam.sendP2PPacket(MEMBER['steam_id'], DATA, type, CHANNEL)
  # Else send it to someone specific
  elif target == CHANNEL.SERVER:
    Steam.sendP2PPacket(SERVER_ID, DATA, type, CHANNEL)
  else:
    Steam.sendP2PPacket(target, DATA, type, CHANNEL)

func _on_p2p_session_connect_fail(steamID: int, session_error: int) -> void:
  # If no error was given
  if session_error == 0:
    print("WARNING: Session failure with "+str(steamID)+" [no error given].")

  # Else if target user was not running the same game
  elif session_error == 1:
    print("WARNING: Session failure with "+str(steamID)+" [target user not running the same game].")

  # Else if local user doesn't own app / game
  elif session_error == 2:
    print("WARNING: Session failure with "+str(steamID)+" [local user doesn't own app / game].")

  # Else if target user isn't connected to Steam
  elif session_error == 3:
    print("WARNING: Session failure with "+str(steamID)+" [target user isn't connected to Steam].")

  # Else if connection timed out
  elif session_error == 4:
    print("WARNING: Session failure with "+str(steamID)+" [connection timed out].")

  # Else if unused
  elif session_error == 5:
    print("WARNING: Session failure with "+str(steamID)+" [unused].")

  # Else no known error
  else:
    print("WARNING: Session failure with "+str(steamID)+" [unknown error "+str(session_error)+"].")