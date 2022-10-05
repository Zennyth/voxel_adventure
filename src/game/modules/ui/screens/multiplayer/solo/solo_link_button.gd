extends CustomLinkButton


func _on_button_pressed():
	Game.multiplayer_manager.set_connection(SoloConnectionStrategy.new(), null)
	super._on_button_pressed()
