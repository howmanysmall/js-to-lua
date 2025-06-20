# Building js-to-lua as Standalone Executables

This guide explains how to build the js-to-lua converter as standalone executables that can run anywhere without requiring Node.js to be installed.

## Current Setup

The project now includes `pkg` as a development dependency and several build scripts to create standalone executables.

## Available Build Commands

### 1. Build for Current Platform Only

```bash
npm run build:exe
```

This builds the project and creates an executable for your current platform (macOS ARM64 in this case).

### 2. Build for All Platforms

```bash
npm run build:exe:all
```

This builds executables for:

- macOS x64 (Intel)
- macOS ARM64 (Apple Silicon)
- Linux x64
- Windows x64

### 3. Individual Build Steps

```bash
# Build the project first
npm run build:prod

# Then create executables
npm run pkg:build        # Current platform only
npm run pkg:build:all     # All platforms
```

## Output

Executables are created in `./dist/executables/` with the following naming:

- `js-to-lua` (current platform, when using `pkg:build`)
- `index-macos-x64`
- `index-macos-arm64`
- `index-linux-x64`
- `index-win-x64.exe`

## File Sizes

The executables are approximately 80-95MB each because they include the entire Node.js runtime and all dependencies bundled together.

## Usage

Once built, you can copy the executable anywhere and run it without Node.js:

```bash
# Copy to a directory in your PATH
cp ./dist/executables/js-to-lua /usr/local/bin/

# Or run directly
./dist/executables/js-to-lua --help
```

## Distribution

For distribution, you can:

1. **Upload to GitHub Releases**: The executables can be attached to GitHub releases
2. **Package Managers**: Create packages for homebrew, chocolatey, etc.
3. **Direct Download**: Host the executables on a web server
4. **Container Images**: Include the executable in Docker images

## Alternative Approaches

### 1. Using `nexe` (Alternative to pkg)

```bash
npm install --save-dev nexe
```

Add to package.json:

```json
{
  "scripts": {
    "build:nexe": "nexe dist/apps/convert-js-to-lua/index.js -o dist/executables/js-to-lua-nexe"
  }
}
```

### 2. Using `ncc` + `pkg` (For better bundling)

```bash
npm install --save-dev @vercel/ncc
```

This would create a single bundled file first, then package it.

### 3. Using Deno Compile (If porting to Deno)

```bash
deno compile --allow-read --allow-write --output js-to-lua main.ts
```

## Cross-Platform Considerations

- **Linux**: The executable should work on most Linux distributions
- **macOS**: Universal binaries or separate Intel/ARM builds
- **Windows**: `.exe` extension is automatically added
- **Permissions**: Make sure executables have proper permissions (`chmod +x`)

## Automation

You can automate builds in CI/CD:

```yaml
# GitHub Actions example
- name: Build Executables
  run: |
    npm ci
    npm run build:exe:all

- name: Upload Artifacts
  uses: actions/upload-artifact@v3
  with:
    name: executables
    path: dist/executables/
```

## Current Configuration

The `pkg` configuration in package.json:

```json
{
  "pkg": {
    "scripts": "dist/apps/convert-js-to-lua/**/*.js",
    "assets": ["dist/apps/convert-js-to-lua/assets/**/*"],
    "outputPath": "dist/executables"
  }
}
```

This ensures all necessary files are included in the executable bundle.

## Important: Babel Configuration for Executables

Due to how `pkg` bundles dependencies, you need to provide both babel configurations when using the standalone executable:

```bash
./js-to-lua --input input.js --output output/ \
  --babelConfig babel-ts.config.json \
  --babelTransformConfig babel-transform-react.config.json
```

The repository includes these config files:

- `babel-ts.config.json` - Basic TypeScript/JSX parsing
- `babel-transform-react.config.json` - React transformation without presets

Without these configs, the executable will fail with a "Cannot find package '@babel/preset-react'" error.
