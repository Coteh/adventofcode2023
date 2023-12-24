import strutils, sequtils, math, ../helper

proc calculateBoatDistance(raceTime: int, timeToHold: int): int =
    return timeToHold * (raceTime - timeToHold)

proc calculateWaysToWin (race: tuple[time: int, recordDist: int]): int = 
    var waysToWin: int = 0

    for i in 0..race.time:
        if calculateBoatDistance(race.time, i) > race.recordDist:
            waysToWin += 1

    return waysToWin


let lines = readLinesFromStdin()

# echo lines

let seqs = lines.map(proc (line: string): seq[int] = 
    return line.split(" ").map(proc (str: string): int = 
        try:
            return parseInt(str)
        except CatchableError:
            return -1
    ).filter(proc (val: int): bool = val >= 0)
)

let part1Races = seqs[0].zip(seqs[1])

# echo part1Races

echo part1Races.map(calculateWaysToWin).prod()

let seqs2 = seqs.map(proc (vals: seq[int]): int =
    return vals.map(proc (val: int): string = val.intToStr).foldl(a & b).parseInt()
)

let part2Race = (seqs2[0], seqs2[1])

echo part2Race.calculateWaysToWin()
