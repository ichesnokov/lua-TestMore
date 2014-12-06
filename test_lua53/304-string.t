#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2009-2014, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua String Library

=head2 Synopsis

    % prove 304-string.t

=head2 Description

Tests Lua String Library

See "Lua 5.3 Reference Manual", section 6.4 "String Manipulation",
L<http://www.lua.org/manual/5.3/manual.html#6.4>.

See "Programming in Lua", section 20 "The String Library".

=cut

]]

require 'Test.More'

plan(169)

is(string.byte('ABC'), 65, "function byte")
is(string.byte('ABC', 2), 66)
is(string.byte('ABC', -1), 67)
is(string.byte('ABC', 4), nil)
is(string.byte('ABC', 0), nil)
eq_array({string.byte('ABC', 1, 3)}, {65, 66, 67})
eq_array({string.byte('ABC', 1, 4)}, {65, 66, 67})

type_ok(getmetatable('ABC'), 'table', "literal string has metatable")

s = "ABC"
is(s:byte(2), 66, "method s:byte")

is(string.char(65, 66, 67), 'ABC', "function char")
is(string.char(), '')

error_like(function () string.char(0, 'bad') end,
           "^[^:]+:%d+: bad argument #2 to 'char' %(number expected, got string%)",
           "function char (bad arg)")

error_like(function () string.char(0, 9999) end,
           "^[^:]+:%d+: bad argument #2 to 'char' %(.-value.-%)",
           "function char (invalid)")

d = string.dump(plan)
type_ok(d, 'string', "function dump")

error_like(function () string.dump(print) end,
           "^[^:]+:%d+: unable to dump given function",
           "function dump (C function)")

s = "hello world"
eq_array({string.find(s, "hello")}, {1, 5}, "function find (mode plain)")
eq_array({string.find(s, "hello", 1, true)}, {1, 5})
eq_array({string.find(s, "hello", 1)}, {1, 5})
is(string.sub(s, 1, 5), "hello")
eq_array({string.find(s, "world")}, {7, 11})
eq_array({string.find(s, "l")}, {3, 3})
is(string.find(s, "lll"), nil)
is(string.find(s, "hello", 2, true), nil)
eq_array({string.find(s, "world", 2, true)}, {7, 11})
is(string.find(s, "hello", 20), nil)

s = "hello world"
eq_array({string.find(s, "^h.ll.")}, {1, 5}, "function find (with regex & captures)")
eq_array({string.find(s, "w.rld", 2)}, {7, 11})
is(string.find(s, "W.rld"), nil)
eq_array({string.find(s, "^(h.ll.)")}, {1, 5, 'hello'})
eq_array({string.find(s, "^(h.)l(l.)")}, {1, 5, 'he', 'lo'})
s = "Deadline is 30/05/1999, firm"
date = "%d%d/%d%d/%d%d%d%d"
is(string.sub(s, string.find(s, date)), "30/05/1999")
date = "%f[%S]%d%d/%d%d/%d%d%d%d"
is(string.sub(s, string.find(s, date)), "30/05/1999")

error_like(function () string.find(s, '%f') end,
           "^[^:]+:%d+: missing '%[' after '%%f' in pattern",
           "function find (invalid frontier)")

is(string.format("pi = %.4f", math.pi), 'pi = 3.1416', "function format")
d = 5; m = 11; y = 1990
is(string.format("%02d/%02d/%04d", d, m, y), "05/11/1990")
is(string.format("%X %x", 126, 126), "7E 7e")
tag, title = "h1", "a title"
is(string.format("<%s>%s</%s>", tag, title, tag), "<h1>a title</h1>")

is(string.format('%q', 'a string with "quotes" and \n new line'), [["a string with \"quotes\" and \
 new line"]], "function format %q")

is(string.format('%q', 'a string with \b and \b2'), [["a string with \8 and \0082"]], "function format %q")

is(string.format("%s %s", 1, 2, 3), '1 2', "function format (too many arg)")

is(string.format("%% %c %%", 65), '% A %', "function format (%%)")

r = string.rep("ab", 100)
is(string.format("%s %d", r, r:len()), r .. " 200")

