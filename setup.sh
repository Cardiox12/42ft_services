#!/bin/bash

# Setup.sh
# 
# Steps :
# 	- Setup Kubernetes cluster environment :
#		- Check if minikube exists
#		- Delete minikube cluster
#		- Start minikube with vm driver previously chosen
#		- Install metalLB
#	- Build docker local images
#	- Deploy :
#		- Service
#		- Deployment
#

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
PBAR_SIZE=50



HEADER=$(cat <<HEADER_S
	███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
	██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
	█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
	██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
	██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚█████╗███████╗███████║
	╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
HEADER_S
)

ProgressBar()
{
	#	Provide a progress bar.
	#
	#	ProgressBar [--help], [done,  target,  size,  advance,  left,  begin,  ending,  label]
	#	 Parameters
	#	 	:done:		the current progress depending on target
	#	 	:target:	the target number to achieve
	#	 	:size:		the size of the ProgressBar
	#	 	:advance:	the character representing the advanced into the progress bar
	#	 	:left:		the character representing the left space into the progress bar
	#	 	:begin:		the trailing character representing progress bar begin delimiter
	#	 	:ending:	the trailing character representing progress bar end delimiter
	#	 	:label:		the progress bar label
	#

	if [ "$#" != 8 ]
	then
		printf "$_help\n"
		exit 1
	fi

	_progress=$(( ${1} * 100 / ${2} * 100 / 100 ))
	_done=$(( ${_progress} * ${3} / 10 / 10 ))
	_left=$(( ${3} - $_done ))

	_fill=$(printf "%${_done}s")
	_empty=$(printf "%${_left}s")

	printf "\r${8} : ${6}${_fill// /${4}}${_empty// /${5}}${7} ${_progress}%%"
}

BasicProgressBar()
{
	#	Provide a basic progress bar.
	#
	#	ProgressBar [--help], [done,  target,  size, label]
	#	 Parameters
	#	 	:done:		the current progress depending on target
	#	 	:target:	the target number to achieve
	#	 	:size:		the size of the ProgressBar
	#	 	:label:		the progress bar label
	#
	if [ "$#" != 4 ]
	then
		exit 1
	fi
	ProgressBar "${1}" "${2}" "${3}" "#" " " "[" "]" "${4}"
}

status_msg()
{
	if [ "$#" = "2" ]
	then
		case $1 in
			"danger")
				printf "$RED==>$NC $2\n"
				;;
			"warning")
				printf "$ORANGE==>$NC $2\n"
				;;
			"success")
				printf "$YELLOW==>$NC $2\n"
				;;
		esac
	fi
}

print_category()
{
	if [ "$#" = "1" ]
	then
		echo ""
		echo ""
		printf ">>> $YELLOW$1$NC \n"
	fi
}

print_header()
{
	echo "$HEADER"
}

select_driver()
{
	printf "Select Minikube vm driver\n"
	for index in ${!drivers[*]}
	do
		item=${drivers[$index]}
		printf "$(( index + 1 ))) $item\n"
	done

	printf "> "
	read index
	echo ""

	if [[ "$index" -gt "0" ]] && [[ "$index" -le "2" ]]
	then
		driver=${drivers[$(( index - 1))]}
		status_msg success "Vm driver is set to $BLUE$driver$NC" 
	else
		status_msg warning "Vm driver is set to default driver $BLUE$driver$NC"
	fi
}

minikube_setup()
{
	if minikube &> /dev/null
	then
		status_msg success "Minikube is installed"
	else
		status_msg danger "Minikube is missing" 
		exit 1
	fi

	if [[ "${_preserve_session}" == 1 ]]
	then
		status_msg success "Preserve session : ${BLUE}on${NC}"
	else
		status_msg warning "Preserve session : ${RED}off${NC}"
		if minikube delete &> /dev/null
		then
			status_msg success "Removing old minikube clusters"
		else
			status_msg danger "Removing old minikube clusters failed"
			exit 1
		fi
	fi

	status_msg success "Starting minikube ... be patient"
	if minikube start --vm-driver="$driver" --extra-config=apiserver.service-node-port-range=1-35000 &> /dev/null
	then
		status_msg success "Minikube started successfully"
	else
		status_msg danger "Minikube startup failed"
		exit 1
	fi
}

print_docker_images()
{
	folders="${1}"

	printf "%-20s %-20s\n" "IMAGE" "STATUS"
	for index in ${!folders[*]}
	do
		printf "%-20s ${GREEN}%-20s${NC}\n" "$(basename ${folders[${index}]})" "created"
		sleep 0.2
	done
}

setup_images()
{
	folders=()

	eval $(minikube -p minikube docker-env)

	for folder in $(ls -d ./srcs/images/**)
	do
		folders+=( "${folder}" )
	done

	size="${#folders[@]}"

	for index in ${!folders[*]} ; do 
		image="${folders[${index}]}"
		image_name="$(basename ${image})"

		if docker build -t "${image_name}" "${image}" &> /dev/null
		then
			BasicProgressBar "$(( index + 1 ))" "$size" "${PBAR_SIZE}" "Building images" 
		else
			echo ""
			echo ""
			status_msg danger "Building ${image_name} failed"
			exit 1
		fi
	done

	echo ""

	print_docker_images "$folders"
}

setup_metallb()
{
	kubectl get configmap kube-proxy -n kube-system -o yaml | \
		sed -e "s/strictARP: false/strictARP: true/" | \
		kubectl apply -f - -n kube-system &> /dev/null
	status_msg success "Configure kube-proxy ARP"

	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml &> /dev/null
	status_msg success "Creating metallb-system namespace"

	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml &> /dev/null
	status_msg success "Installing MetalLB"

	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" &> /dev/null
	status_msg success "Creating metallb-system secret key"

	kubectl apply -f ./srcs/manifests/config/config.yaml &> /dev/null
	status_msg success "Configure IP range"
}

deploy()
{	
	# Create configmaps from config files
	status_msg success "Creating configmaps"
	kubectl create configmap nginx-conf --from-file=./srcs/manifests/configmaps/nginx/serv.conf

	# Create Deployments and Services
	status_msg success "Deploying in progress"

	printf "%-20s %-20s\n" "NAME" "STATUS"
	for deployment in $(ls -d ./srcs/manifests/deployments/*)
	do
		if kubectl apply -f "${deployment}" &> /dev/null
		then
			printf "%-20s ${GREEN}%-20s${NC}\n" "$(basename ${deployment%.*})" "deploy"
		else
			printf "%-20s ${RED}%-20s${NC}\n" "$(basename ${deployment%.*})" "failure"
		fi
	done
}

main()
{
	drivers=("virtualbox" "docker")
	default=${drivers[0]}
	driver=$default
	_preserve_session=0

	if [ "$1" == "--preserve-session" ]
	then
		_preserve_session=1
	fi

	print_header

	# print_category "Minikube"
	# select_driver
	# minikube_setup

	# print_category "Docker"
	# setup_images

	# print_category "MetalLB"
	# setup_metallb

	print_category "Kubernetes"
	deploy
}

main $@
