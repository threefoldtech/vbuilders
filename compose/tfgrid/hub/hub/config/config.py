#
# You should adapt this part to your usage
#
config = {
    ## 0-db internal endpoint (host, port, optional password)
    ## Please note, the default namespace is always used
    ##
    ## For security reason, you should run your 0-db in protected
    ## mode (--protect) with an admin password. This enable your to
    ## get a 0-db with write access protected and public read access.
    ##
    ## If you don't set any password and don't run 0-db in protected
    ## mode, anybody can delete/change 0-db contents.
    ##
    ## 0-db needs to run in 'user' mode, not sequential.
    'backend-internal-host': "hub_zdb",
    'backend-internal-port': 9900,
    'backend-internal-pass': '',

    ## 0-db public endpoint (host, port), this will be used
    ## to provide user information how to reach the backend
    ## when uploading something, this settings are applied on
    ## flist metadata when used internally and are displayed
    ## on the frontend but are not used for creation
    'backend-public-host': "localhost",
    'backend-public-port': 9900,

    ## Hub public reachable url
    ## this will be used to provide user an working url
    ## to reach flist files
    'public-website': "http://localhost",

    ## List of files to ignore inside users directories
    ## when showing users flist, we list the contents of the
    ## user directory, it should contains only flists
    'ignored-files': ['.', '..', '.keep'],

    ## List of usernames which are 'official' and are on top
    ## of the list on the homepage, this is just to provide
    ## a list of 'pinned users', it's not security related
    'official-repositories': ['official-apps', 'dockers'],

    ## You can provide an optional zflist binary path
    ## if not provided, the default value will be used
    ## (/opt/0-flist/zflist/zflist)
    ##
    ## Note: you _need_ to use a non-debug version of zflist
    ## you can make a non-debug version of zflist by using
    ## make target:
    ##  - production
    ##  - release
    ##  - sl-release
    ##  - s-embedded
    ##
    ## If you have a debug version of zflist, it will print
    ## extra debug information and json won't be parsed
    ## correctly
    'zflist-bin': '/bin/zflist',

    ## You can specify a special userdata (list of users
    ## directories) and workdir (temporary directories where
    ## files are uploaded, compressed, etc.)
    ##
    ## by default (if values are commented), the repository
    ## directory will be used as root:
    ##  - ./public
    ##  - ./workdir
    ##
    # 'userdata-root-path': '/opt/0-hub/public',
    # 'workdir-root-path': '/opt/0-hub/workdir',
 
    ## By default, the hub is made to be used publicly
    ## and needs to be protected (with itsyou.online)
    ##
    ## If you are running a local test hub on your local
    ## network and you don't have any security issue, you
    ## can disable authentication, and everybody will have
    ## full access on the hub, otherwise YOU REALLY SHOULD
    ## enable authentication
    'authentication': False,

    ## When authentication is enabled, you need to configure
    ## how itsyou.online will use credential for your app.
    ## 
    ## Note: itsyou.online will be deprecated soon
    ##
    ## You'll need to do multiple things:
    ##  - First, connect to it's you online website
    ##  - Go to 'organizations' page
    ##  - Create a new organization, call it as you want
    ##    (it's better to avoid spaces)
    ##  - Go to settings of your organization
    ##  - Add a new API Access Key
    ##  - Set the label you want, it will be your clientid
    ##  - The callback url can be whatever you want but need
    ##    to match with the callback url you'll set here
    ##    Note: this callback url needs to be reachable when
    ##          you'll login to the hub
    ##  - Generate your keys
    ##  - You can now set the clientid, secret and callback here
    'iyo-clientid': '',
    'iyo-secret': '',
    'iyo-callback': 'http://127.0.0.1:5555/_iyo_callback',

    ## Authentication using threebot (3bot) is also provided
    ## and will be later the only one used.
    ##
    ## You need to provide a x25519 raw private key. From this private
    ## key, server will generate the public key and use it when building
    ## threebot login request, and the private key will be used to uncipher
    ## the response received.
    ##
    ## You can generate a private key with openssl:
    ##
    ##   openssl genpkey -algorithm x25519 -out private.key
    ##   openssl pkey -in private.key -text | xargs | \
    ##     sed -e 's/.*priv\:\(.*\)pub\:.*/\1/' | xxd -r -p | base64
    ##
    ## You also need to provide the appid, which is the host where
    ## the hub is hosted (which should be the same as public-website value
    ##
    ## In order to get API calls working, you need to specify a 32 bytes seed
    ## used to produce signed tokens users can use to authenticate themself
    ## on API requests. This 32 seed needs to remain private.
    ##
    ## You can generate the seed using python NaCl:
    ##   import nacl
    ##   from nacl import utils
    ##   nacl.utils.random(32)
    'threebot-privatekey': '',
    'threebot-appid': 'hub.tld',
    'threebot-seed': b'',

    ## When using authentication, there is also possible to hard code
    ## a 'guest' token, this token will be matched like an itsyou.online
    ## token which still works for the api. This is a workaround to be able
    ## to use the hub with a specific token and a shared global user in order
    ## to test features.
    ##
    ## You can just use this token like a jwt token and being authenticated
    ## as 'guest' user. Just set this to None to disable the feature.
    ##
    ## Any string valid, example: no5rjrsFpgXVxCd6bzicvyI7YmvhuTIs
    'guest-token': None,

    ## The hub can works in two different mode: debug or release
    ##
    ## Debug Mode:
    ##  - Enable debug message
    ##  - Flask debug mode (traceback, hot reload)
    ##  - Enable a banner on top the website, saying the hub
    ##    is in debug and unstable mode
    ##  - Add more verbosity to the console
    ##
    ## Release Mode:
    ##  - Disable debug message
    ##  - Flask is in production mode (no traceback, no reload)
    ##  - Disable the top staging banner
    ##  - Reduce verbosity
    ##
    ## It's obvious, but you should always run release mode, except
    ## if you're debugging the hub code
    ##
    ## When debug is set to True, you're in debug mode, when set
    ## to False, you're in release mode
    'debug': False,
}