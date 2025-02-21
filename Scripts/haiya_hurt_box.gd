extends Area3D


func _init() -> void:
	collision_layer = 0
	collision_mask = 3


func _on_area_entered(area: Area3D) -> void:
	if area.name == "SpikeArea":
		owner.dead()

	if area == null or (area.name != "RightArmHitBox" and area.name != "RightLegHitBox" and area.name != "RightHandHitbox" and area.name!= "WarriorLeftHandHitbox" and area.name!= "WarriorRightHandHitbox" and !area.name.contains("Fireball")):
		return
	
	if owner.has_method("damage"):
		#Boss fireball does 5 damage per hit
		if area.name.contains("Fireball") == true:
			area.queue_free()
			owner.damage(5)
			
			
		#Skelly Warrior does 25 damage per hit
		if area.name == "WarriorLeftHandHitbox" or area.name == "WarriorRightHandHitbox":
			owner.damage(25)
		#Skelly Rogue does 5 damage per hit
		if area.name == "RightHandHitbox":
			owner.damage(5)
		#Skelly Minion does 2 damage per hit
		if area.name == "RightArmHitBox" or area.name == "RightLegHitBox":
			owner.damage(2)	
