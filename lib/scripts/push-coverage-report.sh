#!/bin/bash

if [[ `git status --porcelain --untracked-files=no` ]]; then
  git config --global user.email 'engzerjun@gmail.com'
  git config --global user.name 'juneezee'
  git remote set-url origin https://acb16zje:StWb33dF6ygoCLxNwkoR@git.shefcompsci.org.uk/com4525-2019-20/team07/project.git
  git fetch origin coverage-report:coverage-report
  git checkout coverage-report
  git add coverage/
  git commit -m "docs: coverage report $(date +"%d-%b-%Y %R")"
  git push origin coverage-report
fi
