

# build
docker build -t wishifai .

# run (Se på autentisering på en annen måte senere)
docker run --rm -p 9999:8080 -v "$HOME/.aws:/root/.aws:ro" -e AWS_PROFILE=default wishifai

