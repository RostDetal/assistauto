#! /bin/sh

case "$1" in

  start)
    echo "Cleanup..."
      sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
    echo "done"
    ;;

esac