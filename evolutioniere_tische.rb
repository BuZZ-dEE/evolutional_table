# -*- coding: utf-8 -*-
require 'tisch'
require 'evolution'

module EvolutioniereTische
  extend self

  def mutation(s)
    lambda {|tisch|
      Tisch.new(Array.new(4) {|i|
                  tisch.beine[i] + rand(2*s + 1) - s
                })
    }
  end
  
  KREUZUNG = lambda {|tisch1, tisch2|
    Tisch.new(Array.new(4) {|i|
                if rand(2) == 0
                  tisch1.beine[i]
                else
                  tisch2.beine[i]
                end
              })
  }

  FITNESS = lambda {|tisch|
    -(tisch.schiefe + tisch.wackeln)
  }

  def next_gen(grossN, n, rho, s, population)
    Evolution.next_gen(grossN, n, rho, FITNESS, mutation(s), KREUZUNG, population)
  end

  def evolutioniere_tische(grossN, n, rho, s, generationen)
    population = Array.new(grossN) {
      Tisch.new(Array.new(4) {rand(21)+90})
    }
    generationen.times {
      population = next_gen(grossN, n, rho, s, population)
    }
    population
  end
end

# "Main-Methode" (wird nicht ausgeführt, wenn diese Datei aus einer anderen
#                 heraus geladen wird)
if __FILE__ == $0
  grossN = ARGV[0].to_i
  n = ARGV[1].to_i
  rho = ARGV[2].to_f
  s = ARGV[3].to_i
  anzahl_generationen = ARGV[4].to_i
  
  puts EvolutioniereTische.evolutioniere_tische(grossN, n, rho, s, anzahl_generationen)
end
