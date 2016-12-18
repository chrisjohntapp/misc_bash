#!/bin/bash

# appd-pkgbuild -- <chrisjohntapp@gmail.com>

# Packages AppDynamics agent archives into .deb packages.
# Currently tar and zip archive types are supported.

validate_args()
{
  if [[ -f $1 ]] && [[ ! -x $1 ]]; then
    archive=$(readlink -f $1)
  else
    echo "Archive file must be a regular, non-executable file."
    exit 2
  fi

  if [[ -d $2 ]] && [[ -w $2 ]]; then
    build_dir=$(readlink -f $2) 
  else
    echo "Build directory must be a writable directory."
    exit 3
  fi
}

check_deps()
{
  unzip=$(which unzip) \
      || echo "No 'unzip' binary found. Not a problem unless you need to unpack a .zip archive."
  tar=$(which tar) \
      || echo "No 'tar' binary found. Not a problem unless you need to unpack a tar archive."
  gzip=$(which gzip) \
      || echo "No 'gzip' binary found. Not a problem unless you need to unpack a .gz archive."
  bunzip2=$(which bunzip2) \
      || echo "No 'bunzip2' binary found. Not a problem unless you need to unpack a .bz2 archive."
}

get_input()
{
  printf "Enter the package type ('db', 'java', 'machine' or 'php'): "
  
  while [[ "$package_type" != +(db|java|machine|php) ]]; do
    
    read -r package_type
    if [[ "$package_type" != +(db|java|machine|php) ]]; then
	echo "Package type must be one of 'db', 'java' 'machine' or 'php'."
    fi
  
  done

  read -rep "What is the package version number? (include epoch and release number. eg. '4.1.3.2-1'): " version
  read -rep "What architecture are you building for? (use 'dpkg-architecture -L' for a list of available names): " -i 'amd64' arch
  read -rep 'Who are you?: ' -i 'Christopher J Tapp <chrisjohntapp@gmail.com>' whoyou
}

unpack_archive()
{
  case "$package_type" in
    'db')
      agent_home='DBAgent' ;;
    'java')
      agent_home='JavaAppServerAgent' ;;
    'machine')
      agent_home='MachineAgent' ;;
    'php')
      agent_home='PHPAgent' ;;
    *)
      { echo "Something went wrong, sorry I can't be more helpful. Exiting."; exit 4; } ;;
  esac

  mkdir -p "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/opt/AppDynamicsPro/${agent_home}" \
      || { echo "Could not create directory tree in build_dir: ${build_dir}"; exit 5; }

  case "$archive" in
    *zip)
      $unzip "$archive" -d "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/opt/AppDynamicsPro/${agent_home}" \
	  || { echo "Could not unpack zip archive:  ${archive}"; exit 6; } ;;
    *tar)
      $tar xf "$archive" -C "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/opt/AppDynamicsPro/${agent_home}" \
	  || { echo "Could not unpack tar archive: ${archive}"; exit 7; } ;; 
    *tar.gz)
      $tar xzf "$archive" -C "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/opt/AppDynamicsPro/${agent_home}" \
	  || { echo "Could not unpack tar.gz archive: ${archive}"; exit 8; } ;; 
    *tar.bz2)
      $tar xjf "$archive" -C "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/opt/AppDynamicsPro/${agent_home}" \
	  || { echo "Could not unpack tar.bz2 archive: ${archive}"; exit 9; } ;; 
    *)
      { echo "The archive does not appear to be in a supported format. Exiting";  exit 10; } ;;
  esac
}

create_metadata()
{
  mkdir "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/DEBIAN" \
      || { echo "Could not create DEBIAN metadata directory." ; exit 11; }
  
  control="${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}/DEBIAN/control"
  touch "$control" \
      || { echo "Could not create DEBIAN/control metadata file." ; exit 12; }

  echo 
  echo "==========================================================================================="
  echo "Please check/edit the metadata file. Don't leave any undefined values."
  echo "==========================================================================================="
  echo 
  sleep 4

  echo "Package: appdynamics-${package_type}-agent
Version: $version
Architecture: $arch
Priority: optional
Maintainer: $whoyou
Description: AppDynamics Pro $package_type agent." > "$control" \
      || { echo "Could not populate the DEBIAN/control metadata file." ; exit 13; }

  ${VISUAL:-${EDITOR:-vi}} "$control" \
      || { echo "Could not open the text editor to check/edit the DEBIAN/control metadata file." ; exit 14; }
}

build_deb()
{
  dpkg-deb --build "${build_dir}/appdynamics-${package_type}-agent_${version}_${arch}" \
      || { echo "dpkg-deb failed; Could not build the .deb file." ; exit 15; }
}

verify_deb()
{
  result=$(find "${build_dir}" -type f -name "*${package_type}*.deb")
  
  if [[ "x$result" = "x" ]]; then
    echo 
    echo "========================================================================================="
    echo "No $package_type .deb file was found in build_dir: ${build_dir}. Something must have gone wrong."
    echo "========================================================================================="
    echo "Script complete."
    echo "========================================================================================="
    exit 16
  else
    echo 
    echo "========================================================================================="
    echo "$result found in build_dir: ${build_dir}.  All looks good.  Script complete."
    echo "========================================================================================="
    echo 
    exit 0
  fi
}

usage()
{
  echo "Usage: $(basename $0) <archive_file> <build_directory>"
  exit 1
}

main()
{
  validate_args $1 $2
  check_deps
  get_input
  unpack_archive
  create_metadata
  build_deb
  verify_deb
}

[[ "$#" -ne 2 ]] && usage || main $1 $2

# EOF
