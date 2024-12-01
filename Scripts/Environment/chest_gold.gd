extends Node3D

@onready var interaction_mode: Control = $InteractionMode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_mode.hide()

func show_interaction_mode(show_button: bool = false) -> void:
	interaction_mode.show_message("By the gods! 'Tis a vast hoard of gold, yet I must needs forsake it, for the vailant knight doth require my aid.", show_button)
