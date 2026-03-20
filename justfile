# Justfile for ZMK Sofle firmware

default:
    @just --list

# Initialize the west workspace
init:
    @echo "Initializing west workspace..."
    west init -l config
    west update
    @echo "West workspace initialized!"

# Update west modules
update:
    @echo "Updating west modules..."
    west update
    @echo "West modules updated!"

# Build firmware for right hand
build-right:
    @echo "Building right hand firmware..."
    west build -b eyelash_sofle_right -s zmk/app -- -DSHIELD=nice_view -DZMK_CONFIG="$(PWD)/config"
    @echo "Right hand firmware built: build/zephyr/zmk.uf2"

# Build firmware for left hand
build-left:
    @echo "Building left hand firmware..."
    west build -b eyelash_sofle_left -s zmk/app -- -DSHIELD=nice_view -DZMK_CONFIG="$(PWD)/config"
    @echo "Left hand firmware built: build/zephyr/zmk.uf2"

# Build left hand with ZMK Studio support
build-studio:
    @echo "Building left hand firmware with ZMK Studio..."
    west build -b eyelash_sofle_left -s zmk/app -- -DSHIELD=nice_view -DCONFIG_ZMK_STUDIO=y -DCONFIG_ZMK_STUDIO_LOCKING=n -DZMK_CONFIG="$(PWD)/config"
    @echo "Left hand Studio firmware built: build/zephyr/zmk.uf2"

# Build all firmware variants
build-all: build-right build-left build-studio
    @echo "All firmware variants built!"

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    rm -rf build
    @echo "Build artifacts cleaned!"

# Pristine clean (build + west)
pristine: clean
    @echo "Cleaning west workspace..."
    rm -rf .west
    @echo "West workspace cleaned!"

# Flash right hand firmware (requires uf2 tool or manual copy)
flash-right: build-right
    @echo "Flash right hand: Copy build/zephyr/zmk.uf2 to your keyboard"

# Flash left hand firmware (requires uf2 tool or manual copy)
flash-left: build-left
    @echo "Flash left hand: Copy build/zephyr/zmk.uf2 to your keyboard"

# Flash left hand with ZMK Studio (requires uf2 tool or manual copy)
flash-studio: build-studio
    @echo "Flash left hand Studio: Copy build/zephyr/zmk.uf2 to your keyboard"

# Show build output directory
show-build:
    @echo "Build artifacts location: $(PWD)/build/zephyr/"

# Quick rebuild (clean and build right hand)
rebuild-right: clean build-right

# Quick rebuild (clean and build left hand)
rebuild-left: clean build-left
