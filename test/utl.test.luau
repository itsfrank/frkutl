local frktest = require("@frktest/frktest")
local test = frktest.test
local check = frktest.assert.check

local utl = require("../src")

return function()
    test.suite("Iter tests", function()
        test.case("for_each test", function()
            local a = { 1, 2, 3, 4 }
            local sum = 0
            utl.iter.for_each(a, function(v)
                sum += v
            end)
            check.equal(sum, 10)
        end)

        test.case("slice test", function()
            local a = { 1, 2, 3, 4 }
            local last_3 = utl.iter.slice(a, 2)
            check.array.equal(last_3, { 2, 3, 4 })
            local mid_2 = utl.iter.slice(a, 2, 2)
            check.array.equal(mid_2, { 2, 3 })
        end)

        test.case("filter test", function()
            local a = { 1, 20, 30, 4 }
            local res = utl.iter.filter(a, function(v)
                return v < 10
            end)
            check.array.equal(res, { 1, 4 })
        end)

        test.case("map test", function()
            local a = { 1, 2, 3, 4 }
            local res = utl.iter.map(a, function(v)
                return tostring(v)
            end)
            check.array.equal(res, { "1", "2", "3", "4" })
        end)

        test.case("map test with nil", function()
            local a = { 1, 2, 3, 4 }
            local res = utl.iter.map(a, function(v): string?
                if v == 2 then
                    return nil
                end
                return tostring(v)
            end)
            check.array.equal(res, { "1", nil, "3", "4" })
        end)

        test.case("zip test", function()
            local a = { 1, 2, 3, 4 }
            local b = { "1", "2", "3", "4" }
            local res = utl.iter.zip(a, b)
            check.table.equal(res, {
                { a = 1, b = "1" },
                { a = 2, b = "2" },
                { a = 3, b = "3" },
                { a = 4, b = "4" },
            })
        end)

        test.case("fold test", function()
            local a = { 1, 2, 3, 4 }
            local res = utl.iter.fold(a, "", function(acc, v)
                return acc .. tostring(v)
            end)
            check.equal(res, "1234")
        end)

        test.case("chain test", function()
            local a = { 0, 1, 2, 3, 4 }
            local b = { 0, 10, 2, 3, 4 }
            local sum = 0 -- used by foreach
            local res = utl.iter
                .chain(a)
                :zip(b)
                :slice(2)
                :filter(function(v)
                    return v.a == v.b
                end)
                :map(function(v: any)
                    return v.a + v.b
                end)
                :for_each(function(v)
                    sum += v
                end)
                :fold("", function(a, v)
                    return a .. tostring(v)
                end)

            check.equal(sum, 18)
            check.equal(res, "468")
        end)
    end)

    test.suite("Strs tests", function()
        test.case("split test", function()
            local got = utl.strs.split("1/2/3", "/")
            check.array.equal(got, { "1", "2", "3" })
        end)

        test.case("split test with empty", function()
            local got = utl.strs.split("1//3", "/")
            check.array.equal(got, { "1", "", "3" })
        end)
    end)
end
