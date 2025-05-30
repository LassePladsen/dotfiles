cd ~/work/local/flightpark/flightparkapp/
mv .env .env.tmp
cd android
# rm app/build/outputs/apk/release/app-release.apk
./gradlew app:assembleRelease
cd .. 
mv .env.tmp .env
