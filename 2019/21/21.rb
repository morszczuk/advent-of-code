require_relative '../shared/intcode.rb'
require_relative '../../utils/test.rb'
require 'byebug'

class Quiz21A
  def solve(filename)
    input = instructions
    output = ASCIIIntcode.new(filename: filename, input: input).run[:output]
    result = output.pop
    pp output
    result
  end

  def instructions
    [
      'NOT D T', # w T zapisz informacje, czy za 4 jest dziura
      'NOT T T', # w T zapisz informacje, czy za 4 jest ziemia
      'NOT A J', # w J - czy nastepna jest dziura
      'NOT J J', # w J Czy nastepna jest ziemia
      'AND B J', # jesli B lub J ziemia - 
      'AND C J',
      'NOT J J',
      'AND T J',
      'WALK'
    ]
  end
end

class Quiz21B < Quiz21A
  def instructions
    [
      'NOT D T', # w T zapisz informacje, czy za 4 jest dziura
      'NOT T T', # w T zapisz informacje, czy za 4 jest ziemia
      'NOT A J', # w J - czy nastepna jest dziura
      'NOT J J', # w J Czy nastepna jest ziemia
      'AND B J', # czy w +2 i +1 sa ziemiami
      'AND C J', # czy w +3, +2 i +1 sa ziemiami
      'NOT J J', # skacz, jesli ktoras z nich nie jest ziemia
      'AND T J', # skacz, jesli +4 to ziemia, a +3/2/1 nie jest ziemia
      'NOT E T', # Czy +5 jest dziura 
      'NOT T T', #CZY +5 JEST ZIEMIA
      'OR H T', # Lub czy + 8 jest ziemia
      'AND T J',
      'RUN'
    ]
  end
end

pp Quiz21A.new.solve('input.txt')
pp Quiz21B.new.solve('input.txt')
