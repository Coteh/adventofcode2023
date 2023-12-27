import strutils, tables, ../helper

type
    Network = object
        instructions: string
        nodes: Table[string, NodeRef]

    Node = object
        label: string
        left: NodeRef
        right: NodeRef

    NodeRef = ref Node

proc processNode(splitLine: seq[string], nodeTable: Table[string, NodeRef]): Node =
    result.label = splitLine[0]

    let leftLabel = splitLine[2][1..^2]
    let rightLabel = splitLine[3][0..^2]

    # echo leftLabel, ",", rightLabel

    result.left = nodeTable[leftLabel]
    result.right = nodeTable[rightLabel]

proc processNetwork(lines: seq[string]): Network =
    # first line is the instructions
    result.instructions = lines[0]
    
    var splitLines: seq[seq[string]]

    # starting from third line are the nodes
    for i in 2..<lines.len:
        let splitLine = lines[i].split()
        splitLines.add(splitLine)
        let nodeLabel = splitLine[0]
        result.nodes[nodeLabel] = NodeRef()

    # echo splitLines
    # echo result.nodes["AAA"][]
    # echo result.nodes["AAA"].left == nil

    for splitLine in splitLines:
        let node = processNode(splitLine, result.nodes)
        let nodeLabel = splitLine[0]
        result.nodes[nodeLabel][] = node

    # echo result.nodes["AAA"][]
    # echo result.nodes["AAA"].left == nil
    # echo result.nodes["AAA"].left[]

proc processNetworkInstructions(network: Network): int =
    var currNode: NodeRef = network.nodes["AAA"]
    
    while currNode.label != "ZZZ":
        for step in network.instructions:
            if step == 'L':
                currNode = currNode.left
            else: # 'R'
                currNode = currNode.right
            result += 1

    # echo currNode[]

    return result

let lines = readLinesFromStdin()

# echo lines

let network = processNetwork(lines)

# echo network

let steps = processNetworkInstructions(network)

echo steps
