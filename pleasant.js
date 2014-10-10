// Syntax-matching regular expressions:
var stringRegex     = /^'([^']*)'/,
    numberRegex     = /^\d+\b/,
    identifierRegex = /^[^\s(),']+/,
    callRegex       = /^\(.+\)/;

// Constant strings to print on certain errors
var SYNTAX_ERROR = 'unrecognised syntax: ';

var parseExpr = function(expr) {
  expr = trim(expr); // cut whitespace off expr

  var match, syntax; // syntax = element to go into AST

  if ( match = stringRegex.exec(expr) ) {
    syntax = { type: 'value', value: match[1] };
  }

  else if ( match = numberRegex.exec(expr) ) {
    syntax = { type: 'value', value: match[0] };
  }

  else if ( match = identifierRegex.exec(expr) ) {
    syntax = { type: 'identifier', value: match[0] };
  }

  else if ( match = callRegex.exec(expr) ) {
    return parseFunctionCall( expr );
  }

  else {
    console.log(SYNTAX_ERROR + expr);
  }

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
}

