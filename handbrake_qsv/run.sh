#!/usr/bin/env bash
set -e

OPTIONS_FILE="/data/options.json"

INPUT_DIR=$(jq -r '.input'  "$OPTIONS_FILE")
OUTPUT_DIR=$(jq -r '.output' "$OPTIONS_FILE")
PRESET=$(jq -r '.preset' "$OPTIONS_FILE")
EXTRA_ARGS=$(jq -r '.extra_args' "$OPTIONS_FILE")

mkdir -p "$INPUT_DIR" "$OUTPUT_DIR"

echo "[handbrake-qsv] Watching: $INPUT_DIR"
echo "[handbrake-qsv] Output:   $OUTPUT_DIR"
echo "[handbrake-qsv] Preset:   $PRESET"
echo "[handbrake-qsv] Extra:    $EXTRA_ARGS"

echo "[handbrake-qsv] Checking QSV/VAAPI availability..."
vainfo || echo "vainfo failed — GPU may not be mapped yet."

# Process existing files
find "$INPUT_DIR" -maxdepth 1 -type f | while read -r f; do
    BASENAME=$(basename "$f")
    OUTFILE="$OUTPUT_DIR/$BASENAME"

    echo "[handbrake-qsv] Encoding existing file: $BASENAME"
    HandBrakeCLI \
        -i "$f" \
        -o "$OUTFILE" \
        -e qsv_h265 \
        --no-hw-decoding \
        --preset "$PRESET" \
        $EXTRA_ARGS

    echo "[handbrake-qsv] Done: $OUTFILE"
done

# Watch for new files
inotifywait -m -e close_write,create,move "$INPUT_DIR" | while read -r dir action file; do
    SRC="$dir$file"
    BASENAME="$file"
    OUTFILE="$OUTPUT_DIR/$BASENAME"

    echo "[handbrake-qsv] New file detected: $SRC"

    HandBrakeCLI \
        -i "$SRC" \
        -o "$OUTFILE" \
        -e qsv_h265 \
        --no-hw-decoding \
        --preset "$PRESET" \
        $EXTRA_ARGS

    echo "[handbrake-qsv] Finished encoding: $OUTFILE"
done
