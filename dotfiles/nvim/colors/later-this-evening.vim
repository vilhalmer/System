" Later This Evening
" This uses the basic ANSI colors, and is only designed to work with the included terminal theme installed.
"
" Based on Tomorrow Night Eighties
" http://chriskempson.com

let s:red = "DarkRed"
let s:yellow = "LightYellow"
let s:green = "DarkGreen"
let s:aqua = "DarkCyan"
let s:blue = "DarkBlue"
let s:purple = "DarkMagenta"
let s:black = "Black"
let s:white = "LightGrey"
let s:orange = "Brown" " TODO: This is gross, get rid of it.

let s:bright_red = "Red"
let s:bright_yellow = "Yellow"
let s:bright_green = "Green"
let s:bright_aqua = "Cyan"
let s:bright_blue = "Blue"
let s:bright_purple = "Magenta"
let s:bright_black = "DarkGrey"
let s:bright_white = "White"

let s:foreground = "none" " Default
let s:background = "none" " Same
let s:selection = s:white
let s:line = s:black
let s:comment = s:bright_black
let s:window = s:white

hi clear
syntax reset

let g:colors_name = "later-this-evening"

" Sets the highlighting for the given group
fun <SID>Color(group, fg, bg, attr)
    if a:fg != ""
        exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . a:fg
    endif
    if a:bg != ""
        exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . a:bg
    endif
    if a:attr != ""
        exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
    endif
endfun

" Vim Highlighting
call <SID>Color("Normal", s:foreground, "", "")
call <SID>Color("LineNr", s:selection, "", "")
call <SID>Color("NonText", s:selection, "", "")
call <SID>Color("SpecialKey", s:selection, "", "")
call <SID>Color("Search", s:background, s:yellow, "")
call <SID>Color("TabLine", s:window, s:foreground, "reverse")
call <SID>Color("TabLineFill", s:window, s:foreground, "reverse")
call <SID>Color("StatusLine", s:window, s:yellow, "reverse")
call <SID>Color("StatusLineNC", s:window, s:foreground, "reverse")
call <SID>Color("VertSplit", s:window, s:window, "none")
call <SID>Color("Visual", "", s:selection, "")
call <SID>Color("Directory", s:blue, "", "")
call <SID>Color("ModeMsg", s:green, "", "")
call <SID>Color("MoreMsg", s:green, "", "")
call <SID>Color("Question", s:green, "", "")
call <SID>Color("WarningMsg", s:red, "", "")
call <SID>Color("MatchParen", s:bright_yellow, s:background, "bold")
call <SID>Color("Folded", s:comment, s:background, "")
call <SID>Color("FoldColumn", "", s:background, "")
if version >= 700
    call <SID>Color("CursorLine", "", s:line, "none")
    call <SID>Color("CursorColumn", "", s:line, "none")
    call <SID>Color("PMenu", s:bright_white, s:black, "none")
    call <SID>Color("PMenuSel", s:black, s:yellow, "none")
    call <SID>Color("SignColumn", "", s:black, "none")
end
if version >= 703
    call <SID>Color("ColorColumn", "", s:line, "none")
end

" Standard Highlighting
call <SID>Color("Comment", s:comment, "", "")
call <SID>Color("Todo", s:black, s:bright_yellow, "")
call <SID>Color("Title", s:foreground, "", "bold")
call <SID>Color("Identifier", s:red, "", "none")
call <SID>Color("Statement", s:foreground, "", "")
call <SID>Color("Conditional", s:foreground, "", "")
call <SID>Color("Repeat", s:foreground, "", "")
call <SID>Color("Structure", s:purple, "", "")
call <SID>Color("Function", s:blue, "", "")
call <SID>Color("Constant", s:orange, "", "")
call <SID>Color("Keyword", s:yellow, "", "")
call <SID>Color("String", s:green, "", "")
call <SID>Color("Special", s:foreground, "", "")
call <SID>Color("PreProc", s:purple, "", "")
call <SID>Color("Operator", s:aqua, "", "none")
call <SID>Color("Type", s:blue, "", "none")
call <SID>Color("Define", s:purple, "", "none")
call <SID>Color("Include", s:blue, "", "")
"call <SID>Color("Ignore", "666666", "", "")

