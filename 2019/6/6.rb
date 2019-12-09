require_relative '../../utils/test.rb'
require 'byebug'

# TEST_DATA = [
#   ['', ''],
#   ['', ''],
#   ['', ''],
# ]

# TEST_DATA = [
#   ['', ],
#   ['', ],
#   ['', ],
# ]

# TEST_DATA = [
#   [111111, true],
#   [223450, false],
#   [123789, false],
# ]

# TEST_DATA_2 = [
#   [112233, true],
#   [123444, false],
#   [111122, true],
# ]

# TEST_DATA = [
#   ['input-test1.txt', ],
#   ['input-test2.txt', ],
#   ['input-test3.txt', ],
# ]

TEST_DATA = [
  ['input-test1.txt', 42]
]

# TEST_DATA = [
#   ['1,0,0,0,99', '2,0,0,0,99'],
#   ['2,3,0,3,99', '2,3,0,6,99'],
#   ['2,4,4,5,99,0', '2,4,4,5,99,9801'],
#   ['1,1,1,4,99,5,6,0,99', '30,1,1,4,2,5,6,0,99']
# ]

TEST_DATA_2 = [
  ['input-test2.txt', 4]
]

class Node
  def initialize

  end
end

class Graph
  def initialize
    @nodes = {}
    @nodes_counted = []
  end

  def [](p)
    @nodes[p]
  end

  def add_orbit(source, dest)
    @nodes[source] = [] unless @nodes[source]
    @nodes[source] << dest

    # @nodes[dest] = source
  end

  def solve
    korzenie = @nodes.select { |k, v| !@nodes.values.any? {|val| val.include? k } }.keys
    pp korzenie

    korzenie.map { |kor| count_orb(kor, 0) }.sum


    # liscie = @nodes.select { |k, v| !@nodes.values.include? k }.keys
    # pp liscie.count
    # count = liscie.map { |lisc| conunt_orbits(lisc) }
    # # pp count
    # count.sum
    # # .sum
  end

  def solve_2
    starting = @nodes.find { |node, val| val.include? 'YOU' }
    dijkstra(starting[0])

    # pp starting
  end

  def dijkstra(root)
    s = []
    # u = 'SAN'


    wierzcholki = @nodes.keys | @nodes.values.flatten
    # pp wierzcholki.count
    dist = {}
    prev = {}
    wierzcholki.each do |n| dist[n] = Float::INFINITY; prev[n] = nil end
    # wierzcholki.map { {nod}}

    dist[root] = 0
    until wierzcholki.empty?
      distance = wierzcholki.map { |wi| dist[wi] }.min
      u = wierzcholki.find { |node| dist[node] == distance }
      # byebug
      # dist.reject { |no, val| pp no; !wierzcholki.include?(no) }.min { |k, v| k[1] <=> v[1] }[0]
      wierzcholki.delete(u)
      # pp sasiedzi(u)
      # without_wierzcholki = sasiedzi(u).reject { |no| pp no; !wierzcholki.include?(no) }
      # pp "Without odw: #{without_wierzcholki}"
      # pp sasiedzi(u).select { |no| wierzcholki.include?(no) }
      # byebug
      sasiedzi(u).select { |no| wierzcholki.include?(no) }.each do |vv|
        # byebug
        alt = dist[u] + 1
        if alt < dist[vv]
          dist[vv] = alt
          prev[vv] = u
        end
      end
    end
    # pp dist
    # pp prev

    targets = @nodes.select { |node, val| val.include? 'SAN' }
    s = []
    # pp 'target'
    solution = targets.keys.map do |dest|
      s = []
      u = dest
      if prev[u] || u == root
        while u
          s.unshift(u)
          u = prev[u]
        end
      end
      s
    end

    solution.reject { | sol| sol.include?('SAN') || sol.include?('YOU')}.map{ |path| path.count - 1 }.min

  end

  def sasiedzi(node)
    # pp "NODE: #{node}"
    next_nodes = @nodes[node] || []
    previous = @nodes.select { |k, value| value.include?(node) }.keys || []
    next_nodes | previous
  end

  def count_orb(node, i)
    if @nodes[node].nil?
      pp node
      pp i
      i
    else
      sum = @nodes[node].map {|no| count_orb(no, i + 1)}.sum + i
      pp node
      pp sum
      sum
    end
  end

  def conunt_orbits(lisc)
    step = 1
    sum = 0
    until lisc.nil?
      # pp @nodes_counted
      if @nodes_counted.include? lisc
        # byebug
        sum += 1
      else
        sum += step
        step += 1
        @nodes_counted << lisc
      end
      lisc = @nodes[lisc]
    end
    sum
  end

end

class Quiz6A
  def initialize(input_filename = nil)
    @graph = Graph.new
    parse_input(input_filename) if input_filename
  end

  def solve
    # pp @graph
    @graph.solve
  end

  def parse_input(input_filename)
    File.readlines(input_filename).each do |line|
      next if line.empty?
      source, orbit = line.strip.split(')')
      @graph.add_orbit(source, orbit)
      # line.match(/([A-Z])(\d+)/).captures
    end
  end
end

class Quiz6B < Quiz6A
  def solve
    # pp @graph
    @graph.solve_2


  end
end

Test.new(TEST_DATA_2).test_data do |number|
  Quiz6B.new(number).solve
end

# Test.new(TEST_DATA_2).test_data do |number|
#   Quiz6B.new.potential_password? number.digits.reverse
# end

# pp Quiz6A.new('input.txt').solve
# pp Quiz6A.new.solve
pp Quiz6B.new('input.txt').solve

# 51050
