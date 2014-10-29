grammar Pleasant;

//----STRUCTURE RULES----//

WhiteSpaces
  : [ \t\u000B\u000C\u0020\u00A0]+ -> channel(HIDDEN) ;

program
  : line+ ;

line
  : statement eos
  | functionDeclaration ;

statement
  : block
  | variableStatement
  | ifStatement
  | returnStatement
  | callStatement ;

block
  : '{' statementMultiple? '}' ;

statementMultiple
  : statement+ ;

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
  | expression '.' expression                          # DotMemberExpression
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

//----ARGUMENT / FUNCTION CALL RULES ----//

callStatement
  : Identifier '(' arguments ')' ;

arguments
  : expression ( ',' expression)* ;

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

