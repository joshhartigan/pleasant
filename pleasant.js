// Lexer matching functions
var
  isString = function(str) {
    return str[0] === "'" && str[str.length - 1] === "'";
  },

  isNumber = function(str) {
    return !isNaN(str);
  },

  isIdentifier = function(str) {
    return !(
      str.indexOf('(')  > -1 ||
      str.indexOf(')')  > -1 ||
      str.indexOf('\'') > -1 ||
      str.indexOf(',')  > -1
    );
  },

  isCall = function(str) {
    return str[0] === '(' && str[str.length - 1] === ')';
  };


// Constant strings to print on certain errors
var SYNTAX_ERROR         = 'unrecognised syntax: ';
var EXISTENCE_ERROR      = 'undefined identifier';
var NON_CALLABLE_ERROR   = 'calling a non-function: ';
var ARGUMENT_COUNT_ERROR = 'incorrect number of arguments: ';
var DEFINE_TYPE_ERROR    = 'attempted to set value of non-identifier';


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
    syntax = parseFunctionCall( expr );
  }

  else {
    console.log(SYNTAX_ERROR + expr);
    return;
  }

  return syntax;

  if (syntax) { console.log(syntax); }
};


var trim = function(string) {
  var start = string.search(/\S/);

  if (start < 0) {
    return '';
  }

  return string.slice(start);
};


var parseFunctionCall = function(expr) {
  expr = trim(expr);
  expr = expr.substring(1, expr.length - 1); // cut off first '(' and last ')'

  var syntax = { type: 'call', name: expr.split(' ')[0], args: [] };

  for ( var arg = 0; arg < expr.split(',').length - 1; arg++ ) {
    syntax.args.push(
      expr.split(',').slice(1)[arg].replace('(','').replace(')','')
    );
  }

  return syntax;

};


var evaluateExpr = function(expr, namespace) {
  switch (expr.type) {
    case 'value':
      return expr.value;

    case 'identifier':
      if (expr.name in namespace) {
        return namespace[expr.name];
      } else {
        console.log(EXISTENCE_ERROR);
        return;
      }

    case 'call':
      if (expr.name in standards) {
        return standards[expr.name](expr.args, namespace);
      }

      var op = evaluateExpr(expr.name, namespace);
      if (typeof op !== 'function') {
        console.log(NON_CALLABLE_ERROR + expr.name);
        return;
      }

      return op.apply(null, expr.args.map( function(arg) {
        return evaluateExpr(arg, namespace);
      }));
  }
};


// Standard syntax definitions
var standards = Object.create(null);

standards['if'] = function(args, namespace) {
  if (args.length !== 3) {
    console.log(ARGUMENT_COUNT_ERROR + args);
    return;
  }

  if ( evaluateExpr( args[0], namespace ) !== false ) {
    return evaluateExpr( args[1], namespace );
  } else {
    return evaluateExpr( args[1], namespace );
  }
};

standards['while'] = function(args, namespace) {
  if (args.length !== 2) {
    console.log(ARGUMENT_COUNT_ERROR + expr);
    return;
  }

  while ( evaluateExpr( args[0], namespace ) !== false ) {
    return evaluateExpr( args[1], namespace );
  }

  return false;
};

standards['def'] = function(args, namespace) {
  if (args.length !== 2) {
    console.log(ARGUMENT_COUNT_ERROR + expr);
    return;
  }
  if ( !isIdentifier( args[0] ) ) {
    console.log(DEFINE_TYPE_ERROR + expr);
    return;
  }

  var value = evaluateExpr( args[1], namespace );
  env[ args[0].name ] = value;

  return value;
};


// Default namespace setup
var nsMain = Object.create(null);
    nsMain['$T'] = true;
    nsMain['$F'] = false;

// Operators that work the same as their JS counterparts
['+', '-', '*', '/', '<', '>'].forEach( function(op) {
  nsMain[op] = new Function( 'x', 'y', 'return x ' + op + ' y;' );
});

nsMain['='] = new Function( 'x', 'y', 'return x == y' );

nsMain['log'] = function(value) {
  console.log(value);
  return value;
}


// -------- TESTS --------- //
console.log(

  evaluateExpr(
    parseExpr( 'foobar' ), // Returns error message: ✓
    nsMain
  ) + '\n' +

  evaluateExpr(
    parseExpr( '(if,(< 3 4),(log \'yes\'),(log \'no\')' ), // Returns 'yes':
    nsMain
  )

);

