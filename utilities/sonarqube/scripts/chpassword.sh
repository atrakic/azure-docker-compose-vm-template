SONARQUBE_PASS=$1
curl -s -u admin:admin -X POST \
    "http://sonarqube:9000/api/users/change_password?login=admin&previousPassword=admin&password=${SONARQUBE_PASS}"
