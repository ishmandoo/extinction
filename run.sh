#!/bin/sh

# Check if LOVE is installed
if ! command -v love >/dev/null 2>&1; then
    echo "LOVE is not installed. Please install it first."
    exit 1
fi

# Run LOVE with the current directory
love .
