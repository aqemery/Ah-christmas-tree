extends Node2D
@onready var star: AnimatedSprite2D = $Star
@onready var tree: CharacterBody2D = $Tree
@onready var sleige: Sprite2D = $Santa/Sleige
@onready var santa: Santa = $Santa
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var hit_present: AudioStreamPlayer = $"hit-present"
@onready var santa_hit: AudioStreamPlayer = $"santa-hit"
@onready var rudolph: Rudolph = $Rudolph
@onready var music: AudioStreamPlayer = $music
@onready var label: Label = $Label

var returning: bool = true
var back: bool = true
var shoot_tween:Tween
const EXPLODE = preload("res://explode.tscn")
const ELF_FLY_BY = preload("res://elf_fly_by.tscn")
const TITLE = preload("res://title.tscn")

var stage = 1
func _ready() -> void:
    Signals.die.connect(hit_something)
    Signals.next_stage.connect(next_stage)
    Signals.win.connect(won)
    parallax_2d.process_mode = Node.PROCESS_MODE_DISABLED
    Signals.shake_camera.emit(10,0.2,1)
    



func won():
    music.stop()
    label.show()
    
    
func next_stage():
    stage += 1
    if stage % 2 == 1:
        santa.present_count = stage /2
        santa.next_round()
    elif stage in [2,6]:
        var flyby = ELF_FLY_BY.instantiate()
        flyby.count = stage * 2
        add_child(flyby)
    else:
        rudolph.enter_screen() 


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        print("hello")
        get_tree().change_scene_to_file("res://title.tscn")
    
        
            
func hit_something():
    get_tree().reload_current_scene()

func _process(delta: float) -> void:
    if back:
        star.position = tree.position
    

func _physics_process(delta: float) -> void:
    if back:
        star.position = tree.position
        if Input.is_action_just_pressed("fire"):
            shoot_star()
    elif not shoot_tween.is_running():
        var direction = tree.position - star.position
        direction = direction.normalized()
        if star.position.distance_to(tree.position) < 200 * delta:
            star.position = tree.position
            back = true
            star.stop()
        else:
            star.position += direction * 200 * delta
            
    #prints(rudolph.animation_player.current_animation,rudolph.fire_count)
    if rudolph.animation_player.current_animation == "charge" and rudolph.fire_count >= 0:
        # move rudolph y position towards tree y position
        # rudolph.position.y = tree.position.y - 26

         rudolph.position.y = lerp(rudolph.position.y, tree.position.y- 26, 0.1)
        # var direction = tree.position - rudolph.position
        # direction = direction.normalized()
        # if rudolph.position.distance_to(tree.position) < 200 * delta:
        #     rudolph.position = tree.position
        #     rudolph.laser()
        # else:
        #     rudolph.position += direction * 200 * delta
        

func shoot_star():
    back = false 
    star.play()
    shoot_tween = get_tree().create_tween()
    shoot_tween.tween_property(star,"position:x",star.position.x + 200, 1)

func _on_star_collision(body: Node2D) -> void:
    for _r in range(3):
        var ex = EXPLODE.instantiate()
        ex._duration = .1 + randf_range(0, 0.1)
        ex.position = body.global_position + Vector2(randi_range(-3,3),randi_range(-3,3))
        add_child(ex)
    var ex = EXPLODE.instantiate()
    ex._duration = .1 
    ex.position = body.global_position
    ex._color = Color("f1efef")
    add_child(ex)
    body.call_deferred("queue_free")
    hit_present.play()
    
    if shoot_tween:
        shoot_tween.kill() 
    pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
    if "sleige" in area.get_groups():
        var ex = EXPLODE.instantiate()
        ex._duration = .1 
        ex.position = star.global_position
        ex._color = Color("f1efef")
        add_child(ex)
        santa.health -= 1
        santa_hit.play()
    
        if shoot_tween:
            shoot_tween.kill() 
