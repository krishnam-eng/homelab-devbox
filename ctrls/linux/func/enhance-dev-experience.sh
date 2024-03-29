#!/usr/bin/env bash
################
#description    : Enhance developer experience on working with Kubernetes
#author	        : krishnam
################

function kubelab() {
  # Start the timer
  local start_time=$(date +%s.%N)

  case "$1" in
      restart)
          # Add your specific action for restart
          tlog $INFO "Performing restart action..."
          # Shutdown if it is already running - gives restart
          shutdown_minikube
          init_minikube_environment
          ;;
      start)
          # Add your specific action for start
          tlog $INFO "Performing start action..."
          init_minikube_environment
          ;;
      stop)
          # Add your specific action for stop
          tlog $INFO  "Performing stop action..."
          shutdown_minikube
          ;;
      purge)
          # Add your specific action for stop
          tlog $INFO  "Performing purge action..."
          purge_minikube
          ;;
      *)
          echo "Unknown command: $1"
          ;;
  esac

  # End the timer
  local end_time=$(date +%s.%N)
  local time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $TRACE "Time taken for kubelab to perform $1: $time_taken seconds"
}

# If the setup is done from complete scratch after docker images clean up,
# it will take 3 minutes and 21 seconds
function init_minikube_environment() {

  # Start the timer
  local start_time=$(date +%s.%N)

  start_minikube
  enable_minikube_addons
  create_utility_services
  inspect_minikube

  # End the timer
  local end_time=$(date +%s.%N)
  local time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $TRACE "Time taken for init_minikube: $time_taken seconds"

  # Keep the system awake for next 10 hrs or till it goes to manual sleep
  caffeinate -u -t 36000 &
}

#
######################### < Minikube > #########################
#
function start_minikube() {
  # Start the timer
  local start_time=$(date +%s.%N)

  start_docker

  tlog $INFO "Launching minikube..."
  minikube start --memory=6g --cpus=2

  # End the timer
  local end_time=$(date +%s.%N)
  local time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $TRACE "Time taken for start_minikube: $time_taken seconds"
}

function enable_minikube_addons() {
  # Start the timer
  local start_time=$(date +%s.%N)

  # The default addons: dashboard, storage-provisioner, default-storageclass, ingress, and registry

  # for monitoring the resource usage of Kubernetes nodes and containers
  minikube addons enable metrics-server > /dev/null

  # The Portainer add-on provides a web-based graphical user interface (GUI)
  # to manage Docker containers, images, networks, and volumes running inside a Minikube cluster
  # to deploy and manage Kubernetes resources from the same UI, including managing namespaces, pods, services, and deployments
  # minikube addons enable portainer > /dev/null

  # Container Storage Interface (CSI) driver that provides the ability to use hostPath as a persistent volume.
  # HostPath is a simple way to provide persistent storage for pods in a single node Kubernetes cluster or in a development or test environment
  # minikube addons enable volumesnapshots > /dev/null
  # minikube addons enable csi-hostpath-driver > /dev/null

  # The Kong addon for Minikube installs the Kong API Gateway in the Kubernetes cluster.
  # Kong is an open-source API gateway that allows developers to manage API requests, authentication, and traffic policies.
  # minikube addons enable kong > /dev/null

  # installs the Istio service mesh in the Kubernetes cluster.
  # The Minikube Istio add-on installs the Istio control plane components such as Pilot, Mixer, Citadel, and Galley, and the Istio data plane sidecar proxy (Envoy) in each pod of the service mesh
  # minikube addons enable istio > /dev/null

  # End the timer
  local end_time=$(date +%s.%N)
  local time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $TRACE "Time taken for enable_minikube_addons: $time_taken seconds"
}


function inspect_minikube() {
  tlog $INFO "minikube status"
  minikube status
  tlog $INFO "IP address of the Minikube VM"
  minikube ip
  tlog $INFO "Kubernetes Cluster Info"
  minikube kubectl cluster-info
  tlog $INFO "Background Jobs Running..."
  jobs
}

