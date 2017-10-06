_lib_apt=1

search_repo()
{
  unset ID_LIKE
  . /etc/os-release

  if [ ! $# = 1 ]; then
    printf "Usage: $(basename $0) <repo name substring>.\n"
    return 1
  fi

  if [ "$ID_LIKE" != "debian" ]; then
    printf "$(basename $0) is for dpkg systems only.\n"
    return 1
  fi

  if [ ! -r /var/lib/apt/lists ]; then
    printf "Could not read the package lists file.\n"
    return 1
  fi

  cd /var/lib/apt/lists && cat *$1* | grep "^Package: " | sed 's/^Package: //' | sort -u
}

# vi:syntax=sh
# EOF
