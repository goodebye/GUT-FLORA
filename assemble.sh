#first thing we're gonna do is generate the qr codes
cd qr_codes
echo "creating qr codes...."
ruby main.rb $1
echo "done"
cd images

#we're now looping through all the qr codes and converting them to pdf at the correct size and dpi

echo "converting qr code images to pdf.... (takes a good whiel.....)"

for f in *.png; do
  name=$(echo $f | cut -f 1 -d '.')

  echo "converting qr code #$f to pdf....."
  # convert $f +antialias -filter point -resize 3000x3000 -density 600 pdf/$name.pdf
done

echo "odne!!! nice..."

cd ../..

# now we're going to generate the squigglessSSs
# so because on linux you would have to add processing to your path and
# maybe not all of you have done this (i still havent lol) this will assume you
# have prerun the included processing sketch to generate the interior art ok?

cd squiggles/images

echo "converting squiggle art to pdf (takes a w hile....)...."
for f in *.png; do
  name=$(echo $f | cut -f 1 -d '.')
  echo "converting squiggle art #$f to pdf....."
  # convert $f +antialias -filter point -resize 3000x3000 -density 600 pdf/$name.pdf
done
echo "done!!!!"
#now we stitch the pdfs together!

cd ../..

echo "converting covers to pdf for ebooks......"
cd cover/for_ebook

for f in *.png; do
  name=$(echo $f | cut -f 1 -d '.')
  echo "converting cover #$f to pdf....."
  convert $f +antialias -filter point -resize 3000x3000 -density 600 pdf/$name.pdf
done

echo "done!!!"

cd ../..

echo "now we're stitching the parts together!!"

for ((i=0;i<$1;i++)); do

  echo "exporting print book (this is the version without covers b/c covers are printed separately)......"

  pdftk \
  "squiggles/images/pdf/${i}_0.pdf" \
  text/blank_page.pdf \
  qr_codes/images/pdf/$i.pdf \
  text/blank_page.pdf \
  text/gut_flora_chunk_1.pdf \
  "squiggles/images/pdf/${i}_1.pdf" \
  text/blank_page.pdf \
  text/gut_flora_chunk_2.pdf \
  "squiggles/images/pdf/${i}_2.pdf" \
  text/blank_page.pdf \
  text/gut_flora_chunk_3.pdf \
  cat output final_books/print_books/$i.pdf

  #ebooks this time

  echo "exporting ebook (this is for digital copies for ppl who bought it and want their custom version Forever.....)"

  pdftk \
  "cover/for_ebook/pdf/${i}_front.pdf" \
  "squiggles/images/pdf/${i}_0.pdf" \
  qr_codes/images/pdf/$i.pdf \
  text/gut_flora_chunk_1.pdf \
  "squiggles/images/pdf/${i}_1.pdf" \
  text/gut_flora_chunk_2.pdf \
  "squiggles/images/pdf/${i}_2.pdf" \
  text/gut_flora_chunk_3.pdf \
  "cover/for_ebook/pdf/${i}_back.pdf" \
  cat output final_books/ebooks/$i.pdf
done
