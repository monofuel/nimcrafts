import "./types.nim"

iterator `..<`(a, b: int): int =
    var i = a
    while i < b:
        yield i
        i += 1

iterator items(s: seq[Point]): Point =
    for i in 0 ..< s.len:
        yield s[i]


proc find(haystack: string, needle: char): int =
    for i in 0 ..< haystack.len:
        if haystack[i] == needle:
            return i
    return -1


let index = find("abcabc", 'c')
echo("index: " & $index)


iterator findAll(haystack: string; needle: char): int =
    for i in 0 ..< haystack.len:
        if haystack[i] == needle:
            yield i

for index in findAll("abcabc", 'c'):
    echo("index: " & $index)
