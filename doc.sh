set -ex
rm -rf src/vbuilder/_docs
v fmt -w src/vbuilder
pushd src/vbuilder
v doc -m -f html . -readme -comments -no-timestamp 
popd
mv src/vbuilder/_docs docsv
open docsv/index.html

# open https://threefoldfoundation.github.io/dao_research/liqpool/docs/liquidity.html