error_like(function () string.format("%s %s", 1) end,
           "^[^:]+:%d+: bad argument #3 to 'format' %(.-no value%)",
           "function format (too few arg)")

error_like(function () string.format('%d', 'toto') end,
           "^[^:]+:%d+: bad argument #2 to 'format' %(number expected, got string%)",
           "function format (bad arg)")

error_like(function () string.format('%k', 'toto') end,
           "^[^:]+:%d+: invalid option '%%k' to 'format'",
           "function format (invalid option)")

error_like(function () string.format('%------s', 'toto') end,
           "^[^:]+:%d+: invalid format %(repeated flags%)",
           "function format (invalid format)")

error_like(function () string.format('pi = %.123f', math.pi) end,
           "^[^:]+:%d+: invalid ",
           "function format (invalid format)")

error_like(function () string.format('% 123s', 'toto') end,
           "^[^:]+:%d+: invalid ",
           "function format (invalid format)")

s = "hello"
output = {}
for c in string.gmatch(s, '..') do
    table.insert(output, c)
end
eq_array(output, {'he', 'll'}, "function gmatch")
output = {}
for c1, c2 in string.gmatch(s, '(.)(.)') do
    table.insert(output, c1)
    table.insert(output, c2)
end
eq_array(output, {'h', 'e', 'l', 'l'})
s = "hello world from Lua"
output = {}
for w in string.gmatch(s, '%a+') do
    table.insert(output, w)
end
eq_array(output, {'hello', 'world', 'from', 'Lua'})
s = "from=world, to=Lua"
output = {}
for k, v in string.gmatch(s, '(%w+)=(%w+)') do
    table.insert(output, k)
    table.insert(output, v)
end
eq_array(output, {'from', 'world', 'to', 'Lua'})

is(string.gsub("hello world", "(%w+)", "%1 %1"), "hello hello world world", "function gsub")
is(string.gsub("hello world", "%w+", "%0 %0", 1), "hello hello world")
is(string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%2 %1"), "world hello Lua from")
error_like(function () string.gsub("hello world", "%w+", "%e") end,
           "^[^:]+:%d+: invalid use of '%%' in replacement string",
           "function gsub (invalid replacement string)")
is(string.gsub("home = $HOME, user = $USER", "%$(%w+)", string.reverse), "home = EMOH, user = RESU")
is(string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s) return tostring(load(s)()) end), "4+5 = 9")
local t = {name='lua', version='5.1'}
is(string.gsub("$name-$version.tar.gz", "%$(%w+)", t), "lua-5.1.tar.gz")

is(string.gsub("Lua is cute", 'cute', 'great'), "Lua is great")
is(string.gsub("all lii", 'l', 'x'), "axx xii")
is(string.gsub("Lua is great", '^Sol', 'Sun'), "Lua is great")
is(string.gsub("all lii", 'l', 'x', 1), "axl lii")
is(string.gsub("all lii", 'l', 'x', 2), "axx lii")
is(select(2, string.gsub("string with 3 spaces", ' ', ' ')), 3)

eq_array({string.gsub("hello, up-down!", '%A', '.')}, {"hello..up.down.", 4})
text = "hello world"
nvow = select(2, string.gsub(text, '[AEIOUaeiou]', ''))
is(nvow, 3)
eq_array({string.gsub("one, and two; and three", '%a+', 'word')}, {"word, word word; word word", 5})
test = "int x; /* x */  int y; /* y */"
eq_array({string.gsub(test, "/%*.*%*/", '<COMMENT>')}, {"int x; <COMMENT>", 1})
eq_array({string.gsub(test, "/%*.-%*/", '<COMMENT>')}, {"int x; <COMMENT>  int y; <COMMENT>", 2})
s = "a (enclosed (in) parentheses) line"
eq_array({string.gsub(s, '%b()', '')}, {"a  line", 1})

error_like(function () string.gsub(s, '%b(', '') end,
           "^[^:]+:%d+: .- pattern",
           "function gsub (malformed pattern)")

