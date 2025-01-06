extends Node2D
class_name Rudolph

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var timer: Timer = $Timer
@onready var charging: AudioStreamPlayer = $charging
@onready var laser_sound: AudioStreamPlayer = $laser

var fire_count = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    position = Vector2(400,50)
    reset()


func reset():
    area_2d.process_mode = Node.PROCESS_MODE_DISABLED
    animation_player.play("charge")
    if fire_count > 0:
        fire_count -= 1
    else:
        exit_screen()


func enter_screen():
    var enter = get_tree().create_tween()
    enter.tween_property(self,"position",Vector2(0,50),1)
    fire_count = 4
    timer.start()
    reset()

func exit_screen():
    var exit = get_tree().create_tween()
    exit.tween_property(self,"position",Vector2(400,50),2)
    exit.set_ease(Tween.EASE_OUT)
    timer.stop()
    await get_tree().create_timer(1).timeout
    Signals.next_stage.emit()

func _on_timer_timeout() -> void:
    animation_player.play("fire")
    charging.play()
    pass # Replace with function body.


func laser():
    charging.stop()
    laser_sound.play()
    area_2d.process_mode = Node.PROCESS_MODE_INHERIT
    Signals.shake_camera.emit(10,0.5,1)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "fire":
        laser_sound.stop()
        reset()
        
    pass # Replace with function body.
