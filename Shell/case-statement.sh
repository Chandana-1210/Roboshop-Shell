case $1 in 
    start)
        echo "Services Starting"
    ;;
    stop)
        echo "Services Stopping"
    ;;
    restart)
        echo "Services Restarting"
    ;;
    *)
        echo "Usage:$0{start|stop|restart}"
    ;;
esac