" Vim Highlighting
call <SID>Color("vimCommand", s:red, "", "none")

" C Highlighting
call <SID>Color("cType", s:yellow, "", "")
call <SID>Color("cStorageClass", s:purple, "", "")
call <SID>Color("cConditional", s:purple, "", "")
call <SID>Color("cRepeat", s:purple, "", "")

" PHP Highlighting
call <SID>Color("phpVarSelector", s:red, "", "")
call <SID>Color("phpKeyword", s:purple, "", "")
call <SID>Color("phpRepeat", s:purple, "", "")
call <SID>Color("phpConditional", s:purple, "", "")
call <SID>Color("phpStatement", s:purple, "", "")
call <SID>Color("phpMemberSelector", s:foreground, "", "")

" Ruby Highlighting
call <SID>Color("rubySymbol", s:green, "", "")
call <SID>Color("rubyConstant", s:yellow, "", "")
call <SID>Color("rubyAccess", s:yellow, "", "")
call <SID>Color("rubyAttribute", s:blue, "", "")
call <SID>Color("rubyInclude", s:blue, "", "")
call <SID>Color("rubyLocalVariableOrMethod", s:orange, "", "")
call <SID>Color("rubyCurlyBlock", s:orange, "", "")
call <SID>Color("rubyStringDelimiter", s:green, "", "")
call <SID>Color("rubyInterpolationDelimiter", s:orange, "", "")
call <SID>Color("rubyConditional", s:purple, "", "")
call <SID>Color("rubyRepeat", s:purple, "", "")
call <SID>Color("rubyControl", s:purple, "", "")
call <SID>Color("rubyException", s:purple, "", "")

" Crystal Highlighting
call <SID>Color("crystalSymbol", s:green, "", "")
call <SID>Color("crystalConstant", s:yellow, "", "")
call <SID>Color("crystalAccess", s:yellow, "", "")
call <SID>Color("crystalAttribute", s:blue, "", "")
call <SID>Color("crystalInclude", s:blue, "", "")
call <SID>Color("crystalLocalVariableOrMethod", s:orange, "", "")
call <SID>Color("crystalCurlyBlock", s:orange, "", "")
call <SID>Color("crystalStringDelimiter", s:green, "", "")
call <SID>Color("crystalInterpolationDelimiter", s:orange, "", "")
call <SID>Color("crystalConditional", s:purple, "", "")
call <SID>Color("crystalRepeat", s:purple, "", "")
call <SID>Color("crystalControl", s:purple, "", "")
call <SID>Color("crystalException", s:purple, "", "")

" Python Highlighting
call <SID>Color("pythonInclude", s:purple, "", "")
call <SID>Color("pythonStatement", s:purple, "", "")
call <SID>Color("pythonConditional", s:purple, "", "")
call <SID>Color("pythonRepeat", s:purple, "", "")
call <SID>Color("pythonException", s:purple, "", "")
call <SID>Color("pythonFunction", s:blue, "", "")
call <SID>Color("pythonPreCondit", s:purple, "", "")
call <SID>Color("pythonRepeat", s:aqua, "", "")
call <SID>Color("pythonExClass", s:orange, "", "")

" JavaScript Highlighting
call <SID>Color("javaScriptBraces", s:foreground, "", "")
call <SID>Color("javaScriptFunction", s:purple, "", "")
call <SID>Color("javaScriptConditional", s:purple, "", "")
call <SID>Color("javaScriptRepeat", s:purple, "", "")
call <SID>Color("javaScriptNumber", s:orange, "", "")
call <SID>Color("javaScriptMember", s:orange, "", "")
call <SID>Color("javascriptNull", s:orange, "", "")
call <SID>Color("javascriptGlobal", s:blue, "", "")
call <SID>Color("javascriptStatement", s:red, "", "")

