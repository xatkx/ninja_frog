extends Damage


func _on_area_entered(area):
	if area as Healt:
		area.take_damage(2)
