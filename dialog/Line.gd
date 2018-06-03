extends RichTextLabel

# Node
# a reference to the dialog manager node
var manager_node

# AudioStreamPlayer
# The sound to play for each character. If null, nothing will play.
var voice

# int
# If positive, there will be a pause before displaying the next character.
var wait_ticks = 0

# TODO : make a Controls singleton to handle general control schemes.
# [KEY_CONSTANTS]
# Keys that can be pressed to advance the dialog.
var advance_dialog_controls = [KEY_SPACE, KEY_E]


func _ready():
	# don't process input until activated
	set_process_input(false)


# (Manager, String, AudioStreamPlayer)
# Start displaying a line of text.
# manager_node : see self.manager_nose
# line : The Line of text being displayed
# voice : See Line.voice
func say(manager_node, line, voice):
	self.manager_node = manager_node
	set_text(line)
	self.voice = voice
	$Timer.start()


# (InputEvent)
func _input(event):
	# currently only keyboard input is supported
	if not event is InputEventKey:
		return
	if event.is_echo():
		return
	
	# quickly finish or advance the text
	if event.get_scancode() in advance_dialog_controls and event.is_pressed():
		if visible_characters < get_total_character_count():
			# finish current line
			visible_characters = get_total_character_count()
		else:
			finish()


func finish():
	set_visible_characters(0)
	$Timer.stop()
	manager_node.advance_dialog()


# Called by Timer every tick.
# Displays one more character.
func _tick():
	if wait_ticks > 0:
		wait_ticks -= 1
		return
	if visible_characters >= get_total_character_count():
		return
	
	if voice != null:
		voice.play()
	var char_displyed = get_text()[visible_characters]
	# pause for certain characters
	if char_displyed in [',', '.', '?', '!']:
		wait_ticks = 6
	elif char_displyed == ' ':
		wait_ticks = 1
	
	visible_characters = visible_characters + 1
