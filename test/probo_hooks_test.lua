--[=[
    `Probo` Lua unit test framework
]=]

--[[
    Hooks tested:

        SuiteSetup
        SuiteTeardown
        Setup
        Teardown
        PassedHook
        FailedHook
]]

-- extend `package.path` so it can look in the parent directory
package.path = ("%s;../?.lua"):format(package.path)
-- add probo.lua to the script as `Suite`
local Suite = require("probo/suite")
local Report = require("probo/htmlreport")

local runInfo, combinedReport = {}, {}
local filename = "probo_hooks_test"      -- this file
local silentTests = false                -- true = no test output


--[[ test SuiteSetup ]]
runInfo = {}
do
    local testHasRun = false
    do
        local test <close> = Suite.New()

        function test:SuiteSetup()
            testHasRun = true
        end

        function test:test() end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("SuiteSetup is invoked")
        (function()
            assert:True(testHasRun)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test SuiteTeardown ]]
runInfo = {}
do
    local testHasRun = false
    do
        local test <close> = Suite.New()

        function test:SuiteTeardown()
            testHasRun = true
        end

        function test:test() end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("SuiteTeardown is invoked")
        (function()
            assert:True(testHasRun)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Setup ]]
runInfo = {}
do
    local testHasRun = false
    do
        local test <close> = Suite.New()

        function test:Setup()
            testHasRun = true
        end

        function test:test() end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("Setup is invoked")
        (function()
            assert:True(testHasRun)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test Teardown ]]
runInfo = {}
do
    local testHasRun = false
    do
        local test <close> = Suite.New()

        function test:Teardown()
            testHasRun = true
        end

        function test:test() end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("Teardown is invoked")
        (function()
            assert:True(testHasRun)
        end)

        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test PassedHook is invoked when the test is passed ]]
--[[ test FailedHook is not invoked when the test is passed ]]
runInfo = {}
do
    local testHasPassed = false
    local testHasFailed = false
    do
        local test <close> = Suite.New()

        function test:PassedHook()
            testHasPassed = true
        end

        function test:FailedHook()
            testHasFailed = true  -- should not be set in this Suite
        end

        function test:test()
            test:Pass()
        end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("PassedHook is invoked when the test has passed")
        (function()
            assert:True(testHasPassed)
        end)


        test("FailedHook is not invoked when the test has passed")
        (function()
            assert:False(testHasFailed)
        end)


        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)


--[[ test FailedHook is invoked when the test is failed ]]
--[[ test PassedHook is not invoked when the test is failed ]]
runInfo = {}
do
    local testHasPassed = false
    local testHasFailed = false
    do
        local test <close> = Suite.New()

        function test:PassedHook()
            testHasPassed = true  -- should not be set in this Suite
        end

        function test:FailedHook()
            testHasFailed = true
        end

        function test:test()
            test:Fail()
        end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("PassedHook is not invoked when the test has failed")
        (function()
            assert:False(testHasPassed)
        end)


        test("FailedHook is invoked when the test has failed")
        (function()
            assert:True(testHasFailed)
        end)


        runInfo = test:Run({
            silent=silentTests
        })
    end
end
combinedReport = Report.CombineRunInfo(combinedReport, runInfo)



--[[ test hook order ]]
runInfo = {}
do
    local SuiteSetupTime, SuiteTeardownTime, SetupTime, TeardownTime, testTime
    do
        local test <close> = Suite.New()

        function test:Setup()
            SetupTime = os.clock()
        end

        function test:Teardown()
            TeardownTime = os.clock()
        end

        function test:SuiteSetup()
            SuiteSetupTime = os.clock()
        end

        function test:SuiteTeardown()
            SuiteTeardownTime = os.clock()
        end

        function test:test()
            testTime = os.clock()
        end

        test:Run({silent = true})
    end
    do
        local test <close> = Suite.New()
        local assert <const> = test


        test("SuiteSetup is invoked before every other hook and test")
        (function()
            assert:Condition(SuiteSetupTime < SetupTime)
            assert:Condition(SuiteSetupTime < testTime)
            assert:Condition(SuiteSetupTime < TeardownTime)
            assert:Condition(SuiteSetupTime < SuiteTeardownTime)
        end)


        test("SuiteTeardown is invoked after every other hook and test")
        (function()
            assert:Condition(SuiteTeardownTime > SuiteSetupTime)
            assert:Condition(SuiteTeardownTime > SetupTime)
            assert:Condition(SuiteTeardownTime > testTime)
            assert:Condition(SuiteTeardownTime > TeardownTime)
        end)


        test("Setup is invoked before a test")
        (function()
            assert:Condition(SetupTime > SuiteSetupTime)
            assert:Condition(SetupTime < testTime)
            assert:Condition(SetupTime < TeardownTime)
            assert:Condition(SetupTime < SuiteTeardownTime)
        end)


        test("Teardown is invoked after a test")
        (function()
            assert:Condition(TeardownTime > SuiteSetupTime)
            assert:Condition(TeardownTime > SetupTime)
            assert:Condition(TeardownTime > testTime)
            assert:Condition(TeardownTime < SuiteTeardownTime)
        end)


        test("A test is invoked before Teardown and after Setup")
        (function()
            assert:Condition(testTime > SuiteSetupTime)
            assert:Condition(testTime > SetupTime)
            assert:Condition(testTime < TeardownTime)
            assert:Condition(testTime < SuiteTeardownTime)
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
    local htmlReport = Report.Create(combinedReport)

    -- create a html report
    local reportFile = io.open(("%s_report.html"):format(filename), "w")
    reportFile:write(htmlReport)
    reportFile:close()
end

return combinedReport, true
