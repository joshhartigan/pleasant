// Syntax-matching 'matchers' - I don't want to use regexes:
var isString = function(str) {
  return str[0] === "'" && str[str.length - 1] === "'";
};

var isNumber = function(str) {
  return !isNaN(str);
};

var isIdentifier = function(str) {
  return !(
    str.indexOf('(')  > -1 ||
    str.indexOf(')')  > -1 ||
    str.indexOf('\'') > -1 ||
    str.indexOf(',')  > -1
  );
};

var isCall = function(str) {
  return str[0] === '(' && str[str.length - 1] === ')';
};

// Constant strings to print on certain errors
var SYNTAX_ERROR = 'unrecognised syntax: ';

var parseExpr = function(expr) {
  expr = trim(expr); // cut whitespace off expr

  var match, syntax; // syntax = element to go into AST

  if ( isString(expr) ) {
    syntax = { type: 'value', value: expr.substring(1, expr.length - 1) };
  }

  else if ( isNumber(expr) ) {
    syntax = { type: 'value', value: Number(expr) };
  }

  else if ( isIdentifier(expr) ) {
    syntax = { type: 'identifier', value: expr };
  }

  else if ( isCall(expr) ) {
    return parseFunctionCall( expr );
  }

  else {
    console.log(SYNTAX_ERROR + expr);
  }

  console.log(syntax);

};

var trim = function(string) {
  var start = string.search(/\S/);

  if (start < 0) {
    return "";
  }

  return string.slice(start);
};

var parseFunctionCall = function(expr) {
  expr = trim(expr);
  expr = expr.substring(1, expr.length - 1); // cut off first '(' and last ')'

  var syntax = { type: "call", operator: expr.split(" ")[0], args: [] };
  console.log(syntax);
};

parseExpr("'hello my name is josh'");
parseExpr("34534");
parseExpr("foobar");
parseExpr("(print hi)");

