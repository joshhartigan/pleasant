![Pleasant](http://i.imgur.com/leDXgjz.png)

An enjoyable programming language of the future *(read: not implemented yet &mdash;
plans to be written in literate CoffeeScript)*.

This file documents what I'm learning/thinking/doing while trying to implement
the language. See DESCRIPTION.md for a specification/description of the language.

## Contents:

1. [Todo List](#todo-list)
2. [Introduction](#introduction)
3. [Partial Implementation](#partial-implementation)
4. [An Interpreting Program](#an-interpreting-program)
5. [Parsing Methods](#parsing-methods)
6. [Reading Blocks](#reading-blocks)


## Todo List:

1. Read http://www.bayfronttechnologies.com/mc_tutorial.html
2. Find out about [EBNF](http://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form0).
3. Sort out function calling syntax.
4. Read https://docs.python.org/2/reference/grammar.html


## Introduction

The interpreter for this language is probably going to be created very slowly,
and the repository is probably going to be mainly made up of markdown files. I
feel like if I just write down every thought that goes into making **pleasant**
work well, I will be able to understand the progress I've made, and mistakes
will be much easier to spot.

So, let's have a look at what we need to create: a programming language. A
language for writing programs. Here's a program written in **pleasant**, or at
least the language I want **pleasant** to become:

```
fn doubleAndPrint = x ->
  print x
  return x * 2
end

y = doubleAndPrint 34
print y
```

It looks a bit like CoffeeScript. I haven't written much CoffeeScript, but I
like the look of its syntax.


## Partial Implementation

You can watch a buggy, unfinished and incomplete implementation of **pleasant**
being slowly written in `pleasant.coffee`, but most of the important stuff is in
this document.


## An Interpreting Program

So if I want to write a program that gets the code snippet above, runs it, and
shows the correct output &mdash;

```
>>> 34
>>> 68
```

&mdash; it will need to go through each line as a string, and 'parse' the line into
a format that is readable by the interpreter. Take line 1, for example:

`fn doubleAndPrint = x ->`

To the parser, what do each of these words and symbols mean?

1. `fn` - Define a function. Expects: A name, an equals sign, an argument
   (optional), and an opening arrow (`->`).

2. `doubleAndPrint` - Based off of the fact that the last token was `fn`,
   `doubleAndPrint` must be the function name. Remember, the original `fn` is
   still waiting for `=`, any argument/s, and `->`.

3. `=` - Here marks where the function name ends, and the arguments begin, if
   there are any.

4. `x` - `x` is not `->`, and it is a grammatically-correct identifier,
   therefore it must be an argument.

5. `->` - This is not a grammatically-correct identifier. Is it `->`? Yes, it
   is. That means the rest of the code up until the matching `end` will be
   executed whenever `doubleAndPrint` is run.


## Parsing Methods

The interpreter needs to transform `fn doubleAndPrint = x ->` into an abstract
syntax tree, which would probably look like this:

![AST](http://i.imgur.com/etX4T6P.jpg)

How can I make a program that does that?

Here's a rule:

- Function definition lines must be on their own lines.

Therefore, if we look through some **pleasant** code and the first word of the
line is `fn`, the interpreter knows it is a function definition.

Let's see what the line of code would look like if it were split into multiple
strings, via spaces:

`['fn', 'doubleAndPrint', '=', '(x)', '->']`

This looks good - it's pretty much what we're looking for. But what if there are
multiple arguments, for example?

`fn addTwoNumbers = (x y) ->`

The line above would be split into the following array:

`['fn', 'addTwoNumbers', '=', '(x', 'y)', '->']`

There isn't really a problem here, other than the `'(x'` and `'y)'` thing. Could
we tell the parser *All strings in between '=' and '->' should have their
parentheses removed from them*? ... Kind of &mdash; we need to make sure the
program doesn't throw up when there is a string between `'='` and `'->'` which
doesn't have parentheses. This will happen when there are > 2 arguments:

`['fn', 'addThreeNumbers', '=', '(x', 'y', 'z)', '->']`

-------------------------------------------------------------------------------

So, here's the 'rules' for parsing a function definition 'header' in **pleasant**:

1. Refer to the line split into an array by spaces as `splitLine`.

2. The first string of `splitLine` is `'fn'`. If it isn't, *syntax error.*

3. The second string of `splitLine` should be a valid identifier. Store it as
   the `name` property of the function.

4. The third string should be an `=`, always.

5. Until the string at the current position in `splitLine` is `'->'`, add the
   current string as an element in the function's `args` property. If it has a
   parenthesis in it, remove it.

6. After the `->` string is where the logic of the function begins.

Here's some CoffeeScript code that parses a **pleasant** function definition
header:

```coffee
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
```


## Reading Blocks

We've read and parsed the header of a function, but the most important part of a
function is the code that it executes. The method I'll use for getting all the
lines in a block from `->` to `end` is simply appending each line to an array
&mdash; the array can be parsed at any time later on when the function is
called.

Let's have `headerIndex` as the line number of the function header, and
`currentIndex` as the current line number. We'll use some CoffeeScript code to
read until the line at `currentIndex` matches `'end'`.

```coffee
currentIndex = headerIndex + 1
while lines[currentIndex] != 'end'
  blockArray.push lines[currentIndex]
  currentIndex++
```

