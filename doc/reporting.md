# Probo Reporting  <sub><sup>_Results of the test_<sup><sub>

Sharing a report of the test result is a great way to show confidence in the software.


## Probo report example
```Lua
-- load the modules
local Suite = require('probo/suite')
local Report = require('probo/htmlreport')

-- assure that runInfo is defined out of the do-end scope
local runInfo = {}

-- create and run the test suite
do
    local test <close> = Suite.New("Probo report example")
    local assert = test

    test([[Test Pass]])(function() assert:Pass() end)
    test([[Test Fail]])(function() assert:Fail() end)

    runInfo = test:Run()  -- overwrite the runInfo
end

-- pass the runInfo to the htmlReport.Create function
local htmlReport = Report.Create(runInfo)

-- create a new file and write the html report to it
local outputFile = io.open("report.html", "w")
outputFile:write(htmlReport)
outputFile:close()
```