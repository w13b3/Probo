# Probo reporting  <sub><sup>_Results of the test_<sup><sub>

Reporting is optional.  


## Test suite reporting example
```Lua
-- load the modules
local Suite = require('probo')
local htmlreport = require('reporting/htmlreport')

-- assure that runInfo is defined out of the do-end scope 
local runInfo = {}

-- create and run the test suite
do
    local test <close> = Suite.New("Probo reporting")
    local assert = test
    
    test([[Test Pass]])(function() assert:Pass() end)
    test([[Test Fail]])(function() assert:Fail() end)
    
    runInfo = test:Run()  -- overwrite the runInfo
end

-- pass the runInfo to the htmlReport.Create function
local htmlReport = htmlreport.Create(runInfo)

-- create a new file and write the html report to it
local outputFile = io.open("report.html", "w")
outputFile:write(htmlReport)
outputFile:close()
```  