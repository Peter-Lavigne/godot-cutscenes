extends 'res://cutscenes/Cutscene.gd'


# This node must be the child of a Character.
# This script provides shorthand for calling action functions in a subclass.
# Allows Character logic to be separate from their dialog while also improving readability.


# Node
# A reference to the parent class.
onready var parent = get_parent()


# ([[String, String] ...])
# 'Listening' is Character-independent, so there's no action method for it in characters
# options : See Manager.listen(options) in the dialog box system
func listen(options):
	dialog.listen(options)


# (String)
# See Character.says
func say(line):
	parent.says(line)

