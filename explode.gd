extends Node2D

@export var _radius: float = 50.0
@export var _duration: float = 2.0
@export var _color: Color = Color("fff9a1")

func _process(delta):
    _duration -= delta
    queue_redraw()
    if _duration < 0:
        queue_free()

func _draw():
    var cr = _duration * _radius
    draw_circle(Vector2.ZERO, cr, _color)
