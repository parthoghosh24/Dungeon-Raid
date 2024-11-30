extends Node3D

@onready var small_health = $SmallHealth
@onready var medium_health = $MediumHealth
@onready var large_health = $LargeHealth
var vial_value = 0
signal generate_vial(vial_name: String)

func _ready():
	small_health.hide()
	medium_health.hide()
	large_health.hide()


func activate_vial(vial_name):
	match vial_name:
		"small_health":
			vial_value = 10
			small_health.show()
			medium_health.hide()
			large_health.hide()
		"medium_health":
			vial_value = 50
			small_health.hide()
			medium_health.show()
			large_health.hide()
		"large_health":
			vial_value = 100
			small_health.hide()
			medium_health.hide()
			large_health.show()
	


func _on_generate_vial(vial_name):
	activate_vial(vial_name)

func _on_small_health_interaction_box_body_entered(body):
	if body.is_in_group("player"):
		body.heal_up(self, vial_value)
