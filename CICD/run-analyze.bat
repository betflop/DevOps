git config --local core.quotepath false

sonar-scanner.bat -D"sonar.projectKey=test2" -D"sonar.sources=." -D"sonar.host.url=http://v-srv-sonar:9000" -D"sonar.login=1e3f976e13f277c066672c17ee73afcd6aa5b650"