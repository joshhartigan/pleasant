```
 ____  __    ____   __   ____   __   __ _  ____
(  _ \(  )  (  __) / _\ / ___) / _\ (  ( \(_  _)
 ) __// (_/\ ) _) /    \\___ \/    \/    /  )(
(__)  \____/(____)\_/\_/(____/\_/\_/\_)__) (__)
```

An enjoyable programming language of the future *(read: not implemented yet)*.

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

Here's a rules:

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

