include Java # Java-Klassen einbinden

import javax.swing.JFrame
import javax.swing.JButton

frame = JFrame.new("Hallo Welt")
frame.default_close_operation = JFrame::EXIT_ON_CLOSE
button = JButton.new("Klick mich nicht!")
button.add_action_listener {
  beleidigungen = [
                   "lieber mensch",
                   "netter kerl",
                   "toller typ",
                   "starker kerl",
                   "held"
                  ]
  zufallsbeleidigung = beleidigungen[ rand(beleidigungen.size) ]
  button.text = "Ich hab gesagt, du sollst mich nicht klicken, du #{zufallsbeleidigung}"
  frame.pack
}
frame.add(button)
frame.show
frame.pack
