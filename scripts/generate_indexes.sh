#!/bin/bash
# Usage: ./generate_indexes.sh BASE_DIR DEPLOY_DIR [--no-global]
# BASE_DIR = dossier racine deploy (ex: deploy)
# DEPLOY_DIR = dossier individuel PR ou prod (ex: deploy/dev/pr-123 ou deploy/prod)

set -e

BASE_DIR=$1
DEPLOY_DIR=$2
NO_GLOBAL=$3

# --- Langues disponibles ---
LANGS=("FR" "EN")

# --- Génération index individuel ---
mkdir -p "$DEPLOY_DIR"

echo "<!DOCTYPE html>
<html lang='fr'>
<head>
  <meta charset='UTF-8'>
  <title>Résumé</title>
</head>
<body>
<h1>Mon CV</h1>
<p>" > "$DEPLOY_DIR/index.html"

for lang in "${LANGS[@]}"; do
  echo "<a href='resume-$lang.html'>$lang</a> | " >> "$DEPLOY_DIR/index.html"
done

sed -i '$ s/ | $//' "$DEPLOY_DIR/index.html"

echo "</p>
</body>
</html>" >> "$DEPLOY_DIR/index.html"

echo "Index individuel généré dans $DEPLOY_DIR/index.html"

# --- Génération index global uniquement si non PR ---
if [ "$NO_GLOBAL" != "--no-global" ]; then
  GLOBAL_INDEX="$BASE_DIR/index.html"
  mkdir -p "$BASE_DIR"

  echo "<!DOCTYPE html>
<html lang='fr'>
<head>
  <meta charset='UTF-8'>
  <title>Hub de Développement</title>
</head>
<body>
<h1>Hub de Développement</h1>
<h2>Version Production</h2>
<p>" > "$GLOBAL_INDEX"

  # Liens vers la prod
  for lang in "${LANGS[@]}"; do
    echo "<a href='./prod/resume-$lang.html'>$lang</a> | " >> "$GLOBAL_INDEX"
  done
  sed -i '$ s/ | $//' "$GLOBAL_INDEX"
  echo "</p>
</body>
</html>" >> "$GLOBAL_INDEX"

  echo "Index global généré dans $GLOBAL_INDEX"
fi
