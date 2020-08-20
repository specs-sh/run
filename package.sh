name run-command

version "$( grep VERSION= run-command.sh | sed 's/.*VERSION=\(.*\)/\1/' | sed 's/"//g' )"

description "🚀 Run a command and get its STDOUT/STDERR exit code (for easy testing)"

main run.sh

exclude spec/

script shell    bx multi-bash run 3.2
script test     bx multi-bash build-and-run 3.2,latest ./packages/bin/spec
script test-3.2 bx multi-bash build-and-run 3.2        ./packages/bin/spec

devDependency spec
devDependency assert
devDependency expect

devDependency multi-bash
devDependency bx
