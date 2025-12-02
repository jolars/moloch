#!/usr/bin/env bash
# Convert a PDF presentation to a grid of slide thumbnails
# Usage: ./scripts/pdf-to-grid.sh input.pdf output.png [columns] [density]

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <input.pdf> <output.png> [columns=4] [density=150] [range=1-4]"
    echo "Example: $0 demo.pdf demo-grid.png 4 150 1-4"
    exit 1
fi

INPUT_PDF="$1"
OUTPUT_IMAGE="$2"
COLS="${3:-4}"
DENSITY="${4:-150}"
RANGE="${5:-1-4}"

if [ ! -f "$INPUT_PDF" ]; then
    echo "Error: Input file '$INPUT_PDF' not found"
    exit 1
fi

echo "Converting PDF to images at ${DENSITY} DPI (pages ${RANGE})..."
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Convert PDF pages to PNG images
pdftoppm -png -r "$DENSITY" -f "$(echo $RANGE | cut -d- -f1)" -l "$(echo $RANGE | cut -d- -f2)" "$INPUT_PDF" "$TEMP_DIR/slide"

# Count the number of slides
NUM_SLIDES=$(ls "$TEMP_DIR"/slide-*.png 2>/dev/null | wc -l)

if [ "$NUM_SLIDES" -eq 0 ]; then
    echo "Error: No slides generated from PDF"
    exit 1
fi

echo "Generated $NUM_SLIDES slide images"

# Add borders to each slide
echo "Adding borders to slides..."
for img in "$TEMP_DIR"/slide-*.png; do
    magick "$img" -bordercolor gray -border 1 -bordercolor white -border 10 "$img.bordered"
done

# Calculate grid dimensions
NUM_ROWS=$(( (NUM_SLIDES + COLS - 1) / COLS ))

# Create grid by appending images
echo "Creating ${COLS}-column grid (${NUM_ROWS} rows)..."

# Get sorted list of bordered images
mapfile -t all_images < <(ls "$TEMP_DIR"/slide-*.png.bordered | sort -V)

# Create each row
for ((row=0; row<NUM_ROWS; row++)); do
    start=$((row * COLS))

    row_files=""
    for ((col=0; col<COLS; col++)); do
        idx=$((start + col))
        if [ $idx -lt ${#all_images[@]} ]; then
            row_files="$row_files ${all_images[$idx]}"
        fi
    done

    if [ -n "$row_files" ]; then
        magick $row_files +append "$TEMP_DIR/row-${row}.png"
    fi
done

# Combine all rows vertically
magick "$TEMP_DIR"/row-*.png -append -background white "$OUTPUT_IMAGE"

echo "Grid saved to: $OUTPUT_IMAGE"
