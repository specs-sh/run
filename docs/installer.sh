#! /usr/bin/env installer

install() {
  echo "🚀 [run.sh]"
  echo
  printf "Checking for latest version... "
  local latestReleaseInfoUrl="https://api.github.com/repos/bx-sh/run.sh/releases/latest"
  local downloadUrl="$( curl -s "$latestReleaseInfoUrl" | grep tarball | awk '{print $2}' | sed 's/[",]//g' )"
  [ $? -ne 0 ] && { echo -e "\nFailed to get latest release version of run.sh ($latestReleaseInfoUrl)"; return 1; }
  local latestVersion="${downloadUrl/*\/}"
  echo "$latestVersion"
  echo
  printf "Downloading... "
  local workingDirectory="$( pwd )"
  local tempDirectory="$( mktemp -d )"
  cd "$tempDirectory"
  curl -O "$downloadUrl" &>/dev/null
  [ ! -f latest.tar.gz ] && { echo "Failed to download: $downloadUrl"; return 1; }
  tar zxvf latest.tar.gz &>/dev/null
  [ ! -f run.sh ] && { echo "Failed to extract latest.tar.gz: $tempDirectory/latest.tar.gz"; return 1; }
  local runVersion="$( grep "RUN_VERSION=" run.sh | sed 's/RUN_VERSION=//' )"
  printf "run.sh version ${runVersion//"} downloaded.\n"
  echo
  cp run.sh "$workingDirectory/run.sh"
  cd "$workingDirectory"
  rm -r "$tempDirectory"
  echo "Installation complete."
  echo
  echo "source \"run.sh\" to start using!"
}

install