eq_array({string.gsub("hello Lua!", "%a", "%0-%0")}, {"h-he-el-ll-lo-o L-Lu-ua-a!", 8})
eq_array({string.gsub("hello Lua", "(.)(.)", "%2%1")}, {"ehll ouLa", 4})

function expand (s)
    return (string.gsub(s, '$(%w+)', _G))
end
name = 'Lua'; status= 'great'
is(expand("$name is $status, isn't it?"), "Lua is great, isn't it?")
is(expand("$othername is $status, isn't it?"), "$othername is great, isn't it?")

function expand (s)
    return (string.gsub(s, '$(%w+)', function (n)
                                          return tostring(_G[n]), 1
                                     end))
end
like(expand("print = $print; a = $a"), "^print = function: [0]?[Xx]?[builtin]*#?%x+; a = nil")

error_like(function () string.gsub("hello world", '(%w+)', '%2 %2') end,
           "^[^:]+:%d+: invalid capture index",
           "function gsub (invalid index)")

error_like(function () string.gsub("hello world", '(%w+)', true) end,
           "^[^:]+:%d+: bad argument #3 to 'gsub' %(string/function/table expected%)",
           "function gsub (bad type)")

error_like(function ()
    function expand (s)
        return (string.gsub(s, '$(%w+)', _G))
    end

    name = 'Lua'; status= true
    expand("$name is $status, isn't it?")
           end,
           "^[^:]+:%d+: invalid replacement value %(a boolean%)",
           "function gsub (invalid value)")

is(string.len(''), 0, "function len")
is(string.len('test'), 4)
is(string.len("a\000b\000c"), 5)
is(string.len('"'), 1)

is(string.lower('Test'), 'test', "function lower")
is(string.lower('TeSt'), 'test')

s = "hello world"
is(string.match(s, '^hello'), 'hello', "function match")
is(string.match(s, 'world', 2), 'world')
is(string.match(s, 'World'), nil)
eq_array({string.match(s, '^(h.ll.)')}, {'hello'})
eq_array({string.match(s, '^(h.)l(l.)')}, {'he', 'lo'})
date = "Today is 17/7/1990"
is(string.match(date, '%d+/%d+/%d+'), '17/7/1990')
eq_array({string.match(date, '(%d+)/(%d+)/(%d+)')}, {'17', '7', '1990'})
is(string.match("The number 1298 is even", '%d+'), '1298')
pair = "name = Anna"
eq_array({string.match(pair, '(%a+)%s*=%s*(%a+)')}, {'name', 'Anna'})

s = [[then he said: "it's all right"!]]
eq_array({string.match(s, "([\"'])(.-)%1")}, {'"', "it's all right"}, "function match (back ref)")
p = "%[(=*)%[(.-)%]%1%]"
s = "a = [=[[[ something ]] ]==]x]=]; print(a)"
eq_array({string.match(s, p)}, {'=', '[[ something ]] ]==]x'})

is(string.match(s, "%g"), "a", "match graphic char")

error_like(function () string.match("hello world", "%1") end,
           "^[^:]+:%d+: invalid capture index",
           "function match invalid capture")

error_like(function () string.match("hello world", "%w)") end,
           "^[^:]+:%d+: invalid pattern capture",
           "function match invalid capture")

is(string.rep('ab', 3), 'ababab', "function rep")
is(string.rep('ab', 0), '')
is(string.rep('ab', -1), '')
is(string.rep('', 5), '')
is(string.rep('ab', 3, ','), 'ab,ab,ab', "with sep")

is(string.reverse('abcde'), 'edcba', "function reverse")
is(string.reverse('abcd'), 'dcba')
is(string.reverse(''), '')

is(string.sub('abcde', 1, 2), 'ab', "function sub")
is(string.sub('abcde', 3, 4), 'cd')
is(string.sub('abcde', -2), 'de')
is(string.sub('abcde', 3, 2), '')

is(string.upper('Test'), 'TEST', "function upper")
is(string.upper('TeSt'), 'TEST')
is(string.upper(string.rep('Test', 10000)), string.rep('TEST', 10000))

