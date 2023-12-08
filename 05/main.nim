import strutils, sequtils, math, ../helper

var conversionTables: seq[seq[tuple[destStart: int, sourceStart: int, length: int]]]

proc processSeed(seed: int): int =
    # echo "----"
    var currValue = seed
    # echo currValue
    for conversionTable in conversionTables:
        for conversionMap in conversionTable:
            if currValue >= conversionMap.sourceStart and currValue <= conversionMap.sourceStart + conversionMap.length:
                let dist = currValue - conversionMap.sourceStart
                currValue = conversionMap.destStart + dist
                # echo "->", currValue
                break
        # if number is not in lookup table, just use that value
        # echo currValue
    return currValue

let lines = readLinesFromStdin()

# echo lines

let part1Seeds = lines[0].split(": ")[1].split(' ').map(proc(str: string): int = parseInt(str))

# echo part1Seeds

const MAP_START = 0
const MAP_READ = 1

var readMode = MAP_START
var tableIndex = -1

for i in 2..<lines.len:
    let line = lines[i]
    case readMode:
        of MAP_START:
            tableIndex += 1
            conversionTables.add(newSeq[tuple[destStart: int, sourceStart: int, length: int]]())
            readMode = MAP_READ
        of MAP_READ:
            # echo ">", line, "<"
            if line == "":
                readMode = MAP_START
                # echo "end"
                continue
            var currTable = conversionTables[tableIndex]
            let splitLine = line.split(' ').map(proc(str: string): int = parseInt(str))
            # echo splitLine
            conversionTables[tableIndex].add((splitLine[0], splitLine[1], splitLine[2]))
        else: discard

# echo conversionTables

let part1Locations = part1Seeds.map(processSeed)

# echo part1Locations

echo part1Locations.min()

# TODO: Make this more efficient
# var startSeed: int
# var lowestLocation = -1

# for i, part1Seed in part1Seeds:
#     if i mod 2 == 0:
#         startSeed = part1Seed
#     else:
#         let seedRange = part1Seed
#         echo startSeed, "-", seedRange
#         for seed in startSeed..<startSeed+seedRange:
#             echo "seed: ", seed
#             let location = processSeed(seed)
#             echo "location: ", location
#             if lowestLocation == -1 or location < lowestLocation:
#                 lowestLocation = location

# echo lowestLocation
