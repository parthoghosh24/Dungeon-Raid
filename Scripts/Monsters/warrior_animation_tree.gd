extends AnimationTree

enum {
	IDLE,
	RUN,
	HIT,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	BLOCK,
	COMBO,
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

func change_state_attack1():
	state = ATTACK1
	
func change_state_attack2():
	state = ATTACK2
	
func change_state_attack3():
	state = ATTACK3		

func change_state_block():
	state = BLOCK

func change_state_combo():
	state = COMBO
	
func change_state_dead():
	state = DEAD

func change_state_dodge():
	state = DODGE

func change_state_taunt():
	state = TAUNT

	
