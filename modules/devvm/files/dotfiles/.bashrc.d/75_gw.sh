# DEFAULTS may be overridden by calling environment.
GRADLE="${GRADLE:-gradle}"
GRADLEW="${GRADLEW:-gradlew}"
GRADLE_BUILDFILE="${GRADLE_BUILDFILE:-build.gradle}"

err() {
  echo -e "${@}" >&2
}

lookup() {
  local file="${1}"
  local curr_path="${2}"
  [[ -z "${curr_path}" ]] && curr_path="${PWD}"

  # Search recursively upwards for file.
  until [[ "${curr_path}" == "/" ]]; do
    if [[ -e "${curr_path}/${file}" ]]; then
      echo "${curr_path}/${file}"
      break
    else
      curr_path=$(dirname "${curr_path}")
    fi
  done
}

select_gradle() {
  local dir="${1}"

  # Use project's gradlew if found.
  local gradlew=$(lookup "${GRADLEW}" "${dir}")
  if [[ -z "${gradlew}" ]]; then
    err "No ${GRADLEW} set up for this project; consider setting one up:"
    err "http://gradle.org/docs/current/userguide/gradle_wrapper.html\n"
  else
    echo "${gradlew}"
    return 0
  fi

  # Deal with a missing wrapper by defaulting to system gradle.
  local gradle=$(which "${GRADLE}" 2>/dev/null)
  if [[ -z ${gradle} ]]; then
    err "'${GRADLE}' not installed or not available in your PATH:"
    err "${PATH}"
  else
    echo "${gradle}"
    return 0
  fi

  return 1
}

execute_gradle() {
  local build_gradle=$(lookup "${GRADLE_BUILDFILE}")
  local gradle=$(select_gradle "${working_dir}")
  local build_args=( ${BUILD_ARG} "$@" )

  if [[ -n "${build_gradle}" ]]; then
    # We got a good build file, start gradlew there.
    cd "$(dirname "${build_gradle}")"
  else
    err "Unable to find a gradle build file named ${GRADLE_BUILDFILE}."
  fi

  # Say what we are gonna do, then do it.
  err "Using gradle at '${gradle}' to run buildfile '${build_gradle}':\n"
  if [[ -n "build_args[@]" ]]; then
    "${gradle}" "${build_args[@]}"
  else
    "${gradle}"
  fi
}

export -f execute_gradle select_gradle lookup err
alias gw=execute_gradle

