extends Node3D

@onready var interaction_mode = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()

func show_interaction_mode(show_button=false):
	interaction_mode.show_message("Good heavens! What devilry are these giant spiked traps doing here in the castle's very hall? Have I stumbled into some cursed game of illusions? Best tread lightly!", show_button)	
