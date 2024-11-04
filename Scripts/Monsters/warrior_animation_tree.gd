extends AnimationTree

enum {
	IDLE,
	RUN,
	HIT,
	ATTACK,
	BLOCK,
	DEAD,
	DODGE,
	TAUNT
}

var state

func change_state_idle():
	state = IDLE

func change_state_run():
	state = RUN

func change_state_hit():
	state = HIT

func change_state_attack():
	state = ATTACK

func change_state_block():
	state = BLOCK
	
func change_state_dead():
	state = DEAD

func change_state_dodge():
	state = DODGE

func change_state_taunt():
	state = TAUNT

	
