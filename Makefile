JSON_RESUME_THEME=elegant
SOURCE_FILE=resume-FR-gitconnected.json
PDF_FILENAME=resume-FR.pdf
HTML_FILENAME=resume-FR.html

build-command:
	docker build . -t resume-command

install-env:
	apt install npm install -g resume-cli 

# See: https://github.com/alixaxel/chrome-aws-lambda/issues/164#issuecomment-737435267 
fix-chrome-missing: 
	ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils

install-themes:
	npm install -g jsonresume-theme-even jsonresume-theme-caffeine jsonresume-theme-orbit jsonresume-theme-elegant

create-resume-pdf:
	resume export $(PDF_FILENAME) --format pdf -r $(SOURCE_FILE) --theme $(JSON_RESUME_THEME)

from-gitconnected:
	curl https://gitconnected.com/v1/portfolio/florian0410 | jq . > $(SOURCE_FILE)

# Only with official supported templates
serve-resume:
	resume serve --theme $(JSON_RESUME_THEME) -r $(SOURCE_FILE)
