extends Node3D

@onready var interaction_mode = $InteractionMode

signal player_collided

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func show_interaction_mode(show_button = false):
	interaction_mode.show_message("Ah, this key surely opens a door, though whether to fortune or folly, I know not!", show_button)
