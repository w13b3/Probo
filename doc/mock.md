# Probo Mock  <sub><sup>_Simulate objects_<sup><sub>

Use mock at least as possible.  
Sometimes simulating objects is less expensive than using the actual object.  
For example: Simulating a database connection or the result of a heavy calculation.

```lua
-- prepare global functions, these can be loaded in from other modules

-- expensive function
function RecursiveFibonacci(num)
    if num <= 1 then
        return num
    else
        return (RecursiveFibonacci(num - 1) + RecursiveFibonacci(num - 2))
    end
end

-- function using the expensive function
function FibonacciPlusOne(num)
    return (RecursiveFibonacci(num) + 1)
end

-- load in Probo Suite and Mock
local Suite = require("probo/suite")
local Mock = require("probo/mock")


local runInfo = {}
do
    local test <close> = Suite.New("Probo Mock example")
    local assert <const> = test

    
    -- calculating the fibonacci number for 50 takes a while
    -- but the result is known so it is a good candidate for a mock that simulates the result
    test("Fibonacci plus one for the number 50")
    (function()
        local fib50 = 12586269025
        do
            -- create a mock and use it as short as possible
            -- it makes sure other tests doesn't use the mocked object
            local mock <close> = Mock.New()
            mock("RecursiveFibonacci", function() return fib50 end)

            -- `FibonacciPlusOne` uses the mocked `RecursiveFibonacci`
            local given = 50
            local expected = (fib50 + 1)
            local actual = FibonacciPlusOne(given)
            assert:Equal(actual, expected)

            -- also check if the mocked function is called
            local mockInfoTable = mock:Inspect("RecursiveFibonacci")
            assert:Equal(mockInfoTable.timesCalled, 1)

            -- <close> will reset the object back to original after the do-end scope
        end
    end)
    
    
    -- this test doesn't experience the mocked `RecursiveFibonacci`
    test("Fibonacci plus one for numbers 1 to 10")
    (function()
        local givenAndExpected = {
            [1] = 2, [2] = 2,  [3] = 3,  [4] = 4,  [5]  = 6,
            [6] = 9, [7] = 14, [8] = 22, [9] = 35, [10] = 56
        }
        for given, expected in pairs(givenAndExpected) do
            local actual = FibonacciPlusOne(given)
            assert:Equal(actual, expected)
        end
    end)
    
    
    runInfo = test:Run()
end
```
