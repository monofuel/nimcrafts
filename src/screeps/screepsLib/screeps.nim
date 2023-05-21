import ../screepsArena/main

proc getMostHurtCreep*(creeps: seq[Creep]): Creep =
  var creep = creeps[0]
  var delta = creep.hitsMax - creep.hits
  for c in creeps:
    let d = c.hitsMax - c.hits
    if d > delta:
      creep = c
      delta = d
  return creep