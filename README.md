# test_ashkryab

test for privatbank

## DeepLinking

adb shell am start -a android.intent.action.VIEW \
-c android.intent.category.BROWSABLE \
-d https://api.themoviedb.org/movie/1184918 \
com.ashkryab.test_ashkryab

xcrun simctl openurl booted "tmdb://api.themoviedb.org/movie/1184918"



