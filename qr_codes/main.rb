require 'rqrcode'
require 'marky_markov'

number_of_copies = ARGV[0].to_i || 25

epigraph_markov = MarkyMarkov::TemporaryDictionary.new
epigraph_markov.parse_file "leaves_of_grass.txt"

inscription_log = File.new 'inscriptions.txt', 'w'

# create QR codes and put them in the array of inscriptions

number_of_copies.times do |copy_number|
  epigraph = epigraph_markov.generate_n_sentences 1
  pressing = "1st edition"
  edition = (copy_number).to_s + " of " + number_of_copies.to_s
  final_inscription = epigraph + "\n" + pressing + "\n" + edition

  inscription_log.write(final_inscription + "\n" + "\n")

  qrcode = RQRCode::QRCode.new(final_inscription)
  image = qrcode.as_png
  image.save('images/' + copy_number.to_s + '.png')
end

inscription_log.close
