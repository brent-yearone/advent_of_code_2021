class Map
  def initialize
    @nodes = {}
  end

  def add_nodes(node1, node2)
    initialize_node(node1)
    initialize_node(node2)
    link_nodes(node1, node2)
  end

  # Find the paths for part 1 solution
  def paths(node: 'start', path: [], &block)
    node = @nodes['start'] if node == 'start' # Bootstrap the recursion
    case
    when node[:name] == 'end'
      yield path + [node[:name]]
    else
      node[:nodes].each do |child|
        next if child == 'start'
        next if path.include?(child) && ('a'..'z').include?(child[0])
        paths(node: @nodes[child], path: path + [node[:name]], &block)
      end
    end
  end

  private def initialize_node(node_name)
    @nodes[node_name] ||= {name: node_name, nodes: []}
  end

  private def link_nodes(node1, node2)
    @nodes[node1][:nodes] << node2
    @nodes[node2][:nodes] << node1
  end
end
