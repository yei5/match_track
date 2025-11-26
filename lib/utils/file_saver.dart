export 'package:match_track/utils/file_saver_interface.dart';

export 'package:match_track/utils/file_saver_native.dart'
    if (dart.library.html) 'package:match_track/utils/file_saver_web.dart';

import 'package:match_track/utils/file_saver_native.dart'
    if (dart.library.html) 'package:match_track/utils/file_saver_web.dart';

import 'package:match_track/utils/file_saver_interface.dart';

FileSaver getFileSaver() => FileSaverPlatformImpl();