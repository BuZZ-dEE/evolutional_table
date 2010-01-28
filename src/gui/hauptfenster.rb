# -*- coding: utf-8 -*-
require 'gui/ergebnis_anzeige'
require 'evolutioniere_tische'

include Java
include EvolutioniereTische

import javax.swing.JPanel
import javax.swing.JLabel
import javax.swing.JFrame
import javax.swing.BoxLayout
import javax.swing.BorderFactory
import javax.swing.JSpinner
import javax.swing.SpinnerNumberModel
import javax.swing.JButton
import javax.swing.JScrollPane
import javax.swing.JProgressBar
import java.awt.Dimension

def numspin(value, min=1, max=1000, step=1)
  spinner = JSpinner.new
  spinner.model = SpinnerNumberModel.new(value, min, max, step)
  spinner
end

hf = JFrame.new("(r)evolution!")
hf.default_close_operation = JFrame::EXIT_ON_CLOSE

hf.content_pane.layout = BoxLayout.new(hf.content_pane, BoxLayout::Y_AXIS)
# Parameterleiste
pl = JPanel.new
pl.layout = BoxLayout.new(pl, BoxLayout::X_AXIS)

pl.add JLabel.new("N: ")
grossN = numspin(50)
pl.add grossN

pl.add JLabel.new(" n: ")
n = numspin(5)
pl.add n

pl.add JLabel.new(" ρ: ")
rho = numspin(0.21, 0, 0.99, 0.01)
pl.add rho

pl.add JLabel.new(" Schrittgröße: ")
s = numspin(1)
pl.add s

pl.add JLabel.new(" Anzahl der Generationen: ")
num_gen = numspin(20)
pl.add num_gen

ergebnis = ErgebnisAnzeige.new
progress = JProgressBar.new

evolution = JButton.new("(R)EVOLUTION!")
evolution.add_action_listener {
  Thread.new {
    evolution.enabled = false
    ergebnis.reset
    progress.value = 0
    progress.maximum = num_gen.model.value
    argumente = [grossN, n, rho, s, num_gen].map {|arg|
      arg.model.value
    }
    evolutioniere_tische(*argumente) {|gen|
      ergebnis.add gen
      progress.value += 1
      progress.repaint
      hf.repaint
    }
    hf.pack
    hf.size = Dimension.new(900, 600)
    evolution.enabled = true
  }
}
pl.add evolution


hf.add pl
hf.add JScrollPane.new(ergebnis)
hf.add progress
hf.pack
hf.show
