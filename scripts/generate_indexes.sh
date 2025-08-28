#!/bin/bash
# Usage: ./generate_indexes.sh BASE_DIR TARGET_DIR

set -e

BASE_DIR=$1
TARGET_DIR=$2

# Génération d'un index.html simple avec liens vers les deux versions
cat > "$TARGET_DIR/index.html" <<EOF
<!DOCTYPE html>
<html lang='fr'>
<head>
  <meta charset='UTF-8'>
  <title>Mon CV</title>
</head>
<body>
<h1>Mon CV</h1>
<p>
  <a href='resume-FR.html'>FR</a> | <a href='resume-EN.html'>EN</a>
</p>
</body>
</html>
EOF

echo "Index généré dans $TARGET_DIR/index.html"
