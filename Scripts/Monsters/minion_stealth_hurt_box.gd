extends Area3D


func _init() -> void:
	collision_layer = 0
	collision_mask = 4


func _on_area_entered(area: Area3D) -> void:
	print(area)
	if area == null or area.name != "HaiyaStealthHitBox":
		return
	
	if owner.has_method("stealth_kill"):
		owner.stealth_kill()	
