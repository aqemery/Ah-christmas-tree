extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    gravity_scale = 0.2
    linear_velocity = Vector2(randi_range(-140,-30),randi_range(-140,-100))
    
    sprite_2d.frame = randi_range(0,3)
    
    pass # Replace with function body.


func _physics_process(delta: float) -> void:
    if position.y > 240:
        queue_free()
