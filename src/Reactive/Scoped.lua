--// Packages
local JoinData = require(script.Parent.Parent.Utils.JoinData)

local Types = require(script.Parent.Parent.Types)
type Scoped<D> = Types.Scoped<D>

local function Scope(...: Types.Dict<unknown, unknown>)
    
    local proxy = {}
    proxy.__index = proxy

    for _, object in { ... } do
        assert(typeof(object) == 'table', 'Merge table needs to be a table')

        JoinData(object, proxy)
    end

    local scope = {}
    
    setmetatable(scope, proxy)

    return scope
end

return Scope :: (() -> Scoped<{}>)
& (<A>(A & {}) -> Scoped<A>)
& (<A, B>(A & {}, B & {}) -> Scoped<A & B>)
& (<A, B, C>(A & {}, B & {}, C & {}) -> Scoped<A & B & C>)
& (<A, B, C, D>(A & {}, B & {}, C & {}, D & {}) -> Scoped<A & B & C & D>)
& (<A, B, C, D, E>(A & {}, B & {}, C & {}, D & {}, E & {}) -> Scoped<A & B & C & D & E>)
& (<A, B, C, D, E, F>(A & {}, B & {}, C & {}, D & {}, E & {}, F & {}) -> Scoped<A & B & C & D & E & F>)