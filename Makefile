# Makefile para Status App - React Frontend
# Compatível com Windows e macOS

# Variáveis
APP_NAME = fiap-react-deploy
VERSION = 1.0.0
PORT = 3000
DOCKER_PORT = 8080

# Detectar sistema operacional
ifeq ($(OS),Windows_NT)
	DETECTED_OS := Windows
	RM_CMD = del /Q
	MKDIR_CMD = mkdir
else
	DETECTED_OS := $(shell uname -s)
	RM_CMD = rm -rf
	MKDIR_CMD = mkdir -p
endif

# Comandos padrão
.PHONY: help install dev build preview docker-build docker-run clean test lint

# Target padrão
all: help

# Ajuda - mostra comandos disponíveis
help:
	@echo "=== Status App - Makefile Commands ==="
	@echo "Sistema detectado: $(DETECTED_OS)"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  install      - Instalar dependências"
	@echo "  dev          - Rodar em modo desenvolvimento (localhost:$(PORT))"
	@echo "  build        - Buildar aplicação para produção"
	@echo "  preview      - Preview da build de produção"
	@echo "  test         - Rodar testes"
	@echo "  lint         - Rodar linter"
	@echo "  docker-build - Buildar imagem Docker"
	@echo "  docker-run   - Rodar com Docker (localhost:$(DOCKER_PORT))"
	@echo "  clean        - Limpar arquivos de build"
	@echo "  help         - Mostrar esta ajuda"
	@echo ""

# Instalar dependências
install:
	@echo "📦 Instalando dependências..."
	npm install
	@echo "✅ Dependências instaladas!"

# Rodar em modo desenvolvimento
dev:
	@echo "🚀 Iniciando modo desenvolvimento..."
	@echo "📱 Aplicação disponível em: http://localhost:$(PORT)"
	npm run dev

# Buildar aplicação
build:
	@echo "🔨 Buildando aplicação..."
	@echo "🌍 Ambiente: produção"
	@echo "📦 Versão: $(VERSION)"
	npm run build
	@echo "✅ Build concluído! Arquivos em ./dist"

# Preview da build
preview:
	@echo "👁️ Iniciando preview da build..."
	@echo "📱 Preview disponível em: http://localhost:4173"
	npm run preview

# Rodar testes
test:
	@echo "🧪 Executando testes..."
	npm run test

# Rodar linter
lint:
	@echo "🔍 Executando linter..."
	npm run lint

# Buildar imagem Docker
docker-build:
	@echo "🐳 Buildando imagem Docker..."
	@echo "🏷️ Tag: $(APP_NAME):$(VERSION)"
	docker build \
		--build-arg VITE_ENVIRONMENT=prod \
		--build-arg VITE_APP_VERSION=$(VERSION) \
		--build-arg VITE_BUILD_TIMESTAMP=$(shell date -u +"%Y-%m-%dT%H:%M:%S.000Z") \
		-t $(APP_NAME):$(VERSION) \
		-t $(APP_NAME):latest \
		.
	@echo "✅ Imagem Docker criada!"

# Rodar com Docker
docker-run:
	@echo "🐳 Iniciando container Docker..."
	@echo "📱 Aplicação disponível em: http://localhost:$(DOCKER_PORT)"
	@echo "🔧 Health check: http://localhost:$(DOCKER_PORT)/health"
	@echo "ℹ️ Info API: http://localhost:$(DOCKER_PORT)/api/info"
	docker run -d \
		--name $(APP_NAME) \
		-p $(DOCKER_PORT):8080 \
		--restart unless-stopped \
		$(APP_NAME):latest
	@echo "✅ Container rodando!"
	@echo "📋 Para parar: docker stop $(APP_NAME)"
	@echo "🗑️ Para remover: docker rm $(APP_NAME)"

# Parar container Docker
docker-stop:
	@echo "🛑 Parando container Docker..."
	-docker stop $(APP_NAME)
	-docker rm $(APP_NAME)
	@echo "✅ Container parado!"

# Ver logs do Docker
docker-logs:
	@echo "📋 Logs do container:"
	docker logs -f $(APP_NAME)

# Limpar arquivos de build e cache
clean:
	@echo "🧹 Limpando arquivos..."
	$(RM_CMD) dist
	$(RM_CMD) node_modules/.cache
	$(RM_CMD) coverage
	$(RM_CMD) .nyc_output
	npm cache clean --force
	@echo "✅ Limpeza concluída!"

# Setup completo do projeto
setup: clean install
	@echo "🎯 Setup completo realizado!"
	@echo "▶️ Execute 'make dev' para iniciar o desenvolvimento"

# Deploy local completo (build + docker)
deploy: build docker-build docker-stop docker-run
	@echo "🚀 Deploy local concluído!"
	@echo "📱 Aplicação rodando em: http://localhost:$(DOCKER_PORT)"

# Status da aplicação
status:
	@echo "📊 Status da aplicação:"
	@echo "🔍 Verificando se está rodando..."
	-curl -s http://localhost:$(DOCKER_PORT)/health && echo "✅ Aplicação saudável!" || echo "❌ Aplicação não está rodando"
	@echo ""
	@echo "📋 Containers Docker:"
	docker ps | grep $(APP_NAME) || echo "Nenhum container rodando" 