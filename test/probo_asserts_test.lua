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
        Assert:TableEmpty
        Assert:TableEquals
        Assert:TableHasSameKeys
        Assert:TableNotEmpty
        Assert:True
        Assert:Type
]]

-- extend `package.path` so it can look in the parent directory (where probo.lua resides)
package.path = ("%s;../?.lua"):format(package.path)
-- add probo.lua to the script as `Suite`
local Suite = require("probo")
local report = require("reporting/htmlreport")

local combinedReport = {}
local filename = "probo_asserts_test"      -- this file
local silentTests = false                  -- true = no test output

local runInfo, pass, failed, customErrMsg  -- test values 


-- error mock
-- this makes tests always pass but error"s return the error message
local _error = error
local suppress = setmetatable({},{  -- this metatable mocks the error
    __call=(function()
        error = function(message, level) return message, level end
    end),
    __close=(function()
        error = _error  -- re-assign error
    end),
})


--[[ test Assert:Condition ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Condition")
        local assert = test

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:Condition(true)
        end)
    
        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:Condition(false)
        end)
    
        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Condition(false, "errorMessage")
        end)
    
        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:CreatesError ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:CreatesError")
        local assert = test

        local throwError <const> = function(...) _error() end  -- unsuppressed
        local wontError <const> = function(...) end

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:CreatesError(throwError)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:CreatesError(wontError)
        end)

        -- no custom error

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:CreatesNoError ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:CreatesNoError")
        local assert = test

        local throwError <const> = function(...) _error() end  -- unsuppressed
        local wontError <const> = function(...) end

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:CreatesNoError(wontError)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:CreatesNoError(throwError)
        end)

        -- no custom error

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Equal ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Equal")
        local assert = test

        local actual <const> = "actual"
        local expected <const> = "actual"
        local wrong <const> = "wrong"

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:Equal(actual, expected)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:Equal(actual, wrong)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Equal(actual, wrong, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Fail ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Fail")
        local assert = test

        -- no need to test pass

        test([[Assert:Fail ]])(function()
            failed = assert:Fail()
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Fail("errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end

assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:False ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:False")
        local assert = test

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:False(false)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:False(true)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:False(true, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Invokable ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Invokable")
        local assert = test

        local invokable <const> = function(...) end
        local notInvokable <const> = true

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:Invokable(invokable)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:Invokable(notInvokable)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Invokable(notInvokable, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Nil ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Nil")
        local assert = test

        local notNil <const> = (not nil)  -- true

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:Nil(nil)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:Nil(notNil)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Nil(notNil, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:NotEqual ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:NotEqual")
        local assert = test

        local actual <const> = "actual"
        local expected <const> = "wrong"
        local wrong <const> = "actual"

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:NotEqual(actual, expected)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:NotEqual(actual, wrong)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:NotEqual(actual, wrong, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:NotNil ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:NotNil")
        local assert = test

        local notNil <const> = (not nil)  -- true

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:NotNil(notNil)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:NotNil(nil)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:NotNil(nil, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableEmpty ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:TableEmpty")
        local assert = test

        local empty <const> = {}
        local notEmpty <const> = {not {}}  -- {false}

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:TableEmpty(empty)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:TableEmpty(notEmpty)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:TableEmpty(notEmpty, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableEqual ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:TableEqual")
        local assert = test

        local actual <const> = {["a"]="a", ["b"]="b", ["c"]={1, 2, 3}}
        local expected <const> = {["c"]={1, 2, 3}, ["a"]="a", ["b"]="b"}
        local wrong <const> = {["a"]="a", ["c"]={9, 8, 7}, ["b"]="b"}

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:TableEquals(actual, expected)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:TableEquals(actual, wrong)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:TableEquals(actual, wrong, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableHasSameKeys ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:TableHasSameKeys")
        local assert = test

        local same1 <const> = {["a"]=1, ["b"]=2, ["c"]=3}
        local same2 <const> = {["c"]=3, ["a"]=1, ["b"]=2, }
        local different <const> = {["a"]=1, ["b"]=2, ["c"]=3, ["d"]=4}

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:TableHasSameKeys(same1, same2)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:TableHasSameKeys(different, same1)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:TableHasSameKeys(same2, different, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:TableNotEmpty ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:TableNotEmpty")
        local assert = test

        local empty <const> = {}
        local notEmpty <const> = {not {}}  -- {false}

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:TableNotEmpty(notEmpty)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:TableNotEmpty(empty)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:TableNotEmpty(empty, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:True ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:True")
        local assert = test

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:True(true)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:True(false)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:True(false, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
combinedReport = report.CombineRunInfo(combinedReport, runInfo)


--[[ test Assert:Type ]]--
runInfo = {}
pass, failed, customErrMsg = false, nil, nil
do
    local _ <close> = suppress()  -- do temporary mock `error` until end
    do
        local test <close> = Suite.New("Assert:Type")
        local assert = test

        local actual <const> = "actual"
        local expected <const> = "string"
        local wrong <const> = "number"

        test(([[%s passed]]):format(test.suiteName))
        (function()
            pass = assert:Type(actual, expected)
        end)

        test(([[%s failed]]):format(test.suiteName))
        (function()
            failed = assert:Type(actual, wrong)
        end)

        test(([[%s with custom message]]):format(test.suiteName))
        (function()
            customErrMsg = assert:Type(actual, wrong, "errorMessage")
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
assert((pass == true), "test that should pass has failed")
assert((type(failed) == "string"), "error has not been thrown")
assert((customErrMsg == "errorMessage"), "error message has not been custom")
--combinedReport = report.CombineRunInfo(combinedReport, runInfo)


-- create the last combinedReport with the filename as name
combinedReport = report.CombineRunInfo(combinedReport, runInfo, filename)

if not silentTests then
    -- this wont print if any `assert` has been triggered
    io.write(("%s passed\n"):format(filename))
    local htmlReport = report.Create(combinedReport)
    print(htmlReport)
end

return combinedReport, true