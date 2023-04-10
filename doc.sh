set -ex
rm -rf src/vbuilder/_docs
rm -rf docsv
v fmt -w src/vbuilder
pushd src/vbuilder
v doc -m -f html . -readme -comments -no-timestamp 
popd
mv src/vbuilder/_docs docsv
open docsv/index.html

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html

pushd docsrc
bash run.sh
popd
open docs/index.html

echo "DOC GENERATION WAS OK, VLANG and MDBOOK"
