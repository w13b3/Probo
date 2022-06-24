# Probo Suite  <sub><sup>_Results of the test_<sup><sub>


`suite.lua` is the heart of the framework.  
The tests can be defined in the Suite.  
The tests can be run by the Suite.  
The result of the tests is recorded by the Suite.  

---

##### Suite.New
> `Suite.New( suiteName )`

`Suite.New` returns a Suite instance.  
`suiteName` should be a string that represents the name of the Suite.  
It can be a name of the target that the tests in the Suite will test.  

#### The Suite instance
The code below is what is referred to in the sections below.
```lua
local test <close> = Suite.New()
```

### test
> `test( testName )`

`test` is both the instance of the Suite and a function.  
When `test` is called it returns another function which itself has one parameter, also for a function.  
With better terms, `test` is a decorator.  

This functionality allows for tests to have names with spaces.  
Below is example code showing how to use `test` as a decorator.

```lua
test("Test that 2 is larger than 1")
(function()
    if 2 > 1 then
        error("2 is somehow smaller than 1")
    end
end)
```
Notice the parentheses surrounding the function after `test`.  
This is necessary.  
The example code can be re-written as below.
```lua
local function testTwoIsLargerThanOne()
    if 2 < 1 then
        error("2 is somehow smaller than 1")
    end
end
local definedTest = test("Test that 2 is larger than 1")
definedTest(testTwoIsLargerThanOne)
```
The first example is generally less typing and more readable.  

##### test:Run
>test:Run( options )

The `options` is an optional table.  
```lua
options = {
    stopOnFail       = boolean (default false),  -- stop the tests after the first failure
    silent           = boolean (default false),  -- no output during tests
    rerunFailedTests = boolean (default false),  -- rerun the failed tests if failures has happened
    sortedByName     = boolean (default false)   -- sorts the tests by name before the run of the tests
}
```

`test:Run` returns a table with the results of the tests that are defined in the Suite.  
Below an example of the data in the returned table.  

```lua
runInfo = {
    suiteName = "Probo Suite example",
    runSuccess = false,
    startTime  = 725893261,
    endTime    = 725893265,
    runTime    = 4.000175,
    amountExecuted = 3.0,
    amountFailed   = 2.0,
    amountPassed   = 1.0,
    totalExecuted  = 5.0,
    totalFailed    = 3.0,
    totalPassed    = 2.0,
    definedTests = {
        ["Always Fails"] = <function 1>,
        AlwaysPasses     = <function 2>,
        FlakyTest        = <function 3>
    },
    executedTests = { ["Always Fails"], "FlakyTest", "AlwaysPasses" },
    failedTests = {
        ["Always Fails"] = "Test Failed",
        FlakyTest = "Assert:Condition failed, value: false"
    },
    options = {
        rerunFailedTests = true,
        silent           = false,
        stopOnFail       = false,
        sortedByName     = false
    },
    passedTests = {
        AlwaysPasses = "AlwaysPasses passed"
    },
    rerunInfo = {
        amountExecuted = 2.0,
        amountFailed   = 1.0,
        amountPassed   = 1.0,
        definedTests = {
            ["Always Fails"] = <function 1>,
            FlakyTest        = <function 3>
        },
        executedTests = { ["Always Fails"], "FlakyTest" },
        failedTests = {
            ["Always Fails"] = "Test Failed"
        },
        passedTests = {
            FlakyTest = "FlakyTest passed"
        }
    }
}
```

##### \<close\>

`<close>` is an option which can only be used when the Suite is instantiated in a `do` `end` scope.  
The function bound to `Suite.__close` is invoked at the end of the scope.  
This function starts a full garbage-collection cycle.  


### TestHooks

These functions can be redefined in the Suite.  
These functions will be invoked in certain parts of the test run.

##### SuiteSetup
> `test:SuiteSetup()`

This function is invoked at the start of the Suite run, before any of the tests.

##### SuiteTeardown
> `test:SuiteTeardown()`

This function is invoked at the end of the Suite run, after all the tests are done.

##### Setup
> `test:Setup()`

This function is invoked before every test.

##### Teardown
> `test:Teardown()`

This function is invoked after every test.

##### PassedHook
> `test:PassedHook()`

This function is invoked when a test passes.

##### FailedHook
> `test:FailedHook()`

This function is invoked when a test fails.
