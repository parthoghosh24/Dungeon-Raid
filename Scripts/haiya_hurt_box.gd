extends Area3D


func _init():
	collision_layer = 0
	collision_mask = 3


func _on_area_entered(area):
	if area == null or (area.name != "RightArmHitBox" and area.name != "RightLegHitBox" and area.name != "RightHandHitbox"):
		return
	
	if owner.has_method("damage"):
		#Skelly Rogue does 3 damage per hit
		if area.name == "RightHandHitbox":
			owner.damage(3)
		#Skelly Minion does 2 damage per hit
		if area.name == "RightArmHitBox" or area.name == "RightLegHitBox":
			owner.damage(2)	
