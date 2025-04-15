coverity scan --incremental -o analyze.mode=hfi -- mvn -Ddoclint=all --show-version --batch-mode --no-transfer-progress -Drat.skip=true -Dmaven.test.skip=true install
