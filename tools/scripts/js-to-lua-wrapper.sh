#!/bin/bash

# js-to-lua-wrapper.sh
# Wrapper script for the js-to-lua executable that provides default babel configs

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default babel config files (relative to script location)
DEFAULT_BABEL_CONFIG="$SCRIPT_DIR/babel-ts.config.json"
DEFAULT_BABEL_TRANSFORM_CONFIG="$SCRIPT_DIR/babel-transform-react.config.json"

# Check if babel configs exist
if [[ ! -f "$DEFAULT_BABEL_CONFIG" ]]; then
  echo "Error: Default babel config not found at $DEFAULT_BABEL_CONFIG"
  exit 1
fi

if [[ ! -f "$DEFAULT_BABEL_TRANSFORM_CONFIG" ]]; then
  echo "Error: Default babel transform config not found at $DEFAULT_BABEL_TRANSFORM_CONFIG"
  exit 1
fi

# Get the executable path (assume it's in the same directory as this script)
EXECUTABLE="$SCRIPT_DIR/js-to-lua"

if [[ ! -f "$EXECUTABLE" ]]; then
  echo "Error: js-to-lua executable not found at $EXECUTABLE"
  exit 1
fi

# Run the executable with default babel configs if not provided
ARGS=()
HAS_BABEL_CONFIG=false
HAS_BABEL_TRANSFORM_CONFIG=false

# Parse arguments to see if babel configs are already provided
for arg in "$@"; do
  if [[ "$arg" == "--babelConfig" ]] || [[ "$arg" == "--babelTransformConfig" ]]; then
    if [[ "$arg" == "--babelConfig" ]]; then
      HAS_BABEL_CONFIG=true
    else
      HAS_BABEL_TRANSFORM_CONFIG=true
    fi
  fi
  ARGS+=("$arg")
done

# Add default babel configs if not provided
if [[ "$HAS_BABEL_CONFIG" == false ]]; then
  ARGS+=("--babelConfig" "$DEFAULT_BABEL_CONFIG")
fi

if [[ "$HAS_BABEL_TRANSFORM_CONFIG" == false ]]; then
  ARGS+=("--babelTransformConfig" "$DEFAULT_BABEL_TRANSFORM_CONFIG")
fi

# Execute the command
exec "$EXECUTABLE" "${ARGS[@]}"
