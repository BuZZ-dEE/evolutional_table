# -*- coding: utf-8 -*-

# Füge ein paar nützliche Funktionen zu Enumerable hinzu
module Enumerable
  def sum
    inject {|x,y| x+y}
  end

  def avg
    sum / length
  end
end
