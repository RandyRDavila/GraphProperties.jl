

"""
    matching_number(g::SimpleGraph; optimizer=HiGHS.Optimizer)

Return the [matching number](https://en.wikipedia.org/wiki/Matching_(graph_theory)) of `g`.

### Implementation Notes
This function relies on `maximum_matching` to obtain a maximum matching of `g`.

### Example
```jldoctest
julia> using Graphs

julia> using GraphInvariants

julia> g = cycle_graph(5)
{5, 5} undirected simple Int64 graph

julia> matching_number(g)
2
```
"""
function matching_number(
    g::SimpleGraph{T};
    optimizer=HiGHS.Optimizer
) where T <: Integer

    max_ms = compute(MaximumMatching, g; optimizer=optimizer)

    return length(max_ms.edges)
end
