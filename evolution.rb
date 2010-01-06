# -*- coding: utf-8 -*-

module Evolution
  extend self
  # grossN | Populationsgröße
  # n      | Überlebende pro Generation
  # rho    | Wahrscheinlichkeit einer Mutation
  # f      | Fitnessfunktion
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