is(string.pack('b', 0x31), '\x31', "function pack")
is(string.pack('>b', 0x31), '\x31')
is(string.pack('<b', 0x31), '\x31')
is(string.pack('>B', 0x91), '\x91')
is(string.pack('<B', 0x91), '\x91')
is(string.byte(string.pack('<h', 1)), 1)
is(string.byte(string.pack('>h', 1):reverse()), 1)
is(string.byte(string.pack('<H', 1)), 1)
is(string.byte(string.pack('>H', 1):reverse()), 1)
is(string.byte(string.pack('<l', 1)), 1)
is(string.byte(string.pack('>l', 1):reverse()), 1)
is(string.byte(string.pack('<L', 1)), 1)
is(string.byte(string.pack('>L', 1):reverse()), 1)
is(string.byte(string.pack('<j', 1)), 1)
is(string.byte(string.pack('>j', 1):reverse()), 1)
is(string.byte(string.pack('<J', 1)), 1)
is(string.byte(string.pack('>J', 1):reverse()), 1)
is(string.byte(string.pack('<T', 1)), 1)
is(string.byte(string.pack('>T', 1):reverse()), 1)
is(string.byte(string.pack('<i', 1)), 1)
is(string.byte(string.pack('>i', 1):reverse()), 1)
is(string.byte(string.pack('<I', 1)), 1)
is(string.byte(string.pack('>I', 1):reverse()), 1)
is(string.pack('i1', 0):len(), 1)
is(string.pack('i2', 0):len(), 2)
is(string.pack('i4', 0):len(), 4)
is(string.pack('i8', 0):len(), 8)
is(string.pack('i16', 0):len(), 16)
error_like(function () string.pack('i20', 0) end,
           "^[^:]+:%d+: integral size %(20%) out of limits %[1,16%]",
           "function pack out limit")

is(string.pack('!2 i1 i4', 0, 0):len(), 6)
is(string.pack('i1 Xb i1', 0, 0):len(), 2)
is(string.pack('i1 x x i1', 0, 0):len(), 4)

is(string.pack('c3', 'foo'), 'foo')
is(string.pack('z', 'foo'), 'foo\0')

error_like(function () string.pack('w', 0) end,
           "^[^:]+:%d+: invalid format option 'w'",
           "function pack invalid format")

error_like(function () string.pack('i1 Xz i1', 0, 0) end,
           "^[^:]+:%d+: bad argument #1 to 'pack' %(invalid next option for option 'X'%)",
           "function pack invalid next")

error_like(function () string.pack('i', 'foo') end,
           "^[^:]+:%d+: bad argument #2 to 'pack' %(number expected, got string%)",
           "function pack bad arg")

error_like(function () string.pack('c4', 'foo') end,
           "^[^:]+:%d+: bad argument #2 to 'pack' %(wrong length%)",
           "function pack wrong length")

is(string.unpack('<h', string.pack('>h', 1):reverse()), 1, "function unpack")
is(string.unpack('<H', string.pack('>H', 1):reverse()), 1)
is(string.unpack('<l', string.pack('>l', 1):reverse()), 1)
is(string.unpack('<L', string.pack('>L', 1):reverse()), 1)
is(string.unpack('<j', string.pack('>j', 1):reverse()), 1)
is(string.unpack('<J', string.pack('>J', 1):reverse()), 1)
is(string.unpack('<T', string.pack('>T', 1):reverse()), 1)
is(string.unpack('<i', string.pack('>i', 1):reverse()), 1)
is(string.unpack('<I', string.pack('>I', 1):reverse()), 1)
is(string.unpack('<f', string.pack('>f', 1.0):reverse()), 1.0)
is(string.unpack('<d', string.pack('>d', 1.0):reverse()), 1.0)
is(string.unpack('<n', string.pack('>n', 1.0):reverse()), 1.0)

is(string.unpack('c3', string.pack('c3', 'foo')), 'foo')
is(string.unpack('z', string.pack('z', 'foo')), 'foo')
is(string.unpack('s', string.pack('s', 'foo')), 'foo')

error_like(function () string.unpack('c4', 'foo') end,
           "^[^:]+:%d+: bad argument #2 to 'unpack' %(data string too short%)",
           "function unpack data too short")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
