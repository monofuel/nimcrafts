
type
    Point = object
        x: int
        y: int

# ..< is an exclusive upper bound
# .. is inclusive to upper and lower bounds
# `var` is required to make seq mutable, otherwise it is not
proc resetPointsToOrigin(points: var seq[Point]) =
    for i in 0 ..< points.len:
        points[i] = Point(x: 0, y: 0)


# this one is an error because the seq is not mutable
# resetPointsToOrigin(@[Point(x: 1, y: 2), Point(x: 3, y: 4)])

# let is immutable
# var is mutable
var points = @[Point(x: 1, y: 2), Point(x: 3, y: 4)]
resetPointsToOrigin(points)
