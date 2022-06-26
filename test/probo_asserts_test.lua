--[=[
    `Probo` Lua unit test framework
]=]

--[[
    Asserts tested:

        Assert:Condition
        Assert:CreatesError
        Assert:CreatesNoError
        Assert:Equal
        Assert:Fail
        Assert:False
        Assert:Invokable
        Assert:Nil
        Assert:NotEqual
        Assert:NotNil
        Assert:Pass
        Assert:TableEmpty
        Assert:TableEquals
        Assert:TableHasSameKeys
        Assert:TableNotEmpty
        Assert:True
        Assert:Type
]]

-- extend `package.path` so it can look in the parent directory
package.path = ("%s;../?.lua"):format(package.path)
-- add probo.lua to the script as `Suite`
local Suite = require("probo/suite")
local Report = require("probo/htmlreport")
local Mock = require("probo/mock")

local runInfo, combinedReport = {}, {}
local filename = "probo_asserts_test"      -- this file
local silentTests = false                  -- true = no test output


--[[ test Assert:Condition ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Condition(true)
        end)

        test("failed")
        (function()
            resultFailed = assert:Condition(false)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Condition(false, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Condition")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:CreatesError ]]--
runInfo = {}
do
    local _error = error  -- this error won't be mocked
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:CreatesError(_error)  -- unmocked error
        end)

        test("failed")
        (function()
            resultFailed = assert:CreatesError(function() end)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:CreatesError")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 1)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 1)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:CreatesNoError ]]--
runInfo = {}
do
    local _error = error  -- this error won't be mocked
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:CreatesNoError(function() end)
        end)

        test("failed")
        (function()
            resultFailed = assert:CreatesNoError(_error)  -- unmocked error
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:CreatesNoError")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 1)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 1)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Equal ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Equal(1, 1)
        end)

        test("failed")
        (function()
            resultFailed = assert:Equal(1, 2)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Equal(1, 2, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Equal")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Fail ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("failed")
        (function()
            resultFailed = assert:Fail()
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Fail(message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Fail")
        local assert <const> = test

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 0)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:False ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:False(false)
        end)

        test("failed")
        (function()
            resultFailed = assert:False(true)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:False(true, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:False")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Invokable ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Invokable(function() end)
        end)

        test("failed")
        (function()
            resultFailed = assert:Invokable(nil)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Invokable(nil, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Invokable")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Nil ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Nil(nil)
        end)

        test("failed")
        (function()
            resultFailed = assert:Nil("nil")
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Nil("nil", message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Nil")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:NotEqual ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:NotEqual(1, 2)
        end)

        test("failed")
        (function()
            resultFailed = assert:NotEqual(1, 1)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:NotEqual(1, 1, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:NotEqual")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:NotNil ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:NotNil("nil")
        end)

        test("failed")
        (function()
            resultFailed = assert:NotNil(nil)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:NotNil(nil, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:NotNil")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Pass ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Pass()
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Pass")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 0)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 0)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableEmpty ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:TableEmpty( { } )
        end)

        test("failed")
        (function()
            resultFailed = assert:TableEmpty( { not {} } )  -- { false }
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:TableEmpty( { not {} }, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:TableEmpty")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableEquals ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        local actual <const> = {["a"]="a", ["b"]="b", ["c"]={1, 2, 3}}
        local expected <const> = {["c"]={1, 2, 3}, ["a"]="a", ["b"]="b"}
        local wrong <const> = {["a"]="a", ["c"]={9, 8, 7}, ["b"]="b"}

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:TableEquals(actual, expected)
        end)

        test("failed")
        (function()
            resultFailed = assert:TableEquals(actual, wrong)  -- { false }
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:TableEquals(actual, wrong, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:TableEquals")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableHasSameKeys ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        local same1 <const> = {["a"]=1, ["b"]=2, ["c"]=3}
        local same2 <const> = {["c"]=3, ["a"]=1, ["b"]=2, }
        local different <const> = {["a"]=1, ["b"]=2, ["c"]=3, ["d"]=4}

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:TableHasSameKeys(same1, same2)
        end)

        test("failed")
        (function()
            resultFailed = assert:TableHasSameKeys(same1, different)  -- { false }
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:TableHasSameKeys(same2, different, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:TableHasSameKeys")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableNotEmpty ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:TableNotEmpty( { not {} } )
        end)

        test("failed")
        (function()
            resultFailed = assert:TableNotEmpty( {} )  -- { false }
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:TableNotEmpty( {}, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:TableNotEmpty")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:True ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:True(true)
        end)

        test("failed")
        (function()
            resultFailed = assert:True(false)
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:True(false, message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:True")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:False ]]--
runInfo = {}
do
    local assertsPassed, assertsFailed, errorAmount = 0, 0, 0
    local resultPassed, resultFailed, customMessage
    local message = "customMessage"
    do
        local test <close> = Suite.New()
        local assert <const> = test
        local mock <close> = Mock.New()
        -- mocked error returns the given input
        -- Assert:AttemptFailed returns the `error`
        mock("error", function(...) return ... end)

        function test:SuiteTeardown()
            assertsPassed = test.attemptsSuccess
            assertsFailed = test.attemptsFailed
            errorAmount = mock:Inspect("error").timesCalled
        end

        test("passed")
        (function()
            resultPassed = assert:Type(1, "number")
        end)

        test("failed")
        (function()
            resultFailed = assert:Type(1, "string")
        end)

        test("custom message")
        (function()
            -- custom message is passed on to `error`
            customMessage = assert:Type(1, "string", message)
        end)

        test:Run({silent = true})  -- run the tests
    end
    do
        local test <close> = Suite.New("Assert:Type")
        local assert <const> = test

        test(("%s passed"):format(test.suiteName))
        (function()
            assert:True(resultPassed)
        end)

        test(("%s did fail as expected"):format(test.suiteName))
        (function()
            assert:Type(resultFailed, "string")  -- mocked error returns the given input
        end)

        test(("%s can have a custom error message"):format(test.suiteName))
        (function()
            assert:Equal(customMessage, message)  -- mocked error returns the given input
        end)

        test(("%s is invoked the expected amount of times"):format(test.suiteName))
        (function()
            assert:Equal(assertsPassed, 1)  -- amount of times the assert has passed
            assert:Equal(assertsFailed, 2)  -- should be the same as `errorAmount`
            assert:Equal(errorAmount, 2)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
--combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


-- create the last combinedReport with the filename as name
combinedReport = Report.CombineRunInfo(combinedReport, runInfo, filename)
if not silentTests then
    -- this wont print if any `assert` has been triggered
    io.write(("%s passed\n"):format(filename))
    local htmlReport = Report.Create(combinedReport)

    -- create a html report
    local reportFile = io.open(("%s_report.html"):format(filename), "w")
    reportFile:write(htmlReport)
    reportFile:close()
end

return combinedReport, true