" CoffeeScript Highlighting
call <SID>Color("coffeeRepeat", s:purple, "", "")
call <SID>Color("coffeeConditional", s:purple, "", "")
call <SID>Color("coffeeKeyword", s:purple, "", "")
call <SID>Color("coffeeObject", s:yellow, "", "")

" HTML Highlighting
call <SID>Color("htmlTag", s:red, "", "")
call <SID>Color("htmlTagName", s:red, "", "")
call <SID>Color("htmlArg", s:red, "", "")
call <SID>Color("htmlScriptTag", s:red, "", "")

" Diff Highlighting
call <SID>Color("diffAdd", "", "4c4e39", "")
call <SID>Color("diffDelete", s:background, s:red, "")
call <SID>Color("diffChange", "", "2B5B77", "")
call <SID>Color("diffText", s:line, s:blue, "")

" ShowMarks Highlighting
call <SID>Color("ShowMarksHLl", s:orange, s:background, "none")
call <SID>Color("ShowMarksHLo", s:purple, s:background, "none")
call <SID>Color("ShowMarksHLu", s:yellow, s:background, "none")
call <SID>Color("ShowMarksHLm", s:aqua, s:background, "none")

" Lua Highlighting
call <SID>Color("luaStatement", s:purple, "", "")
call <SID>Color("luaRepeat", s:purple, "", "")
call <SID>Color("luaCondStart", s:purple, "", "")
call <SID>Color("luaCondElseif", s:purple, "", "")
call <SID>Color("luaCond", s:purple, "", "")
call <SID>Color("luaCondEnd", s:purple, "", "")

" Cucumber Highlighting
call <SID>Color("cucumberGiven", s:blue, "", "")
call <SID>Color("cucumberGivenAnd", s:blue, "", "")

" Go Highlighting
call <SID>Color("goDirective", s:purple, "", "")
call <SID>Color("goDeclaration", s:purple, "", "")
call <SID>Color("goStatement", s:purple, "", "")
call <SID>Color("goConditional", s:purple, "", "")
call <SID>Color("goConstants", s:orange, "", "")
call <SID>Color("goTodo", s:yellow, "", "")
call <SID>Color("goDeclType", s:blue, "", "")
call <SID>Color("goBuiltins", s:purple, "", "")
call <SID>Color("goRepeat", s:purple, "", "")
call <SID>Color("goLabel", s:purple, "", "")

" Clojure Highlighting
call <SID>Color("clojureConstant", s:orange, "", "")
call <SID>Color("clojureBoolean", s:orange, "", "")
call <SID>Color("clojureCharacter", s:orange, "", "")
call <SID>Color("clojureKeyword", s:green, "", "")
call <SID>Color("clojureNumber", s:orange, "", "")
call <SID>Color("clojureString", s:green, "", "")
call <SID>Color("clojureRegexp", s:green, "", "")
call <SID>Color("clojureParen", s:aqua, "", "")
call <SID>Color("clojureVariable", s:yellow, "", "")
call <SID>Color("clojureCond", s:blue, "", "")
call <SID>Color("clojureDefine", s:purple, "", "")
call <SID>Color("clojureException", s:red, "", "")
call <SID>Color("clojureFunc", s:blue, "", "")
call <SID>Color("clojureMacro", s:blue, "", "")
call <SID>Color("clojureRepeat", s:blue, "", "")
call <SID>Color("clojureSpecial", s:purple, "", "")
call <SID>Color("clojureQuote", s:blue, "", "")
call <SID>Color("clojureUnquote", s:blue, "", "")
call <SID>Color("clojureMeta", s:blue, "", "")
call <SID>Color("clojureDeref", s:blue, "", "")
call <SID>Color("clojureAnonArg", s:blue, "", "")
call <SID>Color("clojureRepeat", s:blue, "", "")
call <SID>Color("clojureDispatch", s:blue, "", "")

