extends Node

#
# A system for easily writing cutscenes with dialog, animations, movement, and more!
#
# Definitions:
#  + An 'entity' is anything that performs some action in this cutscene
#      + Characters, dialog boxes, the camera, the environment
#  + An 'action' is anything performed by an entity
#      + Saying a line of dialog, moving, performing an animation
#      + Represented by a single line of code
#  + A 'paragraph' is a sequence of actions to be performed together
#      + Represented by one function containing Actions
#  + A 'cutscene' is a collection of paragraphs
#      + Represented by a single file containing paragraphs
#
# Creating an entity / actions:
#  1. Define a function representing an action
#  2. Call `ActiveCutscene.start_action(self)` to start an action
#  3. Call `ActiveCutscene.finish_action(self)` to indicate the action has finished
#      + Optionally, specify the argument `next_paragraph` to indicate what 
#        paragraph should come next
#
# Creating a paragraph / cutscene:
#  1. Create a file extending this class
#  2. Define functions consisting of actions
#      + Calling `yield` will wait until all previous actions are finished to continue
#      + Returning a String will advance to that paragraph
#  3. The cutscene will end when:
#      + All actions have finished
#      + No action has specified the next paragraph to use
#
# To start a cutscene, call `start_cutscene(<paragraph_name>)` in/on the defined cutscene
#

# Node
# A reference to the dialog box
onready var dialog = DialogBox.get_node('DialogBox')

# Dictionary[entity, int]
# Keys represent entities performing actions.
# Values represent the number of actions they're currently performing.
var actions = {}

# String
# The currently running paragraph.
var active_paragraph = null


# (String)
# Must be the first thing called in a cutscene.
# paragraph : The first paragraph to call in this cutscene.
func start_cutscene(paragraph):
	ActiveCutscene.start_cutscene(self)
	active_paragraph = start_paragraph(paragraph)


# Must be the last thing called in a cutscene.
func finish_cutscene():
	ActiveCutscene.finish_cutscene()


# (any)
# Indicates an entity is beginning an action.
# entity : The entity performing the action.
func start_action(entity):
	if (actions.has(entity)):
		actions[entity] += 1
	else:
		actions[entity] = 1


# (any, String)
# Indicates an entity has finished an action.
# entity : The entity passed to the `start_action` call.
# next_paragraph : The next paragraph to perform.
func finish_action(entity, next_paragraph = null):
	actions[entity] -= 1
	assert(actions[entity] >= 0)
	if actions[entity] > 0: # the entity has other actions in progress
		return
	
	actions.erase(entity)
	if not actions.empty(): # there are other entities performing actions
		return
	
	if active_paragraph != null:
		active_paragraph.resume()
	elif next_paragraph != null:
		active_paragraph = start_paragraph(next_paragraph)
	else:
		finish_cutscene()


# (String)
# Calls a paragraph function, treating yield statments as 'wait for actions to finish'.
# paragraph : the name of the paragraph function
func start_paragraph(paragraph):
	var value = call(paragraph)
	dialog.start()
	while value != null:
		if typeof(value) == TYPE_STRING:
			start_paragraph(value)
			return
		else:  # yield statement
			yield()
			value = value.resume()
	active_paragraph = null
