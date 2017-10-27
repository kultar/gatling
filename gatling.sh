#/bin/bash


# check to make sure docker is installed

if [[ ! "$(docker --version)" == *"version"* ]]; then
  echo "Install Docker-CE from https://www.docker.com/community-edition#/download"
  exit 0
fi


# first build the gatling container if it isn't already
if [[ -z "$(docker images -q gatling:latest)" ]]; then
  docker build -t gatling .
fi

# make sure we pull the latest repo if requested (flag --update)
if [[ "$1" == "--update" ]]; then
  git pull origin master
fi

# get current working directory
dir=$(pwd)

# start the container
if [[ "$1" == "-s" ]];then
  docker run -v ${dir}/results:/opt/gatling/results -v ${dir}/user-files:/opt/gatling/user-files -it gatling -s ${2}
elif [[ "$2" == "-s" ]];then
  docker run -v ${dir}/results:/opt/gatling/results -v ${dir}/user-files:/opt/gatling/user-files -it gatling -s ${3}
else 
  docker run -v ${dir}/results:/opt/gatling/results -v ${dir}/user-files:/opt/gatling/user-files -it gatling
fi
