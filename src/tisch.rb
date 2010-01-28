# -*- coding: utf-8 -*-

require 'geometrie'

# Klasse, die einen Tisch samt der Eigenschaften schiefe und wackeln repräsentiert
class Tisch
  # Getter und setter-Methoden für @beine generieren
  attr_accessor :beine

  def initialize(beine)
    @beine = beine
  end

  # Vier Vektoren, die die vier Beine repräsentieren.
  def vektoren
    [Vektor[0, beine[0], 0],
     Vektor[1, beine[1], 0],
     Vektor[1, beine[2], 1],
     Vektor[0, beine[3], 1]]
  end
  
  # Die Schiefe eines Tisches ist der Winkel zwischen der Ebene, die durch die
  # längsten drei Beine aufgespannt wird, und der "Boden-Ebene".
  def schiefe
    laengste_drei_beine = vektoren.sort_by {|vec| vec[1]}[1..3]
    ebene = Ebene.aus_punkten(laengste_drei_beine)
    ebene.winkel(Ebene::XZ)
  end

  # Das Wackeln eines Tisches ist der Winkel zwischen der Ebene, die durch das
  # kuerzeste Bein und die beiden dem kürzesten Bein nicht gegenüberliegenden
  # Beine aufgespannt wird, und der Ebene, die durch diese beiden Beine und dem
  # dem kürzesten Bein gegenüberliegenden Bein aufgespannt wird.
  def wackeln
    kuerzestes_bein = vektoren.sort_by {|vec| vec[1]}[0]
    kuerzestes_idx = vektoren.index(kuerzestes_bein)
    gegenueber_idx = (kuerzestes_idx + 2) % 4
    gegenueber = vektoren[gegenueber_idx]
    nachbar1 = vektoren[(kuerzestes_idx + 1)%4]
    nachbar2 = vektoren[(kuerzestes_idx - 1)%4]
    ebene1 = Ebene.aus_punkten([kuerzestes_bein, nachbar1, nachbar2])
    ebene2 = Ebene.aus_punkten([gegenueber, nachbar1, nachbar2])
    ebene1.winkel(ebene2)
  end

  # Eine to-string-Methode, damit Tische sinnvoll auf die Konsole ausgegeben
  # werden können
  def to_s
    "<Tisch - Beine: #{beine.inspect} Schiefe: #{schiefe} Wackeln: #{wackeln}>"
  end
end
