import std/[os, strformat, parseopt, inotify]

type ArenaBot = ref object
  name*: string
  hasFlag*: bool
  srcPath*: string
  dstFile*: string


let bots = @[
  ArenaBot(
    name: "spawnAndSwamp1",
    hasFlag: false,
    srcPath: "bots/spawnAndSwamp/",
    dstFile: "/home/monofuel/ScreepsArena/alpha-spawn_and_swamp/main.mjs"
  )
]

proc build(b: ArenaBot, release: bool) =
  echo &"Building {b.name}..."

  let mainFile = b.srcPath / "main.nim"
  # -d:release 
  var shellCmd = &"nim js -d:nodejs -d:screepsArena {mainFile}"
  if release:
    shellCmd = &"nim js -d:nodejs -d:screepsArena -d:release {mainFile}"
  let res = execShellCmd(shellCmd)
  echo &"Build result: {res}"
  if res != 0:
    raise newException(OSError, &"Failed to build {b.name}")


proc copy(b: ArenaBot) =

  let jsFile = b.srcPath / "main.js"
  echo &"Copying {b.name} from {jsFile} to {b.dstFile}"
  copyFile(jsFile, b.dstFile)
  

proc main() =

  var opts = initOptParser(quoteShellCommand(commandLineParams()))
  var doRelease = false
  var doWatch = false
  for kind, key, val in opts.getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        echo "Usage: nim c -r arenaBuild.nim"
        echo "  -h, --help: show this help"
        echo "  -r  --release: build in release mode"
        echo "  -w, --watch: watch the bots for changes and rebuild"
        quit(0)
      of "watch", "w":
        doWatch = true
      of "release", "r":
        doRelease = true
      else:
        echo "Unknown option: {kind} {key}"
        quit(1)
    else:
      echo "Unknown option: {kind}"
      quit(1)
        

  let inoty = inotify_init()
  doAssert inoty >= 0
  let watchdog = inotify_add_watch(inoty, "./", IN_MODIFY)
  doAssert watchdog >= 0

  for b in bots:
    build(b, doRelease)
    copy(b)
  echo "Done!"

  var f: File
  discard open(f, inoty, fmRead)

  # if doWatch:
    # TODO does not work yet
    # computers are hard
    # echo "Watching bots for changes..."
    # while true:
    #   var buf = newSeq[char](1024)
    #   let n = readChars(f, buf)
    #   echo &"Read {n} chars"

  # look up guardmon as an example
  # https://github.com/treeform/guardmons/blob/master/src/guardmons/watchmon.nim

  # treeform hottie
  # treeform tracy

main()
