#!/usr/bin/env bash

main() {
  setup $@
  templates_push
}

setup() {
  SCRIPT_PATH=$(readlink -f "${BASH_SOURCE:-$0}")
  BASE_DIR=$(dirname "${SCRIPT_PATH}")
  TEMPLATES=$(find "${BASE_DIR}" -maxdepth 2 -name "main.tf" | awk -F'/' '{print $(NF-1)}')
  TIMESTAMP=$(date '+%Y%m%d%H%M%S')
  [ -n "${1}" ] && TEMPLATES=${1}
}

templates_push() {
  for template in ${TEMPLATES}; do
    banner "Updating ${template}"
    if [[ "${CODER_TEMPLATES}" == *"${template}"* ]]; then
      coder template push --yes --activate --name "${TIMESTAMP}" --directory "${BASE_DIR}/${template}" ${template}
      templates_edit ${template}
      templates_archive ${template}
    else
      echo "Skipping since not in CODER_TEMPLATES environmental variables..."
    fi
  done
}

templates_edit() {
  subbanner "Updating Settings"
  args=()
  if [[ -f "${BASE_DIR}/${1}/README.md" ]]; then
    display_name=$(awk -F': ' '/^display_name: / {print $2}' "${BASE_DIR}/${1}/README.md")
    description=$(awk -F': ' '/^description: / {print $2}' "${BASE_DIR}/${1}/README.md")
    default_ttl=$(awk -F': ' '/^default_ttl: / {print $2}' "${BASE_DIR}/${1}/README.md")
    icon=$(awk -F': ' '/^icon: / {print $2}' "${BASE_DIR}/${1}/README.md")
  fi
  [[ -n "${display_name}" ]] && args+=("--display-name" "${display_name}")
  [[ -n "${description}" ]] && args+=("--description" "${description}")
  [[ -n "${default_ttl}" ]] && args+=("--default-ttl" "${default_ttl}")
  [[ -n "${icon}" ]] && args+=("--icon" "${icon}")
  echo coder template edit "${args[@]}" "${1}"
  coder template edit "${args[@]}" "${1}"
  unset display_name description default_ttl icon
}

templates_archive() {
    coder template versions list --column 'Name,Created At,Active' "${1}" | grep -Eiv "Active\s*$" | awk '{print $1}' | xargs -I '{}' coder template versions archive "${1}" '{}'
}

banner() {
    echo "==================== ${1} ===================="
}

subbanner() {
    echo "---------- ${1} ----------"
}

main $@
