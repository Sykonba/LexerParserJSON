package Example;

import java_cup.runtime.SymbolFactory;

/**
 * A scanner for JSON data files.
 *
 * @author Sugam Marahatta
 */

%%
%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
	}
	private SymbolFactory sf;
	private StringBuffer str = new StringBuffer();
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

%state STRING 

%%
<YYINITIAL> "{" 	{ return sf.newSymbol("LeftBrace", sym.LBRACE); }
<YYINITIAL> "}" 	{ return sf.newSymbol("RightBrace", sym.RBRACE); }
<YYINITIAL> {
"[" 	{ return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" 	{ return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }
"," 	{ return sf.newSymbol("Comma",sym.COMMA); }
":" 	{ return sf.newSymbol("Colon", sym.COLON); }

"null"	{ return sf.newSymbol("Null", sym.NULL); }
"true"	{ return sf.newSymbol("Boolean", sym.BOOLEAN, new Boolean(yytext())); }
"false"	{ return sf.newSymbol("Boolean", sym.BOOLEAN, new Boolean(yytext())); }

[0-9]+ { return sf.newSymbol("Integral Number",sym.NUMBER, new Integer(yytext())); }

\" { str.setLength(0); yybegin(STRING); }
[ \t\r\n\f] { /* ignore white space. */ }
}

//String literals
<STRING>{
\" { yybegin(YYINITIAL); return sf.newSymbol("String", sym.STRING, str.toString()); }
[^\n\r\"\\]+ { str.append(yytext()); }
\\\" { str.append('\"'); }
\\b  { str.append('\b'); }
\\f  { str.append('\f'); }
\\n  { str.append('\n'); }
\\r  { str.append('\r'); }
\\t  { str.append('\t'); }
\\   { str.append('\\'); }
}

//catch all
. { System.err.println("Illegal character: "+yytext()); }
