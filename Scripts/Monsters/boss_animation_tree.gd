extends AnimationTree

enum {
	IDLE,
	ATTACK,
	RUN,
	DEAD,
}

var state

func change_state_idle():
	state = IDLE

func change_state_attack():
	state = ATTACK

func change_state_run():
	state = RUN
	
func change_state_dead():
	state = DEAD


	
