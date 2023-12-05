import strutils, sequtils, math, ../helper

const MAX_RED_CUBES = 12
const MAX_GREEN_CUBES = 13
const MAX_BLUE_CUBES = 14

type GameSet = tuple[red: int, blue: int, green: int]

type 
    Game = object
        id: int
        gameSets: seq[GameSet]

proc parseGameSet(gameSetUnparsed: string): GameSet =
    let split = gameSetUnparsed.split(',')
    for setUnparsed in split:
        let setUnparsedSplit = setUnparsed.strip().split(' ')
        let num = parseInt(setUnparsedSplit[0])
        let color = setUnparsedSplit[1]
        # echo num, "-", color
        case color
            of "red":
                result.red = num
            of "green":
                result.green = num
            of "blue":
                result.blue = num
            else: discard
    # echo result
    # echo "----"

proc isPossibleSet(gameSet: GameSet): bool =
    return gameSet.red <= MAX_RED_CUBES and gameSet.green <= MAX_GREEN_CUBES and gameSet.blue <= MAX_BLUE_CUBES

proc parseGame(gameLine: string): Game =
    let gameLineParts = gameLine.split(":")
    let gameID = gameLineParts[0].split(" ")[1].parseInt
    # echo gameID
    let setsUnparsed = gameLineParts[1].split(';')
    result = Game(id: gameID, gameSets: setsUnparsed.map(parseGameSet))

    # echo result
    # echo "--"

# Returns game ID if it's possible, 0 if it's not
proc getPossibleGameID(game: Game): int =
    let possibleSets = game.gameSets.filter(isPossibleSet)

    # echo possibleSets

    if possibleSets.len != game.gameSets.len:
        return 0
    
    return game.id

proc getFewestCubes(game: Game): GameSet =
    for gameSet in game.gameSets:
        if gameSet.red > result.red:
            result.red = gameSet.red
        if gameSet.green > result.green:
            result.green = gameSet.green
        if gameSet.blue > result.blue:
            result.blue = gameSet.blue

proc getGameSetPower(gameSet: GameSet): int =
    return gameSet.red * gameSet.green * gameSet.blue


let lines = readLinesFromStdin()

# echo lines

let games = lines.map(parseGame)

# echo games

echo games.map(getPossibleGameID).sum()

echo games.map(getFewestCubes).map(getGameSetPower).sum()
