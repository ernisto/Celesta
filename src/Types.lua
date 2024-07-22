--!strict
export type Dict<I, V> = {[I]: V}
export type Array<V> = {[number]: V}

export type State = {
    _dependencySet: Dict<State, boolean>,

    Destruct: () -> ()
}

export type Scoped<D> = Array<unknown> & D

export type Value<D> = State & {
    Get: () -> D,
    Set: (data: any, force: boolean?) -> (),
}

export type Computed<D> = State & {
    Get: () -> D
}

export type Merging = Dict<string, unknown>

export type Component<D> = typeof(setmetatable(
    {} :: {
        _name: string,
        _id: number,

        New: (data: Merging?) -> D,
    },
    {} :: {
        __call: (self: Component<D>, data: Merging?) -> D
    }
))

export type ComponentData<D> = Scoped<D & {
    _name: string,
    _id: number,

    Value: <data>(scope: Dict<unknown, unknown>, initialData: data?) -> Value<data>,
    Computed: <data>(scope: Dict<unknown, unknown>, result: (use: <VD>(value: Value<VD>) -> VD) -> D) -> Computed<D>,
    Clean: (scope: Dict<unknown, unknown>) -> (),
}>

export type Query<Q...> = {
    _no: Dict<number, Component<unknown>>,
    _need: Dict<number, Component<unknown>>,

    No: (self: Query<Q...>, ...Component<unknown>) -> Query<Q...>,
    Match: (self: Query<Q...>, storage: Dict<number, Component<unknown>>) -> boolean,

    --// This property doesnt really exist,
    --// it just holds the typepack
    _: (Q...) -> ()

}

export type Trait = typeof(setmetatable(
    {} :: {
        _entityMap: Dict<unknown, Scoped<unknown>>,
        _query: Query<unknown>,

        Kind: 'Trait',

        Apply: (entity: Entity, world: World, ...ComponentData<unknown>) -> (),
        Remove: (entity: Entity) -> (),
        isApplied: (entity: Entity) -> boolean
    },
    {} :: {
        __call: (self: Trait, ...any) -> ()
    }
))

export type Entity = {
    _id: number,
    _world: World,
    _storage: Dict<number, ComponentData<unknown>>,

    Get: EntityGet,
    Add: (self: Entity, ...ComponentData<unknown>) -> (),
    Remove: (self: Entity, ...Component<unknown>) -> (),
    Clear: (self: Entity) -> (),
    Destruct: (self: Entity) -> ()
}

export type EntityGet = (<D>(self: Entity, component: Component<D>) -> ComponentData<D>)
& (<D, D1>(self: Entity, component: Component<D>, component1: Component<D1>) -> (ComponentData<D>, ComponentData<D1>))
& (<D, D1, D2>(self: Entity, component: Component<D>, component1: Component<D1>, component2: Component<D2>) -> (ComponentData<D>, ComponentData<D1>, ComponentData<D2>))
& (<D, D1, D2, D3>(self: Entity, component: Component<D>, component1: Component<D1>, component2: Component<D2>, component3: Component<D3>) -> (ComponentData<D>, ComponentData<D1>, ComponentData<D2>, ComponentData<D3>))
& (<D, D1, D2, D3, D4>(self: Entity, component: Component<D>, component1: Component<D1>, component2: Component<D2>, component3: Component<D3>, component4: Component<D4>) -> (ComponentData<D>, ComponentData<D1>, ComponentData<D2>, ComponentData<D3>, ComponentData<D4>))
& (<D, D1, D2, D3, D4, D5>(self: Entity, component: Component<D>, component1: Component<D1>, component2: Component<D2>, component3: Component<D3>, component4: Component<D4>, component5: Component<D5>) -> (ComponentData<D>, ComponentData<D1>, ComponentData<D2>, ComponentData<D3>, ComponentData<D4>, ComponentData<D5>))
& (<D, D1, D2, D3, D4, D5, D6>(self: Entity, component: Component<D>, component1: Component<D1>, component2: Component<D2>, component3: Component<D3>, component4: Component<D4>, component5: Component<D5>, component6: Component<D6>) -> (ComponentData<D>, ComponentData<D1>, ComponentData<D2>, ComponentData<D3>, ComponentData<D4>, ComponentData<D5>, ComponentData<D6>))

export type World = {
    _storage: Dict<number, Entity>,
    _traits: Dict<Query<unknown>, Trait>,
    _nextId: number,
    _applyTraits: (self: World, entity: Entity) -> (),

    Import: (self: World, ...Trait | {Trait}) -> (),
    Entity: (self: World, ...ComponentData<unknown>) -> Entity
}

return 0