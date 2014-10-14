# Pleasant

## `Currently Working? :: no`

Pleasant is an unfinished programming language for simple and enjoyable
programming.


## Dependencies

- `fs`: Fairly obvious, required to read files.

    fs = require 'fs'


## Non-Interpreting Code

Utility function - `trim` - cut all leading and trailing whitespace from a
string:

    trim = (string) ->
      return String(this).replace /^s+|\s+$/g, ''

Get a file specified by a command-line argument, and put it into an array of
lines:

    lines = fs.readFileSync( process.argv[1] ).toString().split('\n')

Feed the array, minus the empty (pointless) lines, into a `parse()` function
(which hasn't been written yet):

    for line in lines
      parse line if trim(line) != ''


## Parsing Functions

parseFunctionHeader -
**See ['Parsing Methods'](https://github.com/joshhartigan/pleasant#parsing-methods)**

    parseFunctionHeader = (line) ->
      splitLine = line.split " "

      if not splitLine[0] == 'fn' and splitLine[2] == '->'
        false

      if splitLine.length < 4
        false

      if isIdentifier splitLine[1]
        functionName = splitLine[1]
      else
        false

      functionArgs = []
      if splitLine.length > 4
        for i in [ splitLine.length - 4 .. splitLine.length - 2 ]
          functionArgs.push splitLine[i].replace('(', '').replace(')', '')

getBlock -
**See ['Reading Blocks'](https://github.com/joshhartigan/pleasant#reading-blocks)**

    getBlock = (lines, headerIndex) ->
      currentIndex = headerIndex + 1
      blockArray = []

      while lines[currentIndex] != 'end'
        blockArray.push lines[currentIndex]
        currentIndex++

