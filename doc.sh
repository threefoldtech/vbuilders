set -ex
rm -rf src/_docs
rm -rf docsv
v fmt -w src
pushd src
v doc -m -f html . -readme -comments -no-timestamp 
popd
mv src/_docs docsv
open docsv/index.html

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html

pushd docsrc
bash run.sh
popd
open docs/index.html

echo "DOC GENERATION WAS OK, VLANG and MDBOOK"
