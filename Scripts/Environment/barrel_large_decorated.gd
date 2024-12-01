extends Node3D


@onready var interaction_mode: Control = $InteractionMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_mode.hide()

func show_interaction_mode(show_button: bool = false) -> void:
	interaction_mode.show_message("By the saints, my belly cries for ale and red meat, yet alas, I'm bound by duty and must resist such glorious temptations", show_button)	
