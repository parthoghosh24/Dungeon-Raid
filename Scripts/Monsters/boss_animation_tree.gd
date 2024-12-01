extends AnimationTree

enum {
	IDLE,
	ATTACK,
	JUMP_ATTACK,
	RUN,
	DEAD,
	HIT,
}

var state: int

func change_state_idle() -> void:
	state = IDLE

func change_state_attack()-> void:
	state = ATTACK

func change_state_jump_attack()-> void:
	state = JUMP_ATTACK	

func change_state_run()-> void:
	state = RUN

func change_state_hit()-> void:
	state = HIT
	
func change_state_dead()-> void:
	state = DEAD


	
