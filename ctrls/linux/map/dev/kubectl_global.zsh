# output format

# json, yaml format provides even better view with kubecolor
alias -g Oj='--output json'
alias -g Oy='--output yaml'

# just the names or wide output
alias -g On='--output name'
alias -g Ow='--output wide'

# Out l-lables, i-images, wp-wide pod data
alias -g Ol="--output=custom-columns='Namespace:.metadata.namespace, Kind:.kind, Owner:.metadata.ownerReferences[*].kind, Name:.metadata.name, Node:.spec.nodeName, Lables:.metadata.labels'"
alias -g Oi="--output=custom-columns='Namespace:.metadata.namespace, Kind:.kind, Owner:.metadata.ownerReferences[*].kind, Name:.metadata.name, Node:.spec.nodeName, Image:.spec.containers[*].image'"
alias -g Opo="--output=custom-columns='Namespace:.metadata.namespace, Kind:.kind, Owner:.metadata.ownerReferences[*].kind, Name:.metadata.name, Node:.spec.nodeName, STATUS:.status.phase, Pod IP:.status.podIP, Host IP:.status.hostIP' --sort-by="
alias -g Opow="--output=custom-columns='Namespace:.metadata.namespace, Kind:.kind, Owner:.metadata.ownerReferences[*].kind, Name:.metadata.name, Node:.spec.nodeName, STATUS:.status.phase, Pod IP:.status.podIP, Host IP:.status.hostIP, QoS:.status.qosClass, Service Account:.spec.serviceAccount,READY:.status.conditions[?(@.type==\"Ready\")].status, RESTARTS:.status.containerStatuses[*].restartCount'"
alias -g Ocrd="--output=custom-columns='GROUP:.spec.group, NAME:.metadata.name, KIND:.spec.names.kind, SCOPE:.spec.scope, VERSION:.status.storedVersions'"


# these global variable will not get replaced when used in Ojp="" format.
# The below is merely a notes for important formatting cmd line
alias -g Ojp='--output jsonpath='
# e.g., Ogt '{{range .items}}{{.metadata.name}}, {{.status.phase}}{{"\n"}}{{end}}'
alias -g Ogt='--output go-template'

####### Sort
# todo: sort with custom columns is not working . fix it
alias -g Si="--sort-by=.status.hostIP --sort-by=.status.podIP"
alias -g Sn="--sort-by=.metadata.namespace --sort-by=.metadata.name"
alias -g Sk="--sort-by=.metadata.namespace --sort-by=.metadata.ownerReferences[*].kind -sort-by=.kind sort-by=.metadata.name "

# Flags
alias -g A='all' # all resources

# Use -A option
alias -g ANS='--all-namespaces'
