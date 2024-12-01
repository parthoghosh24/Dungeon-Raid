extends Control

@onready var message: Label = $Panel/Message
@onready var message_timer: Timer = $MessageTimer
@onready var action_button: Button  = $Panel/ActionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_button.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func show_message(message_text: String, show_button: bool=false) -> void:
	if show_button:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		action_button.show()
	message.text = message_text
	self.show()
	get_tree().paused = true
	message_timer.start()
	
	
func _on_message_timer_timeout() -> void:
	get_tree().paused = false
	message.text = ''
	self.hide()


func _on_action_button_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	message.text = ''
	self.hide()
	if owner.name == "keyring_hanging2":
		Global.set_player_inventory(Global.PLAYER_INVENTORY_ITEMS.DOOR_KEY)
		owner.queue_free()
