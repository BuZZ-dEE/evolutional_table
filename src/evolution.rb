# -*- coding: utf-8 -*-

# Beschreibt den in der Aufgabe beschriebenen evolutionären Algorithmus
# unabhängig vom Anwendungsgebiet
module Evolution
  extend self

  # Nimmt die Parameter des evolutionären Algorithmus und die aktuelle Generation
  # und gibt die nächste Generation zurück
  # Parameter:
  # grossN  | Populationsgröße
  # n       | Überlebende pro Generation
  # rho     | Wahrscheinlichkeit einer Mutation
  # f       | Fitnessfunktion
  # mutiere | Mutationsoperator
  # kreuze  | Kreuzungsoperator
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
end
