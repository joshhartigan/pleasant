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
shows the correct output --

```
>>> 34
>>> 68
```

-- it will need to go through each line as a string, and 'parse' the line into a
format that is readable by the interpreter. Take line 1, for example:

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
