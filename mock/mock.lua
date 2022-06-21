--[=[
    `Probo` Lua unit test framework
]=]

--[=[ Mock ]=]

---usage: `mock:reset("mockFuncName")`
---@param mockFuncName string mocked function to un-mock
local function reset(self, mockFuncName)
    local _Gfunc = self.mockFuncTable[mockFuncName]
    if _Gfunc ~= nil and type(_Gfunc) == "function" then
        _G[mockFuncName] = _Gfunc
    end
end


local function Mock()
    local _Mock = {  --[[ Table ]]
        mockFuncTable = {},
        reset = reset,  -- mock:reset function
    }
    local _MetaMock = { --[[ MetaTable ]]
        --Todo: create functionality so functions in nested tables can be mocked. like: string.reverse
        __call = (function(self, mockFuncName, replacementFunc)
            -- check if the given parameters are correct
            assert(type(mockFuncName) == "string", type(replacementFunc) == "function")
            local _Gfunc = _G[mockFuncName]
            -- check if the given name is a global function
            assert(_Gfunc ~= nil, ("'%s' is not a global function"):format(mockFuncName))
            -- add the function to the table, so it can be reset to original
            self.mockFuncTable[mockFuncName] = _Gfunc
            _G[mockFuncName] = replacementFunc
        end),
        -- if `<close>` is defined, un-mock all the mocked functions after the do-end scope
        __close = (function(self)
            for mockFuncName, _Gfunc in pairs(self.mockFuncTable) do
                _G[mockFuncName] = _Gfunc
            end
        end)
    }
    return setmetatable(_Mock, _MetaMock)
end


--[=[
    -- Mock example:

    -- create, or load in, a global function
    function returnString(input)
        return tostring(input)
    end


    do  -- all mocked functions between the do-end are reset at the end when using <close>
        local mock <close> = Mock()

        -- give the name of the function to mock as a string
        -- the given new function replaces the function to mock
        mock('returnString', function(input) return string.reverse(tostring(input)) end)

        -- use the function, perhaps in a test to control a certain state
        print(returnString("Reversed")) -- >stdout: desreveR
    end

    -- mocked functions are reset to their original
    print(returnString("Not reversed")) --> stdout: Not reversed

]=]


return Mock()