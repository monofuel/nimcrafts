import pixels

# sudo yum install SDL2-devel SDL2_ttf-devel

# page 14 has a typo- "if we use two points do define a line'

type
    Point = object
        x: int
        y: int

type
    Direction = enum
        Horizontal
        Vertical

# var p = Point(x: 5, y: 7)

proc drawHorizontalLine(start: Point, length: Positive) =
    for delta in 0..length:
        putPixel(start.x + delta, start.y)

proc drawVerticalLine(start: Point, length: Positive) =
    for delta in 0..length:
        putPixel(start.x, start.y + delta)

proc drawLine(start: Point, length: Positive, direction: Direction) =
    case direction
    of Horizontal:
        drawHorizontalLine(start, length)
    of Vertical:
        drawVerticalLine(start, length)

proc drawHorizontalLine(a, b: Point) =
    if b.x < a.x:
        drawHorizontalLine(b, a)
    else:
        for x in a.x .. b.x:
            putPixel(x, a.y)

proc drawVerticalLine(a, b: Point) =
    if b.y < a.y:
        drawVerticalLine(b, a)
    else:
        for y in a.y .. b.y:
            putPixel(a.x, y)

let
    p = Point(x: 20, y: 20)
    q = Point(x: 50, y: 20)
    r = Point(x: 20, y: -10)

drawHorizontalLine(p, q)
drawVerticalLine(p, r)

let a = Point(x: 60, y: 40)
drawLine(a, 50, Horizontal)
drawLine(a, 30, Vertical)

# putPixel(p.x, p.y)
# putPixel(11, 18, Red)


