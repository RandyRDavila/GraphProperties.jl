"""
    compute(
        ::Type{MinimumProperColoring},
        g::SimpleGraph{T};
        optimizer = HiGHS.Optimizer
    ) where T <: Integer

Return the minimum proper coloring of `g` by solving a Binary Program.

# Arguments

- `g::SimpleGraph{T}`: The graph to compute the minimum proper coloring of.

# Keywords

- `optimizer=HiGHS.Optimizer`: The optimizer to use to solve the minimum proper coloring
  problem.

# Returns

- A `MinimumProperColoring` object representing the minimum proper coloring of `g`.

# Example

```jldoctest
julia> using Graphs

julia> using GraphProperties.Invariants

julia> g = SimpleGraph(5)
{5, 0} undirected simple Int64 graph

julia> add_edge!(g, 1, 2);

julia> add_edge!(g, 1, 3);

julia> add_edge!(g, 1, 4);

julia> add_edge!(g, 1, 5);

julia> compute(MinimumProperColoring, g)
MinimumProperColoring(Dict(5 => 2, 4 => 2, 2 => 2, 3 => 2, 1 => 1))
```
"""
function compute(
    ::Type{MinimumProperColoring},
    g::SimpleGraph{T};
    optimizer = HiGHS.Optimizer
) where T <: Integer

    # Instantiate the optimization model.
    model = Model(optimizer)
    JuMP.set_silent(model)

    # Get the vertices and edges of `g`.
    V = Graphs.vertices(g)
    E = Graphs.edges(g)

    # Decision variable for each vertex and color.
    @variable(model, x[V, V], Bin)
    @variable(model, y[V], Bin)

    # Constraint: Each vertex gets exactly one color
    @constraint(model, [v = V], sum(x[v, k] for k in V) == 1)

    # Constraint: Adjacent vertices cannot have the same color
    for e in E
        u, v = src(e), dst(e)
        @constraint(model, [k = V], x[u, k] + x[v, k] <= 1)
    end

    # Constraint: If a vertex is colored with k, color k is used
    @constraint(model, [v = V, k = V], x[v, k] <= y[k])

    # Constraint: Use the sequential nature of colors. A color k can be used only if color k-1 is used
    for k = 2:nv(g)
        @constraint(model, y[k] <= y[k-1])
    end

    # Objective: Minimize the number of colors used
    @objective(model, Min, sum(y))

    optimize!(model)

    # Extracting the color for each vertex
    vertex_colors = Dict{Int, Int}()
    for v in V
        for k in V
            if value(x[v, k]) > 0.5  # using 0.5 as a threshold due to potential numerical issues
                vertex_colors[v] = k
                break
            end
        end
    end
    return MinimumProperColoring(vertex_colors)
end