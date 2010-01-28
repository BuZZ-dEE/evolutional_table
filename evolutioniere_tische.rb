# -*- coding: utf-8 -*-
require 'tisch'
require 'evolution'
require 'util'

module EvolutioniereTische
  extend self

  # Der Mutationsoperator gibt einen neuen Tisch zurück, bei
  # dem auf jedes Bein des alten Tisches eine zufällige Ganzzahl
  # zwischen -s und s hinzuaddiert wurde.
  def mutation(s)
    lambda {|tisch|
      Tisch.new(Array.new(4) {|i|
                  tisch.beine[i] + rand(2*s + 1) - s
                })
    }
  end
  
  # Der Kreuzungsoperator gibt einen neuen Tisch zurück, bei
  # jedes Bein mit gleicher Wahrscheinlichkeit aus einem der
  # beiden Elterntische übernommen wird
  KREUZUNG = lambda {|tisch1, tisch2|
    Tisch.new(Array.new(4) {|i|
                if rand(2) == 0
                  tisch1.beine[i]
                else
                  tisch2.beine[i]
                end
              })
  }

  # Die Fitness-Funktion ist die Summe der Schiefe und des Wackelns des Tisches
  FITNESS = lambda {|tisch|
    -(tisch.schiefe + tisch.wackeln)
  }

  # Ruft Evolution.next_gen mit den in diesem Modul definierten Funktionen für
  # Fitness, Mutation und Kreuzung auf.
  def next_gen(grossN, n, rho, s, population)
    Evolution.next_gen(grossN, n, rho, FITNESS, mutation(s), KREUZUNG, population)
  end

  # Erzeugt eine zufällige Startgeneration mit Beinlängen zwischen 90 und 110
  # und wendet darauf den evolutionären Algorithmus für generationen Generationen
  # an
  def evolutioniere_tische(grossN, n, rho, s, generationen, &blk)
    population = Array.new(grossN) {
      Tisch.new(Array.new(4) {rand(21)+90})
    }
    generationen.times {
      population = next_gen(grossN, n, rho, s, population)
      if blk
        blk[population]
      end
    }
    population
  end
end

# "Main-Methode" (wird nicht ausgeführt, wenn diese Datei aus einer anderen
#                 heraus geladen wird)
if __FILE__ == $0
  if ARGV.size != 5
    puts <<EOF
Usage:
ruby evolutioniere_tische.rb N n rho s anzahl_generationen
EOF
  else
    grossN = ARGV[0].to_i
    n = ARGV[1].to_i
    rho = ARGV[2].to_f
    s = ARGV[3].to_i
    anzahl_generationen = ARGV[4].to_i

    end_generation = EvolutioniereTische.evolutioniere_tische(grossN, n, rho, s, anzahl_generationen)
    fitnesses = end_generation.map(&EvolutioniereTische::FITNESS)
    puts "Individuen der Endgeneration:"
    puts end_generation
    puts
    puts "Durchschnittliche Fitness: #{ fitnesses.avg  }"
    puts "Beste Fitness: #{ fitnesses.max }"
    puts "(Beste mögliche Fitness ist 0 für den perfekten Tisch)"
  end
end
