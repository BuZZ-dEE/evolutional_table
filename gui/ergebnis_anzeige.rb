require 'gui/tisch_icon'

include Java

import javax.swing.JPanel
import javax.swing.JLabel
import javax.swing.JFrame
import javax.swing.BoxLayout

class ErgebnisAnzeige < JPanel
  def initialize
    super()
    @i = 0
    self.layout = BoxLayout.new(self, BoxLayout::X_AXIS)
  end

  def add(generation)
    gen = JPanel.new
    gen.layout = BoxLayout.new(gen, BoxLayout::Y_AXIS)
    @i += 1
    gen.add JLabel.new("Generation #{@i}:")
    generation.each_with_index {|tisch, idx|
      gen.add TischIcon.new(tisch, "Tisch #{idx}")
    }
    super(gen)
  end

  def reset
    @i = 0
    removeAll
  end
end
