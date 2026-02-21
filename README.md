# Lunar Assets - Game Collection

A comprehensive collection of web games with standardized format for easy integration.

## Game Format

All games follow this standardized format:
- `img.webp` - Game icon/image
- `index.html` - Main game file

## jsDelivr CDN Usage

You can use jsDelivr to serve these games from CDN:

### Base URL
```
https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/
```

### Game Access Pattern
```
https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/[game-name]/index.html
https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/[game-name]/img.webp
```

### Examples

#### Game URLs
- 2048: https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/2048/index.html
- Cookie Clicker: https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/cookieclicker/index.html
- Slope: https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/slope/index.html

#### Game Icons
- 2048 icon: https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/2048/img.webp
- Cookie Clicker icon: https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/cookieclicker/img.webp

## Available Games

This collection includes **155+ games** from various sources including:

### Popular Games
- 2048
- Cookie Clicker
- Slope
- 1v1.lol
- Retro Bowl
- Moto X3M (and variants)
- Vex (series)
- Tunnel Rush
- Drift Boss
- And many more...

### Game Categories
- **Action**: 1v1.lol, Smash Karts, Getaway Shootout
- **Puzzle**: 2048, Little Alchemy 2
- **Idle**: Cookie Clicker, Idle Breakout
- **Racing**: Moto X3M, Drive Mad
- **Sports**: Basketball Stars, Soccer Random
- **Classic**: Retro Bowl, Tetris variants

## Integration Example

### HTML Embed
```html
<iframe 
  src="https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/2048/index.html" 
  width="800" 
  height="600" 
  frameborder="0">
</iframe>
```

### Game List with Icons
```html
<div class="game-list">
  <a href="https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/2048/index.html">
    <img src="https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/2048/img.webp" alt="2048">
    <span>2048</span>
  </a>
  
  <a href="https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/cookieclicker/index.html">
    <img src="https://cdn.jsdelivr.net/gh/darealdecayed/lunar-assets@gam/cookieclicker/img.webp" alt="Cookie Clicker">
    <span>Cookie Clicker</span>
  </a>
</div>
```

## Version Control

- **Branch**: `gam` (for game assets)
- **Main Repository**: https://github.com/darealdecayed/lunar-assets
- **Original Source**: https://github.com/brrrondrugs/lunar-assets

## Notes

- All games are standardized with `img.webp` and `index.html` format
- jsDelivr CDN provides fast, reliable hosting
- Games are ready for immediate embedding
- Icons are optimized for web delivery

## License

Games are collected from various sources. Please check individual game licenses for usage restrictions.
