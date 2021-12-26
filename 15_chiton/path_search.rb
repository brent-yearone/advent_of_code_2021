# Implementation of the A* pathfinding algorithm. Hat-tip to https://github.com/MatteoRagni/ruby-astar

class PathSearch

  def initialize(map, start_node, stop_node)
    [start_node, stop_node].each do |e|
      raise ArgumentError, 
        "Required a Node as input." +
        "Received a #{e.class}" unless e.is_a? Node
    end
    
    # Let's register a starting node and a ending node
    @map = map
    @start_node = start_node
    @stop_node  = stop_node
    
    # There will be two sets at the center of the algorithm.
    # The first is the openset, that is the set that contains
    # all the nodes that we have not explored yet.
    # It is initialized with only the starting node.
    @openset = [@start_node]
    # The closed set is the second set that contains all
    # the nodes that have already been explored and are in our
    # path or are failing strategy
    @closedset = []
  end
  
  def search
    # The search continues until there are nodes in the openset
    # If there are no nodes, the path will be an empty list.
    while @openset.size > 0
      # The next node is the one that has the minimum distance
      # from the origin and the minimum distance from the exit.
      # Thus it should have the minimum value of f.
      node = openset_min_search_criterion()
      
      # If the next node selected is the stop node we are arrived.
      if node == @stop_node
        # And we can return the path by reconstructing it 
        # recursively backward.
        return reconstruct_path(node)
      end
      
      # We are now inspecting the node x. We have to remove it
      # from the openset, and to add it to the closedset.
      @openset -= [node]
      @closedset += [node]
      
      # Let's test all the nodes that are near to the current one
      node.neighbor_coordinates.each do |x,y|
        next unless @map[[x,y]] # Ensure we're not out of bounds
        
        neighbor_node = @map[[x,y]]

        # Obviously, we do not analyze the current node if it
        # is already in the closed set
        next if @closedset.include?(neighbor_node)


        # Let's make an evaluation of the distance from the 
        # starting point. We can evaluate the distance in a way
        # that we actually get a correct valu of distance.
        # It must be saved in a temporary variable, because 
        # it must be checked against the distance_to_start score inside the node
        # (if it was already evaluated)
        distance_to_start = node.distance_to_start + node.risk
        
        # There are three condition to be taken into account
        #  1. neighbor_node is not in the openset. This is always an improvement
        #  2. neighbor_node is in the openset, but the new distance_to_start is lower
        #     so we have found a better strategy to reach neighbor_node
        #  3. neighbor_node has already a better distance_to_start, or in any case
        #     this strategy is not an improvement
        
        # First case: the neighbor_node point is a new node for the openset
        # thus it is an improvement
        if not @openset.include?(neighbor_node)
          @openset += [neighbor_node]
          improving = true
        # Second case: the neighbor_node point was already into the openset
        # but with a value of distance_to_start that is lower with respect to the
        # one we have just found. That means that our current strategy
        # is reaching the point neighbor_node faster. This means that we are
        # improving.
        elsif distance_to_start < neighbor_node.distance_to_start
          improving = true
        # Third case: The y point is not in the openset, and the
        # distance_to_start is not lower with respect to the one already saved
        # into the node y. Thus, we are not improving and this 
        # current strategy is not good.
        else
          improving = false
        end
        
        # We had an improvement
        if improving
          # so we reach y from x
          neighbor_node.previous_node = node
          # we update the gscore value
          neighbor_node.distance_to_start = distance_to_start
        end
      end # for
      
      # The loop instruction is over, thus we are ready to 
      # select a new node.
    end # while
    
    # If we never encountered a return before means that we 
    # have finished the node in the openset and we never
    # reached the @stop_node point.
    # We are returning an empty path.
    return []
  end
  
  private
  
  ##
  # Searches the node with the minimum f in the openset
  def openset_min_search_criterion
    ret = @openset.first
    @openset.each do |node|
      ret = node if node.search_criterion < ret.search_criterion
    end
    return ret
  end
  
  ##
  # It reconstructs the path by using a recursive function
  # that runs from the last node till the beginning.
  # It is stopped when the analyzed node has prev == nil
  def reconstruct_path(curr)
    return ( curr.previous_node ? reconstruct_path(curr.previous_node) + [curr] : [] )
  end
end
