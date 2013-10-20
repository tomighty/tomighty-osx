#!/bin/sh

rm *.png
rm *.tiff

INKSCAPE=/Applications/Inkscape.app/Contents/Resources/bin/inkscape

for svg_file in *.svg
do
  filename="${svg_file%.*}"
  png_file="$filename.png"
  echo "----------------------------------------------"
  echo "Exporting $svg_file to $png_file"
  $INKSCAPE -z --export-area-page --export-png "$png_file" "$svg_file"
done
