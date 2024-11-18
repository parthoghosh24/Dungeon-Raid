extends AnimationTree

enum {
	IDLE,
	ATTACK,
	JUMP_ATTACK,
	RUN,
	DEAD,
	HIT,
}

var state

func change_state_idle():
	state = IDLE

func change_state_attack():
	state = ATTACK

func change_state_jump_attack():
	state = JUMP_ATTACK	

func change_state_run():
	state = RUN

func change_state_hit():
	state = HIT
	
func change_state_dead():
	state = DEAD


	
