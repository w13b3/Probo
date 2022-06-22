--[=[
    `Probo` Lua unit test framework
]=]

--[=[ Mock ]=]

---@private
local function SplitName(mockFuncName)
    local nameParts = {}
    for namePart in string.gmatch(mockFuncName, "[^.]+") do  -- split on dot (.)
        table.insert(nameParts, namePart)
    end
    return nameParts
end

---@private
local function TableTrace(tbl, nameParts, valueOverwrite, idx)
    idx = idx or 1
    local namePart = nameParts[idx]
    local resultTable = {}
    local originalValue
    for key, value in pairs(tbl) do
        if key == namePart and type(value) == "table" then
            resultTable[key], originalValue = TableTrace(value, nameParts, valueOverwrite, idx + 1)  -- recursive
        elseif key == namePart then
            resultTable[key] = valueOverwrite or value
            originalValue = value
        end
    end
    return resultTable, originalValue
end

---@private
local function Merge(tbl1, tbl2)
    tbl2 = tbl2 or {}
    if type(tbl1) == 'table' and type(tbl2) == 'table' then
        for key, value in pairs(tbl2) do
            if type(value) == 'table' and type(tbl1[key]) == 'table' then
                Merge(tbl1[key], value)
            else
                tbl1[key] = value
            end
        end
    end
    return tbl1
end

---@private
local function CountCalls(self, replacementFunc, mockFuncName)
    local function InnerFunc(...)
        local current = self.mockInfo[mockFuncName].timesCalled
        self.mockInfo[mockFuncName].timesCalled = current + 1
        return replacementFunc(...)
    end
    return InnerFunc
end

---@private
local function Inspect(self, mockFuncName)
    return self.mockInfo[mockFuncName] or {}
end

---@private
local function Create(self, mockFuncName, replacementFunc)
    assert(type(mockFuncName) == "string" and type(replacementFunc) == "function")
    local nameParts = SplitName(mockFuncName)  -- split the name into a table
    local _GfuncPath, _Gfunc = TableTrace(_G, nameParts)  -- get the path to the Global function
    if _Gfunc == nil then
        return error("could not find the global function", 2)
    end

    Merge(self.mockFuncTable, _GfuncPath)  -- save the Global function to the `mockFuncTable`
    -- add the info to the `mockInfo` table
    self.mockInfo[mockFuncName] = {
        timesCalled = 0,
        replacementFunc = replacementFunc,
        originalFunc = _Gfunc,
    }
    -- replace the Global function in the path (sub-step to replace)
    local wrapFunc = CountCalls(self, replacementFunc, mockFuncName)
    local replaced_GfuncPath = TableTrace(_GfuncPath, nameParts, wrapFunc)
    Merge(_G, replaced_GfuncPath)  -- overwrite the Global function
end


---@private
local function Reset(self, mockFuncName)
    local nameParts = SplitName(mockFuncName)  -- split the name into a table
    -- get the path to the Global function
    local original_GfuncPath = TableTrace(self.mockFuncTable, nameParts)
    Merge(_G, original_GfuncPath)  -- overwrite the Global function
end

---@private
local function Close(self)
    for mockFuncName, _ in pairs(self.mockInfo) do
        self:Reset(mockFuncName)
    end
end


local Mock = {}
local MetaMock = {
    __index = Mock,
    __call = Create,  -- create by mock()
    __close = Close   -- release mocks with <close> at end of do-end
}

---@public
function Mock:New()
    local object = {
        -- each instance an own object-table
        mockFuncTable = {},
        mockInfo = {},
        Create = Create,
        Inspect = Inspect,
        Reset = Reset
    }
    for key, value in pairs(self or {}) do
        object[key] = value
    end
    return setmetatable(object, MetaMock)
end

--[=[
    -- Mock example
    do
        local mock <close> = Mock:New()
        mock("string.reverse", function(input) return input end)
        mock("print", function(...) return { ... } end)

        -- test 1
        local given = "abc"
        local actual = string.reverse(given)
        assert(actual == given)

        -- reset the mock
        mock:Reset("string.reverse")

        -- test 2
        local expected = "cba"
        actual = string.reverse(given)
        assert(actual == expected)

        print("No output")  -- check the console for this output
    end

    -- after do-end <close> resets all the mocked functions
    print("print un-mocked")
]=]

return Mock