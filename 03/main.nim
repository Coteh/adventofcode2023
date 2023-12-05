import strutils, sequtils, math, ../helper

type Position = tuple[x: int, y: int]

type 
    Gear = object
        pos: Position
        partNumbers: seq[int]

func isSymbol(chr: char): bool =
    return (chr < '0' or chr > '9') and chr != '.'

func isGear(chr: char): bool =
    return chr == '*'

let lines = readLinesFromStdin()

# echo lines

var startIndex = -1
var endIndex = -1
var totalSum = 0
var gears: seq[Gear]

proc addGearPart(gears: var seq[Gear], partNum: int, gearPos: Position): void =
    for i, gear in gears:
        if gear.pos.x == gearPos.x and gear.pos.y == gearPos.y:
            gears[i].partNumbers = gear.partNumbers & partNum
            return
    var newGear: Gear
    newGear.pos = gearPos
    newGear.partNumbers = @[partNum]
    gears.add(newGear)

for y, line in lines:
    for x in 0..line.len:
        if x < line.len and line[x] >= '0' and line[x] <= '9':
            if startIndex == -1:
                startIndex = x
        else:
            endIndex = x
            if startIndex >= 0 and endIndex >= 0:
                # echo startIndex, ",", endIndex
                let num = parseInt(line[startIndex..<endIndex])
                # echo num
                # find all indices that are adjacent to (startIndex, y) and (endIndex - 1, y)
                # and if there's a symbol, then add this number
                # echo "---"
                var can = false
                var gearAdded = false
                for i in startIndex..<endIndex:
                    # check left
                    if i > 0:
                        # echo ">", i, y, lines[y][i - 1]
                        let left = lines[y][i - 1]
                        if left.isSymbol:
                            # echo "left can"
                            can = true
                        if left.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i - 1, y: y))
                            gearAdded = true
                    # check right
                    if i < line.len - 1:
                        let right = lines[y][i + 1]
                        if right.isSymbol:
                            # echo "right can"
                            can = true
                        if right.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i + 1, y: y))
                            gearAdded = true
                    # check up
                    if y > 0:
                        let up = lines[y - 1][i]
                        if up.isSymbol:
                            # echo "up can"
                            can = true
                        if up.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i, y: y - 1))
                            gearAdded = true
                    # check down
                    if y < lines.len - 1:
                        let down = lines[y + 1][i]
                        if down.isSymbol:
                            # echo "down can"
                            can = true
                        if down.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i, y: y + 1))
                            gearAdded = true
                    # check top left
                    if i > 0 and y > 0:
                        let topLeft = lines[y - 1][i - 1]
                        if topLeft.isSymbol:
                            # echo "topLeft can"
                            can = true
                        if topLeft.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i - 1, y: y - 1))
                            gearAdded = true
                    # check top right
                    if i < line.len - 1 and y > 0:
                        let topRight = lines[y - 1][i + 1]
                        if topRight.isSymbol:
                            # echo "topRight can"
                            can = true
                        if topRight.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i + 1, y: y - 1))
                            gearAdded = true
                    # check bottom left
                    if i > 0 and y < lines.len - 1:
                        let bottomLeft = lines[y + 1][i - 1]
                        if bottomLeft.isSymbol:
                            # echo "bottomLeft can"
                            can = true
                        if bottomLeft.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i - 1, y: y + 1))
                            gearAdded = true
                    # check bottom right
                    if i < line.len - 1 and y < lines.len - 1:
                        let bottomRight = lines[y + 1][i + 1]
                        if bottomRight.isSymbol:
                            # echo "bottomRight can"
                            can = true
                        if bottomRight.isGear and not gearAdded:
                            gears.addGearPart(num, (x: i + 1, y: y + 1))
                            gearAdded = true
                if can:
                    totalSum += num
                # echo "---"
            startIndex = -1
            endIndex = -1

echo totalSum

echo gears
    .filter(proc(gear: Gear): bool = return gear.partNumbers.len == 2)
    .map(proc(gear: Gear): int = return gear.partNumbers[0] * gear.partNumbers[1])
    .sum()
