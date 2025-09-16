#!/bin/sh
# shellcheck disable=SC2034

ARC_DIR="$MUOS_STORE_DIR/info"
ARC_LABEL="Playtime Data"

ARC_EXTRACT() {
	DEST="$ARC_DIR"
	LABEL="$ARC_LABEL"
}

ARC_CREATE() {
	SRC="$ARC_DIR"
	LABEL="$ARC_LABEL"
	COMP=0
}
