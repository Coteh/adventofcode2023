import strutils, sequtils, algorithm, ../helper

type
    HandType = enum
        HighCard, OnePair, TwoPair, ThreeOfAKind, FullHouse, FourOfAKind, FiveOfAKind

    CardHand = tuple
        handType: HandType
        hand: string
        bid: int

func getCardValue(card: char): int =
    case card
        of 'T':
            return 58
        of 'J':
            return 59
        of 'Q':
            return 60
        of 'K':
            return 61
        of 'A':
            return 62
        else:
            return int(card)

proc getHandType(hand: string): HandType =
    var cardCounts: array[13, int]

    for card in hand:
        let cardValue = getCardValue(card)
        cardCounts[cardValue - int('2')] += 1
        # echo card, " ", getCardValue(card), " ", getCardValue(card) - int('2')

    # echo cardCounts

    var numOfPairs = 0
    var threeOfAKind = false

    for cardCount in cardCounts:
        case cardCount
            of 5:
                return FiveOfAKind
            of 4:
                return FourOfAKind
            of 3:
                threeOfAKind = true
            of 2:
                numOfPairs += 1
            else:
                discard

    if threeOfAKind and numOfPairs > 0:
        return FullHouse
    elif threeOfAKind:
        return ThreeOfAKind

    if numOfPairs == 2:
        return TwoPair
    elif numOfPairs == 1:
        return OnePair

    return HighCard

# Define a custom comparison procedure for CardHand tuples
proc cmpCardHands(x, y: CardHand): int =
  # Compare based on 'handType' first
  if x.handType < y.handType:
    return -1
  elif x.handType > y.handType:
    return 1

  # If 'handType' is equal, compare based on 'hand'
  for i in 0..<x.hand.len():
    if getCardValue(x.hand[i]) > getCardValue(y.hand[i]):
        return 1
    elif getCardValue(x.hand[i]) < getCardValue(y.hand[i]):
        return -1

  # Tuples are equal
  return 0

let lines = readLinesFromStdin()

# echo lines

var hands = lines.map(proc (line: string): CardHand =
    let split = line.split()
    # echo split
    return (getHandType(split[0]), split[0], parseInt(split[1]))
)

# echo hands

# Use the sort method on the sequence with the custom comparison procedure
hands.sort(cmpCardHands)

var part1Result = 0

for i in 0..<hands.len():
    # echo hands[i]
    part1Result += hands[i].bid * (i + 1)

echo part1Result
