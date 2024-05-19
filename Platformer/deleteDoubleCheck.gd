extends Control

@export var deleteSave: Control

func _on_yes_button_pressed():
	#Delete saves
	deleteSave.delete_save()
	self.hide()



func _on_no_button_pressed():
	self.hide()

