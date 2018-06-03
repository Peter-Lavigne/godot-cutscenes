extends ScrollContainer

# TODO :
#   + Add keyboard support (or replace mouse support with keyboard support)
#   + Wrap lines when they're too long

# A reference the DialogOption scene
export (PackedScene) var dialog_option

# Node
# a reference to the dialog manager node
var manager_node


# (Manager, [[String, String] ...])
# manager_node : See self.manager_node
# options : See Manager.options
func start(manager_node, options):
	self.manager_node = manager_node
	for option in options:
		var button = dialog_option.instance()
		button.create(self, option[0], option[1])
		$VBoxContainer.add_child(button)
	set_v_scroll(0)
	show()


# (String)
# Called by a DialogOption to indicate which line was selected.
# next_paragraph : The paragraph to advance to next
func option_selected(next_paragraph):
	finish()
	manager_node.finish(next_paragraph)


func finish():
	# safely deletes each DialogOption
	for button in $VBoxContainer.get_children():
		button.queue_free()
	hide()
