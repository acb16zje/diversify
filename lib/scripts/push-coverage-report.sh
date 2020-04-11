#!/bin/bash

if [ "$GH_PAGES" == "true" ]; then
  git config --global user.email 'engzerjun@gmail.com'
  git config --global user.name 'juneezee'
  git remote remove origin
  git remote add origin https://Juneezee:$GITHUB_TOKEN@github.com/Juneezee/project.git

  if git show-ref --quiet refs/heads/gh-pages; then
    git branch -D gh-pages
  fi

  git checkout --orphan gh-pages
  git rm -rf .
  mv coverage/* .
  git add index.html assets/
  git commit -m "docs: coverage report $(date +"%d-%b-%Y %R")"
  git push -f origin gh-pages
fi
