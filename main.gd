extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and \
	  $UserInterface/GameStartBackground.visible:
		$UserInterface/GameStartBackground.hide()

func _on_start_button_pressed() -> void:
	$UserInterface/GameStartBackground.hide()
