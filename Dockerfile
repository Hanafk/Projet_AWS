# 1. Image de base : Linux léger + Python 3.12
FROM python:3.12-slim
# 2. Pas de fichiers .pyc, logs affichés immédiatement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app
# 3. Outils système (poppler-utils : lecture des PDF)
RUN apt-get update && apt-get install -y build-essential poppler-utils curl \
&& rm -rf /var/lib/apt/lists/*
# 4. Installer uv (gestionnaire de paquets)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"
ENV UV_LINK_MODE=copy
ENV PYTHONPATH="/app:/app/multi_doc_chat"
# 5. D'abord les dépendances (mises en cache tant qu'elles ne changent pas)
COPY requirements.txt ./
RUN uv pip install --system -r requirements.txt
# 6. Puis le code
COPY . .
# 7. Port d'écoute + commande de démarrage
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
