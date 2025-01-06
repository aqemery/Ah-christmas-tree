extends Node2D
class_name Santa
@onready var raindeer: Node2D = $Raindeer
@onready var sleige: Sprite2D = $Sleige
const PRESENT = preload("res://present.tscn")
@onready var move_timer: Timer = $MoveTimer
@onready var present_timer: Timer = $PresentTimer
@onready var area_2d: Area2D = $Sleige/Area2D
@onready var presents: AudioStreamPlayer = $presents
const SANTA_FALL = preload("res://santa_fall.tscn")
var default_health = 6
var health = default_health
var present_count = 1
var final_hit = false


func _process(delta: float) -> void:
    queue_redraw()
    if health < 1:
        health = 1000
        move_timer.stop()
        if present_count == 4 and final_hit: 
            sleige.frame = 1
            var leave = get_tree().create_tween()
            leave.tween_property(self,"position:x",400,2)
            leave.set_ease(Tween.EASE_IN)
            leave.tween_callback(queue_free)
            var fall = SANTA_FALL.instantiate()
            fall.global_position = sleige.global_position
            fall.linear_velocity = Vector2(0,-30)
            get_parent().add_child(fall)
            present_timer.stop()
            Signals.win.emit()
        elif present_count == 4: 
            var santa_tween = get_tree().create_tween()
            var next_location = Vector2(60,-30)
            santa_tween.tween_property(self,"position",next_location,1)
            await get_tree().create_timer(1).timeout
            final_hit = true
            health = 1
        else:
            move_timer.stop()
            present_timer.stop()
            var leave = get_tree().create_tween()
            leave.tween_property(self,"position:x",400,2)
            leave.set_ease(Tween.EASE_IN)
            leave.tween_callback(next_stage)
    pass
    
func next_stage():
    Signals.next_stage.emit()
    
    
func _draw() -> void:
    var current = sleige
    for r:Node2D in raindeer.get_children():
        draw_line(current.position, r.position, Color("80193b"),1)
        current = r

func next_round():
    health = default_health
    move_timer.start()
    present_timer.start()
    present_count += 1
    move_santa()
    

func drop_presents():
    for i in present_count:
        var new_present = PRESENT.instantiate()
        new_present.position = sleige.global_position - Vector2(20,16)
        get_parent().add_child(new_present)
    presents.play()
    


func move_santa():
    var santa_tween = get_tree().create_tween()
    var next_location = Vector2(randi_range(0,120),randi_range(-40,60))
    santa_tween.tween_property(self,"position",next_location,1)


func _on_move_timer_timeout() -> void:
    move_santa()

func _on_present_timer_timeout() -> void:
    drop_presents()
