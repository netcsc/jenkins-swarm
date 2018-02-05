#!/bin/bash

# deploy script to update apps within docker swarm
while [[ $# -gt 1 ]]
do
    INPUT="$1"
    case $INPUT in
        -a|--application)
        APPLICATION="$2"
        shift
        ;;
        -v|--version)
        VERSION="$2"
        shift
        ;;
        -s|--stack)
        STACK="$2"
        shift
        ;;
        * )
        # Unknown
        ;;
    esac
    shift
done

# Help
do_help () {
    echo "Usage: $0 -a APPLICATION1,APPLICATION2,... -v VERSION -s STACK"
    echo "Required Variables:"
    echo "-a/--application        (e.g. app1)"
    echo "-v/--version            (e.g. 1.0.0.1)"
    echo "-s/--stack              (e.g. frontend)"
    echo " "
    exit 1
}

if [[ -z $VERSION ]]; then
    echo "WARNING: no version provided, use *latest* tag"
    VERSION="latest"
fi

IFS=',' read -a applications <<< "${APPLICATION}"

for APP in "${applications[@]}"
do     
    IMAGE_NAME="$(docker service inspect --format="{{index .Spec.Labels \"com.docker.stack.image\"}}" ${STACK}_${APP} | cut -d':' -f1,2)"
    docker service update --force --image ${IMAGE_NAME}:${VERSION} --update-parallelism 1 --update-delay 10s ${STACK}_${APP}
done
