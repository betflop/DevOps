docker login -u $CI_REGISTRY_USER -p $CI_JOB_TOKEN $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/deus1_back:5393151d1fd40835bd89fa7dbcd3491001c25f80
docker pull $CI_REGISTRY_IMAGE/deus1_front:d17c7d1cefdc000e454d0d65219d9c7fb4361304
docker pull mysql
docker-compose up -d
