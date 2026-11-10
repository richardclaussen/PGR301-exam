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
