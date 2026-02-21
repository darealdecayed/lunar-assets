#!/bin/bash

# Script to download games from Selenite semag directory and standardize format

GAME_DIR="/Users/decayeddev_/Documents/lunar-assets/gam"
API_BASE="https://gitlab.com/api/v4/projects/skysthelimit.dev%2Fselenite"

# Function to download a directory recursively
download_directory() {
    local path="$1"
    local local_dir="$2"
    
    echo "Downloading directory: $path to $local_dir"
    
    # Create local directory if it doesn't exist
    mkdir -p "$local_dir"
    
    # Get directory contents
    local files=$(curl -s "$API_BASE/repository/tree?path=$path&ref=main" | jq -r '.[] | select(.type == "blob") | "\(.name),\(.path)"')
    local dirs=$(curl -s "$API_BASE/repository/tree?path=$path&ref=main" | jq -r '.[] | select(.type == "tree") | "\(.name),\(.path)"')
    
    # Download files
    echo "$files" | while IFS=',' read -r filename filepath; do
        if [ -n "$filename" ] && [ -n "$filepath" ]; then
            echo "  Downloading file: $filename"
            curl -s "$API_BASE/repository/files/$filepath/raw?ref=main" -o "$local_dir/$filename"
        fi
    done
    
    # Recursively download subdirectories
    echo "$dirs" | while IFS=',' read -r dirname dirpath; do
        if [ -n "$dirname" ] && [ -n "$dirpath" ]; then
            download_directory "$dirpath" "$local_dir/$dirname"
        fi
    done
}

# Function to standardize game format
standardize_game() {
    local game_dir="$1"
    
    echo "Standardizing game: $(basename "$game_dir")"
    
    # Find and convert icon to img.webp
    local icon_files=()
    
    # Look for common icon patterns
    for pattern in "icon.png" "icon.jpg" "icon.jpeg" "icon.webp" "logo.png" "logo.jpg" "logo.jpeg" "logo.webp" "splash.png" "splash.jpg" "splash.jpeg" "splash.webp" "thumb.png" "thumb.jpg" "thumb.jpeg" "thumb.webp"; do
        if [[ -f "$game_dir/$pattern" ]]; then
            icon_files+=("$game_dir/$pattern")
        fi
    done
    
    # If no common patterns, look for any image file
    if [[ ${#icon_files[@]} -eq 0 ]]; then
        for ext in png jpg jpeg webp; do
            for file in "$game_dir"/*.$ext; do
                if [[ -f "$file" ]]; then
                    icon_files+=("$file")
                fi
            done
        done
    fi
    
    # Convert first found icon to img.webp
    if [[ ${#icon_files[@]} -gt 0 ]]; then
        local icon="${icon_files[0]}"
        echo "  Converting $(basename "$icon") to img.webp"
        
        if command -v magick &> /dev/null; then
            magick "$icon" "$game_dir/img.webp"
        elif command -v convert &> /dev/null; then
            convert "$icon" "$game_dir/img.webp"
        else
            cp "$icon" "$game_dir/img.webp"
        fi
    else
        echo "  No icon found for $(basename "$game_dir")"
    fi
    
    # Ensure index.html exists
    if [[ -f "$game_dir/index.html" ]]; then
        echo "  Already has index.html"
    else
        # Look for other HTML files
        for html_file in "$game_dir"/*.html "$game_dir"/*.htm; do
            if [[ -f "$html_file" ]]; then
                echo "  Renaming $(basename "$html_file") to index.html"
                mv "$html_file" "$game_dir/index.html"
                break
            fi
        done
    fi
}

# Get all games from semag directory
echo "Fetching game list from Selenite semag directory..."
games=$(curl -s "$API_BASE/repository/tree?path=semag&ref=main&per_page=100" | jq -r '.[] | select(.type == "tree") | .name')

# Download each game
for game in $games; do
    if [[ -n "$game" ]]; then
        game_path="semag/$game"
        local_path="$GAME_DIR/$game"
        
        # Skip if game already exists
        if [[ -d "$local_path" ]]; then
            echo "Game $game already exists, skipping download"
            standardize_game "$local_path"
        else
            echo "Downloading game: $game"
            download_directory "$game_path" "$local_path"
            standardize_game "$local_path"
        fi
        
        echo ""
    fi
done

echo "Game download and standardization complete!"
