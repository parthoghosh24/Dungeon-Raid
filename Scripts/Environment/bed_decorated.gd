extends Node3D


@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button = false):
	interaction_mode.show_message("By my blade, a fine rest would do me wonders, yet cursed be the work that keeps me from my well-earned slumber!", show_button)	
