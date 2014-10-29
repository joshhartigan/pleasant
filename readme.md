## pleasant

a programming language I'm working on. see the ANTLR grammar for generating
parsers in `parser/Pleasant.g4`.

#### example

```
fn oldEnough(age) ->
  if (age >= 18) ->
    console.log('you are old enough');
  end else ->
    console.log('you are too young.');
  end
end

oldEnough(15);
oldEnough(55);
```

### things that don't work

when you have multiple function calls, as such:

```
foobar(5);
bazboz(7);
```

the ANTLR parser returns:

```
line 2:0 missing {<EOF>, ';', ';\n'} at 'bazboz'
```

...what a mystery.

