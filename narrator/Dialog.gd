extends 'res://cutscenes/CharacterCutscene.gd'

func prologue():
	say("It was a warm and sunny day.")
	say("Rin was on a normal trip to the local market.")
	say("But Rin couldn't have known what was in store for her today...")
	listen([["What?!", "suspense"], ["Who cares?", "sass"]])

func suspense():
	say("You'll have to wait and see!")

func sass():
	say("You'll care soon enough.")

