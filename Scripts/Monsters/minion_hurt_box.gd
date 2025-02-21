extends Area3D


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _on_area_entered(area: Area3D) -> void:
	if area == null or (area.name != "HaiyaHitBox" and area.name != "HaiyaStealthHitBox"):
		return
	
	if area.name == "HaiyaHitBox" and owner.has_method("damage"):
		get_viewport().get_camera_3d().shake_camera()
		Input.start_joy_vibration(0,0.5,0.5,2)
		owner.damage()
		
	if area.name == "HaiyaStealthHitBox" and owner.has_method("stealth_kill") and owner.stealth_prompt_visible():
		owner.stealth_kill()		
