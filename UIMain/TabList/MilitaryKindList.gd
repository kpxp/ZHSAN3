extends TabList
class_name MilitaryKindList

enum Action { LIST, PRODUCE_EQUIPMENT }

signal military_kind_selected

func _ready():
	$Tabs.set_tab_title(0, tr('BASIC'))
	$Tabs.set_tab_title(1, tr('MOVEMENT_DETAILS'))
	$Tabs.set_tab_title(2, tr('TERRAIN_STRENGTH'))
	$Tabs.remove_child($Tabs/Tab4)

func show_data(arch_list: Array):
	match current_action:
		Action.LIST: 
			$Title.text = tr('PERSON_LIST')
			_max_selection = 0
		Action.PRODUCE_EQUIPMENT: 
			$Title.text = tr('PRODUCE_EQUIPMENT')
			_max_selection = 1
	$SelectionButtons.visible = _max_selection != 0
	_populate_basic_data(arch_list, current_action)
	_populate_movement_details_data(arch_list, current_action)
	_populate_terrain_strength_data(arch_list, current_action)
	show()

func _populate_basic_data(mk_list: Array, action):
	var item_list = $Tabs/Tab1/Grid as GridContainer
	Util.delete_all_children(item_list)
	if action != Action.LIST:
		item_list.columns = 9
		item_list.add_child(_title(''))
	else:
		item_list.columns = 8
	item_list.add_child(_title(tr('NAME')))
	item_list.add_child(_title(tr('COST')))
	item_list.add_child(_title(tr('OFFENSE')))
	item_list.add_child(_title(tr('DEFENSE')))
	item_list.add_child(_title(tr('RANGE')))
	item_list.add_child(_title(tr('SPEED')))
	item_list.add_child(_title(tr('INITIATIVE')))
	item_list.add_child(_title(tr('MAX_QUANTITY_MULITPLIER')))
	for mk in mk_list:
		if action != Action.LIST:
			item_list.add_child(_checkbox(mk.id))
		item_list.add_child(_label(mk.equipment_cost))
		item_list.add_child(_label(mk.offense))
		item_list.add_child(_label(mk.defense))
		item_list.add_child(_label(mk.range_min + " - " + mk.range_max))
		item_list.add_child(_label(mk.speed))
		item_list.add_child(_label(mk.initiative))
		item_list.add_child(_label("x" + mk.max_quantity_multiplier))

func _populate_movement_details_data(mk_list: Array, action):
	if mk_list.size() <= 0: 
		return
	var item_list = $Tabs/Tab1/Grid as GridContainer
	Util.delete_all_children(item_list)
	
	var terrains = mk_list[0].get_movement_kind_with_name()
	if action != Action.LIST:
		item_list.columns = terrains.size() + 1
		item_list.add_child(_title(''))
	else:
		item_list.columns = terrains.size()
		
	for t in terrains:
		item_list.add_child(_title(t))
	for mk in mk_list:
		var terrain = mk.get_movement_kind_with_name()
		if action != Action.LIST:
			item_list.add_child(_checkbox(mk.id))
		for t in terrain:
			item_list.add_child(_label(terrain[t]))
	
func _populate_terrain_strength_data(mk_list: Array, action):
	if mk_list.size() <= 0: 
		return
	var item_list = $Tabs/Tab1/Grid as GridContainer
	Util.delete_all_children(item_list)
	
	var terrains = mk_list[0].get_terrain_strength_with_name()
	if action != Action.LIST:
		item_list.columns = terrains.size() + 1
		item_list.add_child(_title(''))
	else:
		item_list.columns = terrains.size()
		
	for t in terrains:
		item_list.add_child(_title(t))
	for mk in mk_list:
		var terrain = mk.get_movement_kind_with_name()
		if action != Action.LIST:
			item_list.add_child(_checkbox(mk.id))
		for t in terrain:
			item_list.add_child(_label(terrain[t]))
