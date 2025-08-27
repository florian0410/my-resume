DEPLOY_DIR ?= deploy
TARGET_DIR ?= $(DEPLOY_DIR)/prod

.PHONY: docker_build docker_run docker_push install-env fix-chrome-missing install-theme build_html build_pdf from-gitconnected serve-resume generate_indexes deploy_all

DOCKER_IMAGE_NAME=yupiter/my-resume
JSON_RESUME_THEME=paper-plus-plus
FILENAME=resume
PAGES_FOLDER=docs
SOURCE_FILE_FRENCH=$(FILENAME)-FR.json
SOURCE_FILE_ENGLISH=$(FILENAME)-EN.json

OUTFILE_FRENCH=$(FILENAME)-FR
OUTFILE_ENGLISH=$(FILENAME)-EN

# --- Docker ---
docker_build:
	docker build . -t $(DOCKER_IMAGE_NAME)

docker_run:
	docker run -v $(PWD):/data -it $(DOCKER_IMAGE_NAME) /bin/sh

docker_push:
	docker push $(DOCKER_IMAGE_NAME)

# --- Env / Theme ---
install-env:
	npm install -g resume-cli

fix-chrome-missing: 
	ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils

install-theme:
	npm install jsonresume-theme-$(JSON_RESUME_THEME)

# --- Build HTML ---
build_html: install-theme
# English
	resume export $(PWD)/$(PAGES_FOLDER)/$(OUTFILE_ENGLISH) --format html -r $(SOURCE_FILE_ENGLISH) --theme $(JSON_RESUME_THEME)
# French
	resume export $(PWD)/$(PAGES_FOLDER)/$(OUTFILE_FRENCH) --format html -r $(SOURCE_FILE_FRENCH) --theme $(JSON_RESUME_THEME)

# --- Build PDF ---
build_pdf: install-theme
# English
	resume export $(OUTFILE_ENGLISH) --format pdf -r $(SOURCE_FILE_ENGLISH) --theme $(JSON_RESUME_THEME)
# French
	resume export $(OUTFILE_FRENCH) --format pdf -r $(SOURCE_FILE_FRENCH) --theme $(JSON_RESUME_THEME)

from-gitconnected:
	curl https://gitconnected.com/v1/portfolio/florian0410 | jq . > $(FILENAME)-gitconnected.json

# Only with official supported templates
serve-resume:
	resume serve --theme $(JSON_RESUME_THEME) -r $(SOURCE_FILE_FRENCH)

# --- Build indexes individuels et globaux ---
# TARGET_DIR = dossier individuel PR ou prod, ex: deploy/dev/pr-123 ou deploy/prod
# DEPLOY_DIR = dossier racine pour les déploiements, ex: deploy
generate_indexes:
	./scripts/generate_indexes.sh $(DEPLOY_DIR) $(TARGET_DIR)

# --- Build complet pour déploiement ---
deploy_all: build_html generate_indexes

# --- Build complet pour déploiement PR (ne modifie pas index global) ---
deploy_pr: build_html
	./scripts/generate_indexes.sh $(DEPLOY_DIR) $(TARGET_DIR) --no-global
