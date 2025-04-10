# 🎨 Video Color Bar Generator

This script processes a video file and generates a horizontal color bar image representing the dominant colors sampled from the video at 12-second intervals.

## 📦 Features

- Extracts frames from the input video at one every 12 seconds
- Retrieves the dominant color from each frame
- Creates a horizontal color bar from the extracted colors
- Outputs a final color bar image resized for presentation
- Cleans up all temporary files after processing

## 🧰 Requirements

Make sure you have the following tools installed:

- `bash`
- [`ffmpeg`](https://ffmpeg.org/)
- [`ImageMagick`](https://imagemagick.org/) (must include the `magick` command)

## 🚀 Usage

```bash
./generate_color_bar.sh <input_file>
```

### Arguments

- `<input_file>`: Path to the video file you want to process.

### Example

```bash
./generate_color_bar.sh movie.mp4
```

## 📁 Output

After running the script, you’ll get:

- `movie_color_bars.png`: A horizontal bar composed of color swatches sampled from the video.
- `movie_color_bars_resized.png`: A resized version of the above image (3600x1200 pixels).

## 🧹 Cleanup

Temporary folders used during processing (`thumbnails/` and `temp_swatches/`) are automatically deleted after execution.

## ⚠️ Notes

- If color extraction fails for a frame, a default gray color (`#808080`) is used.
- The script assumes the input file exists and is readable. It will exit with an error if the file is not found or if the wrong number of arguments is provided.

