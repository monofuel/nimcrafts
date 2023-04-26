import pixels

type
    Point = object
        x: int
        y: int


proc putPixels(points: seq[Point]; col: Color) =
    for p in items(points):
        putPixel(p.x, p.y, col)

putPixels(@[Point(x: 2, y: 3), Point(x: 5, y: 10)], Gold)
