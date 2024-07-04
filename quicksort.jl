#General Array Manipulation
function swap!(array, index1, index2)
    array[index1], array[index2] = array[index2], array[index1]
    return nothing
end

function swap(array, index1, index2)
    array_copy = copy(array)
    array_copy[index1], array_copy[index2] = array_copy[index2], array_copy[index1]
    return array_copy
end

function quicksplit!(array)
    array_length = length(array)
    if iseven(array_length)
        pivot = array[array_length ÷ 2]
    else 
        pivot = array[(array_length + 1) ÷ 2]
    end
    array1 = Vector{Number}()
    array2 = Vector{Number}()
    for item in array
        if item < pivot
            push!(array1, item)
        else
            push!(array2, item)
        end
    end
    array = nothing
    return [array1, array2]
end

function quicksort(array)
    subdivisions = Any[array,]
    sorted = false
    counter = 1
    while !sorted

    #Length of list == 0
        if length(subdivisions[counter]) == 0 #Will only happen in the list has identical items only, or if no item is smaller than pivot;  PIVOT IS CONFIRMED TO BE THE SMALLEST NUM IN LIST
            deleteat!(subdivisions, counter) #delete the empty array, now the item at this index is the previrous list we splitted

            #SWAP PIVOTAl ITEM WITH FIRST ITEM
            if iseven(length(subdivisions[counter]))
                temp_pivot_index = length(subdivisions[counter]) ÷ 2
                swap!(subdivisions[counter], temp_pivot_index, 1)
            else
                temp_pivot_index = (length(subdivisions[counter]) + 1) ÷ 2
                swap!(subdivisions[counter], temp_pivot_index, 1)
            end


            #Check if there is any item other than pivot, if no then all items are identical, and counter can be incremented
            temp_all_indentical = true
            temp_index = 2
            for item in subdivisions[counter][2:end]
                if item != subdivisions[counter][1] #As the Pivot has been placed at the first index now
                    temp_all_indentical = false
                    swap!(subdivisions[counter], temp_pivot_index, temp_index)
                    break
                end
                temp_index += 1
            end
            if temp_all_indentical
                counter += 1
            end
            
    #Length of list == 1        
        elseif length(subdivisions[counter]) == 1
            counter += 1
        
    #Length of list == 2
        elseif length(subdivisions[counter]) == 2
            if subdivisions[counter][2] < subdivisions[counter][1]
                swap!(subdivisions[counter], 1, 2)
            end
            counter += 1 


    
        else
            splice!(subdivisions, counter, quicksplit!(subdivisions[counter]))
            # print("◌ ") ##PRINT
        end
        # println(subdivisions) ##PRINT


        #Break while loop when sorted
        if counter > length(subdivisions)
            sorted = true
            break
        end
    end
    sorted_list = Number[]
    for list in subdivisions
        push!(sorted_list, list...)
    end
    return sorted_list
end

# quicksort([2, 3, 5, 7, 1, 9, 6, 8])
# quicksort([2, 1])
# quicksort([3,2,1,4])
# @time quicksort([rand(1:100, 100)...,])
        

# list = [rand(1:100, 100)...,]
# @time x = quicksort(list)
# @time sort(list)
# @time y = sort(list, alg = QuickSort)
        


function quicksort_rec!(array, start=1, stop=length(array))
    if start >= stop
        return array
    else
        index = partition!(array, start, stop)
        quicksort_rec!(array, start, index - 1)
        quicksort_rec!(array, index + 1, stop)
    end
end

function partition!(array, start, stop)
    pivot_index = start
    pivot_value = array[stop]
    i = start
    for _ in array[start:stop]
        if array[i] < pivot_value
            swap!(array, i, pivot_index)
            pivot_index += 1
        end
        i += 1
    end
    swap!(array, pivot_index, stop)
    return pivot_index
end
