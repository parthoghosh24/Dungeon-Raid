extends Node3D

@onready var small_health: Node3D = $SmallHealth
@onready var medium_health: Node3D = $MediumHealth
@onready var large_health: Node3D = $LargeHealth
var vial_value: int = 0
signal generate_vial(vial_name: String)

func _ready() -> void:
	small_health.hide()
	medium_health.hide()
	large_health.hide()


func activate_vial(vial_name: String) -> void:
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
	


func _on_generate_vial(vial_name: String) -> void:
	activate_vial(vial_name)

func _on_small_health_interaction_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.heal_up(self, vial_value)


func _on_medium_health_interaction_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.heal_up(self, vial_value)


func _on_large_health_interaction_box_body_entered(body: Node3D):
	if body.is_in_group("player"):
		body.heal_up(self, vial_value)
