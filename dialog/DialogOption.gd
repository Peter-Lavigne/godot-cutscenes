extends Button

# Node
# a reference to the Options node that created this
var options_node

# String
# The paragraph to advance to if this Option is selected.
var paragraph


# (Options, String, String)
# Contructor for Option objects.
# options_node : See self.options_node
# line : The dialog option shown
# paragraph : See Option.paragraph
func create(options_node, line, paragraph):
	self.options_node = options_node
	text = line
	self.paragraph = paragraph

# Called when the option is selected.
func _on_press():
	options_node.option_selected(paragraph)
