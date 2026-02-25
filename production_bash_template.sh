#!/usr/bin/env bash

set -Eeuo pipefail

LOG_FILE="/var/log/myapp.log"

#######################################
# log: writes message to log file
# Globals:
#   LOG_FILE
# Arguments:
#   $1 - log level (INFO|WARN|ERROR)
#   $2 - message
#######################################
log() {
    local level="$1"
    local message="$2"
    local timestamp

    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    printf "[%s] [%s] %s\n" "$timestamp" "$level" "$message" | tee -a "$LOG_FILE"
}

#######################################
# check_file: verifies file existence
# Arguments:
#   $1 - file path
# Returns:
#   0 if exists
#   1 if not exists
#######################################
check_file() {
    local file="$1"

    if [[ -z "${file:-}" ]]; then
        log "ERROR" "No file path provided"
        return 1
    fi

    if [[ -f "$file" ]]; then
        log "INFO" "File exists: $file"
        return 0
    else
        log "ERROR" "File not found: $file"
        return 1
    fi
}

#######################################
# Main
#######################################
main() {

    if [[ $# -ne 1 ]]; then
        log "ERROR" "Usage: $0 <file_path>"
        exit 1
    fi

    local target_file="$1"

    if check_file "$target_file"; then
        log "INFO" "Processing file..."
        # here goes production logic
    else
        log "ERROR" "Aborting due to missing file"
        exit 1
    fi
}

main "$@"
