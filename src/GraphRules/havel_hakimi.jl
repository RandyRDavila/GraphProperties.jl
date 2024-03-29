
"""
    apply!(::Type{HavelHakimiRule}, sequence::Vector{Int})

Apply the Havel-Hakimi rule to the given sequence.

The Havel-Hakimi rule is a graphical sequence test that determines if a given sequence is
graphical. One step of the rule is to remove the largest number, d1, from the sequence and
subtract 1 from the next d1 numbers in the sorted sequence. If the sequence is all zeros, then
the original sequence is graphical. If the rule cannot be applied to the sequence, then
the sequence is not graphical. This method applies one iteration of the Havel-Hakimi rule
to a given sequence in-place and returns true if the rule was applied successfully.
Otherwise, a DomainError is thrown. Note: if the sequence is not already sorted in
non-increasing order, it will be sorted in-place.

# Arguments
- sequence::Vector{Int}: A sequence of integers.

# Returns
true if the rule was applied successfully, otherwise a DomainError is thrown.

# Example
```jldoctest
julia> using GraphProperties.GraphRules

julia> D = [3, 3, 2, 2, 1, 1];

julia> apply!(HavelHakimiRule, D)
true

julia> D
5-element Vector{Int64}:
 2
 1
 1
 1
 1
```
"""

function apply!(
    ::Type{HavelHakimiRule},
    sequence::Vector{T}
) where T <: Integer

    # Base case: if sequence is all zeros, return false
    # meaning we cannot apply the rule again to the sequence
    all(d == 0 for d in sequence) && return false

    # Sort the sequence in non-increasing order
    sort!(sequence, rev=true)

    # If the first number is greater than the length of the sequence or is negative, it's not graphical
    if sequence[1] < 0 || sequence[1] > length(sequence) - 1
        throw(
            DomainError(
                sequence[1],
                "The sequence is not graphical"
        ))
    end

    # Remove the first number and subtract 1 from the next set of numbers
    Δ = sequence[1]
    for i in 2:(Δ + 1)
        sequence[i] -= 1
        if sequence[i] < 0
            throw(
                DomainError(
                    sequence[i],
                    "The sequence is not graphical"
            ))
        end
    end

    # Remove the first number
    deleteat!(sequence, 1)

    # Return true if we can apply the rule again to the sequence
    return true
end

"""
    apply!(::Type{HavelHakimiRule}, sequence::Vector{Int}, eliminations::Vector{Int})

Apply the Havel-Hakimi rule to the given sequence.

The Havel-Hakimi rule is a graphical sequence test that determines if a given sequence is
graphical. One step of the rule is to remove the largest number, d1, from the sequence and
subtract 1 from the next d1 numbers in the sorted sequence. If the sequence is all zeros,
then the original sequence is graphical. If the rule cannot be applied to the sequence,
then the sequence is not graphical. This method applies one iteration of the Havel-Hakimi
rule to a given sequence in-place and returns true if the rule was applied successfully.
Otherwise, a DomainError is thrown. Note: if the sequence is not already sorted in
non-increasing order, it will be sorted in-place.

# Arguments
- sequence::Vector{Int}: A sequence of integers.
- eliminations::Vector{Int}: A vector to store the eliminations.

# Returns
true if the rule was applied successfully, otherwise a DomainError is thrown.

# Example
```jldoctest
julia> using GraphInvariants

julia> D = [3, 3, 2, 2, 1, 1];

julia> eliminations = Int[];

julia> apply!(HavelHakimiRule, D, eliminations)
true

julia> D
5-element Vector{Int64}:
 2
 1
 1
 1
 1

julia> eliminations
1-element Vector{Int64}:
 3
```
"""
function apply!(
    ::Type{HavelHakimiRule},
    sequence::Vector{T},
    eliminations::Vector{T}
) where T <: Integer

    # If sequence is all zeros, add these zeros to
    # the eliminations vector and returr false meaning
    # we cannot apply the rule again to the sequence
    if all(d == 0 for d in sequence)
        for _ in eachindex(sequence)
            push!(elimnations, 0)
        end

        return true
    end

    # Sort the sequence in non-increasing order
    sort!(sequence, rev=true)

    # If the first number is greater than the length of the sequence or is negative, it's not graphical
    if sequence[1] < 0 || sequence[1] > length(sequence) - 1
        throw(
            DomainError(
                sequence[1],
                "The sequence is not graphical"
        ))
    end

    # Remove the first number and subtract 1 from the next set of numbers
    Δ = sequence[1]
    for i in 2:(Δ + 1)
        sequence[i] -= 1
        if sequence[i] < 0
            throw(
                DomainError(
                    sequence[i],
                    "The sequence is not graphical"
            ))
        end
    end

    # Add the first number to the eliminations vector
    push!(eliminations, Δ)

    # Remove the first number
    deleteat!(sequence, 1)

    # Return true if we can apply the rule again to the sequence
    return true
end