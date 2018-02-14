module SmallFixedSizeSets

export Set0, Set1, Set2, Set3, Set4, Set5, SmallFixedSizeSet
export SFSSFromOrderedVec, SFSSFromVec, SFSSFromSet
export SFSS_subset, SFSS_intersect, SFSS_setdiff, SFSS_union

const Set0 = NTuple{0,Int32}
const Set1 = NTuple{1,Int32}
const Set2 = NTuple{2,Int32}
const Set3 = NTuple{3,Int32}
const Set4 = NTuple{4,Int32}
const Set5 = NTuple{5,Int32}
const SmallFixedSizeSet = Union{Set0, Set1, Set2, Set3, Set4, Set5}

"""
SFSS_FromOrderedVec
----------

SFSSFromOrderedVec(v::Vector{Int32})

Create a small fixed-size set from a vector v

v must contain be of length at most 5
"""
function SFSSFromOrderedVec(v::Vector{Int32})
    if length(v) == 0; return Set0(); end
    if length(v) == 1; return Set1(v); end
    if length(v) == 2; return Set2(v); end
    if length(v) == 3; return Set3(v); end
    if length(v) == 4; return Set4(v); end
    if length(v) == 5; return Set5(v); end
    error("Set size is too large (maximum size is 5)")
end

SFSSFromOrderedVec(v::Vector{Int64}) =
    SFSSFromOrderedVec(convert(Vector{Int32}, v))
SFSSFromVec(v::Vector{Int64}) =
    SFSSFromOrderedVec(sort(v))
SFSSFromVec(v::Vector{Int32}) =
    SFSSFromOrderedVec(sort(v))
SFSSFromSet(S::Set{Int64}) =
    SFSSFromOrderedVec(sort(collect(S)))
SFSSFromSet(S::Set{Int32}) =
    SFSSFromOrderedVec(sort(collect(S)))

# Assumption: sets are sorted

# First set is size 0
SFSS_subset(A::Set0, B::Set0) = true
SFSS_subset(A::Set0, B::Set1) = true
SFSS_subset(A::Set0, B::Set2) = true
SFSS_subset(A::Set0, B::Set3) = true
SFSS_subset(A::Set0, B::Set4) = true
SFSS_subset(A::Set0, B::Set5) = true

# First set is size 1
SFSS_subset(A::Set1, B::Set0) = false
SFSS_subset(A::Set1, B::Set1) = (A == B)
function SFSS_subset(A::Set1, B::Set2)
    a1 = A[1]
    return a1 == B[1] || a1 == B[2]
end
function SFSS_subset(A::Set1, B::Set3)
    a1 = A[1]
    return a1 == B[1] || a1 == B[2] || a1 == B[3]
end
function SFSS_subset(A::Set1, B::Set4)
    a1 = A[1]
    return a1 == B[1] || a1 == B[2] || a1 == B[3] || a1 == B[4]
end
function SFSS_subset(A::Set1, B::Set5)
    a1 = A[1]; return a1 == B[1] || a1 == B[2] || a1 == B[3] || a1 == B[4] || a1 == B[5]
end

# First set is size 2
SFSS_subset(A::Set2, B::Set0) = false
SFSS_subset(A::Set2, B::Set1) = false
SFSS_subset(A::Set2, B::Set2) = (A == B)
function SFSS_subset(A::Set2, B::Set3)
    a1, a2 = A
    b1, b2, b3 = B
    if (a1 == b1) && (a2 == b2 || a2 == B[3]); return true; end
    if (a1 == b2) && (a2 == B[3]); return true; end
    return false
end
function SFSS_subset(A::Set2, B::Set4)
    a1, a2 = A
    b1, b2, b3, b4 = B
    if (a1 == b1) && (a2 == b2 || a2 == b3 || a2 == b4); return true; end
    if (a1 == b2) && (a2 == b3 || a2 == b4); return true; end
    if (a1 == b3) && (a2 == b4); return true; end
    return false
end
function SFSS_subset(A::Set2, B::Set5)
    a1, a2 = A
    b1, b2, b3, b4, b5 = B
    if (a1 == b1) && (a2 == b2 || a2 == b3 || a2 == b4 || a2 == b5); return true; end
    if (a1 == b2) && (a2 == b3 || a2 == b4 || a2 == b5); return true; end
    if (a1 == b3) && (a2 == b4 || a2 == b5); return true; end
    if (a1 == b4) && (a2 == b5); return true; end
    return false
end

# First set is size 3
SFSS_subset(A::Set3, B::Set0) = false
SFSS_subset(A::Set3, B::Set1) = false
SFSS_subset(A::Set3, B::Set2) = false
SFSS_subset(A::Set3, B::Set3) = (A == B)
function SFSS_subset(A::Set3, B::Set4)
    a1, a2, a3 = A
    b1, b2, b3, b4 = B
    if (a1 == b1)
        if (a2 == b2) && (a3 == b3 || a3 == b4); return true; end
        if (a2 == b3) && (a3 == b4); return true; end
    end
    if (a1 == b2) && (a2 == b3) && (a3 == b4); return true; end
    return false
