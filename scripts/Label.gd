extends Label

@onready var score_system = $"../../ScoreSystem" as ScoreSystem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(score_system.score)
