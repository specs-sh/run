name run

version "$( grep VERSION= run.sh | sed 's/.*VERSION=\(.*\)/\1/' | sed 's/"//g' )"

description "🚀 Run a command and get its STDOUT/STDERR/EXITCODE"

main run.sh

exclude spec/

devDependency spec
devDependency assert
devDependency expect