end
function SFSS_subset(A::Set3, B::Set5)
    a1, a2, a3 = A
    b1, b2, b3, b4, b5 = B
    if (a1 == b1)
        if (a2 == b2) && (a3 == b3 || a3 == b4 || a3 == b5); return true; end
        if (a2 == b3) && (a3 == b4 || a3 == b5); return true; end
        if (a2 == b4) && (a3 == b5); return true; end
    end
    if (a1 == b2)
        if (a2 == b3) && (a3 == b4 || a3 == b5); return true; end
        if (a2 == b4) && (a3 == b5); return true; end
    end
    if (a1 == b3) && (a2 == b4) && (a3 == b5); return true; end
    return false
end

# First set is size 4
SFSS_subset(A::Set4, B::Set0) = false
SFSS_subset(A::Set4, B::Set1) = false
SFSS_subset(A::Set4, B::Set2) = false
SFSS_subset(A::Set4, B::Set3) = false
SFSS_subset(A::Set4, B::Set4) = (A == B)
function SFSS_subset(A::Set4, B::Set5)
    a1, a2, a3, a4 = A
    b1, b2, b3, b4, b5 = B
    if (a1 == b1)
        if (a2 == b2)
            if (a3 == b3) && (a4 == b4 || a4 == b5); return true; end
            if (a3 == b4 && a4 == b5); return true; end
        end
        if (a2 == b3 && a3 == b4 && a4 == b5); return true; end
    end
    if (a1 == b2 && a2 == b3 && a3 == b4 && a4 == b5); return true; end
    return false
end

# First set is size 5
SFSS_subset(A::Set5, B::Set0) = false
SFSS_subset(A::Set5, B::Set1) = false
SFSS_subset(A::Set5, B::Set2) = false
SFSS_subset(A::Set5, B::Set3) = false
SFSS_subset(A::Set5, B::Set4) = false
SFSS_subset(A::Set5, B::Set5) = (A == B)

"""
SFSS_intersect
-----------------

SFSS_intersect(A::SmallFixedSizeSet, B::SmallFixedSizeSet)

Returns the intersect of small fixed-size sets A and B as a small fixed-size set.
"""
function SFSS_intersect(A::SmallFixedSizeSet, B::SmallFixedSizeSet)
    intersect_vec = Int32[]
    Aind, Bind = 1, 1
    nA, nB = length(A), length(B)
    while Aind <= nA && Bind <= nB
        aval, bval = A[Aind], B[Bind]
        if aval == bval
            push!(intersect_vec, aval)
            Aind += 1
            Bind += 1
        elseif aval < bval; Aind += 1;
        else                Bind += 1;
        end
    end
    return SFSSFromOrderedVec(intersect_vec)
end

"""
SFSS_setdiff
------------

SFSS_setdiff(A::SmallFixedSizeSet, B::SmallFixedSizeSet)

Returns the elements in A that are not also in B as a small fixed-size set.
"""
function SFSS_setdiff(A::SmallFixedSizeSet, B::SmallFixedSizeSet)
    setdiff_vec = Int32[]
    Aind, Bind = 1, 1
    nA, nB = length(A), length(B)
    while Aind <= nA && Bind <= nB
        aval, bval = A[Aind], B[Bind]
        if aval == bval
            Aind += 1
            Bind += 1
        elseif aval < bval
            push!(setdiff_vec, aval)
            Aind += 1
        else
            Bind += 1
        end
    end
    while Aind <= nA
        push!(setdiff_vec, A[Aind])
        Aind += 1
    end
    return SFSSFromOrderedVec(setdiff_vec)
end

"""
SFSS_union
--------------

SFSS_union(A::SmallFixedSizeSet, B::SmallFixedSizeSet)

Returns the union of small fixed-size sets A and B.
"""
function SFSS_union(A::SmallFixedSizeSet, B::SmallFixedSizeSet)
    union_vec = Int32[]
    Aind, Bind = 1, 1
    nA, nB = length(A), length(B)
    while Aind <= nA && Bind <= nB
        aval, bval = A[Aind], B[Bind]
        if aval == bval
            push!(union_vec, aval)
            Aind += 1
            Bind += 1
        elseif aval < bval
            push!(union_vec, aval)
            Aind += 1
        else
            push!(union_vec, bval)
            Bind += 1
        end
    end
    while Aind <= nA
        push!(union_vec, A[Aind])
        Aind += 1
    end
    while Bind <= nB
        push!(union_vec, B[Bind])
        Bind += 1
    end
    return SFSSFromOrderedVec(union_vec)
end

end # module
