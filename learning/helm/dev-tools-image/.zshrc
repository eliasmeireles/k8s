# Ip check
alias ipCheck="ip a | grep -oP 'inet\s+\K(?!127\.0\.0\.1)[\d.]+'"

# Docker
alias dlist="docker image ls"
alias dp="docker ps"
alias dpa="docker ps -a"
alias dcrm="docker container rm"
alias dcrmf="docker container rm -f"
alias dexec="docker exec -it"
# Copy from docker container example: dcopy my-container:/app/app.yaml
alias dcopy="docker cp"
alias dlf="docker logs -f"
alias dl="docker logs"
alias dirm="docker image rm"
alias dirmf="docker image rm -f"
alias ds="docker save -o"

# Docker compose
alias dcb="docker-compose up --build -d"
alias dcbf="docker-compose up --build -d --force-recreate"
alias dclf="docker-compose logs -f"
alias dcl="docker-compose logs"
alias dck="docker-compose kill"

# Disk
alias diskUsage="df -h --total"

# Zip
alias tar-unzip="tar -xvzf"
alias tar-zip="tar cvfz"

alias clearPort='f(){sudo kill -9 $(sudo lsof -t -i:"$1")};f'

# Zip
alias tar-unzip="tar -xvzf"
alias tar-zip="tar cvfz"

# Kubernetes
alias kubExec='f(){kubectl exec --stdin --tty $1 -- /bin/bash}; f'
alias k='kubectl'
# Streamar logs das pods apartir do namespace getLogsF -lapp service-name
alias getLogsF='kubectl logs -f --since=12h --tail=1000000 --max-log-requests=15'
# Streamar logs das pods com prefixo da pod apartir do namespace exemplo: getLogsFP -lapp service-name
alias getLogsFP='kubectl logs -f --since=12h --tail=1000000 --prefix=true --max-log-requests=15'
alias kubDescServices="kubectl describe svc"
alias kubDescPods="kubectl describe pods"
alias kubDescNodes="kubectl describe nodes"
alias kubDescConfig="kubectl describe configmap"
alias getNodes="kubectl get nodes"
alias kubApply="kubectl apply -f"
alias getServices="kubectl get svc"
alias getConfigMaps="kubectl get configmap"
alias getPods='kubectl get pods'
alias getHpa='kubectl get hpa'
alias getDeployments='kubectl get deployments'
alias uatContext='kubectl config use-context uat'
alias prdContext='kubectl config use-context prd'
alias getJobs='kubectl get pods -n jobs'
# Localizar jobs apartir de um nome exemplo: findJobs some-text-in-pode-name
alias findJobs='kubectl get pods -n jobs | grep'
# Localizar jobs apartir de um nome exemplo: findPods some-text-in-pode-name
alias findPods='kubectl get pods | grep'
# Criar um job manual apartir do namespace exemplo: createJob service-name
alias createJob='f(){kubectl create job -n jobs --from="cronjob/$1" "$1-ef$(date +%H%M)"}; f $@'
# Streamar logs das pods com prefixo da pod apartir do namespace, e abrir o arquivo no vs code, exemplo: getLogsCode service-name
alias getLogsCode='log(){code ~/Downloads/"$1".log && kubectl logs -f --since=12h --tail=1000000 --prefix=true --max-log-requests=15 -lapp=$1  > ~/Downloads/"$1".log}; log'
# Obter os logs de um job exemplo: getJobLogs pode-name
alias getJobLogs='kubectl logs  -n jobs'

alias kub13="/usr/local/bin/kubectl.1.21.13"
alias kd="kubectl describe"
alias kgp="kubectl get pods"
alias kgh="kubectl get hpa"
alias kgs="kubectl get svc"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdh="kubectl describe hpa"
# example -> kdj cronjob/job-name
alias kdj="kubectl describe -n jobs"

# Git
alias gs="git status"
alias gsi="git submodule update --init"
alias gsp="git pull && git submodule foreach --recursive 'git pull ; sleep 1'"
alias gsf="git fetch && git submodule foreach --recursive 'git fetch ; sleep 1'"
alias gss="git status && git submodule foreach --recursive 'git status ; sleep 1'"
alias gsclean="git remote prune origin && git submodule foreach --recursive 'git remote prune origin ; sleep 1'"

# Maven
alias mmrun='r(){values cluster=$1 --inline | echo "Values ok..." && mvnArgs=$(pbpaste) && mvn mn:run $mvnArgs};r'
alias mci="mvn clean install"
alias mcis="mvn clean install -Dmaven.test.skip"
alias pitest="mvn clean test-compile org.pitest:pitest-maven:mutationCoverage"
alias mcp="mvn clean package"
alias mcps="mvn clean package -Dmaven.test.skip"
alias mdt="mvn dependency:tree -Ddetail=true  > ~/Downloads/dependency_tree.log && code ~/Downloads/dependency_tree.log"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

