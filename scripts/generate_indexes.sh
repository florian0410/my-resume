#!/bin/bash
# Usage: ./generate_indexes.sh BASE_DIR TARGET_DIR
# BASE_DIR = dossier racine deploy (ex: deploy)
# TARGET_DIR = dossier individuel PR ou prod (ex: deploy/dev/pr-123 ou deploy/prod)

set -e

BASE_DIR=$1
TARGET_DIR=$2

# --- Langues disponibles ---
LANGS=("FR" "EN")

# --- Génération index individuel ---
mkdir -p "$TARGET_DIR"

echo "<!DOCTYPE html>
<html lang='fr'>
<head>
  <meta charset='UTF-8'>
  <title>Résumé</title>
</head>
<body>
<h1>Mon CV</h1>
<p>" > "$TARGET_DIR/index.html"

for lang in "${LANGS[@]}"; do
  echo "<a href='resume-$lang.html'>$lang</a> | " >> "$TARGET_DIR/index.html"
done

# Supprimer le dernier " | "
sed -i '$ s/ | $//' "$TARGET_DIR/index.html"

echo "</p>
</body>
</html>" >> "$TARGET_DIR/index.html"

echo "Index individuel généré dans $TARGET_DIR/index.html"

# --- Génération index global ---
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
<h2>Préviews PR</h2>
<ul>" >> "$GLOBAL_INDEX"

# Liens vers toutes les PR
for prdir in "$BASE_DIR"/dev/pr-*; do
  if [ -d "$prdir" ]; then
    prnum=$(basename "$prdir" | sed 's/pr-//')
    echo "<li>PR #$prnum : " >> "$GLOBAL_INDEX"
    for lang in "${LANGS[@]}"; do
      echo "<a href='./dev/pr-$prnum/resume-$lang.html'>$lang</a> " >> "$GLOBAL_INDEX"
    done
    echo "</li>" >> "$GLOBAL_INDEX"
  fi
done

echo "</ul>
</body>
</html>" >> "$GLOBAL_INDEX"

echo "Index global généré dans $GLOBAL_INDEX"
