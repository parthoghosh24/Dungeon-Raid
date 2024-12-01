extends Node3D

@onready var interaction_mode: Control = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_mode.hide()

func show_interaction_mode(show_button: bool=false) -> void:
	interaction_mode.show_message("I require a key to unfasten yon door and ascend henceforth!", show_button)	
