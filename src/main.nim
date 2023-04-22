import sequtils, future, strutils, marshal

proc hello*(num: int): int =
  result = num + 4

type
  Cat = object

proc meow(self: Cat) =
  echo("Meow!")


#[
  example of a multi-line comment
]#

let ffxiv_characters = @["Thancred Waters", "Alphinaud Leveilleur", "Hildibrand Manderville"]

proc echoFPSplitList() =
  # iterate over the list, and echo out the array of split arrays
  ffxiv_characters.map(
    (x: string) -> (string, string) => (x.split[0], x.split[1])
  ).echo

proc echoSplitList() =
  # iterate over list, and echo each split array on a separate line
  for name in ffxiv_characters:
    echo((name.split[0], name.split[1]))

proc echoJsonSplitList() =

  let list = ffxiv_characters.map(
    (x: string) -> (string, string) => (x.split[0], x.split[1])
  )
  echo ($$list);
