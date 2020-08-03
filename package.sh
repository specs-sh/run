name run-command

version 0.1.0

description "🚀 Run a command and get its STDOUT/STDERR exit code (for easy testing)"

main run-command.sh

exclude spec/

script shell    bx multi-bash run 3.2
script test     bx multi-bash build-and-run 3.2,latest ./packages/bin/spec
script test-3.2 bx multi-bash build-and-run 3.2        ./packages/bin/spec

devDependency spec
devDependency assert
devDependency expect

devDependency multi-bash
devDependency bx
