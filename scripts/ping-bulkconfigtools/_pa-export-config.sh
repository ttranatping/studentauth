function prop {
    grep "${1}" ../../docker-compose/cdr.env|cut -d'=' -f2
}

echo "Creating output folder..."
mkdir out

echo "Downloading config from https://pa-admin.asb.pingapac.com..."
curl -X GET --basic -u Administrator:$(prop 'PING_IDENTITY_PASSWORD') --header 'Content-Type: application/json' --header 'X-XSRF-Header: PingAccess' https://pa-admin.asb.pingapac.com/pa-admin-api/v3/config/export --insecure > out/pa-export.json

echo "Managing docker-compose configuration..."
java -jar ping-bulkexport-tools-project/target/ping-bulkexport-tools-0.0.1-SNAPSHOT-jar-with-dependencies.jar ./ping-bulkexport-tools-project/in/pa-config.json ./out/pa-export.json ../../docker-compose/pa.env ../../server_profiles/pingaccess/instance/data/start-up-deployer/data.json.subst > out/pa-export-convert.log

echo "Managing k8 configuration..."
java -jar ping-bulkexport-tools-project/target/ping-bulkexport-tools-0.0.1-SNAPSHOT-jar-with-dependencies.jar ./ping-bulkexport-tools-project/in/pa-config.json ./out/pa-export.json ../../k8/02-completeinstall/pa.env ../../server_profiles/pingaccess/instance/data/start-up-deployer/data.json.subst > out/pa-admin-export-convert.log
