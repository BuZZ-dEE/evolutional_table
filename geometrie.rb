# -*- coding: utf-8 -*-
require 'matrix'  # matrix.rb stellt die Klasse Vector zur Verfügung

# Füge ein paar Methoden, zur Vector Klasse hinzu
class Vector
  # Berechnet die Euklidische Norm des Vektors
  def norm
    Math.sqrt(inner_product(self))
  end

  # Berechnet das Kreuzprodukt eines drei-dimensionalen Vektors mit einem
  # anderen drei-dimensionalen Vektors.
  # Wer diese Methode mit Vektoren, die mehr oder weniger als drei Elemente
  # haben, aufruft, den soll der Teufel holen.
  def cross_product(rhs)
    Vector[self[1]*rhs[2] - self[2]*rhs[1],
           self[2]*rhs[0] - self[0]*rhs[2],
           self[0]*rhs[1] - self[1]*rhs[0]]  
  end
end

# Klasse, die eine Ebene im dreidimensionalen Raum beschreibt.
class Ebene
  attr_reader :stuetz_vektor
  attr_reader :richtungs_vektor1
  attr_reader :richtungs_vektor2

  # Eine Ebene besteht aus einem Stützvektor und zwei Richtungsvektoren
  def initialize(stuetz, richtung1, richtung2)
    @stuetz_vektor = stuetz
    @richtungs_vektor1 = richtung1
    @richtungs_vektor2 = richtung2
  end

  # Erstelle eine Ebene aus drei Punkten, die auf dieser Ebene liegen
  def self.aus_punkten(punkte)
    richtungs_vektor1 = punkte[1] - punkte[0]
    richtungs_vektor2 = punkte[2] - punkte[0]
    new(punkte[0], richtungs_vektor1, richtungs_vektor2)
  end

  # Die XZ-Ebene (aka die "Boden-Ebene")
  XZ = Ebene.new( Vector[0,0,0],
                  Vector[1,0,0],
                  Vector[0,0,1])


  # Gib einen Vektor zurück, der senkrecht auf der Ebene steht
  def normalen_vektor
    richtungs_vektor1.cross_product(richtungs_vektor2)
  end

  # Berechne den Winkel zwischen zwei Ebenen
  def winkel(rhs)
    n = normalen_vektor
    m = rhs.normalen_vektor
    cos = n.inner_product(m).abs / (n.norm * m.norm)
    # Floating Point Ungenauigkeiten, können dazu führen, dass cos > 1.0
    # Dieser Fall wird hier abgefangen, damit acos keine Exception wirft
    if cos > 1.0
      cos = 1.0
    end
    Math.acos( cos )
  end
end
