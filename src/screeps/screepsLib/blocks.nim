

template logicBlock*(blockName: string, body: untyped): untyped =
  echo ""
  echo "# " & blockName & " Block"
  # Wrap the body in a function so we can use return
  let doLogic = proc () =
    try:
      body
    except CatchableError as e:
      echo ""
      echo "# " & blockName & " Block Error"
      echo e.msg
      echo ""
  doLogic()


template mainLoop*(body: untyped): untyped =
  echo "----"
  echo "# Start Loop"
  echo "----"
  try:
    body
  except CatchableError as e:
    echo "----"
    echo "# Main Loop Error"
    echo e.msg
    echo "----"
  finally:
    echo "----"
    echo "# End Loop"
    echo "----"