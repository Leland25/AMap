extends OptionButton

func _on_item_selected(index: int) -> void:
	match index:
		0: get_tree().change_scene_to_file("res://scenes/LoginPage.tscn")
