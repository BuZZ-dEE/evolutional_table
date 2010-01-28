require 'tisch'

include Java # Java-Klassen einbinden

import javax.swing.JPanel
import javax.swing.JLabel
import javax.swing.JFrame
import javax.swing.BoxLayout
import javax.swing.BorderFactory

class TischIcon < JPanel
  def initialize(tisch, titel)
    super()
    self.layout = BoxLayout.new(self, BoxLayout::Y_AXIS)
    self.border = BorderFactory.create_titled_border(titel)
    #bein_labels = tisch.beine.each_with_index {|beinlaenge, index|
    #  add JLabel.new("Bein #{index+1}: #{beinlaenge}")   
    #}
    add JLabel.new("Beine: #{tisch.beine.join(", ")}")
    add JLabel.new("<html>Schiefe: #{colorize tisch.schiefe}</html>")
    add JLabel.new("<html>Wackeln: #{colorize tisch.wackeln}</html>")
    add JLabel.new("<html>Fitness: -#{colorize(tisch.schiefe + tisch.wackeln)}</html>")
  end

  def colorize(wert)
    "<font bgcolor=\"#{color wert}\">#{wert}</font>"
  end

  def color(wert)
    if wert < 0.2
      "green"
    elsif wert < 1.0
      "yellow"
    else
      "red"
    end
  end
end
