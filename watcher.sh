namespace="sre"
deployment="swype-app"
restart_limit=3

loop=true

while $loop; do
  restart_count=$(kubectl get pods -n $namespace | awk "/$deployment/{print \$4}") 
  echo "$deployment restart_count is $restart_count"
  if (($restart_count>$restart_limit)); then
    echo "$deployment restart_count $restart_count is greater than restart_limit $restart_limit."
    kubectl scale --replicas=0 deployment/$deployment -n $namespace
    echo "$deployment scaled down to 0."
    loop=false
    echo "loop exited."
    break
  fi
  echo "sleep 60s."
  sleep 60
done