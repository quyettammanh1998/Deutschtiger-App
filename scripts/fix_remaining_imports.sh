#!/bin/bash
# Fix remaining import patterns after manual fixes

echo "Fixing remaining import patterns..."

# Fix screens that import domain/ -> data/
find lib/screens -name "*.dart" -exec sed -i "s|import '../domain/|import 'package:deutschtiger/data/|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import '../../domain/|import 'package:deutschtiger/data/|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import '../../../domain/|import 'package:deutschtiger/data/|g" {} \;

# Fix screens that import ../data/ -> repositories/
find lib/screens -name "*.dart" -exec sed -i "s|import '../data/|import 'package:deutschtiger/repositories/|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import '../../data/|import 'package:deutschtiger/repositories/|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import '../../../data/|import 'package:deutschtiger/repositories/|g" {} \;

# Fix screens that import *_provider.dart from relative paths
find lib/screens -name "*.dart" -exec sed -i "s|import 'affiliate_provider\.dart'|import 'package:deutschtiger/view_models/affiliate/affiliate_provider.dart'|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import 'ai_provider\.dart'|import 'package:deutschtiger/view_models/ai/ai_provider.dart'|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import 'vocab_search_provider\.dart'|import 'package:deutschtiger/view_models/providers.dart'|g" {} \;

# Fix screens that import from widgets/ with relative paths
find lib/screens -name "*.dart" -exec sed -i "s|import '../widgets/|import 'package:deutschtiger/screens/|g" {} \;
find lib/screens -name "*.dart" -exec sed -i "s|import '../../widgets/|import 'package:deutschtiger/screens/|g" {} \;

# Fix widgets that import domain/ -> data/
find lib/widgets -name "*.dart" -exec sed -i "s|import '../../domain/|import 'package:deutschtiger/data/|g" {} \;
find lib/widgets -name "*.dart" -exec sed -i "s|import '../../../domain/|import 'package:deutschtiger/data/|g" {} \;
find lib/widgets -name "*.dart" -exec sed -i "s|import '../domain/|import 'package:deutschtiger/data/|g" {} \;

# Fix widgets that import data/ -> repositories/
find lib/widgets -name "*.dart" -exec sed -i "s|import '../../data/|import 'package:deutschtiger/data/|g" {} \;
find lib/widgets -name "*.dart" -exec sed -i "s|import '../../../data/|import 'package:deutschtiger/data/|g" {} \;

# Fix features imports -> screens
find lib/features -name "*.dart" -exec sed -i "s|import 'package:Deutschtiger/screens/|import 'package:deutschtiger/screens/|g" {} \;

echo "Done fixing imports!"
