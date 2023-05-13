
type BodyPart* = enum
  WORK = "work"
  CARRY = "carry"
  MOVE = "move"


type ReturnCodeType* = enum
  ERR_RCL_NOT_ENOUGH = -14
  ERR_INVALID_ARGS = -10
  ERR_NOT_ENOUGH_ENERGY = -6
  ERR_BUSY = -4
  ERR_NAME_EXISTS = -3
  ERR_NOT_OWNER = -1
  OK = 0
