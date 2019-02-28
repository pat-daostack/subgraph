#!/bin/bash

set -e
# source .env

# publish docker
echo "Publishing to dockerhub..."
docker-compose down -v
docker-compose up -d

# wait a bit for graph-node to come (it will redirect with a 302)
echo "wating for subgraph to start"
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' 127.0.0.1:8000)" != "200" ]]; do sleep 5; done

echo "deploying subgraph"
npm run deploy
container_id=$(docker ps  -f "name=postgres" -l -q)
image_name=daostack/subgraph-postgres
migration_version=$(cat package.json  | jq -r '.devDependencies."@daostack/migration"')
package_version=$(cat package.json | jq -r '.version')
image_version=ganache-$migration_version-$package_version
echo "docker commit $container_id $image_name:$image_version"
docker commit $container_id $image_name:$image_version
echo "docker push $image_name:$image_version"
docker push $image_name:$image_version

docker-compose down -v
# publish npm
#echo "Publishing to npm..."
#npm login
#npm publish
# tag on github
git tag -a $image_version -m "Release of version $image_name:$image_version"
git push --tags
# done
echo "Done!"