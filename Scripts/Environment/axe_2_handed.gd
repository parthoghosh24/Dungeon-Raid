extends Node3D

@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button=false):
	interaction_mode.show_message("Hmm, this axe doth look familiar. Could it perchance belong to the one I think it does?", show_button)	
