grammar Pleasant;

//----STRUCTURE RULES----//

WhiteSpaces
  : [ \t\u000B\u000C\u0020\u00A0]+ -> channel(HIDDEN) ;

program
  : line+
  | EOF ;

line
  : statement eos
  | '\n'
  | functionDeclaration ;

statement
  : block
  | callStatement
  | variableStatement eos
  | ifStatement
  | returnStatement eos
  | chain '.' statement ;

block
  : '->' '\n'? statementGroup? 'end' '\n'? ;

statementGroup
  : statement+ ;

chain
  : Identifier ;

//----VARIABLE RULES----//

variableStatement
  : variableDeclarationList ;

variableDeclarationList
  : variableDeclaration ( ',' variableDeclaration)* ;

variableDeclaration
  : Identifier '=' expression ;

//----Identifier RULES----//

Identifier
  : [a-zA-Z_$][a-zA-Z_$0-9]* ;

//----IF STATEMENT RULES----//

ifStatement
  : ifKeyword '(' expressionGroup ')' statementGroup ( elseKeyword statementGroup )? ;

//----RETURN STATEMENT RULES----//

returnStatement
  : returnKeyword expression? ;

//----FUNCTION DECLARATION RULES----//

functionDeclaration
  : functionKeyword Identifier ( '(' parameterList? ')' )? block ;

parameterList
  : Identifier ( ',' Identifier )* ;

//----EXPRESSION RULES----//

expression
  : expression '[' expressionGroup ']'                 # BracketedMemberExpression
  | expression '.' expression                          # DotMemberExpression
  | '!' Identifier                                     # NotExpression
  | expression ( '*' | '/' | '%' ) expression          # MultiplicativeExpression
  | expression ( '+' | '-' ) expression                # AdditiveExpression
  | expression ( '<' | '>' | '<=' | '>=' ) expression  # RelativeExpression
  | expression ( '==' | '!=' ) expression              # EqualityExpression
  | expression ( 'and' | 'or' ) expression             # LogicalExpression
  | literal                                            # LiteralExpression
  | Identifier                                         # IdentifierExpression
  ;

expressionGroup
  : expression ( ',' expression )* ;

//----ARGUMENT / FUNCTION CALL RULES ----//

callStatement
  : Identifier '(' expressionGroup ')' eos
  | Identifier emptyArguments ;

emptyArguments
  : '()' ;

//----LITERAL RULES----//

literal
  : nilLiteral
  | booleanLiteral
  | stringLiteral
  | numericLiteral ;

nilLiteral
  : 'nil' ;

booleanLiteral
  : 'true'
  | 'false' ;

stringLiteral
  : StringLiteral ;

StringLiteral
  : '\'' ~['\r\n]* '\'' ;

numericLiteral
  : Number
  | Number '.' Number ;

Number
  : [0-9]+ ;

//----LANGUAGE CONSTANTS----//

eos
  : ';'
  | ';\n'
  | EOF ;

// keywords:
ifKeyword
  : 'if' ;

elseKeyword
  : 'else' ;

returnKeyword
  : 'return' ;

functionKeyword
  : 'fn' ;

