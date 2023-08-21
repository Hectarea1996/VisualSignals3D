extends EditorInspectorPlugin

var signal_manager_editor_res = preload("res://addons/signal_nodes/core/signal_manager_editor.gd")



func _can_handle(object):
	if SignalNodesHelper.is_this_my_scene(object as Node):
		var signal_receivers = object.owner.find_children("*","SignalReceiverBase")
		return !signal_receivers.is_empty()
	return false

static func _find_child_receivers(node : Node):
	var receivers : Array[SignalReceiverBase] = []
	var children = node.get_children()
	for child in children:
		if child is SignalReceiverBase:
			receivers.push_back(child)
			receivers.append_array(_find_child_receivers(child))
	return receivers

func _parse_begin(object):
	var root_node = object as Node
	var signal_receivers = _find_child_receivers(root_node)
	for signal_receiver in signal_receivers:
		if signal_receiver.owner == object:
			var signal_manager_editor = signal_manager_editor_res.new(signal_receiver)
			add_custom_control(signal_manager_editor)
