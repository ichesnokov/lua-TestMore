#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2014, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Bitwise Library

=head2 Synopsis

    % prove 305-utf8.t

=head2 Description

Tests Lua UTF-8 Library

See "Lua 5.3 Reference Manual", section 6.5 "UTF-8 support",
L<http://www.lua.org/manual/5.3/manual.html#6.5>.

=cut

--]]

require 'Test.More'

plan(58)

is(utf8.char(65, 66, 67), 'ABC', "function char")
is(utf8.char(0x20AC), '\u{20AC}')
is(utf8.char(), '')

error_like(function () utf8.char(0, -1) end,
           "^[^:]+:%d+: bad argument #2 to 'char' %(value out of range%)",
           "function char (out of range)")

error_like(function () utf8.char(0, 'bad') end,
           "^[^:]+:%d+: bad argument #2 to 'char' %(number expected, got string%)",
           "function char (bad)")

is(utf8.charpattern, "[\0-\x7F\xC2-\xF4][\x80-\xBF]*", "charpattern")

local ap = {}
local ac = {}
for p, c in utf8.codes("A\u{20AC}3") do
    ap[#ap+1] = p
    ac[#ac+1] = c
end
eq_array(ap, {1, 2, 5}, "function codes")
eq_array(ac, {0x41, 0x20AC, 0x33})

local empty = true
for p, c in utf8.codes('') do
    empty = false
end
ok(empty, "codes (empty)")

error_like(function () utf8.codes() end,
           "^[^:]+:%d+: bad argument #1 to 'codes' %(string expected, got no value%)",
           "function codes ()")
error_like(function () utf8.codes(true) end,
           "^[^:]+:%d+: bad argument #1 to 'codes' %(string expected, got boolean%)",
           "function codes (true)")


is(utf8.codepoint("A\u{20AC}3"), 0x41, "function codepoint")
is(utf8.codepoint("A\u{20AC}3", 2), 0x20AC)
is(utf8.codepoint("A\u{20AC}3", -1), 0x33)
is(utf8.codepoint("A\u{20AC}3", 5), 0x33)
eq_array({utf8.codepoint("A\u{20AC}3", 1, 5)}, {0x41, 0x20AC, 0x33})
eq_array({utf8.codepoint("A\u{20AC}3", 1, 4)}, {0x41, 0x20AC})

error_like(function () utf8.codepoint("A\u{20AC}3", 6) end,
           "^[^:]+:%d+: bad argument #3 to 'codepoint' %(out of range%)",
           "function codepoint (out of range)")

error_like(function () utf8.codepoint("A\u{20AC}3", 8) end,
           "^[^:]+:%d+: bad argument #3 to 'codepoint' %(out of range%)",
           "function codepoint (out of range)")


is(utf8.len('A'), 1, "function len")
is(utf8.len(''), 0)
is(utf8.len("\u{41}\u{42}\u{43}"), 3)
is(utf8.len("A\u{20AC}3"), 3)

is(utf8.len('A', 1), 1)
is(utf8.len('A', 2), 0)
is(utf8.len('ABC', -1), 1)
is(utf8.len('ABC', -2), 2)

error_like(function () utf8.len('A', 3) end,
           "^[^:]+:%d+: bad argument #2 to 'len' %(initial position out of string%)",
           "function len (out of range)")


is(utf8.offset("A\u{20AC}3", 1), 1, "function offset")
is(utf8.offset("A\u{20AC}3", 2), 2)
is(utf8.offset("A\u{20AC}3", 3), 5)
is(utf8.offset("A\u{20AC}3", 4), 6) -- ?? nil
is(utf8.offset("A\u{20AC}3", 5), nil)
is(utf8.offset("A\u{20AC}3", 6), nil)
is(utf8.offset("A\u{20AC}3", -1), 5) -- ?? nil
is(utf8.offset("A\u{20AC}3", 1, 2), 2)
is(utf8.offset("A\u{20AC}3", 2, 2), 5)
is(utf8.offset("A\u{20AC}3", 3, 2), 6) -- ?? nil
is(utf8.offset("A\u{20AC}3", 4, 2), nil)
is(utf8.offset("A\u{20AC}3", -1, 2), 1)
is(utf8.offset("A\u{20AC}3", -2, 2), nil)
is(utf8.offset("A\u{20AC}3", 1, 5), 5)
is(utf8.offset("A\u{20AC}3", 2, 5), 6) -- ?? nil
is(utf8.offset("A\u{20AC}3", 3, 5), nil)
is(utf8.offset("A\u{20AC}3", -1, 5), 2)
is(utf8.offset("A\u{20AC}3", -2, 5), 1)
is(utf8.offset("A\u{20AC}3", -3, 5), nil)
is(utf8.offset("A\u{20AC}3", 1, 6), 6) -- ?? nil
is(utf8.offset("A\u{20AC}3", 2, 6), nil)
is(utf8.offset("A\u{20AC}3", 1, -1), 5)
is(utf8.offset("A\u{20AC}3", -1, -1), 2)
is(utf8.offset("A\u{20AC}3", -2, -1), 1)
is(utf8.offset("A\u{20AC}3", -3, -1), nil)
is(utf8.offset("A\u{20AC}3", 1, -4), 2)
is(utf8.offset("A\u{20AC}3", 2, -4), 5)
is(utf8.offset("A\u{20AC}3", -1, -4), 1)
is(utf8.offset("A\u{20AC}3", -2, -4), nil)

error_like(function () utf8.offset("A\u{20AC}3", 1, 7) end,
           "^[^:]+:%d+: bad argument #3 to 'offset' %(position out of range%)",
           "function offset (out of range)")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
