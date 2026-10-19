// @dart = 3.0

import 'package:duskmoon_widgets/src/vendor/flutter_math/flutter_math.dart';
import 'package:duskmoon_widgets/src/vendor/flutter_math/src/parser/tex/parser.dart';

import 'package:duskmoon_widgets/src/vendor/flutter_math/src/encoder/tex/encoder.dart';

String recodeTex(String tex) => TexParser(tex, const TexParserSettings())
    .parse()
    .encodeTeX(conf: TexEncodeConf.mathParamConf);
