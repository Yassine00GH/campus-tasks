#!/usr/bin/env bash
set -u

errors=0
required=(README.md .gitignore .env.example docs/api.md docs/setup.md)

echo "[CHECK] Campus Tasks"

# 1. Vérification des fichiers obligatoires
for file in "${required[@]}"; do
    if [[ -f "$file" ]]; then
        echo "[OK] $file"
    else
        echo "[ERREUR] fichier absent: $file" >&2
        errors=$((errors + 1))
    fi
done

# 2. Vérification qu'aucun .env n'est indexé par Git
if git ls-files | grep -Eq '(^|/)\.env$'; then
    echo "[ERREUR] un fichier .env est suivi par Git" >&2
    errors=$((errors + 1))
else
    echo "[OK] aucun .env suivi"
fi

# 3. DÉFI FINAL : Vérification de la propreté du dépôt (modifications non validées)
if [[ -n $(git status --porcelain) ]]; then
    echo "[ERREUR] modifications locales non validées détectées" >&2
    errors=$((errors + 1))
else
    echo "[OK] espace de travail propre"
fi

# Bilan et code de sortie
if [[ $errors -gt 0 ]]; then
    echo "[ECHEC] $errors erreur(s)" >&2
    exit 1
fi

echo "[SUCCES] contrôles validés"
exit 0
