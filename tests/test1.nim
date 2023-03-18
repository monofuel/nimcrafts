include "std/unittest"
include "../src/main"

suite "first test suite":
        test "hello fn test":
            doAssert hello(1) == 5
            doAssert hello(3) == 7
