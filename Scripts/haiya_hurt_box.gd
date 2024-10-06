extends Area3D


func _init():
	collision_layer = 0
	collision_mask = 3


func _on_area_entered(area):
	if area == null or (area.name != "RightArmHitBox" and area.name != "RightLegHitBox"):
		return
	
	if owner.has_method("damage"):
		owner.damage()
