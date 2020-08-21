#! /usr/bin/env bash

install() {
  echo "🚀 [run.sh]"
  echo
  printf "Checking for latest release... "
  local latestReleaseInfoUrl="https://api.github.com/repos/bx-sh/run.sh/releases/latest"
  local apiTarballUrl="$( curl -s "$latestReleaseInfoUrl" | grep tarball | awk '{print $2}' | sed 's/[",]//g' )"
  [ $? -ne 0 ] && { echo -e "\nFailed to get latest release version of run.sh ($latestReleaseInfoUrl)"; return 1; }
  local latestRelease="${apiTarballUrl/*\/}"
  echo "$latestRelease"
  echo
  printf "Downloading... "
  local workingDirectory="$( pwd )"
  local tempDirectory="$( mktemp -d )"
  cd "$tempDirectory"
  local downloadUrl="https://github.com/bx-sh/run.sh/archive/$latestRelease.tar.gz"
  local tarfile="${downloadUrl/*\/}"
  curl -O "$downloadUrl" &>/dev/null
  [ ! -f "$tarfile" ] && { echo "Failed to download: $downloadUrl"; return 1; }
  tar zxvf "$tarfile" &>/dev/null
  [ ! -f run.sh ] && { echo "Failed to extract $tarfile: $tempDirectory/$tarfile"; return 1; }
  local downloadedVersion="$( grep "RUN_VERSION=" run.sh | sed 's/RUN_VERSION=//' )"
  printf "run.sh version ${downloadedVersion//\"} downloaded.\n"
  echo
  cp run.sh "$workingDirectory/run.sh"
  cd "$workingDirectory"
  rm -r "$tempDirectory"
  echo "Installation complete."
  echo
  echo "source \"run.sh\" to start using!"
}

install