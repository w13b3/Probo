# Probo  <sub><sup>_Lua unit test framework_<sup><sub>

Compatible with [Lua 5.4]

## Test suite example
```Lua
local Suite = require("probo/suite")

local runInfo = {}  -- define a `runInfo` table before the do-end scope
do
    -- create a new test suite instance
    -- with <close> defined a garbage-collection cycle is performed at the end this scope
    local test <close> = Suite.New("Probo Suite example")
    local assert = test -- more readable separation between tests and asserts

    test.run = 1                        -- test suite variable

    function test.AlwaysPasses()        -- this is a defined test
        assert:Invokable(test)          -- multiple different asserts are available
    end

    test("Always Fails")                -- test is a decorator
    (function()                         -- with the decorator test names can have spaces
        assert:Fail()
    end)

    function test.FlakyTest()           -- failed tests in the first run can be rerun
        test.run = test.run + 1         -- if the option `rerunFailedTests` is set to true
        assert:Condition(test.run > 2)
    end

    local suiteOptions = {              -- a table with options
        stopOnFail       = false,       -- stops on first failed test
        silent           = false,       -- no output
        rerunFailedTests = true,        -- rerun failed tests
        sortedByName     = false        -- sort tests by name before the test run
    }

    -- run the above defined tests with the given options
    runInfo = test:Run(suiteOptions)    -- runInfo, a table with info about the run
end
```

## Create report
After a run a report can be made with the `runInfo` created by the run

```lua
local Report = require("probo/htmlreport")

local htmlReport = Report.Create(runInfo)  -- create a HTML report

-- save the report
local reportFile = io.open("probo_report.html", "w")
reportFile:write(htmlReport)
reportFile:close()
```

## Mock global functions
The behaviour of functions can be changed temporarily.

```lua
local Suite = require("probo/suite")
local Mock = require("probo/mock")

do
    local test <close> = Suite.New("Probo Mock example")
    local assert <const> = test
    local mock <close> = Mock.New()
    
    mock("string.reverse", function(str) return str end)
    
    test("global string.reverse function is mocked")
    (function()
        local given = "not reversed"
        local actual = string.reverse(given)
        assert:Equal(given, actual)
    end)
end

```

## Unit tests
Check out the [unit tests] that test the [Probo] unit test package.


## License
[Apache 2.0]


[Lua 5.4]: https://www.lua.org/manual/5.4/
[unit tests]: ./test/README.md "/test/README.md"
[Probo]: ./probo/suite.lua "probo.lua"
[Apache 2.0]: ./LICENSE.txt "LICENSE.txt"
