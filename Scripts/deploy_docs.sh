#!/bin/sh

sh Scripts/generate_docc/run.sh

echo 'kamaal.io/PersistanceManager/' > docs/CNAME

npm i
npx gh-pages -b gh-pages -d docs