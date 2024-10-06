extends Node3D

@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button=false):
	interaction_mode.show_message("Hark! Pray tell, who dost thou think wielded this gleaming sword and yon golden shield? Some noble knight, or perhaps a very wealthy fool?", show_button)	