" Scala Highlighting
call <SID>Color("scalaKeyword", s:purple, "", "")
call <SID>Color("scalaKeywordModifier", s:purple, "", "")
call <SID>Color("scalaOperator", s:blue, "", "")
call <SID>Color("scalaPackage", s:red, "", "")
call <SID>Color("scalaFqn", s:foreground, "", "")
call <SID>Color("scalaFqnSet", s:foreground, "", "")
call <SID>Color("scalaImport", s:purple, "", "")
call <SID>Color("scalaBoolean", s:orange, "", "")
call <SID>Color("scalaDef", s:purple, "", "")
call <SID>Color("scalaVal", s:purple, "", "")
call <SID>Color("scalaVar", s:aqua, "", "")
call <SID>Color("scalaClass", s:purple, "", "")
call <SID>Color("scalaObject", s:purple, "", "")
call <SID>Color("scalaTrait", s:purple, "", "")
call <SID>Color("scalaDefName", s:blue, "", "")
call <SID>Color("scalaValName", s:foreground, "", "")
call <SID>Color("scalaVarName", s:foreground, "", "")
call <SID>Color("scalaClassName", s:foreground, "", "")
call <SID>Color("scalaType", s:yellow, "", "")
call <SID>Color("scalaTypeSpecializer", s:yellow, "", "")
call <SID>Color("scalaAnnotation", s:orange, "", "")
call <SID>Color("scalaNumber", s:orange, "", "")
call <SID>Color("scalaDefSpecializer", s:yellow, "", "")
call <SID>Color("scalaClassSpecializer", s:yellow, "", "")
call <SID>Color("scalaBackTick", s:green, "", "")
call <SID>Color("scalaRoot", s:foreground, "", "")
call <SID>Color("scalaMethodCall", s:blue, "", "")
call <SID>Color("scalaCaseType", s:yellow, "", "")
call <SID>Color("scalaLineComment", s:comment, "", "")
call <SID>Color("scalaComment", s:comment, "", "")
call <SID>Color("scalaDocComment", s:comment, "", "")
call <SID>Color("scalaDocTags", s:comment, "", "")
call <SID>Color("scalaEmptyString", s:green, "", "")
call <SID>Color("scalaMultiLineString", s:green, "", "")
call <SID>Color("scalaUnicode", s:orange, "", "")
call <SID>Color("scalaString", s:green, "", "")
call <SID>Color("scalaStringEscape", s:green, "", "")
call <SID>Color("scalaSymbol", s:orange, "", "")
call <SID>Color("scalaChar", s:orange, "", "")
call <SID>Color("scalaXml", s:green, "", "")
call <SID>Color("scalaConstructorSpecializer", s:yellow, "", "")
call <SID>Color("scalaBackTick", s:blue, "", "")

" Git
call <SID>Color("diffAdded", s:green, "", "")
call <SID>Color("diffRemoved", s:red, "", "")
call <SID>Color("gitcommitSummary", "", "", "bold")

" Tagbar
call <SID>Color("TagbarHighlight", s:yellow, "", "")
call <SID>Color("TagbarType", s:bright_black, "", "")
call <SID>Color("TagbarScope", s:blue, "", "")
call <SID>Color("TagbarNestedKind", s:bright_black, "", "")
call <SID>Color("TagbarFoldIcon", s:bright_black, "", "")
call <SID>Color("TagbarKind", s:purple, "", "")

" Startify
call <SID>Color("StartifyHeader", s:bright_black, "", "")
call <SID>Color("StartifyFooter", s:white, "", "")
call <SID>Color("StartifySection", s:bright_white, "", "bold")
call <SID>Color("StartifyNumber", s:foreground, "", "")
call <SID>Color("StartifyBracket", s:bright_black, "", "")
call <SID>Color("StartifyFile", s:foreground, "", "bold")
call <SID>Color("StartifyPath", s:bright_black, "", "")
call <SID>Color("StartifySlash", s:bright_black, "", "")

" Delete Functions
delf <SID>Color

set background=dark
