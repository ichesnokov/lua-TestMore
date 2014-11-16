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

=head1 Lua Mathematic Library

=head2 Synopsis

    % prove 307-math.t

=head2 Description

Tests Lua Mathematic Library

See "Lua 5.3 Reference Manual", section 6.7 "Mathematical Functions",
L<http://www.lua.org/manual/5.3/manual.html#6.7>.

See "Programming in Lua", section 18 "The Mathematical Library".

=cut

--]]

require 'Test.More'

plan(47)

like(tostring(math.pi), '^3%.14', "variable pi")

type_ok(math.huge, 'number', "variable huge")

is(math.abs(-12.34), 12.34, "function abs")
is(math.abs(12.34), 12.34)

like(math.acos(0.5), '^1%.047', "function acos")

like(math.asin(0.5), '^0%.523', "function asin")

like(math.atan(0.5), '^0%.463', "function atan")

if (platform and platform.compat) or jit then
    like(math.atan2(1, 2), '^0%.463', "function atan2")
else
    is(math.atan2, nil, "function atan2 (removed)")
end

is(math.ceil(12.34), 13, "function ceil")
is(math.ceil(-12.34), -12)

like(math.cos(0), '^1%.?', "function cos")

if (platform and platform.compat) or jit then
    like(math.cosh(0), '^1%.?', "function cosh")
else
    is(math.cosh, nil, "function cosh (removed)")
end

is(math.deg(math.pi), 180, "function deg")

like(math.exp(1.0), '^2%.718', "function exp")

is(math.floor(12.34), 12, "function floor")
is(math.floor(-12.34), -13)

is(math.fmod(7, 3), 1, "function fmod")
is(math.fmod(-7, 3), -1)

if (platform and platform.compat) or jit then
    eq_array({math.frexp(1.5)}, {0.75, 1}, "function frexp")
else
    is(math.frexp, nil, "function frexp (removed)")
end

if (platform and platform.compat) or jit then
    is(math.ldexp(1.2, 3), 9.6, "function ldexp")
else
    is(math.ldexp, nil, "function ldexp (removed)")
end

like(math.log(47), '^3%.85', "function log")
like(math.log(47, 2), '^5%.554', "function log (base 2)")
like(math.log(47, 10), '^1%.672', "function log (base 10)")

if (platform and platform.compat) or jit then
    like(math.log10(47), '^1%.672', "function log10")
else
    is(math.log10, nil, "function log10 (removed)")
end

error_like(function () math.max() end,
           "^[^:]+:%d+: bad argument #1 to 'max' %(.- expected",
           "function max 0")

is(math.max(1), 1, "function max")
is(math.max(1, 2), 2)
is(math.max(1, 2, 3, -4), 3)

error_like(function () math.min() end,
           "^[^:]+:%d+: bad argument #1 to 'min' %(.- expected",
           "function min 0")

is(math.min(1), 1, "function min")
is(math.min(1, 2), 1)
is(math.min(1, 2, 3, -4), -4)

eq_array({math.modf(2.25)}, {2, 0.25}, "function modf")

if (platform and platform.compat) or jit then
    is(math.pow(-2, 3), -8, "function pow")
else
    is(math.pow, nil, "function pow (removed)")
end

like(math.rad(180), '^3%.14', "function rad")

like(math.random(), '^%d%.%d+', "function random no arg")

like(math.random(9), '^%d$', "function random 1 arg")

like(math.random(10, 19), '^1%d$', "function random 2 arg")

if jit then
    todo("LuaJIT intentional. Don't check empty interval.", 2)
end
error_like(function () math.random(0) end,
           "^[^:]+:%d+: bad argument #1 to 'random' %(interval is empty%)",
           "function random empty interval")

error_like(function () math.random(19, 10) end,
           "^[^:]+:%d+: bad argument #%d to 'random' %(interval is empty%)",
           "function random empty interval")

if jit then
    todo("LuaJIT intentional. Don't care about extra arguments.")
end
error_like(function () math.random(1, 2, 3) end,
           "^[^:]+:%d+: wrong number of arguments",
           "function random too many arg")

math.randomseed(12)
a = math.random()
math.randomseed(12)
b = math.random()
is(a, b, "function randomseed")

like(math.sin(math.pi/2), '^1%.?', "function sin")

if (platform and platform.compat) or jit then
    like(math.sinh(1), '^1%.175', "function sinh")
else
    is(math.sinh, nil, "function sinh (removed)")
end

like(math.sqrt(2), '^1%.414', "function sqrt")

like(math.tan(math.pi/3), '^1%.732', "function tan")

if (platform and platform.compat) or jit then
    like(math.tanh(1), '^0%.761', "function sinh")
else
    is(math.tanh, nil, "function tanh (removed)")
end

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
