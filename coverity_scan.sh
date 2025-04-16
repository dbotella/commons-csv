# rm -rf idir
mvn clean
coverity scan -- mvn -Ddoclint=all --show-version --batch-mode --no-transfer-progress -Drat.skip=true install
