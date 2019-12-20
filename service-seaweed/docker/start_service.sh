docker volume create weed_master
docker volume create weed_volume1
docker network create --driver overlay --scope swarm vlan-fstore

docker service create \
    --name fs-master \
    --mount type=volume,source=weed_master,destination=/data \
    --network name=vlan-fstore,alias=weed_master \
    --publish 9333:9333/tcp \
    shx/seaweedfs:prod \
    master \
&& docker service create \
    --name fs-volume1 \
    --mount type=volume,source=weed_volume1,destination=/data \
    --network name=vlan-fstore,alias=weed_volume1 \
    --publish 9380:9380/tcp \
    shx/seaweedfs:prod \
    volume -max=5 -mserver="weed_master:9333" -port=9380 -publicUrl=weed_volume1:9380


