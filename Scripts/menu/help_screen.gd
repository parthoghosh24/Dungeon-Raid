extends Control

@onready var back_audio = $SFX/Back
@onready var hover_audio = $SFX/Hover
@onready var select_audio = $SFX/Select
@onready var next_button = $Next
@onready var prev_button = $Prev
@onready var close_button = $Close
@onready var next_timer = $NextTimer
@onready var prev_timer = $PrevTimer
@onready var close_timer = $CloseTimer
@onready var image_texture: TextureRect = $Image
@onready var help_text = $HelpText

var help_images = [
	"res://Resources/images/help/stealth_kill.png",
	"res://Resources/images/help/env_interaction.png",
	"res://Resources/images/help/combo_attack.png",
	"res://Resources/images/help/chased.png"]

var help_texts = [
	"Haiya can stealth kill enemies . Enemies can only be stealth killed when \"Q\" prompt shows up on them.",
	"Press \"E\" to interact with environment. Interactions reward with points.",
	"Press \"Left click\" to attack. Haiya can perform 3 hit combos with quick clicks. Press \"Spacebar\" to jump. Jumps can be added in attacks strategically." ,
	"Although combat is an option, stealth is the better choice. Enemies will swarm and attack once Haiya is detected. Better outrun then and attack them stealthly. Hold \"Shift\" with \"W,A,S,D\" to sprint."
]	

var curr_idx = 0

func _ready():
	get_tree().paused = true
	get_image_texture(curr_idx)
	help_text.text = help_texts[curr_idx]
	
func get_image_texture(idx):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	image_texture.texture = ImageTexture.create_from_image(Image.load_from_file(help_images[idx]))
	image_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	return image_texture


func _on_next_pressed():
	if next_timer.is_stopped():
		next_timer.start()
		select_audio.play()
		next_button.disabled = true
		

func _on_next_mouse_entered():
	hover_audio.play()


func _on_prev_pressed():
	if prev_timer.is_stopped():
		prev_timer.start()
		select_audio.play()
		prev_button.disabled = true

func _on_close_pressed():
	if close_timer.is_stopped():
		close_timer.start()
		select_audio.play()
		close_button.disabled = true		


func _on_prev_mouse_entered():
	hover_audio.play()


func _on_close_mouse_entered():
	hover_audio.play()

func _on_next_timer_timeout():
	next_button.disabled = false
	if curr_idx == (help_images.size() - 1):
		curr_idx = 0
	else:
		curr_idx += 1
	get_image_texture(curr_idx)	
	help_text.text = help_texts[curr_idx]


func _on_prev_timer_timeout():
	prev_button.disabled = false
	if curr_idx == 0:
		curr_idx = help_images.size() - 1
	else:
		curr_idx -= 1
	get_image_texture(curr_idx)
	help_text.text = help_texts[curr_idx]


func _on_close_timer_timeout():
	close_button.disabled = false
	get_tree().paused = false
	queue_free()
