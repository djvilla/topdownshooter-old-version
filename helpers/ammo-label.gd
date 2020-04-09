extends Label


func setup(weapon):
	weapon.connect("ammo_amount_changed", self, "_on_Character_ammo_changed")


func _on_Character_ammo_changed(ammo_amount, max_ammo):
	text = str(ammo_amount) + "/" + str(max_ammo)