function shutdown_minikube() {
  # Start the timer
  local start_time=$(date +%s.%N)

  if minikube status &>/dev/null; then
      tlog $INFO "Shutting down Minikube"
      minikube stop
  fi

  tlog $INFO "Stopping octant dashboard"
  echo $(pgrep "octant") | xargs kill

  # End the timer
  end_time=$(date +%s.%N)

  # Calculate the time taken in seconds
  time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $LOG "Time taken: $time_taken seconds"
}

function kill_minikube_dashboard() {
  if pgrep -f 'minikube dashboard' >/dev/null; then
    tlog $WARN "Killing Minikube dashboard..."
    set pids = echo $(pgrep -f 'minikube dashboard' | tr '\n' ' ')
    kill $(pgrep -f 'minikube dashboard' | tr '\n' ' ')
  fi
}

function purge_minikube() {
  while true; do
      echo -n "Do you want to perform the purge (y/n): "
      stty -echo
      read -r response
      stty echo
      echo
      case "$response" in
          [yY][eE][sS]|[yY])
              tlog $WARN "Purging resources created in Minikube VM..."
              minikube delete
              break
              ;;
          [nN][oO]|[nN])
              tlog $INFO "Action canceled."
              break
              ;;
          *)
              tlog $ERROR "Invalid input. Please enter 'y' or 'n'."
              ;;
      esac
  done
}

#
######################### < Docker > #########################
#

#
# Common
#

#
# Curl
# K8S Dashboard, Portainer, Octant, Custom utilities
# TODO: verify namespace, context before running kubectl cmds
function create_utility_services(){
  # Start the timer
  local start_time=$(date +%s.%N)

  # Start useful diagnostics tools
  if minikube status &>/dev/null; then
    tlog $INFO "Create curl deployment..."
    # kubectl apply -f ~/hrt/boot/settings/k8s/curl-deployment.yml
    # todo: curl pod is in crashloop - find better alternative
  fi

  cd $HOME/hrt/svc/helm-local-repo
  http-server -p 8512 &

  if docker ps | grep portainer > /dev/null; then
    tlog $INFO "Portainer is already running"
  else
    tlog $INFO "Running portainer container..."
    # limit resource usage like t2.micro
    docker run -d -p 9000:9000 --name portainer --cpus=1 --memory=1g --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
    tlog $INFO "Portainer container port is published to the host in 9000"
  fi

  if pgrep "octant"  > /dev/null ; then
   tlog $INFO "Octant is already running"
  else
    tlog $WARN "Octant is not running. Starting the octant dashboard..."
    octant --disable-open-browser &> /dev/null &
  fi

  # todo:
  #Prometheus: To monitor the performance and health of your Kubernetes cluster.
  #Grafana: To create and display dashboards for monitoring Kubernetes and other systems.
  #Fluentd: To collect, parse, and forward logs from containers and applications running on Kubernetes.
  #Elasticsearch: To store and search logs and other data.
  #Kibana: To visualize and analyze data stored in Elasticsearch.

  tlog $INFO "Launching minikube dashboard in the background..."
  if lsof -Pi :13114 -sTCP:LISTEN -t >/dev/null ; then
    tlog $ERROR "Port 13114 is already in use"
    tlog $FATAL "Waiting until you kill that process(es)"
    echo $(lsof -i :13114 -sTCP:LISTEN)

    # wait until port becomes available
    wait_until 60 5 "! nc -z localhost 13114"
  else
    echo "Port 13114 is available"
    kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 13114:80 > /dev/null &
  fi
  # !! minikube dashboard --port=13114 --url=true &
  # ^ This one is unreliable since killing of the process has to be taken care

  # End the timer
  local end_time=$(date +%s.%N)
  local time_taken=$(echo "$end_time - $start_time" | bc)
  tlog $TRACE "Time taken for create_utility_services: $time_taken seconds"
}
