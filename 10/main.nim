import ../helper

type Position = tuple[x: int, y: int]

let debug = false

proc findFurthestPoint(field: seq[string]): int =
    # clone the field to write to file if debug is enabled
    var debugField = field

    # find starting position
    var x = 0
    var y = 0
    for i in 0..<field.len():
        for j in 0..<field[i].len():
            let cell = field[i][j]
            if cell == 'S':
                # echo j, ",", i
                x = j
                y = i
    
    # track visited locations
    var visited = newSeq[seq[bool]](field.len())
    for i, row in visited:
        visited[i] = newSeq[bool](field[i].len())

    # track a path going one way, and one going the other way
    # once they collide then print the number of steps made in the loop
    var path1: Position = (x, y)
    var path2: Position = (x, y)
    var path1Prev: Position = (-1, -1)
    var path2Prev: Position = (-1, -1)
    var numSteps = 0

    # pick the first path start
    let adjPaths: array[4, Position] = [(x - 1, y), (x, y - 1), (x + 1, y), (x, y + 1)]

    for i, path in adjPaths:
        if path.y < 0 or path.y >= field.len() or path.x < 0 or path.x >= field[path.y].len():
            continue
        let cell = field[path.y][path.x]
        var validPath = false
        case i
            of 0: # left
                if cell == 'F' or cell == 'L' or cell == '-':
                    # echo "selecting left to start"
                    validPath = true
            of 1: # up
                if cell == 'F' or cell == '7' or cell == '|':
                    # echo "selecting up to start"
                    validPath = true
            of 2: # right
                if cell == 'J' or cell == '7' or cell == '-':
                    # echo "selecting right to start"
                    validPath = true
            of 3: # down
                if cell == 'J' or cell == 'L' or cell == '|':
                    # echo "selecting down to start"
                    validPath = true
        if validPath:
            if path1.x == x and path1.y == y:
                path1 = path
            else:
                path2 = path

    # echo "Path 1: ", path1
    # echo "Path 2: ", path2

    # starting location and first two starting
    # locations for the paths will be marked as visited
    visited[y][x] = true
    visited[path1.y][path1.x] = true
    visited[path2.y][path2.x] = true
    if debug:
        debugField[path1.y][path1.x] = '1'
        debugField[path2.y][path2.x] = '2'

    # traverse the paths until they can't go further along (ie. they have collided)
    while path1.x != path1Prev.x or path1.y != path1Prev.y or path2.x != path2Prev.x or path2.y != path2Prev.y:
        # path 1
        var adjPaths: array[4, Position] = [(path1.x - 1, path1.y), (path1.x, path1.y - 1), (path1.x + 1, path1.y), (path1.x, path1.y + 1)]
        path1Prev = path1
        var currCell = field[path1.y][path1.x]
        
        for i, path in adjPaths:
            # echo "Path 1 Adj Visited: ", field[path1.y][path1.x], path, visited[path.y][path.x]
            if path.y < 0 or path.y >= field.len() or path.x < 0 or path.x >= field[path.y].len() or visited[path.y][path.x]:
                continue

            let adjCell = field[path.y][path.x]
            var validPath = false
            case i
                of 0: # left
                    if (currCell == '-' or currCell == 'J' or currCell == '7') and (adjCell == 'F' or adjCell == 'L' or adjCell == '-'):
                        # echo "selecting left for path 1 next"
                        validPath = true
                of 1: # up
                    if (currCell == '|' or currCell == 'J' or currCell == 'L') and (adjCell == 'F' or adjCell == '7' or adjCell == '|'):
                        # echo "selecting up for path 1 next"
                        validPath = true
                of 2: # right
                    if (currCell == '-' or currCell == 'L' or currCell == 'F') and (adjCell == 'J' or adjCell == '7' or adjCell == '-'):
                        # echo "selecting right for path 1 next"
                        validPath = true
                of 3: # down
                    if (currCell == '|' or currCell == 'F' or currCell == '7') and (adjCell == 'J' or adjCell == 'L' or adjCell == '|'):
                        # echo "selecting down for path 1 next"
                        validPath = true
            if validPath:
                path1 = path
                visited[path1.y][path1.x] = true
                if debug:
                    debugField[path1.y][path1.x] = '1'
                break

        # path 2
        adjPaths = [(path2.x - 1, path2.y), (path2.x, path2.y - 1), (path2.x + 1, path2.y), (path2.x, path2.y + 1)]
        path2Prev = path2
        currCell = field[path2.y][path2.x]
        
        for i, path in adjPaths:
            # echo "Testing ", path.y, ",", path.x, ": ", field[path.y]
            # echo "Path 2 Adj Visited: ", path, visited[path.y][path.x]
            if path.y < 0 or path.y >= field.len() or path.x < 0 or path.x >= field[path.y].len() or visited[path.y][path.x]:
                continue

            let adjCell = field[path.y][path.x]
            var validPath = false
            case i
                of 0: # left
                    if (currCell == '-' or currCell == 'J' or currCell == '7') and (adjCell == 'F' or adjCell == 'L' or adjCell == '-'):
                        # echo "selecting left for path 2 next"
                        validPath = true
                of 1: # up
                    if (currCell == '|' or currCell == 'J' or currCell == 'L') and (adjCell == 'F' or adjCell == '7' or adjCell == '|'):
                        # echo "selecting up for path 2 next"
                        validPath = true
                of 2: # right
                    if (currCell == '-' or currCell == 'L' or currCell == 'F') and (adjCell == 'J' or adjCell == '7' or adjCell == '-'):
                        # echo "selecting right for path 2 next"
                        validPath = true
                of 3: # down
                    if (currCell == '|' or currCell == 'F' or currCell == '7') and (adjCell == 'J' or adjCell == 'L' or adjCell == '|'):
                        # echo "selecting down for path 2 next"
                        validPath = true
            if validPath:
                path2 = path
                visited[path2.y][path2.x] = true
                if debug:
                    debugField[path2.y][path2.x] = '2'
                break
        
        numSteps += 1

        # echo "After ", numSteps, " steps"

        # echo "Path 1: ", path1
        # echo "Path 2: ", path2
        # echo "Path 1 prev: ", path1Prev
        # echo "Path 2 prev: ", path2Prev
        # echo "eval: ", path1.x != path1Prev.x or path1.y != path1Prev.y or path2.x != path2Prev.x or path2.y != path2Prev.y

        # if numSteps > 200000:
        #     break

    if debug:
        debugField[path1.y][path1.x] = '3'
        debugField[path2.y][path2.x] = '4'

    if debug:
        let f = open("debug.txt", fmWrite)
        defer: f.close()

        for line in debugField:
            f.writeLine(line)

    return numSteps
            

let lines = readLinesFromStdin()

# echo lines

let furthestPoint = findFurthestPoint(lines)

echo furthestPoint
