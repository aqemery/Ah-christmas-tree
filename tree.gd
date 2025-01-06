extends CharacterBody2D

@onready var die_sound: AudioStreamPlayer = $die

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const EXPLODE = preload("res://explode.tscn")
var dead = false
@onready var hurtbox: Area2D = $hurtbox

func _physics_process(delta: float) -> void:
    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        
    direction = Input.get_axis("ui_up", "ui_down")
    if direction:
        velocity.y = direction * SPEED
    else:
        velocity.y = move_toward(velocity.y, 0, SPEED)
    move_and_slide()
    Signals.player_pos = global_position


func _on_hurtbox_body_entered(body: Node2D) -> void:
    die()

func _on_hurtbox_area_entered(area: Area2D) -> void:
    die()



func die():
    if dead:
        return
    dead = true
    Signals.shake_camera.emit(6,0.5,1)
    visible = false
    hurtbox.queue_free()
    die_sound.play()
    for _r in range(20):    
        var ex = EXPLODE.instantiate()
        ex._duration = .1 + randf_range(0, .2)
        ex.position = position + Vector2(randi_range(-10,10),randi_range(-10,10))
        get_parent().add_child(ex)
    
    await get_tree().create_timer(.5).timeout
    get_parent().get_tree().reload_current_scene()
