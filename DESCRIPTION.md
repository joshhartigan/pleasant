# Pleasant Language Description

This document is an attempt at specifying the grammar, syntax, and semantics of
the Pleasant programming language.

## Blocks

Pleasant uses the delimiters `->` and `end` to start and end (respectively)
blocks of code. Whitespace at the beginning or end of the line is not
significant, though it is highly recommended that code is neatly indented, and
trailing whitespace is removed. The `->` and `end` delimiters work similarly to
opening- and curling- curly braces `{ }` in other programming languages.

## Lines

Semicolons `;` are not used to end statements like they are in other languages.
In most circumstances, a line-ending will finish a statement, but this is not
always true.

## Functions

Functions are defined with a `fn` keyword; an identifier for the function; a
list - optionally - of parameters, and the body of statements surrounded by `->`
and `end` delimiters.

```
fn cube = (x) ->
  give x * x * x
end

fn addTwoNumbers = (x, y) ->
  give x + y
end
```

Functions are called with their identifier, followed by a space, followed by a
comma-seperated list of arguments:

```
cube 10 // => 1000

addTwoNumbers 12, 23 // => 35

addTwoNumbers cube 5, 2 // => 127
```

Functions can be passed around like any other variable.
An example of this is as a function parameter:

```
fn apply = (f, a, b) ->
  f a
end

apply addTwoNumbers, 4, 2 // => 6
```

As in JavaScript, if a parameter isn't specified in a function call, it is given
the nil/null/undefined/none type of Pleasant, which is `nil`.

```
fn speak = (word) ->
  put word
end

speak // => nil
```

