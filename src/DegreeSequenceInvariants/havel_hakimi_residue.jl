
function havel_hakimi_residue(g::SimpleGraph{T},) where T <: Integer

    # Get the degree sequence of `g`.
    sequence = Graphs.degree(g)

    # Sort the degree sequence in descending order.
    sort!(sequence, rev=true)

    # Apply the Havel-Hakimi rule to the degree sequence until
    # the sequene only contains zeros.
    while apply!(HavelHakimiRule, sequence) end

    # Return the length of the sequence.
    return length(sequence)
end
