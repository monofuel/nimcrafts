include "std/unittest"
include "../src/main"

suite "first test suite":
    
    test "hello fn test":
        doAssert hello(1) == 5
        doAssert hello(3) == 7

    test "cat meow test":
        let cat = Cat()
        cat.meow()

    test "split list":
        echoSplitList()
    test "fp split list":
        echoFPSplitList()
    test "json split list":
        echoJsonSplitList()