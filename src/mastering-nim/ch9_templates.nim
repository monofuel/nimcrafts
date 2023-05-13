import pixels

import "./types.nim"

const ScreenWidth = 1024;
const ScreenHeight = 768;

template wrap(body: untyped) =
    drawText(0,10,"Before Body",8,Yellow)
    body

template boundsCheck(p: Point[int]) =
    if p.x < 0 or p.x >= ScreenWidth or
        p.y < 0 or p.y >= ScreenHeight:
        echo "aborting"
        return

proc safePutPixel(p: Point[int], c: Color) =
    boundsCheck(p)
    putPixel(p.x, p.y, c)


safePutPixel(Point[int](x: 10,y: 10), Red)
safePutPixel(Point[int](x: 10,y: -10), Red)

wrap:
    for i in 1..3:
        let textToDraw = "Welcome to Nim for the " & $i & "th time!"
        drawText(10, i*20, textToDraw, 10, Yellow)


template putPixel(x, y: int) =
    putPixel(x, y, colorContext)

template drawText(x, y: int; text: string; size: int) =
    drawText(x, y, text, size, colorContext)

template withColor(col: Color; body: untyped) =
    let colorContext {.inject.} = col
    body

withColor(Blue):
    putPixel(5, 5)
    drawText(50, 10, "Hello World!", 10)