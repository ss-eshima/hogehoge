#cat <<'EOF' $CONTAINER_WORKDIR_SET_BY_JENKINS/$APP_NAME_SET_BY_JENKINS/main.sh
cat <<'EOF' $CONTAINER_WORKDIR_SET_BY_JENKINS//main.sh

echo "curl -s -d ' {\""auth\"":null,\""method\"":\""user.login\"",\""id\"":1,\""params\"":{\""password\"":\""`echo $ZABBIX_USER_PASSWORD_SET_BY_JENKINS`\"",\""user\"":\""`echo $ZABBIX_USER_NAME_SET_BY_JENKINS`\""},\""jsonrpc\"":\""2.0\""}' -H \""Content-Type: application/json-rpc\"" http://$ZABBIX_API_HOST_SET_BY_JENKINS/zabbix/api_jsonrpc.php" | sh | jq -r '.result' > $CONTAINER_WORKDIR_SET_BY_JENKINS/.token && token=`cat $CONTAINER_WORKDIR_SET_BY_JENKINS/.token`
echo "curl -s -d ' {\""auth\"":\""`echo $token`\"",\""method\"":\""trigger.get\"",\""id\"":1,\""params\"":{\""output\"":\""extend\"",  \""expandDescription\"":1,  \""monitored\"":1,  \""filter\"":{\""status\"":0,\""value\"":1} },\""jsonrpc\"":\""2.0\""} ' -H \""Content-Type: application/json-rpc\"" http://$JENKINS_INJECTS_ZABBIX_HOST/zabbix/api_jsonrpc.php" | sh |  jq -r '.result[].description' | sort | nl

sed -i '1s/^/\`\`\`\n/' $CONTAINER_WORKFILE_SET_BY_JENKINS
sed -i -e '$ a \`\`\`' $CONTAINER_WORKFILE_SET_BY_JENKINS

curl -k -S $GO_SCRIPT_URL_SET_BY_JENKINS > $CONTAINER_WORKDIR_SET_BY_JENKINS/slack-notify.go
go run $CONTAINER_WORKDIR_SET_BY_JENKINS/slack-notify.go \
-f $CONTAINER_WORKFILE_SET_BY_JENKINS \
-u "$SLACK_USER_SET_BY_JENKINS" \
-r "$SLACK_ROOM_SET_BY_JENKINS" \
-d "$SLACK_URL_SET_BY_JENKINS"
