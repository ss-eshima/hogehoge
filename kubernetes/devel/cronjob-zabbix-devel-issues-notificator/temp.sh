WORKDIR=___CONTAINER_WORKDIR___
WORKFILE=___CONTAINER_WORKFILE___

cat <<'EOF' > $WORKDIR/$APP_NAME/temp.sh

echo "curl -s -d ' {\""auth\"":null,\""method\"":\""user.login\"",\""id\"":1,\""params\"":{\""password\"":\""`echo $JENKINS_INJECTS_ZABBIX_USER_PASSWORD`\"",\""user\"":\""`echo $JENKINS_INJECTS_ZABBIX_USER_NAME`\""},\""jsonrpc\"":\""2.0\""}' -H \""Content-Type: application/json-rpc\"" http://da-zabbix2.scaleout.local/zabbix/api_jsonrpc.php" | sh | jq -r '.result' > $WORKDIR/.token && token=`cat $WORKDIR/.token`
echo "curl -s -d ' {\""auth\"":\""`echo $token`\"",\""method\"":\""trigger.get\"",\""id\"":1,\""params\"":{\""output\"":\""extend\"",  \""expandDescription\"":1,  \""monitored\"":1,  \""filter\"":{\""status\"":0,\""value\"":1} },\""jsonrpc\"":\""2.0\""} ' -H \""Content-Type: application/json-rpc\"" http://$JENKINS_INJECTS_ZABBIX_HOST/zabbix/api_jsonrpc.php" | sh |  jq -r '.result[].description' | sort | nl

sed -i '1s/^/\`\`\`\n/' $WORKFILE
sed -i -e '$ a \`\`\`' $WORKFILE

curl -k -S $JENKINS_INJECTS_GO_SCRIPT_URL > $WORKDIR/slack-notify.go
go run $WORKDIR/slack-notify.go \
-f $WORKFILE \
-u "$JENKINS_INJECTS_SLACK_USER" \
-r "$JENKINS_INJECTS_SLACK_ROOM" \
-d "$JENKINS_INJECTS_SLACK_URL"
