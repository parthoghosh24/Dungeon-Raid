extends Node3D

@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button=false):
	interaction_mode.show_message("By the stars, these stools are but tiny! Were they crafted fpr children's games or jesters' tricks?", show_button)	
