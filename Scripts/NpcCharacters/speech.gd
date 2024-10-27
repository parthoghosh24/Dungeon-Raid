extends Control

@onready var text: Label = $Panel/VBoxContainer/text
@onready var text_animation: AnimationPlayer = $TextAnimation

# Called when the node enters the scene tree for the first time.
	

func set_text(content):
	text.text = content
	text_animation.queue("Typewriter")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
