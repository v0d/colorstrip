#!/bin/bash

# Display usage information
usage() {
    echo "Usage: $0 <input_file>"
    echo "  <input_file> : Video file to process"
    echo
    echo "Example: $0 movie.avi"
    exit 1
}

# Check if exactly one parameter is provided
if [ $# -ne 1 ]; then
    echo "Error: Exactly one input file must be specified."
    usage
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist."
    usage
fi

# Store input file in a variable
INPUT_FILE="$1"

# Generate output filename based on input filename
OUTPUT_BASE=$(basename "$INPUT_FILE")
OUTPUT_NAME="${OUTPUT_BASE%.*}_color_bars.png"

# Create a directory for thumbnails and temporary color swatches
mkdir -p thumbnails
mkdir -p temp_swatches

# Use ffmpeg to extract frames with thumbnails directly at 1x1 pixels for color extraction
ffmpeg -i "$INPUT_FILE" -vf "fps=1/12,scale=1:1" -vsync vfr -q:v 2 thumbnails/thumb_%04d.png

# Create an array to store color swatch files
color_files=()

# Process each thumbnail to extract colors
count=0
for img in thumbnails/thumb_*.png; do 
  # Extract the dominant color directly as hex - already at 1x1 so no resize needed
  hex_color=$(magick "$img" -format "%[pixel:u]" info:)
  
  # If color extraction fails, use default gray
  if [ -z "$hex_color" ]; then
    hex_color="#808080"  # Default to gray if extraction fails
    echo "Warning: Could not extract valid color from $img, using default gray."
  fi

  # Create an actual file for each color swatch and add to array
  swatch_file="temp_swatches/swatch_${count}.png"
  magick -size 100x25 xc:"$hex_color" "$swatch_file"
  color_files+=("$swatch_file")
  count=$((count + 1))
done

# Combine all color swatches using the array of filenames
montage "${color_files[@]}" -tile x1 -geometry +0+0 "$OUTPUT_NAME"
magick "$OUTPUT_NAME" -strip -resize 3600x1200\! "${OUTPUT_NAME%.*}_resized.png"

# Clean up temporary files
rm -rf thumbnails/
rm -rf temp_swatches/
