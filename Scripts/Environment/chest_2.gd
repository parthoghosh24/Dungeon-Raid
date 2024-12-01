extends Node3D

@onready var interaction_mode: Control = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_mode.hide()

func show_interaction_mode(show_button: bool=false) -> void:
	interaction_mode.show_message("By the heavens, what a colossal chest this is! I wonder what treasures...or curses... lurk within?", show_button)	
