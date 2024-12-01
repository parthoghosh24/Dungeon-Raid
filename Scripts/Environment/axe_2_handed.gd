extends Node3D

@onready var interaction_mode: Control = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_mode.hide()

func show_interaction_mode(show_button: bool=false) -> void:
	interaction_mode.show_message("Hmm, this axe doth look familiar. Could it perchance belong to the one I think it does?", show_button)	
