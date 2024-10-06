extends Node3D

@onready var interaction_mode = $InteractionMode

signal player_collided

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_mode.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_interaction_mode(show_button = false):
	interaction_mode.show_message("By the gods! 'Tis a vast hoard of gold, yet I must needs forsake it, for the vailant knight doth require my aid.", show_button)
