grammar Pleasant;

//----STRUCTURE RULES----//

program
  : line+ ;

line
  : statement
  | functionDeclaration ;

statement
  : block
  | variableStatement
  | ifStatement
  | returnStatement ;

block
  : '{' statementMultiple '}' ;

statementMultiple
  : statement+ ;

//----VARIABLE RULES----//

variableStatement
  : variableDeclarationList eos ;

variableDeclarationList
  : variableDeclaration ( ',' variableDeclaration)* ;

variableDeclaration
  : Identifier '=' expression ;

//----Identifier RULES----//

Identifier
  : [a-zA-Z_$][a-zA-Z_$0-9]* ;

//----IF STATEMENT RULES----//

ifStatement
  : ifKeyword '(' expressionMultiple ')' statement ( elseKeyword statement)? ;

//----RETURN STATEMENT RULES----//

returnStatement
  : returnKeyword expression? eos ;

//----FUNCTION DECLARATION RULES----//

functionDeclaration
  : functionKeyword Identifier ( '(' parameterList? ')' )? '{' functionBody '}' ;

parameterList
  : Identifier ( ',' Identifier )* ;

functionBody
  : block? ;

//----EXPRESSION RULES----//

expression
  : expression '[' expressionMultiple ']'              # BracketedMemberExpression
  | Identifier '.' Identifier                          # DotMemberExpression
  | '!' Identifier                                     # NotExpression
  | expression ( '*' | '/' | '%' ) expression          # MultiplicativeExpression
  | expression ( '+' | '-' ) expression                # AdditiveExpression
  | expression ( '<' | '>' | '<=' | '>=' ) expression  # RelativeExpression
  | expression ( '==' | '!=' ) expression              # EqualityExpression
  | expression ( 'and' | 'or' ) expression             # LogicalExpression
  | literal                                            # LiteralExpression
  ;

expressionMultiple
  : expression ( ',' expression )* ;

//----LITERAL RULES----//

literal
  : nilLiteral
  | booleanLiteral
  | StringLiteral
  | numericLiteral ;

nilLiteral
  : 'nil' ;

booleanLiteral
  : 'true'
  | 'false' ;

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

