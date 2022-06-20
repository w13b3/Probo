# Probo  <sub><sup>_Lua unit test framework_<sup><sub>

Compatible with [Lua 5.4]

## Test suite example
```Lua
local Suite = require('probo')

local runInfo = {}  -- define a `runInfo` table outside the do-end scope
do
    -- create a new test suite instance
    -- with <close> defined a garbage-collection cycle is performed at the end this scope  
    local test <close> = Suite.New("Probo test suite")
    local assert = test -- more readable separation between tests and asserts
    
    test.run = 1                        -- test suite variable

    function test.AlwaysPasses()        -- this is a defined test
        assert:Invokable(test)          -- multiple different asserts are available
    end

    test([[Always Fails]])(function()   -- test is a decorator
        assert:Fail()                   -- with this the name of the test can have spaces
    end)

    function test.FlakyTest()           -- failed tests in the first run can be rerun
        test.run = test.run + 1         -- if the option `rerunFailedTests` is set to true
        assert:Condition(test.run > 2)
    end
    
    local suiteOptions = {              -- a table with options
        stopOnFail       = false,
        silent           = false,
        rerunFailedTests = true
    }

    -- run the above defined tests with the given options
    runInfo = test:Run(suiteOptions)    -- runInfo, a table with info about the run
end
```


## Unit tests
Check out the [unit tests] that test the [Probo] unit test package.


## License
[Apache 2.0]


[Lua 5.4]: https://www.lua.org/manual/5.4/
[unit tests]: ./test/README.md "/test/README.md"
[Probo]: ./probo.lua "probo.lua"
[Apache 2.0]: ./LICENSE.txt "LICENSE.txt"
