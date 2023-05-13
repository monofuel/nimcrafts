import std/macros
import pixels

macro disable(body: untyped): untyped =
    result = newStmtList()

disable:
    drawText(10, 10, "Disabled piece of code!", Blue)
