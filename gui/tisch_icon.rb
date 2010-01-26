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
    add JLabel.new("Schiefe: #{tisch.schiefe}")
    add JLabel.new("Wackeln: #{tisch.wackeln}")
    add JLabel.new("Fitness: #{-(tisch.schiefe + tisch.wackeln)}")
  end
end


ti = TischIcon.new(Tisch.new([90,95,93,100]), "Ja, ja, deine Mudda")
window = JFrame.new("Bla")
window.add ti
window.default_close_operation = JFrame::EXIT_ON_CLOSE
window.pack
window.show
