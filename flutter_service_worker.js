'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "ee72da9542b088a73bf51d0d55c61471",
"index.html": "56f36c2ead1d9fdbb955d329c6bc0348",
"/": "56f36c2ead1d9fdbb955d329c6bc0348",
"version.json": "7af4e8cfb7cd22b96b1a6a0dac3902ad",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/fonts/MaterialIcons-Regular.otf": "eb35efe836e56d5de836b7c5f26ae79c",
"assets/AssetManifest.json": "40188115d6f1cde1b1b1b56478cfb1ae",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ab7e8e99c1128a0f763dfdf928f2d546",
"assets/AssetManifest.bin.json": "db370531826b69f29d0e3466935eb830",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/matches.json": "5b7f32bfaad25fe6a4a7a3c360334c76",
"assets/NOTICES": "6e08351af19904c8c98dab6da7378170",
"main.dart.js": "064a8d49803bdfedb2def119e2b25e15",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
".git/HEAD": "978cf7ce582a3595b9d4daf7cc63115a",
".git/index": "71664e55132d7d52bc6cd2970b5eb803",
".git/COMMIT_EDITMSG": "655d242e09a0059e6c1fb1b459626ad7",
".git/config": "159d8688201c0a562c14a2a7005c555a",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/refs/remotes/origin/ghpages": "66fef6abf3f412d73829fac8f0057154",
".git/refs/remotes/origin/master": "f0f9ebb2e8aa7852eb08724423b1ad6c",
".git/refs/heads/ghpages": "66fef6abf3f412d73829fac8f0057154",
".git/FETCH_HEAD": "325806c1732be83142b167c0f15ed609",
".git/logs/HEAD": "844efbfef40f99251e5ba2123e18cae4",
".git/logs/refs/remotes/origin/ghpages": "5209c24503c0fbfb7a66dae557a64d61",
".git/logs/refs/remotes/origin/master": "4b99bf02945b50dba6c936a1da11d23b",
".git/logs/refs/heads/ghpages": "6a6f67c802ad98bee57d2ad4bc783c75",
".git/objects/2e/491aa099c86984d09c520774764ef0e619e1e1": "f2af8d6ed90eaa81cceabf586ef41781",
".git/objects/2e/53ff59885f1d6e83c982de10222d9e6d028e5e": "9b7e0d89e541ee381d4355b2dd0b6bed",
".git/objects/02/f3594e270361895223652b6cb88561b0de24e1": "56d1ecf1a12fc5e83b0bf0b5bc9abb64",
".git/objects/17/10c1d88ea34e3524047beee1801d59cfa73e4a": "a76961a51ea9adafb32969f1d37fa636",
".git/objects/17/3f20ef49afb0758ad3b2355527a817961bdeac": "8c7028d32f662194aa22da5d69538f12",
".git/objects/17/1454ef2967d198e4aba0c6870949a5d0ae7d61": "06a3472ddd4c4b137c7f9261510d3167",
".git/objects/17/f671023aa7af5b6565cdadcfa9b67af45b0385": "44e1774f2ad2bba6ccc29400068ca54b",
".git/objects/17/fbddd9c36106fe6c93c45a8a10df44a8c80ec7": "172995a5a788dcea288d2d7327d9279a",
".git/objects/f4/631d453bb9b2da659a47f8b4bf7de8a0c7d149": "5642f0de1f122de33cf19d09dd268f30",
".git/objects/73/684599c7791c7e83f31ec150421f83c43bb68e": "5e110bf69e363639f5feba342b59647b",
".git/objects/73/9e85dcd908f940a97671ac34e3285f1059484b": "ebf98ef4bdc5384178e0386229d669fe",
".git/objects/73/24a30d5e0da72ecf7bb5272738f08395604fca": "7a55d519a63024ce2fd942f8577d610e",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/77/2653736a3348aa60b15c3a41e5a3e016d3431c": "480e98b556059c0418109eb37096f37e",
".git/objects/fb/61b2b5f7d75153834b169155198867e8b20aee": "2f60e4befc12b009c6e9ab10958cf320",
".git/objects/14/5915df3cfae885ced29c58a2c9ee517c2c8194": "1e4cb970381038323b8b7479f7ca1f31",
".git/objects/e7/fd716dba52da9e79e8971ea2ddd2e81238298e": "29f5a403f2bd83495e5436f5854affd2",
".git/objects/e7/4940e24389c921433e28e5927562e67460bd5a": "caeda771011fc98b1bc4f220a169aedf",
".git/objects/c0/4cc7ff5811179f90b4b31d87d109edd9c73184": "eeafc4dc23e11d41c8b67463815141b5",
".git/objects/ca/e50cbe9147b2fbf606201cdb2b452b4414a24c": "12830ee78cca078dd6b1625a4d929a72",
".git/objects/8d/35303642daa0cfda394f43dde1ce8a18b07201": "a18f7c4d0271a1477522eccd1cd128d4",
".git/objects/48/7e9e439e3c2ec249ec79b10cc0bb16471c984b": "2b3bbe12812a792f19a90c2a76004c95",
".git/objects/48/bdb2936fa680308e1988ac052b10a8a3c2a656": "8ec1d74419cd41b23abe5dd12cf6f9b5",
".git/objects/9d/d73ff57393ed6cabd7c29be001499bf31e54aa": "9920c5d5793c777136ae6cf9488618ba",
".git/objects/9f/37d195db00d91d94890a7936b19ffbeea9af73": "31c5ec989879c846c8b098639327b73c",
".git/objects/5a/2319808090750a2b1a3cd78722fcde6aa2cb3d": "983f7991456b6e7be941567d3ea13482",
".git/objects/50/e3f02e3e31895e967d5c2ca444d30e7d3b802a": "0900f69c4121c4726baa5a0317bb2971",
".git/objects/fc/27fc607c965a383434cdcecd8fc2873cf25673": "2bbc0dc0321b9eb428705b1008fe7c4b",
".git/objects/fc/c9585f1bcf5b41d16a9d739ba1e8acb45a8a38": "0c789756567a29cd1964553a966643d6",
".git/objects/fc/91e1436291b408f504fbffce3f43fc0ddc7a2f": "dcdd6e3f35b3668e491e59fe294d0726",
".git/objects/ee/ee2f23c3400b31a0265426b8e38cce7413476f": "a645f33006c7c64726b5e7413037a2ee",
".git/objects/ee/2c5ee64bc52fe5b1d30f3a3abe116e311a1093": "7997498962dbf24cc0934bdf1f787baf",
".git/objects/d6/75a3d1b24b928e7e94ffdfd075110623677c55": "06b17bf5ca92bab6cc6ef6ebb4d16e96",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/0a/372bf6face110c9cd394164a050371b590f985": "008b622ff0d8da17c6c76cb02e68a297",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/65/5ff41eb18fa22111d72210e7db316eea23a72d": "6fbbae0cbe554d574e23e9a886013e37",
".git/objects/da/78c13ffc997c5db8ba1d073dfd260e7d84c485": "4d9f03820f8be8cd00fb246e70345191",
".git/objects/cd/935c74e8dc2eb6fee32df5b7ac6b2f9662f39c": "28ec8a521693c218fae511b00b8059c4",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/7c/500a96f205257d6d9b906f57efd0762239da70": "c9a8e5c98c012be1fc9c8bf68313dfcc",
".git/objects/40/6173a9cfadfc1c49b242a46f09d58ac100375a": "06f17ff0d0ff9044f72ef37885ad73e0",
".git/objects/c9/789e1957a57b41d39ad010b1486642658b21d0": "2900c5b35bf1c5d2c5688c94cffbd226",
".git/objects/f5/010cda95492006dae3638dfb01a8d0822a1e6a": "04eb9fcdf209b67f396e5ab84cb956e2",
".git/objects/f5/3460761423d4d3182c6be787cc0b37d46b6e30": "8e0be416f7d2687f932c60b690b1cbbf",
".git/objects/8f/e7af5a3e840b75b70e59c3ffda1b58e84a5a1c": "e3695ae5742d7e56a9c696f82745288d",
".git/objects/51/75e99cb8c3c8c08ba14cce04854a90e0f2e241": "0cfaa4c53f36bfb2f6e50296321fd913",
".git/objects/6a/cb99ab4bd8a8ce6f12c37d7e6bda90e6550e8c": "d5f9770838c0978956b444b3a6435648",
".git/objects/4c/e00f597f4e240254bde4c7d2e544c7a12cf033": "dee8d39429141f99af342a278d2f50eb",
".git/objects/4c/fa3b668ab5f80fbaf2deaaaef382dd3af95d3d": "0600d1d4ea5555d9a8439257fbc207ad",
".git/objects/5d/3071b7c35848b7253fecc0c20815927de94632": "8a29326639d31ad55bc495332019f7e6",
".git/objects/5d/15fadf1864d70c7184fca7d3efde79cdf68af5": "79a44d8578cc18e3add64aa6a97f0da0",
".git/objects/5d/386a4f19fdcfe8aa006cedd856ad4a203beb2b": "305bad295becf98cf20d20791d1ca7be",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/92/b3269885cb3564f1565c7f4d755194d3486401": "5a09cea738a1c1daed99c4cf48abd2a1",
".git/objects/92/59e8f2c10c6ad48aa63afd32732689d56a8983": "fb350479b561984dd1a28e4514f2fc39",
".git/objects/92/a4cca67468a16c8fcf09f27dbda4ff0efa65ec": "0022ce4b547383b7ca027f71e143a373",
".git/objects/d2/4d30c8e1e0e6732b7c1ba9095f2bbc04f59f11": "1a14d41638725adac7f4b5759ed1b07f",
".git/objects/d2/87d83fa2a33ce391a33afc2c5629f5f10872a8": "251fd45ea56c7aad0924467a11aa51f2",
".git/objects/38/30d4d737882306a0a0ada1ba9a566f95a0644f": "1dd47dfe98b8b453a3049d1031d8f4a5",
".git/objects/e2/0a72bb6d9f5a20d1c0da055344efbf3b29e320": "755d0e96206fc9ac1e57be73f3a23d62",
".git/objects/e2/30fb9448b5d704bad202571b087d3637a5b04e": "badb897bd79e2da74a38ed1dfc08542e",
".git/objects/61/ab3e67c735d8b3b6813f4406d3c343908bed91": "f058b9947a9d7b60c3da2d19a1a198dd",
".git/objects/61/df86daa752079d83c895cdddb97cb16b4751eb": "75ca7de3eefb80a035aef8aa853888b2",
".git/objects/61/925576707d075c784c6d38d1ccfb5d774c147e": "2641d9e6a8de1755f18e878fdf99498d",
".git/objects/b9/c36e492c6dab39bcd83f776c8eed59a8eeb25e": "370b79e136d364d47d877306c651a26e",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/71/93e541002b74fc8261f15590b7f860d1238a40": "7fc4edd27e7c75b29fd4991a0e66fb5d",
".git/objects/71/bc52f9731fe312ebb873227d93f946f95c2179": "b3b97431f85051706a32b4f168e8f271",
".git/objects/e5/edc15bb77773eec17874207066e4c431c222a4": "0d2497b180ae1f4b5e01fb41a44cafaf",
".git/objects/e5/cbfa78593dc2c667d7ba105aaaa68ceff39ea8": "c2a841af87ef49b642c9ef32a5ecbe3d",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/79/63f872b3e52662857add5f78b4415280ea59e9": "6b320729326c219d6667673217930cb4",
".git/objects/45/4a835029b5a3ed66488afab7d9359589cea41d": "b41e86aafdfdbc49e421b88e64edd818",
".git/objects/63/4ade55992d02ca4ee9ad2c6d002b063b981779": "732b93359f36f13adc150cefaf9f4f1d",
".git/objects/63/95ab43cd12b1c38c22ee4208160f969eb36c7d": "854f853847e9354977eb8f0890b73270",
".git/objects/ab/e16e0c47ba043db352cd57d219c6ec0dcab13f": "09f7f03046ea8f279bcb4116125fa2fb",
".git/objects/f7/4b5cc71d5d0a06b8d787835189da46372895dd": "5ef614615f7727d429f830656dcd6d81",
".git/objects/f7/b5266831f67812fc069458cfd66e1fe3350563": "128b6d7a639bba2ceb02e77bd66015a1",
".git/objects/f7/7752659c72d32c2c3ff68406d3ad806f7bdf1f": "ed94f3ba989a1df99274a9a8a440b8e4",
".git/objects/97/9f44bbf36fed00d8ea9b2ad6b08a0799237048": "73fb3e113b468dc1d01c2ede9506f9d0",
".git/objects/97/977740018be09e15da356db8543d0603c5f58e": "00a00c5f7953cdf204a790d241e4147f",
".git/objects/97/d3e347663a039b4ffd3601458e8f2e5dafe8f8": "8d4431c3da9ab3c3f266e096cc5ca85e",
".git/objects/ea/4d4e86740a0d03519b51abbe66e3e1bf650e80": "4d3c1f767f5159a52af47d7575110989",
".git/objects/ea/b062d1b51bafca7c0894e3779d8eaadb49b0d1": "6052d71f16604622e1659e2b8b166523",
".git/objects/16/5da67191b73406e15fc3e6cf7cda3c195dc735": "86cfac30d97fb45bba2f4417782645d6",
".git/objects/06/7216af57cac1506fa3b81ac53ed0b4e0a4bff8": "f8aa1c6ca07dccfabdd63be2a4ddbceb",
".git/objects/ed/ebd3f42e7cbfe43e53fd68c2b120acd1831489": "536a300272104a9fb31c8c66bfba1108",
".git/objects/05/d451ee28f74ca9604e1b51527dc2b5d4eeb1aa": "26e03ba052aacb5cc33ca59482dddb77",
".git/objects/a5/3efdf92300d180241adcd14d81d15a734c4e08": "cdce04155deb291d95d5b2a8a45a186e",
".git/objects/11/2bd14a97c5f8819200fd25cfa8ab7f7905499a": "865415bd61ccddc989a5eeb7bc7ee534",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/88/f48876d5e6adb3babf7de4416fd688d423d0db": "932cb0138fe2f2160f38d600eff4b016",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/32/6902413a1858abe22d5b12f1c70c9895b688b5": "9167d75ff2d83ab077e4890b1c99bf22",
".git/objects/9a/7d6bdab58215732692f52b4011e0bcc2fec34c": "37d70dc263ccde5cdeb19ce7434d52ff",
".git/objects/9a/6698dd3f7ce862e3f7957b579af7fd63c115c8": "1b411351ed337fed39077e014a11a664",
".git/objects/2a/42705bd5b1dbd22d78ff8e14919561f511cf6b": "2efd2febeecc92549215a5ec1e14f155",
".git/objects/fd/55f9d8ef740bc6a74f73c93e302d77423d1a94": "bee0bc0ce923f03aa88c07f4dceeb70f",
".git/objects/fd/206a7cbafa3c9dd40c9c12fe2b60155bd514e5": "358519bf48d4c0dcfaf2e8bb272eb381",
".git/objects/41/6477eeca7290eaa780d7bb35592b9bbddf97b9": "1057c4f10266a814d6d898e1f709df68",
".git/objects/54/1d7dca51a39895e0e5b1444d5ed7458332ec59": "cdc56e16bfc71b30b1c4fcb6fc0a09d3",
".git/objects/8e/1e6021b1b221cb84b17ee874a237df24057bfc": "d3c10ea08f45999605f1d1dcc7841f65",
".git/objects/8e/dff803723c6edc1fe39e167bc9d302f9c92ebd": "698b127c87568813b46de2af0bb46fe8",
".git/objects/29/f2c59a5be32766142161bdb0dbde3d9d7231b3": "8fd80cefabd7687e7b983e140d93df27",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/aa59babf7c66d4927a60512faf22f1efb2067d": "d28b5e7ffde8a2983f272344cb9dbb28",
".git/objects/00/52a4cc532b8c556e72c6d8a6bc790c5eb3a7e9": "4bc1365536d09a0e4e8372145e5b1e72",
".git/objects/00/00a05b08b6db21f5da6a32bd5f25fd4e367f31": "e710332148ad6825897c3d222d3ace06",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/19/c78565d1665313d768bbb78fb74a10617a6783": "6fb147c02ced3e188f50c5d73031a01e",
".git/objects/2f/87a128009090f7eda32bb6f29b1ec1a965d092": "fcfcdd2886e55048e0bf1b4334516aae",
".git/objects/60/bde1499cb76e38f6310c9a7aa2f1514c8c5194": "1c0d92de2d752f43d33b69eace70ebc2",
".git/objects/60/d49be65f90f59cf24bed3e7be655e95b7179ee": "b4b98f051f201b8569f890921c1cfd0b",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/b5/8e5feb2eb24d8cef11f1850d1a31372b319932": "15dd32fe660b5b1e27b8822da8e07965",
".git/objects/64/06eb4ed9b0eb374d1de7a21287cd511f98a539": "7d6c850147a9f6765245dfff9a3274b0",
".git/objects/1d/8fd461ef163e2fa45afca9aaa78ff93fbad4ab": "3c0235d733fd7c9d159dcb978959f395",
".git/objects/1d/0d087cf083f4b9598efa29a9107a08dbaa20be": "4aa76a853470e47712a710dc09b0cfc6",
".git/objects/1d/93089d5ef3651abba073237f0383b6758de701": "3f1bbfae6ccd2749d85065a0d7da935f",
".git/objects/1d/6ac365ee70f7b0b3949c6d98c21ed14f8850dc": "2a2819c1ae1e9574b2f74f875edd4fe0",
".git/objects/1d/792dfdbb1b854ab811217193a9182524a2d8c0": "31f04d63c265915dd790c9f44a1bf1a9",
".git/objects/a8/26b2339d645c197872c217f7e3d7f162f99c32": "faf13713fc9ff7233c9c066601a24343",
".git/objects/7b/848d04b32067f182537d85229e2ac666d32488": "81f599a8bd12b4339f766ef8924c3b08",
".git/objects/7b/27f678a38756557781833cbac3138e5169777e": "48e112dc858a59d48e23117e3f7c3aae",
".git/objects/7b/beb1bce6ddff43a16612c96012c7493a0e1c05": "0d6980cc3589d06e48d150fe2897fa49",
".git/objects/03/eaddffb9c0e55fb7b5f9b378d9134d8d75dd37": "87850ce0a3dd72f458581004b58ac0d6",
".git/objects/49/90310327537666cf7039124f8c4fc7d1c76c6b": "5490d1a715f0a9eaa1a5c93da78fa6fc",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/3426f2bee390f61d7f1d0ac48fcfc55cd5f419": "276894e17ccd261a656c6740f5a74921",
".git/objects/ef/1887e8d7b89c8f17c4db9e971ad634dc4301a4": "930ec00bcb73b499f4b17a1de5da8b1e",
".git/objects/ef/2cb6c5817876aa9a9a5308dfb83c797a39f0f2": "0d75744bdb45c797b71384733bf28aeb",
".git/objects/1e/25fb4841dbfcbc6e4fa75d9417a4113ba250bc": "e91280155bc02e320c2a664e7fefc7b5",
".git/objects/9b/b7a59fd1b88444c05865c12c68cb94fe471b2e": "8819818246c89cb90457c41116463e70",
".git/objects/d5/c95606efe8c479c8e8102bb8deaf1df3d23440": "a7c4e9ce08f5615017f789fce630e0a2",
".git/objects/d5/b2dece9e72727d96b64974f2c96813f66f8858": "9cc34a4fbd33dcd1f527b2a8be0b6a4f",
".git/objects/d5/641e5bdf91cddfc0eb21327119e5378be04290": "6d5dcb4a414edbbd4c523ef52c86335d",
".git/objects/f3/aa01cc90bc8c23283fdcd49827d35e1af91e5d": "82dccd97a3d149ef99c78781d1eeef12",
".git/objects/f3/5de76ef92e31d052be3317ff36d8cb7e6dc5dd": "6c124c825debe7345a7d589805ddf997",
".git/objects/a0/73f42b9a113a6340cadb30691c1f6be4452f69": "d48655824b6d8971bfa48034a31868c3",
".git/objects/86/6d2b86af32c6c7255d19cfe798577cad6457d1": "35d81dfe2783d3d2642fa6b045b41814",
".git/objects/86/6892fc7a472886374002a0e6be0b9411c84766": "bd1ddd13e3f3195c7b5b2f6528405c12",
".git/objects/c3/04e33f7edb62866d49586e80744048a914c88b": "c6e68402edcfcf7c828ca0259f78a540",
".git/objects/0b/076a2b5c4b4781701de580c297b6bedb724188": "4b58dfff198249357eb74db6cbc4ddd4",
".git/objects/b1/134645ab05aecb44a8892b8436647f3cf22dc3": "8fda2abcef0e7b237a4b995495d27e16",
".git/objects/52/56717a19993c83c039d383644d15b70174fcff": "6b916070ab26cb169865d463f6b1704c",
".git/objects/0e/7b00720399d3626de20fc9e54aa9b8516253cb": "1b1d53e6f55069e32ee1f55e050daa25",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/35/1e12ea7d35f70d42defc871ccfa64377dee103": "cecfef7bc2faae54ef8206f51cc462be",
".git/objects/35/0080e10f8322d8e2e649ab47ba24aab284b5c7": "2a6f9e0b26001c74a0da89734dcdc22a",
".git/objects/c7/02efa61df4f8fd777238b59306a02843d401fc": "0d1f2237eb6f31acd77afd0ad2e1dd05",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/1f/368fdb077987b6989b0dcc63a1de39666b61a9": "b580ac556a8413e76c9983b436d2e2f1",
".git/objects/c4/b853b7a5801641ca625ffb549ee3c8be4eaa48": "1033fafaa858be3fa566b682a490bcd3",
".git/objects/db/74861cd1ab993738dc9d65cc8e2eacbb47d9d1": "47bccb49eeb238b9eb01d430cd05df61",
".git/objects/b8/a89b32516f28a9ba89ade8df8497c29ebabbe0": "ff59487ad39653921ce056b8d3137d25",
".git/objects/b8/955a6a74bbfd63a63b375c48aa30e09b66bec1": "9c52abee22f7c7d11dd0d859696bfb8f",
".git/objects/de/5341a41654b7043850a621b456f97ae4c2f7d3": "fabadea347580dbcbda5c6d59d8e23f9",
".git/objects/de/8c7f70a832ee3c09de78d88284e368845dcaa2": "14bff092e48df5820629c22d399aab8f",
".git/objects/de/4cc5d9ee21f3fe8df376b88a2a1092d6c76b3b": "d0bba29edbfcbb51afae50233e9fd2cd",
".git/objects/a6/192271048ac94c5f8edc3a1ef6f8d5e7b6fa4e": "2b1ecfba1bc54af22297f548b4fd1fc9",
".git/objects/bb/78db98c089a2a1f98726b7eff0c5d98cfff38d": "c4cddf0e72ad6371c329d4ed90f84cd8",
".git/objects/bb/cec6675c9d4cf9fddd9260acad1a3187c2c988": "a46e9a3160621ca1b001154c7f450ff9",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/90/249f2815bc3428c506bbb2853655ec6c6f6e8c": "ddd42fed4323f254f72ef5b94291ede8",
".git/objects/62/2812e183a483c769fcdd1c18c32f18d14fe4e1": "8b5920e6ff71b44a701883ff49d1801c",
".git/objects/22/8869ae0b8556a9ddb46dca86fb3ac01326d29c": "35229808a0ea1d3beac9c00b2d80d3ec",
".git/objects/72/406531dd280bb3da4ff9f8d3b883d1401c9eeb": "326f41b9ee18594d29bcdefd0c54fd88",
".git/objects/72/af771ecb6ddafd9b188de8f83e832d4e9d69da": "5bece14e9b55d783e3e864a8d81a520a",
".git/objects/4a/78411bc0446d44f608d3402cd3e7058c7c8df9": "395510db0664d56d4505d3ffded82fa3",
".git/objects/09/f07e250b379e752c035e528288912a428ef52f": "2d8f21cb15a5cfe449b8d0c31437db97",
".git/objects/ec/2895d1b26c47d281c7df42a432bc9f77d11036": "9baaccf2f947574180a0b6eb2685a9fd",
".git/objects/a1/a48445737099b1ed5365bc4237a62dbb1236cb": "d19a21df8813f392c06b00bfe6b0681a",
".git/objects/a1/8aa24a92c39d37c14aa2ea97a0e1320f577520": "2399ca969771fca2d58b449e4219344e",
".git/objects/5c/fd418dec35d20cda50d83e305188d218302f49": "d5d32f9878b89b1a3a7829a85ac69bac",
".git/objects/5c/b383aa6e6171de79eac6115ec32b71ad5f497e": "16246e94510694fc30766884eefb5657",
".git/objects/5c/89dcf100b8233152b496a80e93a11c22e79a18": "38cea61f135b2608cd5720560d4d116d",
".git/objects/f6/43c751890ad3c7f9bdee8611e414f7fb22ebb0": "cbe132d4361152222095eeaf78c59ded",
".git/objects/f6/2d8268612f7b5fbd5b0c6148e588183784bad5": "970756249a35baed81cce05b1f468efe",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/84/293a26b0942fc9a2e89027e21dbcf9e1ee8b64": "387a0f96d091399ecc2ee8b6fcdc521a",
".git/objects/84/8e1d641c720d4b47756124bad2bc8e3cd92a46": "693ef811a8e72129cf8cff721a263851",
".git/objects/84/fe8d0554f910cb32be69568a26e65a08c82f31": "6518cb158f3f06821ab23af3030aa256",
".git/objects/15/2f15be2b080600235acb2ebf7d0d69f2fde3c8": "3fab32909080241e073ebe185873ce3f",
".git/objects/15/910f75ef7430c01553f39d7c00a65d9a29f432": "e8d3c9301030db024995749abdfa99d8",
".git/objects/af/2c30776fde81111d53d5ed76fbc1e939bb3bfe": "430fcd108efa4dc2c642fd11edf8f964",
".git/objects/36/671300ae5c22d3b1cd13a95a7312c5d4964c30": "5cb43ce719a88997d3ec685633f7ad97",
".git/objects/36/28d4ab0177aa94c2b2192256d6cae125eb6eec": "b640a0456c722e505c9ed56d88676518",
".git/objects/aa/84085c7de460508b648effe23ddaa6d9493d80": "5e66a4d93ea0e1fb443857c7e6e0665f",
".git/objects/69/dd618354fa4dade8a26e0fd18f5e87dd079236": "8cc17911af57a5f6dc0b9ee255bb1a93",
".git/objects/69/37d66022b62a3c040206ef6c13a625e1dc8fee": "69890cb7ac231550ea9ec4771ab26dfc",
".git/objects/69/a4882b99a289d94179260d2e80852f4f013d25": "3d45a2e1f5ca9593e51cb67ce4ffca28",
".git/objects/a3/787c42da175a7b9709385f609a7e5b4b34fc37": "553d2bf983005b3fccc58a5b4d02aa8f",
".git/objects/a3/10fc075ee6dac4fef3a48230771d958d2c28ce": "de713081944269583e43de5025b45e11",
".git/objects/a2/c2c501d92cade4609fbff2a20d058036a0f07d": "5799cad65f96fe00122233a5625d5041",
".git/objects/a2/38247ab712eba3976bbdbcd1784d85fd8c19ff": "17086542910c8e14d65c7cc1eb85bd62",
".git/objects/a2/ed5c6b7a76a9c36255cb131ef300f68534a406": "adba628447714bccbcf644ae3c7a7791",
".git/objects/c6/81c2b75b918c429b076f7e22f6ee71aa7a0801": "76683316d885a3340796d1d1c2f6d83e",
".git/objects/c6/2882405dbc561bce33d67b4cf7f0cffdf03897": "8a0d83d07d8f84b55712730856a55a0a",
".git/objects/b6/45cf6e3809f66745af4a9d8d5911243ed71b55": "3ea0a1dcb51d5dc104a6ad21869c7b2f",
".git/objects/0f/4d5ac3571ad49703ed561b067bcbeb292a268e": "c67d3fda6bbb1f533e80460d59b285ae",
".git/objects/78/01e6c3461d4b0180fce8e2fe4100b481828624": "8705c06974fc0c41db9c4eb836742945",
".git/objects/6e/ae82f101da43a8b3a40b2e8e53a523b0bddead": "1388f4158dd16b4cd61677219f0b0fd2",
".git/objects/pack/pack-dcff23262941fef9f68361daec8609784abe0f61.idx": "67b4129c2b54806fcf3bd2789f9756ac",
".git/objects/pack/pack-dcff23262941fef9f68361daec8609784abe0f61.pack": "42b106377c9877c4ea47368037a95a3c",
".git/objects/e9/bafcdf9cc0f8aacfd5454d080f8d218c5af0e9": "de1fb8fe33c6705f5b722c9753d2fbdf",
".git/objects/ac/b80cd5ed8dae43d87e4f53e15f02ef3c548476": "a378d4806efab3a5c359011dcd599e7c",
".git/objects/55/b34365bb778c9ff015c267337fee95437851d4": "09fb74a5240d2067f47311fbf6f5f598",
".git/objects/55/6935abce4408922bd0f137c5f9c747d059b3a4": "75392578413bae6843572c249427280e",
".git/objects/24/1ee447ab2fdb89248110c9ac2e21a0b106979e": "428f261c06f89da591f46e8d9d74ffca",
".git/objects/24/0cc42f0fb42b63ae9ce67d048309138697f314": "92046edb4be5a36774138fa5fdabe0bf",
".git/objects/c1/f5bcd105986a96173f9e19207052c295a11b87": "30f72df00d95f50ab3494f8ac02bb0db",
".git/objects/c1/4069b5f320cde1e0a2d34941c5404cbc0cb1b0": "c840c58868135020b4e6f6c29d55c718",
".git/objects/c1/6e503c6eade5dbe99ab49eea34be0dbdc2d80f": "c34daaac7b9386bd669800acde718735",
".git/objects/e6/8dcc3885619fdb748f6eafbc77814496a52a88": "f3e0485e056311cdc0685be72b746a50",
".git/objects/68/2c7755e539cb064fdd35d999918fc7812387ff": "12dec9fe9eb94f7174200d48381d5736",
".git/objects/01/78be8bf8690c0ecef8452faa634bc2f09bf400": "d13218d4ba1a315d077ccb1e37df52a3",
".git/objects/70/66e22f9b41390776758741e03dadfaafcf5ed7": "eb883814271d4e7e15ac91d35859e2c4",
".git/objects/70/b42aeeae71fe5552fdc102bd2bdf94ed28c8ac": "94f6117afb05675b33561de9cc5afa31",
".git/objects/30/4f182ca3a92d419514d10c9d7346fd7ce5d624": "280a27661d1fd77abf3d743b0ec0e81a",
".git/objects/30/5ee3973fafb27650d5305a2663535931f0f22e": "0a6296fb40adda439110f770b27ab006",
".git/objects/43/ea4a0b712d7b60acacdca42d4f98d10fc2340b": "9ea6f562577a4d1243651113a6b174be",
".git/objects/8a/5c0b5d625b34d7816e7b44c2b625675925f743": "f30d5a64154fdd3cdc6bd272560e632c",
".git/objects/8a/0557fb5393f5c3af68db7a678f19e7aea74846": "46e8c213b57e1327a58657d82548efa3",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/07/ffdc9a7f4cca3bc04fa97433670c4cf72eb16d": "65fa1aa2b59b84554381fab97651b7a9",
".git/objects/07/dc4be57bb324fbd4e432af5eeb980887c39f68": "dd740e0080174af5fa831566628f47b9",
".git/objects/6d/8d766c57a26aecb45a13bec7f51ad6eb40589e": "e8fde4375dce0a3604efe6bab5024b40",
".git/objects/b4/b0b660ce53422fa718b5377ecb893f004f5a48": "5b6d8bb49ea57355f288727634caa953",
".git/objects/3a/d2b390f0b3de3d717978a9950e429c66f9962c": "f279b3353fc94c49effeea8f020f353f",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/6f/1b091acc233fd1251633293e2384c33d7e0f95": "a766326a59a9da2de0d9eab7c9f61672",
".git/objects/d8/69914cd641aba5527753cfe5fd8d33405924d2": "97e9b17dffedbd3c48d07ab43dc8ca32",
".git/objects/4b/a1811ab322f1321fabaf73b493ddc553024a56": "c3a5b7a3d0e359fa6e51b95b9f107d04",
".git/objects/4b/64d0e9e48f39e077e1a06ef35bb52385f31739": "034d48651d69aa16d93ad13699f70fe0",
".git/objects/e1/73a53823873b3b5396551cb2a4030be375a32b": "74b6772c4d7339f8f5976a99e4844797",
".git/objects/53/9be96b92d20fb6f395aefd664a3620650c4ff8": "f77274d440302973a54785d38ee5de1f",
".git/objects/53/4b02738d9b0b80b53355edcf8a89f66bad02d1": "87b48b661bae7adcba32375438d952d1",
".git/objects/d7/779821ecece1125a08d45410ec37399d0622d2": "a5c2f1aa5fb13a6619e46f41e8f323b1",
".git/objects/7a/59e7c7c0b27c2d02fae28e5d4965462e5ca026": "ef8a2acbf2e1685e3bbf8cb9b8853544",
".git/objects/7a/464cfdcc5a8ffcec2058ab64c5e5f69bb6cdef": "301e8aae30b82165a9e8feea8e51bb7f",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/1b/ad3e1af76d12edb40bd14dcaa1a25c01deef66": "f10a30318ffb4f17428a00690fc94f1b",
".git/objects/a9/44dd8c5a2c8d620ea25874608ba1aa54b57556": "d98599bab712c65853615350d2a802f3",
".git/objects/1c/51bf7a1d10eb0d8818602de1185e3b21b8e47d": "75e7dce0c87801fd05afe078aa372b52",
".git/objects/1c/2aab7e1b82587dce486ae6aefbc9cb13da6200": "fdc3bb36595e9483f1bca64efe780490",
".git/objects/cc/46e05440e28e698d8309743c71fd0fcdd9dab6": "9cbe80fbfd85829a7b16c668f0b6ffb6",
".git/objects/9c/a6c9f016ddccedcfc7e851aebcb960d32c5534": "a754f5d7027bef715dc1eede0086c400",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
"manifest.json": "f9d0789acb4352691ce0202a2a5418a6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
