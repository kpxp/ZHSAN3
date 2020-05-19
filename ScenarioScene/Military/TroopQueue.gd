extends Node
class_name TroopQueue

var queue: Array
var troops: Array

func _init(in_queue: Array):
	troops = in_queue.duplicate()
	queue = in_queue.duplicate()
	
func execute():
	queue.shuffle()
	queue.sort_custom(Troop, "cmp_initiative")
	for troop in queue:
		troop.prepare_orders()
	while queue.size() > 0:
		var troop = queue.pop_front()
		var step = troop.execute_step()
		if step.type != Troop.ExecuteStepType.STOPPED:
			if step.type == Troop.ExecuteStepType.MOVED:
				var result = troop.set_position(step.new_position)
				if result is GDScriptFunctionState:
					result.resume()
				else:
					yield(troop, "animation_step_finished")
			queue.push_back(troop)
	for troop in troops:
		troop.after_order_cleanup()
	return true
