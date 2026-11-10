## 1A 
#### Spring Boot-applikasjonen er containerisert. Kjør følgende kommandoer:

#### Bygg imaget:
```bash
docker build -t wishifai .
```
#### Start containeren på localhost:9999:
```bash
docker run --rm -p 9999:8080 -v "$HOME/.aws:/root/.aws:ro" -e AWS_PROFILE=default wishifai
```

## 1B
#### GitHub Actions-workflowen kjører ved push til main.

#### Docker-imaget publiseres til Amazon ECR med to tags (Commit-SHA og latest)
#### Grunnen til at man bruker Commit-SHA er for å enkelt vite akkurat hvilken commit som kjører i et miljø. Derfor brukes denne som primær tag. Latest brukes som en sekundær tag for å se hvilken versjon som er den nyeste.


### Link til grønn workflow-kjøring:
https://github.com/richardclaussen/PGR301-exam/actions/runs/42619784601

## 2A

### Offentlig URL til tjenesten:
https://wi-f311228998ee485590d9ca0f43074768.ecs.eu-west-1.on.aws

## 2B

#### Valgt nøkkel for remote state er "wishifai/50/terraform.tfstate" 

## 2C

#### Det er fornuftig å kjøre Terraform etter container-builden fordi Docker-imaget må være publisert til ECR før ECS kan starte eller oppdatere tjenesten med den nye versjonen. Terraform-jobben bruker commit-SHA'en som image tag. Kjøring av Terraform før eller parallelt kan resultere i at deployen enten feiler siden det ikke finnes noe image i ECR enda, eller at en eldre image-versjon blir brukt.

### Link til grønn workflow-kjøring:
https://github.com/richardclaussen/PGR301-exam/actions/runs/42664430007

## 3A

#### Jeg valgte følgende metrikker:

**wishifai.rekognition.duration:**
Timer for hvor lang tid Rekognition bruker på å analysere et bilde. Det gjør det mulig å følge med på ytelsen til bildeanalysen.

**wishifai.bedrock.duration:**
Timer for hvor lang tid Bedrock bruker på å generere gaveforslag. Brukes for å måle responstiden til språkmodellen.

**wishifai.images.analyzed:**
Counter for antall bilder som er analysert. Dette er en business-metrikk som viser hvor mye tjenesten faktisk brukes.

**wishifai.gifts.generated:**
Counter for totalt antall genererte gaveforslag. Relevant metrikk å ha med siden gavegenerering er tjenestens hovedfunksjon.
 
**wishifai.gifts.per.request**
DistributionSummary for antall gaveforslag per forespørsel. Siden prompten til språkmodellen ber om "inntil" 5 gaver, er det aktuelt å få en innsikt i hvor mange forslag brukerne vanligvis får per bildeanalyse.
