#!/bin/sh

set -e

OLD_VOLUME_CONTAINERS="overview-blob-storage overview-database-data overview-searchindex-data"

data_container_exists() {
  container=$1
  docker ps -a -q -f "name=^/$container"'$'
}

upgrade_named_volume() {
  volume=$1
  echo "Filling volume 'overviewlocal_$volume'..."

  case $volume in
    overview-blob-storage)
      src=/var/lib/overview/blob-storage
      ;;
    overview-database-data)
      src=/var/lib/postgresql/data
      ;;
    overview-searchindex-data)
      src=/var/lib/overview/searchindex
      ;;
    *)
      echo "Internal error"
      exit 1
      ;;
  esac

  dest=/mnt/$1

  docker volume create overviewlocal_$volume >/dev/null || true

  # By the end of this command, the data container will be empty and the
  # volume will be full.
  #
  # If cancelled halfway, an incomplete file will exist on the named
  # volume and the data container's volume will still contain the correct file.
  # That's fine: next time around, "mv" will overwrite the incomplete file.
  #
  # (No, we can't just copy the files on the host filesystem: that would only
  # be easy on Linux hosts.)
  #
  # Steps:
  # 1. mkdir all directories (with wrong owners/permissions)
  # 2. mv files (with correct owners/permissions)
  # 3. cp all directories (to fix owners/permissions) -- very fast
  # 4. rm all directories
  #
  # To debug, try one of these:
  # docker run -it --volumes-from overview-blob-storage --volume overviewlocal_overview-blob-storage:/mnt/overview-blob-storage --rm busybox sh
  # docker run -it --volumes-from overview-database-data --volume overviewlocal_overview-database-data:/mnt/overview-database-data --rm busybox sh
  # docker run -it --volumes-from overview-searchindex-data --volume overviewlocal_overview-searchindex-data:/mnt/overview-searchindex-data --rm busybox sh

  docker run \
    --volumes-from $volume \
    --volume overviewlocal_$volume:$dest \
    --rm "$BUSYBOX_IMAGE" \
    sh -c "(cd $src && find . -type d -mindepth 1 -exec mkdir -p $dest/{} \; && find . -type f -exec mv {} $dest/{} \;) && cp -a $src/* $dest/ && rm -r $src/*"

  # Delete the old data-volume container and its volume
  docker rm --volumes $volume
}

need_migrate() {
  for container in $OLD_VOLUME_CONTAINERS; do
    data_container_exists $container && return
  done

  false
}

migrate_volumes_if_needed() {
  if need_migrate; then
    echo '*** DANGER: migrating data just this once ***'
    echo
    echo 'overview-local is switching to named Docker Volumes to aid debugging'
    echo 'and maintenance. We need to move Overview data files -- just this once.'
    echo 'This may take a few minutes. If you encounter an error, you can re-run'
    echo 'to continue where you left off.'
    echo

    for container in $OLD_VOLUME_CONTAINERS; do
      upgrade_named_volume $container
    done

    echo ''
    echo 'All done! Thank you for your patience.'
  fi
}
