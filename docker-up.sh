#!/bin/bash

ARG_NUMBER=3
ARGS=("--path" "--image-name" "--container-name")

if [[ "$#" != 3 ]]; then
	echo "Usage: ./docker-up.sh --path --image-name --container-name"
	exit 1
fi

# if [[ ! -d "$1" ]]; then
# 	echo "Path doesn't exists"
# fi

for arg in "$@"; do
	for _arg in "${ARGS[@]}"; do
		if [[ "$arg" =~ "${_arg}=" ]]
		then
			echo "${ARGS[1]}"
			(( ARG_NUMBER-=1 ))
			case "$arg" in
				*"${ARGS[0]}"*)
					_path="${arg//$_arg/}"
					;;
				*"${ARGS[1]}"*)
					_image_name="${arg//$_arg/}"
					;;
				*"${ARGS[2]}"*)
					_container_name="${arg//$_arg/}"
					;;
			esac
		else
			echo "Unknow parameter $arg"
			exit 2
		fi
	done
done

echo "$_path"
echo "$_container_name"
echo "$_image_name"
echo "$ARG_NUMBER"

# docker build -t $1
# docker run 

