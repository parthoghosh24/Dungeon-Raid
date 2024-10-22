extends Node3D

@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button=false):
	interaction_mode.show_message("What, pray tell, is this great glowing tree, surrounded by a veritable hoard of gold, doing smack in the middle of the chamber? Some wizard's idea of interior decor?", show_button)	
