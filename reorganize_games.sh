#!/bin/bash

# Script to reorganize games to /gamename format with index.html and img.webp

GAME_DIR="/Users/decayeddev_/Documents/lunar-assets"

# Function to reorganize a single game
reorganize_game() {
    local game_path="$1"
    local game_name=$(basename "$game_path")
    
    echo "Reorganizing game: $game_name"
    
    # Skip if not a directory
    if [[ ! -d "$game_path" ]]; then
        return
    fi
    
    # Skip if already in correct format (only has index.html and img.webp)
    local file_count=$(find "$game_path" -maxdepth 1 -type f | wc -l)
    if [[ $file_count -le 2 ]] && [[ -f "$game_path/index.html" ]] && [[ -f "$game_path/img.webp" ]]; then
        echo "  -> Already in correct format"
        return
    fi
    
    # Create temp directory for the game
    local temp_dir="$GAME_DIR/temp_$game_name"
    mkdir -p "$temp_dir"
    
    # Copy index.html
    if [[ -f "$game_path/index.html" ]]; then
        cp "$game_path/index.html" "$temp_dir/"
        echo "  -> Copied index.html"
    else
        # Look for other HTML files
        for html_file in "$game_path"/*.html "$game_path"/*.htm; do
            if [[ -f "$html_file" ]]; then
                cp "$html_file" "$temp_dir/index.html"
                echo "  -> Copied $(basename "$html_file") as index.html"
                break
            fi
        done
    fi
    
    # Copy img.webp
    if [[ -f "$game_path/img.webp" ]]; then
        cp "$game_path/img.webp" "$temp_dir/"
        echo "  -> Copied img.webp"
    else
        # Look for icon files to convert
        local icon_files=()
        for pattern in "icon.png" "icon.jpg" "icon.jpeg" "icon.webp" "logo.png" "logo.jpg" "logo.jpeg" "logo.webp" "splash.png" "splash.jpg" "splash.jpeg" "splash.webp" "thumb.png" "thumb.jpg" "thumb.jpeg" "thumb.webp" "cover.png" "cover.jpg" "cover.jpeg" "cover.webp"; do
            if [[ -f "$game_path/$pattern" ]]; then
                icon_files+=("$game_path/$pattern")
            fi
        done
        
        # If no common patterns, look for any image file
        if [[ ${#icon_files[@]} -eq 0 ]]; then
            for ext in png jpg jpeg webp; do
                for file in "$game_path"/*.$ext; do
                    if [[ -f "$file" ]]; then
                        icon_files+=("$file")
                    fi
                done
            done
        fi
        
        # Convert first found icon to img.webp
        if [[ ${#icon_files[@]} -gt 0 ]]; then
            local icon="${icon_files[0]}"
            if command -v magick &> /dev/null; then
                magick "$icon" "$temp_dir/img.webp"
            elif command -v convert &> /dev/null; then
                convert "$icon" "$temp_dir/img.webp"
            else
                cp "$icon" "$temp_dir/img.webp"
            fi
            echo "  -> Converted $(basename "$icon") to img.webp"
        else
            echo "  -> No icon found for $game_name"
        fi
    fi
    
    # Remove original directory and move temp directory
    rm -rf "$game_path"
    mv "$temp_dir" "$game_path"
    
    echo "  -> Reorganized successfully"
}

# Process each game directory
for game_path in "$GAME_DIR"/*; do
    if [[ -d "$game_path" ]]; then
        game_name=$(basename "$game_path")
        
        # Skip non-game directories
        if [[ "$game_name" == ".git" ]] || [[ "$game_name" == ".vscode" ]] || [[ "$game_name" == "gam" ]]; then
            continue
        fi
        
        reorganize_game "$game_path"
        echo ""
    fi
done

echo "Game reorganization complete!"
