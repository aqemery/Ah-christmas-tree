extends Area2D

@export var speed = 100
@export var throw_dist = 130
var has_snowball = true
@onready var elf: Sprite2D = $Elf
const SNOWBALL = preload("res://snowball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    position.x -= speed * delta
    if has_snowball and position.distance_to(Signals.player_pos) < throw_dist:
        has_snowball = false
        elf.frame = 1
        var snowball = SNOWBALL.instantiate()
        snowball.global_position = global_position
        get_parent().add_child(snowball)
        var angle = snowball.global_position.angle_to_point(Signals.player_pos)
        snowball.velocity = Vector2(150,0).rotated(angle)
    if position.x < -20:
        print("Free elf")
        queue_free()
        


func _on_area_entered(area: Area2D) -> void:    
    var spin_out = get_tree().create_tween()
    spin_out.tween_property(self,"rotation",PI*2, .5)
    spin_out.tween_callback(queue_free)
    pass # Replace with function body.
