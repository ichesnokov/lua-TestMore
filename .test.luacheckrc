codes = true
read_globals = {
    -- Test.More
    'plan',
    'done_testing',
    'skip_all',
    'BAIL_OUT',
    'ok',
    'nok',
    'is',
    'isnt',
    'like',
    'unlike',
    'cmp_ok',
    'type_ok',
    'subtest',
    'pass',
    'fail',
    'require_ok',
    'eq_array',
    'is_deeply',
    'error_is',
    'error_like',
    'lives_ok',
    'diag',
    'note',
    'skip',
    'todo_skip',
    'skip_rest',
    'todo',
    -- Test.Tester
    'test_out',
    'test_err',
    'test_fail',
    'test_diag',
    'test_test',
    'line_num',
    -- test suite
    'platform',
}

files['test/bail_out.t'].ignore = { '122/os' }
files['test/skipall.t'].ignore = { '122/os' }
files['test/skip.t'].ignore = { '511' }
files['test/skip_rest.t'].ignore = { '511' }
files['test/todo.t'].ignore = { '511' }

files['test_lua53/001-if.t'].ignore = { '511' }
files['test_lua53/102-function.t'].ignore = { '122/print' }
files['test_lua53/108-userdata.t'].ignore = { '122/io' }
files['test_lua53/201-assign.t'].ignore = { '411/my_i', '531', '532' }
files['test_lua53/211-scope.t'].ignore = { '421' }
files['test_lua53/231-metatable.t'].ignore = { '421', '431' }
files['test_lua53/304-string.t'].ignore = { '431' }
files['test_lua53/306-table.t'].ignore = { '431' }
files['test_lua53/308-io.t'].ignore = { '512' }

files['test_lua53/000-sanity.t'].globals = { 'f', 'g', 'i', 'j', 'k' }
files['test_lua53/001-if.t'].globals = { 'a', 'b' }
files['test_lua53/002-table.t'].globals = { 'a', 'i', 't' }
files['test_lua53/200-examples.t'].globals = { 'factorial' }
files['test_lua53/201-assign.t'].globals = { 'b' }
files['test_lua53/211-scope.t'].globals = { 'x' }
files['test_lua53/231-metatable.t'].globals = { 'new_a' }
files['test_lua53/301-basic.t'].globals = { 'norm', 'twice', 'foo', 'bar', 'baz', 't', 'i', 'X' }
files['test_lua53/303-package.t'].globals = { 'complex', 'cplx', 'a' }
files['test_lua53/304-string.t'].globals = { 'name', 'status' }
