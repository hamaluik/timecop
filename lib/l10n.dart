// Copyright 2020 Kenton Hamaluik
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timecop/data_providers/l10n/fluent_l10n_provider.dart';
import 'package:timecop/data_providers/l10n/l10n_provider.dart';

class L10N {
  final Locale locale;
  final L10NProvider tr;
  final bool rtl;

  const L10N._internal(this.locale, this.tr, this.rtl)
      : assert(locale != null),
        assert(tr != null),
        assert(rtl != null);

  static Future<L10N> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    L10NProvider tr = await FluentL10NProvider.load(locale);
    return L10N._internal(locale, tr, locale.languageCode == "ar");
  }

  static L10N of(BuildContext context) {
    return Localizations.of<L10N>(context, L10N);
  }

  static const LocalizationsDelegate<L10N> delegate = _L10NDelegate();
}

class _L10NDelegate extends LocalizationsDelegate<L10N> {
  const _L10NDelegate();

  @override
  bool isSupported(Locale locale) => [
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ja',
        'ko',
        'pt',
        'ru',
        'zh',
        'ar',
        'it'
      ].contains(locale.languageCode);

  @override
  Future<L10N> load(Locale locale) => L10N.load(locale);

  @override
  bool shouldReload(_L10NDelegate old) => false;
}
