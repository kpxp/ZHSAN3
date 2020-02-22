extends HBoxContainer
class_name ArchitectureMenu

signal person_list_clicked

var showing_architecture
var _opening_list

func show_menu(arch, mouse_x, mouse_y):
	$MainMenu/Internal.visible = arch.get_belonged_faction().player_controlled
	
	if GameConfig.se_enabled:
		($OpenSound as AudioStreamPlayer).play()
	showing_architecture = arch
	
	margin_left = mouse_x
	margin_top = mouse_y
	
	show()

func _on_PersonList_pressed():
	if GameConfig.se_enabled:
		($SelectSound as AudioStreamPlayer).play()
	emit_signal("person_list_clicked", showing_architecture, PersonList.Action.LIST)
	_opening_list = true
	hide()


func _on_ArchitectureMenu_hide():
	if GameConfig.se_enabled and not _opening_list:
		($CloseSound as AudioStreamPlayer).play()
	$InternalMenu.hide()
	_opening_list = false


func _on_Internal_pressed():
	if GameConfig.se_enabled:
		($OpenSound as AudioStreamPlayer).play()
	$InternalMenu.show()


func _on_Agriculture_pressed():
	if GameConfig.se_enabled:
		($SelectSound as AudioStreamPlayer).play()
	emit_signal("person_list_clicked", showing_architecture, PersonList.Action.AGRICULTURE)
	_opening_list = true
	hide()


func _on_Commerce_pressed():
	if GameConfig.se_enabled:
		($SelectSound as AudioStreamPlayer).play()
	emit_signal("person_list_clicked", showing_architecture, PersonList.Action.COMMERCE)
	_opening_list = true
	hide()


func _on_Morale_pressed():
	if GameConfig.se_enabled:
		($SelectSound as AudioStreamPlayer).play()
	emit_signal("person_list_clicked", showing_architecture, PersonList.Action.MORALE)
	_opening_list = true
	hide()


func _on_Endurance_pressed():
	if GameConfig.se_enabled:
		($SelectSound as AudioStreamPlayer).play()
	emit_signal("person_list_clicked", showing_architecture, PersonList.Action.ENDURANCE)
	_opening_list = true
	hide()