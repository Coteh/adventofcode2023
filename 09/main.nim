import strutils, sequtils, math, ../helper

proc getDiffSeq(numSeq: seq[int]): seq[int] =
    for i in 1..<numSeq.len():
        result.add(numSeq[i] - numSeq[i - 1])

proc getNextNumInSeq(numSeq: seq[int]): int =
    var isAllZero = true
    for num in numSeq:
        if num != 0:
            isAllZero = false
            break

    if isAllZero:
        return 0

    let diffSeq = getDiffSeq(numSeq)

    # echo diffSeq

    let nextNum = getNextNumInSeq(diffSeq)

    # echo nextNum

    return numSeq[^1] + nextNum

proc getPrevNumInSeq(numSeq: seq[int]): int =
    var isAllZero = true
    for num in numSeq:
        if num != 0:
            isAllZero = false
            break

    if isAllZero:
        return 0

    let diffSeq = getDiffSeq(numSeq)

    # echo diffSeq

    let nextNum = getPrevNumInSeq(diffSeq)

    # echo nextNum

    return numSeq[0] - nextNum

let numSeqs = readLinesFromStdin().map(proc (line: string): seq[int] =
    return line.split().map(parseInt)
)

# echo numSeqs

# echo getPrevNumInSeq(numSeqs[0])

let nextNums = numSeqs.map(getNextNumInSeq)

# echo nextNums

echo nextNums.sum()

let prevNums = numSeqs.map(getPrevNumInSeq)

# echo prevNums

echo prevNums.sum()
