# -*- coding: utf-8 -*-

require 'matrix'

class Vector
  # Keine Ahnung, warum diese Methode nicht schon existiert
  # Schlechte API! Ganz schlecht!
  def norm
    Math.sqrt(inner_product(self))
  end
end

# Konvention:
# Eine Ebene sei beschrieben, durch ein Array aus drei Vektoren von jeweils drei Integern,
# wobei das erste Array den Stützvektor beschreibt und die anderen beiden die Richtungsvektoren
NullEbene = [ Vector[0,0,0],
              Vector[1,0,0],
              Vector[0,0,1]]

def normalen_vektor(ebene)
  _, u, v = ebene
  # Der letzte Wert einer Methode ist ihr Rückgabewert, lieber BuZZ-dEE
  Vector[u[1]*v[2] - u[2]*v[1],
         u[2]*v[0] - u[0]*v[2],
         u[0]*v[1] - u[1]*v[0]]
end

def winkel(ebene1, ebene2)
  n = normalen_vektor(ebene1)
  m = normalen_vektor(ebene2)
  tmp = n.inner_product(m).abs / (n.norm * m.norm)
  # Rundungsfehler abfangen
  if tmp > 1.0
    tmp = 1.0
  end
  Math.acos( tmp )
end

def punkte2ebene(punkte)
  richtungs_vektor1 = punkte[1] - punkte[0]
  richtungs_vektor2 = punkte[2] - punkte[0]
  [punkte[0], richtungs_vektor1, richtungs_vektor2]
end

class Tisch
  # Getter und setter-Methoden für @beine generieren
  attr_accessor :beine

  def initialize(beine)
    @beine = beine
  end

  def vektoren
    [Vector[0, beine[0], 0],
     Vector[1, beine[1], 0],
     Vector[1, beine[2], 1],
     Vector[0, beine[3], 1]]
  end
  
  def schiefe
    laengste_drei_beine = vektoren.sort_by {|vec| vec[1]}[1..3]
    stuetz_vektor = laengste_drei_beine[0]
    richtungs_vektor1 = laengste_drei_beine[1] - laengste_drei_beine[0]
    richtungs_vektor2 = laengste_drei_beine[2] - laengste_drei_beine[0]
    winkel([stuetz_vektor, richtungs_vektor1, richtungs_vektor2], NullEbene)
  end

  def wackeln
    kuerzestes_bein = vektoren.sort_by {|vec| vec[1]}[0]
    kuerzestes_idx = vektoren.index(kuerzestes_bein)
    gegenueber_idx = (kuerzestes_idx + 2) % 4
    ebene1 = punkte2ebene([kuerzestes_bein, vektoren[(kuerzestes_idx +1)%4],vektoren[(kuerzestes_idx -1)%4 ]])
    ebene2 = punkte2ebene([vektoren[gegenueber_idx], vektoren[(gegenueber_idx + 1)%4], vektoren[(gegenueber_idx - 1)%4]])
    winkel(ebene1, ebene2)
  end

  def to_s
    "<Tisch - Beine: #{beine.inspect}>"
  end
end

# grossN | Populationsgröße
# n      | Überlebende pro Generation
# rho    | Wahrscheinlichkeit einer Mutation
# f      | Fitnessfunktion
def evolutioniere(grossN, n, rho, f, mutiere, kreuze, generationen)
  population = Array.new(grossN) {
    Tisch.new(Array.new(4) {rand(21)+90})
  }
  generationen.times {
    population = next_gen(grossN, n, rho, f, mutiere, kreuze, population)
  }
  population
end

def next_gen(grossN, n, rho, f, mutiere, kreuze, population)
  ueberlebende = population.map {|individuum|
    if rand <= rho
      mutiere[individuum]
    else
      individuum
    end
  }.sort_by(&f)[-n .. -1]
  ueberlebende + Array.new(grossN - n) {
    kreuze[ ueberlebende[rand(n)], ueberlebende[rand(n)] ]
  }
end

def mutation(s)
  lambda {|tisch|
    Tisch.new(Array.new(4) {|i|
                tisch.beine[i] + rand(2*s + 1) - s
              })
  }
end

kreuzung = lambda {|tisch1, tisch2|
  Tisch.new(Array.new(4) {|i|
    if rand(2) == 0
      tisch1.beine[i]
    else
      tisch2.beine[i]
    end
  })
}

fitness = lambda {|tisch|
  -(tisch.schiefe + tisch.wackeln)
}


grossN, n, rho, s, anzahl_generationen = ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_f, ARGV[3].to_i, ARGV[4].to_i

puts evolutioniere(grossN, n, rho, fitness, mutation(s), kreuzung, anzahl_generationen)
