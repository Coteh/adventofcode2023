proc readLinesFromStdin*(): seq[string] =
    while not stdin.endOfFile():
        result.add(stdin.readLine())
