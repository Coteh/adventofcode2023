import strutils, sequtils, math, ../helper

var useLetters: bool

func parseDigitFromName(input: string): int =
    if input.contains("one"):
        return 1
    elif input.contains("two"):
        return 2
    elif input.contains("three"):
        return 3
    elif input.contains("four"):
        return 4
    elif input.contains("five"):
        return 5
    elif input.contains("six"):
        return 6
    elif input.contains("seven"):
        return 7
    elif input.contains("eight"):
        return 8
    elif input.contains("nine"):
        return 9
    else:
        return 0

proc getDigits(line: string): int =
    var first, last: int
    var currStr: string
    for val in line:
        var digit: int
        if val >= '0' and val <= '9':
            digit = int(val) - int('0')
        elif useLetters:
            currStr.add(val)
            # attempt to parse its meaning
            # echo currStr
            digit = parseDigitFromName(currStr)
            # if a valid digit was obtained, clear the string out
            if digit > 0:
                # keep the last character in case it's needed again
                let lastChr = currStr[^1]
                currStr = ""
                currStr.add(lastChr)
        if digit > 0:
            if first == 0:
                first = digit
            else:
                last = digit
    if last == 0:
        last = first
    # echo "END", " ", first, " ", last
    return first * 10 + last

let lines = readLinesFromStdin()

#echo lines

var answer = lines.map(getDigits).sum()

echo answer

useLetters = true

answer = lines.map(getDigits).sum()

echo answer