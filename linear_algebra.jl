using LinearAlgebra

function matXvec(matrix::AbstractMatrix, vector::AbstractVector)
    product = vector .* 0
    for dim in 1:length(vector)
        index = 1
        for component in vector
            product[dim] += component * matrix[dim, index]
            index += 1
        end
    end
    return product
end

function transpose(A)
    dims = reverse(size(A))
    A_t = zeros(eltype(A), dims...)
    for i in 1:dims[1]
        for j in 1:dims[2]
            A_t[i, j] = A[j, i]
        end
    end
    return A_t
end

del_row(A, n) = A[1:end .!= n,: ]
del_column(A, n) = A[:, 1:end .!= n]
del_row_column(A, n, m) = A[1:end .!= n, 1:end .!= m]

conj([1 2 3; 4 5 6; 7 8 9])