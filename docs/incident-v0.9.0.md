1. **Incident** : Lors de la mise en service de la version `v0.9.0` en staging, le conteneur `api` a échoué au démarrage avec l'erreur : `[COPIER ICI LA PREMIERE ERREUR UTILE VUE DANS LES LOGS]`.
2. **Détection** : La panne a été détectée après le déploiement lancé à `11:15:15` grâce à l'échec du script `scripts/wait-healthy.sh` (`staging non sain`, code de retour `1`).
3. **Action menée** : Après consultation des journaux (`docker compose logs --tail=50 api`), nous avons restauré `IMAGE_TAG=v1.0.2` dans `.env.deploy` sans reconstruire l'image et relancé `docker compose up -d`.
4. **Indisponibilité** : Le service a été indisponible pendant **1 minute et 52 secondes** (de `11:15:15` à `11:17:07`, retour de `{"status":"ok"}` et `staging sain`).
5. **Prévention** : Ajouter un test de démarrage et de réponse sur `/health` dans la CI avant de publier un tag, et automatiser le rollback en cas d'échec du contrôle de santé.
