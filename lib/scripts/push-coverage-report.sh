#!/bin/bash

git config --global user.email 'engzerjun@gmail.com'
git config --global user.name 'juneezee'
git remote set-url origin https://acb16zje:StWb33dF6ygoCLxNwkoR@git.shefcompsci.org.uk/com4525-2019-20/team07/project.git

if git show-ref --quiet refs/heads/coverage-report; then
  git branch -D coverage-report
fi

git checkout --orphan coverage-report
git rm -rf .
git add coverage/
git commit -m "docs: coverage report $(date +"%d-%b-%Y %R")"
git push -f origin coverage-report
