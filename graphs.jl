function random_backtracking_path(words, start, target)
    graph = Dict{String, Vector{String}}()

    for word in words
        graph[word] = [other for other in words if hamming(word, other) == 1]
    end

    function explore_path(current_word, path_length, graph, target, best_path, best_length, prev_node, unvisited, distances)
        # Check if we've reached the target word
        if current_word == target
            return best_path, best_length
        end
    
        # Early termination: Halt exploration if current path length is less than best_length - 1
        if path_length < best_length - 1
            return best_path, best_length
        end
    
        # Find neighboring words
        neighbors = graph[current_word]
    
        # If there are diversions, explore the last unvisited next node
        if length(neighbors) > 1
            while isempty(unvisited) == false
                next_word = pop!(unvisited)

                # Check if the next node is unvisited
                if !(next_word in best_path)
                    new_path, new_length = explore_path(next_word, path_length + 1, graph, target, best_path, best_length, current_word, unvisited, distances)

                    # If the new path is shorter, choose it
                    if new_length < best_length
                        return new_path, new_length
                    end
                end
            end
        else
            # Explore the next word
            next_word = neighbors[1]

            # Check if the next node is unvisited
            if !(next_word in best_path)
                return explore_path(next_word, path_length + 1, graph, target, best_path, best_length, current_word, unvisited, distances)
            end
        end

        return best_path, best_length
    end

    # Start the exploration from the start word with initial values
    unvisited = Set(words)
    current_node = start
    current_path_length = 0
    distances = Dict(word => Inf for word in words)

    best_path, best_length = explore_path(current_node, current_path_length, graph, target, [start], Inf, start, unvisited, distances)

    # Continue exploration until reaching a length one shorter than best path length, a dead end, or the target node
    while current_path_length >= best_length - 1 && current_node != target
        neighbors = graph[current_node]
        if isempty(neighbors) || all(neighbor in best_path for neighbor in neighbors)
            # Dead end or all neighbors are already visited
            current_path_length -= 1
            current_node = best_path[end - 1]
        else
            # Explore the last unvisited next node
            next_word = filter(word -> !(word in best_path), neighbors)[end]
            new_path, new_length = explore_path(next_word, current_path_length + 1, graph, target, best_path, best_length, current_node, unvisited, distances)
            
            # If the new path is shorter, choose it
            if new_length < best_length
                best_path = new_path
                best_length = new_length
            end

            current_node = next_word
            current_path_length += 1
        end
    end

    # Return the best path and its length
    return best_path, best_length
end

function bfs(graph, start, target)
    visited = Set{String}()
    queue = [[start]]

    while !isempty(queue)
        path = popfirst!(queue)
        current_word = last(path)

        if current_word == target
            return path
        end

        if !(current_word in visited)
            push!(visited, current_word)

            for neighbor in graph[current_word]
                if !(neighbor in visited)
                    push!(queue, [path..., neighbor])
                end
            end
        end
    end

    return []
end

function hamming(s1, s2)
    return sum(ch1 != ch2 for (ch1, ch2) in zip(s1, s2))
end






# The Test 
word_list = ["cat", "dat", "dot", "dog", "cog"]
start_word = "cat"
target_word = "cog"


# Test the random backtracking approach

@time random_backtracking_path(word_list, start_word, target_word)

# Test the BFS approach
@time begin
    graph = Dict{String, Vector{String}}()
    for word in word_list
        graph[word] = [other for other in word_list if hamming(word, other) == 1]
    end
    bfs(graph, start_word, target_word)
end