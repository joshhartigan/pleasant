### pleasant

a programming language I'm working on. see the ANTLR grammar for generating
parsers in `parser/Pleasant.g4`.

##### example

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

