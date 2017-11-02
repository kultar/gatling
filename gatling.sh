#/bin/bash
## Arguments:
##  -b  <branch_name> 
##      This will switch to the branch that your test exists in
##  -s <scenario_name>
##      This will execute the scenario passed, otherwise it'll be interactive in scenario selection

# check to make sure docker is installed

if [[ ! "$(docker --version)" == *"version"* ]]; then
  echo "Install Docker-CE from https://www.docker.com/community-edition#/download"
  exit 0
fi


# first build the gatling container if it isn't already
if [[ -z "$(docker images -q gatling:latest)" ]]; then
  docker build -t gatling .
fi

	
while getopts ":b:s:" o; do
    case "${o}" in
        b) branch=${OPTARG}
        ;;
        s) scenario=${OPTARG}
        ;;
    esac
done

# get current working directory
dir=$(pwd)

if [[ -z "$branch" ]];then
  git checkout master
  git pull origin master
else
  git checkout $branch
  git pull origin $branch
fi

if [[ -z "$scenario" ]];then
  docker run -v ${dir}/results:/opt/gatling/results -v ${dir}/user-files:/opt/gatling/user-files -it gatling
else
  docker run -v ${dir}/results:/opt/gatling/results -v ${dir}/user-files:/opt/gatling/user-files -it gatling -s ${scenario}
fi
 
