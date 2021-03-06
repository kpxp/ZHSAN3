extends Panel
class_name PersonBubble


func _on_Timer_timeout():
	queue_free()


func _on_PersonBubble_visibility_changed():
	if visible:
		$Timer.start()


func show_bubble(person, map_object, text: String):
	var viewing_rect = get_viewport_rect()
	var x = map_object.get_screen_position().x
	var y = map_object.get_screen_position().y - 88
	var bubble_rect = Rect2(x, y, rect_size.x, rect_size.y)
	if viewing_rect.intersects(bubble_rect):
		var bubble = duplicate()
		find_parent("*").add_child(bubble)
		
		bubble.find_node('Portrait').texture = person.get_portrait()
		bubble.rect_position = Vector2(x, y)
		bubble.find_node('Text').bbcode_text = text
		
		bubble.show()


