extends Node3D


@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button = false):
	interaction_mode.show_message("Prithee, what manner of drunken tavern brawl hath brought forth such chaos? Methinks tankards flew and fools did flourish!", show_button)	
