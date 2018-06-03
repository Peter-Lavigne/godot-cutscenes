extends Node

# Singleton for accessing the active cutscene.
# Used by entities performing actions.

# This file closely reflects the Cutscene.gd file.

# Methods can be called even without an active cutscene.
# This simplifies code in entities using it (no existence checks).

# Cutscene
# the active cutscene
var cutscene = null


# (Cutscene)
# Indicates that the given cutscene is currently active.
# cutscene : the active cutscene
func start_cutscene(cutscene):
	self.cutscene = cutscene


# Indicates the cutscene has been finished.
func finish_cutscene():
	cutscene = null


# See `Cutscene.start_action`
func start_action(entity):
	if cutscene != null:
		cutscene.start_action(entity)


# See `Cutscene.finish_action()`
func finish_action(entity, next_paragraph = null):
	if cutscene != null:
		cutscene.finish_action(entity, next_paragraph)

