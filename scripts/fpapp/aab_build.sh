cd ~/work/local/flightpark/flightparkapp/
mv .env .env.tmp
npx expo prebuild -p android
cd android
./gradlew app:bundleRelease
cd .. 
mv .env.tmp .env
