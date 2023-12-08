import strutils, sequtils, math, ../helper

type
    Card = object
        num: int
        winningNumbers: seq[int]
        haveNumbers: seq[int]

func getNumberOfWins(card: Card): int =
    for winning in card.winningNumbers:
        for have in card.haveNumbers:
            if winning == have:
                result += 1

let lines = readLinesFromStdin()

# echo lines

var cards = lines
    .map(proc (line: string): seq[string] = line.split('|'))
    .map(proc (unprocessedCard: seq[string]): Card =
        let splitPart = unprocessedCard[0].split(':')
        # echo splitPart, splitPart[0].split(' ')[^1]
        
        result.num = parseInt(splitPart[0].split(' ')[^1])
        
        let splitWinningNumbers = splitPart[1].strip().split(' ')
        # echo splitWinningNumbers
        var winningNumbers: seq[int]
        for num in splitWinningNumbers:
            if num == "":
                continue
            winningNumbers.add(parseInt(num))
        result.winningNumbers = winningNumbers

        let splitHaveNumbers = unprocessedCard[1].strip().split(' ')
        # echo splitHaveNumbers
        var haveNumbers: seq[int]
        for num in splitHaveNumbers:
            if num == "":
                continue
            # echo num
            haveNumbers.add(parseInt(num))
        result.haveNumbers = haveNumbers

        # echo result
    )

let points = cards
    .map(proc (card: Card): int =
        var points = 0

        let numberOfWins = card.getNumberOfWins()

        for i in 0..<numberOfWins:
            if points == 0:
                points = 1
            else:
                points *= 2

        return points
    )
    .sum()

echo points

var numCardInstances: seq[int]
for i in 0..<cards.len:
    numCardInstances.add(1)

for i, card in cards:
    # echo "For card ", i, " (", numCardInstances[i], ")"
    let numberOfWins = getNumberOfWins(card)

    for j in 0..<numberOfWins:
        # echo "> Add card ", i + j + 1
        numCardInstances[i + j + 1] += numCardInstances[i]

echo numCardInstances.sum()
