#!/bin/bash

# Setup.sh
# 
# Steps :
# 	- Setup Kubernetes cluster environment :
#		- Check if minikube exists
#		- Delete minikube cluster
#		- Start minikube with vm driver previously chosen
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



HEADER=$(cat <<HEADER_S
	███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
	██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
	█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
	██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
	██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚█████╗███████╗███████║
	╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
HEADER_S
)


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

category()
{
	if [ "$#" = "1" ]
	then
		printf ">>> $YELLOW$1$NC \n"
	fi
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

	if minikube delete &> /dev/null
	then
		status_msg success "Removing old minikube clusters"
	else
		status_msg danger "Removing old minikube clusters failed"
		exit 1
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

main()
{
	drivers=("virtualbox" "docker")
	default=${drivers[0]}
	driver=$default

	echo "$HEADER"
	echo ""
	echo ""
	category "Minikube"
	select_driver
	minikube_setup
}

main
