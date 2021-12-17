class Map
  def initialize(debug: false)
    @debug = debug
    @nodes = {}
    @small_cave_nodes = []
  end

  def add_nodes(node1, node2)
    initialize_node(node1)
    initialize_node(node2)
    link_nodes(node1, node2)
    @small_cave_nodes.uniq!
  end

  # Find the paths for part 1 solution
  def paths1(node: 'start', path: [], &block)
    node = @nodes['start'] if node == 'start' # Bootstrap the recursion
    case
    when node[:name] == 'end'
      yield path + [node[:name]]
    else
      node[:nodes].each do |child|
        next if child == 'start'
        next if path.include?(child) && ('a'..'z').include?(child[0])
        paths1(node: @nodes[child], path: path + [node[:name]], &block)
      end
    end
  end

  # Find the paths for part 2 solution
  def paths2(node: 'start', path: [], &block)
    node = @nodes['start'] if node == 'start' # Bootstrap the recursion
    padding = ('  ' * path.length) + '| '
    puts "#{padding}#{node[:name]} (next up #{node[:nodes].join(',')}). Current path: #{path.join(',')}" if @debug
    case
    when node[:name] == 'end'
      yield path + [node[:name]]
    else
      tally = (path + [node[:name]]).tally.slice(*@small_cave_nodes)
      puts "#{padding} Path tally: #{tally.inspect}" if @debug
      node[:nodes].each do |child|
        if child == 'start'
          puts "#{padding} start: node is out of bounds. This path is dead." if @debug
          next
        end
        if path.include?(child) && @small_cave_nodes.include?(child) && tally.values.any?{|v| v > 1}
          puts "#{padding} #{child}: double small cave visit detected, and this is a small cave. This path is dead." if @debug
          next
        end
        paths2(node: @nodes[child], path: path + [node[:name]], &block)
      end
    end
  end

  private def initialize_node(node_name)
    @nodes[node_name] ||= {name: node_name, nodes: []}
    @small_cave_nodes << node_name if ('a'..'z').include?(node_name[0]) && !['start', 'end'].include?(node_name)
    @small_cave_nodes.uniq!
  end

  private def link_nodes(node1, node2)
    @nodes[node1][:nodes] << node2
    @nodes[node2][:nodes] << node1
  end
end
